# ============================================================================
# Hashcards Dockerfile for Railway Deployment
# Multi-stage build for optimal size and production deployment
# ============================================================================

# ============================================================================
# Stage 1: Builder
# ============================================================================
FROM rust:1.85-slim AS builder

WORKDIR /build

# Install build dependencies required for hashcards compilation
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    tar \
    sed \
    make \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency files first for Docker layer caching optimization
COPY Cargo.toml Cargo.lock Makefile ./

# Copy source code
COPY src ./src

# Build KaTeX vendor assets (downloads and processes KaTeX v0.16.25)
# This is required before cargo build as KaTeX assets are embedded in the binary
# Manual setup to ensure compatibility with GNU sed in Linux
RUN echo "Downloading KaTeX v0.16.25..." && \
    mkdir -p vendor && \
    curl -L -o vendor/katex.tar.gz https://github.com/KaTeX/KaTeX/releases/download/v0.16.25/katex.tar.gz && \
    echo "Extracting KaTeX..." && \
    tar -xzf vendor/katex.tar.gz -C vendor && \
    rm vendor/katex.tar.gz && \
    echo "Rewriting font paths in CSS for web serving..." && \
    sed -i 's|fonts/|/katex/fonts/|g' vendor/katex/katex.min.css && \
    echo "KaTeX setup complete" && \
    ls -la vendor/katex/

# Build the release binary with aggressive optimizations
# Cargo.toml already configured with: strip=symbols, lto=true, codegen-units=1, panic=abort
RUN cargo build --release

# ============================================================================
# Stage 2: Runtime
# ============================================================================
FROM debian:bookworm-slim

WORKDIR /app

# Install minimal runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy the compiled binary from builder stage
COPY --from=builder /build/target/release/hashcards /app/hashcards

# Copy KaTeX assets from builder stage (embedded at build time but also needed for /katex/* endpoints)
COPY --from=builder /build/vendor/katex /app/katex

# Copy and make entrypoint script executable
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Create data directory for collection mounting
RUN mkdir -p /data && chmod 755 /data

# Create non-root user for security (optional but good practice)
RUN groupadd -r hashcards && useradd -r -g hashcards hashcards && \
    chown -R hashcards:hashcards /app /data
USER hashcards

# Expose port 8000 (default hashcards port)
EXPOSE 8000

# Add health check to verify service is running
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/ || exit 1

# Set entrypoint to our script that handles Railway PORT env var
ENTRYPOINT ["/app/entrypoint.sh"]
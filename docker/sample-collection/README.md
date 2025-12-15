# Sample Hashcards Collection

This directory contains example flashcard decks to demonstrate the hashcards format and help new users get started.

## What's Included

- **Welcome.md**: Basic introduction to hashcards with simple Q&A cards
- **Mathematics.md**: Examples using LaTeX math notation with KaTeX
- **Languages.md**: Cloze deletion cards for language learning
- **macros.tex**: Optional KaTeX macro definitions for mathematical notation

## Getting Started

1. Start the hashcards server: `hashcards drill /path/to/this/directory`
2. Open your browser to `http://localhost:8000`
3. Review the sample cards to learn the format
4. Edit these files or create new `.md` files to add your own content

## Card Format

### Question-Answer Cards
```markdown
Q: What is the capital of France?
A: Paris
```

### Cloze Deletion Cards
```markdown
C: The [mitochondria] is the powerhouse of the [cell].
```

### LaTeX Math
```markdown
Q: What is Euler's formula?
A: $e^{i\pi} + 1 = 0$
```

## Files

Each `.md` file becomes a deck, and the filename (without extension) becomes the deck name shown during review.

## Database

The `hashcards.db` file will be created automatically in this directory to store your review progress and scheduling data.
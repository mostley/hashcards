Q: What is hashcards?
A: A plain-text spaced repetition system that helps you memorize information through scheduled reviews.

Q: What file format do hashcards use?
A: Markdown (.md) files with a simple question-answer or cloze deletion format.

Q: How do you create a basic question-answer card?
A: Use "Q:" for the question and "A:" for the answer, each on separate lines.

Q: What is spaced repetition?
A: A learning technique that increases intervals between reviews of previously learned material to improve long-term retention.

Q: How does hashcards determine when to show you a card again?
A: It uses the FSRS (Free Spaced Repetition Scheduler) algorithm to optimize review timing based on your performance.

Q: What happens when you grade a card as "Forgot"?
A: The card will appear again soon, and its difficulty will increase for future scheduling.

Q: What happens when you grade a card as "Easy"?
A: The card will have a longer interval before appearing again, indicating strong retention.

Q: How do you end a study session?
A: Click the "End" button, or review all cards until the session is complete. Your progress is saved when the session ends.

Q: Can you undo a card grade if you made a mistake?
A: Yes, use the undo shortcut (u) or the undo button to reverse your last grade.

Q: What keyboard shortcuts are available during review?
A: Spacebar to reveal answer, 1-4 to grade (Forgot/Hard/Good/Easy), U to undo.

Q: How are cards identified in the database?
A: Each card is content-addressed, meaning it's identified by a hash of its text content.

Q: What happens if you edit a card's content?
A: The card gets a new hash, so its review progress resets - it becomes a "new" card.

Q: Where is your review progress stored?
A: In a SQLite database file called "hashcards.db" in your collection directory.

Q: Can you organize cards into different topics?
A: Yes, each .md file becomes a separate deck, and the filename becomes the deck name.

Q: What should you do if the web interface doesn't open automatically?
A: Navigate to http://localhost:8000 in your browser (or the port specified when starting hashcards).
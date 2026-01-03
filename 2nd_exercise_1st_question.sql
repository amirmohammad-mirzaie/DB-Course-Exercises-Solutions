
CREATE TABLE PostTypes (
    Id SERIAL PRIMARY KEY,
    Type VARCHAR(64)
);

CREATE TABLE Users (
    Id SERIAL PRIMARY KEY,
    DisplayName VARCHAR(128),
    Reputation INT,
    CreationDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Views INT
);


CREATE TABLE Posts (
    Id SERIAL PRIMARY KEY,
    Body TEXT NOT NULL,
    Title VARCHAR(300),
    Tags TEXT,
    CreationDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    DeletionDate TIMESTAMP,
    CommentCount INT,
    PostTypeId INT REFERENCES PostTypes(Id),
    OwnerUserId INT REFERENCES Users(Id)
);
ALTER TABLE Posts
ADD COLUMN ParentId INT REFERENCES Posts(Id);


ALTER TABLE Posts
ADD COLUMN AcceptedAnswerId INT REFERENCES Posts(Id);

CREATE TABLE LinkType (
    Id SERIAL PRIMARY KEY,
    Type VARCHAR(64)
);


CREATE TABLE PostLinks (
    Id SERIAL PRIMARY KEY,
    CreationDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PostId INT REFERENCES Posts(Id),
    RelatedPostId INT REFERENCES Posts(Id),
    LinkTypeId INT REFERENCES LinkType(Id)
);




CREATE TABLE Comments (
    Id SERIAL PRIMARY KEY,
    PostId INT REFERENCES Posts(Id),
    Score INT CHECK (Score > 0),
    Text TEXT,
    CreationDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UserDisplayName VARCHAR(300),
    UserId INT REFERENCES Users(Id),
    CalleeUserId INT REFERENCES Users(Id) ON DELETE SET NULL
);


CREATE TABLE Tags(
    Id SERIAL PRIMARY KEY,
    TagName VARCHAR(300),
    Count INT
);

----------------------
CREATE TABLE PostTags(
    PostId INT REFERENCES Posts(Id),
    TagId INT REFERENCES Tags(Id),
    PRIMARY KEY (PostId, TagId)
);

------------------------------------------
-------------- create data for the question
------------------------------------------

-- PostTypes data
INSERT INTO PostTypes (Id, Type) VALUES 
(1, 'Question'),
(2, 'Answer');

-- LinkTypes data
INSERT INTO LinkType (Id, Type) VALUES
(1, 'Linked'),
(2, 'Duplicate'),
(3, 'Related');

-- Users with varying reputation levels (for Q2 & Q3)
INSERT INTO Users (Id, DisplayName, Reputation, CreationDate, Views) VALUES
(1, 'HighRepExpert', 5000, '2026-01-15 08:30:00', 1200),
(2, 'MediumRepDev', 1500, '2026-01-18 09:15:00', 850),
(3, 'LowRepUser', 800, '2026-01-25 16:40:00', 200),
(4, 'NegativeRepUser', -150, '2026-01-30 10:20:00', 50),
(5, 'LoopUser', 2000, '2026-01-10 14:30:00', 300),
(6, 'NewbieUser', 300, '2026-02-01 09:45:00', 25),
(7, 'DuplicateAccount1', 1200, '2026-01-05 11:20:00', 400),
(8, 'DuplicateAccount2', 950, '2026-01-05 11:22:00', 380); -- Suspiciously similar creation time

-- Posts data (for all questions)
INSERT INTO Posts (Id, Body, Title, CreationDate, CommentCount, PostTypeId, OwnerUserId, DeletionDate) VALUES
-- Questions (PostTypeId = 1)
(1, '<p>How to optimize SQL queries for large datasets?</p>', 'SQL Query Optimization Techniques', '2026-01-25 10:30:00', 8, 1, 1, NULL),
(2, '<p>What are the best practices for database indexing?</p>', 'Database Indexing Best Practices', '2026-01-24 14:20:00', 12, 1, 2, NULL),
(3, '<p>I keep getting stuck in an infinite loop when processing these records.</p>', 'Help! I''m stuck in a loop', '2026-01-23 09:15:00', 5, 1, 5, NULL),
(4, '<p>How to handle NULL values in SQL calculations?</p>', 'Handling NULL Values in SQL', '2026-01-22 16:45:00', 15, 1, 2, NULL),
(5, '<p>I think I found a bug in the system causing infinite recursion.</p>', 'System bug causing infinite loop', '2026-01-21 11:30:00', 7, 1, 5, NULL),
(6, '<p>What is the difference between INNER JOIN and OUTER JOIN?</p>', 'JOIN Types Explained', '2026-01-20 13:45:00', 10, 1, 1, NULL),
(7, '<p>How to deal with recursive queries in PostgreSQL.</p>', 'Recursive Queries in PostgreSQL', '2026-01-19 15:20:00', 6, 1, 2, NULL),
(8, '<p>This is a test question with very specific title to be deleted</p>', 'DELETE ME - Test Question', '2026-01-18 10:10:00', 0, 1, 3, NULL),
(9, '<p>Another question about loop prevention techniques</p>', 'How to prevent infinite loops', '2026-01-17 09:30:00', 4, 1, 5, NULL),
(10, '<p>Is this a duplicate account detection test?</p>', 'Account verification question', '2026-01-16 14:25:00', 3, 1, 7, NULL),
-- Answers (PostTypeId = 2)
(11, '<p>Use EXPLAIN ANALYZE to identify bottlenecks and add appropriate indexes.</p>', NULL, '2026-01-25 11:45:00', 2, 2, 2, NULL),
(12, '<p>Index columns used in WHERE clauses and JOIN conditions first.</p>', NULL, '2026-01-24 15:30:00', 3, 2, 1, NULL),
(13, '<p>For infinite loops, always include a termination condition and monitor iteration count.</p>', NULL, '2026-01-23 10:20:00', 1, 2, 1, NULL),
(14, '<p>Use COALESCE or NULLIF functions to handle NULL values gracefully.</p>', NULL, '2026-01-22 17:50:00', 4, 2, 2, NULL),
(15, '<p>This bug might be related to the recursive trigger on the users table.</p>', NULL, '2026-01-21 13:15:00', 2, 2, 2, NULL);

-- Set ParentId and AcceptedAnswerId for relationships
UPDATE Posts SET ParentId = NULL, AcceptedAnswerId = 11 WHERE Id = 1;  -- Question 1 has accepted answer 11
UPDATE Posts SET ParentId = 11, AcceptedAnswerId = NULL WHERE Id = 11; -- Answer 11 has parent question 1
UPDATE Posts SET ParentId = NULL, AcceptedAnswerId = 12 WHERE Id = 2;
UPDATE Posts SET ParentId = 12, AcceptedAnswerId = NULL WHERE Id = 12;
UPDATE Posts SET ParentId = NULL, AcceptedAnswerId = 13 WHERE Id = 3;
UPDATE Posts SET ParentId = 13, AcceptedAnswerId = NULL WHERE Id = 13;
UPDATE Posts SET ParentId = NULL, AcceptedAnswerId = 14 WHERE Id = 4;
UPDATE Posts SET ParentId = 14, AcceptedAnswerId = NULL WHERE Id = 14;
UPDATE Posts SET ParentId = NULL, AcceptedAnswerId = 15 WHERE Id = 5;
UPDATE Posts SET ParentId = 15, AcceptedAnswerId = NULL WHERE Id = 15;

-- Tags data
INSERT INTO Tags (Id, TagName, Count) VALUES
(1, 'sql', 500),
(2, 'database', 350),
(3, 'optimization', 200),
(4, 'indexing', 180),
(5, 'postgresql', 150),
(6, 'recursion', 100),
(7, 'loops', 95),
(8, 'bugs', 75),
(9, 'security', 120),
(10, 'joins', 220);

-- PostTags relationships
INSERT INTO PostTags (PostId, TagId) VALUES
(1, 1), (1, 2), (1, 3),
(2, 1), (2, 2), (2, 4),
(3, 6), (3, 7), (3, 8),  -- Loop-related question has recursion/loops tags
(4, 1), (4, 2),
(5, 6), (5, 7), (5, 8),  -- Bug question also has recursion/loops tags
(6, 1), (6, 2), (6, 10),
(7, 1), (7, 5), (7, 6),
(8, 1), (8, 9),
(9, 6), (9, 7),         -- Loop prevention question
(10, 9);

-- PostLinks data (for Q2)
INSERT INTO PostLinks (CreationDate, PostId, RelatedPostId, LinkTypeId) VALUES
('2026-01-25 12:30:00', 1, 2, 3),  -- Q1 related to Q2 (both high rep users)
('2026-01-25 12:35:00', 2, 1, 3),  -- Q2 related to Q1
('2026-01-24 16:15:00', 2, 6, 1),  -- Q2 linked to Q6 (both high rep users)
('2026-01-23 11:00:00', 3, 5, 2),  -- Q3 is duplicate of Q5 (both loop questions)
('2026-01-22 18:20:00', 4, 1, 3),  -- Q4 related to Q1
('2026-01-21 14:00:00', 5, 7, 3),  -- Q5 related to Q7 (bug question related to recursive queries)
('2026-01-20 15:30:00', 6, 7, 3),  -- Q6 related to Q7
('2026-01-19 16:45:00', 7, 3, 3),  -- Q7 related to Q3 (loop question)
('2026-01-18 11:20:00', 10, 3, 3); -- Q10 related to loop question

-- Comments data (for Q1)
INSERT INTO Comments (PostId, Score, Text, CreationDate, UserDisplayName, UserId, CalleeUserId) VALUES
(1, 5, 'Great question! I''ve been wondering about this too.', '2026-01-25 10:45:00', 'MediumRepDev', 2, 1),
(1, 3, 'Have you tried looking at execution plans?', '2026-01-25 11:00:00', 'HighRepExpert', 1, 1),
(2, 8, 'This is exactly what I needed to know!', '2026-01-24 14:45:00', 'HighRepExpert', 1, 2),
(3, 12, 'I had the same issue with infinite loops last week.', '2026-01-23 09:30:00', 'HighRepExpert', 1, 5),
(3, 7, 'Add a counter variable to track iterations and break after a threshold.', '2026-01-23 09:45:00', 'MediumRepDev', 2, 5),
(4, 10, 'The explanation about JOIN types was very helpful', '2026-01-22 17:10:00', 'HighRepExpert', 1, 2),
(5, 15, 'This bug is causing my application to freeze completely!', '2026-01-21 11:45:00', 'MediumRepDev', 2, 5),
(5, 9, 'Check if you have recursive triggers enabled on your tables.', '2026-01-21 12:20:00', 'HighRepExpert', 1, 5),
(6, 6, 'Good explanation of JOIN types', '2026-01-20 14:10:00', 'MediumRepDev', 2, 1),
(7, 4, 'Recursive CTEs can be tricky but powerful', '2026-01-19 15:45:00', 'HighRepExpert', 1, 2),
(7, 8, 'Don''t forget to set a MAXRECURSION option in SQL Server', '2026-01-19 16:20:00', 'MediumRepDev', 2, 2),
(9, 14, 'This question saved me from an infinite loop disaster!', '2026-01-17 10:15:00', 'HighRepExpert', 1, 5),
(10, 3, 'This looks like a test question for duplicate accounts', '2026-01-16 14:40:00', 'NegativeRepUser', 4, 7);

-----------------------------------------------




DROP TABLE IF EXISTS Comments;
DROP TABLE IF EXISTS PostTags;
DROP TABLE IF EXISTS Tags;
DROP TABLE IF EXISTS PostLinks;
DROP TABLE IF EXISTS LinkType;
DROP TABLE IF EXISTS Posts;
DROP TABLE IF EXISTS PostTypes;
DROP TABLE IF EXISTS Users;


----------------------------
----- DML Solutions --------
----------------------------
-- 1. the number of comments below the questions


-- fisrt solution using directly the commentCount for the posts

SELECT p.id, p.CommentCount, pt.Type from Posts p
JOIN PostTypes pt ON pt.Id = p.PostTypeId
ORDER BY p.id ASC;


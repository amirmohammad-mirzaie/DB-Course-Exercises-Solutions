
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


UPDATE Posts SET ParentId = NULL, AcceptedAnswerId = 11 WHERE Id = 1;  -- Question 1 has accepted answer 11
UPDATE Posts SET ParentId = 1, AcceptedAnswerId = NULL WHERE Id = 11; -- Answer 11 has parent question 1
UPDATE Posts SET ParentId = NULL, AcceptedAnswerId = 12 WHERE Id = 2;
UPDATE Posts SET ParentId = 2, AcceptedAnswerId = NULL WHERE Id = 12;
UPDATE Posts SET ParentId = NULL, AcceptedAnswerId = 13 WHERE Id = 3;
UPDATE Posts SET ParentId = 3, AcceptedAnswerId = NULL WHERE Id = 13;
UPDATE Posts SET ParentId = NULL, AcceptedAnswerId = 14 WHERE Id = 4;
UPDATE Posts SET ParentId = 4, AcceptedAnswerId = NULL WHERE Id = 14;
UPDATE Posts SET ParentId = NULL, AcceptedAnswerId = 15 WHERE Id = 5;
UPDATE Posts SET ParentId = 5, AcceptedAnswerId = NULL WHERE Id = 15;
-- Tags data


-- Add more answers to existing questions
INSERT INTO Posts (Id, Body, Title, CreationDate, CommentCount, PostTypeId, OwnerUserId, DeletionDate, ParentId) VALUES
-- Additional answers for Question 1 (SQL Query Optimization)
(16, '<p>Another approach is to use materialized views for frequently accessed data.</p>', NULL, '2026-01-25 13:15:00', 1, 2, 3, NULL, 1),
(17, '<p>Don''t forget to analyze your tables regularly to keep statistics updated.</p>', NULL, '2026-01-25 14:20:00', 0, 2, 4, NULL, 1),
-- Additional answers for Question 2 (Database Indexing)
(18, '<p>Composite indexes can be very effective when you frequently filter on multiple columns.</p>', NULL, '2026-01-24 16:45:00', 2, 2, 3, NULL, 2),
(19, '<p>Consider partial indexes for frequently queried subsets of your data.</p>', NULL, '2026-01-24 17:30:00', 1, 2, 1, NULL, 2),
-- Additional answers for Question 3 (Infinite Loop)
(20, '<p>Use a watchdog timer pattern to automatically terminate long-running processes.</p>', NULL, '2026-01-23 11:45:00', 3, 2, 2, NULL, 3),
-- Additional answers for Question 4 (NULL Values)
(21, '<p>For calculations, consider using NULL-safe equals operator <=> in MySQL.</p>', NULL, '2026-01-22 18:15:00', 0, 2, 3, NULL, 4),
-- New answers for Question 6 (JOIN Types)
(22, '<p>CROSS JOIN creates a cartesian product while INNER JOIN filters based on a condition.</p>', NULL, '2026-01-20 14:30:00', 1, 2, 2, NULL, 6),
(23, '<p>OUTER JOINs preserve rows that don''t match, filling NULLs for missing values.</p>', NULL, '2026-01-20 15:10:00', 2, 2, 1, NULL, 6),
-- Additional answers for Question 7 (Recursive Queries)
(24, '<p>WITH RECURSIVE syntax is very powerful for hierarchical data traversal in PostgreSQL.</p>', NULL, '2026-01-19 17:05:00', 1, 2, 1, NULL, 7),
-- Additional answers for Question 9 (Loop Prevention)
(25, '<p>Always validate your termination condition with edge cases to prevent infinite loops.</p>', NULL, '2026-01-17 11:20:00', 2, 2, 2, NULL, 9);

-- Update ParentId relationships for existing answers (fix circular references)
UPDATE Posts SET ParentId = 1 WHERE Id = 11; -- Answer 11 belongs to Question 1
UPDATE Posts SET ParentId = 2 WHERE Id = 12; -- Answer 12 belongs to Question 2
UPDATE Posts SET ParentId = 3 WHERE Id = 13; -- Answer 13 belongs to Question 3
UPDATE Posts SET ParentId = 4 WHERE Id = 14; -- Answer 14 belongs to Question 4
UPDATE Posts SET ParentId = 5 WHERE Id = 15; -- Answer 15 belongs to Question 5

-- Update accepted answers for some questions
UPDATE Posts SET AcceptedAnswerId = 16 WHERE Id = 1;  -- Change accepted answer for Question 1
UPDATE Posts SET AcceptedAnswerId = 18 WHERE Id = 2;  -- Change accepted answer for Question 2
UPDATE Posts SET AcceptedAnswerId = 20 WHERE Id = 3;  -- Change accepted answer for Question 3

-- Add tags for the new answers (PostTags relationships)
INSERT INTO PostTags (PostId, TagId) VALUES
(16, 1), (16, 2), (16, 3), (16, 5),  -- sql, database, optimization, postgresql
(17, 1), (17, 2), (17, 3),           -- sql, database, optimization
(18, 1), (18, 2), (18, 4),           -- sql, database, indexing
(19, 1), (19, 2), (19, 4), (19, 9),  -- sql, database, indexing, security
(20, 6), (20, 7), (20, 8),           -- recursion, loops, bugs
(21, 1), (21, 2),                    -- sql, database
(22, 1), (22, 2), (22, 10),          -- sql, database, joins
(23, 1), (23, 2), (23, 10),          -- sql, database, joins
(24, 1), (24, 5), (24, 6),           -- sql, postgresql, recursion
(25, 6), (25, 7);                    -- recursion, loops

-- Add comments to the new answers
INSERT INTO Comments (PostId, Score, Text, CreationDate, UserDisplayName, UserId, CalleeUserId) VALUES
(16, 4, 'Materialized views are great for reporting dashboards!', '2026-01-25 13:30:00', 'LowRepUser', 3, 3),
(17, 2, 'This saved me hours of query tuning', '2026-01-25 14:45:00', 'NewbieUser', 6, 4),
(18, 7, 'I implemented this and saw a 3x performance improvement', '2026-01-24 17:00:00', 'HighRepExpert', 1, 3),
(19, 5, 'Partial indexes are underutilized but so powerful', '2026-01-24 18:15:00', 'MediumRepDev', 2, 1),
(20, 9, 'The watchdog pattern solved my infinite loop problem', '2026-01-23 12:20:00', 'HighRepExpert', 1, 2),
(22, 8, 'This explanation cleared up my JOIN confusion', '2026-01-20 14:50:00', 'LowRepUser', 3, 2),
(23, 6, 'Great point about OUTER JOINs preserving non-matching rows', '2026-01-20 15:45:00', 'MediumRepDev', 2, 1),
(24, 11, 'This recursive query example helped me understand CTEs better', '2026-01-19 17:30:00', 'HighRepExpert', 1, 1),
(25, 7, 'This is exactly what I needed to prevent my infinite loop bug', '2026-01-17 11:45:00', 'HighRepExpert', 1, 2);

-- Update CommentCount for questions that got new comments on their answers
UPDATE Posts SET CommentCount = CommentCount + 1 WHERE Id IN (1, 3, 4, 6, 7, 9);

-- Create PostLinks to show relationships between related questions
INSERT INTO PostLinks (CreationDate, PostId, RelatedPostId, LinkTypeId) VALUES
('2026-01-25 13:45:00', 1, 7, 3),  -- Q1 related to Q7 (both about database optimization)
('2026-01-24 18:00:00', 2, 4, 3),  -- Q2 related to Q4 (both about SQL handling)
('2026-01-23 12:00:00', 3, 9, 3),  -- Q3 related to Q9 (both about loop prevention)
('2026-01-22 19:00:00', 4, 6, 3),  -- Q4 related to Q6 (both about SQL syntax)
('2026-01-19 17:45:00', 7, 1, 3);  -- Q7 related to Q1 (both about database optimization)



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

SELECT p.id, p.CommentCount, pt.Type FROM Posts p
JOIN PostTypes pt ON pt.Id = p.PostTypeId
WHERE pt.Type = 'Question'
ORDER BY p.id ASC;

-- second solution using joining tables



SELECT 
    p.Id,
    COUNT(c.Id)
FROM Posts p
JOIN PostTypes pt ON pt.Id = p.PostTypeId
LEFT JOIN Comments c ON c.PostId = p.ID
WHERE pt.Type = 'Question'
GROUP BY p.id
ORDER BY p.id ASC;
    



-- The Id of the user who has done the most comments
SELECT 
    u.id AS user_id

FROM Users u
LEFT JOIN Comments c ON c.UserId = u.Id
GROUP BY u.id
ORDER BY COUNT(c.id) DESC
LIMIT 1;




-- the average of number of answers for a question

SELECT 
    AVG(count)
FROM
    (
        SELECT 
            parent.id AS parent_id,
            COUNT(child.id) AS count
        FROM posts parent
        LEFT JOIN posts child 
            ON child.parentid = parent.id 
            AND child.posttypeid = 2
        WHERE parent.posttypeid = 1
        GROUP BY parent.id
        ORDER BY parent.id
    );



SELECT AVG(count) FROM (
    SELECT
        parent.id AS parent_id,
        COUNT(child.id) as count


        FROM posts parent
        LEFT JOIN posts child ON child.parentid = parent.id
        WHERE parent.posttypeid = 1
        GROUP BY parent.id
        ORDER BY parent.id

);



-- the number of users who has created more than 100 answers 

SELECT 
    u_id,
    count
    
FROM (
    SELECT
        u.id AS u_id,
        -- p.id AS p_id,
        COUNT(p.id) AS count
    FROM users u
    LEFT JOIN posts p ON u.id = p.owneruserid
    GROUP BY u.id
    ORDER BY u.id
)
WHERE count > 2;


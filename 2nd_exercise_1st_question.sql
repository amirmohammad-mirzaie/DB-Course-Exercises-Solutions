CREATE TABLE Posts (
    Id SERIAL PRIMARY KEY,
    Body TEXT NOT NULL,
    Title VARCHAR(300),
    Tags TEXT,
    CreationDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    DeletionDate TIMESTAMP,
    AcceptedAnswerId INT REFERENCES Posts(Id)
);

-- ALTER TABLE Posts
-- Add 

CREATE TABLE PostTypes (
    Id SERIAL PRIMARY KEY,
    Name VARCHAR(64)
);

INSERT INTO PostTypes (Name)
VALUES 
    ('Question'),
    ('Answer'),
    ('WikiAnswer');




INSERT INTO Posts (Title, Body, Tags, creationDate)
VALUES (
        'How to join two tables in PostgreSQL?',
        'I have a Users table and an Orders table. I want to list all orders along with the username of the person who made the order. Which type of JOIN should I use?',
        '<sql><postgresql><join>',
        NOW()
);

-- 2. A question about Database Design (Tags)
INSERT INTO Posts (Title, Body, Tags, CreationDate)
VALUES (
    'Storing Tags as a string vs separate table',
    'I am designing a blog. Should I store tags in a comma-separated string in the post table, or create a many-to-many relationship table? What are the pros and cons?',
    '<database-design><schema><normalization>',
    NOW()
);

-- 3. A question about Timestamps
INSERT INTO Posts (Title, Body, Tags, CreationDate)
VALUES (
    'Why is my CreationDate NULL?',
    'I defined my column as TIMESTAMP DEFAULT CURRENT_TIMESTAMP, but when I insert data without specifying the date, it stays NULL. Did I write the syntax wrong?',
    '<sql><postgresql><timestamp><debugging>',
    '2023-11-15 09:30:00' -- You can also provide a specific date manually
);

-------------------------------------------------------
-- users
--------------------------------------------------------
CREATE TABLE Users (
    Id SERIAL PRIMARY KEY,

    Reputation INT,
    CreationDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Views INT
);
INSERT INTO Users (Reputation, Views)
VALUES (100, 2
);
INSERT INTO Users (Reputation, Views)
VALUES (120, 3
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

-- Insert multiple comments for different Posts at once
INSERT INTO Comments (PostId, Score, Text, UserId, UserDisplayName, CreationDate, CalleeUserId)
VALUES 
    -- Comments for Post 1 (How to join two tables)
    (1, 5, 'You should use INNER JOIN for that. Here is an example: SELECT * FROM Users u INNER JOIN Orders o ON u.Id = o.UserId', 1, 'SQLExpert', NOW(), 2),
    (1, 3, 'LEFT JOIN works too if you want to see users with no orders.', 2, 'DataLover', NOW(), 1),
    (1, 10, 'Actually, you might want a FULL OUTER JOIN in some cases.', 1, 'SQLExpert', NOW(), 1),
    
    -- Comments for Post 2 (Database Design)
    (2, 7, 'Always use a separate table for tags! It''s called normalization.', 1, 'SQLExpert', NOW(), NULL),
    (2, 4, 'CSV strings are fine for simple apps, but separate table is more scalable.', 2, 'DataLover', NOW(), NULL),
    (2, 9, 'Read about database normalization. Third normal form recommends separate tables.', 1, 'SQLExpert', NOW(), 2),
    
    -- Comments for Post 3 (Timestamp issue)
    (3, 2, 'Did you remember to NOT specify the column in your INSERT statement?', 2, 'DataLover', NOW(), NULL),
    (3, 6, 'Show us your table definition and INSERT statement. We can help debug.', 1, 'SQLExpert', NOW(), NULL),
    (3, 8, 'Make sure your DEFAULT constraint is properly set. Try: TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL', 1, 'SQLExpert', NOW(), NULL);


DROP TABLE Comments;



ALTER TABLE Comments
ADD COLUMN CalleeUserId INT REFERENCES Users(Id) ON DELETE SET NULL;


DROP TABLE Comments;


--------------------
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
)

--------------------------------

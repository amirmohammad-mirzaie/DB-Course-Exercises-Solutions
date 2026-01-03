
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
    AcceptedAnswerId INT REFERENCES Posts(Id),
    CommentCount INT,
    PostTypeId INT REFERENCES PostTypes(Id),
    OwnerUserId INT REFERENCES Users(Id)
);
ALTER TABLE Posts
ADD COLUMN ParentId INT REFERENCES Posts(Id);


ALTER TABLE Posts
ADD COLUMN AcceptedAnswerId INT REFERENCES Posts(Id);


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


DROP TABLE Comments;
DROP TABLE PostTags;
DROP TABLE Posts;
DROP TABLE PostTypes;
DROP TABLE Tags;



----------------------------
----- DML Solutions --------
----------------------------
-- 1. the number of comments below the questions


-- fisrt solution using directly the commentCount for the posts

SELECT p.CommentCount, pt.Name from Posts p
JOIN PostTypes pt ON pt.Id = p.PostTypeId;


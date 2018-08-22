INSERT INTO users (username,password,salt) VALUES ('dan','man','the');

INSERT INTO cards (user_id,front,back) VALUES (1,'FRONT','BACK');
INSERT INTO cards (user_id,front,back) VALUES (1,'FRONT2','BACK2');
INSERT INTO cards (user_id,front,back) VALUES (1,'FRONT3','BACK3');
INSERT INTO cards (user_id,front,back) VALUES (1,'FRONT4','BACK4');

INSERT INTO keywords (keyword) VALUES ('test1');
INSERT INTO keywords (keyword) VALUES ('test2');
INSERT INTO keywords (keyword) VALUES ('test3');
INSERT INTO keywords (keyword) VALUES ('test4');
INSERT INTO keywords (keyword) VALUES ('test5');

INSERT INTO cards_keywords VALUES (1,1);
INSERT INTO cards_keywords VALUES (1,2);
INSERT INTO cards_keywords VALUES (1,3);
INSERT INTO cards_keywords VALUES (2,2);
INSERT INTO cards_keywords VALUES (3,1);
INSERT INTO cards_keywords VALUES (3,2);
INSERT INTO cards_keywords VALUES (3,4);
INSERT INTO cards_keywords VALUES (4,4);
INSERT INTO cards_keywords VALUES (4,5);


DECLARE @keyword AS varchar(50);
SET @keyword = 'test2';

DECLARE @CardId AS INT
SET @CardId = 1

DECLARE @KeyId AS INT
IF NOT EXISTS (SELECT * FROM keywords WHERE keyword = @keyword) 
	BEGIN
	INSERT INTO keywords (keyword) VALUES (@keyword)
	END
SET @KeyId = (SELECT id FROM keywords WHERE keyword = @keyword)
INSERT INTO cards_keywords VALUES (@CardId,@KeyId)

select * from users;
select * from decks;
select * from decks_cards;
select * from cards;
select * from cards_keywords;
select * from keywords;
select * from decks;





declare @user as INT;
SET @user = 1;
declare @keyword as varchar(50);
SET @keyword = 'derp';

SELECT decks.id, decks.name, decks.description, decks.[public] FROM decks
INNER JOIN decks_cards ON decks.id = decks_cards.deck_id 
INNER JOIN cards ON decks_cards.card_id = cards.id 
INNER JOIN cards_keywords ON cards.id = cards_keywords.card_id 
INNER JOIN keywords ON cards_keywords.keyword_id = keywords.id 
WHERE decks.user_id = @user AND 
(decks.name LIKE @keyword OR decks.description LIKE @keyword OR keywords.keyword LIKE @keyword);
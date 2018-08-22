
-- Switch to the system (aka master) database
USE master;
GO

-- Delete the FlashCardsDB Database (IF EXISTS)
IF EXISTS(select * from sys.databases where name='FlashCardsDB')
DROP DATABASE FlashCardsDB;
GO

-- Create a new FlashCardsDB Database
CREATE DATABASE FlashCardsDB;
GO

-- Switch to the FlashCardsDB Database
USE FlashCardsDB
GO

BEGIN TRANSACTION;

CREATE TABLE users
(
	id			int			identity(1,1),
	username	varchar(50)	not null,
	password	varchar(50)	not null,
	salt		varchar(50)	not null,
	role		varchar(50)	default('user'),

	constraint pk_users primary key (id)
);

CREATE TABLE decks
(
	id			int				identity(1,1),
	user_id		int				not null,
	[public]	bit				default (0),
	name		varchar(50)		not null,
	description	varchar(300),

	constraint pk_decks primary key (id),
	constraint fk_decks_users foreign key (user_id) references users (id)
);

CREATE TABLE cards
(
	id			int		identity(1,1),
	user_id		int		not null,
	front		varchar(200)	not null,
	back		varchar(200)	not null,

	constraint pk_cards primary key (id),
	constraint fk_cards_users foreign key (user_id) references users (id)
);

CREATE TABLE decks_cards
(
	deck_id	int	not null,
	card_id	int	not null,
	position int not null,

	constraint pk_decks_cards primary key (deck_id, card_id),
	constraint fk_decks_cards_decks foreign key (deck_id) references decks (id),
	constraint fk_decks_cards_cards foreign key (card_id) references cards (id)
);

CREATE TABLE keywords
(
	id			int			identity(1,1),
	keyword		varchar(50)	not null unique,

	constraint pk_keywords primary key (id)
);

CREATE TABLE cards_keywords
(	
	card_id	int	not null,
	keyword_id	int	not null,
	
	constraint pk_cards_keywords primary key (card_id, keyword_id),
	constraint fk_cards_keywords_cards foreign key (card_id) references cards (id),
	constraint fk_cards_keywords_keywords foreign key (keyword_id) references keywords (id)
);
COMMIT TRANSACTION;


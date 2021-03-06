USE [master]
GO
/****** Object:  Database [FlashCardsDB]    Script Date: 8/22/2018 4:28:26 PM ******/
CREATE DATABASE [FlashCardsDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'FlashCardsDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\FlashCardsDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'FlashCardsDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\FlashCardsDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [FlashCardsDB] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [FlashCardsDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [FlashCardsDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [FlashCardsDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [FlashCardsDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [FlashCardsDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [FlashCardsDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [FlashCardsDB] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [FlashCardsDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [FlashCardsDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [FlashCardsDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [FlashCardsDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [FlashCardsDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [FlashCardsDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [FlashCardsDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [FlashCardsDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [FlashCardsDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [FlashCardsDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [FlashCardsDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [FlashCardsDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [FlashCardsDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [FlashCardsDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [FlashCardsDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [FlashCardsDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [FlashCardsDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [FlashCardsDB] SET  MULTI_USER 
GO
ALTER DATABASE [FlashCardsDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [FlashCardsDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [FlashCardsDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [FlashCardsDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [FlashCardsDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [FlashCardsDB] SET QUERY_STORE = OFF
GO
USE [FlashCardsDB]
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [FlashCardsDB]
GO
/****** Object:  Table [dbo].[cards]    Script Date: 8/22/2018 4:28:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cards](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[front] [varchar](200) NOT NULL,
	[back] [varchar](200) NOT NULL,
 CONSTRAINT [pk_cards] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cards_keywords]    Script Date: 8/22/2018 4:28:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cards_keywords](
	[card_id] [int] NOT NULL,
	[keyword_id] [int] NOT NULL,
 CONSTRAINT [pk_cards_keywords] PRIMARY KEY CLUSTERED 
(
	[card_id] ASC,
	[keyword_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[decks]    Script Date: 8/22/2018 4:28:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[decks](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[public] [bit] NULL,
	[name] [varchar](50) NOT NULL,
	[description] [varchar](300) NULL,
 CONSTRAINT [pk_decks] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[decks_cards]    Script Date: 8/22/2018 4:28:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[decks_cards](
	[deck_id] [int] NOT NULL,
	[card_id] [int] NOT NULL,
	[position] [int] NOT NULL,
 CONSTRAINT [pk_decks_cards] PRIMARY KEY CLUSTERED 
(
	[deck_id] ASC,
	[card_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[keywords]    Script Date: 8/22/2018 4:28:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[keywords](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[keyword] [varchar](50) NOT NULL,
 CONSTRAINT [pk_keywords] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[users]    Script Date: 8/22/2018 4:28:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[password] [varchar](50) NOT NULL,
	[salt] [varchar](50) NOT NULL,
	[role] [varchar](50) NULL,
 CONSTRAINT [pk_users] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[cards] ON 
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (1, 1, N'1', N'H')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (2, 1, N'2', N'He')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (3, 1, N'6', N'C')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (4, 1, N'7', N'N')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (5, 1, N'8', N'O')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (6, 1, N'27', N'Co')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (7, 1, N'28', N'Ni')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (8, 1, N'36', N'Kr')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (9, 1, N'80', N'Hg')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (10, 1, N'Ar', N'Argon')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (11, 1, N'Bi', N'Bismuth')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (12, 1, N'Ca', N'Calcium')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (13, 1, N'Dy', N'Dysprosium')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (14, 1, N'Er', N'Erbium')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (15, 1, N'F', N'Flourine')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (16, 1, N'Ga', N'Gallium')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (17, 1, N'H', N'Hydrogen')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (18, 1, N'I', N'Iodine')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (19, 1, N'Kr', N'Krypton')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (20, 1, N'Li', N'Lithium')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (21, 1, N'Mn', N'Manganese')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (22, 1, N'Na', N'Sodium')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (23, 1, N'O', N'Oxygen')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (24, 1, N'Pb', N'Lead')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (25, 1, N'Re', N'Rhenium')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (26, 1, N'Sb', N'Antimony')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (27, 1, N'Tb', N'Terbium')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (28, 1, N'U', N'Uranium')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (29, 1, N'V', N'Vanadium')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (30, 1, N'W', N'Tungsten')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (31, 1, N'Xe', N'Xenon')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (32, 1, N'Y', N'Yttrium')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (33, 1, N'Zn', N'Zinc')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (34, 1, N'To Kill a Mockingbird', N'Harper Lee')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (35, 1, N'Pride and Prejudice', N'Jane Austen')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (36, 1, N'1984', N'George Orwell')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (37, 1, N'The Lord of the Rings', N'J.R.R. Tolkien')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (38, 1, N'The Great Gatsby', N'F. Scott Fitzgerald')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (39, 1, N'Charlotte''s Web', N'E.B. White')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (40, 1, N'Little Women', N'Louisa May Alcott')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (41, 1, N'Fahrenheit 451', N'Ray Bradbury')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (42, 1, N'Jane Eyre', N'Charlotte Bronte')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (43, 1, N'Gone with the Wind', N'Margaret Mitchell')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (44, 1, N'The Catcher in the Rye', N'J.D. Salinger')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (45, 1, N'The Adventures of Huckleberry Finn', N'Mark Twain')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (46, 1, N'The Lion, the Witch, and the Wardrobe', N'C.S. Lewis')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (47, 1, N'Brazil', N'Brasilia')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (48, 1, N'Argentina', N'Buenos 
Aires')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (49, 1, N'Belarus', N'Minsk')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (50, 1, N'China', N'Beijing')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (51, 1, N'Denmark ', N'Copenhagen')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (52, 1, N'Egypt ', N'Cairo')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (53, 1, N'France ', N'Paris')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (54, 1, N'Greece', N'Athens')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (55, 1, N'Haiti ', N'Port-au-Prince')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (56, 1, N'India ', N'New Delhi')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (57, 1, N'Jordan ', N'Amman')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (58, 1, N'Kenya ', N'Nairobi')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (59, 1, N'Libya ', N'Tripoli')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (60, 1, N'Mexico ', N'Mexico City')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (61, 1, N'New 
Zealand', N'Wellington')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (62, 1, N'Oman ', N'Muscat')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (63, 1, N'Philippines ', N'Manila')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (64, 1, N'Qatar ', N'Doha')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (65, 1, N'Russia ', N'Moscow')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (66, 1, N'Singapore ', N'Singapore')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (67, 1, N'Turkey ', N'Ankara')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (68, 1, N'United Arab 
Emirates', N'Abu Dhabi')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (69, 1, N'Venezuela ', N'Caracas')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (70, 1, N'Yemen ', N'Sanaa')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (71, 1, N'Zimbabwe ', N'Harare')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (72, 1, N'Pikachu', N'Electric')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (73, 1, N'Togepi', N'Fairy')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (74, 1, N'Clefable', N'Fairy/Norma
l')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (77, 1, N'Absol', N'Dark')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (78, 1, N'Rhyperior', N'Ground/Rock')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (79, 1, N'Tirtouga', N'Water/Rock')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (80, 1, N'Sliggoo', N'Dragon')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (81, 1, N'Turtonator', N'Fire/Dragon')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (82, 1, N'Tangela', N'Grass')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (83, 1, N'Spinarak', N'Bug/Poison')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (84, 1, N'Pelipper', N'Water/Flying')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (85, 1, N'Lucario', N'Fighting/Steel')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (86, 1, N'Chandelure', N'Ghost/Fire')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (87, 1, N'Aurorus', N'Rock/Ice')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (88, 1, N'Oranguru', N'Normal/Psychic')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (89, 1, N'Ducks', N'Anaheim, CA
NHL')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (90, 1, N'Braves', N'Atlanta, GA
MLB')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (91, 1, N'Orioles', N'Baltimore, MD
MLB')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (92, 1, N'Bulls', N'Chicago, IL
NBA')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (93, 1, N'Browns', N'Cleveland, OH
NFL')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (94, 1, N'Rangers', N'Trick Question:
NYC: NHL
Arlington, TX: MLB')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (95, 1, N'Steelers', N'Pittsburgh, PA
NFL')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (96, 1, N'Heat', N'Miami, FL
NBA')
GO
INSERT [dbo].[cards] ([id], [user_id], [front], [back]) VALUES (97, 1, N'Red Wings', N'Detroit, MI
NHL')
GO
SET IDENTITY_INSERT [dbo].[cards] OFF
GO
INSERT [dbo].[cards_keywords] ([card_id], [keyword_id]) VALUES (75, 1)
GO
INSERT [dbo].[cards_keywords] ([card_id], [keyword_id]) VALUES (75, 2)
GO
INSERT [dbo].[cards_keywords] ([card_id], [keyword_id]) VALUES (76, 1)
GO
INSERT [dbo].[cards_keywords] ([card_id], [keyword_id]) VALUES (76, 3)
GO
SET IDENTITY_INSERT [dbo].[decks] ON 
GO
INSERT [dbo].[decks] ([id], [user_id], [public], [name], [description]) VALUES (1, 1, 0, N'Chemistry 1', N'Elements by Atomic Weight')
GO
INSERT [dbo].[decks] ([id], [user_id], [public], [name], [description]) VALUES (2, 1, 0, N'Chemistry 2', N'Element Names and Symbols')
GO
INSERT [dbo].[decks] ([id], [user_id], [public], [name], [description]) VALUES (3, 1, 0, N'Literature', N'Famous Books and their Authors')
GO
INSERT [dbo].[decks] ([id], [user_id], [public], [name], [description]) VALUES (4, 1, 0, N'Geography', N'Countries and Their Capitals')
GO
INSERT [dbo].[decks] ([id], [user_id], [public], [name], [description]) VALUES (5, 1, 0, N'Pokemon', N'Pokemon Names and Their Types')
GO
INSERT [dbo].[decks] ([id], [user_id], [public], [name], [description]) VALUES (7, 1, 0, N'Sports', N'Sports Teams and their Sport and City')
GO
SET IDENTITY_INSERT [dbo].[decks] OFF
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (1, 1, 1)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (1, 2, 2)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (1, 3, 3)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (1, 4, 4)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (1, 5, 5)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (1, 6, 6)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (1, 7, 7)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (1, 8, 8)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (1, 9, 9)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 10, 1)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 11, 2)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 12, 3)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 13, 4)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 14, 5)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 15, 6)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 16, 7)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 17, 8)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 18, 9)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 19, 10)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 20, 11)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 21, 12)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 22, 13)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 23, 14)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 24, 15)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 25, 16)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 26, 17)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 27, 18)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 28, 19)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 29, 20)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 30, 21)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 31, 22)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 32, 23)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (2, 33, 24)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (3, 34, 1)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (3, 35, 2)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (3, 36, 3)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (3, 37, 4)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (3, 38, 5)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (3, 39, 6)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (3, 40, 7)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (3, 41, 8)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (3, 42, 9)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (3, 43, 10)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (3, 44, 11)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (3, 45, 12)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (3, 46, 13)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 48, 1)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 49, 2)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 50, 3)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 51, 4)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 52, 5)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 53, 6)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 54, 7)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 55, 8)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 56, 9)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 57, 10)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 58, 11)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 59, 12)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 60, 13)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 61, 14)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 62, 15)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 63, 16)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 64, 17)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 65, 18)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 66, 19)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 67, 20)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 68, 21)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 69, 22)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 70, 23)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (4, 71, 24)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (5, 72, 1)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (5, 73, 2)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (5, 77, 3)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (5, 78, 4)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (5, 79, 5)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (5, 80, 6)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (5, 81, 7)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (5, 82, 8)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (5, 83, 9)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (5, 84, 10)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (5, 85, 11)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (5, 86, 12)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (5, 87, 13)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (5, 88, 14)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (7, 89, 1)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (7, 90, 2)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (7, 91, 3)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (7, 92, 4)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (7, 93, 5)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (7, 94, 6)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (7, 95, 7)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (7, 96, 8)
GO
INSERT [dbo].[decks_cards] ([deck_id], [card_id], [position]) VALUES (7, 97, 9)
GO
SET IDENTITY_INSERT [dbo].[keywords] ON 
GO
INSERT [dbo].[keywords] ([id], [keyword]) VALUES (2, N'addition')
GO
INSERT [dbo].[keywords] ([id], [keyword]) VALUES (1, N'math')
GO
INSERT [dbo].[keywords] ([id], [keyword]) VALUES (3, N'subtraction')
GO
SET IDENTITY_INSERT [dbo].[keywords] OFF
GO
SET IDENTITY_INSERT [dbo].[users] ON 
GO
INSERT [dbo].[users] ([id], [username], [password], [salt], [role]) VALUES (1, N'ds.danstone@gmail.com', N'ul+bGkqkvyp8NtqqxgG98TBSpeo=', N'zBd02ifhot8=', N'user')
GO
INSERT [dbo].[users] ([id], [username], [password], [salt], [role]) VALUES (2, N'dantheman@google.com', N't968B+bxJP29Tz22ofaoj7YLbdY=', N'xPF6+5f/p/s=', N'user')
GO
SET IDENTITY_INSERT [dbo].[users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__keywords__3697F5A27F287F51]    Script Date: 8/22/2018 4:28:28 PM ******/
ALTER TABLE [dbo].[keywords] ADD UNIQUE NONCLUSTERED 
(
	[keyword] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[decks] ADD  DEFAULT ((0)) FOR [public]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT ('user') FOR [role]
GO
ALTER TABLE [dbo].[cards]  WITH CHECK ADD  CONSTRAINT [fk_cards_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[cards] CHECK CONSTRAINT [fk_cards_users]
GO
ALTER TABLE [dbo].[cards_keywords]  WITH CHECK ADD  CONSTRAINT [fk_cards_keywords_cards] FOREIGN KEY([card_id])
REFERENCES [dbo].[cards] ([id])
GO
ALTER TABLE [dbo].[cards_keywords] CHECK CONSTRAINT [fk_cards_keywords_cards]
GO
ALTER TABLE [dbo].[cards_keywords]  WITH CHECK ADD  CONSTRAINT [fk_cards_keywords_keywords] FOREIGN KEY([keyword_id])
REFERENCES [dbo].[keywords] ([id])
GO
ALTER TABLE [dbo].[cards_keywords] CHECK CONSTRAINT [fk_cards_keywords_keywords]
GO
ALTER TABLE [dbo].[decks]  WITH CHECK ADD  CONSTRAINT [fk_decks_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[decks] CHECK CONSTRAINT [fk_decks_users]
GO
ALTER TABLE [dbo].[decks_cards]  WITH CHECK ADD  CONSTRAINT [fk_decks_cards_cards] FOREIGN KEY([card_id])
REFERENCES [dbo].[cards] ([id])
GO
ALTER TABLE [dbo].[decks_cards] CHECK CONSTRAINT [fk_decks_cards_cards]
GO
ALTER TABLE [dbo].[decks_cards]  WITH CHECK ADD  CONSTRAINT [fk_decks_cards_decks] FOREIGN KEY([deck_id])
REFERENCES [dbo].[decks] ([id])
GO
ALTER TABLE [dbo].[decks_cards] CHECK CONSTRAINT [fk_decks_cards_decks]
GO
USE [master]
GO
ALTER DATABASE [FlashCardsDB] SET  READ_WRITE 
GO

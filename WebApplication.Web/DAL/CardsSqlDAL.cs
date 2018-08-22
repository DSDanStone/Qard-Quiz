using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using WebApplication.Web.Models.FlashCards;

namespace WebApplication.Web.DAL
{
    public class CardsSqlDAL : ICardsDAL
    {
        private readonly string connectionString;

        public CardsSqlDAL(string connectionString)
        {
            this.connectionString = connectionString;
        }

        /// <summary>
        /// Adds a card to the database
        /// </summary>
        /// <param name="card">The card to add to the database</param>
        /// <returns>The same card with its new Id filed in</returns>
        public CardModel CreateCard(CardModel card)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string sql = @"INSERT INTO cards (user_id, front, back) VALUES (@userId, @front, @back);
									SELECT TOP 1 id FROM cards WHERE user_id = @userId AND front = @front AND back = @back
									ORDER BY id DESC;";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@userId", card.userId);
                    cmd.Parameters.AddWithValue("@front", card.front);
                    cmd.Parameters.AddWithValue("@back", card.back);

                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        card.id = Convert.ToInt32(reader["id"]);
                    }

                    reader.Close();

                    sql = "DECLARE @KeyId AS INT " +
                            "IF NOT EXISTS(SELECT * FROM keywords WHERE keyword = @keyword) " +
                                "BEGIN " +
                                "INSERT INTO keywords(keyword) VALUES(@keyword) " +
                                "END " +
                            "SET @KeyId = (SELECT id FROM keywords WHERE keyword = @keyword) " +
                            "INSERT INTO cards_keywords VALUES(@cardId, @keyId);";
                    cmd.CommandText = sql;

                    if (!string.IsNullOrEmpty(card.keywords))
                    {
                        foreach (string keyword in card.keywords.ToLower().Split(' ').ToHashSet())
                        {
                            cmd.Parameters.Clear();
                            cmd.Parameters.AddWithValue("@cardId", card.id);
                            cmd.Parameters.AddWithValue("@keyword", keyword);
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                return null;
            }
            return card;
        }

        /// <summary>
        /// Assigns a card to a deck
        /// </summary>
        /// <param name="card">The card to assign (the deck id property must be filled in)</param>
        public void AssignCardToDeck(CardModel card)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string sql = @"DECLARE @position AS INT;
									IF EXISTS (SELECT * FROM decks_cards WHERE deck_id = @deckId)
										BEGIN
											SET @position = (SELECT TOP 1 position FROM decks_cards WHERE deck_id = @deckId ORDER BY position DESC);
										END
									ELSE
										BEGIN
											SET @position = 0;
										END
									INSERT INTO decks_cards VALUES (@deckId, @cardId, @position + 1);";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@deckId", card.deckId);
                    cmd.Parameters.AddWithValue("@cardId", card.id);

                    cmd.ExecuteNonQuery();
                }
            }
            catch (SqlException ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Removes a card from a deck
        /// </summary>
        /// <param name="card">The card to assign (the deck id property must be filled in)</param>
        public void RemoveCardFromDeck(CardModel card)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string sql = @"DELETE FROM decks_cards WHERE deck_id = @deckId AND card_id = @cardId;";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@deckId", card.deckId);
                    cmd.Parameters.AddWithValue("@cardId", card.id);

                    cmd.ExecuteNonQuery();
                }
            }
            catch (SqlException ex)
            {
                return;
            }
        }

        /// <summary>
        /// Gets a card by its ID
        /// </summary>
        /// <param name="cardId">The ID of the card to retrieve</param>
        /// <returns>The card with the specified ID</returns>
        public CardModel GetCard(int cardId)
        {
            CardModel card = new CardModel();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string sql = "SELECT * FROM cards WHERE id = @cardId;";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@cardId", cardId);

                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        card = MapRowToCard(reader);
                        reader.Close();

                        sql = "SELECT keyword FROM keywords " +
                        "INNER JOIN cards_keywords ON keywords.id = cards_keywords.keyword_id " +
                        "INNER JOIN cards ON cards_keywords.card_id = cards.id " +
                        "WHERE cards.id = @cardId;";
                        cmd.CommandText = sql;
                        //cmd.Parameters.Clear();
                        //cmd.Parameters.AddWithValue("@cardId", card.id);

                        SqlDataReader keywordReader = cmd.ExecuteReader();
                        card.keywords = MapReaderToString(keywordReader);
                    }
                }
            }
            catch (SqlException ex)
            {
                return null;
            }

            return card;
        }

        /// <summary>
        /// Deletes a card from the database
        /// </summary>
        /// <param name="card">The card to be deleted</param>
        public void DeleteCard(CardModel card)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string sql = "DELETE FROM cards_keywords WHERE card_id = @cardId; " +
                                "DELETE FROM decks_cards WHERE card_id = @cardId; " +
                                "DELETE FROM cards WHERE card_id = @cardId;";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@cardId", card.id);

                    cmd.ExecuteNonQuery();
                }
            }
            catch (SqlException ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Updates the front and back of a card as well as its keywords
        /// </summary>
        /// <param name="card"></param>
        public void UpdateCard(CardModel card)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string sql = "UPDATE cards SET front = @front, back = @back WHERE id = @cardId; " +
                                "DELETE FROM cards_keywords WHERE card_id = @cardId";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@cardId", card.id);
                    cmd.Parameters.AddWithValue("@front", card.front);
                    cmd.Parameters.AddWithValue("@back", card.back);

                    cmd.ExecuteNonQuery();

                    if (!String.IsNullOrEmpty(card.keywords))
                    {
                        sql = @"DECLARE @KeyId AS INT;
						IF NOT EXISTS(SELECT * FROM keywords WHERE keyword = @keyword)
							BEGIN 
							INSERT INTO keywords(keyword) VALUES(@keyword)
							END 
						SET @KeyId = (SELECT id FROM keywords WHERE keyword = @keyword);
						INSERT INTO cards_keywords VALUES(@cardId, @keyId);";
                        cmd.CommandText = sql;

                        foreach (string keyword in card.keywords.ToLower().Split(' '))
                        {
                            cmd.Parameters.Clear();
                            cmd.Parameters.AddWithValue("@cardId", card.id);
                            cmd.Parameters.AddWithValue("@keyword", keyword);
                            cmd.ExecuteNonQuery();
                        }
                    }

                }
            }
            catch (SqlException ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Gets all the cards in a specified deck
        /// </summary>
        /// <param name="deck">The Deck to get cards from</param>
        /// <returns>A list of cards in the deck</returns>
        public IList<CardModel> GetCardsInDeck(DeckModel deck)
        {
            List<CardModel> cards = new List<CardModel>();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string sql = "SELECT cards.id, cards.user_id, cards.front, cards.back FROM decks " +
                                "INNER JOIN decks_cards ON decks.id = decks_cards.deck_id " +
                                "INNER JOIN cards ON decks_cards.card_id = cards.id " +
                                "WHERE decks.id = @deckId " +
                                "ORDER BY decks_cards.position ASC;";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@deckId", deck.id);

                    SqlDataReader reader = cmd.ExecuteReader();

                    sql = "SELECT keyword FROM keywords " +
                        "INNER JOIN cards_keywords ON keywords.id = cards_keywords.keyword_id " +
                        "INNER JOIN cards ON cards_keywords.card_id = cards.id " +
                        "WHERE cards.id = @cardId;";

                    while (reader.Read())
                    {
                        SqlCommand keywordCmd = new SqlCommand(sql, conn);
                        CardModel card = MapRowToCard(reader);
                        keywordCmd.Parameters.Clear();
                        keywordCmd.Parameters.AddWithValue("@cardId", card.id);
                        SqlDataReader keywordReader = keywordCmd.ExecuteReader();
                        card.keywords = MapReaderToString(keywordReader);

                        cards.Add(card);
                    }
                }
            }
            catch (SqlException ex)
            {
                return null;
            }

            return cards;
        }

        /// <summary>
        /// Gets all cards that have the specified keyword
        /// </summary>
        /// <param name="keyword">The keyword to search for</param>
        /// <returns>A list of cards with the keyword</returns>
        public IList<CardModel> GetCardsByKeyword(string keyword)
        {
            List<CardModel> cards = new List<CardModel>();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string sql = "SELECT cards.id, cards.user_id, cards.front, cards.back FROM cards " +
                                "INNER JOIN cards_keywords ON cards.id = cards_keywords.card_id " +
                                "INNER JOIN keywords ON cards_keywords.keyword_id = keyword.id " +
                                "WHERE keywords.keyword LIKE @keyword;";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@keyword", "%" + keyword.ToLower() + "%");

                    SqlDataReader reader = cmd.ExecuteReader();

                    sql = "SELECT keyword FROM keywords " +
                        "INNER JOIN cards_keywords ON keywords.id = cards_keywords.keyword_id " +
                        "INNER JOIN cards ON cards_keywords.card_id = cards.id " +
                        "WHERE cards.id = @cardId;";
                    cmd.CommandText = sql;

                    while (reader.Read())
                    {
                        CardModel card = MapRowToCard(reader);
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@cardId", card.id);
                        SqlDataReader keywordReader = cmd.ExecuteReader();
                        card.keywords = MapReaderToString(keywordReader);

                        cards.Add(card);
                    }
                }
            }
            catch (SqlException ex)
            {
                return null;
            }

            return cards;
        }

        /// <summary>
        /// Gets all the cards not in a specified deck
        /// </summary>
        /// <returns>A list of cards not in any deck</returns>
        public IList<CardModel> GetCardsInNoDeck()
        {
            List<CardModel> cards = new List<CardModel>();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string sql = @"SELECT cards.id, cards.user_id, cards.front, cards.back FROM cards
								INNER JOIN decks_cards ON cards.id = decks_cards.card_id								
								WHERE decks_cards.card_id IS NULL;";

                    SqlCommand cmd = new SqlCommand(sql, conn);

                    SqlDataReader reader = cmd.ExecuteReader();

                    sql = "SELECT keyword FROM keywords " +
                        "INNER JOIN cards_keywords ON keywords.id = cards_keywords.keyword_id " +
                        "INNER JOIN cards ON cards_keywords.card_id = cards.id " +
                        "WHERE cards.id = @cardId;";

                    while (reader.Read())
                    {
                        SqlCommand keywordCmd = new SqlCommand(sql, conn);
                        CardModel card = MapRowToCard(reader);
                        keywordCmd.Parameters.Clear();
                        keywordCmd.Parameters.AddWithValue("@cardId", card.id);
                        SqlDataReader keywordReader = keywordCmd.ExecuteReader();
                        card.keywords = MapReaderToString(keywordReader);

                        cards.Add(card);
                    }
                }
            }
            catch (SqlException ex)
            {
                return null;
            }

            return cards;
        }

        /// <summary>
        /// Maps a SQLDataReader Row into a CardModel
        /// </summary>
        /// <param name="reader">The sql data line to read</param>
        /// <returns>A filled in CardModel object</returns>
        private CardModel MapRowToCard(SqlDataReader reader)
        {
            return new CardModel()
            {
                id = Convert.ToInt32(reader["id"]),
                userId = Convert.ToInt32(reader["user_id"]),
                front = Convert.ToString(reader["front"]),
                back = Convert.ToString(reader["back"]),
            };
        }

        /// <summary>
        /// Gets the keywords out of a SQLDataReader
        /// </summary>
        /// <param name="reader">A SQLDataReader containing keywords</param>
        /// <returns>A string of keywords separated by spaces</returns>
        private string MapReaderToString(SqlDataReader reader)
        {
            string keywords = "";
            while (reader.Read())
            {
                keywords += Convert.ToString(reader["keyword"]) + " ";
            }
            return keywords.Trim();
        }
    }
}

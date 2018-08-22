using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using WebApplication.Web.Models;
using WebApplication.Web.Models.FlashCards;

namespace WebApplication.Web.DAL
{
	public class DecksSqlDAL : IDecksDAL
	{
		private readonly string connectionString;

		public DecksSqlDAL(string connectionString)
		{
			this.connectionString = connectionString;
		}

		/// <summary>
		/// Returns a list of decks for the current user
		/// </summary>
		/// <param name="user"></param>
		/// <returns></returns>
		public IList<DeckModel> GetDecksByUser(User user)
		{
			List<DeckModel> decks = new List<DeckModel>();

			try
			{
				using (SqlConnection conn = new SqlConnection(connectionString))
				{
					conn.Open();
					string sql = $"SELECT * FROM decks WHERE user_id = @user_id ORDER BY id DESC";
					SqlCommand cmd = new SqlCommand(sql, conn);
					cmd.Parameters.AddWithValue("@user_id", user.Id);
					SqlDataReader reader = cmd.ExecuteReader();

					while (reader.Read())
					{
						decks.Add(MapRowsToDeck(reader));
					}
				}
			}
			catch (SqlException ex)
			{
				return null;
			}
			return decks;
		}

		/// <summary>
		/// Creates a new deck for the current user
		/// </summary>
		/// <param name="user"></param>
		/// <param name="deck"></param>
		/// <returns></returns>
		public DeckModel MakeDeck(User user, DeckModel deck)
		{
			try
			{
				using (SqlConnection conn = new SqlConnection(connectionString))
				{
					conn.Open();
					string sql = $"INSERT into decks(user_id, name, description) values (@user_id, @name, @description)";
					SqlCommand cmd = new SqlCommand(sql, conn);
					cmd.Parameters.AddWithValue("@name", deck.name);
					cmd.Parameters.AddWithValue("@description", deck.description);
					cmd.Parameters.AddWithValue("@user_id", user.Id);

					cmd.ExecuteNonQuery();

					sql = $"SELECT TOP 1 id FROM decks WHERE user_id = @user_id AND name = @name AND description = @description ORDER BY id DESC;";
					cmd.CommandText = sql;
					SqlDataReader reader = cmd.ExecuteReader();

					if (reader.Read())
					{
						deck.id = Convert.ToInt32(reader["id"]);
					}
				}
			}
			catch (SqlException ex)
			{
				return null;
			}
			return deck;
		}

		/// <summary>
		/// Returns a deck based on the deck Id
		/// </summary>
		/// <param name="deckId"></param>
		/// <returns></returns>
		public DeckModel GetDeckById(int deckId)
		{
			DeckModel deck = new DeckModel();

			try
			{
				using (SqlConnection conn = new SqlConnection(connectionString))
				{
					conn.Open();
					string sql = $"SELECT * FROM decks WHERE id = @deck_id";
					SqlCommand cmd = new SqlCommand(sql, conn);
					cmd.Parameters.AddWithValue("@deck_id", deckId);

					SqlDataReader reader = cmd.ExecuteReader();

					if (reader.Read())
					{
						deck = MapRowsToDeck(reader);
					}
				}
			}

			catch (SqlException ex)
			{
				return null;
			}

			return deck;
		}

		/// <summary>
		/// Verifies that the user has access to the deck
		/// </summary>
		/// <param name="user"></param>
		/// <param name="deck"></param>
		/// <returns></returns>
		public bool VerifyDeckByUser(User user, DeckModel deck)
		{
			try
			{
				using (SqlConnection conn = new SqlConnection(connectionString))
				{
					conn.Open();
					string sql = $"SELECT * FROM decks WHERE user_id = @user_id AND id = @deck_id";
					SqlCommand cmd = new SqlCommand(sql, conn);
					cmd.Parameters.AddWithValue("@user_id", user.Id);
					cmd.Parameters.AddWithValue("@deck_id", deck.id);

					SqlDataReader reader = cmd.ExecuteReader();

					return reader.Read();

				}
			}
			catch (SqlException ex)
			{
                return false;
			}

		}

		/// <summary>
		/// Searches for decks the user owns which relevant to the provided keywords
		/// </summary>
		/// <param name="user">The current user</param>
		/// <param name="keywords">A list of space separated keywords</param>
		/// <returns>A list of all relevent decks</returns>
		public IList<DeckModel> FilterDecks(User user, string keywords)
		{
			List<DeckModel> decks = new List<DeckModel>();
			try
			{
				using (SqlConnection conn = new SqlConnection(connectionString))
				{
					conn.Open();
					string sql = @"SELECT decks.id, decks.name, decks.description, decks.[public] FROM decks
									LEFT JOIN decks_cards ON decks.id = decks_cards.deck_id 
									LEFT JOIN cards ON decks_cards.card_id = cards.id 
									LEFT JOIN cards_keywords ON cards.id = cards_keywords.card_id 
									LEFT JOIN keywords ON cards_keywords.keyword_id = keywords.id 
									WHERE decks.user_id = @user AND 
									(LOWER(decks.name) LIKE @keyword OR LOWER(decks.description) LIKE @keyword 
									OR LOWER(cards.front) LIKE @keyword OR LOWER(cards.back) LIKE @keyword 
									OR LOWER(keywords.keyword) LIKE @keyword);";

					foreach (string keyword in keywords.ToLower().Split(' ').ToHashSet())
					{
						SqlCommand cmd = new SqlCommand(sql, conn);
						cmd.Parameters.AddWithValue("@user", user.Id);
						cmd.Parameters.AddWithValue("@keyword", "%" + keyword.ToLower() + "%");

						SqlDataReader reader = cmd.ExecuteReader();

						while (reader.Read())
						{
							DeckModel deck = MapRowsToDeck(reader);
							if (decks.Where(d => d.id == deck.id).ToList().Count == 0)
							{
								decks.Add(deck);
							}
						}
					}
				}
			}
			catch (SqlException ex)
			{
				return null;
			}
			return decks;
		}

		/// <summary>
		/// Updates the name and description of a deck
		/// </summary>
		/// <param name="deck"></param>
		public void UpdateDeck(DeckModel deck)
		{
			try
			{
				using (SqlConnection conn = new SqlConnection(connectionString))
				{
					conn.Open();
					string sql = "UPDATE decks SET name = @name, description = @description WHERE id = @deckId;";
					SqlCommand cmd = new SqlCommand(sql, conn);
					cmd.Parameters.AddWithValue("@deckId", deck.id);
					cmd.Parameters.AddWithValue("@name", deck.name);
					cmd.Parameters.AddWithValue("@description", deck.description);

					cmd.ExecuteNonQuery();
				}
			}
			catch (SqlException ex)
			{
                throw ex;
			}
		}

		/// <summary>
		/// Updates the order of the cards in the deck to the current order
		/// </summary>
		/// <param name="deck">The deck to update</param>
		public void UpdateDeckOrder(DeckModel deck)
		{
			try
			{
				using (SqlConnection conn = new SqlConnection(connectionString))
				{
					conn.Open();
					string sql = "DELETE FROM decks_cards WHERE deck_id = @deckId";
					SqlCommand cmd = new SqlCommand(sql, conn);
					cmd.Parameters.AddWithValue("@deckId", deck.id);

					cmd.ExecuteNonQuery();

					sql = "INSERT INTO decks_cards (deck_id, card_id, position) VALUES (@deckId, @cardId, @position);";
					cmd.CommandText = sql;

					for (int i = 0; i < deck.cards.Count; i++)
					{
						cmd.Parameters.Clear();
						cmd.Parameters.AddWithValue("@deckId", deck.id);
						cmd.Parameters.AddWithValue("@cardId", deck.cards[i].id);
						cmd.Parameters.AddWithValue("@position", i + 1);
						cmd.ExecuteNonQuery();
					}
				}
			}
			catch (SqlException ex)
			{
                throw ex;
			}
		}

		/// <summary>
		/// Deletes a deck from the system
		/// </summary>
		/// <param name="deck">The deck to be deleted</param>
		public void DeleteDeck(DeckModel deck)
		{
			try
			{
				using (SqlConnection conn = new SqlConnection(connectionString))
				{
					conn.Open();
					string sql = @"DELETE FROM decks_cards WHERE deck_id = @deckId;
									DELETE FROM decks WHERE id = @deckId;";
					SqlCommand cmd = new SqlCommand(sql, conn);
					cmd.Parameters.AddWithValue("@deckId", deck.id);

					cmd.ExecuteNonQuery();
				}
			}
			catch (SqlException ex)
			{
                throw ex;
			}
		}

		/// <summary>
		/// Gets the deck from the current row in the database and adds them to the list of decks
		/// </summary>
		/// <param name="decks"></param>
		/// <param name="reader"></param>
		private static DeckModel MapRowsToDeck(SqlDataReader reader)
		{
			return new DeckModel
			{
				id = Convert.ToInt32(reader["id"]),
				name = Convert.ToString(reader["name"]),
				description = Convert.ToString(reader["description"]),
				isPublic = Convert.ToBoolean(reader["public"])
			};
		}
	}
}

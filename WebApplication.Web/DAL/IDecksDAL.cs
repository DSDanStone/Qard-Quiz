using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApplication.Web.Models;
using WebApplication.Web.Models.FlashCards;

namespace WebApplication.Web.DAL
{
	public interface IDecksDAL
	{
		/// <summary>
		/// Gets the decks for the logged in user
		/// </summary>
		/// <param name="user"></param>
		/// <returns></returns>
		IList<DeckModel> GetDecksByUser(User user);

		/// <summary>
		/// Creates a new deck for the logged in user
		/// </summary>
		/// <param name="user"></param>
		/// <returns></returns>
		DeckModel MakeDeck(User user, DeckModel deck);

		/// <summary>
		/// Verifies that the current user has access to the deck being modified
		/// </summary>
		/// <param name="user"></param>
		/// <param name="deck"></param>
		/// <returns></returns>
		bool VerifyDeckByUser(User user, DeckModel deck);

		/// <summary>
		/// Returns a specific deck based on the Deck Id
		/// </summary>
		/// <param name="deckId"></param>
		/// <returns></returns>
		DeckModel GetDeckById(int deckId);

		/// <summary>
		/// Searches for decks the user owns which relevant to the provided keywords
		/// </summary>
		/// <param name="user">The current user</param>
		/// <param name="keywords">A list of space separated keywords</param>
		/// <returns>A list of all relevent decks</returns>
		IList<DeckModel> FilterDecks(User user, string keywords);

		/// <summary>
		/// Updates the name and description of a deck
		/// </summary>
		/// <param name="deck"></param>
		void UpdateDeck(DeckModel deck);

		/// <summary>
		/// Updates the order of the cards in the deck to the current order
		/// </summary>
		/// <param name="deck">The deck to update</param>
		void UpdateDeckOrder(DeckModel deck);

		/// <summary>
		/// Deletes a deck from the system
		/// </summary>
		/// <param name="deck">The deck to be deleted</param>
		void DeleteDeck(DeckModel deck);
	}
}

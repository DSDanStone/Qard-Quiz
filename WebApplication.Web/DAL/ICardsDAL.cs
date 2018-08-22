using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApplication.Web.Models.FlashCards;

namespace WebApplication.Web.DAL
{
	public interface ICardsDAL
	{
		/// <summary>
		/// Adds a card to the database
		/// </summary>
		/// <param name="card">The card to add to the database</param>
		/// <returns>The same card with its new Id filed in</returns>
		CardModel CreateCard(CardModel card);

		/// <summary>
		/// Gets a card by its ID
		/// </summary>
		/// <param name="cardId">The ID of the card to retrieve</param>
		/// <returns>The card with the specified ID</returns>
		CardModel GetCard(int id);

		/// <summary>
		/// Gets all the cards in a specified deck
		/// </summary>
		/// <param name="deckId">The id of the Deck to get cards from</param>
		/// <returns>A list of cards in the deck</returns>
		IList<CardModel> GetCardsInDeck(DeckModel deck);

		/// <summary>
		/// Gets all cards that have the specified keyword
		/// </summary>
		/// <param name="keyword">The keyword to search for</param>
		/// <returns>A list of cards with the keyword</returns>
		IList<CardModel> GetCardsByKeyword(string keyword);

		/// <summary>
		/// Deletes a card from the database
		/// </summary>
		/// <param name="card">The card to be deleted</param>
		void DeleteCard(CardModel card);
		
		/// <summary>
		/// Updates the front and back of a card as well as its keywords
		/// </summary>
		/// <param name="card"></param>
		void UpdateCard(CardModel card);

		/// <summary>
		/// Assigns a card to a deck
		/// </summary>
		/// <param name="card">The card to assign (the deck id property must be filled in)</param>
		void AssignCardToDeck(CardModel card);

		/// <summary>
		/// Removes a card from a deck
		/// </summary>
		/// <param name="card">The card to assign (the deck id property must be filled in)</param>
		void RemoveCardFromDeck(CardModel card);

		/// <summary>
		/// Gets all the cards not in a specified deck
		/// </summary>
		/// <returns>A list of cards not in any deck</returns>
		IList<CardModel> GetCardsInNoDeck();
	}
}

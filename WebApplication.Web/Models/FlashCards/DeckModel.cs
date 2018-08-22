using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace WebApplication.Web.Models.FlashCards
{
	public class DeckModel
	{
		/// <summary>
		/// Represents the deck's id in the database
		/// </summary>
		public int id { get; set; }

		[Required]
		[StringLength(50, ErrorMessage = "Get a shorter name")]
		/// <summary>
		/// Represents the deck's name
		/// </summary>
		public string name { get; set; }

		[StringLength(300, ErrorMessage = "Get to the point")]
		/// <summary>
		/// Represents the deck's description
		/// </summary>
		public string description { get; set; }

		/// <summary>
		/// Represents whether the deck is viewable publicly
		/// </summary>
		public bool isPublic { get; set; }

		/// <summary>
		/// Represents the cards contained in the deck
		/// </summary>
		public IList<CardModel> cards { get; set; }
	}
}

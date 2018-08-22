using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace WebApplication.Web.Models.FlashCards
{
    public class CardModel
    {
        /// <summary>
        /// Represents the card's id in the database
        /// </summary>
        public int id { get; set; }

        /// <summary>
        /// Represents the user the card belongs to
        /// </summary>

        public int userId { get; set; }

        /// <summary>
        /// Represents the text on the front of the card
        /// </summary>
        [Required]
        public string front { get; set; }

        /// <summary>
        /// Represents the text on the back of the card
        /// </summary>
        [Required]
        public string back { get; set; }

        /// <summary>
        /// Represents the keywords associated with the card
        /// </summary>
        public string keywords { get; set; }

        /// <summary>
        /// Represents the a deck the card is associated with
        /// </summary>
        public int deckId { get; set; }

        /// <summary>
        /// Represents the name of the deck associated with the card
        /// </summary>
        public string name { get; set; }

        /// <summary>
        /// Represents the description of the deck associated with the card
        /// </summary>
        public string description { get; set; }

    }
}
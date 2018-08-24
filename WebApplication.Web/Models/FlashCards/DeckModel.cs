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


        /// <summary>
        /// Represents the deck's name
        /// </summary>
        [Required]
        [StringLength(50, ErrorMessage = "Get a shorter name")]
        public string name { get; set; }


        /// <summary>
        /// Represents the deck's description
        /// </summary>
        [Required]
        [StringLength(300, ErrorMessage = "Get to the point")]
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

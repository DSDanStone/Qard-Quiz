using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using WebApplication.Web.Models;
using WebApplication.Web.Providers.Auth;
using WebApplication.Web.Models.FlashCards;
using WebApplication.Web.DAL;
using System.Dynamic;

namespace WebApplication.Web.Controllers
{
    public class HomeController : Controller
    {
        private readonly IAuthProvider authProvider;
        private readonly IDecksDAL decksDAL;
        private readonly ICardsDAL cardsDAL;


        public HomeController(IAuthProvider authProvider, IDecksDAL decksDAL, ICardsDAL cardsDAL)
        {
            this.authProvider = authProvider;
            this.decksDAL = decksDAL;
            this.cardsDAL = cardsDAL;
        }

        public IActionResult Index()
        {
            User user = authProvider.GetCurrentUser();

            if (user == null)
            {
                return View();
            }

            return RedirectToAction("ViewDecks");
        }

        [HttpGet]
        [AuthorizationFilter]
        [Route("Home/MakeCard/{deckId}")]
        public IActionResult MakeCard(int deckId)
        {
            CardModel card = new CardModel();
            card.deckId = deckId;
            return View(card);
        }

        [HttpGet]
        [AuthorizationFilter]
        [Route("Home/MakeCard/{deckId}/{cardId}")]
        public IActionResult MakeCard(int deckId, int cardId)
        {
            CardModel card = new CardModel();
            if (cardId != 0)
            {
                card = cardsDAL.GetCard(cardId);
            }
            card.deckId = deckId;
            return View(card);
        }

        [HttpPost]
        [AuthorizationFilter]
        [Route("Home/MakeCard/{deckId}/{cardId}")]
        public IActionResult MakeCard(CardModel card, int deckId, int cardId)
        {
            User user = authProvider.GetCurrentUser();
            if (ModelState.IsValid && decksDAL.VerifyDeckByUser(user, new DeckModel() { id = deckId }))
            {
                ModelState.Clear();
                card.userId = user.Id;
                card.deckId = deckId;

                if (card.id == 0)
                {
                    cardsDAL.CreateCard(card);
                    cardsDAL.AssignCardToDeck(card);
                }
                else
                {
                    cardsDAL.UpdateCard(card);
                    return RedirectToAction("ViewCards", new { id = deckId });
                }
            }
            else
            {
                return RedirectToAction("index");
            }

            return View(new CardModel() { deckId = deckId, userId = user.Id });
        }

        [HttpGet]
        [AuthorizationFilter]
        public IActionResult ViewDecks(string keywords)
        {
            User user = authProvider.GetCurrentUser();

            IList<DeckModel> decks = string.IsNullOrEmpty(keywords)
                ? decksDAL.GetDecksByUser(user) : decksDAL.FilterDecks(user, keywords);

            if (decks == null)
            {
                return Error();
            }

            return View(decks);
        }

        [HttpPost]
        [AuthorizationFilter]
        public IActionResult ViewCards(DeckModel deck)
        {
            User user = authProvider.GetCurrentUser();

            if (ModelState.IsValid && decksDAL.VerifyDeckByUser(user, deck))
            {
                decksDAL.UpdateDeck(deck);
                return RedirectToAction("ViewCards", new { deckId = deck.id });
            }

            return View();
        }

        [HttpGet]
        [AuthorizationFilter]
        public IActionResult MakeDeck()
        {
            User user = authProvider.GetCurrentUser();

            if (user == null)
            {
                return RedirectToAction("index");
            }

            return View();
        }

        [HttpPost]
        [AuthorizationFilter]
        public IActionResult MakeDeck(DeckModel deck)
        {
            User user = authProvider.GetCurrentUser();

            if (user == null)
            {
                return RedirectToAction("index");
            }

            if (ModelState.IsValid)
            {
                deck = decksDAL.MakeDeck(user, deck);

                if (decksDAL.VerifyDeckByUser(user, deck))
                {
                    return RedirectToAction("MakeCard", new { deckId = deck.id });
                }
            }

            return View();
        }

        [HttpGet]
        [AuthorizationFilter]
        public IActionResult ViewCards(int id)
        {
            User user = authProvider.GetCurrentUser();

            if (user == null)
            {
                return RedirectToAction("index");
            }

            if (decksDAL.VerifyDeckByUser(user, new DeckModel() { id = id }))
            {
                DeckModel deck = decksDAL.GetDeckById(id);
                deck.cards = cardsDAL.GetCardsInDeck(deck);
                return View(deck);
            }

            return RedirectToAction("index");
        }

        [HttpGet]
        [AuthorizationFilter]
        [Route("Home/StudySession/{id}")]
        public IActionResult StudySession(int id)
        {
            User user = authProvider.GetCurrentUser();

            if (user == null)
            {
                return RedirectToAction("index");
            }

            DeckModel deck = decksDAL.GetDeckById(id);
            deck.cards = cardsDAL.GetCardsInDeck(deck);

            if (decksDAL.VerifyDeckByUser(user, deck))
            {
                return View(deck);
            }

            return RedirectToAction("index");
        }

        [AuthorizationFilter]
        public IActionResult RemoveCardFromDeck(int deckId, int cardId)
        {
            User user = authProvider.GetCurrentUser();

            if (decksDAL.VerifyDeckByUser(user, new DeckModel() { id = deckId }))
            {
                CardModel card = new CardModel() { id = cardId, deckId = deckId };
                cardsDAL.RemoveCardFromDeck(card);
            }

            return RedirectToAction("ViewCards", new { id = deckId });
        }

        
        [AuthorizationFilter]
        public IActionResult DeleteDeck(int deckId)
        {
            User user = authProvider.GetCurrentUser();
            DeckModel deck = decksDAL.GetDeckById(deckId);
            if (decksDAL.VerifyDeckByUser(user, new DeckModel() { id = deckId }))
            {
                decksDAL.DeleteDeck(deck);
            }

            return RedirectToAction("ViewDecks");
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}

$(document).ready(function() {

    // Loads all of the cards to the page
    for (let i = 0; i < flashcards.length; i++) {
        let container = $('.cardscontainer');
        let flashcard = $(`<div class="card"></div>`);
        let cardfront = $(`<div class="front">${flashcards[i].front}</div>`);
        let cardback = $(`<div class="back">${flashcards[i].back}</div>`);

        container.append(flashcard);
        flashcard.append(cardfront);
        flashcard.append(cardback);

    }

});
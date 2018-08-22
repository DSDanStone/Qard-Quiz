
let current_index = 0;
const totalcards = flashcards.length;
let current_progress = 0;
let right_answers = 0;
let quiz_score = 0;
let wrong_answers = [];

$(document).ready(function () {
    let container = $('.studycard');
    let flashcard = $(`<div class="card"></div>`);
    let cardfront = $(`<div class="front">${flashcards[current_index].front}</div>`);
    let cardback = $(`<div class="back">${flashcards[current_index].back}</div>`);

    //Loads the first card to the page
    container.prepend(flashcard);
    flashcard.prepend(cardback);
    flashcard.prepend(cardfront);


    //Marks the answer right, updates the progress bar, and switches the content to the second card
    $("#right").on("click", function () {
        current_progress = Math.round((current_index + 1) / totalcards * 100);
        current_index++;
        right_answers++;
        $("#progbar").css("width", current_progress + "%")
            .attr("aria-valuenow", current_progress);
        document.querySelector("#current-progress").innerText = `${current_progress}%`;
        $(".card").hide(1);

        //Checks to see if you have completed the study session
        if (current_progress >= 100) {
            endStudySession();
        }
        else {
            document.querySelector(".front").innerText = flashcards[current_index].front;
            document.querySelector(".back").innerText = flashcards[current_index].back;
            $(".card").flip(false);
            $(".card").show('fast');
        }


    });

    //Marks the answer wrong, updates the progress bar, and switches the content to the second card
    $("#wrong").on("click", function () {
        current_progress = Math.round((current_index + 1) / totalcards * 100);

        //Adds to the array of incorrect answers
        wrong_answers.push(document.querySelector('.front').innerText + ": " + document.querySelector('.back').innerText);
        current_index++;
        $("#progbar").css("width", current_progress + "%")
            .attr("aria-valuenow", current_progress);
        document.querySelector("#current-progress").innerText = `${current_progress}%`;
        $(".card").hide(1);

        //Checks to see if you have completed the study session
        if (current_progress >= 100) {
            endStudySession();
        }
        else {
            document.querySelector(".front").innerText = flashcards[current_index].front;
            document.querySelector(".back").innerText = flashcards[current_index].back;
            $(".card").flip(false);
            $(".card").show('fast');
        }
    });

});


//Ends the currend study session
function endStudySession() {
    $(".card").hide(1);
    $(".studybuttons").hide(1);

    quiz_score = Math.round(right_answers / totalcards * 100);

    $(".studycard").append(`<div><p>You got ${right_answers} out of ${flashcards.length} correct, and achieved a score of ${quiz_score + "%"}</p></div>`);

    // If you did not score a 100%, keeps track of which questions were answered incorrectly and displays them to the screen
    if (wrong_answers.length >= 0) {
        if (current_index < flashcards.length) {
            for (let i = current_index; i < flashcards.length; i++) {
                wrong_answers.push(flashcards[i].front + ": " + flashcards[i].back);
            }
        }
        $(".studycard").append(`<br />`);
        $(".studycard").append(`<p><u>Cards answered incorrectly</u></p>`);

        for (let i = 0; i < wrong_answers.length; i++) {
            $(".studycard").append(`<p>${wrong_answers[i]}</p>`);
        }
    }
}
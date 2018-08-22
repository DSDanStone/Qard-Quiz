document.addEventListener('DOMContentLoaded', () => {
    document.getElementById('deck-name').addEventListener('click', ShowInputHideName);
    document.getElementById('deck-description').addEventListener('click', ShowInputHideDescription);
});

function ShowInputHideName() {
    document.getElementById('deck-name').style.display = "none";
    const textbox = document.getElementById('name-input');
    textbox.style.display = "inline";
    textbox.focus();
    textbox.select();
    ShowSaveButton();
}

function ShowInputHideDescription() {
    document.getElementById('deck-description').style.display = "none";
    const textbox = document.getElementById('description-input');
    textbox.style.display = "inline";
    textbox.focus();
    textbox.select();
    ShowSaveButton();
}

function ShowSaveButton() {
    document.getElementById('save').style.display = "block";
}
$(document).ready(function () {
    $('textarea[data-limit-rows=true]')
        .on('keypress', function (event) {
            const textarea = $(this);
            const text = textarea.val();
            const Lines = text.split(/\n/g);
            let overFlowLines = 0;
            for (let i = 0; i < Lines.length; i++) {
                if (Lines[i].length >= textarea.attr('col')) {
                    overFlowLines++;
                }
            }
            const numberOfLines = (text.match(/\n/g) || []).length + 1 + overFlowLines;
            const maxRows = parseInt(textarea.attr('rows'));

            if (numberOfLines >= maxRows + 1) {
                return false;
            }
        });
});

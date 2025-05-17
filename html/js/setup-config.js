const allClass = ['yd-default'];
let themeSelector = false;
let justClick = false;

$(document).ready(() => {
    $('body').append(`
        <style type="text/css">
            .fastItems {
                border-radius: ${Config.CornerRoundedRadius};
            }

            .fastItems {
                left: ${Config.FastItemLeftPosition};
                ${Config.FastItemTopPosition.Type}: ${Config.FastItemTopPosition.Value};
                transform: translateY(${Config.FastItemTopPosition.Translate});
            }
        </style>
    `);

    $('#setting-clicker').click(() => {
        $('.theme-selector').fadeIn(200);
        themeSelector = true;
        justClick = true;
        setTimeout(() => {
            justClick = false;
        }, 200);
    });
});
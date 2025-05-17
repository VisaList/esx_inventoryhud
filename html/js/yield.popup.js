function yieldPopupId() {
    givePopup = true;
    $('#popup-id').fadeIn(200);
}

$('#confirm_id').click(function(e) {
    e.preventDefault();

    if($('#give_id_player').val() == '') return;

    let playerId = $('#give_id_player').val();
    targetPlayerId = parseInt(playerId);

    $('#popup-id').fadeOut(200);

    if($('.ydPlayerCount').val() == '') return;

    popupTarget = 'player';

    if(popupTarget === 'player') {
        $.post("https://esx_inventoryhud/GiveItem", JSON.stringify({
            player: parseInt($('#give_id_player').val()),
            item: currentItem,
            number: parseInt($('.ydPlayerCount').val()),
        }));
    } else {
        $.post(`https://esx_inventoryhud/${popupTarget}`, JSON.stringify({
            item: currentItem,
            number: parseInt($('.ydPlayerCount').val()),
        }));
    }
    var sound = new Audio('sounds/select.mp3'); //เสียงเปิดกระเป๋า
    sound.volume  = 0.8 //ระดับเสียงเปิดกระเป๋า
    sound.play(); //ให้เล่นเสียง ถ้าจะปิดให้ใส่ //ไว้ด้านหน้า open.play(); : //open.play();
    $('.popup').fadeOut(200);
    $('.popup2').fadeOut(200);
    $('.yd-count').val('');
    $('#give_id_player').val('');

    givePopup = false;
    
    // yieldPopupCount('player');
});

function yieldPopupCount(targetType) {
    popupTarget = targetType;
    countPopup = true;
    $('#popup-count').fadeIn(200);
}

$('.inputMax').click(function(e) {
    e.preventDefault();
    var sound = new Audio('sounds/select.mp3'); //เสียงเปิดกระเป๋า
    sound.volume  = 0.8 //ระดับเสียงเปิดกระเป๋า
    sound.play(); //ให้เล่นเสียง ถ้าจะปิดให้ใส่ //ไว้ด้านหน้า open.play(); : //open.play();
    $('.yd-count').val(currentItem.count);
});

$('.inputMin').click(function(e) {
    e.preventDefault();
    var sound = new Audio('sounds/select.mp3'); //เสียงเปิดกระเป๋า
    sound.volume  = 0.8 //ระดับเสียงเปิดกระเป๋า
    sound.play(); //ให้เล่นเสียง ถ้าจะปิดให้ใส่ //ไว้ด้านหน้า open.play(); : //open.play();
    $('.yd-count').val(1);
});

$('#confirm_count').click(function(e) {
    e.preventDefault();

    if($('#item-count').val() == '') return;

    if(popupTarget === 'player') {
        $.post("https://esx_inventoryhud/GiveItem", JSON.stringify({
            player: parseInt($('#give_id_player').val()),
            item: currentItem,
            number: parseInt($('#item-count').val()),
        }));
    } else {
        $.post(`https://esx_inventoryhud/${popupTarget}`, JSON.stringify({
            item: currentItem,
            number: parseInt($('#item-count').val()),
        }));
    }
    var sound = new Audio('sounds/select.mp3'); //เสียงเปิดกระเป๋า
    sound.volume  = 0.8 //ระดับเสียงเปิดกระเป๋า
    sound.play(); //ให้เล่นเสียง ถ้าจะปิดให้ใส่ //ไว้ด้านหน้า open.play(); : //open.play();
    $('.popup').fadeOut(200);
    $('.popup2').fadeOut(200);
    $('#item-count').val('');
    $('#give_id_player').val('');

    countPopup = false;
});

$('.ui').click(() => {
    if(givePopup) {
        givePopup = false;
        $('#popup-id').fadeOut(200);
    }

    if(countPopup) {
        countPopup = false
        $('#popup-count').fadeOut(200);
    }

    if(themeSelector && !justClick) {
        themeSelector = false;
        $('.theme-selector').fadeOut(200);
    }
});
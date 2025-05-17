let AllSkins = [];
let CurrentSkin = 0;
let ImagePath = '';

function skinPopupId(itemName) {
    Popupskin = true;
    $('#skin-menuInner').fadeIn(200)

    $.post('https://esx_inventoryhud/UseSkin', JSON.stringify({
        action: "selectmain",
        weaponName: itemName
    }));
    console.log(itemName);
}

function selectskinId(itemName, skinIndex) {
    $.post('https://esx_inventoryhud/UseSkin', JSON.stringify({
        action: "selectskin",
        id: skinIndex,
        weaponName: itemName, // ✅ เปลี่ยนเป็น weaponName ให้ตรงกับฝั่ง Lua
    }));
    var sound = new Audio('sounds/select.mp3'); //เสียงเปิดกระเป๋า
    sound.volume  = 0.8 //ระดับเสียงเปิดกระเป๋า
    sound.play(); //ให้เล่นเสียง ถ้าจะปิดให้ใส่ //ไว้ด้านหน้า open.play(); : //open.play();
    // Popupskin = false;
    // $('#skin-menuInner').fadeOut(200);
    console.log(skinIndex);
    console.log(itemName);
}

window.addEventListener('message', function (event) {
    const data = event.data;
    if (data.action == 'selectmain') {
        AllSkins = data.data;
        CurrentSkin = 0;
        $('.skin-menuInner .list-skin').empty();
        $.each(data.data, function (i, weapon) {
            $('.skin-menuInner .list-skin').append(`
                <div id="skinId-${i}" class="itemskin" onclick="selectskinId('${data.select}', ${i})">
                    <div class="image">
                        <img src="./img/items/${ImagePath}${weapon.IMAGE}.png" alt="">
                    </div>
                    <div class="name-skin">${weapon.SKINNAME}</div>
                </div>
            `);
        });        
    };

    // if (data.action === 'updateSkinIcon') {
    //     const weaponName = data.weapon;
    //     const image = data.image;
        
    //     // ค้นหาอาวุธใน inventory UI และอัปเดตรูปภาพ
    //     $(`.slot[data-item-name="${weaponName}"] .item-image img`).attr("src", `./img/items/${image}.png`);
    // }
    

    // === Hover Sound ===
    $('.itemskin').off('mouseenter').on('mouseenter', function () {
        var hover = new Audio('sounds/hover.mp3'); //เสียงเปิดกระเป๋า
        hover.volume  = 0.8 //ระดับเสียงเปิดกระเป๋า
        hover.play(); //ให้เล่นเสียง ถ้าจะปิดให้ใส่ //ไว้ด้านหน้า open.play(); : //open.play();
    });

});

$('.ui').click(() => {
    if(Popupskin) {
        Popupskin = false;
        $('#skin-menuInner').fadeOut(200);
    }
});
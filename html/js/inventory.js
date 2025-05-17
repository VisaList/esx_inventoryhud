let type = 'normal';
let disabled = false;
let disabledFunction = null;
let targetPlayerId = null;
let popupTarget = null;
let currentItem = {};
let cacheSlot = null;
let maxWeight = 0;
let inventoryType = null;
let defaultCategory = null;

let listCategory = [];

let no_drop = false;

tippy('.switch', {
    content: 'เปิด/ปิด การรับของ',
    placement: 'right'
});

const cache = {
    ui: $('.ui'),
    secondInventory: $('.secondInventory'),
    fastItems: $('.fastItems'),
    playerWeight: $('.player-weight'),
    inventory: $('.inventory'),
    playerInventory: $('#playerInventory'),
    secondContainer: $('#second-inventory')
};

const getSlotItemTemplate = (item, index, count, classAddon = '', id = '') => {
    const overrideImage = (window.itemImageOverrides && window.itemImageOverrides[item.name]) || item.name;
    return `
        <div class="slot category-show ${classAddon} ${defaultCategory} ${typeof item.category !== 'undefined' ? item.category : ''}">
            <div id="${id}" class="item" style="background-image: url('img/items/${overrideImage}.png'); background-size: 3.5vw 3.5vw;">
                <div class="item-count">
                    ${Config.CountIcon}${count}
                </div> 
                <div class="item-name">${item.label}</div>
                <div class="item-weight">${item.weight} KG</div>
            </div>
            <div class="item-name-bg"></div>
        </div>
    `;
};


window.addEventListener('message', function (event) {
    if(event.data.action === 'setup-extended') {
        $('#playerId').html(`ID : ${event.data.playerId}`);

        if(event.data.useWeight) {
            $('.playerWeight').show();
            maxWeight = event.data.maxWeight / Config.OnWeight.DivideMaxWeight;
            inventoryType = 'weight';
            cache.ui.addClass('on-weight');
        } else {
            $('.playerWeight').hide();
            inventoryType = 'limit';
            cache.ui.removeClass('on-weight');
        }

        if(localStorage.getItem('theme') == null) {
            localStorage.setItem('theme', 'yd-default');
        }

        defaultCategory = event.data.categoryDefault;

        let i = 0;
        $('.category').html('');
        Object.keys(event.data.category)
            .sort()
            .forEach((v, i) => {
                let index = v;
                let data = event.data.category[index];

                listCategory.push(index);

                let template = `
                    <span class="category-item ${i == 0 ? 'active' : ''}" data-target=".${index}">
                        ${event.data.categoryDisplay.Icon ? data.Icon : ''}
                        ${event.data.categoryDisplay.Label ? data.Label : ''}
                    </span>
                `;

                $('.category').append(template);

                i++;
            });

        $('.category-item').click(function(e) {
            e.preventDefault();

            let targetElement = $($(this).data('target'));
            let parentElement = $('.category-show');

            parentElement.removeClass('category-show');
            targetElement.addClass('category-show');
            var select = new Audio('sounds/select.mp3'); //เสียงเปิดกระเป๋า
            select.volume  = 0.8 //ระดับเสียงเปิดกระเป๋า
            select.play(); //ให้เล่นเสียง ถ้าจะปิดให้ใส่ //ไว้ด้านหน้า open.play(); : //open.play();

            $('.category-item.active').removeClass('active');
            $(this).addClass('active');
        });

        $('.category-item').mouseover(function(e) {
            e.preventDefault();

            let parentElement = $('.category-show');
            parentElement.addClass('category-highlight');

            var hover = new Audio('sounds/hover.mp3'); //เสียงเปิดกระเป๋า
            hover.volume  = 0.8 //ระดับเสียงเปิดกระเป๋า
            hover.play(); //ให้เล่นเสียง ถ้าจะปิดให้ใส่ //ไว้ด้านหน้า open.play(); : //open.play();

            let targetElement = $($(this).data('target'));
            targetElement.removeClass('category-highlight');
        });

        $('.category-item').mouseout(function(e) {
            e.preventDefault();

            $('.slot').removeClass('category-highlight');
        });

        } else if(event.data.action === 'request-browser-cache') {
            navigator.sendBeacon('https://esx_inventoryhud/GetBrowserCache', JSON.stringify({
                cache: {
                    slot1: localStorage.getItem('cache_slot_1') ? JSON.parse(localStorage.getItem('cache_slot_1')) : false,
                    slot2: localStorage.getItem('cache_slot_2') ? JSON.parse(localStorage.getItem('cache_slot_2')) : false
                }
            }));

            // 👇 ส่งกลับไป Lua ด้วย fetch
            fetch(`https://${GetParentResourceName()}/set-fastslot-cache`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                },
                body: JSON.stringify({
                    slot1: localStorage.getItem('cache_slot_1') ? JSON.parse(localStorage.getItem('cache_slot_1')) : null,
                    slot2: localStorage.getItem('cache_slot_2') ? JSON.parse(localStorage.getItem('cache_slot_2')) : null
                })
            });

            allClass.forEach(className => $('body').removeClass(className));
            $('body').addClass(localStorage.getItem('theme') == null ? 'yd-default' : localStorage.getItem('theme'));
            
        } else if (event.data.action === 'save-cache-to-browser') {
            if (event.data.slot1) {
                localStorage.setItem('cache_slot_1', JSON.stringify(event.data.slot1));
            }
            if (event.data.slot2) {
                localStorage.setItem('cache_slot_2', JSON.stringify(event.data.slot2));
            }
        }

        if (event.data.action === 'loadCache') {
            // ส่ง cache กลับ Lua
            fetch('https://esx_inventoryhud/GetBrowserCache', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    cache: {
                        slot1: JSON.parse(localStorage.getItem('cache_slot_set1') || '[]'),
                        slot2: JSON.parse(localStorage.getItem('cache_slot_set2') || '[]')
                    }
                })
            }).then(() => {
                // อาจส่ง callback หรือ event ต่อไป
            });
        }
    

    if (event.data.action == 'display') {
        type = event.data.type;
        var open = new Audio('sounds/open.mp3'); //เสียงเปิดกระเป๋า

        if (type === 'normal') {
            cache.fastItems.show();
        } else if (
            ['vault', 'property', 'player', 'thief', 'police', 'crate', 'trunk'].includes(type)
        ) {
            secondInventory();
        }

        cache.ui.fadeIn();
        open.volume  = 0.8 //ระดับเสียงเปิดกระเป๋า
		open.play(); //ให้เล่นเสียง ถ้าจะปิดให้ใส่ //ไว้ด้านหน้า open.play(); : //open.play();
    } else if (event.data.action == 'hide') {
        cache.inventory.removeClass('radius');
        $('#item-count').val('');
        $('#give_id_player').val('');
        cache.ui.fadeOut(200, function () {
            $('.item').remove();
        });

        cache.secondContainer.empty();
        $('.header-text-right').html('');
        $('.popup').hide();
        $('.popup2').hide();

        cache.inventory.animate({ left: '50%' });
        cache.secondInventory.animate({ left: '80%' });
        cache.secondInventory.fadeOut();
    } else if (event.data.action == 'setItems') {
        inventorySetup(event.data.itemList, event.data.fastItems);
    } else if (event.data.action == 'setSecondInventoryItems') {
        secondInventorySetup(event.data.itemList);
    } else if (event.data.action == "setInfoText") {
        $('#weight-text-second').html(`${event.data.weight / 1000} / ${event.data.max / 1000} KG`);
        $('#second-yd').css('width', `${(event.data.weight / event.data.max) * 100}%`);

        /*
            if (event.data.plate !== undefined) {
                $('#sInfo').html(event.data.plate);
            }
        */
    } else if (event.data.action === 'updateSkinIcon') {
        if (!window.itemImageOverrides) window.itemImageOverrides = {};
        window.itemImageOverrides[event.data.weapon] = event.data.image;
    
        // 🔁 อัปเดตรูปในทุกช่อง item ที่มีชื่อนั้น (ใน main inventory)
        $(`.item`).each(function () {
            const itemData = $(this).data('item');
            if (itemData && itemData.name === event.data.weapon) {
                $(this).css('background-image', `url('img/items/${event.data.image}.png')`);
            }
        });
    
        // 🔁 อัปเดตรูปใน fastslot ด้วย
        for (let i = 1; i <= Config.FastSlotCount; i++) {
            const fastEl = $(`#itemFast-${i}`);
            const data = fastEl.data('item');
            if (data && data.name === event.data.weapon) {
                fastEl.css('background-image', `url('img/items/${event.data.image}.png')`);
            }
        }
    }
    

    
});

// function saveFastSlotCache(slotId, slotData) {
//     localStorage.setItem(`cache_slot_${slotId}`, JSON.stringify(slotData));
// }

function updateFastSlotCache(slot1, slot2) {
    if (slot1) localStorage.setItem('cache_slot_1', JSON.stringify(slot1));
    if (slot2) localStorage.setItem('cache_slot_2', JSON.stringify(slot2));
}



function secondInventory() {
    cache.inventory.animate({
        left: '31%',
    });
    cache.secondInventory.fadeIn(100);
    cache.secondInventory.animate({
        left: '72%',
    }, 300);
    cache.fastItems.hide();
}


window.addEventListener('message', function (event) {
    const data = event.data;
    
    let hotbarVisible = false;
    let hotbarTimeout = null; // ✅ ตัวแปร timeout แยก

    if (data.action === 'setItemsFast') {
        if (hotbarVisible) return; // ❌ ห้ามกดซ้ำตอนยังแสดง

        hotbarVisible = true;

        clearTimeout(hotbarTimeout); // ✅ เคลียร์ timeout เดิมก่อนเสมอ
        $('.hotbar').stop(true, true).hide(); // ✅ ล้าง animation ค้าง + ซ่อนก่อนเริ่มใหม่

        $('.hotbar').fadeIn(200, function () {
            hotbarTimeout = setTimeout(function () {
                $('.hotbar').fadeOut(300, function () {
                    hotbarVisible = false;
                    hotbarTimeout = null;
                });
            }, 5000); // ✅ ค้างไว้ 5 วิ
        });

        // อัปเดต slot
        refreshFastSlot(data.fastItems);
        refreshFastSlotHotbar(data.fastItems);

        if (data.fastSetId) {
            $('#swapslot-one-hotbar, #swapslot-two-hotbar').removeClass('active');
            $('#swapslot-one-inventory, #swapslot-two-inventory').removeClass('active');

            if (data.fastSetId === 1) {
                $('#swapslot-one-hotbar').addClass('active');
                $('#swapslot-one-inventory').addClass('active');
            } else if (data.fastSetId === 2) {
                $('#swapslot-two-hotbar').addClass('active');
                $('#swapslot-two-inventory').addClass('active');
            }
        }
    }
    

});




function refreshFastSlotHotbar(fastItems) {
    $('#hotbarSlots').html('');

    for (let i = 1; i < Config.FastSlotCount + 1; i++) {
        let apps = `
            <div class="slot slot-items" id="hotbar-slot-${i}">
                <div id="hotbar-item-${i}" class="items">
                    <div class="item-keybinds">${i}</div>
                    <div class="item-counts"></div>
                </div>
            </div>
        `;
        $('#hotbarSlots').append(apps);
    }

    $.each(fastItems, function (index, item) {
        if (!item.name) {
            return; // ถ้าไม่มีชื่อไอเทม (empty slot) ให้ข้ามไป
        }
        const count = setCount(item);
        const el = $(`#hotbar-item-${item.slot}`);
        let imageName = window.itemImageOverrides?.[item.name] || item.name;
        el.css('background-image', `url('img/items/${imageName}.png')`);
        el.html(`
            <div class="item-keybinds">${item.slot}</div>
            <div class="item-counts">${Config.CountIcon}${count}</div>
        `);
    });
}


function refreshFastSlot(fastItems) {
    $('#hotbarSlots').html('');
    let slotsHas = [];
    
    $.each(fastItems, (index, item) => {
        slotsHas.push(item.slot);
    });

    for (let i = 1; i < Config.FastSlotCount + 1; i++) {
        let name = slotsHas.includes(i) ? '<div class="item-names"></div> ' : '';
        let apps = `
            <div class="slot slot-items" id="slot-fast-id-${i}">
                <div id="itemHotbar-${i}" class="item hotbar-fastslot">
                    <div class="item-keybinds">${i}</div>
                    <div class="item-counts"></div>
                    ${name}
                </div>
            </div>
        `;
        $('#hotbarSlots').append(apps);
    }

    Hotbar = [false, false, false, false, false];

    $.each(fastItems, function (index, item) {
        count = setCount(item);
        Hotbar[index] = true;

        let targetItem = $(`#itemFast-${item.slot}`);
        targetItem.css('background-image', `url('img/items/${item.name}.png')`);
        targetItem.html(`
            <div class="item-keybinds">${item.slot}</div> 
            <div class="item-count">
                ${Config.CountIcon}${count}
            </div> 
            <div class="item-name">${item.label}</div>
        `);
        targetItem.data('item', item);
        targetItem.data('slots', index);
        targetItem.data('inventory', 'fast');
        $(`#slot-fast-id-${item.slot}`).addClass('slot-active');
    });
    // ✅ เพิ่มหลังจากอัปเดตเสร็จ
    // updateFastSlotCache(fastSlotSet1, fastSlotSet2);
}




function closeInventory() {
    navigator.sendBeacon('https://esx_inventoryhud/NUIFocusOff', JSON.stringify({}));
    $('.rmenu').fadeOut(200);
    $('.skin-menuInner').fadeOut(200);
}

$('#swapslot-one-inventory').on('click', function () {
    sendSwapFastSlot(1);
    var select = new Audio('sounds/select.mp3'); //เสียงเปิดกระเป๋า
    select.volume  = 0.8 //ระดับเสียงเปิดกระเป๋า
    select.play(); //ให้เล่นเสียง ถ้าจะปิดให้ใส่ //ไว้ด้านหน้า open.play(); : //open.play();
});

$('#swapslot-two-inventory').on('click', function () {
    sendSwapFastSlot(2);
    var select = new Audio('sounds/select.mp3'); //เสียงเปิดกระเป๋า
    select.volume  = 0.8 //ระดับเสียงเปิดกระเป๋า
    select.play(); //ให้เล่นเสียง ถ้าจะปิดให้ใส่ //ไว้ด้านหน้า open.play(); : //open.play();
});

function sendSwapFastSlot() {
    $.post('https://esx_inventoryhud/swapfastslot', JSON.stringify({}));
    console.log('[NUI] Triggered swapfastslot from UI');
}


function inventorySetup(items, fastItems) {
    cacheSlot = fastItems;
    localStorage.setItem('cache_slot', JSON.stringify(fastItems));

    let allWeight = 0;
    let allContainer = $('#all');
    $('.tab-pane').html('');
    let allCount = items.length;

    $.each(items, function (index, item) {
        let count = setCount(item);
        let itemInventory = 'main';
        let rm = [];

        // ตรวจสอบว่ามีคุณสมบัติ usable = ใช้ได้
        if (item.usable && itemInventory !== 'second') {
            rm.push({
                title: '<ion-icon name="cube-outline"></ion-icon>&nbsp;Use',
                func: function () {
                    disableInventory(300);
                    navigator.sendBeacon('https://esx_inventoryhud/UseItem', JSON.stringify({ item: item }));
                }
            });
        }

        // ตรวจสอบว่ามีคุณสมบัติ canRemove = สามารถให้ได้
        if (item.canRemove && itemInventory !== 'second') {
            rm.push({
                title: '<ion-icon name="shuffle-outline"></ion-icon>&nbsp;Give',
                func: function () {
                    disableInventory(300);
                    currentItem = item;
                    yieldPopupId();
                }
            });
        }

        // เมนู Skin เงื่อนไขเดียวกับ Use หรือจะดัดแปลงให้แยกตามชื่อไอเท็มก็ได้
        if (item.skinble && itemInventory !== 'second') {
            rm.push({
                title: '<ion-icon name="cube-outline"></ion-icon>&nbsp;Skin',
                func: function () {
                    disableInventory(300);
                    currentItem = item;
                    skinPopupId(item.name);
                    // console.log(item.name);
                }
            });
        }

        // เมนู Drop เฉพาะกรณีให้ทิ้งได้ และไม่ได้ล็อก drop ทั้งระบบ
        if (item.canRemove && !no_drop && itemInventory !== 'second') {
            rm.push({
                title: "<ion-icon name='trash-bin-outline'></ion-icon>&nbsp;Drop",
                func: function () {
                    disableInventory(300);
                    currentItem = item;
                    yieldPopupCount('DropItem');
                }
            });
        }

        // เตรียม UI ช่องไอเท็ม
        let defaultItem = $(getSlotItemTemplate(item, index, count, 'slot-player', `item-${index}`));

        // แสดงเงิน
        if (item.name === 'money') {
            $('#money').html(item.count.toLocaleString('en-US'));
        }

        // คำนวณน้ำหนักรวมถ้ามี
        if (inventoryType === 'weight') {
            allWeight += typeof item.weight === 'undefined' ? 0 : (item.weight * item.count / Config.OnWeight.DivideWeight);
        }

        // สร้าง rmenu เฉพาะคำสั่งที่ใช้ได้
        $.createRMenu(defaultItem, rm);

        // ใส่ลงหน้าจอ
        $('#all').append(defaultItem);

        // เก็บข้อมูลไอเท็มไว้กับ element
        $(`#item-${index}`).data('item', item).data('inventory', 'main');
    });


    // Update weight bar
    $('#weight-text-player').html(`<ion-icon name="archive-outline"></ion-icon>&nbsp; ${allWeight}/${maxWeight} KG`);
    $('#player-yd').css('width', `${(allWeight / maxWeight) * 100}%`);

    // ==========================
    // ✅ FASTSLOT SYSTEM UPDATE
    // ==========================

    $('#fastslot').html(''); // ล้าง fastslot เดิม
    let slotMap = {}; // เพื่อ map ว่า slot ไหนมีของ

    fastItems.forEach((item, index) => {
        if (item?.slot && item.name) {
            slotMap[item.slot] = item;
        }
    });

    // วาดใหม่ทั้งหมดแบบ clean
    for (let i = 1; i <= Config.FastSlotCount; i++) {
        const item = slotMap[i];
        let imageName = item ? (window.itemImageOverrides?.[item.name] || item.name) : '';
        let html = `
            <div class="slot slot-item" id="slot-fast-id-${i}">
                <div id="itemFast-${i}" class="item inventory-fastslot" style="${item ? `background-image: url('img/items/${imageName}.png')` : ''}">
                    <div class="item-keybinds">${i}</div>
                    <div class="item-count">${item ? `${Config.CountIcon}${setCount(item)}` : ''}</div>
                    <div class="item-name">${item ? item.label : ''}</div>
                </div>
            </div>
        `;
        $('#fastslot').append(html);

        if (item) {
            let $target = $(`#itemFast-${i}`);
            $target.data('item', item);
            $target.data('slots', i);
            $target.data('inventory', 'fast');
            $(`#slot-fast-id-${i}`).addClass('slot-active');
        }
    }

    // === Hover Sound ===
    $('.slot').off('mouseenter').on('mouseenter', function () {
        var hover = new Audio('sounds/hover.mp3'); //เสียงเปิดกระเป๋า
        hover.volume  = 0.8 //ระดับเสียงเปิดกระเป๋า
        hover.play(); //ให้เล่นเสียง ถ้าจะปิดให้ใส่ //ไว้ด้านหน้า open.play(); : //open.play();
    });

    Hotbar = Array(Config.FastSlotCount).fill(false);
    fastItems.forEach((item, index) => {
        if (item.name && item.slot) {
            Hotbar[index] = true;
        }
    });

    makeDraggables();

}
  

function secondInventorySetup(items) {
    cache.secondContainer.html('');
    $.each(items, function (index, item) {
        count = setCount(item);

        /*cache.secondContainer.append(`
            <div class="slot slot-other">
                <div id="itemOther-${index}" class="item" style="background-image: url('img/items/${item.name}.png'); background-size: 60px 60px;">
                    <div class="item-count">${Config.CountIcon} ${count}</div> 
                    <div class="item-name">${item.label}</div>
                    <div class="item-weight">${item.weight} KG</div>
                </div>
                <div class="item-name-bg"></div>
            </div>
        `);*/

        cache.secondContainer.append(getSlotItemTemplate(item, index, count, 'slot-other', `itemOther-${index}`));

        let targetItem = $(`#itemOther-${index}`);
        targetItem.data('item', item);
        targetItem.data('inventory', 'second');
    });
}

function Interval(time) {
    let timer = false;
    this.start = function () {
        if (this.isRunning()) {
            clearInterval(timer);
            timer = false;
        }

        timer = setInterval(function () {
            disabled = false;
        }, time);
    };
    this.stop = function () {
        clearInterval(timer);
        timer = false;
    };
    this.isRunning = function () {
        return timer !== false;
    };
}

function disableInventory(ms) {
    disabled = true;

    if (disabledFunction === null) {
        disabledFunction = new Interval(ms);
        disabledFunction.start();
    } else {
        if (disabledFunction.isRunning()) {
            disabledFunction.stop();
        }

        disabledFunction.start();
    }
}

function setCount(item) {
    if(inventoryType === 'weight') {
        count = typeof item.weight === 'undefined' ? `${item.count.toLocaleString('en-US')} (${(0).toFixed(Config.OnWeight.DecimalCount)} KG)` : `${item.count.toLocaleString('en-US')} (${(item.weight/ Config.OnWeight.DivideWeight).toFixed(Config.OnWeight.DecimalCount)} KG)`;
        return count;
    } else {
        count = item.count.toLocaleString('en-US');

        if (item.limit > 0) {
            count = `${item.count.toLocaleString('en-US')} | ${item.limit.toLocaleString('en-US')}`;
        }

        if (item.type === 'item_weapon') {
            if (count == 0) {
                count = '';
            } else {
                count = `<img src="img/bullet.png" class="ammoIcon">&nbsp;${item.count.toLocaleString('en-US')}`;
            }
        }

        if (item.type === 'item_account' || item.type === 'item_money') {
            count = formatMoney(item.count);
        }

        return count;
    }
}

function formatMoney(n, c, d, t) {
    var c = isNaN((c = Math.abs(c))) ? 2 : c,
        d = d == undefined ? "." : d,
        t = t == undefined ? "," : t,
        s = n < 0 ? "-" : "",
        i = String(parseInt((n = Math.abs(Number(n) || 0).toFixed(c)))),
        j = (j = i.length) > 3 ? j % 3 : 0;

    return (
        s +
        (j ? i.substr(0, j) + t : "") +
        i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t)
    );
}

$(document).ready(function () {
    $('body').on('keyup', function (key) {
        if (Config.CloseKeys.includes(key.which)) {
            let some = false;
            if(themeSelector) {
                $('.theme-selector').fadeOut(200);
                themeSelector = false;
                some = true;
            }

            if(givePopup) {
                $('#popup-id').fadeOut(200);
                givePopup = false;
                some = true;
            }
        
            if(countPopup) {
                $('#popup-count').fadeOut(200);
                countPopup = false;
                some = true;
            }

            if(Popupskin) {
                $('#skin-menuInner').fadeOut(200);
                Popupskin = false;
                some = true;
            }

            if(some) return;

            closeInventory();
        }
    });

    $('#action-changer').change(function(e) {
        navigator.sendBeacon('https://esx_inventoryhud/ChangeAction', JSON.stringify({
            action: this.checked
        }));
    });

    cache.playerInventory.droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data('item');
            itemInventory = ui.draggable.data('inventory');

            currentItem = itemData;
            if (type === 'trunk' && itemInventory === 'second') {
                disableInventory(500);
                yieldPopupCount('TakeFromTrunk');
            } else if (type === 'property' && itemInventory === 'second') {
                disableInventory(500);
                yieldPopupCount('TakeFromProperty');
            } else if (type === 'vault' && itemInventory === 'second') {
                disableInventory(500);
                yieldPopupCount('TakeFromVault');
            } else if (type === 'crate' && itemInventory === 'second') {
                disableInventory(500);
                yieldPopupCount('TakeFromCrate');
            } else if (type === 'player' && itemInventory === 'second') {
                disableInventory(500);
                yieldPopupCount('TakeFromPlayer');
            } else if (type === 'thief' && itemInventory === 'second') {
                disableInventory(500);
                yieldPopupCount('ThiefFromPlayer');
            } else if (type === 'police' && itemInventory === 'second') {
                disableInventory(500);
                yieldPopupCount('TakeFromPolice');
            } else if (type === 'normal' && itemInventory === 'fast') {
                itemSlot = ui.draggable.data('slots');
                Hotbar[itemSlot] = false;
                navigator.sendBeacon('https://esx_inventoryhud/TakeFromFast', JSON.stringify({
                    item: itemData,
                }));
            }
        },
    });

    cache.secondInventory.droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data('item');
            itemInventory = ui.draggable.data('inventory');

            currentItem = itemData

            if (type === 'trunk' && itemInventory === 'main') {
                disableInventory(500);
                yieldPopupCount('PutIntoTrunk');
            } else if (type === 'property' && itemInventory === 'main') {
                disableInventory(500);
                yieldPopupCount('PutIntoProperty');
            } else if (type === 'vault' && itemInventory === 'main') {
                disableInventory(500);
                yieldPopupCount('PutIntoVault');
            } else if (type === 'crate' && itemInventory === 'main') {
                disableInventory(500);
                yieldPopupCount('PutIntoCrate');
            } else if (type === 'player' && itemInventory === 'main') {
                disableInventory(500);
                yieldPopupCount('PutIntoPlayer');
            } else if (type === 'thief' && itemInventory === 'main') {
                disableInventory(500);
                yieldPopupCount('PutIntoThief');
            }
        },
    });
});

/**
 * 
 * @function makeDraggables
 * Modified improve performance by yield code
 */
function makeDraggables() {
    $('.item').draggable({
        appendTo: 'body',
        zIndex: 99999,
        disabled: false,
        drag: function (event, ui) {
            itemData = $(this).data('item');

            // if('usable' in itemData) {
            //     if(typeof itemData.usable !== 'undefined' && $(this).data('inventory') != 'fast') {
            //         if(!itemData.usable) $('.fastItems').addClass('none');
            //     }
            // }

            ui.position.left = ui.position.left + 5;
            ui.position.top = ui.position.top + 5;
        },
        helper: function (e) {
            let original = $(e.target).hasClass('ui-draggable')
                ? $(e.target)
                : $(e.target).closest('.ui-draggable');
            return original.clone().css({
                width: original.width(),
                height: original.height(),
            });
        },
        stop: function () {
            itemData = $(this).data('item');

            $('.fastItems').removeClass('none');

            if (itemData !== undefined && itemData.name !== undefined) {
                $(this).css('background-image', `url('img/items/${itemData.name}.png')`);
            }
        },
    });

    for (let i = 0; i <= Config.FastSlotCount; i++) {
        let currentSlot = i + 1;
        $(`#itemFast-${currentSlot}`).droppable({
            hoverClass: 'hoverControl',
            drop: function (event, ui) {
                itemData = ui.draggable.data('item');
                itemInventory = ui.draggable.data('inventory');
                if (
                    type === 'normal' 
                    && (itemInventory === 'main' || itemInventory === 'fast')
                ) {
                    if(typeof itemData.usable !== 'undefined') {
                        if(itemData.usable) {
                            navigator.sendBeacon('https://esx_inventoryhud/PutIntoFast', JSON.stringify({
                                item: itemData,
                                slot: currentSlot,
                            }));
                        }
                    }
                }
            },
        });
    }
}

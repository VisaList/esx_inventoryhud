let givePopup = false;
let Popupskin = false;
let countPopup = false;
let Config = {};

/**
 * ปุ่มสำหรับปิดหน้าต่าง
 * https://www.toptal.com/developers/keycode
 */
Config.CloseKeys = [24, 84, 27, 90, 113];

/**
 * จำนวนช่อง Fast Slot
 */
Config.FastSlotCount = 7; //แนะนำไม่เกิน 7 slot

/**
 * 
 * Yield Addon
 * 
 */

 Config.OnWeight = {
    /**
     * เมื่อใช้ระบบน้ำหนัก 
     * ถ้าหากกำหนดน้ำหนักต่อไอเทม 1000 ต่อ 1 กิโลกรัม ให้กำหนดเป็น 1000 เพื่อหารให้เป็นหน่วยกิโลกรัม
     * แต่ถ้าหากใช้หน่วย 1 ต่อ 1 ให้กำหนดเป็น 1 เท่าเดิม
     */
    DivideWeight: 1000,

    /**
     * เมื่อใช้ระบบน้ำหนัก 
     * ถ้าหากกำหนดน้ำหนักสูงสุด 1000 ต่อ 1 กิโลกรัม ให้กำหนดเป็น 1000 เพื่อหารให้เป็นหน่วยกิโลกรัม
     * แต่ถ้าหากใช้หน่วย 1 ต่อ 1 ให้กำหนดเป็น 1 เท่าเดิม
     */
    DivideMaxWeight: 1000,

    /**
     * เมื่อใช้ระบบน้ำหนัก 
     * จำนวนหลักของเลขทศนิยมที่จะโชว์น้ำหนัก
     */
    DecimalCount: 0
};

/**
 * ไอคอนข้างหน้าจำนวนไอเทม
 * https://ionic.io/ionicons
 */
Config.CountIcon = '';

/**
 * ขอบมน
 */
Config.CornerRoundedRadius = '0.4vw';

/**
 * ตำแหน่งชิดซ้ายของช่อง Fast Slot
 */
Config.FastItemLeftPosition = '-10vw';

Config.FastItemTopPosition = {
    // อยู่กลางจอ
    // Type: 'top',
    // Value: '50%',
    // Translate: '-50%'

    // ให้อยู่บนสุด
    Type: 'top',
    // Value: '0',
    // Translate: '0'

    // อยู่ล่างสุด
    Type: 'bottom',
    Value: '0',
    Translate: '0'
}
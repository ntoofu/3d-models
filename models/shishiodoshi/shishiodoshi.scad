// ====================================================================
// Shishiodoshi (鹿威し) PET Bottle Symmetric Twin-Spine Mount (v11.1)
// ネック相欠き突起の干渉修正版:
//  - v11からの変更点:
//    相欠き(ラップジョイント)の受け側底面(hull上面)が Z = 35.5mm なのに対し、
//    突起先端が Z = 50.3mm (反転時 Z = 33.7mm) まで伸びて約1.8mm底突き干渉していた問題を修正。
//    突起先端を Z = 48.3mm (中心+6.3mm) に短縮し、反転組み付け時に 0.2mm クリアランスで
//    ぴったり噛み合うように修正。
// ====================================================================

$fn = 64;

// --- 基本寸法パラメータ ---
bottle_max_d      = 74.0;    // 最大対応ボトル径 (mm)
bottle_min_d      = 62.0;    // 最小対応ボトル径 (mm)
neck_d            = 28.5;    // ボトル首径 (mm)
flange_d          = 34.5;    // ネックリング外径 (mm)
flange_w          = 2.8;     // ネックリング溝幅 (mm)

// 1. 対称メインプレート（2個共通仕様）
plate_len         = 100.0;   // 板の全長（ボトル軸方向 X） (mm)
plate_w           = 30.0;    // 板の幅（Y方向） (mm)
plate_t           = 4.5;     // 板の基本厚み (mm)
boss_t            = 9.0;     // アーチネジ穴用サイドボスの高さ (mm)
boss_start_x      = 57.0;    // ボス開始X位置 (mm)
boss_len          = 16.0;    // ボスX方向長さ (mm) (X=57〜73mm)
boss_slope_len    = 4.0;     // 4.5mm -> 9.0mm への前後スロープ長 (mm)
boss_inner_y      = 9.0;     // 中央の逃げ幅: |Y| < 9.0mm は厚み4.5mmを維持 (mm)

// ボトル中心軸の高さ: 最大半径37mm + クリアランス0.5mm + 板厚4.5mm = 42.0mm
neck_center_z     = (bottle_max_d / 2) + 0.5 + plate_t; // 42.0 mm
neck_len          = 9.0;     // ネック固定部の厚み (mm)
flange_offset_x   = 3.1;     // キャップ側クリアランス3.1mm + 溝2.8mm + 胴側3.1mm = 9.0mm
neck_w            = 54.0;    // ネックブロック全体の幅 (mm)

// 面取り（Chamfer）量
chamfer           = 0.8;     // 0.8mm C面取り

// 切り欠き（相欠きラップジョイント）寸法
lap_y_inner       = 19.0;    // 切り欠き開始Y位置
lap_y_outer       = neck_w / 2; // 27.0mm
lap_y_mid         = (lap_y_inner + lap_y_outer) / 2; // 23.0mm
lap_z_half        = 8.5;     // ボトル中心(Z=42.0)からの土台基準オフセット
lap_base_z        = neck_center_z - lap_z_half + 2.0; // 相欠き受け側底面(hull上面) = 35.5mm
lap_tip_h         = (neck_center_z - lap_base_z) * 2 - 0.2; // 突起高さ = 12.8mm (先端 Z=48.3mm)

// 2. 支点穴（板の垂直方向＝Z貫通穴、ボトル軸と完全直交・共面）
pivot_hole_d      = 4.3;     // M4通し穴径 (mm)
pivot_nut_d       = 8.1;     // M4六角ナット対角径 (mm)
pivot_nut_depth   = 2.0;     // ナット座ぐり深さ (mm)
pivot_start_x     = 40.0;    // 支点穴開始X位置 (mm)
pivot_pitch       = 10.0;    // 支点穴ピッチ (mm)
pivot_count       = 6;       // 支点穴の数 (40, 50, 60, 70, 80, 90 mm)

// 3. アーチ固定用 水平下穴（非貫通の止まり穴）
arch_pos_x        = 65.0;    // アーチ取り付け中心X位置 (支点穴X=60とX=70の中間) (mm)
tap_pilot_d       = 3.2;     // タッピングビス下穴径 (mm)
tap_depth         = 7.0;     // 非貫通の止まり穴深さ (mm) (Y=±15から内側へ7mm入る、内端Y=±8mm)
tap_clearance_d   = 4.2;     // バカ穴径 (mm)

// 4. 左右挟み込みアーチ寸法（スリム・軽量化版）
arch_thick        = 12.0;    // 前後幅 (mm)
arch_wall_t       = 4.5;     // アーチの肉厚 (mm)

// 出力モード: "spine_plate", "arch", "assembled"
part = "spine_plate";

// --- ヘルパーモジュール: 直方体外周のみ面取り ---
module chamfer_box(lx, y0, y1, h, c = chamfer, top_chamfer = true) {
    wy = y1 - y0;
    top_c = top_chamfer ? c : 0;
    translate([0, y0, 0])
    hull() {
        translate([c, c, 0])
            cube([max(0.1, lx - 2*c), max(0.1, wy - 2*c), h]);
        translate([0, c, c])
            cube([lx, max(0.1, wy - 2*c), max(0.1, h - c - top_c)]);
        translate([c, 0, c])
            cube([max(0.1, lx - 2*c), wy, max(0.1, h - c - top_c)]);
    }
}

// ティアドロップ横穴モジュール
module teardrop_y(d, len) {
    r = d / 2;
    rotate([90, 0, 0])
    linear_extrude(height = len, center = true) {
        circle(r = r);
        polygon(points = [
            [-r * cos(45), r * sin(45)],
            [0, r * 1.35],
            [r * cos(45), r * sin(45)]
        ]);
    }
}

// ----------------------------------------------------
// パーツ1: ネックプレート（v11.1: 全長100mm ＋ サイドボス構造 ＋ 相欠き干渉修正）
// ----------------------------------------------------
module spine_plate() {
    difference() {
        union() {
            // A1. メインの板状アーム（厚み 4.5mm、全長 100mm、外周C0.8面取り）
            chamfer_box(plate_len, -plate_w / 2, plate_w / 2, plate_t, chamfer, true);

            // A2. 左右サイドのアーチネジ穴用ボス (+Y側: Y=9.0〜15.0mm, -Y側: Y=-15.0〜-9.0mm)
            for (sy = [-1, 1]) {
                y_min = sy > 0 ? boss_inner_y : -plate_w / 2;
                y_max = sy > 0 ? plate_w / 2 : -boss_inner_y;
                hull() {
                    translate([boss_start_x - boss_slope_len, y_min, 0])
                        cube([boss_len + 2 * boss_slope_len, y_max - y_min, plate_t]);
                    translate([boss_start_x, y_min, 0])
                        cube([boss_len, y_max - y_min, boss_t]);
                }
            }

            // B. 下駄付きネック半月ブロック（厚み9.0mm、合わせ面Z=neck_center_zはフラット）
            chamfer_box(neck_len, -lap_y_inner, lap_y_inner, neck_center_z, chamfer, false);

            // C. 両サイドの相欠き（ハーフ・ラップ）連結ブロック
            // (1) +Y側（右耳）
            hull() {
                translate([0, plate_w / 2 - 2, 0])
                    cube([neck_len, 2, 18]);
                translate([0, lap_y_inner, neck_center_z - lap_z_half])
                    cube([neck_len, lap_y_outer - lap_y_inner, 2]);
            }
            translate([0, lap_y_mid + 0.15, lap_base_z])
                cube([neck_len, (lap_y_outer - lap_y_mid) - 0.15, lap_tip_h]);

            // (2) -Y側（左耳）
            hull() {
                translate([0, -plate_w / 2, 0])
                    cube([neck_len, 2, 18]);
                translate([0, -lap_y_outer, neck_center_z - lap_z_half])
                    cube([neck_len, lap_y_outer - lap_y_inner, 2]);
            }
            translate([0, -lap_y_mid + 0.15, lap_base_z])
                cube([neck_len, (lap_y_mid - lap_y_inner) - 0.15, lap_tip_h]);

            // D. 下駄背面の補強ガセット
            hull() {
                translate([0, -plate_w / 2 + chamfer, plate_t])
                    cube([neck_len, plate_w - 2 * chamfer, neck_center_z - (neck_d / 2) - 2 - plate_t]);
                translate([neck_len + 10, -plate_w / 2 + chamfer, plate_t - 0.1])
                    cube([2, plate_w - 2 * chamfer, 0.1]);
            }
        }

        // --- くり抜き・穴あけ ---
        // 1. ボトル首の半円溝 (直径 28.5mm)
        translate([-1, 0, neck_center_z])
            rotate([0, 90, 0])
            cylinder(d = neck_d, h = neck_len + 2);

        // 2. ネックリング（フランジ）嵌合溝 (直径 34.5mm, 幅 2.8mm)
        translate([flange_offset_x, 0, neck_center_z])
            rotate([0, 90, 0])
            cylinder(d = flange_d, h = flange_w);

        // 3. ネック左右のタッピングビス穴（Y軸貫通、Z=42.0）
        translate([neck_len / 2, lap_y_mid + 2, neck_center_z])
            teardrop_y(d = tap_clearance_d, len = 12);

        translate([neck_len / 2, -lap_y_mid + 2, neck_center_z])
            teardrop_y(d = tap_pilot_d, len = 12);

        // 4. 下駄中央の肉抜きトンネル
        translate([-1, 0, plate_t])
            rotate([0, 90, 0])
            linear_extrude(height = neck_len + 15) {
                polygon(points = [
                    [0, -9],
                    [-10, -9],
                    [-19, 0],
                    [-10, 9],
                    [0, 9]
                ]);
            }

        // 5. 支点調整穴（Z軸貫通穴 × 6箇所 ＋ 六角ナット座ぐり）
        for (i = [0 : pivot_count - 1]) {
            px = pivot_start_x + (i * pivot_pitch);
            translate([px, 0, -1])
                cylinder(d = pivot_hole_d, h = plate_t + 2);
            translate([px, 0, plate_t - pivot_nut_depth])
                rotate([0, 0, 30])
                cylinder(d = pivot_nut_d, h = pivot_nut_depth + 1, $fn = 6);
        }

        // 6. アーチ固定用 タッピングビス下穴（非貫通の止まり穴・左右各1箇所）
        translate([arch_pos_x, plate_w / 2 - tap_depth / 2 + 0.1, boss_t / 2])
            teardrop_y(d = tap_pilot_d, len = tap_depth + 0.2);
        translate([arch_pos_x, -(plate_w / 2 - tap_depth / 2 + 0.1), boss_t / 2])
            teardrop_y(d = tap_pilot_d, len = tap_depth + 0.2);
    }
}

// ----------------------------------------------------
// パーツ2: 胴体挟み込みアーチ（v11.3: 浅型V溝・2点支持・ネジ頭干渉回避版）
// ----------------------------------------------------
module symmetric_arch() {
    v_ang        = 30;                         // V溝片側角度（挟み角 120°）
    r_v          = bottle_min_d / 2;           // 31.0mm（最小径62mm基準）
    tab_x_in     = plate_w / 2;                // 15.0mm
    tab_x_out    = tab_x_in + arch_wall_t + 1; // 20.5mm
    pad_z_in     = neck_center_z - boss_t;     // 33.0mm
    pad_z_out    = neck_center_z;              // 42.0mm
    pad_mid_z    = neck_center_z - (boss_t / 2); // 37.5mm
    head_clear_y = pad_mid_z - 5.5;            // 32.0mm（M4ネジ頭φ11mm相当の逃げ）
    y_taper      = head_clear_y - 4.0;         // 28.0mm

    x_in_0      = r_v / cos(v_ang);
    x_out_0     = (r_v + arch_wall_t) / cos(v_ang);
    x_in_pad    = (r_v - pad_z_in * sin(v_ang)) / cos(v_ang);
    x_out_taper = (r_v + arch_wall_t - y_taper * sin(v_ang)) / cos(v_ang);

    translate([0, 0, arch_thick / 2])
    difference() {
        linear_extrude(height = arch_thick, center = true) {
            offset(r = chamfer) offset(delta = -chamfer)
            polygon(points = [
                [tab_x_in,    -pad_z_out],
                [tab_x_out,   -pad_z_out],
                [tab_x_out,   -head_clear_y],
                [x_out_taper, -y_taper],
                [x_out_0,      0],
                [x_out_taper,  y_taper],
                [tab_x_out,    head_clear_y],
                [tab_x_out,    pad_z_out],
                [tab_x_in,     pad_z_out],
                [tab_x_in,     pad_z_in],
                [x_in_pad,     pad_z_in],
                [x_in_0,       0],
                [x_in_pad,    -pad_z_in],
                [tab_x_in,    -pad_z_in]
            ]);
        }
        // 固定用タッピングビス穴: 前後幅12mmの中央（dz=0）に1箇所のみ配置
        translate([plate_w / 2 + 3, pad_mid_z, 0])
            rotate([0, 0, -90])
            teardrop_y(d = tap_clearance_d, len = 20);

        translate([plate_w / 2 + 3, -pad_mid_z, 0])
            rotate([0, 0, -90])
            teardrop_y(d = tap_clearance_d, len = 20);
    }
}

if (part == "spine_plate") {
    spine_plate();
} else if (part == "arch") {
    translate([-28, 0, 0])
        symmetric_arch();
} else if (part == "assembled") {
    spine_plate();
    translate([0, 0, neck_center_z * 2])
        rotate([180, 0, 0])
        spine_plate();
    translate([arch_pos_x + arch_thick / 2, 0, neck_center_z])
        rotate([90, 0, -90])
        symmetric_arch();
    translate([arch_pos_x - arch_thick / 2, 0, neck_center_z])
        rotate([90, 0, 90])
        symmetric_arch();
}

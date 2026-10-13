/*
 * Voronoi Roller End Cap (ボロノイ肉抜き 円柱キャップ / コロ仕様)
 * 
 * - 完全自律型 OpenSCAD 実装 (Python等の外部ビルド依存なし):
 *     1. シード点生成: Mitchell's Best-Candidate 法 (ポアソンディスク分布生成)
 *     2. ボロノイ分割: 2D 垂直二等分線半平面クリッピング (Half-space bisection)
 *     3. 梁幅・フィレット: OpenSCAD ネイティブ offset() 機構による均一梁 & 角丸め
 *     4. 一体成形スリーブ: 2D 断面プロファイルの rotate_extrude() による
 *        壁立ち上がり内隅フィレット (R 2.0 mm) & 挿入用リードイン面取り
 * 
 * - 主要寸法:
 *     内径 (`fit_id`): 148.0 mm
 *     スリーブ肉厚 (`sleeve_t`): 2.0 mm (外径: 152.0 mm)
 *     端面板厚 (`plate_t`): 3.0 mm
 *     全体高さ (`total_h`): 24.0 mm (スリーブ深さ: 21.0 mm)
 *     立ち上がりフィレット (`fillet_r`): 2.0 mm (応力集中緩和)
 */

$fn = 64;
_ = 0.05;
huge = 350;

// --- Dimensions (mm) ---
fit_id          = 148.0;  // 円柱嵌合内径 (ユーザー指定: 148.0 mm)
sleeve_t        = 2.0;    // スリーブ円筒肉厚 (ユーザー指定: 2.0 mm)
disk_od         = fit_id + 2 * sleeve_t; // 外径: 152.0 mm
plate_t         = 3.0;    // 端面板厚 (ユーザー指定: 3.0 mm)
total_h         = 24.0;   // 全体高さ (スリーブ深さ: 21.0 mm)

fillet_r        = 2.0;    // 壁立ち上がり内隅フィレット (応力集中緩和)
stop_rim_w      = 3.5;    // 円柱端面ストッパー受座幅
pocket_r        = fit_id / 2 - stop_rim_w; // ボロノイ肉抜き領域半径 (70.5 mm)

chamfer_size    = 1.0;    // 外周エッジ面取り
lead_in_chamfer = 1.0;    // スリーブ開口部リードイン面取り

// ボロノイ梁仕様
num_cells       = 70;     // セル数
strut_w         = 2.2;    // 均一梁幅 (mm)
corner_r        = 0.8;    // セルコーナーフィレット (mm)
seed_val        = 42;     // 再現用乱数シード

// =========================================================================
// 1. 純粋 OpenSCAD ポアソンディスクサンプリング (Mitchell's Best-Candidate)
// =========================================================================
function dist(p1, p2) = norm(p1 - p2);

function min_dist_to_points(pt, pts, idx = 0, cur_min = 1e9) =
    idx >= len(pts) ? cur_min :
    min_dist_to_points(pt, pts, idx + 1, min(cur_min, dist(pt, pts[idx])));

function generate_candidates(k, R, rands_x, rands_y, base_idx) =
    [for (i = [0 : k - 1])
        let(
            r = R * sqrt(rands_x[base_idx + i]),
            th = 360 * rands_y[base_idx + i]
        )
        [r * cos(th), r * sin(th)]
    ];

function best_candidate(candidates, existing_pts) =
    let(
        dists = [for (c = candidates) min_dist_to_points(c, existing_pts)],
        best_i = max_idx(dists)
    )
    candidates[best_i];

function max_idx(arr, i = 0, best_i = 0, max_val = -1e9) =
    i >= len(arr) ? best_i :
    arr[i] > max_val ? max_idx(arr, i + 1, i, arr[i]) :
                       max_idx(arr, i + 1, best_i, max_val);

function generate_poisson_points(n, k, R, rx, ry, pts = [[0, 0]], step = 1) =
    step >= n ? pts :
    let(
        cands = generate_candidates(k, R, rx, ry, step * k),
        next_pt = best_candidate(cands, pts)
    )
    generate_poisson_points(n, k, R, rx, ry, concat(pts, [next_pt]), step + 1);

// =========================================================================
// 2. 2D 垂直二等分線クリッピングによるボロノイセル生成
// =========================================================================
module half_plane_cut(p1, p2) {
    m = (p1 + p2) / 2;
    v = p2 - p1;
    ang = atan2(v[1], v[0]);
    translate(m)
        rotate(ang)
            translate([0, -huge/2])
                square([huge, huge]);
}

module voronoi_cell(pts, i, R, strut_w, fillet_r) {
    p1 = pts[i];
    offset(r = fillet_r)
    offset(r = -fillet_r - strut_w/2)
    difference() {
        circle(r = R, $fn = 32);
        for (j = [0 : len(pts) - 1]) {
            if (i != j) {
                half_plane_cut(p1, pts[j]);
            }
        }
    }
}

module voronoi_cutout_holes(pts, R, strut_w, fillet_r) {
    for (i = [0 : len(pts) - 1]) {
        voronoi_cell(pts, i, R, strut_w, fillet_r);
    }
}

// =========================================================================
// 3. 一体成形スリーブ・内隅フィレット回転押し出しプロファイル
// =========================================================================
module solid_shell() {
    r_out = disk_od / 2; // 76.0 mm
    r_in  = fit_id / 2;  // 74.0 mm
    
    // 内隅フィレット円弧 (内壁から底面ストッパー座へ滑らかに接続)
    n_steps = 16;
    fillet_pts = [
        for (i = [0 : n_steps])
            let(th = -90 * i / n_steps)
            [(r_in - fillet_r) + fillet_r * cos(th), (plate_t + fillet_r) + fillet_r * sin(th)]
    ];

    profile_pts = concat(
        [[0, 0],
         [r_out - chamfer_size, 0],
         [r_out, chamfer_size],
         [r_out, total_h - chamfer_size],
         [r_out - chamfer_size, total_h],
         [r_in + lead_in_chamfer, total_h],
         [r_in, total_h - lead_in_chamfer]],
        fillet_pts,
        [[0, plate_t]]
    );

    rotate_extrude(convexity = 10, $fn = 128)
        polygon(points = profile_pts);
}

// =========================================================================
// 4. メインモデル
// =========================================================================
module roller_cap() {
    // OpenSCAD 内で直接乱数とポアソン分布シード点を生成
    rx = rands(0, 1, num_cells * 10, seed_val);
    ry = rands(0, 1, num_cells * 10, seed_val + 100);
    sample_pts = generate_poisson_points(num_cells, 8, pocket_r, rx, ry);

    difference() {
        solid_shell();

        // 端面板を貫通するボロノイ穴を差分
        translate([0, 0, -_])
            linear_extrude(height = plate_t + 2*_, convexity = 10)
                voronoi_cutout_holes(sample_pts, pocket_r, strut_w, corner_r);
    }
}

roller_cap();

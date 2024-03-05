// created by IndiePandaaaaa

TOLERANCE = .15;
THICKNESS = 2.5;
$fn = 75;


// DONGLE
DONGLE_CASE = false;

// CASE
KEYBOARD_CASE = true;
SWITCH_PLATE = false;

// CASE ADDONS
WRIST_REST = true;
LAPTOP_STANDOFFS = true;


BATTERY_SIZE = [40.8, 29, 4.7];  // Battery 600mAh (Jauch LP503040JH)

CASE = [
  [17.9, 65.4],
  [56.3, 65.4],
  [67.0, 80.2],
  [104.6, 85.2],
  [121.1, 94.8],
  [135.9, 69.2],
  [135.9, 7.2],
  [115.4, 7.2],
  [115.4, 4.9],
  [96.4, 4.9],
  [96.4, 2.4],
  [77.3, 2.4],
  [77.3, 0.1],
  [56.8, 0.1],
  [56.8, 2.4],
  [37.8, 2.4],
  [37.8, 7.1],
  [17.8, 7.1],
  [17.8, 16.9],
  [0.1, 16.9],
  [0.1, 56.4],
  [17.9, 56.4],
];

PCB_SIZE = [133.8, 92.6];
CASE_SIZE = [136, 95];

module mounting_holes(thickness, diameter = 4.7, screws = false) {
  // M3 = 1.7, M4 = 2.3
  cone_height_m3 = 1.7;
  cone_height_m4 = 2.3;

  MOUNTING_HOLES = [
    [18.9, 26.3],
    [18.9, 45.3],
    [62.0, 62.5],
    [94.9, 22.8],
    [108.6, 70.1],
  ];

  translate([PCB_SIZE[0], PCB_SIZE[1], 0]) mirror([0, 1, 0]) mirror([1, 0, 0]) union() {
    for (i = MOUNTING_HOLES) {
      if (screws)
        translate([i[0], i[1], 0]) {
          if (diameter == 3)
            translate([0, 0, thickness - cone_height_m3])
              cylinder(d1 = diameter, d2 = diameter * 2 + 0.4, h = cone_height_m3);
          if (diameter == 4)
            translate([0, 0, thickness - cone_height_m4])
              cylinder(d1 = diameter, d2 = diameter * 2 + 0.4, h = cone_height_m4);
        }

      translate([i[0], i[1], 0]) cylinder(d = diameter, h = thickness);
    }
  }
}

module dongle_case(thickness = 2, tolerance = .2) {
  adapter_width = 14.5; // Adafruit P5329
  adapter_length = 14.5;
  adapter_height = 7.2;
  
  controller_width = 17.8; // Seeed XIAO BLE
  controller_length = 21.0;

  connector_wall_thickness = 1;
  connector_offset = 1.2;
  connector_width = 11.4;
 
  distance_length = 4.4;
  distance_width = 10;

  top_tolerance = .1;

  total_length = connector_wall_thickness + adapter_length + distance_length + controller_length + thickness * 2 + tolerance * 4;
  total_width = (thickness + tolerance) * 2 + controller_width;
  total_height = (thickness + tolerance) * 2 + adapter_height;

  inner_height = total_height - thickness - top_tolerance;
  connector_wall_width = (total_width - connector_width) / 2 - tolerance;
  adapter_wall_width = (total_width - adapter_width) / 2 - tolerance;
  
  union() {
    // bottom
    cube([total_width, total_length, thickness]);
    cube([total_width, connector_wall_thickness, thickness + connector_offset]); 
    translate([0, total_length - controller_length, 0]) cube([total_width, controller_width, thickness + connector_offset]);

    // walls
    cube([thickness, total_length, total_height]);
    translate([total_width - thickness, 0, 0]) cube([thickness, total_length, total_height]);
    translate([0, total_length - thickness, 0]) cube([total_width, thickness, total_height]);
    translate([0, total_length - thickness * 2, 0]) cube([total_width, thickness, inner_height]);
    cube([adapter_wall_width, connector_wall_thickness + adapter_length, inner_height]);
    translate([total_width - adapter_wall_width, 0, 0])
      cube([adapter_wall_width, connector_wall_thickness + adapter_length, inner_height]); 
    cube([connector_wall_width, connector_wall_thickness, total_height]);
    translate([total_width - connector_wall_width, 0, 0])
      cube([adapter_wall_width, connector_wall_thickness, total_height]);
  }

  difference() {
    union() {
      top_length = total_length - thickness - connector_wall_thickness - top_tolerance * 2;
      translate([thickness + top_tolerance, connector_wall_thickness + top_tolerance, total_height - thickness])
        cube([controller_width + (tolerance - top_tolerance) * 2, top_length, thickness]);
      translate([connector_wall_width + tolerance, 0, total_height - thickness - connector_offset]) {
        cube([connector_width, connector_wall_thickness, thickness + connector_offset]);
        translate([0, 0, connector_offset]) cube([connector_width, thickness, thickness]);
      }
    }

    cooling_width = 12.5;
    cooling_y = 27.2;
    for (i = [0:4]) {
      translate([(total_width - cooling_width) / 2, cooling_y + 3 * i, total_height - thickness - tolerance])
        cube([cooling_width, 1.5, thickness + tolerance * 2]);
    }
  }
}

module switch_plate(thickness = 2.5) {
  max_thickness = 4.7;
  mx_plate_thickness = 1.5;

  translate([5, 5, 0]) difference() {
    linear_extrude(max_thickness)
      import("./svg/PandaWings_contour_half_switch_plate.svg", dpi = 300);
    translate([0, 0, -.1]) linear_extrude(max_thickness - mx_plate_thickness + .1)
      import("./svg/PandaWings_contour_half_switch_plate_outer_cutout.svg", dpi = 300);
    translate([0, 0, max_thickness - mx_plate_thickness - .1]) linear_extrude(mx_plate_thickness + .2)
      import("./svg/PandaWings_contour_half_switch_plate_inner_cutout.svg", dpi = 300);
    translate([0, 0, -.1]) mounting_holes(max_thickness + .2, 3, true);
  }
}

module keyboard_case(thickness = 2.5) {
  linear_extrude(thickness) import("./svg/PandaWings_contour_case.svg", dpi = 300); 
}

if (DONGLE_CASE) translate([0, 120, 0]) dongle_case();

if (SWITCH_PLATE) switch_plate();

if (KEYBOARD_CASE) keyboard_case();

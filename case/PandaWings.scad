// created by IndiePandaaaaa

TOLERANCE = .15;
THICKNESS = 2.5;
$fn = 75;


// DONGLE
DONGLE_CASE = true;

// CASE
KEYBOARD_CASE = true;
SWITCH_PLATE = true;

// CASE ADDONS
WRIST_REST = false;
LAPTOP_STANDOFFS = false;
TENTING_CAPS = true;
TENTING_SOCKET = true;


BATTERY_SIZE = [41.2, 29.5, 4.8];  // Battery 600mAh (Jauch LP503040JH)

PCB_SIZE = [133.8, 92.6];

module nut_cutout(standard = "M3", thickness = 0, tolerance = .1) {

  nut_m3 = [6.1, 2.4];
  nut_m4 = [7.7, 3.2];
  
  rotate([0, 0, 30])
    if (standard == "M3" || standard == "m3" || standard == "3" || standard == 3)
      cylinder(d = nut_m3[0] + tolerance, h = nut_m3[1] > thickness ? nut_m3[1] + tolerance : thickness, $fn = 6);
    else if (standard == "M4" || standard == "m4" || standard == "4" || standard == "4")
      cylinder(d = nut_m4[0] + tolerance, h = nut_m4[1] > thickness ? nut_m4[1] + tolerance : thickness, $fn = 6);
}

module mounting(thickness, diameter = 4.7, screws = false, countersunk = false, nuts = false, standoffs = false) {
  cone_height_m3 = 1.7;
  cone_height_m4 = 2.3;
  
  standoff_offset = 2.75;

  MOUNTING_HOLES = [
    [18.9, 26.3],
    [18.9, 45.3],
    [62.0, 62.5],
    [94.9, 22.8],
    [108.6, 70.1],
  ];

  translate([PCB_SIZE[0], PCB_SIZE[1], 0]) mirror([0, 1, 0]) mirror([1, 0, 0]) union() {
    for (i = MOUNTING_HOLES) {
      translate([i[0], i[1], 0]) {
        if (countersunk && !nuts && diameter >= 3 && diameter <= 3.5)
          translate([0, 0, thickness - cone_height_m3 - .5])
            cylinder(d1 = diameter, d2 = diameter * 2 + 0.4, h = cone_height_m3 + .5);
        else if (countersunk && !nuts && diameter >= 4 && diameter <= 4.5)
          translate([0, 0, thickness - cone_height_m4 - .5])
            cylinder(d1 = diameter, d2 = diameter * 2 + 0.4, h = cone_height_m4 + .5); 
        else if (!countersunk && nuts && diameter == 3)
          nut_cutout("M3", thickness);
        else if (!countersunk && nuts && diameter == 4)
          nut_cutout("M4", thickness);
      }

      if (screws && !nuts) translate([i[0], i[1], 0]) cylinder(d = diameter, h = thickness);

      if (standoffs) translate([i[0] + standoff_offset, i[1], 0]) cylinder(d = diameter, h = thickness);
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

  translate([3, 3.2, 10]) difference() {
    linear_extrude(max_thickness)
      import("./svg/PandaWings_contour_half_switch_plate.svg", dpi = 300);
    translate([0, 0, -.1]) linear_extrude(max_thickness - mx_plate_thickness + .1)
      import("./svg/PandaWings_contour_half_switch_plate_outer_cutout.svg", dpi = 300);
    translate([0, 0, max_thickness - mx_plate_thickness - .1]) linear_extrude(mx_plate_thickness + .2)
      import("./svg/PandaWings_contour_half_switch_plate_inner_cutout.svg", dpi = 300);
    translate([0, 0, -.1]) mounting(max_thickness + .2, 3.2, screws = true, countersunk = true); // 3.2 mm for M3
  }
}

module wrist_rest_mounting(thickness, case_height, cutout = false) {
  translate([82, 10, 0]) {
    wr_loc = [ [0, 0], [40, 9.5] ];
    size = [9, 20, thickness + .2];

    for (i = wr_loc) {
      translate([i[0], i[1], -.1]) union () {
        cube([size[0], size[1] - size[0] / 2, size[2]]);
        translate([size[0] / 2, size[1] - size[0] / 2, 0]) {
          cylinder(d = size[0], h = size[2]);
          cylinder(d = 2.95, h = case_height - 1.5);
        }
      }
    }
  }
}

module keyboard_case(wrist_rest = true, thickness = 2.5, min_thickness = 1.5, pcb_thickness = 1.6) {
  // heights
  battery_connector_height = 5;
  above_pcb = 3;
  below_pcb = min_thickness + BATTERY_SIZE[2] + 1;
  case_height = below_pcb + pcb_thickness + above_pcb;

  mounting_offset = [2.95, 3.2];
  // todo: find height issue, below_pcb != underside of pcb
  
  tenting_locations = [
    [6, 85], 
    [32, 14],
    [116.25, 34.5],
    [116.25, 85],
  ];

  tenting_socket_pos = [88, 66, 5.2];

  difference() {
    union() {
      difference() {
        linear_extrude(case_height)
          import("./svg/PandaWings_contour_case.svg", dpi = 300); 
        translate([0, 0, thickness]) linear_extrude(case_height - thickness + .1)
          import("./svg/PandaWings_contour_half_pcb.svg", dpi = 300);
        translate([0, 0, -.1]) linear_extrude(thickness + .2)
          import("./svg/PandaWings_contour_case_cutout.svg", dpi = 300);
        translate([mounting_offset[0], mounting_offset[1], -.1]) mounting(thickness + .2, 3, nuts = true);
      }
      translate([tenting_socket_pos[0], tenting_socket_pos[1], 0]) cylinder(d = 26, h = tenting_socket_pos[2]);
      difference() {
        translate([mounting_offset[0], mounting_offset[1], thickness]) union() {
          mounting(below_pcb, 4.5, screws = true);
          mounting(below_pcb - 2, 10, screws = true);
        }
      }


      translate([mounting_offset[0], mounting_offset[1], thickness]) 
        mounting(below_pcb, diameter = 4.5, standoffs = true);
      
      for (i = tenting_locations) {
        translate([i[0], i[1], thickness -.1]) {
          difference() {
            cylinder(d = 10, h = 3);
            nut_cutout("M4", 3);
          } 
        }
      }
    }

    for (i = tenting_locations) translate([i[0], i[1], -.1]) cylinder(d = 4.2, h = below_pcb + .1);
    translate([mounting_offset[0], mounting_offset[1], thickness - .1]) 
      mounting(below_pcb + .2, 3.2, screws = true);

    // battery
    translate([20, 38, min_thickness + .15]) cube(BATTERY_SIZE);

    // USB port
    translate([7.5, 88, below_pcb + 2.5]) cube([9, 5, 8]);

    // side switches
    translate([0, 34, below_pcb]) cube([5, 24, 55]);

    // wrist rest mounting
    wrist_rest_mounting(thickness, case_height, cutout = false);

    // tenting socket
    translate([tenting_socket_pos[0], tenting_socket_pos[1], -.1]) cylinder(d = 5.1, h = tenting_socket_pos[2] + .2); // UNC 1/4" threading
  }

}

module tenting_socket() {
  difference() {
    screw_od = 3.5;
    depth = screw_od * 4;
    rotate([-90, 0, 0]) linear_extrude(depth) {
    polygon([
      [0, 0],
      [depth * 5, 0],
      [depth * 5, screw_od],
      [depth * 4, screw_od],
      [depth * 3, depth * 0.75],
      [depth * 2, depth * 0.75],
      [depth * 1, screw_od],
      [0, screw_od],
    ]);
  }
  for (i = [0:1]) {
    translate([depth / 2 + depth * 4 * i, depth / 2, -.1-screw_od]) cylinder(d1 = (screw_od + .5) * 2, d2 = (screw_od + .5), h = screw_od + .2);
  }
  translate([depth * 2.5, depth /2, -.1 - depth]) cylinder(d = 5.1, h = depth + .2);
  } 
  translate([0, -20, 0]) difference() {
    screw_od = 3.5;
    depth = screw_od * 4;
    rotate([-90, 0, 0]) linear_extrude(depth) {
      polygon([
        [0, 0],
        [depth * 5, 0],
        [depth * 5, screw_od],
        [depth * 3.5, screw_od],
        [depth * 2.5, screw_od + depth],
        [depth * 2.4, screw_od + depth],
        [depth * 1.5, screw_od],
        [0, screw_od],
      ]);
    }
    for (i = [0:1]) {
      translate([depth / 2 + depth * 4 * i, depth / 2, -.1-screw_od]) cylinder(d1 = (screw_od + .5) * 2, d2 = (screw_od + .5), h = screw_od + .2);
    }
    rotate([0, -45, 0])
      translate([depth * 1.5, depth / 2, -.1 - depth * 5]) 
        cylinder(d = 5.1, h = depth * 5 + .2);
  }
}

module wrist_rest(height = 21) {
  translate([40, -68, 0]) {
    difference() {
      linear_extrude(height)
        import("./svg/PandaWings_contour_wrist_rest.svg", dpi = 300);

    translate([27, -49, height - .1])
      rotate([0, 0, 20])
        rotate([5, 0, 0])
        cube(100);
    }
  }
}

module tenting_caps(diameter = 12) {
  m4_diameter = 7 + .1;
  m4_head_height = 4;

  for (i = [0:3]) {
    translate([0, -diameter * 1.25 * i, 0]) difference() {
      cylinder(d = diameter, h = m4_head_height + (diameter - m4_diameter) / 4);
      
      translate([0, 0, (diameter - m4_diameter) / 4])
        cylinder(d = m4_diameter, h = m4_head_height + .1);
    }
  }
}

union() {
  if (DONGLE_CASE) translate([-11, 0, 0]) dongle_case();

  for (i = [0:1]) {
    mirror([i, 0, 0]) {
      translate([30, 0, 0]) {
        if (KEYBOARD_CASE) keyboard_case(wrist_rest = WRIST_REST);

        if (SWITCH_PLATE) switch_plate();

        if (WRIST_REST) wrist_rest();

        if (TENTING_CAPS) translate([10, -10, 0]) tenting_caps();

        if (TENTING_SOCKET) translate([30, -20, 0]) tenting_socket();
      }
    }
  }
}


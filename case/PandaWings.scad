// created by IndiePandaaaaa

TOLERANCE = .15;
THICKNESS = 2.5;

KEYBOARD_COORDS = [

];

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

dongle_case();

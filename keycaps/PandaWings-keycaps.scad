// created by IndiePandaaaaa

use <des/MX_DES_Thumb.scad>
use <des/MX_DES_Standard.scad>

// cherry activation point
SILVER = 1.2;
RED = 2;

// o-ring uncompressed thickness
RING_009 = 1.8;

// needed keys
standard = [ [0, 12], [1, 12], [2, 10] ];
thumbs = [ [0, 1], [1, 1], [2, 1] ];


module standard_caps(id, switch_activation_point = 0, o_ring_thickness = 0) {
  keycap_standard(
    keyID = id, // change profile refer to KeyParameters Struct
    cutLen = 0, // Don't change. for chopped caps
    Stem = true, // tusn on shell and stems
    Dish = true, // turn on dish cut
    Stab = 0,
    visualizeDish = false, // turn on debug visual of Dish
    crossSection = false, // center cut to check internal
    homeDot = false, // turn on homedots
    Legends = false,  // not working
    switch_activation_point = switch_activation_point, // activation distance of the switches [for travel blocker]
    o_ring_thickness = o_ring_thickness // thickness of uncompressed o-ring [for travel blocker]
  );
}

module thumb_caps(id, switch_activation_point = 0, o_ring_thickness = 0) {
  keycap_thumb(
    keyID = id, //change profile refer to KeyParameters Struct
    cutLen = 0, //Don't change. for chopped caps
    Stem = true, //tusn on shell and stems
    Dish = true, //turn on dish cut
    Stab = 0,
    visualizeDish = false, // turn on debug visual of Dish
    crossSection = false, // center cut to check internal
    homeDot = false, //turn on homedots
    Legends = false, // not working
    switch_activation_point = switch_activation_point, // activation distance of the switches [for travel blocker]
    o_ring_thickness = o_ring_thickness // thickness of uncompressed o-ring [for travel blocker]
  );
}


// alphanumerical keycaps
translate([0, 30, 0]) {
  for (i = [0:len(standard) - 1]) {
    translate([0, 20 * i, 0]) {
      standard_caps(id = standard[i][0], switch_activation_point = SILVER, o_ring_thickness = RING_009);
    }
  }
}

// thumb cluster keycaps
translate([10, 0, 0]) {
  for (i = [0:1]) {
    mirror([i, 0, 0]) {
      translate([20 * i, 0, 0]) {
        for (x = [0:len(thumbs) - 1]) {
          translate([20 * x, 0, 0]) {
            thumb_caps(id = thumbs[x][0], switch_activation_point = SILVER, o_ring_thickness = RING_009);
          }
        }
      }
    }
  }
}

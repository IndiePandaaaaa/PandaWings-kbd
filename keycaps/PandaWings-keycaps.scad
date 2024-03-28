// created by IndiePandaaaaa

use <des/MX_DES_Thumb.scad>
use <des/MX_DES_Standard.scad>

module standard_caps(id) {
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
    short_travel = 1.2, // activation distance of the switches [for travel blocker]
    o_ring = 1.8 // thickness of uncompressed o-ring [for travel blocker]
  );
}

module thumb_caps(id) {
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
    short_travel = 1.2, // activation distance of the switches [for travel blocker]
    o_ring = 1.8 // thickness of uncompressed o-ring [for travel blocker]
  );
}

standard_caps(2);
translate([20, 0, 0])
  thumb_caps(3);

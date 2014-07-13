/*
 * Igor Soares' lightweight extruder
 * Idler support
 * (C) 2014 by Ígor Bruno Pereira Soares
 *
 * This project is free: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This project is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this project.  If not, see <http://www.gnu.org/licenses/>.
 */

include <configuration.scad>

$fn=64;

idler_support();

module idler_support(
  lwall=WALL_WIDTH,
  wall=STRUCTURAL_WALL_WIDTH,
  axis_h=HOBBED_BOLT_DIAMETER/2,
  idler_h=IDLER_H,
  width=IDLER_W,
  idler_holder_screw_r=IDLER_HOLDER_SCREW_DIAMETER/2,
  guide_r=FILAMENT_ROOM_DIAMETER/2,
  guide_h=FILAMENT_GUIDE_H,
  guide_pos=HOTEND_BODY_DIAMETER/2 + IDLER_HOLDER_SCREW_HEAD_DIAMETER/2 +
            WALL_WIDTH,
  vsupport=HORIZONTAL_SUPPORT_WALL,
  hsupport=VERTICAL_SUPPORT_WALL
) {
  difference() {
    union() {
      translate([-lwall - 2*idler_holder_screw_r,
                 -wall - idler_holder_screw_r,
                 -guide_h + lwall])
        difference()
      {
        cube([width + 2*lwall +4*idler_holder_screw_r,
              2*wall + 2*idler_holder_screw_r,
              guide_h + idler_h]);
        translate([vsupport, vsupport, -1])
          #cube([width + 2*lwall +4*idler_holder_screw_r - 2*vsupport,
                 2*wall + 2*idler_holder_screw_r - 2*vsupport,
                 guide_h - lwall +1]);
      }
      translate([width/2 -lwall - guide_r,
                 0,
                 -guide_h + lwall])
         cube([2*(guide_r + lwall), guide_pos, guide_h]);

      translate([width/2, guide_pos, -guide_h + lwall])
        cylinder(r=guide_r + lwall, h=guide_h);

      translate([-idler_holder_screw_r, 0, 0])
        cylinder(r=idler_holder_screw_r + lwall, h=lwall + idler_h);
      translate([width + idler_holder_screw_r, 0, 0])
        cylinder(r=idler_holder_screw_r + lwall, h=lwall + idler_h);
    }
    translate([-ST, -wall - idler_holder_screw_r -1, lwall +ST])
        cube([width + 2*ST, 2*wall + 2*idler_holder_screw_r +2, idler_h +1]);
    translate([-idler_holder_screw_r, 0, hsupport])
      cylinder(r=idler_holder_screw_r, h=lwall + idler_h +2);
    translate([width + idler_holder_screw_r, 0, hsupport])
      cylinder(r=idler_holder_screw_r, h=lwall + idler_h +2);

    translate([width/2, guide_pos, -guide_h + lwall -1])
      #cylinder(r=guide_r, h=guide_h +2);
  }
}


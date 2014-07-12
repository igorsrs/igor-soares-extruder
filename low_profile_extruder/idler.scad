/*
 * Igor Soares' lightweight extruder
 * Idler
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

mirror([0,1,0]) rotate([-90,0,0]) idler();

module idler(
  lwall=WALL_WIDTH,
  axis_h=IDLER_BEARING_DIAMETER/2,
  hsupport=HORIZONTAL_SUPPORT_WALL,
  idler_h=IDLER_H -IDLER_DIMENSION_TOLERANCE,
  width=IDLER_W -IDLER_DIMENSION_TOLERANCE,
  bearing_r=IDLER_BEARING_DIAMETER/2,
  bearing_room_r=IDLER_BEARING_ROOM_DIAMETER/2,
  bearing_bore_r=IDLER_BEARING_SCREW_DIAMETER/2,
  bearing_width=IDLER_BEARING_WIDTH,
  bearing_screw_head_r = IDLER_BEARING_SCREW_HEAD_DIAMETER/2,
  bearing_screw_head_h = IDLER_BEARING_SCREW_HEAD_ROOM_H,
  bearing_screw_nut_width = IDLER_BEARING_SCREW_NUT_WIDTH,
  bearing_screw_nut_h = IDLER_BEARING_SCREW_NUT_ROOM_H,
  screw_r=IDLER_PRESSURE_SCREW_DIAMETER/2,
  screw_nut_r=IDLER_PRESSURE_SCREW_NUT_WIDTH/(2*cos(30)),
  screw_nut_h=IDLER_PRESSURE_SCREW_NUT_H,
  idler_len=IDLER_LENGTH,
  pressure_screw_z=IDLER_PRESSURE_SCREW_Z_POS,
  pressure_screw_y=IDLER_PRESSURE_SCREW_Y_POS
) {
  difference(){
    union() {
      cube([width, idler_len, idler_h]);
      translate([0, 0, axis_h])
        rotate([0,90,0])
          cylinder(r=bearing_r - ST, h=width);
    }
    translate([width/2 + bearing_width/2, 0, axis_h])
      rotate([0,-90,0])
        #cylinder(r=bearing_room_r, h=bearing_width);

    //bearing screw
    translate([-1, 0, axis_h])
      rotate([0,90,0])
        #cylinder(r=bearing_bore_r, h=width+2);
    translate([-1, 0, axis_h])
      rotate([0,90,0])
        #cylinder(r=bearing_screw_head_r, h=bearing_screw_head_h +1);
    translate([width - bearing_screw_nut_h, 0, axis_h])
      rotate([0,90,0])
        #cylinder(r=bearing_screw_nut_width/(2*cos(30)),
                  h=bearing_screw_nut_h +1,
                  $fn=6);

    translate([width/2 -pressure_screw_y,
               -screw_nut_h - hsupport,
               pressure_screw_z])
       rotate([-90,0,0])
         #cylinder(r=screw_r, h=idler_len + 2*ST);

    translate([width/2 -pressure_screw_y,
              idler_len - screw_nut_h,
              pressure_screw_z])
       rotate([-90,0,0]) rotate([0,0,30])
         #cylinder(r=screw_nut_r, h=idler_len + 2*ST, $fn=6);
  }
}


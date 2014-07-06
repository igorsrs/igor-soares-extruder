/*
 * Igor Soares' lightweight extruder
 * Configuration
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

WALL_WIDTH = 2.05;
STRUCTURAL_WALL_WIDTH = 5.0;
VERTICAL_SUPPORT_WALL = 0.5;
HORIZONTAL_SUPPORT_WALL = 0.4;

MOTOR_HOLDER_ARM_WIDTH= 5.0;
MOTOR_HOLDER_RING_WIDTH = 7.0;
MOTOR_HOLDER_SCREW_DIAMETER = 3.4;
MOTOR_HOLDER_INNER_DIAMETER = 37.5;

BASE_SCREWS_DIAMETER = 4.4;
BASE_SCREWS_NUT_WIDTH = 7.2;
BASE_SCREW_HOTEND_DISTANCE = 25.0; //center to center

HOTEND_BODY_DIAMETER = 16.2;
HOTEND_MOUNT_GROOVE_DIAMETER = 10.2;
HOTEND_BODY_ABOVE_GROOVE_H = 6.5;
HOTEND_MOUNT_SCREW_DIAMETER = 3.0;
HOTEND_MOUNT_SCREW_HEAD_DIAMETER = 5.0;
HOTEND_MOUNT_SCREW_LENGHT = 25.0;

BEARING_DIAMETER = 16.4;
BEARING_WIDTH = 5.2;
BEARING_ACCESS_HOLE_DIAMETER = 8.4;
PRESSURE_BEARING_CLEARANCE = -1;

SECOND_BEARING_FILAMENT_DISTANCE = 30;
BEARING_HOLDING_SCREW_DIAMETER = 3.6;
BEARING_HOLDING_SCREW_NUT_WIDTH = 6.7;
BEARING_HOLDING_SCREW_NUT_H = 3;
BEARING_HOLDING_SCREW_HEAD_DIAMETER = 6;
BEARING_HOLDING_SCREW_LENGTH = 25;

//Dont make this EXACTLY half the gearbox diameter
// to avoid creatiing a defect in the model
// adding (or subtracting) a small value is enough

HOBBED_BOLT_DIAMETER=7.0;
HOBBED_INPUT_GEAR_DIAMETER = 25;

FILAMENT_ROOM_DIAMETER = 4.0;
FILAMENT_APROX_DIAMETER = 3.0;
FILAMENT_BEARING_DISTANCE = 2.0;
GEARBOX_ROOM_DIAMETER = 50;
GEARBOX_SCREWS_DISTANCE = 42;
GEARBOX_SCREW_DIAMETER = 3.4;
GEARBOX_Y_POS = 38;
GEARBOX_Z_POS = 30;
GEARBOX_OUTPUT_GEAR_DIAMETER = 67;
//GEARBOX_OUTPUT_H = 20;

GEARBOX_SIDE_RINGS_H = 5.0;
GEARBOX_OUTPUT_RING_H = 7.0;
GEARBOX_PLANETS_SPACING = 2;;
GEARBOX_NUT_WIDTH = 5.5;
GEARBOX_NUT_H = 2.5;
GEARBOX_ARM_WIDTH = 10;

//alias
GEARBOX_OUTPUT_H = 2*GEARBOX_SIDE_RINGS_H + 2*GEARBOX_PLANETS_SPACING +
                 GEARBOX_OUTPUT_RING_H;

IDLER_HOLDER_SCREW_DIAMETER = 3.6;
IDLER_HOLDER_SCREW_HEAD_DIAMETER = 5.7;
IDLER_HOLDER_SCREW_HEAD_ROOM_H = 2.5;
IDLER_HOLDER_SCREW_NUT_WIDTH = 6.5;
IDLER_HOLDER_SCREW_NUT_H = 2.5;

EXTRUDER_COMPRESSION_NUT_TRAP_BODY = 6;
IDLER_LEFT_WALL = 5;
IDLER_RIGHT_WALL = 7;
IDLER_BASE_SCREW_DIAMETER = 3.4;
IDLER_BASE_SCREW_NUT_WIDTH = 5.8;
IDLER_BASE_SCREW_NUT_H = 2;
IDLER_BASE_DIAMETER = 9.0;
IDLER_TOLERANCES = 0.4;
IDLER_COMPRESSION_SCREW_DIAMETER = 3.6;
IDLER_COMPRESSION_SCREW_NUT_WIDTH = 6.7;
IDLER_COMPRESSION_SCREW_NUT_H = 3;
IDLER_GUIDE_H = BEARING_DIAMETER/2;
IDLER_BEARING_SCREW_DIAMETER = 5.2;
IDLER_BEARING_SCREW_NUT_WIDTH = 8.4;
IDLER_BEARING_SCREW_NUT_H = 4;
IDLER_BODY_BELOW_BEARING_SCREW = 2;
IDLER_BODY_ABOVE_BEARING_SCREW = 0.5;

IDLER_PRESSURE_SCREW_DIAMETER = 3.6;
IDLER_PRESSURE_SCREW_NUT_WIDTH = 6.7;
IDLER_PRESSURE_SCREW_NUT_H = 6;
IDLER_PRESSURE_SCREW_Z_POS = 10;
IDLER_PRESSURE_SCREW_Y_POS = 3.5;

OUTPUT_GEAR_TEETH = 37;
INPUT_GEAR_TEETH = 11;

GEAR_SHAFTS_DISTANCE = 38;

ST = 0.001;

ANGLE = 90;


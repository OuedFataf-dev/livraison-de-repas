/*
 * Copyright (c) 2021 Akshay Jadhav <jadhavakshay0701@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 3 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';

class UniversalVariables {
  static const Color orangeColor = Colors.orange;
  static const Color orangeAccentColor = Colors.orangeAccent;
  static const Color blackColor = Color(0xff19191b);
  static const Color whiteColor = Colors.white;
  static const Color whiteLightColor = Colors.white10;
  static const Color amberColor = Colors.amber;

  static const Color greyColor = Color(0xff8f8f8f);
  static const Color userCircleBackground = Color(0xff2b2b33);
  static const Color onlineDotColor = Color(0xff46dc64);
  static const Color lightBlueColor = Color(0xff0077d7);
  static const Color separatorColor = Color(0xff272c35);

  static const Color gradientColorStart = Color(0xff00b6f3);
  static const Color gradientColorEnd = Color(0xff0184dc);

  static const Color senderColor = Color(0xff2b343b);
  static const Color receiverColor = Color(0xff1e2225);

  static const Gradient fabGradient = LinearGradient(
      colors: [gradientColorStart, gradientColorEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);
}

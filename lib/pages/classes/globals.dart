import 'package:ansicolor/ansicolor.dart';
import 'dart:developer' as developer;

void p(dynamic str) {
  AnsiPen pen = new AnsiPen()..green(bold: true);
  AnsiPen pen2 = new AnsiPen()..green(bold: true);

  developer.log('[' + pen('INFO') + "]: " + pen2(str));
}

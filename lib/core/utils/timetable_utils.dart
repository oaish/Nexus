import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

Future<void> exportScheduleToExcel(Map<String, dynamic> schedule) async {
  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Timetable'];

  // Time slots from 9 AM to 5 PM
  List<int> timeSlots = List.generate(9, (i) => 9 + i); // 9 to 17
  List<TextCellValue> headerRow = [TextCellValue('Day')] +
      timeSlots.map((hour) => TextCellValue('$hour:00')).toList();
  sheetObject.appendRow(headerRow);

  // For each weekday
  schedule.forEach((day, slots) {
    // Map hour to cell text
    Map<int, String> slotMap = {};

    for (var slot in slots) {
      int startHour = int.parse(slot['sTime'].split(':')[0]);

      String details = '';
      if (slot['type'] == 'TH' || slot['type'] == 'MP') {
        details =
            '${slot['subject']} (${slot['teacher']})\nLocation: ${slot['location']}';
      } else if (slot['type'] == 'AC') {
        details = '${slot['activity']}';
      } else if (slot['type'] == 'PR' || slot['type'] == 'TT') {
        details = (slot['subSlots'] as List<dynamic>).map((sub) {
          return (sub['subject'] != null)
              ? 'Batch ${sub['batch']} - ${sub['subject']} (${sub['teacher']})\nLocation: ${sub['location']}'
              : 'Group ${sub['group']} - ${sub['activity']} (${sub['teacher']})\nLocation: ${sub['location']}';
        }).join('\n\n');
      }

      slotMap[startHour] = details;
    }

    // Construct row
    List<TextCellValue> row = [TextCellValue(day)];
    for (int hour in timeSlots) {
      row.add(TextCellValue(slotMap[hour] ?? ''));
    }

    sheetObject.appendRow(row);
  });

  // Save file
  var status = await Permission.storage.request();
  if (status.isGranted) {
    // Get the app documents directory as a fallback
    Directory? directory = await getApplicationDocumentsDirectory();
    String defaultPath = "${directory.path}/timetable.xlsx";

    // Let user choose where to save the file
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Timetable Excel',
      fileName: 'timetable.xlsx',
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      lockParentWindow: true,
    );

    if (outputFile == null) {
      // User cancelled the save dialog
      print("Save cancelled by user");
      return;
    }

    // Ensure the file has .xlsx extension
    if (!outputFile.toLowerCase().endsWith('.xlsx')) {
      outputFile += '.xlsx';
    }

    // Write the Excel file
    File file = File(outputFile)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    print('Excel file saved at: $outputFile');
  } else {
    print("Storage permission denied");
  }
}

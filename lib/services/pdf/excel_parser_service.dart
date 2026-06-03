import 'dart:io';

import 'package:excel/excel.dart';

import '../../models/test_item.dart';
import '../../utils/column_mapper.dart';

class ExcelParserService {
  Future<List<TestItem>> parse(String path, {int? routineId}) async {
    final bytes = File(path).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);

    final sheet = excel.tables.values.first;

    final headers = sheet.rows.first
        .map((e) => e?.value.toString() ?? '')
        .toList();

    final nameColumn = ColumnMapper.findColumn(headers, [
      'Name',
      'TAG',
      'Nome',
    ]);

    final addressColumn = ColumnMapper.findColumn(headers, [
      'Logical Address',
      'I/O',
    ]);

    final commentColumn = ColumnMapper.findColumn(headers, [
      'Comment',
      'Description',
    ]);

    final nameIndex = headers.indexOf(nameColumn!);

    final addressIndex = headers.indexOf(addressColumn!);

    final commentIndex = headers.indexOf(commentColumn!);

    return sheet.rows.skip(1).map((row) {
      return TestItem(
        name: row[nameIndex]?.value.toString() ?? '',
        address: row[addressIndex]?.value.toString() ?? '',
        comment: row[commentIndex]?.value.toString() ?? '',
        routineId: routineId ?? 0,
        tested: false,
        status: false,
        dateTime: '',
      );
    }).toList();
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';

import '../../models/test_item.dart';
import '../../utils/column_mapper.dart';

class CsvParserService {
  Future<List<TestItem>> parse(String path, {int? routineId}) async {
    final content = await File(path).readAsString(encoding: latin1);

    final rows = CsvToListConverter(
      fieldDelimiter: ',',
      eol: '\n',
    ).convert(content);

    final headers = rows.first.map((e) => e.toString()).toList();

    final nameColumn = ColumnMapper.findColumn(headers, [
      'Identifiers',
      'Class',
      // 'TAG',
      // 'Nome',
    ]);

    final addressColumn = ColumnMapper.findColumn(headers, [
      'Logical Address',
      'Address',
      'I/O',
    ]);

    final commentColumn = ColumnMapper.findColumn(headers, [
      'Comment',
      'Description',
      'Comentário',
    ]);

    final nameIndex = headers.indexOf(nameColumn!);
    final addressIndex = headers.indexOf(addressColumn!);

    final commentIndex = headers.indexOf(commentColumn!);

    return rows.skip(1).map((row) {
      return TestItem(
        name: row[nameIndex].toString(),
        address: row[addressIndex].toString(),
        comment: row[commentIndex].toString(),
        routineId: routineId ?? 0,
        tested: false,
        status: false,
        dateTime: '',
      );
    }).toList();
  }
}

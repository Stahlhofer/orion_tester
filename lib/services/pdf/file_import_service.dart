import 'package:orion_tester/services/parsers/xml_parser_service.dart';

import '../../models/test_item.dart';
import '../parsers/csv_parser_service.dart';
import '../parsers/excel_parser_service.dart';

class FileImportService {
  final _csv = CsvParserService();
  final _excel = ExcelParserService();
  final _xml = XmlParserService();

  Future<List<TestItem>> importFile(String path) async {
    if (path.endsWith('.csv')) {
      return _csv.parse(path);
    }

    if (path.endsWith('.xlsx')) {
      return _excel.parse(path);
    }

    if (path.endsWith('.xml')) {
      return _xml.parse(path);
    }

    throw Exception('Formato não suportado');
  }
}

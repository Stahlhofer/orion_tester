import '../../models/test_item.dart';
import 'csv_parser_service.dart';
import 'excel_parser_service.dart';

class FileImportService {
  final _csv = CsvParserService();
  final _excel = ExcelParserService();

  Future<List<TestItem>> importFile(String path) async {
    if (path.endsWith('.csv')) {
      return _csv.parse(path);
    }

    if (path.endsWith('.xlsx')) {
      return _excel.parse(path);
    }

    throw Exception('Formato não suportado');
  }
}

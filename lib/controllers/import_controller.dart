import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/test_item.dart';
import '../services/pdf/file_import_service.dart';
import '../services/pdf/pdf_service.dart';

class ImportController extends ChangeNotifier {
  final _importService = FileImportService();

  final _pdfService = PdfService();

  List<TestItem> items = [];

  Future<void> import(String path) async {
    items = await _importService.importFile(path);

    notifyListeners();
  }

  Future<String> exportPdf(
    List<TestItem> items,
    String routineName,
  ) async {
    File file = await _pdfService.generate(items, routineName);

    return file.path;
  }
}

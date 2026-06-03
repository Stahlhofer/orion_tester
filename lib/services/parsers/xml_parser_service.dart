import 'dart:io';

import 'package:xml/xml.dart';

import '../../models/test_item.dart';

class XmlParserService {
  Future<List<TestItem>> parse(String path, {int? routineId}) async {
    final xmlString = await File(path).readAsString();

    final document = XmlDocument.parse(xmlString);

    final List<TestItem> items = [];

    final nodes = document.findAllElements('Node');

    for (final node in nodes) {
      final name = node.getAttribute('name');

      final address = node.getAttribute('directaddress');

      // Ignora grupos/pastas
      if (name == null || address == null) {
        continue;
      }

      final comment =
          node.getElement('Comment')?.innerText.trim() ?? '';

      items.add(
        TestItem(
          name: name,
          address: address,
          comment: comment,
          routineId: routineId ?? 0,
          tested: false,
          status: false,
          dateTime: '',
        ),
      );
    }

    return items;
  }
}

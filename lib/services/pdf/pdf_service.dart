import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../models/test_item.dart';

class PdfService {
  pw.Container _buildHeader(String routineName) {
    final now = DateTime.now();

    final formattedDate =
        '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year}';

    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Rotina de Testes',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.Text(
                'Data: $formattedDate',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ),

          pw.SizedBox(height: 6),

          pw.Text(
            routineName,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.Divider(),
        ],
      ),
    );
  }

  pw.Table _buildTable(List<TestItem> items) {
    return pw.TableHelper.fromTextArray(
      border: pw.TableBorder.all(),
      headerStyle: pw.TextStyle(
        fontSize: 12,
        // fontWeight: pw.FontWeight.bold,
      ),
      cellPadding: const pw.EdgeInsets.all(3),
      cellStyle: pw.TextStyle(fontSize: 11),
      columnWidths: {
        0: pw.FixedColumnWidth(90),
        1: pw.FixedColumnWidth(45),
        2: pw.FixedColumnWidth(110),
        3: pw.FixedColumnWidth(50),
        4: pw.FixedColumnWidth(45),
        5: pw.FixedColumnWidth(45),
      },
      headers: const [
        'Nome',
        'Endereço',
        'Comentário',
        'Status',
        'Conclusão',
        'DataHora',
      ],
      data: items
          .map(
            (e) => [
              e.name,
              e.address,
              e.comment,
              e.tested ? 'Testado' : 'Não testado',
              e.status ? 'Aprovado' : 'Reprovado',
              e.formattedDateTime,
            ],
          )
          .toList(),
    );
  }

  pw.Row _buildAssinatura() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        assinatura('Técnico Orion'),
        assinatura('Técnico Cliente'),
      ],
    );
  }

  pw.Widget assinatura(String texto) {
    return pw.Column(
      children: [
        pw.Container(
          width: 160,
          decoration: const pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide()),
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(texto, style: pw.TextStyle(fontSize: 10)),
      ],
    );
  }

  Future<File> generate(
    List<TestItem> items,
    String routineName,
    String message,
  ) async {
    var regular = pw.Font.ttf(
      await rootBundle.load("assets/fonts/OpenSans-Medium.ttf"),
    );

    var bold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/OpenSans-Bold.ttf"),
    );

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: regular,
        bold: bold,
        italic: regular,
        boldItalic: regular,
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        maxPages: 30,
        margin: const pw.EdgeInsets.all(20),
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          _buildHeader(routineName),

          _buildTable(items),
        ],
      ),
    );

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(20),
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            children: [
              pw.Flexible(
                child: pw.Container(
                  // height: 180,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      width: 2,
                      color: PdfColors.black,
                    ),
                  ),
                  child: pw.Column(
                    children: [
                      // Cabeçalho
                      pw.Container(
                        height: 25,
                        width: double.infinity,
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        alignment: pw.Alignment.centerLeft,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(
                              width: 2,
                              color: PdfColors.black,
                            ),
                          ),
                        ),
                        child: pw.Text(
                          'Observações',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ),

                      // Área de observações
                      pw.Flexible(
                        child: pw.Container(
                          width: double.infinity,
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            message,
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              pw.SizedBox(height: 100),
              _buildAssinatura(),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();

    var dateTime = DateTime.now();
    final timeStamp =
        '${dateTime.year}${dateTime.month}${dateTime.day}_${dateTime.hour}${dateTime.minute}${dateTime.second}';

    final file = File('${dir.path}/rotina_testes_$timeStamp.pdf');

    await file.writeAsBytes(await pdf.save());
    print('${dir.path}/rotina_testes_$timeStamp.pdf');

    return file;
  }
}

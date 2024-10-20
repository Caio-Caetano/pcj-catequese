import 'package:excel/excel.dart';

Future<void> exportToExcel(List<Map<String, dynamic>> data) async {
  var excel = Excel.createExcel();
  var sheet = excel['Sheet1'];

  var headers = [
    'id',
    'dataInscricao',
    'nome',
    'dataNascimento',
    'idade',
    'nomeMae',
    'nomePai',
    'nomeResponsavel',
    'telefone',
    'email',
    'endereco-rua',
    'endereco-cidade',
    'endereco-bairro',
    'endereco-uf',
    'endereco-numero',
    'endereco-complemento',
    'endereco-cep',
    'batismo-possui',
    'batismo-arquivo',
    'eucaristia-possui',
    'eucaristia-arquivo',
    'local',
    'etapa',
    'arquivado',
    'arquivado-motivo',
  ];

  for (var i = 0; i < headers.length; i++) {
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i)).value = headers[i];
  }

  // Adicione dados
  var indexRow = 1;
  for (var singleData in data) {
    if (singleData.containsKey('turma')) {
      singleData.remove('turma');
    }
    bool isNowArchived = singleData['archived']?['isNowArchived'] ?? false;
    singleData.forEach((key, value) {
      var parent = key;
      if (value is Map) {
        value.forEach((key, value) {
          var flag = 0;
          if (key == 'reasons') {
            flag = headers.indexOf('arquivado-motivo');
          } else if (key == 'isNowArchived') {
            flag = headers.indexOf('arquivado');
          } else {
            flag = headers.indexOf('$parent-$key');
          }
          sheet.cell(CellIndex.indexByColumnRow(rowIndex: indexRow, columnIndex: flag)).value = value is bool ? (value ? 'Sim' : 'Não') : value;
        });
      } else {
        if (value != null) {
          var flag = headers.indexOf(key);
          sheet.cell(CellIndex.indexByColumnRow(rowIndex: indexRow, columnIndex: flag)).value = value;
        }
      }
    });

    // Destacar a linha se 'isNowArchived' for true
    if (isNowArchived) {
      for (var i = 0; i < headers.length; i++) {
        var cell = sheet.cell(CellIndex.indexByColumnRow(
            rowIndex: indexRow, columnIndex: i));
        cell.cellStyle = CellStyle(
          backgroundColorHex: "#D3D3D3", // Cor cinza claro
          fontFamily: getFontFamily(FontFamily.Arial),
        );
      }
    }
    indexRow++;
  }

  // Salve o arquivo
  excel.save(fileName: 'exported.xlsx');
}

Future<void> exportListaPresenca(List<String> data, String mes) async {
  var excel = Excel.createExcel();
  excel.rename('Sheet1', '${DateTime.now().year}_$mes');
  var sheet = excel['${DateTime.now().year}_$mes'];

  // Adiciona os Header
  sheet.merge(CellIndex.indexByString('B1'), CellIndex.indexByString('F1'), customValue: mes);

  // Adiciona leganda DATA
  sheet.cell(CellIndex.indexByString('A2')).value = 'Data';

  // Adicione NOMES
  var indexRow = 2;
  for (var singleData in data) {
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: indexRow, columnIndex: 0)).value = singleData;
    indexRow++;
  }

  CellStyle headerStyle = CellStyle(
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    bold: true,
    rightBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: '#000000'),
    leftBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: '#000000'),
    topBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: '#000000'),
    bottomBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: '#000000'),
  );

  for (var i = 1; i <= 5; i++) {
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i)).cellStyle = headerStyle;
  }

  // Salve o arquivo
  excel.save(fileName: 'lista_presenca_${DateTime.now().year}.xlsx');
}

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
  ];

  for (var i = 0; i < headers.length; i++) {
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i)).value = headers[i];
  }

  // Adicione dados
  var indexRow = 1;
  for (var singleData in data) {
    singleData.forEach((key, value) {
      var parent = key;
      if (value is Map) {
        value.forEach((key, value) {
          var flag = headers.indexOf('$parent-$key');
          sheet.cell(CellIndex.indexByColumnRow(rowIndex: indexRow, columnIndex: flag)).value = value is bool ? value.toString() : value;
        });
      } else {
        if (value != null) {
          var flag = headers.indexOf(key);
          sheet.cell(CellIndex.indexByColumnRow(rowIndex: indexRow, columnIndex: flag)).value = value;
        }
      }
    });
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

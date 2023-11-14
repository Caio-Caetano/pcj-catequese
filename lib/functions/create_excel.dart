import 'package:excel/excel.dart';

Future<void> exportToExcel(List<Map<String, dynamic>> data) async {
  var excel = Excel.createExcel();
  var sheet = excel['Sheet1'];

  var headers = [
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
          sheet.cell(CellIndex.indexByColumnRow(rowIndex: indexRow, columnIndex: flag)).value = value;
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:webapp/enums.dart';
import 'package:webapp/model/dashboard_model.dart';

class ChartDashboard extends StatefulWidget {
  final List<InscricoesDashboardModel> inscricoesDashboardModel;
  final String titulo;
  final ModeloChart modeloGrafico;
  const ChartDashboard(
      {super.key,
      required this.inscricoesDashboardModel,
      required this.titulo,
      this.modeloGrafico = ModeloChart.donut});

  @override
  State<ChartDashboard> createState() => _ChartDashboardState();
}

class _ChartDashboardState extends State<ChartDashboard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 700,
      height: 500,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _retornaGrafico(widget.modeloGrafico)),
    );
  }

  SfCircularChart _buildDonutChart() {
    return SfCircularChart(
        title: ChartTitle(text: widget.titulo),
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        series: _getDefaultPieSeries(),
        borderColor: Colors.grey[600]!,
        backgroundColor: Colors.grey[100],
        palette: const [
          Colors.green,
          Colors.blue,
          Colors.yellow,
          Colors.indigo,
        ]);
  }

  List<DoughnutSeries<ChartSampleData, String>> _getDefaultPieSeries() {
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
        explode: true,
        explodeIndex: 0,
        dataSource: _gerarDadosGrafico(widget.inscricoesDashboardModel),
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelMapper: (ChartSampleData data, _) => data.text,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(fontSize: 12),
          overflowMode: OverflowMode.shift,
          labelPosition: ChartDataLabelPosition.inside,
          connectorLineSettings: ConnectorLineSettings(
            type: ConnectorType.curve,
          ),
        ),
      ),
    ];
  }

  SfCartesianChart _buildRoundedColumnChart() {
    var max = widget.inscricoesDashboardModel
        .reduce((a, b) => a.quantidade > b.quantidade ? a : b);
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: widget.titulo),
      borderColor: Colors.grey[600]!,
      backgroundColor: Colors.grey[100],
      primaryXAxis: const CategoryAxis(
        labelStyle: TextStyle(color: Colors.white),
        axisLine: AxisLine(width: 0),
        labelPosition: ChartDataLabelPosition.inside,
        majorTickLines: MajorTickLines(width: 0),
        majorGridLines: MajorGridLines(width: 0),
      ),
      palette: widget.titulo.contains('Crisma')
          ? const [Colors.blue]
          : const [Colors.green],
      primaryYAxis: NumericAxis(
          isVisible: false, minimum: 0, maximum: max.quantidade.toDouble()),
      series: _getRoundedColumnSeries(),
    );
  }

  List<ColumnSeries<ChartSampleData, String>> _getRoundedColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        width: 0.9,
        dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top,
            textStyle: TextStyle(fontSize: 12)),
        dataSource: _gerarDadosGrafico(widget.inscricoesDashboardModel),
        borderRadius: BorderRadius.circular(10),
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      ),
    ];
  }

  _retornaGrafico(ModeloChart modelo) {
    switch (modelo) {
      case ModeloChart.column:
        return _buildRoundedColumnChart();
      case ModeloChart.donut:
        return _buildDonutChart();
      default:
        return _buildDonutChart();
    }
  }

  // Função para gerar a lista de dados do gráfico
  List<ChartSampleData> _gerarDadosGrafico(
      List<InscricoesDashboardModel> dados) {
    List<ChartSampleData> dataSource = [];

    for (var dado in dados) {
      // Adiciona cada etapa ao dataSource, com as informações necessárias
      if (dado.quantidade != 0) {
        dataSource.add(
          ChartSampleData(
            x: dado.titulo,
            y: dado.quantidade,
            text: '${dado.titulo} \n ${dado.quantidade}',
          ),
        );
      }
    }

    return dataSource;
  }
}

class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}

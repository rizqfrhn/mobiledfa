import 'schedulingmodel.dart';
import '../services.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';
/*import 'package:fl_chart/fl_chart.dart';*/

//GENERAL//

class FlutterMoneyFormatter {
  FlutterMoneyFormatter({@required this.amount,}){}

  double amount;

  String get compact {
    String compacted = NumberFormat.compact(locale: "in").format(amount);
    return 'Rp. $compacted';
  }
  String get compactNonSymbol {
    String compacted = NumberFormat.compact(locale: "in").format(amount);
    return '$compacted';
  }
}

List<OmsetTotalModel> list = [];
List<OmsetSOModel> listSO = [];
List<OmsetTagihModel> listTagihan = [];
List<PeriodeModel> listPeriode = [];
List<BrandModel> listBrand = [];
List<TokoModel> listToko = [];
List<RuteModel> listRute = [];
List<OmsetCallECModel> listCallEC = [];
List<OmsetLineChartModel> listLineChart = [];
Map<DateTime, double> lineChartSO = lineSO();
Map<DateTime, double> lineChartSJ = lineSJ();
Map<DateTime, double> lineChartTG = lineTagihan();
bool loading = false;
var refreshKey = GlobalKey<RefreshIndicatorState>();
PeriodeModel periodeSelection;
double target = 0, realisasi = 0, persentase = 0,
    targetHari = 0, realisasiHari = 0, persentaseHari = 0;
double so = 0, sj = 0, fk = 0, persentase_kirim = 0, persentase_faktur = 0;
double totalToko = 0, totalOrderSO = 0, persentaseToko = 0, totalRute = 0,
    totalTokoRute = 0, persentaseRute = 0;
double targetTagihan = 0, totalBayar = 0, persentaseTagihan = 0,
    targetTagihanHari = 0, totalBayarHari = 0, persentaseTagihanHari = 0;
double targetOmset = 0, rataCall = 0, rataEC = 0,
    rataFk = 0, jumlahSales = 0, estimasiPersentase = 0;
double targetOmsetLast = 0, rataCallLast = 0, rataECLast = 0,
    rataFkLast = 0, jumlahSalesLast = 0, estimasiPersentaseLast = 0;
var now = new DateTime.now();
int monthChart = now.month;
int yearChart = now.year;

Default() {
  list.clear();
  listSO.clear();
  listTagihan.clear();
  listPeriode.clear();
  listBrand.clear();
  listToko.clear();
  listCallEC.clear();
  listLineChart.clear();
  listRute.clear();
  target = 0; realisasi = 0; persentase = 0;
  targetHari = 0; realisasiHari = 0; persentaseHari = 0;
  so = 0; sj = 0; fk = 0; persentase_kirim = 0; persentase_faktur = 0;
  totalToko = 0; totalOrderSO = 0; persentaseToko = 0; totalRute = 0;
  totalTokoRute = 0; persentaseRute = 0;
  targetTagihan = 0; totalBayar = 0; persentaseTagihan = 0;
  targetTagihanHari = 0; totalBayarHari = 0; persentaseTagihanHari = 0;
  targetOmset = 0; rataCall = 0; rataEC = 0;
  rataFk = 0; jumlahSales = 0; estimasiPersentase = 0;
  targetOmsetLast = 0; rataCallLast = 0; rataECLast = 0;
  rataFkLast = 0; jumlahSalesLast = 0; estimasiPersentaseLast = 0;
}

// OMSET //

fetchDataChart(String nik, String periode) async {
  Map dataParam = {
    'lokasi': '',
    'nik': nik,
    'periode': periode
  };

  var responselineChart =
  await http.post(
      '${url}/GetWidgetHarianChart?',
      body: dataParam);
  if (responselineChart.statusCode == 200) {
    listLineChart = (json.decode(responselineChart.body)['Table'] as List)
        .map((data) => new OmsetLineChartModel.fromJson(data))
        .toList();
    lineChartSO = lineSO();
    lineChartSJ = lineSJ();
    lineChartTG = lineTagihan();
  }
}

fetchDataBrand(String nik, String periode) async {
  Map dataParam = {
    'lokasi': '',
    'nik': nik,
    'periode': periode
  };

  var responseBrand =
  await http.post(
      '${url}/GetDataBrandPareto?',
      body: dataParam);
  if (responseBrand.statusCode == 200) {
    listBrand = (json.decode(responseBrand.body)['Table'] as List)
        .map((data) => new BrandModel.fromJson(data))
        .toList();
  }
}

fetchDataCallEC(String nik, String periode) async {
  Map dataParam = {
    'lokasi': '',
    'nik': nik,
    'periode': periode
  };

  var responseCallEC =
  await http.post(
      '${url}/GetWidgetCallEc?',
      body: dataParam);
  if (responseCallEC.statusCode == 200) {
    listCallEC = (json.decode(responseCallEC.body)['Table'] as List)
        .map((data) => new OmsetCallECModel.fromJson(data))
        .toList();
    targetOmset = listCallEC[0].target_omset;
    rataCall = listCallEC[0].rata_call;
    rataEC = listCallEC[0].rata_ec;
    rataFk = listCallEC[0].rata_fk;
    jumlahSales = listCallEC[0].jumlah_sales;
    estimasiPersentase = listCallEC[0].estimasi_persentase;
    targetOmsetLast = listCallEC[0].target_omset_last;
    rataCallLast = listCallEC[0].rata_call_last;
    rataECLast = listCallEC[0].rata_ec_last;
    rataFkLast = listCallEC[0].rata_fk_last;
    jumlahSalesLast = listCallEC[0].jumlah_sales_last;
    estimasiPersentaseLast = listCallEC[0].estimasi_persentase_last;
  }
}

fetchDataDsToko(String nik, String periode) async {
// Detail Toko
  Map dataToko = {
    'lokasi': '',
    'periode': periode,
    'nik': nik,
    'nikSales' : ''
  };

  var responseToko =
  await http.post(
      '${url}/GetDataPersentaseToko?',
      body: dataToko);
  if (responseToko.statusCode == 200) {
    listToko = (json.decode(responseToko.body)['Table'] as List)
        .map((data) => new TokoModel.fromJson(data))
        .toList();
    totalToko = listToko[0].total;
    totalOrderSO = listToko[0].total_order_so;
    persentaseToko = listToko[0].persentase;
  }
}

fetchDataRute(String nik, String periode, List test) async {
// Detail Toko
  Map dataRute = {
    'lokasi': test,
    'periode': periode,
    'nik': nik,
  };

  var responseRute =
  await http.post(
      '${url}/GetSumRuteToko?',
      body: dataRute);
  if (responseRute.statusCode == 200) {
    listRute = (json.decode(responseRute.body)['Table'] as List)
        .map((data) => new RuteModel.fromJson(data))
        .toList();
    totalRute = listRute[0].total_rute;
    totalTokoRute = listRute[0].total_toko;
    persentaseRute = listRute[0].persentase;
  }
}

fetchDataTagihan(String nik, String periode) async {
  Map dataOmset = {
    'lokasi': '',
    'tahun': '',
    'minggu': '',
    'nik': nik,
    'periode': periode
  };

  var responseTagihan =
  await http.post(
      '${url}/GetWidgetDashboardTagihanTotal?',
      body: dataOmset);
  if (responseTagihan.statusCode == 200) {
    listTagihan = (json.decode(responseTagihan.body)['Table'] as List)
        .map((data) => new OmsetTagihModel.fromJson(data))
        .toList();
    targetTagihan = listTagihan[0].target_tagih;
    totalBayar = listTagihan[0].total_bayar;
    persentaseTagihan = listTagihan[0].persentase;
    targetTagihanHari = listTagihan[0].target_hari;
    totalBayarHari = listTagihan[0].total_bayar_hari;
    persentaseTagihanHari = listTagihan[0].persentase_hari;
  }
}

fetchDataSO(String nik, String periode) async {
// Detail SO
  Map dataParam = {
    'lokasi': '',
    'nik': nik,
    'periode': periode
  };

  var responseSO =
  await http.post(
      '${url}/GetWidgetOrder?',
      body: dataParam);
  if (responseSO.statusCode == 200) {
    listSO = (json.decode(responseSO.body)['Table'] as List)
        .map((data) => new OmsetSOModel.fromJson(data))
        .toList();
    so = listSO[0].so;
    sj = listSO[0].sj;
    fk = listSO[0].fk;
    persentase_kirim = listSO[0].persentase_kirim;
    persentase_faktur = listSO[0].persentase_faktur;
  }
}

fetchData(String nik, String periode) async {
// Detail Omset & Tagihan
  Map dataOmset = {
    'lokasi': '',
    'tahun': '',
    'minggu': '',
    'nik': nik,
    'periode': periode
  };

  var response =
  await http.post(
      '${url}/GetWidgetDashboardNewOmsetAreaTotal?',
      body: dataOmset);
  if (response.statusCode == 200) {
    list = (json.decode(response.body)['Table'] as List)
        .map((data) => new OmsetTotalModel.fromJson(data))
        .toList();
    target = list[0].target_omset;
    realisasi = list[0].net_exc_ppn;
    persentase = list[0].persentase;
    targetHari = list[0].target_omset_hari;
    realisasiHari = list[0].net_exc_ppn_hari;
    persentaseHari = list[0].persentase_hari;
  }

// Periode
  var responsePeriode =
  await http.post(
      '${url}/GetDataPeriode');
  if (responsePeriode.statusCode == 200) {
    listPeriode = (json.decode(responsePeriode.body)['Table'] as List)
        .map((data) => new PeriodeModel.fromJson(data))
        .toList();
  }
}

Future<List<OmsetModel>> fetchResultOmset(http.Client client, String nik, String periode) async {
  Map data = {
    'lokasi' : '',
    'tahun': '',
    'minggu': '',
    'nik': nik,
    'periode': periode
  };

  final response =
  await client.post('${url}/GetDataOmsetRegionalGabung?', body: data);

  return compute(parseOmset, response.body);
}

List<OmsetModel> parseOmset(String responseBody) {
  final parsed = jsonDecode(responseBody)['Table'].cast<Map<String, dynamic>>();

  return parsed.map<OmsetModel>((json) => OmsetModel.fromJson(json)).toList();
}

class OmsetDataSource extends DataTableSource {
  final String nik;
  final String periode;
  final List<OmsetModel> _items;
  final BuildContext context;
  OmsetDataSource(this._items, this.nik, this.periode, this.context);

  void sort<T>(Comparable<T> getField(OmsetModel d), bool ascending) {
    _items.sort((OmsetModel a, OmsetModel b) {
      if (!ascending) {
        final OmsetModel c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _items.length)
      return null;
    final OmsetModel omset = _items[index];
    return DataRow.byIndex(
      index: index,
      /*selected: omset.selected,
      onSelectChanged: (bool value) {
        if (omset.selected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          omset.selected = value;
          notifyListeners();
        }
      },*/
      cells: <DataCell>[
        DataCell(Container(child: Text('${omset.nama_regional}'), width: 80.0), /*onTap: () {Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OmsetArea(nama_regional: omset.nama_regional, nik: nik, periode: periode,)),
        );}*/),
        DataCell(Padding(
          padding: EdgeInsets.all(0.0),
          child: new LinearPercentIndicator(
            width: 75,
            animation: true,
            lineHeight: 20.0,
            animationDuration: 2000,
            percent: omset.persentase_harian / 100 <= 0.0 ? 0.0 :
            omset.persentase_harian / 100 >= 1.0 ? 1.0 :
            omset.persentase_harian / 100,
            center: Text('${omset.persentase_harian.toStringAsFixed(2)}%', style: TextStyle(color: Colors.white)),
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: omset.persentase_harian <= 80 ? Colors.red :
            omset.persentase_harian <= 90 ? Colors.orange :
            Colors.green,
          ),
        ),),
        DataCell(Padding(
          padding: EdgeInsets.all(0.0),
          child: new LinearPercentIndicator(
            width: 75,
            animation: true,
            lineHeight: 20.0,
            animationDuration: 2000,
            percent: omset.persentase_bulan / 100 <= 0.0 ? 0.0 :
            omset.persentase_bulan / 100 >= 1.0 ? 1.0 :
            omset.persentase_bulan / 100,
            center: Text('${omset.persentase_bulan.toStringAsFixed(2)}%', style: TextStyle(color: Colors.white)),
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: omset.persentase_bulan <= 80 ? Colors.red :
            omset.persentase_bulan <= 90 ? Colors.orange :
            Colors.green,
          ),
        ),),
        DataCell(Text(FlutterMoneyFormatter(amount: omset.target_omset).compact),),
        /*DataCell(Text('${omset.target_volume.toStringAsFixed(0)}')),*/
        DataCell(Text(FlutterMoneyFormatter(amount: omset.net_exc_ppn).compact),),
      ],
    );
  }

  @override
  int get rowCount => _items.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void _selectAll(bool checked) {
    for (OmsetModel dessert in _items)
      dessert.selected = checked;
    _selectedCount = checked ? _items.length : 0;
    notifyListeners();
  }
}

Map<DateTime, double> lineSO() {
  Map<DateTime, double> data = {};

  if (listLineChart.length != 0) {
    for (var i in listLineChart)
      data[DateTime(i.tahun, i.bulan, i.tgl)] = i.total_so;
  } else {
    data[DateTime.now()] = 0;
  }

  return data;
}

Map<DateTime, double> lineSJ() {
  Map<DateTime, double> data = {};

  if (listLineChart.length != 0) {
    for (var i in listLineChart)
      data[DateTime(i.tahun, i.bulan, i.tgl)] = i.total_harga_sj;
  } else {
    data[DateTime.now()] = 0;
  }

  return data;
}

Map<DateTime, double> lineTagihan() {
  Map<DateTime, double> data = {};

  if (listLineChart.length != 0) {
    for (var i in listLineChart)
      data[DateTime(i.tahun, i.bulan, i.tgl)] = i.total_bayar;
  } else {
    data[DateTime.now()] = 0;
  }

  return data;
}
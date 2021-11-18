import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class BarcodeScanPage extends StatefulWidget {
  @override
  BarcodeScanPageState createState() {
    return new BarcodeScanPageState();
  }
}

// gets product name based on barcode
Future<Product> getProduct(var barcode) async {
  ProductQueryConfiguration configuration = ProductQueryConfiguration(barcode,
      language: OpenFoodFactsLanguage.ENGLISH, fields: [ProductField.ALL]);
  ProductResult result = await OpenFoodAPIClient.getProduct(configuration);

  if (result.status == 1) {
    return result.product!;
  } else {
    throw Exception('product not found, please insert data for ' +
        barcode); // have to do this eventually
  }
}

class BarcodeScanPageState extends State<BarcodeScanPage> {
  ScanResult? scanResult;
  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');

  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;
  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];
  Future _scanQR() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': _cancelController.text,
            'flash_on': _flashOnController.text,
            'flash_off': _flashOffController.text,
          },
          restrictFormat: selectedFormats,
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );
      setState(() => scanResult = result);
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          type: ResultType.Error,
          format: BarcodeFormat.unknown,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanResult = this.scanResult;
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera),
            tooltip: 'Scan',
            onPressed: _scanQR,
          )
        ],
      ),
      body: FutureBuilder(
          future: getProduct(scanResult?.rawContent),
          builder: (_, snapshot) {
            Product result = snapshot.data as Product;
            String ingredients = result.ingredientsText!;
            if (scanResult != null) {
              return ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  ListTile(
                    title: Text("Barcode"),
                    subtitle: Text(scanResult.rawContent),
                  ),
                  ListTile(
                    title: Text("Product"),
                    subtitle: Text(result.productNameInLanguages![
                        OpenFoodFactsLanguage.ENGLISH]!),
                  ),
                  ListTile(
                      title: Text("Indgedients"), subtitle: Text(ingredients))
                ],
              );
            }
            return Text("Error");
          }),
    ));
  }
}

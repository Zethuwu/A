// scan_screen.dart
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'ProductDetailScreen.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String scannedData = '';

  Future<void> scanBarcode() async {
    var result = await BarcodeScanner.scan();
    if (result.rawContent.isNotEmpty) {
      setState(() {
        scannedData = result.rawContent;
        print("ScannedData: " + scannedData);
      });
      _navigateToProductDetails(scannedData);
    }
  }

  void _navigateToProductDetails(String data) {
    List<String> details = data.split('/');
    if (details.length == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(
            name: details[0],
            price: double.parse(details[1]),
            expirationDate: details[2],
            productId: details[3],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Escanear Código de Barras"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Presiona el botón para escanear",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: scanBarcode,
              child: const Text("Escanear Código de Barras"),
            ),
          ],
        ),
      ),
    );
  }
}

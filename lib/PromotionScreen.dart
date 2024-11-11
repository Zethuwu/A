// promotion_screen.dart
import 'package:flutter/material.dart';
import 'promotion.dart';
import 'dart:io';
import 'PdfViewerScreen.dart';
import 'package:path_provider/path_provider.dart';

class PromotionScreen extends StatelessWidget {
  final List<Promotion> promotions = [
    Promotion(
      imageUrl: 'assets/promo1.png',
      title: ' 3x2 en productos colgate',
      description:
          'Aprovecha un 3x2 de los productos seleccionados de colgate.',
    ),
    Promotion(
      imageUrl: 'assets/promo2.png',
      title: '20% y 25% en cereales y yogurt',
      description:
          'Descuento de 20% en cereales seleccionados junto con leche lala y 25% en en yogurt DNUP y danone seleccionados',
    ),
    Promotion(
      imageUrl: 'assets/icon_pdf.png', // Una imagen de icono PDF
      title: 'Promociones Especiales en PDF',
      description: 'Haz clic para ver el PDF.',
      isPDF: true,
      pdfPath: 'assets/promocion.pdf',
    ),
    Promotion(
      imageUrl: 'assets/icon_pdf.png', // Icono de PDF para el segundo PDF
      title: 'Promoción Extra en PDF',
      description: 'Haz clic para ver el segundo PDF.',
      isPDF: true,
      pdfPath: 'assets/promocion2.pdf', // Ruta al segundo PDF
    ),
  ];

  void _showPromotionDetails(BuildContext context, Promotion promotion) async {
    if (promotion.isPDF) {
      // Carga el archivo PDF desde los activos
      final byteData =
          await DefaultAssetBundle.of(context).load(promotion.pdfPath);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${promotion.pdfPath.split('/').last}');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      // Navega a la pantalla del visor de PDF con el PDF específico
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerScreen(pdfPath: file.path),
        ),
      );
    } else {
      // Mostrar el modal de detalles de la promoción
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 56, 56, 56),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  promotion.imageUrl,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Text(
                  promotion.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  promotion.description,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Promociones"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: promotions.length,
          itemBuilder: (context, index) {
            final promotion = promotions[index];
            return GestureDetector(
              onTap: () => _showPromotionDetails(context, promotion),
              child: Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      promotion.imageUrl,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        promotion.title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

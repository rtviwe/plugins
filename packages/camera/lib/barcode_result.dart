part of 'camera.dart';

class BarcodeResult {
  final int imageWidth;
  final int imageHeight;
  final List<Barcode> barcodes;

  BarcodeResult._fromData(Map<dynamic, dynamic> data)
      : imageWidth = data['imageWidth'],
        imageHeight = data['imageHeight'],
        barcodes = data['barcodes'] == null
            ? const <Barcode>[]
            : List<Barcode>.unmodifiable(data['barcodes'].map((data) => Barcode(data)));
}

package io.flutter.plugins.camera.barcode;

import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcode;

import java.util.List;

public class BarcodeDetectorResult {
    private final List<FirebaseVisionBarcode> barcodes;

    public BarcodeDetectorResult(List<FirebaseVisionBarcode> barcodes) {
        this.barcodes = barcodes;
    }

    public List<FirebaseVisionBarcode> getBarcodes() {
        return barcodes;
    }
}

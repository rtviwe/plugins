package io.flutter.plugins.camera.barcode;

import android.media.Image;

import androidx.annotation.NonNull;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.ml.vision.FirebaseVision;
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcode;
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcodeDetector;
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcodeDetectorOptions;
import com.google.firebase.ml.vision.common.FirebaseVisionImage;
import com.google.firebase.ml.vision.common.FirebaseVisionImageMetadata;

import java.util.List;

public class BarcodeDetectorWrapper {
    private final FirebaseVisionBarcodeDetector detector;
    private final ResultListener resultListener = new ResultListener();
    private BarcodeDetectorResult recentResult;
    private long lastDetectionTime = 0L;
    private boolean isDetecting = false;

    private final long throttle;

    public BarcodeDetectorWrapper(final int barcodeFormats, final long throttle) {
        this.throttle = throttle;
        final FirebaseVisionBarcodeDetectorOptions options = new FirebaseVisionBarcodeDetectorOptions.Builder()
                .setBarcodeFormats(barcodeFormats)
                .build();
        detector = FirebaseVision.getInstance().getVisionBarcodeDetector(options);
    }

    public BarcodeDetectorResult getRecentResult() {
        return recentResult;
    }

    public void resetResult() {
        recentResult = null;
    }

    public void detect(Image image, int rotation) {
        final long currentTime = System.currentTimeMillis();
        if (isDetecting || lastDetectionTime + throttle > currentTime) {
            return;
        }
        isDetecting = true;
        lastDetectionTime = currentTime;

        detector.detectInImage(FirebaseVisionImage.fromMediaImage(image, degreesToFirebaseRotation(rotation)))
                .addOnSuccessListener(resultListener)
                .addOnFailureListener(resultListener);
    }

    private int degreesToFirebaseRotation(int degrees) {
        switch (degrees) {
            case 90:
                return FirebaseVisionImageMetadata.ROTATION_90;
            case 180:
                return FirebaseVisionImageMetadata.ROTATION_180;
            case 270:
                return FirebaseVisionImageMetadata.ROTATION_270;
            default:
                return FirebaseVisionImageMetadata.ROTATION_0;
        }
    }

    private class ResultListener implements OnSuccessListener<List<FirebaseVisionBarcode>>, OnFailureListener {

        @Override
        public void onSuccess(List<FirebaseVisionBarcode> firebaseVisionBarcodes) {
            isDetecting = false;
            recentResult = new BarcodeDetectorResult(firebaseVisionBarcodes);
        }

        @Override
        public void onFailure(@NonNull Exception e) {
            isDetecting = false;
        }
    }
}

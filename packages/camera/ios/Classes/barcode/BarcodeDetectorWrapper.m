@import UIKit;
#import "BarcodeDetectorWrapper.h"

@implementation BarcodeDetectorWrapper{
    FIRVisionBarcodeDetector *barcodeDetector;
}

- (id)initWithFormats:(FIRVisionBarcodeFormat)formats
          andThrottle:(long)throttle {
    self = [super init];
    FIRVision *vision = [FIRVision vision];
    FIRVisionBarcodeDetectorOptions *options = [[FIRVisionBarcodeDetectorOptions alloc] initWithFormats:formats];
    barcodeDetector = [vision barcodeDetectorWithOptions:options];
    return self;
}

- (void)detectInSampleBuffer:(CMSampleBufferRef)sampleBuffer
           forDevicePosition:(AVCaptureDevicePosition)devicePosition
                withCallback:(BarcodeResultCallback)callback {
    FIRVisionImageMetadata *metadata = [[FIRVisionImageMetadata alloc] init];
    metadata.orientation = [self
        imageOrientationFromDeviceOrientation:UIDevice.currentDevice.orientation
                               cameraPosition:devicePosition];

    FIRVisionImage *image = [[FIRVisionImage alloc] initWithBuffer:sampleBuffer];
    image.metadata = metadata;

    [barcodeDetector detectInImage:image
                        completion:^(NSArray<FIRVisionBarcode *> *barcodes, NSError *error) {
        if (error != nil) {
            return;
        } else if (barcodes != nil) {
            BarcodeDetectorResult *result = [[BarcodeDetectorResult alloc] initWithBarcodes:barcodes];
            callback(result);
        }
    }];
}

- (FIRVisionDetectorImageOrientation)imageOrientationFromDeviceOrientation:(UIDeviceOrientation)deviceOrientation
     cameraPosition:(AVCaptureDevicePosition)cameraPosition {
  switch (deviceOrientation) {
    case UIDeviceOrientationPortrait:
      if (cameraPosition == AVCaptureDevicePositionFront) {
        return FIRVisionDetectorImageOrientationLeftTop;
      } else {
        return FIRVisionDetectorImageOrientationRightTop;
      }
    case UIDeviceOrientationLandscapeLeft:
      if (cameraPosition == AVCaptureDevicePositionFront) {
        return FIRVisionDetectorImageOrientationBottomLeft;
      } else {
        return FIRVisionDetectorImageOrientationTopLeft;
      }
    case UIDeviceOrientationPortraitUpsideDown:
      if (cameraPosition == AVCaptureDevicePositionFront) {
        return FIRVisionDetectorImageOrientationRightBottom;
      } else {
        return FIRVisionDetectorImageOrientationLeftBottom;
      }
    case UIDeviceOrientationLandscapeRight:
      if (cameraPosition == AVCaptureDevicePositionFront) {
        return FIRVisionDetectorImageOrientationTopRight;
      } else {
        return FIRVisionDetectorImageOrientationBottomRight;
      }
    default:
      return FIRVisionDetectorImageOrientationTopLeft;
  }
}

@end

#import <AVFoundation/AVFoundation.h>
#import "Firebase/Firebase.h"
#import "BarcodeDetectorResult.h"

typedef void (^BarcodeResultCallback)(BarcodeDetectorResult *);

@interface BarcodeDetectorWrapper : NSObject

- (id)initWithFormats:(FIRVisionBarcodeFormat)formats
          andThrottle:(long)throttle;

- (void)detectInSampleBuffer:(CMSampleBufferRef)sampleBuffer
           forDevicePosition:(AVCaptureDevicePosition)devicePosition
                withCallback:(BarcodeResultCallback)callback;

@end;

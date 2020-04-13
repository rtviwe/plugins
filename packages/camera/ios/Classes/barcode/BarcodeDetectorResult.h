#import "Firebase/Firebase.h"

@interface BarcodeDetectorResult : NSObject

- (id) initWithBarcodes:(NSArray<FIRVisionBarcode *> *)barcodes;

- (NSArray<FIRVisionBarcode *> *)getBarcodes;

- (NSArray *)asSerialized;

@end

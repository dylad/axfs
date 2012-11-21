#import <Foundation/NSObject.h>
#import "axfs_helper.h"
#import "compressor.h"

extern struct axfs_config acfg;

@interface CompressibleObject: NSObject {
	uint8_t *data;
	uint64_t size;
	uint8_t *cdata;
	uint64_t csize;
}

-(void *) data;
-(uint64_t) size;
-(void *) cdata;
-(uint64_t) csize;
@end
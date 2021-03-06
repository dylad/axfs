#import "region.h"

@implementation Region

-(void) add: (id) oobj {
	o = oobj;
}

/* on media struct describing a data region */
//struct axfs_region_desc_onmedia {
//	u64 fsoffset;
//	u64 size;
//	u64 compressed_size;
//	u64 max_index;
//	u8 table_byte_depth;
//	u8 incore;
//};

-(uint8_t *) data_p {
	return data;
}

-(void *) data {
	uint64_t lsize;
	uint64_t csize;
	uint64_t max_index;
	uint64_t offset;
	uint8_t table_byte_depth;
	uint8_t *data_p;

	lsize = (uint64_t)[o size];
	csize = [o csize];
	max_index = [o length];
	offset = [o fsoffset];
	table_byte_depth = [o depth];

	data_p = data;
	data_p = [self bigEndian64: offset ptr: data_p];
	data_p = [self bigEndian64: lsize ptr: data_p];
	data_p = [self bigEndian64: csize ptr: data_p];
	data_p = [self bigEndian64: max_index ptr: data_p];
	data_p = [self bigEndianByte: table_byte_depth ptr: data_p];
	data_p = [self bigEndianByte: incore ptr: data_p];

	return data;
}

-(void) fsoffset: (uint64_t) offset {
	fsoffset = offset;
}

-(uint64_t) fsoffset {
	return fsoffset;
}

-(void) incore: (uint8_t) core {
	incore = core;
}

-(uint64_t) size {
	return AXFS_REGION_SIZE;
}

-(id) init {
	if (!(self = [super init]))
		return self;

	fsoffset = 0;
	data = malloc(AXFS_REGION_SIZE);
	memset(data,0,AXFS_REGION_SIZE);

	return self;
}

-(void) free {
	free(data);
}

@end

/*	Region *region;
	region = [[Region alloc] init];
	[region add: self];

-(Region *) region;

-(Region *) region {
	return region;
}
*/
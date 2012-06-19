#import <Foundation/Foundation.h>
#include "compressor.h"
#include "compressor.m"
#import "getopts.h"
#import "getopts.m"
#import "opts_validator.h"
#import "opts_validator.m"
#import <Foundation/NSAutoreleasePool.h>

struct axfs_config acfg;

char * denullify(char * foo) {
	return foo == NULL ? "" : foo;
}

int main( int argc, const char *argv[] ) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	OptsValidator *ov;
	GetOpts *go;
	bool retval;

	memset(&acfg,0,sizeof(acfg));

	go = [[GetOpts alloc] init];
	[go initialize]; 
	[go argc: argc argv: (char **) argv];

	ov = [[OptsValidator alloc] init];
	[ov initialize];
	retval = [ov validate];

	[ov free];
	[ov release];

	[go free];
	[go release];

	[pool drain];

	printf("---\n");
	printf("axfs_config:\n");
	printf("  input: %s\n",denullify(acfg.input));
	printf("  secondary_output: %s\n",denullify(acfg.secondary_output));
	printf("  output: %s\n",denullify(acfg.output));
	printf("  compression: %s\n",denullify(acfg.compression));
	printf("  profile: %s\n",denullify(acfg.profile));
	printf("  special: %s\n",denullify(acfg.special));
	printf("  xip_size: %llu\n",acfg.xip_size);
	printf("  block_size: %llu\n",acfg.block_size);
	printf("opts_validator:\n");
	printf("  valid: %s\n", retval ? "true":"false");

	return 0;
}
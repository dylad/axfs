#include "header.h"
#include "stubs.h"
#include "CuTest.h"

/* Including function under test */
#include "strings.h"
#include "strings.m"
#include "compressor.h"
#include "compressor.m"

/****** Test Code ******/

static void StringsComp_less(CuTest *tc){
	int output;
	struct string_struct a;
	struct string_struct b;

	printf("Running %s\n", __FUNCTION__);

	a.data = "AAAAAA";
	a.length = 5;
	b.data = "BBBBBB";
	b.length = 6;
	output = StringsComp((void *)&a.data,(void *)&b.data);
	CuAssertIntEquals(tc, -1, output);

	a.data = "AAAAAA";
	a.length = 6;
	b.data = "BBBBBB";
	b.length = 6;
	output = StringsComp((void *)&a.data,(void *)&b.data);
	CuAssertIntEquals(tc, -1, output);

	a.data = "AAAAAA";
	a.length = 2;
	b.data = "BBBBBB";
	b.length = 2;
	output = StringsComp((void *)&a.data,(void *)&b.data);
	CuAssertIntEquals(tc, -1, output);
}

static void StringsComp_greater(CuTest *tc){
	int output;
	struct string_struct a;
	struct string_struct b;

	printf("Running %s\n", __FUNCTION__);

	a.data = "AAAAAA";
	a.length = 6;
	b.data = "BBBBBB";
	b.length = 5;
	output = StringsComp((void *)&a.data,(void *)&b.data);
	CuAssertIntEquals(tc, 1, output);

	a.data = "BBBBBB";
	a.length = 6;
	b.data = "AAAAAA";
	b.length = 6;
	output = StringsComp((void *)&a.data,(void *)&b.data);
	CuAssertIntEquals(tc, 1, output);

	a.data = "BBBBBB";
	a.length = 2;
	b.data = "AAAAAA";
	b.length = 2;
	output = StringsComp((void *)&a.data,(void *)&b.data);
	CuAssertIntEquals(tc, 1, output);
}

static void StringsComp_equal(CuTest *tc){
	int output;
	struct string_struct a;
	struct string_struct b;

	printf("Running %s\n", __FUNCTION__);

	a.data = malloc(4096);
	b.data = malloc(4096);

	a.data = "AAAAAA";
	a.length = 5;
	b.data = "AAAAAA";
	b.length = 5;
	output = StringsComp((void *)&a.data,(void *)&b.data);
	CuAssertIntEquals(tc, 0, output);

	a.data = "AAAAAA";
	a.length = 6;
	b.data = "AAAAAA";
	b.length = 6;
	output = StringsComp((void *)&a.data,(void *)&b.data);
	CuAssertIntEquals(tc, 0, output);

	a.data = "AAAAAA";
	a.length = 2;
	b.data = "AAAAAA";
	b.length = 2;
	output = StringsComp((void *)&a.data,(void *)&b.data);
	CuAssertIntEquals(tc, 0, output);
}

static void Strings_createdestroy(CuTest *tc){
	int output;
	Strings *str = [[Strings alloc] init];
	
	printf("Running %s\n", __FUNCTION__);

	[str numberInodes: 10 length: 40000 path: "./tempfile"];
	[str free];
	[str release];

	output = 0;
	CuAssertIntEquals(tc, 0, output);
}

static void Strings_simplesort(CuTest *tc){
	void *output[5];
	uint8_t data0[4096];
	uint8_t data1[4096];
	uint8_t data2[4096];
	uint8_t data3[4096];
	uint8_t data4[4096];
	uint64_t length = 4096;
	int i,j;

	printf("Running %s\n", __FUNCTION__);

	Strings *str = [[Strings alloc] init];
	[str numberInodes: 10 length: 40000 path: "./tempfile"];

	memset(&data0,'5',4096);
	output[0] = [str addString: &data0 length: length];

	memset(&data1,'6',4096);
	output[1] = [str addString: &data1 length: length];

	memset(&data2,'7',4096);
	output[2] = [str addString: &data2 length: length];

	memset(&data3,'4',4096);
	output[3] = [str addString: &data3 length: length];

	memset(&data4,'5',4096);
	output[4] = [str addString: &data4 length: 500];

	CuAssertPtrNotNull(tc, output[0]);
	CuAssertPtrNotNull(tc, output[1]);
	CuAssertPtrNotNull(tc, output[2]);
	CuAssertPtrNotNull(tc, output[3]);
	CuAssertPtrNotNull(tc, output[4]);
	for(i=0; i<5; i++) {
		for(j=0; j<5; j++) {
			if(i == j)
				continue;
			CuAssertTrue(tc, output[i] != output[j]);
		}
	}
	[str free];
	[str release];
}

static void Strings_duplicates(CuTest *tc){
	void *output[5];
	uint8_t data0[4096];
	uint8_t data1[4096];
	uint8_t data2[4096];
	uint8_t data3[4096];
	uint8_t data4[4096];
	uint64_t length = 4096;

	Strings *str = [[Strings alloc] init];
	[str numberInodes: 10 length: 40000 path: "./tempfile"];

	printf("Running %s\n", __FUNCTION__);

	memset(&data0,'5',4096);
	output[0] = [str addString: &data0 length: length];

	memset(&data1,'6',4096);
	output[1] = [str addString: &data1 length: length];

	memset(&data2,'6',4096);
	output[2] = [str addString: &data2 length: length];

	memset(&data3,'4',4096);
	output[3] = [str addString: &data3 length: length];

	memset(&data4,'5',4096);
	output[4] = [str addString: &data4 length: 500];

	CuAssertPtrNotNull(tc, output[0]);
	CuAssertPtrNotNull(tc, output[1]);
	CuAssertPtrNotNull(tc, output[2]);
	CuAssertPtrNotNull(tc, output[3]);
	CuAssertPtrNotNull(tc, output[4]);
	CuAssertTrue(tc, (output[1] == output[2]));
	CuAssertTrue(tc, (output[0] != output[4]));

	[str free];
	[str release];
}

static void Strings_falsedups(CuTest *tc){
	void *output[5];
	uint8_t data0[4096];
	uint8_t data1[4096];
	uint8_t data2[4096];
	uint8_t data3[4096];
	uint8_t data4[4096];
	uint64_t length = 4096;
	int i,j;

	Strings *str = [[Strings alloc] init];
	[str numberInodes: 10 length: 40000 path: "./tempfile"];

	printf("Running %s\n", __FUNCTION__);

	memset(&data0,'5',4096);
	output[0] = [str addString: &data0 length: length];

	memset(&data1,'5',4096);
	output[1] = [str addString: &data1 length: 4095];

	memset(&data2,'5',4096);
	data2[4095] = '6';
	output[2] = [str addString: &data2 length: length];

	memset(&data3,'5',4096);
	data3[256] = '6';
	output[3] = [str addString: &data3 length: length];

	memset(&data4,'5',4096);
	data4[0] = '6';
	output[4] = [str addString: &data4 length: 500];

	CuAssertPtrNotNull(tc, output[0]);
	CuAssertPtrNotNull(tc, output[1]);
	CuAssertPtrNotNull(tc, output[2]);
	CuAssertPtrNotNull(tc, output[3]);
	CuAssertPtrNotNull(tc, output[4]);
	for(i=0; i<5; i++) {
		for(j=0; j<5; j++) {
			if(i == j)
				continue;
			CuAssertTrue(tc, (output[i] != output[j]));
		}
	}

	[str free];
	[str release];
}

static void Strings_data(CuTest *tc){
	void *output;
	char *text;
	char *expected;
	char *data;
	uint64_t length;
	int explen = 0;

	printf("Running %s\n", __FUNCTION__);

	Strings *str = [[Strings alloc] init];
	[str numberInodes: 1000 length: 40000 path: "./tempfile"];
	expected = malloc(2000);

	length = 5;
	text = "hello";
	data = [str allocStringData: length];
	memcpy(data,text,length);
	[str addString: data length: length];
	memcpy(&expected[explen],text,length);
	explen += length;

	length = 5;
	text = "jared";
	data = [str allocStringData: length];
	memcpy(data,text,length);
	[str addString: data length: length];
	memcpy(&expected[explen],text,length);
	explen += length;

	length = 13;
	text = "jared hulbert";
	data = [str allocStringData: length];
	memcpy(data,text,length);
	[str addString: data length: length];
	memcpy(&expected[explen],text,length);
	explen += length;

	length = 1000;
	data = [str allocStringData: length];
	text = malloc(length);
	memset(text,'a',length);
	memcpy(data,text,length);
	[str addString: data length: length];
	memcpy(&expected[explen],text,length);
	explen += length;
	free(text);

	expected[explen] = 0;
	output = [str data];
	CuAssertStrEquals(tc, expected, output);
	CuAssertIntEquals(tc, explen, [str size]);
	CuAssertIntEquals(tc, 4, [str length]);
}

static void Strings_cdata(CuTest *tc){
	void *output;
	char *text;
	char *expected;
	char *data;
	uint64_t length;
	int explen = 0;

	printf("Running %s\n", __FUNCTION__);

	Strings *str = [[Strings alloc] init];
	[str numberInodes: 1000 length: 40000 path: "./tempfile"];
	expected = malloc(2000);

	length = 5;
	text = "hello";
	data = [str allocStringData: length];
	memcpy(data,text,length);
	[str addString: data length: length];
	memcpy(&expected[explen],text,length);
	explen += length;

	length = 5;
	text = "jared";
	data = [str allocStringData: length];
	memcpy(data,text,length);
	[str addString: data length: length];
	memcpy(&expected[explen],text,length);
	explen += length;

	length = 13;
	text = "jared hulbert";
	data = [str allocStringData: length];
	memcpy(data,text,length);
	[str addString: data length: length];
	memcpy(&expected[explen],text,length);
	explen += length;

	length = 1000;
	data = [str allocStringData: length];
	text = malloc(length);
	memset(text,'a',length);
	memcpy(data,text,length);
	[str addString: data length: length];
	memcpy(&expected[explen],text,length);
	explen += length;
	free(text);

	expected[explen] = 0;
	output = [str cdata];
	CuAssertTrue(tc, (expected[2] != ((char *)output)[2]));
	CuAssertIntEquals(tc, 35, [str csize]);
	CuAssertIntEquals(tc, 4, [str length]);
}

/****** End Test Code ******/


static CuSuite* GetSuite(void){
	CuSuite* suite = CuSuiteNew();

	SUITE_ADD_TEST(suite, StringsComp_less);
	SUITE_ADD_TEST(suite, StringsComp_greater);
	SUITE_ADD_TEST(suite, StringsComp_equal);
	SUITE_ADD_TEST(suite, Strings_createdestroy);
	SUITE_ADD_TEST(suite, Strings_simplesort);
	SUITE_ADD_TEST(suite, Strings_duplicates);
	SUITE_ADD_TEST(suite, Strings_falsedups);
	SUITE_ADD_TEST(suite, Strings_data);
	SUITE_ADD_TEST(suite, Strings_cdata);
	return suite;
}

void FreeSuite(CuSuite* suite)
{
	int i;
	for (i = 0 ; i < suite->count ; ++i)
	{
		if(suite->list[i] != NULL) {
			free((void*)suite->list[i]->name);
			free(suite->list[i]);
		} else
			suite->list[i] = 0;
	}
	free(suite);
}

void RunAllTests(void) 
{
	CuString *output = CuStringNew();
	CuSuite* suite = CuSuiteNew();
	CuSuite* newsuite = GetSuite();
	
	CuSuiteAddSuite(suite, newsuite);
	CuSuiteRun(suite);
	
	CuSuiteSummary(suite, output);
	CuSuiteDetails(suite, output);
	printf("%s\n", output->buffer);
	FreeSuite(suite);
	free(newsuite);
	free(output->buffer);
	free(output);
	return;
}


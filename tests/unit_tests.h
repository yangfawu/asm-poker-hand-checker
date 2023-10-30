#include <assert.h>
#include <stdio.h>
#include <unistd.h>

#include "criterion/criterion.h"

#define TEST_TIMEOUT 10
#define TEST_INPUT_DIR "tests.in"
#define TEST_OUTPUT_DIR "tests.out"

void run_using_system(char *test_name, char *args);
void expect_outfile_matches(char *name);
void execute_test(char *test_name, char *args);
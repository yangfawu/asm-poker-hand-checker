/*
DO NOT CHANGE THE CONTENTS OF THIS FILE IN CASE A NEW VERSION IS DISTRIBUTED.
PUT YOUR OWN TEST CASES IN student_tests.c
*/

#include "unit_tests.h"

static char test_log_outfile[100];

void run_using_system(char *test_name, char *args) {
    char *mars_jar = "./MarsFall2020.jar";
    assert(access(mars_jar, F_OK) == 0);
    char cmd[500];
    sprintf(test_log_outfile, "%s/%s.txt", TEST_OUTPUT_DIR, test_name);
    sprintf(cmd, "ulimit -f 50; ulimit -t %d; java -jar MarsFall2020.jar hw8.asm --noGui --main -q -n 10000 --argv %s >> %s 2>&1", TEST_TIMEOUT, args, test_log_outfile);
    system(cmd);
}

void expect_outfile_matches(char *name) {
    char cmd[500];
    sprintf(cmd, "diff %s/%s.txt %s ", TEST_INPUT_DIR, name, test_log_outfile);
    int err = system(cmd);
    cr_expect_eq(err, 0, "The output was not what was expected (diff exited with status %d).\n", WEXITSTATUS(err));
}

void execute_test(char *test_name, char *args) {
    run_using_system(test_name, args); 
    expect_outfile_matches(test_name);
}

TestSuite(base_tests, .timeout=TEST_TIMEOUT, .disabled=false);

Test(base_tests, encode01) {
    execute_test("encode01", "E 33 17 17 32769");
}

Test(base_tests, encode02) {
    execute_test("encode02", "E 63 31 31 65535");
}

Test(base_tests, encode03) {
    execute_test("encode03", "E 00 00 00 00000");
}

Test(base_tests, encode04) {
    execute_test("encode04", "E 64 31 31 65535");
}

Test(base_tests, encode05) {
    execute_test("encode05", "E 12 00 32 00000");
}

Test(base_tests, encode06) {
    execute_test("encode06", "E 11 00 32 65536");
}

Test(base_tests, encode07) {
    execute_test("encode07", "E 11 00 32 65536 100 lol");
}

Test(base_tests, decode01) {
    execute_test("decode01", "D 0x01f11b9d");
}

Test(base_tests, decode02) {
    execute_test("decode02", "D 0x86318001");
}

Test(base_tests, decode03) {
    execute_test("decode03", "D 0x04210001");
}

Test(base_tests, decode04) {
    execute_test("decode04", "D 0x042103e8");
}

Test(base_tests, decode05) {
    execute_test("decode05", "D 86318001");
}

Test(base_tests, decode06) {
    execute_test("decode06", "D 0X8631801");
}

Test(base_tests, decode07) {
    execute_test("decode07", "D 0x863180010");
}

Test(base_tests, decode08) {
    execute_test("decode08", "D 0x863180010 SBU 2023");
}

Test(base_tests, poker01) {
    execute_test("poker01", "P 1BSd5");
}

Test(base_tests, poker02) {
    execute_test("poker02", "P URYW1");
}

Test(base_tests, poker03) {
    execute_test("poker03", "P 91MAm");
}

Test(base_tests, poker04) {
    execute_test("poker04", "P 91MAB");
}

Test(base_tests, poker05) {
    execute_test("poker05", "P ASaBb");
}

Test(base_tests, poker06) {
    execute_test("poker06", "P 12345");
}

Test(base_tests, poker07) {
    execute_test("poker07", "P kmjli");
}

Test(base_tests, poker08) {
    execute_test("poker08", "P =1342");
}

Test(base_tests, poker09) {
    execute_test("poker09", "P AQaB1");
}

Test(base_tests, poker10) {
    execute_test("poker10", "P AQaB1 hello");
}

Test(base_tests, invalid_command01) {
    execute_test("invalid_command01", "Deg 0x01f11b9d");
}

Test(base_tests, invalid_command02) {
    execute_test("invalid_command02", "Good Bye 0x01f11b9d");
}

Test(base_tests, invalid_command03) {
    execute_test("invalid_command03", "x 15 23 0x01f11b9d");
}
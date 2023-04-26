#include "unit_tests.h"

TestSuite(command_tests, .timeout=TEST_TIMEOUT, .disabled=true);
TestSuite(student_tests, .timeout=TEST_TIMEOUT, .disabled=true);
TestSuite(encode_tests, .timeout=TEST_TIMEOUT, .disabled=true);
TestSuite(decode_tests, .timeout=TEST_TIMEOUT, .disabled=true);
TestSuite(poker_tests, .timeout=TEST_TIMEOUT, .disabled=false);

Test(student_tests, doc1) {
    execute_test("doc1", "e 63 31 31 31");
}

Test(student_tests, doc2) {
    execute_test("doc2", "Deg 0x01f11b9d");
}

Test(student_tests, doc3) {
    execute_test("doc3", "D 0x04212710 10");
}

Test(student_tests, doc4) {
    execute_test("doc4", "P 91MAb 10");
}

// 

Test(encode_tests, encode01) {
    execute_test("encode01", "E 33 17 17 32769");
}

Test(encode_tests, encode02) {
    execute_test("encode02", "E 63 31 31 65535");
}

Test(encode_tests, encode03) {
    execute_test("encode03", "E 00 00 00 00000");
}

Test(encode_tests, encode04) {
    execute_test("encode04", "E 64 31 31 65535");
}

Test(encode_tests, encode05) {
    execute_test("encode05", "E 12 00 32 00000");
}

Test(encode_tests, encode06) {
    execute_test("encode06", "E 11 00 32 65536");
}

Test(encode_tests, encode07) {
    execute_test("encode07", "E 11 00 32 65536 100 lol");
}

Test(decode_tests, decode01) {
    execute_test("decode01", "D 0x01f11b9d");
}

Test(decode_tests, decode02) {
    execute_test("decode02", "D 0x86318001");
}

Test(decode_tests, decode03) {
    execute_test("decode03", "D 0x04210001");
}

Test(decode_tests, decode04) {
    execute_test("decode04", "D 0x042103e8");
}

Test(decode_tests, decode05) {
    execute_test("decode05", "D 86318001");
}

Test(decode_tests, decode06) {
    execute_test("decode06", "D 0X8631801");
}

Test(decode_tests, decode07) {
    execute_test("decode07", "D 0x863180010");
}

Test(decode_tests, decode08) {
    execute_test("decode08", "D 0x863180010 SBU 2023");
}

Test(poker_tests, poker01) {
    execute_test("poker01", "P 1BSd5");
}

Test(poker_tests, poker02) {
    execute_test("poker02", "P URYW1");
}

Test(poker_tests, poker03) {
    execute_test("poker03", "P 91MAm");
}

Test(poker_tests, poker04) {
    execute_test("poker04", "P 91MAB");
}

Test(poker_tests, poker05) {
    execute_test("poker05", "P ASaBb");
}

Test(poker_tests, poker06) {
    execute_test("poker06", "P 12345");
}

Test(poker_tests, poker07) {
    execute_test("poker07", "P kmjli");
}

Test(poker_tests, poker08) {
    execute_test("poker08", "P =1342");
}

Test(poker_tests, poker09) {
    execute_test("poker09", "P AQaB1");
}

Test(poker_tests, poker10) {
    execute_test("poker10", "P AQaB1 hello");
}

Test(command_tests, invalid_command01) {
    execute_test("invalid_command01", "Deg 0x01f11b9d");
}

Test(command_tests, invalid_command02) {
    execute_test("invalid_command02", "Good Bye 0x01f11b9d");
}

Test(command_tests, invalid_command03) {
    execute_test("invalid_command03", "x 15 23 0x01f11b9d");
}

CPU := $(shell uname -p)
ifeq ($(CPU),arm)
export LD_LIBRARY_PATH=/opt/homebrew/lib/:$LD_LIBRARY_PATH
INCD = -I /opt/homebrew/include/
LIBD = -L /opt/homebrew/lib/
endif

CC := gcc
SRCD := src
TSTD := tests

TESTS := unit_tests

STD := -std=gnu11
TEST_LIB := -lcriterion
LIBS := -lm
CFLAGS += $(STD)
CFLAGS += $(DFLAGS)

TEST_RESULTS := "test_results.json"

$(TSTD)/$(TESTS): $(TSTD)/*.c $(TSTD)/$(TESTS).h
	$(CC) $(TSTD)/*.c $(INCD) $(TEST_LIB) $(LIBD) -o $(TSTD)/$(TESTS) $(LIBS)

test:
	@rm -fr $(TSTD).out
	@mkdir -p $(TSTD).out
	@$(TSTD)/$(TESTS) --full-stats --verbose --json=$(TEST_RESULTS) -j1

clean:
	rm -fr $(TSTD).out $(TSTD)/$(TESTS) $(TEST_RESULTS)

.PHONY: all clean test

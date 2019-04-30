# This is a GNU make makefile.
#
#
SKIP_LIST :=

CXXFLAGS ?= -g -Wall


BINS := $(filter-out $(SKIP_LIST), $(patsubst %.cpp, %, $(wildcard *.cpp)))


# Some programs link with additional libraries:
rx_ascii_art_dft_LDFLAGS := -lncurses
benchmark_streamer_LDFLAGS := -lpthread
benchmark_rate_LDFLAGS := -lboost_thread
network_relay_LDFLAGS := -lboost_thread -lpthread
txrx_loopback_to_file_LDFLAGS := -lboost_filesystem -lboost_thread
test_clock_synch_LDFLAGS := -lboost_thread



UHD_LDFLAGS :=\
 $(shell pkg-config uhd --libs)\
 -Wl,-rpath=$(shell pkg-config uhd --variable=libdir)\
 -lboost_program_options


UHD_CPPFLAGS := $(shell pkg-config uhd --cflags)




build: $(BINS) uhd.tar.gz

$(BINS): %:%.o


print:
	@echo "$(BINS)"


# Rule to make objects
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $(UHD_CPPFLAGS) $< -o $@


$(BINS):
	$(CXX) $(CXXFLAGS) $^ -o $@ $($@_LDFLAGS) $(UHD_LDFLAGS)


clean:
	rm -f *.o $(BINS)


download: uhd.tar.gz

uhd.tar.gz:
	./getFiles.bash
	$(MAKE)


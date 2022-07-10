SDCC=sdcc
SDLD=sdld
FLASH=stm8flash
OBJECTS=blinky.ihx uart.ihx

.PHONY: all clean flash

all: $(OBJECTS)

clean:
	rm -f $(OBJECTS)

flash: $(OBJECT).ihx
	$(FLASH) -c stlinkv2 -p stm8s003?3 -w $(OBJECT).ihx

%.ihx: %.c
	$(SDCC) -lstm8 -mstm8 --out-fmt-ihx $(CFLAGS) $(LDFLAGS) $<

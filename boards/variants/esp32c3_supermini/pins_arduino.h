#ifndef Pins_Arduino_h
#define Pins_Arduino_h

#include <stdint.h>

#define USB_VID 0x303a
#define USB_PID 0x1001

// Leave the on-board GPIO8 LED and any RGB LED unmanaged by Arduino's LED APIs.
static const uint8_t LED_BUILTIN = 255;
#define BUILTIN_LED LED_BUILTIN

static const uint8_t TX = 21;
static const uint8_t RX = 20;

static const uint8_t SDA = 6;
static const uint8_t SCL = 7;

static const uint8_t SS = 7;
static const uint8_t MOSI = 6;
static const uint8_t MISO = 5;
static const uint8_t SCK = 4;

static const uint8_t A0 = 4;
static const uint8_t A1 = 3;
static const uint8_t A2 = 2;
static const uint8_t A3 = 1;
static const uint8_t A4 = 0;

static const uint8_t T0 = 0;
static const uint8_t T1 = 1;
static const uint8_t T2 = 2;
static const uint8_t T3 = 3;
static const uint8_t T4 = 4;
static const uint8_t T5 = 5;

#endif /* Pins_Arduino_h */

#include <Arduino.h>
#include <Wire.h>

#define BNO055_ADDR     0x28   // change to 0x29 if ADDR pin is HIGH
#define REG_CHIP_ID     0x00   // should read 0xA0
#define REG_OPR_MODE    0x3D
#define REG_PWR_MODE    0x3E
#define REG_SYS_TRIGGER 0x3F
#define REG_CALIB_STAT  0x35
#define REG_GYR_X       0x14   // Raw gyro: X, Y, Z (6 bytes, 1 dps = 16 LSB)

#define OPR_CONFIG      0x00
#define OPR_IMUPLUS     0x08   // accel + gyro fusion only, no magnetometer
#define PWR_NORMAL      0x00

#define SDA_PIN         20
#define SCL_PIN         19
#define FLEX_PIN        2
#define FLEX_OFFSET     960

static void bnoWrite(uint8_t reg, uint8_t value) {
    Wire.beginTransmission(BNO055_ADDR);
    Wire.write(reg);
    Wire.write(value);
    Wire.endTransmission();
}

static uint8_t bnoRead(uint8_t reg) {
    Wire.beginTransmission(BNO055_ADDR);
    Wire.write(reg);
    Wire.endTransmission(false);
    Wire.requestFrom((uint8_t)BNO055_ADDR, (uint8_t)1, true);
    return Wire.read();
}

void setup() {
    Serial.begin(115200);
    while (!Serial) delay(10); // wait for USB CDC to enumerate
    Wire.begin(SDA_PIN, SCL_PIN);
    delay(850); // BNO055 needs ~850 ms after power-on before it responds

    // Scan I2C bus and print all responding addresses
    Serial.printf("Scanning I2C bus (SDA=%d, SCL=%d)...\n", SDA_PIN, SCL_PIN);
    uint8_t found = 0;
    for (uint8_t addr = 1; addr < 127; addr++) {
        Wire.beginTransmission(addr);
        if (Wire.endTransmission() == 0) {
            Serial.printf("  Device found at 0x%02X\n", addr);
            found++;
        }
    }
    if (found == 0) Serial.println("  No devices found — check SDA/SCL pins and wiring");

    // Verify chip ID
    uint8_t id = bnoRead(REG_CHIP_ID);
    if (id != 0xA0) {
        Serial.printf("BNO055 not found (chip_id=0x%02X, expected 0xA0)\n", id);
        while (true) delay(1000);
    }
    Serial.println("BNO055 found");

    // Reset
    bnoWrite(REG_SYS_TRIGGER, 0x20);
    delay(650);
    while (bnoRead(REG_CHIP_ID) != 0xA0) delay(10);

    // Configure: normal power, NDOF fusion mode (auto-calibrated)
    bnoWrite(REG_OPR_MODE, OPR_CONFIG);  delay(25);
    bnoWrite(REG_PWR_MODE, PWR_NORMAL);  delay(10);
    bnoWrite(REG_OPR_MODE, OPR_IMUPLUS); delay(25);

    analogReadResolution(12);
}

void loop() {
    // Calibration status (0=uncal, 3=fully cal)
    uint8_t cal = bnoRead(REG_CALIB_STAT);
    uint8_t sys_cal = (cal >> 6) & 0x03;
    uint8_t gyr_cal = (cal >> 4) & 0x03;
    uint8_t acc_cal = (cal >> 2) & 0x03;
    uint8_t mag_cal = cal & 0x03;

    // Raw gyro: X, Y, Z (1 dps = 16 LSB)
    Wire.beginTransmission(BNO055_ADDR);
    Wire.write(REG_GYR_X);
    Wire.endTransmission(false);
    Wire.requestFrom((uint8_t)BNO055_ADDR, (uint8_t)6, true);
    int16_t gx = Wire.read() | (Wire.read() << 8);
    int16_t gy = Wire.read() | (Wire.read() << 8);
    int16_t gz = Wire.read() | (Wire.read() << 8);

    int flex_raw = analogRead(FLEX_PIN) - FLEX_OFFSET;

    Serial.printf(
        "CAL(sys:%d gyr:%d acc:%d mag:%d)  |  GX:%8.2f  GY:%8.2f  GZ:%8.2f  |  FLEX:%4d\n",
        sys_cal, gyr_cal, acc_cal, mag_cal,
        gx / 16.0f, gy / 16.0f, gz / 16.0f,
        flex_raw
    );

    delay(50); // ~20 Hz
}

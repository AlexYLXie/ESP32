import machine, time, neopixel, random

# Set up onboard RGB LED pin
rgb_pin = machine.Pin(18)
RGB_LED = neopixel.NeoPixel(rgb_pin, 1)

try:
    while True:
        # Set random RGB value
        red = random.randint(0, 129)
        green = random.randint(0, 129)
        blue = random.randint(0, 129)
        RGB_LED[0] = (red, green, blue)
        RGB_LED.write()
        time.sleep_ms(50)
        
except KeyboardInterrupt:
    # Reset onboard RGB LED
    RGB_LED[0] = (0, 0, 0)
    RGB_LED.write()

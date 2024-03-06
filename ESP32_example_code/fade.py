from machine import PWM, Pin
import utime

brightness = 0
fadeAmount = 1

led = PWM(Pin(5))
led.freq(60)

while True:
    led.duty(brightness)
    brightness += fadeAmount
    if (brightness <= 0 or brightness >= 1023):
        fadeAmount = -fadeAmount   
    utime.sleep_ms(1)

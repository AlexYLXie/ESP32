from machine import Pin
import utime

led = Pin(4, Pin.OUT)
led_onboard = Pin(2, Pin.OUT) 

while(True):
    led_onboard.on()
    utime.sleep(1)
    led.on()
    utime.sleep(1)
    led_onboard.off()   
    led.off()
    utime.sleep(1)
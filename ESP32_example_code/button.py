from machine import Pin
import utime

led = Pin(5, Pin.OUT)                 
switch = Pin(18, Pin.IN)
button_state = 0
while True:
    if switch.value()==1:
        if led.value()==1:
            led.value(0)
            utime.sleep_ms(150)
        elif led.value()==0:   
            led.value(1)
            utime.sleep_ms(150)



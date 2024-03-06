from machine import ADC,Pin,Timer
import time
import pressure_read

#pressure_read.pressure_read

tim1=Timer(1)
tim1.init(period=5, mode=Timer.PERIODIC, callback=pressure_read) #設定成週期性觸發，每5ms觸發一次

try:
    while 1: 
        pass #空迴圈
except:
    tim1.deinit()
    print('stopping')
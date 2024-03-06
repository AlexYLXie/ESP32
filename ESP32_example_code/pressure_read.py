import machine
import time

# 設定UART通訊介面
uart = machine.UART(1, baudrate=115200)  # 假設已設定好UART通訊介面

# 讀取壓力值
adc0 = machine.ADC(2)

def pressure_read():
    # 讀取壓力值
    pressure_value = adc0.read()

    # 將壓力值轉換為字串
    pressure_str = f'{pressure_value:04d}'

    # 透過UART傳輸字串
    print('P' + pressure_str)
    uart.write('P' + pressure_str + '\n')  # 在字串末尾添加換行符以便接收端識別結束

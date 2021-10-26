from digitemp.master import UART_Adapter
from digitemp.device import AddressableDevice
from digitemp.device import DS18B20

NAME = "[read_uart.py] "

if __name__ == "__main__":
    # J44 header name
    device_name = "/dev/ttyTHS1"
    print(f"{NAME} [DEBUG]\t\tReading src: {device_name}")

    # device_name = "/dev/ttyS0"
    try:
        bus = UART_Adapter(device_name)
        print(f"{NAME} [DEBUG]\t\tBus found")
    except Exception as bus_error:
        print(f"{NAME} [BUS_ERROR]\t{bus_error}")

    try:
        print(f"{NAME} [DEBUG]\t\tGetting sensor information ...")
        sensor = DS18B20(bus)
        sensor.info()
        print(f"{NAME} [DEBUG]\t\ttemperature: {sensor.get_temperature()}")
    except Exception as sensor_error:
        print(f"{NAME} [SENSOR_ERROR]\t{sensor_error}")

    print(f"{NAME} [DEBUG]\t\tExiting program")

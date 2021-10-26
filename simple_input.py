#!/usr/bin/env python

import RPi.GPIO as GPIO
import time

# Pin Definitions
# BCM pin-numbering scheme from Raspberry Pi





def main(pin, MODE=GPIO.BCM):
    selected_pin = pin
    prev_value = None

    # Pin Setup:
    GPIO.setmode(MODE)
    GPIO.setup(selected_pin, GPIO.IN)  # set pin as an input pin
    print("Starting demo now! Press CTRL+C to exit")
    counter = 0
    try:
        while counter < 20:
            value = GPIO.input(selected_pin)
            if value != prev_value:
                print(f"[pin {pin}] value ({counter}): {value}")
                prev_value = value
            else:
                print(f"[pin {pin}] value ({counter}): {prev_value}")

            time.sleep(0.1)
            counter += 1

    finally:
        GPIO.cleanup()


if __name__ == '__main__':

    import sys
    if len(sys.argv) != 2:
        print("ArgumentError: len(sys.argv) != 2")
        print(f"Example usage: {sys.argv[0]} <board_pin_number>")
        print(f"Example usage: {sys.argv[0]} 8 ")

    selected_pin = int(sys.argv[1])
    main(pin=selected_pin)

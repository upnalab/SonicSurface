import serial
import time

# Open the serial port
ser = serial.Serial('COM7', 115200)
WAIT = 0.05

try:
    while True:
        # Send '0'
        ser.write(b'0\n')
        ser.flush()
        print("Sent: 0")
        time.sleep(WAIT)
        
        # Send '1'
        ser.write(b'1\n')
        ser.flush()
        print("Sent: 1")
        time.sleep(WAIT)
        
except KeyboardInterrupt:
    # Exit the loop when Ctrl+C is pressed
    print("Exiting program")
    
finally:
    ser.write(b'0\n')
    # Close the serial port
    ser.close()

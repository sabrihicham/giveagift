#!/usr/bin/env python

import time
from serial import Serial
import pickle
import sys
import os

class Calibrator:
    ''' Rudimentary Calibrator class to read digital values sent by Arduino
    over a serial connection and store them for classification with live data.

    Prompts the user to move their eyes to different positions in sequential order.
    Uses values acquired at different positions to populate a dictionary with
    keys as eye positions and values as the corresponding set of values acquired.

    The larger the dataset (user preference), the more accurate the classification.'''

    # The dictionary of positions:values for serialization.
    positions = {
        'BLINK': [],
        'UP': [],
        'RIGHT': [],
        'DOWN': [],
        'LEFT': [],
        'STRAIGHT': []
    }

    def __init__(self):
        # Prompt the user to enter preferred size of dataset until valid integer is input. 
        while True:
            try:
                self.maxVal = int(input("How many values per dataset? "))
                break
            except ValueError:
                print('Enter valid integer value.')
                continue

        # If dataset exists already, ask for confirmation to overwrite.
        if os.path.exists('datasets.p'):
            calAgain = input('Calibrated dataset exists already. Recalibrate? (y(default)/n): ')
            if calAgain.lower() == 'n':
                return
            else:
                pass

        self.calibrate(self.maxVal)
        self.store(self.positions)

    def countdown(self, bufferTime=3, printCount=True):
        ''' Countdown to help in stabilizing values
        received over the USB port before calibrating.
        Default countdown is 3 seconds. '''
        while bufferTime > 0:
            if printCount:
                print(bufferTime)
            time.sleep(1)
            bufferTime -= 1

        return True

    def openSerialPort(self, port, baudrate):
        ''' Open a serial connection at port "port"
        and baud rate "baudrate". Return the
        connection object. '''
        s = Serial(port, baudrate)
        return s

    def calibrate(self, upper):
        ''' Main calibration function to build the
        dataset and serialize it to a Pickle.
        upper - The size of the dataset entered by the user. '''
        serialObj = self.openSerialPort('COM9', 9600)

        print('Stabilizing serial data')
        self.countdown()

        # Iterate through eye positions and prompt the user
        # to move their eyes correspondingly for calibrating.
        for pos in self.positions.keys():
            print(f'Make the following eye gesture: {pos}')
            self.countdown()

            i = 0
            while i < upper:
                try:
                    # Parse out (split around comma) the values into left electrode signal value l
                    # and right electrode signal value r, gotten from the Arduino,
                    # getting rid of the cruft.
                    arr = serialObj.readline().strip(b'\x00\r\n').strip().decode().split(',')
                    # Append values to corresponding position in the dataset.
                    self.positions[pos].append((float(arr[0]), float(arr[1])))
                except Exception as e:
                    print(f'Error: {e}')
                    continue

                i += 1

            goAhead = input('Continue? (y(default)/n) ')

            if goAhead.lower() == 'n':
                sys.exit(0)
            else:
                continue

            # Clear input buffer.
            serialObj.flushInput()

        # Close serial port.
        serialObj.close()

    def store(self, dataset):
        ''' Serialize the dataset to a pickle. '''
        with open('datasets.p', 'wb') as f:
            pickle.dump(dataset, f)

    def read(self):
        ''' Read the dataset from the pickle. '''
        with open('datasets.p', 'rb') as f:
            return pickle.load(f)

if __name__ == "__main__":
    a = Calibrator()

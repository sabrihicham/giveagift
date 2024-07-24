from serial import Serial  # Install with 'pip install pyserial'
import time
import pandas as pd  # Install with 'pip install pandas'

# Serial Connection Setup
# Replace 'COM3' with the correct serial port for your Arduino.
# You can use python -m serial.tools.list_ports to find the correct port.
port = '/dev/cu.sichiray'  # Replace with your Arduino's port
baudrate = 57600  # TGAM baud rate
ser = Serial(port, baudrate)
time.sleep(2)  # Give the connection time to settle

# Data Storage
data = []  # List to store EEG samples

# Data Collection Function: Collects EEG data for a given duration
def collect_data(label, duration=5):  # 5 seconds per action
    global data
    print(f'Start performing action: {label}')
    
    eeg_data = ser.readline().decode('utf-8').strip()
    

    start_time = time.time()
    while time.time() - start_time < duration:
        # You are capturing the raw EEG values under the tag $EEGRAW:. Adjust if your data format is different.
        eeg_data = ser.readline().decode('utf-8').strip()
        if eeg_data.startswith("$EEGRAW:"):
            raw_values = eeg_data.split(":")[1].split(",")
            values = [float(x) for x in raw_values]  # Convert to floats
            values.append(label)  # Append label to data
            data.append(values)
    print(f'Finished collecting for {label}')
    

# Main Loop (Data Collection): Collects data for each action
actions = ['CLOSE', 'OPEN', 'UP', 'DOWN', 'RIGHT', 'LEFT']
trials_per_action = 5  # Number of trials per action

for action in actions:
    for _ in range(trials_per_action):
        collect_data(action)
        time.sleep(2)  # Short rest between trials
        
# Saving the Dataset
columns = [f'Channel_{i}' for i in range(1, 6)] + ['Label'] # Assuming 5 channels
df = pd.DataFrame(data, columns=columns)
df.to_csv('eeg_dataset.csv', index=False)
print('Dataset saved as eeg_dataset.csv')

# Logger BLDC Vibration and Phase-Current Monitoring - User Package

This repository provides a ready-to-use solution for capturing vibration data (6DoF IMU sensor) and three phase currents from a high-speed BLDC motor, as well as controlling a BLDC inverter using an UART commands applayed by Matlab script. It supports manual or automatic recording under varying operational conditions and allows applying inverter faults (open switch faults with transistor combinations from 0 to 63). It is designed for end users who want to quickly flash the firmware, log sensor data, and visualize it in MATLAB without modifying source code.

## Contents
- **Firmware:**
  - `firmware/currents_and_IMU6DoF_logger.hex` - Precompiled STM32 firmware for BLDC vibration and phase-current logging
  - `firmware/bldc_electronic_speed_controller_B-G431B-ESC1.hex` - Precompiled firmware for B-G431B-ESC1 which is an electronic speed controller (ESC).
- **Documentation:**
  - `docs/flashing.md` - Step-by-step flashing guide for STM32CubeProgrammer
  - `docs/uart_setup.md` - Instructions to set up UART connection on Windows
  - `docs/verify_data.md` - Guide to recording and visualizing IMU and current data
  - `docs/bldc_high_speed_rig_instruction.pdf` - Data collection instruction for a rig with high-speed bldc motor and a drone propeller
- **Tools:**
  - `tools/record_data.m` - MATLAB script to log IMU and phase-current data from UART
  - `tools/record_auto_conditions_data.m` - MATLAB script to log IMU and phase-current data from UART with automatic conditions change
  - `tools/plot_data.m` - MATLAB script to plot accelerometer, gyroscope, and current data
  - `tools/plot_all_data.m` - MATLAB script to plot and save all accelerometer, gyroscope, and current data from dataset
- **Examples:**
  - `dataset/examples/bldc_high_speed_fault1_speed4000_2025-08-20-11-02-10.txt` - Example log with fault type 1 at 4000 RPM, recorded on 2025-08-20 11:02:10
  - `dataset/examples/bldc_high_speed_fault0_speed4000_2025-08-20-11-01-32.txt` - Example log with fault type 0 (no fault) at 4000 RPM, recorded on 2025-08-20 11:01:32


## Getting Started

### 1. Flash the Firmware
- Connect your STM32 board to your PC via USB.
- Use STM32CubeProgrammer to flash the firmware:
  - For vibration and current logging: `firmware/bldc_logger.hex`
  - For inverter control: `firmware/bldc_inverter_b-g431b-esc1.hex`
- For detailed steps, see [`docs/flashing.md`](./docs/flashing.md).

### 2. Setup UART Connection
- Identify your COM port on Windows: open Device Manager → Ports (COM & LPT).
- Look for an STLink Virtual COM Port or equivalent.
- Use these serial settings:
  - Baud rate: 2250000
  - Data bits: 8
  - Parity: None
  - Stop bits: 1
  - Flow control: None
- More details in [`docs/uart_setup.md`](./docs/uart_setup.md).

### 3. Record IMU and Phase-Current Data
Open MATLAB and run the logger script to record data from the UART port. Recording can be set manually or configured to automatically change operational conditions and apply inverter faults.

For detailed steps, see [`docs/verify_data.md`](./docs/verify_data.md).

### 4. Visualization
Change folder to **tools** and use the provided plotting script to visualize accelerometer, gyroscope, and phase-current data:

```matlab
plot_data('../dataset/examples/bldc_high_speed_fault1_speed4000_2025-08-20-11-02-10.txt', 10000)
```
Parameters:
- file_name (string): The name of the file containing the data to be plotted.
- max_samples (integer): The maximum number of samples to plot from the data. Use full length if max_samples is -1 or less

To plot all data from a dataset and save the plots use the following script:
```matlab
plot_all_data
```

## Notes
- Start with low motor RPMs to ensure safe data logging.
- Ensure the IMU is rigidly mounted to accurately capture high-frequency BLDC vibrations.
- Use inverter fault injection cautiously; ensure safety measures are in place.

## Repository Structure

```
bldc-high-speed-user/
├── firmware/
│   ├── currents_and_IMU6DoF_logger.hex
│   └── bldc_electronic_speed_controller_B-G431B-ESC1.hex
├── docs/
│   ├── bldc_high_speed_rig_instruction.pdf
│   ├── flashing.md
│   ├── uart_setup.md
│   └── verify_data.md
├── tools/
│   ├── record_data.m
│   ├── record_auto_conditions_data.m
│   ├── plot_data.m
│   ├── plot_all_data.m
├── dataset/
│   └── examples/
|       ├── bldc_high_speed_fault1_speed4000_2025-08-20-11-02-10.txt
|       └── bldc_high_speed_fault0_speed4000_2025-08-20-11-01-32.txt
├── plot/
│   └── examples/
│       ├── samples_1000_bldc_high_speed_fault0_speed4000_2025-08-20-11-01-32.jpg
│       ├── samples_1000_bldc_high_speed_fault1_speed4000_2025-08-20-11-02-10.jpg
│       ├── samples_all_bldc_high_speed_fault0_speed4000_2025-08-20-11-01-32.jpg
│       └── samples_all_bldc_high_speed_fault1_speed4000_2025-08-20-11-02-10.jpg
└── README.md
```

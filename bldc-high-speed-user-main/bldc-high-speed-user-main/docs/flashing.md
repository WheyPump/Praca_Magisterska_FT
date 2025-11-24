# Flashing Guide for BLDC Logger and Inverter Firmware

This document provides step-by-step instructions to flash the STM32-based BLDC vibration and current logger firmware, as well as the B-G431B-ESC1 inverter control firmware, using **STM32CubeProgrammer**.

## Requirements

- **Hardware**
  - STM32 development board (for logger firmware)
  - B-G431B-ESC1 inverter board (for inverter firmware)
  - USB cable (ST-Link interface or onboard USB)
  - Windows PC

- **Software**
  - [STM32CubeProgrammer](https://www.st.com/en/development-tools/stm32cubeprog.html)

## 1. Install STM32CubeProgrammer

1. Download and install **STM32CubeProgrammer** from STMicroelectronics.  
2. After installation, verify that **STM32CubeProgrammer** can detect your connected board.

## 2. Connect Your Board

- For **logger firmware**:  
  Connect your STM32 board to the PC using USB. Ensure the board is powered.  

- For **inverter firmware (B-G431B-ESC1)**:  
  Connect the board using ST-Link USB. Ensure the board is powered.

- **Important**: 
  -  To avoid flashing the wrong firmware, do not connect both boards to your computer at the same time.

## 3. Flash Firmware

1. Open **STM32CubeProgrammer**.  
2. Select the connection interface:  
   - `ST-LINK` (preferred for most STM32 boards and the B-G431B-ESC1)  
   - `USB`
3. Click **Connect**.  
4. In the **Erasing & Programming** tab:  
   - Click **Browse** and select the firmware `.hex` file you want to flash:  
     - `firmware/bldc_logger.hex` → Logger firmware for vibration & phase-current data acquisition  
     - `firmware/bldc_inverter_b-g431b-esc1.hex` → Inverter firmware for BLDC motor control and fault injection  
   - Check **Verify programming** for confirmation.  
5. Click **Start Programming**.  
6. Wait for the success confirmation message.

## 4. Verify Flashing

- Unplug and plug power to restart the device.

- For **logger firmware**:  
  - Open a serial terminal (or MATLAB `record_data.m`) on the configured COM port.  
  - Ensure the device streams IMU and current data at the specified baud rate.  

- For **inverter firmware**:  
  - Power up the BLDC motor setup.  
  - Open MotorPilot (or MATLAB `record_auto_conditions_data.m`) on the configured COM port.  
  - Verify motor rotation and check that faults/conditions can be triggered as configured.  

## 5. Notes
- Always flash the correct `.hex` file for your board.
- If flashing fails:  
  - Check jumpers/boot pins (set to **Normal Boot**).  
  - Try erasing memory fully before reprogramming.  
- For inverter fault injection testing, ensure **safety shields and protection circuits** are in place.  

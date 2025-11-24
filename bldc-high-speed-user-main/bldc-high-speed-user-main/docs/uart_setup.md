# UART Setup Guide for Windows

This document explains how to configure the UART connection between the STM32 logger board and your Windows PC.

## 1. Identify COM Port

1. Connect your STM32 logger board via USB.  
2. Open **Device Manager** → Ports (COM & LPT).  
3. Look for **STLink Virtual COM Port** (or similar).  
4. Note the COM port number (e.g., `COM3`).  

## 2. UART Settings

Configure your serial terminal or MATLAB script with the following settings:

- Baud rate: **2250000**  
- Data bits: **8**  
- Parity: **None**  
- Stop bits: **1**  
- Flow control: **None**  

## 3. Test Connection

- Open a serial terminal (e.g., BryTerminal, PuTTY, Tera Term).  
- Select the identified COM port and apply the settings above.  
- You should see a data stream from the logger if the firmware is running.  

## 4. Troubleshooting

- If the port does not appear, reinstall **STLink drivers**.  
- Ensure no other program is using the COM port.  
- Try a different USB cable/port if connection fails.  

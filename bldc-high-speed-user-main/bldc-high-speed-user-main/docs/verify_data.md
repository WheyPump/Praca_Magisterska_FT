# Data Recording and Verification Guide

This document explains how to record and visualize IMU and phase-current data from the BLDC logger, and how to apply inverter faults during operation.

## 1. Recording Data in MATLAB

Use the provided script to log IMU and phase-current data:

```matlab
record_data(output_folder, 'COM3', record_duration_in_seconds, used_speed, used_fault)
```
- output_folder → Folder where the output file will be saved
- COM3 → Replace with your actual COM port (e.g., COM4).
- record_duration_in_seconds → Logging time window for the experiment (e.g., 10 for 10 seconds).
- used_speed → Used motor speed in RPM. Reference speed must be applied in MotorPilot or use **record_auto_conditions_data.m**.
- used_fault → Inverter fault index (0–63) used for data file name generation, where 0 is for no fault. Fault must be applied in MotorPilot or use **record_auto_conditions_data.m**.

## 2. Applying Faults

- In **auto mode**, the logger will cycle through predefined operating conditions and apply inverter faults.  
- Open switch faults are supported for all transistor combinations (0–63). However some will lead to stop motor operation.  
- Fault injection sequence and record duration can be customized in Matlab script.

## 3. Visualizing Data

After recording, use the provided plotting script to visualize:

```matlab
plot_data('data.txt', 10000)
```
- Phase currents (IA, IB, IC)
- Accelerometer (X, Y, Z)
- Gyroscope (X, Y, Z)

MATLAB script to plot and save all figures of currents data from dataset folder set in script

```matlab
plot_all_data
```


## 4. Example Data

A sample dataset is provided in `dataset/examples/` for testing the MATLAB scripts.

## 5. Notes

- Use caution when applying inverter faults; always follow safety procedures.  
- Ensure the motor and inverter are securely mounted before testing.  
- **Important**: If logging at very high speeds follow safety procedures. Ensure no one is near the motor.



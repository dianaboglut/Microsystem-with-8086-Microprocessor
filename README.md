# Microsystem-with-8086-Microprocessor
This project involves designing a microsystem using the 8086 microprocessor along with various interfacing circuits and peripheral components. The system will include multiple memory units, serial and parallel interfaces, a mini keyboard, LEDs, and a 7-segment display. The assembly programs for this microsystem will be written as subroutines for efficient operation and modularity.
## System Components
1. Central Unit (8086 Microprocessor): The core of the system, responsible for executing instructions and controlling all other components.
2. Memory:
   - 256 KB EPROM (using 27C2048 circuits).
   - 64 KB SRAM (using 62512 circuits).
3. Interfaces:
   - Serial Interface: Managed by the 8251 circuit, providing communication with external devices. Its address is configurable depending on the micro-switch position (either 0AF0H – 0AF2H or 0BF0H – 0BF2H).
   - Parallel Interface: Managed by the 8255 circuit, allowing parallel communication with other devices. Its address is configurable depending on the micro-switch position (either 0D70H – 0D76H or 0C70H – 0C76H).
4. Peripheral Devices:
   - Mini Keyboard with 12 contacts to receive user input.
   - LEDs (10 LEDs) to provide visual feedback for the system’s status or other operations.
   - 7-Segment Display: A 6-digit module for displaying hexadecimal characters.

## Assembly Routines
The system will use assembly language subroutines to handle the following tasks:

1. Programming Routines for 8251 and 8255 Circuits: Configuring and managing the communication protocols for serial and parallel interfaces.
2. Serial Communication Routines: Emission/Reception of Characters via the serial interface.
3. Parallel Communication Routine: Emitting characters via the parallel interface.
4. Mini Keyboard Scanning Routine: Reading input from the mini keyboard (12 contacts).
5. LED Control Routine: Turning LEDs ON/OFF based on system requirements.
6. 7-Segment Display Routine: Displaying hexadecimal characters on the 7-segment display.

![UnitateaCentrala](https://github.com/user-attachments/assets/cbb2cbd1-699e-411c-9968-9c791aab06c0)
![ConectMem](https://github.com/user-attachments/assets/4d69cc39-2b6d-4d33-afbd-d6f306e36961)
![DECpORT](https://github.com/user-attachments/assets/29f9ccde-1538-4066-8d82-561358291585)
![leduri](https://github.com/user-attachments/assets/7a93ce92-95f2-4a59-a3b5-8210dd4ec68d)
![afis](https://github.com/user-attachments/assets/8710defc-fc11-4829-b5a7-2a5cc1d16abb)
![tastatura](https://github.com/user-attachments/assets/890806f6-01b3-4ce2-909e-ad11a243bfed)

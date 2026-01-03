FDAH – Light-Based Window Control System (OPT3001 + FPGA)

This project implements a light-controlled window system using an OPT3001 ambient light sensor, a microcontroller, and an FPGA.

Ambient light intensity is measured by the OPT3001 sensor connected to the microcontroller. The sensor data is then transferred through the FPGA, which processes the control logic. Based on the measured light level, a servo motor connected to the microcontroller adjusts the position of a window mechanism.

The system supports two modes of operation:

Automatic Mode – The window position is adjusted automatically according to ambient light intensity.

Manual Mode – The user manually controls the window position.

This project demonstrates reliable sensor data acquisition, FPGA-based data handling, and microcontroller-driven servo actuation, forming a complete sensing-to-motion embedded control system.

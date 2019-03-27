# Pressure-sensing-insole



A measuring and visualization code for a pressure sensing insole using FSR sensors, written in arduino IDE and processing.
~Foot (Arduino IDE)
Code that measures pressure from 5 different FSR sensors, processes them through an arduino lilypad and translates them from voltage in Newton values between 0N-100N.

~FootGraphics (Processing)
The code to visualize the data from the five sensors in real time. It uploads a foot image as a canvas and by communicating with the Foot code using its IDE, it visualizes the pressure of its sensor in real time. The applied pressure, changes the size and colour of five circles placed in the canvas, accordingly.

~FootGraphics2 (Processing)
Code to analyze the data of FootGraphics. Creates an interface to scroll through the duration of a measurement and analyze the data of each sensor.


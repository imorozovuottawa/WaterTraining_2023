/*******************************************
 Water Training Main Module Rev.0.3
 Irina Morozov
 12 January 2018
 Rev.0.2 - Optical Lickometer by Sanworks deliver liquid rewards.
 Optical Lickometer contains a photogate positioned to measure 
 when beam-break occures
/*********************************************/
//Include the Wire library, to allow communication with I2C devices
#include <Wire.h>
//Pins used on the Arduino Uno
//SDA(data line) is only the A4 pin
//SCL(clock line) is only the A5 pin

//initialize variables
int mode = -1;
int solenoidPin = 4;
int TailShockPin = 7;
int IR_LED_PIN = 12;
int TestLED = 13;

void setup() {
  // initialize serial communication at 9600 bps:
  Serial.begin(9600);
  
  //check serial communication - acknowledgement routine
  Serial.println('a'); // sending a charachter to PC
  char a = 'b';
  while (a != 'a')
  {
    //Wait for a specific character from the PC
    a = Serial.read();
  }
  
  //Initiate the Wire library and join the I2C bus as master
  Wire.begin();
  pinMode(solenoidPin, OUTPUT); // Sets the pin as an output
  pinMode(IR_LED_PIN,INPUT);
  pinMode(TestLED, OUTPUT);
  digitalWrite(IR_LED_PIN, HIGH); // Turn on IR LED
 
}

void loop() {
  // Beam-Breaks
  if  (digitalRead(IR_LED_PIN) == 1)  //Beam is Broken
  {
    digitalWrite(TestLED, HIGH);
  }
  else 
  {
    digitalWrite(TestLED, LOW);
  }  
  
  // if there's any serial available, read it:
  if(Serial.available()> 0)//check is any data has been sent by the PC
  {
    //look for the next valid integer in the incoming serial stream: 
    mode = Serial.read();
    
    switch (mode)//used to set different modes from various operations
    {
      case 'A':
        Wire.beginTransmission(5); //transmit to device #5
        Wire.write(mode); //send mode 'A' - Play Start Sound 
        Wire.endTransmission(); // stop transmitting
      break; 

      case 'S':
        Wire.beginTransmission(5); //transmit to device #5
        Wire.write(mode); //send mode 'S' - Stop to Play Start Sound 
        Wire.endTransmission(); // stop transmitting
      break;
      
      case 'H': 
        digitalWrite(solenoidPin, HIGH); //Switch Solenoid ON
        //delay (100);
      break;
    
      case 'L':
        digitalWrite(solenoidPin, LOW); //Switch Solenoid OFF
       // delay (100);
      break;
      
      }
    }
  }



       

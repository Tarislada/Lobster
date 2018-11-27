#include <Servo.h> 
#include <Arduino.h>

// two HM-1301W motors
Servo myservo1;
Servo myservo2;
 
const int PIN_ATTACK_OUT = 12;
const int PIN_PURGE_IN = 2;
const int PIN_ATTACK_ORDER_IN = 4;

const int PIN_SERVO1 = 9;
const int PIN_SERVO2 = 6;

void setup() 
{
  pinMode(PIN_ATTACK_ORDER_IN, INPUT);
  pinMode(PIN_ATTACK_OUT, OUTPUT);
  digitalWrite(PIN_ATTACK_OUT,LOW);
  
  pinMode(PIN_PURGE_IN, INPUT);

  myservo1.attach(PIN_SERVO1);
  myservo2.attach(PIN_SERVO2);  
} 
 
void loop() 
{

  fixState = 


  if(digitalRead(PIN_ATTACK_ORDER_IN) == LOW) // calm
  {
    digitalWrite(PIN_ATTACK_OUT,LOW);
    // Initial State : sets the servo position according to the scaled value
    myservo1.write(60);
    myservo2.write(145);
  }
  else // attack!
  {
    // Send Attack Info
    digitalWrite(PIN_ATTACK_OUT,HIGH);

    // Perform Attack
    myservo1.write(105);               
    myservo2.write(105);
    delay(170);
    myservo1.write(60);  
    myservo2.write(145);
    delay(230);
    myservo1.write(105);               
    myservo2.write(105);
    delay(170);
    myservo1.write(60);
    myservo2.write(145);
    delay(230);

    // Send Attack Info
    digitalWrite(attackPin,LOW);
  }

  // Purge Motor incase of stuck
  if(digitalRead(PIN_PURGE_IN) == HIGH)
  {
    for(int pos1 = 60; pos1 <= 85; pos1 += 1) 
    {
      myservo1.write(pos1);
      delay(15);
    }
    for(int pos1 = 85; pos1 >= 60; pos1 -= 1) 
    {
      myservo1.write(pos1);
      delay(15);
    }
    for(int pos2 = 145; pos2 >= 125; pos2 -= 1)
    {
      myservo2.write(pos2);
      delay(15);
    }

    for (pos2 = 125; pos2 <= 145; pos2 += 1)
    {
      myservo2.write(pos2);
      delay(15);
    }
  }
}

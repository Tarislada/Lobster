#include <Servo.h> 
 
const int PIN_ATTACK_IN = 9;
const int PIN_ATTACK_OUT = 10;

const int PIN_SERVO1 = 12; // Left 
const int PIN_SERVO2 = 11; // Right

const int PIN_SERVO_ON = 13;

Servo myservo1;
Servo myservo2;

void setup() 
{
  pinMode(PIN_ATTACK_IN, INPUT);
  pinMode(PIN_ATTACK_OUT, OUTPUT);
  pinMode(PIN_SERVO_ON, OUTPUT);

  digitalWrite(PIN_ATTACK_OUT,LOW);

  // initialize motor
  myservo1.attach(PIN_SERVO1);
  myservo2.attach(PIN_SERVO2);

  digitalWrite(PIN_SERVO_ON, HIGH);
  myservo1.write(60);
  myservo2.write(145);
  delay(100);
  digitalWrite(PIN_SERVO_ON, LOW);
} 
 
void loop() 
{
  if(digitalRead(PIN_ATTACK_IN) == HIGH) // Attack
  {
    // Send Attack Info to TDT
    digitalWrite(PIN_ATTACK_OUT,HIGH);

    // Perform Attack
    attack();

    // Send Attack Info
    digitalWrite(PIN_ATTACK_OUT,LOW);
  }
}

void attack()
{
  digitalWrite(PIN_SERVO_ON, HIGH);
  delay(10);
  myservo1.write(90);               
  myservo2.write(115);
  delay(170);
  myservo1.write(60);  
  myservo2.write(145);
  delay(230);
  myservo1.write(90);               
  myservo2.write(115);
  delay(170);
  myservo1.write(60);
  myservo2.write(145);
  delay(230);
  digitalWrite(PIN_SERVO_ON, LOW);
}



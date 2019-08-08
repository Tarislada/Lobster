#include <Servo.h> 
 
const int PIN_ATTACK_IN = 9;
const int PIN_ATTACK_OUT = 10;

const int PIN_SERVO1 = 12; // Left 
const int PIN_SERVO2 = 11; // Right

void setup() 
{
  pinMode(PIN_ATTACK_IN, INPUT);
  pinMode(PIN_ATTACK_OUT, OUTPUT);

  digitalWrite(PIN_ATTACK_OUT,LOW);

  Serial.begin(9600);

  // initialize motor
  setServoAngle(PIN_SERVO1, 60);
  setServoAngle(PIN_SERVO2, 145);
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

void setServoAngle(int pin, int angle)
{
  Servo s;
  s.attach(pin);
  s.write(angle);
  delay(100);
  s.detach();
}

void attack()
{
    Servo myservo1;
    Servo myservo2;
    myservo1.attach(PIN_SERVO1);
    myservo2.attach(PIN_SERVO2);

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
    myservo1.detach();
    myservo2.detach();
}
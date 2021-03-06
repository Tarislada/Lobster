#include <Servo.h> 

const int PIN_ATTACK_IN_MANUAL = 8; 
const int PIN_ATTACK_IN = 9;
const int PIN_ATTACK_OUT = 10;

const int PIN_SERVO1 = 12; // Left 
const int PIN_SERVO2 = 11; // Right

const int PIN_SERVO_ON = 13;

Servo myservo1;
Servo myservo2;

void setup() 
{
  Serial.begin(9600);
  pinMode(PIN_ATTACK_IN, INPUT);
  pinMode(PIN_ATTACK_OUT, OUTPUT);
  pinMode(PIN_SERVO_ON, OUTPUT);

  digitalWrite(PIN_ATTACK_OUT,LOW);

  // initialize motor
  myservo1.attach(PIN_SERVO1);
  myservo2.attach(PIN_SERVO2);

  digitalWrite(PIN_SERVO_ON, HIGH);
  delay(50);
  myservo1.write(60);
  myservo2.write(145);
  delay(200);
  digitalWrite(PIN_SERVO_ON, LOW);
} 
 
void loop() 
{
  if(digitalRead(PIN_ATTACK_IN) == HIGH || digitalRead(PIN_ATTACK_IN_MANUAL) == HIGH) // Attack
  {
    // Send Attack Info to TDT
    digitalWrite(PIN_ATTACK_OUT,HIGH);

    // Perform Attack
    Serial.println("attack");
    attack();

    // Send Attack Info
    digitalWrite(PIN_ATTACK_OUT,LOW);
  }
}

void attack()
{
  digitalWrite(PIN_SERVO_ON, HIGH);
  delay(50);
  myservo1.write(100);               
  myservo2.write(105);
  delay(200);
  myservo1.write(60);  
  myservo2.write(145);
  delay(200);
  myservo1.write(100);               
  myservo2.write(105);
  delay(200);
  myservo1.write(60);
  myservo2.write(145);
  delay(200);
  digitalWrite(PIN_SERVO_ON, LOW);
}



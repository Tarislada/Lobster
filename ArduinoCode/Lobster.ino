// two HM-1301W motors
#include <Servo.h> 
 
Servo myservo1;
Servo myservo2;// create servo object to control a servo 
 

#include <Arduino.h>






//int beam = 7;
//int beamState=0;
int attackPin = 12;
int fixPin = 2;




int attackOrderPin = 4;

int attackState = 0;
int fixState = 0;

int pos1 = 0;
int pos2 = 0;



void setup() 
{ 
 //pinMode(beam, INPUT);
 pinMode(attackPin, OUTPUT);
 pinMode(attackOrderPin, INPUT);
 pinMode(fixPin, INPUT);



   
  myservo1.attach(9);  // attaches the servo on pin 9 to the servo object 
  myservo2.attach(6);
 
  
    
} 
 
void loop() 
{ 


attackState = digitalRead(attackOrderPin);
fixState = digitalRead(fixPin);



if(attackState == 0)
   {
   
    digitalWrite(attackPin,LOW);
  
    myservo1.write(60);                 // sets the servo position according to the scaled value 
    myservo2.write(145);
   }

  

  
  



  
 
        
    if (attackState == 1)
   {
          
    digitalWrite(attackPin,HIGH); // attack!
    
    myservo1.write(105);               
    myservo2.write(105);


    delay(170);

   
    
    myservo1.write(60);                 // 
   myservo2.write(145);

    delay(230);


   
    
   myservo1.write(105);               
    myservo2.write(105);

    delay(170);

    

    
    myservo1.write(60);                 // 
    myservo2.write(145);
    delay(230);


    digitalWrite(attackPin,LOW);
    attackState = 0;
    
     }
     


    

 if (fixState == 1)

 {
  for (pos1 = 60; pos1 <= 85; pos1 += 1) { // goes from 0 degrees to 180 degrees
    // in steps of 1 degree
    myservo1.write(pos1);              // tell servo to go to position in variable 'pos'
    delay(15);                       // waits 15ms for the servo to reach the position
  }
  for (pos1 = 85; pos1 >= 60; pos1 -= 1) { // goes from 180 degrees to 0 degrees
    myservo1.write(pos1);              // tell servo to go to position in variable 'pos'
    delay(15);                       // waits 15ms for the servo to reach the position
  }



  for (pos2 = 145; pos2 >= 125; pos2 -= 1) { // goes from 180 degrees to 0 degrees
    myservo2.write(pos2);              // tell servo to go to position in variable 'pos'
    delay(15);                       // waits 15ms for the servo to reach the position
  }

  for (pos2 = 125; pos2 <= 145; pos2 += 1) { // goes from 0 degrees to 180 degrees
    // in steps of 1 degree
    myservo2.write(pos2);              // tell servo to go to position in variable 'pos'
    delay(15);                       // waits 15ms for the servo to reach the position
  }


  fixState = 0;
 }
   
 
 
   
}

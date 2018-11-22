

int start = 0;

int b_input = 2;
int b = 0;
int bstate = 0;
int b_output = 3;


int t_input = 6;
int t = 1;
int tstate = 0;
int t_output = 7;
int lickPin = 10;
int disp_key = 11;
int pump_key = 4;
int s_i = 9; //sucrose inhibit pin



int l = 0;

int tonekey = 8; //tone key
int a_i_state = 0; //attack inhibit state
int s_s = 0; //sucrose state



int trcount = 0;

int attackPin = 5;



unsigned long currentT = 0;
unsigned long btime = 0;
unsigned long ttime = 0;
unsigned long AT;

unsigned long maxttime = 6000; //max sucrose time 6000
unsigned long Aonset;
unsigned long Loffset;
int Astate = 0;

int eventstate = 0;



int prob; 
int sa = 70; //six second attack probability


void setup() {
  
  // make the pushbutton's pin an input:
 
 pinMode(b_input, INPUT);
  pinMode(t_input, INPUT);

   pinMode(b_output, OUTPUT);
  

    pinMode(t_output, OUTPUT);

    pinMode(attackPin, OUTPUT);

    pinMode(lickPin, INPUT);

    pinMode(disp_key, INPUT);

  //  pinMode(a_i, INPUT);
  // pinMode(a_i_LED, OUTPUT);
   

    pinMode(pump_key, OUTPUT);
    pinMode(s_i, OUTPUT);

    Serial.begin(9600);
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input pin:





currentT = millis();

 
  b = digitalRead(b_input);
  t = digitalRead(t_input);
  l = digitalRead(lickPin);
  //a_i_state = digitalRead(a_i);
  //digitalWrite(a_i_LED,a_i_state);
  eventstate = digitalRead(disp_key);
  



if(start == 0)
{digitalWrite(b_output,LOW);
    
digitalWrite(t_output,LOW);
    


    start = 1;
}
  

if(b == 0 && bstate == 0)
{

  

 if(eventstate == 1)
 {
  Serial.println("Attack 100%");
  Serial.println("If attack, 3s or 6s ");
  
  

  delay(5);
 }
}





  if(b == 1 && bstate == 0)
  {
    digitalWrite(b_output,HIGH);
    Serial.println("Block start");
    
    btime = currentT+500;
    bstate = 1;
  }

 if(b == 0 && bstate == 1 && btime < currentT)
 {
  digitalWrite(b_output,LOW);
  Serial.println("Block end");
  eventstate = 0;
  trcount = 0;
   
    bstate = 0;
 }





  if(t == 0) //because its a magnetic switch, 0 is on
  {
     if( tstate == 0)
     {
    digitalWrite(t_output,HIGH);
    tone(8,1000,1000);
    
    prob = random(1,101);


    if(prob <= sa)   //decide long or short attack onset time
     { AT = 6000;}
    if(prob > sa)
    {AT = 3000;}
    
    
  
    
    Serial.print("trial : ");
    trcount = trcount+1;
    Serial.println(trcount);
  
    ttime = currentT+500;
    
    tstate = 1;
     }

     if (Astate == 0 && l == 1 && a_i_state == 0)
     {
       Astate = 1;
       Aonset = currentT+AT;
       Loffset = currentT+maxttime; //max lick
     }

  
  if((Astate == 1) && (Aonset < currentT) && a_i_state == 0)
  {
    
    
    digitalWrite(attackPin,HIGH);
    Serial.print("attack ");
    Serial.println(AT);
      delay(100);
    digitalWrite(attackPin,LOW);
    
    
    a_i_state = 1;
  }


 if((Loffset != 0) && (Loffset < currentT) && (s_s == 0))
  {
    digitalWrite(s_i,HIGH);
    Serial.print("stop sucrose ");
    Serial.println(maxttime);
    s_s = 1;    
      }


  
  
  }
  



   

 if(t == 1 && tstate == 1 && ttime < currentT)
 {
  digitalWrite(t_output,LOW);
    
    tstate = 0;
    Astate = 0;
    Loffset = 0;
    s_s = 0;
    a_i_state = 0;
    digitalWrite(s_i,LOW);
    Serial.println("sucrose available ");

    digitalWrite(pump_key,HIGH);
    delay(3000);
    digitalWrite(pump_key,LOW);
 }


 


  
 
 
}




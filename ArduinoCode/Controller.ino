/* 
  Original file from KSW
  File name : block_trial_controller_v14_pump_trialMix_3s6sattack_suc6_tone.ino
  Editted by JJH, 2018=11-12

  Arduino Script for the Lobster Controller
*/

// Assign Pin Numbers
const int PIN_BLOCK_INPUT = 2;
const int PIN_BLOCK_OUTPUT = 3;

const int PIN_TRIAL_INPUT = 6;
const int PIN_TRIAL_OUTPUT = 7;

const int PIN_LICK_INPUT = 10;

const int PIN_DISP_INPUT = 11;

const int PIN_ATTK_OUTPUT = 5;
const int PIN_PUMP_OUTPUT = 4;
const int PIN_STOP_SUCROSE_OUTPUT = 9; //sucrose inhibit pin


int start = 0;

int b = 0;
bool isBlock = false;

int t = 1;
bool isTrial = false;

int l = 0;

int tonekey = 8; //tone key
int a_i_state = 0; //attack inhibit state
int s_s = 0; //sucrose state


int trcount = 0;

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


void setup() 
{
  // Block Switch & LED
  pinMode(PIN_BLOCK_INPUT, INPUT);
  pinMode(PIN_BLOCK_OUTPUT, OUTPUT);
  // Trial Sensor & LED
  pinMode(PIN_TRIAL_INPUT, INPUT);
  pinMode(PIN_TRIAL_OUTPUT, OUTPUT);

  pinMode(PIN_LICK_INPUT, INPUT);
  pinMode(PIN_DISP_INPUT, INPUT);
  pinMode(PIN_ATTK_OUTPUT, OUTPUT);
  pinMode(PIN_PUMP_OUTPUT, OUTPUT);
  pinMode(PIN_STOP_SUCROSE_OUTPUT, OUTPUT);

  Serial.begin(9600);
}

// the loop routine runs over and over again forever:
void loop() 
{
  // read the input pin:

  currentT = millis();

  b = digitalRead(PIN_BLOCK_INPUT);
  t = digitalRead(PIN_TRIAL_INPUT);
  l = digitalRead(PIN_LICK_INPUT);
  eventstate = digitalRead(PIN_DISP_INPUT);
  
  if(start == 0)
  {
    digitalWrite(PIN_BLOCK_OUTPUT,LOW);
    digitalWrite(PIN_TRIAL_OUTPUT,LOW);
    start = 1;
  }
  

  if(b == 0 && bstate && eventstate == 1)
  {
    Serial.println("Attack 100%");
    Serial.println("If attack, 3s or 6s ");
    delay(5);
  }

  if(b == 1 && bstate)
  {
    digitalWrite(PIN_BLOCK_OUTPUT,HIGH);
    Serial.println("Block start");
    btime = currentT+500;
    bstate = 1;
  }

  if(b == 0 && bstate && btime < currentT)
  {
    digitalWrite(PIN_BLOCK_OUTPUT,LOW);
    Serial.println("Block end");
    eventstate = 0;
    trcount = 0;
    bstate = 0;
  }

  if(t == 0) //because its a magnetic switch, 0 is on
  {
    if(tstate == 0)
    {
      digitalWrite(PIN_TRIAL_OUTPUT,HIGH);
      tone(8,1000,1000);
      prob = random(1,101);

      if(prob <= sa)   //decide long or short attack onset time
      { 
        AT = 6000;
      }
      if(prob > sa)
      {
        AT = 3000;
      }
    
      Serial.print("trial : ");
      trcount = trcount+1;
      Serial.println(trcount);
    
      ttime = currentT+500;
      
      tstate = true;
    }

    if (Astate == 0 && l == 1 && a_i_state == 0)
    {
      Astate = 1;
      Aonset = currentT+AT;
      Loffset = currentT+maxttime; //max lick
    }

    if((Astate == 1) && (Aonset < currentT) && a_i_state == 0)
    {
      digitalWrite(PIN_ATTK_OUTPUT,HIGH);
      Serial.print("attack ");
      Serial.println(AT);
      delay(100);
      digitalWrite(PIN_ATTK_OUTPUT,LOW);
      a_i_state = 1;
    }

    if((Loffset != 0) && (Loffset < currentT) && (s_s == 0))
    {
      digitalWrite(PIN_STOP_SUCROSE_OUTPUT,HIGH);
      Serial.print("stop sucrose ");
      Serial.println(maxttime);
      s_s = 1;    
    }
  }

  if(t == 1 && isBlock && ttime < currentT)
  {
    digitalWrite(PIN_TRIAL_OUTPUT,LOW);
    tstate = 0;
    Astate = 0;
    Loffset = 0;
    s_s = 0;
    a_i_state = 0;
    digitalWrite(PIN_STOP_SUCROSE_OUTPUT,LOW);
    Serial.println("sucrose available ");

    digitalWrite(PIN_PUMP_OUTPUT,HIGH);
    delay(3000);
    digitalWrite(PIN_PUMP_OUTPUT,LOW);
  } 
}
/* 
  Original file from KSW
  File name : block_trial_controller_v14_pump_trialMix_3s6sattack_suc6_tone.ino
  Editted by JJH, 2018=11-12

  Arduino Script for the Lobster Controller
*/

// Assign Pin Numbers
const int PIN_BLOCK_INPUT = 2;
const int PIN_BLOCK_OUTPUT = 3;

const int PIN_DOOR_INPUT = 6;
const int PIN_TRIAL_OUTPUT = 7;

const int PIN_LICK_INPUT = 10;

const int PIN_ATTK_OUTPUT = 5;
const int PIN_PUMP_OUTPUT = 4;


bool isBlockSwitchOn = 0;
bool isBlock = false;

bool isDoorClosed = true;
bool isTrial = false;

bool isAttackArmed = false;
bool isAttacked = false;

int tonekey = 8; //tone key

int trcount = 0;

unsigned long blockOnSetTime = 0;
unsigned long trialOnSetTime = 0;
unsigned long attackOnSetTime = 0;
unsigned long AT;

unsigned long maxLickTime = 6000; //max sucrose time 6000
unsigned long lickOffSetTime = 0;

int prob; 
int sa = 70; //six second attack probability


void setup() 
{
  // Block Switch & LED
  pinMode(PIN_BLOCK_INPUT, INPUT);
  pinMode(PIN_BLOCK_OUTPUT, OUTPUT);
  digitalWrite(PIN_BLOCK_OUTPUT,LOW);
  // Trial Sensor & LED
  pinMode(PIN_DOOR_INPUT, INPUT); //because its a magnetic switch, 0 is on
  pinMode(PIN_TRIAL_OUTPUT, OUTPUT);
  digitalWrite(PIN_TRIAL_OUTPUT,LOW);

  pinMode(PIN_LICK_INPUT, INPUT);
  pinMode(PIN_ATTK_OUTPUT, OUTPUT);
  pinMode(PIN_PUMP_OUTPUT, OUTPUT);

  // generate random seed
  randomSeed(analogRead(0));

  Serial.begin(9600);
  Serial.println("==========Current Protocol===========");
  Serial.print("Attack in 6sec : ");
  Serial.println(sa);
  Serial.print("Attack in 3sec : ");
  Serial.println(100-sa);
  Serial.println("=====================================");
}

void loop() 
{
  /*********************/
  /********Block********/
  /*********************/
  isBlockSwitchOn = digitalRead(PIN_BLOCK_INPUT);
  if(!isBlock) // not in block
  {
    if(isBlockSwitchOn == HIGH) // block digital switch on
    {
      digitalWrite(PIN_BLOCK_OUTPUT,HIGH);
      Serial.println("Block started");
      blockOnSetTime = millis();
      isBlock = true;
    }
  }
  else // in block
  {
    if(isBlockSwitchOn == LOW && blockOnSetTime > millis()+500/* + 500 for jittering*/) // block digital switch off
    {
      digitalWrite(PIN_BLOCK_OUTPUT,LOW);
      Serial.println("Block ended");
      trcount = 1;
      isBlock = false;
    }
  }

  /*********************/
  /********Trial********/
  /*********************/
  isDoorClosed = digitalRead(PIN_DOOR_INPUT);
  if(!isDoorClosed) // Door opened = trial started
  {
    if(!isTrial) // Start Trial
    {
      trialOnSetTime = millis(); 
      digitalWrite(PIN_TRIAL_OUTPUT,HIGH);

      tone(8,1000,1000);

      if(random(100) < sa)   //decide long or short attack onset time
        AT = 6000;
      else
        AT = 3000;
      
      // Print Trial Info
      Serial.print("trial : ");
      Serial.println(trcount);
      trcount = trcount+1;
      
      isTrial = true;
    }
    
    if(!isAttacked) // not attacked
    {
      if(!isAttackArmed) // not armed
      {
        if(digitalRead(PIN_LICK_INPUT)) // licked
        {
          isAttackArmed = true;
          attackOnSetTime = millis() + AT;
          lickOffSetTime = millis() + maxLickTime;
        }
      }
      else // armed
      {
        if(attackOnSetTime < millis()) // Attack Onset Time reached
        {
          digitalWrite(PIN_ATTK_OUTPUT,HIGH);
          delay(100);
          digitalWrite(PIN_ATTK_OUTPUT,LOW);
          Serial.print("attack at ");
          Serial.println(AT);
          isAttacked = true;
        }
      }
    }
  }
  else // Door closed
  {
    if(isTrial) // finish trial
    {
      isTrial = false;
      isAttackArmed = false;
      isAttacked = false;
    }
  }
}

/* 
  Original file from KSW
  File name : block_trial_controller_v14_pump_trialMix_3s6sattack_suc6_tone.ino
  Editted by JJH, 2018-11-27

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

const int PIN_TONE_OUTPUT = 8;

const int PIN_MANUAL_SUC_INPUT = 11; // Suc button (previously "event button")
const int PIN_MANUAL_SUC_OUTPUT = 12;

// Event state boolean variables
bool isBlockSwitchOn = false;
bool isBlock = false;

bool isDoorClosed = true;
bool isTrial = false;

bool isAttackArmed = false;
bool isAttacked = false;

// Time variable
unsigned long blockOnSetTime = 0;
unsigned long trialOnSetTime = 0;
unsigned long attackOnSetTime = 0;
unsigned long AT;

unsigned long maxLickTime = 6000; //max sucrose time 6000
unsigned long lickOffSetTime = 0;

// Etc.
int sa = 70; //six second attack probability
int trcount = 1;

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

  pinMode(PIN_MANUAL_SUC_INPUT, INPUT);
  pinMode(PIN_MANUAL_SUC_OUTPUT, OUTPUT);

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
    if(isBlockSwitchOn == LOW && blockOnSetTime + 500 < millis()/* + 500 for jittering*/) // block digital switch off
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
      tone(PIN_TONE_OUTPUT,1000,1000);

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

          Serial.print("Licked. Attack in ");
          Serial.print(AT);
          Serial.println("ms sec");
        }
      }
      else // armed
      {
        if(attackOnSetTime < millis()) // Attack Onset Time reached
        {
          digitalWrite(PIN_ATTK_OUTPUT,HIGH);
          delay(100);
          digitalWrite(PIN_ATTK_OUTPUT,LOW);
          Serial.println("Attacked!!");
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

      digitalWrite(PIN_TRIAL_OUTPUT,LOW);
      
      // Pump out
      digitalWrite(PIN_PUMP_OUTPUT,HIGH);
      delay(3000);
      digitalWrite(PIN_PUMP_OUTPUT,LOW);
    }
  }
  /*********************/
  /****Manual Sucrose***/
  /*********************/
  digitalWrite(PIN_MANUAL_SUC_OUTPUT,digitalRead(PIN_MANUAL_SUC_INPUT));
}

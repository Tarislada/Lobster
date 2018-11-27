int test_pin = 7;
int valve = 2;
int LickPin = 12;
int Lick_TDT = 11;
int Lick_trial_key = 3;


bool Lick_trial = false;

bool lick_state = true;  // true false reversed! because of sensor specification

bool test_state = false;

unsigned long currentT = 0;
unsigned long maxlick = 6000;
unsigned long flick = 0;
unsigned long suppress = 3000;

int valve_inhibit = 0;
int valv_i = 5; //valve inhibit key

void setup() 
{
  // put your setup code here, to run once:
  
  pinMode(test_pin, INPUT);
  pinMode(valve, OUTPUT);
  pinMode(LickPin, INPUT);
  pinMode(Lick_TDT, OUTPUT); 
  pinMode(Lick_trial_key, OUTPUT);
  pinMode(valv_i, INPUT); 

}



void loop() 
{
  // put your main code here, to run repeatedly:
  currentT = millis();

  lick_state = digitalRead(LickPin);
  test_state = digitalRead(test_pin);
  valve_inhibit = digitalRead(valv_i);


  if (lick_state == false)
  { 
    digitalWrite(Lick_TDT, HIGH);
    
    if(valve_inhibit == 0)
    {
      digitalWrite(valve, HIGH);
    }
    digitalWrite(Lick_trial_key,HIGH);
  }

  if (lick_state == true)
  { 
    digitalWrite(Lick_TDT, LOW);
    digitalWrite(valve, LOW);
    digitalWrite(Lick_trial_key,LOW);


    if (test_state == true)
    { 
      digitalWrite(valve, HIGH);
    }

    if (test_state == false)
    { 
      digitalWrite(valve, LOW);
    }
  }
}

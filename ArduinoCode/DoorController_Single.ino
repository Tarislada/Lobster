
const int PIN_MOTOR_DIR_OUTPUT = 6;
const int PIN_MOTOR_CLK_OUTPUT = 5;
const int PIN_DOOR_STATE_INPUT = 4;

const int PIN_OPENBUTTON_INPUT = 10;
const int PIN_CLOSESIG_INPUT = 9;
const int PIN_TOGGLE_INPUT = 12;
const int PIN_RESET_INPUT = 13;

bool prevToggleState;
bool currToggleState;

bool isDirectionUp;

// variables for one button mode
bool currPushButtonState;
bool isPushButtonPressed;
bool currControllerSignal;

bool isDoorMoving;
unsigned long doorStartTime;

const int Freq = 500;
const int Duration = 2500;

void setup()
{
  pinMode(PIN_MOTOR_DIR_OUTPUT, OUTPUT);
  pinMode(PIN_MOTOR_CLK_OUTPUT, OUTPUT);
  pinMode(PIN_DOOR_STATE_INPUT, INPUT);
  
  pinMode(PIN_TOGGLE_INPUT, INPUT);
  pinMode(PIN_RESET_INPUT, INPUT);

  pinMode(PIN_OPENBUTTON_INPUT, INPUT);
  pinMode(PIN_CLOSESIG_INPUT, INPUT);

  // Check toggle state
  prevToggleState = digitalRead(PIN_TOGGLE_INPUT);

  // Initialize
  isDoorMoving = false;
  isPushButtonPressed = false;
}

void loop()
{ 

  currToggleState = digitalRead(PIN_TOGGLE_INPUT);
  currPushButtonState = digitalRead(PIN_OPENBUTTON_INPUT);
  currControllerSignal = digitalRead(PIN_CLOSESIG_INPUT);
  
  // set push button state for single button mode
  if (currPushButtonState == HIGH && isPushButtonPressed == false)
  {
    isPushButtonPressed = true;
  }
  else if (currPushButtonState == LOW && isPushButtonPressed == true)
  {
    isPushButtonPressed = false;
  }

  //################## DOOR MOVING ##################
  if (isDoorMoving)
  {
    
    if (prevToggleState != currToggleState) // door direction change while moving
    {
      prevToggleState = currToggleState;
      isDirectionUp = !currToggleState;
      doorStartTime = 2*millis() - Duration - doorStartTime;

      moveDoor(isDirectionUp);
    }
    else // toggle button remain unchanged
    {
      // door stoping criterion reached
      if (isDirectionUp)
      {
        //was going up
        if (millis() - doorStartTime > Duration) // Up stop criterion
        {
          noTone(PIN_MOTOR_CLK_OUTPUT);
          isDoorMoving = false;
        }
      }
      else
      {
        //was going down
        if (digitalRead(PIN_DOOR_STATE_INPUT) == HIGH) // Down stop criterion : door contact + moving more than 1sec
        {
          noTone(PIN_MOTOR_CLK_OUTPUT);
          isDoorMoving = false;
        }
      }     
    }
  }
  //################## DOOR FIXED ##################
  else
  {
    if (prevToggleState != currToggleState) // toggle button state changed
    {
      doorStartTime = millis();
      prevToggleState = currToggleState;
      isDirectionUp = !currToggleState;
      moveDoor(isDirectionUp);
    }
    if (isPushButtonPressed) // push button pressed. go up.
    {
      doorStartTime = millis();
      isDirectionUp = true;
      moveDoor(isDirectionUp);
    }
    if (currControllerSignal == HIGH) // attack signal came. go down.
    {
      delay(1000); // delay for attack signal
      doorStartTime = millis();
      isDirectionUp = false;
      moveDoor(isDirectionUp);  
    }
  }


  // Reset button
  if (digitalRead(PIN_RESET_INPUT))
  {
    noTone(PIN_MOTOR_CLK_OUTPUT); // stops everything
    isDoorMoving = false;
    delay(2000);
    prevToggleState = digitalRead(PIN_TOGGLE_INPUT); // prevent moving right after reset off
  }

}

void moveDoor(bool isDirectionUp)
{
  digitalWrite(PIN_MOTOR_DIR_OUTPUT, isDirectionUp); //set DIR
  tone(PIN_MOTOR_CLK_OUTPUT, Freq); // initiate motor
  isDoorMoving = true;
}

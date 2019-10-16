
const int PIN_MOTOR_DIR_OUTPUT = 6;
const int PIN_MOTOR_CLK_OUTPUT = 5;
const int PIN_DOOR_STATE_INPUT = 4;
const int PIN_TOGGLE_INPUT = 12;
const int PIN_RESET_INPUT = 13;



bool prevToggleState;
bool currToggleState;

bool isDoorMoving;
unsigned long doorStartTime;

const int Freq = 400;
const int Duration = 800;


void setup()
{
	pinMode(PIN_MOTOR_DIR_OUTPUT, OUTPUT);
	pinMode(PIN_DOOR_STATE_INPUT, OUTPUT);
	pinMode(PIN_DOOR_STATE_INPUT, INPUT);
	pinMode(PIN_TOGGLE_INPUT, INPUT);
	pinMode(PIN_RESET_INPUT, INPUT);

	// Check toggle state
	prevToggleState = digitalRead(PIN_TOGGLE_INPUT);

	// Init. condition
	isDoorMoving = false;
}

void loop()
{	

	// reset button
	if (PIN_RESET_INPUT == HIGH)
	{
		noTone(PIN_MOTOR_CLK_OUTPUT); // stops everything
		isDoorMoving = false;
		delay(5000);

	}

	//check toggle button change
	currToggleState = digitalRead(PIN_TOGGLE_INPUT);
	
	if (isDoorMoving) // door moving
	{
		// door stoping criterion reached
		if (currToggleState)
		{
			if (digitalRead(PIN_DOOR_STATE_INPUT) || millis() - doorStartTime > Duration + 200) // Down stop criterion : door contact + moving more than 1sec
			{
				noTone(PIN_MOTOR_CLK_OUTPUT);
				isDoorMoving = false;
			}
		}
		else
		{
			if (millis() - doorStartTime > Duration) // Up stop criterion
			{
				noTone(PIN_MOTOR_CLK_OUTPUT);
				isDoorMoving = false;
			}
		}


		// door direction change while moving
		if (prevToggleState != currToggleState) // toggle button state changed
		{
			prevToggleState = currToggleState;

			doorStartTime = millis() + (Duration - doorStartTime) ;

			// move motor
			digitalWrite(PIN_MOTOR_DIR_OUTPUT, !currToggleState); //set DIR
			tone(PIN_MOTOR_CLK_OUTPUT, Freq); // initiate motor
		} 


	}
	else // door fixed
	{
		if (prevToggleState != currToggleState) // toggle button state changed
		{
			prevToggleState = currToggleState;

			isDoorMoving = true;
			doorStartTime = millis();

			// move motor
			digitalWrite(PIN_MOTOR_DIR_OUTPUT, !currToggleState); //set DIR
			tone(PIN_MOTOR_CLK_OUTPUT, Freq); // initiate motor
		}
	}

}
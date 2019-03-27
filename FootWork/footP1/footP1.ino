

#define HEEL_BONE_SENSOR 0   // Analogue pins used
#define OUTER_BALL_SENSOR1 1
#define OUTER_BALL_SENSOR2 2
#define OUTER_BALL_SENSOR3 3
#define OUTER_BALL_SENSOR4 4

#define HEEL_BONE_INDEX   0   // Analogue pins used
#define OUTER_BALL1_INDEX 1
#define OUTER_BALL1_INDEX 2
#define OUTER_BALL2_INDEX 3
#define OUTER_BALL3_INDEX 4

#define R2 10000


#define FILTER_COEF1 6 //ensure that both sum to 8, increas FILTER_COEF2 value to make the filter stornger.
#define FILTER_COEF2 2
// Variables for storing sensor values
float unHeelBone = 0;
float unOuterBall0 = 0;
float unOuterBall1 = 0;
float unOuterball2 = 0;
float unOuterball3 = 0;

float unHeelBoneOld = 0;
float unOuterBall0Old = 0;
float unOuterBall1Old = 0;
float unOuterball2Old = 0;
float unOuterball3Old = 0;

float mySensorsVolArr[5];
float mySensorsForceArr[5];
float mySensorsForceFilteredArr[5];

void setup()
{

Serial.begin(9600);

}

void loop() {

for (int i = 0; i<5; i++)
{
  mySensorsVolArr[i] = map(analogRead(i),0,1023,0,5000);
  
}

for (int i = 0; i<5; i++)
{
  
  mySensorsForceArr[i] = (5000-mySensorsVolArr[i]);
  mySensorsForceArr[i] *=R2;
  mySensorsForceArr[i] /= mySensorsVolArr[i];
//  mySensorsForceArr[i] = 250;
  //Serial.println(mySensorsForceArr[i]);
  
  mySensorsForceArr[i] = 1000000 / mySensorsForceArr[i];
  mySensorsForceArr[i] = (constrain(mySensorsForceArr[i],1,1000000));
  
  if (mySensorsForceArr[i] <= 1000) 
  {
   
   mySensorsForceArr[i] = mySensorsForceArr[i] / 80; 
  
  } 
  else 
  {
  mySensorsForceArr[i] = mySensorsForceArr[i] - 1000;
  mySensorsForceArr[i] /= 30;
  
  }
}

for (int i = 0; i<5; i++)
{

  mySensorsForceFilteredArr[i] = (mySensorsForceFilteredArr[i]*6 + mySensorsForceArr[i]*2)/8;
}
delay(20);
Serial.write(255);
for (int i = 0; i<5; i++)
{
  
  Serial.print("Heel: "); Serial.print(int(constrain(mySensorsForceFilteredArr[i],0,98))); Serial.print("  ");   // Blue
}
Serial.println("uT");


}

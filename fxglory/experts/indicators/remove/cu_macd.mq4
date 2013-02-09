//+------------------------------------------------------------------+
//|                                         EMA-Crossover_Signal.mq4 |
//|         Copyright � 2005, Jason Robinson (jnrtrading)            |
//|                   http://www.jnrtading.co.uk                     |
//+------------------------------------------------------------------+

/*
  +------------------------------------------------------------------+
  | Allows you to enter two ema periods and it will then show you at |
  | Which point they crossed over. It is more usful on the shorter   |
  | periods that get obscured by the bars / candlesticks and when    |
  | the zoom level is out. Also allows you then to remove the emas   |
  | from the chart. (emas are initially set at 5 and 6)              |
  +------------------------------------------------------------------+
*/   
#property copyright "Copyright � 2005, Jason Robinson (jnrtrading)"
#property link      "http://www.jnrtrading.co.uk"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 SeaGreen
#property indicator_color2 Red

double CrossUp[];
double CrossDown[];
extern int FasterEMA = 4;
extern int SlowerEMA = 8;
extern bool SoundON=true;
double alertTag;
 double control=2147483647;
 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW, EMPTY,3);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY,3);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, CrossDown);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- 

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {
   int limit, i, counter;
   double macd4, macd4_1, macd1, macd1_1, macd30, macd30_1, macd15, macd15_1, macd5, macd5_1, macd5_2;
   double Range, AvgRange;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   limit=Bars-counted_bars;
   
   for(i = 0; i <= limit; i++) {
   
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
       
      macd4 = iMACD(NULL,PERIOD_H4,12,26,9,PRICE_CLOSE,MODE_MAIN,i);
      macd4_1 = iMACD(NULL,PERIOD_H4,12,26,9,PRICE_CLOSE,MODE_MAIN,i+1);
      macd1 = iMACD(NULL,PERIOD_H1,12,26,9,PRICE_CLOSE,MODE_MAIN,i);
      macd1_1 = iMACD(NULL,PERIOD_H1,12,26,9,PRICE_CLOSE,MODE_MAIN,i+1);
      macd30 = iMACD(NULL,PERIOD_M30,12,26,9,PRICE_CLOSE,MODE_MAIN,i);
      macd30_1 = iMACD(NULL,PERIOD_M30,12,26,9,PRICE_CLOSE,MODE_MAIN,i+1);
      macd15 = iMACD(NULL,PERIOD_M15,12,26,9,PRICE_CLOSE,MODE_MAIN,i);
      macd15_1 = iMACD(NULL,PERIOD_M15,12,26,9,PRICE_CLOSE,MODE_MAIN,i+1);
      macd5 = iMACD(NULL,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_MAIN,i+0);
      macd5_1 = iMACD(NULL,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_MAIN,i+1);
      macd5_2 = iMACD(NULL,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_MAIN,i+2);
      
      if (macd4 > macd4_1 && macd1 > macd1_1 && macd30 > macd30_1 && macd15 > macd15_1 && macd5 > macd5_1) {
         CrossUp[i] = Low[i] - Range*0.5;
      }
      else if (macd4 < macd4_1 && macd1 < macd1_1 && macd30 < macd30_1 && macd15 < macd15_1 && macd5 < macd5_1) {
          CrossDown[i] = High[i] + Range*0.5;
      }
  }
   return(0);
}


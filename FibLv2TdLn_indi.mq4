//+------------------------------------------------------------------+
//|                                              FibLv2TdLn_indi.mq4 |
//|                                          Copyright 2022, TTSS000 |
//|                                      https://twitter.com/ttss000 |
//+------------------------------------------------------------------+
// 2021/12/30
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://twitter.com/ttss000"
#property version   "1.5" // 2022/5/12 16:25 JST
#property strict
#property indicator_chart_window

#define RECTANGLE_X_SPACE 8
#define RECTANGLE_Y_SPACE 10

enum ENUM_CORNER{
   Left = CORNER_LEFT_LOWER,   //左側
   Right = CORNER_RIGHT_LOWER   //右側
};

//--- input parameters
input double   NValue0=1.382;
input color    NColor0=clrOrangeRed;
input unsigned int N_Width0=2;

input double   NValue1=1.618;
input color    NColor1=clrBlue;
input unsigned int N_Width1=2;

input double   NValue2=1.764;
input color    NColor2=clrGreen;
input unsigned int N_Width2=2;

input double   NValue3=2.618;
input color    NColor3=clrBrown;
input unsigned int N_Width3=2;

input double   NValue4=0.618;
input color    NColor4=clrRoyalBlue;
input unsigned int N_Width4=1;

input double   NValue5=-1;
input color    NColor5=clrNONE;
input unsigned int N_Width5=2;

input double   NValue6=-1;
input color    NColor6=clrNONE;
input unsigned int N_Width6=2;

input double   SValue0=1.382;
input color    SColor0=clrMagenta;
input unsigned int S_Width0=2;

input double   SValue1=1.618;
input color    SColor1=clrDodgerBlue;
input unsigned int S_Width1=2;

input double   SValue2=1.764;
input color    SColor2=clrSpringGreen;
input unsigned int S_Width2=2;

input double   SValue3=2.618;
input color    SColor3=clrDarkSalmon;
input unsigned int S_Width3=2;

input double   SValue4=0.618;
input color    SColor4=clrMidnightBlue;
input unsigned int S_Width4=1;

input double   SValue5=-1;
input color    SColor5=clrNONE;
input unsigned int S_Width5=2;

input double   SValue6=-1;
input color    SColor6=clrNONE;
input unsigned int S_Width6=2;

//input unsigned int TL_Width=2;
//input unsigned int TL_Width2=1;
input unsigned int TL_Num_Bars=20;
input int label_corner = CORNER_LEFT_LOWER; // left lower
//input int font_size=8;
input int font_size = 8;                          //文字の大きさ
input string font_name = "Segoe UI";
input int Button1_posX=0;
input int Button1_posY=32;
input int Button2_posX=0;
input int Button2_posY=60;
input int Button3_posX=0;
input int Button3_posY=92;
input int Hanrei_posX=0;
input int Hanrei_posX2=40;
input int Hanrei_posY=150;
input int Hanrei_gapY=10;

input ENUM_CORNER chart_corner = Left;      //表示位置
//input int Yaxis = 0;                         //縦軸位置
//input int Yaxis2 = 30;                         //縦軸位置
input color buttonColorOFF = clrGreen;  //buttonの色
input color buttonColorON = clrDarkGreen;  //buttonの色
input color button2ColorOFF = clrOrange;  //buttonの色
input color button2ColorON = clrOrangeRed;  //buttonの色

string indiName = "FibLv2TdLn_indi";

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool nFiboLevel2TrendLine(string name_local, bool bCreate)
 {
//--- 配列のサイズをチェックする
  int levels;
  double price_0 = ObjectGetDouble(0,name_local,OBJPROP_PRICE,1); //0%の価格を取得  
  double price_100 = ObjectGetDouble(0,name_local,OBJPROP_PRICE,0); //100%の価格を取得

  //datetime time_100 = ObjectGet(name_local,OBJPROP_TIME2); //100%のtimeを取得
  datetime time_100 = ObjectGetInteger(0, name_local, OBJPROP_TIME, 1);
  //datetime time_0 = ObjectGet(name_local,OBJPROP_TIME1); //0%のtimeを取得
  datetime time_0 = ObjectGetInteger(0, name_local, OBJPROP_TIME, 0);
  double price_tmp;
  double value;
  datetime time_older, time_newer;
  //datetime time_diff = MathAbs(Time[0] - Time[TL_Num_Bars]);
  int iBarOlder;

  time_older = time_0;
  time_newer = time_100;
  
  if(time_100 < time_0){
    time_older = time_100;
    time_newer = time_0;
  }
  // iBarShiftTmp = iBarShift(NULL,PERIOD_CURRENT,dtVline,true);
  iBarOlder = iBarShift(NULL,PERIOD_CURRENT,time_older,false);
  if(20 < iBarOlder){
    time_newer = iTime(NULL,0,iBarOlder-20); //Time[iBarOlder-20];
  }else{
    time_newer = iTime(NULL,0,0); //Time[0];
  }

  //Print ("obj local name="+name_local);

  //--- レベル数をget する
  levels = ObjectGetInteger(0, name_local,OBJPROP_LEVELS,levels);
  //--- ループ内でレベルプロパティを設定する
  //Print ("levels=" + levels);
  //Print (" price_0=" + price_0 + " price_100=" + price_100 + " time_100=" + time_100 + " time_0=" + time_0);
  //Print (" time older=" + time_older + " time_newer=" + time_newer);
  string obj_name_tl;

  for(int i=0;i<levels;i++){
    //--- レベル値
    value = ObjectGetDouble(0,name_local,OBJPROP_LEVELVALUE,i);
    ///Print ("fibo level=" + MathAbs(value - 1.618));


    // --- nfibo --------------------------------------------
    if(0<=NValue0 && MathAbs(value - NValue0) < 0.0005){
      //Print ("value0=" + value);
      //--- レベルの色
      obj_name_tl = name_local+"TLn"+IntegerToString(i);
      price_tmp = price_0+(price_100-price_0)*NValue0;
      //Print ("price_tmp0=" + price_tmp);
      if (bCreate && ObjectFind(0,obj_name_tl) < 0){
        ObjectCreate(0,obj_name_tl, OBJ_TREND, 0, time_older,price_tmp, time_newer, price_tmp);
     	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
      }
      ObjectMove(0,obj_name_tl,0,time_older,price_tmp);
      ObjectMove(0,obj_name_tl,1,time_newer,price_tmp);
      //ObjectSetInteger(0,obj_name_tl,OBJPROP_TIME2,time_100);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_COLOR,NColor0);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_STYLE,STYLE_SOLID);  // ラインのスタイル設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_WIDTH,N_Width0);              // ラインの幅設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTED,false);       // オブジェクトの選択状態
      ObjectSetInteger(0,obj_name_tl,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位
      ObjectSetInteger(0,obj_name_tl,OBJPROP_RAY_RIGHT,false);      // ラインの延長線(右)    }else if(MathAbs(value - Value1) < 0.0005){
    }else if(0<=NValue1 && MathAbs(value - NValue1) < 0.0005){
      //Print ("value1=" + value);
      obj_name_tl = name_local+"TLn"+IntegerToString(i);
      price_tmp = price_0+(price_100-price_0)*NValue1;
      //Print ("price_tmp1=" + price_tmp);
      if (bCreate && ObjectFind(0,obj_name_tl) < 0){
        ObjectCreate(0,obj_name_tl, OBJ_TREND, 0, time_older,price_tmp, time_newer, price_tmp);
     	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
      }
      ObjectMove(0,obj_name_tl,0,time_older,price_tmp);
      ObjectMove(0,obj_name_tl,1,time_newer,price_tmp);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_COLOR,NColor1);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_STYLE,STYLE_SOLID);  // ラインのスタイル設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_WIDTH,N_Width1);              // ラインの幅設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTED,false);       // オブジェクトの選択状態
      ObjectSetInteger(0,obj_name_tl,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位
      ObjectSetInteger(0,obj_name_tl,OBJPROP_RAY_RIGHT,false);      // ラインの延長線(右)    }else if(MathAbs(value - Value1) < 0.0005){
    }else if(0<=NValue2 && MathAbs(value - NValue2) < 0.0005){
      //Print ("value2=" + value);
      obj_name_tl = name_local+"TLn"+IntegerToString(i);
      price_tmp = price_0+(price_100-price_0)*NValue2;
      //Print ("price_tmp2=" + price_tmp);
      if (bCreate && ObjectFind(0,obj_name_tl) < 0){
        ObjectCreate(0,obj_name_tl, OBJ_TREND, 0, time_older,price_tmp, time_newer, price_tmp);
     	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
      }
      ObjectMove(0,obj_name_tl,0,time_older,price_tmp);
      ObjectMove(0,obj_name_tl,1,time_newer,price_tmp);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_COLOR,NColor2);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_STYLE,STYLE_SOLID);  // ラインのスタイル設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_WIDTH,N_Width2);              // ラインの幅設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTED,false);       // オブジェクトの選択状態
      ObjectSetInteger(0,obj_name_tl,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位
      ObjectSetInteger(0,obj_name_tl,OBJPROP_RAY_RIGHT,false);      // ラインの延長線(右)    }else if(MathAbs(value - Value1) < 0.0005){
    }else if(0<=NValue3 && MathAbs(value - NValue3) < 0.0005){
      //Print ("value3=" + value);
      obj_name_tl = name_local+"TLn"+IntegerToString(i);
      price_tmp = price_0+(price_100-price_0)*NValue3;
      //Print ("price_tmp3=" + price_tmp);
      if (bCreate && ObjectFind(0,obj_name_tl) < 0){
        ObjectCreate(0,obj_name_tl, OBJ_TREND, 0, time_older,price_tmp, time_newer, price_tmp);
     	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
      }
      ObjectMove(0,obj_name_tl,0,time_older,price_tmp);
      ObjectMove(0,obj_name_tl,1,time_newer,price_tmp);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_COLOR,NColor3);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_STYLE,STYLE_SOLID);  // ラインのスタイル設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_WIDTH,N_Width3);              // ラインの幅設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTED,false);       // オブジェクトの選択状態
      ObjectSetInteger(0,obj_name_tl,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位
      ObjectSetInteger(0,obj_name_tl,OBJPROP_RAY_RIGHT,false);      // ラインの延長線(右)    }else if(MathAbs(value - Value1) < 0.0005){
    }else if(0<=NValue4 && MathAbs(value - NValue4) < 0.0005){
      //Print ("value4=" + value);
      obj_name_tl = name_local+"TLn"+IntegerToString(i);
      price_tmp = price_0+(price_100-price_0)*NValue4;
      //Print ("price_tmp4=" + price_tmp);
      if (bCreate && ObjectFind(0,obj_name_tl) < 0){
        ObjectCreate(0,obj_name_tl, OBJ_TREND, 0, time_older,price_tmp, time_newer, price_tmp);
     	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
      }
      ObjectMove(0,obj_name_tl,0,time_older,price_tmp);
      ObjectMove(0,obj_name_tl,1,time_newer,price_tmp);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_COLOR,NColor4);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_STYLE,STYLE_SOLID);  // ラインのスタイル設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_WIDTH,N_Width4);              // ラインの幅設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTED,false);       // オブジェクトの選択状態
      ObjectSetInteger(0,obj_name_tl,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位
      ObjectSetInteger(0,obj_name_tl,OBJPROP_RAY_RIGHT,false);      // ラインの延長線(右)    }else if(MathAbs(value - Value1) < 0.0005){
    }else if(0<=NValue5 && MathAbs(value - NValue5) < 0.0005){
      //Print ("value4=" + value);
      obj_name_tl = name_local+"TLn"+IntegerToString(i);
      price_tmp = price_0+(price_100-price_0)*NValue5;
      //Print ("price_tmp4=" + price_tmp);
      if (bCreate && ObjectFind(0,obj_name_tl) < 0){
        ObjectCreate(0,obj_name_tl, OBJ_TREND, 0, time_older,price_tmp, time_newer, price_tmp);
     	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
      }
      ObjectMove(0,obj_name_tl,0,time_older,price_tmp);
      ObjectMove(0,obj_name_tl,1,time_newer,price_tmp);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_COLOR,NColor5);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_STYLE,STYLE_SOLID);  // ラインのスタイル設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_WIDTH,N_Width5);              // ラインの幅設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTED,false);       // オブジェクトの選択状態
      ObjectSetInteger(0,obj_name_tl,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位
      ObjectSetInteger(0,obj_name_tl,OBJPROP_RAY_RIGHT,false);      // ラインの延長線(右)    }else if(MathAbs(value - Value1) < 0.0005){
    }else if(0<=NValue6 && MathAbs(value - NValue6) < 0.0005){
      //Print ("value4=" + value);
      obj_name_tl = name_local+"TLn"+IntegerToString(i);
      price_tmp = price_0+(price_100-price_0)*NValue6;
      //Print ("price_tmp4=" + price_tmp);
      if (bCreate && ObjectFind(0,obj_name_tl) < 0){
        ObjectCreate(0,obj_name_tl, OBJ_TREND, 0, time_older,price_tmp, time_newer, price_tmp);
     	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
      }
      ObjectMove(0,obj_name_tl,0,time_older,price_tmp);
      ObjectMove(0,obj_name_tl,1,time_newer,price_tmp);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_COLOR,NColor6);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_STYLE,STYLE_SOLID);  // ラインのスタイル設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_WIDTH,N_Width6);              // ラインの幅設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTED,false);       // オブジェクトの選択状態
      ObjectSetInteger(0,obj_name_tl,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位
      ObjectSetInteger(0,obj_name_tl,OBJPROP_RAY_RIGHT,false);      // ラインの延長線(右)    }else if(MathAbs(value - Value1) < 0.0005){
    }
  } // loop fibo level
  ChartRedraw(NULL);

//--- 実行成功
  return(true);
 }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool sFiboLevel2TrendLine(string name_local, bool bCreate)
 {
//--- 配列のサイズをチェックする
  int levels;
  double price_0 = ObjectGetDouble(0,name_local,OBJPROP_PRICE,1); //0%の価格を取得  
  double price_100 = ObjectGetDouble(0,name_local,OBJPROP_PRICE,0); //100%の価格を取得

  //datetime time_100 = ObjectGet(name_local,OBJPROP_TIME2); //100%のtimeを取得
  datetime time_100 = ObjectGetInteger(0, name_local, OBJPROP_TIME, 1);
  //datetime time_0 = ObjectGet(name_local,OBJPROP_TIME1); //0%のtimeを取得
  datetime time_0 = ObjectGetInteger(0, name_local, OBJPROP_TIME, 0);
  double price_tmp;
  double value;
  datetime time_older, time_newer;
  //datetime time_diff = MathAbs(Time[0] - Time[TL_Num_Bars]);
  int iBarOlder;

  time_older = time_0;
  time_newer = time_100;
  
  if(time_100 < time_0){
    time_older = time_100;
    time_newer = time_0;
  }
  // iBarShiftTmp = iBarShift(NULL,PERIOD_CURRENT,dtVline,true);
  iBarOlder = iBarShift(NULL,PERIOD_CURRENT,time_older,false);
  if(20 < iBarOlder){
    time_newer = iTime(NULL,0,iBarOlder-20); //Time[iBarOlder-20];
  }else{
    time_newer = iTime(NULL,0,0); //Time[0];
  }

  //Print ("obj local name="+name_local);

  //--- レベル数をget する
  levels = ObjectGetInteger(0, name_local,OBJPROP_LEVELS,levels);
  //--- ループ内でレベルプロパティを設定する
  //Print ("levels=" + levels);
  //Print (" price_0=" + price_0 + " price_100=" + price_100 + " time_100=" + time_100 + " time_0=" + time_0);
  //Print (" time older=" + time_older + " time_newer=" + time_newer);
  string obj_name_tl;

  for(int i=0;i<levels;i++){
    //--- レベル値
    value = ObjectGetDouble(0,name_local,OBJPROP_LEVELVALUE,i);
    ///Print ("fibo level=" + MathAbs(value - 1.618));

    // --- sfibo --------------------------------------------
    if(0 <= SValue0 && MathAbs(value - SValue0) < 0.0005){
      //Print ("value0=" + value);
      //--- レベルの色
      obj_name_tl = name_local+"TLs"+IntegerToString(i);
      price_tmp = price_0+(price_100-price_0)*SValue0;
      //Print ("price_tmp0=" + price_tmp);
      if (bCreate && ObjectFind(0,obj_name_tl) < 0){
        ObjectCreate(0,obj_name_tl, OBJ_TREND, 0, time_older,price_tmp, time_newer, price_tmp);
     	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
      }
      ObjectMove(0,obj_name_tl,0,time_older,price_tmp);
      ObjectMove(0,obj_name_tl,1,time_newer,price_tmp);
      //ObjectSetInteger(0,obj_name_tl,OBJPROP_TIME2,time_100);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_COLOR,SColor0);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_STYLE,STYLE_SOLID);  // ラインのスタイル設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_WIDTH,S_Width0);              // ラインの幅設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTED,false);       // オブジェクトの選択状態
      ObjectSetInteger(0,obj_name_tl,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位
      ObjectSetInteger(0,obj_name_tl,OBJPROP_RAY_RIGHT,false);      // ラインの延長線(右)    }else if(MathAbs(value - Value1) < 0.0005){
    }else if(0 <= SValue1 && MathAbs(value - SValue1) < 0.0005){
      //Print ("value1=" + value);
      obj_name_tl = name_local+"TLs"+IntegerToString(i);
      price_tmp = price_0+(price_100-price_0)*SValue1;
      //Print ("price_tmp1=" + price_tmp);
      if (bCreate && ObjectFind(0,obj_name_tl) < 0){
        ObjectCreate(0,obj_name_tl, OBJ_TREND, 0, time_older,price_tmp, time_newer, price_tmp);
     	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
      }
      ObjectMove(0,obj_name_tl,0,time_older,price_tmp);
      ObjectMove(0,obj_name_tl,1,time_newer,price_tmp);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_COLOR,SColor1);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_STYLE,STYLE_SOLID);  // ラインのスタイル設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_WIDTH,S_Width1);              // ラインの幅設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTED,false);       // オブジェクトの選択状態
      ObjectSetInteger(0,obj_name_tl,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位
      ObjectSetInteger(0,obj_name_tl,OBJPROP_RAY_RIGHT,false);      // ラインの延長線(右)    }else if(MathAbs(value - Value1) < 0.0005){
    }else if(0 <= SValue2 && MathAbs(value - SValue2) < 0.0005){
      //Print ("value2=" + value);
      obj_name_tl = name_local+"TLs"+IntegerToString(i);
      price_tmp = price_0+(price_100-price_0)*SValue2;
      //Print ("price_tmp2=" + price_tmp);
      if (bCreate && ObjectFind(0,obj_name_tl) < 0){
        ObjectCreate(0,obj_name_tl, OBJ_TREND, 0, time_older,price_tmp, time_newer, price_tmp);
     	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
      }
      ObjectMove(0,obj_name_tl,0,time_older,price_tmp);
      ObjectMove(0,obj_name_tl,1,time_newer,price_tmp);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_COLOR,SColor2);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_STYLE,STYLE_SOLID);  // ラインのスタイル設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_WIDTH,S_Width2);              // ラインの幅設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTED,false);       // オブジェクトの選択状態
      ObjectSetInteger(0,obj_name_tl,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位
      ObjectSetInteger(0,obj_name_tl,OBJPROP_RAY_RIGHT,false);      // ラインの延長線(右)    }else if(MathAbs(value - Value1) < 0.0005){
    }else if(0 <= SValue3 && MathAbs(value - SValue3) < 0.0005){
      //Print ("value3=" + value);
      obj_name_tl = name_local+"TLs"+IntegerToString(i);
      price_tmp = price_0+(price_100-price_0)*SValue3;
      //Print ("price_tmp3=" + price_tmp);
      if (bCreate && ObjectFind(0,obj_name_tl) < 0){
        ObjectCreate(0,obj_name_tl, OBJ_TREND, 0, time_older,price_tmp, time_newer, price_tmp);
     	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
      }
      ObjectMove(0,obj_name_tl,0,time_older,price_tmp);
      ObjectMove(0,obj_name_tl,1,time_newer,price_tmp);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_COLOR,SColor3);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_STYLE,STYLE_SOLID);  // ラインのスタイル設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_WIDTH,S_Width3);              // ラインの幅設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTED,false);       // オブジェクトの選択状態
      ObjectSetInteger(0,obj_name_tl,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位
      ObjectSetInteger(0,obj_name_tl,OBJPROP_RAY_RIGHT,false);      // ラインの延長線(右)    }else if(MathAbs(value - Value1) < 0.0005){
    }else if(0 <= SValue4 && MathAbs(value - SValue4) < 0.0005){
      //Print ("value4=" + value);
      obj_name_tl = name_local+"TLs"+IntegerToString(i);
      price_tmp = price_0+(price_100-price_0)*SValue4;
      //Print ("price_tmp4=" + price_tmp);
      if (bCreate && ObjectFind(0,obj_name_tl) < 0){
        ObjectCreate(0,obj_name_tl, OBJ_TREND, 0, time_older,price_tmp, time_newer, price_tmp);
     	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
      }
      ObjectMove(0,obj_name_tl,0,time_older,price_tmp);
      ObjectMove(0,obj_name_tl,1,time_newer,price_tmp);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_COLOR,SColor4);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_STYLE,STYLE_SOLID);  // ラインのスタイル設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_WIDTH,S_Width4);              // ラインの幅設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTED,false);       // オブジェクトの選択状態
      ObjectSetInteger(0,obj_name_tl,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位
      ObjectSetInteger(0,obj_name_tl,OBJPROP_RAY_RIGHT,false);      // ラインの延長線(右)    }else if(MathAbs(value - Value1) < 0.0005){
    }else if(0 <= SValue5 && MathAbs(value - SValue5) < 0.0005){
      //Print ("value4=" + value);
      obj_name_tl = name_local+"TLs"+IntegerToString(i);
      price_tmp = price_0+(price_100-price_0)*SValue5;
      //Print ("price_tmp4=" + price_tmp);
      if (bCreate && ObjectFind(0,obj_name_tl) < 0){
        ObjectCreate(0,obj_name_tl, OBJ_TREND, 0, time_older,price_tmp, time_newer, price_tmp);
     	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
      }
      ObjectMove(0,obj_name_tl,0,time_older,price_tmp);
      ObjectMove(0,obj_name_tl,1,time_newer,price_tmp);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_COLOR,SColor5);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_STYLE,STYLE_SOLID);  // ラインのスタイル設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_WIDTH,S_Width5);              // ラインの幅設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTED,false);       // オブジェクトの選択状態
      ObjectSetInteger(0,obj_name_tl,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位
      ObjectSetInteger(0,obj_name_tl,OBJPROP_RAY_RIGHT,false);      // ラインの延長線(右)    }else if(MathAbs(value - Value1) < 0.0005){
    }else if(0 <= SValue6 && MathAbs(value - SValue6) < 0.0005){
      //Print ("value4=" + value);
      obj_name_tl = name_local+"TLs"+IntegerToString(i);
      price_tmp = price_0+(price_100-price_0)*SValue6;
      //Print ("price_tmp4=" + price_tmp);
      if (bCreate && ObjectFind(0,obj_name_tl) < 0){
        ObjectCreate(0,obj_name_tl, OBJ_TREND, 0, time_older,price_tmp, time_newer, price_tmp);
     	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
      }
      ObjectMove(0,obj_name_tl,0,time_older,price_tmp);
      ObjectMove(0,obj_name_tl,1,time_newer,price_tmp);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_COLOR,SColor6);
      ObjectSetInteger(0,obj_name_tl,OBJPROP_STYLE,STYLE_SOLID);  // ラインのスタイル設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_WIDTH,S_Width6);              // ラインの幅設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_SELECTED,false);       // オブジェクトの選択状態
      ObjectSetInteger(0,obj_name_tl,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
      ObjectSetInteger(0,obj_name_tl,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位
      ObjectSetInteger(0,obj_name_tl,OBJPROP_RAY_RIGHT,false);      // ラインの延長線(右)    }else if(MathAbs(value - Value1) < 0.0005){
    }

  } // loop fibo level
  ChartRedraw(NULL);

//--- 実行成功
  return(true);
 }
//+------------------------------------------------------------------+
void AddHanrei(){
  //-----------------------------------------------
  string obj_name;

  if(0<=NValue0){
    obj_name = "Label_Hanrei0";
    if (ObjectFind(0,obj_name) < 0){
      ObjectCreate(0,obj_name, OBJ_LABEL, 0, 0,0);
       	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
    }
    //--- set label coordinates
    ObjectSetInteger(0,obj_name,OBJPROP_XDISTANCE,Hanrei_posX);
    ObjectSetInteger(0,obj_name,OBJPROP_YDISTANCE,Hanrei_posY);
    //--- set the chart's corner, relative to which point coordinates are defined
    ObjectSetInteger(0,obj_name,OBJPROP_CORNER,label_corner);
    //--- set the text
    ObjectSetString(0,obj_name,OBJPROP_TEXT,DoubleToString(NValue0,3));
    //--- set text font
    ObjectSetString(0,obj_name,OBJPROP_FONT,font_name);
    //--- set font size
    ObjectSetInteger(0, obj_name,OBJPROP_FONTSIZE,font_size);
    //--- set the slope angle of the text
    // ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
    //--- set anchor type
    // ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
    //--- set color
    ObjectSetInteger(0,obj_name,OBJPROP_COLOR,NColor0);
    //--- display in the foreground (false) or background (true)
    //ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
    //--- enable (true) or disable (false) the mode of moving the label by mouse
    ObjectSetInteger(0,obj_name,OBJPROP_SELECTABLE,true);
    // ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
    //--- hide (true) or display (false) graphical object name in the object list
    // ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
    //--- set the priority for receiving the event of a mouse click in the chart
     //ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
    //--- successful execution
  }

  if(0<=SValue0){
    obj_name = "Label_Hanrei0S";
    if (ObjectFind(0,obj_name) < 0){
      ObjectCreate(0,obj_name, OBJ_LABEL, 0, 0,0);
       	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
    }
    ObjectSetInteger(0,obj_name,OBJPROP_XDISTANCE,Hanrei_posX2);
    ObjectSetInteger(0,obj_name,OBJPROP_YDISTANCE,Hanrei_posY);
    ObjectSetInteger(0,obj_name,OBJPROP_CORNER,label_corner);
    ObjectSetString(0,obj_name,OBJPROP_TEXT,DoubleToString(SValue0,3));
    ObjectSetString(0,obj_name,OBJPROP_FONT,font_name);
    ObjectSetInteger(0, obj_name,OBJPROP_FONTSIZE,font_size);
    ObjectSetInteger(0,obj_name,OBJPROP_COLOR,SColor0);
    ObjectSetInteger(0,obj_name,OBJPROP_SELECTABLE,true);
  }

  //-----------------------------------------------
  if(0<=NValue1){
    obj_name = "Label_Hanrei1";
    if (ObjectFind(0,obj_name) < 0){
      ObjectCreate(0,obj_name, OBJ_LABEL, 0, 0,0);
       	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
    }
    //--- set label coordinates
    ObjectSetInteger(0,obj_name,OBJPROP_XDISTANCE,Hanrei_posX);
    ObjectSetInteger(0,obj_name,OBJPROP_YDISTANCE,Hanrei_posY+Hanrei_gapY);
    //--- set the chart's corner, relative to which point coordinates are defined
    ObjectSetInteger(0,obj_name,OBJPROP_CORNER,label_corner);
    //--- set the text
    ObjectSetString(0,obj_name,OBJPROP_TEXT,DoubleToString(NValue1,3));
    //--- set text font
    ObjectSetString(0,obj_name,OBJPROP_FONT,font_name);
    //--- set font size
    ObjectSetInteger(0, obj_name,OBJPROP_FONTSIZE,font_size);
    //--- set the slope angle of the text
    // ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
    //--- set anchor type
    // ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
    //--- set color
    ObjectSetInteger(0,obj_name,OBJPROP_COLOR,NColor1);
    //--- display in the foreground (false) or background (true)
    //ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
    //--- enable (true) or disable (false) the mode of moving the label by mouse
    ObjectSetInteger(0,obj_name,OBJPROP_SELECTABLE,true);
    // ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
    //--- hide (true) or display (false) graphical object name in the object list
    // ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
    //--- set the priority for receiving the event of a mouse click in the chart
     //ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
    //--- successful execution
  }

  if(0<=SValue0){
    obj_name = "Label_Hanrei1S";
    if (ObjectFind(0,obj_name) < 0){
      ObjectCreate(0,obj_name, OBJ_LABEL, 0, 0,0);
       	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
    }
    ObjectSetInteger(0,obj_name,OBJPROP_XDISTANCE,Hanrei_posX2);
    ObjectSetInteger(0,obj_name,OBJPROP_YDISTANCE,Hanrei_posY+Hanrei_gapY);
    ObjectSetInteger(0,obj_name,OBJPROP_CORNER,label_corner);
    ObjectSetString(0,obj_name,OBJPROP_TEXT,DoubleToString(SValue1,3));
    ObjectSetString(0,obj_name,OBJPROP_FONT,font_name);
    ObjectSetInteger(0, obj_name,OBJPROP_FONTSIZE,font_size);
    ObjectSetInteger(0,obj_name,OBJPROP_COLOR,SColor1);
    ObjectSetInteger(0,obj_name,OBJPROP_SELECTABLE,true);
  }

  //-----------------------------------------------

  if(0<=NValue2){
    obj_name = "Label_Hanrei2";
    if (ObjectFind(0,obj_name) < 0){
      ObjectCreate(0,obj_name, OBJ_LABEL, 0, 0,0);
       	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
    }
    //--- set label coordinates
    ObjectSetInteger(0,obj_name,OBJPROP_XDISTANCE,Hanrei_posX);
    ObjectSetInteger(0,obj_name,OBJPROP_YDISTANCE,Hanrei_posY+2*Hanrei_gapY);
    //--- set the chart's corner, relative to which point coordinates are defined
    ObjectSetInteger(0,obj_name,OBJPROP_CORNER,label_corner);
    //--- set the text
    ObjectSetString(0,obj_name,OBJPROP_TEXT,DoubleToString(NValue2,3));
    //--- set text font
    ObjectSetString(0,obj_name,OBJPROP_FONT,font_name);
    //--- set font size
    ObjectSetInteger(0, obj_name,OBJPROP_FONTSIZE,font_size);
    //--- set the slope angle of the text
    // ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
    //--- set anchor type
    // ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
    //--- set color
    ObjectSetInteger(0,obj_name,OBJPROP_COLOR,NColor2);
    //--- display in the foreground (false) or background (true)
    //ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
    //--- enable (true) or disable (false) the mode of moving the label by mouse
    ObjectSetInteger(0,obj_name,OBJPROP_SELECTABLE,true);
    // ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
    //--- hide (true) or display (false) graphical object name in the object list
    // ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
    //--- set the priority for receiving the event of a mouse click in the chart
     //ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
    //--- successful execution
  }

  if(0<=SValue2){
    obj_name = "Label_Hanrei2S";
    if (ObjectFind(0,obj_name) < 0){
      ObjectCreate(0,obj_name, OBJ_LABEL, 0, 0,0);
       	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
    }
    ObjectSetInteger(0,obj_name,OBJPROP_XDISTANCE,Hanrei_posX2);
    ObjectSetInteger(0,obj_name,OBJPROP_YDISTANCE,Hanrei_posY+2*Hanrei_gapY);
    ObjectSetInteger(0,obj_name,OBJPROP_CORNER,label_corner);
    ObjectSetString(0,obj_name,OBJPROP_TEXT,DoubleToString(SValue2,3));
    ObjectSetString(0,obj_name,OBJPROP_FONT,font_name);
    ObjectSetInteger(0, obj_name,OBJPROP_FONTSIZE,font_size);
    ObjectSetInteger(0,obj_name,OBJPROP_COLOR,SColor2);
    ObjectSetInteger(0,obj_name,OBJPROP_SELECTABLE,true);
  }

  //-----------------------------------------------

  if(0<=NValue3){
    obj_name = "Label_Hanrei3";
    if (ObjectFind(0,obj_name) < 0){
      ObjectCreate(0,obj_name, OBJ_LABEL, 0, 0,0);
       	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
    }
    //--- set label coordinates
    ObjectSetInteger(0,obj_name,OBJPROP_XDISTANCE,Hanrei_posX);
    ObjectSetInteger(0,obj_name,OBJPROP_YDISTANCE,Hanrei_posY+3*Hanrei_gapY);
    //--- set the chart's corner, relative to which point coordinates are defined
    ObjectSetInteger(0,obj_name,OBJPROP_CORNER,label_corner);
    //--- set the text
    ObjectSetString(0,obj_name,OBJPROP_TEXT,DoubleToString(NValue3,3));
    //--- set text font
    ObjectSetString(0,obj_name,OBJPROP_FONT,font_name);
    //--- set font size
    ObjectSetInteger(0, obj_name,OBJPROP_FONTSIZE,font_size);
    //--- set the slope angle of the text
    // ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
    //--- set anchor type
    // ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
    //--- set color
    ObjectSetInteger(0,obj_name,OBJPROP_COLOR,NColor3);
    //--- display in the foreground (false) or background (true)
    //ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
    //--- enable (true) or disable (false) the mode of moving the label by mouse
    ObjectSetInteger(0,obj_name,OBJPROP_SELECTABLE,true);
    // ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
    //--- hide (true) or display (false) graphical object name in the object list
    // ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
    //--- set the priority for receiving the event of a mouse click in the chart
     //ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
    //--- successful execution
  }

  if(0<=SValue3){
    obj_name = "Label_Hanrei3S";
    if (ObjectFind(0,obj_name) < 0){
      ObjectCreate(0,obj_name, OBJ_LABEL, 0, 0,0);
       	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
    }
    ObjectSetInteger(0,obj_name,OBJPROP_XDISTANCE,Hanrei_posX2);
    ObjectSetInteger(0,obj_name,OBJPROP_YDISTANCE,Hanrei_posY+3*Hanrei_gapY);
    ObjectSetInteger(0,obj_name,OBJPROP_CORNER,label_corner);
    ObjectSetString(0,obj_name,OBJPROP_TEXT,DoubleToString(SValue3,3));
    ObjectSetString(0,obj_name,OBJPROP_FONT,font_name);
    ObjectSetInteger(0, obj_name,OBJPROP_FONTSIZE,font_size);
    ObjectSetInteger(0,obj_name,OBJPROP_COLOR,SColor3);
    ObjectSetInteger(0,obj_name,OBJPROP_SELECTABLE,true);
  }

  //-----------------------------------------------

  if(0<=NValue4){
    obj_name = "Label_Hanrei4";
    if (ObjectFind(0,obj_name) < 0){   //ObjectFind(0,objectname_local)
      ObjectCreate(0,obj_name, OBJ_LABEL, 0, 0,0);
    }
    //--- set label coordinates
    ObjectSetInteger(0,obj_name,OBJPROP_XDISTANCE,Hanrei_posX);
    ObjectSetInteger(0,obj_name,OBJPROP_YDISTANCE,Hanrei_posY+4*Hanrei_gapY);
    //--- set the chart's corner, relative to which point coordinates are defined
    ObjectSetInteger(0,obj_name,OBJPROP_CORNER,label_corner);
    //--- set the text
    ObjectSetString(0,obj_name,OBJPROP_TEXT,DoubleToString(NValue4,3));
    //--- set text font
    ObjectSetString(0,obj_name,OBJPROP_FONT,font_name);
    //--- set font size
    ObjectSetInteger(0, obj_name,OBJPROP_FONTSIZE,font_size);
    //--- set the slope angle of the text
    // ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
    //--- set anchor type
    // ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
    //--- set color
    ObjectSetInteger(0,obj_name,OBJPROP_COLOR,NColor4);
    //--- display in the foreground (false) or background (true)
    //ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
    //--- enable (true) or disable (false) the mode of moving the label by mouse
    ObjectSetInteger(0,obj_name,OBJPROP_SELECTABLE,true);
    // ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
    //--- hide (true) or display (false) graphical object name in the object list
    // ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
    //--- set the priority for receiving the event of a mouse click in the chart
     //ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
    //--- successful execution
  }

  if(0<=SValue4){
    obj_name = "Label_Hanrei4S";
    if (ObjectFind(0,obj_name) < 0){
      ObjectCreate(0,obj_name, OBJ_LABEL, 0, 0,0);
       	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
    }
    ObjectSetInteger(0,obj_name,OBJPROP_XDISTANCE,Hanrei_posX2);
    ObjectSetInteger(0,obj_name,OBJPROP_YDISTANCE,Hanrei_posY+4*Hanrei_gapY);
    ObjectSetInteger(0,obj_name,OBJPROP_CORNER,label_corner);
    ObjectSetString(0,obj_name,OBJPROP_TEXT,DoubleToString(SValue4,3));
    ObjectSetString(0,obj_name,OBJPROP_FONT,font_name);
    ObjectSetInteger(0, obj_name,OBJPROP_FONTSIZE,font_size);
    ObjectSetInteger(0,obj_name,OBJPROP_COLOR,SColor4);
    ObjectSetInteger(0,obj_name,OBJPROP_SELECTABLE,true);
  }

  //-----------------------------------------------

  if(0<=NValue5){
    obj_name = "Label_Hanrei5";
    if (ObjectFind(0,obj_name) < 0){   //ObjectFind(0,objectname_local)
      ObjectCreate(0,obj_name, OBJ_LABEL, 0, 0,0);
    }
    //--- set label coordinates
    ObjectSetInteger(0,obj_name,OBJPROP_XDISTANCE,Hanrei_posX);
    ObjectSetInteger(0,obj_name,OBJPROP_YDISTANCE,Hanrei_posY+5*Hanrei_gapY);
    //--- set the chart's corner, relative to which point coordinates are defined
    ObjectSetInteger(0,obj_name,OBJPROP_CORNER,label_corner);
    //--- set the text
    ObjectSetString(0,obj_name,OBJPROP_TEXT,DoubleToString(NValue5,3));
    //--- set text font
    ObjectSetString(0,obj_name,OBJPROP_FONT,font_name);
    //--- set font size
    ObjectSetInteger(0, obj_name,OBJPROP_FONTSIZE,font_size);
    //--- set the slope angle of the text
    // ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
    //--- set anchor type
    // ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
    //--- set color
    ObjectSetInteger(0,obj_name,OBJPROP_COLOR,NColor5);
    //--- display in the foreground (false) or background (true)
    //ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
    //--- enable (true) or disable (false) the mode of moving the label by mouse
    ObjectSetInteger(0,obj_name,OBJPROP_SELECTABLE,true);
    // ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
    //--- hide (true) or display (false) graphical object name in the object list
    // ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
    //--- set the priority for receiving the event of a mouse click in the chart
     //ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
    //--- successful execution
  }

  if(0<=SValue5){
    obj_name = "Label_Hanrei5S";
    if (ObjectFind(0,obj_name) < 0){
      ObjectCreate(0,obj_name, OBJ_LABEL, 0, 0,0);
       	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
    }
    ObjectSetInteger(0,obj_name,OBJPROP_XDISTANCE,Hanrei_posX2);
    ObjectSetInteger(0,obj_name,OBJPROP_YDISTANCE,Hanrei_posY+5*Hanrei_gapY);
    ObjectSetInteger(0,obj_name,OBJPROP_CORNER,label_corner);
    ObjectSetString(0,obj_name,OBJPROP_TEXT,DoubleToString(SValue5,3));
    ObjectSetString(0,obj_name,OBJPROP_FONT,font_name);
    ObjectSetInteger(0, obj_name,OBJPROP_FONTSIZE,font_size);
    ObjectSetInteger(0,obj_name,OBJPROP_COLOR,SColor5);
    ObjectSetInteger(0,obj_name,OBJPROP_SELECTABLE,true);
  }

  //-----------------------------------------------
  
  if(0<=NValue6){
    obj_name = "Label_Hanrei6";
    if (ObjectFind(0,obj_name) < 0){   //ObjectFind(0,objectname_local)
      ObjectCreate(0,obj_name, OBJ_LABEL, 0, 0,0);
    }
    //--- set label coordinates
    ObjectSetInteger(0,obj_name,OBJPROP_XDISTANCE,Hanrei_posX);
    ObjectSetInteger(0,obj_name,OBJPROP_YDISTANCE,Hanrei_posY+6*Hanrei_gapY);
    //--- set the chart's corner, relative to which point coordinates are defined
    ObjectSetInteger(0,obj_name,OBJPROP_CORNER,label_corner);
    //--- set the text
    ObjectSetString(0,obj_name,OBJPROP_TEXT,DoubleToString(NValue6,3));
    //--- set text font
    ObjectSetString(0,obj_name,OBJPROP_FONT,font_name);
    //--- set font size
    ObjectSetInteger(0, obj_name,OBJPROP_FONTSIZE,font_size);
    //--- set the slope angle of the text
    // ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
    //--- set anchor type
    // ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
    //--- set color
    ObjectSetInteger(0,obj_name,OBJPROP_COLOR,NColor6);
    //--- display in the foreground (false) or background (true)
    //ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
    //--- enable (true) or disable (false) the mode of moving the label by mouse
    ObjectSetInteger(0,obj_name,OBJPROP_SELECTABLE,true);
    // ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
    //--- hide (true) or display (false) graphical object name in the object list
    // ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
    //--- set the priority for receiving the event of a mouse click in the chart
     //ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
    //--- successful execution
  }

  if(0<=SValue6){
    obj_name = "Label_Hanrei6S";
    if (ObjectFind(0,obj_name) < 0){
      ObjectCreate(0,obj_name, OBJ_LABEL, 0, 0,0);
       	  //ObjectCreate(indicator_sname, OBJ_LABEL, 0, 0, 0);
    }
    ObjectSetInteger(0,obj_name,OBJPROP_XDISTANCE,Hanrei_posX2);
    ObjectSetInteger(0,obj_name,OBJPROP_YDISTANCE,Hanrei_posY+6*Hanrei_gapY);
    ObjectSetInteger(0,obj_name,OBJPROP_CORNER,label_corner);
    ObjectSetString(0,obj_name,OBJPROP_TEXT,DoubleToString(SValue6,3));
    ObjectSetString(0,obj_name,OBJPROP_FONT,font_name);
    ObjectSetInteger(0, obj_name,OBJPROP_FONTSIZE,font_size);
    ObjectSetInteger(0,obj_name,OBJPROP_COLOR,SColor6);
    ObjectSetInteger(0,obj_name,OBJPROP_SELECTABLE,true);
  }
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void    OnDeinit(const int reason)
{
  EventKillTimer();
  ObjectDelete(0,indiName+"_RunButton");
  ObjectDelete(0,indiName+"_nRunButton");
  ObjectDelete(0,indiName+"_sRunButton");
  ObjectDelete(0,indiName+"_DelButton");
  ObjectDelete(0,"Label_Hanrei0");
  ObjectDelete(0,"Label_Hanrei0S");
  ObjectDelete(0,"Label_Hanrei1");
  ObjectDelete(0,"Label_Hanrei1S");
  ObjectDelete(0,"Label_Hanrei2");
  ObjectDelete(0,"Label_Hanrei2S");
  ObjectDelete(0,"Label_Hanrei3");
  ObjectDelete(0,"Label_Hanrei3S");
  ObjectDelete(0,"Label_Hanrei4");
  ObjectDelete(0,"Label_Hanrei4S");
  ObjectDelete(0,"Label_Hanrei5");
  ObjectDelete(0,"Label_Hanrei5S");
  ObjectDelete(0,"Label_Hanrei6");
  ObjectDelete(0,"Label_Hanrei6S");
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
//---
  int size_x, size_y;
  int position = 0;
  string text_tmp;

  text_tmp="nFib2TL";
  TextSetFont(font_name, -font_size*10);
  TextGetSize(text_tmp,size_x,size_y);
  if(ObjectFind(0, indiName+"_nRunButton") == -1){
    ButtonCreate(indiName+"_nRunButton", Button1_posX, Button1_posY, size_x+RECTANGLE_X_SPACE, size_y+RECTANGLE_Y_SPACE, chart_corner, text_tmp, font_size, clrWhite, buttonColorOFF);
  }else{
    ButtonModify(indiName+"_nRunButton", Button1_posX, Button1_posY, size_x+RECTANGLE_X_SPACE, size_y+RECTANGLE_Y_SPACE, chart_corner, text_tmp, font_size, clrWhite, buttonColorOFF);
  }

  text_tmp="sFib2TL";
  TextSetFont(font_name, -font_size*10);
  TextGetSize(text_tmp,size_x,size_y);
  if(ObjectFind(0, indiName+"_sRunButton") == -1){
    ButtonCreate(indiName+"_sRunButton", Button2_posX, Button2_posY, size_x+RECTANGLE_X_SPACE, size_y+RECTANGLE_Y_SPACE, chart_corner, text_tmp, font_size, clrWhite, buttonColorOFF);
  }else{
    ButtonModify(indiName+"_sRunButton", Button2_posX, Button2_posY, size_x+RECTANGLE_X_SPACE, size_y+RECTANGLE_Y_SPACE, chart_corner, text_tmp, font_size, clrWhite, buttonColorOFF);
  }

  text_tmp="Del F&TL";
  TextSetFont(font_name, -font_size*10);
  TextGetSize(text_tmp,size_x,size_y);
  if(ObjectFind(0, indiName+"_DelButton") == -1){
    ButtonCreate(indiName+"_DelButton", Button3_posX, Button3_posY, size_x+RECTANGLE_X_SPACE, size_y+RECTANGLE_Y_SPACE, chart_corner, text_tmp, font_size, clrWhite, button2ColorOFF);
  }else{
    ButtonModify(indiName+"_DelButton", Button3_posX, Button3_posY, size_x+RECTANGLE_X_SPACE, size_y+RECTANGLE_Y_SPACE, chart_corner, text_tmp, font_size, clrWhite, button2ColorOFF);
  }
  AddHanrei();

  return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
//---
  int size_x, size_y;
  int position = 0;
  string text_tmp;

  //TextSetFont(font_name, -font_size*10);
  //TextGetSize("Fib2TL",size_x,size_y);
  //if(ObjectFind(0, indiName+"_RunButton") == -1){
  //  ButtonCreate(indiName+"_RunButton", Button1_posX, Button1_posY, size_x+RECTANGLE_X_SPACE, size_y+RECTANGLE_Y_SPACE, chart_corner, "Fib2TL", font_size, clrWhite, buttonColorOFF);
  //}else{
  //  ButtonModify(indiName+"_RunButton", Button1_posX, Button1_posY, size_x+RECTANGLE_X_SPACE, size_y+RECTANGLE_Y_SPACE, chart_corner, "Fib2TL", font_size, clrWhite, buttonColorOFF);
  //}

  //if(ObjectFind(0, indiName+"_DelButton") == -1){
  //  ButtonCreate(indiName+"_DelButton", size*MathAbs(0-position), size*4+Yaxis2, size*5, size*3, chart_corner, "Del F&TL", size, clrWhite, button2ColorOFF);
  //}else{
  //  ButtonModify(indiName+"_DelButton", size*MathAbs(0-position), size*4+Yaxis2, size*5, size*3, chart_corner, "Del F&TL", size, clrWhite, button2ColorOFF);
  //}

  //TextSetFont(font_name, -font_size*10);
  //TextGetSize("Del F&TL",size_x,size_y);
  //if(ObjectFind(0, indiName+"_DelButton") == -1){
  //  ButtonCreate(indiName+"_DelButton", Button2_posX, Button2_posY, size_x+RECTANGLE_X_SPACE, size_y+RECTANGLE_Y_SPACE, chart_corner, "Del F&TL", font_size, clrWhite, button2ColorOFF);
  //}else{
  //  ButtonModify(indiName+"_DelButton", Button2_posX, Button2_posY, size_x+RECTANGLE_X_SPACE, size_y+RECTANGLE_Y_SPACE, chart_corner, "Del F&TL", font_size, clrWhite, button2ColorOFF);
  //}

  text_tmp="nFib2TL";
  TextSetFont(font_name, -font_size*10);
  TextGetSize(text_tmp,size_x,size_y);
  if(ObjectFind(0, indiName+"_nRunButton") == -1){
    ButtonCreate(indiName+"_nRunButton", Button1_posX, Button1_posY, size_x+RECTANGLE_X_SPACE, size_y+RECTANGLE_Y_SPACE, chart_corner, text_tmp, font_size, clrWhite, buttonColorOFF);
  }else{
    ButtonModify(indiName+"_nRunButton", Button1_posX, Button1_posY, size_x+RECTANGLE_X_SPACE, size_y+RECTANGLE_Y_SPACE, chart_corner, text_tmp, font_size, clrWhite, buttonColorOFF);
  }

  text_tmp="sFib2TL";
  TextSetFont(font_name, -font_size*10);
  TextGetSize(text_tmp,size_x,size_y);
  if(ObjectFind(0, indiName+"_sRunButton") == -1){
    ButtonCreate(indiName+"_sRunButton", Button2_posX, Button2_posY, size_x+RECTANGLE_X_SPACE, size_y+RECTANGLE_Y_SPACE, chart_corner, text_tmp, font_size, clrWhite, buttonColorOFF);
  }else{
    ButtonModify(indiName+"_sRunButton", Button2_posX, Button2_posY, size_x+RECTANGLE_X_SPACE, size_y+RECTANGLE_Y_SPACE, chart_corner, text_tmp, font_size, clrWhite, buttonColorOFF);
  }

  TextSetFont(font_name, -font_size*10);
  TextGetSize("Del F&TL",size_x,size_y);
  if(ObjectFind(0, indiName+"_DelButton") == -1){
    ButtonCreate(indiName+"_DelButton", Button3_posX, Button3_posY, size_x+RECTANGLE_X_SPACE, size_y+RECTANGLE_Y_SPACE, chart_corner, "Del F&TL", font_size, clrWhite, button2ColorOFF);
  }else{
    ButtonModify(indiName+"_DelButton", Button3_posX, Button3_posY, size_x+RECTANGLE_X_SPACE, size_y+RECTANGLE_Y_SPACE, chart_corner, "Del F&TL", font_size, clrWhite, button2ColorOFF);
  }

  //ObjectSetInteger(0,indiName+"_RunButton",OBJPROP_STATE,false);
  EventKillTimer();

//---
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
//---
  int size_x, size_y;
  int position=0;
  string text_tmp;

  if(id == CHARTEVENT_OBJECT_CLICK){
    if(sparam == indiName+"_nRunButton"){
      ObjectSetInteger(0,indiName+"_nRunButton",OBJPROP_STATE,true);
      //ButtonModify(indiName+"_RunButton", size*MathAbs(0-position), size*4+Yaxis, size*5, size*3, chart_corner, "Fib2TL", size, clrWhite, buttonColorON);
      text_tmp="nFib2TL";
      TextSetFont(font_name, -font_size*10);
      TextGetSize(text_tmp,size_x,size_y);

      ButtonModify(indiName+"_nRunButton", Button1_posX, Button1_posY, size_x+RECTANGLE_X_SPACE, size_y+RECTANGLE_Y_SPACE, chart_corner, text_tmp, font_size, clrWhite, buttonColorON);

      EventSetMillisecondTimer(200);
      int obj_total= ObjectsTotal(0,0,-1);
      //int Get_Arrow_Code;

      //Print ("Object_total = " + obj_total);

      for (int k= obj_total; k>=0; k--){
        string name= ObjectName(0,k, 0, -1);
        //Print ("Object_name 000 = " + name + " type" + ObjectType(name));
        //if(0<=StringFind(StringSubstr(name,0,4),"PIPS")){
        //   Print ("Object_name 001 = " + name);
        //}
        //Get_Arrow_Code = ObjectGetInteger(0,name,OBJPROP_ARROWCODE, 0);
        if(OBJ_FIBO == ObjectGetInteger (0, name, OBJPROP_TYPE)){
          //Horizontal Line 40925
          //Trendline 43376
          if(0<=StringFind(StringSubstr(name,0,5),"Fibo ")
          || 0<=StringFind(StringSubstr(name,3,5),"Fibo ")
              || 0<=StringFind(StringSubstr(name,4,5),"Fibo ")
              || 0<=StringFind(StringSubstr(name,6,5),"Fibo ")  // Daily
              || 0<=StringFind(StringSubstr(name,7,5),"Fibo ")  // weekly
              || 0<=StringFind(StringSubstr(name,8,5),"Fibo ")  // Monthly
              ){  
            //Print ("Object_name 002 = " + name);
            if(ObjectGetInteger(0, name, OBJPROP_SELECTED)){
              nFiboLevel2TrendLine(name, true);
            }
            ObjectSetInteger(0,name,OBJPROP_SELECTED,false);       // オブジェクトの選択状態
            //Print ("obj name="+name);
          }
        }
      }
      for (int k= obj_total; k>=0; k--){
        string name= ObjectName(0,k, 0, -1);
        //Print ("Object_name 000 = " + name + " type" + ObjectType(name));
        //if(0<=StringFind(StringSubstr(name,0,4),"PIPS")){
        //   Print ("Object_name 001 = " + name);
        //}
        //Get_Arrow_Code = ObjectGetInteger(0,name,OBJPROP_ARROWCODE, 0);
        if(OBJ_FIBO == ObjectGetInteger (0, name, OBJPROP_TYPE)){
          //Horizontal Line 40925
          //Trendline 43376
          if(0<=StringFind(StringSubstr(name,0,5),"Fibo ")
          || 0<=StringFind(StringSubstr(name,3,5),"Fibo ")
              || 0<=StringFind(StringSubstr(name,4,5),"Fibo ")
              || 0<=StringFind(StringSubstr(name,6,5),"Fibo ")  // Daily
              || 0<=StringFind(StringSubstr(name,7,5),"Fibo ")  // weekly
              || 0<=StringFind(StringSubstr(name,8,5),"Fibo ")  // Monthly
              ){  
            //Print ("Object_name 002 = " + name);
            nFiboLevel2TrendLine(name, false);
            ObjectSetInteger(0,name,OBJPROP_SELECTED,false);       // オブジェクトの選択状態
            //Print ("obj name="+name);
          }
        }
      }


      AddHanrei();
    }else if(sparam == indiName+"_sRunButton"){
      ObjectSetInteger(0,indiName+"_RunButton",OBJPROP_STATE,true);
      //ButtonModify(indiName+"_RunButton", size*MathAbs(0-position), size*4+Yaxis, size*5, size*3, chart_corner, "Fib2TL", size, clrWhite, buttonColorON);
      text_tmp="sFib2TL";
      TextSetFont(font_name, -font_size*10);
      TextGetSize(text_tmp,size_x,size_y);

      ButtonModify(indiName+"_sRunButton", Button2_posX, Button2_posY, size_x+RECTANGLE_X_SPACE, size_y+RECTANGLE_Y_SPACE, chart_corner, text_tmp, font_size, clrWhite, buttonColorON);

      EventSetMillisecondTimer(200);
      int obj_total= ObjectsTotal(0,0,-1);
      //int Get_Arrow_Code;

      //Print ("Object_total = " + obj_total);

      for (int k= obj_total; k>=0; k--){
        string name= ObjectName(0,k, 0, -1);
        //Print ("Object_name 000 = " + name + " type" + ObjectType(name));
        //if(0<=StringFind(StringSubstr(name,0,4),"PIPS")){
        //   Print ("Object_name 001 = " + name);
        //}
        //Get_Arrow_Code = ObjectGetInteger(0,name,OBJPROP_ARROWCODE, 0);
        if(OBJ_FIBO == ObjectGetInteger (0, name, OBJPROP_TYPE)){
          //Horizontal Line 40925
          //Trendline 43376
          if(0<=StringFind(StringSubstr(name,0,5),"Fibo ")
          || 0<=StringFind(StringSubstr(name,3,5),"Fibo ")
              || 0<=StringFind(StringSubstr(name,4,5),"Fibo ")
              || 0<=StringFind(StringSubstr(name,6,5),"Fibo ")  // Daily
              || 0<=StringFind(StringSubstr(name,7,5),"Fibo ")  // weekly
              || 0<=StringFind(StringSubstr(name,8,5),"Fibo ")  // Monthly
              ){  
            //Print ("Object_name 002 = " + name);
            if(ObjectGetInteger(0, name, OBJPROP_SELECTED)){
              sFiboLevel2TrendLine(name, true);
            }
            ObjectSetInteger(0,name,OBJPROP_SELECTED,false);       // オブジェクトの選択状態
            //Print ("obj name="+name);
          }
        }
      }
      for (int k= obj_total; k>=0; k--){
        string name= ObjectName(0,k, 0, -1);

        if(OBJ_FIBO == ObjectGetInteger (0, name, OBJPROP_TYPE)){
          //Horizontal Line 40925
          //Trendline 43376
          if(0<=StringFind(StringSubstr(name,0,5),"Fibo ")
          || 0<=StringFind(StringSubstr(name,3,5),"Fibo ")
              || 0<=StringFind(StringSubstr(name,4,5),"Fibo ")
              || 0<=StringFind(StringSubstr(name,6,5),"Fibo ")  // Daily
              || 0<=StringFind(StringSubstr(name,7,5),"Fibo ")  // weekly
              || 0<=StringFind(StringSubstr(name,8,5),"Fibo ")  // Monthly
              ){  
            //Print ("Object_name 002 = " + name);
            sFiboLevel2TrendLine(name, false);
            ObjectSetInteger(0,name,OBJPROP_SELECTED,false);       // オブジェクトの選択状態
            //Print ("obj name="+name);
          }
        }
      }
      AddHanrei();
    }else if(sparam == indiName+"_DelButton"){
      TextSetFont(font_name, -font_size*10);
      TextGetSize("Del F&TL",size_x,size_y);
      ObjectSetInteger(0,indiName+"_DelButton",OBJPROP_STATE,true);
      //ButtonModify(indiName+"_DelButton", size*MathAbs(0-position), size*4+Yaxis2, size_x+4, size*3, chart_corner, "Del F&TL", size, clrWhite, button2ColorON);
      ButtonModify(indiName+"_DelButton", Button3_posX, Button3_posY, size_x+RECTANGLE_X_SPACE, size_y+RECTANGLE_Y_SPACE, chart_corner, "Del F&TL", font_size, clrWhite, button2ColorON);

      EventSetMillisecondTimer(200);
      DelFiboAndTL();
    }

  }
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Create the button                                                |
//+------------------------------------------------------------------+
void ButtonCreate(string name, int x, int y, int width, int height,int corner, string text, int font_size, color clr, color back_clr){

   ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,height);
   ObjectSetInteger(0,name,OBJPROP_CORNER,corner);
   ObjectSetString(0,name,OBJPROP_TEXT,text);
   ObjectSetString(0,name,OBJPROP_FONT, "Segoe UI");
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,font_size);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,back_clr);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrNONE);
   ObjectSetInteger(0,name,OBJPROP_BACK,false);
   ObjectSetInteger(0,name,OBJPROP_STATE,false);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(0,name,OBJPROP_SELECTED,true);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
   ObjectSetInteger(0,name,OBJPROP_ZORDER,10);
}

//+------------------------------------------------------------------+
void ButtonModify(string name, int x, int y, int width, int height,int corner, string text, int font_size, color clr, color back_clr){

   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,height);
   ObjectSetInteger(0,name,OBJPROP_CORNER,corner);
   ObjectSetString(0,name,OBJPROP_TEXT,text);
   ObjectSetString(0,name,OBJPROP_FONT, "Segoe UI");
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,font_size);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,back_clr);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrNONE);
   ObjectSetInteger(0,name,OBJPROP_BACK,false);
   ObjectSetInteger(0,name,OBJPROP_STATE,false);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(0,name,OBJPROP_SELECTED,true);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
   ObjectSetInteger(0,name,OBJPROP_ZORDER,10);
}
//+------------------------------------------------------------------+
void DelFiboAndTL(){
  int obj_total= ObjectsTotal(0,0,-1);
  //int Get_Arrow_Code;

  //Print ("Object_total = " + obj_total);

  for (int k= obj_total; k>=0; k--){
    string name= ObjectName(0,k, 0, -1);
    //Print ("Object_name 000 = " + name + " type" + ObjectType(name));
    //if(0<=StringFind(StringSubstr(name,0,4),"PIPS")){
    //   Print ("Object_name 001 = " + name);
    //}
    //Get_Arrow_Code = ObjectGetInteger(0,name,OBJPROP_ARROWCODE, 0);
    if(OBJ_FIBO == ObjectGetInteger (0, name, OBJPROP_TYPE)){
      //Horizontal Line 40925
      //Trendline 43376
      if(0<=StringFind(StringSubstr(name,0,5),"Fibo ")
          || 0<=StringFind(StringSubstr(name,3,5),"Fibo ")
          || 0<=StringFind(StringSubstr(name,4,5),"Fibo ")
          || 0<=StringFind(StringSubstr(name,6,5),"Fibo ")  // Daily
          || 0<=StringFind(StringSubstr(name,7,5),"Fibo ")  // weekly
          || 0<=StringFind(StringSubstr(name,8,5),"Fibo ")  // Monthly
          ){  
        if(ObjectGetInteger(0,name,OBJPROP_SELECTED,0)){
        //Print ("Object_name 002 = " + name);
        // Is selected?
        //if(selected){
          for(int i = 0 ; i < 20 ; i++){
            ObjectDelete(0,name+"TL"+i);
            ObjectDelete(0,name+"TLn"+i);
            ObjectDelete(0,name+"TLs"+i);
            //ObjectDelete(0,name+"TL1");
            //ObjectDelete(0,name+"TL2");
            //ObjectDelete(0,name+"TL3");
            //ObjectDelete(0,name+"TL4");
            //ObjectDelete(0,name+"TL5");
            //ObjectDelete(0,name+"TL6");
            //ObjectDelete(0,name+"TL7");
            //ObjectDelete(0,name+"TL8");
  
            ObjectDelete(0,name+"TLSEL"+i);
            //ObjectDelete(0,name+"TLSEL1");
            //ObjectDelete(0,name+"TLSEL2");
            //ObjectDelete(0,name+"TLSEL3");
            //ObjectDelete(0,name+"TLSEL4");
            //ObjectDelete(0,name+"TLSEL5");
            //ObjectDelete(0,name+"TLSEL6");
            //ObjectDelete(0,name+"TLSEL7");
            //ObjectDelete(0,name+"TLSEL8");
          }
          ObjectDelete(0,name);
          ChartRedraw(NULL);
          //recored the name;
          //create name of Trend line from the name
          //delete the tl,
          //delete the fibo
        }
      }
    }else if(OBJ_TREND == ObjectGetInteger (0, name, OBJPROP_TYPE)){
      if(0<=StringFind(StringSubstr(name,0,5),"Fibo ")
          || 0<=StringFind(StringSubstr(name,3,5),"Fibo ")
          || 0<=StringFind(StringSubstr(name,4,5),"Fibo ")
          || 0<=StringFind(StringSubstr(name,6,5),"Fibo ")  // Daily
          || 0<=StringFind(StringSubstr(name,7,5),"Fibo ")  // weekly
          || 0<=StringFind(StringSubstr(name,8,5),"Fibo ")  // Monthly
          ){  

        if(ObjectGetInteger(0,name,OBJPROP_SELECTED,0)){
        //Print ("Object_name 002 = " + name);
        // Is selected?
        //if(selected){
          string base_name;
          int index_tl;
          index_tl = StringFind(name, "TL");
          Print ("index tl: "+index_tl);
          if(0<=index_tl){
            base_name = StringSubstr(name,0,index_tl);
            Print ("base_name: "+base_name);
            for(int i = 0 ; i < 20 ; i++){
              ObjectDelete(0,base_name+"TL"+i);
              ObjectDelete(0,base_name+"TLs"+i);
              ObjectDelete(0,base_name+"TLn"+i);
              //ObjectDelete(0,base_name+"TL1");
              //ObjectDelete(0,base_name+"TL2");
              //ObjectDelete(0,base_name+"TL3");
              //ObjectDelete(0,base_name+"TL4");
              //ObjectDelete(0,base_name+"TL5");
              //ObjectDelete(0,base_name+"TL6");
              //ObjectDelete(0,base_name+"TL7");
              //ObjectDelete(0,base_name+"TL8");
  
              ObjectDelete(0,base_name+"TLSEL"+i);
              //ObjectDelete(0,base_name+"TLSEL1");
              //ObjectDelete(0,base_name+"TLSEL2");
              //ObjectDelete(0,base_name+"TLSEL3");
              //ObjectDelete(0,base_name+"TLSEL4");
              //ObjectDelete(0,base_name+"TLSEL5");
              //ObjectDelete(0,base_name+"TLSEL6");
              //ObjectDelete(0,base_name+"TLSEL7");
              //ObjectDelete(0,base_name+"TLSEL8");
            }

            ObjectDelete(0,base_name);
            ChartRedraw(NULL);

          }
        }
      }
    
    }
  }
}
//+------------------------------------------------------------------+

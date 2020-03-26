Cleaner macro code using dosubl

Problem: Given a date return the Quarter, ie Q1,Q2,Q3 or Q4

Even though I am using a datastep this code execute at macro execution time.

SAS Forum
https://communities.sas.com/t5/SAS-Programming/Macro-if-then-do-question/m-p/634114

Currently there are performance issues with dosubl, but it has
the potential to be as fast and in many cases faster than a macro solutuon.

I realize there are much easier ways to do yhis but I tried to ose the ops code

* You need this macro;

%macro dosubl(arg);
  %let rc=%qsysfunc(dosubl(&arg));
%mend dosubl;

* this is the ops code;

%macro Quarter_SAS(Quartercal);
    %let Today_SAS  = %sysfunc(date(),Date9.);
    %LET Run_Date   = %SYSFUNC(INPUTN(&Today_SAS., Date9.));
    %LET Quarter_SAS  = %SYSFUNC(INTNX(MONTH, &Run_Date., 0., B), Date9.);
       %if &Quarter_SAS = ('01MAR2020') %then
          %do;
          %let Quartercal=('Q12020');
          %end;
       %else %if &Quarter_SAS = ('01AUG2020') %then
          %do;
          %let Quartercal=('Q22020');
       %end;
       %else %if &Quarter_SAS = ('01DEC2020') %then
          %do;
          %let Quartercal=('Q32020');
       %end;
       %else %if &Quarter_SAS = ('01JAN2021') %then
          %do;
          %let Quartercal=('Q42020');
       %end;
%mend Quarter_SAS;

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

Need to compute the quarter from

20MAR2020
27MAY2020
15AUG2010
16NOV2010

*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
;

QANS=Q1
QANS=Q2
QANS=Q3
QANS=Q4

*
 _ __  _ __ ___   ___ ___  ___ ___
| '_ \| '__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
;


%symdel q qans / nowarn;  * just in case'

%macro quarter_sas(quarter_call);

  %dosubl('
   data _null_;
      today_sas=today();
      run_date =today();
      quarter_sas = put("&quarter_call"d,yyq.);
      select (quarter_sas);
          when ("2020Q1")  q="Q1";
          when ("2020Q2")  q="Q2";
          when ("2020Q3")  q="Q3";
          when ("2020Q4")  q="Q4";
          otherwise q="NA";
      end;
      call symputx("q",q);
      run;quit;
      %let qans=&q;
  ')

   &qans

%mend Quarter_SAS;


%put %quarter_sas(20MAR2020); %put &=qans;
%put %quarter_sas(27MAY2020); %put &=qans;
%put %quarter_sas(15AUG2020); %put &=qans;
%put %quarter_sas(16NOV2020); %put &=qans;




//+------------------------------------------------------------------+
//|                                                        FRAMA.mq4 |
//|                                           Raul Canessa Castañeda |
//|                               https://www.tecnicasdetrading.com/ |
//+------------------------------------------------------------------+
#property copyright "Raul Canessa"
#property link      "https://www.tecnicasdetrading.com/"
#property version   "1.00"
#property strict
#property description "Media móvil adaptativa fractal (FRAMA) creada con fines ilustrativos. "
                      "Si tienen interés en automatizar sus estrategias "
                      "o crear un indicador técnico personalizado pueden contactarnos al correo rcanessa@gmail.com. "
                      
                      "Más información en www.tecnicasdetrading.com"
//+------------------------------------------------------------------+
//| Función de inicialización de media móvil FRAMA                   |
//+------------------------------------------------------------------+
#property indicator_chart_window 
#property indicator_buffers 1                //Buffer del indicador 1
#property indicator_color1 Blue              //Color de la línea del indicador

extern int Periodo_FRAMA=10;               //Periodo de media móvil FRAMA

input ENUM_APPLIED_PRICE  Precio_Aplicado=0;  //Precio aplicado en el calculo
//Aquí el trader puede escoger entre el precio de cierre (0), precio de apertura(1)
//precio máximo (2), precio mínimo (3), precio mediano (4), precio típico (5) y
//precio ponderado (6)

//extern int Total_barras=3000;           //Número máximo de barras usado en el cálculo

double FRAMA_[];                      //Variable de la media móvil FRAMA
double A_[];                          //Valor del coeficiente de suavizado variable basado en la naturaleza fractal del precio
double D_[];                          //Variable para el cálculo de las dimensiones D=1 a D=2 de la FRAMA
double Tipo_Precio[];    //Tipo de precio aplicado en el cálculo

int OnInit()
  {
   IndicatorBuffers(4);              //Número de buffers para el cálculo del indicador
   SetIndexBuffer(0,FRAMA_);        //Asignación de array a primer buffer del indicador
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2);   // Estílo de línea del indicador
   SetIndexBuffer(1,A_);                        //Asignación de array a segundo buffer del indicador
   SetIndexStyle(1,DRAW_NONE,EMPTY,clrNONE);   // Estílo de línea para buffer 2
   SetIndexBuffer(2,D_);                        //Asignación de array a segundo buffer del indicador
   SetIndexStyle(2,DRAW_NONE,EMPTY,clrNONE);   // Estílo de línea para buffer 2
   SetIndexBuffer(3,Tipo_Precio);                        //Asignación de array a segundo buffer del indicador
   SetIndexStyle(3,DRAW_NONE,EMPTY,clrNONE);   // Estílo de línea para buffer 2
   
   
   //Etiqueta de Técnicas de Trading
   ObjectCreate("Label_Tecnicas", OBJ_LABEL, 0, 0, 0);  //Creación de etiqueta de TecnicadeTrading
   ObjectSet("Label_Tecnicas", OBJPROP_CORNER, 0);    // Esquina de referencia
   ObjectSet("Label_Tecnicas", OBJPROP_XDISTANCE, 20);// Coordenada X
   ObjectSet("Label_Tecnicas", OBJPROP_YDISTANCE, 25);// Coordenada Y
   ObjectSetText("Label_Tecnicas","FRAMA - TecnicasDeTrading.com",16,"Arial",Blue); 
   
   return(INIT_SUCCEEDED);
  }
int deinit()
  {
   ObjectDelete("Label_Tecnicas");
   return(0);
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
//Variables de cálculo  
   int i;                     //Variable de cálculo para el conteo de barras usadas en el cálculo de la FRAMA
   int Cant_Bars;             //Variable para el cálculo de la cantidad de barras contadas por el indicador
   int N;                     //Mitad del número de periodos
   int j=0;                     //Variable de cálculo
   int k;                     //Variable de cálculo
   int Pr;                    //Variable usada para determinar el tipo de precio usado en el cálculo
   double Max1;                        //Máximo de N1
   double Min1;                        //Mínimo de N1
   double Max2;                        //Máximo de N2
   double Min2;                        //Mínimo de N2
   double Max3;                        //Máximo de N3
   double Min3;                        //Mínimo de N3
 
//Conteo de barras para el cálculo del indicador
   Cant_Bars=prev_calculated;    //Número de barras contadas por el indicador
   i=rates_total-Cant_Bars-1;    //Número de barras usadas en el cálculo
   if(i>0)
    j=i-2*Periodo_FRAMA;
   if(i==0)
    j=0; 
//Tipo de precio usado en el cálculo del indicador
   for(Pr=i;Pr>=0;Pr--)
    {
    //Precio usado para el cálculo de la FRAMA 
     if(Precio_Aplicado==0)
      Tipo_Precio[Pr]=Close[Pr];                 //Precio de cierre
     if(Precio_Aplicado==1)                      
      Tipo_Precio[Pr]=Open[Pr];                  //Precio de apertura
     if(Precio_Aplicado==2)
      Tipo_Precio[Pr]=High[Pr];                  //Precio máximo
     if(Precio_Aplicado==3)
      Tipo_Precio[Pr]=Low[Pr];                  //Precio mínimo
     if(Precio_Aplicado==4)
      Tipo_Precio[Pr]=(High[Pr]+Low[Pr])/2;        //Precio mediano
     if(Precio_Aplicado==5)
      Tipo_Precio[Pr]=(High[Pr]+Low[Pr]+Close[Pr])/3;     //Precio típico
     if(Precio_Aplicado==6)
      Tipo_Precio[Pr]=(High[Pr]+Low[Pr]+Close[Pr]+Close[Pr])/4;  //Precio ponderado
    }    
//Cálculo de Rango(Máximo-mínimo)durante el periodo   
   int Periodo=2*Periodo_FRAMA;
   N=MathRound(Periodo/2);
   FRAMA_[Bars-Periodo]=Tipo_Precio[Bars-Periodo];
   while(j>=0)
    {
     Max1=High[j+N-1];
     Min1=Low[j+N-1];
     Max2=High[j+Periodo-1];
     Min2=Low[j+Periodo-1];
     Max3=0;
     Min3=0;
     for(k=j+N-1;k>=j;k--)
      {
   //Cálculo de Máximo/Mínimo de N1  
       if(High[k]>Max1)
        {
         Max1=High[k];
        }  
       if(Low[k]<Min1)
        {
         Min1=Low[k];
        }
   //Cálculo dé Máximo/Mínimo de N2        
       if(High[k+N]>Max2)
        {
         Max2=High[k+N];
        } 
       if(Low[k+N]<Min2)
        {
         Min2=Low[k+N];
        }
      }  
 //Cálculo dé Máximo/Mínimo de N3        
     if(Max1>Max2)
      {
       Max3=Max1;
      }
     else
      {
       Max3=Max2;
      }  
     if(Min1<Min2)
      {
       Min3=Min1;
      }
     else
      {
       Min3=Min2;
      }   
   //Cálculo de la media móvil FRAMA      
     D_[j]=(MathLog10((Max1-Min1)/N+(Max2-Min2)/N)-MathLog10((Max3-Min3)/Periodo))/MathLog10(2);  //Cálculo de las dimensiones de la FRAMA
     A_[j]=MathExp(-4.6*(D_[j]-1));                     //Cálculo de coeficiente de suavizado dinámico
     FRAMA_[j]=FRAMA_[j+1]+A_[j]*(Tipo_Precio[j]-FRAMA_[j+1]);      //Cálculo de la media móvil FRAMA final  
     j--;        
     } 
   return(rates_total); 
  }
//+------------------------------------------------------------------+

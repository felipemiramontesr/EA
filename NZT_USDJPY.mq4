//+------------------------------------------------------------------+
//|                                                   NZT_USDJPY.mq4 |
//|                          Mtro. Felipe de Jesús Miramontes Romero |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Mtro. Felipe de Jesús Miramontesr Romero"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

    
//-- Ticket numbers
int ticketBid=0,
    ticketAsk=0;

//-- Precios actuales   
double currentBid = 0.0, 
       currentAsk = 0.0;

int OnInit(){
   EventSetTimer(1);  
   return(INIT_SUCCEEDED);
  }
  
void OnDeinit(const int reason){
//--Destroy timer
   EventKillTimer();   
  }
  
//-- Funcion que se ejecuta cada vez que es recibido un nuevo Tick stream con los nuevos precios de BID y ASK   --//
void OnTick(){
//--Tick
//Alert("Tick");

//-- Constant MQLTick
MqlTick lastTick;
//-- Se comprueba si lastTick tiene información y no es ta vacio.
if(SymbolInfoTick(Symbol(),lastTick)){
   
        //-- Es seleccionada la operacion Bid para porder manipularla
        OrderSelect(ticketBid,SELECT_BY_TICKET);
 
                    //-- Close trade
                    if(lastTick.bid <= currentBid){    
                    //Alert("USD/JPY Bid Closed!");
                    OrderClose(OrderTicket(),10.0,OrderOpenPrice(),3);                         
                                                  }
                    //-- Basket increment, trade modification
                    if(lastTick.bid > currentBid) {   
                    //Alert("USD/JPY Bid basket increased!");
                    OrderModify(OrderTicket(),OrderOpenPrice(),lastTick.bid-0.002,OrderTakeProfit(),0,CLR_NONE);
                   
                    //-- Es seleccionada la operacion Ask para porder manipularla                                        }
                    OrderSelect(ticketAsk,SELECT_BY_TICKET);     
                    
                    //Alert("USD/JPY Ask Closed!"); 
                    OrderClose(OrderTicket(),10.0,OrderOpenPrice(),3);
                                                  }
        //-- Es seleccionada la operacion Ask para porder manipularla                                        }
        OrderSelect(ticketAsk,SELECT_BY_TICKET);
        
                    //-- Close trade
                    if(lastTick.ask >= currentAsk){
                    //Alert("USD/JPY Ask Closed!"); 
                    OrderClose(OrderTicket(),10.0,OrderOpenPrice(),3);                         
                                                  }     
                    //-- Basket increment, trade modification                                         
                    if(lastTick.ask < currentAsk) {
                    //Alert("USD/JPY Bid basket increased!");
                    OrderModify(OrderTicket(),OrderOpenPrice(),lastTick.ask+0.002,OrderTakeProfit(),0,CLR_NONE); 
                    
                    //-- Es seleccionada la operacion Bid para porder manipularla
                    OrderSelect(ticketBid,SELECT_BY_TICKET);
                     
                    //Alert("USD/JPY Bid Closed!");
                    OrderClose(OrderTicket(),10.0,OrderOpenPrice(),3);
                                                  }                                                 
                                     }
//-- Se acutualizan los precios actuales 
currentBid = lastTick.bid;
currentAsk = lastTick.ask;
             }//Fin de onTick function ------------------------------------------------------------------------//
             
void OnTimer()
{
   //Alert("X: "+ ticketBid + "," + " Y: " + ticketAsk);
   //-- Execution Margin
   double executionMargin = 0.05;  
   //-- Slippage
   int slippage = 3;
   //-- Stop loss
   double stopLoss = 0.02;
   //-- Take profit
   double takeProfit = 0.13;
   //-- Magic Numbers
   int mBuy = 1801;
   int mSell = 15311;
   //-- Target Dates
   int NYo[6], date_1[6], date_2[6];
   
   //Fecha de apertura de la bolsa de New York       
   NYo[0]=2015;
   NYo[1]=10;
   NYo[2]=15;
   NYo[3]=7;
   NYo[4]=29;
   NYo[5]=59;
   
   //Fecha de un concurrencia X
   date_1[0]= 2015;
   date_1[1]= 10;
   date_1[2]= 15;
   date_1[3]= 8;
   date_1[4]= 59;
   date_1[5]= 59;
   
    //Fecha de un concurrencia X
   date_2[0]= 2015;
   date_2[1]= 10;
   date_2[2]= 15;
   date_2[3]= 9;
   date_2[4]= 29;
   date_2[5]= 59;
   
   //Variables de tiempo
   MqlDateTime strucTiempoLocal;
   datetime tiempoLocal = TimeLocal();  
   TimeToStruct(tiempoLocal,strucTiempoLocal);
   
   ///------------------------------ Date x Trade Center Open Time  -----------------------------------------///
     if(NYo[0]==strucTiempoLocal.year && NYo[1]==strucTiempoLocal.mon &&
        NYo[2]==strucTiempoLocal.day && NYo[3]==strucTiempoLocal.hour &&
        NYo[4]==strucTiempoLocal.min && NYo[5]==strucTiempoLocal.sec){
       
        MqlTick lastTick;
        Alert("Here we go bitch, New York open, USD/JPY !!! Bid price: "+ lastTick.bid+" Ask price: "+lastTick.ask);
        if(SymbolInfoTick(Symbol(),lastTick)){
   
          ticketBid = OrderSend(Symbol(),OP_SELLSTOP,10.0,lastTick.ask-executionMargin,slippage,
          lastTick.ask-executionMargin+stopLoss,lastTick.ask-executionMargin-takeProfit,"SELL",mSell,0,CLR_NONE); 
          Alert("Bid Ticket: " + ticketBid);
          
          ticketAsk = OrderSend(Symbol(),OP_BUYSTOP,10.0,lastTick.bid+executionMargin,slippage,
          lastTick.bid+executionMargin-stopLoss,lastTick.bid+executionMargin+takeProfit,"BUY",mBuy,0,CLR_NONE);                                                                       
          Alert("Ask Ticket: " + ticketAsk);
          
          Alert("Congratulations Eddie, USD/JPY Rocket launched!!!");
          
                                              }
                                                                         }
                                                                         
     ///------------------------------ End of Trades Block ----------------------------------------------------///
     
     
     ///------------------------------ Date x ----------------------------------------------------------------///
     if(date_1[0]==strucTiempoLocal.year && date_1[1]==strucTiempoLocal.mon &&
        date_1[2]==strucTiempoLocal.day && date_1[3]==strucTiempoLocal.hour &&
        date_1[4]==strucTiempoLocal.min && date_1[5]==strucTiempoLocal.sec){
       
        MqlTick lastTick;
        Alert("Here we go bitch, USD/JPY !!! Bid price: "+ lastTick.bid+" Ask price: "+lastTick.ask);
            
        if(SymbolInfoTick(Symbol(),lastTick)){
   
          ticketBid = OrderSend(Symbol(),OP_SELLSTOP,10.0,lastTick.ask-executionMargin,slippage,
          lastTick.ask-executionMargin+stopLoss,lastTick.ask-executionMargin-takeProfit,"SELL",mSell,0,CLR_NONE); 
          Alert("Bid Ticket: " + ticketBid);
          
          ticketAsk = OrderSend(Symbol(),OP_BUYSTOP,10.0,lastTick.bid+executionMargin,slippage,
          lastTick.bid+executionMargin-stopLoss,lastTick.bid+executionMargin+takeProfit,"BUY",mBuy,0,CLR_NONE);                                                                       
          Alert("Ask Ticket: " + ticketAsk);
          
          Alert("Congratulations Eddie, USD/JPY Rocket launched!!!");
          
                                              }
                                                                         }
                                                                         
     ///------------------------------ End of Trades Block ----------------------------------------------------///
     
      ///------------------------------ Date x ----------------------------------------------------------------///
     if(date_2[0]==strucTiempoLocal.year && date_2[1]==strucTiempoLocal.mon &&
        date_2[2]==strucTiempoLocal.day && date_2[3]==strucTiempoLocal.hour &&
        date_2[4]==strucTiempoLocal.min && date_2[5]==strucTiempoLocal.sec){
       
        MqlTick lastTick;
        Alert("Here we go bitch, USD/JPY !!! Bid price: "+ lastTick.bid+" Ask price: "+lastTick.ask);
            
        if(SymbolInfoTick(Symbol(),lastTick)){
   
          ticketBid = OrderSend(Symbol(),OP_SELLSTOP,10.0,lastTick.ask-executionMargin,slippage,
          lastTick.ask-executionMargin+stopLoss,lastTick.ask-executionMargin-takeProfit,"SELL",mSell,0,CLR_NONE); 
          Alert("Bid Ticket: " + ticketBid);
          
          ticketAsk = OrderSend(Symbol(),OP_BUYSTOP,10.0,lastTick.bid+executionMargin,slippage,
          lastTick.bid+executionMargin-stopLoss,lastTick.bid+executionMargin+takeProfit,"BUY",mBuy,0,CLR_NONE);                                                                       
          Alert("Ask Ticket: " + ticketAsk);
          
          Alert("Congratulations Eddie, USD/JPY Rocket launched!!!");
          
                                              }
                                                                         }
                                                                         
     ///------------------------------ End of Trades Block ----------------------------------------------------///
} 
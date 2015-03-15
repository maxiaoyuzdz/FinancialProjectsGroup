bool checkover = false;

    int allstart = totalbars+1;

    int tempstart = allstart;
    int tempstop = 0;

    int numofuptrend = 0;
    
    bool fs = false;
    bool fe = false;

    int ts = 0;
    int te = 0;


    bool isMarkBar = false;
    int pts = -1;
    int pte = -1;

    int numofright = 0;
    int numofcon = 0;

    bool isneedtrend = false;


    for(int i = FlushedNumOfBars + 1; i >=0; i--)
    {
      
      if(ExtMapBuffer1[i+1]==0 && ExtMapBuffer1[i]>0)
      {
        fs = true;

        ExtMapBuffer3[i] = Open[i] -  100*Point;

        ts = i;
      }

      if(ExtMapBuffer1[i]>0 && ExtMapBuffer1[i-1]==0)
      {
        fe = true;

        ExtMapBuffer4[i] = Close[i] + 100*Point;

        te = i;
      }

      if( fs && fe )

      {
        numofuptrend++;

        fs = false;
        fe = false;



        bool findp = false;

        int p = -1;

        for(int j = ts; j >= te; j--)
        {
            //MODE_EMA MODE_SMA
            double ma8p = iMA(NULL, 0, 8, 0, MODE_EMA, PRICE_CLOSE, j+1) * 10000;
            double ma30p = iMA(NULL, 0, 30, 0, MODE_EMA, PRICE_CLOSE, j+1) * 10000;

            double ma8h = iMA(NULL, 0, 8, 0, MODE_EMA, PRICE_CLOSE, j-1) * 10000;
            double ma30h = iMA(NULL, 0, 30, 0, MODE_EMA, PRICE_CLOSE, j-1) * 10000;

            if( (ma8p<ma30p) && (ma8h>ma30h) )
            {

              ExtMapBuffer4[j] = High[j] + 100*Point;

              findp = true;

              if(j > p)
              {
                p = j;

              }

            }




        }


        if(isneedtrend)
        {
          //(Close[ts]> Close[pts]) && (Close[ts]< Close[pte]) &&
          if( (Close[te]>Close[pte]))
          {

            numofright++;
          }




          isneedtrend = false;
        }


        if(findp)
        {
          if(p > (ts - (ts-te)/3))
          {
            isneedtrend = true;
          numofcon++;
          }
          
        }
        pts = ts;
        pte = te;


        /**
        if(p > (ts - (ts-te)/3))
        {
          //Print( "ok ");
          isneedtrend = true;
          pts = ts;
          pte = te;
          numofcon++;
        }
        */

        








      }



    }

    Print( "num of up trend = ", numofuptrend );

    Print( "num of con trend = ", numofcon );
    Print( "num of right trend = ", numofright );
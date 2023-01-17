<!-- Description : Consumer Remainder View ler düzenlendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Period -->
<querytag>  
    CREATE VIEW [CONSUMER_REMAINDER_MONEY_SUBSCRIPTION] AS
        SELECT     
            CONSUMER_ID, 
            OTHER_MONEY,
            SUBSCRIPTION_ID,
            SUM(BORC-ALACAK) AS BAKIYE, 
            SUM(BORC2-ALACAK2) AS BAKIYE2,
            SUM(BORC3-ALACAK3) AS BAKIYE3,
            SUM(BORC) AS BORC,
            SUM(BORC2) AS BORC2,
            SUM(BORC3) AS BORC3,
            SUM(ALACAK) AS ALACAK,
            SUM(ALACAK2) AS ALACAK2,
            SUM(ALACAK3) AS ALACAK3,
            CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC3,
            CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK3
        FROM         
            CARI_ROWS_CONSUMER
        GROUP BY 
            CONSUMER_ID, 	
            OTHER_MONEY,
            SUBSCRIPTION_ID
</querytag>
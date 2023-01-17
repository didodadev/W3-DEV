<!-- Description : CoNSUMER Remainder View ler düzenlendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Period -->
<querytag> 
   		CREATE VIEW [CONSUMER_REMAINDER_SUBSCRIPTION] AS
        SELECT     
            CONSUMER_ID, 
            SUBSCRIPTION_ID,
            ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
            ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2, 
            SUM(BORC) AS BORC,
            SUM(BORC2) AS BORC2,
            SUM(ALACAK) AS ALACAK,
            SUM(ALACAK2) AS ALACAK2,
            CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
            CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK
        FROM         
            CARI_ROWS_CONSUMER
        GROUP BY 
            CONSUMER_ID, 
            SUBSCRIPTION_ID
</querytag>
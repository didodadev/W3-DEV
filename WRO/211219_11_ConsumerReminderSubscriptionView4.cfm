<!-- Description : Consumer Remainder View ler düzenlendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Period -->
<querytag>
       CREATE VIEW [CONSUMER_REMAINDER_ACC_TYPE] AS
        SELECT
            CONSUMER_ID, 
            ACC_TYPE_ID,
            ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
            ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2,
            ROUND(SUM(BORC),5) AS BORC,
            ROUND(SUM(BORC2),5) AS BORC2,
            ROUND(SUM(ALACAK),5) AS ALACAK,
            ROUND(SUM(ALACAK2),5) AS ALACAK2,
            CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
            CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK	
        FROM
            CARI_ROWS_CONSUMER
        GROUP BY
            CONSUMER_ID,
            ACC_TYPE_ID
</querytag>
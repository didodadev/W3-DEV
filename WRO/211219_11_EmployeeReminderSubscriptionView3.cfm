<!-- Description :Employee Remainder View ler düzenlendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Period -->
<querytag>
         CREATE VIEW [EMPLOYEE_REMAINDER_MONEY_SUBSCRIPTION] AS
			SELECT
				EMPLOYEE_ID, 
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC2-ALACAK2) AS BAKIYE2,
				SUM(BORC3-ALACAK3) AS BAKIYE3,
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(BORC3) AS BORC3,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				SUM(ALACAK3) AS ALACAK3,
				OTHER_MONEY,
				SUBSCRIPTION_ID,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK3,
				ACC_TYPE_ID
			FROM
				CARI_ROWS_EMPLOYEE
			GROUP BY
				EMPLOYEE_ID,
				OTHER_MONEY,
				SUBSCRIPTION_ID,
				ACC_TYPE_ID
</querytag>
<!-- Description : Company Remainder View ler düzenlendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Period -->
<querytag>
    ALTER VIEW [CARI_ROWS_TOPLAM] AS
    SELECT
        CASE WHEN C.TO_CMP_ID IS NOT NULL THEN  SUM(C.ACTION_VALUE) ELSE 0 END AS BORC,
        CASE WHEN C.TO_CMP_ID IS NOT NULL THEN SUM(C.ACTION_VALUE_2) ELSE 0 END AS BORC2,		
        CASE WHEN C.FROM_CMP_ID IS NOT NULL THEN SUM(C.ACTION_VALUE) ELSE 0 END AS ALACAK,
        CASE WHEN C.FROM_CMP_ID IS NOT NULL THEN SUM(C.ACTION_VALUE_2) ELSE 0  END AS ALACAK2,
        CASE WHEN C.FROM_CMP_ID IS NOT NULL THEN SUM(ISNULL(OTHER_CASH_ACT_VALUE,0)) ELSE 0  END AS ALACAK3,				
        CASE WHEN C.TO_CMP_ID IS NOT NULL THEN C.TO_CMP_ID ELSE C.FROM_CMP_ID  END AS COMPANY_ID,
        CASE WHEN C.TO_CMP_ID IS NOT NULL THEN SUM(ISNULL(OTHER_CASH_ACT_VALUE,0)) ELSE 0 END AS BORC3,
        OTHER_MONEY,
        CASE WHEN DATEDIFF(day,ACTION_DATE,ISNULL(DUE_DATE,ACTION_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,ACTION_DATE,ISNULL(DUE_DATE,ACTION_DATE)) END AS DATE_DIFF,
        CASE WHEN DATEDIFF(day,ISNULL(DUE_DATE,ACTION_DATE),GETDATE()) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(DUE_DATE,ACTION_DATE),GETDATE()) END AS DUE_DATE_DIFF,
        ACTION_DATE,
        DUE_DATE,
        PROJECT_ID,
        SUBSCRIPTION_ID,
        ACC_TYPE_ID,
        ACTION_TYPE_ID,
        ISNULL(TO_BRANCH_ID,FROM_BRANCH_ID) BRANCH_ID,
        C.FROM_CMP_ID,
        C.TO_CMP_ID
    FROM
        CARI_ROWS C
    WHERE
        C.TO_CMP_ID IS NOT NULL OR C.FROM_CMP_ID IS NOT NULL
    GROUP BY
        C.FROM_CMP_ID,
        C.TO_CMP_ID,
        OTHER_MONEY,
        ACTION_DATE,
        DUE_DATE,
        PROJECT_ID,
        SUBSCRIPTION_ID,
        ACC_TYPE_ID,
        ACTION_TYPE_ID,
        ISNULL(TO_BRANCH_ID,FROM_BRANCH_ID)
</querytag>
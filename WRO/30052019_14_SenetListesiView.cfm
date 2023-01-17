
<!-- Description : Senet Listesi kalan tutar için view düzenlemesi yapıldı.
Developer: Esma Uysal
Company : Workcube
Destination: Period-->
<querytag>
    ALTER VIEW [VOUCHER_REMAINING_AMOUNT] AS			
        SELECT
            VOUCHER_ID,
            VOUCHER_VALUE-SUM(CLOSED_AMOUNT) REMAINING_VALUE,
            OTHER_MONEY_VALUE - ROUND(SUM((CLOSED_AMOUNT)*(V.OTHER_MONEY_VALUE/V.VOUCHER_VALUE)),4) OTHER_REMAINING_VALUE,
            OTHER_MONEY_VALUE2 - ROUND(SUM((CLOSED_AMOUNT)*(V.OTHER_MONEY_VALUE2/V.VOUCHER_VALUE)),4) OTHER_REMAINING_VALUE2
        FROM
            VOUCHER V,
            VOUCHER_CLOSED VC
        WHERE
            V.VOUCHER_ID = VC.ACTION_ID
            AND V.OTHER_MONEY_VALUE2 > 0
        GROUP BY
            VOUCHER_ID,VOUCHER_VALUE,OTHER_MONEY_VALUE,OTHER_MONEY_VALUE2
    UNION
        SELECT
            VOUCHER_ID,
            SUM(VOUCHER_VALUE) REMAINING_VALUE,
            SUM(OTHER_MONEY_VALUE) OTHER_REMAINING_VALUE,
            SUM(OTHER_MONEY_VALUE2) OTHER_REMAINING_VALUE2
        FROM
            VOUCHER V
        WHERE
            VOUCHER_ID NOT IN(SELECT ACTION_ID FROM VOUCHER_CLOSED WHERE ACTION_ID = VOUCHER_ID)
            AND V.OTHER_MONEY_VALUE2 > 0
        GROUP BY
            VOUCHER_ID
</querytag>
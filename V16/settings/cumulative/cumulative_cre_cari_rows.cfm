<cfsetting showdebugoutput="no">
<cf_date tarih = 'attributes.date'>
<cf_date tarih = 'attributes.date2'>
<cfquery name="GET_MONTHLY_CARI_ROWS" datasource="#attributes.new_donem_data_source#">
    SELECT
        ACTION_TYPE_ID AS PROCESS_TYPE,
        COUNT(ACTION_TYPE_ID) PAPER_COUNT,
        ISNULL(SUM(BORC+ALACAK),0) AS ACTION_VALUE,
        ISNULL(SUM(BORC2+ALACAK2),0) AS ACTION_VALUE_2,
        CASE WHEN SUM(BORC+ALACAK)= 0 THEN SUM(((BORC+ALACAK)*DATE_DIFF)) ELSE ROUND((SUM(((BORC+ALACAK)*DATE_DIFF))/SUM(BORC+ALACAK)),0) END AS VADE_TOPLAM,
		ISNULL(PROJECT_ID,0) AS PROJECT_ID
    FROM
        CARI_ROWS_TOPLAM
	WHERE 
    	ACTION_DATE >= #attributes.date# AND
        ACTION_DATE <= #attributes.date2#
    GROUP BY
        ACTION_TYPE_ID,
		PROJECT_ID
    ORDER BY
        PROCESS_TYPE
</cfquery>
<cfif GET_MONTHLY_CARI_ROWS.recordcount>
	<cfoutput query="GET_MONTHLY_CARI_ROWS">
    	<cfquery name="ADD_MONTHLY_CARI_ROWS" datasource="#DSN_REPORT#">
            INSERT 
                INTO 
                CARI_MONTH
                    (
                        PERIOD_MONTH,
                        PERIOD_YEAR,
                        OUR_COMPANY_ID,
                        PROCESS_TYPE,
                        PAPER_COUNT,
                        MONEY_VALUE,
                        OTHER_MONEY_VALUE,
                        MONEY,
                        OTHER_MONEY,
                        AVERAGE_DUEDATE,
                        PROJECT_ID
                    )
                VALUES
                    (
                        #attributes.period_month#,
                        #attributes.period_year#,
                        #attributes.period_our_company_id#,
                        #PROCESS_TYPE#,
                        #PAPER_COUNT#,
                        #ACTION_VALUE#,
                        #ACTION_VALUE_2#,
                        '#session.ep.money#',
                        '#session.ep.money2#',
                        #VADE_TOPLAM#,
                        #PROJECT_ID#
                    )
        </cfquery>
	</cfoutput>
</cfif>
<script type="text/javascript">
	user_info_show_div(1,1,1);
</script>
<cfquery name="UPD_FLAG_STOCK_MONTHLY" datasource="#DSN_REPORT#"><!--- BELİRTİLEN AY BAZINDA KÜMÜLE RAPOR HAZIRLANDI BU SEBEBLE FINIS_DATE'I DOLDURUYORUZ.FINISH_DATE YOKSA  RAPOR YARIM KALMIŞ DEMEKTİR... --->
    UPDATE 
        REPORT_SYSTEM 
    SET 
        PROCESS_FINISH_DATE = #NOW()#,
        PROCESS_ROW_COUNT = #GET_MONTHLY_CARI_ROWS.recordcount#
    WHERE 
        REPORT_TABLE = 'CARI_MONTH' AND 
        PERIOD_YEAR = #attributes.period_year# AND 
        PERIOD_MONTH = #attributes.period_month# AND 
        OUR_COMPANY_ID = #attributes.period_our_company_id#
</cfquery>

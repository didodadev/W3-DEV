<cfsetting showdebugoutput="no">
<cf_date tarih = 'attributes.date'>
<cf_date tarih = 'attributes.date2'>
<cfparam name="attributes.project_id" default="">
<cfquery name="GET_MONTHLY_CARI_ROWS" datasource="#dsn2#">
    SELECT
        ACTION_TYPE_ID AS PROCESS_TYPE,
        COUNT(ACTION_TYPE_ID) PAPER_COUNT,
        SUM(BORC+ALACAK) AS ACTION_VALUE,
        SUM(BORC2+ALACAK2) AS ACTION_VALUE_2,
        CASE WHEN SUM(BORC+ALACAK)= 0 THEN SUM(((BORC+ALACAK)*DATE_DIFF)) ELSE ROUND((SUM(((BORC+ALACAK)*DATE_DIFF))/SUM(BORC+ALACAK)),0) END AS VADE_TOPLAM
        <cfif len(attributes.project_id)>
		,ISNULL(PROJECT_ID,0)
		</cfif>
    FROM
        CARI_ROWS_TOPLAM
	WHERE 
    	ACTION_DATE >= #attributes.date# AND
        ACTION_DATE <= #attributes.date2#
    GROUP BY
        ACTION_TYPE_ID
        <cfif len(attributes.project_id)>
		,PROJECT_ID
		</cfif>
    ORDER BY
        PROCESS_TYPE
        <cfif len(attributes.project_id)>
		,PROJECT_ID
		</cfif>
</cfquery>
<cfif GET_MONTHLY_CARI_ROWS.recordcount>
	<cfoutput query="GET_MONTHLY_CARI_ROWS">
    	<cfquery name="ADD_MONTHLY_CARI_ROWS" datasource="#DSN_report#">
            INSERT 
                INTO 
                <cfif len(attributes.project_id)>
                CARI_PROJECT_MONTH
                <cfelse>
                CARI_MONTH
                </cfif>
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
                        AVERAGE_DUEDATE
                        <cfif len(attributes.project_id)>
						,PROJECT_ID
						</cfif>
                    )
                VALUES
                    (
                        #attributes.period_month#,
                        #session.ep.period_year#,
                        #session.ep.company_id#,
                        #PROCESS_TYPE#,
                        #PAPER_COUNT#,
                        #ACTION_VALUE#,
                        #ACTION_VALUE_2#,
                        '#session.ep.money#',
                        '#session.ep.money2#',
                        #VADE_TOPLAM#
                        <cfif len(attributes.project_id)>
						,#PROJECT_ID#
						</cfif>
                    )
        </cfquery>
	</cfoutput>
</cfif>
<script type="text/javascript">
	user_info_show_div(1,1,1);
</script>
<cfquery name="UPD_FLAG_STOCK_MONTHLY" datasource="#DSN_report#"><!--- BELİRTİLEN AY BAZINDA KÜMÜLE RAPOR HAZIRLANDI BU SEBEBLE FINIS_DATE'I DOLDURUYORUZ.FINISH_DATE YOKSA  RAPOR YARIM KALMIŞ DEMEKTİR... --->
    UPDATE 
        REPORT_SYSTEM 
    SET 
        PROCESS_FINISH_DATE = #NOW()#
    WHERE 
        REPORT_TABLE = 'CARI_MONTH' AND 
        PERIOD_YEAR = #session.ep.period_year# AND 
        PERIOD_MONTH = #attributes.period_month# AND 
        OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>

<cfquery name="add_temp_report" datasource="#dsn_report#">
    INSERT INTO PRODUCTION_MONTH
    (
        OUR_COMPANY_ID,
        PERIOD_YEAR,
        PERIOD_MONTH,
        STATION_ID,
        STATION_NAME,
        RESULT_COUNT,
        RESULT_MINUTE,
        RESULT_AMOUNT,
        RESULT_PURCHASE_NET_SYSTEM,
        RESULT_PURCHASE_EXTRA_SYSTEM,
        STATION_COST,
        STATION_REFLECTION_COST_SYSTEM,
        TOTAL_COST_RESULT,
        SARF_AMOUNT,
        SARF_PURCHASE_NET_SYSTEM,
        SARF_PURCHASE_EXTRA_SYSTEM,
        SARF_AMOUNT_SB,
        SARF_PURCHASE_NET_SYSTEM_SB,
        SARF_PURCHASE_EXTRA_SYSTEM_SB,
        TOTAL_SARF_AMOUNT,
        TOTAL_COST_SARF
      
    )
    VALUES
    (
        #attributes.period_our_company_id#,
        #attributes.period_year#,
        #attributes.period_month#,
		<cfif len(STATION_ID)>#STATION_ID#<cfelse>NULL</cfif>,
        <cfif len(STATION_ID)>'#GET_STATION.STATION_NAME[listfind(list_station_id,STATION_ID,',')]#'<cfelse>NULL</cfif>,
        #prod_station_result#,
        #prod_station_minute#,
        #prod_amount#,
        #prod_purchase_net_system#,
        #prod_purchase_extra_system#,
        #prod_station_cost#,
        #STATION_REFLECTION_COST_SYSTEM#,
        #STATION_REFLECTION_COST_SYSTEM+prod_purchase_net_system+prod_purchase_extra_system+prod_station_cost#,
        #sarf_amount#,
        #sarf_purchase_net_system#,
        #sarf_purchase_extra_system#,
        #sarf_amount_sb#,
        #sarf_purchase_net_system_sb#,
        #sarf_purchase_extra_system_sb#,
        #sarf_amount+sarf_amount_sb#,
        #sarf_purchase_net_system+sarf_purchase_net_system_sb+sarf_purchase_extra_system+sarf_purchase_extra_system_sb#
    )       
</cfquery>




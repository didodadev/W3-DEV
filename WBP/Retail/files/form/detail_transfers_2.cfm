<cfset only_this_year = 1>
<cfquery name="get_order_date" datasource="#dsn_dev#">
    SELECT ORDER_DAY FROM SEARCH_TABLES_DEFINES
</cfquery>
<cfset order_control_day = -1 * get_order_date.ORDER_DAY>
<cfif month(now()) eq 1 and day(now()) lte order_control_day>
	<cfset only_this_year = 0>
</cfif>

<cfif month(now()) eq 12 and day(now()) gt order_control_day>
	<cfset only_this_year = 0>
</cfif>

<cfquery name="get_periods" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID IS NOT NULL <cfif only_this_year eq 1>AND PERIOD_YEAR = #session.ep.period_year#</cfif>
    	
</cfquery>
<cfquery name="get_periods_ic" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID IS NOT NULL <cfif only_this_year eq 1>AND PERIOD_YEAR = #session.ep.period_year#</cfif>
</cfquery>

<cfquery name="get_dagilim" datasource="#dsn3#">
    SELECT
        (SELECT S.PROPERTY FROM STOCKS S WHERE S.STOCK_ID = T_ALL.STOCK_ID) AS STOK_ADI,
        (SELECT S.PRODUCT_NAME FROM STOCKS S WHERE S.STOCK_ID = T_ALL.STOCK_ID) AS URUN_ADI,
        DISPATCH_SHIP_ID,
        DELIVER_DATE,
        MIKTAR,
        KARSILANAN,
        DEPT_IN,
        DEPT_OUT,
        CODE
    FROM
        (
        <cfoutput query="get_periods">
            SELECT
                ISNULL((
                    SELECT
                        SUM(AMOUNT) AS AMOUNT_TOTAL
                    FROM
                        (
                            <cfset p_count_ = 0>
                            <cfloop query="get_periods_ic">
                                <cfset p_count_ = p_count_ + 1>
                                SELECT 
                                    SROW.AMOUNT
                                FROM 
                                    #dsn#_#get_periods_ic.period_year#_#get_periods_ic.our_company_id#.SHIP_ROW SROW 
                                WHERE 
                                    SROW.WRK_ROW_RELATION_ID = SIR.WRK_ROW_ID
                            <cfif p_count_ neq get_periods_ic.recordcount>
                                UNION ALL
                            </cfif>
                            </cfloop>
                        ) T1
                ),0) AS KARSILANAN,
                SIR.AMOUNT MIKTAR,
                (SELECT D.DEPARTMENT_HEAD FROM #dsn_alias#.DEPARTMENT D WHERE D.DEPARTMENT_ID = SI.DEPARTMENT_IN) AS DEPT_IN,
                (SELECT D.DEPARTMENT_HEAD FROM #dsn_alias#.DEPARTMENT D WHERE D.DEPARTMENT_ID = SI.DEPARTMENT_OUT) AS DEPT_OUT,
                SI.*,
                SIR.STOCK_ID
            FROM
                #dsn#_#period_year#_#our_company_id#.SHIP_INTERNAL SI,
                #dsn#_#period_year#_#our_company_id#.SHIP_INTERNAL_ROW SIR
            WHERE
                SI.DELIVER_DATE >= #dateadd('d',order_control_day,bugun_)# AND
       			SI.DELIVER_DATE < #DATEADD('d',1,bugun_)# AND
                SI.DISPATCH_SHIP_ID = SIR.DISPATCH_SHIP_ID AND
                <cfif isdefined("attributes.stock_id")>
               		SIR.STOCK_ID = #attributes.stock_id#
                <cfelse>
                	SIR.PRODUCT_ID = #attributes.product_id#
                </cfif>
            <cfif currentrow neq get_periods.recordcount>
            UNION ALL
            </cfif>
        </cfoutput>
      ) T_ALL
     WHERE
     	MIKTAR > KARSILANAN   
   	ORDER BY
    	DELIVER_DATE DESC                   
</cfquery>

<cfif not fusebox.fuseaction contains 'emptypopup_detail_transfers_2'>
    <cf_catalystHeader>
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cf_grid_list> 
            <thead>             
                <tr>
                    <th><cf_get_lang dictionary_id='57452.Stok'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='58585.Kod'></th>
                    <th><cf_get_lang dictionary_id='57431.Çıkış'></th>
                    <th><cf_get_lang dictionary_id='57554.Giriş'></th>
                    <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                    <th><cf_get_lang dictionary_id='62060.Karşılanan'></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="get_dagilim">
                <tr>
                    <td>#STOK_ADI#</td>
                    <td>#dateformat(deliver_date,'dd/mm/yyyy')#</td>
                    <td>#DISPATCH_SHIP_ID#</td>
                    <td>#code#</td>
                    <td>#DEPT_OUT#</td>
                    <td>#DEPT_IN#</td>
                    <td style="text-align:right;">#MIKTAR#</td>
                    <td style="text-align:right;">#KARSILANAN#</td>
                </tr>
                </cfoutput>
            </tbody>
        </cf_grid_list> 
    </cf_box>
</div>
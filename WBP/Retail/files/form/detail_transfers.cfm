<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfquery name="get_periods" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD
</cfquery>
<cfquery name="get_periods_ic" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD
</cfquery>
<cfquery name="get_dagilim" datasource="#dsn#">
    SELECT
        DELIVER_DATE,
        MIKTAR,
        KARSILANAN,
        DEPT_IN,
        DEPT_OUT
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
                CASE WHEN SI.DEPARTMENT_IN = #attributes.out_department_id# THEN SIR.AMOUNT ELSE (-1 * SIR.AMOUNT) END AS MIKTAR,
                (SELECT D.DEPARTMENT_HEAD FROM DEPARTMENT D WHERE D.DEPARTMENT_ID = SI.DEPARTMENT_IN) AS DEPT_IN,
                (SELECT D.DEPARTMENT_HEAD FROM DEPARTMENT D WHERE D.DEPARTMENT_ID = SI.DEPARTMENT_OUT) AS DEPT_OUT,
                SI.*
            FROM
                #dsn#_#period_year#_#our_company_id#.SHIP_INTERNAL SI,
                #dsn#_#period_year#_#our_company_id#.SHIP_INTERNAL_ROW SIR
            WHERE
                SI.DELIVER_DATE >= #dateadd('d',order_control_day,bugun_)# AND
       			SI.DELIVER_DATE < #DATEADD('d',1,bugun_)# AND
                SI.DISPATCH_SHIP_ID = SIR.DISPATCH_SHIP_ID AND
                (SI.DEPARTMENT_IN = #attributes.out_department_id# OR SI.DEPARTMENT_OUT = #attributes.out_department_id#) AND
                SIR.STOCK_ID = #attributes.stock_id#
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
<br />

<cfquery name="get_stock" datasource="#dsn3#">
    SELECT
        PRODUCT_NAME,
        PRODUCT_ID,
        PROPERTY
    FROM
        STOCKS
    WHERE
        STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
</cfquery>

<span class="headbold"><cfoutput>#get_stock.PROPERTY#</cfoutput></span>
<table class="medium_list" align="center"> 
<thead>             
    <tr>
    	<th>Tarih</th>
        <th>Çıkış</th>
        <th>Giriş</th>
        <th>Miktar</th>
        <th>Kalan</th>
    </tr>
</thead>
<tbody>
	<cfoutput query="get_dagilim">
	<tr>
    	<td>#dateformat(deliver_date,'dd/mm/yyyy')#</td>
        <td>#DEPT_OUT#</td>
        <td>#DEPT_IN#</td>
        <td style="text-align:right;">#MIKTAR#</td>
        <td style="text-align:right;">#KARSILANAN#</td>
    </tr>
    </cfoutput>
</tbody>
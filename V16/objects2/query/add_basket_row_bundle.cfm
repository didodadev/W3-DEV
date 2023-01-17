<cfif not isdefined("session.pp") and not isdefined("session.ww.userid") and not IsDefined("Cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
	<cfset cookie_name_ = createUUID()>
	<cfcookie name="wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#cookie_name_#" expires="1">
</cfif>
<cfquery name="DEL_COM_ROWS" datasource="#DSN3#">
	DELETE FROM ORDER_PRE_ROWS
	WHERE
		<cfif isdefined("session.pp")>
			RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
		<cfelseif isdefined("session.ww.userid")>
			RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
		<cfelseif not isdefined("session.pp") and not isdefined("session.ww.userid")>
			RECORD_GUEST = 1 AND 
			RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
			COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#"> AND
		</cfif>
		IS_COMMISSION = 1
</cfquery>

<cfquery name="GET_ALL_KARMA_PRODUCT" datasource="#DSN1#">
    SELECT
        KP.ENTRY_ID,
        KP.PRODUCT_AMOUNT,
        KP.MONEY,
        S.STOCK_ID,
        S.IS_KARMA,
        S.IS_PROTOTYPE,
        S.PRODUCT_ID,
        S.PRODUCT_NAME,
        S.TAX,
        S.PROPERTY,
        S.PRODUCT_UNIT_ID,
        KPP.SALES_PRICE PRICE,
        KPP.MONEY PRICE_MONEY,
        KPP.SALES_PRICE_KDV PRICE_KDV
    FROM 
        KARMA_PRODUCTS AS KP,
        #dsn3_alias#.STOCKS S,
        #dsn3_alias#.KARMA_PRODUCTS_PRICE KPP,
        #dsn3_alias#.PRODUCT_UNIT PRODUCT_UNIT
    WHERE
        S.PRODUCT_STATUS = 1 AND 
        S.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
        PRODUCT_UNIT.IS_MAIN = 1 AND
        PRODUCT_UNIT.PRODUCT_ID = S.PRODUCT_ID AND
        KP.STOCK_ID = S.STOCK_ID AND
        KP.KARMA_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
        KPP.STOCK_ID=S.STOCK_ID AND
        KPP.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
        KP.KARMA_PRODUCT_ID = KPP.KARMA_PRODUCT_ID
    ORDER BY
        KP.ENTRY_ID DESC
</cfquery>

<cfquery name="GET_FIRST_" dbtype="query" maxrows="1">
	SELECT * FROM GET_ALL_KARMA_PRODUCT ORDER BY ENTRY_ID DESC
</cfquery>

<cfset attributes.is_prom_asil_hediye = 0>
<cfset number_ = createUUID()>
<cftransaction>
    <cfquery name="ADD_MAIN_PRODUCT_" datasource="#DSN3#">
        INSERT INTO
            ORDER_PRE_ROWS
			(
                UNIQUE_RELATION_ID,
                PRODUCT_ID,
                PRODUCT_NAME,
                QUANTITY,
                PRICE,
                PRICE_KDV,
                PRICE_MONEY,
                TAX,
                STOCK_ID,
                PRODUCT_UNIT_ID,
                PROM_ID,
                PROM_DISCOUNT,
                PROM_AMOUNT_DISCOUNT,
                PROM_COST,
                PROM_MAIN_STOCK_ID,
                PROM_STOCK_AMOUNT,
                IS_PROM_ASIL_HEDIYE,
                PROM_FREE_STOCK_ID,
                PRICE_OLD,
                IS_COMMISSION,
                PRICE_STANDARD,
                PRICE_STANDARD_KDV,
                PRICE_STANDARD_MONEY,
                IS_NONDELETE_PRODUCT,
                RECORD_PERIOD_ID,
                RECORD_PAR,
                RECORD_CONS,
                RECORD_GUEST,
                COOKIE_NAME,
                RECORD_IP,
                RECORD_DATE
			)
			VALUES
			(
                '#number_#',
                #get_first_.product_id#,
                <cfif trim(get_first_.property) is '-'>'#get_first_.product_name#'<cfelse>'#get_first_.product_name# #get_first_.property#'</cfif>,
                #get_first_.product_amount * attributes.istenen_miktar#,
                #get_first_.price#,
                #get_first_.price_kdv#,
                '#get_first_.price_money#',
                #get_first_.tax#,
                #get_first_.stock_id#,
                #get_first_.product_unit_id#,
                NULL,
                NULL,
                NULL,
                NULL,
                #get_first_.stock_id#,
                1,
                #attributes.is_prom_asil_hediye#,
                0,
                NULL,
                0,
                #get_first_.price#,
                #get_first_.price_kdv#,
                '#get_first_.price_money#',
                0,
                #session_base.period_id#,
                <cfif isdefined("session.pp")>#session.pp.userid#<cfelse>NULL</cfif>,
                <cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
                <cfif not isdefined("session.pp") and not isdefined("session.ww.userid")>1<cfelse>0</cfif>,
                <cfif isdefined("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>'#wrk_eval("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#'<cfelse>NULL</cfif>,
                '#cgi.remote_addr#',
                #now()#
			)
	</cfquery>
	<cfquery name="GET_LAST" datasource="#DSN3#">
		SELECT MAX(ORDER_ROW_ID) AS LATEST_ORDER_ROW_ID FROM ORDER_PRE_ROWS
	</cfquery>
</cftransaction>

<cfoutput query="get_all_karma_product">
	<cfif currentrow neq 1>
		<cfquery name="ADD_ALT_PRODUCT_" datasource="#DSN3#">
            INSERT INTO
                ORDER_PRE_ROWS
                (
                    UNIQUE_RELATION_ID,
                    MAIN_ORDER_ROW_ID,
                    PRODUCT_ID,
                    PRODUCT_NAME,
                    QUANTITY,
                    PRICE,
                    PRICE_KDV,
                    PRICE_MONEY,
                    TAX,
                    STOCK_ID,
                    PRODUCT_UNIT_ID,
                    PROM_ID,
                    PROM_DISCOUNT,
                    PROM_AMOUNT_DISCOUNT,
                    PROM_COST,
                    PROM_MAIN_STOCK_ID,
                    PROM_STOCK_AMOUNT,
                    IS_PROM_ASIL_HEDIYE,
                    PROM_FREE_STOCK_ID,
                    PRICE_OLD,
                    IS_COMMISSION,
                    PRICE_STANDARD,
                    PRICE_STANDARD_KDV,
                    PRICE_STANDARD_MONEY,
                    IS_NONDELETE_PRODUCT,
                    RECORD_PERIOD_ID,
                    RECORD_PAR,
                    RECORD_CONS,
                    RECORD_GUEST,
                    COOKIE_NAME,
                    RECORD_IP,
                    RECORD_DATE
                )
                VALUES
                (
                    '#number_#',
                    #get_last.latest_order_row_id#,
                    #product_id#,
                    <cfif trim(property) is '-'>'#product_name#'<cfelse>'#product_name# #property#'</cfif>,
                    #product_amount * attributes.istenen_miktar#,
                    #price#,
                    #price_kdv#,
                    '#price_money#',
                    #tax#,
                    #stock_id#,
                    #product_unit_id#,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    #attributes.stock_id#,
                    1,
                    0,
                    0,
                    null,
                    0,
                    #price#,
                    #price_kdv#,
                    '#price_money#',
                    0,
                    #session_base.period_id#,
                    <cfif isdefined("session.pp")>#session.pp.userid#<cfelse>NULL</cfif>,
                    <cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
                    <cfif not isdefined("session.pp") and not isdefined("session.ww.userid")>1<cfelse>0</cfif>,
                    <cfif isdefined("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>'#wrk_eval("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#'<cfelse>NULL</cfif>,
                    '#cgi.remote_addr#',
                    #now()#
                )
        </cfquery>
    </cfif>
</cfoutput>	


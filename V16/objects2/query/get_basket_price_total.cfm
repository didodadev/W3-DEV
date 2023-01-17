<cfquery name="GET_BASKET_PRICE_TOTAL_" datasource="#DSN3#">
	SELECT 
		SUM(PRICE_STANDARD_KDV*QUANTITY) AS TOTAL_PRICE
	FROM 
	(
        SELECT
            OPR.PRICE_STANDARD_KDV,
            ISNULL(OPR.PRE_STOCK_ID,OPR.STOCK_ID) AS STOCK_ID,
            ISNULL(OPR.PRE_PRODUCT_ID,OPR.PRODUCT_ID) AS PRODUCT_ID,
            OPR.QUANTITY,
            OPR.PROM_ID,
            ISNULL(IS_PROM_ASIL_HEDIYE,0) AS IS_PROM_ASIL_HEDIYE
        FROM
            ORDER_PRE_ROWS OPR,
            PRICE
        WHERE
            ISNULL(OPR.STOCK_ACTION_TYPE,0) NOT IN (1,2,3) AND <!--- bekleyen siparişe alınmaz aşamasındakiler promosyona dahil edilmiyor --->
            ISNULL(OPR.PRE_PRODUCT_ID,OPR.PRODUCT_ID) = PRICE.PRODUCT_ID AND
            OPR.PRICE_KDV > 0 AND
            <cfif isdefined("session.pp")>
                OPR.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
            <cfelseif isdefined("session.ww.userid")>
                OPR.RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
            <cfelseif isdefined("session.ep")>
                OPR.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
            <cfelseif not isdefined("session_base.userid")><!--- sistemde olmayan misafir kullanıcılar için baskete atılan ürünler --->
                OPR.RECORD_GUEST = 1 AND 
                OPR.RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
                OPR.COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#"> AND
            </cfif>
            PRICE.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
            ISNULL(PRICE.STOCK_ID,0) = 0 AND 
            ISNULL(PRICE.SPECT_VAR_ID,0) = 0 AND 
            PRICE.STARTDATE < = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND 
            (PRICE.FINISHDATE > = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR PRICE.FINISHDATE IS NULL)
	) AS T1
</cfquery>
<cfquery name="GET_OTHER_PRODUCTS" datasource="#DSN3#">
	SELECT
		SUM(OPR.PRICE_KDV) TOTAL_P
	FROM
		ORDER_PRE_ROWS OPR,
		PRODUCT P
	WHERE
		ISNULL(OPR.STOCK_ACTION_TYPE,0) NOT IN (1,2,3) AND
		OPR.PRICE_KDV > 0 AND
		P.PRODUCT_ID = OPR.PRODUCT_ID AND
		P.IS_INVENTORY = 0 AND
		<cfif isdefined("session.pp")>
			OPR.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
		<cfelseif isdefined("session.ww.userid")>
			OPR.RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
		<cfelseif isdefined("session.ep")>
			OPR.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		<cfelseif not isdefined("session_base.userid")><!--- sistemde olmayan misafir kullanıcılar için baskete atılan ürünler --->
			OPR.RECORD_GUEST = 1 AND
			OPR.RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
			OPR.COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">
		</cfif>
</cfquery>

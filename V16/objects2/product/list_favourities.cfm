<cfset attributes.myType = 1>

<cfif not isdefined("session.pp") and not isdefined("session.ww.userid") and not IsDefined("Cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
	<cfset cookie_name_ = createUUID()>
	<cfcookie name="wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#cookie_name_#" expires="1">
</cfif>

<cfquery name="GET_FAVOURITIES" datasource="#DSN3#">
	SELECT
	    OP.PRODUCT_ID,
        OP.RECORD_CONS,
        OP.RECORD_PAR,
        OP.RECORD_EMP,
        OP.RECORD_GUEST,
		OP.COOKIE_NAME,
        OP.TYPE, 
		OP.STOCK_ID,     
        P.PRODUCT_NAME  
	FROM
		ORDER_PRE_PRODUCTS OP,
        PRODUCT P
	WHERE
    	OP.PRODUCT_ID = P.PRODUCT_ID AND 
        <cfif isdefined("session.pp.userid")>
			OP.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
		<cfelseif isdefined("session.ww.userid")>
			OP.RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
		<cfelseif isdefined("session.ep")>
			OP.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		<cfelseif not isdefined("session_base.userid")>
			OP.RECORD_GUEST = 1 AND
			OP.RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
			OP.COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#"> AND
		</cfif>   	
        OP.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.mytype#">
</cfquery>

<cfif get_favourities.recordcount>
	<cfset attributes.favourities_list = valuelist(get_favourities.stock_id)>
	<cfinclude template="list_prices.cfm">
</cfif>

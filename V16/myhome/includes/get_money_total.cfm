<cfif not isdefined("attributes.to_day") or not len(attributes.to_day)>
	<cfset attributes.to_day = now()>
</cfif>
<cfquery name="GET_MONEY_TOTALS" datasource="#dsn#">
	SELECT  
		*
	FROM 
		#dsn2_alias#.INVOICE
	WHERE
		PURCHASE_SALES =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PURCHASE_SALES#"> 
		AND
			(
			INVOICE_DATE < (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("D",1,attributes.TO_DAY)#">)
			AND
			INVOICE_DATE > (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("D",-1,attributes.TO_DAY)#">)
			)	
		AND IS_IPTAL <> (<cfqueryparam cfsqltype="cf_sql_integer" value="1">)
</cfquery>
<cfset MONEY_ = 0>
<cfset SALES_ = 0>
<cfset PURCHASE_ = 0>
<cfquery name="get_money_sales" dbtype="query">
	SELECT * FROM GET_MONEY_TOTALS WHERE INVOICE_CAT  IN (62)
</cfquery>
<cfquery name="get_money_purchase" dbtype="query">
	SELECT * FROM GET_MONEY_TOTALS WHERE INVOICE_CAT IN (55,54)
</cfquery>
<cfoutput query="GET_MONEY_TOTALS">
	<cfset MONEY_ += (NETTOTAL-TAXTOTAL)>
</cfoutput>
<cfoutput query="get_money_sales">
	<cfset SALES_ += (NETTOTAL-TAXTOTAL)>
</cfoutput>
<cfoutput query="get_money_purchase">
	<cfset PURCHASE_ += (NETTOTAL-TAXTOTAL)>
</cfoutput>
<cfif get_money_sales.recordCount>
	<cfset MONEY_SALES = MONEY_ - SALES_>
<cfelse>
	<cfset MONEY_SALES = MONEY_>
</cfif>
<cfif get_money_purchase.recordCount>
	<cfset MONEY_PURCHASE = MONEY_ - PURCHASE_>
<cfelse>
	<cfset MONEY_PURCHASE = MONEY_>
</cfif>

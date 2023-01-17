<cfquery name="GET_P" datasource="#DSN3#">
	SELECT 
		PRODUCT_NAME
	FROM 
		STOCKS
	WHERE 
		<cfif isdefined("attributes.product_id")>
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
		<cfelse>
			STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
		</cfif>
</cfquery>
<table cellpadding="0" cellspacing="0" style="width:100%;">
	<tr>
    	<td><h1 class="h_urun"><cfoutput>#get_p.product_name#</cfoutput></h1></td>
    </tr>
</table>

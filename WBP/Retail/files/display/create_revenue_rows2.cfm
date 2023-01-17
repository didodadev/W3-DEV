<cfset dahil_olmayan_tipler = "91,87">
<cf_date tarih= "attributes.startdate">
<cf_date tarih= "attributes.finishdate">

<cfquery name="get_periods" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE PERIOD_YEAR IN (#session.ep.period_Year#)
</cfquery>

<cfif isdefined("attributes.is_ciro")>
	<cfinclude template="create_revenue_rows2_ciro.cfm">
</cfif>

<cfif isdefined("attributes.is_standart_ff")>
	<cfinclude template="create_revenue_rows2_ff.cfm">
</cfif>

<cfif isdefined("attributes.is_cash_out")>
	<cfinclude template="create_revenue_rows2_is_cash_out.cfm">
</cfif>

<cfif isdefined("attributes.is_purchase_sale")>
	<cfinclude template="create_revenue_rows2_purchase_sale.cfm">
</cfif>


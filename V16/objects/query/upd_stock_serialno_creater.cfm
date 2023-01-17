<cfsetting showdebugoutput="no"> 
<cfquery name="get_olds" datasource="#dsn3#">
	SELECT TOP 1 SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE SERIAL_NO LIKE '#attributes.stock_#%' AND SERIAL_NO LIKE '%#attributes.my_seri_#' AND STOCK_ID = #attributes.STOCK_ID# ORDER BY SERIAL_NO DESC
</cfquery>
<cfif get_olds.recordcount>
	<cfset serial_no_ = get_olds.serial_no>
	<cfif Len(stock_)><cfset serial_no_ = replace(serial_no_,'#stock_#','')></cfif>
	<cfif Len(my_seri_)><cfset serial_no_ = replace(serial_no_,'#my_seri_#','')></cfif>
	<cfset serial_no_ = int(serial_no_)>
	<cfset seri_ = serial_no_ + 1>
<cfelse>
	<cfset seri_ = 1>
</cfif>

<cfset seri_baslangic_ = seri_>
<cfloop from="1" to="#6-len(seri_baslangic_)#" index="smk">
	<cfset seri_baslangic_ = "0" & seri_baslangic_>
</cfloop>

<script type="text/javascript">
	document.add_guaranty_.ship_start_no_orta.value = '<cfoutput>#seri_baslangic_#</cfoutput>';
</script>

<!--- <cfif len(startdate)>
	<cf_date tarih="startdate">
</cfif>
<cfif len(finishdate)>
	<cf_date tarih="finishdate">
</cfif> --->

<cfquery name="del_rival_prices" datasource="#dsn3#">
	DELETE FROM PRICE_RIVAL WHERE PR_ID = #PR_ID#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

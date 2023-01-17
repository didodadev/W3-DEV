<!--- del_cc.cfm --->
<cfif isdefined("url.comp")>
	<cfquery name="DEL_CC" datasource="#dsn#">
		DELETE 
			COMPANY_CC 
		WHERE 
			COMPANY_CC_ID = #URL.CCID#
	</cfquery>
<cfelse>
	<cfquery name="DEL_CC" datasource="#dsn#">
		DELETE 
			CONSUMER_CC 
		WHERE 
			CONSUMER_CC_ID = #URL.CCID#
	</cfquery>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

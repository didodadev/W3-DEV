<cfif len(startdate)>
	<cf_date tarih="startdate">
</cfif>
<cfif len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<cfquery name="upd_rival_prices" datasource="#dsn3#">
	UPDATE
		PRICE_RIVAL
	SET
		R_ID = #R_ID#,
		STARTDATE = #STARTDATE#,
		<cfif len(attributes.finishdate)>
		FINISHDATE = #attributes.finishdate#,
		</cfif>
		PRICE = #PRICE#,
		MONEY = '#MONEY#',
		UNIT_ID = #UNIT_ID#, 
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.REMOTE_ADDR#'
	WHERE
		PR_ID = #PR_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

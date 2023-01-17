<cfquery name="DEL_OFFER_PLUS" datasource="#dsn3#">
	DELETE
		RELATED_EVENTS
	WHERE
		CAMPAING_ID = #ATTRIBUTES.CAMPAING_ID#
		AND
		EVENT_ID = #ATTRIBUTES.EVENT_ID#		
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

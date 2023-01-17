<cftransaction>
	<cfquery name="ADD_TMARKET_TO_CAMP" datasource="#dsn3#">
		DELETE FROM
			CAMPAIGN_TARGET_MARKETS
		WHERE
			CAMP_ID = #attributes.CAMP_ID# AND
			TMARKET_ID = #attributes.TMARKET_ID#
	</cfquery>
</cftransaction>
<cfquery name="DEL_TARGET_PEOPLE" datasource="#DSN3#">
    DELETE FROM
	  CAMPAIGN_TARGET_PEOPLE
	WHERE
	   CAMP_ID = #attributes.CAMP_ID# AND
	   TMARKET_ID = #attributes.TMARKET_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

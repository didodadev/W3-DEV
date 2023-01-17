<cfif isdefined("attributes.comp_id")>
	<cfquery name="DEL_CC" datasource="#dsn#">
		DELETE 
		FROM
			COMPANY_CC 
		WHERE 
			COMPANY_CC_ID = #URL.CCID#
	</cfquery>
<cfelse>
	<cfquery name="DEL_CC" datasource="#dsn#">
		DELETE 
		FROM
			CONSUMER_CC 
		WHERE 
			CONSUMER_CC_ID = #URL.CCID#
	</cfquery>
</cfif>
<script type="text/javascript">
	<cfif not (isDefined('attributes.draggable') and len(attributes.draggable))>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
	</cfif>
</script>

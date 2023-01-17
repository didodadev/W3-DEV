<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
	<cfquery name="DEL_PROPERTY" datasource="#DSN1#">
		DELETE
		   PRODUCT_PROPERTY_DETAIL
		WHERE 
		   PRPT_ID = #attributes.PROPERTY_ID#
	</cfquery>
	<cfquery name="DEL_PROPERTY_MAIN" datasource="#DSN1#">
		DELETE
		   PRODUCT_PROPERTY
		WHERE 
		   PROPERTY_ID = #attributes.PROPERTY_ID#
	</cfquery>
	<cf_add_log  log_type="-1" action_id="#attributes.PROPERTY_ID#" action_name="#attributes.head#" data_source="#dsn1#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	location.href="<cfoutput>#request.self#?</cfoutput>fuseaction=prod.list_property";
</script>


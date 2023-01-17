<cfset attributes.RELATED_VARIATION_ID = listdeleteduplicates(attributes.RELATED_VARIATION_ID)>
<cfquery name="ADD_PRODUCT_PROPERTY_DETAIL" datasource="#DSN1#">
	INSERT INTO 
		PRODUCT_PROPERTY_DETAIL 
		(
			IS_ACTIVE,
			PROPERTY_DETAIL,
			PROPERTY_DETAIL_CODE,
			PRPT_ID,
			PROPERTY_VALUES,
			UNIT,
			RELATED_VARIATION_ID,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP,
			ICON_PATCH
		)
		VALUES	
		(
			<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.prop#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.property_detail_code#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prpt_id#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.property_values#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.unit#">,
			<cfif len(attributes.related_variation) and len(attributes.related_variation_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.related_variation_id#"><cfelse>NULL</cfif>,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			<cfif len(attributes.icon_patch) and len(attributes.icon_patch)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.icon_patch#"><cfelse>NULL</cfif>
		)
</cfquery>

<script>
	<cfif not isdefined("attributes.draggable")>
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</cfif>
</script>

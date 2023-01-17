<cfquery name="UPD_PROPERTY_DETAIL" datasource="#dsn1#">
	UPDATE
	   PRODUCT_PROPERTY_DETAIL
	SET
		IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
		PROPERTY_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.property_detail#">,
		PROPERTY_DETAIL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.property_detail_code#">,
		PROPERTY_VALUES = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.property_values#">,
		UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.unit#">,
        RELATED_VARIATION_ID = <cfif len(attributes.related_variation) and len(attributes.related_variation_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.related_variation_id#"><cfelse>NULL</cfif>,
		UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,    
		UPDATE_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		ICON_PATCH=<cfif len(attributes.icon_patch) and len(attributes.icon_patch)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.icon_patch#"><cfelse>NULL</cfif>
	WHERE
		PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.property_detail_id#">
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		location.href = document.referrer;
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
		refresh_variation_upd();
	</cfif>
</script>

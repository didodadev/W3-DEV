<cfif isdefined("attributes.del_all")>
	<cfquery name="del_sub_status" datasource="#dsn#">
		DELETE FROM G_SERVICE_APPCAT_SUB_STATUS WHERE SERVICE_SUB_STATUS_ID = #attributes.service_sub_status_id#
	</cfquery>
</cfif>
<cfif isdefined("attributes.del_all") or ((isdefined("attributes.position_code") and len(attributes.position_code)) or (isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)))>
	<cfquery name="del_sub_status_post" datasource="#dsn#">
		DELETE FROM 
			G_SERVICE_APPCAT_SUB_STATUS_POST
		WHERE 
			SERVICE_SUB_STATUS_ID = #attributes.service_sub_status_id#
			<cfif isdefined("attributes.position_code") and len(attributes.position_code)>
				AND POSITION_CODE = #attributes.position_code#
			</cfif>
			<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
				AND POSITION_CAT_ID = #attributes.position_cat_id#
			</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.del_all") or (isdefined("attributes.position_code_info") and len(attributes.position_code_info))>
	<cfquery name="del_sub_status_info" datasource="#dsn#">
		DELETE FROM 
			G_SERVICE_APPCAT_SUB_STATUS_INFO
		WHERE
			SERVICE_SUB_STATUS_ID = #attributes.service_sub_status_id#
			<cfif isdefined("attributes.position_code_info") and len(attributes.position_code_info)>
				AND POSITION_CODE_INFO = #attributes.position_code_info#
			</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.del_all")>
	<cflocation url="#request.self#?fuseaction=settings.form_add_g_service_app_cat_sub_status" addtoken="no">
<cfelse>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>

<cfif isdefined("attributes.del_all")>
	<cfquery name="del_service_appcat_sub" datasource="#dsn#">
		DELETE FROM G_SERVICE_APPCAT_SUB WHERE SERVICE_SUB_CAT_ID = #attributes.service_cat_sub_id#
	</cfquery>
</cfif>
<cfquery name="del_service_appcat_sub_posts" datasource="#dsn#">
	DELETE FROM 
		G_SERVICE_APPCAT_SUB_POSTS
	WHERE
		SERVICE_SUB_CAT_ID = #attributes.service_cat_sub_id#
		<cfif isdefined("attributes.position_code") and len(attributes.position_code)>
			AND POSITION_CODE = #attributes.position_code#
		</cfif>
		<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
			AND POSITION_CAT_ID = #attributes.position_cat_id#
		</cfif>
		<cfif isdefined("attributes.partner_id") and len(attributes.partner_id)>
			AND SERVICE_PAR_ID = #attributes.partner_id#
		</cfif>
		<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			AND SERVICE_CONS_ID = #attributes.consumer_id#
		</cfif>
</cfquery>
<cfif isdefined("attributes.del_all")>
	<cflocation url="#request.self#?fuseaction=settings.form_add_g_service_app_cat_sub" addtoken="no">
<cfelse>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>

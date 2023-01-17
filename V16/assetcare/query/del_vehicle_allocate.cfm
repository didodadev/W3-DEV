<cfset control_id = attributes.km_control_id>
<cfset residual_control_id = control_id - 1>
<cfquery name="del_allocate" datasource="#dsn#">
	DELETE
	FROM 
		ASSET_P_KM_CONTROL
	WHERE 
		KM_CONTROL_ID = #control_id#	
</cfquery>
<cfquery name="get_residual" datasource="#dsn#">
	SELECT
		IS_RESIDUAL
	FROM
		ASSET_P_KM_CONTROL
	WHERE 
		KM_CONTROL_ID = #residual_control_id# 
</cfquery>
<cfif get_residual.is_residual eq 1>
<cfquery name="del_residual" datasource="#dsn#">
	DELETE
	FROM
		ASSET_P_KM_CONTROL
	WHERE
		KM_CONTROL_ID = #residual_control_id#
</cfquery>
</cfif>
<cfquery name="del_allocate_users" datasource="#dsn#">
	DELETE FROM ASSET_P_KM_CONTROL_USERS WHERE KM_CONTROL_ID = #control_id#
</cfquery>


	<script type="text/javascript">
		location.href='<cfoutput>#request.self#?fuseaction=assetcare.vehicle_allocate&event=add</cfoutput>';
	</script>


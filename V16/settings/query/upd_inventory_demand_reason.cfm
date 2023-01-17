<cfquery name="upd_inventory_cat" datasource="#dsn#">
	UPDATE 
		SETUP_INVENTORY_DEMAND_REASON 
	SET 
		REASON = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.demand_reason#">,
        ACTIVE = <cfif isdefined("attributes.active")>1<cfelse>0</cfif>,
        UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_DATE = #NOW()#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE 
		REASON_ID=#attributes.reason_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_upd_inventory_demand_reason&id=#reason_id#" addtoken="no">

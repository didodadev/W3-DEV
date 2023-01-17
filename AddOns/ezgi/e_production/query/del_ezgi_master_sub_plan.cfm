<cflock name="#CREATEUUID()#" timeout="90">
	<cfquery name="del_vardiya_sales" datasource="#dsn3#">
		DELETE FROM 
        	EZGI_MASTER_ALT_PLAN
		WHERE 
        	MASTER_ALT_PLAN_ID = #master_alt_plan_id#
	</cfquery>
</cflock>
<cflocation url="#request.self#?fuseaction=prod.form_upd_ezgi_master_plan&upd_id=#master_plan_id#" addtoken="no">

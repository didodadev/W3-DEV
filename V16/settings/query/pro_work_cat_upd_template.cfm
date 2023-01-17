<cfquery name="del_cat_template" datasource="#dsn#">
	DELETE FROM PRO_WORK_CAT_TEMPLATE WHERE PRO_WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_cat_id#">
</cfquery>
<cfloop from="1" to="#record_num#" index="kk">
	<cfif len(evaluate("attributes.template_id_#kk#")) and len(evaluate("attributes.process_id_#kk#"))>
		<cfquery name="ADD_PRO_WORK_CAT" datasource="#DSN#">
			INSERT INTO 
				PRO_WORK_CAT_TEMPLATE
				(
					PRO_WORK_CAT_ID,	
					TEMPLATE_ID,
					PROCESS_ID
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_cat_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.template_id_#kk#')#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.process_id_#kk#')#">
				)
		</cfquery>
	</cfif>
</cfloop>
<cflocation url="#request.self#?fuseaction=settings.form_upd_pro_work_cat&id=#work_cat_id#" addtoken="no">

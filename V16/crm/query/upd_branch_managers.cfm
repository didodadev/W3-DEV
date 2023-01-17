<cfloop to="#attributes.branch_recordcount#" from="1" index="i">
	<cfset attributes.sube_pos_code = evaluate("attributes.sube_pos_code#i#")>
	<cfset attributes.sube_pos_name = evaluate("attributes.sube_pos_name#i#")>
	<cfset attributes.operasyon_pos_code = evaluate("attributes.operasyon_pos_code#i#")>
	<cfset attributes.operasyon_pos_name = evaluate("attributes.operasyon_pos_name#i#")>
	<cfset attributes.finans_pos_code = evaluate("attributes.finans_pos_code#i#")>
	<cfset attributes.finans_pos_name = evaluate("attributes.finans_pos_name#i#")>
	<cfset attributes.depo_kod_id = evaluate("attributes.depo_kod_id#i#")>
	
	<cfquery name="upd_branch" datasource="#dsn#">
		UPDATE
			COMPANY_BOYUT_DEPO_KOD
		SET
			SUBE_POS_CODE = <cfif len(attributes.sube_pos_code) and len(attributes.sube_pos_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sube_pos_code#"><cfelse>NULL</cfif>,
			OPERASYON_POS_CODE = <cfif len(attributes.operasyon_pos_code) and len(attributes.operasyon_pos_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.operasyon_pos_code#"><cfelse>NULL</cfif>,
			FINANS_POS_CODE = <cfif len(attributes.finans_pos_code) and len(attributes.finans_pos_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.finans_pos_code#"><cfelse>NULL</cfif>,
			UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		WHERE
			DEPO_KOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.depo_kod_id#">
	</cfquery>
</cfloop>
<cflocation url="#request.self#?fuseaction=crm.branch_managers" addtoken="no">

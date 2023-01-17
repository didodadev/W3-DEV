<cfquery name="UPD_SUB_STATUS" datasource="#DSN#">
	UPDATE 
		G_SERVICE_APPCAT_SUB_STATUS
	SET
		SERVICE_SUB_CAT_ID = <cfif isdefined("attributes.service_sub_cat_id") and len(attributes.service_sub_cat_id)>#attributes.service_sub_cat_id#<cfelse>NULL</cfif>,
		SERVICE_SUB_STATUS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.service_sub_status#">,
        OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.our_company_id#">,        
		ANALYSIS_HOUR = <cfif isdefined("attributes.analysis_hour") and len(attributes.analysis_hour)>#attributes.analysis_hour#<cfelse>NULL</cfif>,
		ANALYSIS_MINUTE = <cfif isdefined("attributes.analysis_minute") and len(attributes.analysis_minute)>#attributes.analysis_minute#<cfelse>NULL</cfif>,
		IS_STATUS = <cfif isdefined("attributes.is_status")>1<cfelse>0</cfif>,
        SERVICE_EXPLAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.explain#">,
		UPDATE_DATE = #now()#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_EMP = #session.ep.userid#		
	WHERE
		SERVICE_SUB_STATUS_ID = #attributes.service_sub_status_id#
</cfquery>
<cfquery name="DEL_ALL_POST" datasource="#DSN#">
	DELETE FROM G_SERVICE_APPCAT_SUB_STATUS_POST WHERE SERVICE_SUB_STATUS_ID = #attributes.service_sub_status_id#
</cfquery>
<cfquery name="DEL_ALL_INFO" datasource="#DSN#">
	DELETE FROM G_SERVICE_APPCAT_SUB_STATUS_INFO WHERE SERVICE_SUB_STATUS_ID = #attributes.service_sub_status_id#
</cfquery>
<cfif isDefined('attributes.TO_EMP_IDS') and len(attributes.TO_EMP_IDS)>
	<cfloop  list="#attributes.TO_EMP_IDS#" delimiters="," index="a">
		<cfquery name="ADD_SUB_STATUS1" datasource="#DSN#">
			INSERT INTO
				G_SERVICE_APPCAT_SUB_STATUS_POST
			(
				SERVICE_SUB_STATUS_ID,
				POSITION_CAT_ID,
				POSITION_CODE
			)
			VALUES
			(
			   #attributes.service_sub_status_id#,
			   NULL,
			   #a#
			)
		</cfquery>
	</cfloop>
</cfif>
<cfif isdefined("attributes.position_cats") and len(attributes.position_cats)>
	<cfloop list="#attributes.position_cats#" index="b" delimiters=",">
		<cfquery name="ADD_SUB_STATUS2" datasource="#DSN#">
			INSERT INTO
				G_SERVICE_APPCAT_SUB_STATUS_POST
			(
				SERVICE_SUB_STATUS_ID,
				POSITION_CAT_ID,
				POSITION_CODE
			)
			VALUES
			(
			   #attributes.service_sub_status_id#,
			   #b#,
			   NULL
			)
		</cfquery>
	</cfloop>
</cfif>
<!--- <cfdump var="#attributes.cc_emp_ids#" abort> --->
<cfif isDefined('attributes.cc_emp_ids') and ListLen(attributes.cc_emp_ids)>
	<cfloop  list="#attributes.cc_emp_ids#" delimiters="," index="c">
		<cfquery name="ADD_SUB_STATUS3" datasource="#DSN#">
			INSERT INTO
				G_SERVICE_APPCAT_SUB_STATUS_INFO
			(
				SERVICE_SUB_STATUS_ID,
				POSITION_CODE_INFO
			)
			VALUES
			(
			   #attributes.service_sub_status_id#,
			   #c#
			)
		</cfquery>
	</cfloop>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.form_upd_g_service_app_cat_sub_status&service_sub_status_id=#attributes.service_sub_status_id#" addtoken="no">

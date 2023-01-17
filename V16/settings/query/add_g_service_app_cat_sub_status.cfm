<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_SERVICE_APPCAT_SUB_STATUS" datasource="#DSN#" result="MAX_ID">
			INSERT INTO 
				G_SERVICE_APPCAT_SUB_STATUS
			(
				SERVICE_SUB_CAT_ID,
				SERVICE_SUB_STATUS,                
                OUR_COMPANY_ID,
				ANALYSIS_HOUR,
				ANALYSIS_MINUTE,
				IS_STATUS,
                SERVICE_EXPLAIN,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP		
			) 
			VALUES 
			(
				<cfif isdefined("attributes.service_sub_cat_id") and len(attributes.service_sub_cat_id)>#attributes.service_sub_cat_id#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.service_sub_status#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.our_company_id#">,
				<cfif isdefined("attributes.analysis_hour") and len(attributes.analysis_hour)>#attributes.analysis_hour#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.analysis_minute") and len(attributes.analysis_minute)>#attributes.analysis_minute#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_status")>1<cfelse>0</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.explain#">,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				#session.ep.userid#
			)
		</cfquery>
	</cftransaction>
</cflock>
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
			   #MAX_ID.IDENTITYCOL#,
			   NULL,
			   #a#
		   )
		</cfquery>
	</cfloop>
</cfif>
<cfif isdefined("attributes.position_cats") and len(attributes.position_cats) gt 0>
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
			   #MAX_ID.IDENTITYCOL#,
			   #b#,
			   NULL
		   )
		</cfquery>
	</cfloop>
</cfif>
<cfif isDefined('attributes.cc_emp_ids') and len(attributes.cc_emp_ids)>
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
			   #MAX_ID.IDENTITYCOL#,
			   #c#
		   )
		</cfquery>
	</cfloop>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.form_add_g_service_app_cat_sub_status" addtoken="no">

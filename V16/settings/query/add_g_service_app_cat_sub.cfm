<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="add_service_appcat_sub" datasource="#dsn#" result="MAX_ID">
			INSERT INTO 
				G_SERVICE_APPCAT_SUB
			(
				SERVICECAT_ID,
				SERVICE_SUB_CAT,
                OUR_COMPANY_ID,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP,
                IS_STATUS		
			) 
			VALUES 
			(
				<cfif isdefined("attributes.servicecat_id") and len(attributes.servicecat_id)>#attributes.servicecat_id#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.servicecat_sub#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.our_company_id#">,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				#session.ep.userid#,
                <cfif isdefined("attributes.is_status")>1<cfelse>0</cfif>
			)
		</cfquery>
	</cftransaction>
</cflock>
<cfif isDefined('attributes.TO_EMP_IDS') and len(attributes.TO_EMP_IDS)>
	<cfloop  list="#attributes.TO_EMP_IDS#" delimiters="," index="a">
		<cfquery name="add_sub_post1" datasource="#dsn#">
			INSERT INTO
				G_SERVICE_APPCAT_SUB_POSTS
			(
				SERVICE_SUB_CAT_ID,
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
	<cfloop list="#attributes.position_cats#" index="b">
		<cfquery name="add_sub_post2" datasource="#dsn#">
			INSERT INTO
				G_SERVICE_APPCAT_SUB_POSTS
			(
				SERVICE_SUB_CAT_ID,
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
<cflocation url="#request.self#?fuseaction=settings.form_add_g_service_app_cat_sub" addtoken="no">

<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="get_related_publish" datasource="#dsn#">
			SELECT ACTION_ID FROM PUBLISH WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
		</cfquery>
		<cfif get_related_publish.recordCount eq 0>
			 <cfquery name="add_publish" datasource="#dsn#">
				INSERT INTO
					PUBLISH
					(	
						ACTION_ID,
						PROCESS_ROW_ID,
						TARGET_COMPANY,
						TARGET_CONSUMER,
						TARGET_EMPLOYEE,
						TARGET_WEBSITE,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">,
						<cfif len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.target_company')>',#attributes.target_company#,'<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.target_consumer')>',#attributes.target_consumer#,'<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.target_employee')>',#attributes.target_employee#,'<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.target_website')>',#attributes.target_website#,'<cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
					)
			</cfquery> 
		<cfelse>
			<cfquery name="upd_publish" datasource="#dsn#">
				UPDATE
					PUBLISH
				SET
					PROCESS_ROW_ID = <cfif len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
					START_DATE = <cfif isdefined('attributes.start_date') and len(attributes.start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateformat(attributes.start_date,dateformat_style)#"><cfelse>NULL</cfif>,
					FINISH_DATE = <cfif isdefined('attributes.finish_date') and len(attributes.finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateformat(attributes.finish_date,dateformat_style)#"><cfelse>NULL</cfif>,
					TARGET_COMPANY = <cfif isdefined('attributes.target_company')>',#attributes.target_company#,'<cfelse>NULL</cfif>,
					TARGET_CONSUMER = <cfif isdefined('attributes.target_consumer')>',#attributes.target_consumer#,'<cfelse>NULL</cfif>,
					TARGET_EMPLOYEE = <cfif isdefined('attributes.target_employee')>',#attributes.target_employee#,'<cfelse>NULL</cfif>,
					TARGET_WEBSITE = <cfif isdefined('attributes.target_website')>',#attributes.target_website#,'<cfelse>NULL</cfif>,
					UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
				WHERE 
					ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<cfif fuseaction contains 'objects'>
	<cflocation addtoken="no" url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_form_upd_detail_survey&survey_id=#attributes.survey_id#">
<cfelse>
	<cflocation addtoken="no" url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_detail_survey&survey_id=#attributes.survey_id#">
</cfif>

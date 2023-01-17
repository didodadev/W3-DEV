<CFLOCK name="#createUUID()#" timeout="20">
	<CFTRANSACTION>
		<cfquery name="upd_report" datasource="#dsn#">
			UPDATE
				REPORTS
			SET
				REPORT_NAME = '#FORM.REPORT_NAME#',
				ADMIN_STATUS = <cfif isdefined("attributes.admin_status")>1,<cfelse>0,</cfif>
				REPORT_DETAIL = '#FORM.REPORT_DETAIL#',
				TEMPLATE_ID = #TEMPLATE_ID#,
				<!---MODULE_ID = #FORM.MODULE_ID#,---> 
				REPORT_STATUS = <cfif isdefined("attributes.report_status")>1<cfelse>0</cfif>,
				UPDATE_EMP = #SESSION.EP.USERID#, 
				UPDATE_IP = '#cgi.REMOTE_ADDR#', 
				UPDATE_DATE = #NOW()#
			WHERE
				REPORT_ID = #attributes.REPORT_ID#
		</cfquery>
		<cfquery name="del_old_queries" datasource="#dsn#">
			DELETE FROM
				REPORTS_QUERIES
			WHERE
				REPORT_ID = #attributes.report_id#		
		</cfquery>
		
		<cfif isdefined("attributes.positions2") and len(attributes.positions2) gt 0>
			<cfloop list="#attributes.positions2#" index="a">
				<cfquery name="add_access_control" datasource="#dsn#">
					SELECT
						COUNT(*) AS ACCESS_CONTROL 
					FROM 
						REPORT_ACCESS_RIGHTS 
					WHERE 
						REPORT_ID = #attributes.report_id#
						AND POS_CAT_ID IS NULL 
						AND POS_CODE = #a#
				</cfquery>
				<cfif add_access_control.ACCESS_CONTROL NEQ 1>
					<cfquery name="add_access" datasource="#dsn#">
						INSERT INTO
							REPORT_ACCESS_RIGHTS
							(
							REPORT_ID,
							POS_CAT_ID,
							POS_CODE
							)
						VALUES
						   (
						   #attributes.report_id#,
						   NULL,
						   #a#
						   )
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfif isdefined("attributes.position_cats") and len(attributes.position_cats) gt 0>
			<cfloop list="#attributes.position_cats#" index="j">
				<cfquery name="add_access_control" datasource="#dsn#">
					SELECT
						COUNT(*) AS ACCESS_CONTROL 
					FROM 
						REPORT_ACCESS_RIGHTS 
					WHERE 
						REPORT_ID = #attributes.report_id#
						AND POS_CAT_ID = #j#
						AND POS_CODE IS NULL 
				</cfquery>
				<cfif add_access_control.ACCESS_CONTROL NEQ 1>
					<cfquery name="add_access" datasource="#dsn#">
						INSERT INTO
							REPORT_ACCESS_RIGHTS
							(
							REPORT_ID,
							POS_CAT_ID,
							POS_CODE
							)
						VALUES
						   (
						   #attributes.report_id#,
						   #j#,
						   NULL
						   )
					</cfquery>
				</cfif>
			</cfloop>	
		</cfif>
		<cfloop from="1" to="#arrayLen(session.report.1.query_id)#" index="i">
			<cfquery name="add_reports_query" datasource="#dsn#">
				INSERT INTO
					REPORTS_QUERIES
					(
					REPORT_ID,
					QUERY_ID,
					DISPLAY_TYPE,
					COLUMN_NO
					)
				VALUES
					(
					#attributes.report_id#,
					#session.report.1.query_id[i]#,
					'#session.report.1.report_type[i]#',
					1
					)
			</cfquery>
		</cfloop>

		<cfif template_id neq 1>
			<cfloop from="1" to="#arrayLen(session.report.2.query_id)#" index="i">
				<cfquery name="add_reports_query" datasource="#dsn#">
					INSERT INTO
						REPORTS_QUERIES
						(
						REPORT_ID,
						QUERY_ID,
						DISPLAY_TYPE,
						COLUMN_NO
						)
					VALUES
						(
						#attributes.report_id#,
						#session.report.2.query_id[i]#,
						'#session.report.2.report_type[i]#',
						2
						)
				</cfquery>
			</cfloop>
		</cfif>	
		
		<cfif (template_id eq 4) or (template_id eq 5)>
			<cfloop from="1" to="#arrayLen(session.report.3.query_id)#" index="i">
				<cfquery name="add_reports_query" datasource="#dsn#">
					INSERT INTO
						REPORTS_QUERIES
						(
						REPORT_ID,
						QUERY_ID,
						DISPLAY_TYPE,
						COLUMN_NO
						)
					VALUES
						(
						#attributes.report_id#,
						#session.report.3.query_id[i]#,
						'#session.report.3.report_type[i]#',
						3
						)
				</cfquery>
			</cfloop>
		</cfif>	

	</CFTRANSACTION>
</CFLOCK>

<cfscript>
	structdelete(session,"report");
</cfscript>

<cflocation url="#request.self#?fuseaction=report.form_upd_report&report_id=#attributes.report_id#" addtoken="no">

<cfset PERCENT = (FORM.PERCENT * FORM.STATUS) + 100>
<cfif isdefined("attributes.work_start_date") and len(attributes.work_start_date)>
	<cf_date tarih="attributes.work_start_date">
</cfif>
<cfif isdefined("attributes.work_finish_date") and len(attributes.work_finish_date)>
	<cf_date tarih="attributes.work_finish_date">
</cfif>

<cfset wrk_id = 'SU' & dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="add_salary_update" datasource="#dsn#" result="MAX_ID">
			INSERT INTO
				SALARY_UPDATE
			(
				SALARY_CODE,
				SALARY_TYPE,
				CONTROL_FINISHDATE,
				UPDATE_PERCENT,
				SAL_MON,
				CHANGE_ALL,
				METHOD_TYPE,
				VALIDATOR_POSITION,
				WORK_START_DATE,
				WORK_FINISH_DATE,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				'#wrk_id#',
				#attributes.salary_type#,
				<cfif isdefined("attributes.control_finishdate")>1,<cfelse>0,</cfif>
				#PERCENT#,
				#sal_mon#,
				<cfif isdefined("change_all")>1<cfelse>0</cfif>,
				#attributes.method_id#,
				<cfif isdefined("attributes.position_code") and len(attributes.position_code)>#position_code#,<cfelse>#session.ep.position_code#,</cfif>
				<cfif isdefined("attributes.work_start_date") and len(attributes.work_start_date)>#attributes.work_start_date#,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.work_finish_date") and len(attributes.work_finish_date)>#attributes.work_finish_date#,<cfelse>NULL,</cfif>
				#session.ep.userid#,
				#now()#,
				'#cgi.remote_addr#'
			)
		</cfquery>
		<cfif isdefined("attributes.our_company_id") and listlen(attributes.our_company_id)>
			<cfloop list="#attributes.our_company_id#" index="i">
				<cfquery name="ADD_SALARY_UPD_COMPANIES" datasource="#DSN#">
					INSERT INTO
						SALARY_UPDATE_COMPANIES
					(
						UPDATE_ID,
						OUR_COMPANY_ID
					)
					VALUES
					(
						#MAX_ID.IDENTITYCOL#,
						#i#
					)
				</cfquery>
			</cfloop>
		</cfif>
		
		<cfloop list="#attributes.sal_year#" index="i" delimiters=",">
			<cfquery name="ADD_SALARY_UPD_YEARS" datasource="#DSN#">
				INSERT INTO
					SALARY_UPDATE_YEARS
				(
					UPDATE_ID,
					SAL_YEAR
				)
				VALUES
				(
					#MAX_ID.IDENTITYCOL#,
					#i#
				)
			</cfquery>
		</cfloop>
		
		<cfif isdefined("attributes.position_cat_id") and listlen(attributes.position_cat_id)>
			<cfloop list="#attributes.position_cat_id#" index="i" delimiters=",">
				<cfquery name="ADD_SALARY_UPD_COMPANIES" datasource="#DSN#">
					INSERT INTO
						SALARY_UPDATE_POSITION_CATS
					(
						UPDATE_ID,
						POSITION_CAT_ID
					)
					VALUES
					(
						#MAX_ID.IDENTITYCOL#,
						#i#
					)
				</cfquery>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>

<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.list_setup_salary&event=upd&update_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>

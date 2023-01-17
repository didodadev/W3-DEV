<cfset PERCENT = (FORM.PERCENT * FORM.STATUS) + 100>
<cfif len(attributes.work_start_date)>
	<cf_date tarih="attributes.work_start_date">
</cfif>
<cfif len(attributes.work_finish_date)>
	<cf_date tarih="attributes.work_finish_date">
</cfif>

<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="add_salary_update" datasource="#dsn#">
			UPDATE
				SALARY_UPDATE
			SET
				SALARY_TYPE = #attributes.salary_type#,
				CONTROL_FINISHDATE = <cfif isdefined("attributes.control_finishdate")>1,<cfelse>0,</cfif>
				UPDATE_PERCENT = #PERCENT#,
				SAL_MON = #sal_mon#,
				CHANGE_ALL = <cfif isDefined("CHANGE_ALL")>1<cfelse>0</cfif>,
				WORK_START_DATE = <cfif len(attributes.work_start_date)>#attributes.work_start_date#<cfelse>NULL</cfif>,
				WORK_FINISH_DATE = <cfif len(attributes.work_finish_date)>#attributes.work_finish_date#<cfelse>NULL</cfif>,
			<cfif isDefined("VALID") and len(VALID)>
				VALID_EMP = #session.ep.userid#,
				VALID_DATE = #now()#,
				VALID = #VALID#,
			<cfelse>
				VALIDATOR_POSITION = #POSITION_CODE#,
			</cfif>
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#cgi.REMOTE_ADDR#'
			WHERE
				UPDATE_ID = #UPDATE_ID#
		</cfquery>

		<cfquery name="clear_Companies" datasource="#dsn#">
			DELETE FROM SALARY_UPDATE_YEARS WHERE UPDATE_ID = #UPDATE_ID#
		</cfquery>
		
		<cfquery name="clear_Companies" datasource="#dsn#">
			DELETE FROM SALARY_UPDATE_COMPANIES WHERE UPDATE_ID = #UPDATE_ID#
		</cfquery>
		
		<cfquery name="clear_position_cats" datasource="#dsn#">
			DELETE FROM SALARY_UPDATE_POSITION_CATS WHERE UPDATE_ID = #UPDATE_ID#
		</cfquery>
		
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
					#UPDATE_ID#,
					#i#
					)
			</cfquery>
		</cfloop>
		
		<cfloop list="#attributes.our_company_id#" index="i" delimiters=",">
			<cfquery name="ADD_SALARY_UPD_COMPANIES" datasource="#DSN#">
				INSERT INTO
					SALARY_UPDATE_COMPANIES
					(
					UPDATE_ID,
					OUR_COMPANY_ID
					)
				VALUES
					(
					#UPDATE_ID#,
					#i#
					)
			</cfquery>
		</cfloop>
		
		<cfif isdefined("attributes.POSITION_CAT_ID")>
			<cfloop list="#attributes.POSITION_CAT_ID#" index="i" delimiters=",">
				<cfquery name="ADD_SALARY_UPD_COMPANIES" datasource="#DSN#">
					INSERT INTO
						SALARY_UPDATE_POSITION_CATS
						(
						UPDATE_ID,
						POSITION_CAT_ID
						)
					VALUES
						(
						#UPDATE_ID#,
						#i#
						)
				</cfquery>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
		<cfif isdefined("valid") and (valid eq 1)>
			<cfinclude template="act_setup_salary.cfm">
		</cfif>
	</cftransaction>
</cflock>

<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.list_setup_salary&event=upd&update_id=#attributes.UPDATE_ID#</cfoutput>';
</script> 

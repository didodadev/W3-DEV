<cfif isDefined("attributes.is_delete") and attributes.is_delete eq 1>
<cflock timeout="60">
	<cftransaction>
		<cfquery name="DEL_salary_update" datasource="#dsn#">
			DELETE FROM SALARY_UPDATE WHERE UPDATE_ID = #attributes.UPDATE_ID#
		</cfquery>
		<cfquery name="DEL_salary_update1" datasource="#dsn#">
			DELETE FROM SALARY_UPDATE_YEARS WHERE UPDATE_ID = #attributes.UPDATE_ID#
		</cfquery>
		<cfquery name="DEL_salary_update2" datasource="#dsn#">
			DELETE FROM SALARY_UPDATE_COMPANIES WHERE UPDATE_ID = #attributes.UPDATE_ID#
		</cfquery>
		<cfquery name="DEL_salary_update3" datasource="#dsn#">
			DELETE FROM SALARY_UPDATE_POSITION_CATS WHERE UPDATE_ID = #attributes.UPDATE_ID#
		</cfquery>
		<cf_add_log  log_type="-1" action_id="#attributes.update_id# " action_name="T.Ücret Ayarı: #attributes.update_id#">
	</cftransaction>
</cflock>
</cfif>
<cfif isDefined("attributes.call_back") and attributes.call_back eq 1>
	<cfquery name="get_setup_salary" datasource="#dsn#">
		SELECT SALARY_CODE,SALARY_TYPE FROM SALARY_UPDATE WHERE UPDATE_ID = #attributes.UPDATE_ID#
	</cfquery>
	<cfquery name="add_salary_update" datasource="#dsn#">
		UPDATE
			SALARY_UPDATE
		SET
			VALID_EMP = NULL,
			VALID_DATE = NULL,
			VALID = NULL,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#'
		WHERE
			UPDATE_ID = #attributes.UPDATE_ID#
	</cfquery>
	<cfif GET_SETUP_SALARY.salary_type eq 0>
		<cfset tablo_ = "EMPLOYEES_SALARY_PLAN">
	<cfelse>
		<cfset tablo_ = "EMPLOYEES_SALARY">
	</cfif>
	<cfquery name="del_" datasource="#dsn#">
		DELETE FROM #tablo_# WHERE SALARY_CODE = '#get_setup_salary.SALARY_CODE#'
	</cfquery>
	<cf_add_log  log_type="-1" action_id="#attributes.UPDATE_ID# " action_name="T.Ücret Ayarı Geri Alındı: #attributes.UPDATE_ID#" period_id="#session.ep.period_id#">
</cfif>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.list_setup_salary</cfoutput>';
</script> 

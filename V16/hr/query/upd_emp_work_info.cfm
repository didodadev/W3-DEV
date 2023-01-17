<!--- pdks no kontrol --->
<cfif len(attributes.pdks_number)>
	<cfquery name="get_emp_pdks_number" datasource="#DSN#">
		SELECT
			EIO.PDKS_NUMBER,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
		FROM
			EMPLOYEES_IN_OUT EIO,
			EMPLOYEES E
		WHERE
			EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND
			EIO.PDKS_NUMBER = '#attributes.pdks_number#'
			AND EIO.EMPLOYEE_ID <> #attributes.EMPLOYEE_ID#
			AND E.EMPLOYEE_STATUS = 1
			AND EIO.FINISH_DATE IS NULL
	</cfquery>
	<cfif get_emp_pdks_number.recordcount>
		<script type="text/javascript">
			alert('<cfoutput>#get_emp_pdks_number.EMPLOYEE_NAME# #get_emp_pdks_number.EMPLOYEE_SURNAME# Adlı Çalışan Aynı PDKS Numarası İle Kayıtlı</cfoutput>! Lütfen Düzeltiniz!');
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<!--- pdks no kontrol --->

<cfquery name="upd_ssk" datasource="#dsn#">
	UPDATE
		EMPLOYEES_IN_OUT
	SET
		PDKS_NUMBER = '#attributes.pdks_number#',
		PDKS_TYPE_ID = <cfif len(attributes.pdks_type_id)>#attributes.pdks_type_id#<cfelse>NULL</cfif>,
		TRANSPORT_TYPE_ID = <cfif len(attributes.transport_type_id)>#attributes.transport_type_id#<cfelse>NULL</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.REMOTE_ADDR#',
		UPDATE_EMP = #session.ep.userid#
	WHERE
		IN_OUT_ID = #attributes.in_out_id#
</cfquery>
<cfinclude template="../ehesap/query/add_in_out_history.cfm">
<cfif isdefined("attributes.callAjaxBranch") and attributes.callAjaxBranch eq 1>
	<script>
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.list_salary&event=det&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#</cfoutput>','ajax_right');
	</script>
<cfelse>
	<cflocation url="#request.self#?fuseaction=hr.list_salary&event=det&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#" addtoken="No">
</cfif>

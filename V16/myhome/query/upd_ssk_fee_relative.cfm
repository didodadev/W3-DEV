<cfquery name="get_in_out" datasource="#DSN#">
	SELECT 
		START_DATE,
		BRANCH_ID
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		IN_OUT_ID = #attributes.in_out_id#
</cfquery>
<cfquery name="ADD_SSK_FEE" datasource="#DSN#">
	UPDATE
		EMPLOYEES_SSK_FEE_RELATIVE
	SET
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#,
		FEE_DATE = #attributes.DATE#,
		FEE_HOUR = #attributes.HOUR#,
		ILL_NAME = '#attributes.ill_name#',
		ILL_SURNAME = '#attributes.ill_surname#',
		<cfif isdefined("attributes.sex") and len(attributes.sex)>SEX = #attributes.sex#,<cfelse>SEX = 1,</cfif>
		ILL_RELATIVE = '#attributes.ill_relative#',
		BIRTH_DATE=#attributes.BIRTH_DATE#,
		BRANCH_ID = #get_in_out.BRANCH_ID#,
		BIRTH_PLACE = '#attributes.BIRTH_PLACE#',
		TC_IDENTY_NO = '#attributes.TC_IDENTY_NO#',
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_DATE = #NOW()#,
		IN_OUT_ID = #attributes.in_out_id#
	WHERE
		FEE_ID = #attributes.FEE_ID#
</cfquery>	
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

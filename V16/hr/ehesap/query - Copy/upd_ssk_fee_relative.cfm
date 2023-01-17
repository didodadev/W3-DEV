<cfquery name="get_in_out" datasource="#DSN#">
	SELECT 
		START_DATE,
		BRANCH_ID
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		IN_OUT_ID = #attributes.in_out_id#
</cfquery>
<cfif len(attributes.DATE)>
	<cf_date tarih="attributes.DATE">
</cfif>
<cfif len(attributes.BIRTH_DATE)>
	<cf_date tarih="attributes.BIRTH_DATE">
</cfif>
<cfquery name="ADD_SSK_FEE" datasource="#DSN#">
	UPDATE
		EMPLOYEES_SSK_FEE_RELATIVE
	SET
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#,
		FEE_DATE = #attributes.DATE#,
		FEE_HOUR = #attributes.HOUR#,
	<cfif isdefined("attributes.valid") and len(attributes.valid)>
		VALID = #attributes.valid#,
		VALID_EMP = #session.ep.userid#,
		VALID_DATE = #now()#,
	<cfelseif isdefined("ATTRIBUTES.VALIDATOR_POS_CODE") and len(ATTRIBUTES.VALIDATOR_POS_CODE)>
		VALIDATOR_POS_CODE = #ATTRIBUTES.VALIDATOR_POS_CODE#,
	</cfif>
		ILL_NAME = '#attributes.ill_name#',
		ILL_SURNAME = '#attributes.ill_surname#',
		ILL_RELATIVE = '#attributes.ill_relative#',
		ILL_SEX = #attributes.ill_sex#,
		BIRTH_DATE= #attributes.BIRTH_DATE#,
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
	window.location.href='<cfoutput>#request.self#?fuseaction=hr.list_visited_relative&event=upd&fee_id=#attributes.FEE_ID#</cfoutput>';
</script>

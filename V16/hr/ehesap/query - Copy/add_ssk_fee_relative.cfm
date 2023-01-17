<cfif len(attributes.DATE)>
	<cf_date tarih="attributes.DATE">
	<cf_date tarih="attributes.BIRTH_DATE">
</cfif>
<cfquery name="get_in_out" datasource="#DSN#">
	SELECT 
		START_DATE,
		BRANCH_ID
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		IN_OUT_ID = #attributes.in_out_id#
</cfquery>
<cfset CONTROL = date_add("D", -90, now())>

<cfquery name="ADD_SSK_FEE" datasource="#DSN#" result="max_id">
	INSERT INTO EMPLOYEES_SSK_FEE_RELATIVE
		(
		EMPLOYEE_ID,
		FEE_DATE,
		FEE_HOUR,
	<cfif isdefined("attributes.VALIDATOR_POS_CODE") and len(attributes.VALIDATOR_POS_CODE)>
		VALIDATOR_POS_CODE,
	<cfelse>
		VALID,
		VALID_EMP,
		VALID_DATE,
	</cfif>
		ILL_NAME,
		ILL_SURNAME,
		ILL_RELATIVE,
		ILL_SEX,
		BIRTH_DATE,
		BIRTH_PLACE,
		TC_IDENTY_NO,
		BRANCH_ID,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE,
		IN_OUT_ID
		)
	VALUES
		(
		#attributes.EMPLOYEE_ID#,
		#attributes.DATE#,
		#attributes.HOUR#,
	<cfif isdefined("attributes.VALIDATOR_POS_CODE") and len(attributes.VALIDATOR_POS_CODE)>
		#ATTRIBUTES.VALIDATOR_POS_CODE#,
	<cfelse>
		1,
		#session.ep.userid#,
		#now()#,
	</cfif>
		'#attributes.ill_name#',
		'#attributes.ill_surname#',
		'#attributes.ill_relative#',
		#attributes.ill_sex#,
		#attributes.BIRTH_DATE#,
		'#attributes.BIRTH_PLACE#',
		'#attributes.TC_IDENTY_NO#',
		#get_in_out.BRANCH_ID#,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#',
		#NOW()#,
		#attributes.in_out_id#
		)
</cfquery>	

<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=hr.list_visited_relative&event=upd&fee_id=#max_id.IDENTITYCOL#</cfoutput>';
</script>

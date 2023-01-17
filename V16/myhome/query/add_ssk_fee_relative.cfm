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

<cfset CONTROL = date_add("D", -30, now())>
<cfif (datediff("D",get_in_out.START_DATE,CONTROL) neq 0) and (datediff("M",get_in_out.START_DATE,CONTROL) neq 0) and (datediff("YYYY",get_in_out.START_DATE,CONTROL) NEQ 0)>
  <script type="text/javascript">
    alert("Çalışan Yakınına Vizite Verilebilmesi İçin 30 gün Sigorta Primi Ödenmiş Olması Gerekmektedir");
  </script>
</cfif>

<cfquery name="ADD_SSK_FEE" datasource="#DSN#">
	INSERT INTO 
		EMPLOYEES_SSK_FEE_RELATIVE
		(
		EMPLOYEE_ID,
		FEE_DATE,
		FEE_HOUR,
	<cfif isdefined("attributes.VALIDATOR_POS_CODE") and len(attributes.VALIDATOR_POS_CODE)>
		VALIDATOR_POS_CODE_1,
	<cfelse>
		VALID_1,
		VALID_EMP_1,
		VALID_DATE_1,
	</cfif>
	<cfif isdefined("attributes.VALIDATOR_POS_CODE2") and len(attributes.VALIDATOR_POS_CODE2)>
		VALIDATOR_POS_CODE_2,
	<cfelse>
		VALID_2,
		VALID_EMP_2,
		VALID_DATE_2,
	</cfif>
		ILL_NAME,
		ILL_SURNAME,
		<cfif isdefined("attributes.sex")>SEX,</cfif>
		ILL_RELATIVE,
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
	<cfif isdefined("attributes.VALIDATOR_POS_CODE2") and len(attributes.VALIDATOR_POS_CODE2)>
		#ATTRIBUTES.VALIDATOR_POS_CODE2#,
	<cfelse>
		1,
		#session.ep.userid#,
		#now()#,
	</cfif>
		'#attributes.ill_name#',
		'#attributes.ill_surname#',
	<cfif isDefined("attributes.sex")>
			#attributes.sex#,
	</cfif>
		'#attributes.ill_relative#',
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
	wrk_opener_reload();
	window.close();
</script>

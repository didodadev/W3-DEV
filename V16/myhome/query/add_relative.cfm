<cfif len(attributes.BIRTH_DATE)>
	<CF_DATE tarih="attributes.BIRTH_DATE">
</cfif>

<cfquery name="ADD_RELATIVE" datasource="#DSN#">
  INSERT INTO
 	EMPLOYEES_RELATIVES
	(
	EMPLOYEE_ID,
	NAME,
	SURNAME,
	RELATIVE_LEVEL,
	BIRTH_DATE,
	BIRTH_PLACE,
	TC_IDENTY_NO,
	EDUCATION,
	EDUCATION_STATUS,
	JOB,
	COMPANY,
	JOB_POSITION,
	RECORD_EMP,
	RECORD_IP,
	RECORD_DATE
	)
  VALUES
    (
	#attributes.EMPLOYEE_ID#,
	'#attributes.NAME#',
	'#attributes.SURNAME#',
	'#attributes.RELATIVE_LEVEL#',
	#attributes.BIRTH_DATE#,
	'#attributes.BIRTH_PLACE#',
	'#attributes.TC_IDENTY_NO#',
	<cfif LEN(attributes.EDUCATION)>#attributes.EDUCATION#,<cfelse>NULL,</cfif>
	<cfif isdefined("attributes.education_status")>1,<cfelse>0,</cfif>	
	'#attributes.JOB#',
	'#attributes.COMPANY#',
	'#attributes.JOB_POSITION#',
	#SESSION.EP.USERID#,
	'#CGI.REMOTE_ADDR#',
	#NOW()#
	)
</cfquery>	
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>


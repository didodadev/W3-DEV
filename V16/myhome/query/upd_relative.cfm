<cfif len(attributes.BIRTH_DATE)>
	<CF_DATE tarih="attributes.BIRTH_DATE">
</cfif>

<cfquery name="UPD_RELATIVE" datasource="#DSN#">
  UPDATE
 	EMPLOYEES_RELATIVES
  SET
	EMPLOYEE_ID=#attributes.EMPLOYEE_ID#,
	NAME='#attributes.NAME#',
	SURNAME='#attributes.SURNAME#',
	RELATIVE_LEVEL='#attributes.RELATIVE_LEVEL#',
	BIRTH_DATE=#attributes.BIRTH_DATE#,
	BIRTH_PLACE='#attributes.BIRTH_PLACE#',
	TC_IDENTY_NO='#attributes.TC_IDENTY_NO#',
	EDUCATION=<cfif LEN(attributes.EDUCATION)>#attributes.EDUCATION#,<cfelse>NULL,</cfif>
	EDUCATION_STATUS=<cfif isdefined("attributes.education_status")>1,<cfelse>0,</cfif>	
	JOB='#attributes.JOB#',
	COMPANY='#attributes.COMPANY#',
	JOB_POSITION='#attributes.JOB_POSITION#',
	UPDATE_EMP=#SESSION.EP.USERID#,
	UPDATE_IP='#CGI.REMOTE_ADDR#',
	UPDATE_DATE=#NOW()#

  WHERE
	RELATIVE_ID=#attributes.RELATIVE_ID#  	
</cfquery>	

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

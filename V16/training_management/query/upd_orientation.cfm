<cfif LEN(START_DATE)>
  <CF_DATE tarih="START_DATE">
</cfif>

<cfif LEN(FINISH_DATE)>
  <CF_DATE tarih="FINISH_DATE">
</cfif>

<cfquery name="upd_orientation" datasource="#dsn#">
  UPDATE 
    TRAINING_ORIENTATION
  SET
    ORIENTATION_HEAD = '#ORIENTATION_HEAD#',
	IS_ABSENT = <cfif IsDefined("attributes.IS_ABSENT")>1<cfelse>0</cfif>,
    DETAIL = '#DETAIL#',
    ATTENDER_EMP = <cfif LEN(emp_id)>#emp_id#,<cfelse>NULL, </cfif>
    TRAINER_EMP = <cfif len(trainer_emp_id)>#trainer_emp_id#,<cfelse>NULL,</cfif> 
	START_DATE = <cfif LEN(START_DATE)>#START_DATE#,<cfelse>NULL,</cfif>
	FINISH_DATE = <cfif LEN(FINISH_DATE)>#FINISH_DATE#<cfelse>NULL</cfif>
 WHERE
    ORIENTATION_ID = #attributes.ORIENTATION_ID#  
</cfquery>

<script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script>


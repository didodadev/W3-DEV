<!---
<cfquery name="GET_INTVIEW_ID" datasource="#DSN#">
 SELECT INTERVIEW_ID FROM EMPLOYEES_INTERVIEW WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>
  
<cfif GET_INTVIEW_ID.recordcount>
    <cfquery name="DEL_INTERVIEW" datasource="#DSN#">
	  DELETE FROM EMPLOYEES_INTERVIEW WHERE INTERVIEW_ID = #GET_INTVIEW_ID.INTERVIEW_ID#
	</cfquery>
	<cfquery name="DEL_DETAIL" datasource="#DSN#">
	  DELETE FROM EMPLOYEES_INTERVIEW_DETAIL WHERE INTERVIEW_ID = #GET_INTVIEW_ID.INTERVIEW_ID#
	</cfquery>
</cfif>
--->

<cfquery name="ADD_INTERVIEW" datasource="#DSN#">
  INSERT INTO 
    EMPLOYEES_INTERVIEW
  (
   EMPLOYEE_ID,
   QUIZ_ID
  )
  VALUES
  (
   <cfif len(attributes.EMPLOYEE_ID)>#attributes.EMPLOYEE_ID#<cfelse>NULL</cfif>,
   #attributes.QUIZ_ID#
  )
</cfquery>

<script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script>

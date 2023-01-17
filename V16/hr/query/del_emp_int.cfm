<cfquery name="GET_INTVIEW_ID" datasource="#DSN#">
    SELECT INTERVIEW_ID FROM EMPLOYEES_INTERVIEW WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND QUIZ_ID = #ATTRIBUTES.QUIZ_ID#
</cfquery>
<cfif GET_INTVIEW_ID.recordcount>
	<cfquery name="DEL_INTERVIEW" datasource="#DSN#">
	  DELETE FROM EMPLOYEES_INTERVIEW WHERE INTERVIEW_ID = #GET_INTVIEW_ID.INTERVIEW_ID#
	</cfquery>
	<cfquery name="DEL_DETAIL" datasource="#DSN#">
	  DELETE FROM EMPLOYEES_INTERVIEW_DETAIL WHERE INTERVIEW_ID = #GET_INTVIEW_ID.INTERVIEW_ID#
	</cfquery>
</cfif>
<cfquery name="GET_INTVIEW_COUNT" datasource="#DSN#">
	SELECT 
    	EI.INTERVIEW_ID, 
        EI.QUIZ_ID, 
        EI.EMPLOYEE_ID, 
        EI.INTERVIEW_EMP_ID, 
        EI.INTERVIEW_DATE, 
        EI.NOTES,
        EQ.QUIZ_ID, 
        EQ.QUIZ_HEAD, 
        EQ.STAGE_ID, 
        EQ.START_DATE, 
        EQ.FINISH_DATE
    FROM 
    	EMPLOYEES_INTERVIEW EI,
	    EMPLOYEE_QUIZ EQ 
    WHERE 
    	EI.EMPLOYEE_ID =  #attributes.EMPLOYEE_ID# 
    AND 
    	EI.QUIZ_ID = EQ.QUIZ_ID
</cfquery>
<cfif GET_INTVIEW_COUNT.RECORDCOUNT>
	<cflocation url="#request.self#?fuseaction=hr.popup_upd_emp_interview&employee_id=#attributes.EMPLOYEE_ID#&quiz_id=#GET_INTVIEW_COUNT.quiz_id#" addtoken="yes">
<cfelse>
	<script type="text/javascript">
        wrk_opener_reload();
        window.close();
    </script>
</cfif>

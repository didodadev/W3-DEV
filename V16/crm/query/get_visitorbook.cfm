<cfquery name="GET_VISITORBOOK" datasource="#DSN#">
      SELECT EMPLOYEES.*,VISITOR_BOOK.*
      FROM VISITOR_BOOK LEFT JOIN EMPLOYEES
      ON  EMPLOYEES.EMPLOYEE_ID=VISITOR_BOOK.EMP_ID
      WHERE VISITOR_BOOK.VISIT_ID=#attributes.visit_id#
</cfquery>
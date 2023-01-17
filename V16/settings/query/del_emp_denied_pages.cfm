
 <!---
 <cfquery name="del_user_denied_emp" datasource="#dsn#">
  DELETE FROM 
   EMPLOYEE_POSITIONS_DENIED_PAGE
  WHERE
  POSITION_CODE = #attributes.pos_code#
 </cfquery>
 --->
 <cfquery name="del_user_denied_emp" datasource="#dsn#">
  DELETE FROM 
   EMPLOYEE_POSITIONS_DENIED
  WHERE
  POSITION_CODE = #attributes.pos_code#
    AND 
  DENIED_PAGE_ID IS NULL
 </cfquery>
 
 <script type="text/javascript">
/*    wrk_opener_reload();
   window.close(); */
   window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=settings.emp_denied_pages';
 </script>

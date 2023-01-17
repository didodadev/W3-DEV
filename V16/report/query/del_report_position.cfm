
<cfquery name="del_report_position" datasource="#dsn#">
  DELETE FROM 
    REPORT_ACCESS_RIGHTS 
  WHERE 
    REPORT_ID = #attributes.REPORT_ID#
	  AND
	POS_CODE = #attributes.pos_code#
</cfquery>

 <script type="text/javascript">
   wrk_opener_reload();
   window.close();
 </script>

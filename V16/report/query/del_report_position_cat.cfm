
<cfquery name="del_report_position" datasource="#dsn#">
  DELETE FROM 
    REPORT_ACCESS_RIGHTS 
  WHERE 
    REPORT_ID = #attributes.REPORT_ID#
	  AND
	POS_CAT_ID = #attributes.pos_cat_id#
</cfquery>

 <script type="text/javascript">
   wrk_opener_reload();
   window.close();
 </script>

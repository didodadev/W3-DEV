<cfquery name="del_my_report" datasource="#dsn#">
	  DELETE 
	  FROM 
		  REPORT_VIEW 
	  WHERE 
		  REPORT_ID= #URL.REPORT_ID# 
	  AND 
	  	  POSITION_CODE = #SESSION.EP.POSITION_CODE#
</cfquery>
<script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script>

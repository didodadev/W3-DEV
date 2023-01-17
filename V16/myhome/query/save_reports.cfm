<cfquery datasource="#DSN#" name="get_my_reports">
	SELECT
		*
	FROM
		REPORT_VIEW
	WHERE
		POSITION_CODE = #SESSION.EP.POSITION_CODE#
</cfquery>
<cfif get_my_reports.RECORDCOUNT>
    <cfquery name="delete_reports" datasource="#DSN#">
	DELETE FROM 
		REPORT_VIEW	
	WHERE 
		POSITION_CODE = #SESSION.EP.POSITION_CODE#	
	</cfquery>   
  <cfloop list="#attributes.REPORT_ID#" index="add_report">
   <cfquery name="ADD_REPORT_VIEW" datasource="#DSN#"> 
       INSERT INTO REPORT_VIEW
	      (
		  POSITION_CODE,
		  REPORT_ID
		  )
	   VALUES
	      (
		  #SESSION.EP.POSITION_CODE#,
		  #add_report#
		  )	   	    
  </cfquery> 
  </cfloop>   
<cfelse>
  <cfloop list="#attributes.REPORT_ID#" index="add_report">
   <cfquery name="ADD_REPORT_VIEW" datasource="#DSN#"> 
       INSERT INTO REPORT_VIEW
	      (
		  POSITION_CODE,
		  REPORT_ID
		  )
	   VALUES
	      (
		  #SESSION.EP.POSITION_CODE#,
		  #add_report#
		  )	   	    
  </cfquery> 
  </cfloop>
</cfif>
<script type="text/javascript">
window.close();
</script>

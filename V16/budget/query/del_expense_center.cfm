<cfinclude template="../query/get_expense_detail.cfm">
<cfset attributes.EXPENSE_CODE = EXPENSE.EXPENSE_CODE>
<cfquery name="DEL_EXPENSE" datasource="#iif(fusebox.use_period,'dsn2','dsn')#">
	DELETE 
	FROM
		EXPENSE_CENTER 
	WHERE	
		EXPENSE_ID = #attributes.EXPENSE_ID#
</cfquery>
<cfif listlen(attributes.EXPENSE_CODE,".") gt 1>
  <cfset upper_code = listdeleteat(attributes.EXPENSE_CODE,listlen(attributes.EXPENSE_CODE,"."),".")>
  <cfquery name="GET_SUBS" datasource="#iif(fusebox.use_period,'dsn2','dsn')#">
	  SELECT 
		  EXPENSE_ID 
	  FROM 
		  EXPENSE_CENTER 
	  WHERE 
		  EXPENSE_CODE LIKE '#UPPER_CODE#.%'
  </cfquery>
  <cfif get_subs.recordcount eq 0>
    <cfquery name="UPD_UPPER" datasource="#iif(fusebox.use_period,'dsn2','dsn')#">
		UPDATE 
			EXPENSE_CENTER 
		SET 
			HIERARCHY = 0 
		WHERE 
			EXPENSE_CODE = '#UPPER_CODE#'
    </cfquery>
  </cfif>
</cfif>
<script type="text/javascript">
	location.reload();
	wrk_opener_reload();
	window.close();
</script>


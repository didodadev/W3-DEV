<cfquery name="control" datasource="#dsn#">
  SELECT 
    *
  FROM
    ORGANIZATION_RESULT_REPORT 
  WHERE
    ORGANIZATION_ID = #URL.ORGANIZATION_ID# 
</cfquery>


<cfif control.RECORDCOUNT>
  <cfquery name="UPD_RESULT" datasource="#DSN#">
    UPDATE ORGANIZATION_RESULT_REPORT
	SET
		RESULT_HEAD = '#result_head#',
		RESULT_DETAIL = '#RESULT#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #SESSION.EP.USERID#, 
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
	  ORGANIZATION_ID = #attributes.ORGANIZATION_ID#
  </cfquery>

<cfelse>

   <cfquery name="ADD_RESULT" datasource="#DSN#">
     INSERT
	  INTO  ORGANIZATION_RESULT_REPORT
	  (
	   ORGANIZATION_ID,
	   RESULT_HEAD,
	   RECORD_DATE,
	   RECORD_EMP,
	   RECORD_IP	   
	  <cfif LEN(RESULT)>
	   ,RESULT_DETAIL
	  </cfif>
	  )
	  VALUES
	  (
	   #attributes.ORGANIZATION_ID#,
	   '#result_head#',
	   #NOW()#,
	   #SESSION.EP.USERID#,
	   '#CGI.REMOTE_ADDR#'
	 <cfif LEN(RESULT)>
	   ,'#RESULT#'
	 </cfif>
	  )
   </cfquery>
</cfif>

<script type="text/javascript">
<cfif isDefined('attributes.draggable') and attributes.draggable eq 1>
	location.href = document.referrer;
<cfelse>
	wrk_opener_reload();
  	window.close();
</cfif>
</script>

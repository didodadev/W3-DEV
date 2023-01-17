<cfquery name="control" datasource="#dsn#">
  SELECT 
    *
  FROM
    TRAINING_CLASS_RESULT_REPORT 
  WHERE
    CLASS_ID = #URL.CLASS_ID# 
</cfquery>


<cfif control.RECORDCOUNT>
  <cfquery name="UPD_RESULT" datasource="#DSN#">
    UPDATE TRAINING_CLASS_RESULT_REPORT
	SET
		RESULT_HEAD = '#class_head#',
		RESULT_DETAIL = '#RESULT#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #SESSION.EP.USERID#, 
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
	  CLASS_ID = #attributes.CLASS_ID#
  </cfquery>

<cfelse>

   <cfquery name="ADD_RESULT" datasource="#DSN#">
     INSERT
	  INTO  TRAINING_CLASS_RESULT_REPORT
	  (
	   CLASS_ID,
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
	   #attributes.CLASS_ID#,
	   '#class_head#',
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
  wrk_opener_reload();
  window.close();
</script>

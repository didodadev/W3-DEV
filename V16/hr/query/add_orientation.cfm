
<cfif LEN(START_DATE)>
  <CF_DATE tarih="START_DATE">
</cfif>

<cfif LEN(FINISH_DATE)>
  <CF_DATE tarih="FINISH_DATE">
</cfif>

<cfquery name="add_orientation" datasource="#dsn#">
  INSERT INTO
    TRAINING_ORIENTATION
   (
    ORIENTATION_HEAD,
   <cfif LEN(DETAIL)>
    DETAIL,
   </cfif>
   <cfif len(START_DATE)>
	START_DATE,
   </cfif>	
   <cfif LEN(FINISH_DATE)>
	FINISH_DATE,
   </cfif>
  <cfif LEN(emp_id)>
    ATTENDER_EMP,
  </cfif>
  <cfif len(trainer_emp_id)>
    TRAINER_EMP,
  </cfif>
    RECORD_DATE,
	RECORD_IP,
	RECORD_EMP
	)
  VALUES
  (
    '#ORIENTATION_HEAD#',
   <cfif LEN(DETAIL)>
    '#DETAIL#',
   </cfif>
  <cfif LEN(START_DATE)>
   #START_DATE#,
  </cfif> 
  <cfif LEN(FINISH_DATE)>
   #FINISH_DATE#,
  </cfif>
  <cfif LEN(emp_id)>
   #emp_id#,
  </cfif> 
  <cfif len(trainer_emp_id)>
    #trainer_emp_id#,
  </cfif>
   #NOW()#,
   '#CGI.REMOTE_ADDR#',
   #SESSION.EP.USERID#
  )
   
</cfquery>

<script type="text/javascript">
location.href = document.referrer;
</script>

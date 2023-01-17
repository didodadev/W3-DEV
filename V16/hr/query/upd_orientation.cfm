<cfif LEN(START_DATE)>
  <CF_DATE tarih="START_DATE">
</cfif>
<cfif LEN(FINISH_DATE)>
  <CF_DATE tarih="FINISH_DATE">
</cfif>
<cfquery name="upd_orientation" datasource="#dsn#">
  UPDATE 
    TRAINING_ORIENTATION
  SET
    ORIENTATION_HEAD = '#ORIENTATION_HEAD#',
    DETAIL = '#DETAIL#',
   <cfif LEN(emp_id)>
    ATTENDER_EMP = #emp_id#,
  </cfif>
  <cfif len(trainer_emp_id)>
    TRAINER_EMP = #trainer_emp_id#,
  </cfif>
	START_DATE = #START_DATE#,
	FINISH_DATE = #FINISH_DATE#,
  UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,    
  UPDATE_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">

 WHERE
    ORIENTATION_ID =#attributes.ORIENTATION_ID#  
  
</cfquery>
<script type="text/javascript">
 window.location.href = "<cfoutput>#request.self#?fuseaction=hr.list_orientation&event=upd&orientation_id=#attributes.orientation_id#</cfoutput>";
</script>


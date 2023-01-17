<cfquery name="UPD_CAUTION_TYPE" datasource="#DSN#">
  UPDATE 
  	SETUP_CAUTION_TYPE
  SET
    CAUTION_TYPE = '#caution_type#',
    DETAIL = '#detail#',
	IS_ACTIVE = <cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>,
    UPDATE_EMP = #SESSION.EP.USERID#,
    UPDATE_IP = '#CGI.REMOTE_ADDR#',
    UPDATE_DATE = #NOW()#
 WHERE
   CAUTION_TYPE_ID = #attributes.caution_type_id#
</cfquery>

<script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script>

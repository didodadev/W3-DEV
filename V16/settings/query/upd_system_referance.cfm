<cfquery name="upd_referance_status" datasource="#dsn3#">
	UPDATE 
    	SETUP_REFERANCE_STATUS
    SET
    	REFERANCE_STATUS = '#attributes.REFERANCE_STATUS#',
        IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
        UPDATE_DATE = #NOW()#,
        UPDATE_EMP = #session.ep.userid#,
        UPDATE_IP = '#cgi.REMOTE_ADDR#'
    WHERE
    	REFERANCE_STATUS_ID = #attributes.id#
</cfquery>
<script>
    location.href = document.referrer;
</script>

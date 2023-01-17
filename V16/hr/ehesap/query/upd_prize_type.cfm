<cfquery name="UPD_CAUTION_TYPE" datasource="#DSN#">
	UPDATE 
		SETUP_PRIZE_TYPE
	SET
		PRIZE_TYPE = '#price_type#',
		DETAIL = '#detail#',
		IS_ACTIVE = <cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>,
        UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.REMOTE_ADDR#'
	WHERE
		PRIZE_TYPE_ID = #attributes.prize_type_id#
</cfquery>
<cfset attributes.actionId = attributes.prize_type_id>
<script type="text/javascript">
  location.href= document.referrer;
</script>

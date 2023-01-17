<cfquery name="GET_TARGET" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		OUR_COMPANY_TARGET 
	WHERE 
		COMPANY_ID = #attributes.company_id# AND 
		PERIOD = #attributes.period# AND 
		OUR_COMPANY_TARGET_ID <> #attributes.target_id#
</cfquery>
<cfif get_target.recordcount>
	<script language="javascript">
		alert("Bu Döneme Ait Hedef Bulunmakta ! ");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfquery name="ADD_TARGET" datasource="#dsn#">
	UPDATE
		OUR_COMPANY_TARGET 
	SET
		COMPANY_ID = #attributes.company_id#,
		PERIOD = #attributes.period#,
		VIZYON = '#attributes.vizyon#',
		DETAIL = '#attributes.detail#',
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.REMOTE_ADDR#',
		UPDATE_DATE	= #now()#,
		TARGET_SIZE = #attributes.target_size#
	WHERE
		OUR_COMPANY_TARGET_ID = #attributes.target_id#
</cfquery>
<script language="javascript">
	window.opener.location.reload();
	window.close();
</script>


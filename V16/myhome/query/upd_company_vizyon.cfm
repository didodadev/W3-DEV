<cfquery name="upd_comp_viz" datasource="#dsn#">
	UPDATE
		OUR_COMPANY_INFO
	SET
		COMP_VIZYON='#attributes.comp_vizyon#',
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE 
		COMP_ID = #attributes.company_id#
</cfquery>
<script type="text/javascript">
	window.close();
</script>

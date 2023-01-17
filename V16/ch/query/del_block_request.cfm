<cfquery name="del_request" datasource="#dsn#">
	DELETE FROM COMPANY_BLOCK_REQUEST WHERE COMPANY_BLOCK_ID = #attributes.block_id#
</cfquery>
<script type="text/javascript">
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.list_block_request';	
</script>
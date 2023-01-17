<cfsetting showdebugoutput="no">
<cfquery name="DEL_CONTENT_RELATION" datasource="#DSN#">
	DELETE FROM		
		CONTENT_RELATION		
	WHERE
		ACTION_TYPE = '#attributes.action_type#' AND
		ACTION_TYPE_ID = #attributes.action_type_id# AND
		CONTENT_ID = #attributes.content_id#
</cfquery>
<script type="text/javascript">
	try
	{
		list_content_id_yukle();
	}
	catch(e)
	{
		window.opener.location.reload();
		window.close();
	}
</script>


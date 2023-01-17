<cfquery name="get_image" datasource="#DSN#">
	SELECT 
		VISUAL_NOTICE,
		SERVER_VISUAL_NOTICE_ID
	FROM 
		NOTICES
	WHERE
		NOTICE_ID = #attributes.notice_id#
</cfquery>
<cfif len(get_image.visual_notice)>
	<cf_del_server_file output_file="hr/#get_image.visual_notice#" output_server="#get_image.server_visual_notice_id#">
</cfif>

<cfquery name="upd_notice" datasource="#dsn#">
	DELETE FROM NOTICES WHERE NOTICE_ID = #ATTRIBUTES.NOTICE_ID#
</cfquery>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_notice';
</script>

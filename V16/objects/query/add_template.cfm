<cfset cont = ReplaceList(attributes.content,chr(13),'')>
<cfset cont = ReplaceList(cont,chr(10),'')>
<cfset cont = ReplaceList(cont,"'","""")>

<cfquery name="UPDTEMPLATE" datasource="#dsn#">
	UPDATE 
		TEMPLATE_FORMS
	SET 
		TEMPLATE_HEAD = '#attributes.template_head#',
		TEMPLATE_MODULE = #attributes.module#,
		TEMPLATE_CONTENT = '#cont#'
	WHERE 
		TEMPLATE_ID = #attributes.template_id#	
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

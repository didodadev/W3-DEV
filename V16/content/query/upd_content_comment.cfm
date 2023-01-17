<!--- bu sayfada unicodelar icin sql_unicode fonksiyonu kullanildi --->
<cfquery name="ADD_COMMENT" datasource="#DSN#">
	UPDATE 
		CONTENT_COMMENT 
	SET
		CONTENT_COMMENT = #sql_unicode()#'#attributes.content_comment#',
		CONTENT_COMMENT_POINT = #attributes.content_comment_point#,
		NAME = #sql_unicode()#'#attributes.name#',
		SURNAME = #sql_unicode()#'#attributes.surname#',
		STAGE_ID = #attributes.stage_id#,	
		MAIL_ADDRESS = '#attributes.mail_address#'
	WHERE
		CONTENT_COMMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.content_comment_id#">
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

<!--- bu sayfada unicodelar icin sql_unicode fonksiyonu kullanildi --->
<cfquery name="ADD_CONTENT" datasource="#DSN#">
	UPDATE 
		CONTENT
	SET
		CONT_HEAD = #sql_unicode()#'#attributes.CONT_HEAD#',
		CONT_BODY = #sql_unicode()#'#attributes.CONTENT_TOPIC#',
		CHAPTER_ID=#attributes.chapter#,
		CONTENT_PROPERTY_ID=#attributes.content_property_id#,
		STAGE_ID=#attributes.STAGE_ID#,
		WRITE_VERSION='#attributes.write_version#',
		VERSION_DATE=<cfif len(attributes.version_date)>#attributes.version_date#,<cfelse>Null,</cfif>
		CONT_SUMMARY='#attributes.cont_summary#',
		<!--- CONT_HEAD='#attributes.cont_head#'--->
		
		UPDATE_MEMBER = <cfif isdefined("SESSION.EP.USERID")>#SESSION.EP.USERID#<cfelse>#SESSION.PP.USERID#</cfif>,
		UPDATE_DATE = #NOW()#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		CONTENT_ID = #attributes.ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

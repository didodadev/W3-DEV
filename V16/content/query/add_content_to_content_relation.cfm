<!--- add_content_to_content_relation.cfm --->
<cfquery name="CHECK_RELATED_CONT" datasource="#dsn#">
	SELECT
		CONTENT_ID
	FROM
		RELATED_CONTENT
	WHERE
		CONTENT_ID = #attributes.content_id# AND 
		RELATED_CONTENT_ID = #attributes.related_id#
</cfquery>
<cfif not check_related_cont.recordcount>
	<cfquery name="ADD_RELATED_CONTENT" datasource="#dsn#">
	INSERT INTO RELATED_CONTENT
		(
			CONTENT_ID,
			RELATED_CONTENT_ID
		)
		VALUES
		(
			#attributes.content_id#,
			#attributes.related_id#
		)
	</cfquery>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no='45.Bu içerik Zaten İlişkili'>!");
		window.history.go(-1);
	</script>
	<cfabort>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
<cfabort>

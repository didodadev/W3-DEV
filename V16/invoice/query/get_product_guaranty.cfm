<cfquery name="GET_QUA" datasource="#DSN2#">
	SELECT
		GUARANTY_CAT_ID
	FROM
		#dsn3_alias#.PRODUCT_GUARANTY
	WHERE
		PRODUCT_ID=#attributes.PRODUCT_ID#
</cfquery>
<cfif GET_QUA.RECORDCOUNT >
	<cfset GUARANTYCAT_ID=GET_QUA.GUARANTY_CAT_ID>
<cfelse>
	<cfset GUARANTYCAT_ID="">
</cfif>

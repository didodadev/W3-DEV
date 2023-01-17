<cfquery name="del_test" datasource="#dsn#">
	DELETE FROM TEST_CAT WHERE ID=#attributes.id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.list_test_category" addtoken="no">

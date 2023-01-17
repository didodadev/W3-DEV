<cfoutput>
<cfquery name="DEL_LIB_CAT" datasource="#DSN#">
		DELETE
			FROM
		LIBRARY_CAT
			WHERE LIBRARY_CAT_ID = #URL.ID#
	</cfquery>
	</cfoutput>
<cflocation url="#request.self#?fuseaction=settings.form_add_library_set" addtoken="no">

<cfquery name="DEL_VOCATION_TYPE" datasource="#DSN#">
	DELETE FROM
		SETUP_VOCATION_TYPE
	WHERE
		VOCATION_TYPE_ID = #TYPE_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_vocation_type" addtoken="no">﻿

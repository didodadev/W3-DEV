<cfquery name="DEL_INCOME_LEVEL" datasource="#DSN#">
	DELETE FROM
		SETUP_INCOME_LEVEL
	WHERE
		INCOME_LEVEL_ID = #LEVEL_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_income_level" addtoken="no">﻿

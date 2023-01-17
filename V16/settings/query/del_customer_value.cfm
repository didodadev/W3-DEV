<cfquery name="DEL_CUSTOMER_VALUE" datasource="#DSN#">
	DELETE FROM
		SETUP_CUSTOMER_VALUE
	WHERE
		CUSTOMER_VALUE_ID = #TYPE_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_customer_value" addtoken="no">﻿

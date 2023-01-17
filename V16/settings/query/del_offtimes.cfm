<cfquery name="DEL_OFFTIMES" datasource="#dsn#">
	DELETE
		FROM 
			<cfif fusebox.circuit eq 'settings'>SETUP_GENERAL_OFFTIMES<cfelse>SETUP_GENERAL_OFFTIMES_SATURDAY</cfif>
	WHERE
		OFFTIME_ID   = #attributes.offtime_id#
</cfquery>

<cflocation url="#request.self#?fuseaction=#fusebox.circuit#.form_add_offtimes" addtoken="no">

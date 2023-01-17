<cfquery name="del" datasource="#dsn#">
	DELETE FROM SETUP_STOP_LOGINS WHERE TYPE = #attributes.type#
</cfquery>

<cfif isdefined("attributes.type_id") and listlen(attributes.type_id)>
	<cfloop list="#attributes.type_id#" index="ccc">
		<cfquery name="add_" datasource="#dsn#">
			INSERT INTO
				SETUP_STOP_LOGINS
				(
					TYPE,
					TYPE_ID,
					MESSAGE			
				)
				VALUES
				(
					#attributes.type#,
					#ccc#,
					<cfif len(attributes.message)>'#attributes.message#'<cfelse>NULL</cfif>
				)
		</cfquery>
	</cfloop>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.form_stop_logins&type=#attributes.type#" addtoken="no">

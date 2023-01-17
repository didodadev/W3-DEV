<!--- <cfdump var="#session#"> --->
<cfloop collection=#session# item="key_field">
	<cfscript>
	if ((key_field neq 'error_text') and (key_field neq 'ep') and (key_field neq 'urltoken'))
		StructDelete(session, key_field); 
	</cfscript>
</cfloop>

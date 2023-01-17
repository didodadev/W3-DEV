<cfif IsDefined ("url.id")>
	<cf_addressbook
		design		= "4"
		id			= "#attributes.id#">
</cfif>
<cflocation url="#request.self#?fuseaction=correspondence.addressbook" addtoken="No">


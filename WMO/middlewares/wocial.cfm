<cfif not isDefined("url.fuseaction") and ((isDefined("url.code") and isDefined("url.state")) or (isDefined("url.error_code") and len(url.error_code)))>
    <cflocation url="#fusebox.server_machine_list#/#request.self#?fuseaction=wocial.popup_auth_control&#cgi.QUERY_STRING#" addtoken="no">
</cfif>
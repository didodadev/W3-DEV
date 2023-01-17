<cfif isDefined("url.fuseaction") and len(url.fuseaction) and reFindNoCase("^[\w-]+\.[\w-]+$", url.fuseaction) eq 0>
    <script>document.location.href = "/index.cfm?fuseaction=plevne.dashboard&event=error&msg=fuseactionshield";</script>
</cfif>

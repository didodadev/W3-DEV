<cfif isDefined("attributes.event") and attributes.event eq "init">
    <cfobject name="jedipackage" type="component" component="addons.jedi.models.jedipackage">
    <cfset qpackage = jedipackage.getpackage(attributes.id)>
    <cfif qpackage.recordcount>
        <cfset session.ep.jedipath = qpackage.path>
        <script>document.location.href='/index.cfm?fuseaction=jedi.playground';</script>
    <cfelse>
    <script>alert('Paket bulunamadı. Aktif olduğundan veya size ait olduğundan emin olun.');</script>
    </cfif>
    <cfabort>
</cfif>
<cfset jedipath = "/documents/jedi/#session.ep.userid#/#session.ep.jedipath#">
<cfinclude template="/documents/jedi/#session.ep.userid#/#session.ep.jedipath#/controllers/mastercontroller.cfm">
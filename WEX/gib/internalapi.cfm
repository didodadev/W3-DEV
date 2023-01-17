
<cffunction name="is_gib_activate">
    <cfobject name="gibdata" type="component" component="WEX.gib.components.gibdata">
    <cfset gibstatus = gibdata.parameters()>
    <cfreturn gibstatus.status>
</cffunction>
<cfcomponent>
    <cffunction name="mukellefsorgulama" access="public">
        <cfargument name="data">

        <cfobject name="gibservis" type="component" component="WEX.gib.components.gibservis">
        <cfobject name="gibdata" type="component" component="WEX.gib.components.gibdata">

        <cfset gibparams = gibdata.parameters()>
        <cfif gibparams.status eq 0>
            <cfreturn '{ "status": 0, "message": "Mükellef servisi aktif değil." }'>
        </cfif>

        <cfif arguments.data.mukkelleftip eq "sahis">
            <cfset mukellefresult = gibservis.GercekSahisMukellefMerkezBilgiSorgu(gibparams.username, gibparams.password, data.tckn)>
            <cfif not isStruct( mukellefresult )>
                <cfreturn '{ "status": 0, "message": "#mukellefresult#" }'>
            <cfelse>
                <cfreturn '{ "status": 1, "result": #replace( serializeJSON(mukellefresult), "//", "" )# }'>
            </cfif>
        <cfelseif arguments.data.mukkelleftip eq "tuzel">
            <cfset mukellefresult = gibservis.TuzelSahisMukellefMerkezBilgiSorgu(gibparams.username, gibparams.password, data.vkn)>
            <cfif not isStruct( mukellefresult )>
                <cfreturn '{ "status": 0, "message": "#mukellefresult#" }'>
            <cfelse>
                <cfreturn '{ "status": 1, "result": #replace( serializeJSON(mukellefresult), "//", "" )# }'>
            </cfif>
        </cfif>
    </cffunction>
</cfcomponent>
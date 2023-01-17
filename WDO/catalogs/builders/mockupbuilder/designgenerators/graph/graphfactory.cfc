<cfcomponent>

    <cffunction name="create" access="public" returntype="any">
        <cfargument name="type" type="string">
        <cfargument name="data" type="any">
        <cfargument name="domain" type="any">
        <cfargument name="ident" type="numeric" default="1">
        
        <cfswitch expression="#arguments.type#">
            <cfcase value="pie">
                <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.graph.pie").init( data:arguments.data, domain:arguments.domain, eventtype:'dashboard', identcount:arguments.ident )>
            </cfcase>
            <cfcase value="bar">
                <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.graph.bar").init( data:arguments.data, domain:arguments.domain, eventtype:'dashboard', identcount: arguments.ident )>
            </cfcase>
            <cfcase value="line">
                <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.graph.line").init( data:arguments.data, domain:arguments.domain, eventtype:'dashboard', identcount: arguments.ident )>
            </cfcase>
        </cfswitch>

    </cffunction>

</cfcomponent>
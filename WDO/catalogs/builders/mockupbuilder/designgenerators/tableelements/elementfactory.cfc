<cfcomponent>

    <cffunction name="create" access="public" returntype="any">
        <cfargument name="data" type="any">
        <cfargument name="domain" type="any">
        <cfscript>
            elementCode = "";
            if (arguments.data.devLink.value neq "")
            {
                linkwidget = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.tableelements.link").init(arguments.data, arguments.domain, 'list');
                elementCode = linkwidget.generate();
            }
            else
            {
                spanwidget = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.tableelements.span").init(arguments.data, arguments.domain, 'list');
                elementCode = spanwidget.generate();
            }
        </cfscript>
        <cfreturn elementCode>
    </cffunction>

</cfcomponent>
<cfcomponent>

    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="element" type="any">
        <cfargument name="precodeCallback" type="any">
        <cfscript>
            if (arguments.element.devIFMethod.value neq "")
            {
                generator = createObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator").createGenerator(arguments.element.devIFMethod.type);
                code = generator.generate(arguments.element.devIFMethod, arguments.element.label & "_ifmethod_");
                arguments.precodeCallback(code);
                arguments.precodeCallback('<script type="text/javascript"> if (! <cfoutput>####' & arguments.element.label & "_ifmethod_" & arguments.element.devIFMethod.name & '####</cfoutput>) { $("item-' & arguments.element.label & '").remove(); } </script>');
            }
        </cfscript>
        <cfreturn "">
    </cffunction>

</cfcomponent>
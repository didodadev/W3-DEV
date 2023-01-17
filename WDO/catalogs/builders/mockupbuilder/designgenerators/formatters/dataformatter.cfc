<cfcomponent>
    <cffunction name="format" access="public">
        <cfargument name="content">
        <cfargument name="element">
        <cfscript>
            switch (arguments.element.dataType) {
                case "Date":
                    return 'Dateformat(' & arguments.content & ', dateformat_style)';
                    break;
                default:
                    return arguments.content;
            }
        </cfscript>
    </cffunction>
</cfcomponent>
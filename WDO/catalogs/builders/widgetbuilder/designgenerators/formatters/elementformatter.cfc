<cfcomponent>

    <cffunction name="format" access="public" returntype="string">
        <cfargument name="element" type="any">
        <cfargument name="domain" type="any">
        <cfscript>
            domainElement = getDomainElement(arguments.element, arguments.domain);
            switch (domainElement.dataType) {
                case "Money":
                    return "AmountFormat(%s)"
                    break;
                default:
            }
        </cfscript>
    </cffunction>

    <!--- local helpers --->

    <cffunction name="getDomainElement" access="private" returntype="any">
        <cfargument name="element" type="any">
        <cfargument name="domain" type="any">
        <cfscript>
            table = arguments.domain[arrayFind(arguments.domain, function(struct) {
                return struct.name eq element.struct;
            })];
            result = table.listOfElements[arrayFind(table.listOfElements, function(elm) {
                return elm.label eq element.label;
            })];
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>
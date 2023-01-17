<cfcomponent extends="WDO.catalogs.builders.componentbuilders.querybuilders.plugins.conditions.formatter">
    <cffunction name="rightConditionFormatter" access="public" returntype="string">
        <cfargument name="field" type="struct">
        <cfargument name="cond" type="string">
        <cfargument name="otherfield" type="struct">
        <cfscript>
            formatstr = "";
            switch (field.fieldType) {
                case "nvarchar":
                case "ntext":
                    switch (cond) {
                        case "CONTAINS":
                        case "NOT CONTAINS":
                            formatstr = "'%%' + %s + '%%'";
                            break;
                        case "END WITH":
                            formatstr = "%s + '%%'";
                            break;
                        case "START WITH":
                            formatstr = "'%%' + %s";
                            break;
                        default:
                            formatstr = "%s";
                    }
                    break;
                default:
                    formatstr = "%s";
            }
        </cfscript>
        <cfreturn formatstr>
    </cffunction>
</cfcomponent>
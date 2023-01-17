<cfcomponent extends="WDO.catalogs.builders.componentbuilders.querybuilders.plugins.conditions.formatter">
    <cffunction name="leftConditionFormatter" access="public" returntype="string">
        <cfargument name="field" type="struct">
        <cfargument name="cond" type="string">
        <cfargument name="otherfield" type="struct">
        <cfscript>
            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
            formatstr = "<c" & 'fqueryparam cfsqltype="' & helper.toSqlType(otherfield.fieldType) & '" value="##arguments.%s##">';
        </cfscript>
        <cfreturn formatstr>
    </cffunction>

    <cffunction name="rightConditionFormatter" access="public" returntype="string">
        <cfargument name="field" type="struct">
        <cfargument name="cond" type="string">
        <cfargument name="otherfield" type="struct">
        <cfscript>
            formatstr = "";
            switchval = "";
            if (isdefined("field.fieldType")) 
            {
                switchval = field.fieldType;
            }
            else if (isdefined("otherfield.fieldType")) 
            {
                switchval = otherfield.fieldType;
            }
            switch (switchval) {
                case "nvarchar":
                case "ntext":
                    switch (cond) {
                        case "CONTAINS":
                        case "NOT CONTAINS":
                            formatstr = "%%##%s##%%";
                            break;
                        case "END WITH":
                            formatstr = "##%s##%%";
                            break;
                        case "START WITH":
                            formatstr = "%%##%s##";
                            break;
                        default:
                            formatstr = "##%s##";
                    }
                    break;
                default:
                    formatstr = "##%s##";
            }
            helper = createObject("component", "WDO.catalogs.builders.componentbuilders.querybuilders.Helper");
            formatstr = "<c" & 'fqueryparam cfsqltype="' & helper.toSqlType(otherfield.fieldType) & '" value="' & formatstr & '">';
        </cfscript>
        <cfreturn formatstr>
    </cffunction>
</cfcomponent>
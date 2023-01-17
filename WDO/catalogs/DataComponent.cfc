<cfcomponent>

    <cfproperty name="DATE" type="any">
    <cfproperty name="EMP" type="any">
    <cfproperty name="IP" type="any">
    <cfproperty name="PAR" type="any">

    <cffunction name="init">
        <cfscript>
            this.DATE = now();
            this.EMP = session.ep.userid;
            this.IP = cgi.REMOTE_ADDR;
            this.PAR = session.ep.userid;
        </cfscript>
    </cffunction>

    <cffunction name="equalityToSql" access="public" returntype="string">
        <cfargument name="equalityData">
        <cfscript>
            switch (arguments.equalityData) {
                case "less":
                    return "<";
                case "greater":
                    return ">";
                case "lessequal":
                    return "<=";
                case "greaterequal":
                    return ">=";
                case "like":
                    return "LIKE";
                default:
                    return "=";
            }
        </cfscript>
    </cffunction>

    <cffunction name="toSqlType" access="public" returntype="string">
        <cfargument name="type" type="string">
        <cfscript>
        result = "";
        switch (type) {
            case "int":
            case "Numeric":
                result = "CF_SQL_INTEGER";
                break;
            case "datetime":
            case "Date":
                result = "CF_SQL_DATE";
                break;
            case "float":
            case "Money":
                result = "CF_SQL_FLOAT";
                break;
            case "decimal":
                result = "CF_SQL_DECIMAL";
                break;
            case "bit":
                result = "CF_SQL_BIT";
            default:
                result = "CF_SQL_NVARCHAR";
                break;
        }
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>
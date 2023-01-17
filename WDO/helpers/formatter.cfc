<cfcomponent>
    <cffunction name="formatByEPCurrency" access="public" returntype="string">
        <cfargument name="value" type="any">
        <cfscript>
            result = stringFormat("%." & session.ep.our_company_info.rate_round_num & "f", [value]);
        </cfscript>
        <cfreturn result>
    </cffunction>

    <!--- local helpers --->
    <cffunction name="stringFormat" access="public" returntype="string">
        <cfargument name="format" type="string">
        <cfargument name="values" type="array">
        <cfscript>
            jString = createObject("java", "java.lang.String");
            return jString.format(format, values);
        </cfscript>
    </cffunction>

</cfcomponent>
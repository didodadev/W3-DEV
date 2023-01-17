<cfcomponent>
    <cffunction name="getStruct" access="public" returntype="struct">
        <cfargument name="structName" type="string">
        <cfargument name="data" type="any">
        <cfscript>
            current = {};
            for (stc in data)
            {
                if (stc.name eq structName) 
                {
                    current = stc;
                    break;
                }
            }
        </cfscript>
        <cfreturn current>
    </cffunction>

    <cffunction name="getElements" access="public" returntype="array">
        <cfargument name="flag" type="string">
        <cfargument name="data" type="any">
        <cfscript>
            elements = arrayFilter(data, function(item) {
                return item[flag] eq 1;
            });
        </cfscript>
        <cfreturn elements>
    </cffunction>

    <cffunction name="getProperties" access="public" returntype="array">
        <cfargument name="flag" type="string">
        <cfargument name="data" type="any">
        <cfargument name="hasCondition" type="boolean" default="1">

        <cfscript>
            properties = arrayFilter(data, function(item) {
                return item[flag] eq 1 and (hasCondition eq 0 or arrayLen(item.listOfConditions) gt 0)
            });
        </cfscript>
        <cfreturn properties>
    </cffunction>

    <cffunction name="distinctArray" access="public" returntype="array">
        <cfargument name="data" type="array">
        <cfscript>
            var output = arrayNew(1);
		    output.addAll(createObject("java", "java.util.HashSet").init(arguments.data));
		    return output;
        </cfscript>
    </cffunction>

    <cffunction name="findTables" access="public" returntype="array">
        <cfargument name="data" type="array">
        <cfscript>
            allTables = arrayMap(data, function(elm) {
                return elm.devDBField.scheme & "." & elm.devDBField.table;
            });
            distinctTable = distinctArray(allTables);
        </cfscript>
        <cfreturn distinctTable>
    </cffunction>

    <cffunction name="formatString" access="public" returntype="string">
        <cfargument name="format" type="string">
        <cfargument name="data" type="array">
        <cfscript>
            jString = createObject("java", "java.lang.String");
            return jString.format(format, data);
        </cfscript>
    </cffunction>
    
    <cffunction name="dataTypeToCFType" access="public" returntype="string">
        <cfargument name="dataType" type="string">
        <cfscript>
            switch (dataType) {
                case "Numeric":
                case "Money":
                    return "numeric";
                case "Date":
                    return "date";
                default:
                    return "string";
            }
        </cfscript>
    </cffunction>

    <cffunction name="masterContainsField" access="public" returntype="any">
        <cfargument name="data" type="any">
        <cfargument name="structName" type="string">
        <cfargument name="relation" type="any">
        <cfscript>
            var currentStruct = arrayFilter( arguments.data, function (stk) {
                return stk.name eq structName;
            })[1];
            var filtered = arrayFilter( currentStruct.listOfElements, function (elm) {
                return elm.devAdd eq 1 
                    && elm.devDBField.value neq "" 
                    && elm.devDBField.table eq relation.table
                    && elm.devDBField.field eq relation.field
                    ;
            });
            if ( arrayLen( filtered ) > 0 ) {
                return filtered[1].label;
            } else {
                return 0;
            }
        </cfscript>
    </cffunction>

    <cffunction name="crlf" access="public" returntype="string">
        <cfreturn CreateObject("java", "java.lang.System").getProperty("line.separator")>
    </cffunction>
    <cffunction name="tab" access="public" returntype="string">
        <cfreturn "    ">
    </cffunction>
</cfcomponent>
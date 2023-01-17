<cfcomponent>
    
    <cffunction name="getAttributes" access="public" returntype="any">
        <cfargument name="element" type="any">
        <cfargument name="domain" type="any">
        <cfargument name="mode" type="string">
        <cfscript>
            resultArray = [];
            if (arguments.mode eq "field")
            {
                arrayAppend(resultArray, 'onchange="gridUpdater.update($(this), ''' & arguments.element.struct & ''', ''field'')"');
            }
            
            struct = getTable(arguments.element, arguments.domain);

            try 
            {
                keyElement = struct.listOfElements[arrayFind(struct.listOfElements, function(elm) {
                    return elm.isKey eq 1;
                })];    
            } catch (any ex) {
                return resultArray;
            }
            
            arrayAppend(resultArray, 'data-keyfield="' & keyElement.label & '"');
            arrayAppend(resultArray, 'data-keyvalue="##iif(isDefined("' & keyElement.label & '"), "' & keyElement.label & '", DE(""))##"');
            arrayAppend(resultArray, 'data-name="' & arguments.element.label & '"');
            arrayAppend(resultArray, 'data-grideditor="true"');

        </cfscript>
        <cfreturn resultArray>
    </cffunction>

    <cffunction name="getTable" access="private" returntype="any">
        <cfargument name="element" type="any">
        <cfargument name="domain" type="any">
        <cfscript>
            stk = arguments.element.struct;
            stck = arguments.domain[arrayFind(arguments.domain, function(elm) {
                return elm.name eq stk;
            })];
        </cfscript>
        <cfreturn stck>
    </cffunction>

    <!--- helpers --->
    <cffunction name="stringFormat" access="public" returntype="string">
        <cfargument name="format" type="string">
        <cfargument name="values" type="array">
        <cfscript>
            jString = createObject("java", "java.lang.String");
            return jString.format(format, values);
        </cfscript>
    </cffunction>
    <cffunction name="crlf" access="public" returntype="string">
        <cfreturn CreateObject("java", "java.lang.System").getProperty("line.separator")>
    </cffunction>
    <cffunction name="ident" access="public" returntype="string">
        <cfargument name="count" type="numeric" default="1">
        <cfreturn repeatString("     ", arguments.count)>
    </cffunction>

</cfcomponent>
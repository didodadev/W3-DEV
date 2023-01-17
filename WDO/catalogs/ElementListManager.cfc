<cfcomponent>
    
    <cffunction name="getValue" returntype="any">
        <cfargument name="data">
        <cfargument name="key">
        <cfscript>
            keyindex = arrayFind( valueArray(arguments.data, "ITEMKEY"), arguments.key );
            if (keyindex gt 0) {
                return valueArray(arguments.data, "ITEMVALUE")[keyindex];
            } else {
                return key;
            }
        </cfscript>
    </cffunction>

</cfcomponent>
<cfcomponent>

    <cfproperty name="bodyonload" type="struct">
    <cfproperty name="bodyunload" type="struct">

    <cffunction name="init" returntype="any">
        <cfset this.bodyonload = structNew()>
        <cfset this.bodyunload = structNew()>
        <cfreturn this>
    </cffunction>

    <cffunction name="addOnload">
        <cfargument name="name">
        <cfargument name="code">
        <cfset this.bodyonload[arguments.name] = code>
    </cffunction>

    <cffunction name="addUnload">
        <cfargument name="name">
        <cfargument name="code">
        <cfset this.bodyunload[arguments.name] = code>
    </cffunction>

    <cffunction name="getOnload" returntype="array">
        <cfreturn structReduce(this.bodyonload, function( acc, key, value ) {
            acc = structKeyExists(arguments,"acc")?arguments.acc:[];
            arrayAppend(acc, value);
            return acc;
        }, [])>
    </cffunction>

    <cffunction name="getUnload" returntype="array">
        <cfreturn structReduce(this.bodyunload, function( acc, key, value ) {
            acc = structKeyExists(arguments,"acc")?arguments.acc:[];
            arrayAppend(acc, value);
            return acc;
        }, [])>
    </cffunction>

</cfcomponent>
<cfcomponent>

    <!--- the dependency list --->
    <cfproperty name="dependencyList" type="array">

    <!--- initialize dependency list --->
    <cffunction name="init" access="public" returntype="any">
        <cfset this.dependencyList = arrayNew(1)>
        <cfreturn this>
    </cffunction>

    <cffunction name="addDependency" access="public">
        <cfargument name="dependStruct" type="string">
        <cfargument name="dependEvent" type="string">
        <cfargument name="dependComponent" type="string" default="addons">
        <cfscript>
            hasAttached = arrayFind( this.dependencyList, function(elm) {
                return elm.dependStruct eq dependStruct and elm.dependEvent eq dependEvent;
            });
            if ( hasAttached eq 0 ) {
                arrayAppend( this.dependencyList, { dependComponent: url.fuseact, dependStruct: arguments.dependStruct, dependEvent: arguments.dependEvent } );
            }
        </cfscript>
    </cffunction>

    <cffunction name="getDependencies" access="public">
        <cfreturn this.dependencyList>
    </cffunction>

</cfcomponent>
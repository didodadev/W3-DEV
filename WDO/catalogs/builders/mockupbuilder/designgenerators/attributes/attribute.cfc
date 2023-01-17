 <cfcomponent>
    <cfproperty name="element" type="any">
    <cfproperty name="structname" type="any">

    <cffunction name="init" access="public" returntype="any">
        <cfargument name="element" type="any">
        <cfargument name="structname" type="any" default="">
        <cfset this.element = arguments.element>
        <cfset this.structname = arguments.structname>
        <cfreturn this>
    </cffunction>

    <cffunction name="generate" access="public" returntype="string">
        <cfreturn "">
    </cffunction>
 </cfcomponent>
<cfcomponent>

    <cfproperty name="ConfigurationService" type="WMO.Services.ApplicationConfigurationService">
    <cfproperty name="Services" type="array">
    <cfproperty name="ApplicationVariableScope">

    <cffunction name="initialize" access="public">
        <cfargument name="ApplicationVariableScope" type="struct">
        <cfset this.ApplicationVariableScope = arguments.ApplicationVariableScope>
        <cfset this.Services = {}>
        <cfset this.ConfigurationService = new WMO.Services.ApplicationConfigurationService( this.ApplicationVariableScope )>
    </cffunction>

    <cffunction name="Register" access="public">
        <cfargument name="path" type="string">
        <cfset service = createObject( "component", arguments.path )>
        <cfif structKeyExists( this.Services, this.path_to_name( arguments.path ) )>
            <cfset this.Services[ this.path_to_name( arguments.path ) ] = service>
        <cfelse>
            <cfset structAppend( this.Services, { #this.path_to_name( arguments.path )#: service } )>
        </cfif>
        <cfset service.Register()>
    </cffunction>

    <!--- helpers ---->
    <cffunction name="path_to_name" returntype="string">
        <cfargument name="path" type="string">
        <cfset result = arguments.path>
        <cfloop array="#[ ".", "/", "\" ]#" index="elm">
            <cfset result = replace( result, elm, "_", "all" )>
        </cfloop>
        <cfreturn result>
    </cffunction>
</cfcomponent>
<cfcomponent>

    <cfproperty name="ApplicationVariableScope">

    <cffunction name="init" access="public">
        <cfargument name="ApplicationVariableScope">
        <cfset this.ApplicationVariableScope = arguments.ApplicationVariableScope>
    </cffunction>

    <cffunction name="RegisterComponentConfiguration" access="public" hint="Register application configuration components">
        <cfargument name="Path" type="string" hint="Component dot notation path">
        <cfscript>
            configurator = createObject( "component", arguments.Path );
            configuration = (IsDefined("configurator.Get") ? configurator.Get() : configurator.systemParam());
            
            if ( not isDefined( "application.systemParam" ) )
                application.systemParam = {};
            
            structAppend( application.systemParam,  configuration, "yes" );
            structAppend( this.ApplicationVariableScope, application.systemParam );
        </cfscript>
    </cffunction>

    <cffunction name="RegisterJsonConfiguration" access="public" hint="Register application configuration json file">
    </cffunction>

    <cffunction name="RegisterRemoteConfiguration" access="public" hint="Register application configuration URL for remote json load">
    </cffunction>

</cfcomponent>
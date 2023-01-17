<!---

    Author : Uğur Hamurpet
    Create Date : 20/03/2021
    Methods : {}

--->

<cfcomponent extends = "V16/settings/cfc/params_settings">

    <cffunction name="setParameter" access="public">
        <cfargument name="parameter_name" type="string" required="true">
        <cfargument name="parameter_value" type="any" required="true">

        <cfif not IsDefined("application.parameters") or not isDefined("application.systemParam")>
            <cfset application.parameters = StructNew() />
            <cfset application.systemParam.systemParam = this.systemParam />
        </cfif>

        <cfif not StructKeyExists(application.parameters, arguments.parameter_name)>
            <cfif IsStruct(arguments.parameter_value)>
                <cfset StructAppend(application.parameters, arguments.parameter_value) />
            <cfelse>
                <cfset StructInsert(application.parameters, arguments.parameter_name, arguments.parameter_value) />
            </cfif>
        <cfelse>
            <cfset application.parameters[arguments.parameter_name] = arguments.parameter_value />
        </cfif>
    </cffunction>

    <cffunction name = "setParameterFromDB" access = "public">
        <cfif not IsDefined("application.parameters") or not isDefined("application.systemParam")>
            <cfset application.parameters = StructNew() />
            <cfset application.systemParam.systemParam = this.systemParam />
        </cfif>
        <cfset structAppend(application.parameters, this.getDeserializedParams(), false) />
    </cffunction>

    <cffunction name="getParameter" access="public">
        <cfreturn application.systemParam.systemParam() />
    </cffunction>

    <cffunction name="systemParam" access="public" returntype="struct">
        <cfreturn application.parameters>
    </cffunction>

</cfcomponent>
<cfcomponent>
    <cfset _crlf="">

    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="data" type="any">
        <cfargument name="prefix" type="string" default="">
        <cfreturn "">
    </cffunction>

    <cffunction name="createGenerator" access="public" returntype="any">
        <cfargument name="type" type="string">
        <cfswitch expression="#type#">
            <cfcase value="customTag">
                <cfreturn CreateObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.customtagcodegenerator")>
            </cfcase>
            <cfcase value="MethodQuery">
                <cfreturn CreateObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.querymethodcodegenerator")>
            </cfcase>
            <cfcase value="session">
                <cfreturn CreateObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.sessioncodegenerator")>
            </cfcase>
            <cfcase value="SystemParam">
                <cfreturn CreateObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.systemparamcodegenerator")>
            </cfcase>
            <cfcase value="Workdata">
                <cfreturn createObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.workdatagenerator")>
            </cfcase>
            <cfcase value="CustomCode">
                <cfreturn createObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.customcodegenerator")>
            </cfcase>
            <cfcase value="lists">
                <cfreturn createObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.listcodegenerator")>
            </cfcase>
        </cfswitch>
    </cffunction>

    <cffunction name="crlf" access="public" returntype="string">
        <cfscript>
            if (len(_crlf) eq 0)
            {
                _crlf = CreateObject("java", "java.lang.System").getProperty("line.separator");
            }
        </cfscript>
        <cfreturn _crlf>
    </cffunction>
</cfcomponent>
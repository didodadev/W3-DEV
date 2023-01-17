<cfparam name="attributes.process" default="display">
<cfparam name="attributes.st" default="deployment">
<cfoutput>
    #factory( attributes.event, attributes.process )#
</cfoutput>

<!--- methods --->
<!--- factory --->
<cffunction name="factory" returntype="string">
    <cfargument name="event">
    <cfargument name="process">
    
    <cfif process eq "display">
        <cfset path = "/NoCode/" & clean_fuseact( attributes.fuseact ) & "/" & attributes.st & "/" & attributes.event & "/widget.cfm">
    <cfelseif process eq "save">
        <cfset path = "/NoCode/" & clean_fuseact( attributes.fuseact ) & "/" & attributes.st & "/" & attributes.event & "/widgetdata.cfm">
    </cfif>

    <cfsavecontent variable="outputdata">
        <cfinclude template="#path#">
    </cfsavecontent>

    <cfreturn outputdata>
</cffunction>

<!--- helpers --->

<!--- clean and normalize fuseact for path --->
<cffunction name="clean_fuseact" returntype="string">
    <cfargument name="fuseact" type="string">
    <cfset retval = replace( arguments.fuseact, ".", "_" )>
    <cfreturn retval>
</cffunction>
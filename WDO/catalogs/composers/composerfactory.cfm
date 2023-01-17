<cfparam name="attributes.md" default="holistic">
<cfparam name="attributes.th" default="default">

<cfif isDefined( "attributes.fuseact" )>
    <cfset md_path = get_md()>
    <cfset th_path = get_th()>
    <cfinclude template="#md_path##th_path#.cfm">
</cfif>


<!--- helpers --->
<!--- get mode part factory name --->
<cffunction name="get_md">
    <cfswitch expression="#attributes.md#">
        <cfdefaultcase>
            <cfreturn "holistic">
        </cfdefaultcase>
    </cfswitch>
</cffunction>

<!--- get theme part factory name ---->
<cffunction name="get_th">
    <cfswitch expression="#attributes.th#">
        <cfcase value="box">
            <cfreturn "_box">
        </cfcase>
        <cfdefaultcase>
            <cfreturn "">
        </cfdefaultcase>
    </cfswitch>
</cffunction>
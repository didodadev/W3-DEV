<cfparam name="attributes.mode" default="">
<cfparam name="attributes.struct" default="">
<link rel="stylesheet" href="/css/assets/template/workdev/animate.css">
<link rel="stylesheet" href="/css/assets/template/workdev/workdev.min.css">
<cfinclude template="./catalogs/designers/mapperdesigner/model.cfm">

<cfswitch expression="#attributes.mode#">

    <cfcase value="structlist">
        <cfset GetPageContext().getCFOutput().clear()>
        <cfset structlist = getStructNames( attributes.fuseact )>
        <cfoutput>#replace(serializeJSON(structlist), "//", "")#</cfoutput>
        <cfabort>
    </cfcase>

    <cfcase value="structdet">
        <cfset GetPageContext().getCFOutput().clear()>
        <cfset structlist = getstruct( attributes.fuseact, attributes.struct )>
        <cfoutput>#replace(serializeJSON(structlist), "//", "")#</cfoutput>
        <cfabort>
    </cfcase>

    <cfdefaultcase>
        <cfinclude template="./catalogs/designers/mapperdesigner/layout.cfm">
        <cfinclude template="./catalogs/designers/mapperdesigner/appengine.cfm">
    </cfdefaultcase>
</cfswitch>
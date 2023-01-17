<cfset model = createObject("component","WDO.catalogs.designers.mockupdesigner.model") />

<cfswitch expression="#attributes.event#">

    <cfcase value="add,upd" delimiters=",">
        <cfinclude template="./catalogs/designers/mockupdesigner/layout.cfm">
        <cfinclude template="./catalogs/designers/mockupdesigner/appengine.cfm">
    </cfcase>

    <cfcase value="det">
        <cfinclude template="./catalogs/designers/mockupdesigner/layout_det.cfm">
    </cfcase>

    <cfdefaultcase>
        <cfinclude template="./catalogs/designers/mockupdesigner/list.cfm">
    </cfdefaultcase>

</cfswitch>

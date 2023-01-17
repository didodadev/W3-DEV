
<cfparam name="attributes.fuseact" default="#iif(isdefined("attributes.fuseact"),"attributes.fuseact",de(""))#">
<cfinclude template="./catalogs/designers/eventdesigner/model.cfm">

<cfset attributes.mode = attributes.mode?: attributes.event />

<cfswitch expression="#attributes.mode#">
    <cfcase value="add">
        <cfinclude template="./catalogs/designers/eventdesigner/form.cfm">
        <cfinclude template="./catalogs/designers/eventdesigner/formengine.cfm">
    </cfcase>
    <cfcase value="upd">
        <cfinclude template="./catalogs/designers/eventdesigner/layout.cfm">
        <cfinclude template="./catalogs/designers/eventdesigner/appengine.cfm">
    </cfcase>
    <cfcase value="save">
        <cfinclude template="./catalogs/designers/eventdesigner/save.cfm">
    </cfcase>
    <cfcase value="setlayout">
        <cfinclude template="./catalogs/designers/eventdesigner/setlayout.cfm">
    </cfcase>
    <cfcase value="publish">
        <cfinclude template="./catalogs/designers/eventdesigner/eventpublisher.cfm">
    </cfcase>
    <cfcase value="listevents">
        <cfinclude template="./catalogs/designers/eventdesigner/listevents.cfm">
    </cfcase>
    <cfdefaultcase>
        <cfinclude template="./catalogs/designers/eventdesigner/list.cfm">
    </cfdefaultcase>
</cfswitch>
<cfscript>
	getObj = CreateObject("component","cfc.system");
</cfscript>

<cfparam name="attributes.fuseact" default="#iif(isdefined("attributes.fuseact"),"attributes.fuseact",de(""))#">
<cfinclude template="./catalogs/designers/widgetdesigner/model.cfm">

<cfset attributes.mode = attributes.mode?: attributes.event />

<cfswitch expression="#attributes.mode#">
	<cfcase value="add">
        <cfinclude template="./catalogs/designers/widgetdesigner/form.cfm">
        <cfinclude template="./catalogs/designers/widgetdesigner/formengine.cfm">
	</cfcase>
	<cfcase value="upd">
		<cfinclude template="./catalogs/designers/widgetdesigner/layout.cfm">
		<cfinclude template="./catalogs/designers/widgetdesigner/appengine.cfm">
	</cfcase>
	<cfcase value="save">
        <cfinclude template="./catalogs/designers/widgetdesigner/save.cfm">
    </cfcase>
	<cfcase value="savedesign">
        <cfinclude template="./catalogs/designers/widgetdesigner/savedesign.cfm">
    </cfcase>
	<cfcase value="saveandgeneratedesign">
        <cfinclude template="./catalogs/designers/widgetdesigner/saveandgeneratedesign.cfm">
    </cfcase>
	<cfcase value="preview">
        <cfinclude template="./catalogs/designers/widgetdesigner/preview.cfm">
    </cfcase>
	<cfdefaultcase>
        <cfinclude template="./catalogs/designers/widgetdesigner/list.cfm">
    </cfdefaultcase>
</cfswitch>
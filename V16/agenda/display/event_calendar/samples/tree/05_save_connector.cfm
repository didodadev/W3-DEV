<cfinclude template="../config.cfm">
<cfset tree = createObject("component",request.dhtmlxConnectors["tree"]).init(request.dhtmlxConnectors["datasource"])>
<cfset tree.render_table("tasks","taskId","taskName","","parentId")>


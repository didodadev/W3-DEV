<cfinclude template="../config.cfm">

<cfset tree = createObject("component",request.dhtmlxConnectors["treegrid"]).init(request.dhtmlxConnectors["datasource"])>
<cfset tree.dynamic_loading(true)>
<cfset tree.render_table("tasks","taskId","taskName,duration,complete","","parentId")>


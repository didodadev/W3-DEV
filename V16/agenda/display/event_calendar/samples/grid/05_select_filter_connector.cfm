<cfinclude template="../config.cfm">

<cfset grid = createObject("component",request.dhtmlxConnectors["grid"]).init(request.dhtmlxConnectors["datasource"])>
<cfset grid.dynamic_loading(100)>
<cfset grid.render_table("countries","item_id","item_nm,item_cd")>


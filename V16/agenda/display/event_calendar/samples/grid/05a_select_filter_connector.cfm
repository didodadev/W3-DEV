<cfinclude template="../config.cfm">

<cfset grid = createObject("component",request.dhtmlxConnectors["grid"]).init(request.dhtmlxConnectors["datasource"])>
<cfset grid.dynamic_loading(100)>

<cfset filter1 = createObject("component",request.dhtmlxConnectors["options"]).init(request.dhtmlxConnectors["datasource"])>
<cfset filter1.render_sql("SELECT  DISTINCT SUBSTR(item_nm,1,2) as value from countries","item_id","item_nm(value)")>
<cfset grid.set_options("item_nm",filter1)>
<cfset grid.render_table("countries","item_id","item_nm,item_cd")>



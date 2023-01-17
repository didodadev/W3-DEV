<cfinclude template="../config.cfm">
<cfset combo = createObject("component",request.dhtmlxConnectors["combo"]).init(request.dhtmlxConnectors["datasource"])>
<cfset combo.render_table("country_data","country_id","name")>


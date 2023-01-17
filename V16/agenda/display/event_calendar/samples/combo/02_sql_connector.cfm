<cfinclude template="../config.cfm">

<cfset combo = createObject("component",request.dhtmlxConnectors["combo"]).init(request.dhtmlxConnectors["datasource"])>
<cfset combo.render_sql("SELECT * FROM country_data  WHERE country_id >40 ","country_id","name")>


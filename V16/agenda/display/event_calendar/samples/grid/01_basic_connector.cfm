<cfinclude template="../config.cfm">

<cfset grid = createObject("component",request.dhtmlxConnectors["grid"]).init(request.dhtmlxConnectors["datasource"])>

<!--- log --->
<cfparam name="error" default="">
<cfset grid.enable_log(expandPath(getFileFromPath(getCurrentTemplatePath())) & ".txt",true,error)>

<cfset grid.dynamic_loading(100)>
<cfset grid.render_table("grid50000","item_id","item_nm,item_cd")>


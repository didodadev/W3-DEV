<cfinclude template="../config.cfm">
<cfset grid = createObject("component",request.dhtmlxConnectors["grid"]).init(request.dhtmlxConnectors["datasource_msAccess"],"MSAccess")>

<!--- log --->
<cfparam name="error" default="">
<cfset grid.enable_log(expandPath(getFileFromPath(getCurrentTemplatePath())) & ".txt",true,error)>

<cfset grid.dynamic_loading(100)>
<!--- number, text. We need the types to define: whether we need define quotes in quiries or not ----->
<cfset grid.field_types("item_id:number,item_nm:text,item_cd:text")>
<cfset grid.render_table("grid50000","item_id","item_nm,item_cd")>



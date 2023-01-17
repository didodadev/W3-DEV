<!--- just define dataources and connector paths --->
<cfset request.dhtmlxConnectors = StructNew()>
<cfset request.dhtmlxConnectors["datasource"] = #DSN#> <!---  "sampleDB" --->
<cfset request.dhtmlxConnectors["datasource_mssql"] = "sampleDB_MSSQL">
<cfset request.dhtmlxConnectors["datasource_msAccess"] = "sampleDB_MSAccess">
<!--- here are the Full Mappings to the directoy with connectors. Later the <path>.<cfcName> must be accessed --->
<cfset request.dhtmlxConnectors["combo"] = "dhtmlx.dhtmlxConnector_cfm.codebase.ComboConnector">
<cfset request.dhtmlxConnectors["tree"] = "dhtmlx.dhtmlxConnector_cfm.codebase.TreeConnector">
<cfset request.dhtmlxConnectors["options"] = "dhtmlx.dhtmlxConnector_cfm.codebase.OptionsConnector">
<cfset request.dhtmlxConnectors["grid"] = "dhtmlx.dhtmlxConnector_cfm.codebase.GridConnector">
<cfset request.dhtmlxConnectors["treegrid"] = "dhtmlx.dhtmlxConnector_cfm.codebase.TreeGridConnector">
<cfset request.dhtmlxConnectors["scheduler"] = "dhtmlx.dhtmlxConnector_cfm.codebase.SchedulerConnector"> <!---  "Yüklenen Sınıf" --->


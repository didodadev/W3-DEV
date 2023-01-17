<cfsetting showdebugoutput="no">
<cfscript>
	CreateComponent = CreateObject("component","/../workdata/#url.comp_name#");
	queryResult = CreateComponent.getComponentFunction();
</cfscript>
<?xml version='1.0' encoding='iso-8859-1'?>
<rows>
<cfoutput query="queryResult">
<row><cell>#UNIT_ID#</cell><cell>#UNIT_NAME#</cell><cell>#UNIT_DESC#</cell></row>
</cfoutput>
</rows>

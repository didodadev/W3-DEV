<cfif (IsDefined('caller.isLoad') neq true)>  
	<link rel="stylesheet" type="text/css" href="test/serhat/autocomplete/codebase/dhtmlxcombo.css" />
	
	<script  src="test/serhat/autocomplete/codebase/dhtmlxcommon.js"></script>
	<script  src="test/serhat/autocomplete/codebase/dhtmlxcombo.js"></script>
	
	<cfset caller.isLoad=true>
</cfif>
	
<cfparam name="attributes.dsn" default=" ">
<cfparam name="attributes.tableName" default=" ">
<cfparam name="attributes.where" default=" ">
<cfparam name="attributes.optionValue" default=" ">
<cfparam name="attributes.optionText" default=" ">
<cfparam name="attributes.mask" default="">
<cfparam name="attributes.name" default="">

<script>
	window.dhx_globalImgPath="test/serhat/autocomplete/codebase/imgs/";
</script>

<cfoutput>
<div id="#attributes.name#" style="width:200px; height:30px; position:relative;"></div>

	<script>
		var z_#attributes.name#=new dhtmlXCombo("#attributes.name#","alfa4",200);
		z_#attributes.name#.enableFilteringMode(true,"http://ep.workcube/index.cfm?fuseaction=test.emptypopup_complete_query&dsn=#attributes.dsn#&tableName=#attributes.tableName#&where=#attributes.where#&optionValue=#attributes.optionValue#&optionText=#attributes.optionText#",true);
	</script>
</cfoutput>
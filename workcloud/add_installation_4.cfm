<cfinclude template="../fbx_workcube_param_gecici.cfm">
	
<cftry>

	<cfset row = 1>
	<cfset maxRowForQuery = 5000>
	<cfset acilis_codu_ = '<cfquery name="ADD_LANGUAGES" datasource="#DSN#">'>
	<cfset kapanis_codu_ = '</cfquery>'>
	<cfset newFile = "">
	<cfset filePath = "languages/language.cfm">
	
	<cfsavecontent variable="languages"><cfinclude template="#filePath#"></cfsavecontent>
	<cfset languages = replace(languages,'v16_catalyst','#DSN#','all')>
	<cfset languages = replace(languages,'GO','','all')>
	<cfset linecount = listlen(languages,chr(13))>
	<cffile action="write" output="#languages#" addnewline="yes" file="#index_folder_ilk_#languages/language.txt" charset="utf-8">
	
	<cfset newFile = acilis_codu_>
	<cfloop index="line" file="#index_folder_ilk_#languages/language.txt" charset="utf-8">
		
		<cfif row MOD maxRowForQuery eq 0> 
			<cfset newFile = "#newFile##line##kapanis_codu_##acilis_codu_#">
		<cfelseif row eq linecount>
			<cfset newFile = "#newFile##line##kapanis_codu_#">
		<cfelse>
			<cfset newFile = "#newFile##line#">	
		</cfif>
		<cfset row = row + 1>

	</cfloop>
	
	<cffile action="write" output="#newFile#" addnewline="yes" file="#index_folder_ilk_#language.cfm" charset="utf-8">
	
	<cftransaction>
		<cfinclude template="language.cfm">
	</cftransaction>
	
	<cffile action="delete" file="#index_folder_ilk_#/languages/language.txt">
	<cffile action="delete" file="#index_folder_ilk_#language.cfm">
	
<cfcatch type = "any">
	<cfif FileExists("#index_folder_ilk_#language.cfm")>
		<cffile action="delete" file="#index_folder_ilk_#language.cfm">
	</cfif>
</cfcatch>

</cftry>
<cfdirectory action="LIST" directory="#upload_folder#training#dir_seperator##attributes.folder#" name="liste">

<cfoutput query="liste">
	<cfif ((liste.name is not ".") and (liste.name is not ".."))>
		<cffile action="DELETE" file="#upload_folder#training#dir_seperator##attributes.folder##dir_seperator##liste.name#">
	</cfif>
</cfoutput>

<cfdirectory action="DELETE" directory="#upload_folder#training#dir_seperator##attributes.folder#">

<cfscript>
	structdelete(session,"training_folder");
</cfscript>
<cflocation url="#request.self#?fuseaction=training_management.list_training_subjects" addtoken="No">

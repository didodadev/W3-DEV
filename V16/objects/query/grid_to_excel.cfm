<cfquery name="GET_FILE_PATH" datasource="#DSN#">
	SELECT FILE_PATH FROM WRK_OBJECTS WHERE FUSEACTION = '#listlast(attributes.fuseact,'.')#' AND MODUL_SHORT_NAME = '#listFirst(attributes.fuseact,'.')#'
</cfquery>
<cf_get_lang_set module_name="#attributes.langCircuit#">
<cfinclude template="../../#GET_FILE_PATH.FILE_PATH#">

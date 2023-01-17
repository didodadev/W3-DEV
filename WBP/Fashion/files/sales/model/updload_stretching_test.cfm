<cfobject name="filehelper" component="WBP.Fashion.files.helpers.filehelper">
<cfset docu_file_name = filehelper.save_uploaded_file("docu_file", upload_folder)>
<cfquery name="query_uploaded_file" datasource="#dsn#_#session.ep.company_id#">
    UPDATE TEXTILE_STRETCHING_TEST_HEAD SET DOCU_FILE = '#docu_file_name#' WHERE STRETCHING_TEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.st_id#'>
</cfquery>
<cfset GetPageContext().getCFOutput().clear()>
1
<cfabort>
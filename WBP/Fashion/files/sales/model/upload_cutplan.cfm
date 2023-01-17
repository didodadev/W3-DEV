<cfobject name="filehelper" component="WBP.Fashion.files.helpers.filehelper">
<cfset docu_file_name = filehelper.save_uploaded_file("docu_file", upload_folder)>
<cfset GetPageContext().getCFOutput().clear()>
<cfoutput>#docu_file_name#</cfoutput>
<cfabort>
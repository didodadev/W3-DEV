<cfheader name="Content-Disposition" value="attachment;filename=#index_folder#documents#dir_seperator##attributes.file_name#">
<cfcontent file="#download_folder#documents#dir_seperator##attributes.file_name#" type="application/octet-stream" deletefile="no">

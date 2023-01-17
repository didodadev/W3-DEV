<cfsetting showdebugoutput="no">
<cfinclude template="../display/exchange_conn.cfm">

<cfexchangemail action="getAttachments" connection="sample" folder="#URL.folder#" uid="<#URL.mail_id#>"  name="attachData" generateUniqueFilenames="yes" attachmentPath="#ExpandPath( "./" )#documents/temp\"> 

<cfoutput>
  <cfcontent deleteFile="Yes" file="#ExpandPath( "./" )#documents/temp/#URLDecode(URL.file)#" type="#URLDecode(URL.mimetype)#">
</cfoutput>

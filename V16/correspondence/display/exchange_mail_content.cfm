<cfsetting showdebugoutput="no">
<cfparam name="URL.folder" default="Gelen Kutusu">
<cfparam name="URL.mail_id" default="">
<cfparam name="URL.i" default="0">

<cfset URL.folder = URLDecode(URL.folder)>
<cfset URL.mail_id = URLDecode(URL.mail_id)>

<cfinclude template="exchange_conn.cfm">

<cfoutput>
	<cfexchangemail action="get" folder="#URL.folder#" name="mail_content" connection="wrk_exchange_connection">
	  <cfif not URL.mail_id is "">
		<cfexchangefilter name="uid" value="<#URL.mail_id#>">
	  </cfif>
	</cfexchangemail>
</cfoutput>

<cfset meetingData=evaluate("mail_content")>

<cfquery dbtype="query" name="theResponses">
	SELECT * FROM meetingData
</cfquery>

<cfif theResponses.recordcount gt 0>
  <cfoutput>
    <cfloop query="theResponses">
      <table width="100%" style="border:solid 1px silver" bgcolor="##dce9f5">
          <td><strong><cf_get_lang dictionary_id="49698.Kimden"></strong></td>
          <td>#FROMID#</td>
        </tr>
        <tr>
          <td><strong><cf_get_lang dictionary_id="57924.Kime"></strong></td>
          <td>#TOID#</td>
        </tr>
        <tr>
          <td><strong><cf_get_lang dictionary_id="57556.Bilgi"></strong></td>
          <td>#CC#</td>
        </tr>
        <tr>
          <td><strong><cf_get_lang dictionary_id="57742.Tarih"></strong></td>
          <td>#DateFormat(TIMERECEIVED,"dd mmm yyyy")# #TimeFormat(TIMERECEIVED,"HH:mm:ss")#</td>
        </tr>
        <tr>
          <td><strong><cf_get_lang dictionary_id="57480.Konu"></strong></td>
		  <td>#SUBJECT#</td>
        </tr>
        <tr>
          <td><strong><cf_get_lang dictionary_id="51093.Ekler"></strong></td>
		  <td>
		    <cfexchangemail action="getAttachments" connection="wrk_exchange_connection" folder="#URL.folder#" uid="<#URL.mail_id#>"  
            name="attachData" generateUniqueFilenames="no" attachmentPath="#ExpandPath( "./" )#documents/temp/"> 
		
			<cfloop query="attachData"> 
                <a href="http:\\<cfoutput>#cgi.HTTP_HOST#</cfoutput>\index.cfm?fuseaction=correspondence.emptypopup_exchange_download_attachment&mail_id=#URLEncodedFormat(URL.mail_id)#&folder=#URLEncodedFormat(URL.folder)#&file=#URLEncodedFormat(attachmentFilename)#&mimetype=#URLEncodedFormat(mimetype)#" target="_blank" style="color:##0033FF">#attachmentFilename#</a> &nbsp;&nbsp; 
            </cfloop> 			
		  </td>
        </tr>
      </table>
	  <br />
      <div id="msg" style="width:100%;height:380px;overflow:auto">#HTMLMESSAGE#</div>
	  
	<cfset mail = StructNew()>
	<cfset mail.ISREAD = true>
	
	<cfexchangemail action="set" uid="<#URL.mail_id#>" message = "#mail#" folder = "<#URL.folder#>" connection = "wrk_exchange_connection">
	
		<cfoutput>
		<script language="javascript">
			document.getElementById('tr_#URL.mail_id#').childNodes[0].style.fontWeight='';
			document.getElementById('tr_#URL.mail_id#_img_isread').innerHTML='<img src="/images/exchange/read.gif">';
		</script>
	</cfoutput>
    </cfloop>
  </cfoutput>
</cfif>
<cfexchangeConnection action="close" connection="wrk_exchange_connection">




<cfif isdefined("form.dosya")>
  <cffile action="UPLOAD" 
		nameconflict="OVERWRITE" 
		filefield="dosya" 
		destination="#upload_folder##ReplaceNoCase(attributes.folder, "/documents/", "")##dir_seperator#">
 	<!---Script dosyalarını engelle  02092010 FA-ND --->
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
	<cfif listfind(blackList,assetTypeName,',')>
		<cffile action="delete" file="#upload_folder##ReplaceNoCase(attributes.folder, "/documents/", "")##dir_seperator#">
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='47804.\php\,\jsp\,\asp\,\cfm\,\cfml\ Formatlarında Dosya Girmeyiniz!!'>");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<script type="text/javascript">
		var eb = window.opener.document.all.editbar;
		<cfoutput>
		eb._editor.WriteFlash("#employee_domain#","#form.boy#","#form.genis#","#ReplaceNoCase(attributes.folder, "/documents/", "")#/#cffile.ServerFile#");
		</cfoutput>
		window.close();
	</script>
  <cfabort>
</cfif>

<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
  <tr class="color-border">
    <td valign="middle">
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-list" valign="middle">
          <td height="35">
            <table width="98%" align="center">
              <tr>
                <td valign="bottom" class="headbold"><cf_get_lang dictionary_id='57517.Flash Ekle'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="top">
          <td>
            <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
              <tr>
                <td colspan="2"> <br/>
                  <table>
                    <form name="flash" method="post" action="" enctype="multipart/form-data">
                      <tr>
                        <td><cf_get_lang dictionary_id='32782.Genişlik x Yükseklik'></td>
                        <td> <input type="text" style="width:70px;" name="boy" id="boy">
                          x                          
                          <input type="text" style="width:70px;" name="genis" id="genis"> 
						  &nbsp;&nbsp;<cf_get_lang dictionary_id='32783.pixel'>
                        </td>
                      </tr>
					   <tr>
                        <td width="110"><cf_get_lang dictionary_id='57691.Dosya'> </td>
                        <td>
                          <input type="File" name="dosya" style="width:200px;">
                        </td>
                      </tr>
                      <tr>
                        <td height="35" colspan="2" style="text-align:right;">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57582.Ekle'></cfsavecontent>
					 	<cf_workcube_buttons is_upd='0' insert_info='#message#'>
                        </td>
                      </tr>
                    </form>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

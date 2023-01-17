<cfset xfa.add = "objects.popup_add_image">
<cfinclude template="../display/imageprocess/imcontrol.cfm">
<!--- 
Kullanım : 
	attributes.folder : resmin yükleneceği adres
 --->
<script type="text/javascript">
	<cfoutput>
	function go(){		   
	
	   document.gonderform.action = "#request.self#?fuseaction=#xfa.add#&rd=yes";
	   return kontrol();

	}
    </cfoutput>

	function kontrol()
	{	
		
		var obj =  document.gonderform.public_image.value;
		if ((obj == "") || !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png'))){
										alert("<cf_get_lang dictionary_id='32503.Lütfen Bir Resim Dosyası gif jpg veya png giriniz '>");        
										return false;
		}
		document.getElementById('upload_status').style.display = '';
		return true;
	}
	
	function take_image(filepath,filename){	
		opener.html_edit.textEdit.document.body.innerHTML += '<img src="' + filepath + filename + '" border="0"><br/>';
		opener.html_edit.textEdit.focus();    
		window.close();
	}
	
</script>
<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">        
		<tr class="color-list"> 
          <td height="35">
            <table width="98%" align="center">
              <tr> 
                <td valign="bottom" class="headbold" width="50%"><cf_get_lang dictionary_id='32629.İmaj Ekle'></td>
				<td id="upload_status" align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b><cf_get_lang dictionary_id='32632.İmaj Upload Ediliyor'>!!</b></font></td>			
				<cfif attributes.module eq 'content'><cfset attributes.module = 'content3'></cfif>
				<td style="text-align:right;"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_get_Archive&module=#attributes.module#&id=1</cfoutput>','list');"><img src="/images/devfolder.gif"  border="0" title="<cf_get_lang dictionary_id='32629.İmaj Ekle'>"></a></td>
              </tr>
            </table>			
		  </td>
        </tr>
        <tr class="color-row">
          <td valign="top"> <br/>
            <table>
              <cfform method="POST" enctype="multipart/form-data" name="gonderform" action="#request.self#?fuseaction=#xfa.add#">
                <input type="Hidden" name="folder" id="folder" value="<cfoutput>#attributes.folder#</cfoutput>">
                <tr>
                  <td width="100"><cf_get_lang dictionary_id='29762.İmaj'></td>
                  <td><input name="public_image" id="public_image" type="FILE" style="width:200px;">
                  </td>
                </tr>
                <tr>
                  <td><cf_get_lang dictionary_id='32631.Boyut (en x boy)'></td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='32391.Boyut Girmelisiniz !'></cfsavecontent>
					<cfinput type="text" style="width:95px;" name="genis" value="" validate="integer" message="#message#">
                    x
                    <cfinput type="text" style="width:95px;" name="boy" value="" validate="integer" message="#message#">
                  </td>
                </tr>
                <cfset session.resim=3>
                <cfset session.imPath = "#ExpandPath(attributes.folder)#">
                <cfset session.module = "#attributes.module#">
                <tr height="35">
					<td></td>
                  	<td><cf_workcube_buttons is_upd='0'>
                    <!--- <input type="Submit"  value="Resmi Düzenle" onclick="javascript:return go()"> --->
                  </td>
                </tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
	document.getElementById('upload_status').style.display = 'none';
</script>

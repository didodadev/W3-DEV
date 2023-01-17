<cfsetting showdebugoutput="no">
<style>
	body{
		font-family:calibri;
		background-color:#c3daf9;
		font-size:8pt;
	}
	
	.inpt{
		border:solid 1px silver;
		font-size:9pt;
		background-color:white;
		height:20px;
	}
	
	.baslik{
		background-color:#2557ad;
		font-size:9pt;
		color:white;
	}
</style>


<cfparam name="FORM.islem" default="">
<cfparam name="FORM.fileName" default="">

<form action="http://<cfoutput>#cgi.HTTP_HOST#</cfoutput>/index.cfm?fuseaction=correspondence.emptypopup_exchange_upd_attachment_frm" method="post" enctype="multipart/form-data">
  <input type="hidden" name="islem" id="islem" value="upload" />
  <table>
    <tr>
      <td colspan="2" class="baslik"><cf_get_lang dictionary_id="30465.Eklenecek Bir Dosya Seç">: </td>
    </tr>
    <tr>
      <td width="400" height="26"><input type="file" style="width:100%" name="file" class="inpt"/></td>
      <td width="42"><input type="submit" value="Ekle" class="inpt" /></td>
    </tr>
  </table>
</form>
<cfset nameList = "">

<cfif FORM.islem is "upload">
	<cfif not FORM.file is "">
	  <cfset mail_folder = #ExpandPath( "./" )# & 'documents\temp\#session.mailbox_username_folder#\'>		 
	  <cfif not DirectoryExists('#mail_folder#')>
	  	 <cfdirectory directory= "#mail_folder#" action="create">
	  </cfif>
	  
	  
	  <cffile action="upload" filefield="file" destination="#ExpandPath( "./" )#documents\temp\#session.mailbox_username_folder#" nameconflict="makeunique"/>	
	  <cfset fileName = "#cffile.ClientFileName#.#cffile.ClientFileExt#">
	  <cfset renamedfileName = Replace(fileName,',','_','all')>
	  <cffile action = "rename" source = "#ExpandPath( "./" )#documents\temp\#session.mailbox_username_folder#\#fileName#" destination = "#ExpandPath( "./" )#documents/temp/#session.mailbox_username_folder#\#renamedfileName#" attributes="normal"> 
	</cfif>
</cfif>

<cfif FORM.islem is "kaldir">	
	<cfloop list="#FORM.fileName#" index="ind">	
		<cffile action="delete" file="#ExpandPath( "./" )#documents\temp\#session.mailbox_username_folder#\#ind#"/>
	  </cfloop>
</cfif>

<cfdirectory action="LIST" directory="#ExpandPath( "./" )#documents\temp\#session.mailbox_username_folder#" recurse="false" name="qDirectoryList"/>

<form action="http://<cfoutput>#cgi.HTTP_HOST#</cfoutput>/index.cfm?fuseaction=correspondence.emptypopup_exchange_upd_attachment_frm" method="post">
	<input type="hidden" name="islem" id="islem" value="kaldir" class="inpt" />
  <table width="100%">
    <tr>
      <td colspan="3" class="baslik"><cf_get_lang dictionary_id="30464.Geçerli Dosya Ekleri"> : </td>
    </tr>
	<tr>
		<td width="95%">
			<table style="background-color:white; font-size:9pt; font-family:calibri" width="100%">
		  <cfoutput query="qDirectoryList">
			<cfset nameList = #ListAppend(nameList,qDirectoryList.name)#>
			<tr>
			<td width="15"><input type="checkbox" name="fileName" id="fileName" value="#qDirectoryList.name#" /> </td>
			<td align="left">
				#qDirectoryList.name#</a>
			</td>
			</td>
			</tr>
		  </cfoutput>
		  </table>	
	  </td>
	  <td></td>
	  <td width="5%" valign="top"><input type="submit" value="Kaldır" class="inpt"/></td>
	</tr>
  </table>
</form>
	
<input type="hidden" value="<cfoutput>#nameList#</cfoutput>" id="nameList">
<input type="button" value="Ekleri Uygula" onclick="uygula()" class="inpt"/>

<script language="javascript">
	function uygula(){
		window.opener.document.getElementById('uploads_name').value = '';
		if (document.getElementById('nameList').value!=''){
			window.opener.document.getElementById('uploads_name').value = document.getElementById('nameList').value;
			alert("<cf_get_lang dictionary_id='30461.Ekleriniz Uygulandı'>");
		}
		
		window.opener.focus();
		self.close();
	}
</script>

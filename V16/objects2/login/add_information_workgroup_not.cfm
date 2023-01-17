<cfsetting showdebugoutput="no">
<cf_box id="my_add_notes">
<cfform name="add_notes#workgroup_id#" action="#request.self#?fuseaction=objects2.emptypopup_add_information_workgroup">
	<table>
		<input type="hidden" name="workgroup_id" id="workgroup_id" value="<cfoutput>#workgroup_id#</cfoutput>">
	   <tr>
		  <td><cf_get_lang no ='1289.Not Bırakan'></td>
		  <td>
		 <cfsavecontent variable="alert"><cf_get_lang no ='1290.Lütfen İsminizi Giriniz'></cfsavecontent>
		  <cfif isdefined("session.ww.userid") and len(session.ww.userid)>
			<cfinput type="text" value="#session.ww.name# #session.ww.surname#" name="member" style="width:150;" maxlength="200" required="yes" message="#alert#">
		  <cfelse>
			<cfinput type="text" value="" name="member" style="width:150;" maxlength="200" required="yes" message="#alert#">
		  </cfif>
		  </td>
		</tr>
		<tr>
		  <td><cf_get_lang_main no ='87.Telefon'></td>
		  <td><input type="text" name="tel" id="tel" style="width:150px;" maxlength="15"></td>
		</tr>
		<tr>
		  <td>E-Mail</td>
		  <td><input type="text" name="email" id="email" style="width:150px;"></td>
		</tr>
		<tr>
		  <td valign="top"><cf_get_lang_main no ='217.Açıklama'></td>
		  <td><textarea style="width:150;height:70px;" name="workgroup_detail" id="workgroup_detail"></textarea></td>
		</tr>
		<tr>
		  <td></td>
		  <td><input type="button" value="<cf_get_lang_main no='1331.Gonder'>" onClick="workgroup_notes<cfoutput>#workgroup_id#</cfoutput>();"></td>
		</tr>
	</table>
</cfform>
</cf_box>
<script type="text/javascript">
	function workgroup_notes<cfoutput>#workgroup_id#</cfoutput>()
	{
		x = (1000 - document.add_notes<cfoutput>#workgroup_id#</cfoutput>.workgroup_detail.value.length);
		if ( x < 0 )
		{ 
			alert ("<cf_get_lang_main no ='217.Açıklama '>"+ ((-1) * x) +" <cf_get_lang_main no='1741.Karakter Uzun'> !");
			return false;
		}
		if(document.add_notes<cfoutput>#workgroup_id#</cfoutput>.workgroup_detail.value=="")
		{
			alert("<cf_get_lang no ='1292.Açıklama Girmelisiniz'> !");
			return false;
		}
		
		var aaa = document.add_notes<cfoutput>#workgroup_id#</cfoutput>.email.value;
		if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)))
			{ 
				alert("<cf_get_lang_main no='1072.Geçerli Bir Mail Adresi Giriniz'> !");
				return false;
			}
		AjaxFormSubmit('add_notes<cfoutput>#workgroup_id#</cfoutput>','SHOW_UPD_MESSAGE','1','Gönderiliyor..','Talebiniz Gönderildi.');
		document.add_notes<cfoutput>#workgroup_id#</cfoutput>.reset();
		document.getElementById('my_workgroup<cfoutput>#WORKGROUP_ID#</cfoutput>').style.display='none';
	}
</script>


<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border">
<tr class="color-list" valign="middle">
  <td height="35">
	<table width="98%" align="center">
	  <tr>
		<td valign="bottom" class="headbold"><cf_get_lang dictionary_id='57465.Not Ekle'></td>
	  </tr>
	</table>
  </td>
</tr>
<tr class="color-row" valign="top">
  <td colspan="2">
  <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
	<cfform name="add_note" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_all_note">
	  <input type="Hidden" name="action_section" id="action_section" value="<cfoutput>#attributes.action#</cfoutput>">
	  <input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
	  <input type="Hidden" name="action_id_2" id="action_id_2" value="<cfif isdefined("attributes.action_id_2")><cfoutput>#attributes.action_id_2#</cfoutput></cfif>">
	  <input type="Hidden" name="action_type" id="action_type" value="<cfoutput>#attributes.action_type#</cfoutput>">					  					  					  
	  <tr>
		<td>&nbsp;</td>
		<td>
			<input type="checkbox" value="1" name="is_special" id="is_special-is" <cfif isdefined('attributes.is_special') and attributes.is_special eq 1>checked</cfif>> <label for="is_special-is"><cf_get_lang_main no='567.�zel Not'></label> 
			<input type="checkbox" value="1" name="is_warning" id="is_warning-iw" <cfif isdefined('attributes.is_warning') and attributes.is_special eq 1>checked</cfif>> <label for="is_warning-iw"><cf_get_lang_main no='13.Uyari Notu'></label>
		</td>
	  </tr>
	  <tr>
		<td width="75"><cf_get_lang dictionary_id='57480.Baslik'>*</td>
		<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Baslik girmelisiniz'></cfsavecontent>
		  <cfinput type="text" style="width:250px;" name="note_head" required="yes" message="#message#" maxlength="75">
		</td>
	  </tr>
	  <tr>
		<td valign="top"><cf_get_lang dictionary_id='57467.Not'></td>
		<td>
		  <textarea name="note_body" id="note_body" style="width:250px; height:100px;" rows="5"></textarea>
		</td>
	  </tr>
	  <tr height="35">
		<td>&nbsp;</td>
		<td>
		 <cf_workcube_buttons is_upd='0' > 
		</td>
	  </tr>
	</cfform>
  </table>
  </td>
</tr>
</table><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>
</body>
</html>


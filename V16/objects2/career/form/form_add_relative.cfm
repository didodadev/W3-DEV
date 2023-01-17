<cfif not isdefined("session.cp.userid")>
	<cflocation url="#request.self#?fuseaction=objects2.kariyer_login" addtoken="no">
</cfif>
<!---<cfinclude template="../query/get_edu_level.cfm">--->
<cfform name="add_relative" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_relative">
<table border="0" align="center" cellspacing="0" class="ik1" style="width:100%">		
	<tr class="ik-header" style="height:30px;">
		<td class="form-title"><cf_get_lang no='793.Yakın Ekle'></td>
		<td>&nbsp;</td>
	</tr>
	<tr style="height:22px;">
		<td><cf_get_lang_main no='219.Ad'></td>
		<td><cfsavecontent variable="message"><cf_get_lang no='219.Ad Giriniz!'></cfsavecontent>
			<cfinput type="text" name="name_relative" id="name_relative" value="" maxlength="50" style="width:150px;" required="yes" message="#message#!"> *
		</td>
	</tr>
	<tr style="height:22px;">
		<td><cf_get_lang_main no='1314.Soyad'></td>
		<td><cfsavecontent variable="message"><cf_get_lang no='237.Soyad Giriniz'></cfsavecontent>
			<cfinput type="text" name="surname_relative" id="surname_relative" value="" maxlength="50" style="width:150px;" required="yes" message="#message#!"> *
		</td>
	</tr>
	<tr>
		<td><cf_get_lang no='794.Yakınlık Derecesi'></td>
		<td>
			<select name="relative_level" id="relative_level" style="width:150px;">
				<option value="1"><cf_get_lang no='795.Babası'></option>
				<option value="2"><cf_get_lang no='796.Annesi'></option>
				<option value="3"><cf_get_lang no='797.Eşi'></option>
				<option value="4"><cf_get_lang no='798.Oğlu'></option>
				<option value="5"><cf_get_lang no='799.Kızı'></option>
				<option value="6"><cf_get_lang no='800.Kardeşi'></option>
			</select> * 
		</td>
	</tr>
	<tr>
		<td><cf_get_lang_main no='1315.Dogum Tarihi'></td>
		<td><cfsavecontent variable="message"><cf_get_lang no='299.Doğum Tarihini Giriniz'>!</cfsavecontent>	
			<cfinput type="text" name="birth_date_relative" id="birth_date_relative" value="" validate="eurodate" maxlength="10" style="width:150px;" message="#message#">
			<cf_wrk_date_image date_field="birth_date_relative">
		</td>
	</tr>
	<tr>
		<td><cf_get_lang_main no='378.Dogum Yeri'></td>
		<td><input type="text" name="birth_place_relative" id="birth_place_relative" value="" style="width:150px;" maxlength="50"></td>
	</tr>
	<tr>
		<td><cf_get_lang no='212.Meslek'></td>
		<td><input type="text" name="job_relative" id="job_relative" value="" style="width:150px;" maxlength="30"></td>
	</tr>
	<tr>
		<td><cf_get_lang_main no='162.Şirket'></td>
		<td><input type="text" name="company_relative" id="company_relative" value="" style="width:150px;" maxlength="50"></td>
	</tr>
	<tr>
		<td><cf_get_lang_main no='161.Görev'></td>
		<td><input type="text" name="job_position_relative" id="job_position_relative" value="" style="width:150px;" maxlength="30"></td>
	</tr>
	<tr>
		<td colspan="4" style="text-align:right;"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
	</tr>
</table>
</cfform>

<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById('relative_level').value.length==0)
		{
			alert("<cf_get_lang no='801.Yakınlık Derecesini Girmelisiniz'>!");
			document.getElementById('relative_level').focus();
			return false;
		}
		return true;
	}
</script>

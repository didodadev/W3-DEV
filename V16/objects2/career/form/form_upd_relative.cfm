<cfif not isdefined('session.cp.userid')>
	<cflocation url="#request.self#?fuseaction=objects2.form_upd_cv_8" addtoken="no">
</cfif>
<!---<cfinclude template="../query/get_edu_level.cfm">--->
<cfquery name="GET_RELATIVES" datasource="#DSN#">
	SELECT NAME, SURNAME, RELATIVE_LEVEL, BIRTH_DATE, BIRTH_PLACE, JOB, COMPANY, JOB_POSITION FROM EMPLOYEES_RELATIVES WHERE EMPAPP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#"> AND RELATIVE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.relative_id#">
</cfquery>

<cfform name="upd_relative" method="post" action="#request.self#?fuseaction=objects2.emptypopup_upd_relative">
<input type="hidden" name="relative_id" id="relative_id" value="<cfoutput>#attributes.relative_id#</cfoutput>">
<table border="0" align="center" cellspacing="0" class="ik1" style="width:100%">
	<tr class="ik-header" style="height:30px;">
		<td class="form-title"><cf_get_lang no ='1189.Yakın Güncelle'> </td>
		<td>&nbsp;</td>
	</tr>
	<tr style="height:22px">
		<td><cf_get_lang_main no='219.Ad'></td>
		<cfsavecontent variable="alert"><cf_get_lang no ='219.İsim Giriniz'></cfsavecontent>
		<td><cfinput type="text" name="name_relative" id="name_relative" value="#get_relatives.name#" maxlength="50" style="width:150px;" required="yes" message="#alert#"> *</td>
	</tr>
	<tr style="height:22px">
		<td><cf_get_lang_main no='1314.Soyad'></td>
		<cfsavecontent variable="alert"><cf_get_lang no ='237.Soyad Giriniz'></cfsavecontent>
		<td><cfinput type="text" name="surname_relative" id="surname_relative" value="#get_relatives.surname#" maxlength="50" style="width:150px;" required="yes" message="#alert#"> *</td>
	</tr>
	<tr>
		<td><cf_get_lang no='794.Yakınlık Derecesi'></td>
		<td><select name="relative_level" id="relative_level" style="width:150px;">
				<option value="1" <cfif get_relatives.relative_level eq 1>selected</cfif>><cf_get_lang no ='795.Babası'></option>
				<option value="2" <cfif get_relatives.relative_level eq 2>selected</cfif>><cf_get_lang no ='796.Annesi'></option>
				<option value="3" <cfif get_relatives.relative_level eq 3>selected</cfif>><cf_get_lang no ='797.Eşi'></option>
				<option value="4" <cfif get_relatives.relative_level eq 4>selected</cfif>><cf_get_lang no ='798.Oğlu'></option>
				<option value="5" <cfif get_relatives.relative_level eq 5>selected</cfif>><cf_get_lang no ='799.Kızı'></option>
				<option value="6" <cfif get_relatives.relative_level eq 6>selected</cfif>><cf_get_lang no ='800.Kardeşi'></option>
			</select> *
		</td>
	</tr>
	<tr>
		<td><cf_get_lang_main no='1315.Dogum Tarihi'></td>
		<cfsavecontent variable="alert"><cf_get_lang no ='299.Doğum Tarihini Giriniz'></cfsavecontent>
		<td><cfinput type="text" name="birth_date_relative" id="birth_date_relative" value="#dateformat(get_relatives.birth_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:150px;" message="#alert#">
			<cf_wrk_date_image date_field="birth_date_relative">
		</td>
	</tr>
	<tr>
		<td><cf_get_lang_main no='378.Dogum Yeri'></td>
		<td><input type="text" name="birth_place_relative" id="birth_place_relative" value="<cfoutput>#get_relatives.birth_place#</cfoutput>" style="width:150px;" maxlength="50"></td>
	</tr>
	<tr>
		<td><cf_get_lang no='212.Meslek'></td>
		<td><input type="text" name="job_relative" id="job_relative" value="<cfoutput>#get_relatives.job#</cfoutput>" style="width:150px;" maxlength="30"></td>
	</tr>
	<tr>
		<td><cf_get_lang_main no='162.Şirket'></td>
		<td><input type="text" name="company_relative" id="company_relative" value="<cfoutput>#get_relatives.company#</cfoutput>" style="width:150px;" maxlength="50"></td>
	</tr>
	<tr>
		<td><cf_get_lang_main no='161.Görev'></td>
		<td><input type="text" name="job_position_relative" id="job_position_relative" value="<cfoutput>#get_relatives.job_position#</cfoutput>" style="width:150px;" maxlength="30"></td>
	</tr>
	<tr>
		<td colspan="4" style="text-align:right;"><cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=objects2.emptypopup_del_relative&relative_id=#attributes.relative_id#'></td>
	</tr>
</table>
</cfform>

<script type="text/javascript">
	function kontrol()
	{
		var tarih_ = fix_date_value(document.getElementById('birth_date_relative').value);
		if(tarih_.substr(6,4) < 1900)
		{
			alert("<cf_get_lang no ='1173.Lütfen Doğum Tarihini Kontrol Ediniz'>!");
			return false;
		}
		if(document.getElementById('relative_level').value.length==0)
		{
			alert("<cf_get_lang no ='801.Yakınlık Derecesini Girmelisiniz'>!");
			document.getElementById('relative_level').focus();
			return false;
		}
		return true;
	}
</script>

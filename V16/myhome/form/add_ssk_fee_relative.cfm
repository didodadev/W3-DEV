<cfif isdefined("attributes.my_emp_id")>
	<cfquery name="GET_POSITION_DETAIL" datasource="#dsn#">
		SELECT
			UPPER_POSITION_CODE,
			UPPER_POSITION_CODE2
		FROM
			EMPLOYEE_POSITIONS
		WHERE
			EMPLOYEE_POSITIONS.EMPLOYEE_ID=#attributes.my_emp_id# 
	</cfquery>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31535.Çalışan Yakınına Vizite'></cfsavecontent>
<cf_popup_box title="#message#">
<cfform name="ssk_fee"  method="post" action="#request.self#?fuseaction=myhome.emptypopup_add_ssk_fee_relative">
	<table>
		<tr>
			<td><cf_get_lang dictionary_id='57576.Çalışan'>*</td>
			<td>
				<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.my_emp_id")><cfoutput>#attributes.my_emp_id#</cfoutput></cfif>"> 
				<input type="hidden" name="in_out_id" id="in_out_id" value="<cfif isdefined("attributes.inout_id")><cfoutput>#attributes.inout_id#</cfoutput></cfif>"> 
				<input type="text" name="emp_name" id="emp_name" style="width:150px;" value="<cfif isdefined("attributes.my_emp_id")><cfoutput>#get_emp_info(attributes.my_emp_id,0,0)#</cfoutput></cfif>" readonly> 
			</td>
			<td>
				<cfif not isdefined("attributes.my_emp_id")><a href="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=ssk_fee.in_out_id&field_emp_name=ssk_fee.emp_name&field_emp_id=ssk_fee.employee_id','list');"><img src="/images/plus_thin.gif"></a></cfif></td>
			</td>
		</tr>
		<tr>
			<td class="formbold" nowrap="nowrap"><cf_get_lang dictionary_id ='31536.Vizite Alacak Kişinin'> </td>
			<td style="text-align:right;"> 
				<a href="javascript://" onClick="javascript:if(ssk_fee.employee_id.value !=''){windowopen('<cfoutput>#request.self#?fuseaction=#fusebox.circuit#</cfoutput>.employee_relative_ssk&event=add&field_name=ssk_fee.ill_name&field_surname=ssk_fee.ill_surname&field_relative=ssk_fee.ill_relative&field_birth_date=ssk_fee.BIRTH_DATE&field_birth_place=ssk_fee.BIRTH_PLACE&field_tc_identy_no=ssk_fee.TC_IDENTY_NO&employee_id='+document.getElementById('employee_id').value,'list');}else {alert('Çalışan seçiniz');return false}"><img src="/images/plus_thin.gif"></a> 
			</td>
		</tr>
		<tr>
			<td width="100"><cf_get_lang dictionary_id='57631.Ad'> *</td>
			<td><input type="text" name="ill_name" id="ill_name" style="width:150px;" value=""></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='58726.Soyad'> *</td>
			<td><input type="text" name="ill_surname" id="ill_surname" style="width:150px;" value=""></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='57764.Cinsiyet'></td>
			<td>
				<input type="radio" name="sex" id="sex" value="1"checked><cf_get_lang dictionary_id='58959.Erkek'>
				<input type="radio" name="sex" id="sex" value="0"><cf_get_lang dictionary_id='58958.Kadın'>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id ='31537.Yakınlığı'> *</td>
			<td><input type="text" name="ill_relative" id="ill_relative" style="width:150px;" value=""></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='58727.Doğum Tarihi'> *</td>
			<td><cfsavecontent variable="message"><cf_get_lang dictionary_id ='31240.Doğum Tarihi Girmelisiniz'></cfsavecontent>
				<cfinput validate="#validate_style#" type="text" name="BIRTH_DATE" value="" style="width:150px;" required="yes" message="#message#">
				<cf_wrk_date_image date_field="BIRTH_DATE">
		</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='57790.Doğum Yeri'> *</td>
			<td><cfsavecontent variable="message"><cf_get_lang dictionary_id ='31324.Doğum Yeri Girmelisiniz'></cfsavecontent>
				<cfinput type="text" name="BIRTH_PLACE" style="width:150px;" value="" required="yes" message="#message#"></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='58025.TC Kimlik No'> *</td>
			<td><cfsavecontent variable="message"><cf_get_lang dictionary_id ='31325.TC Kimlik Numarası Girmelisiniz'></cfsavecontent>
				<cfinput type="text" name="TC_IDENTY_NO" style="width:150px;" onKeyUp="isNumber(this)" validate="integer" value="" required="yes" message="#message#" maxlength="11"></td>
		</tr>
		<tr>
		<td><cf_get_lang dictionary_id ='31464.Vizite Tarih'> *</td>
			<td><cfsavecontent variable="message"><cf_get_lang dictionary_id ='31543.Vizite Tarihi Girmelisiniz'></cfsavecontent>
				<cfinput validate="#validate_style#" type="text" name="DATE" value="" style="width:70px;" required="yes" message="#message#">&nbsp;
				<cf_wrk_date_image date_field="DATE"><cfoutput>
					<select name="HOUR" id="HOUR">
						<cfloop from="0" to="23" index="i">
							<option value="#i#" <cfif i eq 8>selected</cfif>>#i#:00</option>
						</cfloop>
					</select>
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id ='57500.Onay'>1</td>
			<td>
				<input type="hidden" name="validator_pos_code" id="validator_pos_code" value="<cfif isdefined("attributes.my_emp_id") and isdefined("get_position_detail.upper_position_code") and len(get_position_detail.upper_position_code)><cfoutput>#get_position_detail.upper_position_code#</cfoutput></cfif>">
				<input type="text" name="valid_name" id="valid_name" readonly="yes" value="<cfif isdefined("attributes.my_emp_id") and isdefined("get_position_detail.upper_position_code") and len(get_position_detail.upper_position_code)><cfoutput>#get_emp_info(get_position_detail.upper_position_code,1,0)#</cfoutput></cfif>" style="width:150px;">
				<cfif not(isdefined("attributes.my_emp_id") and isdefined("get_position_detail.upper_position_code") and len(get_position_detail.upper_position_code))><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=ssk_fee.validator_pos_code&field_name=ssk_fee.valid_name','list');return false"><img src="/images/plus_thin.gif"></a></cfif>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id ='57500.Onay'>2</td>
			<td>
				<input type="hidden" name="validator_pos_code2" id="validator_pos_code2" value="<cfif isdefined("attributes.my_emp_id") and isdefined("get_position_detail.upper_position_code2") and len(get_position_detail.upper_position_code2)><cfoutput>#get_position_detail.upper_position_code2#</cfoutput></cfif>">
				<input type="text" name="valid_name2" id="valid_name2" readonly="yes" value="<cfif isdefined("attributes.my_emp_id") and isdefined("get_position_detail.upper_position_code2") and len(get_position_detail.upper_position_code2)><cfoutput>#get_emp_info(get_position_detail.upper_position_code2,1,0)#</cfoutput></cfif>" style="width:150px;">
				<cfif not(isdefined("attributes.my_emp_id") and isdefined("get_position_detail.upper_position_code2") and len(get_position_detail.upper_position_code2))><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=ssk_fee.validator_pos_code2&field_name=ssk_fee.valid_name2','list');return false"><img src="/images/plus_thin.gif"></a></cfif>
			</td>
		</tr>
	</table>
	<cf_popup_box_footer>
		<cf_workcube_buttons is_upd='0' type_format="1" add_function='kontrol()'>
	</cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script type="text/javascript">
function kontrol()
{
	if (ssk_fee.emp_name.value == "")
	{
		alert("<cf_get_lang dictionary_id='29498.Çalışan Girmelisiniz'>");
		return false;
	}
	if (ssk_fee.ill_name.value == "")
	{
		alert("<cf_get_lang dictionary_id ='31540.Vizite Alacak Kişinin Adını Giriniz'>!");
		return false;
	}
	if (ssk_fee.ill_surname.value == "")
	{
		alert("<cf_get_lang dictionary_id ='31539.Vizite Alacak Kişinin Soyadını Giriniz'>!");
		return false;
	}
	if (ssk_fee.ill_relative.value == "")
	{
		alert("<cf_get_lang dictionary_id ='31541.Vizite Alacak Kişinin Yakınlığını Giriniz'>!");
		return false;
	}
	if (ssk_fee.TC_IDENTY_NO.value == "")
	{
		alert("<cf_get_lang dictionary_id ='31542.Vizite Alacak Kişinin TC Kimlik Numarasını Giriniz'>!");
		return false;
	}
	return true;
}
</script>
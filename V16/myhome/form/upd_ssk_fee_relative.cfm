<cfif fusebox.circuit eq 'myhome'>
    <cfset attributes.fee_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.fee_id,accountKey:session.ep.userid)>
</cfif>
<cfquery name="GET_FEE_RELATIVE" datasource="#dsn#">
	SELECT
		ES.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
 	FROM
		EMPLOYEES_SSK_FEE_RELATIVE ES,
		EMPLOYEES E
	WHERE 
		E.EMPLOYEE_ID = ES.EMPLOYEE_ID
		AND ES.FEE_ID = #attributes.FEE_ID#
</cfquery>
<cfif len(GET_FEE_RELATIVE.BRANCH_ID)>
	<cfquery name="get_ssk_offices" datasource="#dsn#">
		SELECT
			BRANCH_NAME,		
			SSK_OFFICE,
			SSK_NO
		FROM
			BRANCH
		WHERE
			BRANCH_ID = #GET_FEE_RELATIVE.BRANCH_ID#
	</cfquery>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31535.Çalışan Yakınına Vizite'></cfsavecontent>
<cf_popup_box title="#message#">
 <cfform name="ssk_fee"  method="post" action="#request.self#?fuseaction=myhome.emptypopup_upd_ssk_fee_relative">
	<cfoutput query="get_fee_relative">
		<table>
		<input type="hidden" name="FEE_ID" id="FEE_ID" value="#FEE_ID#">
			<tr>
				<td width="100"><cf_get_lang dictionary_id='57576.Çalışan'> *</td>
				<td>
					<input type="hidden" name="employee_id"  id="employee_id" value="#employee_id#">
					<input type="hidden" name="in_out_id" id="in_out_id" value="#in_out_id#">
					<input type="text" name="emp_name" id="emp_name" style="width:150px;" value="#employee_name# #employee_surname#" readonly>
					<a href="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=ssk_fee.in_out_id&field_emp_name=ssk_fee.emp_name&field_emp_id=ssk_fee.employee_id','list');"><img src="/images/plus_thin.gif" border="0"></a>
				</td>
			</tr>
			<cfif len(GET_FEE_RELATIVE.BRANCH_ID)>
			<tr>
				<td><cf_get_lang dictionary_id ='57453.Şube'></td>
				<td>#get_ssk_offices.BRANCH_NAME#-#get_ssk_offices.SSK_OFFICE#-#get_ssk_offices.SSK_NO#</td>
			</tr>
			</cfif>
			<tr>
				<td class="formbold" nowrap="nowrap"><cf_get_lang dictionary_id ='31536.Vizite Alacak Kişinin'></td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.employee_relative_ssk&event=add&field_name=ssk_fee.ill_name&field_surname=ssk_fee.ill_surname&field_relative=ssk_fee.ill_relative&field_birth_date=ssk_fee.BIRTH_DATE&field_birth_place=ssk_fee.BIRTH_PLACE&field_tc_identy_no=ssk_fee.TC_IDENTY_NO&employee_id='+document.getElementById('employee_id').value,'list');return false"><img src="/images/plus_thin.gif" ></a> </td>
			</tr>
			<tr>
				<td width="100"><cf_get_lang dictionary_id='57631.Ad'>*</td>
				<td><input type="text" name="ill_name" id="ill_name" style="width:150px;"  value="#ILL_NAME#">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='58726.Soyad'>*</td>
				<td><input type="text" name="ill_surname" id="ill_surname" style="width:150px;"  value="#ILL_SURNAME#">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57764.Cinsiyet'></td>
				<td>
					<input type="radio" name="sex" id="sex" value="1" <cfif get_fee_relative.sex eq 1>checked</cfif>>
					<cf_get_lang dictionary_id='58959.Erkek'>
					<input type="radio" name="sex" id="sex" value="0" <cfif get_fee_relative.sex eq 0>checked</cfif>>
					<cf_get_lang dictionary_id='58958.Kadın '>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='31537.Yakınlığı'>*</td>
				<td><input type="text" name="ill_relative" id="ill_relative" style="width:150px;"  value="#ILL_RELATIVE#">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='58727.Doğum Tarihi'>*</td>
				<td>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31240.Doğum Tarihi Girmelisiniz '>!</cfsavecontent>
				<cfinput validate="#validate_style#" type="text" name="BIRTH_DATE" value="#DateFormat(BIRTH_DATE,dateformat_style)#" style="width:70px;" required="yes" message="#message#">
				<cf_wrk_date_image date_field="BIRTH_DATE"></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57790.Doğum Yeri'>*</td>
				<td>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31324.Doğum Yeri Girmelisiniz'> !</cfsavecontent>
				<cfinput type="text" name="BIRTH_PLACE" style="width:150px;" value="#BIRTH_PLACE#" required="yes" message="#message#">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='58025.TC Kimlik No'> *</td>
				<td>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31325.TC Kimlik Numarası Girmelisiniz'>!</cfsavecontent>
				<cfinput type="text" name="TC_IDENTY_NO" style="width:150px;" value="#TC_IDENTY_NO#" validate="integer" required="yes" message="#message#" maxlength="11">
				</td>
			</tr>
			<tr>
			  <td><cf_get_lang dictionary_id ='31464.Vizite Tarih'> *</td>
			  <td>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31543.Vizite Tarihi Girmelisiniz'>!</cfsavecontent>
				<cfinput validate="#validate_style#" type="text" name="DATE" value="#dateformat(FEE_DATE,dateformat_style)#" style="width:70px;" required="yes" message="#message#">
				<cf_wrk_date_image date_field="DATE"><cfoutput>
				  <select name="HOUR" id="HOUR">
					<cfloop from="0" to="23" index="i">
					  <option value="#i#" <cfif i eq FEE_HOUR>selected</cfif>>#i#:00</option>
					</cfloop>
				  </select>
				</cfoutput> </td>
			</tr>
			<tr height="20"> 
				<td  class="txtbold"><cf_get_lang dictionary_id ='57500.Onay'>1</td>
				<td> 
				  <cfif valid_1 EQ 1>
					<cf_get_lang dictionary_id='58699.Onaylandı'> !
					<cfoutput>#get_emp_info(VALID_EMP_1,0,0)# (#dateformat(date_add('h',session.ep.time_zone,valid_date_1),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,valid_date_1),timeformat_style)#)</cfoutput>
				  <cfelseif valid_1 EQ 0>
					<cf_get_lang dictionary_id='57617.Reddedildi'> !
					<cfoutput>#get_emp_info(VALID_EMP_1,0,0)# (#dateformat(date_add('h',session.ep.time_zone,valid_date_1),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,valid_date_1),timeformat_style)#)</cfoutput>
				  <cfelse>
					<cfoutput>#get_emp_info(validator_pos_code_1,1,0)#</cfoutput>&nbsp;<cf_get_lang dictionary_id='57615.Onay Bekliyor'>!
				  </cfif>
				</td>
				</tr>
				<tr> 
					<td  class="txtbold"><cf_get_lang dictionary_id ='57500.Onay'>2</td>
					<td> 
					  <cfif valid_2 EQ 1>
						<cf_get_lang dictionary_id='58699.Onaylandı'> !
						<cfoutput>#get_emp_info(VALID_EMP_2,0,0)# (#dateformat(date_add('h',session.ep.time_zone,valid_date_2),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,valid_date_2),timeformat_style)#)</cfoutput>
					  <cfelseif valid_2 EQ 0>
						<cf_get_lang dictionary_id='57617.Reddedildi'> !
						<cfoutput>#get_emp_info(VALID_EMP_2,0,0)# (#dateformat(date_add('h',session.ep.time_zone,valid_date_2),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,valid_date_2),timeformat_style)#)</cfoutput>
					  <cfelse>
						<cfoutput>#get_emp_info(validator_pos_code_2,1,0)#</cfoutput>&nbsp;
						<cf_get_lang dictionary_id ='57615.Onay Bekliyor'>!
					  </cfif>
					</td>
				</tr>
			</table>
			<cf_popup_box_footer>
            	<cf_record_info query_name="GET_FEE_RELATIVE">
				<cfsavecontent variable="mesaj"><cf_get_lang dictionary_id ='31722.Kayıtlı Viziteyi Siliyorsunun Emin misiniz'></cfsavecontent>
				<cf_workcube_buttons is_upd='1' add_function='kontrol()'delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_ssk_fee_relative&fee_id=#attributes.fee_id#&head=#get_fee_relative.employee_name# #get_fee_relative.employee_surname#' delete_alert='#mesaj#'>
			</cf_popup_box_footer>
		</cfoutput> 
	</cfform>
</cf_popup_box>
<script type="text/javascript">
function kontrol()
{
	if (ssk_fee.emp_name.value == "")
		{
		alert("<cf_get_lang dictionary_id='29498.Çalışan Girmelisinz'>!");
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
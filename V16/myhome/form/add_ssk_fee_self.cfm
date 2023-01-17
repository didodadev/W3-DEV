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
<cfquery name="GET_ACCIDENT_SECURITIES" datasource="#dsn#">
	SELECT 
		*
	FROM 
		EMPLOYEE_ACCIDENT_SECURITY
	<cfif isDefined("attributes.ACCIDENT_SECURITY_ID")>
	WHERE
		ACCIDENT_SECURITY_ID = #attributes.ACCIDENT_SECURITY_ID#
	</cfif>
</cfquery>
<cfquery name="GET_WORK_ACCIDENT_TYPE" datasource="#dsn#">
	SELECT 
		*
	FROM 
		EMPLOYEE_WORK_ACCIDENT_TYPE
	<cfif isDefined("attributes.ACCIDENT_TYPE_ID")>
	WHERE
		ACCIDENT_TYPE_ID = #attributes.ACCIDENT_TYPE_ID#
	</cfif>
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31511.Çalışan Vizite Kağıdı'></cfsavecontent>
<cf_popup_box title="#message#">
 <cfform name="ssk_fee"  method="post" action="#request.self#?fuseaction=myhome.emptypopup_add_ssk_fee_self">
	<table>
		<tr> 
			<td width="110"><cf_get_lang dictionary_id='57576.Çalışan'> *</td>
			<td>
			<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.my_emp_id")><cfoutput>#attributes.my_emp_id#</cfoutput></cfif>"> 
			<input type="hidden" name="in_out_id" id="in_out_id" value="<cfif isdefined("attributes.inout_id")><cfoutput>#attributes.inout_id#</cfoutput></cfif>"> 
			<input type="text" name="emp_name" id="emp_name" style="width:165px;" value="<cfif isdefined("attributes.my_emp_id")><cfoutput>#get_emp_info(attributes.my_emp_id,0,0)#</cfoutput></cfif>" readonly> 
			<cfif not isdefined("attributes.my_emp_id")><a href="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=ssk_fee.in_out_id&field_emp_name=ssk_fee.emp_name&field_emp_id=ssk_fee.employee_id','list');"><img src="/images/plus_thin.gif"></a></cfif></td>
		</tr>
		<tr> 
			<td><cf_get_lang dictionary_id ='31464.Vizite Tarihi'> *</td>
			<td><cfsavecontent variable="message"><cf_get_lang dictionary_id ='31464.Vizite Tarihi'> </cfsavecontent>
			<cfinput validate="#validate_style#" type="text" name="DATE" value="" style="width:75px;" required="yes" message="#message#"> 
			<cf_wrk_date_image date_field="DATE"> 
			<cfoutput> 
			  <select name="HOUR" id="HOUR" style="width:65px">
				<cfloop from="0" to="23" index="i">
				  <option value="#i#" <cfif i eq 8>selected</cfif>> #i#:00</option>
				</cfloop>
			  </select>
			</cfoutput></td>
		</tr>
		<tr> 
			<td width="100"><cf_get_lang dictionary_id ='31463.Viziteye Çıkış'> *</td>
			<td><cfsavecontent variable="message"><cf_get_lang dictionary_id ='31525.Viziteye Çıkış Tarihi Giriniz'></cfsavecontent>
			<cfinput required="yes" message="#message#" validate="#validate_style#" type="text" name="DATEOUT" value="" style="width:75px;"> 
			<cf_wrk_date_image date_field="DATEOUT"> 
			<cfoutput> 
			  <select name="HOUROUT" id="HOUROUT" style="width:65px">
				<cfloop from="0" to="23" index="i">
				  <option value="#i#" <cfif i eq 8>selected</cfif>>#i#:00</option>
				</cfloop>
			  </select>
			</cfoutput></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id ='57629.Açıklama'></td>
			<td>
			<textarea name="detail" id="detail" style="width:165px;height:60px;"></textarea>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id ='57500.Onay'>1</td>
			<td>
			<input type="hidden" name="validator_pos_code" id="validator_pos_code" value="<cfif isdefined("attributes.my_emp_id") and isdefined("get_position_detail.upper_position_code") and len(get_position_detail.upper_position_code)><cfoutput>#get_position_detail.upper_position_code#</cfoutput></cfif>">
			<input type="text" name="valid_name" id="valid_name" readonly="yes" value="<cfif isdefined("attributes.my_emp_id") and isdefined("get_position_detail.upper_position_code") and len(get_position_detail.upper_position_code)><cfoutput>#get_emp_info(get_position_detail.upper_position_code,1,0)#</cfoutput></cfif>" style="width:165px;">
			<cfif not(isdefined("attributes.my_emp_id") and isdefined("get_position_detail.upper_position_code") and len(get_position_detail.upper_position_code))>
				<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=ssk_fee.validator_pos_code&field_name=ssk_fee.valid_name&select_list=1','list')"><img src="/images/plus_thin.gif"></a>
			</cfif>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id ='57500.Onay'>2</td>
			<td>
			<input type="hidden" name="validator_pos_code2" id="validator_pos_code2" value="<cfif isdefined("attributes.my_emp_id") and isdefined("get_position_detail.upper_position_code2") and len(get_position_detail.upper_position_code2)><cfoutput>#get_position_detail.upper_position_code2#</cfoutput></cfif>">
			<input type="text" name="valid_name2" id="valid_name2" readonly="yes" value="<cfif isdefined("attributes.my_emp_id") and isdefined("get_position_detail.upper_position_code2") and len(get_position_detail.upper_position_code2)><cfoutput>#get_emp_info(get_position_detail.upper_position_code2,1,0)#</cfoutput></cfif>" style="width:165px;">
			<cfif not(isdefined("attributes.my_emp_id") and isdefined("get_position_detail.upper_position_code2") and len(get_position_detail.upper_position_code2))>
				<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=ssk_fee.validator_pos_code2&field_name=ssk_fee.valid_name2&select_list=1','list')"><img src="/images/plus_thin.gif"></a>
			</cfif>
			</td>
		</tr>
		<tr> 
			<td><input name="workcheck" id="workcheck" type="checkbox" onClick="gizle_goster(work);"><cf_get_lang dictionary_id ='31515.İş Kazası ise'></td>
			<td><input name="illness" id="illness" type="checkbox" value=""><cf_get_lang dictionary_id ='31516.Meslek Hastalığı'></td>
		</tr>
	</table>
    <!--- İş Kazası --->
    <table id="work" style="display:none;" width="99%" align="center">
		<tr>
			<td width="105"><cf_get_lang dictionary_id ='31496.Olay Tar İşçi Sayısı'></td>
			<td><cfsavecontent variable="message"><cf_get_lang dictionary_id ='31571.İşçi Sayısı Sayısal Olmalıdır'></cfsavecontent>
			<cfinput type="text" name="total_emp" style="width:165px;"  value="" message="#message#" validate="integer"></td>
		</tr>
		<tr>
			<td colspan="2">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='31517.Sigortalının'></cfsavecontent>
				<cf_seperator id="sigortali" header="#message#">
				<table id="sigortali">
					<tr> 
						  <td width="100"><cf_get_lang dictionary_id ='31518.İşi ve Mahiyeti'></td>
						  <td><input type="text" name="emp_work" id="emp_work" style="width:165px;"  value=""></td>
					</tr>
				</table>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='31499.İş Kazasının'></cfsavecontent>
				<cf_seperator id="is_kazasinin" header="#message#">
				<table id="is_kazasinin">
					<tr>                            
						  <td width="100" valign="top"><cf_get_lang dictionary_id ='31572.Oluş Şekli'></td>
						  <td><textarea name="event" id="event" style="width:165px; height:60px;"></textarea></td>
					</tr>
					<tr>                               
						<td><cf_get_lang dictionary_id ='31509.Güvenlik Maddesi'></td>
						<td>
							<select name="accident_security_id" id="accident_security_id" style="width:165px;">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_accident_securities">
									<option value="#accident_security_id#">#accident_security#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>                               
						<td><cf_get_lang dictionary_id ='31513.Kaza Çeşidi'></td>
						  <td>
							<select name="accident_type_id" id="accident_type_id" style="width:165px;">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="GET_WORK_ACCIDENT_TYPE">
									<option value="#ACCIDENT_TYPE_ID#">#accident_type#</option>
								</cfoutput>
							  </select>
						  </td>
					</tr>
					<tr>                               
						<td width="100"><cf_get_lang dictionary_id='31519.Olay Yeri'></td>
						<td><input type="text" name="place" id="place" style="width:165px;"  value="" maxlength="50"></td>
					</tr>
					<tr> 
						<td width="100"><cf_get_lang dictionary_id='58463.Tarih ve Saat'></td>
						<td><cfinput validate="#validate_style#" type="text" name="DATEEVENT" value="" style="width:65px;"> 
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_calender</cfoutput>&alan=ssk_fee.DATEEVENT','date');"><img src="/images/calendar.gif"></a><cfoutput> 
						  <select name="HOUREVENT" id="HOUREVENT">
							<cfloop from="0" to="23" index="i">
							  <option value="#i#" <cfif i eq 8>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
							</cfloop>
						  </select>
							<select name="EVENT_MIN" id="EVENT_MIN">
							  <option value="00" selected>00</option>
							  <option value="05">05</option>
							  <option value="10">10</option>
							  <option value="15">15</option>
							  <option value="20">20</option>
							  <option value="25">25</option>
							  <option value="30">30</option>
							  <option value="35">35</option>
							  <option value="40">40</option>
							  <option value="45">45</option>
							  <option value="50">50</option>
							  <option value="55">55</option>
							</select>
						</cfoutput></td>
					</tr>
					<tr>
						<td width="100"><cf_get_lang dictionary_id ='31520.Olay Günündeki İşbaşı Saati'></td>
							  <td><input type="text" name="workstart" id="workstart" style="width:165px;"  value=""></td>
					</tr>
					</table>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='31522.Tanıkların Ad ve Soyadları'></cfsavecontent>
				<cf_seperator id="Taniklerin_adlari_ve_soyadlari" header="#message#">
				<table id="Taniklerin_adlari_ve_soyadlari">
					<tr> 
						<td width="100"><cf_get_lang dictionary_id='53325.Tanık'> -1 </td>
						<td>
							<input type="text" name="witness1" id="witness1" style="width:165px;"  value="">
							<input type="hidden" name="witness1_id" id="witness1_id" value="">
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=ssk_fee.witness1_id&field_emp_name=ssk_fee.witness1','list');return false"><img src="/images/plus_thin.gif"></a> 
						</td>
					</tr>
					<tr> 
						<td width="100"><cf_get_lang dictionary_id='53325.Tanık'> -2</td>
						 <td>
							<input type="text" name="witness2" id="witness2" style="width:165px;"  value="">
							<input type="hidden" name="witness2_id" id="witness2_id" value="">
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=ssk_fee.witness2_id&field_emp_name=ssk_fee.witness2','list');return false"><img src="/images/plus_thin.gif"></a>   
						</td>
					</tr>		
				</table>
			</td>
		</tr>
	</table>
	<!--- İş Kazası --->
	<cf_popup_box_footer><cf_workcube_buttons is_upd='0' typr_format='1' add_function='kontrol()'></cf_popup_box_footer>
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
		return true;
	}
</script>
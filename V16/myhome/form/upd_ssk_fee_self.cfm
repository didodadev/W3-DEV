<cfif fusebox.circuit eq 'myhome'>
    <cfset attributes.fee_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.fee_id,accountKey:session.ep.userid)>
    <cfset attributes.my_emp_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.my_emp_id,accountKey:session.ep.userid)>
    <cfset attributes.inout_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.inout_id,accountKey:session.ep.userid)>
</cfif>
<cfquery name="GET_FEE" datasource="#dsn#">
	SELECT
		ES.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
 	FROM
		EMPLOYEES_SSK_FEE ES,
		EMPLOYEES E
	WHERE 
		E.EMPLOYEE_ID = ES.EMPLOYEE_ID
		AND ES.FEE_ID = #attributes.FEE_ID#
</cfquery>
<cfif len(GET_FEE.BRANCH_ID)>
	<cfquery name="get_ssk_offices" datasource="#dsn#">
		SELECT
			BRANCH_NAME,		
			SSK_OFFICE,
			SSK_NO
		FROM
			BRANCH
		WHERE
			BRANCH_ID = #GET_FEE.BRANCH_ID#
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
<cfoutput query="GET_FEE">
<cfsavecontent variable="right">
<cfif accident is 1>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='54005.İşyeri Kaza Bildirim Formu'></cfsavecontent>
	<a hreF="javascript://" onClick="windowopen('#request.self#?fuseaction=.popup_ssk_fee_self_report_print&fee_id=#attributes.FEE_ID#','page');"><img src="/images/content_plus.gif" border="0" title="<cfoutput>#message#</cfoutput>"></a>
</cfif>
</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31511.Çalışan Vizite Kağıdı'></cfsavecontent>
<cf_popup_box title="#message#" right_images="#right#">
	<cfform name="ssk_fee"  method="post" action="#request.self#?fuseaction=myhome.emptypopup_upd_ssk_fee_self">
	<input type="hidden" name="FEE_ID" id="FEE_ID" value="#attributes.FEE_ID#">
		<table>
			<tr>
				<td width="110"><cf_get_lang dictionary_id='57576.Çalışan'> *</td>
				<td>
					<input type="hidden" name="employee_id" id="employee_id" value="#employee_id#">
					<input type="hidden" name="in_out_id" id="in_out_id" value="#in_out_id#">
					<input type="text" name="emp_name" id="emp_name" style="width:165px;" value="#employee_name# #employee_surname#" readonly>
					<cfif not isdefined("attributes.my_emp_id")><a href="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=ssk_fee.in_out_id&field_emp_name=ssk_fee.emp_name&field_emp_id=ssk_fee.employee_id','list');"><img src="/images/plus_thin.gif" border="0"></a></cfif>
				</td>
			</tr>
			<cfif len(GET_FEE.BRANCH_ID)>
				<tr>
					<td><cf_get_lang dictionary_id ='57453.Şube'></td>
					<td>#get_ssk_offices.BRANCH_NAME#-#get_ssk_offices.SSK_OFFICE#-#get_ssk_offices.SSK_NO#</td>
				</tr>
			</cfif>
			<tr>
				<td><cf_get_lang dictionary_id ='31464.Vizite Tarihi'> *</td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id ='31464.Vizite Tarihi'></cfsavecontent>
					<cfinput validate="#validate_style#" type="text" name="DATE" value="#dateformat(FEE_DATE,dateformat_style)#" style="width:75px;" required="yes" message="#message#">
					<cf_wrk_date_image date_field="DATE"><cfoutput>
					  <select name="HOUR" id="HOUR" style="width:65px">
						<cfloop from="0" to="23" index="i">
						  <option value="#i#" <cfif i eq FEE_HOUR>selected</cfif>>#i#:00</option>
						</cfloop>
					  </select>
					</cfoutput></td>
			</tr>
			<tr>
				<td width="100"><cf_get_lang dictionary_id ='31463.Viziteye Çıkış'> *</td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='31525.Viziteye Çıkış Tarihi Giriniz'></cfsavecontent>
				<cfinput validate="#validate_style#" type="text" name="DATEOUT" value="#dateformat(FEE_DATEOUT,dateformat_style)#" style="width:75px;" required="yes" message="#message#">
				<cf_wrk_date_image date_field="DATEOUT"> <cfoutput>
				  <select name="HOUROUT" id="HOUROUT" style="width:65px">
					<cfloop from="0" to="23" index="i">
					  <option value="#i#" <cfif i eq FEE_HOUROUT>selected</cfif>>#i#:00</option>
					</cfloop>
				  </select>
				</cfoutput></td>
				</tr>
			<tr>
				<td valign="top"><cf_get_lang dictionary_id ='57629.Açıklama'></td>
				<td>
					<TEXTAREA name="detail" id="detail" style="width:165px;height:60px;">#detail#</TEXTAREA>
				</td>
			</tr>
			<tr height="20"> 
				<td  class="txtbold"><cf_get_lang dictionary_id ='57500.Onay'> 1</td>
				<td> 
					<cfif valid_1 EQ 1>
						<cf_get_lang dictionary_id='58699.Onaylandı'> !
						<cfoutput>#get_emp_info(VALID_EMP_1,0,0)# (#dateformat(date_add('h',session.ep.time_zone,valid_date_1),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,valid_date_1),timeformat_style)#)</cfoutput>
					<cfelseif valid_1 EQ 0>
						<cf_get_lang dictionary_id='57617.Reddedildi'> !
						<cfoutput>#get_emp_info(VALID_EMP_1,0,0)# (#dateformat(date_add('h',session.ep.time_zone,valid_date_1),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,valid_date_1),timeformat_style)#)</cfoutput>
					<cfelse>
						<cfoutput>#get_emp_info(validator_pos_code_1,1,0)#</cfoutput>&nbsp;<cf_get_lang dictionary_id ='57615.Onay Bekliyor'>!
					</cfif>
				</td>
			</tr>
			<tr height="20"> 
				<td  class="txtbold"><cf_get_lang dictionary_id ='88.Onay'> 2</td>
				<td> 
				  <cfif valid_2 EQ 1>
					<cf_get_lang dictionary_id='58699.Onaylandı'> !
					<cfoutput>#get_emp_info(VALID_EMP_2,0,0)# (#dateformat(date_add('h',session.ep.time_zone,valid_date_2),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,valid_date_2),timeformat_style)#)</cfoutput>
				  <cfelseif valid_2 EQ 0>
					<cf_get_lang dictionary_id='57617.Reddedildi'> !
					<cfoutput>#get_emp_info(VALID_EMP_2,0,0)# (#dateformat(date_add('h',session.ep.time_zone,valid_date_2),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,valid_date_2),timeformat_style)#)</cfoutput>
				  <cfelse>
					<cfoutput>#get_emp_info(validator_pos_code_2,1,0)#</cfoutput>&nbsp;<cf_get_lang dictionary_id ='57615.Onay Bekliyor'>!
				  </cfif>
				</td>
			</tr>
			<tr>
			<!--- <td>&nbsp;</td>--->
				<td><input name="workcheck" id="workcheck" type="checkbox" onClick="gizle_goster(work);" <cfif accident is 1>checked</cfif>><cf_get_lang dictionary_id ='31515.İş Kazası ise'></td>
				<td><input type="checkbox" name="illness" id="illness" <cfif ILLNESS IS 1>CHECKED</cfif>><cf_get_lang dictionary_id ='31516.Meslek Hastalığı'></td>
			</tr>
		 </table>
		  <!--- İş Kazası --->
		<table id="work" <cfif accident eq 0>style="display:none;"</cfif>>
			<tr>
				<td width="110"><cf_get_lang dictionary_id ='31570.Olay Tarihi İşçi Sayısı'></td>
				<td>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31571.İşçi Sayısı Sayısal Olmalıdır'></cfsavecontent>
				<cfinput type="text" name="total_emp" style="width:165px;"  value="#total_emp#" message="#message#" validate="integer">
				</td>
			</tr>
			<tr>
				<td colspan="2">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='31517.Sigortalının'></cfsavecontent>
				<cf_seperator id="sigortali" header="#message#"> 
				<table id="sigortali">
					<tr>
						<td width="105"><cf_get_lang dictionary_id ='31518.İşi ve Mahiyeti'></td>
						<td><input type="text" name="emp_work" id="emp_work" style="width:165px;"  value="#emp_work#">
						</td>
					</tr>
				</table>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='31499.İş Kazasının'></cfsavecontent>
				<cf_seperator id="is_kazasinin" header="#message#">
				<table id="is_kazasinin">
					<tr>
						<td width="100" valign="top"><cf_get_lang dictionary_id ='31572.Oluş Şekli'></td>
						<td><textarea name="event" id="event" style="width:165px;height:60px;">#event#</textarea>
						</td>
					</tr>
					<tr>                               
						<td><cf_get_lang dictionary_id ='31509.Güvenlik Maddesi'></td>
						<td>
						<select name="accident_security_id" id="accident_security_id" style="width:165px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfloop query="get_accident_securities">
							  <option value="#accident_security_id#"<cfif GET_FEE.accident_security_id eq accident_security_id> selected</cfif>>#accident_security#</option>
							</cfloop>
						  </select>
						</td>
					</tr>
				 	<tr>                               
						<td><cf_get_lang dictionary_id ='31513.Kaza Çeşidi'></td>
						<td>
						<select name="accident_type_id" id="accident_type_id" style="width:165px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfloop query="GET_WORK_ACCIDENT_TYPE">
							  <option value="#ACCIDENT_TYPE_ID#"<cfif GET_FEE.ACCIDENT_TYPE_ID eq ACCIDENT_TYPE_ID> selected</cfif>>#accident_type#</option>
							</cfloop>
						  </select>
						</td>
					</tr>
					<tr>
						<td width="100"><cf_get_lang dictionary_id ='31519.Olay Yeri'></td>
						<td><input type="text" name="place" id="place" style="width:165px;"  value="#place#" maxlength="50">
						</td>
					</tr>
					<tr>
						<td width="100"><cf_get_lang dictionary_id ='58463.Tarih ve Saat'></td>
						<td>
						<input validate="#validate_style#" type="text" name="DATEEVENT" id="DATEEVENT" value="#dateformat(EVENT_DATE,dateformat_style)#" style="width:65px;">
						<cf_wrk_date_image date_field="DATEEVENT"> 
						<cfoutput>
						  <select name="HOUREVENT" id="HOUREVENT">
							<cfloop from="0" to="23" index="i">
							  <option value="#i#" <cfif i eq event_hour>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
							</cfloop>
						  </select>
								 <select name="EVENT_MIN" id="EVENT_MIN">
								  <option value="00"<cfif event_min is '00'> selected</cfif>>00</option>
								  <option value="05"<cfif event_min is '05'> selected</cfif>>05</option>
								  <option value="10"<cfif event_min is '10'> selected</cfif>>10</option>
								  <option value="15"<cfif event_min is '15'> selected</cfif>>15</option>
								  <option value="20"<cfif event_min is '20'> selected</cfif>>20</option>
								  <option value="25"<cfif event_min is '25'> selected</cfif>>25</option>
								  <option value="30"<cfif event_min is '30'> selected</cfif>>30</option>
								  <option value="35"<cfif event_min is '35'> selected</cfif>>35</option>
								  <option value="40"<cfif event_min is '40'> selected</cfif>>40</option>
								  <option value="45"<cfif event_min is '45'> selected</cfif>>45</option>
								  <option value="50"<cfif event_min is '50'> selected</cfif>>50</option>
								  <option value="55"<cfif event_min is '55'> selected</cfif>>55</option>
								</select>
						</cfoutput>
						</td>
					</tr>
					<tr>
						<td width="100"><cf_get_lang dictionary_id ='31520.Olay Günündeki İşbaşı Saati'></td>
						<td><input type="text" name="workstart" id="workstart" style="width:165px;"  value="#workstart#">
						</td>
					</tr>
				</table>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='31522.Tanıkların Adı ve Soyadı'></cfsavecontent>
				<cf_seperator id="taniklarin_ad_ve_soyadlari" title="#message#">	
				<table id="taniklarin_ad_ve_soyadlari">
						<tr>
							<td width="100"><cf_get_lang dictionary_id ='53325.Tanık'> -1 </td>
							<td>
								<input type="text" name="witness1" id="witness1" style="width:165px;"  value="#witness1#">
								<input type="hidden" name="witness1_id" id="witness1_id" value="">
								<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=ssk_fee.witness1_id&field_emp_name=ssk_fee.witness1','list');return false"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a> 
							</td>
							</tr>
							<tr>
							<td width="100"><cf_get_lang dictionary_id ='53325.Tanık'>-2</td>
							<td>
								<input type="text" name="witness2" id="witness2" style="width:165px;"  value="#witness2#">
								<input type="hidden" name="witness2_id" id="witness2_id" value="">
								<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=ssk_fee.witness2_id&field_emp_name=ssk_fee.witness2','list');return false"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>   
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		  <!--- İş Kazası --->
	<cf_popup_box_footer>
    	<cf_record_info query_name="GET_FEE">
    	<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_ssk_fee_self&fee_id=#attributes.fee_id#&head=#get_fee.employee_name# #get_fee.employee_surname#'>
    </cf_popup_box_footer>
	</cfform>
</cf_popup_box>
</cfoutput> 
<script type="text/javascript">
	function kontrol()
	{
		if (ssk_fee.emp_name.value == "")
			{
			alert("<cf_get_lang dictionary_id='29498.Çalışan Girmelisiniz'>!");
					return false;
			}
		return true;
	}
</script>
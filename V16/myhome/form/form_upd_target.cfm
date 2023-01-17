<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.dept_id" default="">
<cfquery name="GET_TARGET" datasource="#dsn#">
	SELECT * FROM TARGET WHERE TARGET_ID = #attributes.TARGET_ID#
</cfquery>
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT	
		MONEY,
		RATE1,
		RATE2 
	FROM 
		SETUP_MONEY 
	WHERE 
		PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cf_popup_box title="#getLang('main',539)#">
	<table>
		<cfform name="upd_target" method="post" action="#request.self#?fuseaction=myhome.emptypopup_upd_target&update_type=1" onsubmit="return deger_kontrol();">
		<input type="Hidden" name="target_id" id="target_id" value="<cfoutput>#target_id#</cfoutput>">
		<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
		<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
		<input type="hidden" name="dept_id" id="dept_id" value="<cfoutput>#attributes.dept_id#</cfoutput>">
		<input type="hidden" name="counter" id="counter" value="">
		<tr>
			<td width="70"><cf_get_lang_main no='89.Başlangıç'></td>
			<cfsavecontent variable="alert"><cf_get_lang_main no='326.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
			<td><cfinput type="text" name="startdate" value="#dateformat(get_target.startdate,dateformat_style)#" style="width:65px;" required="yes" message="#alert#" validate="#validate_style#">
			<cf_wrk_date_image date_field="startdate">
			<cf_get_lang_main no='90.Bitiş'>&nbsp;
			<cfinput type="text" name="finishdate" value="#dateformat(get_target.finishdate,dateformat_style)#" style="width:65px;" required="yes" message="#alert#" validate="#validate_style#">
			<cf_wrk_date_image date_field="finishdate">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='74.Kategori'></td>
			<td class="txtbold">
			<select name="targetcat_id" id="targetcat_id" style="width:400px;">
			<cfinclude template="../query/get_target_cats.cfm">
			<cfoutput query="get_target_cats">
			  <option value="#targetcat_id#" <cfif get_target.targetcat_id eq targetcat_id>selected</cfif>>#targetcat_name#</option>
			</cfoutput>
			</select></td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='539.Hedef'></td>
			<td><cfsavecontent variable="message"><cf_get_lang no='223.Hedef girmelisiniz'></cfsavecontent>
			<cfinput type="text" name="target_head" required="yes" message="#message#" value="#get_target.target_head#" style="width:400px;" maxlength="300">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang no ='211.Rakam'></td>
			<td><cfinput type="text" class="moneybox" name="target_number" style="width:120px;" value="#TLFormat(get_target.target_number)#"  onkeyup="return(FormatCurrency(this,event));">
			&nbsp;<select name="calculation_type" id="calculation_type" style="width:150px">
			<option value="1" <cfif get_target.CALCULATION_TYPE eq 1>selected </cfif>> + (<cf_get_lang no ='385.Artış Hedefi'>)</option>
			<option value="2" <cfif get_target.CALCULATION_TYPE eq 2>selected </cfif>>- (<cf_get_lang no ='386.Düşüş Hedefi'>)</option>
			<option value="3" <cfif get_target.CALCULATION_TYPE eq 3>selected </cfif>>+% (<cf_get_lang no ='387.Yüzde Artış Hedefi'>)</option>
			<option value="4" <cfif get_target.CALCULATION_TYPE eq 4>selected </cfif>> -% (<cf_get_lang no ='388.Yüzde Düşüş Hedefi'>)</option>
			<option value="5" <cfif get_target.CALCULATION_TYPE eq 5>selected </cfif>> = (<cf_get_lang no ='389.Hedeflenen Rakam'>)</option>
			</select>
			</td>
		</tr>
		<tr>
			<td height="26"><cf_get_lang_main no ='1987.Ağırlık'></td>
			<cfsavecontent variable="alert"><cf_get_lang no ='1165.Hedef Ağırlığı Girmelisiniz'></cfsavecontent>
			<td><cfinput type="text" class="moneybox" name="target_weight" style="width:150px;" value="#TLFormat(get_target.target_weight)#" onkeyup="return(FormatCurrency(this,event));"  required="yes" message="#alert#"></td>
		</tr>
		<tr>
			<td><cf_get_lang no ='395.Hedef Veren'></td>
			<td>
			<input type="hidden" name="target_emp_id" id="target_emp_id"  value="<cfoutput>#get_target.target_emp#</cfoutput>">
			<input type="text" name="target_emp" id="target_emp" value="<cfoutput>#get_emp_info(get_target.target_emp,0,0)#</cfoutput>" style="width:150px;" readonly>
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=upd_target.target_emp&field_emp_id2=upd_target.target_emp_id</cfoutput>','list');"><img SRC="/images/plus_list.gif" title="<cf_get_lang_main no ='322.Seçiniz'>" border="0" align="absmiddle"></a>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='217.Açıklama'></td>
			<td valign="top"><textarea name="target_detail" id="target_detail" style="width:400px;height:50px;"><cfoutput>#get_target.target_detail#</cfoutput></textarea></td>
		</tr>
			<cfoutput>
		<tr>
			<td></td>
			<td>
			<cf_get_lang_main no='71.Kayıt'> :
			<!--- 	<cfif len(get_target.record_emp)>
			<cfset attributes.employee_id = get_target.record_emp>
			<cfinclude template="../query/get_employee_name.cfm">
			<cfoutput>#get_employee_name.employee_name# #get_employee_name.employee_surname# </cfoutput>
			</cfif> --->
			
			<!--- <cfif len(get_target.update_emp)>
			, Güncelleme :
			<cfset attributes.employee_id = get_target.update_emp>
			<cfinclude template="../query/get_employee_name.cfm">
			<cfoutput>#get_employee_name.employee_name# #get_employee_name.employee_surname# , </cfoutput>
			</cfif> --->
			&nbsp;<cf_get_lang_main no ='215.Kayıt Tarihi'>: #dateformat(date_add('h',session.ep.time_zone,get_target.record_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,get_target.record_date),timeformat_style)#)</td>
		</tr>
		<tr>
			<td height="30" style="text-align:right"></td>
			<td>
			<cf_workcube_buttons is_upd='1'  
				delete_page_url='#request.self#?fuseaction=myhome.emptypopup_del_target&target_id=#get_target.target_id#' 
				delete_alert='Kaydı Siliyorsunuz.Emin misiniz?' 
				add_function='check()'></td>
		</tr>
			</cfoutput>
			</cfform>
	</table>
	<hr />
	<cfform name="upd_target_perf" method="post" action="#request.self#?fuseaction=myhome.emptypopup_upd_target&update_type=2">
	<input type="hidden" name="target_id" id="target_id" value="<cfoutput>#target_id#</cfoutput>">  
	<table>
		<tr>
			<td></td>
			<td><cf_get_lang no ='1167.Bu bölümü yöneticiler dolduracak'>!</td></tr>
		<tr>
			<td width="70" valign="top"><cf_get_lang_main no='272.Sonuç'></td>
			<cfsavecontent variable="message"><cf_get_lang_main no='1687.Fazla karakter sayısı'></cfsavecontent>
			<td><textarea name="perform_comment" id="perform_comment" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>" style="width:400px;height:50px;"><cfoutput>#get_target.perform_comment#</cfoutput></textarea></td>
		</tr>
		<tr>
			<td></td>
			<td><input name="perform_point_id" id="perform_point_id" type="radio" value="1" <cfif get_target.perform_point_id is 1>checked</cfif>>
			<cf_get_lang no ='240.Beklenenin Üstü'>  (+)
			<input name="perform_point_id" id="perform_point_id" type="radio" value="2" <cfif get_target.perform_point_id is 2>checked</cfif>>
			<cf_get_lang no ='240.Beklenenin Üstü'> (-)
			<input name="perform_point_id" id="perform_point_id" type="radio" value="3" <cfif get_target.perform_point_id is 3>checked</cfif>>
			<cf_get_lang no ='241.Beklenen Düzey'>  (+)
			<input name="perform_point_id" id="perform_point_id" type="radio" value="4" <cfif get_target.perform_point_id is 4>checked</cfif>>
			<cf_get_lang no ='241.Beklenen Düzey'> </td>
		</tr>
		<tr>
			<td></td>
			<td>
			<input name="perform_point_id" id="perform_point_id" type="radio" value="5" <cfif get_target.perform_point_id is 5>checked</cfif>>
			<cf_get_lang no ='241.Beklenen Düzey'> (-)
			<input name="perform_point_id" id="perform_point_id" type="radio" value="6" <cfif get_target.perform_point_id is 6>checked</cfif>>
			<cf_get_lang no ='242.Beklenenin Altı'>  (+)
			<input name="perform_point_id" id="perform_point_id" type="radio" value="7" <cfif get_target.perform_point_id is 7>checked</cfif>>
			<cf_get_lang no ='242.Beklenenin Altı'> (-)
			<input name="perform_point_id" id="perform_point_id" type="radio" value="8" <cfif get_target.perform_point_id is 8>checked</cfif>>
			<cf_get_lang no ='243.Değerlendirilemedi'> 
			</td>
		</tr>
			<cfoutput>
			</cfoutput>
	</table>
	</cfform>
	<cf_popup_box_footer><cf_workcube_buttons is_upd='0' type_format="1" add_function='check()'></cf_popup_box_footer>
</cf_popup_box>
<script type="text/javascript">
function check()
{
	if ((upd_target.startdate.value != "") && (upd_target.finishdate.value != ""))
	if (! date_check(upd_target.startdate, upd_target.finishdate, "<cf_get_lang no ='1166.Başlangıç tarihi bitiş tarihinden küçük olmalıdır'> !"))
		return false;
	 
}

function deger_kontrol()
{
	upd_target.target_number.value = filterNum(upd_target.target_number.value);
	upd_target.target_weight.value = filterNum(upd_target.target_weight.value);
	return true;
}
</script>

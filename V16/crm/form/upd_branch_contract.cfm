<cfquery name="GET_BRANCH_CONTRACT" datasource="#DSN#">
	SELECT
		CBC.*,
		SCT.CUSTOMER_TYPE
	FROM
		COMPANY_BRANCH_CONTRACT CBC,
		SETUP_CUSTOMER_TYPE SCT
		
	WHERE 
		CBC.COMPANY_BRANCH_CONTRACT_ID = #attributes.contract_id# AND
		CBC.CUSTOMER_TYPE_ID = SCT.CUSTOMER_TYPE_ID
</cfquery>

<cfquery name="GET_RELATED" datasource="#DSN#">
	SELECT
		COMPANY.FULLNAME,
		COMPANY.TAXNO,
		COMPANY.SEMT,
		COMPANY.DISTRICT,
		COMPANY.MAIN_STREET,
		COMPANY.STREET,
		COMPANY.DUKKAN_NO,
		COMPANY.COMPANY_TELCODE,
		COMPANY.COMPANY_TEL1,
		COMPANY.COMPANY_FAX,
		COMPANY.COMPANY_FAX_CODE,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		SETUP_IMS_CODE.IMS_CODE,
		SETUP_IMS_CODE.IMS_CODE_NAME,
		SETUP_CITY.CITY_NAME,
		SETUP_COUNTY.COUNTY_NAME
	FROM
		COMPANY,
		COMPANY_PARTNER,
		SETUP_IMS_CODE,
		SETUP_CITY,
		SETUP_COUNTY
	WHERE
		COMPANY.COMPANY_ID = #get_branch_contract.company_id# AND
		COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
		SETUP_IMS_CODE.IMS_CODE_ID = COMPANY.IMS_CODE_ID AND
		SETUP_CITY.CITY_ID = COMPANY.CITY AND
		SETUP_COUNTY.COUNTY_ID = COMPANY.COUNTY
</cfquery>

<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME
	FROM
		BRANCH
	WHERE
		BRANCH_ID = #get_branch_contract.branch_id#
</cfquery>
<cfquery name="GET_RELATED_BRANCHS" datasource="#DSN#">
	SELECT 
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		COMPANY_BRANCH_RELATED.MUSTERIDURUM
	FROM
		BRANCH,
		COMPANY_BRANCH_RELATED
	WHERE
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND
		COMPANY_BRANCH_RELATED.COMPANY_ID = #get_branch_contract.company_id#
</cfquery>

<cfquery name="GET_CUSTOMER_POSITION" datasource="#DSN#">
	SELECT 
		COMPANY_POSITION.POSITION_ID,
		SETUP_CUSTOMER_POSITION.POSITION_NAME 
	FROM 
		SETUP_CUSTOMER_POSITION, 
		COMPANY_POSITION
	WHERE 
		COMPANY_POSITION.POSITION_ID = SETUP_CUSTOMER_POSITION.POSITION_ID AND 
		COMPANY_POSITION.COMPANY_ID = #get_branch_contract.company_id#
	ORDER BY 
		SETUP_CUSTOMER_POSITION.POSITION_ID
</cfquery>
<cfquery name="GET_COMPANY_RIVAL_INFO" datasource="#DSN#">
	SELECT
		SETUP_RIVALS.R_ID,
		SETUP_RIVALS.RIVAL_NAME
	FROM
		COMPANY,
		COMPANY_PARTNER_RIVAL,
		SETUP_RIVALS
	WHERE
		COMPANY.COMPANY_ID = COMPANY_PARTNER_RIVAL.COMPANY_ID AND
		COMPANY_PARTNER_RIVAL.RIVAL_ID = SETUP_RIVALS.R_ID AND
		COMPANY.COMPANY_ID = #get_branch_contract.company_id#
</cfquery>

<cfquery name="GET_TARGET_PERIOD" datasource="#DSN#">
	SELECT TARGET_PERIOD_ID,TARGET_PERIOD FROM SETUP_TARGET_PERIOD ORDER BY TARGET_PERIOD
</cfquery>

<table width="100%" cellpadding="2" cellspacing="1" border="0" height="100%" class="color-border">
	<tr class="color-list">
		<td height="35" class="headbold"><cf_get_lang no ='906.Anlaşma Güncelle'> (<cf_get_lang no='610.Eczane Adı'> : <cfoutput>#get_related.fullname#</cfoutput>)</td>
		<td>
			<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_branch_contracts_history&contract_id=#attributes.contract_id#</cfoutput>','longpage','popup_branch_contracts_history');"><img src="/images/history.gif" title="<cf_get_lang_main no='61.Tarihçe'>" border="0"></a>
			<!--- <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_list_securefund_info&cpid=#attributes.company_id#</cfoutput>','page');"><img src="/images/notkalem.gif" alt="Müşteri Teminatları" border="0"></a> --->
		</td>
	</tr>
	<tr class="color-row">
		<td valign="top">
		<table>
		<cfform name="branch_contract" method="post" action="#request.self#?fuseaction=crm.emptypopup_upd_branch_contract">
		<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_branch_contract.company_id#</cfoutput>">
		<input type="hidden" name="related_id" id="related_id" value="<cfoutput>#get_branch_contract.related_id#</cfoutput>">
		<input type="hidden" name="contract_id" id="contract_id" value="<cfoutput>#attributes.contract_id#</cfoutput>">
		<cfif isdefined("attributes.is_normal_form")><input type="hidden" name="is_normal_form" id="is_normal_form" value="1"></cfif>
			<tr class="color-row">
				<td class="formbold" colspan="4"><a href="javascript:gizle_goster(show_company);">&raquo;&nbsp;<cf_get_lang no='774.Eczane Bilgileri'>&nbsp;&raquo;</a></td>
			</tr>
			<tr id="show_company" style="display:none;">
				<td colspan="4">
				<table>
					<tr>
						<td width="130"><cf_get_lang no='610.Eczane Adı'></td>
						<td width="175">: <input type="hidden" name="company_name" id="company_name" value="<cfoutput>#get_related.fullname#</cfoutput>"><cfoutput>#get_related.fullname#</cfoutput></td>
						<td width="120"><cf_get_lang no='611.Eczacı Adı Soyadı'></td>
						<td>: <cfoutput>#get_related.company_partner_name# #get_related.company_partner_surname#</cfoutput></td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='340.Vergi No'></td>
						<td>: <cfoutput>#get_related.taxno#</cfoutput></td>
						<td><cf_get_lang no='613.Tel No'></td>
						<td>: <cfoutput>#get_related.company_telcode# #get_related.company_tel1#</cfoutput></td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='722.Mikro Bolge Kodu'></td>
						<td>: <cfoutput>#get_related.ims_code# #get_related.ims_code_name#</cfoutput></td>
						<td><cf_get_lang_main no='76.Fax'></td>
						<td>: <cfoutput>#get_related.company_fax_code# #get_related.company_fax#</cfoutput></td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='1196.İl'></td>
						<td>: <cfoutput>#get_related.city_name#</cfoutput></td>
						<td><cf_get_lang no='614.İşyeri No'></td>
						<td>: <cfoutput>#get_related.dukkan_no#</cfoutput></td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='1226.İlçe'></td>
						<td>: <cfoutput>#get_related.county_name#</cfoutput></td>
						<td><cf_get_lang no='46.Sokak'></td>
						<td>: <cfoutput>#get_related.street#</cfoutput></td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='720.Semt'></td>
						<td>: <cfoutput>#get_related.semt#</cfoutput></td>
						<td><cf_get_lang_main no='1323.Mahalle'></td>
						<td>: <cfoutput>#get_related.main_street#</cfoutput></td>
					</tr>
					<tr>
						<td><cf_get_lang no='45.Cadde'></td>
						<td>: <cfoutput>#get_related.district#</cfoutput></td>
						<td valign="top"><cf_get_lang no='615.Eczane Konumu'></td>
						<td valign="top"><cfoutput query="get_customer_position">: #position_name#<br/></cfoutput></td>
					</tr>
					<tr>
						<td valign="top" nowrap><cf_get_lang no='616.İlişkili Şubeler'><br/><cf_get_lang_main no='344.Durum'></td>
						<td valign="top">
							<cfoutput query="get_related_branchs"> : #branch_name#
								<cfif len(musteridurum)>
									<cfquery name="GET_STATUS" datasource="#DSN#">
										SELECT TR_NAME FROM SETUP_MEMBERSHIP_STAGES WHERE TR_ID = #musteridurum#
									</cfquery>
									- #get_status.tr_name#
								</cfif>
								<br/>
							</cfoutput>
						</td>
						<td valign="top"><cf_get_lang no='617.Çalıştığı Rakipler'><br/><cf_get_lang no='618.Tercih Nedenleri'></td>
						<td valign="top">
							<cfoutput query="get_company_rival_info">
								<cfquery name="GET_OPTIONS" datasource="#DSN#">
									SELECT 
										SETUP_RIVAL_PREFERENCE_REASONS.PREFERENCE_REASON
									FROM 
										COMPANY_RIVAL_OPTION_APPLY,
										SETUP_RIVAL_PREFERENCE_REASONS
									WHERE  
										COMPANY_RIVAL_OPTION_APPLY.COMPANY_ID = #get_branch_contract.company_id# AND 
										COMPANY_RIVAL_OPTION_APPLY.RIVAL_ID = #r_id# AND
										SETUP_RIVAL_PREFERENCE_REASONS.PREFERENCE_REASON_ID = COMPANY_RIVAL_OPTION_APPLY.OPTION_ID
								</cfquery> 
								: #rival_name# 
								<cfif get_options.recordcount>- <cfloop query="get_options">#preference_reason#,</cfloop></cfif>
								<br/>
							</cfoutput>
						</td>
					</tr>				
				</table>
				</td>
			</tr>
			<tr>
				<td width="130"><cf_get_lang_main no='81.Aktif'></td>
				<td width="175"><input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_branch_contract.is_active> checked</cfif>></td>
				<td width="110"></td>
				<td></td>
			</tr>
			<tr>
				<td><cf_get_lang no='35.Müşteri Tipi'> *</td>
				<td>
					<input type="hidden" name="target_customer_type" id="target_customer_type" value="<cfoutput>#get_branch_contract.customer_type_id#</cfoutput>">
					<cfoutput>#get_branch_contract.customer_type#</cfoutput>
				</td>
				<td><cf_get_lang_main no='41.Sube'> *</td>
				<td>
					<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_branch_contract.branch_id#</cfoutput>">
					<input type="hidden" name="branch_name" id="branch_name" value="<cfoutput>#get_branch.branch_name#</cfoutput>">
					<cfoutput>#get_branch.branch_name#</cfoutput>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no="1447.Süreç">*</td>
				<td><cf_workcube_process is_upd='0' select_value = '#get_branch_contract.process_cat#' process_cat_width='120' is_detail='1'></td>
				<td><cf_get_lang no='775.Anlaşma Tarihi'> *</td>
				<td><input type="text" name="contract_date" id="contract_date" value="<cfoutput>#dateformat(get_branch_contract.contract_date,dateformat_style)#</cfoutput>" readonly maxlength="10" style="width:115px"></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='641.Başlangıç Tarihi'> *</td>
				<td>	
					<cfsavecontent variable="message"><cf_get_lang_main no ='326.Başlangıç Tarihi Girmelisiniz'> !</cfsavecontent>			
					<cfinput type="text" name="start_date" value="#dateformat(get_branch_contract.start_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:120px">
					<cf_wrk_date_image date_field="start_date">					
				</td>
				<td><cf_get_lang_main no='288.Bitiş Tarihi'> *</td>
				<td>
					<cfsavecontent variable="message1"><cf_get_lang_main no ='327.Bitiş Tarihi Girmelisiniz'> !</cfsavecontent>
					<cfinput type="text" name="finish_date" value="#dateformat(get_branch_contract.finish_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message1#" style="width:115px">
					<cf_wrk_date_image date_field="finish_date">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no ='848.Mak Anlaşma Mas Oranı'></td>
				<td><input type="text" name="restrict_rate" id="restrict_rate" value="<cfoutput>#tlformat(get_branch_contract.restrict_rate)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:120px;"></td>
				<td><cf_get_lang no ='849.Ciro Kontrol Yöntemi'> *</td>
				<td>
					<select name="control_method" id="control_method" style="width:115px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
						<option value="1" <cfif get_branch_contract.control_method_id eq 1> selected</cfif>><cf_get_lang no ='850.KDV Beyannamesi'></option>
						<option value="2" <cfif get_branch_contract.control_method_id eq 2> selected</cfif>><cf_get_lang no ='851.Reçete Tutarı'></option>
					</select>				
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no ='852.Aylık Alım Kapasitesi'> *</td>
				<td><input type="text" name="monthly_capacity" id="monthly_capacity" value="<cfoutput>#tlformat(get_branch_contract.monthly_capacity)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:120px;"></td>
				<td><cf_get_lang no ='853.Hedeflenen Aylık Ciro'> *</td>
				<td><input type="text" name="monthly_endorsement" id="monthly_endorsement" value="<cfoutput>#tlformat(get_branch_contract.monthly_endorsement)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:115px;"></td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang no='35.Müşteri Tipi'> <cf_get_lang_main no='217.Açıklama'></td>
				<td colspan="3"><textarea style="width:95%;height:30px;" name="customer_type_detail" id="customer_type_detail" readonly><cfoutput>#get_branch_contract.customer_type_detail#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
				<td colspan="3"><textarea style="width:95%;height:50px;" name="detail" id="detail"><cfoutput>#get_branch_contract.detail#</cfoutput></textarea></td>
			</tr>
			<!---	
				FS 20080702 Merkez Onay ve Merkez Red Asamalarinda iken butonlar gorunmeyecek, 
				Merkez Onay Process_row_id : Hedef = 529 // Ep = 165
				Merkez Red Process_Row_Id : Hedef = 530// Ep =  169
			  --->
			<cfif (listfind("529,530",get_branch_contract.process_cat,',') eq 0) and (DateFormat(get_branch_contract.finish_date,dateformat_style) gt DateFormat(now(),dateformat_style))>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3"><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'></td>
				</tr>
			</cfif>
			<tr class="color-row" id="_show_branch_contract_information_">
				<td colspan="4"><div id="show_branch_contract_information"></div></td>
			</tr>
			<script type="text/javascript">
				goster(_show_branch_contract_information_);
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=crm.ajax_popup_view_branch_contract_information&related_id=#get_branch_contract.related_id#&contract_id=#attributes.contract_id#&target_customer_type=#get_branch_contract.customer_type_id#','show_branch_contract_information'</cfoutput>,1);
			</script>
		</cfform>
		</table>
		</td>
		<td>
			<table cellspacing="1" cellpadding="2" width="100%" height="100%" class="color-border">
				<tr class="color-header" height="20">
					<td class="form-title" width="100%"><cf_get_lang_main no='568.Genel Bilgiler'></td>
				</tr>
				<tr class="color-row">
					<td><iframe scrolling="auto" width="100%" height="100%" frameborder="0" name="member_frame" id="member_frame" src="<cfoutput>#request.self#?fuseaction=crm.popup_dsp_risk_info&cpid=#get_branch_contract.company_id#&iframe=1&branch_id=#get_branch.branch_id#</cfoutput>"></iframe></td>
				</tr>
			</table>
		</td>
	</tr>
</table>						
<script type="text/javascript">
function kontrol()
{
	if(document.branch_contract.start_date.value == "")
	{
		alert("<cf_get_lang_main no ='326.Başlangıç Tarihi Girmelisiniz'> !");
		return false;
	}

	if(document.branch_contract.finish_date.value == "")
	{
		alert("<cf_get_lang_main no ='327.Bitiş Tarihi Girmelisiniz'> !");
		return false;
	}
	
	// Baslangic tarihinin bitis tarihinden buyuk olmasi durumunda uyari ver
	if(!date_check(document.branch_contract.start_date,document.branch_contract.finish_date, "<cf_get_lang dictionary_id='30123.Bitiş Tarihini Kontrol Ediniz'>" ,1))
		return false;

	if(document.branch_contract.control_method.value == "")
	{
		alert("<cf_get_lang no ='856.Ciro Kontrol Yöntemi Seçmelisiniz'> !");
		return false;
	}
	
	if(document.branch_contract.monthly_capacity.value == "")
	{
		alert("<cf_get_lang no ='857.Eczane Aylık Alım Kapasitesi Değerini Girmelisiniz'> !");
		return false;
	}	
		
	if(document.branch_contract.monthly_endorsement.value == "")
	{
		alert("<cf_get_lang no ='858.Eczane Hedeflenen Aylık Ciro Değerini Girmelisiniz'> !");
		return false;
	}			
		
	if(document.branch_contract.detail.value.length>1000)
	{
		alert("<cf_get_lang no ='859.Açıklama 1000 Karakterden Fazla Olamaz'>'>!");
		return false;
	}				


	if(branch_contract.record_num.value != 0)
	{
		for(r=1;r<=branch_contract.record_num.value;r++)
		{
			if(eval("document.branch_contract.row_kontrol"+r).value == 1)
			{
				//hizmet icin deger girisi 
				if(eval("document.branch_contract.is_value"+r).value == 1)
				{
					if(eval("document.branch_contract.cost_amount"+r).value == '')
					{
						alert("<cf_get_lang_main no ='1177.Değer Girmelisiniz'> !");
						return false;
					}
				}
				
				//hizmet icin hedef tanimi
				if(eval("document.branch_contract.is_target"+r).value == 1)
				{
					value_target_period = eval("document.branch_contract.target_period"+r);
					x = value_target_period.selectedIndex;
					if(value_target_period[x].value == "")
					{ 
						alert("<cf_get_lang no ='863.Hedef Dönemi Seçiniz'> !");
						return false;
					}
					
					if(eval("document.branch_contract.target_amount"+r).value == '')
					{
						alert("<cf_get_lang no ='864.Hedef Tutar Girmelisiniz'> !");
						return false;
					}							
				}
			}
		}
	}
	
	if(kontrol_row_count == 0)
	{
		alert("<cf_get_lang no ='866.En Az Bir Satır Anlaşma İçeriği Giriniz'> !");
		return false;
	}
	
	//Ek Hizmetler kontrol
	if(branch_contract.record_num_.value != 0)
	{
		for(r=1;r<=branch_contract.record_num_.value;r++)
		{
			if(eval("document.branch_contract.row_kontrol_"+r).value == 1)
			{
				//hizmet icin deger girisi 
				if(eval("document.branch_contract.is_value_"+r).value == 1)
				{
					if(eval("document.branch_contract.cost_amount_"+r).value == '')
					{
						alert("<cf_get_lang_main no ='1177.Değer Girmelisiniz'> !");
						return false;
					}
				}
				//hizmet icin hedef tanimi
				if(eval("document.branch_contract.is_target_"+r).value == 1)
				{
					value_target_period = eval("document.branch_contract.target_period_"+r);
					x = value_target_period.selectedIndex;
					if(value_target_period[x].value == "")
					{ 
						alert("<cf_get_lang no ='863.Hedef Dönemi Seçiniz'>!");
						return false;
					}
					
					if(eval("document.branch_contract.target_amount_"+r).value == '')
					{
						alert("<cf_get_lang no ='864.Hedef Tutar Girmelisiniz'>  !");
						return false;
					}							
				}
			}
		}
	}
	
	
	
	if(process_cat_control())
	{
		for(r=1;r<=branch_contract.record_num.value;r++)
		{
			if(eval("document.branch_contract.row_kontrol"+r).value == 1)
			{				
				eval("document.branch_contract.cost_amount"+r).value = filterNum(eval("document.branch_contract.cost_amount"+r).value);
				if(eval("document.branch_contract.is_target"+r).value == 1)
					eval("document.branch_contract.target_amount"+r).value = filterNum(eval("document.branch_contract.target_amount"+r).value);
			}
		}
		// Ek hizmet
		for(r=1;r<=branch_contract.record_num_.value;r++)
		{
			if(eval("document.branch_contract.row_kontrol_"+r).value == 1)
			{				
				eval("document.branch_contract.cost_amount_"+r).value = filterNum(eval("document.branch_contract.cost_amount_"+r).value);
				if(eval("document.branch_contract.is_target_"+r).value == 1)
					eval("document.branch_contract.target_amount_"+r).value = filterNum(eval("document.branch_contract.target_amount_"+r).value);
			}
			eval("document.branch_contract.target_period_"+r).disabled = false;
		}
		document.branch_contract.restrict_rate.value = filterNum(document.branch_contract.restrict_rate.value);
		document.branch_contract.monthly_capacity.value = filterNum(document.branch_contract.monthly_capacity.value);
		document.branch_contract.monthly_endorsement.value = filterNum(document.branch_contract.monthly_endorsement.value);
		
		
	}
	else
		return false;
}
/*
function window_duty_type(category)
{
	if(category == 0)
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_duty_type&is_category=0&customer_type_id=' + document.branch_contract.target_customer_type.value,'list','popup_list_duty_type');
	else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_duty_type&is_category=1&customer_type_id=' + document.branch_contract.target_customer_type.value,'list','popup_list_duty_type');
}	
*/
</script>

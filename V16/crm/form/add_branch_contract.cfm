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
		COMPANY.COMPANY_ID = #attributes.company_id# AND
		COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
		SETUP_IMS_CODE.IMS_CODE_ID = COMPANY.IMS_CODE_ID AND
		SETUP_CITY.CITY_ID = COMPANY.CITY AND
		SETUP_COUNTY.COUNTY_ID = COMPANY.COUNTY
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT 
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		COMPANY_BRANCH_RELATED.RELATED_ID
	FROM
		BRANCH,
		COMPANY_BRANCH_RELATED
	WHERE
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		COMPANY_BRANCH_RELATED.IS_SELECT <> 0 AND
		BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND
		COMPANY_BRANCH_RELATED.COMPANY_ID = #attributes.company_id# AND
		BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
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
		COMPANY_BRANCH_RELATED.COMPANY_ID = #attributes.company_id#
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
		COMPANY_POSITION.COMPANY_ID = #attributes.company_id#
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
		COMPANY.COMPANY_ID = #attributes.company_id#
</cfquery>
<cfquery name="GET_RELATED_BRANCH" dbtype="query">
	SELECT BRANCH_ID FROM GET_BRANCH WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
</cfquery>

<cfquery name="GET_TARGET_PERIOD" datasource="#DSN#">
	SELECT TARGET_PERIOD_ID,TARGET_PERIOD FROM SETUP_TARGET_PERIOD ORDER BY TARGET_PERIOD
</cfquery>

<cfquery name="GET_CUSTOMER_TYPE" datasource="#DSN#">
	SELECT CUSTOMER_TYPE_ID,CUSTOMER_TYPE FROM SETUP_CUSTOMER_TYPE ORDER BY CUSTOMER_TYPE
</cfquery>

<table width="100%" cellpadding="2" cellspacing="1" border="0" height="100%" class="color-border">
	<tr class="color-list">
		<td height="35" class="headbold"><cf_get_lang_main no='1556.Anla??ma Ekle'> (<cf_get_lang no='610.Eczane Ad??'> : <cfoutput>#get_related.fullname#</cfoutput>)</td>
		<td><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_list_securefund_info&cpid=#attributes.company_id#</cfoutput>','page');"><img src="/images/notkalem.gif" title="<cf_get_lang no ='847.M????teri Teminatlar??'>" border="0"></a></td>
	</tr>
	<tr class="color-row">
		<td valign="top">
		<table>
		<cfform name="branch_contract" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_branch_contract">
		<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#url.company_id#</cfoutput>">	
		<input type="hidden" name="is_control" id="is_control" value="">	
		<input type="hidden" name="control_rate" id="control_rate" value="">	
		<cfif isdefined("attributes.is_normal_form")><input type="hidden" name="is_normal_form" id="is_normal_form" value="1"></cfif>
			<tr class="color-row">
				<td class="formbold" colspan="4"><a href="javascript:gizle_goster(show_company);">&raquo;&nbsp;<cf_get_lang no='774.Eczane Bilgileri'>&nbsp;&raquo;</a></td>
			</tr>
			<tr id="show_company" style="display:none;">
				<td colspan="4">
				<table>
					<tr>
						<td width="130"><cf_get_lang no='610.Eczane Ad??'></td>
						<td width="175">: <input type="hidden" name="company_name" id="company_name" value="<cfoutput>#get_related.fullname#</cfoutput>"><cfoutput>#get_related.fullname#</cfoutput></td>
						<td width="120"><cf_get_lang no='611.Eczac?? Ad?? Soyad??'></td>
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
						<td><cf_get_lang_main no='1196.??l'></td>
						<td>: <cfoutput>#get_related.city_name#</cfoutput></td>
						<td><cf_get_lang no='614.????yeri No'></td>
						<td>: <cfoutput>#get_related.dukkan_no#</cfoutput></td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='1226.??l??e'></td>
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
						<td valign="top" nowrap><cf_get_lang no='616.??li??kili ??ubeler'><br/><cf_get_lang_main no='344.Durum'></td>
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
						<td valign="top"><cf_get_lang no='617.??al????t?????? Rakipler'><br/><cf_get_lang no='618.Tercih Nedenleri'></td>
						<td valign="top">
							<cfoutput query="get_company_rival_info">
								<cfquery name="GET_OPTIONS" datasource="#DSN#">
									SELECT 
										SETUP_RIVAL_PREFERENCE_REASONS.PREFERENCE_REASON
									FROM 
										COMPANY_RIVAL_OPTION_APPLY,
										SETUP_RIVAL_PREFERENCE_REASONS
									WHERE  
										COMPANY_RIVAL_OPTION_APPLY.COMPANY_ID = #attributes.company_id# AND 
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
				<td width="130"><cf_get_lang no='35.M????teri Tipi'> *</td>
				<td width="175">
					<select name="target_customer_type" id="target_customer_type" style="width:120px;" onChange="page_load('2');">
					<option value=""><cf_get_lang_main no='322.Se??iniz'></option>
					<cfoutput query="get_customer_type">
						<option value="#customer_type_id#">#customer_type#</option>
					</cfoutput>
					</select>				
				</td>
				<td width="120"><cf_get_lang_main no='41.Sube'> *</td>
				<td>
					<select name="branch_id" id="branch_id" style="width:115px;" onChange="page_load('1');"><!--- degistir();page_load('1'); --->
                        <option value=""><cf_get_lang_main no='322.Se??iniz'></option>
                        <cfoutput query="get_branch">
                            <option value="#branch_id#,#related_id#">#branch_name#</option>
                        </cfoutput>
					</select>					
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no="1447.S??re??"> *</td>
				<td><cf_workcube_process is_upd='0'	process_cat_width='120' is_detail='0'></td>
				<td><cf_get_lang no='775.Anla??ma Tarihi'> *</td>
				<td><input type="text" name="contract_date" id="contract_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>" readonly maxlength="10" style="width:115px"></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='641.Ba??lang???? Tarihi'> *</td>
				<td>	
					<cfsavecontent variable="message"><cf_get_lang_main no ='326.Ba??lang???? Tarihi Girmelisiniz'> !</cfsavecontent>			
					<cfinput type="text" name="start_date" maxlength="10" validate="#validate_style#" message="#message#" style="width:120px">
					<cf_wrk_date_image date_field="start_date">					
				</td>
				<td><cf_get_lang_main no='288.Biti?? Tarihi'> *</td>
				<td>
					<cfsavecontent variable="message1"><cf_get_lang_main no ='327.Biti?? Tarihi Girmelisiniz'> !</cfsavecontent>
					<cfinput type="text" name="finish_date" maxlength="10" validate="#validate_style#" message="#message1#" style="width:115px">
					<cf_wrk_date_image date_field="finish_date">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no ='848.Mak Anla??ma Mas Oran??'></td>
				<td><input type="text" name="restrict_rate" id="restrict_rate" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:120px;"></td>
				<td><cf_get_lang no ='849.Ciro Kontrol Y??ntemi'> *</td>
				<td>
					<select name="control_method" id="control_method" style="width:115px;">
					<option value=""><cf_get_lang_main no='322.Se??iniz'></option>
						<option value="1"><cf_get_lang no ='850.KDV Beyannamesi'></option>
						<option value="2"><cf_get_lang no ='851.Re??ete Tutar??'></option>
					</select>				
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no ='852.Ayl??k Al??m Kapasitesi'> *</td>
				<td><input type="text" name="monthly_capacity" id="monthly_capacity" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:120px;"></td>
				<td><cf_get_lang no ='853.Hedeflenen Ayl??k Ciro'> *</td>
				<td><input type="text" name="monthly_endorsement" id="monthly_endorsement" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:115px;"></td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang no='35.M????teri Tipi'> <cf_get_lang_main no='217.A????klama'></td>
				<td colspan="3"><textarea style="width:95%;height:30;" name="customer_type_detail" id="customer_type_detail" readonly></textarea></td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no='217.A????klama'></td>
				<td colspan="3"><textarea style="width:95%;height:50;" name="detail" id="detail"></textarea></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="3"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
			</tr>
			<tr class="color-row" id="_show_branch_contract_information_">
				<td colspan="4"><div id="show_branch_contract_information"></div></td>
			</tr>
		</cfform>
		</table>
		</td>
		<td>
			<table cellspacing="1" cellpadding="2" width="100%" height="100%" class="color-border">
				<tr class="color-header" height="20">
					<td class="form-title" width="100%"><cf_get_lang_main no='568.Genel Bilgiler'></td>
				</tr>
				<tr class="color-row">
					<td><iframe scrolling="auto" width="100%" height="100%" frameborder="0" name="member_frame" id="member_frame" src="<cfoutput>#request.self#?fuseaction=crm.popup_dsp_risk_info&cpid=#attributes.company_id#&iframe=1&branch_id=#get_related_branch.branch_id#</cfoutput>"></iframe></td>
				</tr>
			</table>
		</td>
	</tr>
</table>						
<script type="text/javascript">

function kontrol()
{
	
	x = document.branch_contract.branch_id.selectedIndex;
	if (document.branch_contract.branch_id[x].value == "")
	{ 
		alert ("<cf_get_lang_main no='1167.L??tfen ??ube Se??iniz'> !");
		return false;
	}
	
	y = document.branch_contract.target_customer_type.selectedIndex;
	if (document.branch_contract.target_customer_type[y].value == "")
	{ 
		alert ("<cf_get_lang no ='854.L??tfen M????teri Tipi Se??iniz'> !");
		return false;
	}		
	
	if(document.branch_contract.start_date.value == "")
	{
		alert("<cf_get_lang_main no='326.Ba??lang???? Tarihi Girmelisiniz'>");
		return false;
	}

	if(document.branch_contract.finish_date.value == "")
	{
		alert("<cf_get_lang_main no='327.Biti?? Tarihi Girmelisiniz'> !");
		return false;
	}
	
	// Baslangic tarihinin bitis tarihinden buyuk olmasi durumunda uyari ver
	if(!date_check(document.branch_contract.start_date,document.branch_contract.finish_date,"<cf_get_lang_main no ='2326.Biti?? Tarihini Kontrol Ediniz'> !",1))
		return false;
	
	if(document.branch_contract.control_method.value == "")
	{
		alert("<cf_get_lang no ='856.Ciro Kontrol Y??ntemi Se??melisiniz'> !");
		return false;
	}
	
	if(document.branch_contract.monthly_capacity.value == "")
	{
		alert("<cf_get_lang no ='857.Eczane Ayl??k Al??m Kapasitesi De??erini Girmelisiniz'> !");
		return false;
	}	
		
	if(document.branch_contract.monthly_endorsement.value == "")
	{
		alert("<cf_get_lang no ='858.Eczane Hedeflenen Ayl??k Ciro De??erini Girmelisiniz'> !");
		return false;
	}	
			
	if(document.branch_contract.detail.value.length>1000)
	{
		alert("<cf_get_lang no ='859.A????klama 1000 Karakterden Fazla Olamaz'>!");
		return false;
	}
	
	is_control = document.branch_contract.is_control.value;
	control_rate = document.branch_contract.control_rate.value;
	value1 = filterNum(document.branch_contract.monthly_capacity.value);
	value2 = filterNum(document.branch_contract.monthly_endorsement.value);
	
	if(value2>value1)
	{
		alert("<cf_get_lang no ='860.Hedeflenen Ayl??k Ciro Degeri, Ayl??k Al??m Kapasitesinden B??y??k Olamaz'> !");
		return false;
	}	
		
	// Eger varsa musteri tipine bagl?? olarak hedeflenen aylik ciro kontrolu
	if(is_control == 1)
	{
		control_value = (value1/100)*control_rate;
		if(value2>control_value)
		{
			alert('<cf_get_lang no ="861.Hedeflenen Ayl??k Ciro Degerini Kontrol Ediniz">. %'+control_value +'<cf_get_lang no ="862.Degerini A??amaz">  !');
			return false;
		}
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
						alert("<cf_get_lang_main no ='1177.De??er Girmelisiniz'> !");
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
						alert("<cf_get_lang no ='863.Hedef D??nemi Se??iniz'> !");
						return false;
					}
					
					if(eval("document.branch_contract.target_amount"+r).value == '')
					{
						alert("<cf_get_lang no ='864.Hedef Tutar Girmelisiniz '>!");
						return false;
					}							
				}
			}
		}
	}
	else
	{
		alert("<cf_get_lang no ='865.??ubenin Anla??ma Bilgileri Girilmemi?? Kontrol Ediniz'> !");
		return false;
	}
	
	if(kontrol_row_count == 0)
	{
		alert("<cf_get_lang no ='866.En Az Bir Sat??r Anla??ma ????eri??i Giriniz '>!");
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
						alert("<cf_get_lang_main no ='1177.De??er Girmelisiniz'> ");
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
						alert("<cf_get_lang no ='863.Hedef D??nemi Se??iniz'>!");
						return false;
					}
					
					if(eval("document.branch_contract.target_amount_"+r).value == '')
					{
						alert("<cf_get_lang no ='864.Hedef Tutar Girmelisiniz '>!");
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
		}
				
		document.branch_contract.restrict_rate.value = filterNum(document.branch_contract.restrict_rate.value);
		document.branch_contract.monthly_capacity.value = filterNum(document.branch_contract.monthly_capacity.value);
		document.branch_contract.monthly_endorsement.value = filterNum(document.branch_contract.monthly_endorsement.value);
	}
	else
		return false;
}

/*function degistir()
{
	deger_branch_id_ilk = "";
	if(document.branch_contract.branch_id.value != "")
		deger_branch_id_ilk = list_getat(document.branch_contract.branch_id.value,1,',');
	document.member_frame.location.href='<cfoutput>#request.self#?fuseaction=crm.popup_dsp_risk_info&cpid=#attributes.company_id#&iframe=1</cfoutput>&branch_id=' + deger_branch_id_ilk;
}

function window_duty_type(category)
{
	if(category == 0)
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_duty_type&is_category=0&customer_type_id=' + document.branch_contract.target_customer_type.value,'list','popup_list_duty_type');
	else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_duty_type&is_category=1&customer_type_id=' + document.branch_contract.target_customer_type.value,'list','popup_list_duty_type');
}		
*/

function page_load(type)
{
	if(type==1)
	{
		if(document.branch_contract.branch_id.value != "")
		{
			goster(_show_branch_contract_information_);
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=crm.ajax_popup_view_branch_contract_information&related_id='+list_getat(document.branch_contract.branch_id.value,2)+'','show_branch_contract_information'</cfoutput>,1);
		}
		else
			gizle(_show_branch_contract_information_);
	}
	else
	{
		if(document.branch_contract.branch_id.value != "" && document.branch_contract.target_customer_type.value != "")
		{
			goster(_show_branch_contract_information_);
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=crm.ajax_popup_view_branch_contract_information&related_id='+list_getat(document.branch_contract.branch_id.value,2)+'&target_customer_type='+document.branch_contract.target_customer_type.value+'','show_branch_contract_information'</cfoutput>,1);
		}
		else
			gizle(_show_branch_contract_information_);	
	}
}
</script>

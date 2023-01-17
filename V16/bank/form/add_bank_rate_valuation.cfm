<cf_xml_page_edit fuseact="bank.form_add_bank_rate_valuation">
<!---select ifadeleri düzenlendi 23.07.2012 e.a--->
<cf_get_lang_set module_name="bank">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.acc_currency_id" default="">
<cfparam name="attributes.acc_status" default="1">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.bank_name" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.action_date" default="#dateformat(now(),dateformat_style)#">
<cf_date tarih="attributes.action_date">
	<cfif isDefined("attributes.startdate") and len(attributes.startdate)><cf_date tarih="attributes.startdate"></cfif>
	<cfif isDefined("attributes.finishdate") and len(attributes.finishdate)><cf_date tarih="attributes.finishdate"></cfif>
	<cfset curr_date = ( len(attributes.finishdate) ? attributes.finishdate : attributes.action_date ) >
	
	<cfquery name="get_money_rate" datasource="#dsn#"> <!--- SETUP_MONEY yerine MONEY_HISTORY'den alıyorum. excele alırken js çalışmadığından tarihi ne yollarsan yolla kurlar değişmediğinden bugüne göre getiriyordu Durgan20150515 --->
		SELECT MONEY,RATE1,RATE2,0 AS IS_SELECTED,RATE3,EFFECTIVE_SALE,EFFECTIVE_PUR 
			FROM MONEY_HISTORY WHERE MONEY_HISTORY_ID IN(SELECT MAX(MONEY_HISTORY_ID) 
			FROM MONEY_HISTORY WHERE COMPANY_ID= #session.ep.company_id# 
		AND PERIOD_ID=#session.ep.period_id# AND VALIDATE_DATE = #curr_date# GROUP BY MONEY)
	</cfquery>
<cfif get_money_rate.recordcount eq 0>
	<cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
    	SELECT MONEY,RATE1,RATE2,RATE3,ISNULL(EFFECTIVE_SALE,0) AS EFFECTIVE_SALE,ISNULL(EFFECTIVE_PUR,0) AS EFFECTIVE_PUR FROM SETUP_MONEY WHERE MONEY_STATUS = 1 AND MONEY <> '#session.ep.money#' ORDER BY MONEY_ID
    </cfquery>
</cfif>
<cfinclude template="../query/get_branches.cfm">
<cfinclude template="../query/get_banks.cfm">
<cfif isdefined("attributes.form_submitted")>

	<cfquery name="get_bank" datasource="#dsn2#">
		SELECT
			ACCOUNT_ID,
			ACCOUNT_NAME,
			ACCOUNT_ACC_CODE,
			OTHER_MONEY,
			SUM(BORC) BORC,
			SUM(ALACAK) ALACAK,
			SUM(BORC-ALACAK) BAKIYE,
			SUM(BORC3) BORC3,
			SUM(ALACAK3) ALACAK3,
			SUM(BORC3-ALACAK3) BAKIYE3
		FROM
		(
			SELECT 
				ACCOUNTS.ACCOUNT_ID,
				ACCOUNTS.ACCOUNT_NAME,
				ACCOUNTS.ACCOUNT_ACC_CODE,
				0 BORC,
				0 BORC3,
				ISNULL(SUM(ROUND(SYSTEM_ACTION_VALUE,2)),0) ALACAK,
				ISNULL(SUM(ROUND(ACTION_VALUE,2)),0) ALACAK3,
				BANK_ACTIONS.ACTION_CURRENCY_ID OTHER_MONEY
			FROM
				#dsn3_alias#.ACCOUNTS ACCOUNTS,
				BANK_ACTIONS
			WHERE
				ACCOUNTS.ACCOUNT_ID=BANK_ACTIONS.ACTION_FROM_ACCOUNT_ID
				AND ACCOUNTS.ACCOUNT_CURRENCY_ID <> '#session.ep.money#'
				AND BANK_ACTIONS.ACTION_CURRENCY_ID <> '#session.ep.money#'
				<cfif isDefined("attributes.bank_name") and len(attributes.bank_name)>
					AND ACCOUNTS.ACCOUNT_BRANCH_ID IN(SELECT BB.BANK_BRANCH_ID FROM #dsn3_alias#.BANK_BRANCH BB WHERE BB.BANK_NAME='#attributes.bank_name#')
				</cfif>
				<cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
					AND ACCOUNTS.ACCOUNT_BRANCH_ID=#attributes.branch_id#
				</cfif>
				<cfif (isDefined("attributes.acc_status") and len(attributes.acc_status))>
					AND ACCOUNTS.ACCOUNT_STATUS = #attributes.acc_status# 
				</cfif>
				<cfif isDefined("attributes.acc_currency_id") and len(attributes.acc_currency_id)>
					AND ACCOUNTS.ACCOUNT_CURRENCY_ID='#attributes.acc_currency_id#'
				</cfif>
				<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
					AND BANK_ACTIONS.ACTION_DATE <= #attributes.finishdate#
				</cfif>	
				<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
					AND BANK_ACTIONS.ACTION_DATE >= #attributes.startdate#
				</cfif>
			GROUP BY
				ACCOUNTS.ACCOUNT_ID,
				ACCOUNTS.ACCOUNT_NAME,
				ACCOUNTS.ACCOUNT_ACC_CODE,
				BANK_ACTIONS.ACTION_CURRENCY_ID
		UNION ALL
			SELECT 
				ACCOUNTS.ACCOUNT_ID,
				ACCOUNTS.ACCOUNT_NAME,
				ACCOUNTS.ACCOUNT_ACC_CODE,
				ISNULL(SUM(ROUND(SYSTEM_ACTION_VALUE,2)),0) BORC,
				ISNULL(SUM(ROUND(ACTION_VALUE,2)),0) BORC3,
				0 ALACAK,
				0 ALACAK3,
				BANK_ACTIONS.ACTION_CURRENCY_ID OTHER_MONEY
			FROM
				#dsn3_alias#.ACCOUNTS ACCOUNTS,
				BANK_ACTIONS
			WHERE
				ACCOUNTS.ACCOUNT_ID=BANK_ACTIONS.ACTION_TO_ACCOUNT_ID
				AND ACCOUNTS.ACCOUNT_CURRENCY_ID <> '#session.ep.money#'
				AND BANK_ACTIONS.ACTION_CURRENCY_ID <> '#session.ep.money#'
				<cfif isDefined("attributes.bank_name") and len(attributes.bank_name)>
					AND ACCOUNTS.ACCOUNT_BRANCH_ID IN(SELECT BB.BANK_BRANCH_ID FROM #dsn3_alias#.BANK_BRANCH BB WHERE BB.BANK_NAME='#attributes.bank_name#')
				</cfif>
				<cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
					AND ACCOUNTS.ACCOUNT_BRANCH_ID=#attributes.branch_id#
				</cfif>
				<cfif (isDefined("attributes.acc_status") and len(attributes.acc_status))>
					AND ACCOUNTS.ACCOUNT_STATUS = #attributes.acc_status# 
				</cfif>
				<cfif isDefined("attributes.acc_currency_id") and len(attributes.acc_currency_id)>
					AND ACCOUNTS.ACCOUNT_CURRENCY_ID='#attributes.acc_currency_id#'
				</cfif>
				<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
					AND BANK_ACTIONS.ACTION_DATE <= #attributes.finishdate#
				</cfif>	
				<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
					AND BANK_ACTIONS.ACTION_DATE >= #attributes.startdate#
				</cfif>
			GROUP BY
				ACCOUNTS.ACCOUNT_ID,
				ACCOUNTS.ACCOUNT_NAME,
				ACCOUNTS.ACCOUNT_ACC_CODE,
				BANK_ACTIONS.ACTION_CURRENCY_ID
		)T1
		GROUP BY
			ACCOUNT_ID,
			ACCOUNT_NAME,
			ACCOUNT_ACC_CODE,
			OTHER_MONEY
	</cfquery>
<cfelse>
	<cfset get_bank.recordcount = 0>
</cfif>
<cfif attributes.is_excel neq 1>
	<cf_catalystHeader> 
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	 <cf_box>
		<cfform name="add_rate_valuation" id="add_rate_valuation" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bank_rate_valuation">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cfoutput query="get_money_rate">
				<cfif isdefined("xml_money_type") and xml_money_type eq 0>
					<cfset "rate_#money#" = rate2>
				<cfelseif isdefined("xml_money_type") and xml_money_type eq 1>
					<cfset "rate_#money#" = rate3>
				<cfelseif isdefined("xml_money_type") and xml_money_type eq 2>
					<cfset "rate_#money#" = rate2>
				<cfelseif isdefined("xml_money_type") and xml_money_type eq 3>
					<cfset "rate_#money#" = EFFECTIVE_PUR>
				<cfelseif isdefined("xml_money_type") and xml_money_type eq 4>
					<cfset "rate_#money#" = EFFECTIVE_SALE>
				</cfif>	
			</cfoutput>
			<cfoutput query="get_money_rate">
				<input type="hidden" class="box" name="excel_rate2_#money#" id="excel_rate2_#money#" value="#tlformat(evaluate('rate_#money#'),session.ep.our_company_info.rate_round_num)#">
			</cfoutput>
			<cf_box_elements>
				<div class="col col-4 col-md-8 col-sm-12" type="column" sort="true" index="1">
					<div class="form-group" id="item-bank_name">	
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57521.Banka'></label>
						<div class="col col-9 col-xs-12">
							<select name="bank_name" id="bank_name" >
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_banks">
									<option value="#bank_name#" <cfif attributes.bank_name eq bank_name>selected</cfif>>#bank_name#</option>
								</cfoutput>
							</select>      
						</div>
					</div>
					<div class="form-group" id="item-branch_id">	
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-9 col-xs-12">
							<select name="branch_id" id="branch_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_branches">
									<option <cfif isdefined('attributes.branch_id') and attributes.branch_id eq BANK_BRANCH_ID> Selected </cfif> value="#BANK_BRANCH_ID#">#BANK_BRANCH_NAME#</option>
								</cfoutput>
							</select>  
						</div>
					</div>       
				</div>
				<div class="col col-4 col-md-8 col-sm-12" type="column" sort="true" index="2">
					<div class="form-group" id="item-acc_currency_id">	
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57489.Para Birimi'></label>
						<div class="col col-9 col-xs-12">
							<select name="acc_currency_id" id="acc_currency_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_money_rate">
									<option value="#money#" <cfif attributes.acc_currency_id eq money>selected</cfif>>#money#</option>
								</cfoutput>
							</select>	                            
						</div>
					</div>
					<div class="form-group" id="item-acc_status">	
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
						<div class="col col-9 col-xs-12">
							<select name="acc_status" id="acc_status">
								<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
								<option value="1"<cfif isDefined("attributes.acc_status") and (attributes.acc_status eq 1)> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
								<option value="0"<cfif isDefined("attributes.acc_status") and (attributes.acc_status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
							</select>                        
						</div>
					</div>       
				</div>            
				<div class="col col-4 col-md-8 col-sm-12" type="column" sort="true" index="3">
					<div class="form-group" id="item-startdate">	
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
						<div class="col col-9 col-xs-12">
							<div class="input-group ">
								<!---<cfsavecontent variable="alert"><cf_get_lang_main no='1354.Başlangıç Tarihi Hatali'></cfsavecontent>--->
								<cfinput type="text" name="startdate" id="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
							</div>
						</div>       
					</div>  
					<div class="form-group" id="item-finishdate">	
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
						<div class="col col-9 col-xs-12">
							<div class="input-group ">      
								<!---<cfsavecontent variable="alert"><cf_get_lang_main no='1355.Bitiş Tarihi Hatali'></cfsavecontent>--->
								<cfinput type="text" name="finishdate" id="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
							</div> 	                            
						</div>
					</div>
				</div>
			</cf_box_elements>           
			<cf_box_footer>
				<div class="col col-12 text-right">
					<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
					<cf_wrk_search_button button_type='1' is_excel='0' search_function='kontrol()' no_show_process='1'>
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset filename = "#createuuid()#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-8">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	</cfif>
	<cfif isdefined("attributes.form_submitted") and get_bank.recordcount>
		<cfform name="add_rate_valuation_1" id="add_rate_valuation_1" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_bank_rate_valuation">
			<cf_box title="#getLang('','Banka Hesapları',59002)#" uidrop="1" hide_table_column="1">
				<!--- <cf_basket id="add_due_bask"> --->
					<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
					<input type="hidden" name="total_record" id="total_record" value="<cfoutput>#get_bank.recordcount#</cfoutput>">
					<cf_grid_list class="detail_basket_list">
						<thead>
							<tr>
								<th width="35" rowspan="2" class="text-center"><cf_get_lang dictionary_id='57487.No'></th>
								<th width="250" rowspan="2"><cf_get_lang dictionary_id='57652.Hesap'></th>
								<th colspan="3" class="text-center"><cf_get_lang dictionary_id='58905.Sistem Dövizi'></th>
								<th colspan="4" class="text-center"><cf_get_lang dictionary_id='58121.İşlem Dövizi'></th>
								<th class="text-center" colspan="<cfif not(isdefined('attributes.is_excel') and attributes.is_excel eq 1)>3<cfelse>2</cfif>" align="center"><cf_get_lang no='116.Değerleme'></th>
							</tr>
							<tr class="color-header" height="20">
								<th width="90"><cf_get_lang dictionary_id='57587.Borç'></th>
								<th width="90"><cf_get_lang dictionary_id='57588.Alacak'></th>
								<th width="90"><cf_get_lang dictionary_id='57589.Bakiye'></th>
								<th width="90"><cf_get_lang dictionary_id='57587.Borç'></th>
								<th width="90"><cf_get_lang dictionary_id='57588.Alacak'></th>
								<th width="90" ><cf_get_lang dictionary_id='57589.Bakiye'></th>
								<th width="70"><cf_get_lang dictionary_id='58121.İşlem Dövizi'></th>
								<th width="90"><cfoutput>#session.ep.money#</cfoutput><cf_get_lang dictionary_id='48778.Karşılık'> </th>
								<th width="90"><cf_get_lang dictionary_id='57884.Kur Farkı'></th>
								<cfif not(isdefined('attributes.is_excel') and attributes.is_excel eq 1)>	
									<th width="35" class="text-center"></th>
								</cfif>
							</tr>
						</thead>
						<tbody>
						<cfscript>
							count_row = 0;
							total_1 = 0;
							total_2 = 0;
							total_3 = 0;
						</cfscript>
						<cfoutput query="get_bank">
							<cfset count_row = count_row + 1>
							<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
								<td class="text-center">#currentrow#</td>
								<td>#account_name#</td>
								<td class="text-right">#TLFormat(abs(borc))#<cfset total_1 = total_1 + borc></td>
								<td class="text-right">#TLFormat(abs(alacak))#<cfset total_2 = total_2 + alacak></td>
								<td class="text-right">#TLFormat(abs(bakiye))# <cfif bakiye gt 0>(B)<cfelse>(A)</cfif></td>
								<td class="text-right">#TLFormat(abs(borc3))#</td>
								<td class="text-right">#TLFormat(abs(alacak3))#</td>
								<td class="text-right">#TLFormat(abs(bakiye3))# <cfif bakiye3 gt 0>(B)<cfelse>(A)</cfif></td>
								<td nowrap>#other_money#</td>
								<input type="hidden" name="acc_id_#currentrow#" id="acc_id_#currentrow#" value="#account_id#">
								<input type="hidden" name="account_code_#currentrow#" id="account_code_#currentrow#" value="#account_acc_code#">
								<input type="hidden" name="bakiye_#currentrow#" id="bakiye_#currentrow#" value="#wrk_round(bakiye)#">
								<input type="hidden" name="bakiye3_#currentrow#" id="bakiye3_#currentrow#" value="#abs(wrk_round(bakiye3))#">
								<input type="hidden" name="bakiye3_1_#currentrow#" id="bakiye3_1_#currentrow#" value="#wrk_round(bakiye3)#">
								<input type="hidden" name="other_money_#currentrow#" id="other_money_#currentrow#" value="#other_money#">
								<cfset total_3 = total_3 + evaluate('rate_#other_money#')*abs(bakiye3)>
								<td class="text-right">
									<cfif not(isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
										<input type="text" name="control_amount_#currentrow#" id="control_amount_#currentrow#" value="#tlformat(evaluate('rate_#other_money#')*abs(bakiye3))#" class="box" readonly style="width:70px;">
									<cfelse>
										#tlformat(filterNum(evaluate('excel_rate2_#other_money#'),4)*abs(bakiye3))#
									</cfif>
								</td>
								<td class="text-right">
									<cfif not(isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
										<input type="text" name="control_amount_2_#currentrow#" id="control_amount_2_#currentrow#" value="#tlformat((evaluate('rate_#other_money#')*wrk_round(bakiye3))-wrk_round(bakiye))#" class="box" readonly style="width:70px;">
									<cfelse>
										#tlformat((filterNum(evaluate('excel_rate2_#other_money#'),4)*wrk_round(bakiye3))-wrk_round(bakiye))#
									</cfif>
								</td>
								<td align="center">
									<cfif not(isdefined('attributes.is_excel') and attributes.is_excel eq 1)>	
										<input type="checkbox" name="is_pay_#currentrow#" id="is_pay_#currentrow#" value="#account_id#" onClick="check_kontrol(this);" <cfif isdefined("is_pay_#currentrow#")>checked</cfif><cfif wrk_round(((evaluate('rate_#other_money#')*bakiye3)-bakiye),2) eq 0>disabled</cfif>>
									</cfif>		
								</td>				
							</tr>
						</cfoutput>
						<cfoutput>
							<tr class="color-row">
								<td></td>
								<td  class="txtboldblue">#getLang('','Toplam','57492')#</td>
								<td class="txtboldblue text-right" >#TLFormat(abs(total_1))#</td>
								<td class="txtboldblue text-right">#TLFormat(abs(total_2))#</td>
								<td class="txtboldblue text-right">#TLFormat(abs(total_1-total_2))# <cfif (total_1-total_2) gt 0>(B)<cfelse>(A)</cfif></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td class="txtboldblue text-right">
									<cfif not(isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
										<input type="text" name="total_amount" id="total_amount" value="#TLFormat(abs(total_3))#" class="box" readonly="readonly" style="width:70px;">
									<cfelse>
										#TLFormat(abs(total_3))#
									</cfif>
								</td>
								<td></td>
								<td></td>
							</tr>
						</cfoutput>
						<input type="hidden" name="count_row" id="count_row" value="<cfoutput>#count_row#</cfoutput>">
						</tbody>
					</cf_grid_list>
				<!--- </cf_basket> --->
			</cf_box>
			<cf_box>
				<cfif not(isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
					<!--- <cf_basket_footer height="185"> ---><cfinclude template="add_bank_rate_valuation_1.cfm"><!--- </cf_basket_footer> --->
				</cfif>
			</cf_box>
		</cfform>
	</cfif>
</div>
<script type="text/javascript">
	var control_checked = 0;
	function kontrol()
	{
		if(document.add_rate_valuation.is_excel.checked==false)
		{
			document.add_rate_valuation.action="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bank_rate_valuation</cfoutput>";
			return true;
		}
		else
			document.add_rate_valuation.action="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_form_add_bank_rate_valuation</cfoutput>";
		return true;
	}
	function kontrol_form_2()
	{
		if(!chk_process_cat('add_rate_valuation_1')) return false;
		if(!check_display_files('add_rate_valuation_1')) return false;
		if(!chk_period(add_rate_valuation_1.action_date,'İşlem')) return false;
		bank_id_list_1='';
		bank_id_list_2='';
		for(j=1;j<=<cfoutput>#get_bank.recordcount#</cfoutput>;j++)
		{
			if(document.getElementById("other_money_"+j) != undefined && document.getElementById("is_pay_"+j).checked == true)
			{
				if(filterNum(eval('document.add_rate_valuation_1.control_amount_2_'+j).value) > 0)
					bank_id_list_1+=eval('document.add_rate_valuation_1.control_amount_2_'+j).value;
				else if(filterNum(eval('document.add_rate_valuation_1.control_amount_2_'+j).value) < 0)
					bank_id_list_2+=eval('document.add_rate_valuation_1.control_amount_2_'+j).value;
			}
		}
		if(bank_id_list_1 != '' && bank_id_list_2 != '')
		{
			alert('<cfoutput>#getLang('ch',17)#</cfoutput>');
			return false;
		}
		if(bank_id_list_1 == '' && bank_id_list_2 == '')
		{
			alert('<cfoutput>#getLang('bank',425)#</cfoutput>');
			return false;
		}
		process=document.add_rate_valuation_1.process_cat.value;
		var get_process_cat = wrk_safe_query('bnk_get_process_cat','dsn3',0,process);
		if(get_process_cat.IS_ACCOUNT == 1)
		{
			if(document.add_rate_valuation_1.action_account_code.value == "")
			{ 
				alert('<cfoutput>#getLang('finance',532)#</cfoutput>');
				return false;
			}
		}
		<cfif isdefined('xml_acc_department_info') and xml_acc_department_info eq 2> //xmlde muhasebe icin departman secimi zorunlu ise
			if( document.add_rate_valuation_1.acc_department_id.options[document.add_rate_valuation_1.acc_department_id.selectedIndex].value=='')
			{
				alert('<cfoutput>#getLang('ehesap',254)#</cfoutput>');
				return false;
			} 
		</cfif>
		return true;
	}
	function hepsi_view()
	{
		for(j=1;j<=<cfoutput>#get_bank.recordcount#</cfoutput>;j++)
		{
			if(document.getElementById("other_money_"+j) != undefined)
			{
				document.getElementById('is_pay_'+j).checked = false;
				control_checked--;
			}
		}
	}
	function check_kontrol(nesne)
	{
		if(nesne.checked)
			control_checked++;
		else
			control_checked--;
	}
	function toplam_hesapla()
	{
		for(s=1; s<=document.getElementById("kur_say").value; s++)
		{
			money_deger = document.getElementById("hidden_rd_money_"+s).value;
			document.getElementById("txt_rate2_1_"+money_deger).value = document.getElementById("txt_rate2_"+s).value;
			/*excel icin kur farki atanir */
			document.getElementById("excel_rate2_"+money_deger).value = document.getElementById("txt_rate2_"+s).value;
		}
		total_amount = 0;
		for(j=1;j<=<cfoutput>#get_bank.recordcount#</cfoutput>;j++)
		{
			if(document.getElementById("other_money_"+j) != undefined)
			{
				
				row_money = document.getElementById("other_money_"+j).value;
				document.getElementById("control_amount_"+j).value = commaSplit(document.getElementById("bakiye3_"+j).value*filterNum(document.getElementById("txt_rate2_1_"+row_money).value,4),2);
				total_amount = parseFloat(total_amount + parseFloat(document.getElementById("bakiye3_"+j).value*filterNum(document.getElementById("txt_rate2_1_"+row_money).value,4)));
				document.getElementById("control_amount_2_"+j).value =  commaSplit((document.getElementById("bakiye3_1_"+j).value*filterNum(document.getElementById("txt_rate2_1_"+row_money).value,4))-document.getElementById("bakiye_"+j).value)
				if(filterNum(document.getElementById("control_amount_2_"+j).value) == 0)
				{
					document.getElementById("is_pay_"+j).disabled = true;
				}
				else
				{
					document.getElementById("is_pay_"+j).disabled = false;
				}	
			}
		}
		document.add_rate_valuation_1.total_amount.value = commaSplit(total_amount);
	}
	function check_currency(type)
	{
		if(type == 1 && document.getElementById('is_minus_currency').checked == true)
		{
			document.getElementById('is_plus_currency').checked=false;
			for(j=1;j<=<cfoutput>#get_bank.recordcount#</cfoutput>;j++)
			{
				if(document.getElementById('other_money_'+j) != undefined)
				{
					if(parseFloat(filterNum(document.getElementById('control_amount_2_'+j).value)) <0)
						document.getElementById('is_pay_'+j).checked = true;
					else
						document.getElementById('is_pay_'+j).checked = false;
					
				}
			}
		}
		else if(type == 2 && document.getElementById('is_plus_currency').checked == true)
		{
			document.getElementById('is_minus_currency').checked=false;			
			for(j=1;j<=<cfoutput>#get_bank.recordcount#</cfoutput>;j++)
			{
				if(document.getElementById('other_money_'+j) != undefined)
				{
					if(parseFloat(filterNum(document.getElementById('control_amount_2_'+j).value)) >0)
						document.getElementById('is_pay_'+j).checked = true;
					else
						document.getElementById('is_pay_'+j).checked = false;
				}
			}
		}
		else
			hepsi_view();
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

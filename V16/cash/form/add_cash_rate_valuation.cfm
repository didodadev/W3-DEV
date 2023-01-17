<cf_get_lang_set module_name="cash">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.cash_currency_id" default="">
<cfparam name="attributes.cash_status" default="1">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.action_date" default="#dateformat(now(),dateformat_style)#">
<cf_date tarih="attributes.action_date">
<cfquery name="get_money_rate" datasource="#dsn#"> <!--- SETUP_MONEY yerine MONEY_HISTORY'den alıyorum. excele alırken js çalışmadığından tarihi ne yollarsan yolla kurlar değişmediğinden bugüne göre getiriyordu Durgan20150515 --->
	<!---SELECT MONEY,RATE1,RATE2,0 AS IS_SELECTED,RATE3,EFFECTIVE_SALE,EFFECTIVE_PUR FROM MONEY_HISTORY WHERE MONEY_HISTORY_ID IN(SELECT MAX(MONEY_HISTORY_ID) FROM MONEY_HISTORY WHERE COMPANY_ID=#session.ep.company_id# AND PERIOD_ID=#session.ep.period_id# AND VALIDATE_DATE = #attributes.action_date# GROUP BY MONEY)--->
	SELECT MONEY,RATE1,RATE2,0 AS IS_SELECTED,RATE3,EFFECTIVE_SALE,EFFECTIVE_PUR FROM SETUP_MONEY WHERE COMPANY_ID=#session.ep.company_id# AND PERIOD_ID=#session.ep.period_id# 
</cfquery>
<cfif get_money_rate.recordcount eq 0>
	<cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
    	SELECT MONEY,RATE1,RATE2,RATE3,ISNULL(EFFECTIVE_SALE,0) AS EFFECTIVE_SALE,ISNULL(EFFECTIVE_PUR,0) AS EFFECTIVE_PUR FROM SETUP_MONEY WHERE MONEY_STATUS = 1 AND MONEY <> '#session.ep.money#' ORDER BY MONEY_ID
    </cfquery>
</cfif>
<cfinclude template="../query/get_com_branch.cfm">
<cfif isdefined("attributes.form_submitted")>
	<cfif isDefined("attributes.startdate") and len(attributes.startdate)><cf_date tarih="attributes.startdate"></cfif>
	<cfif isDefined("attributes.finishdate") and len(attributes.finishdate)><cf_date tarih="attributes.finishdate"></cfif>
	<cfquery name="get_cash" datasource="#dsn2#">
		SELECT
			CASH_ID,
			CASH_NAME,
			BRANCH_ID,
			CASH_ACC_CODE,
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
				CASH.CASH_ID,
				CASH.CASH_NAME,
				CASH.BRANCH_ID,
				CASH.CASH_ACC_CODE,
				0 BORC,
				0 BORC3,
				SUM(ACTION_VALUE) ALACAK,
				SUM(CASH_ACTION_VALUE) ALACAK3,
				CASH_ACTIONS.CASH_ACTION_CURRENCY_ID OTHER_MONEY
			FROM
				CASH,
				CASH_ACTIONS
			WHERE
				CASH.CASH_ID=CASH_ACTIONS.CASH_ACTION_FROM_CASH_ID
				AND CASH.CASH_CURRENCY_ID <> '#session.ep.money#'
				AND CASH_ACTIONS.CASH_ACTION_CURRENCY_ID <> '#session.ep.money#'
				<cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
					AND CASH.BRANCH_ID=#attributes.branch_id#
				</cfif>
				<cfif (isDefined("attributes.cash_status") and len(attributes.cash_status))>
					AND CASH.CASH_STATUS = #attributes.cash_status# 
				</cfif>
				<cfif isDefined("attributes.cash_currency_id") and len(attributes.cash_currency_id)>
					AND CASH.CASH_CURRENCY_ID='#attributes.cash_currency_id#'
				</cfif>
				<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
					AND CASH_ACTIONS.ACTION_DATE <= #attributes.finishdate#
				</cfif>	
				<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
					AND CASH_ACTIONS.ACTION_DATE >= #attributes.startdate#
				</cfif>
			GROUP BY
				CASH.CASH_ID,
				CASH.CASH_NAME,
				CASH.BRANCH_ID,
				CASH.CASH_ACC_CODE,
				CASH_ACTIONS.CASH_ACTION_CURRENCY_ID
		UNION ALL
			SELECT 
				CASH.CASH_ID,
				CASH.CASH_NAME,
				CASH.BRANCH_ID,
				CASH.CASH_ACC_CODE,
				SUM(ACTION_VALUE) BORC,
				SUM(CASH_ACTION_VALUE) BORC3,
				0 ALACAK,
				0 ALACAK3,
				CASH_ACTIONS.CASH_ACTION_CURRENCY_ID OTHER_MONEY
			FROM
				CASH,
				CASH_ACTIONS
			WHERE
				CASH.CASH_ID=CASH_ACTIONS.CASH_ACTION_TO_CASH_ID
				AND CASH.CASH_CURRENCY_ID <> '#session.ep.money#'
				AND CASH_ACTIONS.CASH_ACTION_CURRENCY_ID <> '#session.ep.money#'
				<cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
					AND CASH.BRANCH_ID=#attributes.branch_id#
				</cfif>
				<cfif (isDefined("attributes.cash_status") and len(attributes.cash_status))>
					AND CASH.CASH_STATUS = #attributes.cash_status# 
				</cfif>
				<cfif isDefined("attributes.cash_currency_id") and len(attributes.cash_currency_id)>
					AND CASH.CASH_CURRENCY_ID='#attributes.cash_currency_id#'
				</cfif>
				<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
					AND CASH_ACTIONS.ACTION_DATE <= #attributes.finishdate#
				</cfif>	
				<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
					AND CASH_ACTIONS.ACTION_DATE >= #attributes.startdate#
				</cfif>
			GROUP BY
				CASH.CASH_ID,
				CASH.CASH_NAME,
				CASH.BRANCH_ID,
				CASH.CASH_ACC_CODE,
				CASH_ACTIONS.CASH_ACTION_CURRENCY_ID
		)T1
		GROUP BY
			CASH_ID,
			CASH_NAME,
			BRANCH_ID,
			CASH_ACC_CODE,
			OTHER_MONEY
	</cfquery>
<cfelse>
	<cfset get_cash.recordcount = 0>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_rate_valuation" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_rate_valuation">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_elements id="add_due">
					<cf_box_search plus="0">
						<div class="form-group medium">
								<select name="branch_id" id="branch_id" style="width:150px;">
									<option value=""><cf_get_lang_main no='41.Şube'></option>
									<cfoutput query="get_com_branch_">
										<option value="#branch_id#" <cfif attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
									</cfoutput>
								</select>
						</div>
						<div class="form-group medium">
								<select name="cash_currency_id" id="cash_currency_id">
									<option value=""><cf_get_lang_main no='77.Para Birimi'></option>
									<cfoutput query="get_money_rate">
										<option value="#money#" <cfif attributes.cash_currency_id eq money>selected</cfif>>#money#</option>
									</cfoutput>
								</select>
						</div>
						<div class="form-group medium">
								<select name="cash_status" id="cash_status" style="width:60px;">
									<option value="" selected><cf_get_lang_main no='344.Durum'></option>
									<option value="1"><cf_get_lang_main no='81.Aktif'></option>
									<option value="0"><cf_get_lang_main no='82.Pasif'></option>
								</select>
						</div>
						<div class="form-group">
							<div class="input-group">
								<cfsavecontent variable="alert"><cf_get_lang no ='333.Başlangıç Tarihini Doğru Giriniz'></cfsavecontent>
								<cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#alert#" style="width:65px;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<cfsavecontent variable="alert"><cf_get_lang no ='334.Bitiş Tarihini Doğru Giriniz'></cfsavecontent>
								<cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#alert#" style="width:65px;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
							</div>
						</div>
						<div class="form-group">
							<cf_wrk_search_button search_function='kontrol()' button_type="4">
						</div>
					</cf_box_search>
			</cf_box_elements>
		</cfform>
	</cf_box>
		<cfif isdefined("attributes.form_submitted") and get_cash.recordcount>
			<cfform name="add_rate_valuation_1" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_cash_rate_valuation">
				<cf_box title="#getLang('','',49724)#"  uidrop="1" hide_table_column="1">
					<!--- <cf_basket id="add_due_bask"> --->
						<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
						<input type="hidden" name="total_record" id="total_record" value="<cfoutput>#get_cash.recordcount#</cfoutput>">
						<cf_grid_list class="detail_basket_list">
							<thead>
								<tr>
									<th width="15" rowspan="2"><cf_get_lang_main no='75.No'></th>
									<th width="120" rowspan="2"><cf_get_lang_main no='108.Kasa'></th>
									<th colspan="3" align="center"><cf_get_lang_main no='1493.Sistem Dövizi'></th>
									<th colspan="4" align="center"><cf_get_lang_main no='709.İşlem Dövizi'></th>
									<th colspan="<cfif not attributes.fuseaction contains 'autoexcelpopuppage'>3<cfelse>2</cfif>" align="center"><cf_get_lang no='62.Değerleme'></th>
								</tr>
								<tr class="color-header" height="20">
									<th width="80"><cf_get_lang_main no='175.Borç'></th>
									<th width="80"><cf_get_lang_main no='176.Alacak'></th>
									<th width="80"><cf_get_lang_main no='177.Bakiye'></th>
									<th width="80"><cf_get_lang_main no='175.Borç'></th>
									<th width="80"><cf_get_lang_main no='176.Alacak'></th>
									<th width="80"><cf_get_lang_main no='177.Bakiye'></th>
									<th width="50"><cf_get_lang_main no='77.Para Birimi'></th>
									<th width="70"><cfoutput>#session.ep.money#</cfoutput><cf_get_lang no='66.Karşılık'> </th>
									<th width="70"><cf_get_lang_main no ='472.Kur Farkı'></th>
									<cfif not attributes.fuseaction contains 'autoexcelpopuppage'>	
										<th width="1%" align="center"></th>
									</cfif>
								</tr>
							</thead>
							<cfoutput query="get_money_rate">
								<cfset "rate_#money#" = rate2>
							</cfoutput>
							<cfscript>
								count_row = 0;
								total_1 = 0;
								total_2 = 0;
								total_3 = 0;
							</cfscript> 
							<tbody>
								<cfoutput query="get_cash">
									<cfset count_row = count_row + 1>
									<tr>
										<td>#currentrow#</td>
										<td>#cash_name#</td>
										<td>#TLFormat(abs(borc))#<cfset total_1 = total_1 + borc></td>
										<td>#TLFormat(abs(alacak))#<cfset total_2 = total_2 + alacak></td>
										<td>#TLFormat(abs(bakiye))# <cfif bakiye gt 0>(B)<cfelse>(A)</cfif></td>
										<td>#TLFormat(abs(borc3))#</td>
										<td>#TLFormat(abs(alacak3))#</td>
										<td>#TLFormat(abs(bakiye3))# <cfif bakiye3 gt 0>(B)<cfelse>(A)</cfif></td>
										<td nowrap>#other_money#</td>
										<input type="hidden" name="cash_id_#currentrow#" id="cash_id_#currentrow#" value="#cash_id#">
										<input type="hidden" name="branch_id_#currentrow#" id="branch_id_#currentrow#" value="#branch_id#">
										<input type="hidden" name="account_code_#currentrow#" id="account_code_#currentrow#" value="#cash_acc_code#">
										<input type="hidden" name="bakiye_#currentrow#" id="bakiye_#currentrow#" value="#wrk_round(bakiye)#">
										<input type="hidden" name="bakiye3_#currentrow#" id="bakiye3_#currentrow#" value="#abs(wrk_round(bakiye3))#">
										<input type="hidden" name="bakiye3_1_#currentrow#" id="bakiye3_1_#currentrow#" value="#wrk_round(bakiye3)#">
										<input type="hidden" name="other_money_#currentrow#" id="other_money_#currentrow#" value="#other_money#">
										<cfset total_3 = total_3 + evaluate('rate_#other_money#')*abs(bakiye3)>
										<td>
											<cfif not attributes.fuseaction contains 'autoexcelpopuppage'>
												<input type="text" name="control_amount_#currentrow#" id="control_amount_#currentrow#" value="#tlformat(evaluate('rate_#other_money#')*abs(bakiye3))#" class="box" readonly style="width:90px;">
											<cfelse>
												#tlformat(evaluate('rate_#other_money#')*abs(bakiye3))#
											</cfif>
										</td>
										<td>
											<cfif not attributes.fuseaction contains 'autoexcelpopuppage'>
												<input type="text" name="control_amount_2_#currentrow#" id="control_amount_2_#currentrow#" value="#tlformat((evaluate('rate_#other_money#')*wrk_round(bakiye3))-wrk_round(bakiye))#" class="box" readonly style="width:90px;">
											<cfelse>
												#tlformat((evaluate('rate_#other_money#')*wrk_round(bakiye3))-wrk_round(bakiye))#
											</cfif>
										</td>
										<cfif not attributes.fuseaction contains 'autoexcelpopuppage'>	
											<td align="center">
												<input type="checkbox" name="is_pay_#currentrow#" id="is_pay_#currentrow#" value="#cash_id#" onClick="check_kontrol(this);" <cfif isdefined("is_pay_#currentrow#")>checked</cfif><cfif wrk_round(((evaluate('rate_#other_money#')*bakiye3)-bakiye),2) eq 0>disabled</cfif>>
											</td>				
										</cfif>
									</tr>
								</cfoutput>
							</tbody>
							<tfoot>
								<cfoutput>
									<tr>
										<td colspan="2"><cf_get_lang dictionary_id='57492.Toplam'></td>
										<td>#TLFormat(abs(total_1))#</td>
										<td>#TLFormat(abs(total_2))#</td>
										<td nowrap="nowrap">#TLFormat(abs(total_1-total_2))# <cfif (total_1-total_2) gt 0>(B)<cfelse>(A)</cfif></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td>
											<cfif not attributes.fuseaction contains 'autoexcelpopuppage'>
												<input type="text" name="total_amount" id="total_amount" value="#TLFormat(abs(total_3))#" class="box" readonly style="width:70px;">
											<cfelse>
												#TLFormat(abs(total_3))#
											</cfif>
										</td>
										<td></td>
										<td></td>
									</tr>
								</cfoutput>
							</tfoot><!-- sil -->
							<input type="hidden" name="count_row" id="count_row" value="<cfoutput>#count_row#</cfoutput>">
						</cf_grid_list><!-- sil --><!-- sil -->						
					<!--- </cf_basket> ---><!-- sil -->
				</cf_box>
				<cf_box pure="1">
					<cfif not attributes.fuseaction contains 'autoexcelpopuppage'>
						<!--- <cf_basket_footer height="170"> --->
							<cfinclude template="add_cash_rate_valuation_1.cfm">
						<!--- </cf_basket_footer> --->
					</cfif>
				</cf_box>
			</cfform>
		<cfelse>
			<cf_box  title="#getLang('','',49724)#">
			<div class="ui-info-bottom">
				<p><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></p>
			</div>
		</cf_box>
		</cfif>
</div>
<script type="text/javascript">
	var control_checked = 0;
	function kontrol()
	{
			document.add_rate_valuation.action="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_rate_valuation</cfoutput>";
			return true;
	}
	function kontrol_form_2()
	{
		if(!chk_process_cat('add_rate_valuation_1')) return false;
		if(!check_display_files('add_rate_valuation_1')) return false;
		if(!chk_period(add_rate_valuation_1.action_date,'İşlem')) return false;
		cash_id_list_1='';
		cash_id_list_2='';
		for(j=1;j<=<cfoutput>#get_cash.recordcount#</cfoutput>;j++)
		{
			if(eval("document.add_rate_valuation_1.other_money_"+j) != undefined && eval("document.add_rate_valuation_1.is_pay_"+j).checked == true)
			{
				if(parseFloat(filterNum(eval('document.add_rate_valuation_1.control_amount_2_'+j).value)) > 0)
					cash_id_list_1+=eval('document.add_rate_valuation_1.control_amount_2_'+j).value;
				else if(parseFloat(filterNum(eval('document.add_rate_valuation_1.control_amount_2_'+j).value)) < 0)
					cash_id_list_2+=eval('document.add_rate_valuation_1.control_amount_2_'+j).value;
			}
		}
		if(cash_id_list_1 != '' && cash_id_list_2 != '')
		{
			alert('<cfoutput>#getLang('ch',17)#</cfoutput>');
			return false;
		}
		if(cash_id_list_1 == '' && cash_id_list_2 == '')
		{
			alert('<cfoutput>#getLang('ch',16)#</cfoutput>');
			return false;
		}
		process=document.add_rate_valuation_1.process_cat.value;
		var get_process_cat = wrk_safe_query('csh_get_process_cat','dsn3',0,process);
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
				alert('<cfoutput>#getLang('ehesap',254)#</cfoutput>' );
				return false;
			} 
		</cfif>
		
		document.getElementById('add_rate_valuation_1').submit();
	}
	function hepsi_view()
	{
		for(j=1;j<=<cfoutput>#get_cash.recordcount#</cfoutput>;j++)
		{
			if(eval("document.add_rate_valuation_1.other_money_"+j) != undefined)
			{
				eval('add_rate_valuation_1.is_pay_'+j).checked = false;
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
		total_amount = 0;
		for(s=1;s<=document.add_rate_valuation_1.kur_say.value;s++)
		{
			money_deger = eval("document.add_rate_valuation_1.hidden_rd_money_"+s).value;
			eval("document.add_rate_valuation_1.txt_rate2_1_"+money_deger).value = eval("document.add_rate_valuation_1.txt_rate2_"+s).value;
		}
		for(j=1;j<=<cfoutput>#get_cash.recordcount#</cfoutput>;j++)
		{
			if(eval("document.add_rate_valuation_1.other_money_"+j) != undefined)
			{
				row_money = eval("document.add_rate_valuation_1.other_money_"+j).value;
				eval('document.add_rate_valuation_1.control_amount_'+j).value = commaSplit(eval("document.add_rate_valuation_1.bakiye3_"+j).value*filterNum(eval("document.add_rate_valuation_1.txt_rate2_1_"+row_money).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>),2);
				total_amount = parseFloat(total_amount + parseFloat(eval("document.add_rate_valuation_1.bakiye3_"+j).value*filterNum(eval("document.add_rate_valuation_1.txt_rate2_1_"+row_money).value)));
				eval('document.add_rate_valuation_1.control_amount_2_'+j).value =  commaSplit((eval("document.add_rate_valuation_1.bakiye3_1_"+j).value*filterNum(eval("document.add_rate_valuation_1.txt_rate2_1_"+row_money).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>))-eval("document.add_rate_valuation_1.bakiye_"+j).value)
				if(filterNum(eval('document.add_rate_valuation_1.control_amount_2_'+j).value) == 0)
				{
					eval('document.add_rate_valuation_1.is_pay_'+j).disabled = true;
				}
				else
				{
					eval('document.add_rate_valuation_1.is_pay_'+j).disabled = false;
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
			for(j=1;j<=<cfoutput>#get_cash.recordcount#</cfoutput>;j++)
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
			for(j=1;j<=<cfoutput>#get_cash.recordcount#</cfoutput>;j++)
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

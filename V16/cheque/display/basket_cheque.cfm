<!--- çek basket sayfasıdır,ekle güncellede ortak çalışır..AE20080428 --->
<cfscript>
	if (isdefined("attributes.id"))//bordro güncellede
		session_basket_kur_ekle(action_id=attributes.id,table_type_id:11,process_type:1);
	else
		session_basket_kur_ekle(process_type:0);//bordro ekle
	total_carpan=0;
	total_value=0;
	control = "";
	del_flag = 0;//bordronun silinmesi kontrolunda kullanılıyor
</cfscript>
<cfif isdefined("attributes.entry_ret")><!--- çek seçerken kullanılan parametreler --->
	<cfset control = "#control#&entry_ret=1">
</cfif>
<cfif isdefined("attributes.endor_ret")>
	<cfset control = "#control#&endor_ret=1">
</cfif>
<cfif isdefined("attributes.is_return")>
	<cfset control = "#control#&is_return=1">
</cfif>
<cfif isdefined("attributes.out_bank")>
	<cfset control = "#control#&out_bank=1">
</cfif>
<cfif isdefined("attributes.out_kontrol")>
	<cfset control = "#control#&out_kontrol=1">
</cfif>
<cfif isdefined("attributes.endorsement")>
	<cfset control = "#control#&endorsement=1">
</cfif>
<cfif isdefined("attributes.is_transfer")>
	<cfset control = "#control#&is_transfer=1">
</cfif>
<cfif isdefined("is_company_select")>
    <cfset control = "#control#&is_company_select=#is_company_select#">
</cfif>

<cfif isdefined("attributes.id")>
	<cfinclude template="../query/get_payroll_cheques.cfm">
</cfif>
<cf_grid_list sort="0">
	<thead>
		<tr>
			<th>
					<a href="javascript://" title="<cf_get_lang dictionary_id='57473.Tarihçe'>"><i class="fa fa-history"></i></a></th>
					<th><a href="javascript://" title="<cf_get_lang dictionary_id='57464.güncelle'>"><i class="fa fa-pencil"></i></a></th>
							<th><a href="javascript://" title="<cf_get_lang dictionary_id='57463.Sil'>"><i class="fa fa-minus"></i></a>
			
			</th>
			<th ><cf_get_lang dictionary_id='58182.Portföy No'></th>
			<th ><cf_get_lang dictionary_id='40910.Çek No'></th>
			<th ><cf_get_lang dictionary_id='57789.Özel Kod'></th>
			<th><cf_get_lang dictionary_id='57521.Banka'></th>
			<th><cf_get_lang dictionary_id='58178.Hesap No'></th>
			<th><cf_get_lang dictionary_id='58180.Borçlu'></th>
			<th><cf_get_lang dictionary_id='58181.Ödeme Yeri'></th>
			<th ><cf_get_lang dictionary_id='57640.Vadesi'></th>
			<th><cf_get_lang dictionary_id='30134.İşlem Para Br'></th>
			<th ><cf_get_lang dictionary_id='54901. Sistem Para Br'></th>
		</tr>
	</thead>
	<tbody name="table1" id="table1">
		<cf_date tarih ='attributes.rev_date'>
		<input type="hidden" name="search_process_date_paper" id="search_process_date_paper" value="payroll_revenue_date">
		<cfif isdefined("attributes.id")>
			<cfset date_list = ''>
			<cfoutput query="get_payroll_cheques">
				<cfset date_list = listappend(date_list,dateformat(get_payroll_cheques.max_act_date,dateformat_style))>
			</cfoutput>
		</cfif>
		<input type="hidden" name="kontrol_process_date" id="kontrol_process_date" value="<cfif isdefined("attributes.id")><cfoutput>#date_list#</cfoutput></cfif>">
		<cfif isdefined("attributes.id")>
			<cfoutput query="GET_PAYROLL_CHEQUES">
				<cfscript>
					fark1 = datediff("d",attributes.rev_date,CHEQUE_DUEDATE);
					if(CURRENCY_ID is not session.ep.money)
					{
						total_value = total_value + OTHER_MONEY_VALUE;
						c1 = fark1 * OTHER_MONEY_VALUE;
					}
					else
					{
						total_value = total_value + CHEQUE_VALUE;
						c1 = fark1 * CHEQUE_VALUE;
					}					
					total_carpan = total_carpan + c1;
					if (LAST_PAYROLL_ID neq PAYROLL_ID)//bordronun silinmesi kontrolunda kullanılıyor
						del_flag = 1;
				</cfscript>
				<cfquery name="get_cheque_money" datasource="#dsn2#">
					SELECT * FROM CHEQUE_MONEY WHERE ACTION_ID = #CHEQUE_ID#
				</cfquery>
				<cfif not get_cheque_money.recordcount>
					<cfquery name="get_cheque_money" datasource="#dsn2#">
						SELECT * FROM PAYROLL_MONEY WHERE ACTION_ID = #PAYROLL_ID#
					</cfquery>
					<cfif not get_cheque_money.recordcount>
						<cfquery name="get_cheque_money" datasource="#dsn#">
							SELECT
								MONEY AS MONEY_TYPE,*
							FROM
								MONEY_HISTORY
							WHERE
								VALIDATE_DATE <= #dateformat(CHEQUE_DUEDATE,dateformat_style)# AND
								PERIOD_ID = #session.ep.period_id# AND
								MONEY = '#GET_PAYROLL_CHEQUES.OTHER_MONEY#'
							ORDER BY
								VALIDATE_DATE DESC
						</cfquery>
						<cfif not get_cheque_money.recordcount>
							<cfquery name="get_cheque_money" datasource="#dsn2#">
								SELECT MONEY AS MONEY_TYPE,* FROM SETUP_MONEY
							</cfquery>
						</cfif>
					</cfif>
				</cfif>
				<tr id="frm_row#currentrow#">
					<cfset money_list2 = get_cheque_money.recordcount & '-'>
					<cfloop query="get_cheque_money">
						<cfset money_list2 = money_list2 & '#get_cheque_money.money_type#' & ',' & '#get_cheque_money.RATE1#' & ',' & '#get_cheque_money.RATE2#' & '-'>
					</cfloop>
					<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
					<input type="hidden" value="#CHEQUE_ID#" name="cheque_id#currentrow#" id="cheque_id#currentrow#">
					<input type="hidden" value="#CHEQUE_STATUS_ID#" name="cheque_status_id#currentrow#" id="cheque_status_id#currentrow#">
					<input type="hidden" value="#money_list2#" name="money_list#currentrow#" id="money_list#currentrow#">
					<input type="hidden" value="#OTHER_MONEY_VALUE2#" name="other_money_value2#currentrow#" id="other_money_value2#currentrow#">
					<input type="hidden" value="#OTHER_MONEY2#" name="other_money2#currentrow#" id="other_money2#currentrow#">
					<input type="hidden" value="#account_id#" name="account_id#currentrow#" id="account_id#currentrow#">							
					<input type="hidden" value="#BANK_BRANCH_NAME#" name="bank_branch_name#currentrow#" id="bank_branch_name#currentrow#">
					<input type="hidden" value="#ENDORSEMENT_MEMBER#" name="endorsement_member#currentrow#" id="endorsement_member#currentrow#">
					<input type="hidden" value="#SELF_CHEQUE#" name="from_cheque_info#currentrow#" id="from_cheque_info#currentrow#">
					<input type="hidden" value="#TAX_NO#" name="tax_no#currentrow#" id="tax_no#currentrow#">
					<input type="hidden" value="#TAX_PLACE#" name="tax_place#currentrow#" id="tax_place#currentrow#">
							<cfif not listfindnocase(denied_pages,'cheque.popup_view_cheque_detail')>
								<cfif len(CHEQUE_ID)>
									<td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_view_cheque_detail&id=#CHEQUE_ID#','horizantal');"><i class="fa fa-history" alt="<cf_get_lang dictionary_id='57473.Tarihçe'>" title="<cf_get_lang dictionary_id='57473.Tarihçe'>"></i></a></td>
								</cfif>
							</cfif>
							<cfif CHEQUE_STATUS_ID is "6">
								<cfif not listfindnocase(denied_pages,'cheque.popup_upd_self_cheque')>
									<td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_upd_self_cheque&row=#currentrow#&cheque_id=#cheque_id#&account_id=#ACCOUNT_ID#&account_no=#ACCOUNT_NO#&currency_id=#CURRENCY_ID#&kur_say=#get_money_bskt.recordcount#');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.güncelle'>" title="<cf_get_lang dictionary_id='57464.güncelle'>"></i></a></td>
								</cfif>
							<cfelseif (attributes.bordro_type is "1") and (CHEQUE_STATUS_ID is "1") and (LAST_PAYROLL_ID eq PAYROLL_ID)>
								<cfif not listfindnocase(denied_pages,'cheque.popup_upd_self_cheque')>
									<td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_upd_self_cheque&row=#currentrow#&cheque_id=#cheque_id#&currency_id=#CURRENCY_ID#&kur_say=#get_money_bskt.recordcount#&self_cheque_info=1');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.güncelle'>" title="<cf_get_lang dictionary_id='57464.güncelle'>"></i></a></td>
								</cfif>
							<cfelse>
								<cfif not listfindnocase(denied_pages,'cheque.popup_upd_cheque_history')>
									<td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_upd_cheque_history&row=#currentrow#&cheque_id=#cheque_id#&kur_say=#get_money_bskt.recordcount#');"><i class="fa fa-exchange" alt="<cf_get_lang dictionary_id='57464.güncelle'>" title="<cf_get_lang dictionary_id='57464.güncelle'>"></i></a></td>
								</cfif> 
							</cfif>
							<cfif (LAST_PAYROLL_ID eq PAYROLL_ID) and CHEQUE_STATUS_ID neq 7>								
								<td><a  href="javascript://" onclick="remove_cheque('#currentrow#');"><i class="fa fa-minus"></i></a></td>
							<cfelse>
								<td></td>
							</cfif>
					<td><div class="form-group"><input type="text" value="#CHEQUE_PURSE_NO#" name="portfoy_no#currentrow#" id="portfoy_no#currentrow#" readonly="yes"></div></td>
					<td><div class="form-group"><input type="text" value="#CHEQUE_NO#"  name="cheque_no#currentrow#" id="cheque_no#currentrow#" readonly="yes"></div></td>
					<td><div class="form-group"><input type="text" value="#CHEQUE_CODE#"  name="cheque_code#currentrow#" id="cheque_code#currentrow#" readonly="yes"></div></td>
					<td><div class="form-group"><input type="text" value="#BANK_NAME#" name="bank_name#currentrow#" id="bank_name#currentrow#" readonly="yes"></div></td>
					<td><div class="form-group"><input type="text" value="#account_no#" name="account_no#currentrow#" id="account_no#currentrow#" readonly="yes"></div></td>
					<td><div class="form-group"><input type="text" value="#DEBTOR_NAME#" name="debtor_name#currentrow#" id="debtor_name#currentrow#" readonly="yes"></div></td>
					<td><div class="form-group"><input type="text" value="#CHEQUE_CITY#" name="cheque_city#currentrow#" id="cheque_city#currentrow#" readonly="yes"></div></td>
					<td><div class="form-group"><input type="text" value="#dateformat(CHEQUE_DUEDATE,dateformat_style)#" name="cheque_duedate#currentrow#" id="cheque_duedate#currentrow#" readonly="yes"></div></td>
					<td>
						<div class="form-group">
							<div class="col col-9 col-md-9 col-sm-9 col-xs-9">
								<input type="text" class="moneybox"  value="#TLFormat(CHEQUE_VALUE)#" name="cheque_value#currentrow#" id="cheque_value#currentrow#" readonly="yes">
							</div>
							<div class="col col-3 col-md-3 col-sm-3 col-xs-3">
								<input type="text" value="#CURRENCY_ID#" name="currency_id#currentrow#" id="currency_id#currentrow#" readonly="yes">
							</div>
						</div>
					</td>
					<td>
						<div class="form-group">
							<div class="col col-9 col-md-9 col-sm-9 col-xs-9">
								<input type="text" class="moneybox"  value="<cfif len(OTHER_MONEY_VALUE)>#TLFormat(OTHER_MONEY_VALUE)#<cfelse>0</cfif>" name="cheque_system_currency_value#currentrow#" id="cheque_system_currency_value#currentrow#" readonly="yes">
							</div>
							<div class="col col-3 col-md-3 col-sm-3 col-xs-3">
								<input type="text"  value="#OTHER_MONEY#" name="system_money_info#currentrow#" id="system_money_info#currentrow#" readonly="yes">
							</div>
						</div>
					</td>
				</tr>
			</cfoutput>
		</cfif>
	</tbody>
</cf_grid_list>
<cfscript>
	if (total_value neq 0)
	{
		avg = total_carpan / total_value;	
		if(isdefined("attributes.id"))
		{
			avg_duedate = dateadd('d', avg, attributes.rev_date);
			avg_age = avg_duedate - attributes.rev_date;
		}
		else
		{
			avg_duedate = dateadd('d', avg, createodbcdatetime(dateformat(attributes.rev_date,dateformat_style)));
			avg_age = avg_duedate - createodbcdatetime(dateformat(attributes.rev_date,dateformat_style));
		}
	}
	else
	{
		avg_duedate = '';
		avg_age = '';
	}
	attributes.avg_duedate = avg_duedate;
	attributes.pyrll_avg_age = avg_age;
	txt_total_value=wrk_round(total_value);
</cfscript> 
<cf_basket_footer height="110">
	<div class="ui-info-bottom">
		<cfoutput>
			<input type="hidden" name="del_flag" id="del_flag" value="#del_flag#">
		<!--- 	<cfif (isdefined("attributes.is_transfer") or isdefined("attributes.out") or isdefined("attributes.entry_ret") or isdefined("attributes.endor_ret") or isdefined("attributes.is_return"))>
				<div><input type="button" value="<cf_get_lang dictionary_id='49732.Çek Seç'>" class="ui-wrk-btn ui-wrk-btn-extra " onclick="javascript:cek_sec();"></div>
			</cfif> --->
<!--- 			<cfif isdefined("attributes.self")>
				<div><input type="button" value="<cf_get_lang dictionary_id='31314.Çek Ekle'>" class="ui-wrk-btn ui-wrk-btn-extra " onclick="javascript:openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_self_cheque');"></div>
			</cfif> --->
		</cfoutput>
	</div>
	<div class="ui-row margin-top-10">
		<div id="sepetim_total" class="padding-0">
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
				<div class="totalBox">
					<div class="totalBoxHead font-grey-mint">
						<span class="headText"><cf_get_lang dictionary_id='57677.Döviz'></span>
						<div class="collapse">
							<span class="icon-minus"></span>
						</div>
					</div>
					<div class="totalBoxBody">
						<table>
							<cfquery name="get_standart_process_money" datasource="#dsn#"><!--- muhasebe doneminden standart islem dövizini alıyor --->
								SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #session.ep.period_id#
							</cfquery>
							<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money_bskt.recordcount#</cfoutput>">
							<input type="hidden" name="basket_money" id="basket_money" value="">
							<input type="hidden" name="basket_money_rate" id="basket_money_rate" value="">
							<cfif isdefined("attributes.id")>
								<cfquery name="get_selected_money" datasource="#dsn2#">
									SELECT MONEY_TYPE FROM PAYROLL_MONEY WHERE ACTION_ID = #attributes.id# AND IS_SELECTED=1
								</cfquery>
							</cfif>
							<cfoutput>
								<cfif isDefined("get_selected_money") and get_selected_money.recordcount>
									<input type="hidden" name="money2_value" id="money2_value" value="#get_selected_money.money_type#">
								<cfelseif isdefined("is_from_payment")>
									<cfset default_basket_money_=attributes.money_type>
									<input type="hidden" name="money2_value" id="money2_value" value="#default_basket_money_#">	
								<cfelseif IsQuery(get_standart_process_money) and len(get_standart_process_money.STANDART_PROCESS_MONEY)><!--- muhasebe doneminden standart islem dövizi işlemleri için --->
									<cfset default_basket_money_=get_standart_process_money.STANDART_PROCESS_MONEY>
									<input type="hidden" name="money2_value" id="money2_value" value="#default_basket_money_#">
								<cfelseif len(session.ep.money2)>
									<cfset default_basket_money_=session.ep.money2>
									<input type="hidden" name="money2_value" id="money2_value" value="#default_basket_money_#">	
								<cfelse>
									<cfset default_basket_money_=session.ep.money>
									<input type="hidden" name="money2_value" id="money2_value" value="#default_basket_money_#">	
								</cfif>
								<cfif session.ep.rate_valid eq 1>
									<cfset readonly_info = "yes">
								<cfelseif isdefined("rate_readonly_info") and rate_readonly_info eq 1>
									<cfset readonly_info = "yes">
								<cfelse>
									<cfset readonly_info = "no">
								</cfif>
								<cfloop query="get_money_bskt">
								  <tr>
										<td nowrap>
											<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money_type#">
											<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#TLFormat(rate1,'#session.ep.our_company_info.rate_round_num#')#">
											<input type="radio" name="rd_money" id="rd_money" value="#money_type#" onclick="toplam(1,0);" <cfif (isdefined("attributes.id") and IS_SELECTED eq 1) or (not isdefined("attributes.id") and (money_type eq default_basket_money_))>checked</cfif>>
											#money_type#
										</td>
										<td>#TLFormat(rate1,0)#/</td>
										<td><input type="text"  style="width:100%"<cfif readonly_info>readonly</cfif> name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,'#session.ep.our_company_info.rate_round_num#')#" onblur="toplam(3,#currentrow#);" class="box" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" <cfif money_type is session.ep.money>readonly</cfif>></td>
								  </tr>
								</cfloop>
							</cfoutput>
						</table>
					</div>
				</div>
			</div>
			<div class="col col-5 col-md-5 col-sm-5 col-xs-12">
				<div class="totalBox">
					<div class="totalBoxHead font-grey-mint">
						<span class="headText"> <cf_get_lang dictionary_id='57492.Toplam'> </span>
						<div class="collapse">
							<span class="icon-minus"></span>
						</div>
					</div>
					<div class="totalBoxBody">       
						<cfoutput>
							<table>
								<tr>
									<td style="min-width:85px" nowrap="nowrap"><cf_get_lang dictionary_id='49756.Ortalama Yaş'></td>
									<td style="text-align:right;">
										<input type="text" name="pyrll_avg_age" id="pyrll_avg_age" value="#attributes.pyrll_avg_age#" class="box" readonly="yes">
									</td>
									<td nowrap="nowrap"><cf_get_lang dictionary_id='50243.Günlük Değer'></td>
									<td nowrap="nowrap" style="text-align:right;">
										<input type="text" name="payroll_total" id="payroll_total" value="#TLFormat(total_value)#" class="box" readonly="yes">
										<input type="text" style="width:85px" name="payroll_currency" id="payroll_currency" value="#session.ep.money#" class="box" readonly="yes">
									</td>
								</tr>
								<tr>
									<td style="min-width:85px"><cf_get_lang dictionary_id='57861.Ortalama Vade'></td>
									<td style="text-align:right;">
										<input type="text" name="pyrll_avg_duedate" id="pyrll_avg_duedate" value="#dateformat(attributes.avg_duedate,dateformat_style)#"   class="box" readonly="yes">
									</td>
									<td><cf_get_lang dictionary_id='40324.Döviz Tutarı'></td>
									<td style="text-align:right;">
										<input type="text" name="other_payroll_total" id="other_payroll_total" value="" onblur="toplam(0,0);" class="box" onkeyup="return(FormatCurrency(this,event));">
										<input type="text" name="other_payroll_currency" id="other_payroll_currency" value="" style="width:85px" class="box" readonly="">
									</td>
								</tr>
								<tr>
									<input type="hidden" name="record_num" id="record_num" value="<cfif isDefined("attributes.id")>#GET_PAYROLL_CHEQUES.recordcount#<cfelse>0</cfif>">
									<td><cf_get_lang dictionary_id='49759.Çek Sayısı'></td>
									<td style="text-align:right;"><input type="text" name="cheque_num"  id="cheque_num" value="<cfif isDefined("attributes.id")>#GET_PAYROLL_CHEQUES.recordcount#<cfelse>0</cfif>" class="box"></td>
								</tr>
							</table>
						</cfoutput>
					</div>
				</div>
			</div>
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
				<div class="totalBox">
					<div class="totalBoxHead font-grey-mint">
						<span class="headText"><cf_get_lang dictionary_id ='32823.Toplam Miktar'> </span>
						<div class="collapse">
							<span class="icon-minus"></span>
						</div>
					</div>
					<div class="totalBoxBody" id="totalAmountList">  
						<table>
							<tr>
								<td id="showw" class="txtbold">
									<cf_n2txt number="txt_total_value">
									<cfif txt_total_value gt 0><cf_get_lang dictionary_id ='50261.Yazıyla'> :&nbsp; <input type="text" name="txt_total_value" id="txt_total_value" value="<cfoutput>#txt_total_value#</cfoutput>" class="boxtext"></cfif>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</cf_basket_footer>
<cfoutput>
	<script type="text/javascript">
		<cfif isdefined("attributes.id")>
			row_count=#GET_PAYROLL_CHEQUES.recordcount#;
		<cfelse>
			row_count=0;
		</cfif>
		function add_cheque_row(portfoy_no,bank_name,debtor_name,cheque_city,cheque_duedate,cheque_value,cheque_no,cheque_code,tax_place,tax_no,bank_branch_name,account_no,account_id,currency_id,cheque_id,cheque_position,from_cheque_info,cheque_status_id,cheque_system_currency_value,system_money_info,other_money_value2,other_money2,kur_say,money_list,endorsement_member,last_act_date)
		{
			<cfif isdefined("attributes.is_transfer")>
				if(form_payroll_basket.process_cat.value == '')
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik veri'> : <cf_get_lang dictionary_id='57800.İşlem Tipi'>");
					return false;
				}
				if(document.form_payroll_basket.cash_id.value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='50477.Çek Transferi Yapılacak Kasayı Seçmelisiniz'> !");
					return false;
				}
				if(document.form_payroll_basket.to_cash_id.value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='50478.Çek Transfer Edilecek Kasayı Seçmelisiniz'>");
					return false;
				}
				if(document.form_payroll_basket.cash_id.value == document.form_payroll_basket.to_cash_id.value)
				{ 
					alert ("<cf_get_lang dictionary_id='50479.Transfer İşlemi İçin Farklı Kasalar Seçmelisiniz'> !");
					return false;
				}
				if(list_getat(document.form_payroll_basket.cash_id.value,3,';') != list_getat(document.form_payroll_basket.to_cash_id.value,3,';'))
				{ 
					alert ("<cf_get_lang dictionary_id='50480.Transfer İşlemi İçin Yapılacak Kasaların Para Birimleri Aynı Olmalı'> !");
					return false;
				}
			</cfif>
			if(document.all.kontrol_process_date.value == '')
				document.all.kontrol_process_date.value = last_act_date;
			else
				document.all.kontrol_process_date.value += ','+last_act_date;		
			row_count++;
			var newRow,newCell;
			newRow = document.all.table1.insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
			newRow.className = 'color-row';
			document.all.record_num.value=row_count;
			document.all.cheque_num.value++;
			newCell = newRow.insertCell(newRow.cells.length);
			<cfif not listfindnocase(denied_pages,'cheque.popup_view_cheque_detail')>
				if(cheque_id != '')
				newCell.innerHTML = '<tr><a href="javascript://" onclick=openBoxDraggable("#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.popup_view_cheque_detail&id='+cheque_id+'","horizantal");><i class="fa fa-history" alt="<cf_get_lang dictionary_id='57473.Tarihçe'>" title="<cf_get_lang dictionary_id='57473.Tarihçe'>"></i></a></tr>';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			if (cheque_status_id == "6")
			{
				<cfif not listfindnocase(denied_pages,'cheque.popup_upd_self_cheque')>
					newCell.innerHTML = '<tr><a href="javascript://" onclick=openBoxDraggable("#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.popup_upd_self_cheque&row='+row_count+'&cheque_id='+cheque_id+'&account_no='+account_no+'&account_id='+account_id+'&currency_id='+currency_id+'&kur_say='+kur_say+'");><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.güncelle'>" title="<cf_get_lang dictionary_id='57464.güncelle'>"></i></a></tr>';
				</cfif>
			}
			else if (document.all.bordro_type.value == "1" && cheque_status_id == "1")
			{
				<cfif not listfindnocase(denied_pages,'cheque.popup_upd_self_cheque')>
					newCell.innerHTML = '<tr><a href="javascript://" onclick=openBoxDraggable("#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.popup_upd_self_cheque&row='+row_count+'&cheque_id='+cheque_id+'&currency_id='+currency_id+'&kur_say='+kur_say+'&self_cheque_info=1");><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.güncelle'>" title="<cf_get_lang dictionary_id='57464.güncelle'>"></i></a></tr>';
				</cfif>
			}
			else if (document.all.bordro_type.value == "14" && cheque_status_id == "1")
			{
				<cfif not listfindnocase(denied_pages,'cheque.popup_upd_self_cheque')>
					newCell.innerHTML = '<tr><a href="javascript://" onclick=openBoxDraggable("#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.popup_upd_self_cheque&row='+row_count+'&cheque_id='+cheque_id+'&currency_id='+currency_id+'&kur_say='+kur_say+'&self_cheque_info=1");><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.güncelle'>" title="<cf_get_lang dictionary_id='57464.güncelle'>"></i></a></tr>';
				</cfif>
			}
			else
			{
				<cfif not listfindnocase(denied_pages,'cheque.popup_upd_cheque_history')>
					newCell.innerHTML = '<tr><a href="javascript://" onclick=openBoxDraggable("#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.popup_upd_cheque_history&row='+row_count+'&cheque_id='+cheque_id+'&kur_say='+kur_say+'");><i class="fa fa-exchange" alt="<cf_get_lang dictionary_id='57464.güncelle'>" title="<cf_get_lang dictionary_id='57464.güncelle'>"></i></a></tr>';
				</cfif> 
			}
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<tr><a href="javascript://" title="<cf_get_lang dictionary_id='57463.Sil'>" onClick="remove_cheque('+row_count+');"><i class="fa fa-minus"></i></a></tr>';
			//Del butonunun her koşulda gelmesi için kapatıldı.
			// if(list_find(document.all.bordro_type.value,cheque_status_id) && cheque_status_id != "7")
			// 	icons += '<li><a href="javascript://" onClick="remove_cheque('+row_count+');"><i class="fa fa-minus"></i></a></li>';
			// else
			// {
			// 	<cfif isdefined("attributes.endorsement") or isdefined("attributes.is_transfer")>
			// 		if(cheque_status_id == "1")
			// 			icons += '<li><a href="javascript://" onClick="remove_cheque('+row_count+');"><i class="fa fa-minus"></i></a></li>';
			// 	</cfif>
			// }
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="cheque_id' + row_count +'" value="' +cheque_id+ '"><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" >';
			newCell.innerHTML += '<input type="hidden" name="cheque_status_id' + row_count +'" value="' +cheque_status_id+ '">';
			newCell.innerHTML += '<input type="hidden" name="money_list' + row_count +'" value="' +money_list+ '">';
			newCell.innerHTML += '<input type="hidden" name="other_money_value2' + row_count +'" value="' +other_money_value2+ '">';
			newCell.innerHTML += '<input type="hidden" name="other_money2' + row_count +'" value="' +other_money2+ '">';
			newCell.innerHTML += '<input type="hidden" name="account_id' + row_count +'" value="' +account_id+ '">';
			newCell.innerHTML += '<input type="hidden" name="bank_branch_name' + row_count +'" value="' +bank_branch_name+ '">';
			newCell.innerHTML += '<input type="hidden" name="from_cheque_info' + row_count +'" value="' +from_cheque_info+ '">';
			newCell.innerHTML += '<input type="hidden" name="tax_no' + row_count +'" value="' +tax_no+ '">';
			newCell.innerHTML += '<input type="hidden" name="tax_place' + row_count +'" value="' +tax_place+ '">';
			newCell.innerHTML += '<input type="hidden" name="endorsement_member' + row_count +'" value="' +endorsement_member+ '">';
			newCell.innerHTML += '<input type="text" name="portfoy_no' + row_count +'" value="' + portfoy_no + '" readonly="yes">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="cheque_no' + row_count +'" value="' + cheque_no+ '" readonly="yes"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="cheque_code' + row_count +'" value="' +cheque_code+ '" readonly="yes"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="bank_name' + row_count +'" value="' + bank_name+ '" readonly="yes"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="account_no' + row_count +'" value="' + account_no+ '" readonly="yes"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="debtor_name' + row_count +'" value="' + debtor_name+ '" readonly="yes"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="cheque_city' + row_count +'" value="' + cheque_city+ '" readonly="yes"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="cheque_duedate' + row_count +'" value="' + cheque_duedate + '" readonly="yes"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><div class="col col-9 col-md-9 col-sm-9 col-xs-9"><input type="text" name="cheque_value' + row_count +'" value="'+commaSplit(cheque_value)+'"  class="moneybox" readonly="yes"></div><div class="col col-3 col-md-3 col-sm-3 col-xs-3"><input type="text" name="currency_id' + row_count +'" value="'+currency_id+'" readonly="yes" ></div></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><div class="col col-9 col-md-9 col-sm-9 col-xs-9"><input type="text" name="cheque_system_currency_value' + row_count +'" value="'+commaSplit(cheque_system_currency_value)+'"  class="moneybox" readonly="yes"></div><div class="col col-3 col-md-3 col-sm-3 col-xs-3"><input type="text" name="system_money_info' + row_count +'" value="'+system_money_info+'"  readonly="yes"></div></div>';
			cheque_rate_change();
			for(s=1;s<=document.all.kur_say.value;s++)
				if(eval('document.all.hidden_rd_money_'+s).value == currency_id)
					money_row_ = s;
			toplam(3,money_row_);		
			<cfif isdefined("attributes.is_transfer")>
				if(document.all.cheque_num.value > 0)
				{
					document.all.cash_id.disabled = true;
					document.all.to_cash_id.disabled = true;
					document.all.process_cat.disabled = true;
				}
			</cfif>
		}
		function remove_cheque(sy)
		{
			if(confirm("<cf_get_lang dictionary_id ='50371.Çeki Çıkarmak İstediğinizden Emin Misiniz'>?"))
			{
				eval("document.all.row_kontrol"+sy).value=0;
				var my_element=eval("frm_row"+sy);
				my_element.style.display="none";
				document.all.cheque_num.value--;
				cheque_rate_change();
				toplam(1,0);
				<cfif isdefined("attributes.is_transfer")>
					if(document.all.cheque_num.value == 0)
					{
						document.all.cash_id.disabled = false;
						document.all.to_cash_id.disabled = false;
					}
				</cfif>
			}
		}
		<cfif isdefined("is_company_select")>
			var company_select = '<cfoutput>#is_company_select#</cfoutput>';
		<cfelse>
			var company_select = 1;
		</cfif>
	
		function cek_sec()
		{
			<cfif isdefined("attributes.is_transfer")>
				if(document.form_payroll_basket.process_cat.value == '')
				{
					alert ("<cf_get_lang dictionary_id='57733.Önce İşlem Tipi Seçmelisiniz'> !");
					return false;
				}
				if(document.form_payroll_basket.cash_id.value == "")
				{ 
					alert ("<cf_get_lang dictionary_id ='50477.Çek Transferi Yapılacak Kasayı Seçmelisiniz'> !");
					return false;
				}
				if(document.form_payroll_basket.to_cash_id.value == "")
				{ 
					alert ("<cf_get_lang dictionary_id ='50478.Çek Transfer Edilecek Kasayı Seçmelisiniz'>");
					return false;
				}
				if(document.form_payroll_basket.cash_id.value == document.form_payroll_basket.to_cash_id.value)
				{ 
					alert ("<cf_get_lang dictionary_id ='50479.Transfer İşlemi İçin Farklı Kasalar Seçmelisiniz'> !");
					return false;
				}
				if(list_getat(document.form_payroll_basket.cash_id.value,3,';') != list_getat(document.form_payroll_basket.to_cash_id.value,3,';'))
				{ 
					alert ("<cf_get_lang dictionary_id ='50480.Transfer İşlemi İçin Yapılacak Kasaların Para Birimleri Aynı Olmal'> !");
					return false;
				}
			</cfif>
			company_id = '';
			consumer_id = '';
			employee_id = '';
			if ((company_select == undefined || company_select ==1) && (document.all.company_id != undefined && document.all.company_id.value =="") && (document.all.consumer_id != undefined && document.all.consumer_id.value =="") && (document.all.employee_id != undefined && document.all.employee_id.value ==""))
			{
				alert("<cf_get_lang dictionary_id ='50372.Cari Hesap Seçiniz'>!");
				return false;
			}
			if(document.all.company_id != undefined && document.all.member_type != undefined && document.all.company_id.value !="" && document.all.member_type.value == 'partner')
				company_id = document.all.company_id.value;
			if(document.all.consumer_id != undefined && document.all.member_type != undefined && document.all.consumer_id.value !="" && document.all.member_type.value == 'consumer')
				consumer_id = document.all.consumer_id.value;
			if(document.all.employee_id != undefined && document.all.member_type != undefined && document.all.employee_id.value !="" && document.all.member_type.value == 'employee')
				employee_id = document.all.employee_id.value;
			if(document.all.cash_id != undefined && document.all.cash_id.options[document.all.cash_id.selectedIndex].value == "") 
			{
				c_cash_id = document.all.cash_id.options[document.all.cash_id.selectedIndex].value;
				alert("<cf_get_lang dictionary_id ='50246.Kasa Seçiniz'> !");
				return false;	
			}
			else if(document.all.cash_id != undefined && document.all.cash_id.options[document.all.cash_id.selectedIndex].value != "")
				c_cash_id = document.all.cash_id.options[document.all.cash_id.selectedIndex].value;
			else
				c_cash_id = '';
			
			if(document.all.to_cash_id != undefined && document.all.to_cash_id.options[document.all.to_cash_id.selectedIndex].value != "")
				to_cash_id = document.all.to_cash_id.options[document.all.to_cash_id.selectedIndex].value;
			else
				to_cash_id = '';
				
			if(document.all.account_id != undefined && document.all.account_id.value == "") 
			{
				acc_id = document.all.account_id.options[document.all.account_id.selectedIndex].value;
				alert("<cf_get_lang dictionary_id='58940.Banka Seçiniz'> !");
				return false;	
			}
			else if(document.all.account_id != undefined && document.all.account_id.value != "")
			{
				acc_id = document.all.account_id.value;
				cur_id = document.all.currency_id.value;
			}
			else
			{
				acc_id = '';
				cur_id = '';
			}
			if(document.all.bordro_type.value== 1)//transfer giriş işlemiyse popupta ona göre işlemler gelmeli
				is_other_act = 1;
			else
				is_other_act = 0;
			openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_selct_cheque&is_other_act='+is_other_act+'&control=#control#&company_id='+company_id+'&consumer_id='+consumer_id+'&employee_id='+employee_id+'&cur_id='+cur_id+'&acc_id='+acc_id+'&to_cash_id='+to_cash_id+'&cash_id='+c_cash_id);
		}
	
		function set_cheque_session_values(new_action_type,new_cheque_total,new_session_avg,column_,new_cheque_value,money_list)
		{
			if(new_action_type == 'total')//bordro toplam kısımları için
			{
				document.all.payroll_total.value = commaSplit(new_cheque_total);//günlük değer
				avg_duedate_new = date_add('d',new_session_avg,document.all.rev_date.value);
				avg_age_new = datediff(document.all.rev_date.value,avg_duedate_new,0);
				document.all.pyrll_avg_duedate.value = avg_duedate_new;//Ortalama Vade
				document.all.pyrll_avg_age.value = avg_age_new;//Ortalama Yaş/Gün
				document.getElementById('showw').innerHTML = '<cf_get_lang dictionary_id='50261.Yazıyla'>: ' + n2txt(wrk_round(new_cheque_total),'<cfoutput>#session.ep.money#</cfoutput>').bold();
			}
			else//çek satırları için
			{
				eval('document.all.cheque_system_currency_value'+column_).value = commaSplit(new_cheque_value);//satır çek sistem para
				eval('document.all.money_list'+column_).value = money_list;
				for(fff=1;fff <=list_getat(money_list,1,'-');fff++)
				{
					money = list_getat(money_list,fff+1,'-')
					if(list_getat(money,1,',') == '#session.ep.money2#')
					{
						eval('document.all.other_money_value2'+column_).value = wrk_round(new_cheque_value/list_getat(money,3,','));//sistem 2.dövizi satır tutar
					}
				}
			}
		}
		function cheque_rate_change(money_row_)
		{
			if(money_row_ == undefined)
				for(s=1; s<=document.all.kur_say.value; s++)
					if(document.all.rd_money[s-1].checked == true)
						money_row_ = s;
			var cheque_system_total =0,cheque_value2=0,total_carpan_new=0,money_list='',avg_new=0;
			money_list = document.all.kur_say.value+'-';
			for(s=1;s<=document.all.kur_say.value;s++)
			{
				money_list= money_list+eval('document.all.rd_money['+(s-1)+'].value')+','+filterNum(eval('document.all.txt_rate1_'+s).value,'#session.ep.our_company_info.rate_round_num#')+','+filterNum(eval('document.all.txt_rate2_'+s).value,'#session.ep.our_company_info.rate_round_num#')+'-';
			}
			for(nnn=1;nnn<=document.all.record_num.value;nnn++)
			{
				if(eval("document.all.row_kontrol"+nnn).value==1)
				{
					fark2 = datediff(document.all.rev_date.value,eval('document.all.cheque_duedate'+nnn).value,0);
					if(eval('document.all.currency_id'+nnn).value != eval('document.all.rd_money['+(money_row_-1)+'].value'))  /*<!--- kuru degistirilen para biriminden farklı cekler direk toplama dahil ediliyor --->*/
					{
						cheque_value2 = eval('document.all.cheque_system_currency_value'+nnn).value;
						cheque_value2 = filterNum(cheque_value2);
						cheque_value = cheque_value2;
						cheque_system_total = parseFloat(cheque_system_total)+parseFloat(cheque_value2);
						cheque_value2 = commaSplit(cheque_value2);
						eval('document.all.cheque_system_currency_value'+nnn).value = cheque_value2; /*<!--- cekin, display basketteki other money degeri guncelleniyor --->*/
					}
					else /*<!--- kuru degisen para birimindeki ceklerin sistem para birimi karsılıgı yeniden hesaplanıyor --->*/
					{
						if(eval('document.all.txt_rate2_'+money_row_).value == "" || eval('document.all.txt_rate2_'+money_row_).value == 0)
							cheque_money_rate=1;
						else					
							cheque_money_rate = filterNum((eval('document.all.txt_rate2_'+money_row_).value),'#session.ep.our_company_info.rate_round_num#')/filterNum((eval('document.all.txt_rate1_'+money_row_).value),'#session.ep.our_company_info.rate_round_num#');
						cheque_value =wrk_round(cheque_money_rate * filterNum(eval('document.all.cheque_value'+nnn).value));
						eval('document.all.cheque_system_currency_value'+nnn).value = commaSplit(cheque_value); /*<!--- cekin, display basketteki other money degeri guncelleniyor --->*/
						set_cheque_session_values('other_money',0,0,nnn,cheque_value,money_list); /*<!--- cekin sessiondaki other money degeri guncelleniyor --->*/
						cheque_system_total = parseFloat(cheque_system_total)+parseFloat(cheque_value);
					}
					total_carpan_new = parseFloat(total_carpan_new) + parseFloat(cheque_value*fark2); /*<!--- total_carpan_new,ortamala vade hesaplamasında kullanılıyor --->*/
				}
			}
			document.all.payroll_total.value =commaSplit(cheque_system_total);
			if (cheque_system_total != 0)
				avg_new = wrk_round(total_carpan_new / cheque_system_total);
			set_cheque_session_values('total',wrk_round(cheque_system_total),avg_new,0,0,money_list); /*<!--- payroll toplam tutarı, ortalama vade-yas cek sessionına aktarılıyor --->*/
		}
		function toplam(action_type_,changed_rate_row_,cash_disable_info)
		{
			if(action_type_==3)
				cheque_rate_change(changed_rate_row_);
			for(s=1;s<=document.all.kur_say.value;s++)
			{
				if(document.all.rd_money[s-1].checked == true || action_type_ == 4) /*<!--- para birimi seciliyse veya tum cekler icin toplam kontrol ediliyorsa --->*/
				{
					if(action_type_==1 || action_type_ == 3)
					{
						if(eval('document.all.txt_rate2_'+s).value == "" || eval('document.all.txt_rate2_'+s).value == 0)
							other_money_rate2=1;
						else					
							other_money_rate2 = filterNum((eval('document.all.txt_rate2_'+s).value),'#session.ep.our_company_info.rate_round_num#')/filterNum((eval('document.all.txt_rate1_'+s).value),'#session.ep.our_company_info.rate_round_num#');
						new_other_money = parseFloat(filterNum(document.all.payroll_total.value))/parseFloat(other_money_rate2);
						document.all.other_payroll_total.value = commaSplit(new_other_money);
						document.all.other_payroll_currency.value = document.all.rd_money[s-1].value;
						document.all.basket_money.value = document.all.rd_money[s-1].value;
						document.all.basket_money_rate.value = other_money_rate2;
					}
					else if(action_type_==0 && document.all.other_payroll_total.value != "" && document.all.other_payroll_total.value != 0)
					{
						temp_other_payroll_total = filterNum(document.all.other_payroll_total.value);
						temp_new_rate = parseFloat(filterNum(document.all.payroll_total.value))/parseFloat(temp_other_payroll_total);
						eval('document.all.txt_rate2_'+s).value = commaSplit(temp_new_rate,'#session.ep.our_company_info.rate_round_num#');
						cheque_rate_change(s);/*<!--- degisen kurun para birimindeki ceklerin sistem para birimi karsılıkları guncelleniyor --->*/
						document.all.basket_money.value = document.all.rd_money[s-1].value;
						document.all.basket_money_rate.value = wrk_round(temp_new_rate,'#session.ep.our_company_info.rate_round_num#');
						document.all.other_payroll_total.value=commaSplit(temp_other_payroll_total);
					}
				}
			}
			if(document.all.cash_id != undefined && document.all.cash_id.value.length)
			{
				for(ccc=1;ccc<=document.all.record_num.value;ccc++)
					if(eval("document.all.row_kontrol"+ccc).value==1)
						if(eval('document.all.currency_id'+ccc).value != list_getat(document.all.cash_id.value,3,';'))
						{
							alert("<cf_get_lang dictionary_id='50481.Kasa ile Çekin Para Birimi Farklı'>!");
							return false;
						}
			}
			if(document.all.account_id != undefined && document.all.currency_id != undefined)
			{
				for(ttt=1;ttt<=document.all.record_num.value;ttt++)
					if(eval("document.all.row_kontrol"+ttt).value==1)
						if(eval('document.all.currency_id'+ttt).value != document.all.currency_id.value)
						{
							alert("<cf_get_lang dictionary_id='50482.Banka ile Çekin Para Birimi Farklı'>!");
							return false;
						}
			}
			if(document.all.masraf_currency != undefined && filterNum(document.all.masraf.value) != 0)
			{
				for(mmm=1;mmm<=document.all.record_num.value;mmm++)
					if(eval("document.all.row_kontrol"+mmm).value==1)
						if(eval('document.all.currency_id'+mmm).value != document.all.masraf_currency.value)
						{
							alert("<cf_get_lang dictionary_id='50483.Masraf ile Çekin Para Birimi Farklı'>!");
							return false;
						}
			}
		}
		window.onload = function ()
		{ 
			for(s=1 ;s<=document.all.kur_say.value; s++)
			{
				if(document.all.rd_money[s-1].value == document.all.money2_value.value)
					new_row = s;
			}
			<cfif isDefined("attributes.id")>
				cheque_rate_change(new_row);
				toplam(1,0);
			</cfif>
		}
	</script>
</cfoutput>
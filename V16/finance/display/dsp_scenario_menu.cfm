<!--- 
BURDA YAPICAGINIZ GENEL DEĞİŞİKLİKLERİ EXECUTİVE SUITE ALTINDAKİ
GRUP FINANS SENARYOSU VE CARI FAALİYET ÖZETİ EKRANINA DA YAPINIZ!! Ayşenur20070419
 --->
<cf_xml_page_edit fuseact="finance.scenario">
<cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
	SELECT 
        MONEY, 
        RATE1, 
        RATE2, 
        MONEY_STATUS, 
        PERIOD_ID, 
        COMPANY_ID 
    FROM 
    	SETUP_MONEY 
    WHERE 
	    MONEY_STATUS = 1 AND MONEY <> '#session.ep.money#'
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.scenario" default="">
<cfparam name="attributes.money" default="#session.ep.money#,1">
<cfparam name="attributes.is_month_based" default="1">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_name" default="">
<cfif attributes.is_month_based eq 2 ><!--- ay bazında gösterim için --->
	<cfsavecontent variable="ay1"><cf_get_lang_main no='180.Ocak'></cfsavecontent>
	<cfsavecontent variable="ay2"><cf_get_lang_main no='181.Şubat'></cfsavecontent>
	<cfsavecontent variable="ay3"><cf_get_lang_main no='182.Mart'></cfsavecontent>
	<cfsavecontent variable="ay4"><cf_get_lang_main no='183.Nisan'></cfsavecontent>
	<cfsavecontent variable="ay5"><cf_get_lang_main no='184.Mayıs'></cfsavecontent>
	<cfsavecontent variable="ay6"><cf_get_lang_main no='185.Haziran'></cfsavecontent>
	<cfsavecontent variable="ay7"><cf_get_lang_main no='186.Temmuz'></cfsavecontent>
	<cfsavecontent variable="ay8"><cf_get_lang_main no='187.Ağustos'></cfsavecontent>
	<cfsavecontent variable="ay9"><cf_get_lang_main no='188.Eylül'></cfsavecontent>
	<cfsavecontent variable="ay10"><cf_get_lang_main no='189.Ekim'></cfsavecontent>
	<cfsavecontent variable="ay11"><cf_get_lang_main no='190.Kasım'></cfsavecontent>
	<cfsavecontent variable="ay12"><cf_get_lang_main no='191.Aralık'></cfsavecontent>
	<cfset ay_listesi = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
</cfif>
<cfif fuseaction contains "popup">
	<cfset is_popup=1>
<cfelse>
	<cfset is_popup=0>
</cfif>
<!--- Açık sipariş ve irsaliyeler --->
<cfscript>
	CreateCompenent = CreateObject("component","/../workdata/get_open_order_ships");
	get_open_order_ships = CreateCompenent.getCompenentFunction();
	get_open_order_ships_pur = CreateCompenent.getCompenentFunction(is_purchase:1);
	order_total = get_open_order_ships.order_total;
	order_total_purchase = -1*get_open_order_ships_pur.order_total;
	ship_total = get_open_order_ships.ship_total;
	ship_total_purchase = -1*get_open_order_ships_pur.ship_total;
</cfscript>
<!--- <cfif isDefined("is_group_scenerio")><!--- executive suitte grup finans senaryosu alabilmek için ---> --->
	<cfquery name="OUR_COMPANY" datasource="#dsn#"><!--- yetkili olduğum aktif şirketler --->
		SELECT DISTINCT
			O.COMP_ID,
			O.COMPANY_NAME,
			O.NICK_NAME
		FROM
			EMPLOYEE_POSITIONS EP,
			SETUP_PERIOD SP,
			EMPLOYEE_POSITION_PERIODS EPP,
			OUR_COMPANY O
		WHERE 
			SP.OUR_COMPANY_ID = O.COMP_ID AND
			SP.PERIOD_ID = EPP.PERIOD_ID AND
			EP.POSITION_ID = EPP.POSITION_ID AND
			EP.POSITION_CODE = #session.ep.position_code# AND
			SP.PERIOD_YEAR = #session.ep.period_year# AND
			O.COMP_STATUS = 1
		ORDER BY
			COMPANY_NAME
	</cfquery>
<!--- </cfif> --->
<cfparam name="attributes.our_company_ids" default="#session.ep.company_id#">
<cfif not (isdefined('attributes.start_date') and isdefined('attributes.until_date'))>
	<cfset attributes.start_date = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>
	<cfset attributes.until_date = '#date_add("d",30,attributes.start_date)#'>
<cfelse>
	<cf_date tarih="attributes.start_date">
	<cf_date tarih="attributes.until_date">
</cfif>
<cfinclude template="../query/get_scenario.cfm">
<cfinclude template="../query/get_cheque_remainder.cfm">
<cfscript>
	total_cheque_cash=0;
	total_cheque_bank_tem=0;
	total_voucher_bank_tem=0;
	total_cheque_bank=0;
	total_cheque_pay=0;
	total_voucher_bank=0;
	total_voucher_pay=0;
	total_voucher_cash=0;
	credit_card_total = 0;
	cc_pay_total = 0;
	scen_rev = 0;
	scen_paym = 0;
	dsp_total_gelen_order = 0;
	dsp_total_giden_order = 0;
	total_gelen_order = 0;
	total_giden_order = 0;
	if (len(GET_CREDIT_CARD_PAYMENTS.VALUE))credit_card_total = credit_card_total + GET_CREDIT_CARD_PAYMENTS.VALUE;
	if (len(GET_PAYMENTS_WITH_CC.VALUE))cc_pay_total = cc_pay_total - GET_PAYMENTS_WITH_CC.VALUE;
	if (len(ALACAK_TUTAR))scen_rev = ALACAK_TUTAR;
	if (len(BORC_TUTAR))scen_paym = BORC_TUTAR;
	if (len(GET_GELEN_BANK_ORDERS.ACTION_VALUE))dsp_total_gelen_order = dsp_total_gelen_order + GET_GELEN_BANK_ORDERS.ACTION_VALUE;
	if (len(GET_GIDEN_BANK_ORDERS.ACTION_VALUE))dsp_total_giden_order = dsp_total_giden_order - GET_GIDEN_BANK_ORDERS.ACTION_VALUE;
	if (len(GET_GELEN_BANK_ORDERS_ALL.ACTION_VALUE))total_gelen_order = total_gelen_order + GET_GELEN_BANK_ORDERS_ALL.ACTION_VALUE;
	if (len(GET_GIDEN_BANK_ORDERS_ALL.ACTION_VALUE))total_giden_order = total_giden_order - GET_GIDEN_BANK_ORDERS_ALL.ACTION_VALUE;
	if(isnumeric(get_cheque_in_cash.BAKIYE))
		total_cheque_cash = total_cheque_cash + get_cheque_in_cash.BAKIYE;
	if(isnumeric(get_cheque_in_bank.BORC))
		total_cheque_bank = total_cheque_bank + get_cheque_in_bank.BORC;
	if(isnumeric(get_cheque_to_pay.BORC))
		total_cheque_pay = total_cheque_pay - get_cheque_to_pay.BORC;
	if(isnumeric(get_voucher_in_bank.BORC))
		total_voucher_bank = total_voucher_bank + get_voucher_in_bank.BORC;
	if(isnumeric(get_voucher_to_pay.BORC))
		total_voucher_pay = total_voucher_pay - get_voucher_to_pay.BORC;
	if(isnumeric(get_voucher_in_cash.BORC))
		total_voucher_cash = total_voucher_cash + get_voucher_in_cash.BORC;
	if(isnumeric(get_cheque_bank_tem.BORC))
		total_cheque_bank_tem = total_cheque_bank_tem + get_cheque_bank_tem.BORC;
	if(isnumeric(get_voucher_bank_tem.BORC))
		total_voucher_bank_tem = total_voucher_bank_tem + get_voucher_bank_tem.BORC;

	budget_last_total_inc = 0;
	budget_last_total_exp = 0;
	if(len(GET_LAST_SCEN_INFO.BORC_SCEN_TOTAL))
		scen_borc_total = GET_LAST_SCEN_INFO.BORC_SCEN_TOTAL;
	else
		scen_borc_total = 0;
	if(len(GET_LAST_SCEN_INFO.ALACAK_SCEN_TOTAL))
		scen_alacak_total = -1*GET_LAST_SCEN_INFO.ALACAK_SCEN_TOTAL;
	else
		scen_alacak_total = 0;

	if(len(GET_BUDGET_INFO.INCOME_TOTAL))
		budget_income_total = GET_BUDGET_INFO.INCOME_TOTAL;
	else
		budget_income_total = 0;
	if(len(GET_BUDGET_INFO.EXPENSE_TOTAL))
		budget_expense_total = -1*GET_BUDGET_INFO.EXPENSE_TOTAL;
	else
		budget_expense_total = 0;
	
	budget_last_total_inc = budget_income_total + scen_borc_total;
	budget_last_total_exp = budget_expense_total + scen_alacak_total;
</cfscript>

<cf_catalystHeader>
<cfform name="search" method="post" action="#request.self#?fuseaction=#fuseaction#">
	<input type="hidden" name="is_group_scenerio" id="is_group_scenerio" value="1">	
	<cfsavecontent  variable="right"><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' tag_module="finance_rapor"></cfsavecontent>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cfsavecontent  variable="head"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
		<cf_box> 
			<cf_box_search more="0">
				<!--- <cfif isDefined("is_group_scenerio")> --->
					<div class="form-group medium">
							<cf_multiselect_check 
										query_name="our_company"  
										name="our_company_ids"
										option_value="comp_id"
										option_name="nick_name"
										value="#attributes.our_company_ids#">	
						
					</div>
				<!--- </cfif> --->
				<div class="form-group" id="item-project_name">

						<div class="input-group">
							<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
							<input type="text" value="<cfoutput>#attributes.project_name#</cfoutput>" placeholder="<cfoutput>#getlang('','Proje','57416')#</cfoutput>" name="project_name" id="project_name" onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" value="" autocomplete="off">
							<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57416.Proje'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=search.project_name&project_id=search.project_id</cfoutput>');"></span>

					</div>
				</div>
				<div class="form-group medium">
					<div class="input-group">
						<cfset attributes.start_date = dateformat(attributes.start_date,dateformat_style)>
						<cfsavecontent variable="message"><cf_get_lang_main no='1333.Başlama Tarihi Girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="start_date" value="#attributes.start_date#" validate="#validate_style#" maxlength="10" required="yes" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group medium">
					<div class="input-group">
						<cfset attributes.until_date = dateformat(attributes.until_date,dateformat_style)>
						<cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="until_date" value="#attributes.until_date#" validate="#validate_style#" maxlength="10" required="yes" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="until_date"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="is_month_based" id="is_month_based">
						<option value="1" <cfif attributes.is_month_based eq 1> selected</cfif>><cf_get_lang dictionary_id='35973.Gün Bazında'></option>
						<option value="3" <cfif attributes.is_month_based eq 3> selected</cfif>><cf_get_lang dictionary_id='63429.Hafta Bazında'></option>
						<option value="2" <cfif attributes.is_month_based eq 2> selected</cfif>><cf_get_lang dictionary_id='40698.Ay Bazında'></option>
					</select>
				</div>
				<!--- <div class="form-group">
					<label><cf_get_lang no='552.Ay Bazında'><input type="checkbox" name="is_month_based" id="is_month_based" <cfif isDefined("attributes.is_month_based")>checked</cfif>></label>
				</div> --->
				<div class="form-group">
					<select name="money" id="money">
						<option value="<cfoutput>#session.ep.money#</cfoutput>,1"<cfif session.ep.money eq listFirst(attributes.money,',')>selected</cfif>><cf_get_lang_main no='265.Döviz'></option>
						<cfoutput query="get_money_rate">
							<option value="#money#,#rate1/rate2#"<cfif get_money_rate.money eq listFirst(attributes.money,',')>selected</cfif>>#money#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<!--- <a href="<cfoutput>#request.self#?fuseaction=finance.list_scen_expense&event=add</cfoutput>" class="tableyazi"><img src="/images/money_plus.gif" alt="<cf_get_lang no='2.Gelir-Gider Ekle'>" title="<cf_get_lang no='3.Gelir-Gider Ekle'>" border="0"></a>
					<a href="<cfoutput>#request.self#?fuseaction=finance.list_scen_expense</cfoutput>" class="tableyazi"><img src="/images/money.gif" alt="<cf_get_lang no='2.Gelir-Gider Ekle'>" title="<cf_get_lang no='2.Gelir-Gider Ekle'>" border="0"></a> --->
				</div>
			</cf_box_search>
		</cf_box> 
	</div>
</cfform>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="finance_rapor">
	<cfsavecontent  variable="head"><cf_get_lang dictionary_id="58052.Özet"></cfsavecontent>
    <cf_box title="#head#" uidrop="1">
		<!--- <cfif isDefined("is_group_scenerio")> --->
			<cfquery name="GET_COMP_NAME" dbtype="query">
				SELECT NICK_NAME FROM our_company WHERE COMP_ID IN (#attributes.our_company_ids#)
			</cfquery>
			<p class="col col-12 col-md-12 col-sm-12 col-xs-12 phead"><cf_get_lang_main no='162.Şirket'>: <cfoutput query="GET_COMP_NAME"><cfif currentrow neq 1>, </cfif>#NICK_NAME#</cfoutput></p>
		<!--- </cfif> --->
		<cfscript>
			ctotal=get_cash_total.CASH_TOTAL;
			btotal=get_bank_total.BANK_TOTAL;
			mktotal=get_mk_total.MK_TOTAL;
			vadelibtotal=GET_VADELI_BANK_TOTAL.BANK_TOTAL;
			if (ctotal eq "") ctotal=0;
			if (btotal eq "") btotal=0;
			if (mktotal eq "") mktotal=0;
			if (vadelibtotal eq "") vadelibtotal=0;
			bugunku_durum = mktotal+ctotal+btotal+total_cheque_bank+total_cheque_bank_tem+total_voucher_bank_tem+total_voucher_bank+total_voucher_cash+total_cheque_pay+total_voucher_pay+total_claim+total_debt+total_cheque_cash+credit_card_total+cc_pay_total+scen_rev+scen_paym+budget_last_total_inc+budget_last_total_exp+total_gelen_order+total_giden_order;
		</cfscript>
		<cfoutput>
			<div class="col col-7 col-md-7 col-sm-7 col-xs-12">
				<cf_grid_list>
					<thead>
						<tr>
							<th colspan="2"><cf_get_lang_main no='1258.Aktifler'></th>
							<th colspan="2"><cf_get_lang_main no='1257.Pasifler'></th>
							<th colspan="1"><cf_get_lang_main no='1256.Oranlar'></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><cf_get_lang dictionary_id='58657.Kasalar'></td>
							<td style="text-align:right;">
								<cfif ctotal lt 0>
									<a href="#request.self#?fuseaction=cash.list_cashes" target="_blank"><font color="FF0000">#TLFormat(ctotal*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font></a>
								<cfelse>
									<a href="#request.self#?fuseaction=cash.list_cashes" target="_blank">#TLFormat(ctotal*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
								</cfif>
							</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='57987.Bankalar'></td>
							<td style="text-align:right;">
								<cfif btotal lt 0>
									<a href="#request.self#?fuseaction=bank.list_bank_account" target="_blank"><font color="FF0000">#TLFormat(btotal*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font></a>
								<cfelse>
									<a href="#request.self#?fuseaction=bank.list_bank_account" target="_blank">#TLFormat(btotal*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
								</cfif>
							</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td class="txtbold padding-left-10"><span class="fa fa-level-up fa-rotate-90"></span>&nbsp;&nbsp;<cf_get_lang dictionary_id='57798.Vadeli'></td>
							<td style="text-align:right;">
								#TLFormat(vadelibtotal*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#
							</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td class="txtbold padding-left-10"><span class="fa fa-level-up fa-rotate-90"></span>&nbsp;&nbsp;<cf_get_lang dictionary_id='60553.Vadesiz'></td>
							<td style="text-align:right;">
								#TLFormat((btotal - vadelibtotal) *ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#
							</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><cf_get_lang no="36.Teminattaki Çekler"></td>
							<td style="text-align:right;">
								<a href="#request.self#?fuseaction=cheque.list_cheques&is_form_submitted=1&status=13" target="_blank">#TLFormat(total_cheque_bank_tem*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
							</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><cf_get_lang no="44.Teminattaki Senetler"></td>
							<td style="text-align:right;">
								<a href="#request.self#?fuseaction=cheque.list_vouchers&is_form_submitted=1&status=13" target="_blank">#TLFormat(total_voucher_bank_tem*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
							</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='58240.Menkul Kıymetler'></td>
							<td style="text-align:right">
								<a href="#request.self#?fuseaction=credit.list_stockbonds" target="_blank">#TLFormat(mktotal*listLast(attributes.money,','))# #listFirst(attributes.money,',')#</a>
							</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><cf_get_lang no='371.Açık Hesap Alacaklar'></td>
							<td style="text-align:right;"><!--- borç alacakdan borçlu üyelere gider --->
								<cfif total_claim lt 0>
									<a href="#request.self#?fuseaction=ch.list_duty_claim&is_submitted=1&duty_claim=1" target="_blank"><font color="FF0000">#TLFormat(total_claim*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#</font></a>
								<cfelse>
									<a href="#request.self#?fuseaction=ch.list_duty_claim&is_submitted=1&duty_claim=1" target="_blank">#TLFormat(total_claim*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#</a>
								</cfif>
							</td>
							<td><cf_get_lang dictionary_id='60390.Açık Hesap Borçlar'></td>
							<td style="text-align:right;"><!--- borç alacakdan alacaklı üyelere gider --->
								<cfif total_debt lt 0>
									<a href="#request.self#?fuseaction=ch.list_duty_claim&is_submitted=1&duty_claim=2" target="_blank"><font color="FF0000">#TLFormat(total_debt*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font></a>
								<cfelse>
									<a href="#request.self#?fuseaction=ch.list_duty_claim&is_submitted=1&duty_claim=2" target="_blank">#TLFormat(total_debt*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
								</cfif>
							</td>
							<td style="text-align:right;"><cfif total_debt lt 0>% #TLFormat((abs(total_claim/total_debt))*100)#</cfif></td>
						</tr>
						<tr>
							<td><cf_get_lang no='39.portföy çekler toplamı'></td>
							<td style="text-align:right;">
								<cfif (total_cheque_bank+total_cheque_cash) lt 0>
									<a href="#request.self#?fuseaction=cheque.list_cheques&is_form_submitted=1&status=1,2" target="_blank"><font color="FF0000">#TLFormat((total_cheque_bank+total_cheque_cash)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#</font></a>
								<cfelse>
									<a href="#request.self#?fuseaction=cheque.list_cheques&is_form_submitted=1&status=1,2" target="_blank">#TLFormat((total_cheque_bank+total_cheque_cash)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#</a>
								</cfif>
							</td>
							<td><cf_get_lang no='42.ödenecek çekler toplamı'></td>
							<td style="text-align:right;">
								<cfif total_cheque_pay lt 0>
									<a href="#request.self#?fuseaction=cheque.list_cheques&is_form_submitted=1&status=6" target="_blank"><font color="FF0000">#TLFormat(total_cheque_pay*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font></a>
								<cfelse>
									<a href="#request.self#?fuseaction=cheque.list_cheques&is_form_submitted=1&status=6" target="_blank">#TLFormat(total_cheque_pay*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
								</cfif>
							</td>
							<td style="text-align:right;"><cfif total_cheque_pay lt 0>% #TLFormat(((abs((total_cheque_bank+total_cheque_cash)/total_cheque_pay))*100))#</cfif></td>
						</tr>
						<tr>
							<td><cf_get_lang no='184.Portföydeki Senetler Toplamı'></td>
							<td style="text-align:right;">
								<cfif (total_voucher_bank+total_voucher_cash) lt 0>
									<a href="#request.self#?fuseaction=cheque.list_vouchers&is_form_submitted=1&status=1,2" target="_blank"><font color="FF0000">#TLFormat((total_voucher_bank+total_voucher_cash)*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font></a>
								<cfelse>
									<a href="#request.self#?fuseaction=cheque.list_vouchers&is_form_submitted=1&status=1,2" target="_blank">#TLFormat((total_voucher_bank+total_voucher_cash)*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
								</cfif>
							</td>
							<td><cf_get_lang no='185.Ödenecek Senetler Toplamı'></td>
							<td style="text-align:right;">
								<cfif total_voucher_pay lt 0>
									<a href="#request.self#?fuseaction=cheque.list_vouchers&is_form_submitted=1&status=6" target="_blank"><font color="FF0000">#TLFormat(total_voucher_pay*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font></a>
								<cfelse>
									<a href="#request.self#?fuseaction=cheque.list_vouchers&is_form_submitted=1&status=6" target="_blank">#TLFormat(total_voucher_pay*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
								</cfif>
							</td>
							<td style="text-align:right;"><cfif total_voucher_pay lt 0>% #TLFormat(((abs((total_voucher_bank+total_voucher_cash)/total_voucher_pay))*100))#</cfif></td>
						</tr>
						<tr>
							<td><cf_get_lang_main no='2304.Kredi Kartı Tahsilatları'></td>
							<td style="text-align:right;">
								<cfif len(GET_CREDIT_CARD_PAYMENTS.VALUE)>
									<a href="#request.self#?fuseaction=bank.list_payment_credit_cards&is_submitted=1&payment_status=2" target="_blank">#TLFormat((GET_CREDIT_CARD_PAYMENTS.VALUE)*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
								</cfif>
							</td>
							<td><cf_get_lang no='394.Kredi Kartıyla Ödemeler'></td>
							<td style="text-align:right;">
								<cfif len(cc_pay_total) and cc_pay_total lt 0>
									<a href="#request.self#?fuseaction=bank.list_credit_card_expense&form_submitted=1&check_payment_info=1&list_type=2" target="_blank"><font color="FF0000">#TLFormat(cc_pay_total)# #ListFirst(attributes.money,',')#</font></a>
								</cfif>
							</td>
							<td style="text-align:right;">
								<cfif not len(GET_CREDIT_CARD_PAYMENTS.VALUE)>
									<cfset GET_CREDIT_CARD_PAYMENTS.VALUE = 0>
								</cfif>
								<cfif len(GET_CREDIT_CARD_PAYMENTS.VALUE) and cc_pay_total lt 0>% #TLFormat(((abs((GET_CREDIT_CARD_PAYMENTS.VALUE)/cc_pay_total))*100))#</cfif></td>
						
						</tr>
						<tr>
							<td><cf_get_lang no ='501.Gelen Banka Talimatları'></td>
							<td style="text-align:right;">
								<cfif dsp_total_gelen_order lt 0>
									<a href="#request.self#?fuseaction=bank.list_assign_order&form_varmi=1&is_havale=2&bank_order_type=251" target="_blank"><font color="FF0000">#TLFormat((dsp_total_gelen_order)*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font></a>
								<cfelse>
									<a href="#request.self#?fuseaction=bank.list_assign_order&form_varmi=1&is_havale=2&bank_order_type=251" target="_blank">#TLFormat((dsp_total_gelen_order)*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
								</cfif>
							</td>
							<td><cf_get_lang no ='502.Giden Banka Talimatları'></td>
							<td style="text-align:right;">
								<cfif dsp_total_giden_order lt 0>
									<a href="#request.self#?fuseaction=bank.list_assign_order&form_varmi=1&is_havale=2&bank_order_type=250" target="_blank"><font color="FF0000">#TLFormat((dsp_total_giden_order)*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font></a>
								<cfelse>
									<a href="#request.self#?fuseaction=bank.list_assign_order&form_varmi=1&is_havale=2&bank_order_type=250" target="_blank">#TLFormat((dsp_total_giden_order)*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
								</cfif>
							</td>
							<td style="text-align:right;"><cfif dsp_total_giden_order lt 0>% #TLFormat(((abs((dsp_total_gelen_order)/dsp_total_giden_order))*100))#</cfif></td>
						
						</tr>
						<tr>
							<td><cf_get_lang no='457.Kredi Sözleşme Alacakları'></td>
							<td style="text-align:right;">
								<cfif len(ALACAK_TUTAR) and ALACAK_TUTAR lt 0>
									<a href="#request.self#?fuseaction=credit.list_credit_contract&form_submitted=1&is_scenario_control=1" target="_blank"><font color="FF0000">#TLFormat(ALACAK_TUTAR)# #ListFirst(attributes.money,',')#</font></a>
								<cfelseif len(ALACAK_TUTAR)>
									<a href="#request.self#?fuseaction=credit.list_credit_contract&form_submitted=1&is_scenario_control=1" target="_blank">#TLFormat(ALACAK_TUTAR)# #ListFirst(attributes.money,',')#</a>
								</cfif>
							</td>
							<td><cf_get_lang no='458.Kredi Sözleşme Borçları'></td>
							<td style="text-align:right;">
								<cfif len(BORC_TUTAR) and BORC_TUTAR lt 0>
									<a href="#request.self#?fuseaction=credit.list_credit_contract&form_submitted=1&is_scenario_control=1" target="_blank"><font color="FF0000">#TLFormat(BORC_TUTAR)# #ListFirst(attributes.money,',')#</font></a>
								<cfelseif len(BORC_TUTAR)>
									<a href="#request.self#?fuseaction=credit.list_credit_contract&form_submitted=1&is_scenario_control=1" target="_blank">#TLFormat(BORC_TUTAR)# #ListFirst(attributes.money,',')#</a>
								</cfif>
							</td>
							<td style="text-align:right;"><cfif BORC_TUTAR lt 0>% #TLFormat(((abs((ALACAK_TUTAR)/BORC_TUTAR))*100))#</cfif></td>
							
							
						</tr>				
						<tr>
							<td><cf_get_lang no='547.Bütçelenmiş Alacaklar'></td>
							<td style="text-align:right;">
								<cfif budget_last_total_inc lt 0>
									#TLFormat(budget_last_total_inc*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font>
								<cfelse>
									#TLFormat(budget_last_total_inc*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#
								</cfif>
							</td>
							<td><cf_get_lang no='548.Bütçelenmiş Borçlar'></td>
							<td style="text-align:right;">
								<cfif budget_last_total_exp lt 0>
									<font color="FF0000">#TLFormat(budget_last_total_exp*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font>
								<cfelseif len(budget_last_total_exp)>
									#TLFormat((budget_last_total_exp)*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#
								</cfif>
							</td>
							<td style="text-align:right;"><cfif budget_last_total_exp lt 0>% #TLFormat(((abs((budget_last_total_inc)/budget_last_total_exp))*100))#</cfif></td>
						
							
						</tr>
						
						<tr>
							<td><cf_get_lang_main no ='1210.Açık Siparişler'></td>
							<td style="text-align:right;">#tlformat(order_total)# #session.ep.money#</td>
							<td><cf_get_lang_main no ='1210.Açık Siparişler'></td>
							<td style="text-align:right;"><font color="FF0000">#tlformat(order_total_purchase)# #session.ep.money#</font></td>
							<td style="text-align:right;"><cfif order_total_purchase lt 0>% #TLFormat((abs(order_total/order_total_purchase))*100)#</cfif></td>
						</tr>
						<tr>
							<td><cf_get_lang_main no='1543.Faturalanmamış irsaliyeler'></td>
							<td style="text-align:right;">#tlformat(ship_total)# #session.ep.money#</td>
							<td><cf_get_lang_main no='1543.Faturalanmamış irsaliyeler'></td>
							<td style="text-align:right;"><font color="FF0000">#tlformat(ship_total_purchase)# #session.ep.money#</font></td>
							<td style="text-align:right;"><cfif ship_total_purchase lt 0>% #TLFormat((abs(ship_total/ship_total_purchase))*100)#</cfif></td>
						</tr>
						<tr style="background-color: ##f9f9f9;">
							<td><b><cf_get_lang dictionary_id='60391.Toplam Alacak'></b></td>
							<td style="text-align:right;">#TLFormat((mktotal+ctotal+btotal+total_claim+total_cheque_bank+total_voucher_bank_tem+total_cheque_bank_tem+total_cheque_cash+total_voucher_bank+total_voucher_cash+credit_card_total+scen_rev+budget_last_total_inc+total_gelen_order)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#</td>
							<td><b><cf_get_lang dictionary_id='60392.Toplam Borç'></b></td>
							<td style="text-align:right;"><font color="red">#TLFormat((total_debt+total_voucher_pay+total_cheque_pay+scen_paym+budget_last_total_exp+cc_pay_total+total_giden_order)*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font></td>					
							<td style="text-align:right;"><cfif (total_debt+total_voucher_pay+total_cheque_pay) lt 0>% #TLFormat(((abs((mktotal+ctotal+btotal+total_claim+total_cheque_bank+total_voucher_bank_tem+total_cheque_bank_tem+total_cheque_cash+total_voucher_bank+total_voucher_cash+total_giden_order)/(total_debt+total_voucher_pay+total_cheque_pay)))*100))#</cfif></td>
						</tr>
						<tr style="background-color: ##f9f9f9;">
							<td><b><cf_get_lang_main no='1233.Nakit'></b></td>
							<td style="text-align:right;">
								<cfset bakiye=ctotal+btotal>
								<cfif bakiye lt 0>
									<font color="FF0000">#TLFormat(bakiye*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font>
								<cfelse>
									#TLFormat(bakiye*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#
								</cfif></td>
							<td><b><cf_get_lang_main no='344.Durum'></b></td>
							<td style="text-align:right;">
								<cfif bugunku_durum lt 0><font color="FF0000">#TLFormat(bugunku_durum*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#</font>
								<cfelse>#TLFormat(bugunku_durum*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#</cfif>
							</td>
							<td></td>
						</tr>
					</tbody>
				</cf_grid_list>
			</div>
			<div class="col col-5 col-md-5 col-sm-5 col-xs-12 margin-top-10" style="display:flex;justify-content:center">
				<cfset graph_type = "bar">
                <cfset toplam_borc=(total_debt+total_voucher_pay+total_cheque_pay+scen_paym+budget_last_total_exp+cc_pay_total+total_giden_order)*ListLast(attributes.money,',')>
                <cfset toplam_alacak=(mktotal+ctotal+btotal+total_claim+total_cheque_bank+total_voucher_bank_tem+total_cheque_bank_tem+total_cheque_cash+total_voucher_bank+total_voucher_cash+credit_card_total+scen_rev+budget_last_total_inc+total_gelen_order)*ListLast(attributes.money,',')>
				<cfif budget_last_total_exp lt 0>
                    <cfset butce_borc=budget_last_total_exp*ListLast(attributes.money,',')>
                <cfelseif len(budget_last_total_exp)>
                    <cfset butce_borc=(budget_last_total_exp)*ListLast(attributes.money,',')>
                </cfif>
                <cfif budget_last_total_inc lt 0>
                    <cfset butce_alacak=budget_last_total_inc*ListLast(attributes.money,',')>
                <cfelse>
                    <cfset butce_alacak=budget_last_total_inc*ListLast(attributes.money,',')>
                </cfif>
				<cfsavecontent variable="message"><cf_get_lang  dictionary_id ='60392.Toplam Borc'></cfsavecontent>
				<cfset item1="#message#">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='60391.Toplam Alacak'></cfsavecontent>
				<cfset item2="#message#">
				<cfsavecontent variable="message"><cf_get_lang  dictionary_id ='54934.Bütçelenmiş Giderler'></cfsavecontent>
				<cfset item3="#message#">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='54933.Bütçelenmiş Gelirler'></cfsavecontent>
				<cfset item4="#message#">
				<script src="JS/Chart.min.js"></script> 
				<canvas id="myChart998" style="float:left;max-width:700px;max-height:700px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart998');
						var myChart998 = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: ["<cfoutput>#item1#</cfoutput>","<cfoutput>#item2#</cfoutput>","<cfoutput>#item3#</cfoutput>","<cfoutput>#item4#</cfoutput>"],
								datasets: [{
									label: "Nakit Akışı Özet",
									backgroundColor: ['rgb(255, 99, 132)','rgba(255, 99, 132, 0.2)'],
									data: [<cfoutput>#toplam_borc#</cfoutput>,<cfoutput>#toplam_alacak#</cfoutput>,<cfoutput>#butce_borc#</cfoutput>,<cfoutput>#butce_alacak#</cfoutput>],
								}]
							},
							options: {
								legend: {
									display: false
								}
							}
					});
				</script>
			</div>
		</cfoutput>
	</cf_box>
	<cfsavecontent  variable="head"><cf_get_lang dictionary_id="47267.Nakit Akım Tablosu"></cfsavecontent>
	<cf_box  title="#head# " hide_table_column="1" uidrop="1">
		<cf_grid_list id="finance_scenario_bask">
			<cfparam name="attributes.totalrecords" default="#get_scen.recordcount#">
			<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
			<cfif attributes.totalrecords gt attributes.maxrows>
				<cfif attributes.page neq 1>
					<cfset max_=(attributes.page-1)*attributes.maxrows>
					<cfoutput query="get_scen" startrow="1" maxrows="#max_#">
						<cfset bakiye=bakiye+(BORC_BUDGET_TOTAL+BORC_CHEQUE_TOTAL+BORC_VOUCHER_TOTAL+BORC_CC_TOTAL+BORC_CREDIT_CONTRACT_TOTAL+BORC_SCEN_EXPENSE_TOTAL)-(ALACAK_BUDGET_TOTAL+ALACAK_CHEQUE_TOTAL+ALACAK_VOUCHER_TOTAL+ALACAK_CC_TOTAL+ALACAK_CREDIT_CONTRACT_TOTAL+ALACAK_SCEN_EXPENSE_TOTAL)>
					</cfoutput>
				</cfif>
			</cfif>
			<cfset toplam_borc_cheque_total=0>
			<cfset toplam_borc_voucher_total=0>
			<cfset toplam_borc_cc_total=0>
			<cfset toplam_borc_bank_order_total=0>
			<cfset toplam_borc_credit_contract_total=0>
			<cfset toplam_borc_budget_total=0>
			<cfset toplam_borc_scen_expense_total=0>
			<cfset toplam_borc=0>
			<cfset toplam_t_borc=0>
			<cfset toplam_alacak_cheque_total=0>
			<cfset toplam_alacak_voucher_total=0>
			<cfset toplam_alacak_cc_total=0>
			<cfset toplam_alacak_bank_order_total=0>
			<cfset toplam_alacak_credit_contract_total=0>
			<cfset toplam_alacak_budget_total=0>
			<cfset toplam_alacak_scen_expense_total=0>
			<cfset toplam_alacak=0>
			<cfset toplam_t_alacak=0>
			<cfset toplam_bakiye=0>
			<cfset T_ALACAK=0>
			<cfset T_BORC=0>
			<cfset newBakiye = bakiye*ListLast(attributes.money,',')>
			<thead>
			<cfif isDefined('bakiye') and len(bakiye)>
				<tr>
					<th colspan="27" style="text-align:right;"><cf_get_lang_main no='452.devir'>: <cfoutput><cfif bakiye lt 0><font color="ff0000"></cfif>#TLFormat(abs(bakiye)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#<cfif bakiye lt 0></font></cfif></cfoutput></th>
				</tr>
			</cfif>
			<tr>
				<th colspan="2">&nbsp;</th>
				<th width="1"></th>
				<th <cfif session.ep.our_company_info.is_paper_closer eq 1>colspan="10"<cfelse>colspan="9"</cfif> align="center"><cf_get_lang_main no='1265.Gelir'></th>
				<th width="1"></th>
				<th <cfif session.ep.our_company_info.is_paper_closer eq 1>colspan="10"<cfelse>colspan="9"</cfif> align="center"><cf_get_lang_main no='1266.Gider'></th>
				<th width="1"></th>
				<th></th><th></th>
			</tr>
			<tr>
				<th width="15"><cf_get_lang_main  no='75.no'></th>
				<th width="60"><cf_get_lang_main no='330.tarih'></th>
				<th width="1"></th>
				<th align="center"><cf_get_lang_main no='595.çek'></th>
				<th align="center"><cf_get_lang_main no='596.Senet'></th>
				<th><cf_get_lang_main no='2304.Kredi Kartı Tahsilatları'></th>
				<th><cf_get_lang no ='501.Gelen Banka Talimatları'></th>
				<th><cf_get_lang no='457.Kredi Sözleşme Alacakları'></th>
				<th><cf_get_lang no="547.Bütçelenmiş Gelirler"></th>
				<th><cf_get_lang no='459.Senaryo Gelirleri'></th>
				<cfif session.ep.our_company_info.is_paper_closer eq 1>
					<th><cf_get_lang no='371.Açık Hesap Alacaklar'></th>
				</cfif>
				<th><cf_get_lang_main no='80.Toplam'></th>
				<th nowrap></th>
				<th width="1"></th>
				<th align="center"><cf_get_lang_main no='595.çek'></th>
				<th align="center"><cf_get_lang_main no='596.Senet'></th>
				<th><cf_get_lang no='394.Kredi Kartıyla Ödemeler'></th>
				<th><cf_get_lang no ='502.Giden Banka Talimatları'></th>
				<th><cf_get_lang no='458.Kredi Sözleşme Borçları'></th>
				<th><cf_get_lang no="548.Bütçelenmiş Giderler"></th>
				<th><cf_get_lang no='460.Senaryo Giderleri'></th>
				<cfif session.ep.our_company_info.is_paper_closer eq 1>
					<th><cf_get_lang dictionary_id='60390.Açık Hesap Borçlar'></th>
				</cfif>
				<th><cf_get_lang_main no='80.Toplam'></th>
				<th nowrap></th>
				<th width="1"></th>
				<th style="text-align:right;"><cf_get_lang_main  no='177.bakiye'></th>
				<th nowrap></th>
			</tr>
			</thead>
			<tbody>
			<cfif attributes.page neq 1>
				<cfoutput query="get_scen" startrow="1" maxrows="#attributes.startrow-1#">
					<cfset toplam_borc_cheque_total = toplam_borc_cheque_total + BORC_CHEQUE_TOTAL*ListLast(attributes.money,',')>
					<cfset toplam_borc_voucher_total = toplam_borc_voucher_total + BORC_VOUCHER_TOTAL*ListLast(attributes.money,',')>
					<cfset toplam_borc_cc_total = toplam_borc_cc_total + BORC_CC_TOTAL*ListLast(attributes.money,',')>
					<cfset toplam_borc_bank_order_total = toplam_borc_bank_order_total + BORC_BANK_ORDER_TOTAL*ListLast(attributes.money,',')>
					<cfset toplam_borc_credit_contract_total = toplam_borc_credit_contract_total + BORC_CREDIT_CONTRACT_TOTAL*ListLast(attributes.money,',')>
					<cfset toplam_borc_budget_total = toplam_borc_budget_total + BORC_BUDGET_TOTAL*ListLast(attributes.money,',')>
					<cfset toplam_borc_scen_expense_total = toplam_borc_scen_expense_total + BORC_SCEN_EXPENSE_TOTAL*ListLast(attributes.money,',')>
					<cfset toplam_borc = toplam_borc + BORC*ListLast(attributes.money,',')>
					<cfset toplam_t_borc = toplam_t_borc + T_BORC>
					<cfset toplam_alacak_cheque_total = toplam_alacak_cheque_total + ALACAK_CHEQUE_TOTAL*ListLast(attributes.money,',')>
					<cfset toplam_alacak_voucher_total = toplam_alacak_voucher_total + ALACAK_VOUCHER_TOTAL*ListLast(attributes.money,',')>
					<cfset toplam_alacak_cc_total = toplam_alacak_cc_total + ALACAK_CC_TOTAL*ListLast(attributes.money,',')>
					<cfset toplam_alacak_bank_order_total = toplam_alacak_bank_order_total + ALACAK_BANK_ORDER_TOTAL*ListLast(attributes.money,',')>
					<cfset toplam_alacak_credit_contract_total = toplam_alacak_credit_contract_total + ALACAK_CREDIT_CONTRACT_TOTAL*ListLast(attributes.money,',')>
					<cfset toplam_alacak_budget_total = toplam_alacak_budget_total + ALACAK_BUDGET_TOTAL*ListLast(attributes.money,',')>
					<cfset toplam_alacak_scen_expense_total = toplam_alacak_scen_expense_total + ALACAK_SCEN_EXPENSE_TOTAL*ListLast(attributes.money,',')>
					<cfset toplam_alacak = toplam_alacak + ALACAK*ListLast(attributes.money,',')>
					<cfset toplam_t_alacak = toplam_t_alacak + T_ALACAK>
					<cfset toplam_bakiye = toplam_bakiye + abs(bakiye)*ListLast(attributes.money,',')>
				</cfoutput>
			</cfif>
			<cfoutput query="get_scen" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfset newAlacak = 0>
			<cfset newBorc = 0>
			<cfset T_ALACAK = T_ALACAK + (ALACAK_BUDGET_TOTAL*ListLast(attributes.money,',')+ALACAK_CHEQUE_TOTAL*ListLast(attributes.money,',')+ALACAK_VOUCHER_TOTAL*ListLast(attributes.money,',')+ALACAK_CC_TOTAL*ListLast(attributes.money,',')+ALACAK_BANK_ORDER_TOTAL*ListLast(attributes.money,',')+ALACAK_CREDIT_CONTRACT_TOTAL*ListLast(attributes.money,',')+ALACAK_SCEN_EXPENSE_TOTAL*ListLast(attributes.money,',')+ALACAK*ListLast(attributes.money,','))>
			<cfset T_BORC = T_BORC + (BORC_BUDGET_TOTAL*ListLast(attributes.money,',')+BORC_CHEQUE_TOTAL*ListLast(attributes.money,',')+BORC_VOUCHER_TOTAL*ListLast(attributes.money,',')+BORC_BANK_ORDER_TOTAL*ListLast(attributes.money,',')+BORC_CC_TOTAL*ListLast(attributes.money,',')+BORC_CREDIT_CONTRACT_TOTAL*ListLast(attributes.money,',')+BORC_SCEN_EXPENSE_TOTAL*ListLast(attributes.money,',')+BORC*ListLast(attributes.money,','))>
			<cfset newAlacak = (ALACAK_BUDGET_TOTAL*ListLast(attributes.money,',')+ALACAK_CHEQUE_TOTAL*ListLast(attributes.money,',')+ALACAK_VOUCHER_TOTAL*ListLast(attributes.money,',')+ALACAK_CC_TOTAL*ListLast(attributes.money,',')+ALACAK_BANK_ORDER_TOTAL*ListLast(attributes.money,',')+ALACAK_CREDIT_CONTRACT_TOTAL*ListLast(attributes.money,',')+ALACAK_SCEN_EXPENSE_TOTAL*ListLast(attributes.money,',')+ALACAK*ListLast(attributes.money,','))>
			<cfset newBorc = (BORC_BUDGET_TOTAL*ListLast(attributes.money,',')+BORC_CHEQUE_TOTAL*ListLast(attributes.money,',')+BORC_VOUCHER_TOTAL*ListLast(attributes.money,',')+BORC_BANK_ORDER_TOTAL*ListLast(attributes.money,',')+BORC_CC_TOTAL*ListLast(attributes.money,',')+BORC_CREDIT_CONTRACT_TOTAL*ListLast(attributes.money,',')+BORC_SCEN_EXPENSE_TOTAL*ListLast(attributes.money,',')+BORC*ListLast(attributes.money,','))>
			<cfset newBakiye = newBakiye + (newBorc - newalacak) >
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';">
				<td width="35">#currentrow#</td>
				<td><cfif attributes.is_month_based eq 1>
				<a class="tableyazi" href="javascript://" onclick="javascript:windowopen('#request.self#?fuseaction=finance.popup_scen_row_detail&project_id=#attributes.project_id#&project_name=#attributes.project_name#&action_date=#dateformat(thedate,dateformat_style)#&until_date=#attributes.until_date#&scenario=#attributes.scenario#&maxrows=#currentrow#&money=#attributes.money#','list');">
					<cfif (dayofweek(thedate) eq 7) or (dayofweek(thedate) eq 1)><font color="FF0000">#dateformat(thedate,dateformat_style)#</font>
					<cfelse>#dateformat(thedate,dateformat_style)#
					</cfif>
				</a>
			<cfelseif attributes.is_month_based eq 2>
				<a class="tableyazi" href="javascript://" onclick="javascript:windowopen('#request.self#?fuseaction=finance.popup_scen_row_detail&project_id=#attributes.project_id#&project_name=#attributes.project_name#&action_date=#thedate#&until_date=#thedate#&scenario=#attributes.scenario#&maxrows=#currentrow#&money=#attributes.money#&is_month_based=2','list');">#ListGetAt(ay_listesi,thedate)#</a>
			<cfelseif attributes.is_month_based eq 3>
				<a class="tableyazi" href="javascript://" onclick="javascript:windowopen('#request.self#?fuseaction=finance.popup_scen_row_detail&project_id=#attributes.project_id#&project_name=#attributes.project_name#&action_date=#thedate#&until_date=#thedate#&scenario=#attributes.scenario#&maxrows=#currentrow#&money=#attributes.money#&is_month_based=3','list');">
				#thedate#.<cf_get_lang dictionary_id="58734.Hafta"></a>
			</cfif></td>
				<td width="1"></td>
				<td style="text-align:right;">#TLFormat(BORC_CHEQUE_TOTAL*ListLast(attributes.money,','))# </td>
					<cfset toplam_borc_cheque_total = toplam_borc_cheque_total + BORC_CHEQUE_TOTAL*ListLast(attributes.money,',')>
				<td style="text-align:right;">#TLFormat(BORC_VOUCHER_TOTAL*ListLast(attributes.money,','))# </td>
					<cfset toplam_borc_voucher_total = toplam_borc_voucher_total + BORC_VOUCHER_TOTAL*ListLast(attributes.money,',')>
				<td style="text-align:right;">#TLFormat(BORC_CC_TOTAL*ListLast(attributes.money,','))#</td>
					<cfset toplam_borc_cc_total = toplam_borc_cc_total + BORC_CC_TOTAL*ListLast(attributes.money,',')>
				<td style="text-align:right;">#TLFormat(BORC_BANK_ORDER_TOTAL*ListLast(attributes.money,','))# </td>
					<cfset toplam_borc_bank_order_total = toplam_borc_bank_order_total + BORC_BANK_ORDER_TOTAL*ListLast(attributes.money,',')>
				<td style="text-align:right;">#TLFormat(BORC_CREDIT_CONTRACT_TOTAL*ListLast(attributes.money,','))# </td>
					<cfset toplam_borc_credit_contract_total = toplam_borc_credit_contract_total + BORC_CREDIT_CONTRACT_TOTAL*ListLast(attributes.money,',')>
				<td style="text-align:right;">#TLFormat(wrk_round(BORC_BUDGET_TOTAL*ListLast(attributes.money,','),2))# </td>
					<cfset toplam_borc_budget_total = toplam_borc_budget_total + BORC_BUDGET_TOTAL*ListLast(attributes.money,',')>
				<td style="text-align:right;">#TLFormat(BORC_SCEN_EXPENSE_TOTAL*ListLast(attributes.money,','))# </td>
					<cfset toplam_borc_scen_expense_total = toplam_borc_scen_expense_total + BORC_SCEN_EXPENSE_TOTAL*ListLast(attributes.money,',')>
					<cfif session.ep.our_company_info.is_paper_closer eq 1>
						<td style="text-align:right;">#TLFormat(BORC*ListLast(attributes.money,','))# </td>
							<cfset toplam_borc = toplam_borc + BORC*ListLast(attributes.money,',')>
					</cfif>
				<td style="text-align:right;">#TLFormat(T_BORC)#</td>
					<cfset toplam_t_borc = T_BORC>
				<td>&nbsp;#ListFirst(attributes.money,',')#</td>
				<td width="1"></td>
				<td style="text-align:right;">#TLFormat(ALACAK_CHEQUE_TOTAL*ListLast(attributes.money,','))# </td>
					<cfset toplam_alacak_cheque_total = toplam_alacak_cheque_total + ALACAK_CHEQUE_TOTAL*ListLast(attributes.money,',')>
				<td style="text-align:right;">#TLFormat(ALACAK_VOUCHER_TOTAL*ListLast(attributes.money,','))# </td>
					<cfset toplam_alacak_voucher_total = toplam_alacak_voucher_total + ALACAK_VOUCHER_TOTAL*ListLast(attributes.money,',')>
				<td style="text-align:right;">#TLFormat(ALACAK_CC_TOTAL*ListLast(attributes.money,','))# </td>
					<cfset toplam_alacak_cc_total = toplam_alacak_cc_total + ALACAK_CC_TOTAL*ListLast(attributes.money,',')>
				<td style="text-align:right;">#TLFormat(ALACAK_BANK_ORDER_TOTAL*ListLast(attributes.money,','))# </td>
					<cfset toplam_alacak_bank_order_total = toplam_alacak_bank_order_total + ALACAK_BANK_ORDER_TOTAL*ListLast(attributes.money,',')>
				<td style="text-align:right;">#TLFormat(ALACAK_CREDIT_CONTRACT_TOTAL*ListLast(attributes.money,','))# </td>
					<cfset toplam_alacak_credit_contract_total = toplam_alacak_credit_contract_total + ALACAK_CREDIT_CONTRACT_TOTAL*ListLast(attributes.money,',')>
				<td style="text-align:right;">#TLFormat(ALACAK_BUDGET_TOTAL*ListLast(attributes.money,','))# </td>
					<cfset toplam_alacak_budget_total = toplam_alacak_budget_total + ALACAK_BUDGET_TOTAL*ListLast(attributes.money,',')>
				<td style="text-align:right;">#TLFormat(ALACAK_SCEN_EXPENSE_TOTAL*ListLast(attributes.money,','))# </td>
					<cfset toplam_alacak_scen_expense_total = toplam_alacak_scen_expense_total + ALACAK_SCEN_EXPENSE_TOTAL*ListLast(attributes.money,',')>
					<cfif session.ep.our_company_info.is_paper_closer eq 1>
						<td style="text-align:right;">#TLFormat(ALACAK*ListLast(attributes.money,','))# </td>
						<cfset toplam_alacak = toplam_alacak + ALACAK*ListLast(attributes.money,',')>
					</cfif>
				<td style="text-align:right;">#TLFormat(T_ALACAK)#</td>
						<cfset toplam_t_alacak = T_ALACAK>
				<td>&nbsp;#ListFirst(attributes.money,',')#</td>
				<td width="1"></td>
				<td style="text-align:right;">
					<cfif satir_bazlı_bakiye eq 0>
						<cfset bakiye=bakiye+T_BORC-T_ALACAK>
						<cfif bakiye lt 0><font color="ff0000"></cfif>
							#TLFormat(abs(bakiye)*ListLast(attributes.money,','))# 
								<cfset toplam_bakiye = abs(bakiye)*ListLast(attributes.money,',')>
						<cfif bakiye lt 0></font></cfif>
					<cfelse>
						#TLFormat(abs(newBakiye)*ListLast(attributes.money,','))# 
					</cfif>
					
				</td>
				<td>&nbsp;#ListFirst(attributes.money,',')#</td>
			</tr>
			</cfoutput>
			
				<cfoutput>
					<tr  style="background-color: ##f9f9f9;">
						<td colspan="2" style="text-align:right;"><cf_get_lang_main no='80.Toplam'></td>
						<td width="1"></td>
						<td style="text-align:right;">#TLFormat(toplam_borc_cheque_total)#</td>
						<td style="text-align:right;">#TLFormat(toplam_borc_voucher_total)#</td>	
						<td style="text-align:right;">#TLFormat(toplam_borc_cc_total)#</td>
						<td style="text-align:right;">#TLFormat(toplam_borc_bank_order_total)#</td>
						<td style="text-align:right;">#TLFormat(toplam_borc_credit_contract_total)#</td>
						<td style="text-align:right;">#TLFormat(toplam_borc_budget_total)#</td>	
						<td style="text-align:right;">#TLFormat(toplam_borc_scen_expense_total)#</td> 
						<cfif session.ep.our_company_info.is_paper_closer eq 1>
							<td style="text-align:right;">#TLFormat(toplam_borc)#</td>
						</cfif>
						<td style="text-align:right;">#TLFormat(toplam_t_borc)#</td>
						<td>&nbsp;#ListFirst(attributes.money,',')#</td>
						<td width="1"></td>
						<td style="text-align:right;">#TLFormat(toplam_alacak_cheque_total)#</td>
						<td style="text-align:right;">#TLFormat(toplam_alacak_voucher_total)#</td>
						<td style="text-align:right;">#TLFormat(toplam_alacak_cc_total)#</td>
						<td style="text-align:right;">#TLFormat(toplam_alacak_bank_order_total)#</td>	
						<td style="text-align:right;">#TLFormat(toplam_alacak_credit_contract_total)#</td>
						<td style="text-align:right;">#TLFormat(toplam_alacak_budget_total)#</td>
						<td style="text-align:right;">#TLFormat(toplam_alacak_scen_expense_total)#</td>
						<cfif session.ep.our_company_info.is_paper_closer eq 1>
							<td style="text-align:right;">#TLFormat(toplam_alacak)#</td>
						</cfif>
						<td  style="text-align:right;">#TLFormat(toplam_t_alacak)#</td>	
						<td>&nbsp;#ListFirst(attributes.money,',')#</td> 
						<td width="1"></td>
						<td style="text-align:right;">
							<cfif satir_bazlı_bakiye eq 0>
								#TLFormat(toplam_bakiye)#
							<cfelse>
								#TLFormat(abs(newBakiye)*ListLast(attributes.money,','))# 
							</cfif>
						</td>
						<td>&nbsp;#ListFirst(attributes.money,',')#</td>
					</tr>
				</cfoutput>
			</tbody>

		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres = "#fuseaction#">
			<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
				<cfset adres = "#adres#&start_date=#attributes.start_date#">
			</cfif>
			<cfif isdefined("attributes.until_date") and len(attributes.until_date)>
				<cfset adres = "#adres#&until_date=#attributes.until_date#">
			</cfif>
			<cfif isdefined("attributes.scenario") and len(attributes.scenario)>
				<cfset adres = "#adres#&scenario=#attributes.scenario#">
			</cfif>
			<cfif isdefined("attributes.money") and len(attributes.money)>		  	
				<cfset adres = "#adres#&money=#attributes.money#">
			</cfif>
			<cfif isdefined("attributes.our_company_ids") and len(attributes.our_company_ids)>		  	
				<cfset adres = "#adres#&our_company_ids=#attributes.our_company_ids#">
			</cfif>
			<cfif isdefined("attributes.is_group_scenerio") and len(attributes.is_group_scenerio)>		  	
				<cfset adres = "#adres#&is_group_scenerio=#attributes.is_group_scenerio#">
			</cfif>
			<cfif isdefined("attributes.is_month_based") and len(attributes.is_month_based)>		  	
				<cfset adres = "#adres#&is_month_based=#attributes.is_month_based#">
			</cfif>
			<cf_paging page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="#adres#">
		</cfif>
	</cf_box>
	
</div>
    
<script>
	$(document).ready(function(){
		$(".list_settings").remove();
	});
</script>


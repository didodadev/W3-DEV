<!--- FBS 20120904 Sayfada duzenlemeler yapildi;
	from_order_payment_plan Kaldirildi, sistemde aratildi kullanilmadigi gozlendi
	inv_order_id kullanimina gerek yok, bilgi alinip kaldirilacak (upd_bill,upd_bill_purchase dosyalarindan gonderiliyor sadece)
 --->
<!--- faturaya baglı parcalı cari hareket kaydediyor --->
<cf_xml_page_edit fuseact="objects.popup_payment_with_voucher">
<cfparam name="attributes.paper_money" default="#session.ep.money#">
<cfparam name="attributes.modal_id" default="">
<cfquery name="get_paymethod" datasource="#dsn#">
	SELECT PAYMETHOD_ID, PAYMETHOD, DUE_START_DAY FROM SETUP_PAYMETHOD ORDER BY PAYMETHOD
</cfquery>
<cfif not (isdefined('attributes.str_table') and isdefined('attributes.payment_process_id') and len(attributes.payment_process_id))>
	<script type="text/javascript">
		alert('İlgili İşlem Kaydı Bulunamadı!');
		window.close();
	</script>
	<cfabort>
</cfif>
<cfset page_round_number=2><!--- Caricide olusan sorun nedeniyle default 2 hane olacak sekilde degistirildi FBS 20100727 --->
<cfif isdefined('attributes.round_number') and len(attributes.round_number)>
	<cfset page_round_number_hd=attributes.round_number>
<cfelse>
	<cfset page_round_number_hd=session.ep.our_company_info.rate_round_num>
</cfif>
<cfif isdefined('attributes.rate_round_num') and len(attributes.rate_round_num)>
	<cfset page_rate_round_num=attributes.rate_round_num>
<cfelse>
	<cfset page_rate_round_num=session.ep.our_company_info.rate_round_num>
</cfif>

<cfif attributes.str_table is 'INVOICE'>
	<cfquery name="get_paper_detail" datasource="#dsn2#">
		SELECT 
			COMPANY_ID,
			CONSUMER_ID,
			PARTNER_ID,
			'' AS EMPLOYEE_ID,
			INVOICE_NUMBER AS PAPER_NUMBER,
			NETTOTAL,
			OTHER_MONEY_VALUE,
			PAY_METHOD,
			INVOICE_CAT AS PAPER_PROCESS_TYPE,
			PROCESS_CAT,
			ISNULL(DUE_DATE,INVOICE_DATE) AS PAPER_DUE_DATE,
			INVOICE_DATE AS PAPER_DATE,
			PROJECT_ID,
			NOTE AS PAPER_DETAIL,
			OTHER_MONEY,
			CARI_ACTION_TYPE,
			ISNULL(IS_IPTAL,0) IS_IPTAL
		FROM 
			INVOICE 
		WHERE
			INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_process_id#">
	</cfquery>
<cfelseif attributes.str_table is 'ORDERS'>
	<cfset xml_payment_plan_type = 1>
	<cfquery name="get_paper_detail" datasource="#dsn3#">
    	SELECT 
			COMPANY_ID,
			CONSUMER_ID,
			PARTNER_ID,
			'' AS EMPLOYEE_ID,
			ORDER_NUMBER AS PAPER_NUMBER,
			NETTOTAL,
			OTHER_MONEY_VALUE,
			PAYMETHOD AS PAY_METHOD,
            '' AS PAPER_PROCESS_TYPE,
            '' AS PROCESS_CAT,
			ISNULL(DUE_DATE,ORDER_DATE) AS PAPER_DUE_DATE,
			ORDER_DATE AS PAPER_DATE,
			PROJECT_ID,
            ORDER_DETAIL AS PAPER_DETAIL,
			OTHER_MONEY,
            '' AS CARI_ACTION_TYPE,
			0 IS_IPTAL
		FROM 
			ORDERS 
		WHERE
			ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_process_id#">
    </cfquery>
<cfelseif attributes.str_table is 'EXPENSE_ITEM_PLANS'>
	<cfset xml_payment_plan_type = 1>
	<cfquery name="get_paper_detail" datasource="#dsn2#">
		SELECT
			CH_COMPANY_ID AS COMPANY_ID,
			CH_CONSUMER_ID AS CONSUMER_ID,
			CH_EMPLOYEE_ID AS EMPLOYEE_ID,
			CH_PARTNER_ID AS PARTNER_ID,
			PAPER_NO AS PAPER_NUMBER,
			TOTAL_AMOUNT_KDVLI AS NETTOTAL,
			OTHER_MONEY_NET_TOTAL AS OTHER_MONEY_VALUE,
			PAYMETHOD_ID AS PAY_METHOD,
			ACTION_TYPE AS PAPER_PROCESS_TYPE,
			PROCESS_CAT,
			ISNULL(DUE_DATE,EXPENSE_DATE) AS PAPER_DUE_DATE,
			EXPENSE_DATE AS PAPER_DATE,
			ISNULL(PROJECT_ID,'') AS PROJECT_ID,
			DETAIL AS PAPER_DETAIL,
			OTHER_MONEY,
			CARI_ACTION_TYPE,
			0 IS_IPTAL
		FROM
			EXPENSE_ITEM_PLANS
		WHERE
			EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_process_id#">
	</cfquery>
</cfif>
<cfscript>
	if(get_paper_detail.recordcount)
	{
		attributes.company_id=get_paper_detail.COMPANY_ID;
		attributes.consumer_id=get_paper_detail.CONSUMER_ID;
		attributes.employee_id=get_paper_detail.EMPLOYEE_ID;
		attributes.partner_id=get_paper_detail.PARTNER_ID;
		attributes.paper_no=get_paper_detail.PAPER_NUMBER;
		attributes.net_total=get_paper_detail.NETTOTAL;
		attributes.other_money_total=get_paper_detail.OTHER_MONEY_VALUE;
		attributes.paymethod_id=get_paper_detail.PAY_METHOD;
		attributes.process_type=get_paper_detail.PAPER_PROCESS_TYPE;
		attributes.process_catid=get_paper_detail.PROCESS_CAT;
		attributes.paper_action_date=dateformat(get_paper_detail.PAPER_DATE,dateformat_style);
		attributes.paper_due_date=dateformat(get_paper_detail.PAPER_DUE_DATE,dateformat_style);
		attributes.project_id=get_paper_detail.PROJECT_ID;
		attributes.paper_detail=get_paper_detail.PAPER_DETAIL;
		attributes.paper_money=get_paper_detail.OTHER_MONEY;
	}
</cfscript>
<cfif len(attributes.process_type) and len(attributes.process_catid)>
	<cfquery name="control_process_cari_action" datasource="#dsn3#">
		SELECT IS_CARI FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_catid#">
	</cfquery>
<cfelse>
	<cfset control_process_cari_action.recordcount=0>
</cfif>
<cfquery name="get_money" datasource="#dsn2#">
	SELECT
		MONEY_TYPE AS MONEY,
		IS_SELECTED,
		RATE1,
		RATE2
	FROM
		<cfif attributes.str_table is 'ORDERS'>
			#dsn3_alias#.ORDER_MONEY
		<cfelseif attributes.str_table is 'INVOICE'>
			INVOICE_MONEY
		<cfelse>
			EXPENSE_ITEM_PLANS_MONEY
		</cfif>
	WHERE
		ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_process_id#">
</cfquery>
<cfif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id)>
	<cfquery name="get_pay_detail" datasource="#dsn#">
		SELECT * FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#">
	</cfquery>
</cfif>
<cfif attributes.str_table is 'ORDERS'><!--- sayfa, siparislerden cagrılıyorsa, kayıtlı taslak var mı kontrol edilir --->
	<cfquery name="get_invoice_cari_rows" datasource="#dsn3#">
		SELECT 
			ORR_PR.DUEDATE AS DUE_DATE,
			ORR_PR.PAYMENT_AMOUNT AS ACTION_VALUE,
			ORR_PR.OTHER_MONEY_VALUE AS OTHER_CASH_ACT_VALUE,
			ORR_PR.OTHER_MONEY,
			ORR_PR.IS_CASH_PAYMENT,
			ORR_PR.DETAIL AS ACTION_DETAIL,
			ORR_PR.PAYMENT_AMOUNT AS PAYMENT_VALUE,
			ORR_PR.ROW_DETAIL
		FROM
			ORDER_PAYMENT_PLAN ORR_P,
			ORDER_PAYMENT_PLAN_ROWS ORR_PR
		WHERE
			ORR_P.PAYMENT_PLAN_ID=ORR_PR.PAYMENT_PLAN_ID AND
			ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_process_id#">
		ORDER BY
			ORR_PR.PAYMENT_PLAN_ROW_ID
	</cfquery>
	<cfset get_paper_detail.CARI_ACTION_TYPE = 4><!--- neden 4 olan sekilde cekiliyor? --->
<cfelseif xml_payment_plan_type neq 1>
	<cfquery name="get_invoice_cari_rows" datasource="#dsn3#">
		SELECT
        	INVOICE_PAYMENT_PLAN_ID,
			INVOICE_ID,
			COMPANY_ID,
			INVOICE_NUMBER,
			INVOICE_DATE,
			DUE_DATE,
			ACTION_VALUE,
			OTHER_ACTION_VALUE OTHER_CASH_ACT_VALUE,
			PAYMENT_VALUE,
			IS_CASH_PAYMENT,
			ACTION_DETAIL,
			OTHER_MONEY,
			PAYMENT_METHOD_ROW,
			IS_ACTIVE,
			IS_BANK,
			IS_PAID
		FROM
			INVOICE_PAYMENT_PLAN
		WHERE
			INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_process_id#">
			AND PERIOD_ID = #session.ep.period_id#
		ORDER BY
			INVOICE_PAYMENT_PLAN_ID
	</cfquery>
	<cfset send_bank_ = 0>
	<cfoutput query="get_invoice_cari_rows">
		<cfif is_bank eq 1>
			<cfset send_bank_ = 1>
		</cfif>
	</cfoutput>
<cfelseif ListFind("4,5",get_paper_detail.CARI_ACTION_TYPE)><!--- sayfa, masraf fişi ve faturalardan cagrıldıgında cari hareketleri kontrol ediliyor --->
	<cfquery name="get_invoice_cari_rows" datasource="#dsn2#">
		SELECT 
			* 
		FROM
			CARI_ROWS
		WHERE
			<cfif attributes.str_table is 'INVOICE'>
				ACTION_TABLE='INVOICE'
			<cfelse>
				ACTION_TABLE='EXPENSE_ITEM_PLANS'
			</cfif>
			AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_process_id#">
			AND ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_paper_detail.paper_process_type#">
		ORDER BY
			CARI_ACTION_ID
	</cfquery>
<cfelse>
	<cfset get_invoice_cari_rows.recordcount=0>
</cfif>
<cf_box title="#getLang('','Ödeme Planı',38717)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="payment_with_voucher" method="post" action="#request.self#?fuseaction=objects.emptypopup_payment_with_voucher">
		<cf_basket_form id="voucher_table">
			<cfoutput> 
				<input type="hidden" name="is_iptal" id="is_iptal" value="<cfif isdefined('get_paper_detail.is_iptal')>#get_paper_detail.is_iptal#<cfelse>0</cfif>">
				<input type="hidden" name="is_purchase_" id="is_purchase_" value="<cfif isdefined('attributes.is_purchase_')>#attributes.is_purchase_#<cfelse>0</cfif>">
				<input type="hidden" name="paper_table_" id="paper_table_" value="<cfif isdefined("attributes.str_table") and len(attributes.str_table)>#attributes.str_table#</cfif>">
				<input type="hidden" name="company_id" id="company_id" value="<cfif isDefined("attributes.company_id") and len(attributes.company_id)>#attributes.company_id#</cfif>">
				<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>#attributes.consumer_id#</cfif>"> 
				<input type="hidden" name="employee_id" id="employee_id" value="<cfif isDefined("attributes.employee_id") and len(attributes.employee_id)>#attributes.employee_id#</cfif>"> 
				<input type="hidden" name="paper_action_id" id="paper_action_id" value="<cfif isdefined("attributes.payment_process_id")>#attributes.payment_process_id#</cfif>">
				<input type="hidden" name="paper_no" id="paper_no" value="<cfif isdefined("attributes.paper_no") and len(attributes.paper_no)>#attributes.paper_no#</cfif>">
				<input type="hidden" name="paper_process_cat" id="paper_process_cat" value="<cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>#attributes.process_catid#</cfif>">
				<input type="hidden" name="paper_process_type" id="paper_process_type" value="<cfif isdefined("attributes.process_type") and len(attributes.process_type)>#attributes.process_type#</cfif>">
				<input type="hidden" name="paper_branch_id" id="paper_branch_id" value="<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>#attributes.branch_id#<cfelse>#ListGetAt(session.ep.user_location,2,"-")#</cfif>">
				<input type="hidden" name="paper_project_id" id="paper_project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#attributes.project_id#</cfif>">
				<input type="hidden" name="paper_detail" id="paper_detail" value="<cfif isdefined('attributes.paper_detail') and len(attributes.paper_detail)>#attributes.paper_detail#</cfif>">
				<input type="hidden" name="paper_money" id="paper_money" value="<cfif isdefined('attributes.paper_money') and len(attributes.paper_money)>#attributes.paper_money#<cfelse>#session.ep.money#</cfif>">
				<input type="hidden" name="db_type" id="db_type" value="#xml_payment_plan_type#">
				<!---<input type="hidden" name="today_" id="today_" value="#dateFormat(now(),dateformat_style)#">--->
				<cfif isdefined("attributes.paper_action_date")>
					<input name="today_" id="today_" value="#attributes.paper_action_date#"  type="hidden">
				<cfelse>
					<input name="today_" id="today_" value="#dateformat(now(),dateformat_style)#" type="hidden" >
				</cfif>
			</cfoutput>

			<cfsavecontent variable="number_"><cfif isdefined("attributes.paper_no")>: <cfoutput>#attributes.paper_no#</cfoutput></cfif></cfsavecontent>
			<cf_seperator id="voucher_id" title="#getLang('','Plan Adı',51861)# #number_#">
			<cf_box_elements id="voucher_id">
				<div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
						<div class="col col-8 col-xs-12">
							<cfif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id)>
								<cfquery name="get_add_duedate" dbtype="query">
									SELECT DUE_START_DAY FROM get_paymethod WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#">
								</cfquery>
							</cfif>
							<input type="hidden" name="paymethod_add_duedate" id="paymethod_add_duedate" value="0">
							<input type="hidden" name="pay_id" id="pay_id" value="<cfif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id)><cfoutput>#attributes.paymethod_id#</cfoutput></cfif>">
						
							<select name="paymethod_id" id="paymethod_id" onChange="paymethod_hesapla(this.value);">
								<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
								<cfoutput query="get_paymethod">
									<option value="#paymethod_id#" <cfif isdefined("attributes.paymethod_id") and attributes.paymethod_id eq paymethod_id>selected</cfif>>#paymethod#</option>
								</cfoutput>
							</select>
						</div>
					</div>		
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='33978.Vade Başlangıç'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='33979.Vade Başlangıç Girmelisiniz'> !</cfsavecontent>
								<cfif isdefined("attributes.paper_due_date")>
									<cfinput value="#attributes.paper_due_date#" validate="#validate_style#" required="Yes" message="#message#" type="text" name="revenue_start_date" id="revenue_start_date">
								<cfelse>
									<cfinput value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" type="text" name="revenue_start_date" id="revenue_start_date">
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="revenue_start_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57742.Tarih'></label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz !'></cfsavecontent>
							<cfif isdefined("attributes.paper_action_date")>
								<cfinput name="paper_action_date" value="#attributes.paper_action_date#" validate="#validate_style#" required="Yes" message="#message#" type="text"  readonly="readonly">
							<cfelse>
								<cfinput name="paper_action_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" type="text"  readonly="readonly">
							</cfif>
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<cfoutput>
						<div class="form-group">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29534.Toplam Tutar'></label>
							<div class="col col-4 col-xs-12">
								<input type="hidden" name="net_total_system" id="net_total_system" value="#attributes.net_total#">
								<input type="hidden" name="net_total_hd" id="net_total_hd" value="#Tlformat(attributes.other_money_total,page_round_number_hd)#">
								<input type="text" name="net_total" id="net_total" value="#Tlformat(attributes.other_money_total,page_round_number)#" readonly>
							</div> 
							<div class="col col-4 col-xs-12">
								<select name="net_total_money" id="net_total_money" readonly>
									<option value="#attributes.paper_money#" selected>#attributes.paper_money#</option>
								</select>
							</div>
						</div>	 
					</cfoutput>
					<cfoutput>
						<div class="form-group">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='34129.Taksit Sayısı'>-<cf_get_lang dictionary_id ='32504.Peşinat'></label>
							<div class="col col-4 col-xs-12">
								<cfset temp_due_month=0>
								<cfset temp_cash_payment = 0>
								<cfif get_invoice_cari_rows.recordcount>
									<cfloop query="get_invoice_cari_rows">
										<cfif IS_CASH_PAYMENT eq 1> <!--- peşinat satırı ise --->
											<cfset is_cash_payment_row_=1>
											<cfset temp_cash_payment=TLFormat(OTHER_CASH_ACT_VALUE,page_round_number)>
										</cfif>
									</cfloop>
									<cfif isdefined('is_cash_payment_row_')>
										<cfset temp_due_month=get_invoice_cari_rows.recordcount-1>
									<cfelse>
										<cfset temp_due_month=get_invoice_cari_rows.recordcount>
										<cfset temp_cash_payment=0>
									</cfif>
								<cfelseif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id) and get_pay_detail.recordcount>
									<cfif Len(get_pay_detail.due_month)>
										<cfset temp_due_month=get_pay_detail.due_month>
									</cfif>
									<cfif len(get_pay_detail.in_advance) and get_pay_detail.in_advance neq 0>
										<cfset temp_cash_payment=tlformat((attributes.other_money_total*get_pay_detail.in_advance/100),page_round_number)>
									<cfelse>
										<cfset temp_cash_payment=0>
									</cfif>
								</cfif>
								<input type="text" name="due_month" id="due_month" value="#temp_due_month#" onkeyup="isNumber(this);" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = 0;">
							</div>
							<div class="col col-4 col-xs-12">
								<input type="text" name="cash_payment" id="cash_payment" value="#temp_cash_payment#" onkeyup="return(FormatCurrency(this,event,#page_round_number#));" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = 0;">
								<input type="hidden" name="cash_payment_hd" id="cash_payment_hd" value="#temp_cash_payment#">
							</div>
						</div>
					</cfoutput>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' is_cancel='0' add_function="payment_with_voucher_kontrol()">
				<cfif not (isdefined("send_bank_") and send_bank_ eq 1)>
					<input type="button" name="due_format" id="due_format" class="ui-wrk-btn ui-wrk-btn-success" value="<cf_get_lang dictionary_id='58718.Düzenle'>" onClick="kontrol_2();">
				</cfif>
			</cf_box_footer>
		</cf_basket_form>
		<cf_basket id="voucher_table_bask">
			<cf_grid_list name="payment_table1" id="payment_table1" class="detail_basket_list">
				<thead>
					<tr>
						<th width="20">
							<input type="hidden" name="record_num" id="record_num" value="<cfif get_invoice_cari_rows.recordcount neq 0><cfoutput>#get_invoice_cari_rows.recordcount#</cfoutput><cfelse>0</cfif>">
							<a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
						</th>
						<th><cf_get_lang dictionary_id ='32505.Taksit'></th>
						<cfif attributes.str_table is 'ORDERS'>
							<th><cf_get_lang dictionary_id ='57629.Aciklama'></th>
						</cfif>
						<th><cf_get_lang dictionary_id ='57640.Vade'></th>
						<th width="100"><cf_get_lang dictionary_id ='57673.Tutar'></th>
						<th width="100"><cf_get_lang dictionary_id ='57279.Döviz Tutar'></th>
						<th><cf_get_lang dictionary_id ='57489.Para Birimi'></th>
						<cfif xml_payment_plan_type neq 1>
							<th><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
							<th><cf_get_lang dictionary_id='57493.Aktif'></th>
						</cfif>
					</tr>
				</thead>
				<tbody id="payment_table_body">
					<cfif get_invoice_cari_rows.recordcount>
						<cfoutput query="get_invoice_cari_rows">
							<tr id="frm_row#currentrow#" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
								<td><input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
									<input type="hidden" name="is_cash_row#currentrow#" id="is_cash_row#currentrow#" value="<cfif len(get_invoice_cari_rows.is_cash_payment) and get_invoice_cari_rows.is_cash_payment eq 1>1<cfelse>0</cfif>">
									<cfif (isdefined("is_bank") and is_bank neq 1) or not isdefined("is_bank")>
										<a href="javascript://" onclick="payment_with_voucher_remove(#currentrow#,1);"><i class="fa fa-minus" title="Sil"></i></a>
									</cfif>
									<input type="hidden" name="is_bank_#currentrow#" id="is_bank_#currentrow#" value="<cfif isdefined("get_invoice_cari_rows.IS_BANK")>#get_invoice_cari_rows.IS_BANK#</cfif>">
									<input type="hidden" name="is_paid#currentrow#" id="is_paid#currentrow#" value="<cfif isdefined("get_invoice_cari_rows.IS_PAID")>#get_invoice_cari_rows.IS_PAID#</cfif>">
									<input type="hidden" name="act_row_id#currentrow#" id="act_row_id#currentrow#" value="<cfif isdefined("get_invoice_cari_rows.INVOICE_PAYMENT_PLAN_ID")>#get_invoice_cari_rows.INVOICE_PAYMENT_PLAN_ID#</cfif>">
								</td>
								<td>
									<div class="form-group">
										<input type="text" name="voucher_name#currentrow#" id="voucher_name#currentrow#" value="#action_detail#" class="boxtext" <cfif isdefined("get_invoice_cari_rows.is_bank") and get_invoice_cari_rows.is_bank eq 1>disabled="disabled"</cfif>>
									</div>
								</td>
								<cfif attributes.str_table is 'ORDERS'>
									<td>
										<input type="text" name="row_detail#currentrow#" id="row_detail#currentrow#" value="#row_detail#">
									</td>
								</cfif>
								<td nowrap="nowrap">
									<cfset vade_gun = abs(DateDiff("d",get_invoice_cari_rows.due_date,dateFormat(now(),dateformat_style)))>
									<input type="hidden" name="duedate_diff#currentrow#" id="duedate_diff#currentrow#" value="#vade_gun#">
									<input type="text" name="due_date#currentrow#" id="due_date#currentrow#" style="width:65px;" value="#dateformat(get_invoice_cari_rows.due_date,dateformat_style)#" class="text">
									<cf_wrk_date_image date_field="due_date#currentrow#">
								</td>
								<td>
									<div class="form-group">
										<input type="hidden" name="voucher_system_value_hd#currentrow#" id="voucher_system_value_hd#currentrow#" value="#TLFormat(get_invoice_cari_rows.action_value,page_round_number_hd,0)#">
										<input type="text" name="voucher_system_value#currentrow#" id="voucher_system_value#currentrow#" value="#TLFormat(get_invoice_cari_rows.action_value,page_round_number,0)#" onkeyup="return(FormatCurrency(this,event,#page_round_number#));" onBlur="payment_with_voucher_toplam_hesapla_system('#currentrow#');" class="box" <cfif isdefined("get_invoice_cari_rows.is_bank") and get_invoice_cari_rows.is_bank eq 1>readonly="readonly"</cfif>>
									</div>
								</td>
								<td>
									<div class="form-group">
										<input type="hidden" name="voucher_value_hd#currentrow#" id="voucher_value_hd#currentrow#" value="#TLFormat(get_invoice_cari_rows.OTHER_CASH_ACT_VALUE,page_round_number_hd)#">
										<input type="text" name="voucher_value#currentrow#" id="voucher_value#currentrow#" value="#TLFormat(get_invoice_cari_rows.OTHER_CASH_ACT_VALUE,page_round_number)#" onkeyup="return(FormatCurrency(this,event,#page_round_number#));" onBlur="payment_with_voucher_hesapla('#currentrow#');" class="box" <cfif isdefined("get_invoice_cari_rows.is_bank") and get_invoice_cari_rows.is_bank eq 1>readonly="readonly"</cfif>>
									</div>
								</td>
								<td>
									<div class="form-group">
										<select name="money_type#currentrow#" id="money_type#currentrow#" class="boxtext" onchange="payment_with_voucher_hesapla('#currentrow#',1);" <cfif isdefined("get_invoice_cari_rows.is_bank") and get_invoice_cari_rows.is_bank eq 1>disabled="disabled"</cfif>>
											<option value="#get_invoice_cari_rows.other_money#">#get_invoice_cari_rows.other_money#</option>
										</select>
									</div>
								</td>
								<cfif xml_payment_plan_type neq 1>
									<td>
										<div class="form-group">
											<select name="paymethod_row_id#currentrow#" id="paymethod_row_id#currentrow#" style="width:150px;" onchange="change_paper_duedate('#currentrow#');">
												<cfif isdefined("get_invoice_cari_rows.is_bank") and get_invoice_cari_rows.is_bank eq 1>
													<cfif isdefined("get_invoice_cari_rows.payment_method_row") and len(get_invoice_cari_rows.payment_method_row)>
														<cfquery name="get_paymethod_bank_" datasource="#dsn#">
															SELECT PAYMETHOD_ID,PAYMETHOD FROM SETUP_PAYMETHOD WHERE BANK_ID = (SELECT BANK_ID FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #get_invoice_cari_rows.payment_method_row#) ORDER BY PAYMETHOD
														</cfquery>
														<cfloop query="get_paymethod_bank_">
															<option value="#paymethod_id#" <cfif isdefined("get_invoice_cari_rows.payment_method_row") and get_paymethod_bank_.paymethod_id eq get_invoice_cari_rows.payment_method_row>selected</cfif>>#paymethod#</option>
														</cfloop>
													</cfif>
												<cfelse>
													<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
													<cfloop query="get_paymethod">
														<option value="#paymethod_id#" <cfif isdefined("get_invoice_cari_rows.payment_method_row") and paymethod_id eq get_invoice_cari_rows.payment_method_row>selected</cfif>>#paymethod#</option>
													</cfloop>
												</cfif>
											</select>
										</div>
									</td>
									<td>
										<input type="checkbox" name="is_active#currentrow#" id="is_active#currentrow#" value="1" onclick="payment_with_voucher_toplam_hesapla_system('#currentrow#');" <cfif isdefined("get_invoice_cari_rows.is_active") and get_invoice_cari_rows.is_active eq 1>checked="checked"</cfif><cfif (isdefined("get_invoice_cari_rows.is_bank") and get_invoice_cari_rows.is_bank eq 0) or (isdefined("get_invoice_cari_rows.is_active") and get_invoice_cari_rows.is_active neq 1) or (isdefined("get_invoice_cari_rows.is_paid") and get_invoice_cari_rows.is_paid eq 1)>disabled="disabled"</cfif>>
										<cfif isdefined("get_invoice_cari_rows.is_paid") and get_invoice_cari_rows.is_paid eq 1><font color="##FF0000"><cf_get_lang dictionary_id='33793.Ödendi'></font></cfif>
									</td>
								</cfif>
							</tr>
						</cfoutput>							
					</cfif> 
				</tbody>
			</cf_grid_list>
			<cfoutput>
				<div class="ui-row">
					<div id="sepetim_total" class="padding-0">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<div class="totalBox">
								<div class="totalBoxHead font-grey-mint">
									<span class="headText"> <cf_get_lang dictionary_id='57677.Dövizler'> </span>
									<div class="collapse">
										<span class="icon-minus"></span>
									</div>
								</div>
								<div class="totalBoxBody">
									<table cellspacing="0" id="money_rate_table">
										<tbody>
											<input type="hidden" name="kur_say" id="kur_say" value="#get_money.recordcount#">
											<cfloop query="get_money">
												<tr>
													<td nowrap="nowrap">
														<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
														<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
														<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="payment_with_voucher_toplam_hesapla();" <cfif get_money.IS_SELECTED eq 1>checked</cfif>>
													</td>
													<td nowrap="nowrap">#money#</td>
													<td nowrap="nowrap">#TLFormat(rate1,0)#/</td>
													<td nowrap="nowrap"><input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" readonly="yes" value="#TLFormat(rate2,page_rate_round_num)#" style="width:70px;" onkeyup="return(FormatCurrency(this,event,#page_rate_round_num#));" onBlur="payment_with_voucher_toplam_hesapla();" class="box"></td>
												</tr>
											</cfloop>
										</tbody>
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
									<table cellspacing="0" id="money_rate_table">
										<tbody>
											<tr>
												<td width="100" class="txtbold"><cf_get_lang dictionary_id ='57492.Toplam'></td>
												<td width="75" style="text-align:right;">
													<input type="hidden" name="total_amount_hd" id="total_amount_hd" value="0">
													<input type="text" name="total_amount" id="total_amount" class="box" readonly value="0">
												</td>
												<td width="75" style="text-align:right;">
													<input type="text" name="tl_value" id="tl_value" class="box" readonly value="#session.ep.money#" style="width:40px;">
												</td>
											</tr>
											<tr>
												<td nowrap="nowrap" class="txtbold"><cf_get_lang dictionary_id ='58124.Döviz Toplam'></td>
												<td id="rate_value1" style="text-align:right;">
													<input type="hidden" name="other_total_amount_hd" id="other_total_amount_hd" value="0">
													<input type="text" name="other_total_amount" id="other_total_amount" class="box" readonly value="0">
												</td>
												<td style="text-align:right;">
													<input type="text" name="tl_value1" id="tl_value1" class="box" readonly value="" style="width:40px;">
												</td>
											</tr>
											<tr>
												<td class="txtbold"><cf_get_lang dictionary_id='57861.Ortalama Vade'></td>
												<td style="text-align:right;">
													<input type="text" name="average_due_date" id="average_due_date" class="box" readonly value="">
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</cfoutput>
		</cf_basket>
	</cfform>
</cf_box>
<script type="text/javascript">
	<cfif get_invoice_cari_rows.recordcount>
		row_count='<cfoutput>#get_invoice_cari_rows.recordcount#</cfoutput>';
	<cfelse>
		row_count=0;
	</cfif>

	record_exist=0;
	var page_round_number_js='<cfoutput>#page_round_number#</cfoutput>';
	var page_round_number_hd_js='<cfoutput>#page_round_number_hd#</cfoutput>';
	var page_rate_round_num_js='<cfoutput>#page_rate_round_num#</cfoutput>';
	if(payment_with_voucher.paper_no.value!='')
		paper_no_ = payment_with_voucher.paper_no.value;
	else
		paper_no_ = '';
		
	function payment_with_voucher_kontrol()
	{
		<cfif attributes.str_table is 'INVOICE' or attributes.str_table is 'EXPENSE_ITEM_PLANS'>
			var new_sql_2 = 'SELECT CLOSED_ID FROM CARI_CLOSED_ROW WHERE ACTION_ID = <cfoutput>#attributes.payment_process_id#</cfoutput> AND ACTION_TYPE_ID = '+ payment_with_voucher.paper_process_type.value;
			var listParam = "<cfoutput>#attributes.payment_process_id#</cfoutput>" + "*" + payment_with_voucher.paper_process_type.value;
			var closed_info = wrk_safe_query("obj_closed_info_2",'dsn2',0,listParam);
			if(closed_info.recordcount)
			{
				alert("<cf_get_lang dictionary_id='56954.Belge Kapama,Talep veya Emir Girilen Belgenin Ödeme Planı Değiştirilemez'> !");
				return false;
			}
		</cfif>
		<cfif attributes.str_table is not 'ORDERS'>
			<cfif not (control_process_cari_action.recordcount neq 0 and control_process_cari_action.IS_CARI eq 1)>
				alert("<cf_get_lang dictionary_id='30432.Belge İçin Cari İşlem Yapılmamaktadır'>!");
				return false;
			<cfelse>
				if(payment_with_voucher.paper_table_.value=='EXPENSE_ITEM_PLANS' && payment_with_voucher.company_id.value=='' && payment_with_voucher.consumer_id.value==''&& payment_with_voucher.employee_id.value=='') //masraf ve gelir fisinde cari hesap secilmemisse cari işlem yapılmaz
				{
					alert("<cf_get_lang dictionary_id='60293.İlgili Fişte Cari Hesap Seçilmediği İçin Cari İşlem Yapılmamaktadır'>!");
					return false;
				}
			</cfif>
		</cfif>		
		for(r=1;r<=payment_with_voucher.record_num.value;r++)
		{
			if(eval("payment_with_voucher.row_kontrol"+r).value == 1)
			{
				record_exist=1;
				if(eval("payment_with_voucher.voucher_value"+r).value == "" || eval("payment_with_voucher.voucher_value"+r).value ==0)
				{ 
					alert ("<cf_get_lang dictionary_id='60294.Taksit Tutarı Belirtilmemiş'>!");
					return false;
				}
				if (eval("payment_with_voucher.due_date"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id ='33993.Vade Tarihi Girmelisiniz'> !");
					return false;
				}
			}
		}
		toplam_pesin_tutar = filterNum(payment_with_voucher.cash_payment.value,page_round_number_js);
		toplam_pesin_tutar_hd = filterNum(payment_with_voucher.cash_payment_hd.value,page_round_number_hd_js);
		toplam_fatura_tutar_dovizli = filterNum(payment_with_voucher.net_total.value,page_round_number_js);
		toplam_fatura_tutar_dovizli_hd = filterNum(payment_with_voucher.net_total_hd.value,page_round_number_hd_js);
		toplam_senet_tutar_dovizli = filterNum(payment_with_voucher.other_total_amount.value,page_round_number_js);
		toplam_senet_tutar_dovizli_hd = filterNum(payment_with_voucher.other_total_amount_hd.value,page_round_number_hd_js);
		toplam_fatura_tutar = payment_with_voucher.net_total_system.value; //hidden da tlformatsız degeri oldugundan filternumdan geçirilmiyor
		toplam_senet_tutar = filterNum(payment_with_voucher.total_amount.value,page_round_number_js);
		toplam_senet_tutar_hd = filterNum(payment_with_voucher.total_amount_hd.value,page_round_number_hd_js);
		
		if(payment_with_voucher.is_iptal.value == 0)
		{
			<cfif xml_payment_plan_type neq 1>
				if (payment_with_voucher.net_total.value != payment_with_voucher.other_total_amount.value) 
				{
					alert("<cf_get_lang dictionary_id='60295.İşlem Tutarı İle Ödeme Satırları Döviz Toplamı Eşit Olmalı'>!");
					return false;
				}
			<cfelse>
				if (parseFloat(wrk_round(toplam_fatura_tutar_dovizli_hd)) != parseFloat(wrk_round(toplam_senet_tutar_dovizli_hd))) 
				{
					alert("<cf_get_lang dictionary_id='60295.İşlem Tutarı İle Ödeme Satırları Döviz Toplamı Eşit Olmalı'>!");
					return false;
				}
				/* Dovize bakmak yeterli olmaz mi fbs */
				/* Masraf fisinde tl tutarlarin da esitligini kontrol etmek gerekmekte, ancak islem dövizine gore calismali */
				/*else if(parseFloat(wrk_round(toplam_fatura_tutar)) != parseFloat(wrk_round(toplam_senet_tutar))) 
				{
					alert("İşlem Tutarı İle Ödeme Satırları Toplamı Eşit Olmalı!");
					return false;
				} */
			</cfif>
		}
		payment_with_voucher_unformat_fields();
		<cfif isdefined("attributes.draggable")> 
			loadPopupBox('payment_with_voucher' , <cfoutput>#attributes.modal_id#</cfoutput>);
			return false;
		<cfelse>
			return true;
		</cfif>
	}
	function kontrol_2()
	{
		if(payment_with_voucher.paymethod_id.value == '')
		{
			alert("<cf_get_lang dictionary_id='58027.Lutfen Odeme Yontemi Seciniz'>");
			return false;
		}
		if(payment_with_voucher.due_month.value == '')
		{
			alert("<cf_get_lang dictionary_id ='33998.Taksit Sayısı Girmelisiniz'>");
			return false;
		}
		if(parseFloat(filterNum(payment_with_voucher.cash_payment.value,page_round_number_js)) > parseFloat(filterNum(payment_with_voucher.net_total.value,page_round_number_js)))
		{
			alert("<cf_get_lang dictionary_id ='33999.Peşinat Tutarı Toplam Tutardan Fazla Olamaz'>");
			return false;
		}
		add_new_row();
	}
	function paymethod_hesapla(pay_id)
	{
		if(payment_with_voucher.paymethod_id.value != '')
		{
			var get_pay = wrk_safe_query('obj_get_pay','dsn',0,pay_id);
			payment_with_voucher.pay_id.value = pay_id;
			payment_with_voucher.paymethod_add_duedate.value = 0;
				
			if(get_pay.DUE_MONTH != 0)
				payment_with_voucher.due_month.value = get_pay.DUE_MONTH;
			else
				payment_with_voucher.due_month.value = 0;
			
			if(get_pay.IN_ADVANCE != 0)
			{
				deger_net_value = payment_with_voucher.net_total;
				deger_net_value.value = filterNum(deger_net_value.value,page_round_number_js);
				payment_with_voucher.cash_payment.value = commaSplit(wrk_round((deger_net_value.value * get_pay.IN_ADVANCE / 100),page_round_number_js),page_round_number_js);
				deger_net_value.value = commaSplit(deger_net_value.value,page_round_number_js);
				
				deger_net_value_hd = payment_with_voucher.net_total_hd;
				deger_net_value_hd.value = filterNum(deger_net_value_hd.value,page_round_number_hd_js);
				payment_with_voucher.cash_payment_hd.value = commaSplit(wrk_round((deger_net_value_hd.value * get_pay.IN_ADVANCE / 100),page_round_number_hd_js),page_round_number_hd_js);
				deger_net_value_hd.value = commaSplit(deger_net_value_hd.value,page_round_number_hd_js);
			}
			else
				payment_with_voucher.cash_payment.value = 0;
		}
	}
	
	//Sistem Para Birimi Icin Hesaplamalar
	function payment_with_voucher_toplam_hesapla_system(satir)
	{
		var toplam_dongu_1 = 0;		//tutar genel toplam
		var toplam_dongu_1_hd = 0;	//tutar genel toplam
		var toplam_dongu_2 = 0;		//doviz tutar genel toplam
		var toplam_dongu_2_hd = 0;	//doviz tutar genel toplam

		for(r=1;r<=payment_with_voucher.record_num.value;r++)
		{
			if ((eval("payment_with_voucher.row_kontrol"+r).value==1 && eval('payment_with_voucher.is_active'+r) == undefined) || (eval("payment_with_voucher.row_kontrol"+r).value==1 && eval('payment_with_voucher.is_active'+r) != undefined && eval('payment_with_voucher.is_active'+r).checked == true))
			{
				deger_total = eval("payment_with_voucher.voucher_system_value"+r);//Sistem tutarı
				deger_total_hd = eval("payment_with_voucher.voucher_system_value_hd"+r);//Sistem tutarı
				if(deger_total_hd.value == '') deger_total_hd.value = 0;

				deger_other_net_total = eval("payment_with_voucher.voucher_value"+r);//Sistem doviz tutarı
				deger_other_net_total_hd = eval("payment_with_voucher.voucher_value_hd"+r);//Sistem doviz tutarı
				if(deger_other_net_total_hd.value == '') deger_other_net_total_hd.value = 0;

				row_money = eval("payment_with_voucher.money_type"+satir).value;
				for(s=1;s<=payment_with_voucher.kur_say.value;s++)
				{
					if(list_getat(payment_with_voucher.rd_money[s-1].value,1,',') == row_money)
						new_form_txt_rate2_ = eval("payment_with_voucher.txt_rate2_"+s);
				}
				
				new_form_txt_rate2_.value = filterNum(new_form_txt_rate2_.value,page_rate_round_num_js);
				deger_total.value = filterNum(deger_total.value,page_round_number_js);
				deger_total_hd.value = filterNum(deger_total.value,page_round_number_js);
				deger_other_net_total.value = ((parseFloat(deger_total.value,page_round_number_js)) / parseFloat(new_form_txt_rate2_.value,page_round_number_js));
				deger_other_net_total.value = commaSplit(deger_other_net_total.value,page_round_number_js);
				
				deger_total_hd.value = filterNum(deger_total_hd.value,page_round_number_hd_js);
				deger_other_net_total_hd.value = ((parseFloat(deger_total.value,page_round_number_hd_js)) / parseFloat(new_form_txt_rate2_.value,page_round_number_hd_js));
				deger_other_net_total_hd.value = commaSplit(deger_other_net_total_hd.value,page_round_number_hd_js);
				new_form_txt_rate2_.value = commaSplit(new_form_txt_rate2_.value,page_rate_round_num_js);
			}
		}
		payment_with_voucher_toplam_hesapla();
	}
	//Sistem Para Birimi Icin Hesaplamalar
	
	function payment_with_voucher_hesapla(satir)
	{
		if(eval("payment_with_voucher.row_kontrol"+satir).value==1)
		{
			deger_total = eval("payment_with_voucher.voucher_system_value"+satir);//Sistem tutarı
			deger_other_net_total = eval("payment_with_voucher.voucher_value"+satir);//dovizli tutar
			if(deger_other_net_total.value == "") deger_other_net_total.value = 0;
			
			deger_total_hd = eval("payment_with_voucher.voucher_system_value_hd"+satir);//Sistem tutarı
			deger_other_net_total_hd = eval("payment_with_voucher.voucher_value_hd"+satir);//dovizli tutar
			if(deger_other_net_total_hd.value == "") deger_other_net_total_hd.value = 0;
			
			row_money = eval("payment_with_voucher.money_type"+satir).value;
			for(s=1;s<=payment_with_voucher.kur_say.value;s++)
			{
				if(list_getat(payment_with_voucher.rd_money[s-1].value,1,',') == row_money)
					new_form_txt_rate2_ = eval("payment_with_voucher.txt_rate2_"+s);
			}
			new_form_txt_rate2_.value = filterNum(new_form_txt_rate2_.value,page_rate_round_num_js);
			deger_total.value = filterNum(deger_total.value,page_round_number_js);
			deger_total_hd.value = filterNum(deger_total.value,page_round_number_js);
			deger_other_net_total.value = filterNum(deger_other_net_total.value,page_round_number_js);
			toplam_dongu_0 = parseFloat(deger_other_net_total.value,page_round_number_js);
			deger_total.value = ((parseFloat(deger_other_net_total.value,page_round_number_js)) * parseFloat(new_form_txt_rate2_.value,page_round_number_js));
			deger_total.value = commaSplit(deger_total.value,page_round_number_js);
			deger_other_net_total.value = commaSplit(deger_other_net_total.value,page_round_number_js);
			
			deger_total_hd.value = filterNum(deger_total_hd.value,page_round_number_hd_js);
			deger_other_net_total_hd.value = filterNum(deger_other_net_total.value,page_round_number_hd_js);
			toplam_dongu_0_hd = parseFloat(deger_other_net_total_hd.value,page_round_number_js);
			deger_total_hd.value = ((parseFloat(deger_other_net_total_hd.value,page_round_number_hd_js)) * parseFloat(new_form_txt_rate2_.value,page_round_number_hd_js));
			deger_total_hd.value = commaSplit(deger_total_hd.value,page_round_number_hd_js);
			deger_other_net_total_hd.value = commaSplit(deger_other_net_total_hd.value,page_round_number_hd_js);
			
			new_form_txt_rate2_.value = commaSplit(new_form_txt_rate2_.value,page_rate_round_num_js);
		}
		payment_with_voucher_toplam_hesapla();
	}
	
	function payment_with_voucher_toplam_hesapla()
	{
		var toplam_dongu_1 = 0;//tutar genel toplam
		var toplam_dongu_1_hd = 0;//tutar genel toplam
		var total_carpan_new = 0;
		var date_diff_ = 0;

		for(r=1;r<=payment_with_voucher.record_num.value;r++)
		{
			if(eval("payment_with_voucher.row_kontrol"+r).value==1)
			{
				deger_total = eval("payment_with_voucher.voucher_system_value"+r);//Sistem tutarı
				deger_other_net_total = eval("payment_with_voucher.voucher_value"+r);//dovizli tutar
				deger_total_hd = eval("payment_with_voucher.voucher_system_value_hd"+r);//Sistem tutarı
				deger_other_net_total_hd = eval("payment_with_voucher.voucher_value_hd"+r);//dovizli tutar
				if(deger_other_net_total.value == "") deger_total.value = 0;
				if(deger_other_net_total_hd.value == "") deger_total_hd.value = 0;
				deger_money_id = eval("payment_with_voucher.money_type"+r);
				deger_money_id_ilk = list_getat(deger_money_id.value,1,',');
				for(s=1;s<=payment_with_voucher.kur_say.value;s++)
				{
					if(list_getat(payment_with_voucher.rd_money[s-1].value,1,',') == deger_money_id_ilk)
						new_form_txt_rate2_ = eval("payment_with_voucher.txt_rate2_"+s);
				}		
				new_form_txt_rate2_.value = filterNum(new_form_txt_rate2_.value,page_rate_round_num_js);
				deger_total.value = filterNum(deger_total.value,page_round_number_js);
				deger_other_net_total.value = filterNum(deger_other_net_total.value,page_round_number_js);
				deger_total_hd.value = filterNum(deger_total_hd.value,page_round_number_hd_js);
				deger_other_net_total_hd.value = filterNum(deger_other_net_total_hd.value,page_round_number_hd_js);
				
				deger_total.value = ((parseFloat(deger_other_net_total.value,page_round_number_js)) * parseFloat(new_form_txt_rate2_.value,page_round_number_js));
				deger_total.value = commaSplit(deger_total.value,page_round_number_js);
				deger_other_net_total.value = commaSplit(deger_other_net_total.value,page_round_number_js);
				
				deger_total_hd.value = ((parseFloat(deger_other_net_total_hd.value,page_round_number_hd_js)) * parseFloat(new_form_txt_rate2_.value,page_round_number_hd_js));
				deger_total_hd.value = commaSplit(deger_total_hd.value,page_round_number_hd_js);
				deger_other_net_total_hd.value = commaSplit(deger_other_net_total_hd.value,page_round_number_hd_js);
				
				new_form_txt_rate2_.value = commaSplit(new_form_txt_rate2_.value,page_rate_round_num_js);
				deger_total1 = eval("payment_with_voucher.voucher_value"+r);//Sistem tutarı
				
				if((eval('payment_with_voucher.is_active'+r) == undefined || (eval('payment_with_voucher.is_active'+r) != undefined && eval('payment_with_voucher.is_active'+r).checked == true)) && deger_total1.value != '')
					toplam_dongu_1 += parseFloat(filterNum(deger_total1.value,page_round_number_js));
				deger_total1.value = filterNum(deger_total1.value,page_round_number_js);
				deger_total1.value = commaSplit(deger_total1.value,page_round_number_js);
				
				deger_total1_hd = eval("payment_with_voucher.voucher_value_hd"+r);//Sistem tutarı
				if((eval('payment_with_voucher.is_active'+r) == undefined || (eval('payment_with_voucher.is_active'+r) != undefined && eval('payment_with_voucher.is_active'+r).checked == true)) && deger_total1_hd.value != '' )
					toplam_dongu_1_hd += parseFloat(filterNum(deger_total1_hd.value,page_round_number_hd_js));
				deger_total1_hd.value = filterNum(deger_total1_hd.value,page_round_number_hd_js);
				deger_total1_hd.value = commaSplit(deger_total1_hd.value,page_round_number_hd_js);
				
				date_diff_ = Math.abs(datediff(eval('payment_with_voucher.due_date'+r).value,eval('payment_with_voucher.today_').value,1));
				eval('payment_with_voucher.duedate_diff'+r).value = date_diff_;
				total_carpan_new = parseFloat(total_carpan_new) + parseFloat(filterNum(eval('payment_with_voucher.voucher_value'+r).value)*date_diff_);
			}
		}
		for(s=1;s<=eval("payment_with_voucher.kur_say").value;s++)
		{
			form_txt_rate2_ = eval("payment_with_voucher.txt_rate2_"+s);
			if(form_txt_rate2_.value == "")
				form_txt_rate2_.value = 1;
		}
		if(eval("payment_with_voucher.kur_say").value == 1)
			for(s=1;s<=eval("payment_with_voucher.kur_say").value;s++)
			{
				if(payment_with_voucher.rd_money.checked == true)
				{
					deger_diger_para = payment_with_voucher.rd_money;
					form_txt_rate2_ = eval("payment_with_voucher.txt_rate2_"+s);
				}
			}
		else 
			for(s=1;s<=eval("payment_with_voucher.kur_say").value;s++)
			{
				if(payment_with_voucher.rd_money[s-1].checked == true)
				{
					deger_diger_para = payment_with_voucher.rd_money[s-1];
					form_txt_rate2_ = eval("payment_with_voucher.txt_rate2_"+s);
				}
			}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_txt_rate2_.value = filterNum(form_txt_rate2_.value,page_rate_round_num_js);
		eval("payment_with_voucher.total_amount").value = commaSplit((toplam_dongu_1 / parseFloat(deger_money_id_3) * (parseFloat(form_txt_rate2_.value,page_rate_round_num_js))),page_round_number_js);
		eval("payment_with_voucher.total_amount_hd").value = commaSplit((toplam_dongu_1_hd / parseFloat(deger_money_id_3) * (parseFloat(form_txt_rate2_.value,page_round_number_hd_js))),page_round_number_hd_js);
		eval("payment_with_voucher.other_total_amount").value = commaSplit(toplam_dongu_1,page_round_number_js);
		eval("payment_with_voucher.other_total_amount_hd").value = commaSplit(toplam_dongu_1_hd,page_round_number_hd_js);
		payment_with_voucher.tl_value1.value = deger_money_id_1;
		form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,page_rate_round_num_js);

		if (toplam_dongu_1 != 0)																			
			avg_duedate_new = parseInt(total_carpan_new / toplam_dongu_1);
		else
			avg_duedate_new = 0;
		
		avg_duedate_new = date_add('d',avg_duedate_new,payment_with_voucher.today_.value);
		payment_with_voucher.average_due_date.value = avg_duedate_new;	 	//ortalama Vade
	}
	function payment_with_voucher_remove(sy,type)
	{
		if(type == 0)
		{
			var my_element=eval("payment_with_voucher.row_kontrol"+sy);
			my_element.value=0;
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
			payment_with_voucher_toplam_hesapla();
		}
		else
		{
			var my_element=eval("payment_with_voucher.row_kontrol"+sy);
			my_element.value=0;
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
			payment_with_voucher_toplam_hesapla();
			deger_vade_tarih = payment_with_voucher.revenue_start_date.value;
			a=0;
			for(var k=1;k<=payment_with_voucher.record_num.value;k++)
			{
				if(eval("payment_with_voucher.row_kontrol"+k).value==1)
				{
					if(eval("payment_with_voucher.is_cash_row"+k).value==0)
					{
						a=a+1;
						
						if(a==1 && payment_with_voucher.paymethod_add_duedate.value!='' && payment_with_voucher.paymethod_add_duedate.value!=0)
							deger_vade_tarih = date_add('d',+ payment_with_voucher.paymethod_add_duedate.value,deger_vade_tarih);						
						else if(a >1) //ilk taksitte vade baslangıc tarihi baz alınır
							deger_vade_tarih = date_add('m',+1,deger_vade_tarih);
					}
					eval("payment_with_voucher.due_date" + k).value = deger_vade_tarih;
					if(eval("payment_with_voucher.is_cash_row"+k).value==0) //peşinat satırı degilse
						eval("payment_with_voucher.voucher_name" + k).value =paper_no_+ ' - '+ a +'. Taksit';
					else
						eval("payment_with_voucher.voucher_name" + k).value =paper_no_+ ' - PEŞİNAT';
				}
			}
		}
	}
	function add_row(row_due_value,row_first_value,row_first_value_hd,row_value,row_value_hd,row_date,rowcount,is_cash_row)
	{
		row_count++;
		var newRow;
		var newCell;
		if(row_value == undefined) var row_value='0';
		if(row_value_hd == undefined) var row_value_hd='';
		if(row_date == undefined) var row_date='';
		if(rowcount==undefined) var rowcount='';
		if(is_cash_row==undefined) var is_cash_row=0;//0 ise taksit satırı 1 ise pesinat satırıdır
		newRow = document.getElementById("payment_table_body").insertRow(document.getElementById("payment_table_body").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newRow.className = 'color-row';
		payment_with_voucher.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><input type="hidden" name="is_cash_row'+row_count +'" id="is_cash_row'+row_count +'" value="'+is_cash_row+'"><a href="javascript://" onclick="payment_with_voucher_remove(' + row_count + ',1);"><i class="fa fa-minus" title="payment_with_voucher_remove"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		if(is_cash_row==0)
			newCell.innerHTML = '<div class="form-group"><input type="text" name="voucher_name' + row_count +'" id="voucher_name' + row_count +'" value="'+ paper_no_ + ' - ' + rowcount +'.Taksit" class="boxtext"></div>';
		else
			newCell.innerHTML = '<div class="form-group"><input type="text" name="voucher_name' + row_count +'" id="voucher_name' + row_count +'" value="'+ paper_no_ +' - PEŞİNAT" class="boxtext"></div>';
		<cfif attributes.str_table is 'ORDERS'>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" name="row_detail' + row_count +'" id="row_detail' + row_count +'" value=""></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","due_date" + row_count + "_td");
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="duedate_diff' + row_count +'" id="duedate_diff' + row_count +'" value=""><input type="text" name="due_date' + row_count +'" id="due_date' + row_count +'" style="width:65px;" class="text" maxlength="10" value="'+ row_date+'">';
		wrk_date_image('due_date' + row_count);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="voucher_system_value_hd' + row_count +'" id="voucher_system_value_hd' + row_count +'" value="'+ row_value_hd +'"><input type="text" name="voucher_system_value' + row_count +'" id="voucher_system_value' + row_count +'" value="'+ row_value +'" class="box" onBlur="payment_with_voucher_toplam_hesapla_system(' + row_count +');" onkeyup="return(FormatCurrency(this,event,'+page_round_number_js+'));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="voucher_value_hd' + row_count +'" id="voucher_value_hd' + row_count +'" value="'+ row_value_hd +'"><input type="text" name="voucher_value' + row_count +'" id="voucher_value' + row_count +'" value="'+ row_value +'"  class="box" onBlur="payment_with_voucher_hesapla(' + row_count +');" onkeyup="return(FormatCurrency(this,event,'+page_round_number_js+'));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="money_type' + row_count  +'" id="money_type' + row_count  +'" class="boxtext"><cfoutput><option value="#attributes.paper_money#">#attributes.paper_money#</option></cfoutput></select></div>';
		<cfif xml_payment_plan_type neq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><select name="paymethod_row_id' + row_count  +'" id="paymethod_row_id' + row_count  +'" onchange="change_paper_duedate(' + row_count  +')"><option value=""><cf_get_lang dictionary_id ="57734.Seçiniz"><cfoutput query="get_paymethod"><option value="#paymethod_id#" <cfif isdefined("attributes.paymethod_id") and attributes.paymethod_id eq paymethod_id>selected</cfif>>#paymethod#</option></cfoutput></select></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="checkbox" name="is_active' + row_count  +'" id="is_active' + row_count  +'" value="1" onclick="payment_with_voucher_toplam_hesapla_system(' + row_count  +')" checked="checked" disabled="disabled">';
		</cfif>
			
		if (row_due_value == 0)
		{
			a=0;
			deger_vade_tarih = payment_with_voucher.revenue_start_date.value;
			for(k=1;k<=payment_with_voucher.record_num.value;k++)
			{
				if(eval("payment_with_voucher.row_kontrol"+k).value==1)
				{
					if(eval("payment_with_voucher.is_cash_row"+k).value==0)
					{
						a=a+1;
						//odmee yonteminin vade baslangıc tarihi varsa satır ilk takside yansıtılır
						if(a==1 && payment_with_voucher.paymethod_add_duedate.value!='' && payment_with_voucher.paymethod_add_duedate.value!=0)
							deger_vade_tarih = date_add('d',+ payment_with_voucher.paymethod_add_duedate.value,deger_vade_tarih);
						else if(a >1) //ilk taksitte vade baslangıc tarihi baz alınır
							deger_vade_tarih = date_add('m',+1,deger_vade_tarih);
					}
					eval("payment_with_voucher.due_date" + k).value = deger_vade_tarih;
					eval("payment_with_voucher.duedate_diff" + k).value = Math.abs(datediff(deger_vade_tarih,payment_with_voucher.today_.value,1));
					row_detail_= eval("payment_with_voucher.voucher_name" + k).value;
					if(eval("payment_with_voucher.is_cash_row"+k).value==0) //peşinat satırı degilse
						eval("payment_with_voucher.voucher_name" + k).value =paper_no_+ ' - '+ a +'. Taksit';
					else
						eval("payment_with_voucher.voucher_name" + k).value =paper_no_+ ' - PEŞİNAT';
				}
			}
		}
		else
		{
			eval("payment_with_voucher.due_date" + row_count).value = payment_with_voucher.revenue_start_date.value;
			eval("payment_with_voucher.duedate_diff" + row_count).value = Math.abs(datediff(payment_with_voucher.revenue_start_date.value,payment_with_voucher.today_.value,1));
			eval("payment_with_voucher.voucher_name" + row_count).value = paper_no_;
		}
		payment_with_voucher_toplam_hesapla();
	}
	function add_new_row()
	{
		if (payment_with_voucher.record_num.value > 0)
		{
			for(var tt=1;tt<=payment_with_voucher.record_num.value;tt++)
			{
				if(eval("payment_with_voucher.row_kontrol"+tt).value==1)
				{
					payment_with_voucher_remove(tt,0);
				}
			}
		}
		deger_toplam = payment_with_voucher.net_total;
		deger_toplam_hd = payment_with_voucher.net_total_hd;
		payment_with_voucher.cash_payment_hd.value = payment_with_voucher.cash_payment.value;
		deger_pesin = payment_with_voucher.cash_payment;
		deger_pesin_hd = payment_with_voucher.cash_payment_hd;
		deger_due_value = payment_with_voucher.due_month;
		deger_toplam.value = filterNum(deger_toplam.value,page_round_number_js);
		deger_toplam_hd.value = filterNum(deger_toplam_hd.value,page_round_number_hd_js);
		pesinat_tutar=filterNum(payment_with_voucher.cash_payment.value);
		pesinat_tutar_hd=filterNum(payment_with_voucher.cash_payment_hd.value);
		deger_pesin.value = filterNum(deger_pesin.value,page_round_number_js);
		deger_pesin_hd.value = filterNum(deger_pesin_hd.value,page_round_number_hd_js);
		deger_due_value.value = filterNum(deger_due_value.value,page_round_number_js);
		deger_vade_total = parseFloat(deger_toplam.value,page_round_number_js) - parseFloat(deger_pesin.value,page_round_number_js);
		deger_vade_total_hd = parseFloat(deger_toplam_hd.value,page_round_number_hd_js) - parseFloat(deger_pesin_hd.value,page_round_number_hd_js);
		my_row_value =  deger_vade_total / parseFloat(deger_due_value.value,page_round_number_js);
		my_row_value = commaSplit(my_row_value,page_round_number_js);
		my_row_value_hd =  deger_vade_total_hd / parseFloat(deger_due_value.value,page_round_number_hd_js);
		my_row_value_hd = commaSplit(my_row_value_hd,page_round_number_hd_js);
		deger_toplam.value = commaSplit(deger_toplam.value,page_round_number_js);
		deger_toplam_hd.value = commaSplit(deger_toplam_hd.value,page_round_number_hd_js);
		deger_pesin.value = commaSplit(deger_pesin.value,page_round_number_js);
		deger_pesin_hd.value = commaSplit(deger_pesin_hd.value,page_round_number_hd_js);
		deger_vade_tarih = payment_with_voucher.revenue_start_date.value;
		cash_due_date = payment_with_voucher.paper_action_date.value;
		paymethod_add_duedate_= payment_with_voucher.paymethod_add_duedate.value;
		if(pesinat_tutar > 0) //pesinat tutarı için satır ekleniyor
			add_row(0,deger_pesin.value,deger_pesin_hd.value,deger_pesin.value,deger_pesin_hd.value,cash_due_date,1,1);
			
		for(i=1;i<=payment_with_voucher.due_month.value;i++)
		{
			if(i==1 && paymethod_add_duedate_!='' && paymethod_add_duedate_!=0) //odeme yonteminde vade baslangıc tarihi varsa bu sayı vade baslangıca eklenip, ilk takside yansıtılır.
				deger_vade_tarih = date_add('d',+paymethod_add_duedate_,deger_vade_tarih);

			add_row(0,my_row_value,my_row_value_hd,my_row_value,my_row_value_hd,deger_vade_tarih,i);
			deger_vade_tarih = date_add('m',+1,deger_vade_tarih);
		}
	}
	
	function change_paper_duedate(satir_no)
	{
		var date_informations = wrk_safe_query('obj_get_pay','dsn',0,eval("payment_with_voucher.paymethod_row_id"+ satir_no).value);
		vade_tarih_ = payment_with_voucher.paper_action_date.value;
		if(date_informations.DUE_DAY != '')
			vade_tarih_ = date_add('d',+ date_informations.DUE_DAY,payment_with_voucher.paper_action_date.value);
		if(date_informations.DUE_START_DAY != '')
			vade_tarih_ = date_add('d',+ date_informations.DUE_START_DAY,vade_tarih_);
		if(date_informations.DUE_START_MONTH != '')	
			vade_tarih_ = date_add('m',+ date_informations.DUE_START_MONTH,vade_tarih_);
		
		eval("payment_with_voucher.due_date"+ satir_no).value = fix_date_value(vade_tarih_);
		payment_with_voucher_toplam_hesapla();
	}
	
	function payment_with_voucher_unformat_fields()
	{
		for(r=1;r<=payment_with_voucher.record_num.value;r++)
		{
			deger_net_total = eval("payment_with_voucher.voucher_value"+r);
			deger_net_total.value = filterNum(deger_net_total.value,page_round_number_js);
			
			deger_other_net_total = eval("payment_with_voucher.voucher_system_value"+r);
			deger_other_net_total.value = filterNum(deger_other_net_total.value,page_round_number_js);

			deger_row_other_total_hd = eval("payment_with_voucher.voucher_value_hd"+r);
			deger_row_other_total_hd.value = filterNum(deger_row_other_total_hd.value,page_round_number_hd_js);
			
			if(eval("payment_with_voucher.row_kontrol"+r).value==1)
			{
				if(eval("payment_with_voucher.voucher_name"+r) != undefined && eval("payment_with_voucher.voucher_name"+r).disabled == true)
				eval("payment_with_voucher.voucher_name"+r).disabled = false;
				if(eval("payment_with_voucher.voucher_system_value"+r) != undefined && eval("payment_with_voucher.voucher_system_value"+r).disabled == true)
					eval("payment_with_voucher.voucher_system_value"+r).disabled = false;	
				if(eval("payment_with_voucher.voucher_value"+r) != undefined && eval("payment_with_voucher.voucher_value"+r).disabled == true)
					eval("payment_with_voucher.voucher_value"+r).disabled = false;
				if(eval("payment_with_voucher.money_type"+r) != undefined && eval("payment_with_voucher.money_type"+r).disabled == true)
					eval("payment_with_voucher.money_type"+r).disabled = false;
				if(eval("payment_with_voucher.is_active"+r) != undefined && eval("payment_with_voucher.is_active"+r).disabled == true)
					 eval("payment_with_voucher.is_active"+r).disabled = false;
			}
		}
		payment_with_voucher.total_amount.value = filterNum(payment_with_voucher.total_amount.value,page_round_number_js); 
		payment_with_voucher.other_total_amount.value = filterNum(payment_with_voucher.other_total_amount.value,page_round_number_js);
		payment_with_voucher.net_total.value = filterNum(payment_with_voucher.net_total.value,page_round_number_js);
		for(s=1;s<=payment_with_voucher.kur_say.value;s++)
		{
			eval("payment_with_voucher.txt_rate2_" + s).value = filterNum(eval("payment_with_voucher.txt_rate2_" + s).value,page_rate_round_num_js);
			eval("payment_with_voucher.txt_rate1_" + s).value = filterNum(eval("payment_with_voucher.txt_rate1_" + s).value,page_rate_round_num_js);
		}
	}
	<cfif not ListFind("4,5",get_paper_detail.CARI_ACTION_TYPE) and xml_payment_plan_type eq 1>
		add_new_row();
	<cfelse>
		payment_with_voucher_toplam_hesapla();
	</cfif>
</script>

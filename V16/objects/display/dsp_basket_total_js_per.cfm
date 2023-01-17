<cfset account_status = 1>
<cfset cash_status = 1>
<cfinclude template="../query/get_cashes.cfm">
<cfinclude template="../query/get_pos_equipment_bank.cfm">
<cfif not isdefined("attributes.form_add") and isdefined("url.iid") and isdefined("GET_SALE_DET") and (GET_SALE_DET.IS_CASH eq 1)>
	<cfquery name="control_cashes" datasource="#dsn2#">
		SELECT 
			INVOICE_CASH_POS.KASA_ID,
			CASH_ACTIONS.*
		FROM
			INVOICE,
			INVOICE_CASH_POS,
			CASH_ACTIONS
		WHERE
			CASH_ACTIONS.ACTION_ID=INVOICE_CASH_POS.CASH_ID
			AND INVOICE_CASH_POS.INVOICE_ID=INVOICE.INVOICE_ID 
			AND INVOICE.INVOICE_ID=#url.iid#
		ORDER BY 
			INVOICE_CASH_POS.KASA_ID DESC
	</cfquery>
	<cfset kasa_listesi=listsort(valuelist(control_cashes.KASA_ID,','),'numeric','desc',',')>
<cfelse>
	<cfset kasa_listesi="">
	<cfset control_cashes.recordcount=0>
</cfif>
<cfif not isdefined("attributes.form_add") and isdefined("url.iid")>
	<cfquery name="CONTROL_POS_PAYMENT" datasource="#dsn2#" maxrows="5">
		SELECT 
			INVOICE_CASH_POS.*,
			CREDIT_CARD_BANK_PAYMENTS.*
		FROM
			INVOICE,
			INVOICE_CASH_POS,
			#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CREDIT_CARD_BANK_PAYMENTS
		WHERE
			INVOICE.INVOICE_ID=INVOICE_CASH_POS.INVOICE_ID
			AND INVOICE_CASH_POS.POS_ACTION_ID=CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID
			AND INVOICE.INVOICE_ID=#url.iid# AND
			INVOICE_CASH_POS.POS_PERIOD_ID = #session_base.period_id#
		ORDER BY
			INVOICE_CASH_POS.POS_ACTION_ID
	</cfquery>
<cfelse>
	<cfset CONTROL_POS_PAYMENT.recordcount=0>
</cfif>
<div class="col col-3 col-md-4 col-sm-6 col-xs-12" id="basket_money_totals_table">
    <div class="totalBox">
        <div class="totalBoxHead font-grey-mint">
			<span class="headText"><cf_get_lang dictionary_id='57673.Tutar'></span>
			<div class="collapse"><span class="icon-minus"></span></div>
        </div>
        <div class="totalBoxBody">
			<cfif GET_CASHES.recordcount><!---tanımlı kasa varsa --->
				<div class="col col-4">
					<label class="col col-12 col-xs-12 txtbold text-center mt-2"><cf_get_lang dictionary_id='57673.Tutar'> - <cf_get_lang dictionary_id='58645.Nakit'></label>
				</div>
				<div class="col col-8">
					<label class="col col-12 col-xs-12 txtbold text-center mt-2"><cf_get_lang dictionary_id='57520.Kasa'></label>
				</div>
				<cfoutput query="get_money_bskt">
					<cfquery name="get_money_cashes" dbtype="query">
						SELECT
							CASH_ID, CASH_NAME,
							CASH_CURRENCY_ID
						FROM 
							GET_CASHES
						WHERE 
							CASH_CURRENCY_ID='#money_type#'
					</cfquery>
					<cfif get_money_cashes.recordcount>
						<cfif control_cashes.recordcount>
							<cfquery name="get_cash_amount" dbtype="query">
								SELECT CASH_ACTION_VALUE,ACTION_ID FROM control_cashes WHERE CASH_ACTION_CURRENCY_ID='#money_type#'
							</cfquery>
						</cfif>
						<div class="col col-12">
							<div class="col col-4">
								<div class="form-group">
									<input type="text" id="cash_amount#currentrow#" name="cash_amount#currentrow#" value="<cfif control_cashes.recordcount>#TLFormat(get_cash_amount.CASH_ACTION_VALUE)#</cfif>" style="width:100px;" class="moneybox" onKeyUp="kasa_dovizi_hesapla(#currentrow#,0);return(FormatCurrency(this,event));" ><!--- onBlur="kasa_dovizi_hesapla(#currentrow#,0);" --->
									<input type="hidden" id="cash_action_id_#currentrow#" name="cash_action_id_#currentrow#" value="<cfif control_cashes.recordcount>#get_cash_amount.ACTION_ID#</cfif>">
								</div>
							</div>
							<div class="col col-8">
								<div class="form-group">
									<select id="kasa#currentrow#" name="kasa#currentrow#" style="width:140px;">
										<cfloop query="get_money_cashes">
											<option value="#get_money_cashes.CASH_ID#" <cfif listfind(kasa_listesi,get_money_cashes.CASH_ID,',')>selected</cfif>>#get_money_cashes.CASH_NAME#-#get_money_cashes.CASH_CURRENCY_ID#</option>
										</cfloop>
									</select>
									<input type="hidden" id="system_cash_amount#currentrow#" name="system_cash_amount#currentrow#" value=""><!--- simdilik gerek olmadigi icin commasplitten gecirilmeden deger atanıyor ve submitten oncede filterNum kontrolu yok, sistem para birimine gore para miktarini tutuyor --->
									<input type="hidden" id="currency_type#currentrow#" name="currency_type#currentrow#" value="#money_type#">
								</div>
							</div>
						</div>
					</cfif>
				</cfoutput>
			<cfelse>
				<strong><cf_get_lang dictionary_id='58739.Kasa Tanımları Eksik'>!</strong>
			</cfif>
			<cfif GET_POS_DETAIL.recordcount>
				<div class="col col-4">
					<label class="col col-12 col-xs-12 txtbold text-center mt-3"><cf_get_lang dictionary_id='57673.Tutar'> - <cf_get_lang dictionary_id='58199.Kredi Kartı'></label>
				</div>
				<div class="col col-8">
					<label class="col col-12 col-xs-12 txtbold text-center mt-3"><cf_get_lang dictionary_id='57521.Banka'></label>
				</div>
				<cfoutput>
					<cfloop from="1" to="5" index="kkm">
						<div class="col col-12">
							<div class="col col-4">
								<div class="form-group">
									<input type="text" id="pos_amount_#kkm#" name="pos_amount_#kkm#" value="<cfif CONTROL_POS_PAYMENT.recordcount and len(CONTROL_POS_PAYMENT.SALES_CREDIT[#kkm#])>#TLFormat(CONTROL_POS_PAYMENT.SALES_CREDIT[kkm])#</cfif>" style="width:100px;" class="moneybox" onKeyUp="pos_hesapla(#kkm#,0);return(FormatCurrency(this,event));" ><!--- onBlur="pos_hesapla(#kkm#,0);" --->
									<input type="hidden" id="pos_action_id_#kkm#" name="pos_action_id_#kkm#" value="<cfif CONTROL_POS_PAYMENT.recordcount and len(CONTROL_POS_PAYMENT.CREDITCARD_PAYMENT_ID[#kkm#])>#CONTROL_POS_PAYMENT.CREDITCARD_PAYMENT_ID[kkm]#</cfif>">
									<input type="hidden" id="system_pos_amount_#kkm#" name="system_pos_amount_#kkm#" value="">
								</div>
							</div>
							<div class="col col-8">
								<div class="form-group">
									<select id="POS_#kkm#" name="POS_#kkm#" style="width:140px;" onChange="pos_hesapla(#kkm#,0);">
										<cfloop query="GET_POS_DETAIL"><!---eleman sırası değişmesin AE--->
											<option value="#ACCOUNT_ID#;#ACCOUNT_CURRENCY_ID#;#PAYMENT_TYPE_ID#" <cfif CONTROL_POS_PAYMENT.recordcount and (GET_POS_DETAIL.PAYMENT_TYPE_ID eq CONTROL_POS_PAYMENT.PAYMENT_TYPE_ID[#kkm#])>selected</cfif>>#ACCOUNT_NAME# / #CARD_NO#</option>
										</cfloop>
									</select>
								</div>
							</div>
						</div>
					</cfloop>
				</cfoutput>
			<cfelse>
				<br/><strong><cf_get_lang dictionary_id='58740.Pos Tanımları Eksik'>!</strong>
			</cfif>
			<cfif GET_CASHES.recordcount or GET_POS_DETAIL.recordcount>
				<tr>
					<div class="col col-6">
						<label class="col col-12 col-xs-12 txtbold text-center" style="margin-top: 10px;"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57847.Ödeme'></label>
					</div>
					<div class="col col-6">
						<label class="col col-12 col-xs-12 txtbold text-center" style="margin-top: 10px;"><cf_get_lang dictionary_id='58583.Fark'></label>
					</div>
					<div class="col col-12">
						<div class="col col-6">
							<div class="form-group">
								<input type="text" id="total_cash_amount" name="total_cash_amount" value="" style="width:100px;margin-bottom:5px;" class="moneybox" readonly="yes">
							</div>
						</div>
						<div class="col col-6">
							<div class="form-group">
								<input type="text" id="diff_amount" name="diff_amount" value="" style="width:80px;" class="moneybox" readonly="yes">
							</div>
						</div>
					</div>
			</cfif>
        </div>
    </div>    
</div>  

			

<script type="text/javascript">

	function kasa_dovizi_hesapla(sira_no,is_common)
	{	
		kasa_money_rate2 = eval('form_basket.txt_rate2_' + sira_no).value;
		kasa_money_rate1=eval('form_basket.txt_rate1_' + sira_no).value;	
		if (eval('form_basket.cash_amount' + sira_no)!=undefined && eval('form_basket.cash_amount' + sira_no).value!= "")
			{
			sistem_tutar=(filterNum(eval('form_basket.cash_amount' + sira_no).value,4)*(filterNum(kasa_money_rate2,4)/filterNum(kasa_money_rate1,4)));
			eval('form_basket.system_cash_amount'+sira_no).value=wrk_round(sistem_tutar);
			}
		if (!is_common)
			toplam_tahsilat();
	}
	
	function pos_hesapla(pos_row,is_common)
	{	
		if(eval('form_basket.pos_amount_'+pos_row)!= undefined)
		{
			if(eval('form_basket.pos_amount_'+pos_row).value!="")
			{
				pos_money_list=new Array(1);
				<cfoutput query="get_money_bskt">
					pos_money_list.push('#get_money_bskt.money_type#');
				</cfoutput>
				for(var jxj=1; jxj<=pos_money_list.length-1; jxj++ )
				{
					pos_deger = eval('form_basket.POS_'+pos_row).value.split(';');
					pos_currency=pos_deger[1];
					if(pos_money_list[jxj] == pos_currency)
						{
							temp_pos_amount= eval('form_basket.pos_amount_'+pos_row).value;
							temp_rate2=eval('form_basket.txt_rate2_' + jxj).value;
							temp_rate1=eval('form_basket.txt_rate1_' + jxj).value;
							eval('form_basket.system_pos_amount_'+pos_row).value=wrk_round(filterNum(temp_pos_amount,4)*(filterNum(temp_rate2,4)/filterNum(temp_rate1,4)));
						}
				}
			}
			else
				eval('form_basket.system_pos_amount_'+pos_row).value=0;
			if (!is_common)
				toplam_tahsilat();
		}
	}
	
	function toplam_tahsilat()
	{	
		tahsilat_tutari=0;
		for(var n=1; n <= form_basket.kur_say.value; n++)
		{
			if(eval('form_basket.cash_amount'+n)!= undefined && eval('form_basket.cash_amount'+n).value!="")
				tahsilat_tutari = tahsilat_tutari+parseFloat(eval('form_basket.system_cash_amount'+n).value);
		}
		for(var m=1; m<=5; m++)
		{
			if(eval('form_basket.pos_amount_'+m)!= undefined && eval('form_basket.pos_amount_'+m).value!="")
				tahsilat_tutari = tahsilat_tutari+parseFloat(eval('form_basket.system_pos_amount_'+m).value);
		}
		if(form_basket.diff_amount != undefined && form_basket.total_cash_amount != undefined) {	
		form_basket.diff_amount.value=commaSplit(form_basket.basket_net_total.value-tahsilat_tutari);
		form_basket.total_cash_amount.value=commaSplit(tahsilat_tutari); }
	}
	function genel_kontrol()
	{
		for(var g=1; g <=5; g++)
			pos_hesapla(g,1); //1 pos_hesapla fonksiyonundaki toplam tahsilat fonk. calismamasi icin
		for(var c=1; c <= form_basket.kur_say.value; c++)
			kasa_dovizi_hesapla(c,1); //1 kasa_dovizi_hesapla fonksiyonundaki toplam tahsilat fonk. calismamasi icin
		toplam_tahsilat();
	}
	$(document).ready(function(){

		genel_kontrol();
	});
	
</script>

<cfquery name="GET_OUR_COMPANIES" datasource="#dsn#">
	SELECT 
	    COMP_ID,
		COMPANY_NAME 
	FROM 
	    OUR_COMPANY
	ORDER BY 
		COMPANY_NAME
</cfquery>
<cfquery name="GET_MONEY" datasource="#dsn2#">
	SELECT 
		MONEY_ID, 
		MONEY, 
		RATE1, 
		RATE2, 
		PERIOD_ID, 
		COMPANY_ID, 
		RATE3, 
		EFFECTIVE_SALE, 
		EFFECTIVE_PUR 
	FROM 
		SETUP_MONEY 
	ORDER BY 
		MONEY_ID
</cfquery>
<cfquery name="GET_PAYMETHOD" datasource="#dsn#">
	SELECT 
		SP.PAYMETHOD_ID, 
		SP.PAYMETHOD, 
		SP.DETAIL, 
		SP.MONEY, 
		SP.RECORD_DATE, 
		SP.RECORD_EMP, 
		SP.RECORD_IP, 
		SP.UPDATE_DATE, 
		SP.UPDATE_EMP, 
		SP.UPDATE_IP, 
		SP.PAYMETHOD_STATUS 
	FROM 
		SETUP_PAYMETHOD SP,
		SETUP_PAYMETHOD_OUR_COMPANY SPOC 
	WHERE
		SP.PAYMETHOD_STATUS = 1
		AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
		AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY 
		SP.PAYMETHOD
</cfquery>
<cfquery name="GET_BLACKLIST_INFO" datasource="#DSN#">
	SELECT 
		BLACKLIST_INFO_ID, 
		BLACKLIST_INFO_NAME, 
		RECORD_DATE, 
		RECORD_EMP, 
		RECORD_IP, 
		UPDATE_DATE, 
		UPDATE_EMP, 
		UPDATE_IP 
	FROM 
		SETUP_BLACKLIST_INFO
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform action="#request.self#?fuseaction=contract.emptypopup_addcompany_credit_total&is_popup=1" method="post" name="add_credit" onsubmit="return (unformat_fields());">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
						</div>
					</div>
					<div class="form-group" id="item-our_company_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50945.Şirketimiz'></label>
						<div class="col col-8 col-xs-12">
							<select name="our_company_id" id="our_company_id">
								<cfoutput query="get_our_companies">
									<option value="#COMP_ID#">#company_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-company_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif isdefined("attributes.cpid") and len(attributes.cpid)>
									<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.cpid#</cfoutput>">
									<input type="hidden" name="consumer_id" id="consumer_id" value="">
									<cfinput type="text" name="company_name" value="#get_par_info(attributes.cpid,1,0,0)#" passthrough="readonly">	
								<cfelseif isdefined("attributes.cid") and len(attributes.cid)>
									<input type="hidden" name="company_id" id="company_id" value="">
									<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.cid#</cfoutput>">
									<cfinput type="text" name="company_name" value="#get_cons_info(attributes.cid,0,0)#" passthrough="readonly">	
								<cfelse>
									<input type="hidden" name="consumer_id" id="consumer_id" value="">
									<input type="hidden" name="company_id" id="company_id" value="">
									<cfinput type="text" name="company_name" value="" passthrough="readonly">	
									<span class="input-group-addon icon-ellipsis" onClick="javascript:openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_id=add_credit.company_id&field_consumer=add_credit.consumer_id&field_member_name=add_credit.company_name</cfoutput>');"></span>
								</cfif>
							</div>		
						</div>
					</div>
					<div class="form-group" id="item-OPEN_ACCOUNT_RISK_LIMIT">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57875.Açık Hesap Limiti'></label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57875.Açık Hesap Limiti'></cfsavecontent>
							<cfinput type="Text" class="moneybox"  name="OPEN_ACCOUNT_RISK_LIMIT" value="0" passthrough="onkeyup=""return(FormatCurrency(this,event));"" onBlur=""doviz_hesapla();""" required="yes" message="#message#">
						</div>
					</div>
					<div class="form-group" id="item-OPEN_ACCOUNT_RISK_LIMIT_OTHER_CASH">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50971.Açık Hesap Limiti Döviz'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="Text" class="moneybox" name="OPEN_ACCOUNT_RISK_LIMIT_OTHER_CASH" value="0" passthrough="onkeyup=""return(FormatCurrency(this,event));"" onBlur=""ytl_hesapla();"" ">
						</div>
					</div>
					<div class="form-group" id="item-FORWARD_SALE_LIMIT">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50766.Vadeli Ödeme Limiti'></label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='50766.Vadeli Ödeme Limiti'></cfsavecontent>
							<cfinput type="Text" class="moneybox" name="FORWARD_SALE_LIMIT" value="0" passthrough = "onkeyup=""return(FormatCurrency(this,event));""onBlur=""doviz_hesapla();""" required="yes" message="#message#">
						</div>
					</div>
					<div class="form-group" id="item-FORWARD_SALE_LIMIT_OTHER_CASH">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51008.Vadeli Ödeme Limiti Döviz'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="Text" class="moneybox" name="FORWARD_SALE_LIMIT_OTHER_CASH" value="0" passthrough = "onkeyup=""return(FormatCurrency(this,event));"" onBlur=""ytl_hesapla();""">
						</div>
					</div>
					<div class="form-group" id="item-PAYMENT_BLOKAJ">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50951.Ödeme Blokajı'></label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>: <cf_get_lang dictionary_id='50951.Ödeme Blokajı'>!</cfsavecontent>
							<cfinput type="Text" class="moneybox" name="PAYMENT_BLOKAJ" value="" passthrough="onkeyup=""return(FormatCurrency(this,event));""" message="#message#">
						</div>
					</div>
					<div class="form-group" id="item-blokaj_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50702.Blokaj Tipi'></label>
						<div class="col col-8 col-xs-12">
							<select name="blokaj_type" id="blokaj_type">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="1">%</option>
								<option value="2"><cf_get_lang dictionary_id='57673.Tutar'></option>
								<option value="3"><cf_get_lang dictionary_id='58906.Stok Maliyeti'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-LAST_PAYMENT_INTEREST">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58501.Vade Farkı'> %</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="Text" class="moneybox" name="LAST_PAYMENT_INTEREST" value="" passthrough="onkeyup=""return(FormatCurrency(this,event));""">
						</div>
					</div>
					<div class="form-group" id="item-FIRST_PAYMENT_INTEREST">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50950.Erken Ödeme İndirimi'>%</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="Text"  class="moneybox" name="FIRST_PAYMENT_INTEREST" value="" passthrough="onkeyup=""return(FormatCurrency(this,event));""">
						</div>
					</div>
					<div class="form-group" id="item-paymethod_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50947.Alış Ödeme Yöntemi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
								<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
								<input type="text" name="paymethod_name" id="paymethod_name" value="">
								<span class="input-group-addon icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=add_credit.paymethod_id&field_name=add_credit.paymethod_name&field_card_payment_id=add_credit.card_paymethod_id&field_card_payment_name=add_credit.paymethod_name</cfoutput>');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-revmethod_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50948.Satış Ödeme Yöntemi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="revmethod_id" id="revmethod_id" value="">
								<input type="hidden" name="card_revmethod_id" id="card_revmethod_id" value="">
								<input type="text" name="revmethod_name" id="revmethod_name" value="">
								<span class="input-group-addon icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=add_credit.revmethod_id&field_name=add_credit.revmethod_name&field_card_payment_id=add_credit.card_revmethod_id&field_card_payment_name=add_credit.revmethod_name</cfoutput>');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-instalment">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50952.Taksitli İşlem Yapılabilir'></label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="instalment" id="instalment">
						</div>
					</div>
					<div class="form-group" id="item-is_blacklist">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58646.Kara Liste'></label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="is_blacklist" id="is_blacklist" value="1" onClick="check_info();">
						</div>
					</div>
					<div class="form-group hide" id="item-blacklist_info">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58647.Kara Listeye Alınma Nedeni'></label>
						<div class="col col-8 col-xs-12">
							<select name="blacklist_info" id="blacklist_info" >
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_blacklist_info">
									<option value="#blacklist_info_id#">#blacklist_info_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group hide" id="item-blacklist_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58648.Kara Listeye Alınma Tarihi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput validate="#validate_style#" type="text" name="blacklist_date" value="">
								<span class="input-group-addon"><cf_wrk_date_image date_field="blacklist_date"></span>
							</div>
						</div>
					</div>
				</div> 
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="row">
						<label class="col col-12 bold"><cf_get_lang dictionary_id='50973.İşlem Para Birimi'></label>
					</div>
					<input type="hidden" name="deger_get_money" id="deger_get_money" value="<cfoutput>#get_money.recordcount#</cfoutput>">
					<cfoutput>
						<cfif len(session.ep.money2)>
							<cfset selected_money=session.ep.money2>
						<cfelse>
							<cfset selected_money=session.ep.money>
						</cfif>
						<cfif session.ep.rate_valid eq 1>
							<cfset readonly_info = "yes">
						<cfelse>
							<cfset readonly_info = "no">
						</cfif>
							<cfloop query="get_money">
								<div class="form-group">
									<div class="col col-2 col-md-2 col-sm-2 col-xs-6">
										<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
										<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
										<input type="radio" name="other_money" id="other_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="doviz_hesapla();" <cfif selected_money eq money>checked</cfif>>
										<label>#money#</label>
									</div>
									<div class="col col-2 col-md-4 col-sm-4 col-xs-12"><label>#TLFormat(rate1,0)# /</label></div>
									<div class="col col-6">
										<input type="text" <cfif readonly_info>readonly</cfif> class="box" name="value_rate2#currentrow#" id="value_rate2#currentrow#" value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="doviz_hesapla();">
									</div>
								</div>
							</cfloop>			
					</cfoutput>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons type_format='1' is_upd='0' add_function = 'kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if (document.add_credit.company_name.value == "")
		{
			alert("<cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='57519.Cari Hesap'> !");
			return false;
		}
		return process_cat_control();
	}
	function unformat_fields()
	{
		document.add_credit.OPEN_ACCOUNT_RISK_LIMIT.value = filterNum(document.add_credit.OPEN_ACCOUNT_RISK_LIMIT.value);
		document.add_credit.OPEN_ACCOUNT_RISK_LIMIT_OTHER_CASH.value = filterNum(document.add_credit.OPEN_ACCOUNT_RISK_LIMIT_OTHER_CASH.value);
		document.add_credit.FORWARD_SALE_LIMIT.value = filterNum(document.add_credit.FORWARD_SALE_LIMIT.value);
		document.add_credit.FORWARD_SALE_LIMIT_OTHER_CASH.value = filterNum(document.add_credit.FORWARD_SALE_LIMIT_OTHER_CASH.value);
		document.add_credit.PAYMENT_BLOKAJ.value = filterNum(document.add_credit.PAYMENT_BLOKAJ.value);
		document.add_credit.LAST_PAYMENT_INTEREST.value = filterNum(document.add_credit.LAST_PAYMENT_INTEREST.value);
		document.add_credit.FIRST_PAYMENT_INTEREST.value = filterNum(document.add_credit.FIRST_PAYMENT_INTEREST.value);
		for(s=1;s<=add_credit.deger_get_money.value;s++)
		{
			eval('add_credit.value_rate2' + s).value = filterNum(eval('add_credit.value_rate2' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		return true;
	}
	function doviz_hesapla()
	{
		toplam =eval("document.add_credit.OPEN_ACCOUNT_RISK_LIMIT");
		toplam1=eval("document.add_credit.FORWARD_SALE_LIMIT");
		toplam.value=filterNum(toplam.value);
		toplam1.value=filterNum(toplam1.value);
		toplam=parseFloat(toplam.value);
		toplam1=parseFloat(toplam1.value);
		for(s=1;s<=add_credit.deger_get_money.value;s++)
		{
			if(document.add_credit.other_money[s-1].checked == true)
			{
				deger_diger_para = document.add_credit.other_money[s-1];
				form_value_rate2=eval("document.add_credit.value_rate2"+s);
			}
		}
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_value_rate2.value = filterNum(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		if(toplam>0)
		{
			document.add_credit.OPEN_ACCOUNT_RISK_LIMIT_OTHER_CASH.value = commaSplit(toplam * parseFloat(deger_money_id_3)/(parseFloat(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')));
			document.add_credit.OPEN_ACCOUNT_RISK_LIMIT.value=commaSplit(toplam);
		}
		else
		{
			document.add_credit.OPEN_ACCOUNT_RISK_LIMIT_OTHER_CASH.value =0;
			document.add_credit.OPEN_ACCOUNT_RISK_LIMIT.value=0;
		}
		if(toplam1>0)
		{
		document.add_credit.FORWARD_SALE_LIMIT_OTHER_CASH.value = commaSplit(toplam1 * parseFloat(deger_money_id_3)/(parseFloat(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')));
		document.add_credit.FORWARD_SALE_LIMIT.value=commaSplit(toplam1);
		}
		else
		{
		document.add_credit.FORWARD_SALE_LIMIT_OTHER_CASH.value = 0;
		document.add_credit.FORWARD_SALE_LIMIT.value=0;
		}
		form_value_rate2.value = commaSplit(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		return true;
	}
	function ytl_hesapla()
	{
		toplam2 =eval("document.add_credit.OPEN_ACCOUNT_RISK_LIMIT_OTHER_CASH");
		toplam3=eval("document.add_credit.FORWARD_SALE_LIMIT_OTHER_CASH");
		toplam2.value=filterNum(toplam2.value);
		toplam3.value=filterNum(toplam3.value);
		toplam2=parseFloat(toplam2.value);
		toplam3=parseFloat(toplam3.value);
		for(s=1;s<=add_credit.deger_get_money.value;s++)
		{
			if(document.add_credit.other_money[s-1].checked == true)
			{
				deger_diger_para = document.add_credit.other_money[s-1];
				form_value_rate2=eval("document.add_credit.value_rate2"+s);
			}
		}
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_value_rate2.value = filterNum(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		if(toplam2>0)
		{
			document.add_credit.OPEN_ACCOUNT_RISK_LIMIT.value = commaSplit(toplam2 * parseFloat(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/(parseFloat(deger_money_id_3)));
			document.add_credit.OPEN_ACCOUNT_RISK_LIMIT_OTHER_CASH.value=commaSplit(toplam2);
		}
		else
		{
			document.add_credit.OPEN_ACCOUNT_RISK_LIMIT.value =0;
			document.add_credit.OPEN_ACCOUNT_RISK_LIMIT_OTHER_CASH.value=0;
		}
		if(toplam3>0)
		{
			document.add_credit.FORWARD_SALE_LIMIT.value = commaSplit(toplam3 *parseFloat(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>') /(parseFloat(deger_money_id_3)));
			document.add_credit.FORWARD_SALE_LIMIT_OTHER_CASH.value=commaSplit(toplam3);
		}
		else
		{
			document.add_credit.FORWARD_SALE_LIMIT.value = 0;
			document.add_credit.FORWARD_SALE_LIMIT_OTHER_CASH.value=0;
		}
		form_value_rate2.value = commaSplit(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		return true;
	}
	function check_info()
	{ 	//bu javascriptin düzenlenmesi lazım
		if(document.add_credit.is_blacklist.checked == true)
		{
			$("#item-blacklist_info").removeClass('hide');
			$("#item-blacklist_date").removeClass('hide');
		}
		else
		{
			$("#item-blacklist_info").addClass('hide');
			$("#item-blacklist_date").addClass('hide');
		}
	}
</script>



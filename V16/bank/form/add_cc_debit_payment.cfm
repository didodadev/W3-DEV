<cf_papers paper_type="creditcard_debit_payment">
<cfset money_info = ''>
<cfif isDefined("attributes.cc_info") and len(attributes.cc_info)>
	<cfquery name="get_cc_info" datasource="#dsn3#">
		SELECT
			<cfif session.ep.period_year lt 2009>
				CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID
			<cfelse>
				ACCOUNTS.ACCOUNT_CURRENCY_ID
			</cfif>
		FROM
			ACCOUNTS,
			CREDIT_CARD
		WHERE
			ACCOUNTS.ACCOUNT_ID = CREDIT_CARD.ACCOUNT_ID
			AND CREDIT_CARD.CREDITCARD_ID = #attributes.cc_info#
	</cfquery>
	<cfset money_info = get_cc_info.account_currency_id>
</cfif>
<cfinclude template="../query/get_accounts.cfm">

<cf_box title="#getLang(211,'Kredi Kartıyla Ödemeler',48872)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_cc_bank_action" method="post" action="#request.self#?fuseaction=bank.emptypopup_add_cc_debit_payment">
		<cfoutput>
			<cfset amount_total_info = 0>
			<cfif isdefined("attributes.row_id")>
				<input type="hidden" name="row_id" id="row_id" value="#attributes.row_id#">
			</cfif>
			<cfif isdefined("attributes.exp_count")>
				<input type="hidden" name="exp_count" id="exp_count" value="#attributes.exp_count#">
			</cfif>
			<cfif isDefined("attributes.cc_info") and len(attributes.cc_info)>
				<cfif isdefined("attributes.exp_count")>
					<cfif attributes.exp_count gt 0 and attributes.process_type neq 248 and attributes.x_interim_payments eq 1>
						<cfquery name="getInterimPayments" datasource="#dsn3#">
							WITH CTE AS(
							SELECT 
								BA.ACTION_ID,
								BA.ACTION_VALUE-ISNULL(BA.MASRAF,0) AS ACTION_VALUE,
								ROUND(ISNULL(SUM(CCB.CLOSED_AMOUNT),0),2) AS CLOSED_AMOUNT
							FROM 
								#dsn2_alias#.BANK_ACTIONS BA
								LEFT JOIN CREDIT_CARD_BANK_EXPENSE_RELATIONS CCB ON BA.ACTION_ID = CCB.BANK_ACTION_ID AND CCB.BANK_ACTION_PERIOD_ID = #session.ep.period_id#
							WHERE 
								BA.CREDITCARD_ID = #attributes.cc_info#
							GROUP BY
								BA.ACTION_ID,
								BA.ACTION_VALUE,
								BA.MASRAF
							)
						
							SELECT ISNULL(SUM((ACTION_VALUE - CLOSED_AMOUNT)),0) AS INTERIM_PAYMENTS FROM CTE WHERE (ACTION_VALUE-CLOSED_AMOUNT)>0
						</cfquery>
						<cfset amount_total_info = amount_total_info-getInterimPayments.INTERIM_PAYMENTS>
						<input type="hidden" name="interim_payment" id="interim_payment" value="#getInterimPayments.INTERIM_PAYMENTS#" />
					</cfif>
				</cfif>
			</cfif>
            <cfif isdefined("attributes.exp_count")>
				<cfloop from="1" to="#attributes.exp_count#" index="ii">
					<input type="hidden" name="exp_amount#ii#" id="exp_amount#ii#" value="#evaluate('attributes.exp_amount#ii#')#">
					<input type="hidden" name="exp_row_id#ii#" id="exp_row_id#ii#" value="#evaluate('attributes.exp_row_id#ii#')#">
					<cfset amount_total_info = amount_total_info + evaluate('attributes.exp_amount#ii#')>
				</cfloop>
			</cfif>
            <cfif amount_total_info lt 0><cfset amount_total_info = 0></cfif>
			<cfif isdefined("attributes.amount_val") and len(attributes.amount_val)>
				<cfset amount_total_info = attributes.amount_val>
			</cfif>
		</cfoutput>
		<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
		<cf_box_elements>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				
					<div style="<cfif isdefined("attributes.exp_count")>display:block<cfelse>display:none</cfif>" class="form-group" id="item-ACTION_FROM_ACCOUNT_ID">
						<label class="col col-3 col-xs-12"><cf_get_lang no='45.Banka/Hesap'></label>
						<div class="col col-9 col-xs-12">
							<select name="ACTION_FROM_ACCOUNT_ID" id="ACTION_FROM_ACCOUNT_ID" style="width:250px;" onChange="kur_ekle_f_hesapla('ACTION_FROM_ACCOUNT_ID');change_currency_info();">
								<option value=""><cf_get_lang_main no='1652.Banka Hesabı'></option>
								<cfoutput query="get_accounts"> 
									<option value="#ACCOUNT_ID#;#ACCOUNT_CURRENCY_ID#" <cfif isdefined("attributes.bcc_info") and attributes.bcc_info eq '#ACCOUNT_ID#;#ACCOUNT_CURRENCY_ID#'>selected="selected"</cfif>> #ACCOUNT_NAME#&nbsp;#ACCOUNT_CURRENCY_ID#</option>
								</cfoutput> 
							</select>
						</div>
					</div>
				
				<div class="form-group" id="item-credit_card">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='787.Kredi Kartı'> *</label>
					<div class="col col-9 col-xs-12">
						<cfif isDefined("attributes.cc_info") and len(attributes.cc_info)>
							<cf_wrk_our_credit_cards slct_width="250" onclick_function="kur_ekle_f_hesapla('credit_card_info');change_currency_info();" credit_card_info="#attributes.cc_info#" disabled_info='1'>
						<cfelse>
							<cf_wrk_our_credit_cards slct_width="250" onclick_function="kur_ekle_f_hesapla('credit_card_info');change_currency_info();get_account(this.value);">
						</cfif>
					</div>
				</div>
				<div class="form-group" id="item-process_cat">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='388.işlem tipi'> *</label>
					<div class="col col-9 col-xs-12">
						<cfif isdefined("attributes.process_type") and len(attributes.process_type)>
							<cf_workcube_process_cat slct_width="155" process_type_info="#attributes.process_type#">
						<cfelse>
							<cf_workcube_process_cat slct_width="155">	
						</cfif>
					</div>
				</div>
				<div class="form-group" id="item-paper_number">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='468.belge no'></label>
					<div class="col col-9 col-xs-12">
						<cfinput type="text" name="paper_number" value="#paper_code & '-' & paper_number#" style="width:155px;">
					</div>
				</div>
				<div class="form-group" id="item-start_date">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='467.İşlem Tarihi'> *</label>
					<div class="col col-9 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="56313.Hesaba Geçiş Tarihi Giriniz!"></cfsavecontent>
							<cfinput type="text" name="start_date" required="yes" value="#dateformat(now(),dateformat_style)#" style="width:155px;" message="#message#" onBlur="change_money_info('add_cc_bank_action','start_date');">
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date" call_function="change_money_info"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-action_value">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='261.Tutar'> *</label>
					<div class="col col-9 col-xs-12">
						<cfsavecontent variable="message1"><cf_get_lang no='83.Miktar giriniz'></cfsavecontent>
						<!--- (amount_total_info lte 0 or attributes.x_interim_payments eq 0) ara ödeme olmadan da tutar değişsin düzenleme yapıldı --->
						<cfif isdefined("attributes.exp_count") and exp_count gt 0 and (amount_total_info lte 0)>
							<cfinput type="text" name="action_value"  value="#TLFormat(amount_total_info)#" class="moneybox" readonly="yes" required="yes" message="#message1#" onBlur="kur_ekle_f_hesapla('ACTION_FROM_ACCOUNT_ID');" onkeyup="return(FormatCurrency(this,event));" style="width:155px;"> 
						<cfelse>
							<cfinput type="text" name="action_value"  value="#TLFormat(amount_total_info)#" class="moneybox" required="yes" message="#message1#" onBlur="kur_ekle_f_hesapla('ACTION_FROM_ACCOUNT_ID');" onkeyup="return(FormatCurrency(this,event));" style="width:155px;"> 
						</cfif>
					</div>
				</div>
				<div class="form-group" id="item-other_money_value">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='644.Dövizli Tutar'></label>
					<div class="col col-9 col-xs-12">
						<cfinput type="text" name="other_money_value" class="moneybox" readonly="yes" onBlur="kur_ekle_f_hesapla('ACTION_FROM_ACCOUNT_ID',true);" onkeyup="return(FormatCurrency(this,event));" style="width:155px;">
					</div>
				</div>
				<div class="form-group" id="item-action_detail">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
					<div class="col col-9 col-xs-12">
						<textarea name="action_detail" id="action_detail" style="width:155px;height:40px;"></textarea>
					</div>
				</div>
				<div class="form-group" id="item-masraf" style="<cfif isdefined("attributes.exp_count")>display:block<cfelse>display:none</cfif>">
					<label class="col col-12 bold"><cf_get_lang_main no='1518.Masraf'></label>
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='261.Tutar'></label>
					<div class="col col-9 col-xs-12">
						<cfinput type="text" name="masraf" class="moneybox" style="width:155px;" value="" onkeyup="return(FormatCurrency(this,event));">
					</div>
				</div>
				<div class="form-group" id="item-expense_center"  style="<cfif isdefined("attributes.exp_count")>display:block<cfelse>display:none</cfif>">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='1048.Masraf Merkezi'></label>
					<div class="col col-9 col-xs-12">
						<cf_wrkExpenseCenter width_info="155" fieldId="expense_center_id" fieldName="expense_center" form_name="add_cc_bank_action">
					</div>
				</div>
				<div class="form-group" id="item-expense_item_id">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='822.Bütçe Kalemi'></label>
					<div class="col col-9 col-xs-12">
						<cf_wrkExpenseItem width_info="155" fieldId="expense_item_id" fieldName="expense_item_name" form_name="add_cc_bank_action" income_type_info="0">
					</div>
				</div>
			</div>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group scrollContent scroll-x2" id="item-add_cc_bank_action">
						<label class="txtbold"><cf_get_lang no='53.İşlem Para Br'></label>
					<div class="col col-12">
							<cfscript>f_kur_ekle(process_type:0,base_value:'action_value',other_money_value:'other_money_value',form_name:'add_cc_bank_action',select_input:'ACTION_FROM_ACCOUNT_ID',is_disable='1');</cfscript>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<div class="col col-12">
				<cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'>
			</div>  
		</cf_box_footer>
            		
	</cfform>
</cf_box>
<script type="text/javascript">
	function get_account(val){
		first_ = list_getat(val,1,';');
		sec_ = list_getat(val,2,';');
		myVal = first_ + ';' + sec_;
		if($("#ACTION_FROM_ACCOUNT_ID").val() == '')
		$("#ACTION_FROM_ACCOUNT_ID option[value='"+myVal+"']").attr("selected", true);
	}
	function change_currency_info()
	{
		new_kur_say = document.all.kur_say.value;
		if(document.getElementById('credit_card_info') != undefined && document.getElementById('credit_card_info').value != '')
		{
			currency_id_info = list_getat(document.getElementById('credit_card_info').value,2,';');
			for(var i=1;i<=new_kur_say;i++)
			{
				if(eval('document.all.hidden_rd_money_'+i) != undefined && eval('document.all.hidden_rd_money_'+i).value == currency_id_info)
					eval('document.all.rd_money['+(i-1)+']').checked = true;
			}
			kur_ekle_f_hesapla('ACTION_FROM_ACCOUNT_ID');
		}
	}
	$(document).ready(function(){
		change_currency_info();
		kur_ekle_f_hesapla('ACTION_FROM_ACCOUNT_ID');
	});
	function kontrol()
	{
		if(!paper_control(add_cc_bank_action.paper_number,'creditcard_debit_payment')) return false;
		if(!chk_process_cat('add_cc_bank_action')) return false;
		if(!check_display_files('add_cc_bank_action')) return false;
		<cfif isdefined("attributes.exp_count")>
			if (document.add_cc_bank_action.ACTION_FROM_ACCOUNT_ID.value == "")
			{
				alert("Banka Hesabı Seçmelisiniz !");
				return false;
			}
		</cfif>
		if (document.add_cc_bank_action.credit_card_info.value == "")
		{ 
			alert ("<cf_get_lang no='201.Lütfen Kredi Kartı Seçiniz'> !");
			return false;
		}
		if(document.add_cc_bank_action.action_value.value == 0)	
		{
			alert("<cf_get_lang_main no='1738.Lutfen Tutar Giriniz'>");
			return false;
		}
		
		if(document.add_cc_bank_action.masraf.value != "" && document.add_cc_bank_action.masraf.value != 0)
		{
			if(document.add_cc_bank_action.expense_item_id.value == "" || document.add_cc_bank_action.expense_item_name.value == "")
			{
				alert("<cf_get_lang no='219.Gider Kalemi Seçiniz'>!");
				return false;
			}
			if(document.add_cc_bank_action.expense_center_id.value == "" || document.add_cc_bank_action.expense_center.value == "")
			{
				alert("<cf_get_lang no='220.Masraf Merkezi Seçiniz'>!");
				return false;
			}
		}
		document.add_cc_bank_action.credit_card_info.disabled = false;
		return true;
	}
</script>

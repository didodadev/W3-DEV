<cfif isDefined("attributes.checked_value")>
	<cfquery name="GET_PAYMENT_ROWS" datasource="#DSN3#">
	SELECT
		PAYMENT_ROWS.ACTION_TO_ACCOUNT_ID,
		PAYMENT_ROWS.PAYMENT_TYPE_ID,
		PAYMENT_ROWS.BANK_ACTION_DATE,
		PAYMENT_ROWS.OTHER_MONEY,
		SUM(DOVIZ_TOPLAM1-DOVIZ_TOPLAM2) DOVIZ_TOPLAM,
		SUM(COMS_TOPLAM1-COMS_TOPLAM2) COMS_TOPLAM,
		SUM(TOPLAM1-TOPLAM2) TOPLAM
	FROM
		(
			SELECT
				CCP.ACTION_TO_ACCOUNT_ID,
				CCP_R.PAYMENT_TYPE_ID,
				CCP_R.BANK_ACTION_DATE,
				<cfif session.ep.period_year lt 2009>
					CASE WHEN(CCP.OTHER_MONEY = 'TL') THEN 'YTL' ELSE CCP.OTHER_MONEY END AS OTHER_MONEY,
				<cfelse>
					CASE WHEN(CCP.OTHER_MONEY = 'YTL') THEN 'TL' ELSE CCP.OTHER_MONEY END AS OTHER_MONEY,
				</cfif>
				SUM(CCP_R.AMOUNT/(CCP.SALES_CREDIT/CCP.OTHER_CASH_ACT_VALUE)) DOVIZ_TOPLAM1,
				0 DOVIZ_TOPLAM2,
				SUM(CCP_R.COMMISSION_AMOUNT) COMS_TOPLAM1,
				0 COMS_TOPLAM2,
				SUM(CCP_R.AMOUNT) TOPLAM1,
				0 TOPLAM2
			FROM
				CREDIT_CARD_BANK_PAYMENTS CCP,
				CREDIT_CARD_BANK_PAYMENTS_ROWS CCP_R
			WHERE
				CCP.CREDITCARD_PAYMENT_ID = CCP_R.CREDITCARD_PAYMENT_ID AND
				CCP_R.CC_BANK_PAYMENT_ROWS_ID IN (#attributes.checked_value#) AND
				CCP.ACTION_TYPE_ID <> 245<!--- iptal dışındakiler--->
			GROUP BY
				CCP.ACTION_TO_ACCOUNT_ID,
				CCP.OTHER_MONEY,
				CCP_R.PAYMENT_TYPE_ID,
				CCP_R.BANK_ACTION_DATE
		UNION ALL	
			SELECT
				CCP.ACTION_TO_ACCOUNT_ID,
				CCP_R.PAYMENT_TYPE_ID,
				CCP_R.BANK_ACTION_DATE,
				<cfif session.ep.period_year lt 2009>
					CASE WHEN(CCP.OTHER_MONEY = 'TL') THEN 'YTL' ELSE CCP.OTHER_MONEY END AS OTHER_MONEY,
				<cfelse>
					CASE WHEN(CCP.OTHER_MONEY = 'YTL') THEN 'TL' ELSE CCP.OTHER_MONEY END AS OTHER_MONEY,
				</cfif>
				0 DOVIZ_TOPLAM1,
				SUM(CCP_R.AMOUNT/(CCP.SALES_CREDIT/CCP.OTHER_CASH_ACT_VALUE)) DOVIZ_TOPLAM2,
				0 COMS_TOPLAM1,
				SUM(CCP_R.COMMISSION_AMOUNT) COMS_TOPLAM2,
				0 TOPLAM1,
				SUM(CCP_R.AMOUNT) TOPLAM2
			FROM
				CREDIT_CARD_BANK_PAYMENTS CCP,
				CREDIT_CARD_BANK_PAYMENTS_ROWS CCP_R
			WHERE
				CCP.CREDITCARD_PAYMENT_ID = CCP_R.CREDITCARD_PAYMENT_ID AND
				CCP_R.CC_BANK_PAYMENT_ROWS_ID IN (#attributes.checked_value#) AND
				CCP.ACTION_TYPE_ID = 245<!--- kredikartı tahsilat iptal --->
			GROUP BY
				CCP.ACTION_TO_ACCOUNT_ID,
				CCP.OTHER_MONEY,
				CCP_R.PAYMENT_TYPE_ID,
				CCP_R.BANK_ACTION_DATE
		) AS PAYMENT_ROWS
	GROUP BY
		PAYMENT_ROWS.ACTION_TO_ACCOUNT_ID,
		PAYMENT_ROWS.PAYMENT_TYPE_ID,
		PAYMENT_ROWS.BANK_ACTION_DATE,
		PAYMENT_ROWS.OTHER_MONEY
	ORDER BY
		PAYMENT_ROWS.PAYMENT_TYPE_ID
	</cfquery>
<cf_catalystHeader>
<cf_papers paper_type="creditcard_cc_bank_action">
<cfform name="add_cc_bank_action" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_credit_card_bank_action">
<input type="hidden" name="checked_value" id="checked_value" value="<cfoutput>#attributes.checked_value#</cfoutput>">
<input type="hidden" name="kayit_toplam" id="kayit_toplam" value="<cfoutput>#get_payment_rows.recordcount#</cfoutput>">
<cfset toplam_tutar = 0>
	<div class="row">
    	<div class="col col-12 uniqueRow">
        	<div class="row formContent">
            	<div class="row" type="row">
                	<div class="col col-4 col-md-5 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    	<div class="form-group" id="item-process_cat">
                        	<label class="col col-3 col-xs-12"><cfoutput>#getLang('main',388)#​</cfoutput>*</label>
                       		<div class="col col-9 col-xs-12">
                        		<cf_workcube_process_cat slct_width="175" onclick_function="clean_exp();">
                       		</div>
                        </div>
                        <div class="form-group" id="item-start_date">
                        	<label class="col col-3 col-xs-12"><cfoutput>#getLang('bank',236)#​</cfoutput>*</label>
                       		<div class="col col-9 col-xs-12">
                            	<div class="input-group">
									<cfif GET_PAYMENT_ROWS.recordcount eq 1 and len(GET_PAYMENT_ROWS.BANK_ACTION_DATE)>
										<cfset start_date = GET_PAYMENT_ROWS.BANK_ACTION_DATE>
									<cfelse>
										<cfset start_date = now()>
									</cfif>
                        			<cfinput type="text" name="start_date" required="yes" value="#dateformat(start_date,dateformat_style)#" style="width:175px;" message="Hesaba Geçiş Tarihi Giriniz!">
                                	<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                </div>
                       		</div>
                        </div>
                        <div class="form-group" id="item-paper_number">
                        	<label class="col col-3 col-xs-12"><cfoutput>#getLang('main',468)#​</cfoutput></label>
                       		<div class="col col-9 col-xs-12">
                        		<cfinput type="text" name="paper_number" readonly="readonly" value="#paper_code & '-' & paper_number#" style="width:175px;" maxlength="50">
                       		</div>
                        </div>
                        <div class="form-group" id="item-action_detail">
                        	<label class="col col-3 col-xs-12"><cfoutput>#getLang('main',217)#​</cfoutput></label>
                       		<div class="col col-9 col-xs-12">
                        		<textarea name="action_detail" id="action_detail" style="width:175px;height:40px;"></textarea>
                       		</div>
                        </div>
                        <div class="form-group" id="item-comission_expense">
                        	<label class="col col-3 col-xs-12 txtboldblue"><cfoutput>#getLang('bank',238)#​</cfoutput></label>
                       		<div class="col col-9 col-xs-12">
                       		</div>
                        </div>
                        <cfoutput query="GET_PAYMENT_ROWS">
							<cfset toplam_tutar = toplam_tutar + GET_PAYMENT_ROWS.TOPLAM>
                            <cfquery name="GET_PAYMENT_TYPE" datasource="#dsn3#">
                            SELECT CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = #GET_PAYMENT_ROWS.PAYMENT_TYPE_ID#
                            </cfquery>
                                <div class="form-group" id="item-masraf_#currentrow#">
                                    <label class="col col-3 col-xs-12">#GET_PAYMENT_TYPE.CARD_NO#</label>
                                    <div class="col col-9 col-xs-12">
                                        <cfinput type="text" name="masraf_#currentrow#"  class="moneybox" required="yes" message="Tutar Giriniz!" value="#TLFormat(abs(GET_PAYMENT_ROWS.COMS_TOPLAM))#" onkeyup="return(FormatCurrency(this,event));">
                                    </div>
                                </div>
                       </cfoutput>
                        <div class="form-group" id="item-expense_item_id">
                        	<label class="col col-3 col-xs-12"><cfoutput>#getLang('main',822)#​</cfoutput></label>
                       		<div class="col col-9 col-xs-12">
                            	<div class="input-group">
                        			<input type="hidden" name="expense_item_id" id="expense_item_id" value="">
									<cfinput type="text" name="expense_item_name" value="" style="width:175px;">
                                	<span class="input-group-addon icon-ellipsis" onClick="open_exp_item();" title="Bütçe Kalemi"></span>
                                </div>
                       		</div>
                        </div>
                        <div class="form-group" id="item-expense_item_id">
                        	<label class="col col-3 col-xs-12"><cfoutput>#getLang('main',1265)#​</cfoutput>/<cfoutput>#getLang('main',1048)#​</cfoutput></label>
                       		<div class="col col-9 col-xs-12">
                            	<div class="input-group">
                        			<input type="hidden" name="expense_center_id" id="expense_center_id" value="">
									<cfinput type="text" name="expense_center" value="" style="width:175px;">
                                	<span class="input-group-addon icon-ellipsis" onClick="open_exp_center();" title="Gelir\<cf_get_lang_main no='1048.Masraf Merkezi'>"></span>
                                </div>
                       		</div>
                        </div>
                    </div>
                </div>
                <div class="row formContentFooter">
                	<div class="col col-6">
                    	<cfif toplam_tutar gte 0><cf_get_lang no='239.Hesaba Geçirilicek Toplam Tutar'><cfelse><font color="red"><cf_get_lang no='241.Hesaptan Düşülecek Toplam Tutar'></font></cfif> : </td><td height="26"><cfoutput>#TLFormat(abs(toplam_tutar))#</cfoutput>
                    </div>
                    <div class="col col-6">
                    	<cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'>
                    </div>
                </div>
            </div>
        </div>
    </div>
</cfform>

<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no='240.Tahsilat Seçiniz'>!");
		window.close();
	</script>
</cfif>
<script type="text/javascript">
function unformat_fields()
{
	for(var i=1;i<=add_cc_bank_action.kayit_toplam.value;i++)
		eval('add_cc_bank_action.masraf_' + i).value = filterNum(eval('add_cc_bank_action.masraf_' + i).value);
}
function kontrol()
{
	if(!chk_period(document.add_cc_bank_action.start_date, 'İşlem')) return false;
	if (!chk_process_cat('add_cc_bank_action')) return false;
	if(!check_display_files('add_cc_bank_action')) return false;
	var selected_ptype = document.add_cc_bank_action.process_cat.options[document.add_cc_bank_action.process_cat.selectedIndex].value;
	eval('var proc_control = document.add_cc_bank_action.ct_process_type_'+selected_ptype+'.value');
	<cfif toplam_tutar gte 0>
		if(proc_control == 247)
		{
			alert('<cfoutput>#getLang('hr',1222)#</cfoutput>');
			document.getElementById("expense_item_id").value = "";
			document.getElementById("expense_center_id").value = "";
			document.getElementById("expense_item_name").value = "";
			document.getElementById("expense_center").value = "";
			return false;
		}
	<cfelse>
		if(proc_control == 243)
		{
			alert('<cfoutput>#getLang('hr',1223)#</cfoutput>');
			document.getElementById("expense_item_id").value = "";
			document.getElementById("expense_center_id").value = "";
			document.getElementById("expense_item_name").value = "";
			document.getElementById("expense_center").value = "";
			return false;
		}
	</cfif>
	if(document.add_cc_bank_action.expense_item_id.value == "" || document.add_cc_bank_action.expense_item_name.value == "")
	{
		for(var i=1;i<=add_cc_bank_action.kayit_toplam.value;i++)
		if(filterNum(eval('add_cc_bank_action.masraf_' + i).value) > 0)
		{
			alert('<cfoutput>#getLang('main',825)#</cfoutput>');
			return false;
		}
	}
	if(document.add_cc_bank_action.expense_center_id.value == "" || document.add_cc_bank_action.expense_center.value == "")
	{
		for(var i=1;i<=add_cc_bank_action.kayit_toplam.value;i++)
		if(filterNum(eval('add_cc_bank_action.masraf_' + i).value) > 0)
		{
			alert("Gelir\<cf_get_lang no='220.Masraf Merkezi Seçiniz'>!");
			return false;
		}
	}

	var get_paper_no = wrk_safe_query('bnk_paper_no','dsn2',0,document.add_cc_bank_action.paper_number.value);
	if(get_paper_no.recordcount)
	{
		alert("<cf_get_lang no='348.Girdiğiniz Belge Numarası Kullanılmaktadır'> !");
		return false;
	}
	
	return unformat_fields();
	
	return true;
}
function open_exp_item()
{
	if (!chk_process_cat('add_cc_bank_action')) return false;
	var selected_ptype = document.add_cc_bank_action.process_cat.options[document.add_cc_bank_action.process_cat.selectedIndex].value;
	eval('var proc_control = document.add_cc_bank_action.ct_process_type_'+selected_ptype+'.value');
	if(proc_control == 243)
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_cc_bank_action.expense_item_id&field_name=add_cc_bank_action.expense_item_name','list');
	else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_cc_bank_action.expense_item_id&field_name=add_cc_bank_action.expense_item_name&is_income=1','list');
}
function open_exp_center()
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=add_cc_bank_action.expense_center_id&field_name=add_cc_bank_action.expense_center','list');
}
function clean_exp()
{
	document.getElementById("expense_item_id").value = "";
	document.getElementById("expense_center_id").value = "";
	document.getElementById("expense_item_name").value = "";
	document.getElementById("expense_center").value = "";
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

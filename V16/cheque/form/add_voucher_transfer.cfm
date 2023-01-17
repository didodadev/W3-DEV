<cf_get_lang_set module_name="cheque">
<cfinclude template="../query/get_control.cfm">
<cfset cash_status = 1><!---
<cfinclude template="../query/get_cashes.cfm">
<cfquery name="GET_TO_CASHES" datasource="#dsn2#">
	SELECT 
		* 
	FROM 
		CASH 
	WHERE 
		CASH_STATUS = 1
	ORDER BY	
		CASH_ID
</cfquery>--->
<cf_catalystHeader>
	<cf_box>
<cfform name="form_payroll_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_voucher_transfer">
    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <input type="hidden" name="rev_date" id="rev_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
    <input type="hidden" name="bordro_type" id="bordro_type" value="1">
    <cf_basket_form id="voucher_transfer">
				<cf_box_elements>
                    	<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        	<div class="form-group" id="item-process">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem'>*</label>
                                <div class="col col-8 col-xs-12">
                                	<cf_workcube_process_cat onclick_function="ayarla_gizle_goster();">
                                </div>
                            </div>
                            <div class="form-group" id="item-">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                    	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
                                        <cfinput value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" type="text" name="payroll_revenue_date" style="width:150px;" onBlur="change_money_info('form_payroll_basket','payroll_revenue_date');">
                                    	<span class="input-group-addon"><cf_wrk_date_image date_field="payroll_revenue_date" call_function="change_money_info"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        	<div class="form-group" id="item-">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50200.Kasasından'> *</label>
                                <div class="col col-8 col-xs-12">
									<cf_wrk_Cash name="cash_id" currency_branch="1">
                                </div>
                            </div>
                            <div class="form-group" id="item-">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50216.Kasasına'> *</label>
                                <div class="col col-8 col-xs-12">
									<cf_wrk_Cash name="to_cash_id" currency_branch="1" cash_status="1">
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        	<div class="form-group" id="item-">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                	<textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px;height:50px;"></textarea>
                                </div>
                            </div>
                        </div>
					</cf_box_elements>
                    <cf_box_footer>
						<input type="button" class="ui-wrk-btn ui-wrk-btn-extra" value="<cf_get_lang dictionary_id='50386.Senet Seç'>" onclick="javascript:senet_sec();">
                    	<cf_workcube_buttons is_upd='0' add_function='kontrol_transfer()'>
					</cf_box_footer>
    </cf_basket_form>
    <cf_basket id="voucher_transfer_bask">
        <cfset attributes.rev_date = dateformat(now(),dateformat_style)>
        <cfset attributes.is_transfer = 1>
        <cfset attributes.bordro_type = 1>
        <cfinclude template="../display/basket_voucher.cfm">
   </cf_basket>
</cfform>
</cf_box>
<script type="text/javascript">
	function kontrol_transfer()
	{
		document.form_payroll_basket.process_cat.disabled = false;
		if(!chk_process_cat('form_payroll_basket')) return false;
		if(!check_display_files('form_payroll_basket')) return false;
		if(!chk_period(form_payroll_basket.payroll_revenue_date, 'İşlem')) return false;
		if(document.all.voucher_num.value == 0)
		{
			alert("<cf_get_lang dictionary_id='50322.Senet Seçiniz veya Senet Ekleyiniz !'>");
			return false;
		}
		var kontrol_process_date = document.all.kontrol_process_date.value;
		if(kontrol_process_date != '')
		{
			var liste_uzunlugu = list_len(kontrol_process_date);
			for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
				{
					var tarih_ = list_getat(kontrol_process_date,str_i_row,',');
					var sonuc_ = datediff(document.all.payroll_revenue_date.value,tarih_,0);
					if(sonuc_ > 0)
						{
							alert("<cf_get_lang dictionary_id='50208.İşlem Tarihi Seçilen Senetlerin Son İşlem Tarihinden Önce Olamaz'>!");
							return false;
						}
				}
		}
		for(kk=1;kk<=document.all.kur_say.value;kk++)
		{
			cheque_rate_change(kk);
		}
		if(toplam(1,0,1)==false)return false;
		document.form_payroll_basket.cash_id.disabled = false;
		document.form_payroll_basket.to_cash_id.disabled = false;
		selected_cash = list_getat((document.form_payroll_basket.cash_id.value),1,';');
		var get_cash_3 = wrk_safe_query('chq_get_cash_3_3','dsn2',0,selected_cash); 
		if(get_cash_3.TRANSFER_VOUCHER_ACC_CODE =="")
		{
				alert ("<cf_get_lang dictionary_id='56558.Kasaların Yoldaki Senetler Muhasebe Kodu tanımlanmamıştır'>!");
				return false;
		}
		return true;
	}
	function ayarla_gizle_goster()
	{
		var selected_ptype = document.form_payroll_basket.process_cat.options[document.form_payroll_basket.process_cat.selectedIndex].value;
		if (selected_ptype != '')
			eval('var proc_control = document.form_payroll_basket.ct_process_type_'+selected_ptype+'.value');
		else
			var proc_control = '';
		<cfif session.ep.isBranchAuthorization>
			//Eğer şube modülüyse işlem tipine göre kasasından ve kasasına seçenekleri değişiyor
			var cash_id_len = eval('document.getElementById("cash_id")').options.length;
			for(j=cash_id_len;j>=0;j--)
				eval('document.getElementById("cash_id")').options[j] = null;	
			var to_cash_id_len = eval('document.getElementById("to_cash_id")').options.length;
			for(j=to_cash_id_len;j>=0;j--)
				eval('document.getElementById("to_cash_id")').options[j] = null;	

			eval('document.getElementById("cash_id")').options[0] = new Option('<cf_get_lang dictionary_id="57734.Seçiniz">','');
			eval('document.getElementById("to_cash_id")').options[0] = new Option('<cf_get_lang dictionary_id="57734.Seçiniz">','');

			var get_cash_1 = wrk_safe_query('chq_get_cash_1','dsn2');
			var get_cash_2 = wrk_safe_query('chq_get_cash_2','dsn2');
			if(proc_control == 136)
			{
				document.form_payroll_basket.bordro_type.value = 14;
				for(var jj=0;jj < get_cash_2.recordcount;jj++)
					eval('document.getElementById("cash_id")').options[jj+1]=new Option(''+get_cash_2.CASH_NAME[jj]+' '+get_cash_2.CASH_CURRENCY_ID[jj]+'',''+get_cash_2.CASH_ID[jj]+';'+get_cash_2.BRANCH_ID[jj]+';'+get_cash_2.CASH_CURRENCY_ID[jj]+'');
				for(var jj=0;jj < get_cash_1.recordcount;jj++)
					eval('document.getElementById("to_cash_id")').options[jj+1]=new Option(''+get_cash_1.CASH_NAME[jj]+' '+get_cash_1.CASH_CURRENCY_ID[jj]+'',''+get_cash_1.CASH_ID[jj]+';'+get_cash_1.BRANCH_ID[jj]+';'+get_cash_1.CASH_CURRENCY_ID[jj]+'');
			}
			else if(proc_control == 137)
			{
				document.form_payroll_basket.bordro_type.value = 1;
				for(var jj=0;jj < get_cash_2.recordcount;jj++)
					eval('document.getElementById("to_cash_id")').options[jj+1]=new Option(''+get_cash_2.CASH_NAME[jj]+' '+get_cash_2.CASH_CURRENCY_ID[jj]+'',''+get_cash_2.CASH_ID[jj]+';'+get_cash_2.BRANCH_ID[jj]+';'+get_cash_2.CASH_CURRENCY_ID[jj]+'');
				for(var jj=0;jj < get_cash_1.recordcount;jj++)
					eval('document.getElementById("cash_id")').options[jj+1]=new Option(''+get_cash_1.CASH_NAME[jj]+' '+get_cash_1.CASH_CURRENCY_ID[jj]+'',''+get_cash_1.CASH_ID[jj]+';'+get_cash_1.BRANCH_ID[jj]+';'+get_cash_1.CASH_CURRENCY_ID[jj]+'');
			}
		<cfelse>
			if(proc_control == 136)
				document.form_payroll_basket.bordro_type.value = 14;
			else
				document.form_payroll_basket.bordro_type.value = 1;
		</cfif>
	}
	var selected_ptype = document.form_payroll_basket.process_cat.options[document.form_payroll_basket.process_cat.selectedIndex].value;
	if (selected_ptype != '')
		eval('var proc_control = document.form_payroll_basket.ct_process_type_'+selected_ptype+'.value');
	else
		var proc_control = '';
	<cfif session.ep.isBranchAuthorization>
		//Eğer şube modülüyse işlem tipine göre kasasından ve kasasına seçenekleri değişiyor
		var cash_id_len = eval('document.getElementById("cash_id")').options.length;
		for(j=cash_id_len;j>=0;j--)
			eval('document.getElementById("cash_id")').options[j] = null;	
		var to_cash_id_len = eval('document.getElementById("to_cash_id")').options.length;
		for(j=to_cash_id_len;j>=0;j--)
			eval('document.getElementById("to_cash_id")').options[j] = null;	

		eval('document.getElementById("cash_id")').options[0] = new Option('<cf_get_lang dictionary_id="57734.Seçiniz">','');
		eval('document.getElementById("to_cash_id")').options[0] = new Option('<cf_get_lang dictionary_id="57734.Seçiniz">','');
		
		var get_cash_1 = wrk_safe_query('chq_get_cash_1','dsn2');
		var get_cash_2 = wrk_safe_query('chq_get_cash_2','dsn2');
		if(proc_control == 136)
		{
			document.form_payroll_basket.bordro_type.value = 14;
			for(var jj=0;jj < get_cash_2.recordcount;jj++)
				eval('document.getElementById("cash_id")').options[jj+1]=new Option(''+get_cash_2.CASH_NAME[jj]+' '+get_cash_2.CASH_CURRENCY_ID[jj]+'',''+get_cash_2.CASH_ID[jj]+';'+get_cash_2.BRANCH_ID[jj]+';'+get_cash_2.CASH_CURRENCY_ID[jj]+'');
			for(var jj=0;jj < get_cash_1.recordcount;jj++)
				eval('document.getElementById("to_cash_id")').options[jj+1]=new Option(''+get_cash_1.CASH_NAME[jj]+' '+get_cash_1.CASH_CURRENCY_ID[jj]+'',''+get_cash_1.CASH_ID[jj]+';'+get_cash_1.BRANCH_ID[jj]+';'+get_cash_1.CASH_CURRENCY_ID[jj]+'');
		}
		else if(proc_control == 137)
		{
			document.form_payroll_basket.bordro_type.value = 1;
			for(var jj=0;jj < get_cash_2.recordcount;jj++)
				eval('document.getElementById("to_cash_id")').options[jj+1]=new Option(''+get_cash_2.CASH_NAME[jj]+' '+get_cash_2.CASH_CURRENCY_ID[jj]+'',''+get_cash_2.CASH_ID[jj]+';'+get_cash_2.BRANCH_ID[jj]+';'+get_cash_2.CASH_CURRENCY_ID[jj]+'');
			for(var jj=0;jj < get_cash_1.recordcount;jj++)
				eval('document.getElementById("cash_id")').options[jj+1]=new Option(''+get_cash_1.CASH_NAME[jj]+' '+get_cash_1.CASH_CURRENCY_ID[jj]+'',''+get_cash_1.CASH_ID[jj]+';'+get_cash_1.BRANCH_ID[jj]+';'+get_cash_1.CASH_CURRENCY_ID[jj]+'');
		}
	<cfelse>
		if(proc_control == 136)
			document.form_payroll_basket.bordro_type.value = 14;
		else
			document.form_payroll_basket.bordro_type.value = 1;
	</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

<cf_get_lang_set module_name="cheque">
<cfquery name="GET_TO_CASHES" datasource="#dsn2#">
	SELECT 
		* 
	FROM 
		CASH 
	ORDER BY	
		CASH_ID
</cfquery>
<cfif isnumeric(url.id)>
	<cfquery name="GET_ACTION_DETAIL" datasource="#DSN2#">
		SELECT
			P.*
		FROM
			VOUCHER_PAYROLL P
		WHERE 
			P.ACTION_ID = #url.id# AND
			P.PAYROLL_TYPE IN(136,137)
			<cfif session.ep.isBranchAuthorization>
				AND P.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
			</cfif>		
	</cfquery>
<cfelse>
	<cfset get_action_detail.recordcount = 0>
</cfif>
<cfif not get_action_detail.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58002.Böyle Bir Çek Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
<cfinclude template="../query/get_cashes.cfm">
<cfif get_action_detail.PAYROLL_TYPE eq 137>
    <cfset p_type = 113>
<cfelseif get_action_detail.PAYROLL_TYPE eq 136>
    <cfset p_type = 114>
</cfif>
<cf_catalystHeader>
<cf_box>
<cfform name="form_payroll_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_voucher_transfer">
    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <input type="hidden" name="rev_date" id="rev_date" value="<cfoutput>#dateformat(get_action_detail.payroll_revenue_date,dateformat_style)#</cfoutput>">
    <input type="hidden" name="bordro_type" id="bordro_type" value="1">
    <input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.id#</cfoutput>">
	<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
    <cf_basket_form id="voucher_transfer">
			<cf_box_elements>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-process">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57692.İşlem'>*</label>
								<div class="col col-8 col-xs-12"> 
									<cf_workcube_process_cat onclick_function="ayarla_gizle_goster();" process_cat="#get_action_detail.process_cat#">
								</div>
							</div>
							<div class="form-group" id="item-payroll_revenue_date">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
								<div class="col col-8 col-xs-12"> 
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
										<cfinput value="#dateformat(GET_ACTION_DETAIL.payroll_revenue_date,dateformat_style)#" required="Yes" message="#message#" type="text" readonly name="payroll_revenue_date" style="width:150px;" validate="#validate_style#" onBlur="change_money_info('form_payroll_basket','payroll_revenue_date');">
										<span class="input-group-addon"><cf_wrk_date_image date_field="payroll_revenue_date" call_function="change_money_info" control_date="#dateformat(GET_ACTION_DETAIL.payroll_revenue_date,dateformat_style)#"></span>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-cash_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50200.Kasasından'> *</label>
								<div class="col col-8 col-xs-12"> 
									<select name="cash_id" id="cash_id" style="width:180px;" disabled>
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="get_cashes">
											<option value="#cash_id#;#branch_id#;#cash_currency_id#" <cfif cash_id eq get_action_detail.payroll_cash_id>selected</cfif>>#cash_name#-#cash_currency_id#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-to_cash_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50216.Kasasına'> *</label>
								<div class="col col-8 col-xs-12"> 
									<select name="to_cash_id" id="to_cash_id" style="width:180px;" disabled>
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="get_to_cashes">
											<option value="#cash_id#;#branch_id#;#cash_currency_id#" <cfif cash_id eq get_action_detail.transfer_cash_id>selected</cfif>>#cash_name#-#cash_currency_id#</option>
										</cfoutput>
									</select>
								</div>
							</div>
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
							<div class="form-group" id="item-ACTION_DETAIL">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
								<div class="col col-8 col-xs-12"> 
									<textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px;height:50px;"><cfoutput>#get_action_detail.action_detail#</cfoutput></textarea>
								</div>
							</div>
						</div>
						
				</cf_box_elements>
					<cf_box_footer>
							<cf_record_info query_name="get_action_detail">
							<input type="button" class="ui-wrk-btn ui-wrk-btn-extra" value="<cf_get_lang dictionary_id='50386.Senet Seç'>" onclick="javascript:senet_sec();">
							<cf_workcube_buttons is_upd='1' 
            				update_status='#get_action_detail.UPD_STATUS#'
            				del_function_for_submit='delete_action()' 
            				add_function='kontrol_transfer()'
            				delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_voucher_payroll&id=#url.id#&head=#get_action_detail.PAYROLL_NO#&cheque_base_acc=#get_action_detail.VOUCHER_BASED_ACC_CARI#'>
					</cf_box_footer>
    </cf_basket_form>
    <cf_basket id="voucher_transfer_bask">
        <cfset attributes.rev_date = dateformat(now(),dateformat_style)>
        <cfset attributes.is_transfer = 1>
        <cfif get_action_detail.payroll_type eq 136>
            <cfset attributes.bordro_type = 14>
        <cfelse>
            <cfset attributes.bordro_type = '1,11'>
        </cfif>
        <cfinclude template="../display/basket_voucher.cfm">
    </cf_basket>
</cfform>
</cf_box>
</cfif>
<script type="text/javascript">
	function delete_action()
	{
		if (!chk_period(form_payroll_basket.payroll_revenue_date, 'İşlem')) return false;			
		if (document.all.del_flag.value != 0)//basket_cheque de tutuluyor
		{
			alert("<cf_get_lang dictionary_id='49814.İşlem Görmüş Çekler Var, Bordroyu Silemezsiniz !'>");
			return false;
		}
		return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.payroll_type#'</cfoutput>);
	}
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
		for(kk=1;kk<=document.all.kur_say.value;kk++)
		{
			cheque_rate_change(kk);
		}
		if(toplam(1,0,1)==false)return false;
		document.form_payroll_basket.cash_id.disabled = false;
		document.form_payroll_basket.to_cash_id.disabled = false;
		return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.payroll_type#'</cfoutput>);
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
	if(proc_control == 136)
		document.form_payroll_basket.bordro_type.value = 14;
	else
		document.form_payroll_basket.bordro_type.value = 1;
	document.form_payroll_basket.process_cat.disabled = true;
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

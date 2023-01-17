<cf_get_lang_set module_name="bank">
<cf_xml_page_edit fuseact="bank.form_add_bank_account_open">
<cfset attributes.TABLE_NAME="BANK_ACTIONS">
<cfinclude template="../query/get_action_detail.cfm">
<cfif not get_action_detail.recordcount>
	<br/><font class="txtbold"><cf_get_lang_main dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cf_catalystHeader>
    <div>
        <cf_box>
            <cfform name="open_acc" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_bank_account_open&id=#attributes.id#" method="post">
                <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
                 <cfif listgetat(attributes.fuseaction,2,'.') is 'popup_upd_bank_account_open'>
                     <input type="hidden" name="is_popup" id="is_popup" value="1">
                 <cfelse>
                     <input type="hidden" name="is_popup" id="is_popup" value="0">
                 </cfif>
                 <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
                 <cf_box_elements>
                     <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                         <div class="form-group" id="item-process_cat">
                             <label class="col col-4 col-xs-12"><cf_get_lang_main dictionary_id='57800.işlem tipi'> *</label>
                             <div class="col col-8 col-xs-12">
                                 <cf_workcube_process_cat process_cat=#get_action_detail.process_cat# slct_width="270">
                                 <cfif len(get_action_detail.action_to_account_id)>
                                     <cfset account_id_info = get_action_detail.action_to_account_id>
                                     <cfset branch_id_info =  get_action_detail.to_branch_id>
                                 <cfelse>
                                     <cfset account_id_info = get_action_detail.action_from_account_id>
                                     <cfset branch_id_info =  get_action_detail.from_branch_id>
                                 </cfif>
                             </div>
                         </div>
                         <div class="form-group" id="item-BankAccounts">
                             <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48706.Banka/Hesap'> *</label>
                             <div class="col col-8 col-xs-12">
                                 <input type="hidden" name="old_acc_id" id="old_acc_id" value="<cfoutput>#account_id_info#</cfoutput>">
                                 <cf_wrkBankAccounts width='270' call_function='kur_ekle_f_hesapla' control_status='1' is_upd='1' selected_value='#account_id_info#'>
                             </div>
                         </div>
                         <cfif x_select_branch eq 1 and session.ep.isBranchAuthorization eq 0>
                         <div class="form-group" id="item-DepartmentBranch">
                             <label class="col col-4 col-xs-12"><cf_get_lang_main dictionary_id='57453.Şube'></label>
                             <div class="col col-8 col-xs-12">
                                 <cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='150' selected_value='#branch_id_info#' is_deny_control='1'>
                             </div>
                         </div>
                         </cfif>
                         <div class="form-group" id="item-ba_status">
                             <label class="col col-4 col-xs-12"><cf_get_lang_main dictionary_id='57867.Borç/Alacak'> *</label>
                             <div class="col col-8 col-xs-12">
                                 <select name="ba_status" id="ba_status" style="width:150px;">
                                     <option value="0" <cfif len(get_action_detail.action_to_account_id)>selected</cfif>><cf_get_lang_main dictionary_id='57587.Borç'></option>
                                     <option value="1" <cfif len(get_action_detail.action_from_account_id)>selected</cfif>><cf_get_lang_main dictionary_id='57588.Alacak'></option>
                                 </select>
                             </div>
                         </div>
                         <div class="form-group" id="item-ACTION_VALUE">
                             <label class="col col-4 col-xs-12"><cf_get_lang_main dictionary_id='57673.Tutar'> *</label>
                             <div class="col col-8 col-xs-12">
                                 <cfinput type="text" name="ACTION_VALUE" class="moneybox" required="yes" style="width:150px;" value="#TLFormat(get_action_detail.action_value)#" onBlur="kur_ekle_f_hesapla('account_id');" onkeyup="return(FormatCurrency(this,event));">
                             </div>
                         </div>
                         <div class="form-group" id="item-OTHER_CASH_ACT_VALUE">
                             <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34116.Diğer Döviz İşlemi'></label>
                             <div class="col col-8 col-xs-12">
                                 <cfinput type="text" name="OTHER_CASH_ACT_VALUE" class="moneybox" style="width:150px;" value="#TLFormat(get_action_detail.other_cash_act_value)#" onBlur="kur_ekle_f_hesapla('account_id',true);" onkeyup="return(FormatCurrency(this,event));">
                             </div>
                         </div>
                         <div class="form-group" id="item-action_date">
                             <label class="col col-4 col-xs-12"><cf_get_lang_main dictionary_id='57742.Tarih'> *</label>
                             <div class="col col-8 col-xs-12">
                                 <div class="input-group">
                                     <cfinput type="text" name="action_date" required="yes" validate="#validate_style#" style="width:150px;"  value="#dateformat(get_action_detail.action_date,dateformat_style)#" onBlur="change_money_info('open_acc','action_date');">
                                     <span class="input-group-addon"><cf_wrk_date_image date_field="action_date" call_function="change_money_info"></span>
                                 </div>
                             </div>
                         </div>
                         <div class="form-group" id="item-action_detail">
                             <label class="col col-4 col-xs-12"><cf_get_lang_main dictionary_id='57629.Açıklama'></label>
                             <div class="col col-8 col-xs-12">
                                 <textarea name="action_detail" id="action_detail" style="width:150px; height:60px;"><cfoutput>#get_action_detail.action_detail#</cfoutput></textarea>
                             </div>
                         </div>
                         <cfsavecontent variable="message"><cf_get_lang no ='49004.Hesap Açılış İşlemini Siliyorsunuz Emin misiniz'></cfsavecontent>
                         <cfif listgetat(attributes.fuseaction,2,'.') is 'popup_upd_bank_account_open'>
                             <cfset url_link = "&is_popup=1">
                         <cfelse>
                             <cfset url_link = "">
                         </cfif>
                     </div>
                     <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="false">
                        <div class="form-group">
                            <label class="col col-12 bold"><cf_get_lang dictionary_id='50114.Döviz Birimi'></label>
                        </div>
                         <div class="form-group" id="item-account_id">                            
                             <div class="col col-12 col-xs-12 scrollContent scroll-x2">
                                 <cfscript>
                                     f_kur_ekle(action_id:attributes.id,process_type:1,base_value:'ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'open_acc',action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#',select_input:'account_id');
                                 </cfscript>
                             </div>
                         </div>
                     </div>
                 </cf_box_elements>
                 <cf_box_footer>
                     <div class="col col-12">
                         <cf_record_info query_name="get_action_detail">
                         <cf_workcube_buttons is_upd='1' update_status='#get_action_detail.UPD_STATUS#'
                         delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_bank_account_open&id=#attributes.id#&old_process_type=#get_action_detail.action_type_id#' 
                         delete_alert='#message#' add_function='kontrol()'>
                     </div>
                 </cf_box_footer>
             </cfform>
        </cf_box>
    </div>
<script type="text/javascript">
	$( document ).ready(function() {
  		$('#account_id').attr('disabled',true);
	});
	function kontrol()
	{
		if(!$("#ACTION_VALUE").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='29943.Miktar Giriniz !'></cfoutput>"})    
			return false;
		}
		if(!$("#action_date").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang_main dictionary_id='58503.Lutfen Tarih Giriniz !'></cfoutput>"})    
			return false;
		}
		if (!chk_process_cat('open_acc')) return false;
		if(!check_display_files('open_acc')) return false;
		kur_ekle_f_hesapla('account_id');//dövizli tutarı silenler için..
		return(unformat_fields());
		return true;
	}
	function unformat_fields()
	{
		open_acc.ACTION_VALUE.value = filterNum(open_acc.ACTION_VALUE.value);
		open_acc.OTHER_CASH_ACT_VALUE.value = filterNum(open_acc.OTHER_CASH_ACT_VALUE.value);
		open_acc.system_amount.value = filterNum(open_acc.system_amount.value);
		for(var i=1;i<=open_acc.kur_say.value;i++)
		{
			eval('open_acc.txt_rate1_' + i).value = filterNum(eval('open_acc.txt_rate1_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('open_acc.txt_rate2_' + i).value = filterNum(eval('open_acc.txt_rate2_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	kur_ekle_f_hesapla('account_id');
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

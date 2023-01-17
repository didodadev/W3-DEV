<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #session.ep.period_id# AND
		MONEY_STATUS = 1
</cfquery>
<cf_catalystHeader>
<cfsavecontent variable="head_">
	<a href="javascript:gizle_goster(add_law);">&raquo;<cf_get_lang no='160.İcra Takip İşlemleri'></a>
</cfsavecontent>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="add_law_request" method="post" action="#request.self#?fuseaction=ch.emptypopup_add_law_request">
            <input type="hidden" name="active_period" id="active_period" value="1">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57800.İşlem Tipi"></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process_cat slct_width="140px">
                        </div>
                    </div>
                    <div class="form-group" id="item-member_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='107.Cari Hesap'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                                    <input type="hidden" name="member_type" id="member_type" value="consumer">
                                    <input type="hidden" name="member_id" id="member_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
                                    <input type="text" name="member_name" id="member_name" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'\',\'0\',\'0\',\'2\',\'0\'','MEMBER_TYPE,MEMBER_ID','member_type,member_id','','3','150');" value="<cfoutput>#get_cons_info(attributes.consumer_id,0,0)#</cfoutput>">
                                <cfelseif isdefined("attributes.company_id") and len(attributes.company_id)> 
                                    <input type="hidden" name="member_type" id="member_type" value="partner">
                                    <input type="hidden" name="member_id" id="member_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                                    <input type="text" name="member_name" id="member_name" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'\',\'0\',\'0\',\'2\',\'0\'','MEMBER_TYPE,MEMBER_ID','member_type,member_id','','3','150');" value="<cfoutput>#get_par_info(attributes.company_id,1,0,0)#</cfoutput>">
                                <cfelse>
                                    <input type="hidden" name="member_type" id="member_type" value="">
                                    <input type="hidden" name="member_id" id="member_id" value="">
                                    <input type="text" name="member_name" id="member_name" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'\',\'0\',\'0\',\'2\',\'0\'','MEMBER_TYPE,MEMBER_ID','member_type,member_id','','3','150');" value="">
                                </cfif>
                                <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='107.Cari Hesap'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=add_law_request.member_name&field_comp_id=add_law_request.member_id&field_name=add_law_request.member_name&field_consumer=add_law_request.member_id&field_type=add_law_request.member_type&select_list=2,3','list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-process">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç"></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                        </div>
                    </div>
                    <div class="form-group" id="item-obligee_company">
                    	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61427.Lehdar'><cf_get_lang dictionary_id='57574.Şirket'></label> 
                        <div class="col col-8 col-xs-12">
                        	<div class="input-group">
                                <input type="hidden" name="obligee_consumer_id" id="obligee_consumer_id"  value="">
                                <input type="hidden" name="obligee_company_id" id="obligee_company_id" value="" >
                                <input type="text" name="obligee_company" id="obligee_company" value="" onblur="CheckShow()" onfocus="AutoComplete_Create('obligee_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','MEMBER_PARTNER_NAME2,CONSUMER_ID,PARTNER_ID,COMPANY_ID','obligee_par_name,obligee_consumer_id,obligee_partner_id,obligee_company_id','','3','250');" autocomplete="off">						
                                <span class="input-group-addon icon-ellipsis btnPointer" id="span_dis1" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=add_law_request.obligee_company_id&is_period_kontrol=0&field_comp_name=add_law_request.obligee_company&field_partner=add_law_request.obligee_partner_id&field_consumer=add_law_request.obligee_consumer_id&field_name=add_law_request.obligee_par_name&par_con=1&function_name=CheckShow&select_list=2,3</cfoutput>')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-obligee_par_name">
                    	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61427.Lehdar'><cf_get_lang dictionary_id='57578.Yetkili'></label>
                        <div class="col col-8 col-xs-12">
                        	<input type="hidden" name="obligee_partner_id" id="obligee_partner_id" value="">
                        	<input type="text" name="obligee_par_name" id="obligee_par_name"   value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-obligee_detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61428.Lehdar Bilgisi'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="obligee_detail" id="obligee_detail"></textarea>
                        </div>
                    </div> 
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58811.Muhasebe Kodu'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="acc_code" id="acc_code" value="" onblur="CheckAcc()" onFocus="AutoComplete_Create('acc_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','1','','','','3','225');">
                                <span class="input-group-addon btnPointer icon-ellipsis" id="span_dis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=add_law_request.acc_code&changeFunction=CheckAcc&keyword='+encodeURIComponent(add_law_request.acc_code.value));"></span>
                            </div>
                        </div>
                    </div>         
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-law_name">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('ch',158)#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="law_name" id="law_name">
                        </div>
                    </div>
                    <div class="form-group" id="item-file_number">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('ch',159)#</cfoutput>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="file_number" id="file_number" value="" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-revenue_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarih'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="revenue_date" validate="#validate_style#" required="yes" message="Tarihi Giriniz !" value="#dateformat(now(),dateformat_style)#" maxlength="10" style="width:65px;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="revenue_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-file_stage">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='157.Dosya Durumu'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="file_stage" id="file_stage">
                        </div>
                    </div>
                    <div class="form-group" id="item-law_adwocate">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('ch',155)#</cfoutput>1</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="hidden" name="law_adwocate_id" value="">
                                <cfinput type="hidden" name="law_adwocate_comp" value="">
                                <input type="text" name="law_adwocate" id="law_adwocate" value="">
                                <span class="input-group-addon icon-ellipsis btnPointer" tiitle="<cf_get_lang no='155.Avukat'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_name=add_law_request.law_adwocate&field_id=add_law_request.law_adwocate_id&field_comp_id=add_law_request.law_adwocate_comp&select_list=2,3','list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-revenue_adwocate">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('ch',155)#</cfoutput>2</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="hidden" name="revenue_adwocate_id" value="">
                                <cfinput type="hidden" name="revenue_adwocate_comp" value="">
                                <input type="text" name="revenue_adwocate" id="revenue_adwocate" value="">
                                <span class="input-group-addon icon-ellipsis btnPointer" tiitle="<cf_get_lang no='155.Avukat'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_name=add_law_request.revenue_adwocate&field_id=add_law_request.revenue_adwocate_id&field_comp_id=add_law_request.revenue_adwocate_comp&select_list=2,3','list');"></span>
                            </div>
                        </div>
                    </div>                    
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="detail" id="detail"></textarea>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">                    
                    <div class="form-group" id="item-credite_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='65235.Alacak Tarih'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="credite_date" validate="#validate_style#" value="" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="credite_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-total_credit">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('ch',154)#</cfoutput>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="total_credit" class="moneybox" value="" style="width:100px;" onkeyup="return(FormatCurrency(this,event));">
                                <span class="input-group-addon width">
                                    <select name="money_currency" id="money_currency" style="width:50px;">
                                        <cfoutput query="get_money">
                                            <option value="#get_money.money#">#get_money.money#</option>
                                        </cfoutput>
                                    </select>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-default_rate">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64369.Temerrüt Oranı'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="default_rate" id="default_rate" class="moneybox" value="">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>	
                <div class="col col-12">
                    <cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
    if(!chk_process_cat('add_law_request')) return false;
	if(document.add_law_request.member_name.value == "")
		{
			alert("<cf_get_lang no='108.Lütfen Cari Hesap Seçiniz'> ");
			return false;
        }
        if((($('#obligee_company_id').val()=="" && $('#obligee_consumer_id').val()=="") || $('#obligee_company').val()=="") && (($('#law_adwocate_id').val()=="" && $('#law_adwocate_comp').val()=="") || $('#law_adwocate').val()=="")  && (($('#revenue_adwocate_id').val()=="" && $('#revenue_adwocate_comp').val()=="") || $('#revenue_adwocate').val()=="") && ($('#acc_code').val()==""))   
        {
            alert("<cf_get_lang dictionary_id='61451.Lütfen Lehdar Şirketi veya Avukat seçiniz'> ");
            return false;
        }
	    if(document.add_law_request.file_number.value == "")
		{
			alert("<cf_get_lang no='107.Lütfen Dosya No Giriniz'> ");
			return false;
        }
        if(document.add_law_request.total_credit.value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='50127.Alacak Tutar'>!");
			return false;
		}
	document.add_law_request.total_credit.value = filterNum(document.add_law_request.total_credit.value);
	return process_cat_control();
}
function CheckShow() {
    $("span#span_dis,input#acc_code").css("pointer-events", "none");
}
function CheckAcc() {
    $("span#span_dis1,input#obligee_company").css("pointer-events", "none");
}
</script>

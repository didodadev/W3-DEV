<cfinclude template="../query/get_money.cfm">
<cfif not get_money.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='54793.Sisteme Kayıtlı Döviz Bilgisi Bulunmamaktadır'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfparam name="attributes.record_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('finance',511)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_currency_hist" method="post" action="#request.self#?fuseaction=finance.emptypopup_add_currency_hist_act">
        <cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" sort="true" index="1">
                <div class="form-group" id="item-money">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57648.Kur'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="money" id="money">
                            <cfoutput query="get_money2">
                                <option value="#money#">#money#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-rate1">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'> *</label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57673.Tutar'></cfsavecontent>
                        <cfinput type="text" name="rate1" size="20" value="" maxlength="10" class="moneybox" required="yes" message="#message#" validate="float" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                    </div>
                </div>
                <div class="form-group" id="item-amount2">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58176.Alış'> <cf_get_lang dictionary_id='42004.Karşılığı'>*</label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58176.Alış'> <cf_get_lang dictionary_id='42004.Karşılığı'>!</cfsavecontent>
                        <cfinput type="text" name="amount2" required="yes" class="moneybox" message="#message#" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                    </div>
                </div>
                <div class="form-group" id="item-amount">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57448.Satış'> <cf_get_lang dictionary_id='42004.Karşılığı'>*</label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57448.Satış'> <cf_get_lang dictionary_id='42004.Karşılığı'>!</cfsavecontent>
                        <cfinput type="text" name="amount" required="yes" class="moneybox" message="#message#" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                    </div>
                </div>
                <div class="form-group" id="item-amount3">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32368.Efektif Alış'> <cf_get_lang dictionary_id='42004.Karşılığı'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="amount3" required="yes" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                    </div>
                </div>
                <div class="form-group" id="item-amount4">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30760.Efektif Satış'> <cf_get_lang dictionary_id='42004.Karşılığı'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="amount4" required="yes" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                    </div>
                </div>
                <div class="form-group" id="item-amountpp2">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33733.Partner Alış'> <cf_get_lang dictionary_id='42004.Karşılığı'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="amountpp2" required="yes" class="moneybox" message="#getLang('','Partner Alış Karşılığı Giriniz',54795)#" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                    </div>
                </div>
                <div class="form-group" id="item-amountpp">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33734.Partner Satış'> <cf_get_lang dictionary_id='42004.Karşılığı'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="amountpp" required="yes" class="moneybox" message="#getLang('','Partner Satış Karşılığı Giriniz',54797)#" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                    </div>
                </div>
                <div class="form-group" id="item-amountww2">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33735.Public Alış'> <cf_get_lang dictionary_id='42004.Karşılığı'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="amountww2" required="yes" class="moneybox" message="#getLang('','Public Alış Karşılığı Giriniz',54799)#" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                    </div>
                </div>
                <div class="form-group" id="item-amountww">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33736.Public Satış'> <cf_get_lang dictionary_id='42004.Karşılığı'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="amountww" required="yes" class="moneybox" message="#getLang('','Public Satış Karşılığı Giriniz',54801)#" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                    </div>
                </div>
                <div class="form-group" id="item-record_date">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58624.Geçerlilik Tarihi'></label>
                    <div class="col col-6 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="record_date" value="#attributes.record_date#" validate="#validate_style#" maxlength="10" required="yes">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="record_date"></span>
                        </div>
                    </div>
                    <div class="col col-2 col-xs-12">
                        <cf_wrkTimeFormat name="event_start_clock" value="0">                                              
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function='#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('add_currency_hist' , #attributes.modal_id#)"),DE(""))#'>
        </cf_box_footer>
	</cfform>
</cf_box>
<cfoutput>
	<script type="text/javascript">
		function unformat_fields()
		{
			add_currency_hist.amount.value = filterNum(add_currency_hist.amount.value,'#session.ep.our_company_info.rate_round_num#');
			add_currency_hist.amount2.value = filterNum(add_currency_hist.amount2.value,'#session.ep.our_company_info.rate_round_num#');
			add_currency_hist.amountpp.value = filterNum(add_currency_hist.amountpp.value,'#session.ep.our_company_info.rate_round_num#');
			add_currency_hist.amountpp2.value = filterNum(add_currency_hist.amountpp2.value,'#session.ep.our_company_info.rate_round_num#');
			add_currency_hist.amountww.value = filterNum(add_currency_hist.amountww.value,'#session.ep.our_company_info.rate_round_num#');
			add_currency_hist.amountww2.value = filterNum(add_currency_hist.amountww2.value,'#session.ep.our_company_info.rate_round_num#');
			add_currency_hist.amount3.value = filterNum(add_currency_hist.amount3.value,'#session.ep.our_company_info.rate_round_num#');
			add_currency_hist.amount4.value = filterNum(add_currency_hist.amount4.value,'#session.ep.our_company_info.rate_round_num#');
			add_currency_hist.rate1.value = filterNum(add_currency_hist.rate1.value,'#session.ep.our_company_info.rate_round_num#');
		}
		function kontrol()
		{
			if ((add_currency_hist.rate1.value =='') || (add_currency_hist.rate1.value == 0))
			{
				alert("<cf_get_lang dictionary_id='29535.Lutfen Tutar Giriniz'>!");
				return false;
			}
			unformat_fields();
			return true;
		}
	</script>
</cfoutput>

<cf_get_lang_set module_name="finance">
<cfinclude template="../query/get_money.cfm">
<!---<cfif not get_money.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='407.Sisteme Kayıtlı Döviz Bilgisi Bulunmamaktadır'>!");
		window.close();
	</script>
	<cfabort>
</cfif>--->
<cfparam name="attributes.record_date" default="#dateformat(now(),dateformat_style)#">
<cfset pageHead = #getLang('finance',511)#>
<cf_catalystHeader>
	<cfform name="add_currency_hist" method="post" action="#request.self#?fuseaction=textile.currencies&event=addCurrenciesHistory">
    	<div class="row">
			<div class="col col-12 uniqueRow">
				<div class="row formContent">
                	<div class="row" type="row">
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                            <div class="form-group" id="item-money">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',236)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                	<select name="money" id="money" style="width:150px;">
										<cfoutput query="get_money2">
                                            <option value="#money#">#money#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-rate1">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',261)#</cfoutput> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='261.Tutar'></cfsavecontent>
                                    <cfinput type="text" name="rate1" size="20" value="" maxlength="10" class="moneybox" required="yes" message="#message#" style="width:150px;" validate="float" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                            </div>
                            <div class="form-group" id="item-amount2">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',764)# #getLang('finance',82)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='764.Alış'> <cf_get_lang no='82.Karşılığı'>!</cfsavecontent>
                                    <cfinput type="text" name="amount2" required="yes" class="moneybox" message="#message#" style="width:150px;" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                            </div>
                            <div class="form-group" id="item-amount">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',36)# #getLang('finance',82)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='36.Satış'> <cf_get_lang no='82.Karşılığı'>!</cfsavecontent>
                                    <cfinput type="text" name="amount" required="yes" class="moneybox" message="#message#" style="width:150px;" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                            </div>
                            <div class="form-group" id="item-amount3">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('myhome',1610)# #getLang('finance',82)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="amount3" required="yes" class="moneybox" style="width:150px;" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                            </div>
                            <div class="form-group" id="item-amount4">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('myhome',3)# #getLang('finance',82)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
									<cfinput type="text" name="amount4" required="yes" class="moneybox" style="width:150px;" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                            </div>
                            <div class="form-group" id="item-amountpp2">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('finance',408)# #getLang('finance',82)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang no='409.Partner Alış Karşılığı Giriniz'></cfsavecontent>
									<cfinput type="text" name="amountpp2" required="yes" class="moneybox" message="#message#" style="width:150px;" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                            </div>
                            <div class="form-group" id="item-amountpp">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('finance',410)# #getLang('finance',82)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang no='411.Partner Satış Karşılığı Giriniz'></cfsavecontent>
									<cfinput type="text" name="amountpp" required="yes" class="moneybox" message="#message#" style="width:150px;" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                            </div>
                            <div class="form-group" id="item-amountww2">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('finance',412)# #getLang('finance',82)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang no='413.Public Alış Karşılığı Giriniz'></cfsavecontent>
									<cfinput type="text" name="amountww2" required="yes" class="moneybox" message="#message#" style="width:150px;" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                            </div>
                            <div class="form-group" id="item-amountww">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('finance',414)# #getLang('finance',82)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang no='415.Public Satış Karşılığı Giriniz'></cfsavecontent>
                                    <cfinput type="text" name="amountww" required="yes" class="moneybox" message="#message#" style="width:150px;" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                            </div>
                            <div class="form-group" id="item-record_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no ='1212.Geçerlilik Tarihi'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                        <cfinput type="text" name="record_date" value="#attributes.record_date#" validate="#validate_style#" maxlength="10" style="width:65px;" required="yes">
                                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="record_date"></span>
                                        <span class="input-group-addon no-bg"><cf_get_lang_main no ='79.Saat'></span>
                                        <span class="input-group-addon btnPointer">
                                            <cf_wrkTimeFormat name="event_start_clock" value="0" style="width:38px;">                                              
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row formContentFooter">
                    	<div class="col col-12">
							<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                        </div>
                    </div>
				</div>
			</div>
		</div>
	</cfform>
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
			document.getElementById("rate1").value = filterNum(document.getElementById("rate1").value,'#session.ep.our_company_info.rate_round_num#');
		}
		function kontrol()
		{
			if ((document.getElementById("rate1").value =='') || (document.getElementById("rate1").value == 0))
			{
				alert("<cf_get_lang_main no='1738.Lutfen Tutar Giriniz'>!");
				return false;
			}
			unformat_fields();
			return true;
		}
	</script>
</cfoutput>

<cf_get_lang_set module_name="finance">
<cfset attributes.ses_id=1>
<cfinclude template="../query/get_money.cfm">
<!---<cfif not get_money.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='407.Sisteme Kayıtlı Döviz Bilgisi Bulunmamaktadır'>!");
		window.close();
	</script>
	<cfabort>
</cfif>--->
<cfset pageHead = #getLang('finance',80)#>
<cf_catalystHeader>
	<cfform name="add_currency" method="post" action="#request.self#?fuseaction=textile.currencies&event=addCurrencies">
		<div class="row">
			<div class="col col-12 uniqueRow">
				<div class="row formContent">
                	<div class="row" type="row">
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                            <div class="form-group" id="item-money">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',236)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                	<select name="money" id="money" style="width:150px;">
										<cfoutput query="get_money2"><option value="#money#">#money#</option></cfoutput>
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
                                    <cfsavecontent variable="message"><cf_get_lang no='23.Miktar Giriniz'>!</cfsavecontent>
                                    <cfinput type="text" name="amount2" required="yes" class="moneybox" message="#message#" style="width:150px;" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                            </div>
                            <div class="form-group" id="item-amount">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',36)# #getLang('finance',82)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang no='23.Miktar Giriniz'>!</cfsavecontent>
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
                                    <cfsavecontent variable="message"><cf_get_lang no='409.Partner Alış Karşılığı Giriniz'>!</cfsavecontent>
                                    <cfinput type="text" name="amountpp2" required="yes" class="moneybox" message="#message#" style="width:150px;" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                            </div>
                            <div class="form-group" id="item-amountpp">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('finance',410)# #getLang('finance',82)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang no='411.Partner Satış Karşılığı Giriniz'>!</cfsavecontent>
                                    <cfinput type="text" name="amountpp" required="yes" class="moneybox" message="#message#" style="width:150px;" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                            </div>
                            <div class="form-group" id="item-amountww2">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('finance',412)# #getLang('finance',82)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang no='413.Public Alış Karşılığı Giriniz'>!</cfsavecontent>
                                    <cfinput type="text" name="amountww2" required="yes" class="moneybox" message="#message#" style="width:150px;" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                            </div>
                            <div class="form-group" id="item-amountww">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('finance',414)# #getLang('finance',82)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang no='415.Public Satış Karşılığı Giriniz'>!</cfsavecontent>
                                    <cfinput type="text" name="amountww" required="yes" class="moneybox" message="#message#" style="width:150px;" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
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
		var fld=document.add_currency.amount;
		var fld2=document.add_currency.amount2;
		var fld3=document.add_currency.amountpp;
		var fld4=document.add_currency.amountpp2;
		var fld5=document.add_currency.amountww;
		var fld6=document.add_currency.amountww2;
		var fld7=document.add_currency.amount3;
		var fld8=document.add_currency.amount4;
		fld.value=filterNum(fld.value,'#session.ep.our_company_info.rate_round_num#');
		fld2.value=filterNum(fld2.value,'#session.ep.our_company_info.rate_round_num#');
		fld3.value=filterNum(fld3.value,'#session.ep.our_company_info.rate_round_num#');
		fld4.value=filterNum(fld4.value,'#session.ep.our_company_info.rate_round_num#');
		fld5.value=filterNum(fld5.value,'#session.ep.our_company_info.rate_round_num#');
		fld6.value=filterNum(fld6.value,'#session.ep.our_company_info.rate_round_num#');
		fld7.value=filterNum(fld7.value,'#session.ep.our_company_info.rate_round_num#');
		fld8.value=filterNum(fld8.value,'#session.ep.our_company_info.rate_round_num#');
		document.getElementById("rate1").value = filterNum(document.getElementById("rate1").value,'#session.ep.our_company_info.rate_round_num#');
	}
	function kontrol()
	{
		if ((document.getElementById("rate1").value =='') || (document.getElementById("rate1").value == 0))
		{
			alert("<cf_get_lang_main no='1738.Lutfen Tutar Giriniz'>!");
			return false;
		}
		if ((document.getElementById("amount2").value =='') || (document.getElementById("amount2").value == 0))
		{
			alert("<cf_get_lang no='416.Alış Karşılığı Giriniz'>!");
			return false;
		}
		if ((document.getElementById("amount").value =='') || (document.getElementById("amount").value == 0))
		{
			alert("<cf_get_lang no='417.Satış karşılığı Giriniz'>!");
			return false;
		}
		unformat_fields();
		return true;
	}
	</script>
</cfoutput>


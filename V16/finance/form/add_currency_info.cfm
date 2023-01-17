<cfset attributes.ses_id=1>
<cfinclude template="../query/get_money.cfm">
<cfif not get_money.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='54793.Sisteme Kayıtlı Döviz Bilgisi Bulunmamaktadır'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('finance',80)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_currency" method="post" action="#request.self#?fuseaction=finance.emptypopup_add_currency_act">
        <cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" sort="true" index="1">
                <div class="form-group" id="item-money">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57648.Kur'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="money" id="money">
                            <cfoutput query="get_money2"><option value="#money#">#money#</option></cfoutput>
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
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58176.Alış'> <cf_get_lang dictionary_id='54468.Karşılığı'></label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='29943.Miktar Giriniz'>!</cfsavecontent>
                        <cfinput type="text" name="amount2" required="yes" class="moneybox" message="#message#" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                    </div>
                </div>
                <div class="form-group" id="item-amount">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57448.Satış'> <cf_get_lang dictionary_id='54468.Karşılığı'></label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='29943.Miktar Giriniz'>!</cfsavecontent>
                        <cfinput type="text" name="amount" required="yes" class="moneybox" message="#message#" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                    </div>
                </div>
                <div class="form-group" id="item-amount3">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32368.Efektif Alış'> <cf_get_lang dictionary_id='54468.Karşılığı'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="amount3" required="yes" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                    </div>
                </div>
                <div class="form-group" id="item-amount4">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30760.Efektif Satış'> <cf_get_lang dictionary_id='54468.Karşılığı'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="amount4" required="yes" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                    </div>
                </div>
                <div class="form-group" id="item-amountpp2">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54794.Partner Alış'> <cf_get_lang dictionary_id='54468.Karşılığı'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="amountpp2" required="yes" class="moneybox" message="#getLang('','Partner Alış Karşılığı Giriniz',54795)#!" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                    </div>
                </div>
                <div class="form-group" id="item-amountpp">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33734.Partner Satış'> <cf_get_lang dictionary_id='54468.Karşılığı'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="amountpp" required="yes" class="moneybox" message="#getLang('','Partner Satış Karşılığı Giriniz',54797)#!" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                    </div>
                </div>
                <div class="form-group" id="item-amountww2">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33735.Public Alış'><cf_get_lang dictionary_id='54468.Karşılığı'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="amountww2" required="yes" class="moneybox" message="#getLang('','Public Alış Karşılığı Giriniz',54799)#" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                    </div>
                </div>
                <div class="form-group" id="item-amountww">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33736.Public Satış'> <cf_get_lang dictionary_id='54468.Karşılığı'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="amountww" required="yes" class="moneybox" message="#getLang('','Public Satış Karşılığı Giriniz',54801)#" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function='#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('add_currency' , #attributes.modal_id#)"),DE(""))#'>
        </cf_box_footer>
	</cfform>
</cf_box>
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
			alert("<cf_get_lang dictionary_id='29535.Lutfen Tutar Giriniz'>!");
			return false;
		}
		if ((document.getElementById("amount2").value =='') || (document.getElementById("amount2").value == 0))
		{
			alert("<cf_get_lang dictionary_id='54802.Alış Karşılığı Giriniz'>!");
			return false;
		}
		if ((document.getElementById("amount").value =='') || (document.getElementById("amount").value == 0))
		{
			alert("<cf_get_lang dictionary_id='54803.Satış karşılığı Giriniz'>!");
			return false;
		}
		unformat_fields();
		return true;
	}
	</script>
</cfoutput>


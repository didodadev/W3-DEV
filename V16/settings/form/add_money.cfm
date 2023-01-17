<cfquery name="get_money" datasource="#dsn2#">
	SELECT 
        MONEY_ID, 
        MONEY, 
        RATE1,
        RATE2,
        MONEY_STATUS, 
        PERIOD_ID,
        COMPANY_ID, 
        ACCOUNT_950, 
        PER_ACCOUNT, 
        RATE3, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        RATEPP2, 
        RATEPP3, 
        RATEWW2,
        RATEWW3, 
        CURRENCY_CODE, 
        DSP_RATE_SALE, 
        DSP_RATE_PUR, 
        DSP_UPDATE_DATE, 
        EFFECTIVE_SALE, 
        EFFECTIVE_PUR, 
        MONEY_NAME, 
        MONEY_SYMBOL 
    FROM 
    	SETUP_MONEY
</cfquery>
<cfif get_money.recordcount>
	<cfset money_list = valuelist(get_money.money)>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Para Birimi','57489')#" add_href="#request.self#?fuseaction=settings.form_add_money" is_blank="0">
		<div class="row" type="row">			
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
				<cfinclude template="../display/list_money.cfm">
			</div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
                <cfform name="form_money" method="post" action="#request.self#?fuseaction=settings.emptypopup_money_add" onsubmit="return(unformat_fields());">	
                    <cf_box_elements>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-money">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57489.Para Birimi'></label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <select name="money" id="money" onchange="get_symbol()">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><!--- 2.parametre kodları CURRENCY_CODE alanında tutulur ve merkez bankasındaki kurları karşılaştırmk için kullanılır,yeni para birimi eklendiğinde merkez bankasndaki ilgili CurrencyCode eklenmelidir --->
                                        <cfif (isdefined("money_list") and not listfind(money_list,'TL')) or not isdefined("money_list")><cfif session.ep.period_year gt 2008><option value="TL,TL"> TL</option><cfelse><option value="YTL,YTL"> YTL</option></cfif></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'EUR')) or not isdefined("money_list")><option value="EURO,EUR">EUR</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'USD')) or not isdefined("money_list")><option value="USD,USD">USD</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'JPY')) or not isdefined("money_list")><option value="YEN,JPY">JPY</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'GBP')) or not isdefined("money_list")><option value="STERLIN,GBP">GBP</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'CAD')) or not isdefined("money_list")><option value="KANADADOLARI,CAD">CAD</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'CHF')) or not isdefined("money_list")><option value="ISVICREFRANGI,CHF">CHF</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'AED')) or not isdefined("money_list")><option value="DIRHAM,AED">AED</option></cfif><!---  Merkaz Bankası Kurlarında yok --->
                                        <cfif (isdefined("money_list") and not listfind(money_list,'SEK')) or not isdefined("money_list")><option value="ISVECKRONU,SEK">SEK</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'AFN')) or not isdefined("money_list")><option value="AFGHANI,AFN">AFN</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'IRR')) or not isdefined("money_list")><option value="IRANRIYALI,IRR">IRR</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'IQD')) or not isdefined("money_list")><option value="IRAKDINARI,IQD">IQD</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'AUD')) or not isdefined("money_list")><option value="AVUSTRALYADOLARI,AUD">AUD</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'YER')) or not isdefined("money_list")><option value="YEMENRIYALI,YER">YER</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'NOK')) or not isdefined("money_list")><option value="NORVECKRONU,NOK">NOK</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'DKK')) or not isdefined("money_list")><option value="DANIMARKAKRONU,DKK">DKK</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'KWD')) or not isdefined("money_list")><option value="KUVEYTDINARI,KWD">KWD</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'SAR')) or not isdefined("money_list")><option value="SUUDIARABISTANRIYALI,SAR">SAR</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'BGN')) or not isdefined("money_list")><option value="BULGARLEVASI,BGN">BGN</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'RON')) or not isdefined("money_list")><option value="RUMENLEYI,RON">RON</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'RUB')) or not isdefined("money_list")><option value="RUSRUBLESI,RUB">RUB</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'CNY')) or not isdefined("money_list")><option value="CINYUANI,CNY">CNY</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'PKR')) or not isdefined("money_list")><option value="PAKISTANRUPISI,PKR">PKR</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'QAR')) or not isdefined("money_list")><option value="KATARRIYALI,QAR">QAR</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'UAH')) or not isdefined("money_list")><option value="UKRAYNAGRİVNASI,UAH">UAH</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'XAU')) or not isdefined("money_list")><option value="ALTIN,XAU">XAU</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'LYD')) or not isdefined("money_list")><option value="LIBYADINARI,LYD">LYD</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'EGP')) or not isdefined("money_list")><option value="MISIRPOUNDU,EGP">EGP</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'BRL')) or not isdefined("money_list")><option value="BREZILYAREALI,BRL">BRL</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'KZT')) or not isdefined("money_list")><option value="TENGE,KZT">KZT</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'TWD')) or not isdefined("money_list")><option value="TAYVANDOLARI,TWD">TWD</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'AZN')) or not isdefined("money_list")><option value="AZERBAYCANMANATI,AZN">AZN</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'PLN')) or not isdefined("money_list")><option value="POLONYAZLOTISI,PLN">PLN</option></cfif><!---  Merkaz Bankası Kurlarında yok --->
                                        <cfif (isdefined("money_list") and not listfind(money_list,'TMT')) or not isdefined("money_list")><option value="TURKMENISTAN MANATI,TMT">TMT</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'KES')) or not isdefined("money_list")><option value="KENYASILINI,KES">KES</option></cfif>
                                        <cfif (isdefined("money_list") and not listfind(money_list,'XCP')) or not isdefined("money_list")><option value="BAKIR ONS,XCP">XCP</option></cfif>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-rate1">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'>*</label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='59025.Geçerli Bir Tutar Giriniz'></cfsavecontent>
                                    <cfinput type="text" name="rate1" value="1" maxlength="10" required="Yes" message="#message#" validate="integer" class="moneybox">
                                </div>
                            </div>
                            <div class="form-group" id="item-money_symbol">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42242.Sembol'></label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <input type="text" name="money_symbol" readonly="readonly" id="money_symbol" value="">
                                </div>
                            </div>
                            <div class="form-group" id="item-title">
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</div>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-6"><cf_get_lang dictionary_id='57448.Satış'></div>
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-6"><cf_get_lang dictionary_id='58176.Alış'></div>
                                </div>
                            </div>
                            <div class="form-group" id="item-rate">
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</div>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                                        <cfinput type="text" name="rate2"  value="1" maxlength="10" class="moneybox" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                    </div>
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                                        <cfinput type="text" name="rate3" value="1" maxlength="10" class="moneybox" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-efectiveAlis">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58945.Efektif'></label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">    
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                                        <cfinput type="text" name="efectiveSatis"  value="1" maxlength="10" class="moneybox" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                    </div>
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                                        <cfinput type="text" name="efectiveAlis" value="1" maxlength="10" class="moneybox" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-partner">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58885.Partner'></label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                                        <cfinput type="text" name="ratepp2"  value="1" maxlength="10" class="moneybox" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                    </div>
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                                        <cfinput type="text" name="ratepp3" value="1" maxlength="10" class="moneybox" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                    </div>
                                </div>  
                            </div>
                            <div class="form-group" id="item-public">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43232.Public'></label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                                        <cfinput type="text" name="rateww2"  value="1" maxlength="10" class="moneybox" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                    </div>
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                                        <cfinput type="text" name="rateww3" value="1" maxlength="10" class="moneybox" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                    </div>
                                </div> 
                            </div>
                        </div>
                    </cf_box_elements>
                    <cf_box_footer>
                        <cf_workcube_buttons is_upd='0' add_function='unformat_fields();kontrol(); '>
                    </cf_box_footer>
                </cfform>
            </div>
        </div>
    </cf_box>
</div>
<cfoutput>
    <script type="text/javascript">
        function kontrol()
        {
            if((document.getElementById('rate1').value == 1) && (document.getElementById('rate2').value == 1))
            {
                alert("<cf_get_lang no='1206.İki Yerel Para Birimi Olamaz !'>");
                return false;
            }
            if(document.getElementById('money').value == '')
            {
                alert("<cf_get_lang no='8.Para Birimi girmelisiniz'>");
                return false;
            }
            return true;
        }
        function get_symbol()
        {
            if(document.getElementById('money').value == 'EURO,EUR')
                document.getElementById('money_symbol').value = '€';
            else if(document.getElementById('money').value == 'KUVEYTDINARI,KWD')
                document.getElementById('money_symbol').value = 'د.ك';
            else if(document.getElementById('money').value == 'USD,USD')
                document.getElementById('money_symbol').value = '$';
            else if(document.getElementById('money').value == 'YEN,JPY')
                document.getElementById('money_symbol').value = '¥';
            else if(document.getElementById('money').value == 'STERLIN,GBP')
                document.getElementById('money_symbol').value = '£';
            else if(document.getElementById('money').value == 'KANADADOLARI,CAD')
                document.getElementById('money_symbol').value = '$';
            else if(document.getElementById('money').value == 'ISVICREFRANGI,CHF')
                document.getElementById('money_symbol').value = 'CHF';
            else if(document.getElementById('money').value == 'ISVECKRONU,SEK')
                document.getElementById('money_symbol').value = 'kr';
            else if(document.getElementById('money').value == 'AFGHANI,AFN')
                document.getElementById('money_symbol').value = '؋';
            else if(document.getElementById('money').value == 'IRANRIYALI,IRR')
                document.getElementById('money_symbol').value = '﷼';
            else if(document.getElementById('money').value == 'AVUSTRALYADOLARI,AUD')
                document.getElementById('money_symbol').value = '$';
            else if(document.getElementById('money').value == 'YEMENRIYALI,YER')
                document.getElementById('money_symbol').value = '﷼';
            else if(document.getElementById('money').value == 'NORVECKRONU,NOK')
                document.getElementById('money_symbol').value = 'kr';
            else if(document.getElementById('money').value == 'DANIMARKAKRONU,DKK')
                document.getElementById('money_symbol').value = 'kr';
            else if(document.getElementById('money').value == 'KUVEYTDINARI,KWD')
                document.getElementById('money_symbol').value = '';
            else if(document.getElementById('money').value == 'SUUDIARABISTANRIYALI,SAR')
                document.getElementById('money_symbol').value = '﷼';									
            else if(document.getElementById('money').value == 'BULGARLEVASI,BGN')
                document.getElementById('money_symbol').value = 'лв';									
            else if(document.getElementById('money').value == 'RUMENLEYI,RON')
                document.getElementById('money_symbol').value = 'lei';
            else if(document.getElementById('money').value == 'RUSRUBLESI,RUB')
                document.getElementById('money_symbol').value = 'руб';
            else if(document.getElementById('money').value == 'CINYUANI,CNY')
                document.getElementById('money_symbol').value = '¥';
            else if(document.getElementById('money').value == 'PAKISTANRUPISI,PKR')
                document.getElementById('money_symbol').value = '₨';
            else if(document.getElementById('money').value == 'KATARRIYALI,QAR')
                document.getElementById('money_symbol').value = '﷼';
            else if(document.getElementById('money').value == 'TURKMENISTAN MANATI,TMT')
                document.getElementById('money_symbol').value = 'T';
            else if(document.getElementById('money').value == 'ALTIN,XAU')
                document.getElementById('money_symbol').value = 'XAU';
                else if(document.getElementById('money').value == 'BAKIR ONS,XCP')
                document.getElementById('money_symbol').value = 'XCP';
        }
        
            function unformat_fields()
            {		
                document.getElementById('rate1').value = filterNum(document.getElementById('rate1').value,'#session.ep.our_company_info.rate_round_num#');
                document.getElementById('rate2').value = filterNum(document.getElementById('rate2').value,'#session.ep.our_company_info.rate_round_num#');
                document.getElementById('rate3').value = filterNum(document.getElementById('rate3').value,'#session.ep.our_company_info.rate_round_num#');
                document.getElementById('ratepp2').value = filterNum(document.getElementById('ratepp2').value,'#session.ep.our_company_info.rate_round_num#');
                document.getElementById('ratepp3').value = filterNum(document.getElementById('ratepp3').value,'#session.ep.our_company_info.rate_round_num#');
                document.getElementById('rateww2').value = filterNum(document.getElementById('rateww2').value,'#session.ep.our_company_info.rate_round_num#');
                document.getElementById('rateww3').value = filterNum(document.getElementById('rateww3').value,'#session.ep.our_company_info.rate_round_num#');
                document.getElementById('efectiveSatis').value = filterNum(document.getElementById('efectiveSatis').value,'#session.ep.our_company_info.rate_round_num#');
                document.getElementById('efectiveAlis').value = filterNum(document.getElementById('efectiveAlis').value,'#session.ep.our_company_info.rate_round_num#');
            }
        
    </script>
</cfoutput>
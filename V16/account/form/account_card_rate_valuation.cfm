<cf_xml_page_edit fuseaction="account.account_card_rate_valuation">
<cfquery name="get_money_bskt" datasource="#dsn#">
	SELECT MONEY,RATE1,RATE2,RATE3,ISNULL(EFFECTIVE_SALE,0) AS EFFECTIVE_SALE,ISNULL(EFFECTIVE_PUR,0) AS EFFECTIVE_PUR FROM SETUP_MONEY WHERE COMPANY_ID = #session.ep.company_id# AND PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
</cfquery>
<cfoutput query="get_money_bskt">
    <cfif isdefined("xml_money_type") and xml_money_type eq 0>
       <cfset 'money_rate_#money#' = (rate2/rate1)>
    <cfelseif isdefined("xml_money_type") and xml_money_type eq 1>
        <cfset 'money_rate_#money#' = rate3>
    <cfelseif isdefined("xml_money_type") and xml_money_type eq 2>
        <cfset 'money_rate_#money#' = rate2>
    <cfelseif isdefined("xml_money_type") and xml_money_type eq 3>
        <cfset 'money_rate_#money#' = EFFECTIVE_PUR>
    <cfelseif isdefined("xml_money_type") and xml_money_type eq 4>
        <cfset 'money_rate_#money#' = EFFECTIVE_SALE>
    </cfif>	
</cfoutput>
<cfif not (isdefined('attributes.date1') and isdate(attributes.date1))>
	<cfset attributes.date1 = createodbcdatetime('#session.ep.period_year#-#month(now())#-1')>
</cfif>
<cfif not (isdefined('attributes.date2') and isdate(attributes.date2))>
	<cfset attributes.date2 =  Replace(now(),year(now()),"#session.ep.period_year#")><!---"#daysinmonth(now())#/#month(now())#/#session.ep.period_year#" >--->
</cfif>
<cfparam name="attributes.code1" default="">
<cfparam name="attributes.code2" default="">
<cfparam name="attributes.action_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.duty_claim" default="">
<cfif isdefined("attributes.form_varmi")>
    <cf_date tarih="attributes.date1">
    <cf_date tarih="attributes.date2">
	<cfinclude template="../query/get_acc_remainder.cfm">
	<cfparam name="attributes.totalrecords" default="#get_acc_remainder.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif isdate(attributes.date1) and isdate(attributes.date2)>
	<cfset attributes.date1 = dateformat(attributes.date1,dateformat_style)>
	<cfset attributes.date2 = dateformat(attributes.date2,dateformat_style)>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<!-- sil -->
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form" method="post" action="#request.self#?fuseaction=account.account_card_rate_valuation">
            <input type="hidden" name="form_varmi" id="form_varmi" value="1">
            <cf_basket_form id="rate_valuation">
                <cf_box_elements>
                    <div class="col col-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                        <div class="form-group" id="item-account_codes1">
                            <label class="col col-3 col-xs-12"><cfoutput>#getLang(240,'Hesap',57652)#</cfoutput> 1:</label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <cf_wrk_account_codes form_name='form' account_code='code1'>
                                    <cfinput type="text" name="code1" value="#attributes.code1#" maxlength="255" onkeyup="get_wrk_acc_code_1();">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:pencere_ac_muavin('form.code1','form.name1','form.name1');" title="<cfoutput>#getLang(240,'Hesap',57652)#</cfoutput>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-account_codes2">
                            <label class="col col-3 col-xs-12"><cfoutput>#getLang(240,'Hesap',57652)#</cfoutput> 2:</label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <cf_wrk_account_codes form_name='form' account_code='code2' is_multi_no ='2'>
                                    <cfinput type="text" name="code2" value="#attributes.code2#" maxlength="255" onkeyup="get_wrk_acc_code_2();">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:pencere_ac_muavin('form.code2','form.name2','form.name2');" title="<cfoutput>#getLang(240,'Hesap',57652)#</cfoutput>"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
                        <div class="form-group" id="item-duty_claim">
                            <label class="col col-3 col-xs-12"><cfoutput>#getLang(20,'Hesap Tipi',48681)#</cfoutput></label>
                            <div class="col col-9 col-xs-12">
                                <select name="duty_claim" id="duty_claim">
                                    <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                    <option value="1" <cfif isDefined("attributes.duty_claim") and attributes.duty_claim eq 1>selected</cfif>><cf_get_lang dictionary_id ='47269.Borçlu Hesaplar'></option>
                                    <option value="2" <cfif isDefined("attributes.duty_claim") and attributes.duty_claim eq 2>selected</cfif>><cf_get_lang dictionary_id ='34115.Alacaklı Hesaplar'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-money_type">
                            <label class="col col-3 col-xs-12"><cfoutput>#getLang(77,'Para Birimi',57489)#</cfoutput></label>
                            <div class="col col-9 col-xs-12">
                                <select name = "money_type" id = "money_type">
                                    <option value = ""><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></option>
                                    <cfoutput query = "get_money_bskt">
                                        <option value = "#money#" <cfif isDefined('attributes.money_type') and money eq attributes.money_type>selected</cfif>>#money#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
                        <div class="form-group" id="item-date">
                            <label class="col col-3 col-xs-12"><cfoutput>#getLang(330,'Tarih',57742)#</cfoutput></label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <cfinput value="#attributes.date1#" validate="#validate_style#" type="text" name="date1" maxlength="10">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="date1"></span>
                                    <span class="input-group-addon no-bg"></span>
                                    <cfinput value="#attributes.date2#" validate="#validate_style#" type="text" name="date2" maxlength="10">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="date2"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <div class="row formContentFooter">
                    <label class="col col-9 col-xs-12">&nbsp;</label>
                    <div class="col col-3 col-xs-12 ">
                        <div class="form-group">
                            <div class="input-group x-13 pull-right">
                                <!--- <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer">
                                <cfelse>
                                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,250">
                                </cfif> --->
                                <cfsavecontent variable="msg"><cf_get_lang dictionary_id='58998.Hesapla'></cfsavecontent>
                                <span class="input-group-addon no-bg"></span>
                                <cf_wrk_search_button button_type="2" button_name="#msg#" search_function="kontrol()">
                            </div>
                        </div>
                    </div>
                </div>
            </cf_basket_form>
        </cfform>
    </cf_box>
    <cf_box>
        <cfif isdefined("attributes.form_varmi")>
            <cfform name="add_acc_card" method="post" action="">
                <input type="hidden" name="acc_start_row" id="acc_start_row" value="<cfoutput>#attributes.startrow#</cfoutput>">
                <input type="hidden" name="acc_end_row" id="acc_end_row" value="<cfoutput>#get_acc_remainder.recordcount#</cfoutput>">
                <input type="hidden" name="from_rate_valuation" id="from_rate_valuation" value="1">
                    <cf_grid_list>
                        <thead>
                            <tr>
                                <th rowspan="2"><cf_get_lang dictionary_id='47299.Hesap Kodu'></th>
                                <th rowspan="2"><cf_get_lang dictionary_id='47300.Hesap Adı'></th>
                                <th colspan="4" align="center"><cf_get_lang dictionary_id='58905.Sistem Dövizi'></th>
                                <th colspan="5" align="center"><cf_get_lang dictionary_id='58121.İşlem Dövizi'></th>
                                <th colspan="3" align="center"><cf_get_lang dictionary_id='57884.Kur Farkı'></th>
                            </tr>
                            <tr class="color-header" height="20">
                                <th><cf_get_lang dictionary_id ='57587.Borç'></th>
                                <th><cf_get_lang dictionary_id ='57588.Alacak'></th>
                                <th><cf_get_lang dictionary_id ='47441.Bakiye Borç'></th>
                                <th><cf_get_lang dictionary_id ='47442.Bakiye Alacak'></th>
                                <th><cf_get_lang dictionary_id ='57587.Borç'></th>
                                <th><cf_get_lang dictionary_id ='57588.Alacak'></th>
                                <th><cf_get_lang dictionary_id ='47441.Bakiye Borç'></th>
                                <th><cf_get_lang dictionary_id ='47442.Bakiye Alacak'></th>
                                <th width="70"><cf_get_lang dictionary_id='58121.İşlem Dövizi'></th>
								<th width="90"><cfoutput>#session.ep.money#</cfoutput><cf_get_lang dictionary_id='48778.Karşılık'> </th>
                                <th><cf_get_lang dictionary_id='57884.Kur Farkı'></th>
                                <th width="20"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfif isdefined("attributes.form_varmi") and get_acc_remainder.recordcount >
                                <cfscript>
                                    total_borc = 0;
                                    total_alacak = 0;
                                    total_bakiye = 0;
                                    total_borc_all = 0;
                                    total_alacak_all = 0;
                                    total_bakiye_all = 0;
                                    borc_bakiye_tpl = 0;
                                    alacak_bakiye_tpl = 0;
                                </cfscript>
                                <cfoutput query="get_acc_remainder">
                                    <cfset diff_amount2=0>
                                    <cfif not Find(".",account_code) or listlen(account_code,".") eq 2 ><cfset str_line = "class='txtbold'"><cfelse><cfset str_line = "" ></cfif>
                                    <tr>
                                        <td #str_line# nowrap="nowrap">
                                        <cfif ListLen(account_code,".") neq 1><cfloop from="1" to="#ListLen(account_code,".")#" index="i">&nbsp;</cfloop></cfif>
                                        #account_code#
                                        </td>
                                        <td #str_line# style="width:300px;">
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_scale&str_account_code=#account_code#&date1=#attributes.date1#&date2=#attributes.date2#','page_horizantal');">
                                        #account_name#
                                        </a>			  
                                        </td>
                                        <td style="text-align:right;" #str_line#>#TLFormat(BORC)#</td>
                                        <td style="text-align:right;" #str_line#>#TLFormat(ALACAK)#</td>
                                        <cfif BORC GT ALACAK>
                                            <td style="text-align:right;" #str_line#>#TLFormat(abs(BAKIYE))#
                                                <cfif listlen(ACCOUNT_CODE,'.') eq 1><cfset borc_bakiye_tpl=borc_bakiye_tpl+abs(BAKIYE)></cfif>
                                            </td>
                                            <td style="text-align:right;" #str_line#></td>
                                        <cfelse>
                                            <td style="text-align:right;" #str_line# ></td>				
                                            <td style="text-align:right;" #str_line#> #TLFormat(abs(BAKIYE))#
                                            <cfif listlen(ACCOUNT_CODE,'.') eq 1><cfset alacak_bakiye_tpl=alacak_bakiye_tpl+abs(BAKIYE)></cfif>
                                            </td>
                                        </cfif>
                                        <td nowrap style="text-align:right;" #str_line#>#TLFormat(OTHER_BORC)#</td>				
                                        <td nowrap style="text-align:right;" #str_line#>#TLFormat(OTHER_ALACAK)# </td>
                                        <cfif OTHER_BORC GT OTHER_ALACAK>
                                            <td style="text-align:right;" #str_line#> <cfif len(OTHER_BAKIYE)>#TLFormat(abs(OTHER_BAKIYE))#</cfif></td>
                                            <td style="text-align:right;" #str_line#></td>
                                        <cfelse>
                                            <td style="text-align:right;" #str_line#></td>				
                                            <td style="text-align:right;" #str_line#><cfif len(OTHER_BAKIYE)>#TLFormat(abs(OTHER_BAKIYE))#</cfif> </td>
                                        </cfif>                                        
                                            <td>#OTHER_CURRENCY#</td>
                                            <td><input type="text" name="acc_diff_amount2_#currentrow#" id="acc_diff_amount2_#currentrow#" value="#tlformat(evaluate('money_rate_#OTHER_CURRENCY#')*abs(OTHER_BAKIYE))#" readonly="yes" class="box"></td>
                                        <cfif listlen(ACCOUNT_CODE,'.') eq 1>
                                            <cfset total_borc_all=total_borc_all+BORC>
                                            <cfset total_alacak_all=total_alacak_all+ALACAK>
                                            <cfset total_bakiye_all=total_bakiye_all+BAKIYE>
                                        </cfif>
                                        
                                        <cfif SUB_ACCOUNT eq 0> <!--- alt hesabı yoksa --->
                                        <td nowrap="nowrap" style="text-align:right;">
                                            <cfif len(get_acc_remainder.OTHER_BAKIYE) and get_acc_remainder.OTHER_BAKIYE neq 0 and len(get_acc_remainder.OTHER_CURRENCY)>
                                                <cfif ((OTHER_BORC gt OTHER_ALACAK) and (BORC gt ALACAK)) or ((OTHER_BORC lte OTHER_ALACAK) and (BORC lte ALACAK))>
                                                    <cfset diff_amount2 = wrk_round(abs(OTHER_BAKIYE)*evaluate('money_rate_#get_acc_remainder.OTHER_CURRENCY#') )-wrk_round(abs(get_acc_remainder.BAKIYE))>
                                                <cfelse>
                                                    <cfset diff_amount2 = wrk_round(abs(OTHER_BAKIYE)*evaluate('money_rate_#get_acc_remainder.OTHER_CURRENCY#') )+wrk_round(abs(get_acc_remainder.BAKIYE))>
                                                </cfif>
                                            <cfelse>
                                                <cfset diff_amount2 = wrk_round(abs(get_acc_remainder.BAKIYE))>
                                            </cfif>
                                            <!--- 
                                            borç bakiyesi (-) vermişse alacağa, borç bakiyesi (+) vermişse mahsup fişinde borca,
                                            alacak bakiyesi(-) vermişse borca, alacak bakiyesi(+) vermişse mahsup fişinde alacaga yazar --->
                                            <input type="text" name="acc_diff_amount_#currentrow#" id="acc_diff_amount_#currentrow#" value="#TlFormat(diff_amount2)#" readonly="yes" class="box">
                                        </td>
                                        <td>
                                            <input type="checkbox" name="is_acc_diff_#currentrow#" id="is_acc_diff_#currentrow#" value="#diff_amount2#" <cfif diff_amount2 neq 0>checked="checked"</cfif> <cfif diff_amount2 eq 0>disabled="disabled"</cfif>>
                                            <input type="hidden" name="diff_acc_code_#currentrow#" id="diff_acc_code_#currentrow#" value="#account_code#">
                                            <input type="hidden" name="diff_acc_name_#currentrow#" id="diff_acc_name_#currentrow#" value="#account_name#">
                                            <input type="hidden" name="diff_bakiye_type_#currentrow#" id="diff_bakiye_type_#currentrow#" value="<cfif OTHER_BORC gt OTHER_ALACAK>0<cfelse>1</cfif>"><!--- bakiye tipi --->
                                            <input type="hidden" name="acc_diff_money_#currentrow#" id="acc_diff_money_#currentrow#" value="#OTHER_CURRENCY#">
                                        </td>
                                        <cfelse>
                                            <td></td><td></td>
                                        </cfif>
                                    </tr>
                                </cfoutput>
                            <cfelse>
                                <tr class="color-row" height="20">
                                    <td colspan="13"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                                </tr>
                            </cfif>
                        </tbody>
                    </cf_grid_list>
                    <cf_box_elements>
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57879.İşlem Tarihi'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='47464.Lütfen İşlem Tarihini Giriniz'></cfsavecontent>
                                            <cfinput value="#attributes.action_date#" validate="#validate_style#" message="#message#" type="text" name="action_date" maxlength="10" onBlur="change_money_info('add_acc_card','action_date','#xml_money_type#');control_diff_amount();">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="action_date" call_function="change_money_info&control_diff_amount" function_currency_type="#xml_money_type#"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <div id="sepetim_total">
                                <div class="col col-3 col-md-3 col-sm-12 col-xs-12">
                                    <div class="totalBox">
                                        <div class="totalBoxHead font-grey-mint">
                                            <span class="headText"><cf_get_lang dictionary_id='57677.Dövizler'></span>
                                            <div class="collapse">
                                                <span class="icon-minus"></span>
                                            </div>
                                        </div>  
                                        <div class="totalBoxBody"> 
                                            <table>
                                                <cfif get_money_bskt.recordcount>
                                                    <input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money_bskt.recordcount#</cfoutput>">
                                                    <input type="hidden" name="money_type" id="money_type" value="">
                                                    <cfif session.ep.rate_valid eq 1>
                                                        <cfset readonly_info = "yes">
                                                    <cfelse>
                                                        <cfset readonly_info = "no">
                                                    </cfif>
                                                    <cfoutput query="get_money_bskt">
                                                        <tr>
                                                            <td nowrap="nowrap" style="width:50px;">
                                                                #MONEY# 
                                                            </td>
                                                            <td>
                                                            <cfif isdefined("xml_money_type") and xml_money_type eq 0>
                                                                <cfset currency_rate_ = RATE2>
                                                            <cfelseif isdefined("xml_money_type") and xml_money_type eq 1>
                                                                <cfset currency_rate_ = RATE3>
                                                            <cfelseif isdefined("xml_money_type") and xml_money_type eq 2>
                                                                <cfset currency_rate_ = RATE2>
                                                            <cfelseif isdefined("xml_money_type") and xml_money_type eq 3>
                                                                <cfset currency_rate_ = EFFECTIVE_PUR>
                                                            <cfelseif isdefined("xml_money_type") and xml_money_type eq 4>
                                                                <cfset currency_rate_ = EFFECTIVE_SALE>
                                                            </cfif>                                  
                                                                <div class="form-group">
                                                                    #TLFormat(RATE1,0)#/
                                                                    <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
                                                                    <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                                                                    <input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> value="#TLFormat(currency_rate_,session.ep.our_company_info.rate_round_num)#" class="box" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="if(parseFloat(filterNum(this.value,8))<=0) this.value=commaSplit(1);control_diff_amount();">
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </cfoutput>
                                                </cfif>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <cf_box_footer>
                            <div><cfoutput><input type="button" onclick="acc_card_process()" value="#getLang(49,'Kaydet',57461)#" /></cfoutput></div>
                        </cf_box_footer>
                    </div>
            </cfform>
        </cfif>  
        <!--- <cfset adres = 'account.account_card_rate_valuation'>
        <cfset adres = '#adres#&date1=#attributes.date1#'>
        <cfset adres = '#adres#&date2=#attributes.date2#'>
        <cfif isDefined('attributes.code1')>
            <cfset adres = '#adres#&code1=#attributes.code1#'>
        </cfif>
        <cfif isDefined('attributes.code2')>
            <cfset adres = '#adres#&code2=#attributes.code2#'>
        </cfif>
        <cfif isDefined('attributes.form_varmi')>
            <cfset adres = '#adres#&form_varmi=#attributes.form_varmi#'>
        </cfif>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#adres#"> --->
    </cf_box>
</div>
<script type="text/javascript">
function pencere_ac_muavin(str_alan_1,str_alan_2,str_alan){
	var txt_keyword = eval(str_alan_1 + ".value" );
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id='+str_alan_1+'&field_id2='+str_alan_1+'&keyword='+txt_keyword,'list');
}
function acc_card_process()
{
	if(!$("#action_date").val().length)
	{
		alertObject({message: "<cfoutput>#getLang(494,'İşlem Tarihi Girmelisiniz',57906)# !</cfoutput>"})    
		return false;
	}
	
	windowopen('','wide','acc_card');
	add_acc_card.action='<cfoutput>#request.self#</cfoutput>?fuseaction=account.form_add_bill_cash2cash&var_=cash2cash_card';
	add_acc_card.target='acc_card';
	add_acc_card.submit();
	return true;
}
function control_diff_amount()
{	
	var diff_amount=0;				
	<cfoutput query="get_money_bskt">
		rate_#money# = filterNum(add_acc_card.txt_rate2_#get_money_bskt.currentrow#.value,#session.ep.our_company_info.rate_round_num#)/filterNum(add_acc_card.txt_rate1_#get_money_bskt.currentrow#.value,#session.ep.our_company_info.rate_round_num#);
	</cfoutput>
	<cfif isdefined('get_acc_remainder')>
    <cfoutput query="get_acc_remainder" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
        <cfif get_acc_remainder.SUB_ACCOUNT eq 0>
            <cfif len(get_acc_remainder.OTHER_BAKIYE) and get_acc_remainder.OTHER_BAKIYE neq 0 and len(get_acc_remainder.OTHER_CURRENCY)>
                <cfif ((OTHER_BORC gt OTHER_ALACAK) and (BORC gt ALACAK)) or ((OTHER_BORC lte OTHER_ALACAK) and (BORC lte ALACAK))>
                    diff_amount = wrk_round( ((#abs(get_acc_remainder.OTHER_BAKIYE)#*eval('rate_#get_acc_remainder.OTHER_CURRENCY#') )-(#abs(get_acc_remainder.BAKIYE)#)));
                <cfelse>
                    diff_amount = wrk_round( ((#abs(get_acc_remainder.OTHER_BAKIYE)#*eval('rate_#get_acc_remainder.OTHER_CURRENCY#') )+(#abs(get_acc_remainder.BAKIYE)#)));
                </cfif>
            <cfelse>
                diff_amount = #wrk_round(get_acc_remainder.BAKIYE)#;
            </cfif>
            
            if(diff_amount != 0)
            {
                $('##acc_diff_amount_#currentrow#').val(commaSplit(diff_amount));/<!--- kur farkını sadece listede göstermek icin --->/
                $('##acc_diff_amount2_#currentrow#').val(commaSplit(<cfoutput>#abs(get_acc_remainder.OTHER_BAKIYE)#*eval('rate_#get_acc_remainder.OTHER_CURRENCY#')</cfoutput> ));
                $('##is_acc_diff_#currentrow#').val(diff_amount);/<!--- mahsup fisine bu deger gonderiliyor --->/
                $('##is_acc_diff_#currentrow#').attr("disabled",false);                
            }
            else
            {
                $('##acc_diff_amount_#currentrow#').val(commaSplit(diff_amount)); /<!--- kur farkını sadece listede göstermek icin --->/
                $('##is_acc_diff_#currentrow#').val(diff_amount); /<!--- mahsup fisine bu deger gonderiliyor --->/
                $('##is_acc_diff_#currentrow#').attr("disabled",true);
            }
        </cfif> 
    </cfoutput>
	</cfif>
}
function kontrol()
{
	if(!$("#code1").val().length)
	{
		alertObject({message: "<cfoutput>#getLang(59,'Eksik Veri',57471)# #getLang('account',46)# !</cfoutput>"})    
		return false;
	}
	if(!$("#code2").val().length)
	{
		alertObject({message: "<cfoutput>#getLang(59,'Eksik Veri',57471)# #getLang('account',49)# !</cfoutput>"})    
		return false;
	}
	if(!$("#date1").val().length)
	{
		alertObject({message: "<cfoutput>#getLang('account',87)# !</cfoutput>"})    
		return false;
	}
	if(!$("#date2").val().length)
	{
		alertObject({message: "<cfoutput>#getLang('account',31)# !</cfoutput>"})    
		return false;
	}
	if(!$("#maxrows").val().length)
	{
		alertObject({message: "<cfoutput>#getLang(125,'Kayıt Sayısı Hatalı',57537)# !</cfoutput>"})    
		return false;
	}
	return true;
}
</script>

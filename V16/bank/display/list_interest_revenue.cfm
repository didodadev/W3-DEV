<cf_get_lang_set module_name="bank"><!--- sayfanin en altinda kapanisi var --->
    <cf_xml_page_edit fuseact="bank.interest_revenue">
    <cfparam name="attributes.date1" default="">
    <cfparam name="attributes.date2" default="">
    <cfparam name="attributes.search_type" default="">
    <cfparam name="attributes.record_emp_id" default="">
    <cfparam name="attributes.record_emp_name" default="">
    <cfparam name="attributes.record_date" default="">
    <cfparam name="attributes.record_date2" default="">
    <cfparam name="attributes.is_form_submitted" default="">
    <cfparam name="attributes.tahsil_status" default="">
    <cfparam name="attributes.current_value_date" default="">
    <cfparam name="attributes.yield_valuation_date" default="">
    <cfparam name="attributes.yield_valuation_amount" default="">
    <cfparam name="attributes.create_budget_plan" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="datediff_val" default="0">
    <cfparam name="last_reeskont_date" default="">
    <cfparam name="attributes.saveControl" default="0">
    
    <cfset INTEREST_REVENUE = createObject("component", "V16.bank.cfc.vadeliMevduat")>

    <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
        <cf_date tarih = "attributes.date1">
    </cfif>
    <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
        <cf_date tarih = "attributes.date2">
    </cfif>
    <cfif isdefined("attributes.record_date") and isdate(attributes.record_date)>
        <cf_date tarih = "attributes.record_date">
    </cfif>
    <cfif isdefined("attributes.record_date2") and isdate(attributes.record_date2)>
        <cf_date tarih = "attributes.record_date2">
    </cfif>
    <cfif isdefined("attributes.current_value_date") and isdate(attributes.current_value_date)>
        <cf_date tarih = "attributes.current_value_date">
    </cfif>
    <cfset GET_MONEY = INTEREST_REVENUE.GET_MONEY()>
    <cfset GET_ACCOUNTS = INTEREST_REVENUE.GET_ACCOUNTS()>

    <cfif isdefined("attributes.is_form_submitted")>
        <cfset GET_YIELD_PLAN_ROWS = INTEREST_REVENUE.GET_YIELD_PLAN_ROWS(
            date1 : '#iif( len(attributes.date1), "attributes.date1", DE(""))#',
            date2 : '#iif( len(attributes.date2), "attributes.date2", DE(""))#',
            record_date : '#iif( len(attributes.record_date), "attributes.record_date", DE(""))#',
            record_date2 : '#iif( len(attributes.record_date2), "attributes.record_date2", DE(""))#',
            tahsil_status : '#iif( len(attributes.tahsil_status), "attributes.tahsil_status", DE(""))#',
            keyword : '#iif( len(attributes.keyword), "attributes.keyword", DE(""))#',
            record_emp_id : '#iif( len(attributes.record_emp_id), "attributes.record_emp_id", DE(""))#'
        )>
    <cfelse>
        <cfset GET_YIELD_PLAN_ROWS.recordcount = 0>
    </cfif>
   
    <!--- reeskont hesaplama yapılıyorsa --->
    <cfif len(attributes.current_value_date)>

        <!--- <cfloop from="1" to="#GET_YIELD_PLAN_ROWS.recordcount#" index="i">
            <cfset date_diff = DateDiff("d",GET_YIELD_PLAN_ROWS.BANK_ACTION_DATE[i],attributes.current_value_date)>
            <cfset start_date = DateDiff("d",GET_YIELD_PLAN_ROWS.ACTION_DATE[i],attributes.current_value_date)>
            <cfif len(GET_YIELD_PLAN_ROWS.REESKONT_DATE[i])>
                <cfset last_reeskont_date = DateDiff("d",GET_YIELD_PLAN_ROWS.REESKONT_DATE[i],attributes.current_value_date)>
            </cfif>
            <cfif date_diff gt 0 >
                <script>
                    alert("Reeskont Değerleme Tarihi <cfoutput>#i# </cfoutput>"+". Satırdaki Getiri Vade Tarihinden Büyük Olamaz!");
                    window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.interest_revenue</cfoutput>';
                </script>
                <cfabort>
            <cfelseif start_date lt 0>
                <script>
                    alert("Reeskont Değerleme Tarihi <cfoutput>#i# </cfoutput>"+". Satırdaki Vade Başlangıç Tarihinden Küçük Olamaz!");
                    window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.interest_revenue</cfoutput>';
                </script>
                <cfabort>   
            <cfelseif len(last_reeskont_date) and last_reeskont_date lte 0>
                <script>
                    alert("Reeskont Değerleme Tarihi <cfoutput>#i# </cfoutput>"+". Satırdaki Son Değerleme Tarihinden Küçük Olamaz!");
                    window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.interest_revenue</cfoutput>';
                </script>
                <cfabort>  
            </cfif>
        </cfloop> --->

        <cfif attributes.create_budget_plan eq 1 and attributes.saveControl eq 0>
            <cf_date tarih="attributes.yield_valuation_date">         
            <cfinclude template="interest_reeskont.cfm">
            <cfif attributes.budget_type eq 2>
                <script>
                    alert("Planlama Fişi Oluşturulmuştur. Satır Detayından İlgili Fişi Görüntüleyebilirsiniz.");
                    let url = document.URL+"&saveControl=1";
                    history.pushState('', '', url);
                </script>
            <cfelseif attributes.budget_type eq 1>
                <script>alert("Gelir İşlemi Başarıyla Oluşturulmuştur.");
                    let url = document.URL+"&saveControl=1";
                    history.pushState('', '', url);
                </script>
            </cfif>
        </cfif>
    </cfif> 

    <!--- reeskont hesaplama yapılıyorsa --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="intereset_revenue_list" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.interest_revenue" method="post">
            <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1"/>
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang(48,'Filtre',57460)#">
                </div>
                <div class="form-group">
                    <select name="tahsil_status" id="tahsil_status" >
                        <option value=""><cf_get_lang dictionary_id='33565.Tahsil Türü'></option>
                        <option value="1"<cfif isDefined("attributes.tahsil_status") and (attributes.tahsil_status eq 1)> selected</cfif>><cf_get_lang dictionary_id='33564.Tahsil Edilen'></option>
                        <option value="0"<cfif isDefined("attributes.tahsil_status") and (attributes.tahsil_status eq 0)> selected</cfif>><cf_get_lang dictionary_id='33563.Tahsil Edilmemiş'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
            <cfparam name="attributes.totalrecords" default='#GET_YIELD_PLAN_ROWS.recordcount#'>
            <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
            <cf_box_search_detail>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-record_emp_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
                                <input name="record_emp_name" type="text" id="record_emp_name" onFocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','intereset_revenue_list','3','125');" value="<cfif len(attributes.record_emp_name)><cfoutput>#attributes.record_emp_name#</cfoutput> </cfif>" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=intereset_revenue_list.record_emp_name&field_emp_id=intereset_revenue_list.record_emp_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-account">
                        <label class="col col-12"><cf_get_lang dictionary_id='57652.Hesap'></label>
                        <div class="col col-12">
                            <select name="account" id="account">
                                <option value=""><cf_get_lang dictionary_id='57652.Hesap'></option>
                                <cfoutput query="get_accounts">
                                    <option value="#account_id#" <cfif isDefined("attributes.account") and attributes.account eq get_accounts.account_id>selected</cfif> >#account_name#-#account_currency_id#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-record_date">
                        <label class="col col-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfsavecontent variable="record_date"><cf_get_lang dictionary_id='57782.Tarih Değerlerini Kontrol ediniz'></cfsavecontent>
                                <cfinput type="text" maxlength="10" name="record_date" value="#dateformat(attributes.record_date,dateformat_style)#" validate="#validate_style#" message="#record_date#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="record_date"></span>
                                <span class="input-group-addon no-bg"></span>
                                <cfinput type="text" maxlength="10" name="record_date2" value="#dateformat(attributes.record_date2,dateformat_style)#" validate="#validate_style#" message="#record_date#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="record_date2"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-date1">
                        <label class="col col-12"><cf_get_lang dictionary_id='57881.Vade Tarihi'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfinput value="#dateformat(attributes.date1,dateformat_style)#" type="text" name="date1" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
                                <span class="input-group-addon no-bg"></span>
                                <cfinput value="#dateformat(attributes.date2,dateformat_style)#" type="text" name="date2" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-date2">
                        <label class="col col-12"><!---<cf_get_lang dictionary_id='33562.Güncel Değer Tarihi'> ---><cf_get_lang dictionary_id='59787.Reeskont Değerleme Tarihi'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfinput value="#dateformat(attributes.current_value_date,dateformat_style)#" type="text" name="current_value_date" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="current_value_date"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box> 
    <cf_box title="#getLang(1169,'Vadeli Mevduat Getiri Listesi',33559)#" uidrop="1" hide_table_column="1">
        <cfform name="add_budget_plan" action="" method="post">
            <cf_grid_list>
                <cfset colspan_ = 10>
                <cfset colspan_info = 8>
                <cfset totalCurrentValue = 0>
                <cfset totalReeskontValue = 0>
                <thead>
                    <tr>
                        <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <!--- <th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th> --->
                        <th><cf_get_lang dictionary_id='29449.Banka Hesabı'></th>
                        <th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
                        <th><cf_get_lang dictionary_id='57880.Belge No'></th>
                        <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                        <th><cf_get_lang dictionary_id='59179.Ana Para'></th>
                        <th><cf_get_lang dictionary_id='57640.Vade'></th>
                        <th><cf_get_lang dictionary_id='51354.Faiz Oranı'> %</th>
                        <th><cf_get_lang dictionary_id='51374.Getiri Tutarı'></th>
                        <th>Getiri <cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
                        <cfif len(attributes.current_value_date)> <!--- daha önce değerleme yapıldı ise o tarih üzerinden yeni değerleme yapılacak --->
                            <th><cf_get_lang dictionary_id='59802.Son Değerleme Tarihi'></th>
                            <th title="<cf_get_lang dictionary_id='59803.Değerleme Gün Farkı'>">D.G.F</th>
                            <!--- <th style="text-align:right;">Getiri Kaybı</th> --->
                            <!--- <th>Güncel Getiri</th> --->
                            <th><cf_get_lang dictionary_id='59804.Reeskont Değeri'></th>
                        </cfif>
                        <th width="20" class="text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
                        <cfif len(attributes.current_value_date)>
                            <th width="20" class="text-center"><input type="checkbox"></th>
                        </cfif>
                        <th width="20" class="text-center"><i class="fa fa-bookmark" title="<cf_get_lang dictionary_id='30020.Tahsil'>"></i></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif GET_YIELD_PLAN_ROWS.recordcount>
                        <cfoutput query="GET_YIELD_PLAN_ROWS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td width="20">#currentrow#</td>
                                <!--- <td>#process_cat#</td> --->
                                <td>
                                    <cfset act_id = ACTION_ID + 1>
                                    <cfquery name="get_account_name" datasource="#dsn3#">SELECT ACCOUNT_NAME,ACCOUNT_CURRENCY_ID FROM ACCOUNTS AS A LEFT JOIN #dsn2#.BANK_ACTIONS AS BA ON BA.ACTION_TO_ACCOUNT_ID = A.ACCOUNT_ID WHERE BA.ACTION_ID = #act_id#</cfquery>
                                    #get_account_name.ACCOUNT_NAME#
                                    <input type="hidden" name="bank_currency_id#YIELD_ROWS_ID#" id="bank_currency_id#YIELD_ROWS_ID#" value="#get_account_name.ACCOUNT_CURRENCY_ID#">
                                </td>
                                <td>#dateformat(ACTION_DATE,dateformat_style)#</td>
                                <td>#PAPER_NO#</td>
                                <td>#OPERATION_NAME#</td>
                                <td class="moneybox">#TLFormat(ACTION_VALUE-MASRAF)#</td>
                                <td>
                                    <cfif YIELD_PAYMENT_PERIOD eq 1><cf_get_lang dictionary_id='58724.Ay'>
                                    <cfelseif YIELD_PAYMENT_PERIOD eq 2>3 <cf_get_lang dictionary_id='58724.Ay'>
                                    <cfelseif YIELD_PAYMENT_PERIOD eq 3>6 <cf_get_lang dictionary_id='58724.Ay'>
                                    <cfelseif YIELD_PAYMENT_PERIOD eq 4><cf_get_lang dictionary_id='58455.Yıl'>
                                    <cfelseif YIELD_PAYMENT_PERIOD eq 5> #SPECIAL_DAY# <cf_get_lang dictionary_id='
                                        57490.Day'>
                                    <cfelseif YIELD_PAYMENT_PERIOD eq 6> #due_value# <cf_get_lang dictionary_id='
                                        57490.Day'>
                                    </cfif> 
                                </td>
                                <td class="moneybox">#TLFormat(YIELD_RATE)#</td>
                                <td class="moneybox">#TLFormat(AMOUNT)#</td>
                                <td>#dateformat(BANK_ACTION_DATE,dateformat_style)#</td>
                                <cfif len(attributes.current_value_date)>
                                    <td>#dateformat(REESKONT_DATE,dateformat_style)#</td>
                                    <td>
                                        <cfif IS_PAYMENT EQ 0>  <!--- tahsil edilmemişlerin gün farkını göster --->
                                            <cfif len(REESKONT_DATE) and len(attributes.current_value_date)>
                                                #DateDiff("d",REESKONT_DATE,attributes.current_value_date)# 
                                                <cfset datediff_val = "#DateDiff("d",REESKONT_DATE,attributes.current_value_date)#"> 
                                                <input type="hidden" name="reeskont_datediff_val#YIELD_ROWS_ID#" id="reeskont_datediff_val#YIELD_ROWS_ID#" value="#datediff_val#">
                                            <cfelse>
                                                #DateDiff("d",ACTION_DATE,attributes.current_value_date)# 
                                                <cfset datediff_val = "#DateDiff("d",ACTION_DATE,attributes.current_value_date)#"> 
                                                <input type="hidden" name="reeskont_datediff_val#YIELD_ROWS_ID#" id="reeskont_datediff_val#YIELD_ROWS_ID#" value="#datediff_val#">
                                            </cfif>
                                        </cfif>
                                    </td>
                                    <!--- <td style="text-align:right;"> --->
                                            <cfset ygs_ = ( len(YGS) ) ? YGS : 365 >
                                            <cfset val = ((YIELD_RATE / 100) / ygs_)> 
                                            <!--- #TLFormat(AMOUNT - (ACTION_VALUE * val * datediff_val ))#  --->
                                            <cfset totalReeskontValue = AMOUNT - ( ACTION_VALUE * val * datediff_val ) + totalReeskontValue >
                                    <!--- </td> --->
                                    <td class="moneybox"> 
                                        #TLFormat(ACTION_VALUE * val * datediff_val)#
                                        <cfset totalCurrentValue = (ACTION_VALUE * val * datediff_val) + totalCurrentValue>
                                        <input type="hidden" name="reeskont_val#YIELD_ROWS_ID#" id="reeskont_val#YIELD_ROWS_ID#" value="#TLFormat( ACTION_VALUE * val * datediff_val )#">
                                    </td>
                                </cfif>
                                <td width="20" class="text-center">
                                    <a href="#request.self#?fuseaction=bank.form_add_term_deposit&event=yieldPayment&id=#GET_YIELD_PLAN_ROWS.ACTION_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                </td>
                                <cfif len(attributes.current_value_date)>
                                    <cfset date_diff = DateDiff("d",BANK_ACTION_DATE,attributes.current_value_date)>
                                    <cfset start_date = DateDiff("d",ACTION_DATE,attributes.current_value_date)>
                                    <cfif len(REESKONT_DATE)>
                                        <cfset last_reeskont_date = DateDiff("d",REESKONT_DATE,attributes.current_value_date)>
                                    </cfif>
                                    <td width="20" class="text-center">
                                         <!--- Satırdaki Getiri Vade Tarihinden Büyük Olamaz! // Satırdaki Vade Başlangıç Tarihinden Küçük Olamaz! // Satırdaki Son Değerleme Tarihinden Küçük Olamaz! --->
                                        <cfif date_diff gt 0 or start_date lt 0 or ( len(last_reeskont_date) and last_reeskont_date lte 0 )>
                                        <cfelse>
                                            <cfif IS_PAYMENT EQ 0><input type="checkbox" name="currently_value" class="currently_value" value="#GET_YIELD_PLAN_ROWS.YIELD_ROWS_ID#"></cfif>
                                        </cfif>
                                    </td>
                                </cfif>
                                <td width="20" class="text-center">
                                    <cfif IS_PAYMENT EQ 1><i class="fa fa-bookmark" style="color:green;cursor:pointer;" title="<cf_get_lang dictionary_id='49834.Tahsil Edilmiştir'>"></i><cfelse><i class="fa fa-bookmark-o" title="Tahsil Edilmedi" style="vertical-align:middle;"></i></cfif>
                                </td>
                            </tr>
                            <cfset last_reeskont_date = "">
                        </cfoutput>
                    <cfelse>
                        <td colspan="15"><cfif attributes.is_form_submitted neq 1><cf_get_lang dictionary_id='57701.Filtre Ediniz'><cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'></cfif>!</td>
                    </cfif>
                </tbody>
                <cfif len(attributes.current_value_date)>
                    
                    <tr>
                        <td colspan="12" style="text-align:right;" class="txtbold"> <cf_get_lang dictionary_id='57492.Toplam'> : </td>
                        <!--- <td style="text-align:right" class="txtbold"><cfoutput>#TLFormat(totalReeskontValue)#</cfoutput></td> --->
                        <td style="text-align:right" class="txtbold"><cfoutput>#TLFormat(totalCurrentValue)#</cfoutput></td>
                        <td colspan="3"></td>
                    </tr>
                    <cfif attributes.create_budget_plan neq 1>
                        <tr>
                            <td colspan="18" rowspan="2">
                                <cfif xml_is_budget_income_cost eq 1>
                                    <input type="button" class="ui-btn ui-btn-success" style="float:right;" name="income_cost" id="income_cost" value="Gelir İşlemi Yap" onClick="CreateBudgetPlan(1);">
                                </cfif>
                                <cfif xml_is_create_budget_plan eq 1>
                                    <input type="button" class="ui-btn ui-btn-success" style="float:right;" name="budget_plan_rec" id="budget_plan_rec" value="Değerleme ve <cf_get_lang dictionary_id='40594.Gelir Planlama Fişi'> Oluştur" onClick="CreateBudgetPlan(2);">
                                </cfif>
                            </td>
                        </tr>
                    </cfif>
                 
                </cfif>
            </cf_grid_list>
            <table style="display:none;">				
                <input type="hidden" name="deger_get_money" id="deger_get_money" value="<cfoutput>#get_money.recordcount#</cfoutput>">
                <input type="hidden" name="money_type" id="money_type" value="<cfoutput>#session.ep.money#</cfoutput>">
                <cfoutput>
                    <cfif len(session.ep.money)>
                        <cfset selected_money=session.ep.money>
                    </cfif>
                    <cfif session.ep.rate_valid eq 1>
                        <cfset readonly_info = "yes">
                    <cfelse>
                        <cfset readonly_info = "no">
                    </cfif>
                <cfloop query="get_money">
                <tr>
                    <td height="17">
                        <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
                        <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                        <input type="radio" name="rd_money" id="rd_money" value="#money#" onClick="doviz_hesapla();" <cfif selected_money eq money>checked</cfif>>#money#
                    </td>
                    <td>
                        #TLFormat(rate1,0)#/<input type="text" name="value_rate2#currentrow#" id="value_rate2#currentrow#" <cfif readonly_info>readonly</cfif> class="box" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" style="width:50px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="doviz_hesapla();">
                    </td>
                </tr>
                </cfloop>
                </cfoutput>
            </table>
        </cfform>

            <cfset adres="#listgetat(attributes.fuseaction,1,'.')#.interest_revenue">
            <cfif isDefined ("attributes.date1")>
                <cfset adres = "#adres#&date1=#dateformat(attributes.date1,dateformat_style)#">
            </cfif>
            <cfif isDefined ("attributes.date1")>
                <cfset adres = "#adres#&date2=#dateformat(attributes.date2,dateformat_style)#">
            </cfif>
            <cfif isDefined ("attributes.current_value_date")>
                <cfset adres = "#adres#&current_value_date=#dateformat(attributes.current_value_date,dateformat_style)#">
            </cfif>
            <cf_paging page="#attributes.page#" 
                maxrows="#attributes.maxrows#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#"
                adres="#adres#">
        <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
    </cf_box>
</div>
    <script>
        function CreateBudgetPlan(val){ // val = 1 -> Gelir Fişi -- val = 2 -> Planlama Fişi
            var type = val;
            var checked = "";
            var reeskont_datediff_val = "";
            var bank_currency_id = "";
            var reeskont_date = $("#current_value_date").val();
            var keyword = $("#keyword").val();
            var record_date = $("#record_date").val();
            var record_date2 = $("#record_date2").val();
            var date1 = $("#date1").val();
            var date2 = $("#date2").val();
            checked = $(".currently_value").is(":checked");

            if(checked){
                if(confirm("Reeskont İşlemi Yapmak istediğinizden emin misiniz?"))
                {
                    if( $(".currently_value").length >= 1 )
                    {
                        checked_value = "";
                        yield_valuation_amount = "";
                            for( i=0; i < $(".currently_value").length ; i++ ){
                                if( $(".currently_value")[i].checked == true ){
                                        chk_val = $(".currently_value")[i].value;
                                        checked_value += $(".currently_value")[i].value + ",";
                                        yield_valuation_amount += filterNum($("input[id=reeskont_val"+ chk_val +"]").val()) + ",";
                                        reeskont_datediff_val += $("input[id=reeskont_datediff_val"+ chk_val +"]").val() + ",";
                                        bank_currency_id += $("input[id=bank_currency_id"+ chk_val +"]").val() + ",";
                                    }
                            }
                    }
                    add_budget_plan.action='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.interest_revenue&create_budget_plan=1&yield_valuation_date='+reeskont_date+'&yield_valuation_amount='+yield_valuation_amount+'&current_value_date='+reeskont_date+'&keyword='+keyword+'&record_date='+record_date+'&record_date2='+record_date2+'&date1='+date1+'&date2='+date2+'&budget_type='+type+'&reeskont_datediff_val='+reeskont_datediff_val+'&bank_currency_id='+bank_currency_id;  

                    for(st=1;st<=document.getElementById("deger_get_money").value;st++)
                    {
                        document.getElementById("value_rate2" + st).value = filterNum(document.getElementById("value_rate2" + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                    }
                    
                    add_budget_plan.submit();  
                    }
            }else{
                alert("<cf_get_lang dictionary_id='59801.En az 1 adet satır seçmelisiniz!'>");
            }

        }
    </script>
    
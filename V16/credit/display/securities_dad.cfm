<cfparam name="attributes.stockbond_type_id" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.create_budget_plan" default="">
<cfparam name="attributes.current_value_date" default="">
<cfparam name="attributes.saveControl" default="0">
<cfparam name="attributes.yield_type" default="">
<cf_papers paper_type="mkdad">
<cfif len(attributes.current_value_date)>
    <cf_date tarih="attributes.current_value_date">
</cfif>
<cfset adres = "">
<!--- <cfdump var="#attributes#"> --->
<cfquery name="GET_MONEY" datasource="#dsn#">
    SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isdefined('attributes.form_exist')>
    <cfset list_dad = createObject("component","V16.credit.cfc.credit")>
    <cfset get_stockbonds_dad = list_dad.GET_STOCKBONDS_DAD(
                                                            stockbond_type_id : attributes.stockbond_type_id,   
                                                            startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
                                                            maxrows : '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',   
                                                            keyword : '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#', 
                                                            yield_type : '#iif(isdefined("attributes.yield_type"),"attributes.yield_type",DE(""))#',
                                                            Allrow : '#iif(isdefined("attributes.Allrow") and len(attributes.Allrow),"attributes.Allrow",DE(""))#'    
                                                            )>

    <cfset attributes.totalrecords ='#get_stockbonds_dad.QUERY_COUNT#'>
    <cfset adres = "">
<cfelse>
	<cfset get_stockbonds_dad.recordcount = 0>
    <cfset attributes.totalrecords ='0'>	
</cfif>

<cfif attributes.create_budget_plan eq 1 and attributes.saveControl eq 0>
    <cfinclude template="securities_dad_revenue.cfm">
    <script>
        alert("Değerleme İşlemi Tamamlanmıştır.");
        let url = document.URL+"&saveControl=1";
        history.pushState('', '', url);
        location.reload();
        window.location.href = "<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.securities_dad"; 
        
    </script>
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box name="securities_dad" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.securities_dad" method="post">
        <cfform>
            <cf_box_search more="0">
                <input type="hidden" name="form_exist" id="form_exist" value="1">
                <div class="form-group">
                    <cfsavecontent variable="place"><cf_get_lang dictionary_id='58585.Kod'></cfsavecontent>
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" style="width:80px;" placeholder="#place#">
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="text"><cf_get_lang dictionary_id ='51415.Menkul Kıymet Tipi'></cfsavecontent>
                            <cf_wrk_combo
                            name="stockbond_type_id"
                            query_name="GET_STOCKBOND_TYPE"
                            option_name="stockbond_type"
                            option_value="stockbond_type_id"
                            value="#iif(isdefined("attributes.stockbond_type_id"),'attributes.stockbond_type_id',DE(''))#"
                            option_text="#text#"
                            width=120>
                    </div>
                </div>
                <div class="form-group" id="item-dad">
                    <select name="yield_type">
                        <option value=""><cf_get_lang dictionary_id ='57708.Tümü'></option>
                        <option value="1" <cfif attributes.yield_type eq 1> selected</cfif>><cf_get_lang dictionary_id ='60511.Sabit Getirili'></option>
                        <option value="2" <cfif attributes.yield_type eq 2> selected</cfif>><cf_get_lang dictionary_id ='60512.Piyasa Değeri ve Temettülü'></option>
                    </select>
                </div>
                <div class="form-group large" id="item-date1">
                    <div class="input-group">
                        <cfsavecontent variable="place"><cf_get_lang dictionary_id='33566.Değerleme Tarihi'></cfsavecontent>
                        <cfinput value="#dateformat(attributes.current_value_date,dateformat_style)#" type="text" name="current_value_date" validate="#validate_style#" maxlength="10" placeholder="#place#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="current_value_date"></span>
                    </div>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <!--- <cfdump var="#get_stockbonds_dad#"> --->
    <cfsavecontent variable="msg"><cf_get_lang dictionary_id='59920.Değer Artışı Düşüşü'></cfsavecontent>
    <cf_box title="#msg#" hide_table_column="1" uidrop="1" collapsable="1">
        <cf_flat_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id ='57487.No'></th>
                    <th ><cf_get_lang dictionary_id ='57630.Tip'></th>
                    <th><cf_get_lang dictionary_id ='58585.Kod'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id ='51408.Stok Miktarı'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id ='51411.Alış Değer'></th>	
                    <th width="20" title="<cf_get_lang dictionary_id='33046.Sistem Para Birimi'>"><cf_get_lang dictionary_id='64590.S.P.B'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id ='51412.Alış Değer Döviz'></th>
                    <th width="20"><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                    <th title="<cf_get_lang dictionary_id ='29398.Son'> <cf_get_lang dictionary_id ='61048.Muhasebe Tarihi'>"><cf_get_lang dictionary_id='64591.S.M.T'></th>
                    <th title="<cf_get_lang dictionary_id ='61047.Toplam Muhasebe Değeri'>" style="text-align:right;"><cf_get_lang dictionary_id='64592.T.M.D'></th>
                    <th title="<cf_get_lang dictionary_id ='29398.Son'> <cf_get_lang dictionary_id ='55055.Güncelleme Tarihi'>"><cf_get_lang dictionary_id='64593.S.G.T'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id ='51413.Güncel Değer'></th>
                    <th style="text-align:right;" title="<cf_get_lang dictionary_id='61045.Birim Değer Artış Düşüş'>"><cf_get_lang dictionary_id='64594.Br. DAD'></th>
                    <th style="text-align:right;" title="<cf_get_lang dictionary_id='61046.Toplam Değer Artış Düşüş'>"><cf_get_lang dictionary_id='64595.Toplam DAD'></th>
                    <th></th>
                    <cfif len(attributes.current_value_date)>
                        <th><input class="checkControl checkAll" type="checkbox" id="checkAll" name="checkAll" value="0" /></th>
                    <cfelse>
                        <th></th>
                    </cfif>
                    <th width="20" class="header_icn_none text-center"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
                </tr>
            </thead>
            <tbody>
                <cfif isdefined("attributes.form_exist") and get_stockbonds_dad.RECORDCOUNT>
                    <cfoutput query="get_stockbonds_dad" >
                        <cfquery name="get_history_id" datasource="#dsn3#">
                            SELECT TOP 1 HISTORY_ID FROM STOCKBONDS_VALUE_CHANGES WHERE STOCKBOND_ID = #get_stockbonds_dad.STOCKBOND_ID# AND IS_DAD_ACCOUNT IS NULL ORDER BY HISTORY_ID DESC
                        </cfquery>
                        <tr>
                            <td>#rownum#</td>
                            <td><a href="#request.self#?fuseaction=credit.list_stockbonds&event=det&stockbond_id=#stockbond_id#" class="tableyazi" target="_blank">#STOCKBOND_TYPE_#</a></td>
                            <td><a href="#request.self#?fuseaction=credit.list_stockbonds&event=det&stockbond_id=#stockbond_id#" class="tableyazi" target="_blank">#STOCKBOND_CODE#</a></td>
                            <td style="text-align:right;">#ReplaceNoCase(NET_QUANTITY,'.',',','all')#</td>
                            <td style="text-align:right;">#TLFormat(PURCHASE_VALUE)#</td>
                            <td>#session.ep.money#</td>
                            <td style="text-align:right;">#TLFormat(OTHER_PURCHASE_VALUE)#</td>
                            <td>#other_money#</td>
                                <cfquery name="get_dad_account_date" datasource="#dsn3#">
                                    SELECT TOP 1 IS_DAD_ACCOUNT_DATE,ACTUAL_VALUE FROM STOCKBONDS_VALUE_CHANGES WHERE STOCKBOND_ID = #get_stockbonds_dad.STOCKBOND_ID# AND IS_DAD_ACCOUNT = 1 AND IS_DAD_ACCOUNT_DATE IS NOT NULL ORDER BY HISTORY_ID DESC
                                </cfquery>
                            <td>
                                #dateformat(get_dad_account_date.IS_DAD_ACCOUNT_DATE,dateformat_style)#
                            </td>
                            <td style="text-align:right">
                                <cfset s_m_d = 0>
                                <cfif len(IS_DAD_LAST_ACTUAL_VALUE)> <!--- Güncel Değeri var ise --->
                                    <cfset s_m_d = IS_DAD_LAST_ACTUAL_VALUE - PURCHASE_VALUE >
                                    <cfif abs(s_m_d) gt 0>
                                        #TLFormat(abs(s_m_d))#
                                        <cfif s_m_d gt 0>
                                            <i class="fa fa-arrow-up" style="color:green;"></i>
                                        <cfelseif s_m_d lt 0>
                                            <i class="fa fa-arrow-down" style="color:red;"></i> 
                                        </cfif>
                                    </cfif>
                                </cfif>
                            </td>
                            <td>#dateformat(LAST_ACTUAL_DATE,dateformat_style)# #dateformat(LAST_ACTUAL_DATE,timeformat_style)#</td>
                            <td style="text-align:right;">
                                #TLFormat(LAST_ACTUAL_VALUE)#
                                <a onclick="connectAjax('#currentrow#','#stockbond_id#');" id="stockbond_plus_detail#currentrow#" title="<cf_get_lang dictionary_id='51413.Güncel Değer'>"><i class="catalyst-graph"></i></a>
                            </td>
                            <td style="text-align:right;">
                                <cfif len(IS_DAD_LAST_ACTUAL_VALUE) and len(LAST_ACTUAL_VALUE)>  <!--- Güncel Değeri var ise --->
                                    <cfset total_quantity = abs((LAST_ACTUAL_VALUE - IS_DAD_LAST_ACTUAL_VALUE ))>
                                    <cfif total_quantity gt 0>
                                        #TLFormat( abs((LAST_ACTUAL_VALUE - IS_DAD_LAST_ACTUAL_VALUE )))#
                                    </cfif>
                                <cfelseif len(LAST_ACTUAL_VALUE)>
                                    <cfset total_quantity = abs((LAST_ACTUAL_VALUE - PURCHASE_VALUE ))>
                                    <cfif total_quantity gt 0>
                                        #TLFormat( abs((LAST_ACTUAL_VALUE - PURCHASE_VALUE )))#
                                    </cfif>
                                </cfif>
                            </td>
                            <td style="text-align:right;">
                                <cfset total_dad = 0>
                                <cfif len(IS_DAD_LAST_ACTUAL_VALUE) and len(LAST_ACTUAL_VALUE)> <!--- Güncel Değeri var ise --->
                                    <cfset total_dad = ( LAST_ACTUAL_VALUE - IS_DAD_LAST_ACTUAL_VALUE ) * ReplaceNoCase(NET_QUANTITY,'.',',','all') >
                                    <cfif abs(total_dad) gt 0>
                                        #TLFormat(abs(total_dad))# 
                                    </cfif>
                                <cfelseif len(LAST_ACTUAL_VALUE)>
                                    <cfset total_dad = ( LAST_ACTUAL_VALUE - PURCHASE_VALUE ) * ReplaceNoCase(NET_QUANTITY,'.',',','all')>
                                    <cfif abs(total_dad) gt 0>
                                        #TLFormat(abs(total_dad))# 
                                    </cfif>
                                </cfif>
                            </td>
                            <td>
                                <cfif len(LAST_ACTUAL_VALUE)>
                                    <cfif total_dad gt 0>
                                        <i class="fa fa-arrow-up" style="color:green;"></i>
                                    <cfelseif total_dad lt 0>
                                        <i class="fa fa-arrow-down" style="color:red;"></i> 
                                    </cfif>
                                </cfif>
                            </td>
                            <cfif len(attributes.current_value_date) and len(LAST_ACTUAL_VALUE) and abs(total_dad) gt 0>
                                <td>
                                    <input type="checkbox" class="checkControl" name="chcStockbond" id="chcStockbond" total_value="#total_dad#" money_type="<cfif len(other_money)>#other_money#<cfelse>TL</cfif>" value="#get_history_id.HISTORY_ID#">
                                </td>
                            <cfelse>
                                <td></td>
                            </cfif>
                            <td style="align:center;">
                                <a href="#request.self#?fuseaction=credit.list_stockbonds&event=det&stockbond_id=#STOCKBOND_ID#" target="_blank"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                            </td>

                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="17" class="color-row" height="20"><cfif isdefined("attributes.form_exist")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                    </tr>    
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cfset adres="form_exist=1">
            <cfif isdefined('attributes.stockbond_type_id') and len(attributes.stockbond_type_id)>
                <cfset adres = "#adres#&stockbond_type_id=#attributes.stockbond_type_id#" >
            </cfif>
            <cf_paging
                page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="credit.securities_dad&#adres#">
        </cfif>
    </cf_box>

    <cfsavecontent variable="title"><cf_get_lang dictionary_id="57492.Toplam"></cfsavecontent>
    <cf_box id="list_checked" collapsable="0" title="#title#">
        <cfform name="listChecked">
            <cf_box_elements>
                    <div class="col col-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang(388,'İşlem Tipi',57800)#</cfoutput>*</label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process_cat slct_width="285">
                            </div> 
                        </div>
                        <div class="form-group" id="form_ul_process_stage">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process is_upd='0' is_detail='0'>
                            </div>
                        </div>
                        <div class="form-group" id="item-paper_number">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang(468,'Belge No',57880)#</cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="paper_number" maxlength="50" value="#paper_code & '-' & paper_number#">
                            </div> 
                        </div>
                        <div class="form-group" id="item-expense_center_id">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang(1048,'Masraf Merkezi',58460)#</cfoutput>*</label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkExpenseCenter width_info="150" fieldId="expense_center_id" fieldName="expense_center_name" form_name="listChecked" img_info="plus_thin">
                            </div> 
                        </div>
                    </div>
                    <div class="col col-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-expense_item_masraf_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58173.Gelir Kalemi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkExpenseItem width_info="150" fieldId="expense_item_masraf_id" fieldName="expense_item_masraf_name" form_name="listChecked" income_type_info="1" img_info="plus_thin">
                            </div> 
                        </div>
                        <div class="form-group" id="item-expense_item_masraf_gider_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkExpenseItem width_info="150" fieldId="expense_item_masraf_gider_id" fieldName="expense_item_masraf_gider_name" form_name="listChecked" income_type_info="0" img_info="plus_thin">
                            </div> 
                        </div>
                        <div class="form-group" id="item-deger_artis_account_code">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61049.Değer Artış'> <cf_get_lang dictionary_id='58811.Muhasebe Kodu'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cf_wrk_account_codes form_name='listChecked' account_code='acc_id' account_name='acc_name' search_from_name='1'>			
                                    <input type="hidden" name="acc_id" id="acc_id" value="">
                                    <cfinput type="text" name="acc_name" id="acc_name" value="" style="width:120px;" onkeyup="get_wrk_acc_code_1();" onFocus="AutoComplete_Create('acc_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','acc_id','listChecked','3','120');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=listChecked.acc_name&field_id=listChecked.acc_id','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-deger_azalis_account_code">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61050.Değer Azalış'> <cf_get_lang dictionary_id='58811.Muhasebe Kodu'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cf_wrk_account_codes form_name='listChecked' account_code='acc_id_azalis' account_name='acc_name_azalis' search_from_name='1'>			
                                    <input type="hidden" name="acc_id_azalis" id="acc_id_azalis" value="">
                                    <cfinput type="text" name="acc_name_azalis" id="acc_name_azalis" value="" style="width:120px;" onkeyup="get_wrk_acc_code_1();" onFocus="AutoComplete_Create('acc_name_azalis','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','acc_id_azalis','listChecked','3','120');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=listChecked.acc_name_azalis&field_id=listChecked.acc_id_azalis','list');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                <div class="col col-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="col col-12">
                        <div class="form-group col col-3">
                            <label><cf_get_lang dictionary_id='57489.Para Birimi'></label>
                        </div>
                        <div class="form-group col col-3">
                            <label><cf_get_lang dictionary_id='61049.Değer Artışı'></label>
                        </div>
                        <div class="form-group col col-3">
                            <label><cf_get_lang dictionary_id='61051.Değer Düşüşü'></label>
                        </div>
                        <div class="form-group col col-3">
                            <label><cf_get_lang dictionary_id='58583.Fark'></label>
                        </div>
                    </div>
                    <cfoutput query="get_money">
                        <cfset id="item-#currency_code#">
                        <div class="form-group col col-12" id="#id#">
                            <label style="display:none!important;"> #CURRENCY_CODE#</label>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-3">
                                <input value="#money#" type="text" readonly style="width:50px;">
                            </div>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-3">
                                <div class="input-group">
                                    <span class="input-group-addon"><strong>0</strong></span>
                                    <input id="deger_artis_#money#" type="text" name="deger_artis_#money#" value="0" class="moneybox" readonly>
                                </div>
                            </div>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-3">
                                <div class="input-group">
                                    <span class="input-group-addon"><strong>0</strong></span>
                                    <input id="deger_dusus_#money#" type="text" name="deger_dusus_#money#" value="0" class="moneybox" readonly>
                                </div>
                            </div>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-3">
                                <div class="input-group">
                                    <input id="deger_fark_#money#" type="text" name="deger_fark_#money#" value="0" class="moneybox" readonly>
                                </div>
                            </div>
                        </div>
                    </cfoutput>
                    <div class="col col-12">
                        <div class="form-group col col-12">
                            <label><cf_get_lang dictionary_id='33046.Sistem Para Birimi'>- <cf_get_lang dictionary_id='57492.Toplam'></label>
                        </div>
                    </div>
                    <div class="form-group col col-12" id="item-_ep_money">
                        <label style="display:none!important;">Ep Money</label>
                        <div class="col col-3">
                            <input type="text" value="<cfoutput>#session.ep.money#</cfoutput>" readonly style="width:50px;">
                        </div>
                        <div class="col col-3">
                            <div class="input-group">
                                <span class="input-group-addon"><strong>0</strong></span>
                                <input id="deger_artis_system" type="text" name="deger_artis_system" value="0" class="moneybox" readonly>
                            </div>
                        </div>
                        <div class="col col-3">
                            <div class="input-group">
                                <span class="input-group-addon"><strong>0</strong></span>
                                <input id="deger_dusus_system" type="text" name="deger_dusus_system" value="0" class="moneybox" readonly>
                            </div>
                        </div>
                        <div class="col col-3">
                            <div class="input-group">
                                <input id="deger_fark_system" type="text" name="deger_fark_system" value="0" class="moneybox" readonly>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
        <cf_box_footer>
            <div class="text-right">
                <input type="button" name="saveProcess" id="saveProcess" onclick="CreateAcc()" value="<cf_get_lang dictionary_id='57461.Kaydet'>">
            </div>
        </cf_box_footer>
        <table id="mny_table" style="display:none;">				
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
                    <input type="radio" name="rd_money" id="rd_money" value="#money#"  onClick="doviz_hesapla();" <cfif selected_money eq money>checked</cfif>>#money#
                </td>
                <td>
                    #TLFormat(rate1,0)#/<input type="text" name="value_rate2#currentrow#" money_type="#money#" id="value_rate2#currentrow#" <cfif readonly_info>readonly</cfif> class="box" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" style="width:50px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="doviz_hesapla();">
                </td>
            </tr>
            </cfloop>
            </cfoutput>
        </table>
        </cfform>
    </cf_box>
</div>

<script>

    $(function(){
        $('input[name=checkAll]').click(function(){
            if(this.checked){
                $('.checkControl').each(function(){
                    $(this).prop("checked", true);
                });
            }
            else{
                $('.checkControl').each(function(){
                    $(this).prop("checked", false);
                });
            }
        });
        
        $('.checkControl').click(function(){

            deger_artis =  { <cfoutput query="get_money"> #money# : { money : 0.0, counter : 0 , system_money : 0.0 , system_money_counter : 0 } ,</cfoutput> }
            deger_dusus = { <cfoutput query="get_money"> #money# : { money : 0.0, counter : 0 , system_money : 0.0 , system_money_counter : 0 } ,</cfoutput> }
            fark = { <cfoutput query="get_money"> #money# : { money : 0.0, system_money : 0.0 } ,</cfoutput> }
            
            $('.checkControl').each(function() {

                type = $(this).attr("money_type"); 
                if(this.checked){
                    if( parseFloat($(this).attr("total_value")) < 0 ) {
                        deger_dusus[type]["money"] += parseFloat($(this).attr("total_value"));
                        deger_dusus["<cfoutput>#session.ep.money#</cfoutput>"]["system_money"] += parseFloat($(this).attr("total_value")) / parseFloat($("table#mny_table input[money_type=<cfoutput>#session.ep.money#</cfoutput>]").val()) * parseFloat($("table#mny_table input[money_type="+type+"]").val()); 
                        deger_dusus[type]["counter"] ++;
                        deger_dusus["<cfoutput>#session.ep.money#</cfoutput>"]["system_money_counter"]++;
                    }else{
                        deger_artis[type]["money"] += parseFloat($(this).attr("total_value"));
                        deger_artis["<cfoutput>#session.ep.money#</cfoutput>"]["system_money"] += parseFloat($(this).attr("total_value")) / parseFloat($("table#mny_table input[money_type=<cfoutput>#session.ep.money#</cfoutput>]").val()) * parseFloat($("table#mny_table input[money_type="+type+"]").val()); 
                        deger_artis[type]["counter"] ++;
                        deger_artis["<cfoutput>#session.ep.money#</cfoutput>"]["system_money_counter"]++;
                    }
                        fark[type]["money"] += parseFloat($(this).attr("total_value"));
                        fark["<cfoutput>#session.ep.money#</cfoutput>"]["system_money"] += parseFloat($(this).attr("total_value")) / parseFloat($("table#mny_table input[money_type=<cfoutput>#session.ep.money#</cfoutput>]").val()) * parseFloat($("table#mny_table input[money_type="+type+"]").val()); 
                }
                if( !$(this).hasClass("checkAll") ) {
                    $('#deger_artis_'+type).val(commaSplit(deger_artis[type]["money"])).parent().find("span.input-group-addon > strong").html(deger_artis[type]["counter"]);
                    $('#deger_dusus_'+type).val(commaSplit(deger_dusus[type]["money"])).parent().find("span.input-group-addon > strong").html(deger_dusus[type]["counter"]);
                    $('#deger_fark_'+type).val(commaSplit(fark[type]["money"]));  
                }
            });

            $("#deger_artis_system").val(commaSplit(deger_artis["<cfoutput>#session.ep.money#</cfoutput>"]["system_money"])).parent().find("span.input-group-addon > strong").html(deger_artis["<cfoutput>#session.ep.money#</cfoutput>"]["system_money_counter"]);
            $("#deger_dusus_system").val(commaSplit(deger_dusus["<cfoutput>#session.ep.money#</cfoutput>"]["system_money"])).parent().find("span.input-group-addon > strong").html(deger_dusus["<cfoutput>#session.ep.money#</cfoutput>"]["system_money_counter"]);
            $("#deger_fark_system").val(commaSplit(fark["<cfoutput>#session.ep.money#</cfoutput>"]["system_money"]));
          
        });
    });

    function CreateAcc(){
        rowCount = 0;
        var row_id = new Array();
        var money_type = new Array();
        var CurrentDate = $("#current_value_date").val();

        if(confirm('<cf_get_lang dictionary_id="45686.Kaydetmek istediğinize eminmisinz?">')){
            $('.checkControl').each(function() {
                if(this.checked){
                    rowCount++;
                    row_id.push(this.value);
                    money_type.push($(this).attr("money_type"));
                }
            });
            if(rowCount > 0){
                Allrow = row_id.join(",");
                Moneytype = money_type.join(",");
                listChecked.action = "<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.securities_dad&create_budget_plan=1&form_exist=1&Allrow="+Allrow+"&currentDate="+CurrentDate+"&Moneytype="+Moneytype;
                
                for(st=1;st<=document.getElementById("deger_get_money").value;st++)
                {
                    document.getElementById("value_rate2" + st).value = filterNum(document.getElementById("value_rate2" + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                }

                listChecked.submit();
                return false;
            }else{
                alert("<cf_get_lang dictionary_id='59801.En Az bir satır seçmelisiniz!'>");
                return false;
            }
        }else{
            return false;
        }
    }

    function connectAjax(crtrow,stockbond_id)
	{
		cfmodal('<cfoutput>#request.self#?fuseaction=credit.ajax_stockbond_value_currently</cfoutput>&stockbond_id='+stockbond_id, 'warning_modal');
	}

</script>
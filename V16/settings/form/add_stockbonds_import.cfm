<cfquery name="GET_MONEY" datasource="#dsn#">
    SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<div class="col col-12 col-xs-12">
    <cf_box title="#getLang('','Menkul Kıymetler Aktarım','60594')#" closable="0">
        <cfform name="formimport" id="formimport" action="#request.self#?fuseaction=settings.emptypopup_form_add_stockbonds_import" enctype="multipart/form-data" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format">
                                <option value="UTF-8"><cf_get_lang no='1405.UTF-8'></option>
                            </select>
                        </div>
                    </div> 
                    <div class="form-group" id="item-uploaded_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">
                        </div>
                    </div>  
                    <div class="form-group" id="item-download-link">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <a href="/documents/settings/mk_aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                        </div>
                    </div>           
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                    </div>
                    <div class="form-group" id="item-exp1">
                        <cf_get_lang dictionary_id='54238.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır.'>
                    </div>
                    <div class="form-group" id="item-exp2">
                        <cf_get_lang dictionary_id='44951.Bu belgede olması gereken alan sayısı'> : 21
                    </div>
                    <div class="form-group" id="item-exp3">
                        <cf_get_lang dictionary_id='53860.Alanlar sırasıyla'>;
                    </div>
                    <div class="form-group" id="item-exp4">
                        1-<cf_get_lang dictionary_id='51415.M.Kıymet Tipi'> ID (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
                        2-<cf_get_lang dictionary_id='58585.Kod'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
                        3-<cf_get_lang dictionary_id='54291.Açıklaması'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
                        4-<cf_get_lang dictionary_id='32992.Alış Tarihi'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) <cf_get_lang dictionary_id='58967.Örnek'> : 23.03.2020<br/>
                        5-<cf_get_lang dictionary_id='57800.İşlem Tipi'> ID (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
                        6-<cf_get_lang dictionary_id='51409.Nominal Deger'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) <cf_get_lang dictionary_id='58967.Örnek'>: 1.000<br/>
                        7-<cf_get_lang dictionary_id='51410.Nominal Deger Döviz'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) <cf_get_lang dictionary_id='58967.Örnek'> : 1.000<br/>
                        8-<cf_get_lang dictionary_id='51411.Alış Değer'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) <cf_get_lang dictionary_id='58967.Örnek'> : 1.000<br/>
                        9-<cf_get_lang dictionary_id='51412.Alış Değer Döviz'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) <cf_get_lang dictionary_id='58967.Örnek'> : 1.000<br/>
                        10- <cf_get_lang dictionary_id='57635.Miktar'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
                        11-<cf_get_lang dictionary_id='39893.Toplam Alış'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) <cf_get_lang dictionary_id='58967.Örnek'> : 1.000<br/>
                        12-<cf_get_lang dictionary_id='51420.Toplam Alış Döviz'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) <cf_get_lang dictionary_id='58967.Örnek'> : 1.000<br/>
                        13-<cf_get_lang dictionary_id='58460.Masraf Merkezi'> ID (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
                        14-<cf_get_lang dictionary_id='56648.Bütçe Kalemi'>(<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
                        15-<cf_get_lang dictionary_id='58811.Muhasebe Kodu'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) <cf_get_lang dictionary_id='58967.Örnek'> : 111.01.001<br/>
                        16-<cf_get_lang dictionary_id='40995.Getiri Tipi'> ID (<cf_get_lang dictionary_id='29801.Zorunlu'>) <cf_get_lang dictionary_id='60511.Sabit Getirili'> : 1 - <cf_get_lang dictionary_id='64278.Piyasa Değerli'> : 2<br/>
                        17-<cf_get_lang dictionary_id='29449.Banka Hesabı'>(<cf_get_lang dictionary_id='29801.Zorunlu'>) <cf_get_lang dictionary_id='58967.Örnek'> : 38-TL (<cf_get_lang dictionary_id='57521.Banka'> ID - <cf_get_lang dictionary_id='57489.Para Birimi'> ) <br/>
                        18-<cf_get_lang dictionary_id='57519.Cari Hesap'> ID (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>   
                        19-<cf_get_lang dictionary_id='40325.Komisyon'> <cf_get_lang dictionary_id='64279.Yok ise kolonu boş bırakın'></br>
                        20-<cf_get_lang dictionary_id='40325.Komisyon'><cf_get_lang dictionary_id='29801.Zorunlu'><cf_get_lang dictionary_id='64279.Yok ise kolonu boş bırakın'></br>
                        21-<cf_get_lang dictionary_id='35334.Komisyon Oranı'> <cf_get_lang dictionary_id='64279.Yok ise kolonu boş bırakın'></br>
                    </div>  
                </div>       
                 <div class="col col-2 col-md-2 col-sm-2 col-xs-12" type="column" index="2" sort="true">      
                    <div class="form-group" id="item-exp5" style="display: none;">
                            <input class="text-center" type="hidden" name="deger_get_money" id="deger_get_money" value="<cfoutput>#get_money.recordcount#</cfoutput>">
                            <input class="text-center" type="hidden" name="money_type" id="money_type" value="<cfoutput>#session.ep.money#</cfoutput>">
                            <div class="col">
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
                                        <div class="form-group">
                                            <input nowrap="nowrap" type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
                                            <input nowrap="nowrap"small" type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                                            <input nowrap="nowrap" class="text-center" type="radio" name="rd_money" id="rd_money" value="#money#" onClick="doviz_hesapla();" <cfif selected_money eq money>checked</cfif>>#money#
                                            #TLFormat(rate1,0)#/<input width="30px"  nowrap="nowrap" type="text" name="value_rate2#currentrow#" id="value_rate2#currentrow#" <cfif readonly_info>readonly</cfif> class="box" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="doviz_hesapla();">
                                        </div>                                
                                    </cfloop>        
                                </cfoutput>                              
                            </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0'>
            </cf_box_footer>  
        </cfform>
    </cf_box>
</div>

<script>
  for(st=1;st<=document.getElementById("deger_get_money").value;st++)
    {
        document.getElementById("value_rate2" + st).value = filterNum(document.getElementById("value_rate2" + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
    }
</script>




























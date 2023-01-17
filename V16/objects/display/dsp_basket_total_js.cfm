<cfscript>
	str_money_bskt_found = true;
	sa_percent = 0;
	if (((fusebox.circuit is 'invoice') or listfind("1,2,3,4,5,6,7,10,14,18,20,21,33,38,46,51,52",attributes.basket_id,",")) and arraylen(sepet.satir))
		{
		
		if (not isnumeric(sepet.genel_indirim)) sepet.genel_indirim = 0;
		if (sepet.total gt 0 and sepet.total gt sepet.toplam_indirim)/*buradaki sepet.toplam_indirim belgenin fatura alti indirim haric indirimleri toplamidir*/
			{
			sa_percent = (sepet.genel_indirim / (sepet.total-sepet.toplam_indirim)) * 100;
			sepet.total_tax = wrk_round( (sepet.total_tax * (100-sa_percent)) / 100 ,price_round_number);
			//writeoutput('#sepet.total_tax#');
			if( ListFindNoCase(display_list, "OTV") and  StructKeyExists(sepet,'total_otv'))
				sepet.total_otv = wrk_round( (sepet.total_otv * (100-sa_percent)) / 100 ,price_round_number);
			sepet.toplam_indirim = sepet.toplam_indirim + sepet.genel_indirim;
			sepet.net_total = wrk_round( (sepet.net_total * (100-sa_percent)) / 100 ,price_round_number);
			//writeoutput('sa_percent:#sa_percent#,sepet.total_tax:#sepet.total_tax#,sepet.toplam_indirim:#sepet.toplam_indirim#,sepet.net_total:#sepet.net_total#');
			if(StructKeyExists(sepet,'tevkifat_box'))
				{
				beyan_tutar = 0;
				for (m=1;m lte arraylen(sepet.kdv_array);m=m+1)
				{	
					temp_tax = wrk_round(sepet.kdv_array[m][2]*(100-sa_percent)/100,8);
					beyan_tutar = beyan_tutar+wrk_round(temp_tax*sepet.tevkifat_oran,8);
				}
				sepet.net_total = sepet.net_total-sepet.total_tax+beyan_tutar;
				sepet.total_tax = beyan_tutar;
				}
			}
		}
	if (isDefined('sepet.stopaj') and len(sepet.stopaj))
		sepet.net_total = sepet.net_total - sepet.stopaj;//faturaya toplam kaydedilen stopaj ekrana basilirken ciksin
	if ( listfind("1,20,42,43",attributes.basket_id,",") and StructKeyExists(sepet,'yuvarlama') and len(sepet.yuvarlama))
		sepet.net_total = wrk_round((sepet.net_total + sepet.yuvarlama),price_round_number);
</cfscript>

<cfif isDefined('attributes.order_id') and len(attributes.order_id)>
    <cfquery name="GET_MONEY_CREDITS" datasource="#DSN3#">
        SELECT 
            SUM(OMCU.USED_VALUE) AS TOTAL_USED_VALUE 
        FROM 
            ORDER_MONEY_CREDIT_USED OMCU,
            ORDER_MONEY_CREDITS OMC
        WHERE 
            OMC.ORDER_CREDIT_ID = OMCU.ORDER_CREDIT_ID AND
            OMCU.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
    </cfquery>
    
    <cfif get_money_credits.recordcount and len(get_money_credits.total_used_value)>
        <cfset money_cred_discount = get_money_credits.total_used_value>
        <cfset sepet.net_total = sepet.net_total - money_cred_discount>
        <cfset sepet.toplam_indirim = sepet.toplam_indirim + money_cred_discount>
    </cfif>
</cfif>
                                    
<cfoutput>
    <div class="col col-2 col-md-3 col-sm-6 col-xs-12" id="basket_money_totals_table" <cfif not ListFindNoCase(display_list, "is_price_total_other_money")>style="display:none"</cfif>>
        <div class="totalBox">
            <div class="totalBoxHead font-grey-mint">
                <span class="headText"><cf_get_lang dictionary_id='57677.Dövizler'></span>
                <div class="collapse">
                    <span class="icon-minus"></span>
                </div>
            </div>
            <div class="totalBoxBody">
                      
            <input type="hidden" id="kur_say" name="kur_say" value="#get_money_bskt.recordcount#">
            <cfif not isdefined("default_basket_money_")>
                    <cfif IsQuery(get_standart_process_money) and len(get_standart_process_money.STANDART_PROCESS_MONEY)>
                        <cfset default_basket_money_=get_standart_process_money.STANDART_PROCESS_MONEY>
                    <cfelseif len(session_base.money2)>
                        <cfset default_basket_money_=session_base.money2>
                    <cfelse>
                        <cfset default_basket_money_=session_base.money>
                    </cfif>
            </cfif>
           
                    <table cellspacing="0" id="money_rate_table">
                    <cfset money_order_ = 0>
                    <cfloop query="get_money_bskt">
                        <cfif IS_SELECTED>
                            <cfset str_money_bskt = money_type>
                            <cfset selectedRadioButton = 1>
                        </cfif>
                    </cfloop>
                    
                    
                    <cfloop query="get_money_bskt"><!--- 20060214 hassas bi yer, tikkat pls... --->
                        <cfset money_order_ = money_order_ + 1>
                        <cfif IS_SELECTED>
                            <cfset sepet_rate1 = rate1>
                            <cfset sepet_rate2 = rate2>
                            <cfset str_money_bskt_found = false>
                        <cfelseif str_money_bskt_found and not ListFindNoCase(display_list, "is_price_total_other_money")> <!--- basket sablonunda dovizler gosterilmesin secilmisse, secili doviz olarak sistem para br i atanır. --->
                            <cfset sepet_rate1 = 1>
                            <cfset sepet_rate2 = 1>
                            <cfif not isdefined("selectedRadioButton")>
                                <cfset str_money_bskt = session_base.money>
                            </cfif>
                            <cfset str_money_bskt_found = false>
                        <cfelseif str_money_bskt_found and ListFindNoCase(display_list, "is_price_total_other_money") and money_type is default_basket_money_>
                            <cfset sepet_rate1 = rate1>
                            <cfset sepet_rate2 = rate2>
                            <cfif not isdefined("selectedRadioButton")>
                                <cfset str_money_bskt = money_type>
                            </cfif>
                            <cfset str_money_bskt_found = false>
                        </cfif>
                        <cfif isdefined("attributes.basket_sub_id") and attributes.basket_sub_id eq 21>
                            <cfif isdefined('attributes.company_id') and len(attributes.company_id)>
                                <cfquery name="get_money_risc" datasource="#dsn#">
                                    SELECT MONEY FROM COMPANY_CREDIT WHERE COMPANY_ID = #attributes.company_id# AND OUR_COMPANY_ID = #session.ep.company_id#
                                </cfquery>
                                <cfset sepet_rate1 = rate1>
                                <cfset sepet_rate2 = rate2>
                                <cfif not isdefined("selectedRadioButton")>
                                    <cfset str_money_bskt = get_money_risc.money>
                                </cfif>
                                <cfset str_money_bskt_found = false>
                            </cfif>
                        </cfif>
                        <cfif attributes.basket_id eq 31 and isdefined("attributes.is_from_report") and isdefined("attributes.convert_str_other_money")>
                            <cfif not isdefined("selectedRadioButton")>
                                <cfset str_money_bskt = listlast(attributes.convert_str_other_money)>
                            </cfif>
                            <cfset str_money_bskt_found = false>
                        </cfif>
                    
                        <tr >
                    
                        <cfif session.ep.rate_valid eq 1>
                            <cfset readonly_info = "yes">
                        <cfelse>
                            <cfset readonly_info = "no">
                        </cfif>
                        <input type="hidden" id="hidden_rd_money_#currentrow#" name="hidden_rd_money_#currentrow#" value="#money_type#">
                        <input type="hidden" id="txt_rate1_#currentrow#" name="txt_rate1_#currentrow#" value="#TLFormat(rate1)#">
                        <td nowrap="nowrap"><input type="radio" class="rdMoney" id="rd_money" name="rd_money" value="#currentrow#" onclick="selectedCurrency('#money_type#'); toplam_hesapla(0);" <cfif isDefined('str_money_bskt') and str_money_bskt eq money_type>checked="checked"</cfif>></td>
                        <td nowrap="nowrap">#money_type#</td>
                        <td nowrap="nowrap">#TLFormat(rate1,0)#/</td>
                        <td nowrap="nowrap"><input type="text" <cfif readonly_info>readonly</cfif> id="txt_rate2_#currentrow#" name="txt_rate2_#currentrow#" value="#TLFormat(rate2,basket_rate_round_number)#" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event,basket_rate_round_number));" onblur="if((this.value.length == 0) || filterNum(this.value,basket_rate_round_number) <=0 ) this.value=commaSplit(1,basket_rate_round_number);kur_degistir(#currentrow#);" <cfif money_type eq session_base.money>readonly</cfif>></td>
                    
                        </tr>
                    
                </cfloop>						
                    </table>
      
            </div>
        </div>    
    </div>      
    <cfset doviz_vergili_toplam = 0>
    <cfset doviz_toplam = 0>
        <div class="col col-4 col-md-5 col-sm-6 col-xs-12" id="basket_money_totals_table" <cfif not ListFindNoCase(display_list, "is_price_total_other_money")>style="display:none"</cfif>>
            <div class="totalBox">
                <div class="totalBoxHead font-grey-mint">
                    <span class="headText"><cf_get_lang dictionary_id='57492.Toplam'></span>
                    <div class="collapse">
                        <span class="icon-minus"></span>
                    </div>
                </div>
                <div class="totalBoxBody">       
                    <table>
                        <tr >
                            <td width="100" class="txtbold" ><cf_get_lang dictionary_id='57492.Toplam'></td>
                            <td width="75" id="total_default"  style="text-align:right;" name="total_default">#TLFormat(sepet.total,basket_total_round_number)#</td>
                            <td width="75" id="total_wanted" style="text-align:right;" <cfif not ListFindNoCase(display_list, "is_price_total_other_money")>style="display:none"</cfif> name="total_wanted">#TLFormat(sepet.total*sepet_rate1/sepet_rate2,basket_total_round_number)#</td>
                        </tr>
                        <!--- teklif icin baskette fatura alti indirim alani acildi, id:3 --->
                        <cfif fusebox.circuit eq 'invoice' or listfind("1,2,3,4,5,6,10,14,18,20,21,33,38,42,43,46,51,52",attributes.basket_id,",")>
                        <tr  <cfif not ListFindNoCase(display_list,"is_paper_discount")>style="display:none;"</cfif>>
                            <td nowrap="nowrap" class="txtbold" ><cf_get_lang dictionary_id='57678.Fatura Altı İndirim'> <cf_get_lang dictionary_id="58716.KDV'li"></td>
                            <td style="text-align:right;" nowrap="nowrap">
                                <input id="genel_indirim_kdvli_hesap_" name="genel_indirim_kdvli_hesap_" type="text" class="box" style="width:55px;" onfocus="if(this.value=='0,00') this.value='';" onblur="if(!this.value.length) this.value=''; kdvli_net_indirim_hesapla();" onkeyup="return(FormatCurrency(this,event,basket_total_round_number));"/>
                                <a href="javascript://" onclick="alert('Bu alana yazılan tutar döviz kuruna oranlanarak fatura altı indirim alanının hesaplama yapmasını sağlar.');"><i class="fa fa-question"></i></a>
                            </td>
                            <td style="text-align:right;" <cfif not ListFindNoCase(display_list, "is_price_total_other_money")>style="display:none"</cfif>>
                                <input id="genel_indirim_doviz_brut_hesap" name="genel_indirim_doviz_brut_hesap" type="text" class="box" style="width:55px;" onfocus="if(this.value=='0,00') this.value='';" onblur="if(!this.value.length) this.value=''; kdvli_doviz_indirim_hesapla();" onkeyup="return(FormatCurrency(this,event,basket_total_round_number));"/>
                                <a href="javascript://" onclick="alert('Bu alana yazılan tutar döviz kuruna oranlanarak fatura altı indirim alanının hesaplama yapmasını sağlar.');"><i class="fa fa-question"></i></a>
                            </td>
                        </tr>
                        <tr  <cfif not ListFindNoCase(display_list,"is_paper_discount")>style="display:none;"</cfif>>
                            <td nowrap="nowrap" class="txtbold" ><cf_get_lang dictionary_id='57678.Fatura Altı İndirim'></td>
                            <td style="text-align:right;"><input id="genel_indirim_" name="genel_indirim_" type="text" class="box" style="width:100%;" onfocus="if(this.value=='0,00') this.value='';" onblur="genelIndirimHesapla(this);" onkeyup="return(FormatCurrency(this,event,basket_total_round_number));" value="<cfif StructKeyExists(sepet,'genel_indirim')>#TLFormat(sepet.genel_indirim,basket_total_round_number)#</cfif>" <cfif ListFindNoCase(basket_read_only_discount_list, "genel_indirim_")>readonly</cfif> autocomplete="off"></td>
                            <td style="text-align:right;" nowrap="nowrap" <cfif not ListFindNoCase(display_list, "is_price_total_other_money")>style="display:none"</cfif>>
                                <input id="genel_indirim_doviz_net_hesap" name="genel_indirim_doviz_net_hesap" type="text" class="box" style="width:55px;" onfocus="if(this.value=='0,00') this.value='';" onblur="if(!this.value.length) this.value=''; kdvsiz_doviz_indirim_hesapla();" onkeyup="return(FormatCurrency(this,event,basket_total_round_number));" value="<cfif StructKeyExists(sepet,'genel_indirim')>#TLFormat(sepet.genel_indirim*sepet_rate1/sepet_rate2,basket_total_round_number)#</cfif>"/>
                                <a href="javascript://" onclick="alert('Bu alana yazılan tutar döviz kuruna oranlanarak KDVli fatura altı indirim alanının hesaplama yapmasını sağlar.');"><i class="fa fa-question"></i></a>
                            </td>
                        </tr> 
                        </cfif>
                        <cfif listfind("1,20,42,43",attributes.basket_id,",")>
                        <tr >
                            <td class="txtbold"><cf_get_lang dictionary_id='57710.Yuvarlama'></td>
                            <td style="text-align:right;">
                                <input id="yuvarlama" name="yuvarlama" type="text" class="box" style="width:75px;"  onfocus="if(this.value == '0,00') this.value = '';" onblur="if(this.value.length == 0) this.value = '0,00'; toplam_hesapla(0);" onkeyup="return(FormatCurrency(this,event,basket_total_round_number));" value="<cfif StructKeyExists(sepet,'yuvarlama')>#TLFormat(sepet.yuvarlama,basket_total_round_number)#</cfif>" autocomplete="off">
                                <input type="hidden" id="flt_net_total_all" name="flt_net_total_all" value="0">
                            </td>
                            <td style="text-align:right"; nowrap="nowrap" <cfif not ListFindNoCase(display_list, "is_price_total_other_money")>style="display:none"</cfif>>
                                <input id="yuvarlama_doviz" name="yuvarlama_doviz" type="text" class="box" style="width:55px;" onfocus="if(this.value=='0,00') this.value='';" onblur="if(!this.value.length) this.value=''; yuvarlama_doviz_hesapla();" onkeyup="return(FormatCurrency(this,event,basket_total_round_number));"/>
                                <a href="javascript://" onclick="alert('Bu alana yazılan tutar döviz kuruna oranlanarak yuvarlama alanının hesaplama yapmasını sağlar.');"><i class="fa fa-question"></i></a>
                            </td>
                        </tr>
                        </cfif>
                        <tr > 
                            <td class="txtbold"><cf_get_lang dictionary_id='57649.Toplam İndirim'> </td>
                            <td width="75" id="total_discount_default" style="text-align:right;" name="total_discount_default">#TLFormat(sepet.toplam_indirim,basket_total_round_number)#</td>
                            <td width="75" id="total_discount_wanted" style="text-align:right;" <cfif not ListFindNoCase(display_list, "is_price_total_other_money")>style="display:none"</cfif> name="total_discount_wanted">#TLFormat(sepet.toplam_indirim*sepet_rate1/sepet_rate2,basket_total_round_number)#</td>
                        </tr>
                        <cfif StructKeyExists(sepet,'total_otv')>
                            <cfset sepet_kdvsiz_toplam = sepet.net_total-sepet.total_tax-sepet.total_otv>
                        <cfelse>
                            <cfset sepet_kdvsiz_toplam = sepet.net_total-sepet.total_tax>
                        </cfif>
                        <tr > 
                            <td class="txtbold"><cf_get_lang dictionary_id="30024.KDVsiz"> <cf_get_lang dictionary_id="57492.Toplam"></td>
                            <td width="75" id="brut_total_default" style="text-align:right;" name="total_discount_default">#TLFormat(sepet_kdvsiz_toplam,basket_total_round_number)#</td>
                            <td width="75" id="brut_total_wanted" style="text-align:right;" <cfif not ListFindNoCase(display_list, "is_price_total_other_money")>style="display:none"</cfif> name="total_discount_wanted">#TLFormat(sepet_kdvsiz_toplam*sepet_rate1/sepet_rate2,basket_total_round_number)#</td>
                        </tr>
                        <tr > 
                            <td class="txtbold"><cf_get_lang dictionary_id='57643.Toplam KDV'></td>
                            <td id="total_tax_default" style="text-align:right;" name="total_tax_default">#TLFormat(sepet.total_tax,basket_total_round_number)#</td>
                            <td id="total_tax_wanted" style="text-align:right;" <cfif not ListFindNoCase(display_list, "is_price_total_other_money")>style="display:none"</cfif> name="total_tax_wanted">#TLFormat(sepet.total_tax*sepet_rate1/sepet_rate2,basket_total_round_number)#</td>
                        </tr>
                        <cfif ListFindNoCase(display_list, "OTV")>
                        <tr > 
                            <td class="txtbold"><cf_get_lang dictionary_id='58021.ÖTV'></td>
                            <td id="total_otv_default" style="text-align:right;" name="total_otv_default"><cfif StructKeyExists(sepet,'total_otv')>#TLFormat(sepet.total_otv,basket_total_round_number)#</cfif></td>
                            <td id="total_otv_wanted" style="text-align:right;" <cfif not ListFindNoCase(display_list, "is_price_total_other_money")>style="display:none"</cfif> name="total_otv_wanted"><cfif StructKeyExists(sepet,'total_otv')>#TLFormat(sepet.total_otv*sepet_rate1/sepet_rate2,basket_total_round_number)#</cfif></td>
                        </tr>
                        </cfif>
                        <cfif ListFindNoCase(display_list, "OIV")>
                        <tr height="20">
                            <td class="txtbold"><cf_get_lang dictionary_id="50982.öiv"></td>
                            <td id="total_oiv_default" style="text-align:right;" name="total_oiv_default"></td>
                            <input type="hidden" id="total_oiv"  name="total_oiv" value="">
                            <td id="total_oiv_wanted" style="text-align:right;" name="total_oiv_wanted"></td>
                        </tr>
                        </cfif>
                        <cfif ListFindNoCase(display_list, "BSMV")>
                        <tr height="20">
                            <td class="txtbold"><cf_get_lang dictionary_id="50923.BSMV"></td>
                            <td id="total_bsmv_default" style="text-align:right;" name="total_bsmv_default"></td>
                            <input type="hidden" id="total_bsmv"  name="total_bsmv" value="">
                            <td id="total_bsmv_wanted" style="text-align:right;" name="total_bsmv_wanted"></td>
                        </tr>
                        </cfif>
                        <tr height="20"> 
                        <tr > 
                            <td class="txtbold"><!--- Genel Toplam---><cf_get_lang dictionary_id='51316.KDVli Toplam'> </td>
                            <td id="net_total_default" style="text-align:right;" name="net_total_default">#TLFormat(sepet.net_total,basket_total_round_number)#</td>
                            <td id="net_total_wanted" style="text-align:right;" <cfif not ListFindNoCase(display_list, "is_price_total_other_money")>style="display:none"</cfif> name="net_total_wanted">#TLFormat(sepet.net_total*sepet_rate1/sepet_rate2,basket_total_round_number)#</td>
                        </tr>
                    </table>            
                </div>
            </div>    
        </div>    
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" id="basket_money_totals_table" <cfif not ListFindNoCase(display_list, "is_price_total_other_money")>style="display:none"</cfif>>
            <div class="totalBox">
                <div class="totalBoxHead font-grey-mint">
                    <span class="headText"><cf_get_lang dictionary_id='59181.Vergi'></span>
                    <div class="collapse">
                        <span class="icon-minus"></span>
                    </div>
                </div>
                <div class="totalBoxBody">  
                    <table>
            <cfif ListFindNoCase(display_list, "tax")>
                <tr>
                    <td id="td_kdv_list">
                        <font class="txtbold"><cf_get_lang dictionary_id='57639.KDV'></font>
                        <cfloop from="1" to="#arraylen(sepet.kdv_array)#" index="m">
                            <cfset sepet.kdv_array[m][2] = wrk_round(sepet.kdv_array[m][2]*(100-sa_percent)/100,basket_total_round_number)>
                            <b>% #sepet.kdv_array[m][1]#:</b> #TLFormat(sepet.kdv_array[m][2],basket_total_round_number)# 
                        </cfloop>
                    </td>
                </tr>
            <cfelse>
                <tr >
                    <td id="td_kdv_list"><cf_get_lang dictionary_id='57681.Kdv Tanımı Yapılmış'></td>
                </tr>
            </cfif>
            <cfif ListFindNoCase(display_list, "OTV")>
                <tr >
                    <td id="td_otv_list">
                        <font class="txtbold"><cf_get_lang dictionary_id='58021.ÖTV'></font>
                        <cfif StructKeyExists(sepet,'otv_array')> <!--- tum get_basketlere otv eklendikten sonra kaldırılabilir --->
                            <cfloop from="1" to="#arraylen(sepet.otv_array)#" index="nn">
                                <cfset sepet.otv_array[nn][2] = wrk_round(sepet.otv_array[nn][2]*(100-sa_percent)/100,basket_total_round_number)>
                                <b>% #sepet.otv_array[nn][1]#:</b> #TLFormat(sepet.otv_array[nn][2],basket_total_round_number)#  
                            </cfloop>
                        </cfif>
                    </td>
                </tr>
            </cfif>
            <cfif ListFindNoCase(display_list, "otv_discount")>
                <tr height="20">
                    <td id="td_otv_disc_list" class="txtbold">
                        <span><cf_get_lang dictionary_id='62556.ÖTV İndirimi'></span>
                    </td>
                </tr>
            </cfif>
            <cfif ListFindNoCase(display_list, "OIV")>
                <tr height="20">
                    <td id="td_oiv_list" class="txtbold">
                        <span><cf_get_lang dictionary_id='50982.OIV'></span>
                    </td>
                </tr>
            </cfif>
            <cfif ListFindNoCase(display_list, "BSMV")>
                <tr height="20">
                    <td id="td_bsmv_list" class="txtbold">
                        <span><cf_get_lang dictionary_id='50923.BSMV'></span>
                    </td>
                </tr>
            </cfif>
            <cfif not isdefined("sepet.stopaj_rate_id")><cfset sepet.stopaj_rate_id = 0></cfif>
            <cfif not isdefined("sepet.stopaj_yuzde")><cfset sepet.stopaj_yuzde = 0></cfif>
            <cfif not isdefined("sepet.stopaj")><cfset sepet.stopaj = 0></cfif>
            <cfif ListFindNoCase(display_list, "tax") and (listfind('invoice,',fusebox.circuit,',') or listfind("1,2,18,20,33,42,43",attributes.basket_id,","))>
                <tr >
                    <td>
                        <cfif listfind('invoice,',fusebox.circuit,',') or listfind("1,2,18,20,33,42,43",attributes.basket_id,",")>
                            <cfif StructKeyExists(sepet,'tevkifat_box')>
                                <input type="hidden" id="tevkifat_id" name="tevkifat_id" value="#sepet.tevkifat_id#">
                                <input type="checkbox" id="tevkifat_box" name="tevkifat_box" <cfif isdefined("attributes.is_retail")>style="display:none"</cfif> onclick="gizle_goster(tevkifat_oran);gizle_goster(tevkifat_plus);toplam_hesapla(1);" value="" checked>
                                <cfif not isdefined("attributes.is_retail")><cf_get_lang dictionary_id='58022.Tevkfat'></cfif> <!--- perakende satıs faturasında tevkıfat kullanılmaz--->
                                <input type="text" class="box" id="tevkifat_oran" name="tevkifat_oran" value="#TLFormat(sepet.tevkifat_oran,8)#" readonly onblur="toplam_hesapla(1);">
                                <a style=" <cfif isdefined("attributes.is_retail")>display:none;cursor:pointer<cfelse>display:'';cursor:pointer</cfif>" id="tevkifat_plus"onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_tevkifat_rates&field_tevkifat_rate_id=tevkifat_id&field_tevkifat_rate=tevkifat_oran&call_function=toplam_hesapla(0)</cfoutput>','list')"> <i class="fa fa-plus"></i></a>
                            <cfelse>
                                <input type="hidden" id="tevkifat_id" name="tevkifat_id" value="">
                                <input type="checkbox" id="tevkifat_box" name="tevkifat_box" <cfif isdefined("attributes.is_retail")>style="display:none"</cfif> onclick="gizle_goster(tevkifat_oran);gizle_goster(tevkifat_plus);toplam_hesapla(1);" value="">
                                <cfif not isdefined("attributes.is_retail")><cf_get_lang dictionary_id='58022.Tevkfat'></cfif>
                                <input type="text" class="box" id="tevkifat_oran" name="tevkifat_oran" value="" readonly style="display:none;" onblur="toplam_hesapla(1);">
                                <a style="display:none;cursor:pointer" id="tevkifat_plus" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_tevkifat_rates&field_tevkifat_rate_id=tevkifat_id&field_tevkifat_rate=tevkifat_oran&call_function=toplam_hesapla(0)</cfoutput>')"> <i class="fa fa-plus"></i></a>
                            </cfif>
                        </cfif>
                    </td>
                </tr>            
                <cfif listfind('form_copy_bill,form_add_bill,detail_invoice_sale,add_sale_invoice_from_order,form_add_bill_from_ship,form_add_bill_other,detail_invoice_other,form_add_bill_purchase,detail_invoice_purchase,form_copy_bill_purchase,add_purchase_invoice_from_order',fusebox.fuseaction)>
                    <tr >
                        <td class="txtbold">
                            <a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_stoppage_rates&field_stoppage_rate=form_basket.stopaj_yuzde&field_stoppage_rate_id=form_basket.stopaj_rate_id&field_decimal=#basket_total_round_number#&call_function=toplam_hesapla(0)</cfoutput>')"><i class="fa fa-plus" title="Stopaj Oranları"></i></a>
                            <cf_get_lang dictionary_id='57711.Stopaj'>%
                            <input type="hidden" id="stopaj_rate_id" name="stopaj_rate_id" value="#sepet.stopaj_rate_id#">
                            <input id="stopaj_yuzde" name="stopaj_yuzde" type="text" class="box" style="width:75px;" onfocus="if(this.value=='0,00') this.value='';" onblur="{if(!this.value.length) this.value=0; form_basket.stopaj_yuzde.value = filterNumBasket(this.value); toplam_hesapla(0);}" onkeyup="return(FormatCurrency(this,event,0));" value="#TLformat(sepet.stopaj_yuzde,4)#" autocomplete="off">
                            <input type="text" class="box" style="width:75px;" id="stopaj" name="stopaj" value="#TLFormat(sepet.stopaj,basket_total_round_number)#" readonly>
                        </td>
                    </tr>
                    <tr>
                        <td class="txtbold">
                            <a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_exceptions&field_exc_id=exc_id&field_exc_code=exc_code&field_exc_article=exc_article</cfoutput>')"><i class="fa fa-plus"></i></a>
                            <cf_get_lang dictionary_id="60107.İstisnalar">
                            
                                <input type="hidden" id="exc_id" name="exc_id" value="<cfif isdefined('sepet.vat_exception_id') and len(sepet.vat_exception_id)>#sepet.vat_exception_id#</cfif>">
                            <cfif isdefined('sepet.vat_exception_id') and len(sepet.vat_exception_id)>
                                <cfquery name="get_vat_exc" datasource="#dsn#">
                                    SELECT * FROM VAT_EXCEPTION WHERE VAT_EXCEPTION_ID = #sepet.vat_exception_id#
                                </cfquery>
                                <cfset vat_exc_code=get_vat_exc.VAT_EXCEPTION_CODE>
                                <cfset vat_exc_art=get_vat_exc.VAT_EXCEPTION_ARTICLE>
                            </cfif>
                                <input type="text" id="exc_code" name="exc_code" class="box" style="width:75px;" placeholder="<cf_get_lang dictionary_id='58585.Kod'>" value="<cfif isdefined('vat_exc_code') and len(vat_exc_code)>#vat_exc_code#</cfif>">
                                <input type="text" id="exc_article" name="exc_article"  class="box" value="<cfif isdefined('vat_exc_art') and len(vat_exc_art)>#vat_exc_art#</cfif>" autocomplete="off" style="width:75px;" placeholder="<cf_get_lang dictionary_id='60108.Madde'>">
                        </td>
                    </tr>
                </cfif>
                <tr>
                    <td id="tev_kdv_list">
                        <cfif StructKeyExists(sepet,'tevkifat_box')>
                            <font class="txtbold"><cf_get_lang dictionary_id='58022.Tevkifat'>
                                <cfloop from="1" to="#arraylen(sepet.kdv_array)#" index="m">
                                    <b>% #sepet.kdv_array[m][1]#:</b> #TLFormat(sepet.kdv_array[m][2]- (sepet.kdv_array[m][2]*sepet.tevkifat_oran),basket_total_round_number)#
                                </cfloop>
                            </font>
                        </cfif>
                    </td>
                </tr>
                <tr>
                    <td id="bey_kdv_list">
                        <cfif StructKeyExists(sepet,'tevkifat_box')>
                            <font class="txtbold"><cf_get_lang dictionary_id='58024.Beyan Edilen'>
                            <cfloop from="1" to="#arraylen(sepet.kdv_array)#" index="m">
                                % #sepet.kdv_array[m][1]# : #TLFormat(sepet.kdv_array[m][2]*sepet.tevkifat_oran,basket_total_round_number)#
                            </cfloop>
                            </font>
                        </cfif>
                    </td>
                </tr>
            <cfelse>
                <input type="hidden" id="stopaj_rate_id" name="stopaj_rate_id" value="#sepet.stopaj_rate_id#">
                <input type="hidden" id="stopaj_yuzde" name="stopaj_yuzde" value="#sepet.stopaj_yuzde#">
                <input type="hidden" id="stopaj" name="stopaj" value="#sepet.stopaj#">
            </cfif>
        </table>
                    <input type="hidden" id="basket_gross_total" name="basket_gross_total" value="<cfif StructKeyExists(sepet,'total')>#wrk_round(sepet.total,basket_total_round_number)#<cfelse>0</cfif>">
                    <input type="hidden" id="basket_tax_total" name="basket_tax_total" value="<cfif StructKeyExists(sepet,'total_tax')>#wrk_round(sepet.total_tax,basket_total_round_number)#<cfelse>0</cfif>">
                    <input type="hidden" id="basket_otv_total" name="basket_otv_total" value="<cfif StructKeyExists(sepet,'total_otv')>#wrk_round(sepet.total_otv,basket_total_round_number)#<cfelse>0</cfif>">
                    <input type="hidden" id="basket_net_total" name="basket_net_total" value="<cfif StructKeyExists(sepet,'net_total')>#wrk_round(sepet.net_total,basket_total_round_number)#<cfelse>0</cfif>">
                    <input type="hidden" id="basket_discount_total" name="basket_discount_total" value="<cfif StructKeyExists(sepet,'toplam_indirim')>#wrk_round(sepet.toplam_indirim,basket_total_round_number)#</cfif>">
                    <input type="hidden" id="basket_money" name="basket_money" value="<cfif isdefined('str_money_bskt')>#str_money_bskt#</cfif>">
                    <input type="hidden" id="basket_rate1" name="basket_rate1" value="<cfif isdefined('sepet_rate1')>#sepet_rate1#</cfif>">
                    <input type="hidden" id="basket_rate2" name="basket_rate2" value="<cfif isdefined('sepet_rate2')>#sepet_rate2#</cfif>">
                </div>
            </div>    
         </div> 
    </cfoutput>

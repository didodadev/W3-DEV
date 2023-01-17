<cf_xml_page_edit fuseact="ehesap.list_puantaj">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Kişi  Puantaj','64570')#" uidrop="1" module="puantaj_list_layer">
        <cf_flat_list>
            <thead>
                <tr>
                    <!-- sil -->
                    <th style="text-align:center"><i class="fa fa-lg fa-pencil" title="<cf_get_lang dictionary_id='58718.Düzenle'>"></i></th>
                    <th style="text-align:center"><i class="fa fa-lg fa-print" title="Print"></i></th>
                    <!-- sil -->
                    <th nowrap class="header_icn_text"><cf_get_lang dictionary_id ='53109.Sıra No'></th>
                    <th><cf_get_lang dictionary_id='57570.Adı Soyadı'></th>
                    <th width="100"><cf_get_lang dictionary_id ='54265.TC No'></th>
                    <th width="150"><cf_get_lang dictionary_id ='57453.Şube'></th>
                    <th width="150"><cf_get_lang dictionary_id ='58472.Dönem'></th>
                    <th width="40"><cf_get_lang dictionary_id ='53127.Ücret'></th>
                    <th width="30"><cf_get_lang dictionary_id ='57490.Gün'></th>
                    <cfif x_view_total_days eq 1>
                        <th><cf_get_lang dictionary_id='53745.Toplam Gün'></th>
                    </cfif>
                    <th width="90" style="text-align:right;"><cf_get_lang dictionary_id='53244.Toplam Kazanç'></th>
                    <th width="75" style="text-align:right;"><cf_get_lang dictionary_id ='53399.Ek Ödenekler'></th>
                    <th width="90" style="text-align:right;"><cf_get_lang dictionary_id="57492.Toplam"> <cf_get_lang dictionary_id='39992.Kesinti'></th>
                    <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='53255.Net Ücret'></th>
                    <cfif x_view_recorded eq 1>
                        <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>            
                        <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>    
                    </cfif>        
                </tr>
            </thead>
            <tbody>
                <cfscript>
                    t_toplam_kazanc = 0;
                    t_kesinti = 0;
                    t_net_ucret = 0;
                    t_ssk_days = 0;
                    //sgk_toplam_gun = 0;
                    t_ek_odeneks = 0;
                    sayac = 0;
                    id_list = '';
                    ssk_count = 0;
                    t_total_days = 0;
                </cfscript>
                <cfoutput query="get_puantaj_rows">
                    <cfscript>
                        sayac = sayac+1;
                        if(attributes.ssk_statue neq 2)
                        {
                              t_toplam_kazanc = t_toplam_kazanc + (total_salary-VERGI_ISTISNA_SSK-VERGI_ISTISNA_VERGI+VERGI_ISTISNA_AMOUNT_);
                            t_kesinti = t_kesinti + SSK_ISCI_HISSESI + ssdf_isci_hissesi + gelir_vergisi + damga_vergisi + issizlik_isci_hissesi + bes_isci_hissesi;
                            t_ek_odeneks = total_pay_ssk_tax+total_pay_ssk+total_pay_tax+total_pay;
                            t_net_ucret = t_net_ucret + net_ucret;
                        }
                        if(len(ssk_days))
                        t_ssk_days = t_ssk_days + ssk_days;
                        if(len(total_days))
                            t_total_days = t_total_days + total_days;
                    </cfscript>
                    <tr class="color-row">
                        <!-- sil -->
                        <cfset ssk_count = ssk_count+1>
                        <td style="text-align:center">
                            <cfif (get_puantaj_rows.IS_ACCOUNT EQ 0) and (get_puantaj_rows.IS_LOCKED EQ 0) and (get_puantaj_rows.IS_BUDGET EQ 0)>              
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_list_employee_payroll&employee_puantaj_id=#employee_puantaj_id#&employee_id=#employee_id#&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&in_out_id=#in_out_id#','page')"><i class="fa fa-lg fa-pencil" title="<cf_get_lang dictionary_id='58718.Düzenle'>"></i></a>
                            </cfif> 
                        </td>
                        <td style="text-align:center">
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_view_price_compass&style=one&employee_id=#employee_id#&employee_puantaj_id=#employee_puantaj_id#&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&puantaj_type=#attributes.puantaj_type#','page')"><i class="fa fa-lg fa-print" title="Print"></i></a>
                        </td>
                        <!-- sil -->
                        <td>#sayac#</td>
                        <td><a href="#request.self#?fuseaction=ehesap.list_salary&event=upd&employee_id=#employee_id#&in_out_id=#in_out_id#&empName=#UrlEncodedFormat('#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#')#" target="_blank" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
                        <td>#TC_IDENTY_NO#</td>
                        <td>#puantaj_branch_name#-#ssk_office_no#</td>
                        <td>#attributes.sal_mon# - #attributes.sal_year#</td>
                        <td>
                            <cfif salary_type eq 0>
                                <cf_get_lang dictionary_id='53260.Saatlik'>
                            <cfelseif salary_type eq 1>
                                <cf_get_lang dictionary_id='58457.Günlük'>
                            <cfelseif salary_type eq 2>
                                <cf_get_lang dictionary_id='58932.Aylık'>
                            </cfif>
                        </td>
                        <td style="text-align:right;">#ssk_days#</td>
                        <cfif x_view_total_days eq 1>
                            <td style="text-align:right;">#total_days#</td>
                        </cfif>
                        <td style="text-align:right;"><cfif attributes.ssk_statue neq 2>#TLFormat(TOTAL_SALARY-VERGI_ISTISNA_SSK-VERGI_ISTISNA_VERGI+VERGI_ISTISNA_AMOUNT_)#<cfelse>0,00</cfif></td>
                        <td style="text-align:right;"><cfif attributes.ssk_statue neq 2>#TLFormat(total_pay+total_pay_ssk_tax+total_pay_ssk+total_pay_tax)#<cfelse>0,00</cfif></td>
                        <td style="text-align:right;"><cfif attributes.ssk_statue neq 2>#tlformat(SSK_ISCI_HISSESI + ssdf_isci_hissesi + gelir_vergisi + damga_vergisi + issizlik_isci_hissesi + bes_isci_hissesi)#<cfelse>0,00</cfif></td>
                        <td style="text-align:right;"><cfif attributes.ssk_statue neq 2>#TLFormat(net_ucret)#<cfelse>0,00</cfif></td>
                        <cfif x_view_recorded eq 1 and attributes.ssk_statue neq 2>
                            <td>#get_emp_info(update_emp,0,0)#</td>
                            <td>#dateformat(update_date,dateformat_style)# #timeformat(date_add("h",2,update_date),timeformat_style)#</td>
                        </cfif>
                    </tr>
                </cfoutput> 
                <cfoutput>
                    <tr class="total" height="25">
                        <td colspan="<cfif isDefined("attributes.popup_for_files")>5<cfelse>8</cfif>" align="left" class="txtboldblue"><cf_get_lang dictionary_id='53263.Toplamlar'></td>
                        <td class="txtboldblue" style="text-align:right;">#t_ssk_days#</td>
                        <cfif x_view_total_days eq 1>
                            <td class="txtboldblue" style="text-align:right;">&nbsp;#t_total_days#</td>
                        </cfif>
                        <td class="txtboldblue" style="text-align:right;">#TLFormat(t_toplam_kazanc)#</td>
                        <td class="txtboldblue" style="text-align:right;">#TLFormat(t_ek_odeneks)#</td>
                        <td class="txtboldblue" style="text-align:right;">#TLFormat(t_kesinti)#</td>
                        <td class="txtboldblue" style="text-align:right;">#TLFormat(t_net_ucret)#</td>
                        <cfif x_view_recorded eq 1>
                        <td></td>
                        <td></td>
                        </cfif>
                    </tr>
                </cfoutput>
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>
<!---
    File: V16\hr\ehesap\display\view_bes_detail.cfm
    Author: Alper Çitmen <alpercitmen@workcube.com>
    Date: 2022-01-25
    Description: Bes Kesinti Raporu
    History:
    To Do:

--->
<cfset get_title_cmp = createObject('component','V16.hr.cfc.add_rapid_emp')>

<cfquery name="get_puantaj_personal_" dbtype="query">
    SELECT * FROM get_puantaj_personal WHERE BES_ISCI_HISSESI <> 0
</cfquery>

<!--- <cf_box>
    <cfdump var = #get_puantaj_personal_# abort>
</cf_box> --->

<cfif get_puantaj_personal_.recordCount eq 0>
    <cf_box title="Bordro"><cf_get_lang dictionary_id="57484.Kayıt Yok">!</cf_box>
    <cfabort>
<cfelse>
    <cfset title="#Ucase(getLang('','Zorunlu Bireysel Emeklilik Kesinti Raporu',65059))#">
</cfif>

<cfset page_max_row = 10>
<cfset all_total = 0>
<cfset total_page = (round(get_puantaj_personal_.recordCount/page_max_row) LT 1)?1:round(get_puantaj_personal_.recordCount/page_max_row)>

<cf_box title="#title#" closable="0" uidrop="1"> 
    <div class="printThis">
        <style>
            .printableArea{
                display: block;
                position: relative;
                page-break-after: always;
                width: 208mm;
                height: 295mm;
                display: block;
                position: relative;
                margin: 0 auto;
                padding:10mm 5px 5px 5px;
            }    
        
            .printableArea * {
                font-family: Arial,Helvetica Neue,Helvetica,sans-serif; 
                -webkit-box-sizing: border-box;
                -moz-box-sizing: border-box;
                box-sizing: border-box;
                font-size: 12px;
            }
            .printableArea *:before,
            .printableArea *:after {
                -webkit-box-sizing: border-box;
                -moz-box-sizing: border-box;
                box-sizing: border-box;
            }
        
            <!--- SADECE DEVELOPER DA AÇ --->
                /* .printableArea div{border:1px solid red;}
                .printableArea{border: 1px solid #2196F3; } */
            <!--- SADECE DEVELOPER DA AÇ --->   
        
            .bold{font-weight: bold;}
            .underline{text-decoration:underline;}
            .left{text-align:left;}
            .center{text-align:center;}
            .right{text-align:right;}
            .no-border{border:0px;}
        
            table#tablo_ust_baslik {
                width: 100%;
                padding: 10px 200px;
                box-sizing: border-box;
                border-collapse: collapse;
                border: 0px;
            }
        
            table#tablo_ust_baslik th {
            border: 1px solid black;
            padding: 3mm;
            }
            table#tablo_alt_baslik {
                width: 100%;
                padding: 10px 200px;
                box-sizing: border-box;
                border-collapse: collapse;
                border: 0px;
                margin-top:3mm;
            }
        
            table#tablo_alt_baslik td {
            border: 1px solid black;
            padding: 3mm;
            }
        
            #bordrologo{
                width: 100px  !important;
                height: 50px  !important;
                display: block;
                margin-left: auto;
                margin-right: auto;
                width: 50%;
                -webkit-filter: grayscale(100%); /* Safari 6.0 - 9.0 */
                filter: grayscale(100%);
            }
            #paper_title{
                text-align: center;
                vertical-align: middle;
                line-height: 90px;
                font-size: 16pt;
            }
        
            table#tablo_ust_ekbilgi {
                min-width: 110mm;
                margin: 2mm 0mm;
            }
        
            @media print      {
                .printableArea{
                    page-break-after:always;
                }
            }
            table#tablo_ust_baslik td {
                padding: 3mm;
            }
        
        </style>
        <cfloop index="i" from="1" to="#total_page#">
            <cfset page_total = 0>
            <div class="printableArea" id="printBordro">
                <div id="logo">
                    <img src="https://ms.hmb.gov.tr/uploads/2018/12/logo.png" id="bordrologo"/>
                </div>
                <div id = "paper_title">
                    <cfoutput>#title#</cfoutput>
                </div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <cfoutput>
                        <table style="width:100%">
                            <tr>
                                <th><cf_get_lang dictionary_id='64935.Muhasebe Birim Kodu'> - <cf_get_lang dictionary_id='57897.Adı'>: #GET_PUANTAJ_PERSONAL_.BRANCH_POSTCODE# - #GET_PUANTAJ_PERSONAL_.related_company#</th>
                                <th><cf_get_lang dictionary_id='58455.Yıl'> : <cfoutput>#attributes.sal_year#</cfoutput></th>
                            </tr>
                            <tr>
                                <th><cf_get_lang dictionary_id='51485.Kurum Kodu'> - <cf_get_lang dictionary_id='57897.Adı'>: #GET_PUANTAJ_PERSONAL_.BRANCH_ID# - #GET_PUANTAJ_PERSONAL_.related_company#</th>
                                <th><cf_get_lang dictionary_id='58724.Ay'> : <cfoutput>#attributes.sal_mon#</cfoutput></th>
                            </tr>
                            <tr>
                                <th><cf_get_lang dictionary_id='64936.VKN No'> / <cf_get_lang dictionary_id='64937.VKN Adı'> :#GET_PUANTAJ_PERSONAL.BRANCH_TAX_NO# / #GET_PUANTAJ_PERSONAL.branch_fullname#</th>
                                <th><cf_get_lang dictionary_id='64941.Maaş Belge No'> :?</th>
                            </tr>
                            <tr>
                                <th></th>
                                <th><cf_get_lang dictionary_id='64953.'> :?</th>
                            </tr>
                        </table>
                    </cfoutput>
                    <table id="tablo_ust_baslik">
                        <tr>
                            <th><cf_get_lang dictionary_id='31253.Sıra No'></th>
                            <th><cf_get_lang dictionary_id='65057.TCKN'></th>
                            <th><cf_get_lang dictionary_id='63668.Personel No'></th>
                            <th><cf_get_lang dictionary_id='32370.Adı Soyadı'></th>
                            <th><cf_get_lang dictionary_id='65058.Unvanı'></th>
                            <th><cf_get_lang dictionary_id='58485.Şirket Adı'></th>
                            <th><cf_get_lang dictionary_id='32191.Kesinti'><cf_get_lang dictionary_id='58671.Oranı'></th>
                            <th><cf_get_lang dictionary_id='32191.Kesinti'><cf_get_lang dictionary_id='54452.Tutarı'></th>
                        </tr>
                        <cfoutput query="get_puantaj_personal_" startrow="#((i-1)*page_max_row)+1#" maxrows="#page_max_row#">     
                            <cfquery name="get_bes_emp" dbtype="query">
                                SELECT
                                *
                                FROM 
                                    get_puantaj_personal 
                                WHERE 
                                    EMPLOYEE_PUANTAJ_ID = '#EMPLOYEE_PUANTAJ_ID#'
                            </cfquery> 
                            <tr>
                                <td class="center" nowrap="nowrap">#currentrow#</td>
                                <td class="center">#TC_IDENTY_NO#</td>
                                <td class="center" nowrap="nowrap">#EMPLOYEE_NO#</td>
                                <td class="center" nowrap="nowrap">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                                <td class="center">#POSITION_NAME#</td>
                                <td class="center">#COMP_FULL_NAME#</td>
                                <td class="right">#BES_ISCI_CARPAN#</td>
                                <td class="right">#BES_ISCI_HISSESI#</td>
                                <td class="right">
                                    <cfset page_total = page_total + BES_ISCI_HISSESI>
                                    <cfset all_total = all_total + BES_ISCI_HISSESI>
                                    <!--- #tlformat(BES_ISCI_HISSESI)#
                                    #MONEY# --->
                                </td>
                            </tr>
                        </cfoutput>
                        <cfoutput>
                            <tr>
                                <td colspan="7" class="right">
                                    <cf_get_lang dictionary_id='53907.Sayfa Toplamı'>
                                </td>
                                <td class="right">
                                    #tlformat(page_total)# #session.ep.money# 
                                </td>
                            </tr>
                            <tr>
                                <td colspan="7" class="right">
                                    <cf_get_lang dictionary_id='57680.Genel Toplam'>
                                </td>
                                <td class="right">
                                    #tlformat(all_total)# #session.ep.money# 
                                </td>
                            </tr>
                        </cfoutput>
                    </table>
                    <cfoutput>
                        <table id="tablo_alt_baslik">
                            <tr>
                                <td class="no-border">&nbsp;</td>
                                <td><cf_get_lang dictionary_id='64961.Gerçekleştirme Görevlisi'> (<cf_get_lang dictionary_id='64962.Maaş Mutemedi'>)</td>
                                <td><cf_get_lang dictionary_id='64961.Gerçekleştirme Görevlisi'></td>
                                <td><cf_get_lang dictionary_id='62976.Harcama Yetkilisi'></td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id='32370.Adı Soyadı'></td>
                                <td><cfif len(GET_PUANTAJ_PERSONAL.SALARY_SYNDIC_POS_ID)>#get_emp_info(GET_PUANTAJ_PERSONAL.SALARY_SYNDIC_POS_ID,1,0)#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                                <td><cfif len(GET_PUANTAJ_PERSONAL.FULFILLMENT_OFFICER_POS_ID)>#get_emp_info(GET_PUANTAJ_PERSONAL.FULFILLMENT_OFFICER_POS_ID,1,0)#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                                <td><cfif len(GET_PUANTAJ_PERSONAL.EXPENSE_USER_POS_ID)>#get_emp_info(GET_PUANTAJ_PERSONAL.EXPENSE_USER_POS_ID,1,0)#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id='57571.Ünvan'></td>
                                <td><cfif len(GET_PUANTAJ_PERSONAL.SALARY_SYNDIC_POS_ID)>#get_title_cmp.get_titles(TITLE_ID: GET_PUANTAJ_PERSONAL.SALARY_SYNDIC_POS_ID).TITLE#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                                <td><cfif len(GET_PUANTAJ_PERSONAL.FULFILLMENT_OFFICER_POS_ID)>#get_title_cmp.get_titles(TITLE_ID: GET_PUANTAJ_PERSONAL.FULFILLMENT_OFFICER_POS_ID).TITLE#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                                <td><cfif len(GET_PUANTAJ_PERSONAL.EXPENSE_USER_POS_ID)>#get_title_cmp.get_titles(TITLE_ID: GET_PUANTAJ_PERSONAL.EXPENSE_USER_POS_ID).TITLE#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id='64960.Sistem Onay Tarih / Saati'></td>
                                <td>#dateFormat(now(),dateformat_style)# #timeFormat(now(),timeformat_style)#</td>
                                <td>#dateFormat(now(),dateformat_style)# #timeFormat(now(),timeformat_style)#</td>
                                <td>#dateFormat(now(),dateformat_style)# #timeFormat(now(),timeformat_style)#</td>
                            </tr>
                        </table>
                    </cfoutput>
                </div>
                <div style="position: absolute;bottom: 8mm;right: 8mm;"><cfoutput>#i#/#total_page#</cfoutput></div>
            </div>
        </cfloop>
    </div>
</cf_box>
<!--- 
    File: V16\hr\ehesap\display\show_payroll_draft.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2020-11-13
    Description: Taslak Puantaj - JSON dan değerler okunur ekrana yazdılır.
        
    History:
        
    To Do:
 --->
<cfoutput>
<cfsavecontent variable = "title">
    <cf_get_lang dictionary_id='61718.Taslak Bordro'>
</cfsavecontent>
<cf_box title="#title#" resize="0" closable="1" draggable="1" id="payroll_draft">
    <cfset payroll_cmp = createObject("component","V16.hr.ehesap.cfc.payroll_job") />
    <cfset get_payroll_draft = payroll_cmp.PAYROLL_JOB_DRAFT(attributes.employee_payroll_id)>
    <cfset deserialize_draft = deserializeJSON(get_payroll_draft.PAYROLL_DRAFT)>
    <!--- <cfdump var="#deserialize_draft#"> --->
    <cf_flat_list>
        <tbody>
            <cfloop collection=#deserialize_draft# item="key">    
                <tr>
                    <td class="bold" width="150">
                        #replace(key,"_"," ","all")#
                    </td>
                    <td class="text-right">
                        #deserialize_draft[key]#
                    </td>
                </tr>
            </cfloop>
        </tbody>
               <!--- <tr>
                    <td>
                        <label class="col col-3" > MAAŞ TİPİ: </label>
                        <label class="col col-3">#deserialize_draft.SALARY_TYPE#</label>
                        <label class="col col-3" > ÜCRET: </label>
                        <label class="col col-3">#deserialize_draft.SALARY#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > TOPLAM BRÜT KAZANÇ: </label>
                        <label class="col col-3">#deserialize_draft.TOTAL_SALARY_#</label>
                        <label class="col col-3" > NET UCRET: </label>
                        <label class="col col-3">#deserialize_draft.NET_UCRET#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > SGK MATRAH: </label>
                        <label class="col col-3">#deserialize_draft.SSK_MATRAH#</label>
                        <label class="col col-3" > SGK DEVİR: </label>
                        <label class="col col-3">#deserialize_draft.ONCEKI_AYDAN_DUSULECEK#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > SSK VERGİ DAHİL ÖDENEKLER: </label>
                        <label class="col col-3">#deserialize_draft.TOTAL_PAY_SSK_TAX#</label>
                        <label class="col col-3" > SGK MATRAH MAAŞ: </label>
                        <label class="col col-3">#deserialize_draft.SSK_MATRAH_SALARY#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > SGK DURUMU: </label>
                        <label class="col col-3">#deserialize_draft.SSK_STATUTE#</label>
                        <label class="col col-3" > SGK NUMARASI: </label>
                        <label class="col col-3">#deserialize_draft.SOCIALSECURITY_NO#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > SGK ÇALIŞMA SAATLERİ: </label>
                        <label class="col col-3">#deserialize_draft.SSK_WORK_HOURS#</label>
                        <label class="col col-3" > AVANS: </label>
                        <label class="col col-3">#deserialize_draft.AVANS#</label>
                    </td>
                </tr>     
                <tr>
                    <td>
                        <label class="col col-3" > ÜCRETLİ İZİN SAATİ: </label>
                        <label class="col col-3">#deserialize_draft.IZIN_PAID_COUNT#</label>
                        <label class="col col-3" > 45 SAATİ AŞAN FAZLA MESAİ: </label>
                        <label class="col col-3">#deserialize_draft.EXT_TOTAL_HOURS_3#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > YILLIK İZİN ÜCRETİ: </label>
                        <label class="col col-3">#deserialize_draft.YILLIK_IZIN_AMOUNT#</label>
                        <label class="col col-3" > HAFTASONU FAZLA MESAİSİ: </label>
                        <label class="col col-3">#deserialize_draft.EXT_TOTAL_HOURS_1#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > İZİNLİ HAFTASONU: </label>
                        <label class="col col-3">#deserialize_draft.OFFDAYS_SUNDAY_COUNT#</label>
                        <label class="col col-3" > RESMİ TATİL FAZLA MESAİSİ: </label>
                        <label class="col col-3">#deserialize_draft.EXT_TOTAL_HOURS_2#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > ÜCRETLİ İZİN GÜNÜ: </label>
                        <label class="col col-3">#deserialize_draft.IZIN_PAID#</label>
                        <label class="col col-3" > NORMAL GÜN FAZLA MESAİSİ: </label>
                        <label class="col col-3">#deserialize_draft.EXT_TOTAL_HOURS_0#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > IZIN: </label>
                        <label class="col col-3">#deserialize_draft.IZIN#</label>
                        <label class="col col-3" > İZİN SAATİ: </label>
                        <label class="col col-3">#deserialize_draft.IZIN_COUNT#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > SSK GÜN: </label>
                        <label class="col col-3"><cfif isdefined("deserialize_draft.SSK_DAYS")>#deserialize_draft.SSK_DAYS#<cfelse>0</cfif></label>
                        <label class="col col-3" > OFFDAYS COUNT: </label>
                        <label class="col col-3">#deserialize_draft.OFFDAYS_COUNT#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > ÜCRETLİ HAFTASONU GÜNÜ: </label>
                        <label class="col col-3">#deserialize_draft.PAID_IZINLI_SUNDAY_COUNT#</label>
                        <label class="col col-3" > İZİNLİ SAYILAN PAZAR GÜNÜ: </label>
                        <label class="col col-3">#deserialize_draft.IZINLI_SUNDAY_COUNT#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > PAZAR SAYISI: </label>
                        <label class="col col-3">#deserialize_draft.SUNDAY_COUNT#</label>
                        <label class="col col-3" > KUMULATIF GELIR VERGISI MATRAHI: </label>
                        <label class="col col-3">#deserialize_draft.KUMULATIF_GELIR_VERGISI_MATRAHI#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > GELİR VERGİSİ MATRAHI IZIN: </label>
                        <label class="col col-3">#deserialize_draft.GVM_IZIN#</label>
                        <label class="col col-3" > GELİR VERGİSİ MATRAHI İHBAR: </label>
                        <label class="col col-3">#deserialize_draft.GVM_IHBAR#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > VERGİ İSTİSNASI: </label>
                        <label class="col col-3">#deserialize_draft.VERGI_ISTISNA#</label>
                        <label class="col col-3" > VERGİ İADESİ: </label>
                        <label class="col col-3">#deserialize_draft.VERGI_IADESI#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > DAMGA VERGİSİ MATRAH: </label>
                        <label class="col col-3">#deserialize_draft.DAMGA_VERGISI_MATRAH#</label>
                        <label class="col col-3" > GELIR VERGISI MATRAH: </label>
                        <label class="col col-3">#deserialize_draft.GELIR_VERGISI_MATRAH#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > GELIR VERGISI: </label>
                        <label class="col col-3">#deserialize_draft.GELIR_VERGISI#</label>
                        <label class="col col-3" > DAMGA VERGISI: </label>
                        <label class="col col-3">#deserialize_draft.DAMGA_VERGISI#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > İŞSİZLİK İŞVEREN HİSSESİ: </label>
                        <label class="col col-3">#deserialize_draft.ISSIZLIK_ISVEREN_HISSESI#</label>
                        <label class="col col-3" > ISSIZLIK ISCI HISSESI: </label>
                        <label class="col col-3">#deserialize_draft.ISSIZLIK_ISCI_HISSESI#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > EK KAZANÇ: </label>
                        <label class="col col-3">#deserialize_draft.EXT_SALARY#</label>
                        <label class="col col-3" > TOTAL ODEME: </label>
                        <label class="col col-3">#deserialize_draft.TOTAL_PAY#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > SGK MATRAH KULLANILAN: </label>
                        <label class="col col-3">#deserialize_draft.SSK_MATRAH_KULLANILAN#</label>
                        <label class="col col-3" > SGK ISVEREN CARPAN: </label>
                        <label class="col col-3">#deserialize_draft.SSK_ISVEREN_CARPAN#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > SGK İŞVEREN HİSSESİ: </label>
                        <label class="col col-3">#deserialize_draft.SSK_ISVEREN_HISSESI#</label>
                        <label class="col col-3" > SGK İŞÇİ HİSSESİ: </label>
                        <label class="col col-3" >#deserialize_draft.SSK_ISCI_HISSESI#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > KIDEM İŞÇİ PAYI: </label>
                        <label class="col col-3">#deserialize_draft.KIDEM_ISCI_PAYI#</label>
                        <label class="col col-3" > SGDF İŞÇİ PAYI: </label>
                        <label class="col col-3">#deserialize_draft.SSDF_ISCI_HISSESI#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > OZEL KESINTI 2: </label>
                        <label class="col col-3">#deserialize_draft.OZEL_KESINTI_2#</label>
                        <label class="col col-3" > OZEL KESINTI: </label>
                        <label class="col col-3">#deserialize_draft.OZEL_KESINTI#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > KIDEM ÜCRETİ: </label>
                        <label class="col col-3">#deserialize_draft.KIDEM_AMOUNT#</label>
                        <label class="col col-3" > İHBAR ÜCRETİ: </label>
                        <label class="col col-3">#deserialize_draft.IHBAR_AMOUNT#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > SSK DAHİL VERGİ MUAF ÖDENEKLER: </label>
                        <label class="col col-3">#deserialize_draft.TOTAL_PAY_SSK#</label>
                        <label class="col col-3" > VERGİ DAHİL SSK MUAF ÖDENEKLER: </label>
                        <label class="col col-3">#deserialize_draft.TOTAL_PAY_TAX#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > KIDEM İŞVEREN PAYI: </label>
                        <label class="col col-3">#deserialize_draft.KIDEM_ISVEREN_PAYI#</label>
                        <label class="col col-3" > VERGİ İADE DAMGA VERGİSİ: </label>
                        <label class="col col-3">#deserialize_draft.VERGI_IADE_DAMGA_VERGISI#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > SSDF ISVEREN HISSESI: </label>
                        <label class="col col-3">#deserialize_draft.SSDF_ISVEREN_HISSESI#</label>
                        <label class="col col-3" > GÖÇMEN İNDİRİMİ: </label>
                        <label class="col col-3">#deserialize_draft.GOCMEN_INDIRIMI#</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="col col-3" > SENDİKA İNDİRİMİ: </label>
                        <label class="col col-3">#deserialize_draft.SENDIKA_INDIRIMI#</label>
                        <label class="col col-3" > SAKATLIK INDIRIMI: </label>
                        <label class="col col-3">#deserialize_draft.SAKATLIK_INDIRIMI#</label>
                    </td>
                </tr> --->
        </cf_flat_list>
</cf_box>
</cfoutput>


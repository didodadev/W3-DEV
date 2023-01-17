<!---
    File: WTO\Print\Preview\izin_mutabakat.cfm
    Author: Esma R. UYSAL<esmauysal@workcube.com>
    Date: 06/09/2021
    Description:
        İzin mutabakatı standart print şablonu
--->
<cfif isDefined("woc_list")> <!--- Sayfa woc'a gönderildiyse, woc_list içinde tüm id'ler geliyor MK 14.12.2021 --->
	<cfset attributes.action_id = woc_list>
<cfelse> <!--- sayfa woc'a gönderilmediyse action_id ile işlem yapıyor. --->
	<cfset attributes.action_id = attributes.action_id>
</cfif>
<cfset  cmp_eoc = createObject("component","V16.hr.cfc.get_employees_offtime_contract")>
<cfset cmp_eoc.dsn = dsn>
<cfset get_employees_offtime_contract = cmp_eoc.get_employees_offtime_contract(
    employees_offtime_contract_id: attributes.action_id      
)>
<style>
    .print_title{font-size:16px;}
    table{border-collapse:collapse;border-spacing:0;}
    table tr td{padding:5px 3px;}
    .print_border thead tr th{border:1px solid!important;padding:3px;color:##000}
    .print_border tbody tr td{border:1px solid!important;padding:3px;color:##000}
    .row_border{border-bottom:1px solid}
    table tr td img{max-width:50px;}
  </style>
<cfif get_employees_offtime_contract.Recordcount>
    <cfoutput query="get_employees_offtime_contract">       
        <table style="width:210mm">
            <tr>
                <td>
                    <tr class="row_border">
                        <td class="print-head">
                            <table style="width:100%;">
                                <tr>
                                    <td class="print_title"><b><cf_get_lang dictionary_id='56647.İzin Mutabakatları'></b></td>
                                </tr> 
                            </table>
                        </td>
                    </tr>
                    <table width="100%">
                        <tr>
                            <td>
                                <table>
                                    <tr>
                                        <td style="width:150px;"><b><cf_get_lang dictionary_id='57570.Ad Soyad'></b></td>
                                        <td>: #employee_name# #employee_surname#</td>
                                    </tr>
                                    <tr>
                                        <td style="width:150px;"><b><cf_get_lang dictionary_id='57453.Şube'></b></td>
                                        <td>: #BRANCH_NAME#</td>
                                    </tr>
                                    <tr>
                                        <td style="width:150px;"><b><cf_get_lang dictionary_id='57572.Departman'></b></td>
                                        <td>: #DEPARTMENT_HEAD#</td>
                                    </tr>
                                    <tr>
                                        <td style="width:150px;"><b><cf_get_lang dictionary_id='57880.Belge No'></b></td>
                                        <td>: #SYSTEM_PAPER_NO#</td>
                                    </tr>
                                    <tr>
                                        <td style="width:150px;"><b><cf_get_lang dictionary_id='58859.Süreç'></b></td>
                                        <td>: #CONTRACT_STAGE#</td>
                                    </tr>
                                    <tr>
                                        <td style="width:150px;"><b><cf_get_lang dictionary_id='58472.Dönem'></b></td>
                                        <td>: #SAL_YEAR#</td>
                                    </tr>
                                    <tr>
                                        <td style="width:150px;"><b><cf_get_lang dictionary_id='56651.Mutabakat Tarihi'></b></td>
                                        <td>: #dateTimeFormat(OFFTIME_DATE_1,"DD-MM-YYYY HH:mm:ss")#</td>
                                    </tr>
                                    <tr>
                                        <td style="width:150px;"><b><cf_get_lang dictionary_id='55804.Onay Durumu'></b></td>
                                        <td>: 
                                            <cfif IS_APPROVE eq 0>
                                                -
                                            <cfelseif IS_APPROVE eq 1>
                                                <cf_get_lang dictionary_id ="58699.Onaylandı">
                                                <cfelseif IS_APPROVE eq 0> 
                                                <cf_get_lang dictionary_id ="54645.Red Edildi">
                                            </cfif>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <table width="100%"  class="print_border">
                        <thead>
                            <tr>
                                <th style="width:150px;"><b><cf_get_lang dictionary_id='63445.Önceki Dönem Kullanılmayan İzin Günü'></b></th>
                                <th style="width:150px;"><b><cf_get_lang dictionary_id="59770.Önceki Dönem Kullanılan İzin Günü"></b></th>
                                <th style="width:150px;"><b><cf_get_lang dictionary_id="59771.İlgili Dönem Hakedilen İzin Günü"></b></th>
                                <th style="width:150px;"><b><cf_get_lang dictionary_id="59772.İlgili Dönem Kullanılan İzin Günü"></b></th>
                                <th style="width:150px;"><b><cf_get_lang dictionary_id="59773.Toplam Kalan"></b></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>#tlformat(EX_SAL_YEAR_REMAINDER_DAY)#</td>
                                <td>#tlformat(EX_SAL_YEAR_OFTIME_DAY)#</td>
                                <td>#tlformat(SAL_YEAR_REMAINDER_DAY)#</td>
                                <td>#tlformat(SAL_YEAR_OFTIME_DAY)#</td>
                                <td>#tlformat(EX_SAL_YEAR_REMAINDER_DAY + SAL_YEAR_REMAINDER_DAY - SAL_YEAR_OFTIME_DAY)#</td>
                            </tr>
                        </tbody>
                                
                    </table>
                </td>
            </tr>
        </table>
        <cfif currentrow neq recordcount>
            <div style="page-break-after: always"></div>
        </cfif>           
    </cfoutput>
<cfelse>
    <cf_get_lang dictionary_id='63731.Önizleme yapılacak belgeyi seçiniz'>!
</cfif>

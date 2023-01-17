<!--- 
    Developer'a not : 
    Bu dosya include edildiğinde eğer güncelleme, mail gönderme butonlarının gelmesi isteniliyorsa is_control = 1 olarak tanımlanmalıdır.
    Esma R. Uysal
--->
<cf_box title="#getLang('hr',1562,'İzin mutabakatı')#" closable="0">
    <cf_flat_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id='58455.Yıl'></th>
                <th width="80"><cf_get_lang dictionary_id='56651.Mutabakat Tarihi'></th>
                <th width="150"><cf_get_lang dictionary_id='63726.Önceki Dönemden Kullanılmayan İzin Gün Sayısı'></td>
                <th width="150"><cf_get_lang dictionary_id='63727.Önceki Dönemde Kullanılan İzin Gün Sayısı'></td>
                <th width="150"><cf_get_lang dictionary_id='63728.İlgili Dönem Hak Edilen İzin Gün Sayısı'></td>
                <th width="150"><cf_get_lang dictionary_id='63729.İlgili Dönemda Kullanılan İzin Gün Sayısı'></td>
                <th width="150"><cf_get_lang dictionary_id='63730.Toplam Kalan İzin Gün Sayısı'></td>
                <cfif isdefined("is_control") and is_control eq 1>
                    <!-- sil --> <th width="50"><i class="fa fa-thumbs-o-up"></i></td>
                    <th width="50"><i class="fa fa-paper-plane"></i></td>			
                    <th width="15"><a href="<cfoutput>#request.self#?fuseaction=ehesap.hr_offtime_approve&event=add&employee_id=#attributes.employee_id#</cfoutput>" target="_blank" ><img src="/images/plus_list.gif" border="0" title="<cf_get_lang_main no='170.Ekle'>"></a></th><!-- sil -->
                </cfif>
            </tr>
        </thead>
        <tbody>
            <cfquery name="get_contract" datasource="#dsn#">
                SELECT * FROM EMPLOYEES_OFFTIME_CONTRACT WHERE EMPLOYEE_ID = #attributes.employee_id# ORDER BY SAL_YEAR DESC
            </cfquery>        
            <cfif get_contract.recordcount>
                <cfoutput query="get_contract">
                <tr>
                    <td>#sal_year#</td>
                    <td style="text-align:center;"><cfif len(RECORD_DATE)>#dateformat(RECORD_DATE,dateformat_style)#</cfif></td>
                    <td style="text-align:center;">#EX_SAL_YEAR_REMAINDER_DAY#</td>
                    <td style="text-align:center;">#EX_SAL_YEAR_OFTIME_DAY#</td>
                    <td style="text-align:center;">#SAL_YEAR_REMAINDER_DAY#</td>
                    <td style="text-align:center;">#SAL_YEAR_OFTIME_DAY#</td>
                    <td style="text-align:RİGHT;">#tlformat(EX_SAL_YEAR_REMAINDER_DAY+(SAL_YEAR_REMAINDER_DAY-SAL_YEAR_OFTIME_DAY),1)#</td>
                    <cfif isdefined("is_control") and is_control eq 1>
                        <td>
                            <cfif get_contract.IS_APPROVE eq 1>
                                <i class="fa fa-thumbs-o-up font-green-jungle"></i>
                            <cfelse>
                                <i class="fa fa-thumbs-o-down font-red"></i>
                            </cfif>
                        </td>
                        <!-- sil -->
                        <td>
                            <cfif get_contract.IS_MAIL eq 1>
                                <i class="fa fa-paper-plane font-green-jungle"></i>
                            <cfelse>
                                <i class="fa fa-paper-plane font-red"></i>
                            </cfif>
                        </td>	
                        <td><a href="#request.self#?fuseaction=ehesap.hr_offtime_approve&event=upd&EMPLOYEES_OFFTIME_CONTRACT_ID=#EMPLOYEES_OFFTIME_CONTRACT_ID#" target="_blank"><img src="/images/update_list.gif" border="0"></a></td><!-- sil -->
                    </cfif>
                </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_flat_list>
</cf_box>

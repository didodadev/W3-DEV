
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.sal_mon" default="#month(now())#">
<cfparam name="attributes.process_type" default="">

<cfobject name="kdv_beyan" component="V16.report.cfc.kdv_beyan">
<cfset query_kdv_kesintisi_yapilan_saticilar = kdv_beyan.get_kdv_kesintisi_yapilan_saticilar( sal_mon: attributes.sal_mon, sal_year: attributes.sal_year )>
<cfset query_tam_tevkifatli_alislar = kdv_beyan.get_tevkifatli_alislar( is_tamtevkifat: 1, sal_mon: attributes.sal_mon, sal_year: attributes.sal_year )>
<cfset query_kismi_tevkifatli_alislar = kdv_beyan.get_tevkifatli_alislar( is_tamtevkifat: 0, sal_mon: attributes.sal_mon, sal_year: attributes.sal_year )>

<cfif isDefined("attributes.wrk_search_button") and attributes.wrk_search_button eq "Excel">
    <cfset GetPageContext().getCFOutput().clear()>

    <cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=report.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    
    <table border="1">
            <thead>
                <tr>
                    <th colspan="6" align="center"><cf_get_lang dictionary_id='60769.KDV Kesintisi Yapılan Satıcılar'></th>
                </tr>    
                <tr>
                    <th><cf_get_lang dictionary_id='57571.Ünvan'></th>
                    <th><cf_get_lang dictionary_id='57571.Ünvan'>2</th>
                    <th><cf_get_lang dictionary_id='55649.TC. Kimlik No'></th>
                    <th><cf_get_lang dictionary_id='57752.Vergi No(VKN)'></th>
                    <th><cf_get_lang dictionary_id='60714.Matrah'></th>
                    <th><cf_get_lang dictionary_id='60770.Kesinti Tevkif Edilen KDV'></th>
                    <th><cf_get_lang dictionary_id='54855.İşlem Sayısı'></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="query_kdv_kesintisi_yapilan_saticilar">
                    <tr>
                        <td>#UNVAN1#</td>
                        <td>#UNVAN2#</td>
                        <td>#TCKN#</td> 
                        <td>#VERGINO#</td>
                        <td>#tlformat(TOTAL, 2)#</td>
                        <td>#tlformat(TOTALTEVKIFAT, 2)#</td>
                        <td>#ADET#</td>
                    </tr>
                </cfoutput>
                <cfoutput>
                <tr>
                    <td colspan="4" align="right"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
                    <td>#tlformat( arraySum( valueArray( query_kdv_kesintisi_yapilan_saticilar, "TOTAL" ) ), 2 )#</td>
                    <td>#tlformat( arraySum( valueArray( query_kdv_kesintisi_yapilan_saticilar, "TOTALTEVKIFAT" ) ), 2 )#</td>
                    <td>#arraySum( valueArray( query_kdv_kesintisi_yapilan_saticilar, "ADET" ) )#</td>
                </tr>
                </cfoutput>
            <tbody>
        </table>
        <table>
            <tr><td> </td></tr>
            <tr><td> </td></tr>
        </table>
        <table border="1">
            <thead>
                <tr>
                    <th colspan="5" align="center"><cf_get_lang dictionary_id='60771.Tam Tevkifatlı İşlemler'></th>
                </tr>
                <tr>
                    <th><cf_get_lang dictionary_id='50161.İşlem Türü'></th>
                    <th><cf_get_lang dictionary_id='60714.Matrah'></th>
                    <th><cf_get_lang dictionary_id='42533.KDV Oranı'></th>
                    <th><cf_get_lang dictionary_id='57391.Tevkifat Oranı'></th>
                    <th><cf_get_lang dictionary_id='53332.Vergi'></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="query_tam_tevkifatli_alislar">
                <tr>
                    <td>#TEVKIFAT_CODE# - #TEVKIFAT_CODE_NAME#</td>
                    <td>#tlformat(NETTOTAL, 2)#</td>
                    <td>#TAX#</td>
                    <td>#(len(TEVKIFAT_ORAN) ? TEVKIFAT_ORAN : 0 ) * 100#</td>
                    <td>#tlformat(TAXTOTAL, 2)#</td>
                </tr>
                </cfoutput>
                <cfoutput>
                <tr>
                    <td><cf_get_lang dictionary_id='57492.Toplam'>:</td>
                    <td>#tlformat( arraySum( valueArray( query_tam_tevkifatli_alislar, "NETTOTAL" ) ), 2 )#</td>
                    <td colspan="2"></td>
                    <td>#tlformat( arraySum( valueArray( query_tam_tevkifatli_alislar, "TAXTOTAL" ) ), 2 )#</td>
                </tr>
                </cfoutput>
            </tbody>
        </table>
        <table>
            <tr><td> </td></tr>
            <tr><td> </td></tr>
        </table>
        <table border="1">
            <thead>
                <tr>
                    <th colspan="5" align="center"><cf_get_lang dictionary_id='60772.Kısmi Tevkifatlı İşlemler'></th>
                </tr>
                <tr>
                    <th><cf_get_lang dictionary_id='50161.İşlem Türü'></th>
                    <th><cf_get_lang dictionary_id='60714.Matrah'></th>
                    <th><cf_get_lang dictionary_id='42533.KDV Oranı'></th>
                    <th><cf_get_lang dictionary_id='57391.Tevkifat Oranı'></th>
                    <th><cf_get_lang dictionary_id='33304.Vergi'></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="query_kismi_tevkifatli_alislar">
                <tr>
                    <td>#TEVKIFAT_CODE# - #TEVKIFAT_CODE_NAME#</td>
                    <td>#tlformat(NETTOTAL, 2)#</td>
                    <td>#TAX#</td>
                    <td>#(len(TEVKIFAT_ORAN) ? TEVKIFAT_ORAN : 0 ) * 100#</td>
                    <td>#tlformat(TAXTOTAL, 2)#</td>
                </tr>
                </cfoutput>
                <cfoutput>
                <tr>
                    <td style="text-align: right;"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
                    <td>#tlformat( arraySum( valueArray( query_kismi_tevkifatli_alislar, "NETTOTAL" ) ), 2 )#</td>
                    <td colspan="2"></td>
                    <td>#tlformat( arraySum( valueArray( query_kismi_tevkifatli_alislar, "TAXTOTAL" ) ), 2 )#</td>
                </tr>
                </cfoutput>
            </tbody>
        </table>
    <cfabort>
</cfif>

<!--- islem tipleri --->
<div class="col col-12">
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='57639.KDV'>-2 <cf_get_lang dictionary_id='60773.Beyan Hazı±rlama Raporu'></cfsavecontent>
        <cf_box title="#title#">
            <cfform name="rapor" action="#request.self#?fuseaction=report.kdv2_report" method="post">
                <div class="ui-form-list flex-list">
                    <div class="form-group">
                        <select name="sal_mon" id="sal_mon">
                            <cfloop from="1" to="12" index="i">
                                <cfoutput>
                                    <option value="#i#"<cfif attributes.sal_mon eq i> selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                </cfoutput>
                            </cfloop>
                        </select>
                    </div>
                    <div class="form-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58455.Yıl'></cfsavecontent>
                        <input type="text" name="sal_year" id="sal_year" value="<cfoutput>#attributes.sal_year#</cfoutput>" style="width:50px;" required="yes" validate="integer" range="1900,2100" maxlength="4" message="<cfoutput>#message#</cfoutput>">
                    </div>
                    <div class="form-group">
                        <cf_wrk_report_search_button button_type="4" is_excel="0" is_excelbuton="0" is_wordbuton="0" is_pdfbuton="0" is_mailbuton="0" is_printbuton="0">
                    </div>
                    <div class="form-group">
                        <input type="submit" name="wrk_search_button" value="Excel" onclick="return setAjax(this)">
                        <script>
                            function setAjax(elm) {
                                $(elm).after('<input type="hidden" name="isajax" value="1">');
                                $(elm).after('<input type="hidden" name="isAjaxPage" value="1">');
                                return true;
                            }
                        </script>
                    </div>
                </div>
            </cfform>
            
            <cf_seperator id="spr1" header="#getLang('','KDV Kesintisi Yapılan Satıcılar',60769)#">
            <div class="ui-scroll" id="spr1">
                <cf_grid_list>
                    <thead>    
                        <tr>
                            <th><cf_get_lang dictionary_id='57571.Ünvan'></th>
                            <th><cf_get_lang dictionary_id='58025.TCKN'></th>
                            <th><cf_get_lang dictionary_id='57752.Vergi no(VKN)'></th>
                            <th><cf_get_lang dictionary_id='60714.Matrah'></th>
                            <th><cf_get_lang dictionary_id='60770.Kesinti Tevkif Edilen KDV'></th>
                            <th><cf_get_lang dictionary_id='54855.İşlem Sayısı'></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="query_kdv_kesintisi_yapilan_saticilar">
                            <tr>
                                <td>#FIRMA#</td>
                                <td>#TCKN#</td>
                                <td>#VERGINO#</td>
                                <td><input type="text" value="#tlformat(TOTAL, 2)#" style="text-align: right; width: 100%;" readonly></td>
                                <td><input type="text" value="#tlformat(TOTALTEVKIFAT, 2)#" style="text-align: right; width: 100%;" readonly></td>
                                <td><input type="text" value="#ADET#" style="text-align: right; width: 100%;" readonly></td>
                            </tr>
                        </cfoutput>
                        <cfoutput>
                        <tr>
                            <td colspan="3" style="text-align: right;"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
                            <td><input type="text" value="#tlformat( arraySum( valueArray( query_kdv_kesintisi_yapilan_saticilar, "TOTAL" ) ), 2 )#" style="text-align: right; width: 100%;" readonly></td>
                            <td><input type="text" value="#tlformat( arraySum( valueArray( query_kdv_kesintisi_yapilan_saticilar, "TOTALTEVKIFAT" ) ), 2 )#" style="text-align: right; width: 100%;" readonly></td>
                            <td><input type="text" value="#arraySum( valueArray( query_kdv_kesintisi_yapilan_saticilar, "ADET" ) )#" style="text-align: right; width: 100%;" readonly></td>
                        </tr>
                        </cfoutput>
                    <tbody>
                </cf_grid_list>
            </div>
            
            <cfsavecontent variable="title"><cf_get_lang dictionary_id='60771.Tam Tevkifatlı İşlemler'></cfsavecontent>
            <cf_seperator id="spr2" header="#title#">
            <div class="ui-scroll" id="spr2">
                <cf_grid_list>
                    <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='50161.İşlem Türü'></th>
                            <th><cf_get_lang dictionary_id='60714.Matrah'></th>
                            <th><cf_get_lang dictionary_id='42533.KDV Oranı'></th>
                            <th><cf_get_lang dictionary_id='57391.Tevkifat Oranı'></th>
                            <th><cf_get_lang dictionary_id='53332.Vergi'></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="query_tam_tevkifatli_alislar">
                        <tr>
                            <td>#TEVKIFAT_CODE# - #TEVKIFAT_CODE_NAME#</td>
                            <td><input type="text" value="#tlformat(NETTOTAL, 2)#" style="text-align: right; width: 100%;" readonly></td>
                            <td><input type="text" value="#TAX#" style="text-align: right; width: 100%;" readonly></td>
                            <td><input type="text" value="#(len(TEVKIFAT_ORAN) ? TEVKIFAT_ORAN : 0 ) * 100#" style="text-align: right; width: 100%;" readonly></td>
                            <td><input type="text" value="#tlformat(TAXTOTAL, 2)#" style="text-align: right; width: 100%;" readonly></td>
                        </tr>
                        </cfoutput>
                        <cfoutput>
                        <tr>
                            <td style="text-align: right;"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
                            <td><input type="text" value="#tlformat( arraySum( valueArray( query_tam_tevkifatli_alislar, "NETTOTAL" ) ), 2 )#" style="text-align: right; width: 100%;" readonly></td>
                            <td colspan="2"></td>
                            <td><input type="text" value="#tlformat( arraySum( valueArray( query_tam_tevkifatli_alislar, "TAXTOTAL" ) ), 2 )#" style="text-align: right; width: 100%;" readonly></td>
                        </tr>
                        </cfoutput>
                    </tbody>
                </cf_grid_list>
            </div>
        
            <cfsavecontent variable="header"><cf_get_lang dictionary_id='60772.Kısmi Tevkifatlı İşlemler'></cfsavecontent>
            <cf_seperator id="spr3" header="#header#">
            <div class="ui-scroll" id="spr3">
                <cf_grid_list>
                    <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='50161.İşlem Türü'></th>
                            <th><cf_get_lang dictionary_id='60714.Matrah'></th>
                            <th><cf_get_lang dictionary_id='42533.KDV Oranı'></th>
                            <th><cf_get_lang dictionary_id='57391.Tevkifat Oranı'></th>
                            <th><cf_get_lang dictionary_id='53332.Vergi'></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="query_kismi_tevkifatli_alislar">
                        <tr>
                            <td>#TEVKIFAT_CODE# - #TEVKIFAT_CODE_NAME#</td>
                            <td><input type="text" value="#tlformat(NETTOTAL, 2)#" style="text-align: right; width: 100%;" readonly></td>
                            <td><input type="text" value="#TAX#" style="text-align: right; width: 100%;" readonly></td>
                            <td><input type="text" value="#(len(TEVKIFAT_ORAN) ? TEVKIFAT_ORAN : 0 ) * 100#" style="text-align: right; width: 100%;" readonly></td>
                            <td><input type="text" value="#tlformat(TAXTOTAL, 2)#" style="text-align: right; width: 100%;" readonly></td>
                        </tr>
                        </cfoutput>
                        <cfoutput>
                        <tr>
                            <td style="text-align: right;"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
                            <td><input type="text" value="#tlformat( arraySum( valueArray( query_kismi_tevkifatli_alislar, "NETTOTAL" ) ), 2 )#" style="text-align: right; width: 100%;" readonly></td>
                            <td colspan="2"></td>
                            <td><input type="text" value="#tlformat( arraySum( valueArray( query_kismi_tevkifatli_alislar, "TAXTOTAL" ) ), 2 )#" style="text-align: right; width: 100%;" readonly></td>
                        </tr>
                        </cfoutput>
                    </tbody>
                </cf_grid_list>
            </div>
        
        </cf_box>
</div>
<!--- Rapor : Aylık Ayrıntılı KDV Raporu
	Açıklama : Yıl içindeki o döneme kadar olan ayların Ay bazında Aylık Ayrıntılı KDV Raporu
	Liste Alanları : KDV Oranı, Matrah Hesaplanan Kdv, Hesaplanan Kdv, Matrah Alış İade, Alış İade Kdv,  
					   Matrah İndirilecek KDV, İndirilecek KDV, Matrah Satış İade, Satış İade Kdv, Bakiye  --->

<!--- KDV AYRINTILI RAPOR
	Bakiye: (Hesaplanan+aliş iade)-(İndirilicek + Satış iade)	
	Gider odeme her zaman inidirilecek kdv olarak yazilir.
	
	Gider odeme CAT_ID = 36
	Alim Faturalari : 51,59,60,63,65
	Satış Faturalari : 50,52,53,56,58,66
	Alım İade Faturaları : 62
	Satış İade Faturaları : 54,55
	
	! ! ! 
	arzu ya : hani banka gider ödeme, ayrıca kodlara bakalım ve eğer burada değil ama başka yerlerde gerekirse 
	invoice tablosundaki PURCHASE_SALES doğru set ediliyorsa işlem tipi kontrolüne bile gerek olmadan bazı değerler bulunabilir
	HS20040713
	! ! !
	
	Eksiklikler:
	-> Muhasebe doneminin yili icin her ay icin ayri ayri getirecek.
	
    Duzenleme : FBS 20110616 Tevkifat hesaplamalari dikkate alinacak sekilde duzenlendi
    
    48: Verilen kur farkı faturası
    50: Verilen vade farkı faturası
--->
<cf_xml_page_edit fuseact ="report.kdv_report_with_month">
<cfparam name="attributes.module_id_control" default="20">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.sal_mon" default="#month(now())#">
<cfparam name="attributes.process_type" default="">

<cffunction name="_reduceflatten">
    <cfargument name="acc" default="0">
    <cfargument name="val">
    <cfreturn acc + val>
</cffunction>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <!--- islem tipleri --->
    <cf_box title="#getlang('','KDV-1 Beyan Hazırlama Raporu',39635)#">
    <cfform name="rapor" action="#request.self#?fuseaction=report.kdv_report_with_month" method="post">
        <cf_box_search more="0">
            <div class="form-group">
                <select name="sal_mon" id="sal_mon">
                    <cfloop from="1" to="12" index="i">
                        <cfoutput>
                            <option value="#i#"<cfif attributes.sal_mon eq i> selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                        </cfoutput>
                    </cfloop>
                </select>
            </div>
            <div class="form-group">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58455.Yıl'></cfsavecontent>
                <input type="text" name="sal_year" id="sal_year" value="<cfoutput>#attributes.sal_year#</cfoutput>" style="width:50px;" required="yes" validate="integer" range="1900,2100" maxlength="4" message="<cfoutput>#message#</cfoutput>">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4" is_excel="0" is_excelbuton="0" is_wordbuton="0" is_pdfbuton="0" is_mailbuton="0" is_printbuton="0">
            </div>
        </cf_box_search>
    </cfform>
    <cfif isDefined("attributes.form_submited")>
        <cfset attributeToStruct(attributes, "beyanname")>
    <cfelse>
        <cfset attributes.beyanname = { bolum1: { tevkifatsiz: { rows: {}, total: {} } } }>
    </cfif>
    <cfobject name="kdv_beyan" component="V16.report.cfc.kdv_beyan">
    <cfform name="body" method="post">
        <input type="hidden" name="form_submited" value="1">
        <input type="hidden" name="sal_year" value="<cfoutput>#attributes.sal_year#</cfoutput>">
        <input type="hidden" name="sal_mon" value="<cfoutput>#attributes.sal_mon#</cfoutput>">
        <cf_tab defaultOpen="entegre_islemler" divId="entegre_islemler,manuel_muhasebe" divLang="#getlang('','Entegre İşlemler',883)#;#getlang('','Manuel Muhasebe Kayıtları',884)#">
            <div id="unique_entegre_islemler" class="ui-info-text uniqueBox">
                <!--- prepare --->
                <cfif not isDefined("attributes.beyanname.bolum1.tevkifatsiz.rows")>
                    <cfset attributes.beyanname.bolum1.tevkifatsiz.rows = {}>
                </cfif>
                <cfif not isDefined("attributes.form_submited")>
                    <cfset query_tevkifatsiz_islemler = kdv_beyan.get_tevkifatsiz_islemler( sal_mon: attributes.sal_mon, sal_year: attributes.sal_year )>
                    <cfquery name="query_summary_tevkifatsiz_islemler" dbtype="query">
                        SELECT TAX, SUM(TAXTOTAL) AS TAXTOTAL, SUM(NETTOTAL) AS NETTOTAL FROM query_tevkifatsiz_islemler
                        GROUP BY TAX
                    </cfquery>
                    <cfloop query="query_summary_tevkifatsiz_islemler">
                        <cfset attributes.beyanname.bolum1.tevkifatsiz.rows["row"&query_summary_tevkifatsiz_islemler.currentRow] = {
                            tax: query_summary_tevkifatsiz_islemler.TAX,
                            taxtotal: tlformat(query_summary_tevkifatsiz_islemler.TAXTOTAL, 2),
                            nettotal: tlformat(query_summary_tevkifatsiz_islemler.NETTOTAL, 2)
                        }>
                    </cfloop>
                    <cfquery name="query_total_tevkifatsiz_islemler" dbtype="query">
                        SELECT SUM(TAXTOTAL) AS TAXTOTAL, SUM(NETTOTAL) AS NETTOTAL FROM query_tevkifatsiz_islemler
                    </cfquery>
                    <cfif query_total_tevkifatsiz_islemler.recordCount>
                        <cfset attributes.beyanname.bolum1.tevkifatsiz.total = { 
                            taxtotal: tlformat(query_total_tevkifatsiz_islemler.TAXTOTAL, 2), 
                            nettotal: tlformat(query_total_tevkifatsiz_islemler.NETTOTAL, 2) 
                        }>
                    <cfelse>
                        <cfset attributes.beyanname.bolum1.tevkifatsiz.total = { 
                            taxtotal: tlformat(0, 2), 
                            nettotal: tlformat(0, 2) 
                        }>
                    </cfif>
                <cfelse>
                    <cfif isDefined("attributes.beyanname.bolum1.tevkifatsiz") and StructCount(attributes.beyanname.bolum1.tevkifatsiz.rows) gt 0 and  structKeyExists(attributes.beyanname.bolum1.tevkifatsiz, "rows")>
                        <cffunction name="_tevkifatsizrowtaxtotal">
                            <cfargument name="item">
                            <cfreturn filternum(attributes.beyanname.bolum1.tevkifatsiz.rows[arguments.item].taxtotal, 2)>
                        </cffunction>
                        <cffunction name="_tevkifatsizrownettotal">
                            <cfargument name="item">
                            <cfreturn filternum(attributes.beyanname.bolum1.tevkifatsiz.rows[arguments.item].taxtotal, 2)>
                        </cffunction>
                        
                        <cfset attributes.beyanname.bolum1.tevkifatsiz.total = { 
                            taxtotal: tlformat( arrayReduce( arrayMap( structKeyArray(attributes.beyanname.bolum1.tevkifatsiz.rows), _tevkifatsizrowtaxtotal ), _reduceflatten ), 2), 
                            nettotal: tlformat( arrayReduce( arrayMap( structKeyArray(attributes.beyanname.bolum1.tevkifatsiz.rows), _tevkifatsizrownettotal ), _reduceflatten ), 2) 
                        }>
                    <cfelse>
                        <cfset attributes.beyanname.bolum1.tevkifatsiz.total = { 
                            taxtotal: tlformat( 0, 2), 
                            nettotal: tlformat( 0, 2) 
                        }>
                    </cfif>
                </cfif>
                <!--- end prepare --->
                <cfsavecontent variable="header"><cf_get_lang dictionary_id='60714.Matrah'></cfsavecontent>
                <cf_seperator id="spr1" header="#header#">
                <div id="spr1">
                    <cf_grid_list>
                        <thead>
                            <tr>
                                <th colspan="3"><cf_get_lang dictionary_id='60713.Tevkifat Uygulanmayan İşlemler'></th>
                            </tr>
                        <thead>
                            <tr>
                                <th style="width: 33%"><cf_get_lang dictionary_id='60714.Matrah'></th>
                                <th style="width: 33%"><cf_get_lang dictionary_id='42533.KDV Oranı'></th>
                                <th style="width: 33%"><cf_get_lang dictionary_id='53332.Vergi'></th>
                            </tr>
                        </thead>
                        <tbody>
                            
                            <cfoutput>
                                <cfset currentRow = 1>
                                <cfloop collection="#attributes.beyanname.bolum1.tevkifatsiz.rows#" item="key">
                                <tr>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" style="text-align: right;" name="beyanname.bolum1.tevkifatsiz.rows.row#currentRow#.nettotal" value="#attributes.beyanname.bolum1.tevkifatsiz.rows[key].nettotal#">
                                        </div>
                                    </td>
                                    <td style="text-align: right;"><input type="hidden" name="beyanname.bolum1.tevkifatsiz.rows.row#currentRow#.tax" value="#attributes.beyanname.bolum1.tevkifatsiz.rows[key].tax#">#attributes.beyanname.bolum1.tevkifatsiz.rows[key].tax#</td>
                                    <td> 
                                        <div class="form-group">
                                            <input type="text" style="text-align: right;" name="beyanname.bolum1.tevkifatsiz.rows.row#currentRow#.taxtotal" value="#attributes.beyanname.bolum1.tevkifatsiz.rows[key].taxtotal#">
                                        </div>
                                    </td>
                                </tr>
                                <cfset currentRow++>
                                </cfloop>
                            
                                <tr>
                                    <td colspan="2" style="text-align: right;"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
                                    <td style="text-align: right;">#attributes.beyanname.bolum1.tevkifatsiz.total.TAXTOTAL#</td>
                                </tr>
                            </cfoutput>

                        </tbody>
                    </cf_grid_list>
                    <!--- prepare --->
                    <cfif not isDefined("attributes.beyanname.bolum1.tevkifatli.rows")>
                        <cfset attributes.beyanname.bolum1.tevkifatli.rows = {}>
                    </cfif>
                    <cfif not isDefined("attributes.form_submited")>
                        <cfset query_tevkifatli_islemler = kdv_beyan.get_tevkifatli_islemler( sal_mon: attributes.sal_mon, sal_year: attributes.sal_year )>
                        <cfquery name="query_summary_tevkifatli_islemler" dbtype="query">
                            SELECT TAX, TEVKIFAT_ORAN, TEVKIFAT_CODE, TEVKIFAT_CODE_NAME, SUM(TAXTOTAL) AS TAXTOTAL, SUM(NETTOTAL) AS NETTOTAL FROM query_tevkifatli_islemler
                            GROUP BY TAX, TEVKIFAT_ORAN, TEVKIFAT_CODE, TEVKIFAT_CODE_NAME
                        </cfquery>
                        <cfoutput query="query_summary_tevkifatli_islemler">
                            <cfset attributes.beyanname.bolum1.tevkifatli.rows["row"&currentRow] = {
                                tax: TAX,
                                tevkifat_oran: TEVKIFAT_ORAN,
                                tevkifat_code: TEVKIFAT_CODE,
                                tevkifat_code_name: TEVKIFAT_CODE_NAME,
                                taxtotal: tlformat(TAXTOTAL, 2),
                                nettotal: tlformat(NETTOTAL, 2)
                            }>
                        </cfoutput>
                        <cfquery name="query_total_tevkifatli_islemler" dbtype="query">
                            SELECT SUM(TAXTOTAL) AS TAXTOTAL, SUM(NETTOTAL) AS NETTOTAL FROM query_tevkifatli_islemler
                        </cfquery>
                        <cfif query_total_tevkifatli_islemler.recordCount>
                            <cfset attributes.beyanname.bolum1.tevkifatli.total = {
                                taxtotal: tlformat(query_total_tevkifatli_islemler.TAXTOTAL, 2),
                                nettotal: tlformat(query_total_tevkifatli_islemler.NETTOTAL, 2)
                            }>
                        <cfelse>
                            <cfset attributes.beyanname.bolum1.tevkifatli.total = {
                                taxtotal: tlformat(0, 2),
                                nettotal: tlformat(0, 2)
                            }>
                        </cfif>
                    <cfelse>
                        <cfif isDefined("attributes.beyanname.bolum1.tevkifatli") and StructCount(attributes.beyanname.bolum1.tevkifatli.rows) gt 0 and structKeyExists(attributes.beyanname.bolum1.tevkifatli, "rows")>
                            <cffunction name="_tevkifatlirowtaxtotal">
                                <cfargument name="itm">
                                <cfreturn filternum(attributes.beyanname.bolum1.tevkifatli.rows[itm].taxtotal, 2)>
                            </cffunction>
                            <cffunction name="_tevkifatlirownettotal">
                                <cfargument name="itm">
                                <cfreturn filternum(attributes.beyanname.bolum1.tevkifatli.rows[itm].nettotal, 2)>
                            </cffunction>
                            <cfset attributes.beyanname.bolum1.tevkifatli.total = {
                                taxtotal: tlformat( arrayReduce( arrayMap( structKeyArray(attributes.beyanname.bolum1.tevkifatli.rows), _tevkifatlirowtaxtotal ), _reduceflatten ), 2),
                                nettotal: tlformat( arrayReduce( arrayMap( structKeyArray(attributes.beyanname.bolum1.tevkifatli.rows), _tevkifatlirownettotal ), _reduceflatten ), 2)
                            }>
                        <cfelse>
                            <cfset attributes.beyanname.bolum1.tevkifatli.total = {
                                taxtotal: tlformat( 0, 2),
                                nettotal: tlformat( 0, 2)
                            }>
                        </cfif>
                    </cfif>
                    <!--- end prepare --->
                    <cf_grid_list>
                        <thead>
                            <tr>
                                <th colspan="5"><cf_get_lang dictionary_id='60715.Tevkifat Uygulanan İşlemler'></th>
                            </tr>
                        </thead>
                        <thead>
                            <tr>
                                <th><cf_get_lang dictionary_id='50161.İşlem Türü'></th>
                                <th><cf_get_lang dictionary_id='60714.Matrah'></th>
                                <th><cf_get_lang dictionary_id='42533.KDV Oranı'></th>
                                <th><cf_get_lang dictionary_id='57391.Tevkifat Oranı'></th>
                                <th><cf_get_lang dictionary_id='33304.Vergi'></th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput>
                                <cfset currentRow = 1>
                                <cfloop collection="#attributes.beyanname.bolum1.tevkifatli.rows#" item="key">
                                <tr>
                                    <td>
                                        <input type="hidden" name="beyanname.bolum1.tevkifatli.rows.row#currentRow#.tevkifat_code" value="#attributes.beyanname.bolum1.tevkifatli.rows["row"&currentRow].tevkifat_code#">
                                        <input type="hidden" name="beyanname.bolum1.tevkifatli.rows.row#currentRow#.tevkifat_code_name" value="#attributes.beyanname.bolum1.tevkifatli.rows["row"&currentRow].tevkifat_code_name#">
                                        #attributes.beyanname.bolum1.tevkifatli.rows["row"&currentRow].tevkifat_code# - #attributes.beyanname.bolum1.tevkifatli.rows["row"&currentRow].tevkifat_code_name#</td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" name="beyanname.bolum1.tevkifatli.rows.row#currentRow#.nettotal" style="text-align: right;" value="#attributes.beyanname.bolum1.tevkifatli.rows["row"&currentRow].nettotal#">
                                        </div>
                                    </td>
                                    <td style="text-align: right;"><input type="hidden" name="beyanname.bolum1.tevkifatli.rows.row#currentRow#.tax" value="#attributes.beyanname.bolum1.tevkifatli.rows["row"&currentRow].tax#"> #attributes.beyanname.bolum1.tevkifatli.rows["row"&currentRow].tax#</td>
                                    <td style="text-align: right;"><input type="hidden" name="beyanname.bolum1.tevkifatli.rows.row#currentRow#.tevkifat_oran" value="#attributes.beyanname.bolum1.tevkifatli.rows["row"&currentRow].tevkifat_oran#"> #attributes.beyanname.bolum1.tevkifatli.rows["row"&currentRow].tevkifat_oran*10#/10</td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" style="text-align: right;" name="beyanname.bolum1.tevkifatli.rows.row#currentRow#.taxtotal" value="#attributes.beyanname.bolum1.tevkifatli.rows["row"&currentRow].taxtotal#">
                                        <div>
                                    </td>
                                </tr>
                                <cfset currentRow++>
                                </cfloop>
                                <tr>
                                    <td colspan="4" style="text-align: right;"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
                                    <td style="text-align: right;">#attributes.beyanname.bolum1.tevkifatli.total.taxtotal#</td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    </cf_grid_list>
            
                    <!--- prepare --->
                    <cfif not isDefined("attributes.form_submited")>
                        <cfset query_bavul_ticareti = kdv_beyan.get_bavul_ticareti( sal_mon: attributes.sal_mon, sal_year: attributes.sal_year )>
                        <cfquery name="query_summary_bavul_ticareti" dbtype="query">
                            SELECT SUM(TAXTOTAL) AS TAXTOTAL, SUM(NETTOTAL) AS NETTOTAL FROM query_bavul_ticareti
                        </cfquery>
                        <cfif query_summary_bavul_ticareti.recordCount>
                            <cfset attributes.beyanname.bolum1.diger.bavul_ticareti = {
                                nettotal: tlformat(query_summary_bavul_ticareti.NETTOTAL, 2),
                                taxtotal: tlformat(query_summary_bavul_ticareti.TAXTOTAL, 2)
                            }>
                        <cfelse>
                            <cfset attributes.beyanname.bolum1.diger.bavul_ticareti = {
                                nettotal: tlformat(0, 2),
                                taxtotal: tlformat(0, 2)
                            }>
                        </cfif>

                        <cfset query_sabit_kiymet_satisi = kdv_beyan.get_sabit_kiymet_satisi( sal_mon: attributes.sal_mon, sal_year: attributes.sal_year )>
                        <cfquery name="query_summary_sabit_kiymet_satisi" dbtype="query">
                            SELECT SUM(TAXTOTAL) AS TAXTOTAL, SUM(NETTOTAL) AS NETTOTAL FROM query_sabit_kiymet_satisi
                        </cfquery>
                        <cfif query_summary_sabit_kiymet_satisi.recordCount>
                            <cfset attributes.beyanname.bolum1.diger.sabit_kiymet_satisi = {
                                nettotal: tlformat(query_summary_sabit_kiymet_satisi.NETTOTAL, 2),
                                taxtotal: tlformat(query_summary_sabit_kiymet_satisi.TAXTOTAL, 2)
                            }>
                        <cfelse>
                            <cfset attributes.beyanname.bolum1.diger.sabit_kiymet_satisi = {
                                nettotal: tlformat(0, 2),
                                taxtotal: tlformat(0, 2)
                            }>
                        </cfif>

                        <cfset query_ilave_edilecek_kdv = kdv_beyan.get_ilave_edilecek_kdv( sal_mon: attributes.sal_mon, sal_year: attributes.sal_year )>
                        <cfquery name="query_summary_ilave_edilecek_kdv" dbtype="query">
                            SELECT SUM(TAXTOTAL) AS TAXTOTAL, SUM(NETTOTAL) AS NETTOTAL FROM query_ilave_edilecek_kdv
                        </cfquery>
                        <cfif query_summary_ilave_edilecek_kdv.recordCount>
                            <cfset attributes.beyanname.bolum1.diger.ilave_edilecek_kdv = {
                                nettotal: tlformat(query_summary_ilave_edilecek_kdv.NETTOTAL, 2),
                                taxtotal: tlformat(query_summary_ilave_edilecek_kdv.TAXTOTAL, 2)
                            }>
                        <cfelse>
                            <cfset attributes.beyanname.bolum1.diger.ilave_edilecek_kdv = {
                                nettotal: tlformat(0, 2),
                                taxtotal: tlformat(0, 2)
                            }>
                        </cfif>

                        <cfset attributes.beyanname.bolum1.diger.vuk322_borclara_ait_kdv = {
                            nettotal: tlformat(0, 2),
                            taxtotal: tlformat(0, 2)
                        }>

                        <cfset attributes.beyanname.bolum1.diger.diger = {
                            nettotal: tlformat(0, 2),
                            taxtotal: tlformat(0, 2)
                        }>
                    </cfif>
                    <!--- end prepare --->
                    <cf_grid_list>
                        <thead>
                            <tr>
                                <th colspan="4"><cf_get_lang dictionary_id='55990.Diğer İşlemler'></th>
                            </tr>
                        </thead>
                        <thead>
                            <tr>

                                <th><cf_get_lang dictionary_id='58585.Kod'></th>
                                <th><cf_get_lang dictionary_id='55990.İşlem Türü'></th>
                                <th><cf_get_lang dictionary_id='60714.Matrah'></th>
                                <th><cf_get_lang dictionary_id='54859.KDV Tutar'></th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput>
                                <tr>
                                    <td>501</td>
                                    <td><cf_get_lang dictionary_id='60727.Türkiye de İkamet Etmeyenlere KDV Hesaplanarak Yapılan Satışlar'></td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" name="beyanname.bolum1.diger.bavul_ticareti.nettotal" style="text-align: right;" value="#attributes.beyanname.bolum1.diger.bavul_ticareti.nettotal#">
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" name="beyanname.bolum1.diger.bavul_ticareti.taxtotal" style="text-align: right;" value="#attributes.beyanname.bolum1.diger.bavul_ticareti.taxtotal#">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>503</td>
                                    <td><cf_get_lang dictionary_id='60728.Amortismana Tabi Sabit Kıymet Satışları'></td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" name="beyanname.bolum1.diger.sabit_kiymet_satisi.nettotal" style="text-align: right;" value="#attributes.beyanname.bolum1.diger.sabit_kiymet_satisi.nettotal#">
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" name="beyanname.bolum1.diger.sabit_kiymet_satisi.taxtotal" style="text-align: right;" value="#attributes.beyanname.bolum1.diger.sabit_kiymet_satisi.taxtotal#">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>504</td>
                                    <td><cf_get_lang dictionary_id='60729.Alınan Malların İadesi'></td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" name="beyanname.bolum1.diger.ilave_edilecek_kdv.nettotal" style="text-align: right;" value="#attributes.beyanname.bolum1.diger.ilave_edilecek_kdv.nettotal#">
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" name="beyanname.bolum1.diger.ilave_edilecek_kdv.taxtotal" style="text-align: right;" value="#attributes.beyanname.bolum1.diger.ilave_edilecek_kdv.taxtotal#">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>505</td>
                                    <td><cf_get_lang dictionary_id='60730.VUK 322 Kapsamına Giren Borçlara Ait KDV'></td>
                                    <td> 
                                        <div class="form-group">
                                            <input type="text" name="beyanname.bolum1.diger.vuk322_borclara_ait_kdv.nettotal" style="text-align: right;" value="#attributes.beyanname.bolum1.diger.vuk322_borclara_ait_kdv.nettotal#">
                                        </div>
                                    </td>
                                    <td> 
                                        <div class="form-group">
                                            <input type="text" name="beyanname.bolum1.diger.vuk322_borclara_ait_kdv.taxtotal" style="text-align: right;" value="#attributes.beyanname.bolum1.diger.vuk322_borclara_ait_kdv.taxtotal#">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>550</td>
                                    <td><cf_get_lang dictionary_id='58156.Diğer'></td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" name="beyanname.bolum1.diger.diger.nettotal" style="text-align: right;" value="#attributes.beyanname.bolum1.diger.diger.nettotal#">
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" name="beyanname.bolum1.diger.diger.taxtotal" style="text-align: right;" value="#attributes.beyanname.bolum1.diger.diger.taxtotal#">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3" style="text-align: right;"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
                                    <td style="text-align: right;"><cfoutput>#tlformat( filternum(attributes.beyanname.bolum1.diger.bavul_ticareti.taxtotal,2) + filternum(attributes.beyanname.bolum1.diger.sabit_kiymet_satisi.taxtotal,2) + filternum(attributes.beyanname.bolum1.diger.ilave_edilecek_kdv.taxtotal,2) + filternum(attributes.beyanname.bolum1.diger.vuk322_borclara_ait_kdv.taxtotal,2) + filternum(attributes.beyanname.bolum1.diger.diger.taxtotal,2) , 2)#</cfoutput></td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    </cf_grid_list>
                    <cf_grid_list>
                        <thead>
                            <tr>
                                <th colspan="2"><cf_get_lang dictionary_id='41564.TOPLAMLAR'></th>
                            </tr>
                        </thead>
                        <tbody>
                            <!--- prepare --->
                            <cfset beyanname_bolum1_nettotal = filternum(attributes.beyanname.bolum1.diger.bavul_ticareti.nettotal, 2) +  
                            filternum(attributes.beyanname.bolum1.diger.sabit_kiymet_satisi.nettotal, 2) + 
                            filternum(attributes.beyanname.bolum1.diger.ilave_edilecek_kdv.nettotal, 2) + 
                            filternum(attributes.beyanname.bolum1.tevkifatsiz.total.nettotal, 2) + 
                            filternum(attributes.beyanname.bolum1.tevkifatli.total.nettotal, 2)>
                            <!--- end prepare --->
                            <tr>
                                <td><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='60714.Matrah'></td>
                                <td>
                                    <div class="form-group"><input style="text-align: right;" type="text" value="<cfoutput>#tlformat(beyanname_bolum1_nettotal, 2)#</cfoutput>" readonly></div>
                                </td>
                            </tr>
                            <!--- prepare --->
                            <cfset beyanname_bolum1_taxtotal = filternum(attributes.beyanname.bolum1.diger.bavul_ticareti.taxtotal, 2) +
                                filternum(attributes.beyanname.bolum1.diger.sabit_kiymet_satisi.taxtotal, 2) +
                                filternum(attributes.beyanname.bolum1.diger.ilave_edilecek_kdv.taxtotal, 2) +
                                filternum(attributes.beyanname.bolum1.tevkifatsiz.total.taxtotal, 2) +
                                filternum(attributes.beyanname.bolum1.tevkifatli.total.taxtotal, 2)>
                            <!--- end prepare --->
                            <tr>
                                <td><cf_get_lang dictionary_id='34137.Hesaplanan'> <cf_get_lang dictionary_id='57639.KDV'></td>
                                <td>
                                    <div class="form-group">
                                        <input style="text-align: right;" type="text" value="<cfoutput>#tlformat(beyanname_bolum1_taxtotal, 2)#</cfoutput>" readonly>
                                    </div>
                                </td>
                            </tr>
                            <!--- prepare --->
                            <cfif not isDefined("attributes.form_submited")>
                                <cfset attributes.beyanname.bolum1.diger.indirim_konusu_kdv = tlformat(0, 2)>
                            </cfif>
                            <!--- end prepare --->
                            <tr>
                                <td><cf_get_lang dictionary_id="882.Daha Önce İndirim Konusu KDV'nin İlavesi"></td>
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="beyanname.bolum1.diger.indirim_konusu_kdv" value="<cfoutput>#attributes.beyanname.bolum1.diger.indirim_konusu_kdv#</cfoutput>" style="text-align: right;">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id='51317.Toplam KDV'></td>
                                <td style="text-align: right;">
                                    <cfoutput>#tlformat( beyanname_bolum1_taxtotal + filternum(attributes.beyanname.bolum1.diger.indirim_konusu_kdv, 2), 2)#</cfoutput>
                                </td>
                            </tr>
                        </tbody>
                    </cf_grid_list>
                </div>
                <cf_seperator id="spr2" header="#getlang('','İndirilecek İşlemler',885)#">
                <div id="spr2">
                    <cf_grid_list>
                        <thead>
                            <tr>
                                <th><cf_get_lang dictionary_id='58585.KOD'></th>
                                <th><cf_get_lang dictionary_id='58560.İndirim'> <cf_get_lang dictionary_id='58651.Türü'></th>
                                <th><cf_get_lang dictionary_id='53332.Vergi'></th>
                            </tr>
                        </thead>
                        <tbody>
                            <!--- prepare --->
                            <cfif not isDefined("attributes.form_submited")>
                                <cfset attributes.beyanname.bolum2.onceki_donemden_devreden_indirilecek = {
                                    taxtotal: tlformat(0, 2),
                                    nettotal: tlformat(0, 2)
                                }>
                            </cfif>
                            <!--- end prepare --->
                            <cfoutput>
                                <tr>
                                    <td>101</td>
                                    <td><cf_get_lang dictionary_id='60731.Önceki Dönemden Devreden İndirilecek'></td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" style="text-align: right;" name="beyanname.bolum2.onceki_donemden_devreden_indirilecek.taxtotal" value="#attributes.beyanname.bolum2.onceki_donemden_devreden_indirilecek.taxtotal#">
                                        </div>
                                        <input type="hidden" name="beyanname.bolum2.onceki_donemden_devreden_indirilecek.nettotal" value="#attributes.beyanname.bolum2.onceki_donemden_devreden_indirilecek.nettotal#">
                                    </td>
                                </tr>
                            </cfoutput>
                            <!--- prepare --->
                            <cfif not isDefined("attributes.form_submited")>
                                <cfset query_indirilecek_islemler = kdv_beyan.get_indirilecek_islemler( sal_mon: attributes.sal_mon, sal_year: attributes.sal_year, codes: "55,54,690,691" )>
                                <cfquery name="query_summary_indirilecek_islemler" dbtype="query">
                                    SELECT SUM(TAXTOTAL) AS TAXTOTAL, SUM(NETTOTAL) AS NETTOTAL FROM query_indirilecek_islemler
                                </cfquery>
                                <cfif query_summary_indirilecek_islemler.recordCount>
                                    <cfset attributes.beyanname.bolum2.satistan_iadeler = {
                                        taxtotal: tlformat(query_summary_indirilecek_islemler.TAXTOTAL, 2),
                                        nettotal: tlformat(query_summary_indirilecek_islemler.NETTOTAL, 2)
                                    }>
                                <cfelse>
                                    <cfset attributes.beyanname.bolum2.satistan_iadeler = {
                                        taxtotal: tlformat(0, 2),
                                        nettotal: tlformat(0, 2)
                                    }>
                                </cfif>
                            </cfif>
                            <!--- end prepare --->
                            <cfoutput>
                                <tr>
                                    <td>103</td>
                                    <td><cf_get_lang dictionary_id='58314.Satıştan İadeler'></td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" style="text-align: right;" name="beyanname.bolum2.satistan_iadeler.taxtotal" value="#attributes.beyanname.bolum2.satistan_iadeler.taxtotal#">
                                            <input type="hidden" name="beyanname.bolum2.satistan_iadeler.nettotal" value="#attributes.beyanname.bolum2.satistan_iadeler.nettotal#">
                                        </div>
                                    </td>
                                </tr>
                            </cfoutput>
                            <!--- prepare --->
                            <cfif not isDefined("attributes.form_submited")>
                                <cfset attributes.beyanname.bolum2.turkiyede_ikamet_etmeyenlere_iade = {
                                    taxtotal: tlformat(0, 2),
                                    nettotal: tlformat(0, 2)
                                }>
                            </cfif>
                            <!--- end prepare --->
                            <cfoutput>
                                <tr>
                                    <td>104</td>
                                    <td><cf_get_lang dictionary_id='60732.Türkiyede İkamet Etmeyenlere İade'></td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" style="text-align: right;" name="beyanname.bolum2.turkiyede_ikamet_etmeyenlere_iade.taxtotal" value="#attributes.beyanname.bolum2.turkiyede_ikamet_etmeyenlere_iade.taxtotal#">
                                            <input type="hidden" name="beyanname.bolum2.turkiyede_ikamet_etmeyenlere_iade.nettotal" value="#attributes.beyanname.bolum2.turkiyede_ikamet_etmeyenlere_iade.nettotal#">
                                        </div>
                                    </td>
                                </tr>
                            </cfoutput>
                            <!--- prepare --->
                            <cfif not isDefined("attributes.form_submited")>
                                <cfset attributes.beyanname.bolum2.indirime_tabi_iadesi_gerceklesmeyen_kdv = {
                                    taxtotal: tlformat(0, 2),
                                    nettotal: tlformat(0, 2)
                                }>
                            </cfif>
                            <!--- end prepare --->
                            <cfoutput>
                                <tr>
                                    <td>106</td>
                                    <td><cf_get_lang dictionary_id='60733.İndirimli Orana Tabi İşlemlerle İlgili Yıl İçinde Mahsuben İadesi Gerçekleşmeyen KDV'></td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" style="text-align: right;" name="beyanname.bolum2.indirime_tabi_iadesi_gerceklesmeyen_kdv.taxtotal" value="#attributes.beyanname.bolum2.indirime_tabi_iadesi_gerceklesmeyen_kdv.taxtotal#">
                                            <input type="hidden" name="beyanname.bolum2.indirime_tabi_iadesi_gerceklesmeyen_kdv.nettotal" value="#attributes.beyanname.bolum2.indirime_tabi_iadesi_gerceklesmeyen_kdv.nettotal#">
                                        </div>
                                    </td>
                                </tr>
                            </cfoutput>
                            <!--- prepare --->
                            <cfif not isDefined("attributes.form_submited")>
                                <cfset attributes.beyanname.bolum2.madde11_1c_17 = {
                                    taxtotal: tlformat(0, 2),
                                    nettotal: tlformat(0, 2)
                                }>
                            </cfif>
                            <!--- end prepare --->
                            <cfoutput>
                                <tr>
                                    <td>107</td>
                                    <td>11/1-C ve Geçici 17.Madde</td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" style="text-align: right;" name="beyanname.bolum2.madde11_1c_17.taxtotal" value="#attributes.beyanname.bolum2.madde11_1c_17.taxtotal#">
                                            <input type="hidden" name="beyanname.bolum2.madde11_1c_17.nettotal" value="#attributes.beyanname.bolum2.madde11_1c_17.nettotal#">
                                        </div>
                                    </td>
                                </tr>
                            </cfoutput>
                            <!--- prepare --->
                            <cfif not isDefined("attributes.form_submited")>
                                <cfset query_indirilecek_islemler = kdv_beyan.get_indirilecek_islemler( sal_mon: attributes.sal_mon, sal_year: attributes.sal_year, codes: "51,59,60,63,64,120,122,1201,1202,1203,592,601,296" )>
                                <cfquery name="query_summary_indirilecek_islemler" dbtype="query">
                                    SELECT SUM(TAXTOTAL) AS TAXTOTAL, SUM(NETTOTAL) AS NETTOTAL FROM query_indirilecek_islemler
                                </cfquery>
                                <cfif query_summary_indirilecek_islemler.recordCount>
                                    <cfset attributes.beyanname.bolum2.yurtici_alimlara_iliskin_kdv = {
                                        taxtotal: tlformat(query_summary_indirilecek_islemler.TAXTOTAL, 2),
                                        nettotal: tlformat(query_summary_indirilecek_islemler.NETTOTAL, 2)
                                    }>
                                <cfelse>
                                    <cfset attributes.beyanname.bolum2.yurtici_alimlara_iliskin_kdv = {
                                        taxtotal: tlformat(0, 2),
                                        nettotal: tlformat(0, 2)
                                    }>
                                </cfif>
                            </cfif>
                            <!--- end prepare --->
                            <cfoutput>
                                <tr>
                                    <td>108</td>
                                    <td><cf_get_lang dictionary_id='60736.Yurtiçi Alımlara İlişkin KDV'></td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" style="text-align: right;" name="beyanname.bolum2.yurtici_alimlara_iliskin_kdv.taxtotal" value="#attributes.beyanname.bolum2.yurtici_alimlara_iliskin_kdv.taxtotal#">
                                            <input type="hidden" name="beyanname.bolum2.yurtici_alimlara_iliskin_kdv.nettotal" value="#attributes.beyanname.bolum2.yurtici_alimlara_iliskin_kdv.nettotal#">
                                        </div>
                                    </td>
                                </tr>
                            </cfoutput>
                            <!--- prepare --->
                            <cfif not isDefined("attributes.form_submited")>
                                <cfset query_tam_tevkifatli_alislar_ = kdv_beyan.get_tevkifatli_alislar( is_tamtevkifat: 0, sal_mon: attributes.sal_mon, sal_year: attributes.sal_year )>
                                <cfquery name="query_tam_tevkifatli_alislar" dbtype="query">
                                    SELECT SUM(TAXTOTAL) AS TAXTOTAL, SUM(NETTOTAL) AS NETTOTAL FROM query_tam_tevkifatli_alislar_
                                </cfquery>
                               <cfif query_tam_tevkifatli_alislar.recordCount>
                                    <cfset attributes.beyanname.bolum2.sorumlu_sifatiyle_beyan = {
                                        taxtotal: tlformat(query_tam_tevkifatli_alislar.TAXTOTAL, 2),
                                        nettotal: tlformat(query_tam_tevkifatli_alislar.NETTOTAL, 2)
                                    }>
                                <cfelse>
                                    <cfset attributes.beyanname.bolum2.sorumlu_sifatiyle_beyan = {
                                        taxtotal: tlformat(0, 2),
                                        nettotal: tlformat(0, 2)
                                    }>
                                </cfif>
                            </cfif>
                            <!--- end prepare --->
                            <cfoutput>
                                <tr>
                                    <td>109</td>
                                    <td><cf_get_lang dictionary_id='60737.Sorumlu Sıfatıyla Beyan Edilen KDV'></td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" style="text-align: right;" name="beyanname.bolum2.sorumlu_sifatiyle_beyan.taxtotal" value="#attributes.beyanname.bolum2.sorumlu_sifatiyle_beyan.taxtotal#">
                                            <input type="hidden" name="beyanname.bolum2.sorumlu_sifatiyle_beyan.nettotal" value="#attributes.beyanname.bolum2.sorumlu_sifatiyle_beyan.nettotal#">
                                        </div>
                                    </td>
                                </tr>
                            </cfoutput>
                            <!--- prepare --->
                            <cfif not isDefined("attributes.form_submited")>
                                <cfset query_indirilecek_islemler = kdv_beyan.get_indirilecek_islemler( sal_mon: attributes.sal_mon, sal_year: attributes.sal_year, codes: "591" )>
                                <cfquery name="query_summary_indirilecek_islemler" dbtype="query">
                                    SELECT SUM(TAXTOTAL) AS TAXTOTAL, SUM(NETTOTAL) AS NETTOTAL FROM query_indirilecek_islemler
                                </cfquery>
                                <cfif query_summary_indirilecek_islemler.recordCount>
                                    <cfset attributes.beyanname.bolum2.ithalde_odenen_kdv = {
                                        taxtotal: tlformat(query_summary_indirilecek_islemler.TAXTOTAL, 2),
                                        nettotal: tlformat(query_summary_indirilecek_islemler.NETTOTAL, 2)
                                    }>
                                <cfelse>
                                    <cfset attributes.beyanname.bolum2.ithalde_odenen_kdv = {
                                        taxtotal: tlformat(0, 2),
                                        nettotal: tlformat(0, 2)
                                    }>
                                </cfif>
                            </cfif>
                            <!--- end prepare --->
                            <cfoutput>
                                <tr>
                                    <td>110</td>
                                    <td><cf_get_lang dictionary_id='60738.İthalde Ödenen KDV'></td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" style="text-align: right;" name="beyanname.bolum2.ithalde_odenen_kdv.taxtotal" value="#attributes.beyanname.bolum2.ithalde_odenen_kdv.taxtotal#">
                                            <input type="hidden" name="beyanname.bolum2.ithalde_odenen_kdv.nettotal" value="#attributes.beyanname.bolum2.ithalde_odenen_kdv.nettotal#">
                                        </div>
                                    </td>
                                </tr>
                            </cfoutput>
                            <!--- prepare --->
                            <cfif not isDefined("attributes.form_submited")>
                                <cfset attributes.beyanname.bolum2.degersiz_alacaklara_iliskin_indirilecek_kdv = {
                                    taxtotal: tlformat(0, 2),
                                    nettotal: tlformat(0, 2)
                                }>
                            </cfif>
                            <!--- end prepare --->
                            <cfoutput>
                                <tr>
                                    <td>111</td>
                                    <td><cf_get_lang dictionary_id='60739.Değersiz Alacaklara İlişkin İndirilecek KDV'></td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" style="text-align: right;" name="beyanname.bolum2.degersiz_alacaklara_iliskin_indirilecek_kdv.taxtotal" value="#attributes.beyanname.bolum2.degersiz_alacaklara_iliskin_indirilecek_kdv.taxtotal#">
                                            <input type="hidden" name="beyanname.bolum2.degersiz_alacaklara_iliskin_indirilecek_kdv.nettotal" value="#attributes.beyanname.bolum2.degersiz_alacaklara_iliskin_indirilecek_kdv.nettotal#">
                                        </div>
                                    </td>
                                </tr>
                            </cfoutput>

                            <tr>
                                <td colspan="2" style="text-align: right;"><cf_get_lang dictionary_id='57649.İndirimler Toplamı'>:</td>
                                <td style="text-align: right;"><cfoutput>#tlformat(
                                    filternum(attributes.beyanname.bolum2.onceki_donemden_devreden_indirilecek.taxtotal, 2) +
                                    filternum(attributes.beyanname.bolum2.satistan_iadeler.taxtotal, 2) +
                                    filternum(attributes.beyanname.bolum2.turkiyede_ikamet_etmeyenlere_iade.taxtotal, 2) +
                                    filternum(attributes.beyanname.bolum2.indirime_tabi_iadesi_gerceklesmeyen_kdv.taxtotal, 2) +
                                    filternum(attributes.beyanname.bolum2.madde11_1c_17.taxtotal, 2) +
                                    filternum(attributes.beyanname.bolum2.yurtici_alimlara_iliskin_kdv.taxtotal, 2) +
                                    filternum(attributes.beyanname.bolum2.sorumlu_sifatiyle_beyan.taxtotal, 2) +
                                    filternum(attributes.beyanname.bolum2.ithalde_odenen_kdv.taxtotal, 2) +
                                    filternum(attributes.beyanname.bolum2.degersiz_alacaklara_iliskin_indirilecek_kdv.taxtotal, 2)
                                    , 2)#</cfoutput></td>
                            </tr>
                        </tbody>
                    </cf_grid_list>
                    <cf_grid_list>
                        <thead>
                            <tr>
                                <th colspan="3"><cf_get_lang dictionary_id='60740.Bu Döneme Ait İndirilecek KDV Tutarının Oranlara Göre Dağılımı'></th>
                            </tr>
                            <tr>
                                <th><cf_get_lang dictionary_id='42533.KDV Oranı'></th>
                                <th><cf_get_lang dictionary_id='60714.Matrah'></th>
                                <th><cf_get_lang dictionary_id='54859.KDV Tutarı'></th>
                            </tr>
                        </thead>
                        <tbody>
                            <!--- prepare --->
                            <cfif not isDefined("attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.rows")>
                                <cfset attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.rows = {}>
                            </cfif>
                            <cfif not isDefined("attributes.form_submited")>
                                <cfset query_indirilecek_islemler = kdv_beyan.get_indirilecek_islemler( is_taxtotal: 1 ,sal_mon: attributes.sal_mon, sal_year: attributes.sal_year, codes: "51,59,60,63,64,120,1201,1203,122,592,601,296")>
                                <cfquery name="query_summary_indirilecek_islemler" dbtype="query">
                                    SELECT TAX, SUM(TAXTOTAL) AS TAXTOTAL, SUM(NETTOTAL) AS NETTOTAL FROM query_indirilecek_islemler
                                    GROUP BY TAX
                                    ORDER BY TAX
                                </cfquery>
                                <cfoutput query="query_summary_indirilecek_islemler">
                                    <cfset attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.rows["row"&currentRow] = {
                                        tax: TAX,
                                        taxtotal: tlformat(TAXTOTAL, 2),
                                        nettotal: tlformat(NETTOTAL, 2)
                                    }>
                                </cfoutput>
                                <cfif query_summary_indirilecek_islemler.recordCount>
                                    <cfset attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.total = {
                                        taxtotal: tlformat( arrayReduce( valueArray( query_summary_indirilecek_islemler, "TAXTOTAL" ), _reduceflatten ), 2),
                                        nettotal: tlformat( arrayReduce( valueArray( query_summary_indirilecek_islemler, "NETTOTAL" ), _reduceflatten ), 2)
                                    }>
                                <cfelse>
                                    <cfset attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.total = {
                                        taxtotal: tlformat(0, 2),
                                        nettotal: tlformat(0, 2)
                                    }>
                                </cfif>
                            <cfelse>
                                <cfif isDefined("attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi") and StructCount(attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.rows) gt 0 and structKeyExists( attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi, "rows" )>
                                    <cffunction name="_budomeneaitindirilecekkdvdagilimitaxtotal">
                                        <cfargument name="elm">
                                        <cfreturn filternum(attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.rows[elm].taxtotal, 2)>
                                    </cffunction>
                                    <cffunction name="_budomeneaitindirilecekkdvdagiliminettotal">
                                        <cfargument name="elm">
                                        <cfreturn filternum(attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.rows[elm].nettotal, 2)>
                                    </cffunction>
                                    <cfset attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.total = {
                                        taxtotal: tlformat( arrayReduce( arrayMap( structKeyArray(attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.rows), _budomeneaitindirilecekkdvdagilimitaxtotal ), _reduceflatten ), 2),
                                        nettotal: tlformat( arrayReduce( arrayMap( structKeyArray(attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.rows), _budomeneaitindirilecekkdvdagiliminettotal ), _reduceflatten ), 2)
                                    }>
                                <cfelse>
                                    <cfset attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.total = {
                                        taxtotal: tlformat(0, 2),
                                        nettotal: tlformat(0, 2)
                                    }>
                                </cfif>
                            </cfif>
                            <!--- end prepare --->
                            <cfoutput>
                                <cfset currentRow = 1>
                                <cfloop collection="#attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.rows#" item="key">
                                <tr>
                                    <td>
                                        #attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.rows["row"&currentRow].tax#
                                        <input type="hidden" name="beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.rows.row#currentRow#.tax" value="#attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.rows["row"&currentRow].tax#">
                                    </td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" style="text-align: right;" name="beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.rows.row#currentRow#.nettotal" value="#attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.rows["row"&currentRow].nettotal#">
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form-group">
                                            <input type="text" style="text-align: right;" name="beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.rows.row#currentRow#.taxtotal" value="#attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.rows["row"&currentRow].taxtotal#">
                                        </div>
                                    </td>
                                </tr>
                                <cfset currentRow++>
                                </cfloop>
                            </cfoutput>
                            <cfoutput>
                            <tr>
                                <td colspan="2" style="text-align: right;"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
                                <td style="text-align: right;">#attributes.beyanname.bolum2.bu_doneme_ait_indirilecek_kdv_dagilimi.total.taxtotal#</td>
                            </tr>
                            </cfoutput>
                        </tbody>
                    </cf_grid_list>
                    <cf_grid_list>
                        <thead>
                            <tr>
                                <th colspan="4"><cf_get_lang dictionary_id='60742.Önceki Dönemden Devreden KDV Tutarında Değişiklik Varsa Doldurulacak Tablo'></th>
                            </tr>
                            <tr>
                                <th><a href="javascript:void(0)" onclick="add_onceki_donem_devreden_kdv_degisiklik()"><i class="fa fa-plus"></i></a></th>
                                <th><cf_get_lang dictionary_id='60743.Değişiklik Nedeni'></th>
                                <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                                <th><cf_get_lang dictionary_id='54859.KDV Tutarı'></th>
                            </tr>
                        </thead>
                        <tbody id="tdata_onceki_donem_devreden_kdv_degisiklik">
                            
                        </tbody>
                        <tbody>
                            <tr>
                                <td colspan="3" style="text-align: right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                <td style="text-align: right;" id="onceki_donem_devreden_kdv_degisiklik_toplam">0,00</td>
                            </tr>
                        </tbody>
                    </cf_grid_list>
                    <!--- prepare --->
                    <script type="text/html" id="onceki_donem_devreden_kdv_degisiklik_template">
                        <tr>
                            <td><a href="javascript:void(0)" onclick="remove_onceki_donem_devreden_kdv_degisiklik(this)"><i class="fa fa-minus"></i></a></td>
                            <td>
                                <div class="form-group">
                                    <select name="beyanname.bolum2.onceki_donem_devreden_kdv.rows.row@id.degisiklik_nedeni" class="onceki_donem_devreden_kdv_degisiklik_nedeni">
                                        <option value="1"><cf_get_lang dictionary_id='60744.Birleşme'></option>
                                        <option value="2"><cf_get_lang dictionary_id='57864.Devir'></option>
                                        <option value="3"><cf_get_lang dictionary_id='60745.Yıl İçinde Açıp Kapama'></option>
                                        <option value="4"><cf_get_lang dictionary_id='60746.Yıl İçinde Dönem'></option>
                                        <option value="5"><cf_get_lang dictionary_id='60747.Fatura Çıkarma'></option>
                                        <option value="6"><cf_get_lang dictionary_id='57263.Fatura Ekleme'></option>
                                        <option value="7"><cf_get_lang dictionary_id='57677.Döviz'></option>
                                        <option value="8"><cf_get_lang dictionary_id='58156.Diğer'></option>
                                    </select>
                                </div>
                            </td>
                            <td>
                                <div class="form-group">
                                    <input type="text" name="beyanname.bolum2.onceki_donem_devreden_kdv.rows.row@id.degisiklik_aciklama" class="onceki_donem_devreden_kdv_degisiklik_aciklama">
                                </div>
                            </td>
                            <td>
                                <div class="form-group">
                                    <input type="text" style="text-align: right;" name="beyanname.bolum2.onceki_donem_devreden_kdv.rows.row@id.degisiklik_tutar" class="onceki_donem_devreden_kdv_degisiklik_tutar" onchange="update_onceki_donem_devreden_kdv_degisiklik()">
                                </div>
                            </td>
                        </tr>
                    </script>
                    <script type="text/javascript">
                        window.onceki_donem_devreden_kdv_degisiklik_counter = 0;
                        function add_onceki_donem_devreden_kdv_degisiklik() {
                            window.onceki_donem_devreden_kdv_degisiklik_counter++;
                            $("#tdata_onceki_donem_devreden_kdv_degisiklik").append($("#onceki_donem_devreden_kdv_degisiklik_template")[0].textContent.replace(/@id/gi, window.onceki_donem_devreden_kdv_degisiklik_counter.toString()));
                        }
                        function remove_onceki_donem_devreden_kdv_degisiklik(elm) {
                            $(elm).closest("tr").remove();
                            update_onceki_donem_devreden_kdv_degisiklik();
                        }
                        function update_onceki_donem_devreden_kdv_degisiklik() {
                            $("#onceki_donem_devreden_kdv_degisiklik_toplam").html( $('.onceki_donem_devreden_kdv_degisiklik_tutar').toArray().reduce(function(acc, val) {
                                if ( !isNaN($(val).val().replace(",",".")) && $(val).val() != '' ) {
                                    return acc + parseFloat($(val).val().replace(".", "").replace(",","."));
                                } else {
                                    return acc;
                                }
                            }, 0).toFixed(2).toString().replace(".", ",") );
                        }
                        $(document).ready(function() {
                        <cfif isDefined("attributes.beyanname.bolum2.onceki_donem_devreden_kdv.rows") and arrayLen( structKeyArray( attributes.beyanname.bolum2.onceki_donem_devreden_kdv.rows ) )>
                            <cfloop collection="#attributes.beyanname.bolum2.onceki_donem_devreden_kdv.rows#" item="di">
                            add_onceki_donem_devreden_kdv_degisiklik();
                            var lst = $("#tdata_onceki_donem_devreden_kdv_degisiklik tr:last-child")[0];
                            $(lst).find('.onceki_donem_devreden_kdv_degisiklik_nedeni').val("<cfoutput>#attributes.beyanname.bolum2.onceki_donem_devreden_kdv.rows[di].degisiklik_nedeni#</cfoutput>");
                            $(lst).find('.onceki_donem_devreden_kdv_degisiklik_aciklama').val("<cfoutput>#attributes.beyanname.bolum2.onceki_donem_devreden_kdv.rows[di].degisiklik_aciklama#</cfoutput>");
                            $(lst).find('.onceki_donem_devreden_kdv_degisiklik_tutar').val("<cfoutput>#attributes.beyanname.bolum2.onceki_donem_devreden_kdv.rows[di].degisiklik_tutar#</cfoutput>");
                            </cfloop>
                            update_onceki_donem_devreden_kdv_degisiklik();
                        </cfif>
                        });
                    </script>
                    <!--- end prepare --->
                </div>

                <cfsavecontent variable="header"><cf_get_lang dictionary_id='60749.İhracat Kayıtlı Teslimler'></cfsavecontent>
                <cf_seperator id="spr3" header="#header#">
                <div id="spr3">
                    <!--- prepare --->
                    <cfif not isDefined("attributes.beyanname.bolum3.ihtracat_kayitli_islemler.rows")>
                        <cfset attributes.beyanname.bolum3.ihracat_kayitli_islemler.rows = {}>
                    </cfif>
                    <cfif not isDefined("attributes.form_submited")>
                        <cfset query_ihracat_kayitli_islemler = kdv_beyan.get_ihracat_kayitli_islemler( sal_year: attributes.sal_year )>
                        <cfquery name="query_summary_ihracat_kayitli_islemler" dbtype="query">
                            SELECT TAX, ISLEMTURU, SUM(TAXTOTAL) AS TAXTOTAL, SUM(NETTOTAL) AS NETTOTAL FROM query_ihracat_kayitli_islemler
                            GROUP BY TAX, ISLEMTURU
                        </cfquery>
                        <cfoutput query="query_summary_ihracat_kayitli_islemler">
                            <cfset attributes.beyanname.bolum3.ihracat_kayitli_islemler.rows["row"&currentRow] = {
                                tax: TAX,
                                islemturu: ISLEMTURU,
                                taxtotal: tlformat(TAXTOTAL, 2),
                                nettotal: tlformat(NETTOTAL, 2)
                            }>
                        </cfoutput>
                        <cfif query_summary_ihracat_kayitli_islemler.recordCount>
                            <cfset attributes.beyanname.bolum3.ihracat_kayitli_islemler.total = {
                                taxtotal: tlformat( arrayReduce( valueArray( query_summary_ihracat_kayitli_islemler, "TAXTOTAL" ), _reduceflatten ), 2),
                                nettotal: tlformat( arrayReduce( valueArray( query_summary_ihracat_kayitli_islemler, "NETTOTAL" ), _reduceflatten ), 2)
                            }>
                        <cfelse>
                            <cfset attributes.beyanname.bolum3.ihracat_kayitli_islemler.total = {
                                taxtotal: tlformat(0, 2),
                                nettotal: tlformat(0, 2)
                            }>
                        </cfif>
                    <cfelse>
                        <cfif isDefined("attributes.beyanname.bolum3.ihtracat_kayitli_islemler") and structKeyExists(attributes.beyanname.bolum3.ihracat_kayitli_islemler, "rows")>
                            <cffunction name="_ihracatkayitliislemlertaxtotal">
                                <cfargument name="itm">
                                <cfreturn filternum(attributes.beyanname.bolum3.ihracat_kayitli_islemler.rows[itm].taxtotal, 2)>
                            </cffunction>
                            <cffunction name="_ihracatkayitliislemlernettotal">
                                <cfargument name="itm">
                                <cfreturn filternum(attributes.beyanname.bolum3.ihracat_kayitli_islemler.rows[itm].taxtotal, 2)>
                            </cffunction>
                            <cfset attributes.beyanname.bolum3.ihracat_kayitli_islemler.total = {
                                taxtotal: tlformat( arrayReduce( arrayMap( structKeyArray( attributes.beyanname.bolum3.ihracat_kayitli_islemler.rows ), _ihracatkayitliislemlertaxtotal ), _reduceflatten ), 2),
                                nettotal: tlformat( arrayReduce( arrayMap( structKeyArray( attributes.beyanname.bolum3.ihracat_kayitli_islemler.rows ), _ihracatkayitliislemlernettotal ), _reduceflatten ), 2)
                            }>
                        <cfelse>
                            <cfset attributes.beyanname.bolum3.ihracat_kayitli_islemler.total = {
                                taxtotal: tlformat( 0, 2),
                                nettotal: tlformat( 0, 2)
                            }>
                        </cfif>
                    </cfif>
                    <!--- end prepare --->
                    <cf_grid_list>
                        <thead>
                            <tr>
                                <th><cf_get_lang dictionary_id='50161.İşlem Türü'></th>
                                <th><cf_get_lang dictionary_id='60750.Teslim Bedeli'></th>
                                <th><cf_get_lang dictionary_id='58456.Oran'></th>
                                <th><cf_get_lang dictionary_id='34137.Hesaplanan'> <cf_get_lang dictionary_id='57639.KDV'></th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput>
                                <cfset currentRow = 1>
                                <cfloop collection="#attributes.beyanname.bolum3.ihracat_kayitli_islemler.rows#" item="idx">
                                    <tr>
                                        <td>
                                            #attributes.beyanname.bolum3.ihracat_kayitli_islemler.rows["row"&currentRow].islemturu#
                                            <input type="hidden" name="beyanname.bolum3.ihracat_kayitli_islemler.rows.row#currentRow#.islemturu" value="#attributes.beyanname.bolum3.ihracat_kayitli_islemler.rows["row"&currentRow].islemturu#">
                                        </td>
                                        <td>
                                            #attributes.beyanname.bolum3.ihracat_kayitli_islemler.rows["row"&currentRow].tax#
                                            <input type="hidden" name="beyanname.bolum3.ihracat_kayitli_islemler.rows.row#currentRow#.tax" value="#attributes.beyanname.bolum3.ihracat_kayitli_islemler.rows["row"&currentRow].tax#">
                                        </td>
                                        <td>
                                            <div class="form-group">
                                                <input type="text" name="beyanname.bolum3.ihracat_kayitli_islemler.rows.row#currentRow#.taxtotal" style="text-align: right;" value="#attributes.beyanname.bolum3.ihracat_kayitli_islemler.rows["row"&currentRow].taxtotal#">
                                            </div>
                                        </td>
                                        <td>
                                            <div class="form-group">
                                                <input type="text" name="beyanname.bolum3.ihracat_kayitli_islemler.rows.row#currentRow#.nettotal" style="text-align: right;" value="#attributes.beyanname.bolum3.ihracat_kayitli_islemler.rows["row"&currentRow].nettotal#">
                                            </div>
                                        </td>
                                    </tr>
                                    <cfset currentRow++>
                                </cfloop>
                                <tr>
                                    <td colspan="3" style="text-align: right;"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
                                    <td style="text-align: right;">
                                        #attributes.beyanname.bolum3.ihracat_kayitli_islemler.total.taxtotal#
                                    </td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    </cf_grid_list>
                    <cf_grid_list>
                        <tbody>
                            <tr>
                                <td><cf_get_lang dictionary_id='60751.İhraç Kaydıyla Teslim Bedeli Toplamı'></td>
                                <td>
                                    <div class="form-group">
                                        <input type="text" value="<cfoutput>#attributes.beyanname.bolum3.ihracat_kayitli_islemler.total.nettotal#</cfoutput>" style="text-align: right;" readonly>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id='60752.Tecil Edilebilir'> <cf_get_lang dictionary_id='57639.KDV'></td>
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="beyanname.bolum3.ihracat_kayitli_islemler.total.taxtotal" value="<cfoutput>#attributes.beyanname.bolum3.ihracat_kayitli_islemler.total.taxtotal#</cfoutput>" style="text-align: right;" readonly>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id='60753.İhracatın Gerçekleştiği Dönemde İade Edilecek Tecil Edilmeyen KDV'></td>
                                <!--- prepare --->
                                <cfif not isDefined("attributes.form_submited")>
                                    <cfset attributes.beyanname.bolum3.ihracat_gerceklestigi_donem_iade_edilecek_tecil_edilmeyen_kdv = tlformat(0, 2)>
                                </cfif>
                                <!--- end prepare --->
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="beyanname.bolum3.ihracat_gerceklestigi_donem_iade_edilecek_tecil_edilmeyen_kdv" value="<cfoutput>#attributes.beyanname.bolum3.ihracat_gerceklestigi_donem_iade_edilecek_tecil_edilmeyen_kdv#</cfoutput>" style="text-align: right;">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id='60754.Yurtiçi ve Yurtdışı KDV ödenmeksizin Temin Edilen Mal Bedeli'></td>
                                <!--- prepare --->
                                <cfif not isDefined("attributes.form_submitted")>
                                    <cfset attributes.beyanname.bolum3.ihrac_kaydiyla_yurticive_yurtdisi_kdv_odenmeksizin_temin_edilen_mal_bedeli = tlformat(0, 2)>
                                </cfif>
                                <!--- end prepare --->
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="beyanname.bolum3.ihrac_kaydiyla_yurticive_yurtdisi_kdv_odenmeksizin_temin_edilen_mal_bedeli" value="<cfoutput>#attributes.beyanname.bolum3.ihrac_kaydiyla_yurticive_yurtdisi_kdv_odenmeksizin_temin_edilen_mal_bedeli#</cfoutput>" style="text-align: right;">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id='60755.İhracatın Gerçekleştiği Dönemde İade Edilecek KDV'></td>
                                <!--- prepare --->
                                <cfif not isDefined("attributes.form_submitted")>
                                    <cfset attributes.beyanname.bolum3.ihrac_kaydiyla_i̇hracatin_gerceklestigi_donemde_i̇ade_edilecek_kdv = tlformat(0, 2)>
                                </cfif>
                                <!--- end prepare --->
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="beyanname.bolum3.ihrac_kaydiyla_i̇hracatin_gerceklestigi_donemde_i̇ade_edilecek_kdv" value="<cfoutput>#attributes.beyanname.bolum3.ihrac_kaydiyla_i̇hracatin_gerceklestigi_donemde_i̇ade_edilecek_kdv#</cfoutput>" style="text-align: right;">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id='60756.Yüklenilen'> <cf_get_lang dictionary_id='57639.KDV'></td>
                                <!--- prepare --->
                                <cfif not isDefined("attributes.form_submitted")>
                                    <cfset attributes.beyanname.bolum3.ihrac_kaydiyla_yuklenilen_kdv = tlformat(0, 2)>
                                </cfif>
                                <!--- end prepare --->
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="beyanname.bolum3.ihrac_kaydiyla_yuklenilen_kdv" value="<cfoutput>#attributes.beyanname.bolum3.ihrac_kaydiyla_yuklenilen_kdv#</cfoutput>" style="text-align: right;">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id='60757.İndirimli Orana Tabi Malların İhraç Kaydıyla Tesliminde İade Edilecek Yüklenilen Vergi Farkı'></td>
                                <!--- prepare --->
                                <cfif not isDefined("attributes.form_submitted")>
                                    <cfset attributes.beyanname.bolum3.ihrac_kaydiyla_i̇ndirimli_orana_tabi_mallarini̇hrac_kaydiyla_tesliminde_i̇ade_edilecek_yuklenilen_vergi_farki = tlformat(0, 2)>
                                </cfif>
                                <!--- end prepare --->
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="beyanname.bolum3.ihrac_kaydiyla_i̇ndirimli_orana_tabi_mallarini̇hrac_kaydiyla_tesliminde_i̇ade_edilecek_yuklenilen_vergi_farki" value="<cfoutput>#attributes.beyanname.bolum3.ihrac_kaydiyla_i̇ndirimli_orana_tabi_mallarini̇hrac_kaydiyla_tesliminde_i̇ade_edilecek_yuklenilen_vergi_farki#</cfoutput>" style="text-align: right;">
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </cf_grid_list>
                </div>
                <cf_seperator id="spr4" header="#getlang('','Sonuç Hesapları',887)#">
                <cf_grid_list id="spr4">
                    <tbody>
                        <!--- prepare --->
                        <cfif not isDefined("attributes.form_submited")>
                            <cfset attributes.beyanname.bolum5.tecil_edilecek_kdv = tlformat(0, 2)>
                        </cfif>
                        <!--- end prepare --->
                        <tr>
                            <td><cf_get_lang dictionary_id='60758.Tecil Edilecek Katma Değer Vergisi'></td>
                            <td>
                                <div class="form-group">
                                    <input type="text" name="beyanname.bolum5.tecil_edilecek_kdv" style="text-align: right;" value="<cfoutput>#attributes.beyanname.bolum5.tecil_edilecek_kdv#</cfoutput>">
                                </div>
                            </td>
                        </tr>
                        <!--- prepare --->
                        <cfif not isDefined("attributes.form_submited")>
                            <cfset attributes.beyanname.bolum5.odenmesi_gereken_kdv = tlformat(0, 2)>
                        </cfif>
                        <!--- end prepare --->
                        <tr>
                            <td><cf_get_lang dictionary_id='60759.Ödenmesi Gereken Katma Değer Vergisi'></td>
                            <td>
                                <div class="form-group">
                                    <input type="text" name="beyanname.bolum5.odenmesi_gereken_kdv" style="text-align: right;" value="<cfoutput>#attributes.beyanname.bolum5.odenmesi_gereken_kdv#</cfoutput>">
                                </div>
                            </td>
                        </tr>
                        <!--- prepare --->
                        <cfif not isDefined("attributes.form_submited")>
                            <cfset attributes.beyanname.bolum5.sonraki_doneme_devreden_kdv = tlformat(0, 2)>
                        </cfif>
                        <!--- end prepare --->
                        <tr>
                            <td><cf_get_lang dictionary_id='60760.Sonraki Döneme Devreden Katma Değer Vergisi'></td>
                            <td>
                                <div class="form-group">
                                    <input type="text" name="beyanname.bolum5.sonraki_doneme_devreden_kdv" style="text-align: right;" value="<cfoutput>#attributes.beyanname.bolum5.sonraki_doneme_devreden_kdv#</cfoutput>">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2"><cf_get_lang dictionary_id='55572.Diğer Bilgiler'></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang dictionary_id='60762.Özel Matrah Şekline Tabi İşlemlerde Matrah Dahili Olmayan Bedel'></td>
                            <td>
                                <div class="form-group">
                                    <input type="text" value="<cfoutput>#attributes.beyanname.bolum1.diger.sabit_kiymet_satisi.nettotal#</cfoutput>" style="text-align: right;" readonly>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td><cf_get_lang dictionary_id='60763.Teslim ve Hizmetlerin Karşılığını Teşkil Eden Bedel'> (<cf_get_lang dictionary_id='58932.Aylık'>)</td>
                            <td>
                                <div class="form-group">
                                    <input type="text" value="<cfoutput>#tlformat(
                                    filternum(attributes.beyanname.bolum1.diger.bavul_ticareti.nettotal, 2) +  
                                    filternum(attributes.beyanname.bolum1.diger.sabit_kiymet_satisi.nettotal, 2) + 
                                    filternum(attributes.beyanname.bolum1.diger.ilave_edilecek_kdv.nettotal, 2) + 
                                    filternum(attributes.beyanname.bolum1.tevkifatsiz.total.nettotal, 2) + 
                                    filternum(attributes.beyanname.bolum1.tevkifatli.total.nettotal, 2)
                                    , 2)#</cfoutput>" style="text-align: right;" readonly>
                                </div>
                            </td>
                        </tr>
                        <!--- prepare --->
                            <cfset query_yillik_bavul_ticareti = kdv_beyan.get_bavul_ticareti( to_mon: attributes.sal_mon, sal_year: attributes.sal_year )>
                            <cfset sumof_yillik_bavul_ticareti = query_yillik_bavul_ticareti.recordCount ? arrayReduce( valueArray( query_yillik_bavul_ticareti, "NETTOTAL" ), _reduceflatten ) : 0>
                            <cfset query_yillik_ilave_edilecek_kdv = kdv_beyan.get_ilave_edilecek_kdv( to_mon: attributes.sal_mon, sal_year: attributes.sal_year )>
                            <cfset sumof_yillik_ilave_edilecek_kdv = query_yillik_ilave_edilecek_kdv.recordCount ? arrayReduce( valueArray( query_yillik_ilave_edilecek_kdv, "NETTOTAL" ), _reduceflatten ) : 0>
                            <cfset query_yillik_tevkifatsiz_islemler = kdv_beyan.get_tevkifatsiz_islemler( to_mon: attributes.sal_mon, sal_year: attributes.sal_year )>
                            <cfset sumof_yillik_tevkifatsiz_islemler = query_yillik_tevkifatsiz_islemler.recordCount ? arrayReduce( valueArray( query_yillik_tevkifatsiz_islemler, "NETTOTAL" ), _reduceflatten ) : 0>
                            <cfset query_yillik_tevkifatli_islemler = kdv_beyan.get_tevkifatli_islemler( to_mon: attributes.sal_mon, sal_year: attributes.sal_year )>
                            <cfset sumof_yillik_tevkifatli_islemler = query_yillik_tevkifatli_islemler.recordCount ? arrayReduce( valueArray( query_yillik_tevkifatli_islemler, "NETTOTAL" ), _reduceflatten ) : 0>
                        <!--- end prepare --->
                        <tr>
                            
                            <td><cf_get_lang dictionary_id='60763.Teslim ve Hizmetlerin Karşılığını Teşkil Eden Bedel'> (<cf_get_lang dictionary_id='60764.Kümilatif'>)</td>
                            <td>
                                <div class="form-group">
                                    <input type="text" value="<cfoutput>#tlformat(sumof_yillik_bavul_ticareti+sumof_yillik_ilave_edilecek_kdv+sumof_yillik_tevkifatli_islemler+sumof_yillik_tevkifatsiz_islemler)#</cfoutput>" style="text-align: right;" readonly>
                                </div>
                            </td>
                            
                        </tr>
                        <tr>
                            <td><cf_get_lang dictionary_id='60765.Kredi Kartı ile Tahsil Edilen Teslim ve Hizmetlerin KDV Dahil Karşılığını Teşkil Eden Bedel'></td>
                            <td></td>
                        </tr>
                    </tbody>
                </cf_grid_list>
        
                <cfsavecontent variable="header"><cf_get_lang dictionary_id='57980.Genel Bilgiler'></cfsavecontent>
                <cf_seperator id="spr5" header="#header#">
                <cfset ourcompany = kdv_beyan.get_our_company(session.ep.company_id)>
                <cf_grid_list id="spr5">
                    <tbody>
                        <!--- prepare --->
                        <cfif not isDefined("attributes.form_submited")>
                            <cfset attributes.beyanname.bolum6.vergi_dairesi = ourcompany.TAX_OFFICE>
                        </cfif>
                        <!--- end prepare --->
                        <tr>
                            <td><cf_get_lang dictionary_id='58762.Vergi Dairesi'></td>
                            <td>
                                <div class="form-group"><input type="text" name="beyanname.bolum6.vergi_dairesi" value="<cfoutput>#attributes.beyanname.bolum6.vergi_dairesi#</cfoutput>"></div>
                            </td>
                        </tr>
                        <!--- prepare --->
                        <cfif not isDefined("attributes.form_submited")>
                            <cfset attributes.beyanname.bolum6.donem_tipi = 1>
                        </cfif>
                        <!--- end prepare --->
                        <tr>
                            <td><cf_get_lang dictionary_id='60766.Dönem Tipi'></td>
                            <td>
                                <div class="form-group">
                                    <select name="beyanname.bolum6.donem_tipi" onchange="onDonemChange(this)">
                                        <option value="1" <cfif attributes.beyanname.bolum6.donem_tipi eq 1>selected</cfif>><cf_get_lang dictionary_id='58932.Aylık'></option>
                                        <option value="2" <cfif attributes.beyanname.bolum6.donem_tipi eq 2>selected</cfif>>3 <cf_get_lang dictionary_id='58932.Aylık'></option>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <!--- prepare --->
                        <cfif not isDefined("attributes.form_submited")>
                            <cfset attributes.beyanname.bolum6.donem_ay = attributes.sal_mon>
                            <cfset attributes.beyanname.bolum6.donem_period = 1>
                            <cfset attributes.beyanname.bolum6.donem_yil = attributes.sal_year>
                        </cfif>
                        <!--- end prepare --->
                        <tr>
                            <td><cf_get_lang dictionary_id='58472.Dönem'>/ <cf_get_lang dictionary_id='58455.Yıl'></td>
                            <td>
                                <div class="form-group">
                                    <div class="col col-6 pl-0">
                                    <select name="beyanname.bolum6.donem_ay" id="donem_ay">
                                        <option value="1" <cfif attributes.beyanname.bolum6.donem_ay eq "1">selected</cfif>><cf_get_lang dictionary_id='57592.Ocak'></option>
                                        <option value="2" <cfif attributes.beyanname.bolum6.donem_ay eq "2">selected</cfif>><cf_get_lang dictionary_id='57593.Şubat'></option>
                                        <option value="3" <cfif attributes.beyanname.bolum6.donem_ay eq "3">selected</cfif>><cf_get_lang dictionary_id='57594.Mart'></option>
                                        <option value="4" <cfif attributes.beyanname.bolum6.donem_ay eq "4">selected</cfif>><cf_get_lang dictionary_id='57595.Nisan'></option>
                                        <option value="5" <cfif attributes.beyanname.bolum6.donem_ay eq "5">selected</cfif>><cf_get_lang dictionary_id='57596.Mayıs'></option>
                                        <option value="6" <cfif attributes.beyanname.bolum6.donem_ay eq "6">selected</cfif>><cf_get_lang dictionary_id='57597.Haziran'></option>
                                        <option value="7" <cfif attributes.beyanname.bolum6.donem_ay eq "7">selected</cfif>><cf_get_lang dictionary_id='57598.Temmuz'></option>
                                        <option value="8" <cfif attributes.beyanname.bolum6.donem_ay eq "8">selected</cfif>><cf_get_lang dictionary_id='57599.Ağustos'></option>
                                        <option value="9" <cfif attributes.beyanname.bolum6.donem_ay eq "9">selected</cfif>><cf_get_lang dictionary_id='57600.Eylül'></option>
                                        <option value="10" <cfif attributes.beyanname.bolum6.donem_ay eq "10">selected</cfif>><cf_get_lang dictionary_id='57601.Ekim'></option>
                                        <option value="11" <cfif attributes.beyanname.bolum6.donem_ay eq "11">selected</cfif>><cf_get_lang dictionary_id='57602.Kasım'></option>
                                        <option value="12" <cfif attributes.beyanname.bolum6.donem_ay eq "12">selected</cfif>><cf_get_lang dictionary_id='57603.Aralık'></option>
                                    </select>
                                    <select name="beyanname.bolum6.donem_period" id="donem_period" style="display: none;">
                                        <option value="1" <cfif attributes.beyanname.bolum6.donem_period eq "1">selected</cfif>>1. <cf_get_lang dictionary_id='52247.Çeyrek'></option>
                                        <option value="2" <cfif attributes.beyanname.bolum6.donem_period eq "1">selected</cfif>>2. <cf_get_lang dictionary_id='52247.Çeyrek'></option>
                                        <option value="3" <cfif attributes.beyanname.bolum6.donem_period eq "1">selected</cfif>>3. <cf_get_lang dictionary_id='52247.Çeyrek'></option>
                                        <option value="4" <cfif attributes.beyanname.bolum6.donem_period eq "1">selected</cfif>>4. <cf_get_lang dictionary_id='52247.Çeyrek'></option>
                                    </select>
                                    </div>
                                    <div class="col col-6">
                                    <input type="text" name="beyanname.bolum6.donem_yil" value="<cfoutput>#attributes.beyanname.bolum6.donem_yil#</cfoutput>">
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <!--- prepare --->
                        <cfif not isDefined("attributes.form_submited")>
                            <cfset attributes.beyanname.bolum6.vergi_no = ourcompany.TAX_NO>
                        </cfif>
                        <!--- end prepare --->
                        <tr>
                            <td><cf_get_lang dictionary_id='57752.Vergi No'></td>
                            <td>
                                <div class="form-group">
                                    <input type="text" name="beyanname.bolum6.vergi_no" value="<cfoutput>#attributes.beyanname.bolum6.vergi_no#</cfoutput>">
                                </div>
                            </td>
                        </tr>
                        <!--- prepare --->
                        <cfif not isDefined("attributes.form_submited")>
                            <cfset attributes.beyanname.bolum6.unvan = ourcompany.COMPANY_NAME>
                        </cfif>
                        <!--- end prepare --->
                        <tr>
                            <td><cf_get_lang dictionary_id='57571.Ünvan'> (<cf_get_lang dictionary_id='58550.Soyadı'>)</td>
                            <td>
                                <div class="form-group">
                                    <input type="text" name="beyanname.bolum6.unvan" value="<cfoutput>#attributes.beyanname.bolum6.unvan#</cfoutput>">
                                </div>
                            </td>
                        </tr>
                        <!--- prepare --->
                        <cfif not isDefined("attributes.form_submited")>
                            <cfset attributes.beyanname.bolum6.unvan_devam = "">
                        </cfif>
                        <!--- end prepare --->
                        <tr>
                            <td><cf_get_lang dictionary_id='60767.Ünvan Devamı'> (<cf_get_lang dictionary_id='57897.Adı'>)</td>
                            <td>
                                <div class="form-group">
                                    <input type="text" name="beyanname.bolum6.unvan_devam" value="<cfoutput>#attributes.beyanname.bolum6.unvan_devam#</cfoutput>">
                                </div>
                            </td>
                        </tr>
                        <!--- prepare --->
                        <cfif not isDefined("attributes.form_submited")>
                            <cfset attributes.beyanname.bolum6.ticari_sicilno = ourcompany.T_NO>
                        </cfif>
                        <!--- end prepare --->
                        <tr>
                            <td><cf_get_lang dictionary_id='29446.Ticari'> <cf_get_lang dictionary_id='56542.Sicil No'></td>
                            <td>
                                <div class="form-group">
                                    <input type="text" name="beyanname.bolum6.ticari_sicilno" value="<cfoutput>#attributes.beyanname.bolum6.ticari_sicilno#</cfoutput>">
                                </div>
                            </td>
                        </tr>
                        <!--- prepare --->
                        <cfif not isDefined("attributes.form_submited")>
                            <cfset attributes.beyanname.bolum6.email = ourcompany.EMAIL>
                        </cfif>
                        <!--- end prepare --->
                        <tr>
                            <td><cf_get_lang dictionary_id='57428.E-Posta Adresi'></td>
                            <td>
                                <div class="form-group">
                                    <input type="text" name="beyanname.bolum6.email" value="<cfoutput>#attributes.beyanname.bolum6.email#</cfoutput>">
                                </div>
                            </td>
                        </tr>
                        <!--- prepare --->
                        <cfif not isDefined("attributes.form_submited")>
                            <cfset attributes.beyanname.bolum6.telcode = ourcompany.TEL_CODE>
                            <cfset attributes.beyanname.bolum6.tel = ourcompany.TEL>
                        </cfif>
                        <!--- end prepare --->
                        <tr>
                            <td><cf_get_lang dictionary_id='29756.İrtibat'> <cf_get_lang dictionary_id='49272.Tel'></td>
                            <td>
                                <div class="form-group">
                                    <div class="col col-4 pl-0">
                                        <input type="text" name="beyanname.bolum6.telcode" value="<cfoutput>#attributes.beyanname.bolum6.telcode#</cfoutput>">
                                    </div>
                                    <div class="col col-8">
                                        <input type="text" name="beyanname.bolum6.tel" value="<cfoutput>#attributes.beyanname.bolum6.tel#</cfoutput>">
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <!--- prepare --->
                        <cfif not isDefined("attributes.form_submited") or not isDefined("attributes.beyanname.bolum6.beyan")>
                            <cfset attributes.beyanname.bolum6.beyan = 0>
                        </cfif>
                        <!--- end prepare --->
                        <tr>
                            <td colspan="2">
                                <div class="form-group">
                                    <input type="checkbox" name="beyanname.bolum6.beyan" value="1" <cfif attributes.beyanname.bolum6.beyan eq "1">checked</cfif>><cf_get_lang dictionary_id='60768.Beyan Edilecek Bilgim Bulunmamaktadır'>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </cf_grid_list>
            </div>
            <div id="unique_manuel_muhasebe" class="ui-info-text uniqueBox">
                <cfsavecontent variable="header"><cf_get_lang dictionary_id='40382.İndirilecek KDV'></cfsavecontent>
                <cf_seperator id="spr6" header="#header#">
                <!--- prepare --->
                <cfif not isDefined("attributes.beyanname.manuel.indirilecek_kdv.rows")>
                    <cfset attributes.beyanname.manuel.indirilecek_kdv.rows = {}>
                </cfif>
                <cfif not isDefined("attributes.form_submited")>
                    <cfset query_muhasebe_indirilecek_kdv = kdv_beyan.get_muhasebe_indirilecek_kdv( sal_mon: attributes.sal_mon, sal_year: attributes.sal_year )>
                    <cfset row_1 = 1>
                    <cfloop query="query_muhasebe_indirilecek_kdv">
                        <cfset attributes.beyanname.manuel.indirilecek_kdv.rows["row"&#row_1#] = {
                            kod: query_muhasebe_indirilecek_kdv.ACCOUNT_ID,
                            hesap_adi: query_muhasebe_indirilecek_kdv.ACCOUNT_NAME,
                            kdv_oran: query_muhasebe_indirilecek_kdv.TAX,
                            vergi: tlformat( query_muhasebe_indirilecek_kdv.KDV, 2 ),
                            matrah: tlformat( query_muhasebe_indirilecek_kdv.MATRAH, 2 ),
                            islem_sayisi: query_muhasebe_indirilecek_kdv.MIKTAR
                        }>
                        <cfset row_1++>
                    </cfloop>
                    <cfset attributes.beyanname.manuel.indirilecek_kdv.total = {
                        vergi: tlformat( query_muhasebe_indirilecek_kdv.recordCount ? arrayReduce( valueArray( query_muhasebe_indirilecek_kdv, "KDV" ), _reduceflatten ) : 0, 2 ),
                        matrah: tlformat( query_muhasebe_indirilecek_kdv.recordCount ? arrayReduce( valueArray( query_muhasebe_indirilecek_kdv, "MATRAH" ), _reduceflatten ) : 0, 2 ),
                        islem_sayisi: query_muhasebe_indirilecek_kdv.recordCount ? arrayReduce( valueArray( query_muhasebe_indirilecek_kdv, "MIKTAR" ), _reduceflatten ) : 0
                    }>
                <cfelse>
                    <cfloop collection="#attributes.beyanname.manuel.indirilecek_kdv.rows#" item="di">
                        <cfif len(attributes.beyanname.manuel.indirilecek_kdv.rows[di].kdv_oran) and attributes.beyanname.manuel.indirilecek_kdv.rows[di].kdv_oran neq "0" and len(attributes.beyanname.manuel.indirilecek_kdv.rows[di].vergi)>
                            <cfset attributes.beyanname.manuel.indirilecek_kdv.rows[di].matrah = tlformat( 100 * filternum( attributes.beyanname.manuel.indirilecek_kdv.rows[di].vergi, 2 ) / attributes.beyanname.manuel.indirilecek_kdv.rows[di].kdv_oran, 2 )>
                        <cfelse>
                            <cfset attributes.beyanname.manuel.indirilecek_kdv.rows[di].matrah = 0>
                        </cfif>
                    </cfloop>
                    <cffunction name="_indirilecekkdvvergi">
                        <cfargument name="key">
                        <cfreturn filternum( attributes.beyanname.manuel.indirilecek_kdv.rows[key].vergi, 2 )>
                    </cffunction>
                    <cffunction name="_indirilecekkdvmatrah">
                        <cfargument name="key">
                        <cfreturn filternum( attributes.beyanname.manuel.indirilecek_kdv.rows[key].matrah, 2 )>
                    </cffunction>
                    <cffunction name="_indirilecekkdvislem_sayisi">
                        <cfargument name="key">
                        <cfreturn attributes.beyanname.manuel.indirilecek_kdv.rows[key].islem_sayisi>
                    </cffunction>
                    <cfset control=arrayReduce( arrayMap( structKeyArray(attributes.beyanname.manuel.indirilecek_kdv.rows), _indirilecekkdvvergi ), _reduceflatten )>
                    <cfif isdefined("control") and len(control)>
                        <cfset attributes.beyanname.manuel.indirilecek_kdv.total = {
                            vergi: tlformat( arrayReduce( arrayMap( structKeyArray(attributes.beyanname.manuel.indirilecek_kdv.rows), _indirilecekkdvvergi ), _reduceflatten ), 2 ),
                            matrah: tlformat( arrayReduce( arrayMap( structKeyArray(attributes.beyanname.manuel.indirilecek_kdv.rows), _indirilecekkdvmatrah ), _reduceflatten ), 2 ),
                            islem_sayisi: arrayReduce( arrayMap( structKeyArray(attributes.beyanname.manuel.indirilecek_kdv.rows), _indirilecekkdvislem_sayisi ), _reduceflatten )
                        }>
                    <cfelse>
                        <cfset attributes.beyanname.manuel.indirilecek_kdv.total = {
                            vergi: tlformat( 0, 2 ),
                            matrah: tlformat( 0, 2 ),
                            islem_sayisi:0
                        }>
                    </cfif>
                  
                </cfif>
                <!--- end prepare --->
                <cf_grid_list id="spr6">
                    <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='58585.Kod'></th>
                            <th><cf_get_lang dictionary_id='55271.Hesap Adı'></th>
                            <th style="width: 50px;"><cf_get_lang dictionary_id='42533.KDV Oran'></th>
                            <th><cf_get_lang dictionary_id='33304.Vergi'></th>
                            <th><cf_get_lang dictionary_id='60714.Matrah'></th>
                            <th><cf_get_lang dictionary_id='54855.İşlem Sayısı'></th>
                        </tr>
                    </thead>
                    <tbody data-compute="col_ik">
                        <cfoutput>
                            <cfset currentRow = 1>
                            <cfloop collection="#attributes.beyanname.manuel.indirilecek_kdv.rows#" item="di">
                            <tr data-compute="ik#currentRow#">
                                <td>
                                    <input type="hidden" name="beyanname.manuel.indirilecek_kdv.rows.row#currentRow#.kod" value="#attributes.beyanname.manuel.indirilecek_kdv.rows[di].kod#">
                                    #attributes.beyanname.manuel.indirilecek_kdv.rows[di].kod#
                                </td>
                                <td>
                                    <input type="hidden" name="beyanname.manuel.indirilecek_kdv.rows.row#currentRow#.hesap_adi" value="#attributes.beyanname.manuel.indirilecek_kdv.rows[di].hesap_adi#">
                                    #attributes.beyanname.manuel.indirilecek_kdv.rows[di].hesap_adi#
                                </td>
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="beyanname.manuel.indirilecek_kdv.rows.row#currentRow#.kdv_oran" data-compute-item="row#currentRow#_kdv_oran" value="#attributes.beyanname.manuel.indirilecek_kdv.rows[di].kdv_oran#" style="text-align: right;">
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="beyanname.manuel.indirilecek_kdv.rows.row#currentRow#.vergi" data-compute-item="row#currentRow#_vergi" value="#attributes.beyanname.manuel.indirilecek_kdv.rows[di].vergi#" style="text-align: right;" readonly>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="beyanname.manuel.indirilecek_kdv.rows.row#currentRow#.matrah" data-compute-item="row#currentRow#_matrah" data-compute-id="ik#currentRow#" data-compute-formula="100 * parseFloat($('[data-compute=ik#currentRow#] [data-compute-item=row#currentRow#_vergi]').val().replace('.', '').replace(',','.')) / parseFloat($('[data-compute=ik#currentRow#] [data-compute-item=row#currentRow#_kdv_oran]').val())" value="#attributes.beyanname.manuel.indirilecek_kdv.rows[di].matrah#" style="text-align: right;">
                                    </div>
                                </td>
                                <td style="text-align: right;">
                                    <input type="hidden" name="beyanname.manuel.indirilecek_kdv.rows.row#currentRow#.islem_sayisi" value="#attributes.beyanname.manuel.indirilecek_kdv.rows[di].islem_sayisi#">
                                    #attributes.beyanname.manuel.indirilecek_kdv.rows[di].islem_sayisi#
                                </td>
                            </tr>
                            <cfset currentRow++>
                            </cfloop>
                            <tr>
                                <td colspan="3" style="text-align: right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                <td style="text-align: right;"><cfoutput>#attributes.beyanname.manuel.indirilecek_kdv.total.vergi#</cfoutput></td>
                                <td>
                                    <div class="form-group">
                                        <cfoutput><input type="text" value="#attributes.beyanname.manuel.indirilecek_kdv.total.matrah#" data-compute-id="col_ik" data-compute-formula="$('[data-compute=col_ik] [data-compute-item*=_matrah]').toArray().reduce(function(acc, elm) { return acc + parseFloat($(elm).val().replace('.','').replace(',','.')) }, 0)" style="text-align: right; width: 100%;"></cfoutput>
                                    </div>
                                </td>
                                <td style="text-align: right;"><cfoutput>#attributes.beyanname.manuel.indirilecek_kdv.total.islem_sayisi#</cfoutput></td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </cf_grid_list>

                <cfsavecontent variable="header"><cf_get_lang dictionary_id='34137.Hesaplanan'> <cf_get_lang dictionary_id='57639.KDV'></cfsavecontent>
                <cf_seperator id="spr7" header="#header#">
                <!--- prepare --->
                <cfif not isDefined("attributes.beyanname.manuel.hesaplanan_kdv.rows")>
                    <cfset attributes.beyanname.manuel.hesaplanan_kdv.rows = {}>
                </cfif>
                <cfif not isDefined("attributes.form_submited")>
                    <cfset query_muhasebe_hesaplanan_kdv = kdv_beyan.get_muhasebe_hesaplanan_kdv( sal_mon: attributes.sal_mon, sal_year: attributes.sal_year )>
                    <cfset row_2 = 1>
                    <cfloop query="query_muhasebe_hesaplanan_kdv">
                        <cfset attributes.beyanname.manuel.hesaplanan_kdv.rows["row"&#row_2#] = {
                            kod: query_muhasebe_hesaplanan_kdv.ACCOUNT_ID,
                            hesap_adi: query_muhasebe_hesaplanan_kdv.ACCOUNT_NAME,
                            vergi: tlformat( query_muhasebe_hesaplanan_kdv.KDV, 2 ),
                            kdv_oran: query_muhasebe_hesaplanan_kdv.TAX,
                            matrah: tlformat( query_muhasebe_hesaplanan_kdv.MATRAH, 2 ),
                            islem_sayisi: query_muhasebe_hesaplanan_kdv.MIKTAR
                        }>
                        <cfset row_2++>
                    </cfloop>
                    <cfset attributes.beyanname.manuel.hesaplanan_kdv.total = {
                        vergi: tlformat( query_muhasebe_hesaplanan_kdv.recordCount ? arrayReduce( valueArray( query_muhasebe_hesaplanan_kdv, "KDV" ), _reduceflatten ) : 0, 2 ),
                        matrah: tlformat( query_muhasebe_hesaplanan_kdv.recordCount ? arrayReduce( valueArray( query_muhasebe_hesaplanan_kdv, "MATRAH" ), _reduceflatten ) : 0, 2 ),
                        islem_sayisi: query_muhasebe_hesaplanan_kdv.recordCount ? arrayReduce( valueArray( query_muhasebe_hesaplanan_kdv, "MIKTAR" ), _reduceflatten ) : 0
                    }>
                <cfelse>
                    <cfloop collection="#attributes.beyanname.manuel.hesaplanan_kdv.rows#" item="di">
                        <cfif len(attributes.beyanname.manuel.hesaplanan_kdv.rows[di].kdv_oran) and attributes.beyanname.manuel.hesaplanan_kdv.rows[di].kdv_oran neq "0" and len(attributes.beyanname.manuel.hesaplanan_kdv.rows[di].vergi)>
                            <cfset attributes.beyanname.manuel.hesaplanan_kdv.rows[di].matrah = tlformat( 100 * filternum( attributes.beyanname.manuel.hesaplanan_kdv.rows[di].vergi, 2 ) / attributes.beyanname.manuel.hesaplanan_kdv.rows[di].kdv_oran, 2 )>
                        <cfelse>
                            <cfset attributes.beyanname.manuel.hesaplanan_kdv.rows[di].matrah = 0>
                        </cfif>
                    </cfloop>
                    <cffunction name="_hesaplanankdvvergi">
                        <cfargument name="key">
                        <cfreturn filternum( attributes.beyanname.manuel.hesaplanan_kdv.rows[key].vergi, 2)>
                    </cffunction>
                    <cffunction name="_hesaplanankdvmatrah">
                        <cfargument name="key">
                        <cfreturn filternum( attributes.beyanname.manuel.hesaplanan_kdv.rows[key].matrah, 2 )>
                    </cffunction>
                    <cffunction name="_hesaplanankdvislem_sayisi">
                        <cfargument name="key">
                        <cfreturn attributes.beyanname.manuel.hesaplanan_kdv.rows[key].islem_sayisi>
                    </cffunction>
                    <cfset control2=arrayReduce( arrayMap( structKeyArray(attributes.beyanname.manuel.hesaplanan_kdv.rows), _hesaplanankdvvergi ), _reduceflatten )>
                    <cfif isdefined("control2") and len(control)>
                        <cfset attributes.beyanname.manuel.hesaplanan_kdv.total = {
                            vergi: tlformat( arrayReduce( arrayMap( structKeyArray(attributes.beyanname.manuel.hesaplanan_kdv.rows), _hesaplanankdvvergi ), _reduceflatten ) , 2 ),
                            matrah: tlformat( arrayReduce( arrayMap( structKeyArray(attributes.beyanname.manuel.hesaplanan_kdv.rows), _hesaplanankdvmatrah ), _reduceflatten ) , 2 ),
                            islem_sayisi: arrayReduce( arrayMap( structKeyArray(attributes.beyanname.manuel.hesaplanan_kdv.rows), _hesaplanankdvislem_sayisi ), _reduceflatten )
                        }>
                    <cfelse>
                        <cfset attributes.beyanname.manuel.hesaplanan_kdv.total = {
                            vergi: tlformat( 0 , 2 ),
                            matrah: tlformat( 0 , 2 ),
                            islem_sayisi: 0
                        }>
                    </cfif>
                </cfif>
                <!--- end prepare --->
                <cf_grid_list id="spr7">
                    <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='58585.Kod'></th>
                            <th><cf_get_lang dictionary_id='55271.Hesap Adı'></th>
                            <th style="width: 50px;"><cf_get_lang dictionary_id='42533.KDV Oran'></th>
                            <th><cf_get_lang dictionary_id='53332.Vergi'></th>
                            <th><cf_get_lang dictionary_id='60714.Matrah'></th>
                            <th><cf_get_lang dictionary_id='54855.İşlem Sayısı'></th>
                        </tr>
                    </thead>
                    <tbody data-compute="col_hk">
                        <cfoutput>
                            <cfset currentRow = 1>
                            <cfloop collection="#attributes.beyanname.manuel.hesaplanan_kdv.rows#" item="di">
                            <tr data-compute="hk#currentRow#">
                                <td>
                                    <input type="hidden" name="beyanname.manuel.hesaplanan_kdv.rows.row#currentRow#.kod" value="#attributes.beyanname.manuel.hesaplanan_kdv.rows[di].kod#">
                                    #attributes.beyanname.manuel.hesaplanan_kdv.rows[di].kod#
                                </td>
                                <td>
                                    <input type="hidden" name="beyanname.manuel.hesaplanan_kdv.rows.row#currentRow#.hesap_adi" value="#attributes.beyanname.manuel.hesaplanan_kdv.rows[di].hesap_adi#">
                                    #attributes.beyanname.manuel.hesaplanan_kdv.rows[di].hesap_adi#
                                </td>
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="beyanname.manuel.hesaplanan_kdv.rows.row#currentRow#.kdv_oran" value="#attributes.beyanname.manuel.hesaplanan_kdv.rows[di].kdv_oran#" style="width: 100%; text-align: right;" data-compute-item="row#currentRow#_kdv_oran">
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="beyanname.manuel.hesaplanan_kdv.rows.row#currentRow#.vergi" value="#attributes.beyanname.manuel.hesaplanan_kdv.rows[di].vergi#" style="width: 100%; text-align: right;" data-compute-item="row#currentRow#_vergi" readonly>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="beyanname.manuel.hesaplanan_kdv.rows.row#currentRow#.matrah" value="#attributes.beyanname.manuel.hesaplanan_kdv.rows[di].matrah#" style="width: 100%; text-align: right;" data-compute-item="row#currentRow#_matrah" data-compute-formula="100 * parseFloat($('[data-compute=hk#currentRow#] [data-compute-item=row#currentRow#_vergi]').val().replace('.', '').replace(',','.')) / parseFloat($('[data-compute=hk#currentRow#] [data-compute-item=row#currentRow#_kdv_oran]').val())" data-compute-id="hk#currentRow#" readonly>
                                    </div>
                                </td>
                                <td style="text-align: right;">
                                    <input type="hidden" name="beyanname.manuel.hesaplanan_kdv.rows.row#currentRow#.islem_sayisi" value="#attributes.beyanname.manuel.hesaplanan_kdv.rows[di].islem_sayisi#">
                                    #attributes.beyanname.manuel.hesaplanan_kdv.rows[di].islem_sayisi#
                                </td>
                            </tr>
                            <cfset currentRow++>
                            </cfloop>
                            <tr>
                                <td colspan="3" style="text-align: right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                <td style="text-align: right;"><cfoutput>#attributes.beyanname.manuel.hesaplanan_kdv.total.vergi#</cfoutput></td>
                                <td>
                                    <div class="form-group">
                                        <cfoutput><input type="text" value="#attributes.beyanname.manuel.hesaplanan_kdv.total.matrah#" style="text-align: right; width: 100%;" data-compute-id="col_hk" data-compute-formula="$('[data-compute=col_hk] [data-compute-item*=_matrah]').toArray().reduce(function(acc, elm) { return acc + parseFloat($(elm).val().replace('.','').replace(',','.')) }, 0)"></cfoutput>
                                    </div>
                                </td>
                                <td style="text-align: right;"><cfoutput>#attributes.beyanname.manuel.hesaplanan_kdv.total.islem_sayisi#</cfoutput></td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </cf_grid_list>
            </div>
        </cf_tab>
        
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <div class="ui-form-list-btn">
                <cf_workcube_buttons>
            </div>
        </div>
    
    </cfform>
</cf_box>
</div>
<script type="text/javascript">
    function onDonemChange(elm) {
        if ($(elm).val() === "1") {
            $("#donem_ay").show();
            $("#donem_period").hide();
        } else {
            $("#donem_ay").hide();
            $("#donem_period").show();
        }
    }

    $('[data-compute-item]').change(function() {
        var containers = $(this).parents('[data-compute]');
        $(containers).each(function(idx, container) {
            var formula = $(container).find('[data-compute-id="' + $(container).attr("data-compute") + '"]').attr("data-compute-formula");
            $(container).find('[data-compute-id="' + $(container).attr("data-compute") + '"]').val( commaSplit( eval(formula) ) );
            console.log($(container).find('[data-compute-id="' + $(container).attr("data-compute") + '"]'));
        });
    })
</script>
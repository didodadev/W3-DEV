<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = date_add('d',-3,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>	
</cfif>
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.target_pos" default="">
<cfif fusebox.circuit is "retail">
	<cfinclude template="../../../../V16/pos/query/get_branch.cfm">
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../../../../V16/pos/query/get_sales_imports.cfm">
<cfelse>
	<cfset get_sales_imports.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_sales_imports.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="header_">
	<cfif fusebox.circuit is 'store'>
	Satış İmport
	<cfelseif fusebox.circuit is 'retail'>
	Satış İmport
	</cfif>
</cfsavecontent>
<cfform name="search_form" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.list_sales_import">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
    <cf_big_list_search title="#header_#"> 
        <cf_big_list_search_area>
            <table>
                <tr>
                    <td></td>
                    <td>
                        <select name="target_pos" id="target_pos" style="width:75px;">
                            <option value="">Format</option>
                            <option value="-1" <cfif attributes.target_pos eq -1>selected</cfif>>Genius</option>
                            <option value="-2" <cfif attributes.target_pos eq -2>selected</cfif>>Inter</option>
                            <option value="-3" <cfif attributes.target_pos eq -3>selected</cfif>>N C R</option>
                            <option value="-4" <cfif attributes.target_pos eq -4>selected</cfif>>Workcube</option>
                            <option value="-6" <cfif attributes.target_pos eq -6>selected</cfif>>ESPOS</option>
							<option value="-8" <cfif attributes.target_pos eq -8>selected</cfif>>Wincor Nixdorf</option>
                        </select>
                    </td>
                    <cfif not fusebox.circuit is "store">
                        <td><select name="branch_id" id="branch_id" style="width:150px;">
                                <option value="">Tüm Şubeler</option>
                                <cfoutput query="get_branch">
                                    <option value="#branch_id#"<cfif attributes.branch_id eq branch_id> selected</cfif>>#branch_name#</option>
                                </cfoutput>
                            </select>
                        </td>
                    </cfif>
                    <td>
                        <cfsavecontent variable="message">Başlangıç</cfsavecontent>
                        <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <cf_wrk_date_image date_field="startdate">
                    </td>
                    <td>
                        <cfsavecontent variable="message">Bitiş</cfsavecontent>
                        <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <cf_wrk_date_image date_field="finishdate">
                    </td>
                    <td>
                        <cfsavecontent variable="message">Sayi_Hatasi_Mesaj</cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" required="yes" message="#message#" range="1,250" style="width:25px;">
                    </td>
                    <td><cf_wrk_search_button search_function='search_kontrol()'></td>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>
</cfform>
<cf_big_list> 
    <thead>
        <tr>
            <th width="180" nowrap="nowrap">Şube/Depo</th>
            <th width="180">Açıklama</th>
            <th width="65">Belge</th>
            <th width="80" nowrap="nowrap">Format</th>
            <th style="text-align:right;" width="80">Tutar</th>
            <th style="text-align:right;" width="80">KDV Tutar</th>
            <th width="65" nowrap="nowrap">Tarih</th>
            <th width="50">Aktarım</th>
            <th width="80" colspan="2">Hatalar</th>
            <th width="110" nowrap="nowrap">Kaydeden</th>
            <th width="120">Kayıt Tarihi</th>
            <th class="header_icn_none"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_form_import_sales_cards&department_id=#listfirst(session.ep.user_location,"-")#</cfoutput>','medium','pos_islem');"><img src="/images/plus_list.gif" title="Ekle"></a></th>
        </tr> 
    </thead>
    <tbody>
        <cfset invoice_id_list = ''>
        <cfif get_sales_imports.recordcount>
            <cfoutput query="get_sales_imports" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <cfif len(invoice_id)>
                    <cfset invoice_id_list = ListAppend(invoice_id_list,invoice_id,',')>
                </cfif>
            </cfoutput>
            <cfset invoice_id_list = listsort(invoice_id_list,'numeric','ASC',',')>
            <cfif len(invoice_id_list)>
                <cfquery name="get_invoice_amounts" datasource="#dsn2#">
                    SELECT NETTOTAL,INVOICE_ID,TAXTOTAL FROM INVOICE WHERE INVOICE_ID IN (#invoice_id_list#) ORDER BY INVOICE_ID
                </cfquery>
                <!--- 20050429 listeye yeniden atiyoruz ki altta bu listeden find edecegiz faturayi ve bulmazsak satiri bos gececegiz --->
                <cfset invoice_id_list = listsort(valuelist(get_invoice_amounts.invoice_id,','),'numeric','ASC',',')>
            </cfif>
            <cfoutput query="get_sales_imports" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td>#branch_name# - #Department_head#</td>
                    <td><cfif len(get_sales_imports.import_detail)>#get_sales_imports.import_detail#</cfif></td>
                    <td align="right" style="text-align:right;">
                        <cf_get_server_file output_file="store/#file_name#" output_server="#file_server_id#" output_type="2" small_image="/images/attach.gif" image_link="2">
                        #round(file_size/1024)#Kb.
                    </td>
                <td><cfif source_system eq -1>Genius<cfelseif source_system eq -2>Inter<cfelseif source_system eq -3>N C R<cfelseif source_system eq -4>Workcube<cfelseif source_system eq -6>ESPOS<cfelseif source_system eq -8>Wincor Nixdorf<cfelse>Bilinmiyor</cfif></td>
                <td align="right" style="text-align:right;">
                    <cfif len(invoice_id)>
                        <cfif listfind(invoice_id_list,invoice_id,',')>#TLFormat(get_invoice_amounts.nettotal[listfind(invoice_id_list,invoice_id,',')],2)#</cfif>
                    </cfif>
                </td>
                <td align="right" style="text-align:right;">
                    <cfif len(invoice_id)>
                        <cfif listfind(invoice_id_list,invoice_id,',')>#TLFormat(get_invoice_amounts.taxtotal[listfind(invoice_id_list,invoice_id,',')],2)#</cfif>
                    </cfif>
                </td>
                <td>#dateformat(startdate,"dd/mm/yyyy")#</td>
                <td style="text-align:right;">#product_count#</td>
                <td style="text-align:right;" width="90">
					<cfif imported and isnumeric(problems_count) and (problems_count gt 0)>#problems_count#</cfif>
                </td>
                <td>
                	<cfif imported and isnumeric(problems_count) and (problems_count gt 0)>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_match_products&i_id=#i_id#','list');">
                            <img src="/images/plus_thin.gif" align="absmiddle">
                        </a>
                    </cfif>
                </td>
                <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
                <td>#dateformat(date_add("h",session.ep.time_zone,record_date),"dd/mm/yyyy")# (#timeformat(date_add("h",session.ep.time_zone,record_date),"HH:MM")#)</td>
                <td align="center" nowrap="nowrap">
                    <cfif not imported>					
                        <a href="javascript://" onClick="if (confirm('Satış İmport Belgesini Silme İşlemini Geri Alamazsınız !\n Emin misiniz ?')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_sale_import&i_id=#i_id#','small');"><img src="/images/delete.gif" title="İmportları Sil"></a>
                        <cfif source_system neq -4><!--- Belge tipi Workcube disindakiler --->
                            <a href="javascript://" onClick="if (confirm('Satış Belgesini İşletmek İstediğinizden Emin misiniz ?\n')) windowopen('#request.self#?fuseaction=retail.emptypopupflush_import_sales_cards&i_id=#i_id#','small');"><img src="/images/cubexport.gif" title="İmport Et"></a>
                        <!---Workcube formatı tam olarak düzenlendiğinde 
                         <cfelse>
                            <a href="javascript://" onClick="if (confirm('Workcube Satış Belgesini İşletmek İstediğinizden Emin misiniz ?\n')) windowopen('#request.self#?fuseaction=objects.emptypopupflush_import_sales_cards_workcube&i_id=#i_id#','small');"><img src="/images/cubexport.gif" alt="<cfif fusebox.circuit is 'store'><cf_get_lang no='339.İmport Et'><cfelseif fusebox.circuit is 'pos'><cf_get_lang no='35.İmport Et'></cfif>" border="0" align="absmiddle"></a> --->
                        </cfif>
                    <cfelse>
                        <cfsavecontent variable="message">Satış İmport Belgesinden Dolayı Yapılan Hareketleri Geri Alıyorsunuz! Tekrar Dosyayı İşletmeniz Gerekecektir !Emin misiniz</cfsavecontent>
                        <a href="javascript://" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_sale_import&invoice_id=#invoice_id#&just_actions=1','small');">
                        <img src="/images/close.gif" title="Sadece Hareketleri Sil"></a>
                        <cfsavecontent variable="message">İşletilmiş Belgeyi Silerseniz Belgenin Oluşturduğu Stok Hareketlerini Kaybedersiniz ! Emin misiniz </cfsavecontent>
                        <a href="javascript://" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_sale_import&invoice_id=#invoice_id#','small','emptypopup_del_sale_import');">
                        <img src="/images/delete.gif" title="İmportları Sil"></a>
                        <img src="/images/control.gif" title="Aktarıldı">
                        <cfif listgetat(session.ep.user_level,50) and is_muhasebe is not '1' and (dateformat(startdate,'yyyy-mm-dd') gte session.ep.period_date) and (not listfindnocase(denied_pages,'pos.emptypopupflush_account_sale_import'))>
                            <cfsavecontent variable="message">Muhasebeleştirmek İstediğinizden Emin misiniz</cfsavecontent>
                            <a href="##" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=pos.emptypopupflush_account_sale_import&i_id=#i_id#&invoice_id=#invoice_id#','small');"><img src="/images/extre.gif" title="Muhasebeleştir"></a>
                        </cfif>
                    </cfif>
                </td>
            </tr>
        </cfoutput>
        <cfelse>
            <tr>
                <td colspan="13"><cfif isdefined("attributes.form_submitted")>Kayıt Bulunamadı !<cfelse>Filtre Ediniz !</cfif></td>
            </tr>
        </cfif>
    </tbody>
</cf_big_list> 
<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
    <cfset url_string = ''>
    <cfif len(attributes.target_pos)>
        <cfset url_string = '#url_string#&target_pos=#attributes.target_pos#'>
    </cfif>
    <cfif len(attributes.startdate)>
        <cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,"dd/mm/yyyy")#'>
    </cfif>
    <cfif len(attributes.finishdate)>
        <cfset url_string = '#url_string#&finishdate=#dateformat(attributes.finishdate,"dd/mm/yyyy")#'>
    </cfif>
    <cfif len(attributes.branch_id)>
        <cfset url_string = '#url_string#&branch_id=#attributes.branch_id#'>
    </cfif>
    <cfif isdefined("attributes.form_submitted")>
        <cfset url_string = '#url_string#&form_submitted=#attributes.form_submitted#'>
    </cfif>		
    <table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
        <tr>
            <td>
                <cf_pages page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="pos.list_sales_import#url_string#">
            </td>
            <!-- sil -->
            <td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
            <!-- sil -->
        </tr>
    </table>
</cfif>
<script type="text/javascript">
function search_kontrol()
{
	if ((search_form.startdate.value != "") && (search_form.finishdate.value != ""))
		return date_check(search_form.startdate,search_form.finishdate,"<cf_get_lang_main no ='394.Bitiş Tarihi Başlangıç Tarihinden Küçük'> !");
			return true;
}
</script>
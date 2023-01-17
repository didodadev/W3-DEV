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
<cfif fusebox.circuit is "pos">
	<cfinclude template="../query/get_branch.cfm">
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_sales_imports.cfm">
<cfelse>
	<cfset get_sales_imports.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_sales_imports.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_form" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.list_sales_import">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search more="0"> 
                <div class="form-group">
                    <select name="target_pos" id="target_pos" style="width:75px;">
                        <option value=""><cf_get_lang dictionary_id='58594.format'></option>
                        <option value="-1" <cfif attributes.target_pos eq -1>selected</cfif>><cf_get_lang dictionary_id='32843.Genius'></option>
                        <option value="-2" <cfif attributes.target_pos eq -2>selected</cfif>><cf_get_lang dictionary_id='50158.Inter'></option>
                        <option value="-3" <cfif attributes.target_pos eq -3>selected</cfif>>N C R</option>
                        <option value="-4" <cfif attributes.target_pos eq -4>selected</cfif>><cf_get_lang dictionary_id='58783.Workcube'></option>
                        <option value="-6" <cfif attributes.target_pos eq -6>selected</cfif>>ESPOS</option>
                        <option value="-8" <cfif attributes.target_pos eq -8>selected</cfif>>Wincor Nixdorf</option>
                    </select>
                </div>
                <cfif session.ep.isBranchAuthorization eq 0>
                <div class="form-group">
                    <select name="branch_id" id="branch_id" style="width:150px;">
                        <option value=""><cf_get_lang dictionary_id='29495.Tüm Şubeler'></option>
                        <cfoutput query="get_branch">
                            <option value="#branch_id#"<cfif attributes.branch_id eq branch_id> selected</cfif>>#branch_name#</option>
                        </cfoutput>
                    </select>
                </div>
                </cfif>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57501.başlangıç'></cfsavecontent>
                        <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57502.Bitiş'></cfsavecontent>
                        <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group small">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" required="yes" message="#message#" range="1,250" style="width:25px;">
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function='search_kontrol()'>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
</div>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='36039.Satış İmport'></cfsavecontent>
    <cf_box title="#header_#" uidrop="1" hide_table_column="1">
        <cf_grid_list> 
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='57453.Şube'>/<cf_get_lang dictionary_id='58763.Depo'></th>
                    <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    <th><cf_get_lang dictionary_id='57468.Belge'></th>
                    <th><cf_get_lang dictionary_id='58594.format'></th>
                    <th><cf_get_lang dictionary_id ='57673.Tutar'></th>
                    <th><cf_get_lang dictionary_id ='36067.KDV Tutar'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='36012.Aktarım'></th>
                    <th><cf_get_lang dictionary_id='36038.hatalar'></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=objects.popup_form_import_sales_cards&department_id=#listfirst(session.ep.user_location,"-")#</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
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
                        <td><cfif source_system eq -1>Genius<cfelseif source_system eq -2>Inter<cfelseif source_system eq -3>N C R<cfelseif source_system eq -4>Workcube<cfelseif source_system eq -6>ESPOS<cfelseif source_system eq -8>Wincor Nixdorf<cfelse><cf_get_lang dictionary_id ='36057.Bilinmiyor'></cfif></td>
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
                        <td>#dateformat(startdate,dateformat_style)#</td>
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
                        <td>#dateformat(date_add("h",session.ep.time_zone,record_date),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,record_date),timeformat_style)#)</td>
                        <td align="center" nowrap="nowrap">
                            <cfif not imported>
                                <a href="javascript://" onClick="if (confirm('<cf_get_lang dictionary_id='36161.Satış İmport Belgesini Silme İşlemini Geri Alamazsınız'> !\n <cf_get_lang dictionary_id='58588.Emin misiniz'> ?')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_sale_import&i_id=#i_id#','small');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='36015.İmportları Sil'>"></a>
                                <cfif source_system neq -4><!--- Belge tipi Workcube disindakiler --->
                                    <a href="javascript://" onClick="if (confirm('<cf_get_lang dictionary_id='36013.Satış Belgesini İşletmek İstediğinizden Emin misiniz'> ?\n')) windowopen('#request.self#?fuseaction=objects.emptypopupflush_import_sales_cards&i_id=#i_id#','small');"><img src="/images/cubexport.gif" title="<cf_get_lang dictionary_id='36035.İmport Et'>"></a>
                                </cfif>
                            <cfelse>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='36069.Satış İmport Belgesinden Dolayı Yapılan Hareketleri Geri Alıyorsunuz! Tekrar Dosyayı İşletmeniz Gerekecektir !Emin misiniz'></cfsavecontent>
                                <a href="javascript://" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_sale_import&invoice_id=#invoice_id#&just_actions=1','small');">
                                <img src="/images/close.gif" title="<cf_get_lang dictionary_id='36017.Sadece Hareketleri Sil'>"></a>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='36070.İşletilmiş Belgeyi Silerseniz Belgenin Oluşturduğu Stok Hareketlerini Kaybedersiniz ! Emin misiniz '></cfsavecontent>
                                <a href="javascript://" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_sale_import&invoice_id=#invoice_id#','small','emptypopup_del_sale_import');">
                                <img src="/images/delete.gif" title="<cf_get_lang dictionary_id='36015.İmportları Sil'>"></a>
                                <img src="/images/control.gif" title="<cf_get_lang dictionary_id='36034.Aktarıldı'>">
                                <cfif get_module_user(50) and is_muhasebe is not '1' and (dateformat(startdate,'yyyy-mm-dd') gte session.ep.period_date) and (not listfindnocase(denied_pages,'pos.emptypopupflush_account_sale_import'))>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='36071.Muhasebeleştirmek İstediğinizden Emin misiniz'></cfsavecontent>
                                    <a href="##" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=pos.emptypopupflush_account_sale_import&i_id=#i_id#&invoice_id=#invoice_id#','small');"><img src="/images/extre.gif" title="<cf_get_lang dictionary_id='36042.Muhasebeleştir'>"></a>
                                </cfif>
                            </cfif>
                        </td>
                    </tr>
                </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="13"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list> 
        <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
            <cfset url_string = ''>
            <cfif len(attributes.target_pos)>
                <cfset url_string = '#url_string#&target_pos=#attributes.target_pos#'>
            </cfif>
            <cfif len(attributes.startdate)>
                <cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,dateformat_style)#'>
            </cfif>
            <cfif len(attributes.finishdate)>
                <cfset url_string = '#url_string#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#'>
            </cfif>
            <cfif len(attributes.branch_id)>
                <cfset url_string = '#url_string#&branch_id=#attributes.branch_id#'>
            </cfif>
            <cfif isdefined("attributes.form_submitted")>
                <cfset url_string = '#url_string#&form_submitted=#attributes.form_submitted#'>
            </cfif>		
            <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="pos.list_sales_import#url_string#">
            
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">
function search_kontrol()
{
	if ((search_form.startdate.value != "") && (search_form.finishdate.value != ""))
		return date_check(search_form.startdate,search_form.finishdate,"<cf_get_lang dictionary_id ='36063.Bitiş Tarihi Başlangıç Tarihinden Küçük'> !");
			return true;
}
</script>

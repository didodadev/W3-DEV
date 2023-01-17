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
<cfset import_file_type=-50>
<cfset import_process_type=-14>
<cfset invoice_id_list = "">
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_sales_imports.cfm">
<cfelse>
	<cfset get_sales_imports.recordcount=0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="#get_sales_imports.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_form" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.list_xml_import">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <select name="target_pos" id="target_pos" style="width:90px;">
                        <option value=""><cf_get_lang dictionary_id='58594.Format'></option>
                        <option value="-50" <cfif attributes.target_pos eq -50>selected</cfif>><cf_get_lang dictionary_id='57441.Fatura'></option>
                        <option value="-51" <cfif attributes.target_pos eq -51>selected</cfif>><cf_get_lang dictionary_id='57845.Tahsilat'></option>
                        <option value="-52" <cfif attributes.target_pos eq -52>selected</cfif>><cf_get_lang dictionary_id='57611.Sipariş'></option>
                        <option value="-53" <cfif attributes.target_pos eq -53>selected</cfif>><cf_get_lang dictionary_id='36155.Objects2 Ürünler'></option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="branch_id" id="branch_id">
                        <option value=""><cf_get_lang dictionary_id='29495.Tüm Şubeler'></option>
                        <cfoutput query="get_branch">
                            <option value="#branch_id#"<cfif attributes.branch_id eq branch_id> selected</cfif>>#branch_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57501.başlangıç'></cfsavecontent>
                        <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57502.Bitiş'></cfsavecontent>
                        <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" required="yes" message="#message#" range="1,250" style="width:25px;">
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function='search_kontrol()'>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='29478.XML Import'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='58594.Format'></th>
                    <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'>/<cf_get_lang dictionary_id='58763.Depo'></th>
                    <th><cf_get_lang dictionary_id='57468.Belge'></th>
                    <th><cf_get_lang dictionary_id='36012.Aktarım'></th>
                    <th><cf_get_lang dictionary_id='36038.Hatalar'></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th width="20" class="header_icn_none"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_form_xml_import&department_id=#listfirst(session.ep.user_location,"-")#</cfoutput>','medium','pos_islem');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></th><!-- sil -->
                </tr> 
            </thead>
            <tbody>
                <cfif get_sales_imports.recordcount>
                    <cfoutput query="get_sales_imports" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td align="center">#currentrow#</td>
                            <td align="center">#dateformat(startdate,dateformat_style)#</td>
                            <td><cfif SOURCE_SYSTEM eq -50>
                                    <cf_get_lang dictionary_id='57441.Fatura'>
                                <cfelseif SOURCE_SYSTEM eq -51>
                                    <cf_get_lang dictionary_id='57845.Tahsilat'>
                                <cfelseif SOURCE_SYSTEM eq -52>
                                    <cf_get_lang dictionary_id='57611.Sipariş'>
                                <cfelseif SOURCE_SYSTEM eq -53>
                                    Objects2 <cf_get_lang dictionary_id='57564.Ürünler'>
                                </cfif>
                                <!--- <cfif source_system eq -1>Genius<cfelseif source_system eq -2>Inter<cfelseif source_system eq -3>N C R<cfelseif source_system eq -4>Workcube<cfelse><cf_get_lang no ='57.Bilinmiyor'></cfif> --->
                            </td>
                            <td>#get_sales_imports.import_detail#</td>
                            <td>#branch_name#-#department_head#</td>
                            <td align="right" style="text-align:right;">
                                <cf_get_server_file output_file="pos/#file_name#" output_server="#file_server_id#" output_type="2" small_image="/images/attach.gif" image_link="2">
                                #round(file_size/1024)# Kb.
                            </td>
                            <td align="right" style="text-align:right;">#product_count#</td>
                            <td align="right" style="text-align:right;"><cfif imported and isnumeric(problems_count) and (problems_count gt 0)>#problems_count#<!--- <cfif source_system neq -1> ---><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_match_products&i_id=#i_id#','list');"><img src="/images/plus_thin.gif"></a><!--- </cfif> ---></cfif></td>
                            <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
                            <td align="center">#dateformat(date_add("h",session.ep.time_zone,record_date),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,record_date),timeformat_style)#)</td>
                            <!-- sil -->
                            <td nowrap>
                                <cfif not imported>
                                    <a href="javascript://" onClick="if (confirm('<cf_get_lang dictionary_id='36162.XML Belgesini Silme İşlemini Geri Alamazsınız'> !\n <cf_get_lang dictionary_id='58588.Emin misiniz'> ?')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_xml_import&file_id=#I_ID#','small');"><img src="/images/delete.gif" title="<cf_get_lang dictionary_id='36015.İmportları Sil'>"></a>
                                    <a href="javascript://" onClick="if (confirm('<cf_get_lang dictionary_id='36163.XML Belgesini İşletmek İstediğinizden Emin misiniz'> ?\n')) windowopen('#request.self#?fuseaction=objects.emptypopupflush_xml_import&file_id=#i_id#','small');"><img src="/images/cubexport.gif" title="<cf_get_lang dictionary_id='36035.İmport Et'>"></a>
                                    <cfif SOURCE_SYSTEM eq -53>
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_xml_stocks_row&file_id=#i_id#','wwide');"><img src="../../images/transfer.gif"></a>
                                    </cfif>
                                <cfelse>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='36066.XML İmport Belgesinden Dolayı Yapılan Hareketleri Geri Alıyorsunuz! Tekrar Dosyayı İşletmeniz Gerekecektir! Emin misiniz'></cfsavecontent>
                                    <a href="javascript://" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_xml_import','small');">
                                    <img src="/images/close.gif" title="<cf_get_lang dictionary_id='36017.Sadece Hareketleri Sil'>"></a>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='36064.İşletilmiş Belgeyi Silerseniz Belgenin Oluşturduğu Stok Hareketlerini Kaybedersiniz! Emin misiniz'></cfsavecontent>
                                    <a href="javascript://" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_xml_import','small','emptypopup_del_sale_import');">
                                    <i class="fa fa-minus" title="<cf_get_lang dictionary_id='36015.İmportları Sil'>"></a>
                                    <img src="/images/control.gif" title="<cf_get_lang dictionary_id='36034.Aktarıldı'>">
                                </cfif>
                            </td>
                            <!-- sil -->
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="13"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
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
            adres="pos.list_xml_import#url_string#">
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

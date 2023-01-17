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
<cfif fusebox.circuit is "extra" or fusebox.circuit is "retail">
	<cfinclude template="../../../../V16/pos/query/get_branch.cfm">
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_SALES_IMPORTS" datasource="#DSN#">
        SELECT
            FI.*,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            B.BRANCH_ID,
            B.BRANCH_NAME,
            D.DEPARTMENT_HEAD
        FROM
            #dsn2_alias#.FILE_IMPORTS AS FI,
            EMPLOYEES E,
            DEPARTMENT D,
            BRANCH B
        WHERE
        <cfif isdefined('import_process_type') and len(import_process_type)>
            FI.PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#import_process_type#"> AND
        <cfelse>
            FI.PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="-2"> AND<!--- satis --->
        </cfif>
        <cfif len(attributes.startdate) and (not len(attributes.finishdate))>
            FI.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
        <cfelseif len(attributes.finishdate)  and (not len(attributes.startdate))>
            FI.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
        <cfelseif len(attributes.startdate) and len(attributes.finishdate)>
            FI.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
            FI.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
        </cfif>
        <cfif fusebox.circuit is "store">
            D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#"> AND
        </cfif>
        <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
            B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND
        </cfif>
        <cfif isdefined("attributes.target_pos") and len(attributes.target_pos)>
            FI.SOURCE_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.target_pos#"> AND
        </cfif>
            FI.DEPARTMENT_ID = D.DEPARTMENT_ID AND
            B.BRANCH_ID = D.BRANCH_ID AND
            FI.RECORD_EMP = E.EMPLOYEE_ID AND
            <!--- yetkili oldugu subelerin gelmesi icin eklendi BK 20090609 --->
            B.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
        ORDER BY
            FI.IMPORTED,
            FI.RECORD_DATE DESC
    </cfquery>
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
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_form" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.list_sales_import">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search more="0">
                <div class="form-group">
                    <select name="target_pos" id="target_pos" style="width:75px;">
                        <option value=""><cf_get_lang dictionary_id='58594.Format'></option>
                        <option value="-1" <cfif attributes.target_pos eq -1>selected</cfif>><cf_get_lang dictionary_id='32843.Genius'></option>
                        <option value="-2" <cfif attributes.target_pos eq -2>selected</cfif>><cf_get_lang dictionary_id='50158.Inter'></option>
                        <option value="-3" <cfif attributes.target_pos eq -3>selected</cfif>>N C R</option>
                        <option value="-4" <cfif attributes.target_pos eq -4>selected</cfif>><cf_get_lang dictionary_id='58783.Workcube'></option>
                        <option value="-6" <cfif attributes.target_pos eq -6>selected</cfif>>ESPOS</option>
                        <option value="-8" <cfif attributes.target_pos eq -8>selected</cfif>>Wincor Nixdorf</option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="branch_id" id="branch_id" style="width:150px;">
                        <option value=""><cf_get_lang dictionary_id='29495.Tüm Şubeler'></option>
                        <cfoutput query="get_branch">
                            <option value="#branch_id#"<cfif attributes.branch_id eq branch_id> selected</cfif>>#branch_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57501.Başlangıç'></cfsavecontent>
                        <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57502.Bitiş'></cfsavecontent>
                        <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                    </div>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" required="yes" message="#message#" range="1,250" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function='search_kontrol()'>
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=retail.list_sales_import&event=add&department_id=#listfirst(session.ep.user_location,"-")#</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a>
                </div>
            </cf_box_search>    
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Kasa Satışları Import',62542)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th nowrap="nowrap"><cf_get_lang dictionary_id='61464.Şube/Depo'></th>
                    <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    <th ><cf_get_lang dictionary_id='57468.Belge'></th>
                    <th nowrap="nowrap"><cf_get_lang dictionary_id='58594.Format'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='35553.KDV Tutar'></th>
                    <th nowrap="nowrap"><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='36012.Aktarım'></th>
                    <th colspan="2"><cf_get_lang dictionary_id='45838.Hatalar'></th>
                    <th nowrap="nowrap"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th width="20" class="header_icn_none text-center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=retail.list_sales_import&event=add&department_id=#listfirst(session.ep.user_location,"-")#</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a></th>
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
                        <td><cfif source_system eq -1><cf_get_lang dictionary_id='32843.Genius'><cfelseif source_system eq -2><cf_get_lang dictionary_id='50158.Inter'><cfelseif source_system eq -3>N C R<cfelseif source_system eq -4><cf_get_lang dictionary_id='58783.Workcube'><cfelseif source_system eq -6>ESPOS<cfelseif source_system eq -8>Wincor Nixdorf<cfelse><cf_get_lang dictionary_id='36057.Bilinmiyor'></cfif></td>
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
                                    <i class="fa fa-plus" align="absmiddle"></i>
                                </a>
                            </cfif>
                        </td>
                        <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
                        <td>#dateformat(date_add("h",session.ep.time_zone,record_date),"dd/mm/yyyy")# (#timeformat(date_add("h",session.ep.time_zone,record_date),"HH:MM")#)</td>
                        <td align="center" nowrap="nowrap">
                            <!---
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.sales_import_other_invoice_other&i_id=#i_id#','list');"><img src="/images/senet.gif" title="Gider Pusulası Oluştur"></a>
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.sales_import_other&i_id=#i_id#','list');"><img src="/images/notkalem.gif" title="Fatura Oluştur"></a>
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.sales_import_other_ship&i_id=#i_id#','list');"><img src="/images/ship.gif" title="İrsaliye Oluştur"></a>
                            --->
                                <cfif IS_TRANSFER neq 1>
                                    <a href="javascript://" onClick="if (confirm('Satış Belgesini Dönüştürmek İstediğinizden Emin misiniz ?\n')) windowopen('#request.self#?fuseaction=retail.list_sales_import&event=transfer&i_id=#i_id#','small');"><i class="fa fa-exchange" title="<cf_get_lang dictionary_id='58068.Dönüştür'>"></i></a>
                                </cfif>
                            <!---
                            <cfif not imported>					
                                <a href="javascript://" onClick="if (confirm('Satış İmport Belgesini Silme İşlemini Geri Alamazsınız !\n Emin misiniz ?')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_sale_import&i_id=#i_id#','small');"><img src="/images/delete.gif" title="İmportları Sil"></a>
                                <cfif source_system neq -4><!--- Belge tipi Workcube disindakiler --->
                                    <!--- <a href="javascript://" onClick="if (confirm('Satış Belgesini İşletmek İstediğinizden Emin misiniz ?\n')) windowopen('#request.self#?fuseaction=retail.emptypopupflush_import_sales_cards&i_id=#i_id#','small');"><img src="/images/cubexport.gif" title="İmport Et"></a> --->
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
                            --->
                        </td>
                    </tr>
                </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="13"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
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
		return date_check(search_form.startdate,search_form.finishdate,"<cf_get_lang_main no ='394.Bitiş Tarihi Başlangıç Tarihinden Küçük'> !");
			return true;
}
</script>
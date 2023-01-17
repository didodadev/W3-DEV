<cf_get_lang_set module_name="pos">
<cfif isdefined("attributes.start_date") and len(attributes.start_date) and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfset attributes.start_date = date_add('d',-1,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date) and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfset attributes.finish_date = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>	
</cfif>
<cfinclude template="../../pos/query/get_price_change_import.cfm">
<cfif fusebox.circuit is not "store">
	<cfinclude template="../../pos/query/get_branch.cfm">
</cfif>
<cfif get_stock_imports.recordcount>
	<cfinclude template="../../pos/query/get_department.cfm">
	<cfset department_list=listsort(listdeleteduplicates(ValueList(GET_DEPARTMENT.DEPARTMENT_ID,',')),'numeric','ASC',',')>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_stock_imports.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.target_pos" default="">
<cfsavecontent variable="header_">
	<cfif fusebox.circuit is 'store'>
		<cf_get_lang_main no ='1313.Fiyat Değişim Import'>
	<cfelseif fusebox.circuit is 'pos' or fusebox.circuit is 'retail'>
		<cf_get_lang_main no ='1313.Fiyat Değişim Import'>
	</cfif>
</cfsavecontent>
<cfform name="search_form" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.list_price_change_import">
    <cf_big_list_search title="#header_#"> 
        <cf_big_list_search_area>
            <table>
                <tr>
                    <td><cf_get_lang_main no='48.Filtre'></td>
                <cfif not fusebox.circuit is "store">
                    <td>
                        <select name="branch_id" id="branch_id">
                            <option value=""><cfif fusebox.circuit is 'store'><cf_get_lang_main no='1698.Tüm Şubeler'><cfelseif fusebox.circuit is 'pos'><cf_get_lang_main no='1698.Tüm Şubeler'></cfif></option>
                            <cfoutput query="get_branch">
                                <option value="#branch_id#"<cfif attributes.branch_id eq branch_id> selected</cfif>>#branch_name#</option>
                            </cfoutput>
                        </select>
                    </td>
                </cfif>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='326.Baslangic Tarihi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <cf_wrk_date_image date_field="start_date">
                    </td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='327.Bitis Tarihi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <cf_wrk_date_image date_field="finish_date">
                    </td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
                    </td>
                    <td><cf_wrk_search_button search_function="kontrol()"></td>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>
</cfform>
<cf_big_list> 
    <thead>
        <tr>
        	<th><cf_get_lang_main no="1165.Sıra"></th>
            <th><cf_get_lang_main no='41.Şube'>/ <cfif fusebox.circuit is 'store'><cf_get_lang no='71.Depo'><cfelseif fusebox.circuit is 'pos' or fusebox.circuit is 'retail'><cf_get_lang_main no='1351.Depo'></cfif></th>
            <th width="40"><cfif fusebox.circuit is 'store'><cf_get_lang no='92.Format'><cfelseif fusebox.circuit is 'pos' or fusebox.circuit is 'retail'><cf_get_lang_main no='1182.Format'></cfif></th>
            <th width="65"><cf_get_lang_main no='56.Belge'></th>
            <th><cf_get_lang_main no='371.Problemli Kayıtlar'></th>
            <th width="200"><cfif fusebox.circuit is 'store'><cf_get_lang no='95.Kaydeden'><cfelseif fusebox.circuit is 'pos' or fusebox.circuit is 'retail'><cf_get_lang_main no='487.Kaydeden'></cfif></th>
            <th width="100"><cf_get_lang_main no='215.Kayıt Tarihi'></th>
            <th class="header_icn_none">
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_form_import_price_change<cfif fusebox.circuit is "store">&department_id=#listfirst(session.ep.user_location,"-")#&is_branch=1</cfif></cfoutput>','medium','pos_islem');"><img src="/images/plus_list.gif" title="<cfif fusebox.circuit is 'store'><cf_get_lang no='113.Eksport Ekle'><cfelseif fusebox.circuit is 'pos'><cf_get_lang no='43.Eksport Ekle'></cfif>"></a>
            </th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="get_stock_imports" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr>
            	<td>#currentrow#</td>
                <td>#get_department.branch_name[listfind(department_list,department_id,',')]#/#get_department.department_head[listfind(department_list,department_id,',')]#</td>
                <td><cfif SOURCE_SYSTEM eq -4><cf_get_lang_main no="1371.Workcube"><cfelse><cf_get_lang no ='57.Bilinmiyor'></cfif></td>
                <td><a href="#file_web_path#store#dir_seperator##file_name#"><img src="/images/attach.gif"></a><cfif len(FILE_SIZE)>#round(FILE_SIZE/1024)#Kb.</cfif></td>
                <td><cfif problems_count gt 0><a href="#file_web_path#store#dir_seperator##PROBLEMS_FILE_NAME#">#problems_count# <img src="/images/attach.gif"></a><cfelse> - </cfif></td>
                <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
                <td>#dateformat(date_add("h",session.ep.time_zone,record_Date),"dd/mm/yyyy")# (#timeformat(date_add("h",session.ep.time_zone,record_Date),"HH:MM")#)</td>
                <td align="center" nowrap width="45">
                    <cfif not imported>					
                        <a href="javascript://" onClick="if (confirm('Fiyat Değişim İmport Belgesini Silme İşlemini Geri Alamazsınız !\nEmin misiniz ?')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_file_price_change_import&i_id=#I_ID#','small');"><img src="/images/delete.gif" title="<cfif fusebox.circuit is 'store'><cf_get_lang no='323.İmportları Sil'><cfelseif fusebox.circuit is 'pos'><cf_get_lang no='15.İmportları Sil'></cfif>"></a>
                    </cfif>
                </td>
            </tr>
        </cfoutput>
        <cfif not get_stock_imports.recordcount>
            <tr>
                <td colspan="9"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
            </tr>
        </cfif>
    </tbody>
</cf_big_list>
    <cfset url_string = ''>
    <cfif isdefined("attributes.target_pos") and len(attributes.target_pos)>
        <cfset url_string = '#url_string#&target_pos=#attributes.target_pos#'>
    </cfif>
    <cfif isdefined("attributes.start_date") and len(attributes.start_date)>
        <cfset url_string = '#url_string#&start_date=#dateformat(attributes.start_date,"dd/mm/yyyy")#'>
    </cfif>
    <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
        <cfset url_string = '#url_string#&finish_date=#dateformat(attributes.finish_date,"dd/mm/yyyy")#'>
    </cfif>
    <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
        <cfset url_string = '#url_string#&branch_id=#attributes.branch_id#'>
    </cfif>
    <cf_paging page="#attributes.page#" 
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#fusebox.circuit#.list_price_change_import#url_string#">
<script type="text/javascript">
function kontrol()
{
	return date_check(document.search_form.start_date,document.search_form.finish_date,"<cf_get_lang no ='63.Bitiş Tarihi Başlangıç Tarihinden Küçük'> !");
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
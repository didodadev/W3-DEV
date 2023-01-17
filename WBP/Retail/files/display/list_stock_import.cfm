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
<cfinclude template="../../pos/query/get_file_stock_imports.cfm">
<cfif fusebox.circuit is not "store">
	<cfinclude template="../../pos/query/get_branch.cfm">
</cfif>
<cfif get_stock_imports.recordcount>
	<cfinclude template="../../pos/query/get_department.cfm">
	<cfset department_list=listsort(listdeleteduplicates(ValueList(get_department.department_id,',')),'numeric','ASC',',')>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_stock_imports.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.target_pos" default="">
<cfsavecontent variable="header_">
	<cfif fusebox.circuit is 'store'>
		<cf_get_lang no='129.Stok Import'>
	<cfelseif fusebox.circuit is 'pos'>
		<cf_get_lang no='45.Stok Import'>
	</cfif>
</cfsavecontent>
<cf_big_list_search title="Stok İmport"> 
    <cf_big_list_search_area>
      <cfform name="search_form" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.list_stock_import">
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
                    <cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
                </td>
                <td><cf_wrk_search_button search_function="kontrol()"></td>
            </tr>
        </table>
       </cfform>
    </cf_big_list_search_area>
</cf_big_list_search>
<cf_big_list> 
<thead>
    <tr>
        <th><cf_get_lang_main no='41.Şube'>/ Depo</th>
        <th width="40">Format</th>
        <th width="65"><cf_get_lang_main no='56.Belge'></th>
        <th><cf_get_lang_main no='371.Problemli Kayıtlar'></th>
        <th width="200">Kaydeden</th>
        <th width="100"><cf_get_lang_main no='215.Kayıt Tarihi'></th>
        <th class="header_icn_none">
            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_form_add_stock_import<cfif fusebox.circuit is "store">&department_id=#listfirst(session.ep.user_location,"-")#&is_branch=1</cfif></cfoutput>','medium','pos_islem');"><img src="/images/plus_list.gif" title="<cfif fusebox.circuit is 'store'><cf_get_lang no='113.Eksport Ekle'><cfelseif fusebox.circuit is 'pos'><cf_get_lang no='43.Eksport Ekle'></cfif>"></a>
        </th>
    </tr>
</thead>
<tbody>
    <cfif get_stock_imports.recordcount>
    <cfoutput query="get_stock_imports" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
        <tr>
            <td>#get_department.branch_name[listfind(department_list,department_id,',')]#/#get_department.department_head[listfind(department_list,department_id,',')]#</td>
            <td><cfif SOURCE_SYSTEM eq -4><cf_get_lang_main no='1371.Workcube'><cfelse><cf_get_lang no ='57.Bilinmiyor'></cfif></td>
            <td><a href="#file_web_path#store#dir_seperator##file_name#"><img src="/images/attach.gif"></a><cfif len(FILE_SIZE)>#round(FILE_SIZE/1024)#Kb.</cfif></td>
            <td><cfif PROBLEMS_COUNT gt 0><a href="#file_web_path#store#dir_seperator##PROBLEMS_FILE_NAME#"><img src="/images/attach.gif"> #PROBLEMS_COUNT#</a><cfelse> - </cfif></td>
            <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
            <td>#dateformat(date_add("h",session.ep.time_zone,record_Date),"dd/mm/yyyy")# (#timeformat(date_add("h",session.ep.time_zone,record_Date),"HH:MM")#)</td>
            <td align="center" nowrap width="45">
                <cfif not imported>
                    <cfsavecontent variable="message"><cf_get_lang no ='74.Stok İmport Belgesini Silme İşlemini Geri Alamazsınız!Emin misiniz'></cfsavecontent>					
                    <cfsavecontent variable="message2"><cf_get_lang no ='75.Stok İmport Belgesini İşletmek İstediğinizden Emin misiniz'></cfsavecontent>
                    <a href="javascript://" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_file_stock_import&i_id=#I_ID#','small');"><img src="/images/delete.gif" title="<cfif fusebox.circuit is 'store'><cf_get_lang no='323.İmportları Sil'><cfelseif fusebox.circuit is 'pos'><cf_get_lang no='15.İmportları Sil'></cfif>"></a>
                    <a href="javascript://" onClick="if (confirm('#message2#')) windowopen('#request.self#?fuseaction=objects.emptypopupflush_stock_import&i_id=#I_ID#','small');"><img src="/images/cubexport.gif" title="<cfif fusebox.circuit is 'store'><cf_get_lang no='339.İmport Et'><cfelseif fusebox.circuit is 'pos'><cf_get_lang no='35.İmport Et'></cfif>"></a>
                </cfif>
            </td>
        </tr>
    </cfoutput>
    <cfelse>
        <tr class="color-row" height="20">
            <td colspan="8"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
        </tr>
    </cfif>
</tbody>
</cf_big_list> 
<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
<cfset url_string = ''>
<cfif len(attributes.target_pos)>
    <cfset url_string = '#url_string#&target_pos=#attributes.target_pos#'>
</cfif>
<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
    <cfset url_string = '#url_string#&start_date=#dateformat(attributes.start_date,"dd/mm/yyyy")#'>
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
    <cfset url_string = '#url_string#&finish_date=#dateformat(attributes.finish_date,"dd/mm/yyyy")#'>
</cfif>
<cfif len(attributes.branch_id)>
    <cfset url_string = '#url_string#&branch_id=#attributes.branch_id#'>
</cfif>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
    <tr>
        <td>
            <cf_pages page="#attributes.page#" 
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#fusebox.circuit#.list_stock_import#url_string#">
        </td>
        <!-- sil -->
        <td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
    </tr>
</table>
</cfif>
<script type="text/javascript">
function kontrol()
{
	return date_check(document.search_form.start_date,document.search_form.finish_date,"<cf_get_lang no ='63.Bitiş Tarihi Başlangıç Tarihinden Küçük'> !");
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
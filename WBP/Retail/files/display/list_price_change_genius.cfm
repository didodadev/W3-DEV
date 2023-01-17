<cf_get_lang_set module_name="pos">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfset attributes.start_date = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfset attributes.finish_date = date_add('d',+1,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
</cfif>
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.target_pos" default="">
<cfinclude template="../../pos/query/get_price_change_genius.cfm">
<cfif fusebox.circuit is not "store">
	<cfinclude template="../../pos/query/get_branch.cfm">
</cfif>
<cfif get_price_change_genius.recordcount>
	<cfinclude template="../../pos/query/get_department.cfm">
	<cfset department_list=listsort(listdeleteduplicates(ValueList(get_department.department_id,',')),'numeric','ASC',',')>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_price_change_genius.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="header_">
	<cfif fusebox.circuit is 'store'>
		<cf_get_lang no='90.Fiyat Değişim Export'>
	<cfelseif fusebox.circuit is 'pos' or fusebox.circuit is 'retail'>
		<cf_get_lang no='33.Fiyat Değişim Export'>
	</cfif>
</cfsavecontent>
<cf_big_list_search title="#header_#"> 
    <cf_big_list_search_area>
    	<cfform name="search_form" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.list_price_change_genius">
        <table>
            <tr>
                <td><cf_get_lang_main no='48.Filtre'></td>
                <td>
                    <select name="target_pos" id="target_pos" style="width:75px;">
                        <option value=""><cf_get_lang_main no='1182.Format'></option>
                        <option value="-1" <cfif attributes.target_pos eq -1>selected</cfif>>Genius</option>
                        <option value="-2" <cfif attributes.target_pos eq -2>selected</cfif>>Inter</option>
                        <option value="-3" <cfif attributes.target_pos eq -3>selected</cfif>>N C R</option>
                        <option value="-4" <cfif attributes.target_pos eq -4>selected</cfif>><cf_get_lang_main no="1371.Workcube"></option>
                    </select>
                </td>
                <cfif not fusebox.circuit is "store">
                    <td>
                        <select name="branch_id" id="branch_id">
                            <option value=""><cf_get_lang_main no='1698.Tüm Şubeler'></option>
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
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
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
        	<th width="35"><cf_get_lang_main no="1165.Sıra"></th>
            <th><cf_get_lang_main no='41.Şube'>/<cfif fusebox.circuit is 'store'><cf_get_lang no='71.Depo'><cfelseif fusebox.circuit is 'pos' or fusebox.circuit is 'retail'><cf_get_lang_main no='1351.Depo'></cfif></th>
            <th width="120"><cfif fusebox.circuit is 'store'><cf_get_lang no='91.Tarih Aralığı'><cfelseif fusebox.circuit is 'pos' or fusebox.circuit is 'retail'><cf_get_lang_main no='1278.Tarih Aralığı'></cfif></th>
            <th width="40"><cfif fusebox.circuit is 'store'><cf_get_lang no='92.Format'><cfelseif fusebox.circuit is 'pos' or fusebox.circuit is 'retail'><cf_get_lang_main no='1182.Format'></cfif></th>
            <th width="65"><cfif fusebox.circuit is 'store'><cf_get_lang no='93.Ürün Sayısı'><cfelseif fusebox.circuit is 'pos' or fusebox.circuit is 'retail'><cf_get_lang no='19.Ürün Sayısı'></cfif></th>
            <th width="65"><cf_get_lang_main no='56.Belge'></th>
            <th width="110"><cfif fusebox.circuit is 'store'><cf_get_lang no='95.Kaydeden'><cfelseif fusebox.circuit is 'pos' or fusebox.circuit is 'retail'><cf_get_lang_main no='487.Kaydeden'></cfif></th>
            <th width="100"><cf_get_lang_main no='215.Kayıt Tarihi'></th>
            <th class="header_icn_none"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_form_export_price_change_genius&department_id=#listfirst(session.ep.user_location,"-")#</cfoutput>','medium','pos_islem');"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Export Ekle'>"></a></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_price_change_genius.recordcount>
          <cfoutput query="get_price_change_genius" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr>
            	<td>#currentrow#</td>
                <td>#get_department.branch_name[listfind(department_list,department_id,',')]#/#get_department.department_head[listfind(department_list,department_id,',')]#</td>
                <td>#dateformat(startdate,"dd/mm/yyyy")#-#dateformat(finishdate,"dd/mm/yyyy")#</td>
                <td><cfif target_system eq -1>Genius<cfelseif target_system eq -2>MPOS<cfelseif target_system eq -3>NCR<cfelseif target_system eq -4>Workcube<cfelse><cf_get_lang no ='57.Bilinmiyor'></cfif></td>
                <td>#product_count#</td>
                <td>
                    <a href="#file_web_path#store#dir_seperator##file_name#"><img src="/images/attach.gif"></a>
                    <cfif len(file_size)>#round(file_size/1024)#Kb.</cfif>
                </td>
                <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
                <td>#dateformat(date_add("h",session.ep.time_zone,record_date),"dd/mm/yyyy")# (#timeformat(date_add("h",session.ep.time_zone,record_date),"HH:MM")#)</td>
                <td><cfif session.ep.admin><a href="javascript://" onClick="javascript:if(confirm('<cf_get_lang no='14.Kayıtlı Stok Belgesini Siliyorsunuz'>! <cf_get_lang_main no='1176.Emin misiniz'>?')) windowopen('#request.self#?fuseaction=pos.emptypopup_del_price_change_genius&E_ID=#E_ID#','small'); else return false;"><img src="/images/delete_list.gif"></a></cfif></td>             
            </tr>
          </cfoutput>
        <cfelse>
            <tr>
                <td colspan="10"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_big_list> 
<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
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
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
    <tr>
        <td><cf_pages page="#attributes.page#" 
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#fusebox.circuit#.list_price_change_genius#url_string#">
        </td>
        <!-- sil -->
        <td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
        <!-- sil -->
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
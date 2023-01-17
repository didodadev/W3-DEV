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
<cfinclude template="../query/get_file_stock_imports.cfm">
<cfif fusebox.circuit is "pos">
	<cfinclude template="../query/get_branch.cfm">
</cfif>
<cfif get_stock_imports.recordcount>
	<cfinclude template="../query/get_department.cfm">
	<cfset department_list=listsort(listdeleteduplicates(ValueList(get_department.department_id,',')),'numeric','ASC',',')>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_stock_imports.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.target_pos" default="">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_form" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.list_stock_import">
            <cf_box_search>
                <div class=form-group>
                    <select name="branch_id" id="branch_id">
                        <option value=""><cf_get_lang dictionary_id='29495.Tüm Şubeler'></option>
                        <cfoutput query="get_branch">
                            <option value="#branch_id#"<cfif attributes.branch_id eq branch_id> selected</cfif>>#branch_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangic Tarihi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitis Tarihi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group ">
                    <div class="input-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="kontrol()">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='36045.Stok Import'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='57453.Şube'>/ <cf_get_lang dictionary_id='58763.Depo'></th>
                    <th><cf_get_lang dictionary_id='58594.Format'></th>
                    <th><cf_get_lang dictionary_id='57468.Belge'></th>
                    <th><cf_get_lang dictionary_id='57783.Problemli Kayıtlar'></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th width="20" class="header_icn_none text-center">
                        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_form_add_stock_import<cfif session.ep.isBranchAuthorization>&department_id=#listfirst(session.ep.user_location,"-")#&is_branch=1</cfif></cfoutput>','medium','pos_islem');"><i class="fa fa-plus" title="<cf_get_lang no='43.Eksport Ekle'>"></i></a>
                    </th>
                </tr>
            </thead>
            <tbody>
                <cfif get_stock_imports.recordcount>
                    <cfoutput query="get_stock_imports" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#get_department.branch_name[listfind(department_list,department_id,',')]#/#get_department.department_head[listfind(department_list,department_id,',')]#</td>
                            <td><cfif SOURCE_SYSTEM eq -4><cf_get_lang dictionary_id='58783.Workcube'><cfelse><cf_get_lang dictionary_id ='36057.Bilinmiyor'></cfif></td>
                            <td><a href="#file_web_path#store#dir_seperator##file_name#"><img src="/images/attach.gif"></a><cfif len(FILE_SIZE)>#round(FILE_SIZE/1024)#Kb.</cfif></td>
                            <td><cfif PROBLEMS_COUNT gt 0><a href="#file_web_path#store#dir_seperator##PROBLEMS_FILE_NAME#"><img src="/images/attach.gif"> #PROBLEMS_COUNT#</a><cfelse> - </cfif></td>
                            <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
                            <td>#dateformat(date_add("h",session.ep.time_zone,record_Date),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,record_Date),timeformat_style)#)</td>
                            <td align="center" nowrap width="45">
                                <cfif not imported>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='36075.Stok İmport Belgesini Silme İşlemini Geri Alamazsınız!Emin misiniz'></cfsavecontent>					
                                    <cfsavecontent variable="message2"><cf_get_lang dictionary_id ='36076.Stok İmport Belgesini İşletmek İstediğinizden Emin misiniz'></cfsavecontent>
                                    <a href="javascript://" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_file_stock_import&i_id=#I_ID#','small');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='36015.İmportları Sil'>"></i></a>
                                    <a href="javascript://" onClick="if (confirm('#message2#')) windowopen('#request.self#?fuseaction=objects.emptypopupflush_stock_import&i_id=#I_ID#','small');"><img src="/images/cubexport.gif" title="<cf_get_lang dictionary_id='36035.İmport Et'>"></a>
                                </cfif>
                            </td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr class="color-row" height="20">
                        <td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
            <cfset url_string = ''>
            <cfif len(attributes.target_pos)>
                <cfset url_string = '#url_string#&target_pos=#attributes.target_pos#'>
            </cfif>
            <cfif isdefined("attributes.start_date") and len(attributes.start_date)>
                <cfset url_string = '#url_string#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
            </cfif>
            <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
                <cfset url_string = '#url_string#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
            </cfif>
            <cfif len(attributes.branch_id)>
                <cfset url_string = '#url_string#&branch_id=#attributes.branch_id#'>
            </cfif>
                <cf_paging page="#attributes.page#" 
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#fusebox.circuit#.list_stock_import#url_string#">
            
        </cfif>
    </cf_box>
</div>

<script type="text/javascript">
function kontrol()
{
	return date_check(document.search_form.start_date,document.search_form.finish_date,"<cf_get_lang dictionary_id ='36063.Bitiş Tarihi Başlangıç Tarihinden Küçük'> !");
}
</script>

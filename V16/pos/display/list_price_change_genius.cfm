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
<cfif isdefined("attributes.form_submitted")>
    <cfinclude template="../query/get_price_change_genius.cfm">
<cfelse>
    <cfset get_price_change_genius.recordcount=0>
</cfif>
<cfif fusebox.circuit is "pos">
	<cfinclude template="../query/get_branch.cfm">
</cfif>
<cfif get_price_change_genius.recordcount>
	<cfinclude template="../query/get_department.cfm">
	<cfset department_list=listsort(listdeleteduplicates(ValueList(get_department.department_id,',')),'numeric','ASC',',')>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_price_change_genius.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">    
    <cf_box>
        <cfform name="search_form" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.list_price_change_genius">
            <cf_box_search>
                <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                <div class="form-group">
                    <select name="target_pos" id="target_pos">
                        <option value=""><cf_get_lang dictionary_id='58594.Format'></option>
                        <option value="-1" <cfif attributes.target_pos eq -1>selected</cfif>><cf_get_lang dictionary_id='45932.Genius'></option>
                        <option value="-2" <cfif attributes.target_pos eq -2>selected</cfif>><cf_get_lang dictionary_id='50158.Inter'></option>
                        <option value="-3" <cfif attributes.target_pos eq -3>selected</cfif>>NCR</option>
                        <option value="-4" <cfif attributes.target_pos eq -4>selected</cfif>><cf_get_lang dictionary_id='62481.Workcube Whops'></option>
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
                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','Baslangic Tarihi Girmelisiniz',57738)#" required="yes">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>            
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','Bitis Tarihi Girmelisiniz',57739)#" required="yes" >
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>    
                </div>    
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#getLang('','Sayi_Hatasi_Mesaj',57537)#" maxlength="3">
                </div>    
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="kontrol()">
                </div>  
            </cf_box_search>    
        </cfform>
    </cf_box> 
    <cf_box title="#getLang('','Fiyat Değişim Export',36033)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="35"><cf_get_lang dictionary_id="58577.Sıra"></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'>/<cf_get_lang dictionary_id='58763.Depo'></th>
                    <th><cf_get_lang dictionary_id='58690.Tarih Aralığı'></th>
                    <th><cf_get_lang dictionary_id='58594.Format'></th>
                    <th><cf_get_lang dictionary_id='36019.Ürün Sayısı'></th>
                    <th width="20"><cf_get_lang dictionary_id='57468.Belge'></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th width="20" class="header_icn_none text-center">
                        <a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=pos.list_price_change_genius&event=add&department_id=#listfirst(session.ep.user_location,"-")#</cfoutput>','','ui-draggable-box-large');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='45919.Export Ekle'>"></i></a>
                    </th>
                </tr>
            </thead>
            <tbody>                                    
                <cfif get_price_change_genius.recordcount>
                  <cfoutput query="get_price_change_genius" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#get_department.branch_name[listfind(department_list,department_id,',')]#/#get_department.department_head[listfind(department_list,department_id,',')]#</td>
                        <td>#dateformat(startdate,dateformat_style)#-#dateformat(finishdate,dateformat_style)#</td>
                        <td><cfif target_system eq -1>Genius<cfelseif target_system eq -2>MPOS<cfelseif target_system eq -3>NCR<cfelseif target_system eq -4><cf_get_lang dictionary_id='62481.Workcube Whops'><cfelse><cf_get_lang dictionary_id ='36057.Bilinmiyor'></cfif></td>
                        <td>#product_count#</td>
                        <td>
                            <a href="#file_web_path#store#dir_seperator##file_name#"><i class="fa fa-paperclip"></i></a>
                            <cfif len(file_size)>#round(file_size/1024)#Kb.</cfif>
                        </td>
                        <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
                        <td>#dateformat(date_add("h",session.ep.time_zone,record_date),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,record_date),timeformat_style)#)</td>
                        <td><cfif session.ep.admin><a href="javascript://" onClick="javascript:if(confirm('<cf_get_lang dictionary_id='36014.Kayıtlı Stok Belgesini Siliyorsunuz'>! <cf_get_lang dictionary_id='58588.Emin misiniz'>?')) openBoxDraggable('#request.self#?fuseaction=pos.list_price_change_genius&event=del&E_ID=#E_ID#'); else return false;"><i class="fa fa-minus"></i></a></cfif></td>             
                    </tr>
                  </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="10"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>  
        <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
            <cfset url_string = ''>
            <cfif isdefined("attributes.target_pos") and len(attributes.target_pos)>
                <cfset url_string = '#url_string#&target_pos=#attributes.target_pos#'>
            </cfif>
            <cfif isdefined("attributes.start_date") and len(attributes.start_date)>
                <cfset url_string = '#url_string#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
            </cfif>
            <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
                <cfset url_string = '#url_string#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
            </cfif>
            
            <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
                <cfset url_string = '#url_string#&branch_id=#attributes.branch_id#'>
            </cfif>
            <cf_paging 
                page="#attributes.page#" 
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#fusebox.circuit#.list_price_change_genius#url_string#">
        </cfif>  
    </cf_box>
</div>    


<script type="text/javascript">
function kontrol()
{
	return date_check(document.search_form.start_date,document.search_form.finish_date,"<cf_get_lang dictionary_id ='36063.Bitiş Tarihi Başlangıç Tarihinden Küçük'> !");
}
</script>

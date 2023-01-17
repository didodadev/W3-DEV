
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
<cfinclude template="../../../../V16/pos/query/get_file_export_promotion.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_file_export_promotions.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.target_pos" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="list_export_promotion" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.list_export_promotion">
            <cf_box_search>
                <div class="form-group">
                    <select name="target_pos" id="target_pos" style="width:75px;">
                        <option value=""><cf_get_lang dictionary_id='58594.Format'></option>
                        <option value="-1" <cfif attributes.target_pos eq -1>selected</cfif>>Genius</option>				
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangic Tarihi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitis Tarihi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="kontrol()">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='36047.Promosyon Export'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cfif fusebox.circuit is 'store'><cf_get_lang dictionary_id='58690.Tarih Aralığı'><cfelseif fusebox.circuit is 'pos' or fusebox.circuit is 'retail'><cf_get_lang dictionary_id='58690.Tarih Aralığı'></cfif></th>
                    <th><cfif fusebox.circuit is 'store'><cf_get_lang dictionary_id='58594.Format'><cfelseif fusebox.circuit is 'pos' or fusebox.circuit is 'retail'><cf_get_lang dictionary_id='58594.Format'></cfif></th>
                    <th><cfif fusebox.circuit is 'store'><cf_get_lang dictionary_id='33886.Ürün Sayısı'><cfelseif fusebox.circuit is 'pos' or fusebox.circuit is 'retail'><cf_get_lang dictionary_id='33886.Ürün Sayısı'></cfif></th>
                    <th><cf_get_lang dictionary_id='57468.Belge'></th>
                    <th><cfif fusebox.circuit is 'store'><cf_get_lang dictionary_id='57899.Kaydeden'><cfelseif fusebox.circuit is 'pos' or fusebox.circuit is 'retail'><cf_get_lang dictionary_id='57899.Kaydeden'></cfif></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th width="20" class="header_icn_none text-center">
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=retail.list_export_promotion&event=add</cfoutput>','small','popup_export_promotion');"><i class="fa fa-plus" title="<cfif fusebox.circuit is 'store'><cf_get_lang dictionary_id='61463.Eksport Ekle'><cfelseif fusebox.circuit is 'pos'><cf_get_lang dictionary_id='61463.Eksport Ekle'></cfif>"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="get_file_export_promotions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                  <tr>
                    <td>#dateformat(startdate,"dd/mm/yyyy")# (#timeformat(startdate,"HH:MM")#) - #dateformat(finishdate,"dd/mm/yyyy")# (#timeformat(finishdate,"HH:MM")#)</td>
                    <td><cfif target_system eq -1>Genius<cfelseif target_system eq -2>MPOS<cfelseif target_system eq -3>NCR<cfelse><cf_get_lang dictionary_id ='39419.Bilinmiyor'></cfif></td>
                    <td>#product_count#</td>
                    <td><a href="#file_web_path#store#dir_seperator##file_name#"><img src="/images/attach.gif"></a><cfif len(FILE_SIZE)>#round(FILE_SIZE/1024)#Kb.</cfif></td>
                    <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
                    <td>#dateformat(date_add("h",session.ep.time_zone,record_Date),"dd/mm/yyyy")# (#timeformat(date_add("h",session.ep.time_zone,record_Date),"HH:MM")#)</td>
                    <td><cfif session.ep.admin><a href="javascript://" onClick="javascript:if(confirm('<cf_get_lang dictionary_id='
                        36159.Kayıtlı Stok Export Belgesini Siliyorsunuz! Emin misiniz'>?')) windowopen('#request.self#?fuseaction=pos.emptypopup_del_stock_export_file&e_id=#e_id#','small'); else return false;"><i class="fa fa-minus"></i></a></cfif></td>
                  </tr>
                </cfoutput>
                <cfif not get_file_export_promotions.recordcount>
                  <tr>
                    <td colspan="7"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !</td>
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
                <cfset url_string = '#url_string#&start_date=#dateformat(attributes.start_date,"dd/mm/yyyy")#'>
            </cfif>
            <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
                <cfset url_string = '#url_string#&finish_date=#dateformat(attributes.finish_date,"dd/mm/yyyy")#'>
            </cfif>
            <cf_paging page="#attributes.page#" 
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#fusebox.circuit#.list_export_promotion#url_string#">         
        </cfif>
    </cf_box>
</div>

<script type="text/javascript">
function kontrol()
{
	return date_check(document.list_export_promotion.start_date,document.list_export_promotion.finish_date,"<cf_get_lang dictionary_id ='
    36063.Bitiş Tarihi Başlangıç Tarihinden Küçük'>!");
}
</script>

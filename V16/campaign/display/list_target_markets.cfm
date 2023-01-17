<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.tmarket_id" default="">
<cfif isdefined('attributes.form_submit')>
    <!---<cfset attributes.tmarket_module = 'campaign'>--->
    <cfif fusebox.circuit is 'campaign'>
        <cfinclude template="../query/get_target_markets.cfm">
    </cfif>
<cfelse>
    <cfset tmarket.recordcount = 0 >
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#tmarket.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif fuseaction contains "popup">
  <cfset is_popup=1>
<cfelse>
  <cfset is_popup=0>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search" id="search" method="post" action="#request.self#?fuseaction=campaign.list_target_markets">
            <input type="hidden" name="form_submit" id="form_submit" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" maxlength="50" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#">
                </div>
                <div class="form-group">
                    <select name="is_active" id="is_active" style="width:50px;">
                        <option value="2" <cfif isdefined("attributes.is_active") and attributes.is_active eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="1" <cfif isdefined("attributes.is_active") and attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif isdefined("attributes.is_active") and attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang(493,'Hedef Kitleler',57905)#" uidrop="1" hide_table_column="1">
        <cf_flat_list>
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cfoutput>#getLang(43,'Hedef Kitle',49363)#</cfoutput></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='57756.Durum'></th>
                    <th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=campaign.list_target_markets&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif tmarket.recordcount>
                    <cfset record_emp_list=''>
                    <cfoutput query="tmarket" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif len(record_emp) and not listfind(record_emp_list,record_emp)>
                            <cfset record_emp_list = Listappend(record_emp_list,record_emp)>
                        </cfif>
                    </cfoutput>
                    <cfif len(record_emp_list)>
                        <cfset record_emp_list=listsort(record_emp_list,"numeric","ASC",",")>
                        <cfquery name="GET_EMP" datasource="#DSN#">
                            SELECT
                                EMPLOYEE_NAME,
                                EMPLOYEE_SURNAME,
                                EMPLOYEE_ID
                            FROM
                                EMPLOYEES
                            WHERE
                                EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#record_emp_list#">)
                            ORDER BY
                                EMPLOYEE_ID
                        </cfquery>
                        <cfset record_emp_list = valuelist(get_emp.employee_id,',')>		
                    </cfif>
                    <cfoutput query="tmarket" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>	
                            <td>#tmarket_no#</td>
                            <td>
                                <cfif (fusebox.fuseaction contains "popup") and not isDefined("module")>
                                    <a href="#request.self#?fuseaction=campaign.popup_add_camp_tmarket&tmarket_id=#tmarket_id#&camp_id=#camp_id#" class="tableyazi">#tmarket_name#</a>
                                <cfelse>
                                    <cfquery name="get_records" datasource="#dsn3#">
                                        SELECT DISTINCT TMARKET_ID FROM TARGET_AUDIENCE_RECORD WHERE TMARKET_ID = #tmarket.tmarket_id#
                                    </cfquery>
                                    <cfif get_records.recordcount>
                                        <a href="#request.self#?fuseaction=campaign.list_target_list_extra&tmarket_id=#tmarket_id#" class="tableyazi">#tmarket_name#</a>
                                    <cfelse>
                                        <a href="#request.self#?fuseaction=campaign.list_target_list&tmarket_id=#tmarket_id#" class="tableyazi">#tmarket_name#</a>
                                    </cfif>
                                </cfif>
                            </td>
                            <td><cfif len(record_emp)><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_emp.employee_id[listfind(record_emp_list,tmarket.record_emp,',')]#','medium');">#get_emp.employee_name[listfind(record_emp_list,tmarket.record_emp,',')]#&nbsp;#get_emp.employee_surname[listfind(record_emp_list,tmarket.record_emp,',')]#</a></cfif></td>
                            <td>#dateformat(record_date,dateformat_style)#</td>
                            <td><cfif get_records.recordcount><cf_get_lang dictionary_id='61167.Hedef Kitle Kaydedilmiştir'><cfelse><cf_get_lang dictionary_id='61167.Hedef Kitle Kaydedilmemiştir'></cfif></td>
                            <td><a href="#request.self#?fuseaction=campaign.list_target_markets&event=upd&tmarket_id=#tmarket_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        </tr>
                    </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="7"><cfif isdefined("attributes.form_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
                        </tr>
                </cfif>
            </tbody>
            <cfset url_str = "">
            <cfif len(attributes.keyword)>
                <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
            </cfif>
        </cf_flat_list>
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="campaign.list_target_markets#url_str#&form_submit=1">
    </cf_box>
</div>
<script type="text/javascript">
    document.getElementById('keyword').focus();
</script>

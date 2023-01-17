<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_targets.cfm">
<cfelse>
	<cfset get_targets.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_targets.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.branch_id" default="">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_target" method="post" action="#request.self#?fuseaction=salesplan.targets">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
	        <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#getLang('','Filtre',57460)#">
                </div>
                <div class="form-group">
                    <select name="targetcat_id" id="targetcat_id">
                        <cfinclude template="../query/get_target_cats.cfm">
                        <option value=""><cf_get_lang dictionary_id='57486.Kategori'> 
                        <cfoutput query="get_target_cats">
                            <option value="#targetcat_id#" <cfif isdefined("attributes.targetcat_id") and len(attributes.targetcat_id) and attributes.targetcat_id eq targetcat_id>selected</cfif>>#targetcat_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <cfinclude template="../query/get_all_departments.cfm">
                <div class="form-group">
                    <select name="branch_id" id="branch_id">
                        <option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
                        <cfoutput query="ALL_BRANCHES">
                            <option value="#BRANCH_ID#" <cfif isdefined("attributes.branch_id") and (attributes.branch_id eq BRANCH_ID)>selected</cfif>>#branch_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)# !" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function='kontrol()'>
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-employee_name">
                        <label class="col col-12"><cf_get_lang dictionary_id='41521.Hedef Verilen'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="employee_poscode" id="employee_poscode" value="<cfif isdefined("attributes.employee_poscode") and len(attributes.employee_poscode) and isdefined("attributes.employee_name") and len(attributes.employee_name)><cfoutput>#attributes.employee_poscode#</cfoutput></cfif>">
                                <input type="text" name="employee_name" id="employee_name" value="<cfif isdefined("attributes.employee_name") and len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" maxlength="255">
                                <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=search_target.employee_poscode&field_name=search_target.employee_name&select_list=1&branch_related=1&keyword='+encodeURIComponent(document.search_target.employee_name.value));"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-start_date">
                        <label class="col col-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','Başlama Tarihi Girmelisiniz',58745)# !">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-finish_date">
                        <label class="col col-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','Bitiş Tarihi Girmelisiniz',57739)# !">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Hedefler',57964)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="35"><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                    <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                    <th><cf_get_lang dictionary_id='41523.Rakam'></th>
                    <th><cf_get_lang dictionary_id='57501.Başlangıç'></th>
                    <th><cf_get_lang dictionary_id='57502.Bitiş'></th>
                    <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=salesplan.targets&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_targets.recordcount>
                    <cfoutput query="get_targets" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#targetcat_name#</td>
                            <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_targets.employee_id#','medium');">#employee_name# #employee_surname#</a></td>
                            <td>#TLFormat(target_number)#</td>
                            <td>#dateformat(startdate,dateformat_style)#</td>
                            <td>#dateformat(finishdate,dateformat_style)#</td>
                            <td><a href="javascript://" onclick="window.open('#request.self#?fuseaction=salesplan.targets&event=upd&target_id=#get_targets.target_id#&position_code=#get_targets.position_code#&sales_plan=1')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        </tr>
                    </cfoutput>
                    <cfelse>
                    <tr>
                        <td colspan="7"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cfif len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
            </cfif>
            <cfif isdefined("attributes.targetcat_id") and len(attributes.targetcat_id)>
            <cfset url_str = "#url_str#&targetcat_id=#attributes.targetcat_id#">
            </cfif>
            <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
            <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
            </cfif>
            <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
            <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
            </cfif>
            <cfif isdefined("attributes.start_date") and len(attributes.start_date)>
            <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
            </cfif>
            <cfif isdefined("attributes.employee_poscode") and len(attributes.employee_poscode) and isdefined("attributes.employee_name") and len(attributes.employee_name)>
                <cfset url_str = "#url_str#&employee_poscode=#attributes.employee_poscode#&employee_name=#attributes.employee_name#">
            </cfif>
            <cfif len(attributes.form_submitted)>
                <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
            </cfif>
            <cf_paging 
                page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="salesplan.targets#url_str#"></td>
        </cfif>
    </cf_box>
</div>

<script type="text/javascript">
document.getElementById('keyword').focus();
function kontrol()
{
	if ((document.search_target.start_date.value.length>0) && (document.search_target.finish_date.value.length>0))
	return date_check(document.search_target.start_date,document.search_target.finish_date,"<cf_get_lang dictionary_id='57806.Tarih Aralığını Kontrol Ediniz'>!");
	return true;
}
</script>

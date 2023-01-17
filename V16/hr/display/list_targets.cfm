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
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.targetcat_id" default="">
<cfif len(attributes.keyword)>
  <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
  <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
  <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.targetcat_id") and len(attributes.targetcat_id)>
  <cfset url_str = "#url_str#&targetcat_id=#attributes.targetcat_id#">
</cfif>
<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
  <cfset url_str = "#url_str#&department_id=#attributes.department_id#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_target" method="post" action="#request.self#?fuseaction=hr.targets">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" placeholder="#place#" maxlength="50">
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
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.başlama tarihi girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" placeholder="#getLang('','Başlangıç Tarihi',58053)#" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitiş girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" placeholder="#getLang('','Bitiş Tarihi',57700)#" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function='kontrol()'>
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-departments">
                        <label class="col col-12"></label>
                        <div class="col col-12">
                            <cfinclude template="../query/get_all_departments.cfm">
                            <select name="department_id" id="department_id">
                                <option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
                                <cfoutput query="all_departments">
                                    <cfif isdefined("attributes.department_id")>
                                        <option value="#department_id#" <cfif attributes.department_id eq department_id>selected</cfif>>&nbsp;#branch_name# / #department_head#</option>
                                    <cfelse>
                                        <option value="#department_id#">&nbsp;#branch_name# / #department_head#</option>
                                    </cfif>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57964.Hedefler"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_grid_list> 
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57951.Hedef'></th>
                    <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                    <th><cf_get_lang dictionary_id='57486.kategori'></th>
                    <th><cf_get_lang dictionary_id='56298.Hedef Veren'></th>
                    <th><cf_get_lang dictionary_id='55486.Rakam'></th>
                    <th><cf_get_lang dictionary_id='57501.Başlangıç'></th>
                    <th><cf_get_lang dictionary_id='57502.Bitiş'></th>
                    <th><cf_get_lang dictionary_id='56469.Hedef Ağırlığı'></th>
                    <!-- sil -->
                    <th width="20" ><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.targets&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_targets.recordcount>
                    <cfoutput query="get_targets" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td height="35">#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=hr.targets&event=upd&target_id=#target_id#&position_code=#get_targets.position_code#" class="tableyazi">#target_head#</a></td>
                            <td><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#get_targets.employee_id#" class="tableyazi">#employee_name# #employee_surname#</a></td>
                            <td>#targetcat_name#</td>
                            <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#target_emp#');" class="tableyazi">#TARGET_EMP_NAME#</a></td>
                            <td style="text-align:right;">#TLFormat(target_number)#</td>
                            <td>#dateformat(startdate,dateformat_style)#</td>
                            <td>#dateformat(finishdate,dateformat_style)#</td>
                            <td>#TLFormat(target_weight)#</td>
                            <!-- sil -->
                            <td style="text-align:center;"><a href="#request.self#?fuseaction=hr.targets&event=upd&target_id=#get_targets.target_id#&position_code=#get_targets.position_code#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                            <!-- sil -->
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="10"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list> 
        <cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
            <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
        </cfif>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="hr.targets#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function kontrol()
	{
	if ( (search_target.start_date.value.length != 0)&&(search_target.finish_date.value.length != 0) )
		return date_check(search_target.start_date,search_target.finish_date,"<cf_get_lang dictionary_id='56017.Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'>!");
	return true;
	}
</script>

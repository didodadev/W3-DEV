<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfscript>
	attributes.startrow = ((attributes.page - 1) * attributes.maxrows) + 1;
	if (isdefined("attributes.form_submitted"))
	{
		cmp_pos_auth = createObject("component","V16.hr.cfc.get_positions_authority");
		cmp_pos_auth.dsn = dsn;
		get_positions_authority = cmp_pos_auth.get_pos_auth(
			keyword: attributes.keyword,
			status: '#iif(isdefined("attributes.status") and len(attributes.status),"attributes.status",DE(""))#',
			maxrows: attributes.maxrows,
			startrow: attributes.startrow
		);
	}
	else
		get_positions_authority.query_count=0;
		
	url_str = '';
	if (isdefined("attributes.keyword") and len(attributes.keyword))
		url_str = '#url_str#&keyword=#attributes.keyword#';
	if (isdefined("attributes.status") and len(attributes.status))
		url_str = '#url_str#&status=#attributes.status#';
	if (isdefined("attributes.form_submitted") and len(attributes.form_submitted))
		url_str = '#url_str#&form_submitted=#attributes.form_submitted#';
</cfscript>
<cfscript>
    cmp_department = createObject("component","V16.hr.cfc.get_departments");
    cmp_department.dsn = dsn;
</cfscript>
<cfparam name="attributes.totalrecords" default="#get_positions_authority.query_count#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=hr.list_contents" method="post" name="search">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang(48,'Filtre',57460)#">
                </div>
                <div class="form-group">
                    <select name="status" id="status">
                        <option value=""<cfif isdefined("attributes.status") and (attributes.status eq '')>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="1"<cfif isdefined("attributes.status") and (attributes.status eq 1)>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0"<cfif isdefined("attributes.status") and (attributes.status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)"validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4"> 
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Görev Tanımları',47117)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>  
            <thead>
                <tr> 
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='58820.Başlık'></th>
                    <th> <cf_get_lang dictionary_id='58497.Pozisyon'></th> 
                    <th><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></th>
                    <th><cf_get_lang dictionary_id='57572.Departman'></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th> 
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none text-center"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_collected_print','wide');"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></th>
                    <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_contents&event=add"> <i class="fa fa-plus" title="<cf_get_lang dictionary_id='55226.Yetki ve Sorumluluk Ekle'>" alt="<cf_get_lang dictionary_id='55226.Yetki ve Sorumluluk Ekle'>"></i></a></th>
                    <!-- sil -->
                </tr> 
            </thead>
            <tbody>             
                <cfif len(get_positions_authority.query_count) and get_positions_authority.query_count gt 0>
                    <cfoutput query="get_positions_authority" group="AUTHORITY_ID">
                        <cfset dep_list="">
                        <cfset dep_list=listappend(dep_list,'#department_id#')> 
                        <tr>
                            <td>#rownum#</td>
                            <td nowrap="nowrap"><a href="#request.self#?fuseaction=hr.list_contents&event=upd&authority_id=#authority_id#" class="tableyazi">#AUTHORITY_HEAD#</a></td>	
                            <td>#position_names#</td>
                            <td>#position_cats#</td>	
                            <td>
                                <cfloop list="#dep_list#" index="i">
                                    <cfset get_department = cmp_department.get_department(department_id : i)>
                                    #get_department.DEPARTMENT_HEAD_#<cfif i neq listlast(dep_list)>,</cfif>
                                </cfloop>
                            </td>			  		  
                            <td>#employee_name# #employee_surname#</td>
                            <td>#dateformat(record_date,dateformat_style)#</td>
                            <!-- sil -->
                            <td class="text-center"><a href="javascript://" target="" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#get_positions_authority.authority_id#&print_type=181','print_page','workcube_print');"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></td>
                            <td width="20">
                                <a href="#request.self#?fuseaction=hr.list_contents&event=upd&authority_id=#authority_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                            </td>
                            <!-- sil -->
                        </tr>
                    </cfoutput> 
                    <cfelse>
                        <tr>
                            <td colspan="9"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
                        </tr>
                </cfif>
            </tbody>	
        </cf_grid_list>
        <cf_paging 
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="hr.list_contents#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

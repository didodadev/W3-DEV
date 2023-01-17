<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.is_active" default=1>
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.position_name" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default="0">
<cfparam name="attributes.period_year" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_approve" default="">
<cfparam name="attributes.is_mail" default="">

<!--- Filtre BEGIN --->	
    <cfscript>  
        attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1;
        cmp_period_year = createObject("component","V16.hr.cfc.get_period_year");
        cmp_period_year.dsn = dsn;
        get_period_year = cmp_period_year.get_period_year();
        
        cmp_pos_cat = createObject("component","V16.hr.cfc.get_position_cat");
        cmp_pos_cat.dsn = dsn;
        get_position_cats_ = cmp_pos_cat.get_position_cat();
        cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp");
        cmp_branch.dsn = dsn;
        get_branches = cmp_branch.get_branch(ehesap_control:1,branch_status:attributes.is_active);
        if (isdefined('attributes.branch_id') and isnumeric(attributes.branch_id))
        {
            cmp_department = createObject("component","V16.hr.cfc.get_departments");
            cmp_department.dsn = dsn;
            get_department = cmp_department.get_department(branch_id:attributes.branch_id);
        }
    </cfscript>
<!--- Filtre END --->
<!--- Search Qery BEGIN --->
    <cfscript>
        url_str = "&event=list&keyword=#attributes.keyword#";
        if (isdefined("attributes.form_submitted"))
            url_str = "#url_str#&form_submitted=#attributes.form_submitted#";	
        if (len(attributes.position_name))
            url_str="#url_str#&position_name=#attributes.position_name#";
        if (len(attributes.position_cat_id))
            url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#";
        if (isdefined("attributes.branch_id"))
            url_str = "#url_str#&branch_id=#attributes.branch_id#";
        if (isdefined("attributes.department"))
            url_str = "#url_str#&department=#attributes.department#";
        if (isdefined("attributes.is_mail"))
            url_str = "#url_str#&is_mail=#attributes.is_mail#";
        if (isdefined("attributes.is_approve"))
            url_str = "#url_str#&is_approve=#attributes.is_approve#";
        if (isdefined("attributes.form_submitted"))
        {
            cmp_eoc= createObject("component","V16.hr.cfc.get_employees_offtime_contract");
            cmp_eoc.dsn = dsn;
            get_employees_offtime_contract = cmp_eoc.get_employees_offtime_contract(
                keyword: attributes.keyword,
                position_cat_id: attributes.position_cat_id,
                branch_id: '#iif(isdefined("attributes.branch_id"),"attributes.branch_id",DE(""))#',
                position_name: attributes.position_name,
                department: '#iif(isdefined("attributes.department"),"attributes.department",DE(""))#',
                fusebox_dynamic_hierarchy: fusebox.dynamic_hierarchy,
                database_type: database_type,
                maxrows: attributes.maxrows,
                startrow: attributes.startrow,
                is_approve: attributes.is_approve,
                is_mail: attributes.is_mail                
            );
        }
        else
        {
            get_employees_offtime_contract.recordcount = 0;
        }
    </cfscript>
<!--- Search Qery END --->
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="leave_reconciliation" action="#request.self#?fuseaction=#url.fuseaction#&event=list">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1" />
            <cf_box_search plus="0">
                <div class="form-group">
                    <input type="text" name="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" maxlength="50" placeholder="<cfoutput>#getLang('main',48)#</cfoutput>">
                </div>
                <div class="form-group">
                    <select name="period_year" id="period_year">
                        <option value=""><cf_get_lang dictionary_id='40553.Periyod/Yıl'></option>
                        <cfoutput query="get_period_year">
                            <option value="#PERIOD_YEAR#" <cfif isdefined("attributes.period_year") and attributes.period_year eq PERIOD_YEAR> selected <cfelseif len(attributes.period_year) eq 0 AND session.ep.PERIOD_YEAR eq PERIOD_YEAR>selected</cfif>>#PERIOD_YEAR#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray2" href="/index.cfm?fuseaction=ehesap.hr_offtime_approve&event=batch"><i class="fa fa-clone" title="<cf_get_lang dictionary_id='63444.Toplu Mutabakat Oluştur'>"></i></a>
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray" href="/index.cfm?fuseaction=ehesap.hr_offtime_approve&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-12">					
                            <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
                                <option value="all" <cfif isdefined("attributes.branch_id") and attributes.branch_id is 'all'>selected</cfif>><cf_get_lang dictionary_id='57453.Şube'></option>
                                <cfoutput query="get_branches" group="NICK_NAME">
                                    <optgroup label="#get_branches.NICK_NAME#"></optgroup>
                                    <cfoutput>
                                        <option value="#get_branches.BRANCH_ID#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq get_branches.branch_id)> selected</cfif>>#get_branches.BRANCH_NAME#</option>
                                    </cfoutput>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <cfoutput>
                    <div class="form-group" id="item-department">
                        <label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-12" id="DEPARTMENT_PLACE">					
                            <select name="department" id="department">
                                <option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
                                <cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
                                    <cfloop query="get_department">
                                        <option value="#department_id#"<cfif isdefined('attributes.department') and (attributes.department eq get_department.department_id)>selected</cfif>>#department_head#</option>
                                    </cfloop>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-position_cat_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
                        <div class="col col-12">					
                            <select name="position_cat_id" id="position_cat_id">
                                <option value=""><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'>
                                <cfloop query="GET_POSITION_CATS_">
                                    <option value="#position_cat_id#"<cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#position_cat#</option>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    </cfoutput>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-is_mail">
                        <label class="col col-12"><cf_get_lang dictionary_id='64544.Gönderim durumu'></label>
                        <div class="col col-12">					
                            <select name="is_mail" id="is_mail">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1"<cfif attributes.is_mail eq 1> selected</cfif>><cf_get_lang dictionary_id='57096.Gönderildi'></option>
                                <option value="0"<cfif attributes.is_mail eq 0> selected</cfif>><cf_get_lang dictionary_id='40103.Gönderilmedi'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-is_approve">
                        <label class="col col-12"><cf_get_lang dictionary_id='33139.Onay durumu'></label>
                        <div class="col col-12">					
                            <select name="is_approve" id="is_approve">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1"<cfif attributes.is_approve eq 1> selected</cfif>><cf_get_lang dictionary_id='64545.İmzlandı'></option>
                                <option value="0"<cfif attributes.is_approve eq 0> selected</cfif>><cf_get_lang dictionary_id='64546.İmzalanmadı'></option>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','İzin Mutabakatları','31567')#" closable="0" add_href="/index.cfm?fuseaction=ehesap.hr_offtime_approve&event=add" uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'row_check',  print_type : 355 }#">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th> 
                    <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                    <th width="125"><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th width="125"><cf_get_lang dictionary_id='57572.Departman'></th>
                    <th width="80"><cf_get_lang dictionary_id='58472.Dönem'></th>
                    <th width="135"><cf_get_lang dictionary_id='56651.Mutabakat Tarihi'></th>
                    <th class="text-center" width="35"><i class="fa fa-paper-plane"></i></th>
                    <th width="120"><cf_get_lang dictionary_id='49359.Gönderi Tarihi'></th>
                    <th class="text-center" width="35"><i class="fa fa-thumbs-o-up "></i></th>
                    <th width="120"><cf_get_lang dictionary_id='45408.Dönüş Tarihi'></th>
                    <th class="text-center" width="35"><i class="fa fa-print"></i></th>
                    <th class="text-center" width="35"><i class="fa fa-pencil"></i></th>
                    <th class="text-center" width="35">
                        <input type="checkbox" name="row_all_check" id="row_all_check" onclick="wrk_select_all('row_all_check','row_check');">                   
                    </th>
                </tr>
            </thead>
            <tbody>
                <cfif get_employees_offtime_contract.recordcount>
                    <cfobject component="/WMO/GeneralFunctions" name="GnlFunctions">
                    <cfset attributes.totalrecords = get_employees_offtime_contract.query_count>
                    <cfloop query="get_employees_offtime_contract">
                        <tr>
                            <cfoutput>                    
                            <td title="#EMPLOYEE_ID#"><a href="/index.cfm?fuseaction=ehesap.hr_offtime_approve&event=upd&employees_offtime_contract_id=#employees_offtime_contract_id#">#rownum#</a></td>
                            <td <cfif len(last_surname)>title="Kızlık Soyadı : #last_surname#"</cfif>><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#">#employee_name# #employee_surname#</a></td>
                            <td>#BRANCH_NAME#</td>
                            <td>#DEPARTMENT_HEAD#</td>
                            <td>#SAL_YEAR#</td> 
                            <td>#dateTimeFormat(OFFTIME_DATE_1,"DD-MM-YYYY HH:mm:ss")#</td>                  
                            <td class="text-center"><cfif is_mail eq 1><i class="fa fa-paper-plane font-green-jungle" ></i><cfelse><i class="fa fa-paper-plane font-red" ></i></cfif></td>
                            <td></td>
                            <td class="text-center"><cfif is_approve eq 1><i class="fa fa-thumbs-o-up font-green-jungle" ></i><cfelse><i class="fa fa-thumbs-o-down font-red" ></i></cfif></td>
                            <td></td>
                            <td class="text-center"><i class="fa fa-print font-blue"  onclick="windowopen('index.cfm?fuseaction=objects.popup_print_files&id#employees_offtime_contract_id#&ACTION_ID=#employees_offtime_contract_id#&print_type=355','page');"></i></td>
                            <td class="text-center"><a href="/index.cfm?fuseaction=ehesap.hr_offtime_approve&event=upd&employees_offtime_contract_id=#employees_offtime_contract_id#"><i class="fa fa-pencil"></i></a></td>
                            <td><input type="checkbox" name="row_check" id="row_check" value="#employees_offtime_contract_id#"></td>
                            </cfoutput>
                        </tr>
                    </cfloop>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif get_employees_offtime_contract.recordcount eq 0>
            <div class="ui-info-bottom">
                <p><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></p>
            </div>
        </cfif>
        <cf_paging page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#(attributes.page-1)*attributes.maxrows#" 
        adres="ehesap.hr_offtime_approve#url_str#">
        <!---  	<cfif isdefined("attributes.form_submitted") and get_employees_offtime_contract.recordcount neq 0>
            <div id="item_footer">
                <cf_box_footer>
                    <form id="send_mail" name="send_mail" action="<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_output_center" method="post" target="_print_center">
                        <input type="hidden" name="files" id="file_ids">
                        <input type="hidden" name="form_type" value="355">
                        <input type="hidden" name="wo" value="ehesap.hr_offtime_approve">
                        <input type="hidden" name="det" value="/index.cfm?fuseaction=ehesap.hr_offtime_approve&event=upd&employees_offtime_contract_id=">
                        
                        <div class="form-group col col-6">
                            <!--- <label>Gönderen</label> --->
                            <div class="input-group">
                                <input type="hidden" name="employee_id" id="employee_id">
                                <input type="text" name="employee" id="employee" autocomplete="off" placeholder="<cfoutput>#getlang('','Gönderen',57066)#</cfoutput>">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=send_mail.employee_id&field_name=send_mail.employee&select_list=1');"></span>
                            </div>
                        </div>
                            <span class="ui-wrk-btn ui-wrk-btn-extra" onClick="send_output_center()"><cf_get_lang dictionary_id='64543.Çıktı Merkezine Gönder'></span>
                        
                    </form>
                </cf_box_footer>  
            </div>
        </cfif>--->
    </cf_box>
</div>
<script language="javascript">
    function showDepartment(branch_id)	
    {
        var branch_id = document.getElementById('branch_id').value;
        if (branch_id != "")
        {
            var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
            AjaxPageLoad(send_address,'item-department',1,'İlişkili Departmanlar');
        }
    }
    function triggerPlusIcon(){
        location.href="/index.cfm?fuseaction=ehesap.hr_offtime_approve&event=add";
    }
    function all_check(e){
        var status = $(e).prop('checked');
        $('input#row_check').each(function() {
            $( this ).prop('checked',status);
        });
    }
    /* function send_output_center(){
        select_file_id = '0';
        $('input#row_check').each(function() {
            var status = $(this).prop('checked');
            if(status){
                var file_id = $( this ).data('file_id');
                console.log(file_id);
                select_file_id += ',' + file_id;
                
            }
        });
        console.log(select_file_id);
        $('#file_ids').val(select_file_id);
        if (select_file_id !='0'){
           $('#send_mail').submit();
        }
    } */
</script> 
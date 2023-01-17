<cf_xml_page_edit fuseact="ehesap.list_import_process">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset url_str = "">
<cfif isdefined("attributes.BRANCH_ID") and len(attributes.BRANCH_ID)>
    <cfset url_str = "#url_str#&BRANCH_ID=#attributes.BRANCH_ID#">
</cfif>
<cfif isdefined("attributes.import_type") and len(attributes.import_type)>
    <cfset url_str = "#url_str#&import_type=#attributes.import_type#">
</cfif>
<cfif isdefined('attributes.form_submit')>
    <cfquery name="get_imports" datasource="#dsn#">
        SELECT 
            * 
        FROM 
            EMPLOYEES_PUANTAJ_FILES 
        WHERE
            RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            OR
            (
                1=1
                <cfif x_power_user eq 1 and not session.ep.ehesap>
                    AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
                <cfelseif x_power_user eq 2 and get_module_power_user(application['objects']['#attributes.fuseaction#']['MODULE_NO']) eq 0>
                    AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
                <cfelseif x_power_user eq 3 and get_module_user(application['objects']['#attributes.fuseaction#']['MODULE_NO']) eq 0>
                    AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
                </cfif>
                <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
                    AND BRANCH_ID = #attributes.branch_id#
                </cfif>
                <cfif isdefined("attributes.import_type") and len(attributes.import_type)>
                    AND PROCESS_TYPE = #attributes.import_type#
                </cfif>
            )
        ORDER BY 
            RECORD_DATE DESC
    </cfquery>
<cfelse>
    <cfset get_imports.recordcount = 0>
</cfif>
<cfset branch_list=''>
<cfset emp_list=''>
<cfif isdefined("attributes.form_submit") and get_imports.recordcount>
    <cfoutput query="get_imports">
        <cfif len(branch_id) and not listfind(branch_list,branch_id)>
            <cfset branch_list=listappend(branch_list,branch_id)>
        </cfif>
        <cfif len(record_emp) and not listfind(emp_list,record_emp)>
            <cfset emp_list=listappend(emp_list,record_emp)>
        </cfif>
    </cfoutput>
</cfif>
<cfif len(branch_list)>
    <cfset branch_list=listsort(branch_list,"numeric","ASC",",")>
    <cfquery name="get_all_branch" datasource="#dsn#">
        SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (#branch_list#) ORDER BY BRANCH_ID
    </cfquery>
</cfif>
<cfif len(emp_list)>
    <cfset emp_list=listsort(emp_list,"numeric","ASC",",")>
    <cfquery name="get_employee" datasource="#dsn#">
        SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#emp_list#) ORDER BY EMPLOYEE_ID
    </cfquery>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=ehesap.list_import_process"  name="myform" method="post">
            <input type="hidden" name="form_submit" id="form_submit" value="1">
            <input type="hidden" name="modal_id" id="modal_id" value="<cfoutput>#attributes.modal_id#</cfoutput>">
            <cf_box_search more="0">
                <div class="form-group">
                
                    <select name="import_type" id="import_type" style="width:150px;">
                        <option value=""><cf_get_lang dictionary_id='57800.İşlem Tipi'></option>
                        <option value="1" <cfif isdefined("attributes.import_type") and (attributes.import_type eq 1)>selected</cfif>><cf_get_lang dictionary_id='65475.Tip 1 - Gün Bazlı import'></option>
                        <option value="5" <cfif isdefined("attributes.import_type") and (attributes.import_type eq 5)>selected</cfif>><cf_get_lang dictionary_id='65476.Tip 2 - Tek Gün Tipinde İmport'></option>
                        <option value="8" <cfif isdefined("attributes.import_type") and (attributes.import_type eq 8)>selected</cfif>><cf_get_lang dictionary_id='65477.Tip 3 - Ay Bazında Toplamlı'></option>
                        <option value="6" <cfif isdefined("attributes.import_type") and (attributes.import_type eq 6)>selected</cfif>><cf_get_lang dictionary_id ='54244.İzin İmport'></option>
                        <option value="2" <cfif isdefined("attributes.import_type") and (attributes.import_type eq 2)>selected</cfif>><cf_get_lang dictionary_id ='54068.Ödenek İmport'></option>
                        <option value="3" <cfif isdefined("attributes.import_type") and (attributes.import_type eq 3)>selected</cfif>><cf_get_lang dictionary_id ='54069.Kesinti İmport'></option>
                        <option value="4" <cfif isdefined("attributes.import_type") and (attributes.import_type eq 4)>selected</cfif>><cf_get_lang dictionary_id ='54070.Vergi İstisnaları İmport'></option>
                        <option value="9" <cfif isdefined("attributes.import_type") and (attributes.import_type eq 9)>selected</cfif>><cf_get_lang dictionary_id ="41795.OKES İmport"></option>
                    </select>
                </div>
                <div class="form-group">
                    <cfinclude template="../query/get_our_comp_and_branchs.cfm">
                    <select name="branch_id" id="branch_id" style="width:150px;">
                        <option value=""><cf_get_lang dictionary_id='29434.Şubeler'></option>
                        <cfoutput query="get_our_comp_and_branchs">
                            <option value="#BRANCH_ID#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>#BRANCH_NAME#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.import_payments')"><i class="fa fa-plus"></i></a>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="53664.İmport İşlemleri"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id ='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id ='54071.İmport Tipi'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id ='54072.İmport Eden'></th>
                    <th><cf_get_lang dictionary_id ='57627.Kayıt Tarihi'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none text-center"><a href="javascript://"><i class="fa fa-download" title="<cfoutput>#getLang('main',1931)#</cfoutput>" ></i></a></th>
                    <th width="20" class="header_icn_none text-center"><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.import_payments')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                            
                    <!-- sil -->  
                </tr>
            </thead>
            <tbody>
                <cfparam name="attributes.totalrecords" default="#get_imports.recordcount#">
                <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
                <cfif get_imports.recordcount>
                <cfoutput query="get_imports" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                    <tr>
                        
                        <td width="35">#currentrow#</td>
                        
                        <td>
                            <cfif process_type eq 1><cf_get_lang dictionary_id='65475.Tip 1 - Gün Bazlı import'>
                            <cfelseif process_type eq 2><cf_get_lang dictionary_id ='54068.Ödenek İmport'>
                            <cfelseif process_type eq 8><cf_get_lang dictionary_id='65477.Tip 3 - Ay Bazında Toplamlı'>
                            <cfelseif process_type eq 3><cf_get_lang dictionary_id ='54069.Kesinti İmport'>
                            <cfelseif process_type eq 4><cf_get_lang dictionary_id ='54070.Vergi İstisnaları İmport'>
                            <cfelseif process_type eq 5><cf_get_lang dictionary_id='65476.Tip 2 - Tek Gün Tipinde İmport'>
                            <cfelseif process_type eq 6><cf_get_lang dictionary_id ='54244.İzin İmport'> 
                            <cfelseif process_type eq 9><cf_get_lang dictionary_id ="41795.OKES İmport"> 
                            </cfif>
                        </td>
                        <td><cfif len(BRANCH_ID)>#get_all_branch.BRANCH_NAME[listfind(branch_list,BRANCH_ID,',')]#</cfif></td>
                        <td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#RECORD_EMP#');" class="tableyazi">#get_employee.EMPLOYEE_NAME[listfind(emp_list,RECORD_EMP,',')]# #get_employee.EMPLOYEE_SURNAME[listfind(emp_list,RECORD_EMP,',')]#</a></td>
                        <td>#dateformat(record_date,dateformat_style)# ( #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)# )</td>
                        <!-- sil -->
                        <td align="center" width="40">
                            <cf_get_server_file output_file="hr/eislem/#file_name#" output_server="#file_server_id#" output_type="2"  image_link="2" icon="fa fa-download" alt="#getLang('main',1931)#" title="#getLang('main',1931)#">
                        </td>
                        <td align="center" width="40">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='54074.Kayıtlı İmport Belgesini Siliyorsunuz Emin misiniz '></cfsavecontent>
                            <a href="javascript://" onClick="if (confirm('#message#')) openBoxDraggable('#request.self#?fuseaction=ehesap.emptypopup_del_import_payments&action_id=#ISLEM_ID#&modal_id=1');"><i class="fa fa-trash" title="<cf_get_lang dictionary_id ='57463.Sil'>"></i></a>
                        </td>
                        <!-- sil -->
                    </tr>
                </cfoutput>  
                <cfelse>	
                    <tr>
                        <td colspan="7"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>

        <cfif isdefined("attributes.form_submit") and len(attributes.form_submit)>
            <cfset url_str = '#url_str#&form_submit=#attributes.form_submit#'>
        </cfif>
        <cf_paging
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="ehesap.list_import_process#url_str#">
    </cf_box>
</div> 
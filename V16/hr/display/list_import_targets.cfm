<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset url_str = "">
<cfif isdefined("attributes.import_type") and len(attributes.import_type)>
	<cfset url_str = "#url_str#&import_type=#attributes.import_type#">
</cfif>
<cfif isdefined('attributes.form_submit')>
	<cfquery name="get_imports" datasource="#dsn#">
		SELECT 
			* 
		FROM 
			EMPLOYEES_PERFORMANCE_FILES 
		WHERE
			1=1
			<cfif isdefined("attributes.import_type") and len(attributes.import_type)>
				AND PROCESS_TYPE = #attributes.import_type#
			</cfif>
		ORDER BY 
			RECORD_DATE DESC
	</cfquery>
<cfelse>
	<cfset get_imports.recordcount = 0>
</cfif>
<cfset emp_list=''>
<cfif isdefined("attributes.form_submit") and get_imports.recordcount>
	<cfoutput query="get_imports">
		<cfif len(record_emp) and not listfind(emp_list,record_emp)>
			<cfset emp_list=listappend(emp_list,record_emp)>
		</cfif>
	</cfoutput>
</cfif>
<cfif len(emp_list)>
	<cfset emp_list=listsort(emp_list,"numeric","ASC",",")>
	<cfquery name="get_employee" datasource="#dsn#">
		SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#emp_list#) ORDER BY EMPLOYEE_ID
	</cfquery>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=hr.list_import_targets"  name="myform" method="post">
            <input type="hidden" name="form_submit" id="form_submit" value="1">
            <cf_box_search more="0">
                <div class="form-group">
                    <select name="import_type" id="import_type" style="width:150px;">
                        <option value=""><cf_get_lang dictionary_id='57800.İşlem Tipi'></option>
                        <option value="2" <cfif isdefined("attributes.import_type") and (attributes.import_type eq 2)>selected</cfif>><cf_get_lang dictionary_id="55935.Hedef İmport"></option>
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
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang(669,'İmport İşlemleri',55754)#" uidrop="1" hide_table_column="1">
        <cf_flat_list>
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id="36068.İmport Tipi"></th>
                    <th><cf_get_lang dictionary_id="54072.İmport Eden"></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <!-- sil --><th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.import_targets"><i class="fa fa-plus" title="<cf_get_lang_main no='170.Ekle'>" alt="<cf_get_lang_main no='170.Ekle'>"></i></a></th><!-- sil -->  
                </tr>
            </thead>
            <tbody>
                <cfparam name="attributes.totalrecords" default="#get_imports.recordcount#">
                <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
                <cfif get_imports.recordcount>
                <cfoutput query="get_imports" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                    <tr>
                        <td width="35">#currentrow#</td>
                        <td><cfif process_type eq 2><cf_get_lang dictionary_id ='55935.Hedef İmport'> </cfif>
                        </td>
                        <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#RECORD_EMP#','medium');" class="tableyazi">#get_employee.EMPLOYEE_NAME[listfind(emp_list,RECORD_EMP,',')]# #get_employee.EMPLOYEE_SURNAME[listfind(emp_list,RECORD_EMP,',')]#</a></td>
                        <td>#dateformat(record_date,dateformat_style)# ( #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)# )</td>
                        <!-- sil -->
                        <td style="text-align:center;" width="20">
                            <cf_get_server_file output_file="hr/eislem/#file_name#" output_server="#file_server_id#" output_type="2" small_image="/images/download.gif" image_link="1" title="#getLang(1931,'Dosya İndir',29728)#">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='55930.Kayıtlı İmport Belgesini Siliyorsunuz Emin misiniz? '></cfsavecontent>
                            <a href="javascript://" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=hr.emptypopup_del_import_targets&action_id=#ISLEM_ID#','small');"><i class="fa fa-minus" title="<cf_get_lang_main no ='51.Sil'>" alt="<cf_get_lang_main no ='51.Sil'>"></i></a>
                        </td>
                        <!-- sil -->
                    </tr>
                </cfoutput>  
                <cfelse>	
                    <tr>
                        <td colspan="6"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfif isdefined("attributes.form_submit") and len(attributes.form_submit)>
            <cfset url_str = '#url_str#&form_submit=#attributes.form_submit#'>
        </cfif>
        <cf_paging
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="hr.list_import_targets#url_str#">
    </cf_box>
</div>
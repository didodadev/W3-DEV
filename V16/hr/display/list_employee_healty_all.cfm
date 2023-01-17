<cfparam name="attributes.status" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.date_selection" default="1">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfif isdefined('attributes.form_submit')>
	<cfinclude template="../query/get_emp_healty_all.cfm">	
<cfelse>
	<cfset get_healty.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#GET_HEALTY.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=hr.list_employee_healty_all" method="post" name="form1">
            <input name="form_submit" id="form_submit" type="hidden" value="1">
            <cf_box_search>
                <div class="form-group">
                    <div class="input-group">
                        <cfinput type="text" name="keyword" id="keyword" placeholder="#getlang('main',48)#" value="#attributes.keyword#" maxlength="50">
                    </div>
                </div>
                <div class="form-group" id="item-report_type">
                    <select name="report_type" id="report_type">
                        <option value="1"<cfif attributes.report_type eq 1> selected</cfif>><cf_get_lang dictionary_id="55492.Çalışan Bazında"></option>
                        <option value="2"<cfif attributes.report_type eq 2> selected</cfif>><cf_get_lang dictionary_id="55520.Muayene Bazında"></option>
                    </select>
                </div>
                <div class="form-group" id="item-date_selection">
                    <select name="date_selection" id="date_selection">
                        <option value="1"<cfif attributes.date_selection eq 1> selected</cfif>><cf_get_lang dictionary_id="56543.İşe Giriş Tarihi"></option>
                        <option value="2"<cfif attributes.date_selection eq 2> selected</cfif>><cf_get_lang dictionary_id="55221.Son Muayene Tarihi"></option>
                        <option value="3"<cfif attributes.date_selection eq 3> selected</cfif>><cf_get_lang dictionary_id="55503.Bir Sonraki Tarihi"></option>
                    </select>
                </div>
                <div class="form-group" id="item-start_date">
                    <cfsavecontent variable="date_2"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" placeholder="#date_2#" validate="#validate_style#" maxlength="10" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>                    
                    </div>
                </div>
                <div class="form-group" id="item-finish_date">
                    <cfsavecontent variable="date_1"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                    <div class="input-group">
                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" placeholder="#date_1#" validate="#validate_style#" maxlength="10" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>                    
                    </div>
                </div>
                <div class="form-group medium">
                    <select name="status" id="status">
                        <option value="" <cfif attributes.status eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>	
                        <option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
                        <option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>			                        
                    </select>                    
                </div>
                <div class="form-group">
                    <div class="input-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
                    </div>
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                    <cf_wrk_search_button search_function="date_check(form1.start_date,form1.finish_date,'#message_date#')" button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="47131.İş Yeri Sağlık Muayeneleri"></cfsavecontent>
    <cf_box uidrop="1" hide_table_column="1" title="#message#"> 
        <cf_grid_list>  			
            <thead>  
                <cfif attributes.report_type eq 1>
                    <tr>
                        <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='57570.Hastanın Adı Soyadı'></th>
                        <th><cf_get_lang dictionary_id='57453.Şube'></th>
                        <th><cf_get_lang dictionary_id='57572.Departman'></th>
                        <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                        <th><cf_get_lang dictionary_id='56543.İşe Giriş Tarihi'></th>
                        <th><cf_get_lang dictionary_id='55221.Son Muayene Tarihi'></th>
                        <th><cf_get_lang dictionary_id='55223.Bir Sonraki Muayene Tarihi'></th>
                        <!-- sil -->
                        <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=hr.list_employee_healty_all&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                        <!-- sil -->
                    </tr>
                <cfelse>
                    <tr>
                        <th><cf_get_lang dictionary_id='57487.No'></th>
                        <th><cf_get_lang dictionary_id='57570.Hastanın Adı Soyadı'></th>
                        <th><cf_get_lang dictionary_id='56885.Muayene Tipi'></th>
                        <th><cf_get_lang dictionary_id='55221.Son Muayene Tarihi'></th>
                        <th><cf_get_lang dictionary_id='57684.Sonuç'></th>
                        <th><cf_get_lang dictionary_id='55223.Bir Sonraki Muayene Tarihi'></th>
                        <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=hr.list_employee_healty_all&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                    </tr>
                </cfif>
            </thead>  
            <tbody>
                <cfif GET_HEALTY.recordcount>
                    <cfquery NAME="GET_EMPLOYEE_DETAIL" DATASOURCE="#DSN#">
                        SELECT
                            ED.SEX,
                            ED.HOMEADDRESS, 
                            EI.BIRTH_DATE
                        FROM
                            EMPLOYEES_DETAIL AS ED,
                            EMPLOYEES_IDENTY AS EI
                        WHERE
                            ED.EMPLOYEE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_HEALTY.EMPLOYEE_ID#"> AND
                            EI.EMPLOYEE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_HEALTY.EMPLOYEE_ID#">
                    </cfquery>
                    <cfset currentrow_ = 0>
                    <cfif attributes.report_type eq 1>
                        <cfoutput QUERY="GET_HEALTY"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <cfset currentrow_ = currentrow_ + 1>
                            <tr>
                                <td width="35">#currentrow_#</td>
                                <td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
                                <td><cfif len(department_head)>#branch_name#</cfif></td>
                                <td><cfif len(department_head)>#department_head#</cfif></td>
                                <td>#position_name#</td>
                                <td><cfif len(START_DATE2)>#dateformat(get_healty.START_DATE2,dateformat_style)#</cfif></td>
                                <td><cfif len(inspection_date)>#dateformat(get_healty.inspection_date,dateformat_style)#</cfif></td>
                                <td><cfif len(inspection_date)>#dateformat(get_healty.next_inspection_date,dateformat_style)#</cfif></td>
                                <!-- sil -->
                                <td style="text-align:center;">
                                    <a onclick="openBoxDraggable('#request.self#?fuseaction=hr.list_employee_healty_all&event=det&healty_id=#HEALTY_ID#&employee_id=#employee_id#')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.güncelle'>" alt="<cf_get_lang dictionary_id='57464.güncelle'>"></i></a> 
                                </td>
                                <!-- sil -->
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <cfoutput QUERY="GET_HEALTY"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td>#get_healty.currentrow#</td>
                                <td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#');" class="tableyazi">
                                        <cfif len(relative_name)>
                                            #relative_name#(Çalışan Yakını)
                                        <cfelse>
                                            #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
                                        </cfif>
                                    </a>
                                </td>
                                <td><cfif len(get_healty.PROCESS_TYPE)>
                                    <cfset get_inspection_type = createObject("component","V16.settings.cfc.setupInspectionTypes").getInspectionTypes(inspection_type_id:get_healty.PROCESS_TYPE)>
                                        #get_inspection_type.inspection_type#
                                    </cfif>
                                </td>
                                <td><cfif len(inspection_date)>#dateformat(get_healty.inspection_date,dateformat_style)#</cfif></td>
                                <td><cfif get_healty.conclusion eq 1>Sevk
                                        <cfelseif get_healty.conclusion eq 2><cf_get_lang dictionary_id='55224.İstiharat'>
                                        <cfelseif get_healty.conclusion eq 3><cf_get_lang dictionary_id='55229.İşbaşı'>
                                        <cfelseif get_healty.conclusion eq 4><cf_get_lang dictionary_id='58156.Diğer'>
                                    </cfif>
                                </td>
                                <td><cfif len(inspection_date)>#dateformat(get_healty.next_inspection_date,dateformat_style)#</cfif></td>
                                <td style="text-align:center;"> 
                                    <a onclick="openBoxDraggable('#request.self#?fuseaction=hr.list_employee_healty_all&event=det&healty_id=#HEALTY_ID#&employee_id=#employee_id#')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.güncelle'>" alt="<cf_get_lang dictionary_id='57464.güncelle'>"></i></a> 
                                </td>
                            </tr>
                        </cfoutput>
                    </cfif>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif not GET_HEALTY.recordcount>
            <div class="ui-info-bottom">
                <p> <cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.filtre ediniz'>!</cfif></p>
            </div>
        </cfif>
        <cfset url_str = ''>
        <cfif isdefined('attributes.form_submit')>
            <cfset url_str = "#url_str#&form_submit=#attributes.form_submit#">
        </cfif>
        <cfif isdefined('attributes.keyword')>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif isdefined('attributes.date_selection')>
            <cfset url_str = "#url_str#&date_selection=#attributes.date_selection#">
        </cfif>
        <cfif isdefined('attributes.status')>
            <cfset url_str = "#url_str#&status=#attributes.status#">
        </cfif>
        <cfif isdefined('attributes.report_type')>
            <cfset url_str = "#url_str#&report_type=#attributes.report_type#">
        </cfif>
        <cfif isdefined('attributes.start_date')>
            <cfset url_str = "#url_str#&start_date=#attributes.start_date#">
        </cfif>
        <cfif isdefined('attributes.finish_date')>
            <cfset url_str = "#url_str#&finish_date=#attributes.finish_date#">
        </cfif>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="hr.list_employee_healty_all#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

<cfset search_year = year(#now()#)>
<cfparam name="attributes.position_cat_id" default='0'>
<cfparam name="attributes.emp_status" default='1'>
<cfparam name="attributes.search_tarih" default='#search_year#'>
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_total_perf_results.cfm">
<cfelse>
	<cfset get_total_perf_results.recordcount=0>
</cfif>
<cfset url_str = "">

<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.department_id")>
  <cfset url_str = "#url_str#&department_id=#attributes.department_id#">
</cfif>
<cfif isdefined("attributes.position_cat_id")>
  <cfset url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#">
</cfif>
<cfif isdefined("attributes.attenders")>
  <cfset url_str = "#url_str#&attenders=#attributes.attenders#">
</cfif>
<cfif isdefined('emp_status')>
  <cfset url_str = '#url_str#&emp_status=#attributes.emp_status#'>
</cfif>
<cfinclude template="../query/get_positions_notempty.cfm">
<cfinclude template="../query/get_position_cats.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_total_perf_results.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search" method="post" action="#request.self#?fuseaction=hr.list_total_performances">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group" item="item-keyword">
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('main',48)#">
                </div>
                <div class="form-group" item="item-department_id">
                    <select name="department_id" id="department_id">
                        <option value=""><cf_get_lang dictionary_id='55190.Departmanlar'>
                        <cfinclude template="../query/get_all_departments.cfm">
                        <cfoutput query="all_departments">
                            <cfif isdefined("attributes.department_id")>
                                <option value="#department_id#" <cfif attributes.department_id eq all_departments.department_id>selected</cfif>>&nbsp;#BRANCH_NAME# / #DEPARTMENT_HEAD#
                            <cfelse>
                                <option value="#department_id#">&nbsp;#BRANCH_NAME# / #DEPARTMENT_HEAD#
                            </cfif>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group" item="item-position_cat_id">
                    <select name="position_cat_id" id="position_cat_id">
                        <option value="0" selected><cf_get_lang dictionary_id='59004.Pozisyon Tipi'> 
                        <cfoutput query="get_position_cats">
                            <cfif isdefined("attributes.keyword")>
                                <option value="#position_cat_id#" <cfif attributes.position_cat_id eq position_cat_id>selected</cfif>>#position_cat#
                            <cfelse>
                                <option value="#position_cat_id#" <cfif attributes.position_cat_id eq position_cat_id>selected</cfif>>#position_cat#
                            </cfif>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group" item="item-search_tarih">
                    <select name="search_tarih" id="search_tarih">
                        <cfloop from="#search_year-10#" to="#search_year+10#" index="i">
                            <cfoutput>
                                <option value="#i#" <cfif i eq attributes.search_tarih>selected</cfif>>#i#</option>
                            </cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group small" item="item-maxrows">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="55183.Performanslar"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_flat_list>   
            <thead>
                <tr>
                    <!--- <td class="form-title">No</td> --->
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                    <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                    <th><cf_get_lang dictionary_id='58472.Dönem'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none text-center">
                        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_total_performances&event=addinfo"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                    </th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_total_perf_results.recordcount>
                    <cfoutput query="get_total_perf_results" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td width="35">#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" clasS="tableyazi">#employee_name# #employee_surname#</a></td>
                            <td><a href="#request.self#?fuseaction=hr.list_positions&event=upd&position_id=#position_id#" clasS="tableyazi">#position_name#</a></td>
                            <td> #DateFormat(START_DATE,dateformat_style)# - #DateFormat(FINISH_DATE,dateformat_style)#</td>
                            <!-- sil -->
                            <td style="text-align:center;">
                            <cfif not listfindnocase(denied_pages,'hr.list_total_performances&event=upd')>
                                <a href="#request.self#?fuseaction=hr.list_total_performances&event=upd&performance_id=#PERFORMANCE_ID#">
                                    <i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>
                                </a>
                            </cfif>
                            </td>
                            <!-- sil -->
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="5"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
            <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
        </cfif>            	
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="hr.list_total_performances#url_str#">
    </cf_box>
</div>
    <script type="text/javascript">
    	document.getElementById('keyword').focus();
    </script>

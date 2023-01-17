<cf_get_lang_set module_name="hr"><!--- sayfanin en altinda kapanisi var --->
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.is_hierarchy" default='1'>
<cfparam name="attributes.listing_type" default="1">
<cfif listgetat(attributes.fuseaction,1,'.') eq "service">
	<cfset module_name = "service">
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfinclude template="../query/get_workgroups.cfm">
<cfelse>
	<cfset get_workgroups.recordcount = 0>
</cfif>
<cfif listgetat(attributes.fuseaction,1,'.') eq "objects">
	<cfif isdefined("attributes.project_id")>
		<cfset action_url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_workgroup&project_id=#attributes.project_id#">
	<cfelse>
		<cfset action_url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_workgroup">
	</cfif>
<cfelse>
	<cfset action_url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_workgroup">
</cfif>
<cfquery name="DEP" datasource="#DSN#">
	SELECT 
		DEPARTMENT.DEPARTMENT_ID, 
		DEPARTMENT.DEPARTMENT_HEAD, 
		DEPARTMENT.ADMIN1_POSITION_CODE,
		DEPARTMENT.ADMIN2_POSITION_CODE,
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID
	FROM 
		DEPARTMENT,
		BRANCH
	WHERE 
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
	ORDER BY
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD
</cfquery>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_workgroups.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form1" method="post" action="#action_url#">
            <cfif isdefined("attributes.field_name")><cfinput type="hidden" name="field_name" value="#attributes.field_name#"></cfif>
            <cfif isdefined("attributes.field_id")><cfinput type="hidden" name="field_id" value="#attributes.field_id#"></cfif>
            <cf_box_search> 
                <cfinput type="hidden" value="1" name="is_form_submitted" id="is_form_submitted">
                <div class="form-group">
                    <cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#getLang('','Filtre',57460)#">
                </div>
                <div class="form-group">
                    <input type="text" name="hierarchy" id="hierarchy" value="<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)><cfoutput>#attributes.hierarchy#</cfoutput></cfif>" maxlength="255" placeholder="<cfoutput><cf_get_lang dictionary_id='57761.Hiyerarşi'></cfoutput>">
                </div>
                <div class="form-group">
                    <div class="input-group small">
                        <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı hatalı',57537)#" maxlength="3">
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-">
                        <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-12">
                            <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
                            <option value="all"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfquery name="get_branch" datasource="#dsn#">
                                    SELECT BRANCH_NAME,BRANCH_ID,BRANCH_STATUS FROM BRANCH WHERE BRANCH_STATUS = 1 AND COMPANY_ID = #session.ep.company_id# ORDER BY BRANCH_NAME
                                </cfquery>
                                <cfoutput query="get_branch">
                                    <option value="#branch_id#"<cfif isdefined("attributes.branch_id") and attributes.branch_id eq get_branch.branch_id>selected</cfif>>#branch_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-">
                        <label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-12">
                            <select name="department" id="department">
                                <option value="all"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and attributes.branch_id is not "all">
                                    <cfquery name="get_department" datasource="#dsn#">
                                        SELECT * FROM DEPARTMENT WHERE BRANCH_ID = #attributes.branch_id# AND DEPARTMENT_STATUS =1 AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
                                    </cfquery>
                                    <cfoutput query="get_department"><option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#DEPARTMENT_HEAD#</option></cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-">
                        <label class="col col-12"><cf_get_lang dictionary_id="57761.Hiyerarşi"></label>
                        <div class="col col-12">
                            <select name="listing_type" id="listing_type">
                                <option value="1" <cfif attributes.listing_type eq 1>selected</cfif>><cf_get_lang dictionary_id="55598.Hiyerarşik Artan"></option>
                                <option value="2" <cfif attributes.listing_type eq 2>selected</cfif>><cf_get_lang dictionary_id="56509.Alfabetik Artan"></option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-">
                        <label class="col col-12"><cf_get_lang dictionary_id="57982.Tür"></label>
                        <div class="col col-12">
                            <select name="is_hierarchy" id="is_hierarchy">
                                <option value=""><cf_get_lang dictionary_id='57708.Tüm'></option>
                                <option value="1" <cfif attributes.is_hierarchy eq 1> selected</cfif>><cf_get_lang dictionary_id="56380.Organizasyonel"></option>
                                <option value="0" <cfif attributes.is_hierarchy eq 0> selected</cfif>><cf_get_lang dictionary_id="56381.Proje/Destek/Müşteri"></option>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Servis İş Grupları',41733)#" uidrop="1" hide_table_column="1">
        <cf_grid_list> 
            <cfif not isdefined("attributes.department_id")>
                <cfset attributes.department_id="">
            </cfif>
            <thead>
                <tr> 
                    <th width="35"><cf_get_lang dictionary_id='57487.No'></th>
                    <th width="35"><cf_get_lang dictionary_id='57761.Hiyerarşi'></th>
                    <th><cf_get_lang dictionary_id='58140.İş Grubu'></th>
                    <th><cf_get_lang dictionary_id="56319.Organizasyon Ünitesi"></th>
                    <th><cf_get_lang dictionary_id='57578.Yetkili'></th>
                    <!-- sil -->
                    <cfif listgetat(attributes.fuseaction,1,'.') is not 'service'>
                        <th><cf_get_lang dictionary_id ='56382.İş Grupları Arası Şema'></th>
                    </cfif>

                    <th width="50" class="text-center">
                    <div class="imput-group"<cf_get_lang dictionary_id='63246.Şema'> > 
                        <span class="input-group-addon icon-branch"></span>
                    </div>
                    </th>
                    <th width="20" class="header_icn_none text-center">
                        <cfif isdefined('attributes.project_id') and len(attributes.project_id)>
                            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_form_add_list_pro_group&project_id=<cfoutput>#attributes.PROJECT_ID#</cfoutput>','list');"></a>
                        <cfelse>
                            <a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.list_workgroup&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                        </cfif>
                    </th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_workgroups.recordcount>
                    <cfset our_company_list = ''>
                    <cfset branch_list = ''>
                    <cfset grup_list = ''>
                    <cfset manager_list = ''>
                    <cfset department_list = ''>
                    <cfoutput query="get_workgroups" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfset our_company_list = listappend(our_company_list,get_workgroups.OUR_COMPANY_ID,',')>
                        <cfset branch_list = listappend(branch_list,get_workgroups.BRANCH_ID,',')>
                        <cfset grup_list = listappend(grup_list,get_workgroups.HEADQUARTERS_ID,',')>
                        <cfset department_list = listappend(department_list,get_workgroups.DEPARTMENT_ID,',')>
                        <cfset manager_list = listappend(manager_list,get_workgroups.MANAGER_EMP_ID,',')>
                    </cfoutput>
                    <cfset our_company_list = listsort(our_company_list,'numeric','ASC',',')>
                    <cfset manager_list = listsort(manager_list,'numeric','ASC',',')>
                    <cfset branch_list = listsort(branch_list,'numeric','ASC',',')>
                    <cfset department_list = listsort(department_list,'numeric','ASC',',')>
                    <cfset grup_list = listsort(grup_list,'numeric','ASC',',')>

                    <cfif listlen(manager_list)>
                        <cfquery name="get_manager_employees" datasource="#dsn#">
                            SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#manager_list#) ORDER BY EMPLOYEE_ID
                        </cfquery>
                        <cfset main_employee_list = listsort(listdeleteduplicates(valuelist(get_manager_employees.EMPLOYEE_ID,',')),'numeric','ASC',',')>
                    </cfif>
                    
                    <cfif listlen(our_company_list)>
                        <cfquery name="get_our_companies" datasource="#dsn#">
                            SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID IN (#our_company_list#) ORDER BY COMP_ID
                        </cfquery>
                        <cfset our_company_list = listsort(listdeleteduplicates(valuelist(get_our_companies.COMP_ID,',')),'numeric','ASC',',')>
                    </cfif>
                    
                    <cfif listlen(branch_list)>
                        <cfquery name="get_our_branch" datasource="#dsn#">
                            SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (#branch_list#) ORDER BY BRANCH_ID
                        </cfquery>
                        <cfset branch_list = listsort(listdeleteduplicates(valuelist(get_our_branch.BRANCH_ID,',')),'numeric','ASC',',')>
                    </cfif>
                    
                    <cfif listlen(grup_list)>
                        <cfquery name="get_our_heads" datasource="#dsn#">
                            SELECT HEADQUARTERS_ID,NAME FROM SETUP_HEADQUARTERS WHERE HEADQUARTERS_ID IN (#grup_list#) ORDER BY HEADQUARTERS_ID
                        </cfquery>
                        <cfset grup_list = listsort(listdeleteduplicates(valuelist(get_our_heads.HEADQUARTERS_ID,',')),'numeric','ASC',',')>
                    </cfif>
                    
                    <cfif listlen(department_list)>
                        <cfquery name="get_our_department" datasource="#dsn#">
                            SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#department_list#) ORDER BY DEPARTMENT_ID
                        </cfquery>
                        <cfset department_list = listsort(listdeleteduplicates(valuelist(get_our_department.DEPARTMENT_ID,',')),'numeric','ASC',',')>
                    </cfif>
                <cfoutput query="get_workgroups" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 			 
                    <tr>
                        <td class="text-center">#currentrow#</td>
                        <td class="text-center">#hierarchy#</td>
                        <td>
                            <cfif listgetat(attributes.fuseaction,1,'.') is 'objects'>
                                <a href="javascript://" onclick="add_work('#WORKGROUP_ID#','#WORKGROUP_NAME#');" class="tableyazi"><cfloop from="1" to="#listlen(hierarchy,'.')#" index="i">&nbsp;</cfloop>#workgroup_name#</a>
                            <cfelse>
                                <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_workgroup&event=upd&workgroup_id=#workgroup_id#" class="tableyazi"><cfloop from="1" to="#listlen(hierarchy,'.')#" index="i">&nbsp;</cfloop>#workgroup_name#</a>
                            </cfif>
                        </td>
                        <td><cfif len(headquarters_id)>
                                <cfquery name="GET_MY_HEAD" dbtype="query">
                                    SELECT NAME FROM GET_OUR_HEADS WHERE HEADQUARTERS_ID = #headquarters_id#
                                </cfquery>
                                #get_my_head.name#,
                            </cfif>
                            <cfif len(our_company_id)>#get_our_companies.company_name[listfind(our_company_list,our_company_id,',')]#,</cfif>
                            <cfif len(branch_id)>#get_our_branch.branch_name[listfind(branch_list,branch_id,',')]#,</cfif>
                            <cfif len(department_id)>#get_our_department.department_head[listfind(department_list,department_id,',')]#</cfif>
                        </td>
                        <td>
                        <cfif len(manager_emp_id)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#manager_emp_id#','medium');" class="tableyazi">#get_manager_employees.employee_name[listfind(main_employee_list,manager_emp_id,',')]# #get_manager_employees.employee_surname[listfind(main_employee_list,manager_emp_id,',')]#</a></cfif>
                        </td>
                        <!-- sil -->
                        <cfif #listgetat(attributes.fuseaction,1,'.')# is not 'service'>
                        <td><cfif sub_workgroup eq 1><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_draw_workgroups&hierarchy_code=#hierarchy#','page');"><img src="/images/shema_list.gif" title="<cf_get_lang dictionary_id ='56382.İş Grupları Arası Şema'>"></a></cfif></td>
                        </cfif>
                        <td class="text-center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_draw_workgroup&workgroup_id=#workgroup_id#','list');"><i class="fa fa-male" title="<cf_get_lang dictionary_id ='56383.Roller Arası Şema'>" alt="<cf_get_lang dictionary_id ='56383.Roller Arası Şema'>"></i></a></td>
                        
                        <td class="text-center">
                            <cfif listgetat(attributes.fuseaction,1,'.') is 'objects'><!--- İk yada objects den gelmesine bağlı olarak aynı dosyalara farklı switchler verildi. --->
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_list_pro_group&workgroup_id=#workgroup_id#','page')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                            <cfelse>
                                <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_workgroup&event=upd&workgroup_id=#workgroup_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                            </cfif>
                        </td>   
                        <!-- sil -->
                    </tr>
                </cfoutput> 
                <cfelse>
                    <tr>
                        <td colspan="8"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif>
                        </td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list> 
        <cfset url_string = "">
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cfif listgetat(attributes.fuseaction,1,'.') eq 'objects'>
                <cfset url_string = "#listgetat(attributes.fuseaction,1,'.')#.popup_list_workgroup">
                <cfif isdefined("attributes.project_id")>
                    <cfset url_string = "#url_string#&project_id=#attributes.project_id#">
                </cfif> 
                <cfif isdefined("field_id")>
                <cfset url_string = "#url_string#&field_id=#field_id#">
                </cfif>
                <cfif isdefined("field_name")>
                <cfset url_string = "#url_string#&field_name=#field_name#">
                </cfif>
            <cfelse>
                <cfset url_string = "#listgetat(attributes.fuseaction,1,'.')#.list_workgroup">
            </cfif>	
            <cfif len(attributes.keyword)>
                <cfset url_string = "#url_string#&keyword=#attributes.keyword#">
            </cfif>
            <cfif len(attributes.is_hierarchy)>
                <cfset url_string = "#url_string#&is_hierarchy=#attributes.is_hierarchy#">
            </cfif>
            <cfset url_string = "#url_string#&is_form_submitted=1">
            <cfif len(attributes.listing_type)>
            <cfset url_string = "#url_string#&listing_type=#attributes.listing_type#">
            </cfif>
            <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#url_string#">
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function add_work(id,name)
	{
		<cfif isdefined("attributes.field_name")>
			opener.<cfoutput>#field_name#</cfoutput>.value = name;
		</cfif>
		<cfif isdefined("attributes.field_id")>
			opener.<cfoutput>#field_id#</cfoutput>.value = id;
		</cfif>
		window.close();
	}
	function showDepartment(branch_id)	
	{
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'department_place',1,'İlişkili Departmanlar');
		}
	}
</script>
<cf_get_lang_set module_name="hr"><!--- sayfanin en ustunde acilisi var --->

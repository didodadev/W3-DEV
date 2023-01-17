<!--- File: list_hr.cfm
    Author: Canan Ebret <cananebret@workcube.com>
    Date: 12.09.2019
    Controller: -
    Description: Daha önce oluşturulan Kim kimdir sayfası, sayfalama yapısı yeniden düzenlendi.​
 --->
<!--- INSTANT MESSAGE 1-2 ICON ve ENTEGRASYONU Linki | MG 20101130 --->
<!---<cfscript>
	function IMsgIcon()
	{
		ImSayisi = 2;
		for (Sayac = 1; Sayac <= ImSayisi; Sayac++)
		{
			stil = "style=""cursor: hand;""";
			if (Sayac == 1)
				Say = "";
			else
				Say = Sayac;
			if (Len(Evaluate("IMCAT#Say#_ICON")))
			{
				"Im#Say#Address" = Evaluate("IM#Say#");
				"Link#Say#Type" = Evaluate("IMCAT#Say#_LINK_TYPE");
			}
			else
			{
				"Im#Say#Address" = "Bu Instant Mesajın kategorisi bulunamadı, lütfen IM Bilgilerinizi güncelleyiniz.";
				"IMCAT#Say#_ICON" = "icons_invalid.gif";
				"Link#Say#Type" = "";
			}
			"Link#Say#" = Evaluate("Link#Say#Type") & Evaluate("Im#Say#Address");
			if (Evaluate("Link#Say#Type") == "")
			{
				"Link#Say#" = "##";
				stil = "";
			}
			if (Len(Evaluate("IMCAT#Say#_ID")))
				WriteOutput(" <img onclick=""javascript:location.href='" & Evaluate("Link#Say#") & "';"" src=""/documents/settings/#Evaluate("IMCAT#Say#_ICON")#"" border=""0"" " & stil & " alt=""" & Evaluate("Im#Say#Address") & """>");
		}
	}
</cfscript>--->
<cf_xml_page_edit fuseact="objects.popup_emp_det">
    <cfparam name="attributes.form_submitted" default="">
    <cfinclude template="../query/get_position_cats.cfm">
    <cfset listHrCFC = CreateObject("component","V16.rules.cfc.list_hr")>
    <cfset getHrCFC = CreateObject("component","V16.hr.cfc.get_hrs")>
    <cfset HR = getHrCFC.get_hr(
            keyword: attributes.keyword?:"",
            keyword2: attributes.keyword2?:"",
            position_cat_id: position_cat_id?:"",
            title_id: attributes.title_id?:"",
            branch_id: attributes.branch_id?:"",
            func_id: attributes.func_id?:"",
            organization_step_id:attributes.organization_step_id?:"",
            position_name:attributes.position_name?:"",
            collar_type:attributes.collar_type?:"",
            emp_status: attributes.emp_status?:"",
            hierarchy: attributes.hierarchy?:"",
            emp_code_list:attributes.emp_code_list?:"",
            department: attributes.department?:"",
            process_stage: attributes.process_stage?:"",
            duty_type: attributes.duty_type?:"",
            fusebox_dynamic_hierarchy: fusebox.dynamic_hierarchy,
            database_type: database_type,
            maxrows:attributes.maxrows?:"",
            startrow:attributes.startrow?:""
            )>
    <cfset TITLES= listHrCFC.TITLES()>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.department_id" default="0">
    <cfif isdefined("attributes.keyword")>
        <cfset filtered = 1>	
    <cfelse>
        <cfset filtered = 0>
    </cfif>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.hierarchy" default="">
    <cfparam name="attributes.position_cat_id" default="">
    <cfparam name="attributes.title_id" default="">
    <cfset url_str = "">
    <cfif len(attributes.keyword)>
        <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
    </cfif>	
    <cfif len(attributes.hierarchy)>
        <cfset url_str = "#url_str#&hierarchy=#attributes.hierarchy#">
    </cfif>
    <cfif len(attributes.position_cat_id)>
        <cfset url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#">
    </cfif>
    <cfif len(attributes.title_id)>
        <cfset url_str="#url_str#&title_id=#attributes.title_id#">
    </cfif>
    <cfif isdefined("attributes.branch_id")>
        <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
        <cfset attributes.id = attributes.branch_id>
    </cfif>
    <cfif isdefined("attributes.emp_status") and len(attributes.emp_status)>
        <cfset url_str = "#url_str#&emp_status=#attributes.emp_status#">
    </cfif>
    <cfinclude template="../query/get_our_comp_and_branchs.cfm">
    <cfparam name="attributes.totalrecords" default='0'>
    <cfparam name="attributes.page" default='1'>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif filtered eq 1>
        <cfset HR = getHrCFC.get_hr(
            keyword: attributes.keyword?:"",
            keyword2: attributes.keyword2?:"",
            position_cat_id: position_cat_id?:"",
            title_id: attributes.title_id?:"",
            branch_id: attributes.branch_id?:"",
            func_id: attributes.func_id?:"",
            organization_step_id:attributes.organization_step_id?:"",
            position_name:attributes.position_name?:"",
            collar_type:attributes.collar_type?:"",
            emp_status: attributes.emp_status?:"",
            hierarchy: attributes.hierarchy?:"",
            emp_code_list:attributes.emp_code_list?:"",
            department: attributes.department?:"",
            process_stage: attributes.process_stage?:"",
            duty_type: attributes.duty_type?:"",
            fusebox_dynamic_hierarchy: fusebox.dynamic_hierarchy,
            database_type: database_type,
            maxrows:attributes.maxrows?:"",
            startrow:attributes.startrow?:""
            )>
        <cfset attributes.totalrecords = HR.recordcount>
    </cfif>
    <style><!--- Kaldırılacak --->
    .pageMainLayout{padding:0;}
    </style>
    <cfinclude template="rule_menu.cfm">
        <cfif HR.recordcount>
            <cfparam name="attributes.page" default="1">
            <cfparam name="attributes.totalrecords" default='#HR.recordcount#'>
            <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>		
            <cfset employee_list = ''>
            <cfset mobiltel_list = "">
            <cfoutput query="HR" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <cfif len(employee_id) and not ListFind(mobiltel_list,employee_id,',')>
                    <cfset mobiltel_list = ListAppend(mobiltel_list,employee_id,',')>
                </cfif>
                <cfset employee_list = listappend(employee_list,HR.employee_id,',')>
            </cfoutput>
            <cfif ListLen(mobiltel_list)>
                <cfset get_employee_detail= listHrCFC.GetEmployeeDetail(mobiltel_list:mobiltel_list)>
                <cfset mobiltel_list = ListSort(ListDeleteDuplicates(ValueList(get_employee_detail.employee_id,",")),"numeric","asc",",")>
            </cfif>
            <cfset GET_POSITIONS= listHrCFC.GetPositions(employee_list:employee_list)>
            <div class="wrapper" id="who_content">
                <div class="search_group">    
                    <cf_box>
                        <cfform name="employees" method="post" action="#request.self#?fuseaction=rule.list_hr">
                            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                            <cf_box_search id="rule_list_hr" more="0" plus="0">
                                <div class="form-group">
                                    <div class="blog_title" style="margin:5px;">
                                        <i class="fa fa-users"></i>
                                        <cf_get_lang dictionary_id='40779.Kim kimdir'>
                                    </div> 
                                </div>
                                <div class="form-group">
                                    <cfinput type="text" name="keyword" placeholder="#getLang('','Who are you looking for?',61433)#"  value="#attributes.keyword#" maxlength="50">
                                </div>
                                <div class="form-group">
                                    <select name="emp_status" id="emp_status">
                                        <option value="1" <cfif isDefined("attributes.emp_status")and (attributes.emp_status eq 1)>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                        <option value="-1" <cfif isDefined("attributes.emp_status")and(attributes.emp_status eq -1)>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                                        <option value="0" <cfif isDefined("attributes.emp_status")and (attributes.emp_status eq 0)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                    </select>
                                </div>
                                <div class="form-group small">
                                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#!" maxlength="3">
                                </div>
                                <div class="form-group">
                                    <cf_wrk_search_button button_type="4"> 	
                                </div>
                            </cf_box_search>
                            <script type="text/javascript">
                                $(document).ready(function(){
                                    $( "form[name=employees] #keyword" ).focus();
                                });
                            </script>
                        </cfform>
                    </cf_box>
                </div>
                <cfoutput query="HR" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                    <cfset GET_POSITION = listHrCFC.GetPosition(employee_id:employee_id)>
                    <div class="col col-3 col-md-3 col-sm-4 col-xs-12">
                        <cf_box>
                            <div class="who_item">
                                <div class="who_item_img">
                                    <cfif len(PHOTO)>
                                        <img src="/documents/hr/#PHOTO#">
                                    <cfelseif SEX eq 1>
                                        <img src="/images/maleicon.jpg">
                                    <cfelse>
                                        <img src="/images/femaleicon.jpg">
                                    </cfif>
                                </div>
                                <div class="who_info">
                                    <div class="who_info_name">							
                                        <a href="#request.self#?fuseaction=rule.list_hr&event=det&emp_id=#employee_id#">#employee_name# #employee_surname#</a>
                                    </div>
                                    <div class="who_info_desc">
                                        <p><cfif get_position.recordcount>#get_position.department_head#, #get_position.position_name#</cfif></p>
                                    </div>
                                </div> 
                                <div class="who_btn">
                                    <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=myhome.popup_form_add_warning&employee_id=#employee_id#')"><i class="catalyst-share"></i>Workshare</a>
                                    <a href="javascript://" onclick="window.open('index.cfm?fuseaction=objects.workflowpages&tab=1&subtab=1','Chatflow');"><i class="catalyst-bubbles"></i>Chatflow</a>
                                </div>
                            </div>
                        </cf_box>
                    </div>										
                </cfoutput>
            </div>
        <cfelse>
            <cfif filtered><div class="ui-info-bottom"><p><cf_get_lang_main no='1074.Kayıt Bulunamadı'>!</p></div><cfelse>
        </cfif>
    </cfif>      
    <style>
        .loading-area{
            display:flex;
        }
    </style>      
    <cfif HR.recordcount gt attributes.maxrows>
        <cf_loader 
            data_type="HTML" 
            win_scroll="0"
            totalCount="#HR.QUERY_COUNT#"
            startrow="#attributes.startrow#" 
            maxrows="#attributes.maxrows#" 
            append_Element="who_content" 
            href="#request.self#?fuseaction=rule.ajax_hr_list&#url_str#">
    </cfif>
<script type="text/javascript">
    document.getElementById('keyword').focus();
</script>
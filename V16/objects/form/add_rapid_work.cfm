<cfparam name="attributes.type" default="0">
<cfparam name="attributes.process_id" default="">
<cfparam name="attributes.milestone_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.work_cat" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.work_cat" default="">
<cfset getComponentKanban = createObject('component','V16.report.cfc.kanban_board')><!--- İşler Component --->
<cfset get_process_types  = getComponentKanban.GET_PROCESS_TYPES()>
<cfset getComponentWork = createObject('component','V16.project.cfc.get_work')><!--- İşler Component --->
<cfset get_work_cat = getComponentWork.GET_WORK_CAT()><!--- Kategori --->
<cfset get_cats = getComponentWork.get_cats()><!---Öncelik --->
<cfset get_workgroups = getComponentWork.GET_WORKGROUPS()><!--- İş Grubu --->
<cfset get_activity = getComponentWork.GET_ACTIVITY()><!--- Aktivite Tipi --->
<cfset get_money = getComponentWork.GET_MONEY()><!---money --->
<cfset GET_SPECIAL_DEFINITION = getComponentWork.GET_SPECIAL_DEFINITION()><!---Özel Tanım --->
<cfsavecontent variable = "add_work">
    <cfif isdefined("attributes.work_id") and len(attributes.work_id)>
        <cf_get_lang dictionary_id="55061.İş Detay">
    <cfelse>
        <cf_get_lang dictionary_id="57933.İş ekle">
    </cfif> 
</cfsavecontent>
<cfsavecontent variable = "add_work_2"><cf_get_lang dictionary_id = "30219.Ek Bilgiler"></cfsavecontent>
    <cfsavecontent variable = "add_work_1"><cf_get_lang dictionary_id="58131.Temel Bilgiler"></cfsavecontent>
<cfform name="add_work" id="add_work" method="post" action="">
    <cf_box
        info_href_3="#isdefined("attributes.work_id") and len(attributes.work_id) ? "#request.self#?fuseaction=project.works&event=det&id=#attributes.work_id#" : ""#" 
        info_title_4 = "#isdefined("attributes.work_id") and len(attributes.work_id) ? "İş Detayına Git" : ""#" 
        title="#add_work#" resize="0" closable="1" draggable="1" id="add_work_box">
        <cf_tab divID = "sayfa_1,sayfa_2" defaultOpen="sayfa_1" divLang = "#add_work_1#;#add_work_2#" tabcolor = "fff">
            <div id = "unique_sayfa_1" class = "uniqueBox">            
                <cf_box_elements vertical="1">
                    <cfoutput>
                        <input type="Hidden" name="type" id="type" value="">
                    </cfoutput>
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-head">
                        <label><cf_get_lang dictionary_id="58820.başlık"></label>
                        <input type="text" id="work_head" name="work_head" value="">
                    </div>
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-detail">
                        <label><cf_get_lang dictionary_id="57629.açıklama"></label>
                        <textarea id="work_detail" name="work_detail" rows="4" cols="50"></textarea>
                    </div>
                    <cfif attributes.type eq 1>
                        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item-project_id">
                            <label><cf_get_lang dictionary_id='57416.Proje'></label>      
                            <div class="input-group">
                                <cfif isdefined('attributes.project_id') and len(attributes.project_id)>
                                    <cfquery name="GET_PRO_NAME" datasource="#DSN#">
                                        SELECT PROJECT_HEAD,TARGET_START,TARGET_FINISH FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                                    </cfquery>
                                </cfif>
                                <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
                                <input type="text" name="project_head"  id="project_head" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD,FULLNAME','get_project','','PROJECT_ID,TARGET_START,TARGET_FINISH','project_id','','3','200','add_milestone();');" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)><cfoutput>#GET_PRO_NAME.PROJECT_HEAD#</cfoutput></cfif>" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_head=add_work.project_head&project_id=add_work.project_id&function_name=add_milestone');"></span>                   
                            </div>
                        </div>
                        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item-milestone_id">
                            <label>Milestone</label>
                            <select name="milestone_id" id="milestone_id" >
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif isdefined('attributes.project_id') and len(attributes.project_id)>
                                    <cfquery name="GET_WORK_MILESTONE" datasource="#DSN#">
                                        SELECT WORK_ID,WORK_HEAD FROM PRO_WORKS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND IS_MILESTONE = 1
                                    </cfquery>
                                    <cfoutput query="get_work_milestone">
                                        <option value="#work_id#" <cfif isdefined("attributes.work_id") and attributes.work_id eq work_id>selected</cfif>>#work_head#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </div>
                        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item-process_stage">
                            <label><cf_get_lang dictionary_id='57482.aşama'></label>      
                            <select name="process_stage" id="process_stage" >
                            <option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
                            <cfoutput query="get_process_types">
                                <option value="#process_row_id#" <cfif isdefined("attributes.process_stage") and attributes.process_stage eq process_row_id>selected</cfif>>#stage#</option>
                            </cfoutput>
                            </select>
                        </div>
                    <cfelse>
                        <cfoutput>
                            <input type="hidden" name="project_id" id="project_id" value="#attributes.project_id#">
                            <input type="hidden" name="milestone_id" id="milestone_id" value="#attributes.milestone_id#">
                            <input type="Hidden" name="process_id" id="process_id" value="#attributes.process_id#">
                        </cfoutput>
                    </cfif>
                    <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item-process_cat">
                        <label><cf_get_lang dictionary_id='57486.kategori'></label>      
                        <select name="work_cat" id="work_cat" >
                            <option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
                            <cfoutput query="get_work_cat">
                                <option value="#WORK_CAT_ID#" <cfif isdefined("attributes.work_cat") and attributes.work_cat eq WORK_CAT_ID>selected</cfif>>#WORK_CAT#</option>
                            </cfoutput>
                        </select>
                    </div>
                    <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item-estimated_time_hour" >
                        <label><cf_get_lang dictionary_id='38215.Öngörülen Süre'></label> 
                            <cfif isdefined("attributes.work_id") and len(attributes.work_id)>
                                <cfset totalminute = attributes.totalminute>
                                <cfset totalhour = attributes.totalhour>
                            <cfelse>
                                <cfset totalminute = "">
                                <cfset totalhour = "">
                            </cfif>    
                            <cfoutput>                                      
                        <div class="col col-6">
                            <input type="text" name="estimated_hour" id="estimated_hour" validate="integer" placeHolder="#getLang('','',57491)#" value="#totalhour#" onKeyUp="isNumber(this);" >
                        </div>
                        <div class="col col-6">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='60617.Lütfen 60dan Küçük Bir Değer Giriniz'></cfsavecontent>
                            <input type="text" name="estimated_minute" id="estimated_minute" value="#totalminute#" placeHolder="#getLang('','',58827)#" onKeyUp="isNumber(this);" range="0,59" onBlur="estimated_finishdate(this.value,'minute')" message="#message#">                    
                        </div></cfoutput> 
                    </div>  
                    <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item-terminate_date" >
                        <label><cf_get_lang dictionary_id='60609.Termin tarihi'></label>        
                        <div class="input-group">
                            <cfoutput>
                                <input name="terminate_date" id="terminate_date" validate="#validate_style#" maxlength="10" type="text" value="#dateformat(now(),dateformat_style)#" >
                                <span class="input-group-addon"><cf_wrk_date_image date_field="terminate_date"></span>
                                <span class="input-group-addon no-bg"></span>
                                <cf_wrkTimeFormat name="terminate_hour" value="">                                          
                            </cfoutput>
                        </div> 
                    </div>  
                    <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item_pro_employee_id">
                        <label><cf_get_lang dictionary_id="57569.Görevli"></label>
                        <div class="input-group">
                            <cfif isdefined('attributes.pro_employee_id') and len(attributes.pro_employee_id)>
                                <cfset attributes.pro_employee = get_emp_info(attributes.pro_employee_id,0,0)>
                            </cfif>
                            <input type="hidden" name="pro_employee_id"  id="pro_employee_id" value="<cfif isdefined('attributes.pro_employee_id') and len(attributes.pro_employee)><cfoutput>#attributes.pro_employee_id#</cfoutput></cfif>">
                            <input type="text" name="pro_employee" id="pro_employee"  value="<cfif isdefined('attributes.pro_employee') and len(attributes.pro_employee)><cfoutput>#attributes.pro_employee#</cfoutput></cfif>" style="width:100px;" onfocus="AutoComplete_Create('pro_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','pro_employee_id','','3','135');" autocomplete="off">	
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_work.pro_employee_id&field_name=add_work.pro_employee&select_list=1','list');"></span>
                        </div>
                    </div>
                    <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item-priority_cat">
                        <label><cf_get_lang dictionary_id='57485.Öncelik'>*</label>
                        <select name="priority_cat" id="priority_cat" >
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="get_cats">
                                <option value="#priority_id#">#priority#</option>
                            </cfoutput>
                        </select>
                    </div>             
                </cf_box_elements>
            </div>
            <div id = "unique_sayfa_2" class = "uniqueBox">
                <cf_box_elements vertical="1">
                    <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item_workgroup_id">
                        <label><cf_get_lang dictionary_id='58140.İş Grubu'></label>
                        <select name="workgroup_id" id="workgroup_id" >
                            <option value=""><cf_get_lang dictionary_id='58140.İş Grubu'></option>
                            <cfoutput query="get_workgroups">
                                <option value="#workgroup_id#">#workgroup_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                    <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item_about_company">
                        <label><cf_get_lang dictionary_id='57574.Şirket'> - <cf_get_lang dictionary_id='57578.Yetkili'></label>
                        <div class="input-group">
                            <input type="text" name="about_company" id="about_company"  value="" onfocus="AutoComplete_Create('about_company','MEMBER_PARTNER_NAME3','MEMBER_PARTNER_NAME3','get_member_autocomplete','\'1,2\',0,0','COMPANY_ID,PARTNER_ID','company_id,company_partner_id','','3','150');">
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=add_work.company_id&field_name=add_work.about_company&field_id=add_work.company_partner_id&par_con=1&select_list=7</cfoutput>','list')"></span>
                            <input type="hidden" name="company_partner_id" id="company_partner_id" value="">
                            <input type="hidden" name="company_id" id="company_id" value="">
                        </div>
                    </div>
                    <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item_activity_type">
                        <label><cf_get_lang dictionary_id='38378.Aktivite Tipi'></label>
                        <select name="activity_type" id="activity_type" >
                            <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                            <cfoutput query="get_activity">
                                <option value="#ACTIVITY_ID#">#ACTIVITY_NAME#</option>
                            </cfoutput>
                        </select>
                    </div>
                    <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item_startdate_plan" >
                        <label><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>*</label>
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                            <cfinput name="startdate_plan" id="startdate_plan" required="Yes" validate="#validate_style#" message="#message#" maxlength="10" type="text" value="#DateFormat(now(),dateformat_style)#">	
                            <span class="input-group-addon"><cf_wrk_date_image date_field="startdate_plan"></span>
                            <input type="hidden" name="start_hour" id="start_hour" value="8">
                        </div> 
                    </div>
                    <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item_finishdate_plan" >
                        <label><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                            <cfinput required="Yes" validate="#validate_style#" maxlength="10" message="#message#" type="text"  id="finishdate_plan" name="finishdate_plan" value="#DateFormat(now(),dateformat_style)#"  readonly>
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate_plan"></span>
                            <input type="hidden" name="finish_hour_plan" id="finish_hour_plan" value="23">	                           
                        </div>   
                    </div>
                    <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item_expected_budget">
                        <label><cf_get_lang dictionary_id='38175.Tahmini Bütçe'></label>
                        <div class="input-group">
                            <cfinput type="text" name="expected_budget" id="expected_budget"  value="" passthrough="onkeyup=""return(formatcurrency(this,event));""" class="moneybox">            
                            <span class="input-group-addon width">
                                <select name="expected_budget_money" id="expected_budget_money" class="formselect" >
                                    <cfoutput query="get_money">
                                        <option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
                                    </cfoutput>
                                </select>
                            </span>     
                        </div>                      
                    </div>
                    <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item_average_amount">
                        <label><cf_get_lang dictionary_id='29685.Tahmini'><cf_get_lang dictionary_id='57635.Miktar'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="average_amount" id="average_amount" value=""  passthrough="onkeyup=""return(formatcurrency(this,event));""" class="moneybox">
                                <cfquery name="getUnit" datasource="#dsn#">
                                    SELECT UNIT_ID,UNIT FROM SETUP_UNIT ORDER BY UNIT
                                </cfquery>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <select name="amount_unit" id="amount_unit" class="formselect" >
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="getUnit">
                                    <option value="#unit_id#">#unit#</option>
                                </cfoutput>
                            </select>     	
                        </div>
                    </div>
                    <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item_special_definition">
                        <label><cf_get_lang dictionary_id='38125.Özel Tanım'></label>
                            <select name="special_definition" id="special_definition" >
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="GET_SPECIAL_DEFINITION">
                                    <option value="#special_definition_id#">#special_definition#</option>
                                </cfoutput>
                            </select>
                    </div>
                    <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item_work_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38472.İş No'></label>
                        <cfinput type="text" name="work_no" id="work_no" maxlength="20" value=""  />
                    </div>
                    <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item-work_fuse">
                        <label>Workfuse</label>
                        <div class="input-group">
                            <input name="work_fuse" type="text" id="work_fuse" value="report.project_work_board">
                            <span class="input-group-addon btnPointer icon-link" onclick="window.open('<cfoutput>#request.self#?fuseaction=report.project_work_board</cfoutput>','_blank');"></span>
                        </div>
                    </div>
                </cf_box_elements>
            </div>
        </cf_tab> 
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <cf_box_footer>
                <cfsavecontent  variable="message"><cf_get_lang dictionary_id='57536.Güncellemek İstediğinizden Emin misiniz?'></cfsavecontent>
                <cf_workcube_buttons update_status="0" extraButton="1" extraButtonText="Kaydet" extraAlert="#message#" extraFunction='add_work_()'>
            </cf_box_footer>
        </div>   
    </cf_box>
</cfform>
<script>
    function estimated_finishdate(add_time,type)
        {
            if(document.getElementById('estimated_minute').value >= 60)
            {
                alert("<cf_get_lang dictionary_id='60617.Lütfen 60dan Küçük Bir Deger Giriniz'>!");
                document.getElementById('estimated_minute').value = '';
                return false;
            }
        }
    function add_work_()
    {
        work_head = $('#work_head').val();
        work_detail = $('#work_detail').val();
        pro_employee_id = $('#pro_employee_id').val();
        pro_employee = $('#pro_employee').val();
        terminate_date = $('#terminate_date').val();
        process_stage = $('#process_stage').val();
        milestone_id = $('#milestone_id').val();
        process_id = $('#process_id').val();
        terminate_hour = $('#terminate_hour').val(); 
        project_id = $('#project_id').val();
        work_cat = $('#work_cat').val();
        if(document.getElementById('estimated_hour').value== '') estimated_hour = 0; else estimated_hour= parseInt($('#estimated_hour').val());    
        if(document.getElementById('estimated_minute').value== '') estimated_minute=0; else estimated_minute = parseInt($('#estimated_minute').val());
        total_time = (estimated_hour*60) + estimated_minute;
        priority_cat = $('#priority_cat').val();
        workgroup_id = $('#workgroup_id').val();
        about_company = $('#about_company').val();
        company_partner_id = $('#company_partner_id').val();
        company_id = $('#company_id').val();
        activity_type = $('#activity_type').val();
        startdate_plan = $('#startdate_plan').val();
        finishdate_plan = $('#finishdate_plan').val();
        expected_budget = $('#expected_budget').val();
        expected_budget_money = filterNum($('#expected_budget_money').val());
        average_amount = filterNum($('#average_amount').val());
        amount_unit = $('#amount_unit').val();
        special_definition = $('#special_definition').val();
        work_no = $('#work_no').val();
        work_fuse = $('#work_fuse').val();
        start_hour = $('#start_hour').val();
        finish_hour_plan = $('#finish_hour_plan').val();
        if(work_head == '')
        {
            alert("<cf_get_lang dictionary_id = '31595.Lütfen başlık giriniz'>");
            return false;
        }
        if(work_detail == '')
        {
            alert("<cf_get_lang dictionary_id = '31629.Lütfen açıklama giriniz'>");
            return false;
        } 
        if(pro_employee == '')
        {
            alert("<cf_get_lang dictionary_id = '56320.Lütfen çalışan giriniz'>");
            return false;
        } 
        if(terminate_date == '')
        {
            alert("<cf_get_lang dictionary_id = '275.Lütfen termin tarihi giriniz'>");
            return false;
        }
        if(process_stage == '')
        {
            alert("<cf_get_lang dictionary_id = '36223.Lütfen süreç giriniz'>");
            return false;
        } 
        if(work_cat == '')
        {
            alert("<cf_get_lang dictionary_id = '53158.Lütfen kategori giriniz'>");
            return false;
        }
        $.ajax({ 
          type:'POST',  
          url:'V16/report/cfc/kanban_board.cfc?method=add_work',  
          data: { 
            work_head      : work_head, 
            work_detail    : work_detail,
            pro_employee_id: pro_employee_id,
            pro_employee   : pro_employee,
            terminate_date : terminate_date,
            process_stage  : process_stage,
            milestone_id   : milestone_id,
            process_id     : process_id,
            terminate_hour : terminate_hour,
            project_id     : project_id,
            work_cat       : work_cat,
            total_time     : total_time,
            priority_cat   :priority_cat,
            workgroup_id:workgroup_id,
            about_company     : about_company,
            company_partner_id:company_partner_id,
            company_id         : company_id,
            activity_type : activity_type,
            startdate_plan      : startdate_plan,
            finishdate_plan    : finishdate_plan,
            expected_budget    :expected_budget,
            expected_budget_money: expected_budget_money,
            average_amount       :average_amount,
            amount_unit          : amount_unit,
            special_definition   :special_definition,
            work_no              : work_no,
            start_hour           :start_hour,
            finish_hour_plan      :finish_hour_plan,
            work_fuse  : work_fuse 
        }
      });
      show_hide('add_work_box');
      gizle('add_work_box');
    }
    function add_milestone()
{
		if(document.getElementById('project_id').value)
		{
			var GET_MILESTONE = wrk_safe_query('get_add_milestone','dsn',0,document.getElementById('project_id').value);
			for(j=document.getElementById("milestone_id").options.length;j>=0;j--)
				eval('document.getElementById("milestone_id")').options[j] = null;	
		
			eval('document.getElementById("milestone_id")').options[0] = new Option('Seçiniz','');
			for(i=0;i<GET_MILESTONE.recordcount;++i)
			{
				document.getElementById("milestone_id").options.add(new Option(GET_MILESTONE.WORK_HEAD[i], GET_MILESTONE.WORK_ID[i])); 
			}
		}
}
</script>

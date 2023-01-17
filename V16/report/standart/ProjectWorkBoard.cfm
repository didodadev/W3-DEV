<!---
    File : report/standart/ProjectWorkBoard.cfm
    Author : Melek KOCABEY <melekkocabey@workcube.com>
    Date : 05.09.2019
    Description : İşlerin detaylı olarak raporlanması,Kişilere göre işlerin listelenmesi.
    Notes :         
--->
<cfsetting showdebugoutput="yes">
<cfparam name="attributes.equipment_id" default="">
<cfparam name="attributes.work_currency_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.work_cat" default="">
<cfparam name="attributes.work_head" default="">
<cfparam name="attributes.work_id" default="">
<cfparam name="attributes.workgroup_id" default="">
<cfparam  name="attributes.start_date" default="">
<cfparam  name="attributes.finish_date" default="">
<cfparam  name="attributes.is_termin" default="">
<cfparam  name="attributes.is_termin_date" default="">
<cfparam  name="attributes.is_services" default="">
<cfparam  name="attributes.last_month_" default="">
<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
    <cf_date tarih="attributes.start_date">
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
    <cf_date tarih="attributes.finish_date">
</cfif>
<cfset today = now()> 
<cfparam name="attributes.last_month" default="#month(today)#">
<cfset lastMonthStartDate = createDate(year(today), attributes.last_month, 1)> 
<cfset lastMonthFinishDate = createDateTime(year(today), attributes.last_month, DaysInMonth(lastMonthStartDate),23,59,59)>
<cfset getComponent = createObject('component','V16.report.cfc.ProjectWorkBoard')>
<cfset get_employees = getComponent.get_employee()>
<cfset get_work_cat = getComponent.GET_WORK_CAT()>
<cfset get_procurrency = getComponent.GET_WORK_PROCURRENCY()>
<cfset get_workgroups = getComponent.GET_WORKGROUPS()>
<cfif isDefined("equipment_id") and len(equipment_id)>
<cfset employee_id_list = "">
<cfset employee_id_list = ListAppend(employee_id_list,Evaluate("equipment_id"))>
</cfif>
<cfset GET_WORKS = getComponent.GET_WORKS(
    equipment_id:attributes.equipment_id,
    work_currency_id:attributes.work_currency_id,
    project_head:attributes.project_head,
    project_id:attributes.project_id,
    work_cat:attributes.work_cat,
    work_head:attributes.work_head,
    work_id:attributes.work_id,
    workgroup_id:attributes.workgroup_id,
    finish_date:attributes.finish_date,
    start_date:attributes.start_date,
    dsn3_alias : '#dsn3_alias#',
    employee_id_list:'#IIf(IsDefined("employee_id_list"),"employee_id_list",DE(""))#',
    is_termin:attributes.is_termin,
    is_termin_date:attributes.is_termin_date,
    is_services:attributes.is_services,
    last_month_:attributes.last_month_,
    department: '#iif(isdefined("attributes.department"),"attributes.department",DE(""))#',
	branch_id: '#iif(isdefined("attributes.branch_id"),"attributes.branch_id",DE(""))#',
    lastMonthStartDate:lastMonthStartDate,
    lastMonthFinishDate:lastMonthFinishDate
)>
<cfif get_works.recordcount>
    <cfset termin_count = getComponent.GET_TERMİN_WORK()>
    <cfset get_my_works = getComponent.CatWorkSummary()>
    <cfset get_stage = getComponent.StageWorkSummary()>
    <cfquery name="GET_TOTAL_COUNTS" dbtype="query">
        SELECT COUNT(WORK_ID) WORK_COUNT, SUM(HARCANAN_DAKIKA) TOPLAM_HARCANAN, SUM(ESTIMATED_TIME) TOPLAM_ONGORULEN FROM get_works
    </cfquery>

    <cfset total_work_count =GET_TOTAL_COUNTS.WORK_COUNT>
    <cfset totalminute = GET_TOTAL_COUNTS.TOPLAM_HARCANAN mod 60>
    <cfset totalhour = (GET_TOTAL_COUNTS.TOPLAM_HARCANAN-totalminute)/60>

    <cfset totalminute_1 = GET_TOTAL_COUNTS.TOPLAM_ONGORULEN mod 60>
    <cfset totalhour_1 = (GET_TOTAL_COUNTS.TOPLAM_ONGORULEN-totalminute_1)/60>
</cfif>
<cfscript>
    cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp");
	cmp_branch.dsn = dsn;
	get_branches = cmp_branch.get_branch(ehesap_control:1,branch_status:1);
    if (isdefined('attributes.branch_id') and isnumeric(attributes.branch_id))
	{
		cmp_department = createObject("component","V16.hr.cfc.get_departments");
		cmp_department.dsn = dsn;
		get_department = cmp_department.get_department(branch_id:attributes.branch_id);
	}
</cfscript>
<cfform name="proje_workboard" action="" method="post">
    <input name="form_varmi" id="form_varmi" value="1" type="hidden">
    <cf_report_list_search title="#getLang('contract',267)#">
        <cf_report_list_search_area>
           <div class="row">
                <div class="col col-12 col-xs-12">                                              
                    <div class="row formContent">
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="col col-12 col-md-12 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57569.Görevli'></label>
                                    <div class="col col-12 col-md-12 col-xs-12">
                                        <cf_multiselect_check 
                                            query_name="get_employees"  
                                            name="equipment_id"
                                            width="135" 
                                            option_value="employee_id"
                                            option_name="EMPLOYEE_NS"
                                            value="#attributes.equipment_id#">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                    <div class="col col-12 col-md-12 col-xs-12">
                                        <div class="input-group">
                                            <cfoutput>
                                                <input type="hidden" name="project_id" id="project_id" value="#attributes.project_id#">
                                                <input name="project_head" type="text" id="project_head" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','proje_workboard','3','250');" value="#attributes.project_head#" autocomplete="off">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_head=proje_workboard.project_head&project_id=proje_workboard.project_id');"></span>
                                            </cfoutput>     
                                        </div>  
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58445.İş'></label>
                                    <div class="col col-12 col-md-12 col-xs-12">
                                        <div class="input-group">
                                            <cfoutput>
                                                <input type="text" class="boxtext" name="work_head" id="work_head" value="#attributes.WORK_HEAD#" onfocus="AutoComplete_Create('work_head','WORK_HEAD','WORK_HEAD','get_work','','WORK_ID','work_id','','3','110')">
                                                <input type="hidden" class="boxtext" name="work_id" id="work_id" value="#attributes.work_id#">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_add_work&field_id=proje_workboard.work_id&field_name=proje_workboard.work_head','list');"></span>
                                            </cfoutput>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58140.İş Grubu'></label>
                                    <div class="col col-12 col-md-12 col-xs-12">
                                        <select name="workgroup_id" id="workgroup_id">				  
                                            <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                            <cfoutput query="get_workgroups">
                                                <option value="#workgroup_id#" <cfif isdefined("attributes.workgroup_id") and workgroup_id eq attributes.workgroup_id>selected</cfif>>#workgroup_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="col col-12 col-md-12 col-xs-12">
                                <div class="form-group" id="item-branch_id">
                                    <label><cf_get_lang dictionary_id="57453.Şube"></label>
                                        <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)" multiple>
                                            <option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
                                        <cfoutput query="get_branches" group="NICK_NAME">
                                            <optgroup label="#get_branches.NICK_NAME#"></optgroup>
                                            <cfoutput>
                                                <option value="#get_branches.BRANCH_ID#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq get_branches.branch_id)> selected</cfif>>#get_branches.BRANCH_NAME#</option>
                                            </cfoutput>
                                        </cfoutput>
                                    </select> 
                                </div>
                                <div class="form-group" id="item-department">
                                    <label><cf_get_lang dictionary_id="57572.Departman"></label>
                                    <select name="department" id="department">
                                        <option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
                                        <cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
                                            <cfloop query="get_department">
                                               <cfoutput> <option value="#department_id#"<cfif isdefined('attributes.department') and (attributes.department eq get_department.department_id)>selected</cfif>>#department_head#</cfoutput></option>
                                            </cfloop>
                                        </cfif>
                                    </select>        
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
                                    <div class="col col-12 col-md-12 col-xs-12">
                                        <select name="work_currency_id" id="work_currency_id" >
                                            <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                            <cfoutput query="get_procurrency">
                                                <option value="#process_row_id#" <cfif attributes.work_currency_id eq process_row_id>selected</cfif>>#stage#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                                    <div class="col col-12 col-md-12 col-xs-12">
                                        <select name="work_cat" id="work_cat">
                                            <option value=""><cf_get_lang dictionary_id='57734.kategori'></option>
                                            <cfoutput query="get_work_cat">
                                                <option value="#get_work_cat.work_cat_id#" <cfif attributes.work_cat eq get_work_cat.work_cat_id>selected</cfif>>#get_work_cat.work_cat#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div> 
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="col col-12 col-md-12 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>				
                                    <div class="col col-6 col-md-6">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57738.Baslangiç tarihini yaziniz'> !</cfsavecontent>
                                            <cfif isdefined("attributes.start_date")>
                                                <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" maxlength="10" message="#message#" validate="#validate_style#">
                                            <cfelse>
                                                <cfinput type="text" name="start_date" value="" validate="#validate_style#" maxlength="10" message="#message#">
                                            </cfif>
                                            <span class="input-group-addon">
                                            <cf_wrk_date_image date_field="start_date">
                                            </span> 
                                        </div>
                                    </div>
                                    <div class="col col-6 col-md-6">
                                        <div class="input-group">
                                            <cfsavecontent variable="message1"><cf_get_lang dictionary_id ='39357.Bitis tarihini yaziniz'> !</cfsavecontent>
                                            <cfif isdefined("attributes.finish_date")>
                                                <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" maxlength="10" message="#message1#" validate="#validate_style#">
                                            <cfelse>
                                                <cfinput type="text" name="finish_date" value="" validate="#validate_style#" maxlength="10" message="#message1#">
                                            </cfif>
                                            <span class="input-group-addon">
                                            <cf_wrk_date_image date_field="finish_date">	
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58672.Aylar"></label>
                                    <div class="col col-12 col-xs-12">
                                        <cfset monthList = 'Ocak,Şubat,Mart,Nisan,Mayıs,Haziran,Temmuz,Ağustos,Eylül,Ekim,Kasım,Aralık'>
                                        <select name="last_month" id="last_month">
                                            <cfoutput>
                                                <option value="#month(now())#"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                                <cfloop from="1" to="#Month(now())-1#" index="i">
                                                    <option value="#i#"<cfif attributes.last_month eq i>selected</cfif>>#ListGetAt(monthList,i,',')#</option>
                                                </cfloop>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12">&nbsp;</label>
                                    <div class="col col-6 col-xs-12">
                                        <label><cf_get_lang dictionary_id='56202.Geçen'><cf_get_lang dictionary_id='58724.Ay'><input type="checkbox" id="last_month_" name="last_month_" <cfif isdefined("attributes.last_month_") and len(attributes.last_month_)>checked="checked"</cfif> value="1"/></label>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col col-6 col-xs-12">
                                        <label><cf_get_lang dictionary_id="45888.Termini Geçmiş İşler"><input type="checkbox" id="is_termin" name="is_termin" <cfif isdefined("attributes.is_termin") and len(attributes.is_termin)>checked="checked"</cfif> value="1"/></label>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col col-6 col-xs-12">
                                        <label><cf_get_lang dictionary_id="46089.Termini verilmemiş işler"><input type="checkbox" id="is_termin_date" name="is_termin_date" <cfif isdefined("attributes.is_termin_date") and len(attributes.is_termin_date)>checked="checked"</cfif> value="1"/></label>
                                    </div>
                                </div>                                
                                <div class="form-group">
                                    <div class="col col-6 col-xs-12">
                                        <label><cf_get_lang dictionary_id="57656.Servis"><input type="checkbox" id="is_services" name="is_services" <cfif isdefined("attributes.is_services") and len(attributes.is_services)>checked="checked"</cfif> value="1"/></label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter pull-right">            
                            <cf_wrk_report_search_button search_function='control()' button_type='1' is_excel='0'>
                        </div>
                    </div>
                </div>
            </div>
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<br/>
<cfif isDefined("attributes.form_varmi")>
    <cf_report_list>
        <cfif GET_WORKS.recordcount>
            <div class="row row">
                <cfif not (len(attributes.equipment_id) or len(attributes.work_head) or len(attributes.is_termin) or len(attributes.is_termin_date))>
                    <cfoutput>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12 msrItem margin-bottom-15" style="text-align-last: center;">
                            <cf_box>    
                                <div class="form-group">
                                    <div class="col col-6">                                                    
                                        <div class="portHead">
                                            <span><cf_get_lang dictionary_id="57492.Toplam"><cf_get_lang dictionary_id="58445.İş"></span>
                                        </div>
                                    </div>
                                    <div class="col col-6">                                                    
                                        <div class="portHead">
                                            <span><cf_get_lang dictionary_id="45888.Termini Geçmiş İş"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col col-6">                                                    
                                        <div class="portBody">
                                            <span>#total_work_count#</span>
                                        </div>
                                    </div>
                                    <div class="col col-6">                                                    
                                        <div class="portBody">
                                            <span>#termin_count.work_count#</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col col-6">                                                    
                                        <div class="portHead">
                                            <span><cf_get_lang dictionary_id="38215.Öngörülen"></span>
                                        </div>
                                    </div>
                                    <div class="col col-6">                                                    
                                        <div class="portHead">
                                            <span><cf_get_lang dictionary_id="38128.Harcanan"><cf_get_lang dictionary_id="29513.Süre"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col col-6">                                                    
                                        <div class="portBody">
                                            <span>#totalhour_1# <cf_get_lang dictionary_id="57491.Saat"> #totalminute_1# <cf_get_lang dictionary_id="58827.Dk"></span>
                                        </div>
                                    </div>
                                    <div class="col col-6">                                                    
                                        <div class="portBody">
                                            <span>#totalhour# <cf_get_lang dictionary_id="57491.Saat"> #totalminute# <cf_get_lang dictionary_id="58827.Dk"></span>
                                        </div>
                                    </div>
                                </div>
                            </cf_box>
                        </div>
                    </cfoutput>
                </cfif>
                <cfif not len(attributes.work_cat)>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12 msrItem margin-bottom-15" style="text-align-last: center;">
                        <cf_box>
                            <cfoutput query="get_my_works">
                                <cfset 'item_#currentrow#' = "#get_my_works.work_cat#">
                                <cfset 'value_#currentrow#' = "#get_my_works.work_count#">
                            </cfoutput>
                            <canvas id="myChart1"></canvas>
                                <script src="JS/Chart.min.js"></script>
                                <script>
                                    var ctx = document.getElementById('myChart1');
                                    var myChart1 = new Chart(ctx, {
                                        type: 'bar',
                                        data: {
                                                labels: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj">
                                                    <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                                datasets: [{
                                                label: "<cf_get_lang dictionary_id = '40177.Kategorilere Göre'> <cf_get_lang dictionary_id = '58020.İşler'>",
                                                backgroundColor: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                                data: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                                    }]
                                                },
                                        options: {}
                                    });
                                </script>                    
                        </cf_box>
                    </div>
                </cfif>
                <cfif not len(attributes.work_currency_id)>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12 msrItem margin-bottom-15" style="text-align-last: center;">
                        <cf_box>
                            <cfif get_stage.recordcount>
                                <cfoutput query="get_stage">
                                    <cfset 'item_#currentrow#' = "#get_stage.stage#">
                                    <cfset 'value_#currentrow#' = "#get_stage.work_count#">
                                </cfoutput>
                            </cfif>
                            <canvas id="myChart2"></canvas>
                            <script src="JS/Chart.min.js"></script>
                            <script>
                                var ctx = document.getElementById('myChart2');
                                var myChart2 = new Chart(ctx, {
                                    type: 'bar',
                                    data: {
                                            labels: [<cfloop from="1" to="#get_stage.recordcount#" index="jj">
                                                <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                            datasets: [{
                                            label: "<cf_get_lang dictionary_id = '40176	.Aşamalara Göre'> <cf_get_lang dictionary_id = '58020.İşler'>",
                                            backgroundColor: [<cfloop from="1" to="#get_stage.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                            data: [<cfloop from="1" to="#get_stage.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                                }]
                                            },
                                    options: {}
                                });
                            </script> 
                        </cf_box>
                    </div>
                </cfif>
            </div>
            <div class="row msrContent"> 
                <cfoutput query="GET_WORKS" group="NAME_SURNAME">
                    <div class="col col-3 col-md-6 col-sm-12 msrItem">
                        <cf_box>
                            <div class="col col-12">
                                <cfset get_emp_works = getComponent.GET_WORKS(employee_id_list:employee_id,
                                    dsn3_alias : '#dsn3_alias#',
                                    finish_date:attributes.finish_date,
                                    start_date:attributes.start_date,
                                    work_currency_id:attributes.work_currency_id,
                                    project_head:attributes.project_head,
                                    project_id:attributes.project_id,
                                    work_cat:attributes.work_cat,
                                    workgroup_id:attributes.workgroup_id
                                    )>
                                    <cfquery name="GetEmpTotal" dbtype="query">
                                        SELECT COUNT(WORK_ID) WORK_COUNT, SUM(HARCANAN_DAKIKA) TOPLAM_HARCANAN, SUM(ESTIMATED_TIME) TOPLAM_ONGORULEN FROM get_emp_works
                                    </cfquery>
                                    <cfif len(employee_id)>
                                        <cfquery name="get_history" datasource="#dsn#">
                                            SELECT 
                                                SUM(TOTAL_TIME_HOUR) TOTAL_TIME_HOUR,
                                                SUM(TOTAL_TIME_MINUTE) TOTAL_TIME_MINUTE,
                                                SUM(TOTAL_TIME_HOUR1) AS TOTAL_TIME_HOUR1,
                                                SUM(TOTAL_TIME_MINUTE1)  AS TOTAL_TIME_MINUTE1,
                                                EMPLOYEE_ID
                                            FROM 
                                                ( 
                                                    SELECT
                                                        SUM(TOTAL_TIME_HOUR) AS TOTAL_TIME_HOUR, 
                                                        SUM(TOTAL_TIME_MINUTE) AS TOTAL_TIME_MINUTE, 
                                                        '' AS TOTAL_TIME_HOUR1,
                                                        ''  AS TOTAL_TIME_MINUTE1, 
                                                        UPDATE_AUTHOR AS EMPLOYEE_ID 
                                                                                                        
                                                    FROM 
                                                        PRO_WORKS_HISTORY 
                                                                                                
                                                    WHERE                                                     
                                                        UPDATE_AUTHOR IS NOT NULL AND
                                                        UPDATE_AUTHOR IN (<cfqueryparam cfsqltype="cf_sql_integer" value='#valueList(get_emp_works.employee_id)#' list="yes">) AND
                                                        WORK_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value='#valueList(get_emp_works.WORK_ID)#' list="yes">)
                                                    GROUP BY
                                                        UPDATE_AUTHOR
                                                UNION 
                                                    SELECT 
                                                        '' AS TOTAL_TIME_HOUR,
                                                        ''  AS TOTAL_TIME_MINUTE, 
                                                        SUM(TOTAL_TIME_HOUR1) AS TOTAL_TIME_HOUR1, 
                                                        SUM(TOTAL_TIME_MINUTE1) AS TOTAL_TIME_MINUTE1, 
                                                        EMPLOYEE_ID AS EMPLOYEE_ID
                                                    FROM 
                                                        TIME_COST_PLANNED 
                                                    WHERE 
                                                        EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value='#valueList(get_emp_works.employee_id)#' list="yes">) AND
                                                        WORK_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value='#valueList(get_emp_works.WORK_ID)#' list="yes">)
                                                    GROUP BY 
                                                        EMPLOYEE_ID
                                                                                                    
                                                ) AS T1 
                                            GROUP BY 
                                                EMPLOYEE_ID
                                        </cfquery>
                                    <cfelse>
                                        <cfset get_history.recordcount = 0>
                                    </cfif>
                                    <cfif get_history.recordcount and len(get_history.TOTAL_TIME_HOUR)>
                                        <cfset total_time_1 = get_history.TOTAL_TIME_HOUR * 60>                                                        
                                        <cfset minute_1 = total_time_1 / 60>
                                    </cfif>
                                    <cfif get_history.recordcount and len(get_history.TOTAL_TIME_MINUTE)>
                                        <cfset total_time_2 = get_history.TOTAL_TIME_MINUTE * 60>
                                        <cfset minute_2 = total_time_2 / 60>                                                        
                                        <cfset total_time_end = total_time_1 + get_history.TOTAL_TIME_MINUTE>
                                        <cfset totaltime_ = total_time_end mod 60>
                                    </cfif> 
                                    
                                    <cfif get_history.recordcount and len(get_history.TOTAL_TIME_HOUR)>
                                        <cfset totalminute = totaltime_>
                                        <cfset totalhour = ((total_time_end - totaltime_)/60)>
                                    <cfelse>
                                        <cfset totalminute = 0>
                                        <cfset totalhour = 0>
                                    </cfif>
                                
                                    <cfif isdefined("TERMINATE_DATE") and len(TERMINATE_DATE)>
                                        <cfquery name="GetEmpTermin" datasource="#DSN#">
                                            SELECT COUNT(ISNULL(TERMINATE_DATE,0)) TOPLAM_TERMINATE_DATE FROM PRO_WORKS WHERE TERMINATE_DATE  <= #now()# AND WORK_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value='#valueList(get_emp_works.WORK_ID)#' list="yes"> )
                                        </cfquery>                                       
                                    </cfif>
                                    <cfset total_work_count =GetEmpTotal.WORK_COUNT>
                                    
                                    <cfif len(GetEmpTotal.TOPLAM_ONGORULEN)>
                                        <cfset totalminute_1 = GetEmpTotal.TOPLAM_ONGORULEN mod 60>
                                        <cfset totalhour_1 = (GetEmpTotal.TOPLAM_ONGORULEN-totalminute_1)/60>
                                    <cfelse>
                                        <cfset totalminute_1 = 0>
                                        <cfset totalhour_1 = 0>
                                    </cfif>
                                <div class="form-group">
                                    <div class="col col-9">         
                                        <span class="avatextCt color-#Left(EMPLOYEE_NAME, 1)#" style="width: 25px !important; float: left; margin-right: 8px; height: 25px;"><small class="avatext" style="font-size:11px; top:-6px; width:26px !important;">#Left(EMPLOYEE_NAME, 1)##Left(EMPLOYEE_SURNAME, 1)# </small></span>
                                        <div class="pull-left" style="line-height:25px;">#NAME_SURNAME#</div>
                                    </div>
                                    <div class="col col-3 text-end">
                                        <a href="javascript://" title="İş Ekle" onclick="cfmodal('#request.self#?fuseaction=project.works&event=add&WORK_FUSE=report.project_work_board&work_detail_id=0&totalminute=#totalminute_1#&totalhour=#totalhour_1#<cfif len(attributes.work_currency_id)>&process_stage=#attributes.work_currency_id#</cfif><cfif len(attributes.work_id)>&work_id=#attributes.work_id#</cfif><cfif len(attributes.work_cat)>&pro_work_cat=#attributes.work_cat#</cfif>&type=1&project_emp_id=#employee_id#<cfif len(attributes.project_id)>&id=#attributes.project_id#</cfif>','warning_modal');">
                                            <i class="catalyst-plus"></i>
                                        </a>
                                    </div>
                                </div> 
                                    
                                    <cfif isdefined("TERMINATE_DATE") and len(TERMINATE_DATE) and len(GetEmpTermin.TOPLAM_TERMINATE_DATE)>
                                        <cfset termin= GetEmpTermin.TOPLAM_TERMINATE_DATE>
                                    <cfelse>
                                        <cfset termin = "<i class = 'fa fa-smile-o' style='font-size:15px;'></i>">
                                    </cfif>                           
                                <div class="form-group">
                                    <div class="col col-6 portHead">                                                    
                                        <span><cf_get_lang dictionary_id="57492.Toplam"><cf_get_lang dictionary_id="58445.İş"></span>
                                    </div>
                                    <div class="col col-6 portHead">                                                    
                                        <span><cf_get_lang dictionary_id="45888.Termini Geçmiş İş"></span>
                                    </div>
                                </div>
                                <div class="form-group ">
                                    <div class="col col-6">                                                    
                                        <span>#total_work_count#</span>
                                    </div>
                                    <div class="col col-6">                                               
                                        <span>#termin#</span>                                    
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col col-6 portHead">
                                        <span><cf_get_lang dictionary_id="38215.Öngörülen"></span>
                                    </div>
                                    <div class="col col-6 portHead">
                                        <span><cf_get_lang dictionary_id="38128.Harcanan"><cf_get_lang dictionary_id="29513.Süre"></span>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col col-6">
                                        <span>#totalhour_1# <cf_get_lang dictionary_id="57491.Saat"> #totalminute_1# <cf_get_lang dictionary_id="58827.Dk"></span>
                                    </div>
                                    <div class="col col-6">                                                    
                                        <span>#totalhour# <cf_get_lang dictionary_id="57491.Saat"> #totalminute# <cf_get_lang dictionary_id="58827.Dk"></span>
                                    </div>
                                </div>
                                <div class="form-group portHead">
                                    <a style="font-size: 12px;cursor:pointer;" onclick="gizle_goster(wrk_history#currentrow#);"><i class = 'fa fa-angle-right'></i> <cf_get_lang dictionary_id ="58691.İş Listesi"></a>
                                </div>
                                <div id="wrk_history#currentrow#" style="display:none; cursor:pointer;">
                                    <cfloop query="get_emp_works">
                                        <div class="border-bottom border-bottom-default">                     
                                            <div class="form-group">
                                                <div class="col col-6">
                                                    <span title="Öncelik" class="avatextCt color-#Left(EMPLOYEE_NAME, 1)#" style="width: 25px !important; float: left; margin-right: 8px; height: 25px; display: inline-block;"><small class="avatext" style="font-size:11px; top:-6px; width:26px !important;">#Left(PRIORITY, 1)#</small></span>
                                                    <a href="#request.self#?fuseaction=project.works&event=det&id=#WORK_ID#" target="_blank"><span title ="iş id" style="line-height:25px;">#WORK_ID#</span></a>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="col col-12">                                                    
                                                    <a href="#request.self#?fuseaction=project.works&event=det&id=#WORK_ID#" target="_blank"><span title="İş Adı">#URLDecode(WORK_HEAD)#</span></a>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="col col-6">                                                    
                                                    <span title="Kategori">#work_cat#</span>
                                                </div>
                                                <div class="col col-6">                                                    
                                                    <span title="Aşama">#STAGE#</span>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="col col-6">                                                    
                                                    <i class="fa fa-clock-o" title="<cf_get_lang dictionary_id='60609.Termin Tarihi'>"></i> #dateformat(TERMINATE_DATE,dateformat_style)# #timeformat(TERMINATE_DATE,timeformat_style)#
                                                </div>
                                            </div>
                                        </div>
                                    </cfloop>                               
                                </div>
                            </div>
                        </cf_box>
                    </div>
                </cfoutput>
            </div>
        </cfif>
    </cf_report_list>
</cfif>
<cfsetting showdebugoutput="NO">
<script type="text/javascript">
    function control() 
    {
        if ((document.proje_workboard.start_date.value != '') && (document.proje_workboard.finish_date.value != ''))
        {
            if(!date_check(document.proje_workboard.start_date,document.proje_workboard.finish_date,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))        
            {
                return false;
            }
        }   
        else{
				document.proje_workboard.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.project_work_board"
				return true;
			} 
    }
    function homeMasonry(){
		var $container = $('.msrContent');	
		$container.masonry({itemSelector: '.msrItem'});
    }  
    $('.msrContent').bind('DOMNodeInserted DOMNodeRemoved', function() {
		homeMasonry();
	}); 
    function showDepartment(branch_id)	
	{
        var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popupajax_list_departments&branch_id="+branch_id;
			AjaxPageLoad(send_address,'item-department',1,'İlişkili Departmanlar');
		}
	} 
</script>
<!---
    File: add_flexible_worktime.cfm
    Controller: fuseaction is myhome = FlexibleWorkTimeController.cfm, fuseaction is hr = hrFlexibleWorkTimeController.cfm
    Author: Esma R. UYSAL
    Date: 07/12/2019 
    Description:
        Esnek çalışma saatleri ekleme form sayfasıdır.
        Hem hr modülü ve myhome üzerinde çalışır.
        Myhome dan girildiğinde Başvuru yapan, Şube ve Departman seçili olarak gelmektedir.
--->
<cfsavecontent variable = "header"><cf_get_lang dictionary_id = "38598.Flexible Work Application"></cfsavecontent>
    <cf_catalystHeader>
    <cfparam name="attributes.employee_id" default="#session.ep.userid#" />
    <cfset fuseaction = listFirst(attributes.fuseaction,".")>
    <cfset days_name = "">
    <cfif fuseaction is 'myhome'>
        <cfset get_emp_branch_department_cmp = createObject("component","V16.myhome.cfc.flexible_worktime") /><!--- esnek çalışma cmp --->
        <cfset get_employee  = get_emp_branch_department_cmp.GET_EMLOYEE_BRANCH_DEPARTMENT_FROM_IS_MASTER(employee_id : session.ep.userid)><!---Çalışanın is master branch ve departmanı --->
        <cfif get_employee.recordcount><!---Ücret kartında departman ve şube varsa --->
            <cfset emp_branch_id = get_employee.branch_id><!--- Ücret kartında bulunan şube --->
            <cfset emp_department_id = get_employee.department_id><!--- Ücret kartındaki departman --->
        <cfelse>
            <cfset emp_branch_id =  listlast(session.ep.user_location,'-')><!--- sessionda bulunan şube --->
            <cfset emp_department_id = listfirst(session.ep.user_location,'-')><!--- sessionda kartındaki departman --->
        </cfif>
    <cfelse>
        <cfset emp_branch_id = ''>
        <cfset emp_department_id = ''>
    </cfif>
    <cfset cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp")>
    <cfset cmp_branch.dsn = dsn>
    <cfset get_branches = cmp_branch.get_branch(branch_status:1)>
    <cfset cmp_department = createObject("component","V16.hr.cfc.get_departments")>
    <cfset cmp_department.dsn = dsn>
    <cfset get_department = cmp_department.get_department(branch_id : emp_branch_id)>
    <cfset periods = createObject('component','V16.objects.cfc.periods')>
    <cfset period_years = periods.get_period_year()>
    
    <cfloop from="1" to="7" index="c">
        <cfif	c eq 1><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57604.Pazartesi"></cfsavecontent>
        <cfelseif c eq 2><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57605.Salı"></cfsavecontent>
        <cfelseif c eq 3><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57606.Çarşamba"></cfsavecontent>
        <cfelseif c eq 4><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57607.Perşembe"></cfsavecontent>
        <cfelseif c eq 5><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57608.Cuma"></cfsavecontent>
        <cfelseif c eq 6><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57609.Cumartesi"></cfsavecontent>
        <cfelseif c eq 7><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57610.Pazar"></cfsavecontent>
        </cfif>
        <cfset days_name = listappend(days_name,'#day_name#')>
    </cfloop>
    <cfsavecontent variable="ay1"><cf_get_lang dictionary_id='57592.Ocak'></cfsavecontent>
    <cfsavecontent variable="ay2"><cf_get_lang dictionary_id='57593.Subat'></cfsavecontent>
    <cfsavecontent variable="ay3"><cf_get_lang dictionary_id='57594.Mart'></cfsavecontent>
    <cfsavecontent variable="ay4"><cf_get_lang dictionary_id='57595.Nisan'></cfsavecontent>
    <cfsavecontent variable="ay5"><cf_get_lang dictionary_id='57596.Mayis'></cfsavecontent>
    <cfsavecontent variable="ay6"><cf_get_lang dictionary_id='57597.Haziran'></cfsavecontent>
    <cfsavecontent variable="ay7"><cf_get_lang dictionary_id='57598.Temmuz'></cfsavecontent>
    <cfsavecontent variable="ay8"><cf_get_lang dictionary_id='57599.Agustos'></cfsavecontent>
    <cfsavecontent variable="ay9"><cf_get_lang dictionary_id='57600.Eylül'></cfsavecontent>
    <cfsavecontent variable="ay10"><cf_get_lang dictionary_id='57601.Ekim'></cfsavecontent>
    <cfsavecontent variable="ay11"><cf_get_lang dictionary_id='57602.Kasim'></cfsavecontent>
    <cfsavecontent variable="ay12"><cf_get_lang dictionary_id='57603.Aralik'></cfsavecontent>
    
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12"> 
        <cf_box>
                <cfform name="flexible_worktime" id="flexible_worktime" action="" enctype="multipart/form-data" method="post">
                    <cf_box_elements>
                        <input type = "hidden" id = "row_count" name = "row_count" value = "">
                        <div class="col col-5 col-md-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-process">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id = '58859.Süreç'></label>
                                <div class="col col-9 col-xs-12">
                                    <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                                </div>
                            </div>
                            <div class="form-group" id="item-date">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id = '58593.Tarihi'> *</label>
                                <div class="col col-9 col-xs-12">
                                    <div class="input-group">
                                       <cfinput type="text" name="request_date" id="request_date" maxlength="10" required="Yes" validate="#validate_style#"  style="width:65px;" value="#dateformat(now(),dateformat_style)#">
                                       <span class="input-group-addon"> <cf_wrk_date_image date_field="request_date"> </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-employee">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="29514.Başvuru yapan"> *</label>
                                <div class="col col-9 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="employee_id" id="employee_id" value="<cfif fuseaction is 'myhome'><cfoutput>#session.ep.userid#</cfoutput></cfif>">
                                        <input type="hidden" name="position_id" id="position_id" value="<cfif fuseaction is 'myhome'><cfoutput>#session.ep.position_code#</cfoutput></cfif>">
                                        <input type="text" name="employee" id="employee" onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3,9\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'1\'','EMPLOYEE_ID,MEMBER_TYPE','employee_id','','3','135');" style="width:120px;" value="<cfif fuseaction is 'myhome'><cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput> </cfif>" <cfif fuseaction is 'myhome'>disabled</cfif>>
                                        <span class="input-group-addon btnPointer icon-ellipsis" <cfif fuseaction neq 'myhome'>onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_display_self=1&is_cari_action=1&field_emp_id=flexible_worktime.employee_id&field_name=flexible_worktime.employee&field_type=flexible_worktime.employee_id&field_id=position_id&select_list=1,9','list');"</cfif>></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-branch">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'> *</label>
                                <div class="col col-9 col-xs-12">
                                    <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)" <cfif fuseaction is 'myhome'>disabled</cfif>>
                                        <option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
                                        <cfoutput query="get_branches" group="NICK_NAME">
                                            <optgroup label="#get_branches.NICK_NAME#"></optgroup>
                                            <cfoutput>
                                                <option value="#get_branches.BRANCH_ID#"<cfif fuseaction is 'myhome' and emp_branch_id eq get_branches.branch_id> selected</cfif>>#get_branches.BRANCH_NAME#</option>
                                            </cfoutput>
                                        </cfoutput>
                                    </select>
                                    <cfif fuseaction is 'myhome'>
                                       <cfoutput> <input type = "hidden" id = "branch_id" name = "branch_id" value = "#emp_branch_id#"></cfoutput>
                                    </cfif>
                                </div>
                            </div>
                            <div class="form-group" id="item-department"  >
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'> *</label>
                                <div class="col col-9 col-xs-12" id="department_div">
                                    <select name="department_id" id="department_id" <cfif fuseaction is 'myhome'>disabled</cfif>> 
                                        <option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
                                        <cfif fuseaction is 'myhome' and emp_department_id>
                                            <cfoutput query="get_department">
                                                <option value="#department_id#" <cfif fuseaction is 'myhome' and emp_department_id eq get_department.department_id>selected</cfif>>#department_head#</option>
                                            </cfoutput>
                                        </cfif>
                                    </select>
                                    <cfif fuseaction is 'myhome'>
                                        <cfoutput><input type = "hidden" id = "department_id" name = "department_id" value = "#emp_department_id#"></cfoutput>
                                    </cfif>
                                </div>
                            </div>
                            <div class="form-group" id="item-employee">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57467.Not"></label>
                                <div class="col col-9 col-xs-12">
                                    <textarea id="desciription" name="woRktime_flexible_notice" class="form-control" style="height:50px;"> </textarea>
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                    <div class = "col col-12 col-md-12 col-xs-12 ">
                            <div class="form-group mt-3 mb-3" id="item-label">
                                <label style="color : #E08283 ; font-size :14px"><b><cf_get_lang dictionary_id = '41799.Seçeceğiniz Ay ve Yıl İçerisinde Periyodik Olarak Esnek Çalışmak İstediğiniz Gün ve Saat Aralığını Girmek İçin + ya Tıklayınız..'></b></label>
                            </div>
                            <cf_grid_list margin="1">
                                <thead>
                                    <th style="text-align:center;width:25px;"><input type="button" class="eklebuton" title="" onClick="add_row();" value=""></th>
                                    <th style="width:45px;" id = "year_th"><cf_get_lang dictionary_id = "58455.Yıl"></th>
                                    <th style="width:60px;" id = "month_th"><cf_get_lang dictionary_id = "58724.Ay"></th>
                                    <th style="width:65px;" id = "day_th"><cf_get_lang dictionary_id = "57490.Gün"></th>
                                    <th style="width:200px;"><cf_get_lang dictionary_id = "41014.Saat aralığı"></th>
                                </thead>
                                <tbody id="add_flexible_worktime_normal">
                                </tbody>
                            </cf_grid_list>
                        </div>
                        <div class = "col col-12 col-md-12 col-xs-12 ">
                            <div class="form-group mt-3 mb-3" id="item-label">
                                <label style="color : #E08283 ; font-size :14px"><b><cf_get_lang dictionary_id = '41798.Esnek Çalışmak İsteiğiniz Tarih ve Saat Aralığı Eklemek İçin  + ya Tıklayınız.'></b></label>
                            </div>
                            <cf_grid_list margin="1">
                                <thead>
                                    <th style="text-align:center;width:25px;"><input type="button" class="eklebuton" title="" onClick="add_row_2();" value=""></th>
                                    <th style="width:205px;" id = "date_th"><cf_get_lang dictionary_id = "57742.Tarih"></th>
                                    <th style="width:200px;"><cf_get_lang dictionary_id = "41014.Saat aralığı"></th>
                                </thead>
                                <tbody id="add_flexible_worktime_period">
                                </tbody>
                            </cf_grid_list>
                        </div>
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_box_footer>
                                <cf_workcube_buttons is_upd='0' add_function="kontrol()">
                            </cf_box_footer>
                        </div>
                </cfform>
        </cf_box>
    </div>
    <script type="text/javascript">
        row_count = 0;
        row_count_control = 0;
        document.getElementById("row_count").value = row_count;
        function showDepartment(branch_id)	
        {
            var branch_id = document.getElementById('branch_id').value;
            if (branch_id != "")
            {
                var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&show_div=0&branch_id="+branch_id;
                AjaxPageLoad(send_address,'department_div',1,'İlişkili Departmanlar');
            }
        }
        function add_row(){
            row_count++;
            row_count_control++;
            var newRow;
            document.getElementById("row_count").value = row_count;
            newRow = document.getElementById("add_flexible_worktime_normal").insertRow(document.getElementById("add_flexible_worktime_normal").rows.length);	
            newRow.setAttribute("name","" + row_count);
            newRow.setAttribute("id","row_" + row_count);
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><a style="cursor:pointer" onclick="del_row(' + row_count + ');" ><i class="fa fa-minus"></i></a></div>';
            newCell.setAttribute("style","text-align:center");
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><select name = "period_years'+ row_count +'" id = "period_years'+ row_count +'" class = "boxtext"><cfoutput query = "period_years"> <option value="#period_year#" <cfif session.ep.period_year eq period_year>selected</cfif>>#period_year#</option></cfoutput></select></div>';
            newCell.setAttribute("style","text-align:center");
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><select name = "flexible_month'+ row_count +'" id = "flexible_month'+ row_count +'" class = "boxtext"><cfloop index="i" from="1" to="12"><cfoutput><option value="#i#">#Evaluate('ay#i#')#</option></cfoutput></cfloop></select></div>';
            newCell.setAttribute("style","text-align:center");
     
            newCell = newRow.insertCell(newRow.cells.length);		
            newCell.innerHTML = '<div class="form-group"><select name="flexible_day' + row_count +'" id="flexible_day' + row_count +'" class = "boxtext"> <cfloop from="1" to="7" index="c"><cfoutput><option value="#c#">#listGetAt(days_name,c)#</option></cfoutput></cfloop></select></div>';
            newCell.setAttribute("style","text-align:center");
    
            newCell = newRow.insertCell(newRow.cells.length);		
            newCell.innerHTML = '<cf_wrktimeformat name="flexible_start_hour' + row_count + '"><select name="flexible_start_min' + row_count + '" id="flexible_start_min' + row_count + '"><option value=""><cf_get_lang dictionary_id="58827.min"></option><cfloop from="0" to="59" index="i" step = "5"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select> - <cf_wrktimeformat name="flexible_finish_hour' + row_count + '"><select id="flexible_finish_min' + row_count + '" name="flexible_finish_min' + row_count + '"><option value=""><cf_get_lang dictionary_id="58827.min"></option><cfloop from="0" to="59" index="i" step = "5"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select>';
            newCell.setAttribute("style","text-align:center");
            newCell.setAttribute("nowrap","nowrap");
        }
        function add_row_2(){
            row_count++;
            row_count_control++;
            var newRow;
            document.getElementById("row_count").value = row_count;
            newRow = document.getElementById("add_flexible_worktime_period").insertRow(document.getElementById("add_flexible_worktime_period").rows.length);	
            newRow.setAttribute("name","" + row_count);
            newRow.setAttribute("id","row_" + row_count);
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><a style="cursor:pointer" onclick="del_row(' + row_count + ');" ><i class="fa fa-minus"></i></a></div>';
            newCell.setAttribute("style","text-align:center");
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute("id","work_date_row" + row_count + "_td");
            newCell.innerHTML = '<input type="text" name="work_date_row' + row_count +'" id="work_date_row' + row_count +'" class="text" maxlength="10" value="">';
            wrk_date_image('work_date_row' + row_count);
          
    
            newCell = newRow.insertCell(newRow.cells.length);		
            newCell.innerHTML = '<cf_wrktimeformat name="flexible_start_hour' + row_count + '"><select name="flexible_start_min' + row_count + '" id="flexible_start_min' + row_count + '"><option value=""><cf_get_lang dictionary_id="58827.min"></option><cfloop from="0" to="59" index="i" step = "5"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select> - <cf_wrktimeformat name="flexible_finish_hour' + row_count + '"><select id="flexible_finish_min' + row_count + '" name="flexible_finish_min' + row_count + '"><option value=""><cf_get_lang dictionary_id="58827.min"></option><cfloop from="0" to="59" index="i" step = "5"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select>';
            newCell.setAttribute("style","text-align:center");
            newCell.setAttribute("nowrap","nowrap");
        }
        function del_row(del_row_num,id)//Satır silme fonksiyonu
        {
            if(confirm ("<cf_get_lang dictionary_id = '36628.Satırı silmek istediğinize emin misiniz?'> ? "))
            {
                $( "[id = 'row_"+del_row_num+"']" ).each(function( index ) {
                    $( this ).remove();
                    row_count_control--;
                });
            }else return false;
        }
        function kontrol(){
            if(row_count_control == 0 ){
                alert("<cf_get_lang dictionary_id = '33822.Lütfen satır ekleyiniz'>");
                return false;
            }else{
                for(i = 1; i <= row_count_control; i++){
                    if(document.getElementById("work_date_row"+i)){
                        if(document.getElementById("work_date_row"+i).value == ''){
                            alert("<cf_get_lang dictionary_id = '58222.Lütfen Satıra Tarih Giriniz'>");
                            return false;
                        }
                    }
    
                    start_clock = $('#flexible_start_hour'+i).val();
                    finish_clock = $('#flexible_finish_hour'+i).val();
                    start_minute = $('#flexible_start_min'+i).val();
                    finish_minute = $('#flexible_finish_min'+i).val();
    
                    if(start_clock != undefined && start_minute != undefined && finish_clock != undefined && finish_minute != undefined)
                    {
                        if(start_clock == 0 || finish_clock == 0 || start_minute == '' || finish_minute == ''){
                            alert("<cf_get_lang dictionary_id='64855.	Lütfen Saat Aralığı Seçiniz!'>");
                            return false;
                        }
                        else if(start_clock > finish_clock) 
                        {
                            alert("<cf_get_lang dictionary_id='31409.Başlangıç Saati Bitiş Saatinden Büyük Olamaz'>!");
                            return false;
                        }
                        else if((start_clock == finish_clock) && (start_minute ==finish_minute))
                        {	
                            alert("<cf_get_lang dictionary_id ='31636.Başlangıç Ve  Bitiş Saati Aynı Olamaz'>!");
                            return false;
                        }
                        else if((start_clock == finish_clock) && (start_minute > finish_minute))
                        {
                            alert("<cf_get_lang dictionary_id ='31409.Başlangıç Saati Bitiş Saatinden Büyük Olamaz'>!");
                            return false;
                        }
                    }
                }
                if(document.getElementById("request_date").value == ''){
                    alert("<cf_get_lang dictionary_id = '58503.Lütfen Tarih Giriniz'>");
                    return false;
                }
                if(document.getElementById("employee_id").value == ''){
                    alert("<cf_get_lang dictionary_id = '41876.Başvuru yapan seçmelisiniz.'>");
                    return false;
                }
                if(document.getElementById("branch_id").value == ''){
                    alert("<cf_get_lang dictionary_id = '36397.Şube ve departman seçmelisiniz.'>");
                    return false;
                }
                /*if(document.getElementById("DEPARTMENT_ID").value == ''){
                    alert("<cf_get_lang dictionary_id = '36397.Şube ve departman  seçmelisiniz.'>");
                    return false;
                }*/
            }
            return process_cat_control();
        }
    </script>
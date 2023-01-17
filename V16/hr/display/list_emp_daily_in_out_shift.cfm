<!---
    File: list_emp_daily_in_out_shift.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 20-06-19
    Description:
        Çalışana vardiya ekleme, güncelleme, listeleme
        
    History:
        
    To Do:

--->
<cfparam name="attributes.branch_name" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.shift_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.in_out_id" default="">
<cfparam name="attributes.form_submited" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">

<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<!--- QUERY'LER --->
<cfset get_shift_cmp = createObject("component","V16.hr.cfc.get_employee_shift")>
<cfset get_shifts = get_shift_cmp.get_shifts()>

<!--- Buton Yetkileri --->
<cfset get_buttons_info = get_shift_cmp.GET_BUTTONS_INFO(fuseaction : attributes.fuseaction)>
    
<cfif attributes.form_submited eq 1>
    <cfif not len(attributes.employee_name)>
        <cfset attributes.employee_id = "">
        <cfset attributes.in_out_id = "">
    </cfif>
    <cfif not len(attributes.department_name)>
        <cfset attributes.department_id = "">
    </cfif>
    
    <cfset get_shift_employee = get_shift_cmp.GET_SHIF_EMPLOYEES(
        employee_id : attributes.employee_id,
        employee_name : attributes.employee_name,
        department_id : attributes.department_id,
        department_name : attributes.department_name,
        branch_id : attributes.branch_id,
        branch_name : attributes.branch_name,
        shift_id : shift_id,
        in_out_id : attributes.in_out_id,
        is_shift : 1,
        start_date : attributes.start_date,
        finish_date : attributes.finish_date,
        is_dep_power_control : get_module_power_user(69) eq 0 ? 1 : 0
    )>
</cfif>
<cfif not(isdefined("get_shift_employee.recordcount") and get_shift_employee.recordcount)>
    <cfset get_shift_employee.recordcount = 0>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box scroll="0">
        <cfform name="shits_search" method="post" action="#request.self#?fuseaction=hr.emp_daily_in_out_shift">
            <input type="hidden" name="form_submited" id="form_submited" value="1">
            <cf_box_search more="0">
                <!--- Değiştirilecek ---->
                <div class="form-group" id="item-employee_name" >
                    <cfif get_module_power_user(69)>
                        <cf_wrk_employee_in_out
                            form_name="shits_search"
                            emp_id_fieldname="employee_id"
                            in_out_id_fieldname="in_out_id"
                            width="188"
                            emp_name_fieldname="employee_name"
                            emp_id_value="#attributes.employee_id#"
                            in_out_value="#attributes.in_out_id#"
                            is_shift=1
                            >
                        <cfelse>
                            <cf_wrk_employee_in_out
                            form_name="shits_search"
                            emp_id_fieldname="employee_id"
                            in_out_id_fieldname="in_out_id"
                            width="188"
                            emp_name_fieldname="employee_name"
                            emp_id_value="#attributes.employee_id#"
                            in_out_value="#attributes.in_out_id#"
                            is_shift=1
                            is_dep_power_control = 1
                            >
                    </cfif>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfoutput>
                            <input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined("attributes.branch_id")>#attributes.branch_id#</cfif>">
                            <input type="text" name="branch_name" id="branch_name" value="<cfif isdefined("attributes.branch_name")>#attributes.branch_name#</cfif>" placeholder="#getLang('main',41)#">
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=hr.popup_list_departments&field_branch_name=shits_search.branch_name&field_branch_id=shits_search.branch_id&field_id=shits_search.department_id&field_name=shits_search.department_name');"></span>
                        </cfoutput>
                    </div>
                </div>
                <div class="form-group">
                    <cfoutput>
                        <input type="hidden" name="department_id" id="department_id" value="<cfif isdefined("attributes.department_id")>#attributes.department_id#</cfif>">
                        <input type="text" name="department_name" id="department_name" value="<cfif isdefined("attributes.department_name")>#attributes.department_name#</cfif>" placeholder="#getLang('main',160)#">
                    </cfoutput>
                </div>
                <div class="form-group">
                    <select name="shift_id" id="shift_id" <cfif attributes.form_submited eq 1> onChange="change_all_row(this.value)"</cfif>>
                        <option value=""><cf_get_lang dictionary_id ='56566.Vardiya'></option>
                        <cfoutput query="get_shifts">
                            <option value="#shift_id#"<cfif isdefined("attributes.shift_id") and (shift_id eq attributes.shift_id)>selected</cfif>>#shift_name# (#start_hour#-#end_hour#)</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.başlama tarihi girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" placeholder="#getLang('','Başlangıç Tarihi',58053)#" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitiş girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" placeholder="#getLang('','Bitiş Tarihi',57700)#" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4"> 	
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray2" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.import_shift</cfoutput>')"><i class="fa fa-download" title="<cf_get_lang dictionary_id='58641.İmport'>" alt="<cf_get_lang dictionary_id='58641.İmport'>"></i></a>
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray" href="javascript://" onclick="TableToExcel.convert(document.getElementById('export_table')); "><i class="fa fa-file-excel-o" title="<cf_get_lang dictionary_id='29737.Excel Üret'>" alt="<cf_get_lang dictionary_id='29737.Excel Üret'>"></i></a>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <form name="row_form" id="row_form" action="">
        <cf_box title="#getLang('','Vardiyalar','32180')#">
            <cf_grid_list sort="0">
                <thead>
                    <tr>
                        <th width="20"><cfif get_buttons_info.recordcount eq 0 or (get_buttons_info.recordcount gt 0 and get_buttons_info.ADD_OBJECT eq 0)><a data-button="add" data-table="add" href="javascript://"><i class="fa fa-plus"/></a></cfif></th>
                        <th><cf_get_lang dictionary_id="29831.Kişi"></th>
                        <th><cf_get_lang dictionary_id="56566.Vardiya"></th>
                        <th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
                        <th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
                        <th width="20"><i class="fa fa-pencil"></i></th>
                    </tr>
                </thead>
                <tbody id="ship_table">
                    <cfif attributes.form_submited eq 1 and get_shift_employee.recordcount>
                        <cfoutput query="get_shift_employee">
                            <tr id="table_tr_#currentrow#">
                                <td class="text-center" id="del_td#currentrow#">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57533.Silmek istediğinizden emin misiniz?"></cfsavecontent>
                                    <cfif get_buttons_info.recordcount eq 0 or (get_buttons_info.recordcount gt 0 and get_buttons_info.DELETE_OBJECT eq 0)>
                                        <label title="<cf_get_lang dictionary_id='57463.Sil'>" onclick="if (confirm('#message#')) {del_form(#currentrow#,#setup_shift_employee_id#);} else {return false;}">
                                        <i class="fa fa-minus"></i>
                                    </cfif>
                                    </label>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <div class="input-group">
                                            <input type="hidden" name="employee_id" id="employee_id#currentrow#" value="#employee_id#">
                                            <input type="hidden" name="in_out_id" id="in_out_id#currentrow#" value="#in_out_id#">
                                            <input type="text" name="employee_name" id="employee_name#currentrow#" value="#get_emp_info(employee_id,0,0)#"> 
                                            <span class='icon-ellipsis btnPointer input-group-addon' onclick='open_emp(#currentrow#)'></span> 
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <select class="shift_class" name="shift_id" id="shift_id#currentrow#">
                                        <option value=""><cf_get_lang dictionary_id ='56566.Vardiya'></option>
                                        <cfloop query="get_shifts">
                                            <option value="#shift_id#"<cfif (get_shifts.shift_id eq get_shift_employee.shift_id)>selected</cfif>>#get_shifts.shift_name# (#get_shifts.start_hour#-#get_shifts.end_hour#)</option>
                                        </cfloop>
                                    </select>
                                </td>
                                <td>
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></cfsavecontent>
                                        <input name="start_date" id="start_date#currentrow#" placeholder="#message#" maxlength="10" value="#dateformat(start_date,dateformat_style)#">
                                        <cf_wrk_date_image date_field="start_date#currentrow#">
                                    </div>
                                </td>
                                <td>
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></cfsavecontent>
                                        <input name="finish_date" id="finish_date#currentrow#" placeholder="#message#" maxlength="10" value="#dateformat(finish_date,dateformat_style)#">
                                        <cf_wrk_date_image date_field="finish_date#currentrow#">
                                    </div>
                                </td>
                                <td id="add_td#currentrow#"  class="text-center">
                                    <cfif not len(shift_id)>
                                        <cfif get_buttons_info.recordcount eq 0 or (get_buttons_info.recordcount gt 0 and get_buttons_info.ADD_OBJECT eq 0)>
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='45686.kaydetmek istediğinize emin misiniz'></cfsavecontent>
                                            <label title="<cf_get_lang dictionary_id='57582.Ekle'>" onclick="if (confirm('#message#')) {add_form(#currentrow#);} else {return false}">
                                                <i class="icon-check"></i>
                                            </label>
                                        </cfif>
                                    <cfelse>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='45686.kaydetmek istediğinize emin misiniz'></cfsavecontent>
                                        <cfif get_buttons_info.recordcount eq 0 or (get_buttons_info.recordcount gt 0 and get_buttons_info.UPDATE_OBJECT eq 0)>
                                            <label title="<cf_get_lang dictionary_id ='57464.Güncelle'>" onclick="if (confirm('#message#')) {upd_form('row_form#currentrow#',#currentrow#,#setup_shift_employee_id#,#in_out_id#);} else {return false}">
                                                <i class="fa fa-pencil"></i>
                                            </label>
                                        </cfif>
                                    </cfif>
                                </td>
                            </tr>
                        </cfoutput>
                    </cfif>
                </tbody>
            </cf_grid_list>
            <div style="display:none">
                <table id="export_table">
                    <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id="29831.Kişi"></th>
                            <th><cf_get_lang dictionary_id="56566.Vardiya"></th>
                            <th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
                            <th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfif attributes.form_submited eq 1 and get_shift_employee.recordcount>
                            <cfoutput query="get_shift_employee">
                                <tr id="table_tr_#currentrow#">
                                    <td>#get_emp_info(employee_id,0,0)#</td>
                                    <td>
                                        <cfloop query="get_shifts">
                                            <cfif (get_shifts.shift_id eq get_shift_employee.shift_id)>
                                                #get_shifts.shift_name# (#get_shifts.start_hour#-#get_shifts.end_hour#)
                                            </cfif>
                                        </cfloop>
                                    </td>
                                    <td>#dateformat(start_date,dateformat_style)#</td>
                                    <td>#dateformat(finish_date,dateformat_style)#</td>
                                </tr>
                            </cfoutput>
                        </cfif>
                    </tbody>
                </table>
            </div>
           
        </cf_box>
    </form>
</div>

<script type="text/javascript">
    <cfif attributes.form_submited eq 1>
        row_count = "<cfoutput>#get_shift_employee.recordcount#</cfoutput>"
    <cfelse>
        row_count = 0;
    </cfif>

    $( document ).on( "click", "[data-button]", function() {
        row_count++;
        //Satır Ekleme
        if($(this).attr('data-button')=='add'){		

            employee_id = document.getElementById("employee_id").value;
            employee_name = document.getElementById("employee_name").value;
            in_out_id = document.getElementById("in_out_id").value;

            var appendData = "<tr id='table_tr_"+row_count+"'><td class='text-center' id='del_td"+row_count+"'><cfif get_buttons_info.recordcount eq 0 or (get_buttons_info.recordcount gt 0 and get_buttons_info.DELETE_OBJECT eq 0)><label title='<cf_get_lang dictionary_id ='57463.Sil'>' onclick='if(confirm("+'"<cf_get_lang dictionary_id='57533.Silmek istediğinize emin misiniz?'>"'+")){del_form("+row_count+");} else{return false;}'><i class='fa fa-minus'></i></cfif></td></label>"+
            "<td><div class='form-group'><div class='input-group'><input type='hidden' name='employee_id' id='employee_id"+row_count+"' value='"+employee_id+"'><input type='hidden' name='in_out_id' id='in_out_id"+row_count+"' value='"+in_out_id+"'><input type='text' name='employee_name"+row_count+"' id='employee_name"+row_count+"' value='"+employee_name+"'><span class='icon-ellipsis btnPointer input-group-addon' onclick='open_emp("+row_count+")'></span></div></div></td>"+
            "<td><select name='shift_id' id='shift_id"+row_count+"'><option value=''><cf_get_lang dictionary_id ='56566.Vardiya'></option><cfloop query='get_shifts'><cfoutput><option value='#shift_id#' <cfif shift_id eq attributes.shift_id>selected </cfif>>#get_shifts.shift_name# (#get_shifts.start_hour#-#get_shifts.end_hour#)</option></cfoutput></cfloop></select></td>"+
            "<td id='start_date"+ row_count + "_td'><input name='start_date' id='start_date"+row_count+"'></td>"+
            "<td id='finish_date"+ row_count + "_td'><input name='finish_date' id='finish_date"+row_count+"'></td>"+
            "<td id='add_td"+ row_count +"' class='text-center'><cfif get_buttons_info.recordcount eq 0 or (get_buttons_info.recordcount gt 0 and get_buttons_info.ADD_OBJECT eq 0)><label title='<cf_get_lang dictionary_id='57582.Ekle'>' onclick='add_form("+row_count+");' <i class='icon-check'/></label></cfif></td>"+
            "</tr>";	

            tableBody = $("#ship_table"); 
            tableBody.append(appendData); 

            //Tarih ikonları
            wrk_date_image('start_date' + row_count);
            wrk_date_image('finish_date' + row_count);
        }
    });

    //Tarih Formatı
    function myfisherdatefixer(date) { let d = date.split('/'); return d[1]+'/'+d[0]+'/'+d[2]; } 

    //Satır Güncelleme
    function upd_ajax(employee_id,start_date,finish_date,shift_id,setup_shift_employee_id,in_out_id)
    {
        $.ajax({ 
            type:'POST',  
            url:'V16/hr/cfc/get_employee_shift.cfc?method=upd_shift',
            data: {
                employee_id : employee_id,
                start_date : start_date,
                finish_date : finish_date,
                shift_id : shift_id,
                setup_shift_employee_id :setup_shift_employee_id,
                in_out_id: in_out_id
            },
            success: function (returnData) {  
                console.log('Tarih Güncellendi..');  
            },
            error: function () 
            {
                console.log('try again..');
                return false; 
            }
        });
    }
    function add_ajax(employee_id,start_date,finish_date,shift_id,row_id,in_out_id)
    {
        console.log(in_out_id);
        $.ajax({ 
            type:'POST',  
            url:'V16/hr/cfc/get_employee_shift.cfc?method=add_shift',
            data: {
                employee_id : employee_id,
                start_date :start_date,
                finish_date : finish_date,
                shift_id : shift_id,
                in_out_id : in_out_id
            },
            success: function (returnData) {  
                
                id = JSON.parse(returnData);
                //console.log(returnData);  
                 if(row_id != undefined || row_id != -1)
                {
                    $("#add_td"+row_id).html('<cfif get_buttons_info.recordcount eq 0 or (get_buttons_info.recordcount gt 0 and get_buttons_info.UPDATE_OBJECT eq 0)><label title="<cf_get_lang dictionary_id ='57464.Güncelle'>" onclick="if (confirm('+"'<cfoutput><cf_get_lang dictionary_id='57536.Güncellemek İstediğinizden Emin misiniz?'></cfoutput>'"+')) {upd_form('+row_id+','+row_id+','+id+');} else {return false;}"><i class="fa fa-pencil"></i> </label></cfif>');    
                    $("#del_td"+row_id).html('<cfif get_buttons_info.recordcount eq 0 or (get_buttons_info.recordcount gt 0 and get_buttons_info.DELETE_OBJECT eq 0)><label title="<cf_get_lang dictionary_id ='57463.Sil'>" onclick="if (confirm('+"'<cf_get_lang dictionary_id='57533.Silmek istediğinize emin misiniz?'>'"+')) {del_form('+row_id+','+id+');} else {return false;}"><i class="fa fa-minus"></i> </label></cfif>');    
                    
                }
                return id;
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
                return false; 
            }
        });
    }
    //Sİlme
    function del_form(row_id,setup_shift_employee_id) {
        if(setup_shift_employee_id != undefined)
        {
            $.ajax({ 
                type:'POST',  
                url:'V16/hr/cfc/get_employee_shift.cfc?method=del_shift',
                data: {
                    setup_shift_employee_id : setup_shift_employee_id
                },
                success: function (returnData) {  
                                        
                },
                error: function () 
                {
                    console.log('CODE:8 please, try again..');
                    return false; 
                }
            });
        } 
        $("#table_tr_"+row_id).remove(); 
    }
    //Satır kayıt
    function add_form(row_id)
    {
        start_date = document.getElementById("start_date"+row_id).value;
        finish_date = document.getElementById("finish_date"+row_id).value;
        shift_id = document.getElementById("shift_id"+row_id).value;
        employee_id = document.getElementById("employee_id"+row_id).value;
        in_out_id = document.getElementById("in_out_id"+row_id).value;
        employee_name = document.getElementById("employee_name"+row_id).value;

        //Seçilen Vardiya Saatleri
        get_shift = wrk_safe_query('get_shift_date','dsn',0,shift_id);
        shift_startdate = date_format(get_shift.STARTDATE);
        shift_finishdate = date_format(get_shift.FINISHDATE);

        start_date_format = new Date(myfisherdatefixer(start_date));
        finish_date_format = new Date(myfisherdatefixer(finish_date));
        shift_startdate = new Date(shift_startdate);
        shift_finishdate =  new Date(shift_finishdate);



        if(employee_name == "")
        {
            alert("<cf_get_lang dictionary_id='41450.Lütfen Satır İçin Ad Soyad Giriniz'>!");
            return false;
        }

        if(start_date == "")
        {
            alert("<cf_get_lang dictionary_id='41039.Lütfen Başlangıç Tarihi Giriniz'>!");
            return false;
        }
        if(finish_date == "")
        {
            alert("<cf_get_lang dictionary_id='50693.Lütfen Bitiş Tarihi Giriniz'>!");

            return false;
        }
        if(start_date_format < shift_startdate || start_date_format > shift_finishdate)
        {
            alert("<cf_get_lang dictionary_id='63488.Başlangıç Tarihi, Vardiya Başlangıç Tarihinden Önce veya Vardiya Bitiş tarihinden Sonra Olamaz'>");
            return false;
        }
        else if(finish_date_format < shift_startdate || finish_date_format > shift_finishdate)
        {
            alert("<cf_get_lang dictionary_id='63489.Bitiş Tarihi, Vardiya Başlangıç Tarihinden Önce veya Vardiya Bitiş tarihinden Sonra Olamaz'>");
            return false;
        }
        if(shift_id == "")
        {
            alert("<cf_get_lang dictionary_id='63490.Vardiya Seçiniz'>!");
            return false;
        }
// bitiş tarihi başlangıç tarihinden önce olmaz kontrolü
        if(start_date >=finish_date)
        {
            alert("<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>");
            return false;
        }
        //Çakışan tarih var mı?
        parameters = start_date + "*" + finish_date + "*" + 0 + "*" + employee_id;
        get_shift_conflict = wrk_safe_query('get_shift_date_conflicting','dsn',0,parameters);
        get_shift_same = wrk_safe_query('get_shift_date_conflicting_same','dsn',0,parameters)
        //Eğer çakışan kayıt varsa
        if(get_shift_same.recordcount > 0)
        {
            alert("<cf_get_lang dictionary_id='63491.Girilen tarihte çakışan vardiya bulunmaktadır'>");
            return false;
        }
        else if(get_shift_conflict.recordcount == 1)
        {
            //Çalışanın çakışan vardiya bilgileri
            conflict_start_date = get_shift_conflict.START_DATE;
            conflict_finish_date = get_shift_conflict.FINISH_DATE;
            conflict_setup_shift_employee_id = get_shift_conflict.SETUP_SHIFT_EMPLOYEE_ID;
            conflict_shift_id = get_shift_conflict.SHIFT_ID;

            conflict_start_date_format = new Date(conflict_start_date);
            conflict_finish_date_format = new Date(conflict_finish_date);
                

            if (confirm('<cf_get_lang dictionary_id='63492.Çakışan Vardiya Tarihi'> : '+date_format(get_shift_conflict.START_DATE)+' : '+date_format(get_shift_conflict.FINISH_DATE)+' <cf_get_lang dictionary_id='64686.Parçalama İşlemi Yapmak İster misiniz?'>'))
            {
                console.log([conflict_start_date_format,start_date_format,start_date,finish_date]);
                //Eğer yeni girilen vardiya eski vardiyanın ortasındaysa
                if(conflict_start_date_format <= start_date_format && conflict_finish_date_format >= finish_date_format)
                {
                    //Önceki vardiyanın bitiş tarihi yeni vardiyanın bir önceki gününe atılır
                    conflict_finish_date_format = date_add('d',-1,start_date);
                    conflict_start_date_format = date_add('d',1,finish_date);
                    
                    //Satırı Güncelleme
                    upd_ajax(employee_id,date_format(conflict_start_date),conflict_finish_date_format,conflict_shift_id[0],conflict_setup_shift_employee_id[0],in_out_id); 
                    //Yeni eklenen vardiya 
                    add_ajax(employee_id,start_date,finish_date,shift_id,-1,in_out_id);
                    //Çakışan vardiya için yeni kayıt
                    add_ajax(employee_id,conflict_start_date_format,date_format(conflict_finish_date),conflict_shift_id[0],-1,in_out_id);
                }
                //Eğer girilen vardiyanın başlangıç tarihi çakışan vardiyadan küçükse ve girilen vardiyanın bitişi çakışan vardiyadan büyükse
                else if(conflict_start_date_format >= start_date_format && conflict_finish_date_format <= finish_date_format)
                {
                    //Önceki vardiyanın bitiş tarihi yeni vardiyanın bir önceki gününe atılır
                    conflict_start_date_format = date_add('d',-1,date_format(conflict_start_date));
                    conflict_finish_date_format = date_add('d',1,date_format(conflict_finish_date));
                    
                    //Satır ekleme
                    add_ajax(employee_id,start_date,conflict_start_date_format,shift_id,-1,in_out_id); 
                    //Çakışan vardiya için yeni kayıt
                    add_ajax(employee_id,conflict_finish_date_format,finish_date,shift_id,-1,in_out_id);
                }
                //girilen vardiyanın başlangıcı çakışan vardiyadan küçükse ve girilen vardiyanın bitişi çakışan vardiya bitişinden küçükse 
                else if(conflict_start_date_format >= start_date_format && conflict_finish_date_format >= finish_date_format)
                {
                    //Önceki vardiyanın bitiş tarihi yeni vardiyanın bir önceki gününe atılır
                    conflict_start_date_format = date_add('d',1,finish_date);

                    //Satırı Güncelleme
                    add_ajax(employee_id,start_date,finish_date,shift_id,-1,in_out_id); 
                    upd_ajax(employee_id,conflict_start_date_format,conflict_finish_date_format,shift_id,conflict_setup_shift_employee_id[0],in_out_id); 
                }
                //girilen vardiyanın başlangıcı çakışan vardiyanın başlangıcından büyük bitişinden küçükse ve girilen vardiyanın bitişi çakışan vardiya bitişinden büyükse 
                else if(conflict_start_date_format <= start_date_format && conflict_finish_date_format <= finish_date_format)
                {
                    //Önceki vardiyanın bitiş tarihi yeni vardiyanın bir önceki gününe atılır
                    conflict_finish_date_format = date_add('d',-1,start_date);

                    //Satırı Güncelleme
                    add_ajax(employee_id,start_date,finish_date,shift_id,-1,in_out_id); 
                    upd_ajax(employee_id,conflict_start_date_format,conflict_finish_date_format,conflict_shift_id[0],conflict_setup_shift_employee_id[0],in_out_id); 
                }
                location.reload();
            }

        }
        else if(get_shift_conflict.recordcount > 1)
        {
            alert("<cf_get_lang dictionary_id='63493.Birden Fazla Vardiyada Çakışma Bulunuyor. Kayıtlarınızı Kontrol Ediniz'>!");
            return false;
        }
        else
        {
            add_ajax(employee_id,start_date,finish_date,shift_id,row_id,in_out_id);
        }
            
      confirm('<cf_get_lang dictionary_id ='45686.kaydetmek istediğinize emin misiniz'>')  
    }
    //Satır Güncelleme
    function upd_form(form_name,row_id,setup_shift_employee_id)
    {
        
        start_date = document.getElementById("start_date"+row_id).value;
        finish_date = document.getElementById("finish_date"+row_id).value;
        shift_id = document.getElementById("shift_id"+row_id).value;
        employee_id = document.getElementById("employee_id"+row_id).value;
        in_out_id = document.getElementById("in_out_id"+row_id).value;
        employee_name = document.getElementById("employee_name"+row_id).value;

        //Seçilen Vardiya Saatleri
        get_shift = wrk_safe_query('get_shift_date','dsn',0,shift_id);
        shift_startdate = date_format(get_shift.STARTDATE);
        shift_finishdate = date_format(get_shift.FINISHDATE);

        start_date_format = new Date(myfisherdatefixer(start_date));
        finish_date_format = new Date(myfisherdatefixer(finish_date));
        shift_startdate = new Date(shift_startdate);
        shift_finishdate =  new Date(shift_finishdate);
    

        if(start_date == "")
        {
            alert("<cf_get_lang dictionary_id='30623.Lütfen Başlangıç Tarihi Giriniz'>");
            return false;
        }
        if(finish_date == "")
        {
            alert("<cf_get_lang dictionary_id='36494.Lütfen Bitiş Tarihi Giriniz'>!");
            return false;
        }

        if(start_date_format < shift_startdate || start_date_format > shift_finishdate)
        {
            alert("<cf_get_lang dictionary_id='63488.Başlangıç Tarihi, Vardiya Başlangıç Tarihinden Önce veya Vardiya Bitiş tarihinden Sonra Olamaz'>");
            return false;
        }
      
        else if(finish_date_format < shift_startdate || finish_date_format > shift_finishdate)
        {
            alert("<cf_get_lang dictionary_id='63489.Bitiş Tarihi, Vardiya Başlangıç Tarihinden Önce veya Vardiya Bitiş tarihinden Sonra Olamaz'>");
            return false;
        }
        if(shift_id == "")
        {
            alert("<cf_get_lang dictionary_id='63490.Vardiya Seçiniz'>!");
            return false;
        }
        // bitiş tarihi başlangıç tarihinden önce olmaz kontrolü
        if(start_date >=finish_date)
        {
            alert("<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>");
            return false;
        }
        //Çakışan tarih var mı?
        parameters = start_date + "*" + finish_date + "*" + setup_shift_employee_id + "*" + employee_id;
        get_shift_conflict = wrk_safe_query('get_shift_date_conflicting','dsn',0,parameters);
        get_shift_same = wrk_safe_query('get_shift_date_conflicting_same','dsn',0,parameters)

        if(get_shift_same.recordcount > 0)
        {
            alert("<cf_get_lang dictionary_id='63491.Girilen tarihte çakışan vardiya bulunmaktadır'>");
            return false;
        }
        if(get_shift_conflict.recordcount == 1)
        {
            //Çalışanın çakışan vardiya bilgileri
            conflict_start_date = get_shift_conflict.START_DATE;
            conflict_finish_date = get_shift_conflict.FINISH_DATE;
            conflict_setup_shift_employee_id = get_shift_conflict.SETUP_SHIFT_EMPLOYEE_ID;
            conflict_shift_id = get_shift_conflict.SHIFT_ID;

            conflict_start_date_format = new Date(conflict_start_date);
            conflict_finish_date_format = new Date(conflict_finish_date);

            if (confirm('<cf_get_lang dictionary_id='63492.Çakışan Vardiya Tarihi'> : '+date_format(get_shift_conflict.START_DATE)+' : '+date_format(get_shift_conflict.FINISH_DATE)+'<cf_get_lang dictionary_id='64686.Parçalama İşlemi Yapmak İster misiniz?'>'))
            {
                //console.log([conflict_start_date_format,conflict_finish_date_format,start_date_format,finish_date_format,finish_date,start_date]);
                //Eğer yeni girilen vardiya eski vardiyanın ortasındaysa
                if(conflict_start_date_format <= start_date_format && conflict_finish_date_format >= finish_date_format)
                {
                    //Önceki vardiyanın bitiş tarihi yeni vardiyanın bir önceki gününe atılır
                    conflict_finish_date_format = date_add('d',-1,start_date);
                    conflict_start_date_format = date_add('d',1,finish_date);
                    
                    //Satırı Güncelleme
                    upd_ajax(employee_id,date_format(conflict_start_date),conflict_finish_date_format,conflict_shift_id[0],conflict_setup_shift_employee_id[0],in_out_id); 

                    upd_ajax(employee_id,start_date,finish_date,shift_id,setup_shift_employee_id,in_out_id); 
                    //Çakışan vardiya için yeni kayıt
                    add_ajax(employee_id,conflict_start_date_format,date_format(conflict_finish_date),conflict_shift_id[0],in_out_id);
                }
                //Eğer girilen vardiyanın başlangıç tarihi çakışan vardiyadan küçükse ve girilen vardiyanın bitişi çakışan vardiyadan büyükse
                else if(conflict_start_date_format >= start_date_format && conflict_finish_date_format <= finish_date_format)
                {
                    //Önceki vardiyanın bitiş tarihi yeni vardiyanın bir önceki gününe atılır
                    conflict_start_date_format = date_add('d',-1,date_format(conflict_start_date));
                    conflict_finish_date_format = date_add('d',1,date_format(conflict_finish_date));
                    
                    //Satırı Güncelleme
                    upd_ajax(employee_id,start_date,conflict_start_date_format,shift_id,setup_shift_employee_id,in_out_id); 
                    //Çakışan vardiya için yeni kayıt
                    add_ajax(employee_id,conflict_finish_date_format,finish_date,shift_id,in_out_id);
                }
                //girilen vardiyanın başlangıcı çakışan vardiyadan küçükse ve girilen vardiyanın bitişi çakışan vardiya bitişinden küçükse 
                else if(conflict_start_date_format >= start_date_format && conflict_finish_date_format >= finish_date_format)
                {
                    //Önceki vardiyanın bitiş tarihi yeni vardiyanın bir önceki gününe atılır
                    conflict_start_date_format = date_add('d',1,finish_date);

                    //Satırı Güncelleme
                    upd_ajax(employee_id,start_date,finish_date,shift_id,setup_shift_employee_id,in_out_id); 
                    upd_ajax(employee_id,conflict_start_date_format,conflict_finish_date_format,shift_id,conflict_setup_shift_employee_id[0],in_out_id); 
                }
                //girilen vardiyanın başlangıcı çakışan vardiyanın başlangıcından büyük bitişinden küçükse ve girilen vardiyanın bitişi çakışan vardiya bitişinden büyükse 
                else if(conflict_start_date_format <= start_date_format && conflict_finish_date_format <= finish_date_format)
                {
                    //Önceki vardiyanın bitiş tarihi yeni vardiyanın bir önceki gününe atılır
                    conflict_finish_date_format = date_add('d',-1,start_date);

                    //Satırı Güncelleme
                    upd_ajax(employee_id,start_date,finish_date,shift_id,setup_shift_employee_id,in_out_id); 
                    upd_ajax(employee_id,conflict_start_date_format,conflict_finish_date_format,conflict_shift_id,conflict_setup_shift_employee_id[0],in_out_id); 
                }
                location.reload();
            }

        }
        else if(get_shift_conflict.recordcount > 2)
        {
            alert("<cf_get_lang dictionary_id='63493.Birden Fazla Vardiyada Çakışma Bulunuyor. Kayıtlarınızı Kontrol Ediniz'>!");
        }
        else
        {
            //Satırı Güncelleme
            
            upd_ajax(employee_id,start_date,finish_date,shift_id,setup_shift_employee_id,in_out_id);
        }        
    }
    //Kişi popup
    function open_emp(row_id)
    {
        openBoxDraggable("<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=row_form.in_out_id"+row_id+"&field_emp_id=row_form.employee_id"+row_id+"&field_emp_name=row_form.employee_name"+row_id+"&is_shift=1<cfif not get_module_power_user(69)>&is_dep_power_control=1</cfif>&call_function=");
    }
    //Tüm satır 
    function change_all_row(shift_id)
    {
        
    }
</script>

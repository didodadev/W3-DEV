<!---
    File: V16\hr\ehesap\form\pdks_working_inout_days.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-11-1
    Description:  Çalışan pdks giriş çıkışlar gün
        
    History:
        
    To Do:
            company_id_par : len(arguments.company_id) ? arguments.company_id : '',
            consumer_id_par : len(arguments.consumer_id) ? arguments.consumer_id : '',
            employee_id_par : len(arguments.employee_id_par) ? arguments.employee_id_par : '',
            member_type : len(arguments.member_type) ? arguments.member_type : '',
            member_name : len(arguments.member_name) ? arguments.member_name : '',
            company_id : len(arguments.comp_id) ? arguments.comp_id : '',
            branch_id :  len(arguments.branch_id) ? arguments.branch_id : ''
--->
<cfset date_title = CreateDateTime(attributes.sal_year, attributes.sal_mon, attributes.day)>

<cfset pdks_working_inout_cmp = createObject("component","V16.hr.ehesap.cfc.pdks_working_inout")>
<cfset get_photo_cmp = createObject("component","V16.project.cfc.get_work")>
<cfset setup_working_type_cmp = createObject("component","V16.settings.cfc.setup_working_type")>

<cfset get_emp_photo = get_photo_cmp.EMPLOYEE_PHOTO(employee_id: attributes.employee_id)>
<cfset get_employee_daily_in_out = pdks_working_inout_cmp.get_employee_daily_in_out(
    day_ : attributes.day, 
    sal_mon : attributes.sal_mon,
    sal_year : attributes.sal_year, 
    in_out_id : attributes.in_out_id
)>
<cfset get_setup_working_type = setup_working_type_cmp.get_setup_working_type()>

<cf_box closable="1"  draggable="1" popup_box="1" title ="#dateformat(date_title,dateformat_style)#">
    <cfform id="pdks_working_inout_form" name = "pdks_working_inout_form" method="post" action="V16/hr/ehesap/cfc/pdks_working_inout.cfc?method=add_pdks_working_inout_day">
        <cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">	
                <cfinput type="hidden" name="working_inout_day_count" id="working_inout_day_count" value="#get_employee_daily_in_out.recordcount#">	
                <cfinput type="hidden" name="in_out_id" id="in_out_id" value="#attributes.in_out_id#">		
                <cfinput type="hidden" name="sal_mon" id="sal_mon" value="#attributes.sal_mon#">		
                <cfinput type="hidden" name="sal_year" id="sal_year" value="#attributes.sal_year#">		
                <cfinput type="hidden" name="day_" id="day_" value="#attributes.day#">		
                <cfinput type="hidden" name="branch_id" id="branch_id" value="#attributes.branch_id#">	
                <cfinput type="hidden" name="employee_id" id="employee_id" value="#attributes.employee_id#">	
              <!---   <cfinput type="hidden" name="attributes_json" id="attributes_json" value="#attributes.attributes_json#">	 --->
                <cfinput type="hidden" value="#attributes.in_out_id##attributes.day##attributes.sal_mon##attributes.sal_year#" name="special_code" id="special_code">

                <div class="form-group" id="item-photo">
                    <div class="col col-2">
                        <cfif len(get_emp_photo.photo)><img src="/documents/hr/<cfoutput>#get_emp_photo.photo#</cfoutput>" style="width:80px !important; height:80px !important;" class="avatextCt onlineusers"><cfelse><img src="/images/maleicon.jpg"></cfif>
                    </div>
                    <div class="col col-10">
                        <label><cfoutput>#get_emp_photo.EMPLOYEE_NAME# #get_emp_photo.EMPLOYEE_SURNAME# - #get_emp_photo.position#</cfoutput></label>
                    </div>
                </div>	
                <cf_grid_list id="pdks_working_inout">
                    <thead>
                        <th width="20" class='text-center'><a href="javascript://" onClick="addRow()"><i class="fa fa-plus"></i></th>
                        <th><cf_get_lang dictionary_id='54126.Mesai'> - <cf_get_lang dictionary_id='58575.İzin'></th>
                        <th colspan="2"><cf_get_lang dictionary_id='41014.Saat Aralığı'></th>
                    </thead>
                    <tbody id="pdks_working_inout">
                        <cfif get_employee_daily_in_out.recordcount>
                            <cfoutput query ="get_employee_daily_in_out">
                                <tr id="#currentrow#">
                                    <cfinput  type="hidden" name="row_id_#currentrow#" value="#ROW_ID#">
                                    <input type='hidden' name='row_#currentrow#' id='row_#currentrow#' value='1'>
                                    <td class="text-center"><a style='cursor:pointer;' onclick='sil(#currentrow#);'><i class='fa fa-minus'></i></a><input name='in_out_row' value='#currentrow#' type='hidden'></td>
                                    <td>
                                        <select name="working_type_#currentrow#" id="working_type_#currentrow#">
                                            <cfloop query="get_setup_working_type">
                                                <option value="#get_setup_working_type.working_type#" <!--- style="background-color: #chr(35)##get_setup_working_type.COLOR_CODE#" ---> <cfif get_employee_daily_in_out.DAY_TYPE eq get_setup_working_type.working_type>selected</cfif>>#get_setup_working_type.detail#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                    <td>
                                        <div class="col col-12">
                                            <div class="col col-6 col-xs-6">
                                                <cf_wrkTimeFormat name="start_hour_#currentrow#" value="#timeformat(start_date,'HH')#">
                                            </div>
                                            <div class="col col-6 col-xs-6">
                                                <select name="start_minute_#currentrow#" id="start_minute_#currentrow#">
                                                    <cfloop from="0" to="59" index="a" step="1">
                                                        <cfoutput><option value="#Numberformat(a,00)#" <cfif timeformat(start_date,'MM') eq a> selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                                    </cfloop>
                                                </select>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="col col-12">
                                            <div class="col col-6 col-xs-6">
                                                <cf_wrkTimeFormat name="finish_hour_#currentrow#" value="#timeformat(finish_date,'HH')#">
                                            </div>
                                            <div class="col col-6 col-xs-6">
                                                <select name="finish_minute_#currentrow#" id="finish_minute_#currentrow#">
                                                    <cfloop from="0" to="59" index="a" step="1">
                                                        <cfoutput><option value="#Numberformat(a,00)#" <cfif timeformat(finish_date,'MM') eq a> selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                                    </cfloop>
                                                </select>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </cfoutput>
                        </cfif>
                    </tbody>
                </cf_grid_list>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function="control()"next_page="#request.self#?fuseaction=ehesap.working_inout">
        </cf_box_footer>
    </cfform>
</cf_box>
<script>
    function sil(no)
    {
        $("#pdks_working_inout tr#"+no).hide();
        $("#row_"+no).val("0");
    }
    var jsonArray = [
    {
        "sil" : "<a style='cursor:pointer;' onclick='sil(&id&);'><i class='fa fa-minus'></i></a><input name='in_out_row' value='&id&' type='hidden'>",
        "working_type" : "<select name='working_type_&id&' id='working_type_&id&' data-bind='value: selected().html'><cfoutput query='get_setup_working_type'><option value='#get_setup_working_type.working_type#'>#get_setup_working_type.detail#</option></cfoutput></select>",
        "start_hour": '<div class="col col-12"><div class="col col-6 col-xs-6"><cf_wrkTimeFormat name="start_hour_&id&" value=""></div><div class="col col-6 col-xs-6"><select name="start_minute_&id&" id="start_minute_&id&"><cfloop from="0" to="59" index="a" step="1"><cfoutput><option value="#Numberformat(a,00)#">#Numberformat(a,00)#</option></cfoutput></cfloop></select></div></div>',
        "finish_hour":'<div class="col col-12"><div class="col col-6 col-xs-6"><cf_wrkTimeFormat name="finish_hour_&id&" value=""></div><div class="col col-6 col-xs-6"><select name="finish_minute_&id&" id="finish_minute_&id&"><cfloop from="0" to="59" index="a" step="1"><cfoutput><option value="#Numberformat(a,00)#">#Numberformat(a,00)#</option></cfoutput></cfloop></select></div></div>'
    }];
    var working_inout_day_count = parseInt($("input[name=working_inout_day_count]").val());
    function addRow(){
        working_inout_day_count +=1;
        jsonArray.filter((a) => {
            var template="<tr id='"+working_inout_day_count+"'><input type='hidden' name='row_&id&' id='row_&id&' value='1'><td class='text-center'>{sil}</td><td>{working_type}</td><td>{start_hour}</td><td>{finish_hour}</td></tr>";
            $('#pdks_working_inout').append(nano( template, a ).replace(/&id&/g,working_inout_day_count) );
        });
        $("input[name=working_inout_day_count]").val(working_inout_day_count);
    }

    function control()
    {
        for(i=1; i<=working_inout_day_count; i++)
        {
            start_clock = $('#start_hour_'+i).val();
            finish_clock = $('#finish_hour_'+i).val();
            start_minute = $('#start_minute_'+i).val();
            finish_minute = $('#finish_minute_'+i).val();
            if(start_clock != undefined && start_minute != undefined && finish_clock != undefined && finish_minute != undefined)
            {
                if(start_clock == 0 || finish_clock == 0 || start_minute == '' || finish_minute == ''){
                    alert("Lütfen Saat Aralığı Seçiniz!");
                    return false;
                }
                if(start_clock > finish_clock) 
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
        //form submit
        myform = document.getElementById("pdks_working_inout_form");
        form_data= new FormData(myform);
        AjaxControlPostData('/V16/hr/ehesap/cfc/pdks_working_inout.cfc?method=add_pdks_working_inout_day', form_data, function(response) {
            
            response = JSON.parse(response);
            if(response.STATUS){
                $('#day_table_<cfoutput>#attributes.currentrow#_#attributes.day#</cfoutput> td').remove();
                for(i=1; i<=working_inout_day_count; i++)
                {
                    working_type = $('#working_type_'+i).val();
                    var listParam = working_type + "*";
			        var working_type_val = wrk_safe_query('get_setup_working_type','dsn',0,listParam);
                    $('#day_table_<cfoutput>#attributes.currentrow#_#attributes.day#</cfoutput>').append('<td style="background:#'+working_type_val.COLOR_CODE[0]+';padding: 7px;">'+working_type_val.WORKING_ABBREVIATION[0]+'</td>');
                }
                $("#action_list").val($("#action_list").val()+","+response.IDENTITY);
                closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' )
               
            }else{
            }
        });
        return false;
    };
</script>
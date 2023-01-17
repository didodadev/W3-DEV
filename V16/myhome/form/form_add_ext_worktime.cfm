<!--- Fazla mesai xml --->
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset get_day_control = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.list_ext_worktimes',
    property_name : 'is_day_control'
    )
>
<cfif get_day_control.recordcount>
	<cfset is_day_control = get_day_control.property_value>
<cfelse>
	<cfset is_day_control = 0>
</cfif>
<cf_catalystHeader>
<cfscript>
	last_in_out_id = createObject("component","V16.myhome.cfc.get_last_in_out");
	last_in_out_id.dsn = dsn;
	get_last_in_out = last_in_out_id.last_in_out(
        employee_id : session.ep.userid
    );
</cfscript>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform name="ext_worktime_request" action="#request.self#?fuseaction=myhome.emptypopup_add_ext_worktime" method="post">
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='38224.Fazla Mesai'><cf_get_lang dictionary_id='34493.Ekleme'></cfsavecontent>  
        <cf_box>
            <cf_box_elements>
                <input type="hidden" value="1" name="is_puantaj_off" id="is_puantaj_off">
                <div class="row" type="row">
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-employee_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                                    <input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#get_last_in_out.IN_OUT_ID#</cfoutput>">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57576.Çalışan'></cfsavecontent>
                                    <cfinput name="EMPLOYEE" id="EMPLOYEE" type="text" style="width:150px;" required="yes" message="#message#" readonly="yes" value="#session.ep.name# #session.ep.surname#">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_emp_in_out&field_in_out_id=ext_worktime_request.in_out_id&field_emp_name=ext_worktime_request.EMPLOYEE&field_emp_id=ext_worktime_request.employee_id&upper_position_code=<cfoutput>#session.ep.position_code#</cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                            </div>
                        </div>
                        <div class="form-group" id="item-Shift_Status">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30866.Mesai'><cf_get_lang dictionary_id='42004.Karşılığı'></label>
                            <div class="col col-8 col-xs-12">                   
                                <select name="Shift_Status" id="Shift_Status" style="width:150px;" onchange="tik();">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="1"><cf_get_lang dictionary_id='38380.Serbest'><cf_get_lang dictionary_id='41697.Zaman'></option>
                                    <option value="2"><cf_get_lang dictionary_id='59683.Ucret eklensin'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-Working_Location">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32327.Çalışma'></label>
                            <div class="col col-8 col-xs-12">                   
                                <select name="Working_Location" id="Working_Location" style="width:150px;">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="1"><cf_get_lang dictionary_id='38672.Kurum İçi'></option>
                                    <option value="2"><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='38447.Şehir İçi'></option>
                                    <option value="3"><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='38448.Yurt İçi'></option>
                                    <option value="4"><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='39476.Yurt Dışı'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-startdate">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57742.Tarih'></cfsavecontent>
                                    <cfinput type="text" name="startdate" id="startdate" value="" maxlength="10" validate="#validate_style#" message="#message#" required="yes">
                                    <span class="input-group-addon">
                                        <cfif is_day_control eq 1>
                                            <cf_wrk_date_image date_field="startdate" call_function="control">
                                        <cfelse>
                                            <cf_wrk_date_image date_field="startdate">
                                        </cfif>
                                    </span>
                                </div>        
                            </div>
                        </div>
                        <div class="form-group" id="item-start_hour">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
                            <div class="col col-4 col-xs-12">
                                <cf_wrkTimeFormat name="start_hour" value="0">
                            </div>
                            <div class="col col-4 col-xs-12">
                                <select name="start_min" id="start_min">
                                    <option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
                                    <cfloop from="1" to="59" index="i">
                                        <cfoutput>
                                            <option value="#i#">#i#</option>
                                        </cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-end_hour">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>
                            <div class="col col-4 col-xs-12">
                                <cf_wrkTimeFormat name="end_hour" value="0">
                            </div>
                            <div class="col col-4 col-xs-12">
                                <select name="end_min" id="end_min">
                                    <option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
                                    <cfloop from="1" to="59" index="i">
                                        <cfoutput>
                                            <option value="#i#">#i#</option>
                                        </cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-day_type">
                            <label class="col col-4 col-xs-12">&nbsp;</label>
                            <div class="col col-8 col-xs-12">
                                <label><input type="radio" name="day_type" id="day_type" value="0" checked> <cf_get_lang dictionary_id='53727.Çalışma Günü'></label>
                                <label><input type="radio" name="day_type" id="day_type" value="1"> <cf_get_lang dictionary_id='58867.Hafta Tatili'></label>
                                <label><input type="radio" name="day_type" id="day_type" value="2"> <cf_get_lang dictionary_id='31473.Resmi Tatil'></label>
                                <label><input type="radio" name="day_type" id="day_type" value="3"><cf_get_lang dictionary_id='54251.Gece Çalışması'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-valid_detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12"><textarea name="valid_detail" id="valid_detail" style="width:150px;height:60px;"></textarea></div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='check_()'>
            </cf_box_footer>
        </cf_box>
    </cfform>
</div>
<script type="text/javascript">
    function myfisherdatefixer(date) { let d = date.split('/'); return d[1]+'/'+d[0]+'/'+d[2]; } 
    function tik()
    {
        if (document.getElementById('Shift_Status').value == 1)
        {  
            document.getElementById('is_puantaj_off').value = 1;
        }
        else{
            document.getElementById('is_puantaj_off').value = 0;
        }
    }

	function check_()
	{
        start_clock = $('#start_hour').val();
        finish_clock = $('#end_hour').val();
        start_minute = $('#start_min').val();
        finish_minute = $('#end_min').val();

        if(start_clock != undefined && start_minute != undefined && finish_clock != undefined && finish_minute != undefined)
        {
            if(start_clock > finish_clock) 
            {
                alert("<cf_get_lang dictionary_id='31409.Başlangıç Saati Bitiş Saatinden Büyük Olamaz'>!");
                return false;
            }
            else if((start_clock == finish_clock) && (start_minute ==finish_minute))
            {	
                alert("<cf_get_lang dictionary_id ='31636.Başlangıç ve  Bitiş Saati Aynı Olamaz'>!");
                return false;
            }
            else if((start_clock == finish_clock) && (start_minute > finish_minute))
            {
                alert("<cf_get_lang dictionary_id ='31409.Başlangıç Saati Bitiş Saatinden Büyük Olamaz'>!");
                return false;
            }
        }
		<cfif attributes.fuseaction neq 'ehesap.list_ext_worktimes'>
		    return process_cat_control();
		<cfelse>
		    return true;
		</cfif>
	}
    function control()
    {
        startdate = $("#startdate").val();
        parameters = startdate;
        
        //Hafta Sonu Kontrolü
        startdate_format = myfisherdatefixer( $("#startdate").val());
        date_format = new Date(startdate_format);
        dayofweek = date_format.getDay();
        
        //Resmi Tatil Kontrolü
        get_shift_conflict = wrk_safe_query('get_general_offtimes','dsn',0,parameters);

        //Vardiya Kontrolü
        is_shift_holiday = 0;
        employee_id = $("#employee_id").val();
        startdate = $("#startdate").val();
        finishdate = $("#startdate").val();
        is_shift_holiday = shift_holiday_control(employee_id, startdate,finishdate);

        if(get_shift_conflict.recordcount > 0)
        {
            $("input[name=day_type][value=2]").prop("checked", true);
        }
        else if(((dayofweek == 6 || dayofweek == 0) && is_shift_holiday == 0) || is_shift_holiday == 1)
        {
            $("input[name=day_type][value=1]").prop("checked", true);
        }
        else
        {
            $("input[name=day_type][value=0]").prop("checked", true);
        }     
    }
</script>
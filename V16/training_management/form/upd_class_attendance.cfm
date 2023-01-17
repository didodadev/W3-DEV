<cf_xml_page_edit fuseact="training_management.popup_form_add_class_attendance">
<cfquery name="GET_CLASS_ATTENDANCE" datasource="#DSN#">
	SELECT
		TRAINING_CLASS.CLASS_NAME,
		TRAINING_CLASS_ATTENDANCE.*
	FROM
		TRAINING_CLASS_ATTENDANCE,
		TRAINING_CLASS
	WHERE
		TRAINING_CLASS_ATTENDANCE.CLASS_ATTENDANCE_ID IS NOT NULL AND
		TRAINING_CLASS_ATTENDANCE.CLASS_ID = TRAINING_CLASS.CLASS_ID
		<cfif isDefined("class_attendance_id") and len(attributes.class_attendance_id)>
			AND TRAINING_CLASS_ATTENDANCE.CLASS_ATTENDANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_attendance_id#">
		</cfif>
</cfquery>
<cfquery name="GET_CLASS_ATTENDANCE_DT" datasource="#DSN#">
	SELECT
		'employee' TYPE,
		1 DT_TYPE,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME AD,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME SOYAD,
		TADT.CLASS_ATTENDANCE_ID CLASS_ATTENDANCE_ID,
		TADT.EMP_ID EMP_ID,
		TADT.PAR_ID PAR_ID,
		TADT.CON_ID CON_ID,
		TADT.ATTENDANCE_MAIN ATTENDANCE,
		TADT.IS_EXCUSE_MAIN IS_EXCUSE,
		TADT.EXCUSE_MAIN EXCUSE,
		TADT.REASON_TO_START_ID,
		TADT.IS_TRAINER
	FROM
		TRAINING_CLASS_ATTENDANCE_DT TADT,
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH,
		OUR_COMPANY C
	WHERE
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND 
		C.COMP_ID = BRANCH.COMPANY_ID AND 
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = TADT.EMP_ID AND 
		EMPLOYEE_POSITIONS.IS_MASTER = 1 AND 
		TADT.EMP_ID IS NOT NULL AND 
		TADT.CLASS_ATTENDANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_attendance_id#">
		
	UNION

	SELECT 
		'partner' TYPE,
		1 DT_TYPE,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME AD,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME SOYAD,
		TADT.CLASS_ATTENDANCE_ID CLASS_ATTENDANCE_ID,
		TADT.EMP_ID EMP_ID,
		TADT.PAR_ID PAR_ID,
		TADT.CON_ID CON_ID,
		TADT.ATTENDANCE_MAIN ATTENDANCE,
		TADT.IS_EXCUSE_MAIN IS_EXCUSE,
		TADT.EXCUSE_MAIN EXCUSE,
		TADT.REASON_TO_START_ID,
		TADT.IS_TRAINER
	FROM
		TRAINING_CLASS_ATTENDANCE_DT TADT,
		COMPANY_PARTNER
	WHERE	
		TADT.CLASS_ATTENDANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_attendance_id#"> AND 
		COMPANY_PARTNER.PARTNER_ID = TADT.PAR_ID AND 
		TADT.PAR_ID IS NOT NULL
		
	UNION
	
	SELECT
		'consumer' TYPE,
		1 DT_TYPE,
		CONSUMER.CONSUMER_NAME AD,
		CONSUMER.CONSUMER_SURNAME SOYAD,
		TADT.CLASS_ATTENDANCE_ID CLASS_ATTENDANCE_ID,
		TADT.EMP_ID EMP_ID,
		TADT.PAR_ID PAR_ID,
		TADT.CON_ID CON_ID,
		TADT.ATTENDANCE_MAIN ATTENDANCE,
		TADT.IS_EXCUSE_MAIN IS_EXCUSE,
		TADT.EXCUSE_MAIN EXCUSE,
		TADT.REASON_TO_START_ID,
		TADT.IS_TRAINER
	FROM
		TRAINING_CLASS_ATTENDANCE_DT TADT,
		CONSUMER
	WHERE
		TADT.CLASS_ATTENDANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_attendance_id#"> AND 
		CONSUMER.CONSUMER_ID = TADT.CON_ID AND 
		TADT.CON_ID IS NOT NULL
</cfquery>
<cfquery name="get_reason_to_start" datasource="#dsn#">
	SELECT TRAINING_EXCUSE_ID, EXCUSE_HEAD FROM SETUP_TRAINING_EXCUSES WHERE IS_ACTIVE = 1 AND REASON_TO_START = 1 ORDER BY EXCUSE_HEAD
</cfquery>
<cfset show_reason = 1>
<cfif x_reason_to_leave eq 1>
	<cfquery name="get_class" datasource="#dsn#">
		SELECT INT_OR_EXT FROM TRAINING_CLASS WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
	</cfquery>
	<cfif get_class.int_or_ext neq 1>
		<cfset show_reason = 0>
	</cfif>
</cfif>
<cfset start_date = date_add('h', session.ep.time_zone, get_class_attendance.start_date)>
<cfset finish_date = date_add('h', session.ep.time_zone, get_class_attendance.finish_date)>
<cfsavecontent variable="img_">
	<cfoutput>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_class_attendance&action=print&id=#get_class_attendance.class_attendance_id#&module=training_management&iframe=1&trail=1','page');return false;"><img src="/images/print.gif" border="0" title="<cf_get_lang_main no='62.Yazdır'>"></a>
	</cfoutput>
</cfsavecontent>
<cf_popup_box title="#getLang('training_management',222)#" right_images="#img_#">
<cfform name="upd_class_attendance" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_class_attendance">
<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
<input type="hidden" name="class_attendance_id" id="class_attendance_id" value="<cfoutput>#get_class_attendance.class_attendance_id#</cfoutput>">
<input type="hidden" name="attendance_row_count" id="attendance_row_count" value="<cfoutput>#get_class_attendance_dt.recordcount#</cfoutput>">
	<div class="row">
		<div class="row form-inline">
			<div class="form-group" id="item-start_date">
				<div class="col col-12 col-md-6 col-xs-12">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='641.başlangıç tarihi'></cfsavecontent>
                		<cfinput value="#dateformat(start_date,dateformat_style)#" required="Yes" placeholder="#getLang('main',89)#" validate="#validate_style#" message="#message#" type="text" name="start_date" style="width:65px;" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="col col-12 col-md-3 col-xs-12">
					<select name="event_start_clock" id="event_start_clock" style="width:54px;">
                    	<option value="0" selected><cf_get_lang_main no='79.Saat'></option>
							<cfloop from="7" to="30" index="i">
							<cfset saat=i mod 24>
                        <option value="<cfoutput>#saat#</cfoutput>"<cfif timeformat(start_date,'HH') eq saat> selected</cfif>><cfoutput>#saat#</cfoutput></option>
                    </cfloop>
                </select>
				</div>
				<div class="col col-12 col-md-3 col-xs-12">
					<select name="event_start_minute" id="event_start_minute" style="width:54px;">
						<option value="00">00</option>
						<option value="05"<cfif timeformat(start_date,'MM') eq 05> selected</cfif>>05</option>
						<option value="10"<cfif timeformat(start_date,'MM') eq 10> selected</cfif>>10</option>
						<option value="15"<cfif timeformat(start_date,'MM') eq 15> selected</cfif>>15</option>
						<option value="20"<cfif timeformat(start_date,'MM') eq 20> selected</cfif>>20</option>
						<option value="25"<cfif timeformat(start_date,'MM') eq 25> selected</cfif>>25</option>
						<option value="30"<cfif timeformat(start_date,'MM') eq 30> selected</cfif>>30</option>
						<option value="35"<cfif timeformat(start_date,'MM') eq 35> selected</cfif>>35</option>
						<option value="40"<cfif timeformat(start_date,'MM') eq 40> selected</cfif>>40</option>
						<option value="45"<cfif timeformat(start_date,'MM') eq 45> selected</cfif>>45</option>
						<option value="50"<cfif timeformat(start_date,'MM') eq 50> selected</cfif>>50</option>
						<option value="55"<cfif timeformat(start_date,'MM') eq 55> selected</cfif>>55</option>
					</select>
				</div>
			</div>
		</div>
		<!--- event cat dan alınacak --->
		<div class="row form-inline">
			<div class="form-group" id="item-start_date">
				<div class="col col-12 col-md-6 col-xs-12">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.bitis tarihi'></cfsavecontent>
                		<cfinput value="#dateformat(finish_date,dateformat_style)#"type="text" placeholder="#getLang('main',90)#" name="finish_date" style="width:65px;" required="Yes" message="#message#" validate="#validate_style#" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="col col-12 col-md-3 col-xs-12">
					<select name="event_finish_clock" id="event_finish_clock" style="width:54px;">
                        <option value="0" selected><cf_get_lang_main no='79.Saat'></option>
                        <cfloop from="7" to="30" index="i">
                            <cfset saat=i mod 24>
                            <option value="<cfoutput>#saat#</cfoutput>"<cfif timeformat(finish_date,'HH') eq saat> selected</cfif>><cfoutput>#saat#</cfoutput></option>
                        </cfloop>
                    </select>
				</div>
				<div class="col col-12 col-md-3 col-xs-12">
					<select name="event_finish_minute" id="event_finish_minute" style="width:54px;">
                        <option value="00">00</option>
                        <option value="05"<cfif timeformat(finish_date,'MM') eq 05> selected</cfif>>05</option>
                        <option value="10"<cfif timeformat(finish_date,'MM') eq 10> selected</cfif>>10</option>
                        <option value="15"<cfif timeformat(finish_date,'MM') eq 15> selected</cfif>>15</option>
                        <option value="20"<cfif timeformat(finish_date,'MM') eq 20> selected</cfif>>20</option>
                        <option value="25"<cfif timeformat(finish_date,'MM') eq 25> selected</cfif>>25</option>
                        <option value="30"<cfif timeformat(finish_date,'MM') eq 30> selected</cfif>>30</option>
                        <option value="35"<cfif timeformat(finish_date,'MM') eq 35> selected</cfif>>35</option>
                        <option value="40"<cfif timeformat(finish_date,'MM') eq 40> selected</cfif>>40</option>
                        <option value="45"<cfif timeformat(finish_date,'MM') eq 45> selected</cfif>>45</option>
                        <option value="50"<cfif timeformat(finish_date,'MM') eq 50> selected</cfif>>50</option>
                        <option value="55"<cfif timeformat(finish_date,'MM') eq 55> selected</cfif>>55</option>
                    </select>
				</div>
			</div>
		</div>
	</div>	
    <cfquery name="get_attenders" dbtype="query">
    	SELECT * FROM get_class_attendance_dt WHERE IS_TRAINER = 0
    </cfquery>
    <cf_medium_list>
        <thead>
        	<tr>
    			<th colspan="6"><cf_get_lang_main no='178.Katılımcılar'></th>
    		</tr>
            <tr>
                <th width="25"><cf_get_lang_main no='75.No'></th>
                <th width="200"><cf_get_lang_main no='158.Ad Soyad'></th>
                <th><cf_get_lang no='174.Yoklama'>*</th>
                <th><cf_get_lang no='115.Mazeretli'></th>
                <cfif show_reason eq 1><th>Eğitime Başlamama Sebebi</th></cfif>
                <th><cf_get_lang_main no='217.Açıklama'></th>
            </tr>
        </thead>
        <tbody>
        <cfoutput query="get_attenders">
        	<input name="dt_type" id="dt_type" value="#dt_type#" type="hidden">
        	<input type="hidden" name="is_tra_#currentrow#" id="is_tra_#currentrow#" value="0">
            <tr>
                <td>#currentrow#</td>
                <td><cfif len(get_attenders.emp_id)>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_attenders.emp_id#','medium');" class="tableyazi">#get_attenders.ad#&nbsp;#get_attenders.soyad#</a>
                        <input type="hidden" name="emp_id_#currentrow#" id="emp_id_#currentrow#" value="#emp_id#">
                    <cfelseif len(get_attenders.par_id)>
                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_attenders.par_id#','medium');" class="tableyazi">#get_attenders.ad#&nbsp;#get_attenders.soyad#</a>
                        <input type="hidden" name="par_id_#currentrow#" id="par_id_#currentrow#" value="#par_id#">
                    <cfelseif len(get_attenders.con_id)>
                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_attenders.con_id#','medium');" class="tableyazi">#get_attenders.ad#&nbsp;#get_attenders.soyad#</a>
                        <input type="hidden" name="con_id_#currentrow#" id="con_id_#currentrow#" value="#con_id#">
                    </cfif>
                </td>
                <td align="center">
                    <cfif get_attenders.dt_type eq 1>
						<input type="text" name="attendance_#currentrow#" id="attendance_#currentrow#" value="#attendance#" style="width:50px" maxlength="3" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
					<cfelse>	
                        <input type="text" name="attendance_#currentrow#" id="attendance_#currentrow#" style="width:50px" value="100" maxlength="3" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
                    </cfif>
                </td>
                <td align="center">
                    <cfif get_attenders.dt_type eq 1>
						<input type="checkbox" name="is_excuse_#currentrow#" id="is_excuse_#currentrow#" <cfif is_excuse eq 1>checked</cfif>>
                    <cfelse>	
                        <input type="checkbox" name="is_excuse_#currentrow#" id="is_excuse_#currentrow#">
                    </cfif>
                </td>
                <cfif show_reason eq 1>
	                <td align="center">
	                	<select name="reason_to_start_#currentrow#" id="reason_to_start_#currentrow#" style="width:140px;">
	                    	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
	                    	<cfloop query="get_reason_to_start">
	                    		<option value="#training_excuse_id#" <cfif get_attenders.reason_to_start_id eq training_excuse_id>selected</cfif>>#excuse_head#</option>
	                    	</cfloop>
	                    </select>
	                </td>
                </cfif>
                <td>
                    <cfif get_attenders.dt_type eq 1>
					   <input type="text" name="excuse_#currentrow#" id="excuse_#currentrow#" style="width:200px;" value="#excuse#" maxlength="100">
                    <cfelse>
                        <input type="text" name="excuse_#currentrow#" id="excuse_#currentrow#" style="width:200px;" maxlength="100">
                    </cfif>
                </td>
            </tr>
        </cfoutput>
        </tbody>
        <tfoot>
            <tr>
                <td colspan="6" class="txtbold" height="20">*<cf_get_lang no='223.Kişi Eğitime Katıldıysa 0 ile 100 Arasında Katılım Oranı Girilmeli !'></td>
            </tr>
        </tfoot>
    </cf_medium_list><br>
    <cfquery name="get_trainers" dbtype="query">
    	SELECT * FROM get_class_attendance_dt WHERE IS_TRAINER = 1
    </cfquery>
    <cf_medium_list>
    	<thead>
    		<tr>
    			<th colspan="6"><cf_get_lang no='118.Eğitimciler'></th>
    		</tr>
    		<tr>
    			<th width="25"><cf_get_lang_main no='75.No'></th>
                <th width="200"><cf_get_lang_main no='158.Ad Soyad'></th>
                <th><cf_get_lang no='174.Yoklama'>*</th>
                <th><cf_get_lang no='115.Mazeretli'></th>
                <cfif show_reason eq 1><th>Eğitime Başlamama Sebebi</th></cfif>
                <th><cf_get_lang_main no='217.Açıklama'></th>
    		</tr>
    	</thead>
    	<tbody>
    		<cfoutput query="get_trainers">
    			<input type="hidden" name="is_tra_#currentrow+get_attenders.recordcount#" id="is_tra_#currentrow+get_attenders.recordcount#" value="1">
    			<input name="dt_type" id="dt_type" value="#dt_type#" type="hidden">
    			<tr>
    				<td>#currentrow#</td>
    				<td><cfif len(get_trainers.emp_id)>
	                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_trainers.emp_id#','medium');" class="tableyazi">#get_trainers.ad#&nbsp;#get_trainers.soyad#</a>
	                        <input type="hidden" name="emp_id_#currentrow+get_attenders.recordcount#" id="emp_id_#currentrow+get_attenders.recordcount#" value="#emp_id#">
	                    <cfelseif len(get_trainers.par_id)>
	                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_trainers.par_id#','medium');" class="tableyazi">#get_trainers.ad#&nbsp;#get_trainers.soyad#</a>
	                        <input type="hidden" name="par_id_#currentrow+get_attenders.recordcount#" id="par_id_#currentrow+get_attenders.recordcount#" value="#par_id#">
	                    <cfelseif len(get_trainers.con_id)>
	                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_trainers.con_id#','medium');" class="tableyazi">#get_trainers.ad#&nbsp;#get_trainers.soyad#</a>
	                        <input type="hidden" name="con_id_#currentrow+get_attenders.recordcount#" id="con_id_#currentrow+get_attenders.recordcount#" value="#con_id#">
	                    </cfif>
	                </td>
	                <td align="center">
	                    <cfif get_trainers.dt_type eq 1>
							<input type="text" name="attendance_#currentrow+get_attenders.recordcount#" id="attendance_#currentrow+get_attenders.recordcount#" value="#attendance#" style="width:50px" maxlength="3" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
						<cfelse>	
	                        <input type="text" name="attendance_#currentrow+get_attenders.recordcount#" id="attendance_#currentrow+get_attenders.recordcount#" style="width:50px" value="100" maxlength="3" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
	                    </cfif>
	                </td>
	                <td align="center">
	                    <cfif get_trainers.dt_type eq 1>
							<input type="checkbox" name="is_excuse_#currentrow+get_attenders.recordcount#" id="is_excuse_#currentrow+get_attenders.recordcount#" <cfif is_excuse eq 1>checked</cfif>>
	                    <cfelse>	
	                        <input type="checkbox" name="is_excuse_#currentrow+get_attenders.recordcount#" id="is_excuse_#currentrow+get_attenders.recordcount#">
	                    </cfif>
	                </td>
	                <cfif show_reason eq 1>
		                <td align="center">
		                	<select name="reason_to_start_#currentrow+get_attenders.recordcount#" id="reason_to_start_#currentrow+get_attenders.recordcount#" style="width:140px;">
		                    	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
		                    	<cfloop query="get_reason_to_start">
		                    		<option value="#training_excuse_id#" <cfif get_trainers.reason_to_start_id eq training_excuse_id>selected</cfif>>#excuse_head#</option>
		                    	</cfloop>
		                    </select>
		                </td>
	                </cfif>
	                <td>
	                    <cfif get_trainers.dt_type eq 1>
						   <input type="text" name="excuse_#currentrow+get_attenders.recordcount#" id="excuse_#currentrow+get_attenders.recordcount#" style="width:200px;" value="#excuse#" maxlength="100">
	                    <cfelse>
	                        <input type="text" name="excuse_#currentrow+get_attenders.recordcount#" id="excuse_#currentrow+get_attenders.recordcount#" style="width:200px;" maxlength="100">
	                    </cfif>
	                </td>
    			</tr>
    		</cfoutput>
    	</tbody>
    	<tfoot>
    		<tr>
                <td colspan="6" class="txtbold" height="20">*<cf_get_lang no='223.Kişi Eğitime Katıldıysa 0 ile 100 Arasında Katılım Oranı Girilmeli !'></td>
            </tr>
    	</tfoot>
    </cf_medium_list>	
    <cf_popup_box_footer>
        <cfif GET_CLASS_ATTENDANCE.recordcount><cf_record_info query_name="GET_CLASS_ATTENDANCE"></cfif>
        <cf_workcube_buttons is_upd='1' add_function='check()' delete_page_url='#request.self#?fuseaction=training_management.emptypopup_del_class_attendance&class_id=#attributes.class_id#&class_attendance_id=#attributes.class_attendance_id#'>
    </cf_popup_box_footer>			
</cfform>
</cf_popup_box>
<script type="text/javascript">
function check()
{
	emp_count = $('#attendance_row_count').val();
	if (emp_count > 0)
	{
		for(i=1;i<=emp_count;i++)
		{
			if(! ($('#attendance_'+i).val().length > 0))
			{
				alert('Çalışanlara yoklama oranı girmelisiniz!');
				return false;
			}
		}
	}
	if ((upd_class_attendance.start_date.value != "") && (upd_class_attendance.finish_date.value != ""))
		return time_check(upd_class_attendance.start_date, upd_class_attendance.event_start_clock, upd_class_attendance.event_start_minute, upd_class_attendance.finish_date,  upd_class_attendance.event_finish_clock, upd_class_attendance.event_finish_minute, "<cf_get_lang no='80.Ders yoklamasının başlangıç tarihi, bitiş tarihinden önce olmalıdır'>!");
	return true;	
}
</script> 

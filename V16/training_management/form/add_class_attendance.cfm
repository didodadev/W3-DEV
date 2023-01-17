<cf_xml_page_edit fuseact="training_management.popup_form_add_class_attendance">
<cfquery name="get_attender" datasource="#dsn#">
	SELECT
		'EMP' AS TYPE,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME AS AD,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME AS SOYAD,
		TRAINING_CLASS_ATTENDER.EMP_ID TYPE_ID
	FROM
		TRAINING_CLASS_ATTENDER,
		EMPLOYEE_POSITIONS
	WHERE
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = TRAINING_CLASS_ATTENDER.EMP_ID AND 
		EMPLOYEE_POSITIONS.IS_MASTER = 1 AND 
		TRAINING_CLASS_ATTENDER.EMP_ID IS NOT NULL AND 
		TRAINING_CLASS_ATTENDER.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
	UNION
	SELECT 
		'PAR' AS TYPE,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME AS AD,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS SOYAD,
		TRAINING_CLASS_ATTENDER.PAR_ID TYPE_ID
	FROM
		TRAINING_CLASS_ATTENDER,
		COMPANY_PARTNER
	WHERE	
		TRAINING_CLASS_ATTENDER.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#"> AND 
		COMPANY_PARTNER.PARTNER_ID = TRAINING_CLASS_ATTENDER.PAR_ID  AND 
		TRAINING_CLASS_ATTENDER.PAR_ID IS NOT NULL
	UNION
	SELECT
		'CON' AS TYPE,
		CONSUMER.CONSUMER_NAME AS AD,
		CONSUMER.CONSUMER_SURNAME AS SOYAD,
		TRAINING_CLASS_ATTENDER.CON_ID TYPE_ID
	FROM
		TRAINING_CLASS_ATTENDER,
		CONSUMER
	WHERE
		TRAINING_CLASS_ATTENDER.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#"> AND 
		CONSUMER.CONSUMER_ID = TRAINING_CLASS_ATTENDER.CON_ID AND 
		TRAINING_CLASS_ATTENDER.CON_ID IS NOT NULL
</cfquery>
<cfquery name="get_trainer" datasource="#dsn#">
	SELECT
		'EMP' AS TYPE,
		E.EMPLOYEE_NAME AS AD,
		E.EMPLOYEE_SURNAME AS SOYAD,
		TCT.EMP_ID TYPE_ID
	FROM
		TRAINING_CLASS_TRAINERS TCT 
		INNER JOIN EMPLOYEES E ON TCT.EMP_ID = E.EMPLOYEE_ID 
	WHERE
		TCT.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
	UNION
	SELECT 
		'PAR' AS TYPE,
		CP.COMPANY_PARTNER_NAME AS AD,
		CP.COMPANY_PARTNER_SURNAME AS SOYAD,
		TCT.PAR_ID TYPE_ID
	FROM
		TRAINING_CLASS_TRAINERS TCT 
		INNER JOIN COMPANY_PARTNER CP ON TCT.PAR_ID =CP.PARTNER_ID 
	WHERE	
		TCT.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
	UNION
	SELECT
		'CON' AS TYPE,
		C.CONSUMER_NAME AS AD,
		C.CONSUMER_SURNAME AS SOYAD,
		TCT.CONS_ID TYPE_ID
	FROM
		TRAINING_CLASS_TRAINERS TCT 
		INNER JOIN CONSUMER C ON TCT.CONS_ID =C.CONSUMER_ID
	WHERE
		TCT.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
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
<cf_popup_box title="#getLang('training_management',174)#">
<cfform name="add_class_attendance" method="post" action="#request.self#?fuseaction=training_management.emptypopup_add_class_attendance">
<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#class_id#</cfoutput>">
<input type="hidden" name="attendance_row_count" id="attendance_row_count" value="<cfoutput>#get_attender.recordcount+get_trainer.recordcount#</cfoutput>">
	<div class="row">
		<div class="row form-inline">
			<div class="form-group" id="item-start_date">
				<div class="col col-12 col-md-6 col-xs-12">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='641.başlangıç tarihi'></cfsavecontent>
						<cfinput required="Yes" validate="#validate_style#" placeholder="#getLang('main',89)#" message="#message#" type="text" name="start_date" style="width:80px;" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="col col-12 col-md-3 col-xs-12">
					<select name="event_start_clock" id="event_start_clock" style="width:54px;">
						<option value="0" selected><cf_get_lang_main no='79.Saat'></option>
						<cfloop from="7" to="30" index="i">
							<cfset saat=i mod 24>
							<option value="<cfoutput>#saat#</cfoutput>"><cfoutput>#saat#</cfoutput></option>
						</cfloop>
					</select>
				</div>
				<div class="col col-12 col-md-3 col-xs-12">
					<select name="event_start_minute" id="event_start_minute" style="width:54px;">
						<option value="00" selected>00</option>
						<option value="05">05</option>
						<option value="10">10</option>
						<option value="15">15</option>
						<option value="20">20</option>
						<option value="25">25</option>
						<option value="30">30</option>
						<option value="35">35</option>
						<option value="40">40</option>
						<option value="45">45</option>
						<option value="50">50</option>
						<option value="55">55</option>
					</select>
				</div>
			</div>
		</div>
		<!--- event cat dan alınacak --->
		<div class="row form-inline">
			<div class="form-group" id="item-start_date">
				<div class="col col-12 col-md-6 col-xs-12">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.bitis tarihi'>!</cfsavecontent>
						<cfinput type="text" name="finish_date" style="width:80px;" placeholder="#getLang('main',90)#" required="Yes" message="#message#" validate="#validate_style#" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="col col-12 col-md-3 col-xs-12">
					<select name="event_finish_clock" id="event_finish_clock" style="width:54px;">
					<option value="0" selected><cf_get_lang_main no='79.Saat'></option>
						<cfloop from="7" to="30" index="i">
							<cfset saat=i mod 24>
							<option value="<cfoutput>#saat#</cfoutput>"><cfoutput>#saat#</cfoutput></option>
						</cfloop>
					</select>
				</div>
				<div class="col col-12 col-md-3 col-xs-12">
					<select name="event_finish_minute" id="event_finish_minute" style="width:54px;">
						<option value="00" selected>00</option>
						<option value="05">05</option>
						<option value="10">10</option>
						<option value="15">15</option>
						<option value="20">20</option>
						<option value="25">25</option>
						<option value="30">30</option>
						<option value="35">35</option>
						<option value="40">40</option>
						<option value="45">45</option>
						<option value="50">50</option>
						<option value="55">55</option>
					</select>
				</div>
			</div>
		</div>
	</div>	
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
            <cfoutput query="get_attender">
                <tr>
                	<input type="hidden" name="is_tra_#currentrow#" id="is_tra_#currentrow#" value="0">
                    <td width="25">#currentrow#</td>
                    <td><cfif get_attender.type eq 'emp'>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_attender.type_id#','medium');" class="tableyazi">#get_attender.ad#&nbsp;#get_attender.soyad#</a>
                            <input type="hidden" name="emp_id_#currentrow#" id="emp_id_#currentrow#" value="#get_attender.type_id#">
                        <cfelseif get_attender.type eq 'par'>
                            <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_attender.type_id#','medium');" class="tableyazi">#ad#&nbsp;#soyad#</a>
                            <input type="hidden" name="par_id_#currentrow#" id="par_id_#currentrow#" value="#get_attender.type_id#">
                        <cfelseif get_attender.type eq 'con'>
                            <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_attender.type_id#','medium');" class="tableyazi">#ad#&nbsp;#soyad#</a>
                            <input type="hidden" name="con_id_#currentrow#" id="con_id_#currentrow#" value="#get_attender.type_id#">
                        </cfif>
                    </td>
                    <td align="center"><input type="text" name="attendance_#currentrow#" id="attendance_#currentrow#" style="width:50px" value="100"  maxlength="3"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));"></td>
                    <td align="center"><input type="checkbox" name="is_excuse_#currentrow#" id="is_excuse_#currentrow#"></td>
                    <cfif show_reason eq 1>
	                    <td>
	                    	<select name="reason_to_start_#currentrow#" id="reason_to_start_#currentrow#" style="width:140px;">
	                    		<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
	                    		<cfloop query="get_reason_to_start">
	                    			<option value="#training_excuse_id#">#excuse_head#</option>
	                    		</cfloop>
	                    	</select>
	                    </td>
                    </cfif>
                    <td><input type="text" name="excuse_#currentrow#" id="excuse_#currentrow#" style="width:200px;" maxlength="100"></td>
                </tr>
            </cfoutput>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="6" class="txtbold" height="20"> *<cf_get_lang no='223.Kişi Eğitime Katıldıysa 0 ile 100 Arasında Katılım Oranı Girilmeli !'></td>
                </tr>
            </tfoot>
	</cf_medium_list>
	<br>
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
			<cfoutput query="get_trainer">
				<tr>
					<input type="hidden" name="is_tra_#currentrow+get_attender.recordcount#" id="is_tra_#currentrow+get_attender.recordcount#" value="1">
					<td width="25">#currentrow#</td>
					<td><cfif type eq 'emp'>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#type_id#','medium');" class="tableyazi">#ad#&nbsp;#soyad#</a>
                            <input type="hidden" name="emp_id_#currentrow+get_attender.recordcount#" id="emp_id_#currentrow+get_attender.recordcount#" value="#type_id#">
                        <cfelseif type eq 'par'>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#type_id#','medium');" class="tableyazi">#ad#&nbsp;#soyad#</a>
                            <input type="hidden" name="par_id_#currentrow+get_attender.recordcount#" id="par_id_#currentrow+get_attender.recordcount#" value="#type_id#">
                        <cfelseif type eq 'con'>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#type_id#','medium');" class="tableyazi">#ad#&nbsp;#soyad#</a>
                            <input type="hidden" name="con_id_#currentrow+get_attender.recordcount#" id="con_id_#currentrow+get_attender.recordcount#" value="#type_id#">
                        </cfif>
                    </td>
                    <td align="center"><input type="text" name="attendance_#currentrow+get_attender.recordcount#" id="attendance_#currentrow+get_attender.recordcount#" style="width:50px" value="100" maxlength="3" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));"></td>
                    <td align="center"><input type="checkbox" name="is_excuse_#currentrow+get_attender.recordcount#" id="is_excuse_#currentrow+get_attender.recordcount#"></td>
                    <cfif show_reason eq 1>
	                    <td>
	                    	<select name="reason_to_start_#currentrow+get_attender.recordcount#" id="reason_to_start_#currentrow+get_attender.recordcount#" style="width:140px;">
	                    		<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
	                    		<cfloop query="get_reason_to_start">
	                    			<option value="#training_excuse_id#">#excuse_head#</option>
	                    		</cfloop>
	                    	</select>
	                    </td>
                    </cfif>
                    <td><input type="text" name="excuse_#currentrow+get_attender.recordcount#" id="excuse_#currentrow+get_attender.recordcount#" style="width:200px;" maxlength="100"></td>
				</tr>
			</cfoutput>
			<tfoot>
				<tr>
					<td colspan="6" class="txtbold" height="20"> *<cf_get_lang no='223.Kişi Eğitime Katıldıysa 0 ile 100 Arasında Katılım Oranı Girilmeli !'></td>
				</tr>
			</tfoot>
		</tbody>
	</cf_medium_list>
	<cf_popup_box_footer><cf_workcube_buttons type_format='1' is_upd='0' add_function='check()'></cf_popup_box_footer>
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
	if ( (add_class_attendance.start_date.value != "") && (add_class_attendance.finish_date.value != "") )
		return time_check(add_class_attendance.start_date, add_class_attendance.event_start_clock, add_class_attendance.event_start_minute, add_class_attendance.finish_date,  add_class_attendance.event_finish_clock, add_class_attendance.event_finish_minute, "<cf_get_lang no='80.Ders yoklamasının başlangıç tarihi, bitiş tarihinden önce olmalıdır'>!");
	return true;	
}

</script>


<!--- <cfif isDefined("attributes.date")><cf_date tarih="attributes.date"></cfif> --->
	<cfparam name="attributes.is_butons" default="1">
	<cfparam name="attributes.form_submit" default="0">
	<cfset getComponent = createObject('component','V16.objects2.agenda.cfc.agenda_data')>
	<cfset company_cmp = createObject("component","V16.member.cfc.member_company")> 
	<cfset partner_info = getComponent.GET_PAR()>
	<cfset record_par_mail = partner_info.COMPANY_PARTNER_EMAIL>
	<cfset advisor_mail = (isdefined("attributes.emp_id") and len(attributes.emp_id))? getComponent.GET_EMPLOYEES(emp_id:attributes.emp_id).EMPLOYEE_EMAIL:session_base.email>
	<cfparam name="attributes.hour" default="#timeformat(date_add("h",session.pp.time_zone,now()),'HH')#">
	<cfinclude template="../query/get_event_cats.cfm">
	<cfset action_cmp_id = session.pp.COMPANY_ID>
	<cfset get_cons.recordcount = 0>
	<cfif isdefined("attributes.action_id") and isdefined("attributes.action_section") and attributes.action_section eq "OPPORTUNITY_ID">
		<cfset opportunity = createObject('component','V16.objects2.protein.data.opportunities_data').GET_OPPORTUNITY(opp_id : attributes.action_id)>
		<cfset action_cmp_id = (len(opportunity.company_id))?action_cmp_id&","&opportunity.company_id:action_cmp_id>
		<cfset action_cmp_id = (len(opportunity.ref_company_id))?action_cmp_id&","&opportunity.ref_company_id:action_cmp_id>
		<cfif len(opportunity.consumer_id)>
			<cfset get_cons = company_cmp.get_cons(consumer_id:opportunity.consumer_id)>
		</cfif>		
	</cfif>
	<cfset GET_PARTNER = company_cmp.GET_PARTS_EMPS(cpid: action_cmp_id)>
	<cfquery name="get_emps"  dbtype="query">
		SELECT * FROM GET_PARTNER WHERE TYPE=2
	</cfquery>
	<cfquery name="get_parts"  dbtype="query">
		SELECT * FROM GET_PARTNER WHERE TYPE=1
	</cfquery>
	<cfquery name="GET_REQUEST_STAGE" datasource="#DSN#">
		SELECT
			PTR.STAGE,
			PTR.PROCESS_ROW_ID 
		FROM
			PROCESS_TYPE_ROWS PTR,
			PROCESS_TYPE_OUR_COMPANY PTO,
			PROCESS_TYPE PT
		WHERE
			PT.IS_ACTIVE = 1 AND
			PT.PROCESS_ID = PTR.PROCESS_ID AND
			PT.PROCESS_ID = PTO.PROCESS_ID AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%objects2.form_add_event%">
		ORDER BY 
			PTR.LINE_NUMBER
	</cfquery>
	<style>
		#time_zone{
			display: block;
			width: 100%;
			height: calc(1.5em + 0.75rem + 2px);
			padding: 0.375rem 0.75rem;
			font-size: 1rem;
			font-weight: 400;
			line-height: 1.5;
			color: #495057;
			background-color: #fff;
			background-clip: padding-box;
			border: 1px solid #ced4da;
			border-radius: 0.25rem;
			transition: border-color .15s ease-in-out,box-shadow .15s ease-in-out;
		}
		.checkmark{
			background-color:#ccc;
		}
	</style>
	<cfif not get_request_stage.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no='1616.Ajanda Olay Ekleme Süreci Tanımlı Degil!'>");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<!--- Google Cal --->
	<script async defer src="https://apis.google.com/js/api.js"
		onreadystatechange="if (this.readyState === 'complete') this.onload()">
	</script>
	<!--- //Google Cal --->
	<cfform name="add_event" method="post">
		<cfif isdefined("attributes.action_id") or isdefined("attributes.action_section")>
			<input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.action_id#</cfoutput>"><!--- Bu alan projeden ilişkili olay eklenirken kullanılıyor.	 --->
			<input type="hidden" name="action_section" id="action_section" value="<cfoutput>#attributes.action_section#</cfoutput>">
			<input type="hidden" name="our_company_id" id="our_company_id" value="<cfoutput>#session_base.our_company_id#</cfoutput>">
		</cfif>
		<div class="ui-scroll row">
			<div class="col-lg-12 col-xl-7">
				<div class="form-row mb-3">
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='58054.Süreç - Aşama'></div>
					<div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
						<select id="process_stage" name="process_stage" class="form-control">
							<option value="0" selected><cf_get_lang dictionary_id='57734.Please Select'></option>
							<cfoutput query="get_request_stage">
								<option value="#process_row_id#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq process_row_id)>selected</cfif>>#stage#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-row mb-3">
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='57497.Zaman Dilimi'> *</label></div>
					<div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
						<cf_wrkTimeZone>
					</div>
				</div>
				<div class="form-row mb-3">
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='57486.Kategori'> *</label></div>
					<div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
						<select name="eventcat_id" id="eventcat_id" class="form-control">
							<option value="0" selected><cf_get_lang dictionary_id='57734.Please Select'></option>
							<cfoutput query="get_event_cats">
								<option value="#eventcat_id#">#eventcat#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<cfif isDefined("attributes.date")>
					<div class="form-row mb-3">
						<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'> *</label></div>
						<div class="col-6 col-sm-6 col-md-6 col-lg-6 col-xl-6">
							<cfinput type="date" name="startdate" id="startdate" class="form-control" value="#dateformat(attributes.date,'yyyy-mm-dd')#">
						</div>
						<div class="col-2 col-sm-2 col-md-2 col-lg-2 col-xl-2">
							<input type="time" name="event_start_clock" class="form-control">
						</div>
					</div>
				<cfelse>
					<div class="form-row mb-3">
						<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'> *</label></div>
						<div class="col-6 col-sm-6 col-md-6 col-lg-6 col-xl-6">
							<cfinput type="date" name="startdate" id="startdate" class="form-control" value="#dateformat(now(),'yyyy-mm-dd')#">
						</div>
						<div class="col-2 col-sm-2 col-md-2 col-lg-2 col-xl-2">
							<input type="time" name="event_start_clock" class="form-control">
						</div>
					</div>
				</cfif>
				<cfif isDefined("attributes.date")>
					<div class="form-row mb-3">
						<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label></div>
						<div class="col-6 col-sm-6 col-md-6 col-lg-6 col-xl-6">
							<cfinput type="date" name="finishdate" id="finishdate" class="form-control" value="#dateformat(attributes.date,'yyyy-mm-dd')#">
						</div>
						<div class="col-2 col-sm-2 col-md-2 col-lg-2 col-xl-2">
							<input type="time" name="event_finish_clock" class="form-control">
						</div>
					</div>
				<cfelse>
					<div class="form-row mb-3">
						<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label></div>
						<div class="col-6 col-sm-6 col-md-6 col-lg-6 col-xl-6">
							<cfinput type="date" name="finishdate" id="finishdate" class="form-control" value="#dateformat(now(),'yyyy-mm-dd')#">
						</div>
						<div class="col-2 col-sm-2 col-md-2 col-lg-2 col-xl-2">
							<input type="time" name="event_finish_clock" class="form-control">
						</div>
					</div>
				</cfif>
				<div class="form-row mb-3">
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='57480.Konu'> *</label></div>
					<div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'></cfsavecontent>
						<cfinput type="text" class="form-control" name="event_head" id="event_head" value="" required="Yes" message="#message#!">
					</div>
				</div>
				<div class="form-row mb-3">
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='36199.Açıklama'></label></div>
					<div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
						<textarea name="event_detail" id="event_detail" class="form-control"></textarea>
					</div>
				</div>
				<div class="form-row mb-3" id="item-to">
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cfoutput>#getLang('','',57590)#</cfoutput></label></div>
					<div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
						<cfinput name="to_emp_ids" id="to_emp_ids" value="" type="hidden">
						<cfinput name="to_par_ids" id="to_par_ids" value="" type="hidden">
						<cfinput name="to_cons_ids" id="to_cons_ids" value="" type="hidden">
						<select class="form-control" id="participants" name="participants" multiple="yes">
							<option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
							<optgroup label="<cf_get_lang dictionary_id='58885.Partner'>">
								<cfoutput query="get_parts">
									<option value="#ID_CE#_#TYPE#">#name_surname#</option>
								</cfoutput>
							</optgroup>
  							<optgroup label="<cf_get_lang dictionary_id='57576.Çalışan'>">
							  	<cfoutput query="get_emps">
									<option value="#ID_CE#_#TYPE#">#name_surname#</option>
								</cfoutput>
							</optgroup>
							<cfif get_cons.recordcount>
								<optgroup label="<cf_get_lang dictionary_id='57457.Müşteri'>">
									<cfoutput query="get_cons">
										<option value="#ID_CE#_#TYPE#">#name_surname#</option>
									</cfoutput>
								</optgroup>
							</cfif>  							
						</select>
					</div>
				</div>
				<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.company_id')><cfoutput>#attributes.company_id#</cfoutput><cfelse><cfoutput>#session_base.company_id#</cfoutput></cfif>">
			</div>
	
			<div class="col-lg-12 col-xl-5">
				<div class="form-row mb-3">
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='33149.Uyarı Başlat'></label></div>
					<div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
						<cfif isDefined("attributes.date") and len(attributes.date)>
							<cfinput type="date" name="warning_start" id="warning_start" class="form-control" value="#dateformat(attributes.date,'yyyy-mm-dd')#">
						<cfelse>
							<cfinput type="date" name="warning_start" id="warning_start" class="form-control" value="#dateformat(now(),'yyyy-mm-dd')#">
						</cfif>
					</div>
				</div>
				<div class="form-row mb-3">
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='35012.E-posta Uyarı'>(<cf_get_lang dictionary_id='57490.Gün'> / <cf_get_lang dictionary_id='33151.Saat Önce'>)</label></div>
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4">
						<cfinput type="text" name="email_alert_day" id="email_alert_day" class="form-control" value="0" onKeyUp="isNumber(this);" range="0,90">
					</div>
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4">
						<cfinput type="text" name="email_alert_hour" id="email_alert_hour" class="form-control" value="0" onKeyUp="isNumber(this);" range="0,18">
					</div>
				</div>
				<div class="form-row mb-3">
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='33163.Olay Tekrar'></label></div>
					<div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
						<select name="warning" id="warning" onchange="show_warn(this.selectedIndex);" class="form-control">
							<option value="0" selected><cf_get_lang dictionary_id='58546.Yok'></option>
							<option value="1"><cf_get_lang dictionary_id='33153.Periyodik'></option>
						</select>
					</div>
				</div>
				<div class="form-row mb-3" id="warn_multiple">
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='33154.Tekrar'></label></div>
					<div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
						<input type="radio" name="warning_type" id="warning_type" value="7"> <cf_get_lang dictionary_id='33155.Haftada Bir'>
						<input type="radio" name="warning_type" id="warning_type" value="30"> <cf_get_lang dictionary_id='33156.Ayda Bir'>
					</div>
				</div>
				<div class="form-row mb-3" id="warn_multiple2">
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='33157.Tekrar Sayısı'></label></div>
					<div class="col-6 col-sm-6 col-md-6 col-lg-6 col-xl-6">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='47606.Tekrar Sayısı Tam Sayı Olmalıdır'></cfsavecontent>
						<cfinput type="text" class="form-control" name="warning_count" id="warning_count" value="" onKeyUp="isNumber(this);" maxlength="5" message="#message#!">
					</div>
					<div class="col-2 col-sm-2 col-md-2 col-lg-2 col-xl-2">
						<cf_get_lang dictionary_id='33159.kez'>
					</div>
				</div>
				<div class="form-row mb-3">
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='33164.Bu Olayı Herkes Görsün'></div>
					<div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
						<label class="checkbox-container font-weight-bold">
							<input type="checkbox" name="view_to_all" id="view_to_all" value="1" checked>
							<span class="checkmark"></span>
						</label>    
					</div>
				</div>
				<div class="form-row mb-3" id="item-online">
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='30015.Online'></div>
					<div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
						<label class="checkbox-container font-weight-bold">
							<input type="checkbox" name="online" id="online" value="1" onclick="online_check(1)">
							<span class="checkmark"></span>
						</label>    
					</div>
				</div>
				<div class="form-row mb-3" id="item-online_link">
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cf_get_lang dictionary_id='42371.Link'></label></div>
					<div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
						<cfinput type="text" class="form-control" name="place_online" id="place_online" value="" disabled>
					</div>
				</div>
				<div class="form-row mb-3" id="item-google_cal">
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='64162.Google Takvimde Görünsün'></div>
					<div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
						<label class="checkbox-container font-weight-bold">
							<input type="checkbox" name="google_cal" id="google_cal" value="1" onclick="online_check(2)">
							<span class="checkmark"></span><div id="meet_warning_text"></div>
						</label>    
					</div>
				</div>
				
				<cfinput name="googleEventId" id="googleEventId" value="" type="hidden">
				<cfinput name="meetLink" id="meetLink" value="" type="hidden">
				<cfinput name="event_place" id="event_place" value="Workcube" type="hidden">
				<cfinput name="emp_id" id="emp_id" value="#iif(isdefined('attributes.emp_id'),'attributes.emp_id',DE(''))#" type="hidden">
				<cfinput  name="record_par_mail" id="record_par_mail" value="#record_par_mail#" type="hidden">
				<cfinput  name="advisor_mail" id="advisor_mail" value="#advisor_mail#" type="hidden">
				<div id="event_result" style="display:none"></div>
				<div class="form-row mb-3" id="item-cc">
					<div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><label class="font-weight-bold"><cfoutput>#getLang('','',58773)#</cfoutput></label></div>
					<div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
						<cfinput name="cc_emp_ids" id="cc_emp_ids" value="" type="hidden">
						<cfinput name="cc_par_ids" id="cc_par_ids" value="" type="hidden">
						<cfinput name="cc_cons_ids" id="cc_cons_ids" value="" type="hidden">						
						<select class="form-control" id="cc" name="cc" multiple="yes">
							<option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
							<optgroup label="<cf_get_lang dictionary_id='58885.Partner'>">
								<cfoutput query="get_parts">
									<option value="#ID_CE#_#TYPE#">#name_surname#</option>
								</cfoutput>
							</optgroup>
  							<optgroup label="<cf_get_lang dictionary_id='57576.Çalışan'>">
							  	<cfoutput query="get_emps">
									<option value="#ID_CE#_#TYPE#">#name_surname#</option>
								</cfoutput>
							</optgroup>
  							<cfif get_cons.recordcount>
								<optgroup label="<cf_get_lang dictionary_id='57457.Müşteri'>">
									<cfoutput query="get_cons">
										<option value="#ID_CE#_#TYPE#">#name_surname#</option>
									</cfoutput>
								</optgroup>
							</cfif> 
						</select>
					</div>
				</div>
			</div>
			<!--- <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">		
				
				<cfif isdefined("session.pp")>
					<cfset database_type="MSSQL">
					<cf_workcube_to_cc 
						is_update="1" 
						to_dsp_name="#getLang('','',57590)#"
						form_name="add_event" 
						str_list_param="1,7,8" 
						action_dsn="#DSN#"
						str_action_names="PARTNER_ID AS TO_PAR"
						action_table="COMPANY_PARTNER"
						action_id_name="PARTNER_ID"
						action_id="#session.pp.userid#"
						data_type="1"
						str_alias_names="">
				<cfelse>
					<cf_workcube_to_cc 
                        is_update="0" 
                        to_dsp_name="#getLang('','',57590)#"
                        form_name="add_event" 
                        str_list_param="1,7,8" 
                        data_type="1">
				</cfif>
			</div>
			<div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
				<cfif isdefined("session.pp")>
					<cf_workcube_to_cc 
						is_update="1" 
						cc_dsp_name="#getLang('','',58773)#" 
						form_name="add_event" 
						str_list_param="1,7,8" 
						action_dsn="#DSN#"
						str_action_names="PARTNER_ID AS TO_PAR"
						action_table="COMPANY_PARTNER"
						action_id_name="PARTNER_ID"
						action_id="#session.pp.userid#"
						data_type="1"
						str_alias_names="">
				<cfelse>
					<cf_workcube_to_cc 
						is_update="0"
						cc_dsp_name="#getLang('','',58773)#" 
						form_name="add_event" 
						str_list_param="1,7,8" 
						data_type="1"> 
				</cfif>
			</div> --->
		</div>
		<div class="draggable-footer">
			<cf_workcube_buttons
				add_function='check()'
				data_action = "/V16/objects2/protein/data/event_data:add_event" 
				next_page = "advisorCalendar#iif(isdefined("attributes.emp_id") and len(attributes.emp_id),DE('?emp_id='),DE(''))#">
		</div>
		
	</cfform>
	
	<script type="text/javascript">
		function online_check(val) {
			var online_link = document.getElementById("place_online");
			var online = document.getElementById("online");
			var google_cal = document.getElementById("google_cal");
			if(val == 1){ /* online seçiliyse */
				if (online.checked == true){
					online_link.disabled = false;
				} else {
					online_link.disabled = true;
					google_cal.checked = false;
				}
			}else if (val == 2){ /* google'da görünsün seçiliyse */
				online.checked = true;
	
				if ( online.checked == true && google_cal.checked == true && google_cal.disabled == false ){
					online_link.disabled = true;
					online_link.title = "Otomatik doldurulacak";
					online_link.style.textDecoration = "line-through";
				} else if ( online.checked == true && google_cal.checked == false ) {
					online_link.disabled = false;
					online_link.title = "";
					online_link.style.textDecoration = "";
				}
			}
		}
		function formatDate(date) {
			var d = new Date(date),
				month = '' + (d.getMonth() + 1),
				day = '' + d.getDate(),
				year = d.getFullYear();
	
			if (month.length < 2) 
				month = '0' + month;
			if (day.length < 2) 
				day = '0' + day;
	
			return [day, month, year];
		}
		function check()
		{
			var startDateString = new Date($('#startdate').val());
			var finishDateString = new Date($('#finishdate').val());
			if($('#participants').val().length>0){
				parts = $('#participants').val();
				var to_pars=[];
				var to_emps=[];
				var to_cons=[];
				$.each(parts, function(index, value){
					if(value.includes("_1"))
						to_pars.push(value.split("_")[0]);
					else if(value.includes("_2"))
						to_emps.push(value.split("_")[0]);
					else
						to_cons.push(value.split("_")[0]);
				});
				$('#to_par_ids').val(to_pars);
				$('#to_emp_ids').val(to_emps);
				$('#to_cons_ids').val(to_cons);
			}
			if($('#cc').val().length>0){
				ccs = $('#cc').val();
				var cc_pars=[];
				var cc_emps=[];
				var cc_cons=[];
				$.each(ccs, function(index, value){
					if(value.includes("_1"))
						cc_pars.push(value.split("_")[0]);
					else if(value.includes("_2"))   
						cc_emps.push(value.split("_")[0]);
					else
						cc_cons.push(value.split("_")[0]);
				});
				$('#cc_par_ids').val(cc_pars);
				$('#cc_emp_ids').val(cc_emps);
				$('#cc_cons_ids').val(cc_cons);
			}
			if(startDateString.getTime() > finishDateString.getTime()){
				alert("<cf_get_lang dictionary_id='33715.Olay Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'>");
				return false;
			}
			if (document.getElementById('eventcat_id').value == 0)
			{ 
				alert("<cf_get_lang dictionary_id='33714.Olay Kategorisi Seçiniz'>");
				document.getElementById('eventcat_id').focus();
				return false;
			}
			if (document.getElementById('event_head').value == 0)
			{ 
				alert("<cf_get_lang dictionary_id='63209.Eksik Veri : Konu'>");
				document.getElementById('event_head').focus();
				return false;
			}
			if (document.getElementById('startdate').value == 0)
			{ 
				alert("<cf_get_lang dictionary_id='30623.Lütfen Başlangıç Tarihi Giriniz'>");
				document.getElementById('startdate').focus();
				return false;
			}
			if (document.getElementById('finishdate').value == 0)
			{ 
				alert("<cf_get_lang dictionary_id='36494.Lütfen Bitiş Tarihi Giriniz'>");
				document.getElementById('finishdate').focus();
				return false;
			}
			if (document.getElementById('record_par_mail').value == '')
			{ 
				alert("<cf_get_lang dictionary_id='31877.Sistemde mail adresiniz kayıtlı değil. Mail adresinizi kaydedip tekrar deneyin!'>");
				return false;
			}
			if (document.getElementById('advisor_mail').value == '')
			{ 
				alert("<cf_get_lang dictionary_id='32175.Sistemde danışmanın mail adresi kayıtlı değil. Toplantı talebi oluşturulamıyor!'>");
				$('#google_cal').prop('checked',false);
				return true;
			}
	
	
			if ($('#google_cal').prop('checked')){
				$( "form#add_event" ).submit(function( event ) {
					event.preventDefault(); // don't submit this
					var startDateString = $('#startdate').val();
					var startClockNew = document.add_event.event_start_clock.value.split(":")[0] ? document.add_event.event_start_clock.value.split(":")[0] : "00";
					var startMinuteNew = document.add_event.event_start_clock.value.split(":")[1] ? document.add_event.event_start_clock.value.split(":")[1] : "00";
	
					var finishDateString = $('#finishdate').val();
					var finishClockNew = document.add_event.event_finish_clock.value.split(":")[0] ? document.add_event.event_finish_clock.value.split(":")[0] : "00";
					var finishMinuteNew = document.add_event.event_finish_clock.value.split(":")[1] ? document.add_event.event_finish_clock.value.split(":")[1] : "00";
	
					var eventStartTime = startDateString + "T" + startClockNew + ":" + startMinuteNew + ":00.000";
					var eventFinishTime = finishDateString + "T" + finishClockNew + ":" + finishMinuteNew + ":00.000";
	
					<cfoutput>
						var #toScript(record_par_mail, "record_par_mail")#;
						var #toScript(advisor_mail, "advisor_mail")#;
					</cfoutput>
					
					signInGoogle(eventStartTime, eventFinishTime, record_par_mail, advisor_mail);
					return false;
				});
			}
			/* else{
				var formData = new FormData(document.getElementById('add_event'));
				var formDataJSON = JSON.stringify(Object.fromEntries(formData));
	
				var data = new FormData();
				data.append('cfc', '/V16/objects2/protein/data/event_data');
				data.append('method', 'add_event');
				data.append('form_data', formDataJSON);
				
	
				AjaxControlPostDataJson('/datagate', data, function (response) {
					if(response.STATUS){
						toastr
							.success(
								response.SUCCESS_MESSAGE,
								'',
								{ timeOut: 5000, progressBar: true, closeButton: true }
							);
					}else{
						toastr
							.error(
								response.DANGER_MESSAGE,
								'',
								{ timeOut: 5000, progressBar: true, closeButton: true }
							);
					}
					window.location.reload();
				});
			} */
		}
	
		function show_warn(i)
		{
			/* uyarı var*/
			if(i == 0)
			{
				/*tek uyarı açık*/
				warn_multiple.style.display = 'none';
				warn_multiple2.style.display = 'none';
			}
			if(i == 1)
			{
				/*çoklu uyarı açık*/
				warn_multiple.style.display = '';
				warn_multiple2.style.display = '';
			}
		}
		show_warn(0);
	
		var googleCalEventsListed = 0; // listelenen olaylar yinelenmesin diye eklendi
		var CLIENT_ID = '';
		var CLIENT_SECRET = '';
		var API_KEY = '';
		var DISCOVERY_DOCS = [];
		var SCOPES = "";
		var type = "add"; // add, upd ve list seçenkelerinden uygun olan, burada tanımlanmalıdır.
		var googleSignInMessage = "<cf_get_lang dictionary_id='64111.Google Hesabınızla Giriş Yapmalısınız!'>";
	
		function signInGoogle(eventStartTime = '', eventFinishTime = '', record_par_mail = '', advisor_mail = ''){
			loadScript("/src/assets/js/google_calendar_init.js")
			.then( data  => {
				/* console.log("Script loaded successfully", data); */
				<cfquery name = "get_api_key" datasource="#dsn#">
					SELECT GOOGLE_API_KEY,GOOGLE_LANGUAGE, GOOGLE_CLIENT_SECRET, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.OUR_COMPANY_ID#">
				</cfquery>
				if(<cfoutput>#len(get_api_key.GOOGLE_API_KEY)#</cfoutput> && <cfoutput>#len(get_api_key.GOOGLE_CLIENT_ID)#</cfoutput> && <cfoutput>#len(get_api_key.GOOGLE_CLIENT_SECRET)#</cfoutput>){
					CLIENT_ID = '<cfoutput>#get_api_key.GOOGLE_CLIENT_ID#</cfoutput>';
					CLIENT_SECRET = '<cfoutput>#get_api_key.GOOGLE_CLIENT_SECRET#</cfoutput>';
					API_KEY = '<cfoutput>#get_api_key.GOOGLE_API_KEY#</cfoutput>';
	
					// Array of API discovery doc URLs for APIs used by the quickstart
					DISCOVERY_DOCS = ["https://www.googleapis.com/discovery/v1/apis/calendar/v3/rest"];
					// Authorization scopes required by the API; multiple scopes can be
					// included, separated by spaces.
					SCOPES = "https://www.googleapis.com/auth/calendar.readonly https://www.googleapis.com/auth/calendar";
					handleClientLoad(eventStartTime, eventFinishTime, record_par_mail, advisor_mail);
				}else{
					alert("<cf_get_lang dictionary_id='61524.API Key'>, <cf_get_lang dictionary_id='64109.CLIENT_ID'>, <cf_get_lang dictionary_id='64110.CLIENT_SECRET'> bilgilerinin girilmesi gerekiyor.");
					return false;
				}
			})
			.catch( err => {
				console.error(err);
			});
		}
		
		const loadScript = (FILE_URL, async = true, type = "text/javascript") => {
			return new Promise((resolve, reject) => {
				try {
					const scriptEle = document.createElement("script");
					scriptEle.type = type;
					scriptEle.async = async;
					scriptEle.src =FILE_URL;
	
					scriptEle.addEventListener("load", (ev) => {
						resolve({ status: true });
					});
	
					scriptEle.addEventListener("error", (ev) => {
						reject({
							status: false,
							message: `Failed to load the script ${FILE_URL}`
						});
					});
	
					document.body.appendChild(scriptEle);
				} catch (error) {
					reject(error);
				}
			});
		};
	</script>
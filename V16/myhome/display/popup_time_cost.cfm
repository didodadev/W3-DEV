<cfquery name="get_time_cost" datasource="#dsn#">
	SELECT * FROM TIME_COST WHERE TIME_COST_ID = #time_cost_id#
</cfquery>
<cfquery name="get_activity" datasource="#dsn#">
	SELECT * FROM SETUP_ACTIVITY WHERE ACTIVITY_STATUS = 1
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='30807.Zaman Harcaması Güncelle'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box title="#message#">
	<cfform action="#request.self#?fuseaction=myhome.emptypopup_upd_time_cost&time_cost_id=#time_cost_id#" name="time_cost" method="post">
		<input type="hidden" name="is_popup" id="is_popup" value="1">
		<cf_box_elements>
		
				<div class="col col-5 col-md-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-employee_id">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
						<div class="col col-9 col-xs-12">
							<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_time_cost.employee_id#</cfoutput>">
							<input type="text" readonly name="emloyee" id="emloyee" value="<cfoutput>#get_emp_info(get_time_cost.EMPLOYEE_ID,0,0)#</cfoutput>"  style="width:150px;">
						</div>
					</div>
					<div class="form-group" id="item-comment">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-9 col-xs-12">
							<textarea name="comment" id="comment" style="width:150px;height:80px;"><cfoutput>#get_time_cost.comment#</cfoutput></textarea>
						</div>
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
						<div class="col col-9 col-xs-12">
							<cf_workcube_process is_upd='0' select_value='#get_time_cost.TIME_COST_STAGE#' process_cat_width='160' is_detail='0'>
						</div>
					</div>
					<div class="form-group" id="item-project_head">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
						<div class="col col-9 col-xs-12">
							<div class="input-group">
								<cfif len(get_time_cost.PROJECT_ID)>
									<cfquery name="get_project_name" datasource="#dsn#">
										SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID=#get_time_cost.PROJECT_ID#
									</cfquery>
								</cfif>
								<input type="hidden" name="project_id" id="project_id" value="<cfif len(get_time_cost.PROJECT_ID)><cfoutput>#get_time_cost.PROJECT_ID#</cfoutput></cfif>">
								<input type="text" name="project_head" id="project_head" style="width:150;" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','time_cost','3','250');" autocomplete="off" value="<cfif len(get_time_cost.PROJECT_ID)><cfoutput>#get_project_name.PROJECT_HEAD#</cfoutput></cfif>">
								<span class="input-group-addon icon-ellipsis btnPointer"  href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=time_cost.project_head&project_id=time_cost.project_id</cfoutput>');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-event_head">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='31065.Toplantı'></label>
						<div class="col col-9 col-xs-12">
							<div class="input-group">
								<cfif len(get_time_cost.EVENT_ID)>
									<cfquery name="GET_EVENT" datasource="#DSN#">
										SELECT EVENT_HEAD FROM EVENT WHERE EVENT_ID = #get_time_cost.EVENT_ID#
									</cfquery>
								</cfif>
								<input type="hidden" name="event_id" id="event_id" value="<cfif len(get_time_cost.EVENT_ID)><cfoutput>#get_time_cost.EVENT_ID#</cfoutput></cfif>">
								<input type="text" readonly name="event_head" id="event_head" value="<cfif len(get_time_cost.EVENT_ID)><cfoutput>#GET_EVENT.EVENT_HEAD#</cfoutput></cfif>"  style="width:150px;">
								<span class="input-group-addon icon-ellipsis btnPointer"  href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_add_event&field_id=time_cost.event_id&field_name=time_cost.event_head</cfoutput>','list')"></span> 
							</div>
						</div>
					</div>
					<div class="form-group" id="item-member_name">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
						<div class="col col-9 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_time_cost.consumer_id#</cfoutput>">
								<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_time_cost.partner_id#</cfoutput>">
								<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_time_cost.company_id#</cfoutput>">
								<cfif len(get_time_cost.company_id)>
									<input type="text" name="member_name" id="member_name" style="width:150px;" value="<cfoutput>#get_par_info(get_time_cost.company_id,1,1,0)#</cfoutput>" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,CONSUMER_ID,PARTNER_ID','company_id,consumer_id,partner_id','','3','250');" autocomplete="off">
								<cfelseif len(get_time_cost.consumer_id)>
									<input type="text" name="member_name" id="member_name" value="<cfoutput>#get_cons_info(get_time_cost.consumer_id,0,0)#</cfoutput>" style="width:150px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,CONSUMER_ID,PARTNER_ID','company_id,consumer_id,partner_id','','3','250');" autocomplete="off">
								<cfelse>
									<input type="text" name="member_name" id="member_name" value="" style="width:150px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,CONSUMER_ID,PARTNER_ID','company_id,consumer_id,partner_id','','3','250');" autocomplete="off">
								</cfif>
								<span class="input-group-addon icon-ellipsis btnPointer"  href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_consumer=time_cost.consumer_id&field_comp_id=time_cost.company_id&field_member_name=time_cost.member_name&field_partner=time_cost.partner_id&select_list=7,8</cfoutput>','list')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-subscription_no">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58832.Abone'></label>
						<div class="col col-9 col-xs-12">
							<div class="input-group">
								<cfif len(get_time_cost.subscription_id)>
									<cfquery name="get_subscription_name" datasource="#DSN3#">
										SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID=#get_time_cost.SUBSCRIPTION_ID#
									</cfquery>
									<input type="hidden" name="subscription_id" id="subscription_id" value="<cfoutput>#get_time_cost.subscription_id#</cfoutput>">
									<input type="text" name="subscription_no" id="subscription_no" value="<cfoutput>#get_subscription_name.subscription_no#</cfoutput>" style="width:150px;" onFocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','200');" autocomplete="off">
								<cfelse>
									<input type="hidden" name="subscription_id" id="subscription_id" value="">
									<input type="text" name="subscription_no" id="subscription_no" value="" style="width:150px;" onFocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','200');" autocomplete="off">
								</cfif>
								<span class="input-group-addon icon-ellipsis btnPointer"  href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_subscription&field_id=time_cost.subscription_id&field_no=time_cost.subscription_no'</cfoutput>,'list','popup_list_subscription');"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-7 col-md-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-today">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57490.Gün'></label>
						<div class="col col-4 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='30890.Gün Girmelisiniz !'></cfsavecontent>
								<cfinput type="text" REQUIRED="Yes" message="#message#" name="today" value="#DateFormat(get_time_cost.event_date,dateformat_style)#" style="width:68px;" validate="#validate_style#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="today"></span>
							</div>
						</div>
						<div class="col col-4 col-xs-12">
							<select name="overtime_type" id="overtime_type" style="width:70px;">
								<option value="1" <cfif len(get_time_cost.OVERTIME_TYPE) and get_time_cost.OVERTIME_TYPE EQ 1>selected</cfif>><cf_get_lang dictionary_id='32287.Normal'></option>
								<option value="2" <cfif len(get_time_cost.OVERTIME_TYPE) and get_time_cost.OVERTIME_TYPE EQ 2>selected</cfif>><cf_get_lang dictionary_id='31547.Fazla Mesai'></option>
								<option value="3" <cfif len(get_time_cost.OVERTIME_TYPE) and get_time_cost.OVERTIME_TYPE EQ 3>selected</cfif>><cf_get_lang dictionary_id='31472.Hafta Sonu'></option>
								<option value="4" <cfif len(get_time_cost.OVERTIME_TYPE) and get_time_cost.OVERTIME_TYPE EQ 4>selected</cfif>><cf_get_lang dictionary_id='31473.Resmi Tatil'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-total_time_hour">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29513.Süre'></label>
						<div class="col col-4 col-xs-12"><cfset dakika_oran = "">
							<input type="text" name="total_time_hour" placeholder="<cf_get_lang dictionary_id='57491.Saat'>" id="total_time_hour" maxlength="3" style="width:30px;" value="<cfoutput><cfif not len(get_time_cost.start) and not len(get_time_cost.finish) and not len(get_time_cost.FINISH_MIN) and not len(get_time_cost.START_MIN)><cfif Find('.',wrk_round(get_time_cost.TOTAL_TIME)) gt 0>#left(wrk_round(get_time_cost.TOTAL_TIME),Find('.',wrk_round(get_time_cost.TOTAL_TIME))-1)# <cfset dakika_oran = "0." & "#right(wrk_round(get_time_cost.TOTAL_TIME),len(wrk_round(get_time_cost.TOTAL_TIME)) - Find('.',wrk_round(get_time_cost.TOTAL_TIME)))#"><cfelse>#wrk_round(get_time_cost.TOTAL_TIME)#</cfif></cfif></cfoutput>" style="width:60;">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31894.0 59 Arası Giriniz'></cfsavecontent>
						</div>
						<div class="col col-4 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31894.0 59 Arası Giriniz'></cfsavecontent>
							<cfsavecontent variable="place"><cf_get_lang dictionary_id='58827.Dk'></cfsavecontent>
							<cfif len(dakika_oran) and dakika_oran gt 0>									
								<cfinput type="text" name="total_time_minute" placeholder="#place#" value="#wrk_round(dakika_oran * 60,0)#" maxlength="2" style="width:25px;" range="0,59" message="#message#">
							<cfelse>
								<cfinput type="text" name="total_time_minute" placeholder="#place#" value="" range="0,59" maxlength="2" style="width:25px;" message="#message#">
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-event_start_clock">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='30961.Başlangıç Saati'></label>
						<div class="col col-4 col-xs-12">
							<select name="event_start_clock" id="event_start_clock" style="width:40px;">
								<option value="" selected><cf_get_lang dictionary_id='57491.Saat'></option>
								<cfloop from="0" to="23" index="i">
									<cfset saat=i mod 24>
									<option value="<cfoutput>#saat#</cfoutput>" <cfif get_time_cost.start eq i>selected</cfif>><cfoutput>#NumberFormat(saat,'00')#</cfoutput></option>
								</cfloop>
							</select>
						</div>
						<div class="col col-4 col-xs-12">
							<select name="event_start_minute" id="event_start_minute" style="width:45px;">
								<option value="" selected><cf_get_lang dictionary_id='58827.Dk'></option>
								<option value="00" <cfif get_time_cost.START_MIN EQ 00>selected</cfif>>00</option>
								<option value="05" <cfif get_time_cost.START_MIN EQ 05>selected</cfif>>05</option>
								<option value="10" <cfif get_time_cost.START_MIN EQ 10>selected</cfif>>10</option>
								<option value="15" <cfif get_time_cost.START_MIN EQ 15>selected</cfif>>15</option>
								<option value="20" <cfif get_time_cost.START_MIN EQ 20>selected</cfif>>20</option>
								<option value="25" <cfif get_time_cost.START_MIN EQ 25>selected</cfif>>25</option>
								<option value="30" <cfif get_time_cost.START_MIN EQ 30>selected</cfif>>30</option>
								<option value="35" <cfif get_time_cost.START_MIN EQ 35>selected</cfif>>35</option>
								<option value="40" <cfif get_time_cost.START_MIN EQ 40>selected</cfif>>40</option>
								<option value="45" <cfif get_time_cost.START_MIN EQ 45>selected</cfif>>45</option>
								<option value="50" <cfif get_time_cost.START_MIN EQ 50>selected</cfif>>50</option>
								<option value="55" <cfif get_time_cost.START_MIN EQ 55>selected</cfif>>55</option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-event_finish_clock">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='30959.Bitiş Saati'></label>
						<div class="col col-4 col-xs-12">
							<select name="event_finish_clock" id="event_finish_clock" style="width:40px;">
								<option value="" selected><cf_get_lang dictionary_id='57491.Saat'></option>
								<cfloop FROM="0" TO="23" INDEX="i">
									<cfset saat=i mod 24>
									<option value="<cfoutput>#saat#</cfoutput>" <cfif get_time_cost.finish eq i>selected</cfif>><cfoutput>#NumberFormat(saat,'00')#</cfoutput></option>
								</cfloop>
							</select>
						</div>
						<div class="col col-4 col-xs-12">
							<select name="event_finish_minute" id="event_finish_minute" style="width:45px;">
								<option value="" selected><cf_get_lang dictionary_id='58827.Dk'></option>
								<option value="00" <cfif get_time_cost.FINISH_MIN EQ 00>selected</cfif>>00</option>
								<option value="05" <cfif get_time_cost.FINISH_MIN EQ 05>selected</cfif>>05</option>
								<option value="10" <cfif get_time_cost.FINISH_MIN EQ 10>selected</cfif>>10</option>
								<option value="15" <cfif get_time_cost.FINISH_MIN EQ 15>selected</cfif>>15</option>
								<option value="20" <cfif get_time_cost.FINISH_MIN EQ 20>selected</cfif>>20</option>
								<option value="25" <cfif get_time_cost.FINISH_MIN EQ 25>selected</cfif>>25</option>
								<option value="30" <cfif get_time_cost.FINISH_MIN EQ 30>selected</cfif>>30</option>
								<option value="35" <cfif get_time_cost.FINISH_MIN EQ 35>selected</cfif>>35</option>
								<option value="40" <cfif get_time_cost.FINISH_MIN EQ 40>selected</cfif>>40</option>
								<option value="45" <cfif get_time_cost.FINISH_MIN EQ 45>selected</cfif>>45</option>
								<option value="50" <cfif get_time_cost.FINISH_MIN EQ 50>selected</cfif>>50</option>
								<option value="55" <cfif get_time_cost.FINISH_MIN EQ 55>selected</cfif>>55</option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-activity">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='32374.Aktiviteler'></label>
						<div class="col col-8 col-xs-12">
							<select name="activity" id="activity" style="width:150px;">
								<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'>
								<cfoutput query="get_activity">
									<option value="#activity_id#" <cfif len(get_time_cost.activity_id) and get_time_cost.activity_id eq activity_id>selected</cfif>>#activity_name#</option>
								</cfoutput> 
							</select>
						</div>
					</div>
					<div class="form-group" id="item-expense">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58235.Masraf Merkezi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif len(get_time_cost.expense_id)>
									<cfquery name="GET_EXPENSE" datasource="#DSN2#">
										SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = #get_time_cost.expense_id#
									</cfquery> 
								</cfif>
								<input type="hidden" name="expense_id" id="expense_id" value="<cfif len(get_time_cost.expense_id)><cfoutput>#get_time_cost.expense_id#</cfoutput></cfif>">
								<input type="text" name="expense" id="expense" onfocus="AutoComplete_Create('expense','EXPENSE','EXPENSE','get_expense_center','0','EXPENSE_ID','expense_id','time_cost','3','250');" value="<cfif len(get_time_cost.expense_id)><cfoutput>#GET_EXPENSE.EXPENSE#</cfoutput></cfif>" style="width:150px;"  autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_id=time_cost.expense_id&field_name=time_cost.expense</cfoutput>','list')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-work_head">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58445.İş'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif len(get_time_cost.work_id)>
									<cfquery name="GET_WORK" datasource="#DSN#">
										SELECT WORK_HEAD,COMPANY_ID,WORK_ID FROM PRO_WORKS WHERE WORK_ID = #get_time_cost.WORK_ID#
									</cfquery>
								</cfif>
								<input type="hidden" name="work_id" id="work_id" value="<cfif len(get_time_cost.WORK_ID)><cfoutput>#GET_WORK.WORK_ID#</cfoutput></cfif>">
								<input type="hidden" name="comp_id" id="comp_id" value="<cfif len(get_time_cost.WORK_ID)><cfoutput>#GET_WORK.COMPANY_ID#</cfoutput></cfif>">
								<input type="text" readonly name="work_head" id="work_head" value="<cfif len(get_time_cost.WORK_ID)><cfoutput>#GET_WORK.WORK_HEAD#</cfoutput></cfif>" style="width:150px;">
								<span class="input-group-addon icon-ellipsis btnPointer"  href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_add_work&field_id=time_cost.work_id&field_name=time_cost.work_head&comp_id=time_cost.comp_id</cfoutput>','list')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-service_head">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57656.Servis'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif len(get_time_cost.SERVICE_ID)>
									<cfquery name="GET_SERVICE" datasource="#DSN3#">
										SELECT SERVICE_ID,SERVICE_HEAD FROM SERVICE WHERE SERVICE_ID = #get_time_cost.SERVICE_ID#
									</cfquery> 
								</cfif>
								<input type="hidden" name="service_id" id="service_id" value="<cfif len(get_time_cost.SERVICE_ID)><cfoutput>#GET_SERVICE.SERVICE_ID#</cfoutput></cfif>">
								<input type="text" readonly name="service_head" id="service_head" value="<cfif len(get_time_cost.SERVICE_ID)><cfoutput>#GET_SERVICE.SERVICE_HEAD#</cfoutput></cfif>" style="width:150px;">
								<span class="input-group-addon icon-ellipsis btnPointer"  href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_add_crm&field_id=time_cost.service_id&field_name=time_cost.service_head</cfoutput>','list')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-class_name">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57419.Eğitim'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif len(get_time_cost.CLASS_ID)>
									<cfquery name="get_class" datasource="#dsn#">
										SELECT CLASS_ID, CLASS_NAME FROM TRAINING_CLASS WHERE CLASS_ID = #get_time_cost.CLASS_ID#
									</cfquery>
								</cfif>
								<input type="hidden" name="class_id" id="class_id" value="<cfif len(get_time_cost.CLASS_ID)><cfoutput>#get_class.CLASS_ID#</cfoutput></cfif>">
								<input type="text" name="class_name" id="class_name" value="<cfif len(get_time_cost.CLASS_ID)><cfoutput>#get_class.CLASS_NAME#</cfoutput></cfif>" style="width:150px;">
								<span class="input-group-addon icon-ellipsis btnPointer"  href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_list_training_classes&field_id=time_cost.class_id&field_name=time_cost.class_name</cfoutput>','list');"></span>
							</div>
						</div>
					</div>
				</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name="get_time_cost">
			<cf_workcube_buttons is_upd='1' add_function='saat_kontrol()' delete_page_url='#request.self#?fuseaction=myhome.del_time_cost&time_cost_id=#time_cost_id#&is_popup=1&head=#get_emp_info(get_time_cost.EMPLOYEE_ID,0,0)#' delete_alert='Zaman Harcaması Siliyorsunuz ! Emin misiniz?'>
		</cf_box_footer>
		
	</cfform>
</cf_box>

<script type="text/javascript">
	function saat_kontrol()
	{ 
		start_clock = document.time_cost.event_start_clock[document.time_cost.event_start_clock.selectedIndex].value;
		finish_clock = document.time_cost.event_finish_clock[document.time_cost.event_finish_clock.selectedIndex].value;
		start_minute=document.time_cost.event_start_minute.value;
		finish_minute=document.time_cost.event_finish_minute.value;
		if(start_clock != '' || finish_clock != '' || start_minute != '' || finish_minute != '')
		{
			if(start_clock.value > finish_clock.value)
				{
					alert("<cf_get_lang dictionary_id='31409.Başlangıç Saati Bitiş Saatinden Büyük Olamaz'>!");
					return false;
				}
			else if((start_clock == finish_clock) && (start_minute == finish_minute))
				{	
					alert("<cf_get_lang dictionary_id='31636.Başlangıç Ve Bitiş Saati Aynı Olamaz'>!");
					return false;
				}	
			else if((start_clock == finish_clock) && (start_minute > finish_minute))
				{
					alert("<cf_get_lang dictionary_id='31409.Başlangıç Saati Bitiş Saatinden Büyük Olamaz'>!");
					return false;
				}
		}
		if(time_cost.comment.value.length > 300)
		{
			alert("<cf_get_lang dictionary_id ='37038.Açıklama Alanına En Fazla 300 Karakter Girilebilir'>!");
			return false;
		}	
		if(time_cost.process_stage.value =='')
		{
			alert("<cf_get_lang dictionary_id ='41036.Lütfen Süreçlerinizi Tanımlayınız veveya Tanımlanan Süreçler Üzerinde Yetkiniz Yok'>!");
			return false;
		}	
		
		x = (300 - document.time_cost.comment.value.length);
		
	}
</script>


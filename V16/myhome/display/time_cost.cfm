<cf_xml_page_edit fuseact="myhome.emptypopup_form_add_timecost">
<cfquery name="get_time_cost_cats" datasource="#dsn#">
	SELECT TIME_COST_CAT,TIME_COST_CAT_ID FROM TIME_COST_CAT ORDER BY TIME_COST_CAT
</cfquery>
<cfif isdefined("attributes.is_service")>
	<cfquery name="get_service_detail" datasource="#dsn3#">
		SELECT 
			SUBSCRIPTION_ID, 
			PROJECT_ID, 
			SERVICE_COMPANY_ID, 
			SERVICE_PARTNER_ID, 
			SERVICE_CONSUMER_ID, 
			SERVICE_HEAD, 
			START_DATE,
			FINISH_DATE
		FROM 
			SERVICE 
		WHERE 
			SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
	</cfquery>
	<cfif len(get_service_detail.start_date)>
		<cfset adate = dateadd('H',session.ep.time_zone,get_service_detail.start_date)>
		<cfset ahour = datepart("H",adate)>
		<cfset aminute = datepart("N",adate)>
	</cfif>
	<cfif len(get_service_detail.finish_date)>
		<cfset fdate = dateadd('H',session.ep.time_zone,get_service_detail.finish_date)>
		<cfset fhour = datepart("H",fdate)>
		<cfset fminute =  datepart("N",fdate)>
	</cfif>
	<cfset attributes.service_head = get_service_detail.service_head>
	<cfset attributes.project_id = get_service_detail.project_id>
	<cfset attributes.subscription_id = get_service_detail.subscription_id>
	<cfset attributes.service_company_id = get_service_detail.service_company_id>
	<cfset attributes.service_partner_id = get_service_detail.service_partner_id>
	<cfset attributes.service_consumer_id = get_service_detail.service_consumer_id>
	<cfquery name="get_related_work" datasource="#dsn#">
		SELECT TOP 1 WORK_ID, WORK_HEAD FROM PRO_WORKS WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#"> ORDER BY WORK_HEAD
	</cfquery>
	<cfset attributes.work_id = get_related_work.work_id>
	<cfset attributes.work_head = get_related_work.work_head>
</cfif>
<cfif isdefined("attributes.is_call_service")>
	<cfquery name="get_service_detail" datasource="#dsn#">
		SELECT 
			SUBSCRIPTION_ID, 
            SERVICE_HEAD,
			PROJECT_ID, 
			SERVICE_COMPANY_ID, 
			SERVICE_PARTNER_ID, 
			SERVICE_CONSUMER_ID,  
			START_DATE,
			FINISH_DATE
		FROM 
			G_SERVICE 
		WHERE 
			SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
	</cfquery>
	<cfif len(get_service_detail.start_date)>
		<cfset adate = dateadd('H',session.ep.time_zone,get_service_detail.start_date)>
		<cfset ahour = datepart("H",adate)>
		<cfset aminute = datepart("N",adate)>
	</cfif>
	<cfif len(get_service_detail.finish_date)>
		<cfset fdate = dateadd('H',session.ep.time_zone,get_service_detail.finish_date)>
		<cfset fhour = datepart("H",fdate)>
		<cfset fminute =  datepart("N",fdate)>
	</cfif>
    <cfset attributes.service_head = get_service_detail.service_head>
	<cfset attributes.project_id = get_service_detail.project_id>
	<cfset attributes.subscription_id = get_service_detail.subscription_id>
	<cfset attributes.service_company_id = get_service_detail.service_company_id>
	<cfset attributes.service_partner_id = get_service_detail.service_partner_id>
	<cfset attributes.service_consumer_id = get_service_detail.service_consumer_id>
</cfif>
<cfif isdefined("attributes.is_cus_help")>
	<cfquery name="get_cus_help_detail" datasource="#dsn#">
		SELECT SUBSCRIPTION_ID,COMPANY_ID,PARTNER_ID,CONSUMER_ID,CUS_HELP_ID FROM CUSTOMER_HELP WHERE CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#">
	</cfquery>
	<cfif len(get_cus_help_detail.SUBSCRIPTION_ID)><!--- etkilesimin iliskili oldugu sistem projesini getirir --->
		<cfquery name="get_project_id" datasource="#dsn3#">
			SELECT PROJECT_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cus_help_detail.subscription_id#">
		</cfquery>
		<cfset attributes.project_id = get_project_id.project_id>
	</cfif>
	<cfset attributes.service_company_id = get_cus_help_detail.company_id>
	<cfset attributes.service_partner_id = get_cus_help_detail.partner_id>
	<cfset attributes.service_consumer_id = get_cus_help_detail.consumer_id>
	<cfset attributes.cus_help_id = get_cus_help_detail.cus_help_id>
</cfif>
<!--- Uretim sonucu sayfasindan geliyorsa --->
<cfif isdefined('attributes.p_order_result_id')>
	<cfquery name="get_p_order_result_id" datasource="#dsn3#">
		SELECT 
			POR.FINISH_DATE,
			POR.START_DATE,
			POR.RESULT_NO,
			POR.PRODUCTION_ORDER_NO,
			POR.PR_ORDER_ID,
			PO.PROJECT_ID 
		FROM 
			PRODUCTION_ORDER_RESULTS POR,
			PRODUCTION_ORDERS PO
		WHERE 
			PO.P_ORDER_ID = POR.P_ORDER_ID AND
			POR.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_result_id#">
	</cfquery>
	<cfif len(get_p_order_result_id.start_date)>
		<!--- <cfset adate = dateadd('H',session.ep.time_zone,get_p_order_result_id.start_date)> --->
		<cfset ahour = datepart("H",get_p_order_result_id.start_date)>
		<cfset aminute = datepart("N",get_p_order_result_id.start_date)>
	</cfif>
	<cfif len(get_p_order_result_id.finish_date)>
		<!--- <cfset fdate = dateadd('H',session.ep.time_zone,get_p_order_result_id.finish_date)> --->
		<cfset fhour = datepart("H",get_p_order_result_id.finish_date)>
		<cfset fminute =  datepart("N",get_p_order_result_id.finish_date)>
	</cfif>
	<cfset today_ = get_p_order_result_id.finish_date>
	<cfset attributes.project_id = get_p_order_result_id.project_id>
	<cfset attributes.finish_date = get_p_order_result_id.finish_date><!--- tarih ---> 
	<cfset attributes.comment = get_p_order_result_id.result_no><!--- aciklama --->
	<cfset attributes.production_order_no = get_p_order_result_id.production_order_no><!--- uretim sonucu --->
	<cfset attributes.p_order_id = get_p_order_result_id.pr_order_id><!--- uretim sonucu --->
<cfelse>
	<cfset today_ = now()>
</cfif>
<cfif not isdefined('attributes.today')>
	<cfset attributes.today = today_>
<cfelse>
	<cf_date tarih = "attributes.today">
</cfif>
 <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Zaman Harcamaları','57561')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="time_cost" action="#request.self#?fuseaction=myhome.add_time_cost" method="post">
            <input type="hidden" name="is_p_order_result" id="is_p_order_result" value="<cfif isdefined("attributes.is_p_order_result")>1<cfelse>0</cfif>"><!--- uretim sonucu --->
            <input type="hidden" name="is_service" id="is_service" value="<cfif isdefined("attributes.is_service")>1<cfelse>0</cfif>">
            <input type="hidden" name="is_subscription" id="is_subscription" value="<cfif isdefined("attributes.is_subscription")>1<cfelse>0</cfif>">
            <input type="hidden" name="is_bug" id="is_bug" value="<cfif isdefined("attributes.is_bug")>1<cfelse>0</cfif>">
            <input type="hidden" name="is_cus_help" id="is_cus_help" value="<cfif isdefined("attributes.is_cus_help")>1<cfelse>0</cfif>">
            <input type="hidden" name="is_call_service" id="is_call_service" value="<cfif isdefined("attributes.is_call_service")>1<cfelse>0</cfif>" />
            <input type="hidden" name="cus_help_id" id="cus_help_id" value="<cfif isdefined("attributes.cus_help_id")><cfoutput>#attributes.cus_help_id#</cfoutput></cfif>"><!--- etkilesim --->
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-employee">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="employee_id" id="employee_id" value="#session.ep.userid#">
                                    <input type="text" name="employee" id="employee" readonly value="#get_emp_info(session.ep.userid,0,0)#">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=time_cost.employee_id&field_name=time_cost.employee&select_list=1');"></span>
                                </cfoutput>                 
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-member_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined('attributes.service_consumer_id') and len(attributes.service_consumer_id)><cfoutput>#attributes.service_consumer_id#</cfoutput></cfif>">
                                <input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined('attributes.service_partner_id') and len(attributes.service_partner_id)><cfoutput>#attributes.service_partner_id#</cfoutput></cfif>">
                                <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.service_company_id') and len(attributes.service_company_id)><cfoutput>#attributes.service_company_id#</cfoutput></cfif>">
                                <input type="text" name="member_name" id="member_name" value="<cfif isdefined('attributes.service_consumer_id') and len(attributes.service_consumer_id)><cfoutput>#get_cons_info(attributes.service_consumer_id,2,0)#</cfoutput><cfelseif isdefined('attributes.service_partner_id') and len(attributes.service_partner_id)><cfoutput>#get_par_info(attributes.service_partner_id,0,1,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','CONSUMER_ID,COMPANY_ID,PARTNER_ID','consumer_id,company_id,partner_id','','3','250');" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_consumer=time_cost.consumer_id&field_comp_id=time_cost.company_id&field_member_name=time_cost.member_name&field_partner=time_cost.partner_id&select_list=7,8</cfoutput>')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-subscription_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58832.Abone'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("attributes.is_subscription") or (isdefined("attributes.is_service") and isdefined("attributes.subscription_id") and len(attributes.subscription_id)) or (isdefined("attributes.is_cus_help") and isdefined('attributes.subscription_id') and len(attributes.subscription_id)) or (isdefined("attributes.is_call_service") and isdefined('attributes.subscription_id') and len(attributes.subscription_id))>
                                    <cfquery name="get_sub" datasource="#dsn3#">
                                        SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #attributes.subscription_id#
                                    </cfquery>
                                    <input type="hidden" name="subscription_id" id="subscription_id" value="<cfoutput>#attributes.subscription_id#</cfoutput>">
                                    <input type="text" name="subscription_no" id="subscription_no" value="<cfoutput>#get_sub.subscription_no#</cfoutput>" onfocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','200');" autocomplete="off">
                                <cfelse>
                                    <input type="hidden" name="subscription_id" id="subscription_id" value="">
                                    <input type="text" name="subscription_no" id="subscription_no" value="" onfocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','200');" autocomplete="off">
                                </cfif>
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_subscription&field_id=time_cost.subscription_id&field_no=time_cost.subscription_no&field_company_id=time_cost.company_id&field_company_name=time_cost.member_name'</cfoutput>);"></span>
                            </div>
                        </div>
                    </div> 
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='160' is_detail='0'>                
                        </div>
                    </div>
                    <div class="form-group" id="item-project_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                <input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)><cfoutput>#get_project_name(attributes.project_id)#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID,PARTNER_ID,CONSUMER_ID,COMPANY_ID,MEMBER_NAME','project_id,partner_id,consumer_id,company_id,member_name','time_cost','3','250');" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=time_cost.project_head&project_id=time_cost.project_id&company_id=time_cost.company_id&consumer_id=time_cost.consumer_id&company_name=time_cost.member_name&partner_id=time_cost.partner_id</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-event_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31065.Toplantı'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="event_id" id="event_id" value="">
                                <input type="text" name="event_head" id="event_head" value="" >
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_events&field_id=time_cost.event_id&field_name=time_cost.event_head</cfoutput>')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-comment">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                            <cfif isdefined("attributes.is_bug") or isdefined("attributes.is_cus_help")>
                                <textarea name="comment" id="comment" message="<cfoutput>#message#</cfoutput>"  ><cfoutput><cfif isdefined("attributes.is_bug")><cf_get_lang dictionary_id='32297.Bug id'> :#attributes.bug_id#:#attributes.bug_head#<cfelseif isdefined("attributes.is_cus_help")><cf_get_lang dictionary_id='32381.Etkilesim'>: #attributes.cus_help_id#</cfif></cfoutput></textarea>
                            <cfelse>
                                <textarea name="comment" id="comment" message="<cfoutput>#message#</cfoutput>"><cfif isdefined('attributes.comment')><cfoutput>#attributes.comment#</cfoutput></cfif></textarea>
                            </cfif>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-time_cost_cat_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="time_cost_cat_id" id="time_cost_cat_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_time_cost_cats">
                                    <option value="#time_cost_cat_id#">#time_cost_cat#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-today">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57490.Gün'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group"> 
                                <input type="text" required="yes" name="today" id="today" value="<cfoutput>#DateFormat(attributes.today,dateformat_style)#</cfoutput>"  validate="#validate_style#">
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="today"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-event_start_clock">
                        <label class="col col-4 col-xs-12 "><cf_get_lang dictionary_id='30961.Başlangıç Saati'></label>
                        <div class="col col-4 col-xs-6">
                        <cfif isdefined('ahour')>
                            <cf_wrkTimeFormat name="event_start_clock" value="#ahour#">
                            <cfelse>
                            <cf_wrkTimeFormat name="event_start_clock" value="0">
                            </cfif>
                        </div>
                        <div class="col col-4 col-xs-6">
                            <select name="event_start_minute" id="event_start_minute">
                                <cfloop from="0" to="59" index="a">
                                    <cfoutput>
                                        <option value="#Numberformat(a,'00')#" <cfif isdefined('aminute') and aminute eq a>selected</cfif>>#Numberformat(a,'00')#</option>
                                    </cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-event_finish_clock">
                        <label class="col col-4 col-xs-12 "><cf_get_lang dictionary_id='30959.Bitiş Saati'></label>
                        <div class="col col-4 col-xs-6">
                        <cfif isdefined('fhour')>
                            <cf_wrkTimeFormat name="event_finish_clock" value="#fhour#">
                            <cfelse>
                            <cf_wrkTimeFormat name="event_finish_clock" value="0">
                            </cfif>
                        </div>
                        <div class="col col-4 col-xs-6">
                            <select name="event_finish_minute" id="event_finish_minute">
                                <cfloop from="0" to="59" index="a">
                                    <cfoutput>
                                        <option value="#Numberformat(a,'00')#" <cfif isdefined('fminute') and  fminute eq a>selected</cfif>> #Numberformat(a,'00')#</option>
                                    </cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-total_time_hour">
                        <label class="col col-4 col-xs-12 "><cf_get_lang dictionary_id='29513.Süre'>(<cf_get_lang dictionary_id='57491.Saat'>/<cf_get_lang dictionary_id='58827.Dk'>.)</label>
                        <div class="col col-4 col-xs-6">
                            <input type="text" name="total_time_hour" id="total_time_hour" value="" class="moneybox" onKeyUp="isNumber(this);" maxlength="3" range="0,999">
                        </div>
                        <div class="col col-4 col-xs-6">
                            <input type="text" name="total_time_minute" id="total_time_minute" value="" class="moneybox" onKeyUp="isNumber(this);" validate="integer" maxlength="2">
                        </div>
                    </div>
                    <div class="form-group" id="item-overtime_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31990.Mesai Türü'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="overtime_type" id="overtime_type">
                                <option value="1"><cf_get_lang dictionary_id='32287.Normal'></option>
                                <option value="2"><cf_get_lang dictionary_id='31547.Fazla Mesai'></option>
                                <option value="3"><cf_get_lang dictionary_id='31472.Hafta Sonu'></option>
                                <option value="4"><cf_get_lang dictionary_id='31473.Resmi Tatil'></option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-activity">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32374.Aktiviteler'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrk_budgetactivity 
                            name="activity"
                            activity_status="1"
                            width="160">
                        </div>
                    </div>
                    <div class="form-group" id="item-expense">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58235.Masraf Merkezi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="expense_id" id="expense_id" value="">
                                <input type="text" name="expense" id="expense" value="" onfocus="AutoComplete_Create('expense','EXPENSE','EXPENSE','get_expense_center','0','EXPENSE_ID','expense_id','time_cost','3','250');" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_id=time_cost.expense_id&field_name=time_cost.expense</cfoutput>')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-work_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58445.İş'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="work_id" id="work_id" value="<cfif isdefined('attributes.work_id') and len(attributes.work_id)><cfoutput>#attributes.work_id#</cfoutput></cfif>">
                                <input type="text" name="work_head" id="work_head" value="<cfif isdefined('attributes.work_head') and len(attributes.work_head)><cfoutput>#attributes.work_head#</cfoutput></cfif>">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_add_work&field_id=time_cost.work_id&field_name=time_cost.work_head&comp_id=time_cost.company_id&comp_name=time_cost.member_name&field_pro_id=time_cost.project_id&field_pro_name=time_cost.project_head</cfoutput>')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-service_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57656.Servis'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="service_id" id="service_id" value="<cfif (isdefined("attributes.is_service") or isdefined("attributes.is_call_service")) and isdefined("attributes.service_id") and len(attributes.service_id)><cfoutput>#attributes.service_id#</cfoutput></cfif>">
                                <input type="text" name="service_head" id="service_head" value="<cfif  (isdefined("attributes.is_service") or isdefined("attributes.is_call_service")) and isdefined("attributes.service_head") and len(attributes.service_head)><cfoutput>#attributes.service_head#</cfoutput></cfif>">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=myhome.popup_add_crm&field_id=time_cost.service_id&field_name=time_cost.service_head&field_comp_id=time_cost.company_id</cfoutput>')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-class_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57419.Eğitim'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="class_id" id="class_id" value="">
                                <input type="text" name="class_name" id="class_name" value="">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=myhome.popup_list_training_classes&field_id=time_cost.class_id&field_name=time_cost.class_name</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-p_order_result">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29651.Üretim Sonucu'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="p_order_result_id" id="p_order_result_id" value="<cfif isdefined('attributes.p_order_result_id') and len(attributes.p_order_result_id)><cfoutput>#attributes.p_order_id#</cfoutput></cfif>">
                                <input type="text" name="p_order_result" id="p_order_result" value="<cfif isdefined('attributes.production_order_no') and len(attributes.production_order_no)><cfoutput>#attributes.production_order_no#</cfoutput></cfif>">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_p_order_results&field_id=time_cost.p_order_result_id&field_name=time_cost.p_order_result</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-rd">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31750.Arge Gününe Dahil'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="is_rd_ssk" id="is_rd_ssk">
                                <option value="0"><cf_get_lang dictionary_id = "57496.Hayır" ></option>
                                <option value="1"><cf_get_lang dictionary_id = "57495.Evet"></option>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='saat_kontrol()'>
            </cf_box_footer>
        </cfform>
        <cfif isdefined("attributes.is_service") or isdefined("attributes.is_call_service") or isdefined("attributes.is_cus_help") or isdefined("attributes.is_p_order_result")>
            <cfinclude template="../display/time_cost_list.cfm">
        </cfif>
        <cfif isdefined("attributes.is_subscription")>
            <cfinclude template="../display/time_cost_list2.cfm">
        </cfif>
        <cfif isdefined("attributes.today")>
            <cfinclude template="../display/time_cost_list3.cfm">
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">
	function saat_kontrol()
	{ 
		start_clock = $('#event_start_clock').val();
		finish_clock = $('#event_finish_clock').val();
		start_minute = $('#event_start_minute').val();
		finish_minute = $('#event_finish_minute').val();
        /*if($("#total_time_hour").val()=='' && $("#total_time_minute").val()==''){
            alert("<cf_get_lang dictionary_id='31630.Lütfen Süre Giriniz'>!");
			return false;
        }*/
		if (time_cost.comment.value == "")
		{
			alert ("<cf_get_lang dictionary_id ='31629.Lütfen Açıklama Giriniz '>!");
			return false;
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
		if (document.getElementById('form_ul_event_start_clock').style.display != 'none')
		{
			if (document.time_cost.total_time_hour.value == "" && document.time_cost.total_time_minute.value == "")
			{ 
				if(start_clock != '' || finish_clock != '' || start_minute != '' || finish_minute != '')
				{
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
		}
		else
		{
			if (document.time_cost.total_time_hour.value == "" && document.time_cost.total_time_minute.value == "")
			{
				alert("<cf_get_lang dictionary_id='31630.Lütfen Süre Giriniz'>!");
				return false;
			}
		}
        return process_cat_control();
		
	}
</script>
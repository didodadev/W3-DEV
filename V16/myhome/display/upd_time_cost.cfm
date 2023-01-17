<cfif fusebox.circuit eq 'myhome'>
    <cfset attributes.time_cost_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.time_cost_id,accountKey:'wrk')>
</cfif>
<cfquery name="get_time_cost" datasource="#dsn#">
	SELECT * FROM TIME_COST WHERE TIME_COST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.time_cost_id#">
</cfquery>
<cfquery name="get_activity" datasource="#dsn#">
	SELECT * FROM SETUP_ACTIVITY WHERE ACTIVITY_STATUS = 1 ORDER BY ACTIVITY_NAME
</cfquery>
<cfquery name="get_time_cost_cats" datasource="#dsn#">
	SELECT TIME_COST_CAT,TIME_COST_CAT_ID FROM TIME_COST_CAT ORDER BY TIME_COST_CAT
</cfquery>
<cfset get_component = createObject("component", "V16.myhome.cfc.time_cost")>
	<cfset get_activity = get_component.get_activity()>
	<cfset get_time_cost_cats = get_component.get_time_cost_cats()>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Zaman Harcamaları','57561')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="time_cost" action="#request.self#?fuseaction=myhome.emptypopup_upd_time_cost&time_cost_id=#attributes.time_cost_id#" method="post">
            <cfinput type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-employee">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="employee_id" id="employee_id" value="#get_time_cost.employee_id#">
                                    <input type="text" name="employee" id="employee" readonly  value="#get_emp_info(get_time_cost.employee_id,0,0)#">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=time_cost.employee_id&field_name=time_cost.employee&select_list=1');"></span>
                                </cfoutput>                 
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-member_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_time_cost.consumer_id#</cfoutput>">
                                <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_time_cost.partner_id#</cfoutput>">
                                <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_time_cost.company_id#</cfoutput>">
                                <cfif len(get_time_cost.company_id)>
                                    <input type="text" name="member_name" id="member_name"  value="<cfoutput>#get_par_info(get_time_cost.company_id,1,1,0)#</cfoutput>" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,CONSUMER_ID,PARTNER_ID','company_id,consumer_id,partner_id','','3','250');" autocomplete="off">
                                <cfelseif len(get_time_cost.consumer_id)>
                                    <input type="text" name="member_name" id="member_name" value="<cfoutput>#get_cons_info(get_time_cost.consumer_id,0,0)#</cfoutput>"  onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,CONSUMER_ID,PARTNER_ID','company_id,consumer_id,partner_id','','3','250');" autocomplete="off">
                                <cfelse>
                                    <input type="text" name="member_name" id="member_name" value=""  onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,CONSUMER_ID,PARTNER_ID','company_id,consumer_id,partner_id','','3','250');" autocomplete="off">
                                </cfif>
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_consumer=time_cost.consumer_id&field_comp_id=time_cost.company_id&field_member_name=time_cost.member_name&field_partner=time_cost.partner_id&select_list=7,8</cfoutput>')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-subscription_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58832.Abone'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif len(get_time_cost.subscription_id)>
                                    <cfquery name="get_subscription_name" datasource="#DSN3#">
                                        SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_time_cost.subscription_id#">
                                    </cfquery>
                                    <input type="hidden" name="subscription_id" id="subscription_id" value="<cfoutput>#get_time_cost.subscription_id#</cfoutput>">
                                    <input type="text" name="subscription_no" id="subscription_no" value="<cfoutput>#get_subscription_name.subscription_no#</cfoutput>"  onFocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','200');" autocomplete="off">
                                <cfelse>
                                    <input type="hidden" name="subscription_id" id="subscription_id" value="">
                                    <input type="text" name="subscription_no" id="subscription_no" value=""  onFocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','200');" autocomplete="off">
                                </cfif>
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_subscription&field_id=time_cost.subscription_id&field_no=time_cost.subscription_no&field_company_id=time_cost.company_id&field_company_name=time_cost.member_name'</cfoutput>);"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' select_value='#get_time_cost.time_cost_stage#' process_cat_width='160' is_detail='1'>                
                        </div>
                    </div>
                    <div class="form-group" id="item-project_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif len(get_time_cost.project_id)>
                                    <cfquery name="get_project_name" datasource="#dsn#">
                                        SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_time_cost.project_id#">
                                    </cfquery>
                                </cfif>
                                <input type="hidden" name="project_id" id="project_id" value="<cfif len(get_time_cost.project_id)><cfoutput>#get_time_cost.project_id#</cfoutput></cfif>">
                                <input type="text" name="project_head" id="project_head"  onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID,PARTNER_ID,CONSUMER_ID,COMPANY_ID,MEMBER_NAME','project_id,partner_id,consumer_id,company_id,member_name','time_cost','3','250');" value="<cfif len(get_time_cost.project_id)><cfoutput>#get_project_name.project_head#</cfoutput></cfif>" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=time_cost.project_head&project_id=time_cost.project_id&company_id=time_cost.company_id&consumer_id=time_cost.consumer_id&company_name=time_cost.member_name&partner_id=time_cost.partner_id</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-event_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31065.Toplantı'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif len(get_time_cost.event_id)>
                                    <cfquery name="GET_EVENT" datasource="#DSN#">
                                        SELECT EVENT_HEAD FROM EVENT WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_time_cost.event_id#">
                                    </cfquery>
                                </cfif>
                                <input type="hidden" name="event_id" id="event_id" value="<cfif len(get_time_cost.event_id)><cfoutput>#get_time_cost.event_id#</cfoutput></cfif>">
                                <input type="text" readonly name="event_head" id="event_head" value="<cfif len(get_time_cost.event_id)><cfoutput>#get_event.event_head#</cfoutput></cfif>" >
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_events&field_id=time_cost.event_id&field_name=time_cost.event_head</cfoutput>')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-comment">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'>*</label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="comment" id="comment" style="width:150px;height:80px;"><cfoutput>#get_time_cost.comment#</cfoutput></textarea>
                        </div>
                    </div>
                    <!---<div class="form-group" id="item-p_order_result">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1854.Üretim Sonucu'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="p_order_result_id" id="p_order_result_id" value="<cfif isdefined('attributes.p_order_result_id') and len(attributes.p_order_result_id)><cfoutput>#attributes.p_order_id#</cfoutput></cfif>">
                                <input type="text" name="p_order_result" id="p_order_result" value="<cfif isdefined('attributes.production_order_no') and len(attributes.production_order_no)><cfoutput>#attributes.production_order_no#</cfoutput></cfif>">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_p_order_results&field_id=time_cost.p_order_result_id&field_name=time_cost.p_order_result</cfoutput>','list');"></span>
                            </div>
                        </div>
                    </div>--->
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-time_cost_cat_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="time_cost_cat_id" id="time_cost_cat_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_time_cost_cats">
                                    <option value="#time_cost_cat_id#" <cfif get_time_cost.time_cost_cat_id eq time_cost_cat_id>selected</cfif>>#time_cost_cat#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-today">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57490.Gün'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group"> 
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='30890.Gün Girmelisiniz !'></cfsavecontent>
                                <cfinput type="text" required="yes" message="#message#" name="today" value="#DateFormat(get_time_cost.event_date,dateformat_style)#" style="width:68px;" validate="#validate_style#">
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="today"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-event_start_clock">
                        <label class="col col-4 col-xs-12 "><cf_get_lang dictionary_id='30961.Başlangıç Saati'></label>
                        <div class="col col-4 col-xs-6">
                            <cf_wrkTimeFormat name="event_start_clock" value="#get_time_cost.start#">
                        </div>
                        <div class="col col-4 col-xs-6">
                            <select name="event_start_minute" id="event_start_minute">
                                <cfloop from="0" to="55" index="a" step="5">
                                    <cfoutput><option value="#Numberformat(a,00)#"<cfif get_time_cost.start_min eq a>selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-event_finish_clock">
                        <label class="col col-4 col-xs-12 "><cf_get_lang dictionary_id='30959.Bitiş Saati'></label>
                        <div class="col col-4 col-xs-6">
                            <cf_wrkTimeFormat name="event_finish_clock" value="#get_time_cost.finish#">
                        </div>
                        <div class="col col-4 col-xs-6">
                            <select name="event_finish_minute" id="event_finish_minute">
                                <cfloop from="0" to="55" index="a" step="5">
                                    <cfoutput><option value="#Numberformat(a,00)#"<cfif get_time_cost.finish_min eq a>selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-total_time_hour">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29513.Süre'></label>
                        <cfif len(get_time_cost.expensed_minute)>
                            <cfset totalminute = get_time_cost.expensed_minute mod 60>
                            <cfset totalhour = (get_time_cost.expensed_minute-totalminute)/60>
                        <cfelse>
                            <cfset totalminute = "">
                            <cfset totalhour = "">
                        </cfif>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="total_time_hour" id="total_time_hour" value="<cfoutput>#totalhour#</cfoutput>">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id ='57491.Saat'></span>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='31894.0 59 Arası Giriniz'></cfsavecontent>
                                <cfinput type="text" name="total_time_minute" value="#totalminute#" range="0,59" message="#message#">
                                <span class="input-group-addon no-bg "><cf_get_lang dictionary_id='58827.Dk'></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-overtime_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31990.Mesai Türü'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="overtime_type" id="overtime_type">
                                <option value="1" <cfif get_time_cost.OVERTIME_TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id='32287.Normal'></option>
                                <option value="2"<cfif get_time_cost.OVERTIME_TYPE eq 2>selected</cfif>><cf_get_lang dictionary_id='31547.Fazla Mesai'></option>
                                <option value="3"<cfif get_time_cost.OVERTIME_TYPE eq 3>selected</cfif>><cf_get_lang dictionary_id='31472.Hafta Sonu'></option>
                                <option value="4"<cfif get_time_cost.OVERTIME_TYPE eq 4>selected</cfif>><cf_get_lang dictionary_id='31473.Resmi Tatil'></option>
                            </select>
                        </div>
                    </div>
                </div> 
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-activity">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32374.Aktiviteler'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="activity" id="activity" >
                                <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'>
                                <cfoutput query="get_activity">
                                    <option value="#activity_id#"<cfif get_time_cost.activity_id eq activity_id>selected</cfif>>#activity_name#</option>
                                </cfoutput> 
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-expense">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58235.Masraf Merkezi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif len(get_time_cost.expense_id)>
                                    <cfquery name="GET_EXPENSE" datasource="#DSN2#">
                                        SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_time_cost.expense_id#">
                                    </cfquery> 
                                </cfif>
                                <input type="hidden" name="expense_id" id="expense_id" value="<cfif LEN(get_time_cost.expense_id)><cfoutput>#get_time_cost.expense_id#</cfoutput></cfif>">
                                <input type="text" name="expense" id="expense" onfocus="AutoComplete_Create('expense','EXPENSE','EXPENSE','get_expense_center','','EXPENSE_ID','expense_id','time_cost','3','250');" value="<cfif LEN(get_time_cost.expense_id)><cfoutput>#get_expense.expense#</cfoutput></cfif>"  autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_id=time_cost.expense_id&field_name=time_cost.expense</cfoutput>')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-work_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58445.İş'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif len(get_time_cost.work_id)>
                                    <cfquery name="GET_WORK" datasource="#DSN#">
                                        SELECT WORK_HEAD,COMPANY_ID,WORK_ID FROM PRO_WORKS WHERE WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_time_cost.work_id#">
                                    </cfquery>
                                </cfif>
                                <input type="hidden" name="work_id" id="work_id" value="<cfif len(get_time_cost.work_id)><cfoutput>#get_work.work_id#</cfoutput></cfif>">
                                <input type="text" readonly name="work_head" id="work_head" value="<cfif len(get_time_cost.work_id)><cfoutput>#get_work.work_head#</cfoutput></cfif>" >
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_add_work&field_id=time_cost.work_id&field_name=time_cost.work_head&comp_id=time_cost.company_id&comp_name=time_cost.member_name&field_pro_id=time_cost.project_id&field_pro_name=time_cost.project_head</cfoutput>')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-service_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57656.Servis'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif len(get_time_cost.service_id)>
                                    <cfquery name="GET_SERVICE" datasource="#DSN3#">
                                        SELECT SERVICE_ID,SERVICE_HEAD FROM SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_time_cost.service_id#">
                                    </cfquery> 
                                </cfif>
                                <input type="hidden" name="service_id" id="service_id" value="<cfif len(get_time_cost.service_id)><cfoutput>#get_service.service_id#</cfoutput></cfif>">
                                <input type="text" readonly name="service_head" id="service_head" value="<cfif len(get_time_cost.service_id)><cfoutput>#get_service.service_head#</cfoutput></cfif>"  >
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=myhome.popup_add_crm&field_id=time_cost.service_id&field_name=time_cost.service_head&field_comp_id=time_cost.company_id</cfoutput>')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-class_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57419.Eğitim'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif len(get_time_cost.class_id)>
                                    <cfquery name="get_class" datasource="#dsn#">
                                        SELECT CLASS_ID, CLASS_NAME FROM TRAINING_CLASS WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_time_cost.class_id#">
                                    </cfquery>
                                </cfif>
                                <input type="hidden" name="class_id" id="class_id" value="<cfif len(get_time_cost.class_id)><cfoutput>#get_class.class_id#</cfoutput></cfif>">
                                <input type="text" name="class_name" id="class_name" value="<cfif len(get_time_cost.class_id)><cfoutput>#get_class.class_name#</cfoutput></cfif>" >
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=myhome.popup_list_training_classes&field_id=time_cost.class_id&field_name=time_cost.class_name</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-rd">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31750.Arge Gününe Dahil'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="is_rd_ssk" id="is_rd_ssk">
                                <option value="0" <cfif get_time_cost.is_rd_ssk eq 0>selected</cfif>><cf_get_lang dictionary_id = "57496.Hayır" ></option>
                                <option value="1" <cfif get_time_cost.is_rd_ssk eq 1>selected</cfif>><cf_get_lang dictionary_id = "57495.Evet"></option>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer> 
                <cf_record_info query_name="get_time_cost">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='59981.Zaman Harcaması Siliyorsunuz ! Emin misiniz'></cfsavecontent>
                <cf_workcube_buttons is_upd='1' add_function='saat_kontrol()' delete_page_url='#request.self#?fuseaction=myhome.del_time_cost&time_cost_id=#attributes.time_cost_id#' delete_alert='#message#'>
            </cf_box_footer>
            <cfif len("get_time_cost.event_date")>
                <cfset attributes.today = get_time_cost.event_date>
                <cfinclude template="../display/time_cost_list3.cfm">
            </cfif>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function saat_kontrol()
	{
		start_clock = $('#event_start_clock').val();
		finish_clock = $('#event_finish_clock').val();
		start_minute=$('#event_start_minute').val();
		finish_minute=$('#event_finish_minute').val();
		if (document.getElementById('form_ul_event_start_clock').style.display != 'none')
		{
			if(start_clock != '' || finish_clock != '' || start_minute != '' || finish_minute != '')
			{
				if(start_clock > finish_clock)
				{
					alert("<cf_get_lang dictionary_id='31409.Başlangıç Saati Bitiş Saatinden Büyük Olamaz'>!");
					return false;
				}
				else if((start_clock == finish_clock) && (start_minute == finish_minute))
				{	
					alert("<cf_get_lang dictionary_id='53595.Başlangıç Saati Bitiş saatinden büyük veya eşit olamaz	'>!");
					return false;
				}	
				else if((start_clock == finish_clock) && (start_minute > finish_minute))
				{
					alert("<cf_get_lang dictionary_id='31409.Başlangıç Saati Bitiş Saatinden Büyük Olamaz'>!");
					return false;
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
		
		x = (300 - document.time_cost.comment.value.length);
		if ( x < 0 )
		{ 
			alert ("<cf_get_lang dictionary_id='36199.Açıklama'> "+ ((-1) * x) +" <cf_get_lang dictionary_id='29538.Karakter Uzun'>!");
			return false;
		}
		return process_cat_control();
	}
</script>
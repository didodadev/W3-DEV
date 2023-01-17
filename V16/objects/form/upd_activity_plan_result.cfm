<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_STAGES" datasource="#dsn#">
	SELECT * FROM SETUP_ACTIVITY_STAGES
</cfquery>
<cfquery name="GET_EXPENSE" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS
</cfquery>
<cfquery name="GET_PLAN_ROW" datasource="#dsn#">
 	SELECT
		ACTIVITY_PLAN.EVENT_PLAN_HEAD,
		ACTIVITY_PLAN.EXPENSE_ID,
		ACTIVITY_PLAN_ROW.*,
		ACTIVITY_PLAN.EST_LIMIT,
		ACTIVITY_PLAN.EVENT_CAT,
		ACTIVITY_PLAN_ROW.WARNING_ID,
		ACTIVITY_PLAN.EVENT_PLAN_ID,
		ACTIVITY_PLAN.ANALYSE_ID,
		ACTIVITY_PLAN.MAIN_START_DATE,
		ACTIVITY_PLAN.MAIN_FINISH_DATE,
		COMPANY.FULLNAME,
		COMPANY.COMPANY_ID,
		ACTIVITY_PLAN_ROW.EVENT_PLAN_ROW_ID,
		ACTIVITY_PLAN.ANALYSE_ID
	FROM
		COMPANY,
		ACTIVITY_PLAN,
		ACTIVITY_PLAN_ROW
	WHERE 
		ACTIVITY_PLAN_ROW.COMPANY_ID = COMPANY.COMPANY_ID AND
		ACTIVITY_PLAN.EVENT_PLAN_ID = ACTIVITY_PLAN_ROW.EVENT_PLAN_ID AND
		ACTIVITY_PLAN_ROW.EVENT_PLAN_ROW_ID = #attributes.event_plan_row_id#
</cfquery>
<cfquery name="GET_ROW" datasource="#dsn#">
	SELECT 
		EMPLOYEE_POSITIONS.EMPLOYEE_ID
	FROM
		ACTIVITY_PLAN_ROW_POS,
		EMPLOYEE_POSITIONS
	WHERE
		ACTIVITY_PLAN_ROW_POS.EVENT_PLAN_ID = #attributes.eventid# AND
		EMPLOYEE_POSITIONS.POSITION_ID = ACTIVITY_PLAN_ROW_POS.POS_ID
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Etkinlik Sonucu','34158')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">			
        <cfform name="event_result" action="#request.self#?fuseaction=objects.emptypopup_add_activity_plan_result" method="post">
            <input type="hidden" name="eventid" id="eventid" value="<cfoutput>#attributes.eventid#</cfoutput>">
            <input type="hidden" name="event_plan_row_id" id="event_plan_row_id" value="<cfoutput>#attributes.event_plan_row_id#</cfoutput>">
            <input type="hidden" name="today_value_" id="today_value_" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
            <cf_box_elements>
                <div class="col col-8" type="column" index="1" sort="true">
					<cfif (get_plan_row.position_id eq session.ep.position_code) or listfind(get_row.employee_id, session.ep.position_code, ',')>
                        <div class="form-group" id="item-is_pos">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp;</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <label><input type="checkbox" name="is_pos" id="is_pos" <cfif get_plan_row.is_pos eq 1>checked</cfif>><cf_get_lang dictionary_id='52320.Katılımcıları Bilgilendir'></label>
                                </div>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <label><input type="checkbox" name="is_inf" id="is_inf" <cfif get_plan_row.is_inf eq 1>checked</cfif>><cf_get_lang dictionary_id ='34163.Bilgi Verilecekleri Bilgilendir'></label>
                                </div>
                            </div> 
                        </div>
                    </cfif>
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='41214.Plan'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="plan_" value="#get_plan_row.event_plan_head#" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='57486.Kategori'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif len(get_plan_row.warning_id)>
                                <cfquery name="GET_ACT_TYPE" datasource="#dsn#">
                                    SELECT * FROM SETUP_ACTIVITY_TYPES WHERE ACTIVITY_TYPE_ID = #get_plan_row.warning_id#
                                </cfquery>
                                <cfinput type="text" name="cat_" value="#get_act_type.activity_type#" readonly>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='34159.Etkinlik Yapılan'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="fullname_" value="#get_plan_row.fullname#" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='34160.Etkinlik Formu'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif len(get_plan_row.analyse_id)>
                                <cfquery name="GET_ANALYSE" datasource="#dsn#">
                                    SELECT ANALYSIS_ID, ANALYSIS_HEAD FROM MEMBER_ANALYSIS WHERE ANALYSIS_ID = #get_plan_row.analyse_id#
                                </cfquery>
                                <cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_make_analysis&analysis_id=#get_analyse.analysis_id#&member_type=partner&member_id=#get_plan_row.company_id#' ,'list');">#get_analyse.analysis_head#&nbsp;</a></cfoutput>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="date_" value="#dateformat(get_plan_row.start_date,dateformat_style)# #timeformat(get_plan_row.start_date,timeformat_style)#- #timeformat(get_plan_row.finish_date,timeformat_style)#" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57569.Görevli'></label> 
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="pos_" value="#get_emp_info(get_plan_row.position_id,1,0)#" readonly>
                        </div>
                    </div>

					<cfif (get_plan_row.position_id eq session.ep.position_code) or listfind(get_row.employee_id, session.ep.position_code, ',')>
                        <div class="form-group" id="item-get_stage">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57684.Sonuç'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="visit_stage" id="visit_stage">
                                    <option value=""><cf_get_lang dictionary_id='57684.Sonuç'></option>
                                    <cfoutput query="get_stages">
                                        <option value="#activity_stage_id#" <cfif activity_stage_id eq get_plan_row.visit_stage>selected</cfif>>#activity_stage#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-money">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51532.Harcama'></label>
                            <cfsavecontent variable="alert"><cf_get_lang dictionary_id='35482.Sayı Giriniz'></cfsavecontent>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <div class="input-group">
                                        <cfinput type="text" name="visit_expense" validate="float" message="#alert#" onKeyup="'return(FormatCurrency(this,event));'" value="#tlformat(get_plan_row.expense)#" class="moneybox">
                                        <span class="input-group-addon width">
                                            <select name="money" id="money">
                                                <cfoutput query="get_money">
                                                    <option value="#money#" <cfif money eq get_plan_row.money_currency>selected</cfif>>#money#</option>
                                                </cfoutput>
                                            </select>
                                        </span>
                                    </div>
                                </div>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <select name="expense_item" id="expense_item">
                                        <option value=""><cf_get_lang dictionary_id='58551.Gider Kalemi'></option>
                                        <cfoutput query="get_expense">
                                            <option value="#expense_item_id#" <cfif expense_item_id eq get_plan_row.expense_item>selected</cfif>>#expense_item_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-execute_start_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51718.Gerçekleşme Tarihi'></label>
                            <cfsavecontent variable="alert"><cf_get_lang dictionary_id='52319.Lütfen Gerçekleşme Tarihi Formatını Doğru Giriniz'>!</cfsavecontent>
                            <div class="col col-4 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text"  name="execute_start_date" validate="#validate_style#" message="#alert#" value="#dateformat(get_plan_row.execute_startdate,dateformat_style)#">
                                    <span class="input-group-addon">
                                        <cf_wrk_date_image date_field="execute_start_date">
                                    </span>
                                </div>
                            </div>
						</div>
                        <div class="form-group" id="item-execute_finish_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                            <div class="col col-4 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="alert"><cf_get_lang dictionary_id='30615.Geçerli Bir Bitiş Tarihi Giriniz'>!</cfsavecontent>
                                        <cfinput type="text"  name="execute_finish_date" validate="#validate_style#" message="#alert#" value="#dateformat(get_plan_row.execute_finishdate,dateformat_style)#">
                                    <span class="input-group-addon">
                                        <cf_wrk_date_image date_field="execute_finish_date">
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-result">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><textarea name="result" id="result" style="width:400px;height:100px;"><cfoutput>#get_plan_row.result_detail#</cfoutput></textarea></div>
                        </div>
                    <cfelse>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='34024.Harcama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfoutput>#tlformat(get_plan_row.expense)# #get_plan_row.money_currency#</cfoutput>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfif len(get_plan_row.expense_item)>
                                    <cfquery name="GET_EXPENSE" datasource="#dsn2#">
                                        SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #get_plan_row.expense_item#
                                    </cfquery><cfoutput>#get_expense.expense_item_name#</cfoutput>
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57684.Sonuç'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfif len(get_plan_row.visit_stage)>
                                    <cfquery name="GET_STAGE" datasource="#dsn#">
                                        SELECT * FROM SETUP_VISIT_STAGES WHERE VISIT_STAGE_ID = #get_plan_row.visit_stage#
                                    </cfquery><cfoutput>#get_stage.visit_stage#</cfoutput></cfif>
                                </div>
                            </div>
						</div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfoutput>#get_plan_row.result_detail#</cfoutput>
                            </div>
                        </div>
                    </cfif>
                </div>
            </cf_box_elements>
            <cf_box_footer>
				<cf_record_info
				query_name="get_plan_row"	
				record_emp="result_record_emp"
				record_date="RESULT_RECORD_DATE"
				update_emp="RESULT_UPDATE_EMP"
				update_date="RESULT_UPDATE_DATE">
				<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
        </cfform>
    </cf_box>
</div>



<script type="text/javascript">
	function kontrol()
	{
		x = document.event_result.visit_stage.selectedIndex;
		if (document.event_result.visit_stage[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id ='34023.Lütfen Sonuç Giriniz'> !");
			return false;
		}
		tarih1_1 = event_result.execute_start_date.value.substr(6,4) + event_result.execute_start_date.value.substr(3,2) + event_result.execute_start_date.value.substr(0,2);
		tarih2_2 = event_result.today_value_.value.substr(6,4) + event_result.today_value_.value.substr(3,2) + event_result.today_value_.value.substr(0,2);
		if((event_result.execute_start_date.value != "") && (tarih1_1 > tarih2_2))
		{
			alert("<cf_get_lang dictionary_id ='34164.Lütfen Başlangıç Tarihini Bugünden Önce Giriniz'> !");
			return false;
		}
		tarih1_3 = event_result.execute_finish_date.value.substr(6,4) + event_result.execute_finish_date.value.substr(3,2) + event_result.execute_finish_date.value.substr(0,2);
		tarih2_3 = event_result.today_value_.value.substr(6,4) + event_result.today_value_.value.substr(3,2) + event_result.today_value_.value.substr(0,2);
		if((event_result.execute_finish_date.value != "") && (tarih1_3 > tarih2_3))
		{
			alert("<cf_get_lang dictionary_id ='34165.Lütfen Bitiş Tarihini Bugünden Önce Giriniz'> !");
			return false;
		}
		event_result.visit_expense.value = filterNum(event_result.visit_expense.value);
	}
</script>

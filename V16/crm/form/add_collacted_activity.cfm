<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT 
        MONEY, 
        MONEY_STATUS, 
        PERIOD_ID, 
        COMPANY_ID, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        MONEY_SYMBOL	 
    FROM 
    	SETUP_MONEY 
    WHERE 
    	PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_STAGE" datasource="#dsn#">
	SELECT 
    	ACTIVITY_STAGE_ID, 
        ACTIVITY_STAGE, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_ACTIVITY_STAGES 
    ORDER BY 
    	ACTIVITY_STAGE
</cfquery>
<cfquery name="GET_EXPENSE" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS
</cfquery>	
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Toplu Etkinlik Sonucu Girişi','52317')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">			
        <cfform name="event_result" action="#request.self#?fuseaction=crm.emptypopup_add_collacted_activity" method="post">
            <input type="hidden" name="event_plan_id" id="event_plan_id" value="<cfoutput>#attributes.event_plan_id#</cfoutput>">
            <input type="hidden" name="today_value_" id="today_value_" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
            <cf_box_elements>
                <div class="col col-8" type="column" index="1" sort="true">
                    <div class="form-group" id="item-is_pos">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp;</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <label><input type="checkbox" name="is_pos" id="is_pos"><cf_get_lang dictionary_id='34162.Katılımcıları Bilgilendir'></label>
                            </div>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <label><input type="checkbox" name="is_inf" id="is_inf"><cf_get_lang dictionary_id='34163.Bilgi Verilecekleri Bilgilendir'></label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-get_stage">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57684.Sonuç'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="visit_stage" id="visit_stage">
                                <option value=""><cf_get_lang dictionary_id='57684.Sonuç'></option>
                                <cfoutput query="get_stage">
                                    <option value="#activity_stage_id#">#activity_stage#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-money">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51532.Harcama'></label>
                        <cfsavecontent variable="alert"><cf_get_lang dictionary_id='55805.Sayı Giriniz'></cfsavecontent>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="visit_expense" validate="float" message="#alert#" onKeyup="'return(FormatCurrency(this,event));'" value="0" class="moneybox">
                                    <span class="input-group-addon width">
                                        <select name="money" id="money">
                                            <cfoutput query="get_money">
                                                <option value="#money#" <cfif money eq session.ep.money>selected</cfif>>#money#</option>
                                            </cfoutput>
                                        </select>
                                    </span>
                                </div>
                            </div>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <select name="expense_item" id="expense_item">
                                    <option value=""><cf_get_lang_main no='1139.Gider Kalemi'></option>
                                    <cfoutput query="get_expense">
                                        <option value="#expense_item_id#">#expense_item_name#</option>
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
                                <cfinput type="text"  name="execute_start_date" validate="#validate_style#" message="#alert#" value="">
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
                                    <cfinput type="text"  name="execute_finish_date" validate="#validate_style#" message="#alert#" value="">
                                <span class="input-group-addon">
                                    <cf_wrk_date_image date_field="execute_finish_date">
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-result">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no ='217.Açıklama'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><textarea name="result" id="result" style="width:400px;height:100px;"></textarea></div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		x = document.event_result.visit_stage.selectedIndex;
		if (document.event_result.visit_stage[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='52322.Lütfen Sonuç Giriniz'>!");
			return false;
		}
		tarih1_1 = event_result.execute_start_date.value.substr(6,4) + event_result.execute_start_date.value.substr(3,2) + event_result.execute_start_date.value.substr(0,2);
		tarih2_2 = event_result.today_value_.value.substr(6,4) + event_result.today_value_.value.substr(3,2) + event_result.today_value_.value.substr(0,2);
		if((event_result.execute_start_date.value != "") && (tarih1_1 > tarih2_2))
		{
			alert("<cf_get_lang dictionary_id='52323.Lütfen Başlangıç Tarihini Bugünden Önce Giriniz'> !");
			return false;
		}
		tarih1_3 = event_result.execute_finish_date.value.substr(6,4) + event_result.execute_finish_date.value.substr(3,2) + event_result.execute_finish_date.value.substr(0,2);
		tarih2_3 = event_result.today_value_.value.substr(6,4) + event_result.today_value_.value.substr(3,2) + event_result.today_value_.value.substr(0,2);
		if((event_result.execute_finish_date.value != "") && (tarih1_3 > tarih2_3))
		{
			alert("<cf_get_lang dictionary_id='34165.Lütfen Bitiş Tarihini Bugünden Önce Giriniz'> !");
			return false;
		}
		event_result.visit_expense.value = filterNum(event_result.visit_expense.value);
	}
</script>

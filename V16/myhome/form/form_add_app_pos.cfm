<cfquery name="GET_NOTICE" datasource="#dsn#">
	SELECT
		NOTICE_HEAD, 
		NOTICE_NO,
		STATUS,
		STATUS_NOTICE,
		DETAIL, 
		POSITION_ID,
		POSITION_NAME,
		POSITION_CAT_ID,
		POSITION_CAT_NAME,
		INTERVIEW_POSITION_CODE, 
		VALIDATOR_POSITION_CODE,
		VALID, 
		VALID_DATE, 
		VALID_EMP,
		STARTDATE, 
		FINISHDATE, 	
		PUBLISH, 
		COMPANY_ID,
		OUR_COMPANY_ID,
		DEPARTMENT_ID,
		BRANCH_ID,
		RECORD_DATE,
		RECORD_IP,
		RECORD_EMP,
		UPDATE_IP,
		UPDATE_DATE,
		UPDATE_EMP,
		NOTICE_CITY,
		COUNT_STAFF,
		WORK_DETAIL,
		PIF_ID,
		IS_VIEW_LOGO,
		IS_VIEW_COMPANY_NAME,
		VIEW_VISUAL_NOTICE,
		SERVER_VISUAL_NOTICE_ID,
		VISUAL_NOTICE
	FROM
		NOTICES
	WHERE
		NOTICE_ID = #attributes.NOTICE_ID#
</cfquery>
<div class="col col-12 col-xs-12">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='31952.Başvuru Ekle'></cfsavecontent>
    <cf_box title="#message#">
        <cfform name="add_app_pos" method="post" action="#request.self#?fuseaction=myhome.emptypopup_add_app_pos">
            <input type="hidden" value="<cfoutput>#url.empapp_id#</cfoutput>" name="empapp_id" id="empapp_id">
            <cf_box_elements>
                <div class="col col-3 col-md-4 col-sm-12 column" id="column-1">
                    <input type="hidden" name="app_pos_status" id="app_pos_status" value="1">
                    <div class="form-group" id="item-notice_no">
                        <label class="col col-4 col-sm-3"><cf_get_lang dictionary_id ='31334.İlan'></label>
                        <div class="col col-8 col-sm-6 bold">
                            <input type="hidden" name="notice_id" id="notice_id" value="<cfoutput>#attributes.NOTICE_ID#</cfoutput>">
                            <input type="hidden" name="notice_no" id="notice_no" value="<cfoutput>#GET_NOTICE.NOTICE_NO#</cfoutput>">
                            <input type="hidden" name="notice_head" id="notice_head" value="<cfoutput>#GET_NOTICE.NOTICE_HEAD#</cfoutput>">
                            <cfoutput>#GET_NOTICE.NOTICE_HEAD# (#GET_NOTICE.NOTICE_NO#)</cfoutput> 
                        </div>
                    </div>
                    <div class="form-group" id="item-date_now">
                        <label class="col col-4 col-sm-3"><cf_get_lang dictionary_id ='31362.Başvuru Tarihi'></label>
                        <div class="col col-8 col-sm-6 bold">
                        <input type="hidden" name="date_now" id="date_now" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>"><cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>
                        </div>
                    </div>
                    <div class="form-group" id="item-startdate_if_accepted">
                        <label class="col col-4 col-sm-3"><cf_get_lang dictionary_id ='31622.İşe Başlama Tarih'>*</label>
                        <div class="col col-8 col-sm-6">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='31953.İşe Başlama Tarihi Giriniz'></cfsavecontent>
                                <cfinput type="text" name="startdate_if_accepted" value="" validate="#validate_style#" required="yes" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate_if_accepted"></span>
                            </div>	                           
                        </div>                
                    </div>
                    <div class="form-group" id="item-salary_wanted_money">
                        <label class="col col-4 col-sm-3"><cf_get_lang dictionary_id ='31954.İstenen Ücret'><br/>(<cf_get_lang dictionary_id ='31955.Aylık Ort Brüt Ücret'>)</label>
                        <div class="col col-4 col-sm-4">
                            <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='31957.İstenen Ücret Giriniz'></cfsavecontent>
                            <cfinput type="text" name="salary_wanted" required="yes" message="#alert#" onkeyup="return(formatcurrency(this,event));" value="" class="moneybox">
                        </div>             
                        <cfquery name="get_moneys" datasource="#dsn#">
                            SELECT MONEY FROM SETUP_MONEY
                        </cfquery>   
                        <div class="col col-4 col-sm-2">                    
                            <select name="salary_wanted_money" id="salary_wanted_money">
                                <cfoutput query="get_moneys">
                                    <option value="#money#" <cfif session.ep.money eq get_moneys.money>selected</cfif>>#money#</option>
                                </cfoutput>
                            </select>
                        </div>	                           
                    </div>
                    <div class="form-group" id="item-detail_app">
                        <label class="col col-4 col-sm-3"><cf_get_lang dictionary_id='58649.Ön Yazı'></label>
                        <div class="col col-8 col-sm-6">
                        <textarea name="detail_app" id="detail_app"></textarea>            
                        </div>
                    </div>
                </div>
            </cf_box_elements>	
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>

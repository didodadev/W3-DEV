<cfform name="add_app_pos">
<cfsavecontent variable="title">
    <cf_get_lang dictionary_id='58614.Member Notes Balance'>
</cfsavecontent>
<cf_popup_box title="#title#: #get_app.name# #get_app.surname#">
<input type="hidden" value="<cfoutput>#get_app.empapp_id#</cfoutput>" name="empapp_id" id="empapp_id">
<div class="row">
    <div class="col col-3 col-md-4 col-sm-12 column" id="column-1">
        <input type="hidden" name="app_pos_status" id="app_pos_status" value="1">
        <div class="form-group" id="item-notice_no">
            <label class="col col-4 col-sm-3"><cf_get_lang no ='577.İlan'></label>
            <div class="col col-8 col-sm-3 bold">
				<input type="hidden" name="notice_id" id="notice_id" value="<cfoutput>#attributes.NOTICE_ID#</cfoutput>">
				<input type="hidden" name="notice_no" id="notice_no" value="<cfoutput>#GET_NOTICE.NOTICE_NO#</cfoutput>">
				<input type="hidden" name="notice_head" id="notice_head" value="<cfoutput>#GET_NOTICE.NOTICE_HEAD#</cfoutput>">
				<input type="hidden"  name="app_id" id="app_id" value="<cfoutput>#GET_APP_POS.APP_POS_ID#</cfoutput>">
				<cfoutput>#GET_NOTICE.NOTICE_HEAD# (#GET_NOTICE.NOTICE_NO#)</cfoutput> 
            </div>
        </div>
        <div class="form-group" id="item-date_now">
            <label class="col col-4 col-sm-3"><cf_get_lang no ='605.Başvuru Tarihi'></label>
            <div class="col col-8 col-sm-3 bold">
            <input type="hidden" name="date_now" id="date_now" value="<cfoutput>#dateformat(get_app_pos.app_date,dateformat_style)#</cfoutput>"><cfoutput>#dateformat(get_app_pos.app_date,dateformat_style)#</cfoutput>            
            </div>
        </div>
        <div class="form-group" id="item-startdate_if_accepted">
            <label class="col col-4 col-sm-3"><cf_get_lang no ='864.İşe Başlayabileceğiniz Tarih'>*</label>
            <div class="col col-8 col-sm-3">
                <div class="input-group">
                    <cfsavecontent variable="message"><cf_get_lang no ='1195.İşe Başlama Tarihi Giriniz'></cfsavecontent>
                    <cfinput type="text" name="startdate_if_accepted" validate="#validate_style#" required="yes" message="#message#" value="#dateformat(get_app_pos.STARTDATE_IF_ACCEPTED,dateformat_style)#">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="startdate_if_accepted"></span>
                </div>	                           
            </div>                
    </div>
        <div class="form-group" id="item-salary_wanted_money">
            <label class="col col-4 col-sm-3"><cf_get_lang no ='1196.İstenen Ücret'><br/>(<cf_get_lang no ='1197.Aylık Ort Brüt Ücret'>)</label>
            <div class="col col-8 col-sm-3">
                    <cfsavecontent variable="alert"><cf_get_lang no ='1199.İstenen Ücret Giriniz'></cfsavecontent>
                    <cfinput type="text" name="salary_wanted" required="yes" message="#alert#" onkeyup="return(formatcurrency(this,event));" value="#get_app_pos.SALARY_WANTED#" class="moneybox">
            </div>                
            <div class="col col-8 col-sm-2">                    
                <select name="salary_wanted_money" id="salary_wanted_money">
                        <cfoutput query="get_moneys">
                        <option value="#money#" <cfif get_app_pos.SALARY_WANTED_MONEY eq get_moneys.money>selected</cfif>>#money#</option>
                        </cfoutput>
                    </select>
                </div>	                           
        </div>
        <div class="form-group" id="item-detail_app">
            <label class="col col-4 col-sm-3"><cf_get_lang_main no='1237.Ön Yazı'></label>
            <div class="col col-8 col-sm-6">
            <textarea  rows="3" name="detail_app" id="detail_app"><cfoutput>#get_app_pos.DETAIL#</cfoutput></textarea>            
            </div>
        </div>
    </div>
</div>
	<cf_popup_box_footer><cf_workcube_buttons is_upd='1' type_format="1" add_function='kontrol()' is_delete='0'></cf_popup_box_footer>
<cf_popup_box>
</cfform>
<cfscript>
	get_trainers = createObject("component","V16.training_management.cfc.get_class_trainers");
	get_trainers.dsn = dsn;
	get_trainer_names = get_trainers.get_classes
    (
        module_name : fusebox.circuit,
        class_id : attributes.lesson_id
    );
</cfscript>
<cfset cfc = createObject('component','V16.training_management.cfc.training_management')>
<cfset homework = cfc.get_homework_by_id(homework_id: attributes.homework_id)>
<cfset get_user_info = cfc.get_user_info(userkey: session.ep.userkey)>
<cfset DELIVERIES = cfc.GET_HOMEWORK_DELIVERIES(homework_id: attributes.homework_id)>
<cfsavecontent  variable="message"><cf_get_lang dictionary_id='63657.Ödev'><cf_get_lang dictionary_id='44630.Ekle'>: <cfoutput>#get_user_info.name# #get_user_info.surname#</cfoutput></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="add_homework_answer" method="post">
        <cfif homework.recordcount>
            <cf_box_elements>
                <input type="hidden" name="homework_delivery_id" id="homework_delivery_id" value="<cfoutput>#DELIVERIES.homework_delivery_id#</cfoutput>">
                <input type="hidden" name="homework_id" id="homework_id" value="<cfoutput>#attributes.homework_id#</cfoutput>">
                <cfif get_user_info.member_type eq 'employee'>
                    <cfoutput><input type="hidden" name="emp_id" id="emp_id" value="#get_user_info.member_id#"></cfoutput>
                <cfelseif get_user_info.member_type eq 'partner'>
                    <cfoutput><input type="hidden" name="par_id" id="par_id" value="#get_user_info.member_id#"></cfoutput>
                <cfelse>
                    <cfoutput><input type="hidden" name="cons_id" id="cons_id" value="#get_user_info.member_id#"></cfoutput>
                </cfif>
                <cfinput type="hidden" name="member_type" id="member_type" value="#get_user_info.member_type#">
        
                <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='33211.Teslim Eden'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <cfinput type="text" name="delivered_by" id="delivered_by" value="#get_user_info.name# #get_user_info.surname#" readonly>
                    </div>
                </div>
                <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='57645.Teslim Tarihi'></label>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="delivery_date" validate="#validate_style#" value="#dateformat(now(), DATEFORMAT_STYLE)#">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="delivery_date"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='63657.Ödev'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <cfinput id="homework" name="homework" value="#homework.homework#" readonly>
                    </div>
                </div>
                <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='63657.Ödev'><cf_get_lang dictionary_id='57771.Detay'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <textarea name="homework_detail" id="homework_detail" cols="30" rows="5" readonly><cfoutput>#homework.detail#</cfoutput></textarea>
                    </div>
                </div>
                <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='58654.Cevap'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <textarea name="answer" id="answer" cols="30" rows="3"><cfif get_trainer_names.T_ID eq session.ep.userid and session.ep.userkey contains 'e'><cfif DELIVERIES.recordcount><cfoutput>#DELIVERIES.ANSWER#</cfoutput></cfif></cfif></textarea>
                    </div>
                </div>
                <cfif get_trainer_names.T_ID eq session.ep.userid and session.ep.userkey contains 'e'>
                    <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                            <label>Puan</label>
                        </div>
                        <div class="small">
                            <cfinput  name="puan" id="puan" value="#IIf(len(DELIVERIES.PUAN), DELIVERIES.PUAN, DE(0))#">
                        </div>
                    </div>
                </cfif>
            </cf_box_elements>
        <cfelse>
            <cf_box>
                <p class="text"><cfif isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></p>
            </cf_box>
        </cfif>
        <cf_box_footer>
            <cf_workcube_buttons
                is_upd='0'
                add_function="kontrol()"
                data_action = "/V16/training_management/cfc/training_management:add_homework_answer"
                next_page="#request.self#?fuseaction=training.lesson&event=det&lesson_id=#attributes.lesson_id#"
            >
        </cf_box_footer>
    </cfform>
</cf_box>

<script type="text/javascript">
	function kontrol()
	{
		if ($("#answer").val() == '' || $("#delivery_date").val() == '')
		{
			alert('<cf_get_lang dictionary_id='52097.Boş alan bırakmayın'>');
			return false;
		}
		return true;
	}
</script>
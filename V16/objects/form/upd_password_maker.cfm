<cfquery name="get_password_maker" datasource="#dsn#">
	SELECT * FROM PASSWORD_MAKER WHERE PASSWORD_MAKER_ID=#attributes.pass_id#
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Şifrematik',29506)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="upd_password_maker" method="post" action="#request.self#?fuseaction=objects.emptypopup_upd_password_maker">
        <cf_box_elements>
            <input type="hidden" name="pass_id" id="pass_id" value="<cfoutput>#attributes.pass_id#</cfoutput>">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="57493.Aktif"></label>
                    <div class="col col-8 col-sm-12">
                        <input type="checkbox" value="1" name="active" id="active" <cfif get_password_maker.is_active eq 1>checked</cfif>/>
                    </div>                
                </div> 
                <cfif len(get_password_maker.employee_id)>
                    <div class="form-group require" id="item-process_stage">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                        <div class="col col-8 col-sm-12">
                            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_password_maker.employee_id#</cfoutput>" >
                            <cfinput type="text" name="employee_name" value="#get_emp_info(get_password_maker.employee_id,0,0)#" readonly required="yes">	
                        </div>                
                    </div> 
                <cfelse>
                    <div class="form-group require" id="item-process_stage">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                        <div class="col col-8 col-sm-12">
                            <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_password_maker.partner_id#</cfoutput>" >
                            <cfinput type="text" name="partner_name" value="#get_par_info(get_password_maker.partner_id,0,-1,0)#" readonly required="yes">
                        </div>                
                    </div> 
                 </cfif>
                 <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29506.Şifrematik'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput name="password_maker" value="#get_password_maker.password_maker_no#" maxlength="100" required="yes" message="#getLang('','En fazla 100 karakter',29509)#">
                    </div>                
                </div> 
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-6">
                <cf_record_info query_name="get_password_maker">
            </div>
            <div class="col col-6">
                <cf_workcube_buttons is_upd='1' is_cancel="0" del_function="#isDefined('attributes.draggable') ? 'deleteFunc()' : ''#" add_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('upd_password_maker' , #attributes.modal_id#)"),DE(""))#">
            </div>
        </cf_box_footer>
    </cfform>
</cf_box>

<script>
    <cfif isDefined('attributes.draggable')>
        function deleteFunc() {
            openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.emptypopup_del_password_maker&pass_id=#attributes.pass_id#</cfoutput>',<cfoutput>#attributes.modal_id#</cfoutput>);
        }
    </cfif>
</script>


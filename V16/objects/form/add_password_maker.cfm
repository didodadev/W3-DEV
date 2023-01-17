<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Şifrematik',29506)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="add_password_maker" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_password_maker">
        <cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="57493.Aktif"></label>
                    <div class="col col-8 col-sm-12">
                        <input type="checkbox" value="1" name="active" id="active" checked="checked" />
                    </div>                
                </div> 
                <cfif isdefined("attributes.employee_id")>
                    <div class="form-group require" id="item-process_stage">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                        <div class="col col-8 col-sm-12">
                            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>" >
                            <cfinput type="text" name="employee_name" value="#get_emp_info(attributes.employee_id,0,0)#" readonly required="yes">
                        </div>                
                    </div> 
                <cfelse>
                    <div class="form-group require" id="item-process_stage">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58885.partner'></label>
                        <div class="col col-8 col-sm-12">
                            <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#attributes.partner_id#</cfoutput>" >
                            <cfinput type="text" name="partner_name" value="#get_par_info(attributes.partner_id,0,-1,0)#" readonly required="yes">		
                        </div>                
                    </div> 
                </cfif>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29506.Şifrematik'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput name="password_maker" maxlength="100" required="yes" message="#getLang('','En fazla 100 karakter giriniz',29509)#">
                    </div>                
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons type_format='1' is_upd='0' is_cancel="0" add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_password_maker' , #attributes.modal_id#)"),DE(""))#">
        </cf_box_footer>
    </cfform>
</cf_box>

<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.modal_id" default="">

<cf_box title="#getLang('','Maaş Planla',53541)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="#request.self#?fuseaction=ehesap.emptypopup_add_remote_plan" method="post" name="add_remote">
        <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
        <input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#attributes.in_out_id#</cfoutput>">
        <cf_box_elements>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58455.Yıl'></label>
                    <div class="col col-8 col-sm-12">
                        <select name="sal_year" id="sal_year">
                            <cfloop from="#YEAR(NOW())-1#" to="#YEAR(NOW())+2#" index="i">
                                <cfoutput><option value="#i#"<cfif attributes.sal_year eq i> selected</cfif>>#i#</option></cfoutput>
                            </cfloop>
                        </select>	
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57592.Ocak'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput type="text" name="M1" style="width:100px;" value="">	
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57593.Şubat'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput type="text" name="M2" style="width:100px;" value="">	
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57594.Mart'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput  type="text" name="M3" style="width:100px;" value="">	
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57595.Nisan'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput type="text" name="M4" style="width:100px;" value="">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57596.Mayıs'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput type="text" name="M5" style="width:100px;" value="">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57597.Haziran'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput type="text" name="M6" style="width:100px;" value="">
                    </div>
                </div>
            </div>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57598.Temmuz'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput type="text" name="M7" style="width:100px;" value="">	
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57599.Ağustos'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput type="text" name="M8" style="width:100px;" value="">	
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57600.Eylül'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput type="text" name="M9" style="width:100px;" value="">	
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57601.Ekim'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput type="text" name="M10" style="width:100px;" value="">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57602.Kasım'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput type="text" name="M11" style="width:100px;" value="">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57603.Aralık'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput type="text" name="M12" style="width:100px;" value="">
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("upd_form() && loadPopupBox('add_remote' , #attributes.modal_id#)"),DE(""))#">
        </cf_box_footer>
    </cfform>
</cf_box>                
<script type="text/javascript">
function upd_form()
{
    /* var elem = document.getElementById('add_remote').elements;
    for(var i = 0; i < elem.length; i++)
    {
        if(elem[i].type === "text")
        {
            if(Number(elem[i].value) > 15 || Number(elem[i].value) < 0) {
                alert("<cfoutput>#getLang('','Girilen değer 0-15 aralığında olmalıdır!',63060)#</cfoutput>");
                return false;
            } 
        }
    }  */
   
	UnformatFields();
	if (add_remote.M1.value == '') add_remote.M1.value = 0;
	if (add_remote.M2.value == '') add_remote.M2.value = 0;
	if (add_remote.M3.value == '') add_remote.M3.value = 0;
	if (add_remote.M4.value == '') add_remote.M4.value = 0;
	if (add_remote.M5.value == '') add_remote.M5.value = 0;
	if (add_remote.M6.value == '') add_remote.M6.value = 0;
	if (add_remote.M7.value == '') add_remote.M7.value = 0;
	if (add_remote.M8.value == '') add_remote.M8.value = 0;
	if (add_remote.M9.value == '') add_remote.M9.value = 0;
	if (add_remote.M10.value == '') add_remote.M10.value = 0;
	if (add_remote.M11.value == '') add_remote.M11.value = 0;
	if (add_remote.M12.value == '') add_remote.M12.value = 0;
	return true;
}
function upd_12()
{
	add_remote.M2.value = add_remote.M1.value;
	add_remote.M3.value = add_remote.M1.value;
	add_remote.M4.value = add_remote.M1.value;
	add_remote.M5.value = add_remote.M1.value;
	add_remote.M6.value = add_remote.M1.value;
	add_remote.M7.value = add_remote.M1.value;
	add_remote.M8.value = add_remote.M1.value;
	add_remote.M9.value = add_remote.M1.value;
	add_remote.M10.value = add_remote.M1.value;
	add_remote.M11.value = add_remote.M1.value;
	add_remote.M12.value = add_remote.M1.value;
}
function upd_6()
{
	add_remote.M8.value = add_remote.M7.value;
	add_remote.M9.value = add_remote.M7.value;
	add_remote.M10.value = add_remote.M7.value;
	add_remote.M11.value = add_remote.M7.value;
	add_remote.M12.value = add_remote.M7.value;
}

function UnformatFields()
{
	add_remote.M1.value = filterNum(add_remote.M1.value);
	add_remote.M2.value = filterNum(add_remote.M2.value);
	add_remote.M3.value = filterNum(add_remote.M3.value);
	add_remote.M4.value = filterNum(add_remote.M4.value);
	add_remote.M5.value = filterNum(add_remote.M5.value);
	add_remote.M6.value = filterNum(add_remote.M6.value);
	add_remote.M7.value = filterNum(add_remote.M7.value);
	add_remote.M8.value = filterNum(add_remote.M8.value);
	add_remote.M9.value = filterNum(add_remote.M9.value);
	add_remote.M10.value = filterNum(add_remote.M10.value);
	add_remote.M11.value = filterNum(add_remote.M11.value);
	add_remote.M12.value = filterNum(add_remote.M12.value);
}
</script>
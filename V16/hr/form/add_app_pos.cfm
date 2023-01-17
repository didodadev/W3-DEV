<cfset xfa.upd= "hr.emptypopup_add_app_pos">
<cfinclude template="../query/get_app.cfm">
<cfinclude template="../query/get_commethods.cfm">
<cfinclude template="../query/get_moneys.cfm">
<cfsavecontent variable="txt"><cf_get_lang dictionary_id='55172.Başvuru Ekle'>: <cfoutput>#get_app.name# #get_app.surname#</cfoutput></cfsavecontent>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform action="#request.self#?fuseaction=#xfa.upd#" name="add_app_pos" method="post" enctype="multipart/form-data">
        <cf_box title="#txt#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
            <input type="hidden" value="<cfoutput>#attributes.empapp_id#</cfoutput>" name="empapp_id" id="empapp_id">
            <input type="hidden" name="app_pos_status" id="app_pos_status" value="1">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0'  process_cat_width='150' is_detail='0'>
                        </div>
                    </div>
                    <div class="form-group" id="item-notice_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55159.İlan'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="notice_id" id="notice_id" value="">
                                <input type="hidden" name="notice_no" id="notice_no" value="">
                                <input type="text" name="notice_head" id="notice_head" value="" style="width:150px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_notices&field_id=add_app_pos.notice_id&field_no=add_app_pos.notice_no&field_name=add_app_pos.notice_head&field_comp=add_app_pos.company&field_comp_id=add_app_pos.company_id&field_department_id=add_app_pos.department_id&field_department=add_app_pos.department&field_branch_id=add_app_pos.branch_id&field_branch=add_app_pos.branch&&field_our_company_id=add_app_pos.our_company_id&field_pos_id=add_app_pos.position_id&field_pos_name=add_app_pos.app_position');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-position_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="Hidden" name="position_cat_id" id="position_cat_id" value="">
                                <input type="text" name="position_cat" id="position_cat" style="width:150px;" value="" readonly>
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_cats&field_cat_id=add_app_pos.position_cat_id&field_cat=add_app_pos.position_cat');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-app_position">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="Hidden" name="position_id" id="position_id" value="" maxlength="50">
                                <input type="text" name="app_position" id="app_position" style="width:150px;" value="" readonly>
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_app_pos.position_id&field_pos_name=add_app_pos.app_position&show_empty_pos=1');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-department">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="our_company_id" id="our_company_id" value="">	
                                <input type="hidden" name="department_id" id="department_id" value="">
                                <input type="text" name="department" id="department" value="" style="width:150px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=add_app_pos.department_id&field_name=add_app_pos.department&field_branch_name=add_app_pos.branch&field_branch_id=add_app_pos.branch_id&field_our_company_id=add_app_pos.our_company_id</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-company">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57585.Kurumsal Üye'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" value="" name="company_id" id="company_id">
                                <input type="text" name="company" id="company" value="" style="width:150px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=add_app_pos.company_id&field_comp_name=add_app_pos.company&select_list=7');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail_app">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58649.Ön Yazı'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="detail_app" id="detail_app" style="width:438px;height:50px;"></textarea>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-app_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55434.Başvuru Tarihi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu alan'>:<cf_get_lang dictionary_id='55434.Başvuru Tarihi'></cfsavecontent>
                                <cfinput type="text" style="width:150px;" name="app_date" value="" required="yes" validate="#validate_style#" maxlength="10" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="app_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-salary_wanted_money">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55740.İstenen Ücret'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="salary_wanted" style="width:100px;" onkeyup="return(FormatCurrency(this,event));" value="" class="moneybox">
                                <span class="input-group-addon width">
                                    <select name="salary_wanted_money" id="salary_wanted_money" style="width:48px;">
                                        <cfoutput query="get_moneys">
                                        <option value="#money#" <cfif get_moneys.money eq session.ep.money>selected</cfif>>#money# </option>
                                        </cfoutput>
                                    </select>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-STARTDATE_IF_ACCEPTED">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55154.İşe Başlama Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='55327.kabul edildiğiniz takdirde işe başlayabileceğiniz tarih'></cfsavecontent>
                                <cfinput type="text" name="STARTDATE_IF_ACCEPTED" style="width:150px;" value="" validate="#validate_style#" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="STARTDATE_IF_ACCEPTED"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-branch">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="hidden" name="branch_id" id="branch_id" value="">
                            <input type="text" name="branch" id="branch" value="" style="width:150px;" readonly>
                        </div>
                    </div>
                    <div class="form-group" id="item-commethod_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58143.İletişim'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="commethod_id" id="commethod_id" style="width:150px;">
                                <cfoutput query="get_commethods">
                                <option value="#commethod_id#" >#commethod# </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>    
            <cf_box_footer>
                <div class="col col-12">
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </div>
            </cf_box_footer>
        </cf_box>
    </cfform>
</div>
<script type="text/javascript">
function kontrol()
{
	if (add_app_pos.app_position.value.length == 0) add_app_pos.position_id.value = "";
	if (add_app_pos.position_cat.value.length == 0) add_app_pos.position_cat_id.value = "";
	if ( (add_app_pos.notice_id.value.length==0) && (add_app_pos.position_id.value.length == 0) && (add_app_pos.position_cat_id.value.length == 0) )
		{
			alert("<cf_get_lang dictionary_id='56179.Pozisyon Veya İlan Seçmelisiniz'> !");
			return false;
		}

	if ((document.add_app_pos.detail_app.value.length)>1000)
	{
		alert("<cf_get_lang dictionary_id='56180.Ön yazı alanının uzunluğu 1000 karakterden az olmalıdır'>!");
		return false;
	}
	document.add_app_pos.salary_wanted.value = filterNum(document.add_app_pos.salary_wanted.value);
	/*aşama kontrol return process_cat_control();*/
	return true;
}
</script>


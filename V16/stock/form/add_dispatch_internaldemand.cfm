<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cf_catalystHeader>
<cf_papers paper_type="SHIP_INTERNAL" increase="1">
<div class="col col-12 col-xs-12">
    <cf_box>
        <div id="basket_main_div">
            <cfform name="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_dispatch_internaldemand">
                <cf_basket_form id="add_dispatch_internaldemand">
                    <cfoutput>
                        <input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_dispatch_internaldemand">
                        <input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
                        <input type="hidden" name="search_process_date" id="search_process_date" value="ship_date">
                        <input type="hidden" name="company_id" id="company_id" value="-1">
                    </cfoutput>   	
                    <cf_box_elements>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-form_ul_process_stage">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_ship_internal_number">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'>*</label>
								<div class="col col-8 col-xs-12">
									<cfif isdefined("paper_full")>
										<cfinput type="text" name="ship_internal_number" value="#paper_full#" required="Yes" mmaxlength="50"  onBlur="paper_control(this,'SHIP_INTERNAL',true);">
									<cfelse>
										<cfinput type="text" name="ship_internal_number" value="" required="Yes"  maxlength="50"  onBlur="paper_control(this,'SHIP_INTERNAL',true);">					
									</cfif>  
								</div>
							</div>
                            <div class="form-group" id="item-location_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29428.Çıkış Depo'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrkdepartmentlocation
                                    returnInputValue="location_id,txt_departman_,department_id,branch_id"
                                    returnInputQuery="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                    fieldName="txt_departman_"
                                    fieldid="location_id"
                                    department_fldId="department_id"
                                    user_level_control="0"
                                    line_info="1"
                                    is_store_kontrol = "0"
                                    width="150">
                                </div>
                            </div>
                            <div class="form-group" id="item-location_in_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56969.Giriş Depo'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cfset search_dep_id = listgetat(session.ep.user_location, 1, '-')>
                                    <cfinclude template="../query/get_dep_names_for_inv.cfm">
                                    <cfinclude template="../query/get_default_location.cfm">
                                    <cfif get_loc.recordcount and get_name_of_dep.recordcount>
                                        <cfset txt_department_name = get_name_of_dep.department_head & '-' & get_loc.comment>
                                    <cfelse>
                                    <cfset txt_department_name = "" >
                                    </cfif>							
                                    <cfif get_loc.recordcount and get_name_of_dep.recordcount>
                                        <cf_wrkdepartmentlocation
                                            returnInputValue="location_in_id,department_in_txt,department_in_id,branch_id"
                                            returnInputQuery="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                            fieldName="department_in_txt"
                                            fieldid="location_in_id"
                                            department_fldId="department_in_id"
                                            department_id="#search_dep_id#"
                                            location_id="#get_loc.location_id#"
                                            location_name="#txt_department_name#"
                                            user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                            line_info="2"
                                            width="150">
                                    <cfelseif isdefined('attributes.department_in') and len(attributes.department_in) and len(attributes.location_in)>
                                            <cfset location_info_ = get_location_info(attributes.department_in,attributes.location_in)>
                                            <cf_wrkdepartmentlocation
                                                returnInputValue="location_in_id,department_in_txt,department_in_id,branch_id"
                                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                                fieldName="department_in_txt"
                                                fieldid="location_in_id"
                                                department_fldId="department_in_id"
                                                department_id="#attributes.department_in#"
                                                location_id="#attributes.location_in#"
                                                location_name="#location_info_#"
                                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                                line_info="2"
                                                width="150">
                                    <cfelse>                                   
                                            <cf_wrkdepartmentlocation
                                                returnInputValue="location_in_id,department_in_txt,department_in_id,branch_id"
                                                returnInputQuery="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                                fieldName="department_in_txt"
                                                fieldid="location_in_id"
                                                department_fldId="department_in_id"
                                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                                line_info="2"
                                                width="150">
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-deliver_date_frm">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57009.Fiili Sevk Tarihi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfinput type="text" validate="#validate_style#" name="deliver_date_frm" value="" message="#getLang('','Fiili Sevk Tarihi Girmelisiniz',41841)#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date_frm"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-ship_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfinput type="text" required="Yes" maxlength="10"  validate="#validate_style#" name="ship_date" value="#dateformat(now(),dateformat_style)#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="ship_date"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-ship_method">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="ship_method" id="ship_method" value="">
                                        <input type="text" name="ship_method_name" id="ship_method_name" value="" readonly>
                                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','','ui-draggable-box-small');"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                            <div class="form-group" id="item-detail">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea style="height:75px; width:175px" name="detail" id="detail" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#getLang('','Fazla Karakter Sayısı',29484)#</cfoutput>"></textarea>
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                    <cf_box_footer>
                        <cf_workcube_buttons is_upd='0' add_function="control_depo()">
                    </cf_box_footer>
                </cf_basket_form>
                                            
                <cfif session.ep.isBranchAuthorization>
                    <cfset attributes.basket_id = 45>
                <cfelse>
                    <cfset attributes.basket_id = 44>
                </cfif>
                <cfif not isdefined('attributes.type')>
                    <cfset attributes.form_add = 1>
                </cfif>
                <cfinclude template="../../objects/display/basket.cfm">
            </cfform>
        </div>
    </cf_box>
</div>
<script type="text/javascript">
function control_depo()
{
        if(!paper_control(form_basket.ship_internal_number,'SHIP_INTERNAL',true)) return false;
	   if(form_basket.txt_departman_.value=="" || form_basket.department_id.value=="")
		{
		   alert("<cf_get_lang dictionary_id='45602.Çıkış Deposunu Seçmelisiniz'>!");
		   return false;
		}
		if(form_basket.department_in_txt.value=="" || form_basket.department_in_id.value=="")
		{
		    alert("<cf_get_lang dictionary_id='45601.Giriş Deposunu Seçmelisiniz'>!");
			return false;
		}
		if(form_basket.department_in_id.value == form_basket.department_id.value && form_basket.location_in_id.value == form_basket.location_id.value)
		{
			alert("<cf_get_lang dictionary_id='45351.Giriş ve Çıkış Depoları Aynı Olamaz'>!");
			return false;
		}
		else
		return (process_cat_control() && saveForm());
		
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
<!---<cfsavecontent variable="header_"><cf_get_lang_main no='1447.Süreç'></cfsavecontent>--->
<!---<cfsavecontent variable="header_"><cf_get_lang no='127.Fiili Sevk Tarihi'></cfsavecontent>--->
<!---<cfsavecontent variable="header_"><cf_get_lang_main no ='217.Açıklama'></cfsavecontent>--->
<!---<cfsavecontent variable="header_"><cf_get_lang_main no='1631.Çıkış Depo'></cfsavecontent>--->
<!---<cfsavecontent variable="header_"><cf_get_lang no='96.Giriş Depo'></cfsavecontent>--->
<!---<cfsavecontent variable="header_"><cf_get_lang_main no='330.Tarih'></cfsavecontent>--->
<!---<cfsavecontent variable="header_"><cf_get_lang_main no='1703.Sevk Yontemi'></cfsavecontent>--->
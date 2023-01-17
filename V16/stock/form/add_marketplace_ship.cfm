<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<div id="basket_main_div">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_marketplace_ship">
            <cf_basket_form id="marketplace_ship">
            
                <input type="hidden" name="form_action_address" id="form_action_address" value="<cfoutput>#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_marketplace_ship</cfoutput>">
                <input type="hidden" name="search_process_date" id="search_process_date" value="ship_date">
                <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
            
                <cf_box_elements>
                    <div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="1">
                        <div class="form-group" id="item-process_cat">			
                            <label class="col col-4"><cf_get_lang dictionary_id='57800.Operasyon Tipi'></label>
                            <div class="col col-8">
                                <cf_workcube_process_cat>
                            </div>
                        </div> 
                        <div class="form-group" id="item-ship_number">
                            <label class="col col-4"><cf_get_lang dictionary_id='58138.İrsaliye No'>*</label>
                            <div class="col col-8">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='41835.İrsaliye No Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="ship_number" style="width:115px;" maxlength="50" required="Yes" message="#message#">
                            </div>
                        </div>  
                        <div class="form-group" id="item-ship_method">
                            <label class="col col-4"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
                            <div class="col col-8">
                                <div class="input-group">
                                    <input type="hidden" name="ship_method" id="ship_method" value="">
                                    <cfinput type="text" readonly name="ship_method_name" style="width:150px;" value="" >
                                    <span class="input-group-addon icon-ellipsis btnPointer"  onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method');"></span>
                                </div>
                            </div>
                        </div> 
                    </div>
                    <div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="2">
                        <div class="form-group" id="item-comp_name">
                            <label class="col col-4"><cf_get_lang dictionary_id='57519.Cari Hesap'>*</label>
                            <div class="col col-8">
                                <div class="input-group">
                                    <input type="hidden" name="company_id" id="company_id" <cfif isdefined("attributes.company_id")>value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
                                    <input type="text" name="comp_name" id="comp_name" style="width:150px;" readonly="" <cfif isdefined("attributes.comp_name")>value="<cfoutput>#attributes.comp_name#</cfoutput>"</cfif>>
                                    <span class="input-group-addon icon-ellipsis btnPointer" href="#" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_name=form_basket.partner_name&field_partner=form_basket.partner_id&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&come=stock&var_new=ship<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>');"></span>
                                </div>    
                            </div>
                        </div>
                        <div class="form-group" id="item-ship_date">
                            <label class="col col-4"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
                            <div class="col col-8">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'></cfsavecontent>
                                    <cfinput type="text" name="ship_date" value="#dateformat(now(),dateformat_style)#" style="width:115px;" validate="#validate_style#" message="#message#" readonly onblur="change_money_info('form_basket','ship_date');">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="ship_date" call_function="change_money_info"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-location_id">
                            <label class="col col-4"><cf_get_lang dictionary_id='58763.Depo'>*</label>
                            <div class="col col-8">   
                            <cf_wrkdepartmentlocation 
                                returnInputValue="location_id,txt_departman_,department_id,branch_id"
                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                fieldName="txt_departman_"
                                fieldId="location_id"
                                department_fldId="department_id"
                                branch_fldId="branch_id"
                                width="150">    
                            </div>
                        </div>
                    </div> 
                    <div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="3">
                        <div class="form-group" id="item-partner_name">
                            <label class="col col-4"><cf_get_lang dictionary_id='57578.Yetkili'></label>
                            <div class="col col-8">
                                <input type="hidden" name="partner_id" id="partner_id" <cfif isdefined("attributes.partner_id")>value="<cfoutput>#attributes.partner_id#</cfoutput>"</cfif>>
                                <input type="hidden" name="consumer_id" id="consumer_id">
                                <input type="text" name="partner_name" id="partner_name" style="width:150px;" readonly="">
                            </div>
                        </div>   
                        <div class="form-group" id="item-deliver_date_frm">
                            <label class="col col-4"><cf_get_lang dictionary_id='34140.Fiili Sevk Tarihi'></label>
                            <div class="col col-8">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='41841.Fiili Sevk Tarihi Girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="deliver_date_frm" value="#dateformat(now(),dateformat_style)#" style="width:115px;" required="yes" message="#message#" validate="#validate_style#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date_frm"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-deliver_date_frm">
                            <label class="col col-4"><cf_get_lang dictionary_id='57775.Teslim Alan'></label>
                            <div class="col col-8">
                                <div class="input-group">        
                                    <input type="hidden" name="deliver_get_id" id="deliver_get_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                                    <cfinput type="text" name="deliver_get" style="width:150px;"  readonly value="#get_emp_info(session.ep.userid,0,0)#">
                                    <span class="input-group-addon icon-ellipsis btnPointer" href="#" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.deliver_get&field_emp_id2=form_basket.deliver_get_id</cfoutput>')"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons is_upd='0' add_function='kontrol_firma()'>
                </cf_box_footer>
            </cf_basket_form>
            <cfset attributes.basket_id = 40 >
            <cfset attributes.form_add = 1 >
            <cfinclude template="../../objects/display/basket.cfm">
        </cfform>
    </cf_box>
</div>


<script type="text/javascript">
	function kontrol_firma()
	{
		if(!chk_process_cat('form_basket')) return false;
		if(form_basket.partner_id.value =="" && form_basket.consumer_id.value =="")
		{
			alert("<cf_get_lang dictionary_id='33557.Cari Hesap Seçmelisiniz'> !");
			return false;
		}
		saveForm();
        return false;
	}
	function hal_irs_tip_sec()
	{
		max_sel = form_basket.process_cat.options.length;
		for(my_i=0;my_i<=max_sel;my_i++)
		{
			if(form_basket.process_cat.options[my_i]!=undefined)
			{
				deger = form_basket.process_cat.options[my_i].value;
				if(deger!="")
				{
					var fis_no = eval("form_basket.ct_process_type_" + deger );
					if(fis_no.value == 761)
					{
						form_basket.process_cat.options[my_i].selected = true;
						my_i = max_sel + 1;
					}
				}
			}
		}
	}
	hal_irs_tip_sec();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

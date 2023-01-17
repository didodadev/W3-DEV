<cfparam name="attributes.req_id" default="">
<cfparam name="attributes.plan_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.author_id" default="">
<cfparam name="attributes.date_start" default="">
<cfparam name="attributes.date_end" default="">
<cfparam name="attributes.author_title" default="">
<cfparam name="attributes.project_title" default="">
<cfparam name="attributes.project_emp_id" default="">
<cfparam name="attributes.emp_name" default="">
<!---<cfif not isdefined("attributes.project_emp_id")>
	<cfset attributes.project_emp_id = session.ep.userid>
	<cfset attributes.emp_name = get_emp_info(session.ep.userid,0,0)>
</cfif>--->

<cfobject name="product_plan" component="WBP.Fashion.files.cfc.product_plan">
<cfset product_plan.dsn3 = dsn3>
<cfset query_product_plan=product_plan.list_productplan(attributes.plan_id)>

<cfif len(query_product_plan.task_emp)>
	<cfset attributes.project_emp_id = query_product_plan.task_emp>
	<cfset attributes.emp_name = get_emp_info(query_product_plan.task_emp,0,0)>
</cfif>
<cf_catalystHeader>
<cfform name="plan"  method="post" action="#request.self#?fuseaction=textile.emptypopup_upd_product_plan">
    <input type="hidden" name="referel_page" value="product_plan">
    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <!--- col 1 --->
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-stretching_test_id">
                            <label class="col col-4 col-xs-12">Ürün Plan No</label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="plan_no" id="plan_no" value="<cfoutput>#attributes.plan_id#</cfoutput>" disabled="disabled">
                                <input type="hidden" name="plan_id" id="plan_id" value="<cfoutput>#attributes.plan_id#</cfoutput>">
                            </div>
                        </div>
                        <div class="form-group" id="item-order_id">
                            <label class="col col-4 col-xs-12">Numune No</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="req_id" id="req_id" value="<cfoutput>#query_product_plan.req_id#</cfoutput>">
                                    <input type="text" name="req_no" id="req_no" style="width:140px;" readonly="" value="<cfoutput>#query_product_plan.req_no#</cfoutput>">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-emp_name" >
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='157.Görevli'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="project_emp_id" id="project_emp_id"  value="#attributes.project_emp_id#">
                                     <cfinput type="text" name="emp_name" id="emp_name" value="#attributes.emp_name#"  onFocus="AutoComplete_Create('emp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0,0','PARTNER_ID,EMPLOYEE_ID','outsrc_partner_id,project_emp_id','plan','3','250');">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:gonder2('plan.emp_name');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--- col 2 --->
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-">
                            <label class="col col-4 col-xs-12">Tarih</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
                                    <input type="text" name="plan_date" id="plan_date" value="<cfoutput>#dateformat(query_product_plan.plan_date,dateformat_style)#</cfoutput>" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="plan_date"></span>
                                </div>
                            </div>
                        </div>
						<div class="form-group" id="item-project_id">
                            <label class="col col-4 col-xs-12">Proje No</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="">
                                    <input name="project_head" type="text" id="project_head" value="" readonly="">
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--- col 3 --->
                   <!--- col 2 --->
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-">
                            <label class="col col-4 col-xs-12">Başlangıç Tarih</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
                                    <input type="text" name="date_start" id="date_start" value="<cfoutput>#dateformat(query_product_plan.start_date,dateformat_style)#</cfoutput>" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="date_start"></span>
                                </div>
                            </div>
                        </div>
						<div class="form-group" id="item-project_id">
                            <label class="col col-4 col-xs-12">Bitiş Tarih</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
                                    <input type="text" name="date_finish" id="date_finish" value="<cfoutput>#dateformat(query_product_plan.finish_date,dateformat_style)#</cfoutput>" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="date_finish"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--- col 4 --->
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                        <div class="form-group" id="item-purchasing_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1447.Süreç'> *</label>
                            <div class="col col-8 col-xs-12">
                               <cf_workcube_process is_upd='0' select_value='#query_product_plan.stage_id#' process_cat_width='140' is_detail='1'>
                            </div>
                        </div>
						<div class="form-group" id="item-purchasing_id">
							<div class="col col-8 col-xs-12">
									<cf_basket_form_button>
										<cf_record_info query_name="query_product_plan">
											<cf_workcube_buttons is_upd='1' is_delete=1 add_function='kontrol()' del_function='kontrol2()'>	
										</cf_basket_form_button>
									
							</div>
						 </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</cfform>
<cfset attributes.req_id=query_product_plan.req_id>

        <cfif query_product_plan.is_fabric_plan eq 1>
                <cfsavecontent variable="message1">Kumaş Detayları<!---<cf_get_lang_main no="1731.Tedarikçiler">---></cfsavecontent>
                <cf_box id="list_supplier_k"
                    box_page="#request.self#?fuseaction=textile.emptypopup_ajax_req_supplier&tableid=list_supplier_k&req_id=#attributes.req_id#&req_type=0&default_station=3&product_plan=1&plan_id=#attributes.plan_id#"
                    title="#message1#"
                    closable="0">
                </cf_box>
            </cfif>
    
        <cfif query_product_plan.is_accessory_plan eq 1>
			<cfset attributes.product_edit=1>

                <cfsavecontent variable="message2">Aksesuar Detayları<!---<cf_get_lang_main no="1731.Tedarikçiler">---></cfsavecontent>
                <cf_box id="list_supplier_a"
                    box_page="#request.self#?fuseaction=textile.emptypopup_ajax_req_supplier_a&tableid=list_supplier_a&req_id=#attributes.req_id#&req_type=1&product_plan=1&plan_id=#attributes.plan_id#"
                    title="#message2#"
                    closable="0">
                </cf_box>
        </cfif>

        <script>
            function gonder2(str_alan_1)
                {
                    str_list = '';
                       /* str_list = str_list+'branch_id='+document.getElementById("branch_id").value;
                        str_list = str_list+'&department_id='+document.getElementById("department").value;*/
                    windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=plan.project_emp_id&'+str_list+'&field_name=plan.emp_name <cfif isdefined("xml_only_employee") and xml_only_employee eq 0>&field_partner=plan.outsrc_partner_id</cfif>&select_list=1,2&is_form_submitted=1&keyword='+encodeURIComponent(plan.emp_name.value),'list');
                }
        </script>
          

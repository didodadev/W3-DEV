<style>
	.ui-multiselect-checkboxes ul,.ui-multiselect-checkboxes li{
		width:300px;
	}
	 .ui-widget-content ul,.ui-widget-content div
	{
		width:300px;
	}
</style>
<cfparam name="attributes.product_size" default="">	
<cfparam name="attributes.color_size" default="">
<cfparam name="attributes.prop_id" default="">		

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

<cfobject name="product_plan" component="WBP.Fashion.files.cfc.product_plan">
<cfset product_plan.dsn3 = dsn3>
<cfset query_product_plan=product_plan.list_productplan(attributes.plan_id)>

<cfif len(query_product_plan.task_emp)>
	<cfset attributes.project_emp_id = query_product_plan.task_emp>
	<cfset attributes.emp_name = get_emp_info(query_product_plan.task_emp,0,0)>
</cfif>


<cfscript>
	CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.get_sample_request");
    getSize = CreateCompenent.getSize(prop_id:#attributes.prop_id#);
	CreateCompenentWash = CreateObject("component","WBP.Fashion.files.cfc.wash_plan");
    getWashType=CreateCompenentWash.getWashType();
	list_washplan=CreateCompenentWash.list_washplan(
						plan_id:attributes.plan_id,
						req_id:attributes.req_id
	);
</cfscript>

<cf_catalystHeader>
    <cfquery name="get_kuru_islem" dbtype="query">
        select *from  getWashType WHERE wash_type_id=0
    </cfquery>
	    <cfquery name="get_kumas" dbtype="query">
        select *from  getWashType WHERE wash_type_id=1
    </cfquery>
	    <cfquery name="get_cresh" dbtype="query">
        select *from  getWashType WHERE wash_type_id=2
    </cfquery>
	  <cfquery name="get_recine" dbtype="query">
        select *from  getWashType WHERE wash_type_id=3
    </cfquery>
		<cfquery name="get_lokal" dbtype="query">
        select *from  getWashType WHERE wash_type_id=4
    </cfquery>
	  <cfquery name="get_kimyasal" dbtype="query">
        select *from  getWashType WHERE wash_type_id=5
    </cfquery>
	
	 <cfquery name="get_kuru_islem_value" dbtype="query">
        select *from  list_washplan WHERE wash_type=0
    </cfquery>
	    <cfquery name="get_kumas_value" dbtype="query">
        select *from list_washplan WHERE wash_type=1
    </cfquery>
	    <cfquery name="get_cresh_value" dbtype="query">
        select *from list_washplan WHERE wash_type=2
    </cfquery>
	  <cfquery name="get_recine_value" dbtype="query">
        select *from list_washplan WHERE wash_type=3
    </cfquery>
		<cfquery name="get_lokal_value" dbtype="query">
        select *from list_washplan WHERE wash_type=4
    </cfquery>
	  <cfquery name="get_kimyasal_value" dbtype="query">
        select *from list_washplan WHERE wash_type=5
    </cfquery>

<cfform name="plan"  method="post" action="#request.self#?fuseaction=textile.emptypopup_upd_product_plan">
				<!----   
				<!-----kunye---->
				
				<div class="row">
					<div class="col col-9 col-xs-12 ">
							<cf_box id="sample_request" closable="0" unload_body = "1"  title="Numune Özet" >	
								<cfinclude template="../V16/sales/query/get_opportunity_type.cfm">
								<cfinclude template="../display/dsp_sample_request.cfm">
							</cf_box>
					</div>
					<div class="col col-3 col-xs-12 ">
					<cfinclude template="../../objects/display/asset_image.cfm">
					</div>
				</div>
				<!------kunye----------->  
				   ---->
				   
				   
				<input type="hidden" name="referel_page" value="wash_plan">
				<div class="row">
					<div class="col col-12 uniqueRow">
						<div class="row formContent">
							<div class="row" type="row">
								<!--- col 1 --->
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
									<div class="form-group" id="item-stretching_test_id">
										 <label class="col col-4 col-xs-12">Yıkama İşlem No</label>
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
												<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#query_product_plan.project_id#</cfoutput>">
												<input name="project_head" type="text" id="project_head" value=" <cfoutput>#get_project_name(project_id:query_product_plan.project_id)#</cfoutput>" readonly="">
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
									
								</div>
							</div>
						</div>
					</div>
				</div>
			
			


	<input type="hidden" name="process_count" id="process_count" value="6">
    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-project_id">
                            <label class="col col-4 col-xs-12">Kuru İşlem</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cf_multiselect_check
                                    name="islem0"
                                    query_name="get_kuru_islem"
									  width="300"
									    height="300"
                                    option_name="wash_detail"
                                    option_value="wash_id"
                                    option_text="İşlem Seçiniz"
                                    value="#valueList(get_kuru_islem_value.WASH_VALUE)#">
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-author_id">
                            <label class="col col-4 col-xs-12">Kumaş</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cf_multiselect_check
                                    name="islem1"
                                    query_name="get_kumas"
                                    option_name="wash_detail"
								    width="300"
								    height="300"
                                    option_value="wash_id"
                                    option_text="İşlem Seçiniz"
                                    value="#valueList(get_kumas_value.WASH_VALUE)#">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-test_date_start">
                            <label class="col col-4 col-xs-12">Crash</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cf_multiselect_check
                                    name="islem2"
                                     query_name="get_cresh"
                                     option_name="wash_detail"
									   width="300"
								      height="300"
                                    option_value="wash_id"
                                     option_text="İşlem Seçiniz"
                                    value="#valueList(get_cresh_value.WASH_VALUE)#">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                        <div class="form-group" id="item-test_date_end">
                            <label class="col col-4 col-xs-12">Recine</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cf_multiselect_check
                                    name="islem3"
                                    query_name="get_recine"
                                     option_name="wash_detail"
                                    option_value="wash_id"
									  width="300"
								      height="300"
                                     option_text="İşlem Seçiniz"
                                    value="#valueList(get_recine_value.WASH_VALUE)#">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
                        <div class="form-group" id="item-test_date_start">
                            <label class="col col-4 col-xs-12">Lokal Uygulama</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cf_multiselect_check
                                    name="islem4"
                                    query_name="get_lokal"
                                    option_name="wash_detail"
                                    option_value="wash_id"
									  width="300"
								      height="300"
                                    option_text="İşlem Seçiniz"
                                     value="#valueList(get_lokal_value.WASH_VALUE)#">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="6" sort="true">
                        <div class="form-group" id="item-test_date_start">
                            <label class="col col-4 col-xs-12">Kimyasal</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cf_multiselect_check
                                    name="islem5"
                                    query_name="get_kimyasal"
                                    option_name="wash_detail"
                                    option_value="wash_id"
									  width="300"
								      height="300"
                                    option_text="İşlem Seçiniz"
                                    value="#valueList(get_kimyasal_value.WASH_VALUE)#">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row formContentFooter">
                    <div class="col col-12" >
                        <!---<cf_workcube_buttons is_upd='0' add_function='control()' >--->
						<cf_basket_form_button>
						<cf_record_info query_name="query_product_plan">
						<cf_workcube_buttons is_upd='1' is_delete=0 add_function='kontrol()' del_function='kontrol2()'>	
						</cf_basket_form_button>
                    </div>
                </div>
            </div>
        </div>
    </div>

</cfform>
  <script>
            function gonder2(str_alan_1)
                {
                    str_list = '';
                       /* str_list = str_list+'branch_id='+document.getElementById("branch_id").value;
                        str_list = str_list+'&department_id='+document.getElementById("department").value;*/
                    windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=plan.project_emp_id&'+str_list+'&field_name=plan.emp_name <cfif isdefined("xml_only_employee") and xml_only_employee eq 0>&field_partner=plan.outsrc_partner_id</cfif>&select_list=1,2&is_form_submitted=1&keyword='+encodeURIComponent(plan.emp_name.value),'list');
                }
        </script>

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

<cfobject name="product_plan" component="addons.n1-soft.textile.cfc.product_plan">
<cfset product_plan.dsn3 = dsn3>
<cfset query_product_plan=product_plan.list_productplan(attributes.plan_id)>

<cfif len(query_product_plan.task_emp)>
	<cfset attributes.project_emp_id = query_product_plan.task_emp>
	<cfset attributes.emp_name = get_emp_info(query_product_plan.task_emp,0,0)>
</cfif>

<!---künye numune özet--->
<cfset attributes.req_id=query_product_plan.req_id>
<cfinclude template="../query/get_req.cfm">
<cfscript>
	CreateCompenent = CreateObject("component","AddOns.N1-Soft.textile.cfc.get_sample_request");
	getAsset=CreateCompenent.getAssetRequest(action_id:#attributes.req_id#,action_section:'REQ_ID');
</cfscript>
<!---künye numune özet--->

<cfset pageHead = " #getlang('textile',22)#: (#query_product_plan.req_no#)">
<cfsavecontent variable="title">
	<cfoutput>#getlang('textile',22)#</cfoutput> No
</cfsavecontent>
<cfset referel_page="marker_plan">
<cf_catalystHeader>
    <br/><br/><br/><br/>
<div class="row">
 <div class="col col-12">
	<div class="col col-10 col-xs-12 uniqueRow">
	<cf_box title="Pastal">
		<cfform name="plan"  method="post" action="#request.self#?fuseaction=textile.emptypopup_upd_product_plan">
			<cfinclude template="plan_form.cfm">
			<div class="row formContentFooter">
				<div class="col col-6"><cf_record_info query_name="query_product_plan"></div>
				<div class="col col-6">
					<cf_basket_form_button>
						
							<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()' del_function='kontrol2()'>	
					</cf_basket_form_button>
				</div>
			</div>
	</cfform>
	</cf_box>
</div>
	<div class="col col-2 col-xs-12 ">
		<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-3" module_id='99' action_section='MARKER_PLAN_ID' action_id='#plan_id#'>
	</div>
</div>
<div class="col col-12">
			<cf_box id="sample_request" closable="0" unload_body = "1"  title="Numune Özet" >
				<div class="col col-10 col-xs-12 ">
						
						<cfinclude template="/V16/sales/query/get_opportunity_type.cfm">
						<cfinclude template="../display/dsp_sample_request.cfm">
					
				</div>
				<div class="col col-2 col-xs-2">
					<cfinclude template="../../objects/display/asset_image.cfm">
				</div>
			</cf_box>
		</div>

            <script>
                function gonder2(str_alan_1)
                    {
                        str_list = '';
                           /* str_list = str_list+'branch_id='+document.getElementById("branch_id").value;
                            str_list = str_list+'&department_id='+document.getElementById("department").value;*/
                        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=plan.project_emp_id&'+str_list+'&field_name=plan.emp_name <cfif isdefined("xml_only_employee") and xml_only_employee eq 0>&field_partner=plan.outsrc_partner_id</cfif>&select_list=1,2&is_form_submitted=1&keyword='+encodeURIComponent(plan.emp_name.value),'list');
					}
					function kontrol()
					{
						var oldstage='<cfoutput>#query_product_plan.stage_id#</cfoutput>';
                        var taskempid=$('#project_emp_id').val();
                        if($('#old_process_line').val()=='1' && oldstage!=$('#process_stage').val())
                        {
                            if(taskempid=='')
                            {
                                alert('Görevli Seçiniz!');
                                return false;    
                            }
                            
                        }
						return process_cat_control();
					}
            </script>
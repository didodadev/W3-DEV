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




<cfsavecontent variable="title">
	Aksesuar Fiyat Talep No
</cfsavecontent>
<cfset referel_page="accessory_price">
<cf_catalystHeader>
<br/><br/><br/><br/>
<div class="row">

		<div class="col col-12">
			<div class="col col-12 col-xs-12 uniqueRow">
				<cf_box title="Fiyat Talep">
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
		
		
<cfif len(attributes.project_emp_id)>
<div class="col col-12">
  <!---<cfif get_module_user(75)>
                <cfsavecontent variable="message1">Kumaş Fiyat Talepleri<!---<cf_get_lang_main no="1731.Tedarikçiler">---></cfsavecontent>
                <cf_box id="list_supplier_k"
                    box_page="#request.self#?fuseaction=textile.emptypopup_ajax_req_supplier&tableid=list_supplier_k&req_id=#attributes.req_id#&req_type=0&default_station=3&price_plan=1"
                    title="#message1#"
                    closable="0">
                </cf_box>
            </cfif>--->
			<cfset attributes.product_edit=1>

                <cfsavecontent variable="message2">Aksesuar Fiyat Talepleri<!---<cf_get_lang_main no="1731.Tedarikçiler">---></cfsavecontent>
                <cf_box id="list_supplier_a"
                    box_page="#request.self#?fuseaction=textile.emptypopup_ajax_req_supplier_a&tableid=list_supplier_a&req_id=#attributes.req_id#&req_type=1&price_plan=1&plan_id=#attributes.plan_id#"
                    title="#message2#"
                    closable="0">
                </cf_box>

</div>
</cfif>
	<form name="aktar_form" method="post">
    <input type="hidden" name="list_price" id="list_price" value="0">
    <input type="hidden" name="price_cat" id="price_cat" value="">
    <input type="hidden" name="CATALOG_ID" id="CATALOG_ID" value="">
    <input type="hidden" name="NUMBER_OF_INSTALLMENT" id="NUMBER_OF_INSTALLMENT" value="">
    <input type="hidden" name="convert_stocks_id" id="convert_stocks_id" value="">
    <input type="hidden" name="convert_amount_stocks_id" id="convert_amount_stocks_id" value="">
    <input type="hidden" name="convert_price" id="convert_price" value="">
    <input type="hidden" name="convert_price_other" id="convert_price_other" value="">
    <input type="hidden" name="convert_money" id="convert_money" value="">
    <input type="hidden" name="convert_relation_id" id="convert_relation_id" value="">
    <input type="hidden" name="convert_row_detail" id="convert_row_detail" value="">
    <input type="hidden" name="convert_action_id" id="convert_action_id" value="<cfoutput>#attributes.plan_id#</cfoutput>">
</form>


          
            <script>
                function gonder2(str_alan_1)
                    {
                        str_list = '';
                           /* str_list = str_list+'branch_id='+document.getElementById("branch_id").value;
                            str_list = str_list+'&department_id='+document.getElementById("department").value;*/
                        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=plan.project_emp_id&'+str_list+'&field_name=plan.emp_name <cfif isdefined("xml_only_employee") and xml_only_employee eq 0>&field_partner=plan.outsrc_partner_id</cfif>&select_list=1,2&is_form_submitted=1&keyword='+encodeURIComponent(plan.emp_name.value),'list');
                    }
					function gondertalep(form_name)
                        {
                            //İç Talep Oluştur
						
                            var convert_list ="";
                            var convert_list_amount ="";
                            var convert_list_price ="";
                            var convert_list_price_other="";
                            var convert_list_money ="";
                            var convert_date_list="";
                            var convert_relation_id="";
                            var convert_row_detail = "";
                            var dep_="";
                            var to_emp="";

						for(r=1;r<=row_count_;r++)		
						{
                                deger_member_id = eval("document."+form_name+".company_id"+r);
                                deger_stock_id = eval("document."+form_name+".stock_id"+r);
                                deger_internal_id=eval("document."+form_name+".i_id"+r);
								
								if(deger_stock_id!=undefined && deger_internal_id!=undefined && deger_internal_id.value.length==0 && deger_stock_id.value.length>0)
								{
                                    deger_workstation_id = eval("document."+form_name+".work_station"+r);
                                    deger_pcat_id = eval("document."+form_name+".category"+r);
                                    deger_pcat = eval("document."+form_name+".category_name"+r);
                                    deger_amount = eval("document."+form_name+".quantity"+r);
                                    deger_rowid = eval("document."+form_name+".rowid"+r);
									amount=filterNum(deger_amount.value); 
										
									if(parseFloat(amount)==0 || amount=='')
									amount=1;
									convert_list +=deger_stock_id.value+',';
									convert_list_amount += amount+',';
									convert_list_price_other +='0,';
									convert_list_price +='0,';
									convert_list_money +='TL,';
									convert_relation_id+=deger_rowid.value+',';
								}
						}
                           
                            document.getElementById('convert_stocks_id').value=convert_list;
                            document.getElementById('convert_amount_stocks_id').value=convert_list_amount;
                            document.getElementById('convert_price').value=convert_list_price;
                            document.getElementById('convert_price_other').value=convert_list_price_other;
                            document.getElementById('convert_money').value=convert_list_money;
                            document.getElementById('convert_relation_id').value=convert_relation_id;
                            document.getElementById('convert_row_detail').value = convert_row_detail;

						 
                            if(convert_list)//Ürün Seçili ise
                                {
                                    dep_id="";
                                    loc_id="";
                                    if(dep_.length>0)
                                    {
                                        dep_id=list_getat(dep_,1,'-');
                                        loc_id=list_getat(dep_,2,'-');
                                        dep_id=parseInt(dep_id);
                                        loc_id=parseInt(loc_id);
                                    }
                                
                                
                                    windowopen('','wide','cc_paym');
                            url="<cfoutput>#request.self#?fuseaction=purchase.list_internaldemand&event=add&type=convert&project_id=#query_product_plan.project_id#</cfoutput>";
                                  <!---  if(tip==0)
                            url+='&ref_no=<cfoutput>#get_order_row.order_number#</cfoutput>&to_position_code='+to_emp+'&department_out='+dep_id+'&location_out='+loc_id+'&department_in='+dep_id+'&location_in='+loc_id+'&stage=-2&subject='+encodeURI(konu);
                                   --->         
                                    aktar_form.action=url;1
                                    aktar_form.target='cc_paym';
                                    aktar_form.submit();
                                }
                                else
                                alert("Aktarılacak Stok Bulunamadı!.");

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


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
<cfinclude template="../../common/get_opportunity_type.cfm">

<cfif len(query_product_plan.task_emp)>
	<cfset attributes.project_emp_id = query_product_plan.task_emp>
	<cfset attributes.emp_name = get_emp_info(query_product_plan.task_emp,0,0)>
</cfif>

<!---künye numune özet--->
<cfset attributes.req_id=query_product_plan.req_id>
<cfinclude template="../query/get_req.cfm">
<cfscript>
	CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.get_sample_request");
	getAsset=CreateCompenent.getAssetRequest(action_id:#attributes.req_id#,action_section:'REQ_ID');
</cfscript>
<!---künye numune özet--->
<!---<cfset pageHead = " #getlang('textile',23)#: (#query_product_plan.req_no#)">--->
<cfsavecontent variable="title">
	Modelhane İşlem No
</cfsavecontent>
<cfset referel_page="pattern_plan">

<cf_catalystHeader>
 
<div class="row">
 <div class="col col-12">
	<div class="col col-9 col-xs-12 uniqueRow">
	<cf_box title="Modelhane">
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
<div class="col col-3 col-xs-12 ">
	<cfquery name="get_mold_planid" datasource="#dsn3#">
		select *from TEXTILE_PRODUCT_PLAN
		where REQUEST_ID=#attributes.req_id#
	</cfquery>
	<cf_get_workcube_asset title="Kalıp" company_id="#session.ep.company_id#" asset_cat_id="-3" module_id='99' action_section='REQUEST_ID' action_id='#attributes.req_id#'>
</div>
</div>
<div class="col col-12">
			<cf_box id="sample_request" closable="0" unload_body = "1"  title="Numune Özet" >
				<div class="col col-10 col-xs-12 ">
						
						
						<cfinclude template="../display/dsp_sample_request.cfm">
					
				</div>
				<div class="col col-2 col-xs-2">
					<cfinclude template="../../objects/display/asset_image.cfm">
				</div>
			</cf_box>
		</div>
<cfif  len(attributes.project_emp_id)>
    <div class="col col-12">
              <cfsavecontent variable="message1">Kumaş Detayları</cfsavecontent>
                    <cf_box id="list_supplier_k"
                        box_page="#request.self#?fuseaction=textile.emptypopup_ajax_req_supplier&tableid=list_supplier_k&req_id=#attributes.req_id#&req_type=0&default_station=3&modelhouse_plan=1&plan_id=#attributes.plan_id#"
                        title="#message1#"
                        closable="0">
                    </cf_box>
    </div>
</cfif>

<cfif  len(attributes.project_emp_id)>
    <div class="col col-12">
            <cfset attributes.product_edit=1>
                    <cfsavecontent variable="message2">Aksesuar Detayları</cfsavecontent>
                    <cf_box id="list_supplier_a"
                        box_page="#request.self#?fuseaction=textile.emptypopup_ajax_req_supplier_a&tableid=list_supplier_a&req_id=#attributes.req_id#&req_type=1&modelhouse_plan=1&plan_id=#attributes.plan_id#"
                        title="#message2#"
                        closable="0">
                    </cf_box>
    </div>
</cfif>
<div class="col col-12">
<cf_get_textile_labor_critics company_id='#get_opportunity.company_id#' action_section='TEXTILE_SAMPLE_REQUEST' action_id='#attributes.req_id#'>
</div>
<div class="col col-12">
		<!---ölçü tablosu
				<cf_box title="Ölçü Tablosu">
					<cfform name="add_measure" action="#request.self#?fuseaction=textile.emptypopup_upd_req" enctype="multipart/form-data">
					   <div class="col col-11 col-md-11 col-sm-6 col-xs-12" > 
						   <div class="form-group" id="item-measure"> 
							   <cfif not len(query_product_plan.measure_filename)>
									<input type="file" name="olcu_tablo" value="">
									<input type="hidden" name="req_id" id="req_id" value="<cfoutput>#query_product_plan.req_id#</cfoutput>">
							   <cfelse>
								   <cfoutput>
									  <a class="tableyazi" href="#request.self#?fuseaction=objects.popup_download_file&file_name=olcutablo/#query_product_plan.measure_filename#"> #query_product_plan.measure_filename#</a></cfoutput>
							   </cfif>
						   </div>
						   <div class="form-group" id="item-asset">
							   <div clas="input-group" style="float:right">
								   <cfif not len(query_product_plan.measure_filename)>
									   <button class="btn btn-primary btn-small">Kaydet</button>
								   </cfif>
							   </div>
						   </div>
					   </div>
				   </cfform>
				   
			   </cf_box>--->
			   <cfquery name="get_images" datasource="#dsn3#">
                SELECT IMAGE_ID,MEASURE_FILENAME 
                FROM TEXTILE_SAMPLE_REQUEST_IMAGE 
                WHERE REQ_ID = #GET_OPPORTUNITY.req_id#
                ORDER BY IMAGE_ID DESC
            </cfquery>
               <cf_box title="Ölçü Tablosu">
                <cfform name="add_measure" action="#request.self#?fuseaction=textile.emptypopup_sample_add_image&type=add" enctype="multipart/form-data">
                   <input type="file" name="olcu_tablo" value="">
                   <input type="hidden" name="req_id" id="req_id" value="<cfoutput>#GET_OPPORTUNITY.req_id#</cfoutput>">
                   <input type="submit" class="btn btn-primary btn-small" value="Kaydet">
                   <div class="col col-12"> 	
                        <table class="workDevList">
                            <cfloop query="get_images">
                                <tr>
                                    <cfoutput>
                                    <td><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_download_file&file_name=olcutablo/#get_images.measure_filename#"> #get_images.measure_filename#</a></td>
                                    <td><a style="cursor:pointer;" onclick="javascript:if(confirm('#getLang('main',1057)#')) location.href='#request.self#?fuseaction=textile.emptypopup_sample_add_image&type=del&image_id=#get_images.IMAGE_ID#&req_id=#GET_OPPORTUNITY.req_id#'; else return false;"><img src="/images/delete_list.gif" border="0" alt="#getLang('main',51)#"></a>	</td>
                                </cfoutput>
                                </tr>
                            </cfloop>
                        </table>
                   </div>
               </cfform>
           </cf_box>	
</div>
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
<cfset attributes.req_id=query_product_plan.req_id>
		  
            <script>
                function gonder2(str_alan_1)
                    {
                        str_list = '';
                           /* str_list = str_list+'branch_id='+document.getElementById("branch_id").value;
                            str_list = str_list+'&department_id='+document.getElementById("department").value;*/
                        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=plan.project_emp_id&'+str_list+'&field_name=plan.emp_name <cfif isdefined("xml_only_employee") and xml_only_employee eq 0>&field_partner=plan.outsrc_partner_id</cfif>&select_list=1,2&is_form_submitted=1&keyword='+encodeURIComponent(plan.emp_name.value),'list');
                    }
                    function gondertalep(r)
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

                                deger_member_id = eval("document.add_opp_supplier.company_id"+r);
                                deger_stock_id = eval("document.add_opp_supplier.stock_id"+r);
                                    deger_workstation_id = eval("document.add_opp_supplier.work_station"+r);
                                    deger_pcat_id = eval("document.add_opp_supplier.category"+r);
                                    deger_pcat = eval("document.add_opp_supplier.category_name"+r);
                                    deger_amount = eval("document.add_opp_supplier.quantity"+r);
                                    deger_rowid = eval("document.add_opp_supplier.rowid"+r);
                            amount=filterNum(deger_amount.value);   
                            if(parseFloat(amount)==0)
                            amount=1;
                            convert_list +=deger_stock_id.value+',';
                            convert_list_amount += amount+',';
                            convert_list_price_other +='0,';
                            convert_list_price +='0,';
                            convert_list_money +='TL,';
                            convert_relation_id+=deger_rowid.value+',';
                           
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
                            url="<cfoutput>#request.self#?fuseaction=purchase.list_internaldemand&event=add&type=convert</cfoutput>";
                                  <!---  if(tip==0)
                            url+='&ref_no=<cfoutput>#get_order_row.order_number#</cfoutput>&to_position_code='+to_emp+'&department_out='+dep_id+'&location_out='+loc_id+'&department_in='+dep_id+'&location_in='+loc_id+'&stage=-2&subject='+encodeURI(konu);
                                   --->         
                                    aktar_form.action=url;1
                                    aktar_form.target='cc_paym';
                                    aktar_form.submit();
                                }
                                else
                                alert("<cf_get_lang_main no ='313.Lütfen ürün seçiniz'>.");

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
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

<!---künye numune özet--->
<cfset attributes.req_id=query_product_plan.req_id>
<cfinclude template="../query/get_req.cfm">
<cfscript>
	CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.get_sample_request");
	getAsset=CreateCompenent.getAssetRequest(action_id:#attributes.req_id#,action_section:'REQ_ID');
</cfscript>
<!---künye numune özet--->

<cf_catalystHeader>
    <cfquery name="get_kuru_islem" dbtype="query">
        select *from  getWashType WHERE wash_type_id=1
    </cfquery>
	    <cfquery name="get_kumas" dbtype="query">
        select *from  getWashType WHERE wash_type_id=2
    </cfquery>
		<cfquery name="get_yikama" dbtype="query">
        select *from  getWashType WHERE wash_type_id=3
    </cfquery>
	    <cfquery name="get_cresh" dbtype="query">
        select *from  getWashType WHERE wash_type_id=4
    </cfquery>
	  <cfquery name="get_recine" dbtype="query">
        select *from  getWashType WHERE wash_type_id=5
    </cfquery>
		<cfquery name="get_lokal" dbtype="query">
        select *from  getWashType WHERE wash_type_id=6
    </cfquery>
	  <cfquery name="get_kimyasal" dbtype="query">
        select *from  getWashType WHERE wash_type_id=7
    </cfquery>

	<cfquery name="get_boyama" dbtype="query">
        select *from  getWashType WHERE wash_type_id=8
    </cfquery>
	
	
	 <cfquery name="get_kuru_islem_value" dbtype="query">
        select *from  list_washplan WHERE wash_type=1
    </cfquery>
	    <cfquery name="get_kumas_value" dbtype="query">
        select *from list_washplan WHERE wash_type=2
    </cfquery>
	<cfquery name="get_yikama_value" dbtype="query">
        select *from list_washplan WHERE wash_type=3
    </cfquery>
	    <cfquery name="get_cresh_value" dbtype="query">
        select *from list_washplan WHERE wash_type=4
    </cfquery>
	  <cfquery name="get_recine_value" dbtype="query">
        select *from list_washplan WHERE wash_type=5
    </cfquery>
		<cfquery name="get_lokal_value" dbtype="query">
        select *from list_washplan WHERE wash_type=6
    </cfquery>
	  <cfquery name="get_kimyasal_value" dbtype="query">
        select *from list_washplan WHERE wash_type=7
    </cfquery>

	  <cfquery name="get_boyama_value" dbtype="query">
        select *from list_washplan WHERE wash_type=8
    </cfquery>
	<cfset listtype="Kuru İşlem,Kumaş,Yıkama,Cresh,Recine,Lokal,Kimyasal,Parça Boyama">
	<cfsavecontent variable="title">
		Yıkama İşlem No
	</cfsavecontent>
	<cfset referel_page="wash_plan">
					   				
            
		
        <div class="row">
            <div class="col col-12">
                <cf_box id="sample_request" closable="0" unload_body = "1"  title="Numune Özet" >
                    <div class="col col-10 col-xs-12 ">
                            
                            <cfinclude template="../../common/get_opportunity_type.cfm">
                            <cfinclude template="../display/dsp_sample_request.cfm">
                        
                    </div>
                    <div class="col col-2 col-xs-2">
                        <cfinclude template="../../objects/display/asset_image.cfm">
                    </div>
                </cf_box>
            </div>
        </div>	
        
        <cfform name="plan"  method="post" action="#request.self#?fuseaction=textile.emptypopup_upd_product_plan">
        <input type="hidden" name="process_count" id="process_count" value="8">
        <div class="col col-12 col-xs-12">
            <div class="col col-10 col-xs-10 ">
                <cfinclude template="plan_form.cfm">
            </div>
            <div class="col col-2 col-xs-2 ">
            <cf_get_workcube_asset title="Kalıp" company_id="#session.ep.company_id#" asset_cat_id="-3" module_id='99' action_section='REQUEST_ID' action_id='#attributes.req_id#'>
            </div>
        </div>
        
        <div class="row">
            <div class="col col-12 uniqueRow">
                <div class="row formContent">
                <cfif len(attributes.project_emp_id)>
                    <div class="row" type="row">
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="14" sort="true">
                            <div class="form-group" id="item-kuruislem">
                                <label class="col col-4 col-xs-12">Kuru İşlem</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cf_multiselect_check
                                        name="islem1"
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
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="15" sort="true">
                            <div class="form-group" id="item-kumas">
                                <label class="col col-4 col-xs-12">Kumaş</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cf_multiselect_check
                                        name="islem2"
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
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="16" sort="true">
                            <div class="form-group" id="item-yikama">
                                <label class="col col-4 col-xs-12">Yıkama</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cf_multiselect_check
                                        name="islem3"
                                        query_name="get_yikama"
                                        option_name="wash_detail"
                                        width="300"
                                        height="300"
                                        option_value="wash_id"
                                        option_text="İşlem Seçiniz"
                                        value="#valueList(get_yikama_value.WASH_VALUE)#">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="17" sort="true">
                            <div class="form-group" id="item-crash">
                                <label class="col col-4 col-xs-12">Crash</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cf_multiselect_check
                                        name="islem4"
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
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="18" sort="true">
                            <div class="form-group" id="item-recine">
                                <label class="col col-4 col-xs-12">Recine</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cf_multiselect_check
                                        name="islem5"
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
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="19" sort="true">
                            <div class="form-group" id="item-localuygulama">
                                <label class="col col-4 col-xs-12">Lokal Uygulama</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cf_multiselect_check
                                        name="islem6"
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
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="20" sort="true">
                            <div class="form-group" id="item-kimyasal">
                                <label class="col col-4 col-xs-12">Kimyasal</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cf_multiselect_check
                                        name="islem7"
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
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="21" sort="true">
                            <div class="form-group" id="item-parcaboya">
                                <label class="col col-4 col-xs-12">Parça Boyama</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cf_multiselect_check
                                        name="islem8"
                                        query_name="get_boyama"
                                        option_name="wash_detail"
                                        option_value="wash_id"
                                        width="300"
                                        height="300"
                                        option_text="İşlem Seçiniz"
                                        value="#valueList(get_boyama_value.WASH_VALUE)#">
                                    </div>
                                </div>
                            </div>
                        </div>
                    
                    </div>
                </cfif>
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
<cfform name="add_detail" method="post" action="#request.self#?fuseaction=textile.emptypopup_product_subject_row">	
	<input type="hidden" name="recordCount" value="<cfoutput>#list_washplan.recordCount#</cfoutput>">
	<input type="hidden" name="plan_id" value="<cfoutput>#attributes.plan_id#</cfoutput>">
	 <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
					<cf_big_list>
						<thead>
								<th></th>
								<th>Yıkama Tipi</th>
								<th>Yıkama Değeri</th>
								<th>Açıklama</th>
								<th>Fiyatı</th>
						</thead>
						<tbody>
						<cfset toplamfiyat=0>
						<cfoutput query="list_washplan">
							<tr>
								<td>#currentrow# 
								<input type="hidden" value="#wash_type_id#" name="wash_type_id#currentrow#">
								<input type="hidden" value="#wash_id#" name="washid#currentrow#"></td>
								<td>#ListGetAt(listtype,wash_type)#</td>
								<td>#WASH_DETAIL#</td>
								<td><input type="text" name="subject#currentrow#" value="#SUBJECT#" style="width:100%;"></td>
								<td style="text-align:right;">#A_price#</td>
								<cfset toplamfiyat=toplamfiyat+A_price>
							</tr>
						</cfoutput>
						</tbody>
                </cf_big_list>
                <div class="row">
                <div class="col-3" style="float: right;">
                    <cf_grid_list>
                        <tr>
                            <td style="text-align:right;">Toplam Fiyat</td>
                            <td> </td>
                            <td style="text-align:right;"><cfoutput>#tlformat(toplamfiyat)#</cfoutput></td>
                        </tr>
                        <tr>
                            <td style="text-align:right;">İskonto %</td>
                            <td>
                                <div class="form-group">
                                <cfinput type="text" value="#query_product_plan.discount_rate#" name="discount_rate" size="5">
                                </div>
                            </td>
                                
                                <cfset isk=(toplamfiyat/100)*(len(query_product_plan.discount_rate)?query_product_plan.discount_rate:0)>
                            <td style="text-align:right;" id="discount_value">
                                <cfoutput>#tlformat(isk)#</cfoutput>
                            </td>
                        </tr>
                                <cfset gtoplam=toplamfiyat-isk>
                        <tr>
                            <td style="text-align:right;">Genel Toplam</td>
                            <td></td>
                            <td style="text-align:right;" id="total_price_value">
                                <cfoutput>#tlformat(gtoplam)#</cfoutput>
                            </td>
                        </tr>
                        <cfinput type="hidden" name="total_price" value="#gtoplam#">
                    </cf_grid_list>
                </div>
                </div>
                <div class="row">
				<div class="row">
				<cf_workcube_buttons is_upd='1' is_delete=0 add_function="kontrol_($(this).closest('form'))">	
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
                        if(<cfoutput>#list_washplan.recordcount#</cfoutput>==0)
                        {
                            alert('Operasyon Seçiniz!')
                            return false;
                        }
                    }
                    return process_cat_control();
                }
            function set_discount() {
                let discount_rate = 0;
                if ($("#discount_rate").val() != "") {
                    discount_rate = parseFloat($("#discount_rate").val())
                } else {
                    discount_rate = 0;
                }
                let toplam = wrk_round(<cfoutput>#toplamfiyat#</cfoutput>, 2);

                let discount = wrk_round(toplam * discount_rate / 100, 2);
                let gtotal = toplam - discount;

                $("#discount_value").html(commaSplit(discount, 2));
                $("#total_price_value").html(commaSplit(gtotal, 2));
                $("#total_price").val(gtotal);
                $("#discount_rate").val(discount_rate);
            }

            function kontrol_(frm) {
                set_discount();
                $(frm).submit();
                return false;
            }

            $(document).ready(function () {
                $("#discount_rate").change(set_discount);
            });
    </script>

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
<!---<cfset pageHead = " #getlang('textile',23)#: (#query_product_plan.req_no#)">--->
<cfsavecontent variable="title">
	İşçilik Fiyat Talep İşlem No
</cfsavecontent>
<cfset referel_page="workmanship_plan">
<cf_catalystHeader>
 <br/><br/><br/><br/>
<div class="row">
	<div class="col col-12">
		<div class="col col-12 col-xs-12 uniqueRow">
			<cf_box title="">
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
	
	
	<!------kumas ve aksesuar detayları ıcın-------->
	<cfquery name="get_detail" datasource="#dsn3#">
        SELECT 
            T.ID,
            T.REQUEST_COMPANY_STOCK,
            T.STOCK_ID,
            T.UNIT,
            T.PRODUCT_CATID,
            T.MONEY_TYPE,
            T.QUANTITY,
            T.REVIZE_QUANTITY,
            T.PRICE,
            T.REVIZE_PRICE,
            T.PRODUCT_NAME,
            T.TYPE
        FROM
            (
            SELECT 
                0 AS TYPE,
                TSS.ID,
                TSS.REQUEST_COMPANY_STOCK,
                TSS.STOCK_ID,
                TSS.PRODUCT_ID,
                TSS.UNIT,
                TSS.PRODUCT_CATID,
                ISNULL(TSS.MONEY_TYPE,'TL') MONEY_TYPE,
                ISNULL(TSS.QUANTITY,0) QUANTITY,
                ISNULL(TSS.REVIZE_QUANTITY,ISNULL(TSS.QUANTITY,0)) REVIZE_QUANTITY,
                ISNULL(TSS.PRICE,0) PRICE,
                ISNULL(TSS.REVIZE_PRICE,ISNULL(TSS.PRICE,0)) REVIZE_PRICE,
                P.PRODUCT_NAME
            FROM #dsn3#.[TEXTILE_SR_SUPLIERS] TSS
                RIGHT JOIN #dsn1#.PRODUCT P
                ON TSS.PRODUCT_ID=P.PRODUCT_ID
            WHERE REQ_ID=#attributes.req_id# AND
                ISNULL(TSS.IS_STATUS,1)=1
            
            UNION ALL
            SELECT
                1 AS TYPE,
                TSP.ID,
                Null REQUEST_COMPANY_STOCK,
                TSP.STOCK_ID,
                P.PRODUCT_ID,
                'BR' AS UNIT,
                TSP.PRODUCT_CATID,
                ISNULL(TSP.MONEY,'TL') MONEY_TYPE,
                1 AS QUANTITY,
                1 AS REVIZE_QUANTITY,
                ISNULL(TSP.PRICE,0) PRICE,
                    ISNULL(TSP.REVIZE_PRICE,ISNULL(TSP.PRICE,0)) REVIZE_PRICE,
                P.PRODUCT_NAME
            FROM #dsn3#.[TEXTILE_SR_PROCESS] TSP
                RIGHT JOIN #dsn1#.PRODUCT P
                ON TSP.PRODUCT_ID=P.PRODUCT_ID
            WHERE 
                REQUEST_ID=#attributes.req_id# and
                ISNULL(TSP.IS_STATUS,1)=1
            ) T  
    </cfquery>
		
	<div class="col col-12">
		<cf_box id="test" closable="1" unload_body = "1"  title="Kumaş ve Aksesuar Detayları" >
			<div class="col col-8 col-xs-8 ">
					
					<cf_big_list>
						<thead>
							<tr>
								 <th style="text-align:center;">Sıra</th>
								 <th>Kullanılan Malzeme</th>
								 <th style="text-align:center;">Miktar</th>
								 <th style="text-align:center;">Revize Miktar</th>
								 <th style="text-align:center;">Birim</th>
							</tr>
						</thead>

						<tbody>

						<cfoutput query="get_detail">
							 <tr>
								<td text-wrap:suppress; style="text-align:center;" width="20px">#currentrow#</td>
								<td text-wrap:suppress; width="300px">#PRODUCT_NAME#</td>
								<td text-wrap:suppress; width="100px" style="text-align:right;">#QUANTITY#</td>
								<td text-wrap:suppress; width="100px" style="text-align:right;">#REVIZE_QUANTITY#</td>
								<td text-wrap:suppress; width="100px" style="text-align:center;">#UNIT#</td>
								
							 </tr>
						</cfoutput>

						</tbody>

					</cf_big_list>


				
			</div>
			
		</cf_box>
	</div>
		
		
		
		
<cfif len(attributes.project_emp_id)>
	<div class="col col-12">	
	<cfsavecontent variable="message2">İşçilik Fiyat Talep<!---<cf_get_lang_main no="1731.Tedarikçiler">---></cfsavecontent>
		<cf_box id="list_process"
			box_page="#request.self#?fuseaction=textile.emptypopup_ajax_req_process_list&req_id=#attributes.req_id#&plan_id=#attributes.plan_id#&workmanship_plan=1"
			title="#message2#"
			closable="0">
		</cf_box>
	</div>
</cfif>
<!---<div class="col col-12">
	 <cfsavecontent variable="message2">Gm İşçilik Fiyat Talep</cfsavecontent>
        <cf_box id="list_process_gm"
            box_page="#request.self#?fuseaction=textile.emptypopup_ajax_req_process_list&req_id=#attributes.req_id#&gm=&plan_id=#attributes.plan_id#&workmanship_plan=1"
            title="#message2#"
            closable="0">
        </cf_box>
</div>--->
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
                function gonder2(str_alan_1)
                    {
                        str_list = '';
                           /* str_list = str_list+'branch_id='+document.getElementById("branch_id").value;
                            str_list = str_list+'&department_id='+document.getElementById("department").value;*/
                        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=plan.project_emp_id&'+str_list+'&field_name=plan.emp_name <cfif isdefined("xml_only_employee") and xml_only_employee eq 0>&field_partner=plan.outsrc_partner_id</cfif>&select_list=1,2&is_form_submitted=1&keyword='+encodeURIComponent(plan.emp_name.value),'list');
                    }
</script>
   

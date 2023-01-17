<cfparam name="attributes.project_id" default="0">
<cfparam name="attributes.opp_id" default="0">
<cfparam name="attributes.order_id" default="0">
<cfparam name="attributes.viewmode" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.lot" default="">

<cfif attributes.viewmode eq "lotfind">
    <cfobject name="product_lots" component="WBP.Fashion.files.cfc.product_lots">
    <cfset GetPageContext().getCFOutput().clear()>
    <cfset result = product_lots.GetList(attributes.product_id, attributes.lot)>
	
    <cfoutput>{ 
        "count": #result.recordCount#,
        "product_id": #len(result.product_id)?result.product_id:-1#,
        "envanter": #len(result.ENVANTER)?result.ENVANTER:0#
     }</cfoutput>
    <cfabort>
</cfif>

<cfobject name="stretching_test" component="WBP.Fashion.files.cfc.stretching_test">
<cfset stretching_test.dsn3 = dsn3>
<cfscript>
    attributes.checkTotal = attributes.project_id + attributes.opp_id + attributes.order_id;
    query_stretching_test = stretching_test.get_stretching_test(attributes.st_id);
    query_stretching_test_rows = stretching_test.get_stretching_test_rows(attributes.st_id);
    query_stretching_test_groups = stretching_test.get_stretching_test_groups(attributes.st_id);
</cfscript>

<cfset pageHead = "ÇEKME TESTİ">
<cf_catalystHeader>
    <div style="clear: both"></div>
<cfif isDefined("query_stretching_test.req_id") and len(query_stretching_test.req_id)>
<!---künye numune özet--->
<cfset attributes.req_id=query_stretching_test.req_id>
<cfinclude template="../query/get_req.cfm">
<cfscript>
	CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.get_sample_request");
	getAsset=CreateCompenent.getAssetRequest(action_id:#attributes.req_id#,action_section:'REQ_ID');
</cfscript>

<!---künye numune özet--->

<cfif isdefined("attributes.req_id")>
	<cfquery name="get_related_order" datasource="#dsn3#">
		SELECT ORD.*,
		CASE
			WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
			ELSE PRT.PRIORITY
		END AS PRIORITY
		FROM 
			ORDERS ORD
			LEFT JOIN #dsn#.SETUP_PRIORITY PRT ON ORD.PRIORITY_ID = PRT.PRIORITY_ID
			LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PRT.PRIORITY_ID
			AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRIORITY">
			AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_PRIORITY">
			AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
		WHERE ORD.ORDER_ID 
				IN(
				SELECT ORDER_ID FROM ORDER_ROW
				WHERE RELATED_ACTION_ID=#attributes.req_id# AND RELATED_ACTION_TABLE='TEXTILE_SAMPLE_REQUEST'
				)
	</cfquery>
</cfif>

<cfquery name="get_sip_top" datasource="#dsn3#">
SELECT SUM (QUANTITY) SIPTOP FROM ORDER_ROW where ORDER_ID = #get_related_order.order_id#
</cfquery>

<cfquery name="get_kumas_detay" datasource="#dsn3#">
	SELECT [ID]
      ,[REQ_ID]
      ,TSR.[COMPANY_ID]
	  ,FULLNAME
      ,[BRAND_ID]
      ,[PRODUCT_CATID]
      ,[PRODUCT_ID]
      ,[STOCK_ID]
      ,[PRODUCT_NAME]
      ,[UNIT_ID]
      ,[UNIT]
      ,[ESTIMATED_INCOME]
      ,[ESTIMATED_COST]
      ,[ESTIMATED_PROFIT]
      ,[MONEY_TYPE]
      ,[OPERATION_ID]
      ,[REQUEST_COMPANY_STOCK]
      ,[REQUEST_TYPE]
      ,[QUANTITY]
      ,[PRICE]
      ,[WRK_ROW_ID]
      ,[WORK_ID]
      ,[IMAGE_PATH]
      ,[ROW_DETAIL]
      ,[EN]
      ,[REVIZE_QUANTITY]
      ,[REVIZE_PRICE]
      ,[IS_REVISION]
      ,[IS_STATUS]
      ,[PLAN_ID]
      ,[VARIANT]
  FROM [TEXTILE_SR_SUPLIERS] TSR
  left join COMPANY COM ON COM.COMPANY_ID = TSR.COMPANY_ID
  where REQ_ID = #attributes.req_id# and OPERATION_ID = 1
</cfquery>

<div class="row">
	<cf_box id="sample_request" closable="0" unload_body = "1"  title="Numune Özet" >
		<div class="col col-10 col-xs-12 ">
			<cfinclude template="../../common/get_opportunity_type.cfm">
			<cfinclude template="../display/dsp_sample_request.cfm">
		</div>
		<div class="col col-2 col-xs-2">
			<cfinclude template="../../objects/display/asset_image.cfm">
		</div>
	</cf_box>
	<!---
	<div>
		<cfsavecontent variable="message1">Kumaş Detayları</cfsavecontent>
		<cf_box id="list_supplier_k"
			box_page="#request.self#?fuseaction=textile.emptypopup_ajax_req_supplier&tableid=list_supplier_k&req_id=#attributes.req_id#&req_type=0&request_plan=1&req_stage=#get_opportunity.req_stage#"
			title="#message1#"
			closable="0">
		</cf_box>
	</div>
	---->
</div>

<div class="row">	
	<div>
		<cf_box title="Kumaş Detayları" >
		<cfsavecontent variable="message1">Kumaş Detayları</cfsavecontent>
		<cf_grid_list>
		<thead>
			<tr>
				<th>Ürün</th>
				<th>Hammadde</th>
				<th>Tedarikçi</th>			
				<th>Birim Metraj</th>
				<th>En</th>
				<th>Sipariş Adeti</th>
				<th>Kumaş Metraj Toplamı</th>
			</tr>
		<thead>
		<tbody>
		<cfoutput query="get_kumas_detay">
			<tr>
				<td>#PRODUCT_NAME#</td>
				<td>#REQUEST_COMPANY_STOCK#</td>
				<td>#FULLNAME#</td>
				<td>#QUANTITY#</td>
				<td>#EN#</td>
				<td>#get_sip_top.SIPTOP#</td>
				<td><cfset SIPMIKTOP = #get_sip_top.SIPTOP# * #get_kumas_detay.QUANTITY#>#SIPMIKTOP#</td>
			</tr>
		</tbody>
		</cfoutput>
		</cf_grid_list>
		</cf_box>
	</div>
</div>

</cfif>
<cfform name="stretching_test" method="post">
<input type="hidden" name="order_id" id="order_id" value="<cfoutput>#get_related_order.order_id#</cfoutput>">
	<div class="col col-10 col-xs-12 uniqueRow">
		<cf_box id="stretching_test_box" closable="0" unload_body = "1"  title="Çekme Testi">
			<input type="hidden" name="stretching_test_id" value="<cfoutput>#query_stretching_test.STRETCHING_TEST_ID#</cfoutput>">
			<div class="row">
				<div class="col col-12 uniqueRow">
					<div class="row formContent">
						<div class="row" type="row">
							<!--- col 1 --->
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="11" sort="true">
								<div class="form-group" id="item-process_id">
									<label class="col col-4 col-xs-12">Süreç</label>
									<div class="col col-8 col-xs-12">
										<cf_workcube_process is_upd='0' select_value='#iif(isDefined("query_stretching_test.STAGE_ID"),"query_stretching_test.STAGE_ID",de(""))#' is_detail='1'>
									</div>
								</div>
								<div class="form-group" id="item-production_orderid">
									<label class="col col-4 col-xs-12">Üretim Emir No</label>
									<div class="col col-8 col-xs-12">
										<input type="text" name="production_orderid" id="production_orderid" value="<cfoutput>#query_stretching_test.PRODUCTION_ORDERID#</cfoutput>">
									</div>
								</div>
								<div class="form-group" id="item-emp_id">
									<label class="col col-4 col-xs-12">Görevli</label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#query_stretching_test.EMP_ID#</cfoutput>">
											<input type="text" name="emp_name" id="emp_name" value="<cfoutput>#query_stretching_test.EMP_NAME#</cfoutput>">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_positions&field_emp_id=stretching_test.emp_id&field_name=stretching_test.emp_name &select_list=1,2&is_form_submitted=1&keyword='+encodeURIComponent(stretching_test.emp_name.value),'list');"></span>
										</div>
									</div>
								</div>
							</div>
							<!--- col 2 --->
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="12" sort="true">
								<div class="form-group" id="item-stretching_test_id">
									<label class="col col-4 col-xs-12">Test No</label>
									<div class="col col-8 col-xs-12">
										<input type="text" name="stretching_test_no" id="stretching_test_no" value="<cfoutput>#query_stretching_test.STRETCHING_TEST_ID#</cfoutput>" disabled="disabled">
									</div>
								</div>
								<div class="form-group" id="item-purchasing_id">
									<label class="col col-4 col-xs-12">İrsaliye No</label>
									<div class="col col-8 col-xs-12">
										<input type="text" name="waybill" id="waybill" value="<cfoutput>#query_stretching_test.WAYBILL#</cfoutput>">
									</div>
								</div>
								<div class="form-group" id="item-date_start">
									<label class="col col-4 col-xs-12">İş Başlangıç Zaman</label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
											<input type="text" name="date_start" id="date_start" value="<cfoutput>#dateformat(query_stretching_test.start_date,dateformat_style)#</cfoutput>" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon"><cf_wrk_date_image date_field="date_start"></span>
											<cfif len(query_stretching_test.start_date)>
												<cfset sdate=date_add("H",session.ep.time_zone,query_stretching_test.start_date)>
												<cfset shour=datepart("H",sdate)>
												<cfset sminute=datepart("N",sdate)>
											<cfelse>
												<cfset sdate="">
												<cfset shour="">
												<cfset sminute="">                                           
											</cfif>
											<cfoutput>
											<span class="input-group-addon">
												<cf_wrkTimeFormat name="date_start_hour" value="#shour#">
											</span>
											<span class="input-group-addon">
												<select name="date_start_minute" id="date_start_minute" style="width:38px;">
													<cfloop from="0" to="59" index="sta_min">
														<option value="#NumberFormat(sta_min,00)#" <cfif sta_min eq sminute>selected</cfif>>#NumberFormat(sta_min,00)#</option>
													</cfloop>
												</select>
											</span>
											</cfoutput>
										</div>
									</div>
								</div>
							</div>
							<!--- col 3 --->
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="13" sort="true">
								<div class="form-group" id="item-test_date">
									<label class="col col-4 col-xs-12">Tarih</label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
											<input type="text" name="test_date" id="test_date" value="<cfoutput>#dateformat( iif(attributes.checkTotal gt 0 and query_stretching_test.recordcount eq 1, "query_stretching_test.TEST_DATE", "now()") ,dateformat_style)#</cfoutput>" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon"><cf_wrk_date_image date_field="test_date"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-washing_id">
									<label class="col col-4 col-xs-12">Yıkama No</label>
									<div class="col col-8 col-xs-12">
										<cfobject name="washing_receipe" component="WBP.Fashion.files.cfc.washing_recepie">
										<cfset washing_recepie_query = washing_receipe.simple_recepie_head()>
										<div class="input-group"> 
											<select name="washing_id" id="washing_id">
												<option value="">Seçiniz</option>
												<cfoutput query="washing_recepie_query">
												<option value="#WASHING_RECEPIE_ID#" #iif(query_stretching_test.WASHING_ID eq WASHING_RECEPIE_ID, de('selected="selected"'), de(""))#>RN-#WASHING_RECEPIE_ID#</option>
												</cfoutput>
											</select>
											<div class="input-group-addon">
												<button type="button" class="btn green-haze" onclick="$('#washing_id').val() !== '' && windowopen('<cfoutput>#request.self#?fuseaction=textile.washing_recepie&event=upd&rid=</cfoutput>' + $('#washing_id').val(), 'wide')"><i class="fa fa-eye"></i></button>
											</div>
										</div>
										<script>
											$("#washing_id").select2();
										</script>
									</div>
								</div>
								<div class="form-group" id="item-fabric_arrival_date">
									<label class="col col-4 col-xs-12">Kumaş Geliş Tarihi</label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
											<input type="text" name="fabric_arrival_date" id="fabric_arrival_date" value="<cfoutput>#dateformat( iif(attributes.checkTotal gt 0 and query_stretching_test.recordcount eq 1, "query_stretching_test.FABRIC_ARRIVAL_DATE", "now()") ,dateformat_style)#</cfoutput>" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon"><cf_wrk_date_image date_field="fabric_arrival_date"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-date_finish">
									<label class="col col-4 col-xs-12">İş Bitiş Zamanı</label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
												<input type="text" name="date_finish" id="date_finish" value="<cfoutput>#dateformat(query_stretching_test.finish_date,dateformat_style)#</cfoutput>" validate="#validate_style#" maxlength="10">
												<span class="input-group-addon"><cf_wrk_date_image date_field="date_finish"></span>
												<cfif len(query_stretching_test.finish_date)>
													<cfset sdate=date_add("H",session.ep.time_zone,query_stretching_test.finish_date)>
													<cfset shour=datepart("H",sdate)>
													<cfset sminute=datepart("N",sdate)>
												<cfelse>
													<cfset sdate="">
													<cfset shour="">
													<cfset sminute="">                                           
												</cfif>
												<cfoutput>
												<span class="input-group-addon">
													<cf_wrkTimeFormat name="date_finish_hour" value="#shour#">
												</span>
												<span class="input-group-addon">
													<select name="date_finish_minute" id="date_finish_minute" style="width:38px;">
														<cfloop from="0" to="59" index="sta_min">
															<option value="#NumberFormat(sta_min,00)#" <cfif sta_min eq sminute>selected</cfif>>#NumberFormat(sta_min,00)#</option>
														</cfloop>
													</select>
												</span>
												</cfoutput>
										</div>
									</div>
								</div>
							</div>
							<!--- col 4 --->
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="14" sort="true">
								<div class="form-group" id="item-project_id">
									<label class="col col-4 col-xs-12">Proje No</label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="req_id" id="req_id" value="<cfoutput>#query_stretching_test.REQ_ID#</cfoutput>">
											<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#query_stretching_test.PROJECT_ID#</cfoutput>">
											<input name="project_head" type="text" id="project_head" value="<cfoutput>#query_stretching_test.PROJECT_HEAD#</cfoutput>" readonly="">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_projects&amp;project_id=stretching_test.project_id&amp;project_head=stretching_test.project_head','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-notes">
									<label class="col col-4 col-xs-12">Açıklama</label>
									<div class="col col-8 col-xs-12">
										<textarea name="notes" id="notes"><cfoutput>#query_stretching_test.NOTES#</cfoutput></textarea>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</cf_box>
		<cf_box id="stretching_test_form" closable="0" unload_body = "1"  title="Çekme Testi Lot Alanı">
			<div class="col col-12 col-xs-12 uniqueRow">	
				<cfinclude template="list_stretching_fabric.cfm">
			</div>
		</cf_box>
	</div>
	<div class="col col-2 col-xs-12 uniqueRow">
		<div>
			<cfquery name="get_mold_planid" datasource="#dsn3#">
				select *from TEXTILE_PRODUCT_PLAN
				where REQUEST_ID=#attributes.req_id#
			</cfquery>
			<cf_get_workcube_asset title="Kalıp" company_id="#session.ep.company_id#" asset_cat_id="-3" module_id='99' action_section='REQUEST_ID' action_id='#attributes.req_id#'>
		</div>
	</div>
</cfform>

<script type="text/javascript">
    function upload_myfile() {
        var formData = new FormData();
        formData.append('docu_file', $('#docu_file')[0].files[0]);

        $.ajax({
            url : '<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&event=upload&st_id=#attributes.st_id#</cfoutput>',
            type : 'POST',
            data : formData,
            processData: false,  // tell jQuery not to process the data
            contentType: false,  // tell jQuery not to set contentType
            success : function(data) {
                alert( 'Belge Başarıyla Yüklenmiştir!' );
            }
        });
    }

    var list_stretching_fabric_control_2 = list_stretching_fabric_control;
    list_stretching_fabric_control = function () {
        if ($("#req_id").val() == "") {
            $("#req_id").val($("#req_id2").val());
        }
        return list_stretching_fabric_control_2();
    }
</script>
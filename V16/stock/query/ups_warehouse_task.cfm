<cfscript>
	get_warehouse_tasks_action = createObject("component", "v16.stock.cfc.get_warehouse_tasks");
	get_warehouse_tasks_action.dsn3 = dsn3;
	get_warehouse_tasks_action.dsn_alias = dsn_alias;
	get_warehouse_task = get_warehouse_tasks_action.get_warehouse_task_fnc(
		 task_id : '#attributes.task_id#'
	);

 	get_warehouse_ups_action = createObject("component", "v16.stock.cfc.ups");
</cfscript>

<cfif not len(get_warehouse_task.cargo_code)>
	<cfquery name="get_products_control" datasource="#dsn3#">
		SELECT 
			*
		FROM 
			WAREHOUSE_TASKS_PRODUCTS 
		WHERE 
			(
				(WEIGHT IS NULL OR WEIGHT = '')
				OR
				(DIMENSION IS NULL OR DIMENSION = '')
			) AND
			TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">
	</cfquery>
	<cfif get_products_control.recordcount>
		<script>	
			alert('Please Check Dimenstions and Weights!');
			history.back();
		</script>
		<cfabort>
	</cfif>

	<cfscript>
		rows = structnew();
		rows.pck = arraynew(1);
	</cfscript>
	
	<cfquery name="get_products" datasource="#dsn3#">
		SELECT 
			*
		FROM 
			WAREHOUSE_TASKS_PRODUCTS WHERE TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">
	</cfquery>
	
	<cfset aktif_satir = 0>
	<cfoutput query="get_products">
		<cfset dimension_ = dimension>
		<cfset dimension_ = replace(dimension_,'*','x','all')>
		<cfset dimension_ = replace(dimension_,'X','x','all')>
		<cfif listlen(dimension_,'x') neq 3>
			<cfset l_ = "">
			<cfset w_ = "">
			<cfset h_ = "">
		<cfelse>
			<cfset l_ = listgetat(dimension_,1,'x')>
			<cfset w_ = listgetat(dimension_,2,'x')>
			<cfset h_ = listgetat(dimension_,3,'x')>
		</cfif>
		<cfloop from="1" to="#AMOUNT#" index="ra">
			<cfset aktif_satir = aktif_satir + 1>
			<cfset rows.pck[aktif_satir] = structnew()>
			<cfset rows.pck[aktif_satir].pkgLength = "#l_#">
			<cfset rows.pck[aktif_satir].pkgWidth = "#w_#">
			<cfset rows.pck[aktif_satir].pkgHeight = "#h_#">
			<cfset rows.pck[aktif_satir].pkgWeight = "#ceiling(weight)#">
		</cfloop>
	</cfoutput>
	
	
	<cfset p_ = "Yes">
	<cfscript>
		get_warehouse_ups_action.init
		(
			License : "9D6A3E5FAC2C5932",
			Account : "376RY4",
			UserId : "TTCChicago",
			Password: "Evegroup2800",
			Production : "#p_#"
		);
		
		result_ups = get_warehouse_ups_action.shipping
		(
			MyAttention:"#get_warehouse_task.CARGO_MYNAME#",
			MyName:"#get_warehouse_task.CARGO_MYCOMPANY#",
			MyAddress1:"#get_warehouse_task.CARGO_MYADDRESS#",
			MyCity:"#get_warehouse_task.CARGO_MYCOUNTY#",
			MyState:"#get_warehouse_task.CARGO_MYCITY#",
			MyZIP:"#get_warehouse_task.CARGO_MYPOSTCODE#",
			MyPhone:"#get_warehouse_task.CARGO_MYPHONE#",
			
			FromCompany:"#get_warehouse_task.FULLNAME#",
			FromName:".",
			FromAddress1:"#get_warehouse_task.COMPANY_ADDRESS#",
			FromCity:"#get_warehouse_task.C_CITY#",
/* 			FromState:"#get_warehouse_task.C_STATE#", */
			FromZIP:"#get_warehouse_task.COMPANY_POSTCODE#",
			
			BillAccount:"#get_warehouse_task.CARGO_SHIP_RELATED_NUMBER#",
			BillZip:"#get_warehouse_task.CARGO_SHIP_RELATED_POSTCODE#",
			
			Company:"#get_warehouse_task.CARGO_SHIP_COMPANY#",
			Name:".",
			Attention:"#get_warehouse_task.CARGO_SHIP_NAME#",		
			Address1:"#get_warehouse_task.CARGO_SHIP_ADDRESS#",
			City:"#get_warehouse_task.CARGO_SHIP_COUNTY#",
			State:"#get_warehouse_task.CARGO_SHIP_CITY#",
			ZIP:"#get_warehouse_task.CARGO_SHIP_POSTCODE#",
			Phone:"#get_warehouse_task.CARGO_SHIP_PHONE#",
			
			InsuranceValue:"0",
			pkgStruct:rows
		);
	</cfscript>

	<cfset result_code = result_ups.code>
	<cfset cargo_status_note = result_ups.message>
	<cfset cargo_code = result_ups.TrackingNumber>
	<cfquery name="upd_" datasource="#dsn3#">
		UPDATE
			WAREHOUSE_TASKS
		SET
			CARGO_STATUS = '#result_code#',
			CARGO_STATUS_NOTE = '#left(cargo_status_note,200)#',
			CARGO_CODE = '#cargo_code#',
			CARGO_TYPE = 'UPS'
		WHERE
			TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">
	</cfquery>
</cfif>

<cfscript>
	get_warehouse_task = get_warehouse_tasks_action.get_warehouse_task_fnc(
		 task_id : '#attributes.task_id#'
	);
</cfscript>

<cf_catalystHeader>
<cfoutput>
<cf_box>
		<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-company">
						<label class="col col-12 col-xs-12">
							<b><cf_get_lang dictionary_id="51619.Kargo Bilgileri"></b>
						</label>
					</div>
					<div class="form-group" id="item-document-no">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="63891.Sold To"></label>
						<div class="col col-9 col-xs-12">										
								<input type="text" name="CARGO_SHIP_RELATED_NUMBER" value="#get_warehouse_task.CARGO_SHIP_RELATED_NUMBER#" style="width:150px;" readonly>
						</div>
					</div>
					<div class="form-group" id="item-document-no">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="63892.Sold To Zipcode"></label>
						<div class="col col-9 col-xs-12">										
								<input type="text" name="CARGO_SHIP_RELATED_POSTCODE" value="#get_warehouse_task.CARGO_SHIP_RELATED_POSTCODE#" style="width:150px;" readonly>
						</div>
					</div>
					<div class="form-group" id="item-ship">
						<label class="col col-12 col-xs-12">
							<b><cf_get_lang dictionary_id="35958.Teslimat Bilgileri"></b>
						</label>
					</div>
					<div class="form-group" id="item-document-no">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="63893.Ship To"></label>
						<div class="col col-9 col-xs-12">										
								<input type="text" name="CARGO_SHIP_COMPANY" value="#get_warehouse_task.CARGO_SHIP_COMPANY#" style="width:150px;" readonly>
						</div>
					</div>
					<div class="form-group" id="item-document-no">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="63894.Ship To Attention"></label>
						<div class="col col-9 col-xs-12">							
								<input type="text" name="CARGO_SHIP_NAME" value="#get_warehouse_task.CARGO_SHIP_NAME#" style="width:150px;" readonly>
						</div>
					</div>
					<div class="form-group" id="item-document-no">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="63895.Ship To Address"></label>
						<div class="col col-9 col-xs-12">
								<input type="text" name="CARGO_SHIP_ADDRESS" value="#get_warehouse_task.CARGO_SHIP_ADDRESS#" style="width:150px;" readonly>
						</div>
					</div>
					<div class="form-group" id="item-document-no">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="63896.Ship To Phone"></label>
						<div class="col col-9 col-xs-12">							
								<input type="text" name="CARGO_SHIP_PHONE" value="#get_warehouse_task.CARGO_SHIP_PHONE#" style="width:150px;" readonly>
						</div>
					</div>
					<div class="form-group" id="item-document-no">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="63897.Ship To PostCode"></label>
						<div class="col col-9 col-xs-12">							
								<input type="text" name="CARGO_SHIP_POSTCODE" value="#get_warehouse_task.CARGO_SHIP_POSTCODE#" style="width:150px;" readonly>
						</div>
					</div>
					<div class="form-group" id="item-document-no">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="63898.Ship To City"></label>
						<div class="col col-9 col-xs-12">							
								<input type="text" name="CARGO_SHIP_COUNTY" value="#get_warehouse_task.CARGO_SHIP_COUNTY#" style="width:150px;" readonly>
						</div>
					</div>
					<div class="form-group" id="item-document-no">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="63899.Ship To State"></label>
						<div class="col col-9 col-xs-12">							
								<input type="text" name="CARGO_SHIP_CITY" value="#get_warehouse_task.CARGO_SHIP_CITY#" style="width:150px;">
						</div>
					</div>
					<br/>
					<br/>
					<br/>
					<div class="form-group" id="item-document-no">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="34574.Kargo Durumu"></label>
						<div class="col col-9 col-xs-12">							
								<input type="text" name="CARGO_STATUS_NOTE" value="#get_warehouse_task.CARGO_STATUS_NOTE#" style="width:150px;">
						</div>
					</div>
					<cfloop list="#get_warehouse_task.CARGO_CODE#" index="t_number">
						<div class="form-group" id="item-document-no">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="34574.Kargo Durumu"> <cf_get_lang dictionary_id="64031.Kargo Takip Numarası"></label>
							<div class="col col-9 col-xs-12">						
									<input type="text" name="CARGO_CODE" value="#t_number#" style="width:150px;">
							</div>
						</div>
					</cfloop>
				</div>
			</cf_box_elements>
				<cf_box_footer>
					<input type="button" class="ui-wrk-btn ui-wrk-btn-red" onclick="send_to_void('ups');" value="<cf_get_lang dictionary_id='64036.Geçersiz Kıl'>">
					<input type="button" class="ui-wrk-btn ui-wrk-btn-success" onclick="window.location.href='#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#attributes.task_id#';" value="<cf_get_lang dictionary_id='64032.Servise Dön'>">
				</cf_box_footer>
			</cf_box>
</cfoutput>
<script>
function send_to_void(type)
{
	if(confirm('<cf_get_lang dictionary_id="64035.Kargoyu geçersiz kılmak istediğinizden emin misiniz">?'))
	{
		window.location.href='<cfoutput>#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#attributes.task_id#&is_ups_void=1</cfoutput>';
	}
	else
	{
		return false;
	}
}
</script>

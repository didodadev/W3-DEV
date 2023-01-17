
<cfsetting showDebugOutput = "no" >
<cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
<cfset fuseaction_ = replace(fuseaction_,'emptypopup_','')>

<cfscript>
	comp = createObject("component", "WBP.Fashion.files.cfc.production_orders");
	comp.dsn3 = dsn3;
	comp.dsn = dsn;
	get_size_detail=comp.getOrders(party_id:attributes.party_id);
</cfscript>

<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%textile.order%">
</cfquery>
<cfquery name="GET_W" datasource="#dsn#">
	SELECT 
		CASE WHEN UP_STATION IS NULL THEN
			STATION_ID 
		ELSE
			UP_STATION 
		END AS UPSTATION_ID,
		STATION_ID,
		STATION_NAME,
		UP_STATION,
		CASE WHEN (SELECT TOP 1 WS1.UP_STATION FROM #dsn3_alias#.WORKSTATIONS WS1 WHERE WS1.UP_STATION = WORKSTATIONS.STATION_ID) IS NOT NULL THEN 0 ELSE 1 END AS TYPE
	FROM 
		#dsn3_alias#.WORKSTATIONS
	WHERE 
		ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
		DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
	ORDER BY 
		UPSTATION_ID, 
		TYPE
</cfquery>
	
	<cf_ajax_list style="align:center;">
			<thead>
					<tr>
						<th style="width:10px;">Operasyon No</th>
						<th style="width:10px;">Operasyon</th>
						<th style="width:250px;">Stok / Asorti Özellik</th>
						<th style="width:10px;">Stok Kodu</th>
						<th style="width:10px;">Stok Özel Kodu</th>
						<th style="width:10px;">Gerçekleşen Operasyon Miktarı</th>
						<th style="width:10px;">Üretilen Miktar</th>
						<th style="width:10px;">Kalan Miktar</th>
						<th></th>
						
					</tr>
					<cfoutput query="get_size_detail">
							<tr>
								<td style="width:20px;">#p_order_no#</td>
								<td>#operation_type#</td>
								<td>#product_name#  /  #property#</td>
								<td>#stock_code#</td>
								<td>#stock_code_2#</td>
								<td>#QUANTITY#</td>
								<td>#ROW_RESULT_AMOUNT#</td>
								<td>#QUANTITY-ROW_RESULT_AMOUNT#</td>
								<td></td>
								
							</tr>
					</cfoutput>
	</cf_ajax_list>
	<script>
			
		function satir_guncelle(lot_no,row_number,product_id,stock_id,quantity,spec_main_id,renk_id,order_id)
		{
		
						if(eval('document.all.production_start_date_main_'+row_number).value.length>0)
						{
							psdate=eval('document.all.production_start_date_main_'+row_number).value;
							psh=eval('document.all.production_start_h_main_'+row_number).value;
							psm=eval('document.all.production_start_m_main_'+row_number).value;
						}else
						{
							psdate='';
							psh='';
							psm='';
						}
						if(eval('document.all.production_finish_date_main_'+row_number).value.length>0)
						{
							pfdate=eval('document.all.production_finish_date_main_'+row_number).value;
							pfh=eval('document.all.production_finish_h_main_'+row_number).value;
							pfm=eval('document.all.production_finish_m_main_'+row_number).value;
						}
						else
						{
							pfdate='';
							pfh='';
							pfm='';
						}
				stationid=eval('document.all.station_id_main_'+row_number).value;
				stage=eval('document.all.prod_order_stage'+row_number).value;
				var bb='<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_ajax_upd_station&station_id='+stationid+'&lot_no='+lot_no+'&start_date='+psdate+'&start_m='+psm+'&start_h='+psh+'&finish_date='+pfdate+'&finish_m='+pfm+'&finish_h='+pfh+'&stage='+stage+'&product_id='+product_id;
				AjaxPageLoad(bb,'',1);
				connectAjaxDetail(row_number,product_id,stock_id,quantity,spec_main_id,renk_id,order_id,lot_no);
		}
	</script>
<!---</table>--->
<cfscript>
	attributes.purchase_labour_price = filterNum(attributes.purchase_labour_price);
	attributes.purchase_material_price = filterNum(attributes.purchase_material_price);
	attributes.purchase_engineering_price = filterNum(attributes.purchase_engineering_price);
	attributes.purchase_management_price = filterNum(attributes.purchase_management_price);
	attributes.sales_labour_price = filterNum(attributes.sales_labour_price);
	attributes.sales_material_price = filterNum(attributes.sales_material_price);
	attributes.sales_engineering_price = filterNum(attributes.sales_engineering_price);
	attributes.sales_management_price = filterNum(attributes.sales_management_price);
	
	attributes.purchase_labour_amount = filterNum(attributes.purchase_labour_amount);
	attributes.purchase_material_amount = filterNum(attributes.purchase_material_amount);
	attributes.purchase_engineering_amount = filterNum(attributes.purchase_engineering_amount);
	attributes.purchase_management_amount = filterNum(attributes.purchase_management_amount);
	attributes.sales_labour_amount = filterNum(attributes.sales_labour_amount);
	attributes.sales_material_amount = filterNum(attributes.sales_material_amount);
	attributes.sales_engineering_amount = filterNum(attributes.sales_engineering_amount);
	attributes.sales_management_amount = filterNum(attributes.sales_management_amount);
</cfscript>
<cfquery name="updRelationPBS" datasource="#dsn3#">
	UPDATE 
		RELATION_PBS_CODE 
	SET 
		DETAIL = '#attributes.rel_detail#',
		
		PURCHASE_LABOUR_PRICE = <cfif len(attributes.purchase_labour_price)>#attributes.purchase_labour_price#<cfelse>0</cfif>,
		PURCHASE_MATERIAL_PRICE = <cfif len(attributes.purchase_material_price)>#attributes.purchase_material_price#<cfelse>0</cfif>,
		PURCHASE_ENGINEERING_PRICE = <cfif len(attributes.purchase_engineering_price)>#attributes.purchase_engineering_price#<cfelse>0</cfif>,
		PURCHASE_MANAGEMENT_PRICE = <cfif len(attributes.purchase_management_price)>#attributes.purchase_management_price#<cfelse>0</cfif>,
		SALES_LABOUR_PRICE = <cfif len(attributes.sales_labour_price)>#attributes.sales_labour_price#<cfelse>0</cfif>,
		SALES_MATERIAL_PRICE = <cfif len(attributes.sales_material_price)>#attributes.sales_material_price#<cfelse>0</cfif>,
		SALES_ENGINEERING_PRICE = <cfif len(attributes.sales_engineering_price)>#attributes.sales_engineering_price#<cfelse>0</cfif>,
		SALES_MANAGEMENT_PRICE = <cfif len(attributes.sales_management_price)>#attributes.sales_management_price#<cfelse>0</cfif>,
		
		PURCHASE_LABOUR_MONEY = '#attributes.purchase_labour_money#',
		PURCHASE_MATERIAL_MONEY = '#attributes.purchase_material_money#',
		PURCHASE_ENGINEERING_MONEY = '#attributes.purchase_engineering_money#',
		PURCHASE_MANAGEMENT_MONEY = '#attributes.purchase_management_money#',
		SALES_LABOUR_MONEY = '#attributes.sales_labour_money#',
		SALES_MATERIAL_MONEY ='#attributes.sales_material_money#',
		SALES_ENGINEERING_MONEY = '#attributes.sales_engineering_money#',
		SALES_MANAGEMENT_MONEY = '#attributes.sales_management_money#',
		
		PURCHASE_LABOUR_UNIT_ID = #attributes.purchase_labour_unit_id#,
		PURCHASE_MATERIAL_UNIT_ID = #attributes.purchase_material_unit_id#,
		PURCHASE_ENGINEERING_UNIT_ID = #attributes.purchase_engineering_unit_id#,
		PURCHASE_MANAGEMENT_UNIT_ID = #attributes.purchase_management_unit_id#,
		SALES_LABOUR_UNIT_ID = #attributes.sales_labour_unit_id#,
		SALES_MATERIAL_UNIT_ID = #attributes.sales_material_unit_id#,
		SALES_ENGINEERING_UNIT_ID = #attributes.sales_engineering_unit_id#,
		SALES_MANAGEMENT_UNIT_ID = #attributes.sales_management_unit_id#,
		
		PURCHASE_LABOUR_AMOUNT = <cfif len(attributes.purchase_labour_amount)>#attributes.purchase_labour_amount#<cfelse>0</cfif>,
		PURCHASE_MATERIAL_AMOUNT = <cfif len(attributes.purchase_material_amount)>#attributes.purchase_material_amount#<cfelse>0</cfif>,
		PURCHASE_ENGINEERING_AMOUNT = <cfif len(attributes.purchase_engineering_amount)>#attributes.purchase_engineering_amount#<cfelse>0</cfif>,
		PURCHASE_MANAGEMENT_AMOUNT = <cfif len(attributes.purchase_management_amount)>#attributes.purchase_management_amount#<cfelse>0</cfif>,
		SALES_LABOUR_AMOUNT = <cfif len(attributes.sales_labour_amount)>#attributes.sales_labour_amount#<cfelse>0</cfif>,
		SALES_MATERIAL_AMOUNT = <cfif len(attributes.sales_material_amount)>#attributes.sales_material_amount#<cfelse>0</cfif>,
		SALES_ENGINEERING_AMOUNT = <cfif len(attributes.sales_engineering_amount)>#attributes.sales_engineering_amount#<cfelse>0</cfif>,
		SALES_MANAGEMENT_AMOUNT = <cfif len(attributes.sales_management_amount)>#attributes.sales_management_amount#<cfelse>0</cfif>
	WHERE
		PBS_ID = #attributes.pbs_id# AND
		<cfif isdefined('attributes.pid') and len(attributes.pid)>
			PRODUCT_ID = #attributes.pid#
		<cfelseif isdefined('attributes.opp_id') and len(attributes.opp_id)>
			OPPORTUNITY_ID = #attributes.opp_id#
		<cfelseif isdefined('attributes.project_id') and len(attributes.project_id)>
			PROJECT_ID = #attributes.project_id#	
		<cfelseif isdefined('attributes.offer_id') and len(attributes.offer_id)>
			OFFER_ID = #attributes.offer_id#
		</cfif>
</cfquery>
<cfquery name="get_relation_pbs_code" datasource="#dsn3#">
	SELECT 
		RPC.*,
		SPC.PBS_CODE,
		SPC.PBS_DETAIL,
		SPC.PBS_DETAIL2
	FROM 
		RELATION_PBS_CODE RPC,
		SETUP_PBS_CODE SPC
	WHERE 
		SPC.PBS_ID = RPC.PBS_ID AND
		SPC.PBS_ID = #attributes.pbs_id# AND
		<cfif isdefined('attributes.pid') and len(attributes.pid)>
			PRODUCT_ID = #attributes.pid#
		<cfelseif isdefined('attributes.opp_id') and len(attributes.opp_id)>
			OPPORTUNITY_ID = #attributes.opp_id#
		<cfelseif isdefined('attributes.project_id') and len(attributes.project_id)>
			PROJECT_ID = #attributes.project_id#	
		<cfelseif isdefined('attributes.offer_id') and len(attributes.offer_id)>
			OFFER_ID = #attributes.offer_id#
		</cfif>
</cfquery>

<cfif isdefined('attributes.opp_id') and len(attributes.opp_id)>
	<cfquery name="getProduct" datasource="#dsn3#">
		SELECT STOCK_ID FROM OPPORTUNITIES WHERE OPP_ID = #attributes.opp_id#
	</cfquery>
	<cfset productSelect = getProduct.STOCK_ID>	
</cfif>
<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
	<cfquery name="getProduct" datasource="#dsn#">
		SELECT PRODUCT_ID FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.project_id#
	</cfquery>
	<cfquery name="getOffer" datasource="#dsn3#">
		SELECT OFFER_ID FROM OFFER WHERE PROJECT_ID = #attributes.project_id#
	</cfquery>
	<cfquery name="getOpp" datasource="#dsn3#">
		SELECT OPP_ID FROM OPPORTUNITIES WHERE PROJECT_ID = #attributes.project_id#
	</cfquery>
</cfif>
<cfif isdefined('attributes.pid') and len(attributes.pid)>
	<cfquery name="getProject" datasource="#dsn#">
		SELECT PROJECT_ID FROM PRO_PROJECTS WHERE PRODUCT_ID = #attributes.pid#
	</cfquery>
	<cfquery name="getOpp" datasource="#dsn3#">
		SELECT DISTINCT OPP.OPP_ID FROM OPPORTUNITIES OPP,STOCKS S WHERE S.STOCK_ID = OPP.STOCK_ID AND S.PRODUCT_ID = #attributes.pid#
	</cfquery>
</cfif>


<script>
<cfoutput query="get_relation_pbs_code">
	var table = window.top.document.getElementById('table1');
	table.rows[#attributes.row_id+2#].cells[0].innerHTML = ''; 
	<cfif 
		(isdefined('productSelect') and not len(productSelect)) or 
		(isdefined('attributes.project_id') and not len(getProduct.product_id) and getOffer.recordcount eq 0 and getOpp.recordcount eq 0) or 
		(isdefined('attributes.pid') and (getProject.recordcount eq 0 and getOpp.recordcount eq 0))>
		table.rows[#attributes.row_id+2#].cells[0].innerHTML += '<a href=javascript:// onClick=sil("#attributes.row_id#","#attributes.pbs_id#");><img src="images/delete_list.gif" border="0"></a>';
	</cfif>
	table.rows[#attributes.row_id+2#].cells[0].innerHTML += '<a href=javascript:// onClick=pbs_edit("#attributes.row_id#","#pbs_id#");><img  src="images/update_list.gif" border="0"></a>';
	table.rows[#attributes.row_id+2#].cells[1].innerHTML = '#pbs_code#';
	table.rows[#attributes.row_id+2#].cells[2].innerHTML = '#left(pbs_detail,30)#';
	table.rows[#attributes.row_id+2#].cells[3].innerHTML = '#left(pbs_detail2,30)#';
	table.rows[#attributes.row_id+2#].cells[4].innerHTML = '#left(detail,30)#';
	
	table.rows[#attributes.row_id+2#].cells[5].innerHTML = '#purchase_labour_amount#';
	table.rows[#attributes.row_id+2#].cells[6].innerHTML = '<cfif len(purchase_labour_unit_id)><cfquery name="get_unit_pl" datasource="#dsn#">SELECT UNIT FROM SETUP_UNIT WHERE UNIT_ID = #purchase_labour_unit_id#</cfquery>#get_unit_pl.unit#</cfif>';
	table.rows[#attributes.row_id+2#].cells[7].innerHTML = '#TLFormat(purchase_labour_price,2)#';
	table.rows[#attributes.row_id+2#].cells[8].innerHTML = '#purchase_labour_money#';
	
	table.rows[#attributes.row_id+2#].cells[9].innerHTML = '#purchase_material_amount#';
	table.rows[#attributes.row_id+2#].cells[10].innerHTML = '<cfif len(purchase_material_unit_id)><cfquery name="get_unit_pm" datasource="#dsn#">SELECT UNIT FROM SETUP_UNIT WHERE UNIT_ID = #purchase_material_unit_id#</cfquery>#get_unit_pm.unit#</cfif>';
	table.rows[#attributes.row_id+2#].cells[11].innerHTML = '#TLFormat(purchase_material_price,2)#';
	table.rows[#attributes.row_id+2#].cells[12].innerHTML = '#purchase_material_money#';
	
	table.rows[#attributes.row_id+2#].cells[13].innerHTML = '#purchase_engineering_amount#';
	table.rows[#attributes.row_id+2#].cells[14].innerHTML = '<cfif len(purchase_engineering_unit_id)><cfquery name="get_unit_pe" datasource="#dsn#">SELECT UNIT FROM SETUP_UNIT WHERE UNIT_ID = #purchase_engineering_unit_id#</cfquery>#get_unit_pe.unit#</cfif>';
	table.rows[#attributes.row_id+2#].cells[15].innerHTML = '#TLFormat(purchase_engineering_price,2)#';
	table.rows[#attributes.row_id+2#].cells[16].innerHTML = '#purchase_engineering_money#';
	
	table.rows[#attributes.row_id+2#].cells[17].innerHTML = '#purchase_management_amount#';
	table.rows[#attributes.row_id+2#].cells[18].innerHTML = '<cfif len(purchase_management_unit_id)><cfquery name="get_unit_p_m" datasource="#dsn#">SELECT UNIT FROM SETUP_UNIT WHERE UNIT_ID = #purchase_management_unit_id#</cfquery>#get_unit_p_m.unit#</cfif>';
	table.rows[#attributes.row_id+2#].cells[19].innerHTML = '#TLFormat(purchase_management_price,2)#';
	table.rows[#attributes.row_id+2#].cells[20].innerHTML = '#purchase_management_money#';
	
	table.rows[#attributes.row_id+2#].cells[21].innerHTML = '#sales_labour_amount#';
	table.rows[#attributes.row_id+2#].cells[22].innerHTML = '<cfif len(sales_labour_unit_id)><cfquery name="get_unit_sl" datasource="#dsn#">SELECT UNIT FROM SETUP_UNIT WHERE UNIT_ID = #sales_labour_unit_id#</cfquery>#get_unit_sl.unit#</cfif>';
	table.rows[#attributes.row_id+2#].cells[23].innerHTML = '#TLFormat(sales_labour_price,2)#';
	table.rows[#attributes.row_id+2#].cells[24].innerHTML = '#sales_labour_money#';
	
	table.rows[#attributes.row_id+2#].cells[25].innerHTML = '#sales_material_amount#';
	table.rows[#attributes.row_id+2#].cells[26].innerHTML = '<cfif len(sales_material_unit_id)><cfquery name="get_unit_sm" datasource="#dsn#">SELECT UNIT FROM SETUP_UNIT WHERE UNIT_ID = #sales_material_unit_id#</cfquery>#get_unit_sm.unit#</cfif>';
	table.rows[#attributes.row_id+2#].cells[27].innerHTML = '#TLFormat(sales_material_price,2)#';
	table.rows[#attributes.row_id+2#].cells[28].innerHTML = '#sales_material_money#';
	
	table.rows[#attributes.row_id+2#].cells[29].innerHTML = '#sales_engineering_amount#';
	table.rows[#attributes.row_id+2#].cells[30].innerHTML = '<cfif len(sales_engineering_unit_id)><cfquery name="get_unit_se" datasource="#dsn#">SELECT UNIT FROM SETUP_UNIT WHERE UNIT_ID = #sales_engineering_unit_id#</cfquery>#get_unit_se.unit#</cfif>';
	table.rows[#attributes.row_id+2#].cells[31].innerHTML = '#TLFormat(sales_engineering_price,2)#';
	table.rows[#attributes.row_id+2#].cells[32].innerHTML = '#sales_engineering_money#';
	
	table.rows[#attributes.row_id+2#].cells[33].innerHTML = '#sales_management_amount#';
	table.rows[#attributes.row_id+2#].cells[34].innerHTML = '<cfif len(sales_management_unit_id)><cfquery name="get_unit_s_m" datasource="#dsn#">SELECT UNIT FROM SETUP_UNIT WHERE UNIT_ID = #sales_management_unit_id#</cfquery>#get_unit_s_m.unit#</cfif>';
	table.rows[#attributes.row_id+2#].cells[35].innerHTML = '#TLFormat(sales_management_price,2)#';
	table.rows[#attributes.row_id+2#].cells[36].innerHTML = '#sales_management_money#';
</cfoutput>
</script>
<cfabort>

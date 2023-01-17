<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.pid_') and len(attributes.pid_)>
	<cfset relation_deger = 'PRODUCT_ID=#attributes.pid_#'>
	<cfset relation_input_deger = '<input type="hidden" name="pid" value="#attributes.pid_#"/>'>
<cfelseif isdefined('attributes.opp_id_') and len(attributes.opp_id_)>
	<cfset relation_deger = 'OPPORTUNITY_ID=#attributes.opp_id_#'>
	<cfset relation_input_deger = '<input type="hidden" name="opp_id" value="#attributes.opp_id_#"/>'>
<cfelseif isdefined('attributes.project_id_') and len(attributes.project_id_)>
	<cfset relation_deger = 'PROJECT_ID=#attributes.project_id_#'>
	<cfset relation_input_deger = '<input type="hidden" name="project_id" value="#attributes.project_id_#"/>'>
<cfelseif  isdefined('attributes.offer_id_') and len(attributes.offer_id_)>
	<cfset relation_deger = 'OFFER_ID=#attributes.offer_id_#'>
	<cfset relation_input_deger = '<input type="hidden" name="offer_id" value="#attributes.offer_id_#"/>'>
</cfif>

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
		#relation_deger#
</cfquery>
<cfinclude template="../../product/query/get_money.cfm">
<cfinclude template="../../product/query/get_unit.cfm">
<script>
	function row_back_<cfoutput>#pbs_id#</cfoutput>()
	{
		var table = document.getElementById('table1');
		<cfloop from="0" to="36" index="ccc">
			<cfoutput>
				table.rows[#attributes.satir_#].cells[#ccc#].innerHTML = deger_#pbs_id#_#ccc#;
			</cfoutput> 
		</cfloop>
		<cfoutput>
			table.rows[#attributes.satir_#].style.backgroundColor = '';
		</cfoutput>
	}
	
	function upd_row_<cfoutput>#pbs_id#</cfoutput>()
	{	
	var table = document.getElementById('table1');
	<cfloop from="0" to="36" index="ccc">
		<cfoutput>
			deger_#pbs_id#_#ccc# = document.getElementById("table1").rows[#attributes.satir_#].cells[#ccc#].innerHTML;
		</cfoutput> 
	</cfloop>
	
	<cfoutput query="get_relation_pbs_code">
		table.rows[#attributes.satir_#].cells[0].innerHTML =  "<a href=javascript:// onClick=row_back_#pbs_id#(); style='color:black;'><cf_get_lang dictionary_id='57462.Vazgeç'></a>&nbsp;|&nbsp;";
		table.rows[#attributes.satir_#].cells[0].innerHTML += "<a href=javascript:// onClick=update_pbs('#attributes.satir_-2#','#pbs_id#'); style='color:black;'><cf_get_lang dictionary_id='57464.Güncelle'></a>";
	
		table.rows[#attributes.satir_#].cells[1].innerHTML =  '<input type="hidden" name="pbs_id_#pbs_id#" id="pbs_id_#pbs_id#" value="#pbs_id#"/>';
		table.rows[#attributes.satir_#].cells[1].innerHTML += '<input type="text" name="pbs_code_#pbs_id#" id="pbs_code_#pbs_id#" value="#pbs_code#" style="width:65px;" class="boxtext" readonly/>';
		
		table.rows[#attributes.satir_#].cells[2].innerHTML = '<input type="text" title="#XmlFormat(pbs_detail)#" name="pbs_detail_#pbs_id#" id="pbs_detail_#pbs_id#" style="width:100px;" value="#XmlFormat(pbs_detail)#" class="boxtext" readonly />';
		
		table.rows[#attributes.satir_#].cells[3].innerHTML = '<input type="text" title="#XmlFormat(pbs_detail2)#" name="pbs_detail2_#pbs_id#" id="pbs_detail2_#pbs_id#" style="width:100px;" value="#XmlFormat(pbs_detail2)#" class="boxtext" readonly />';
		
		table.rows[#attributes.satir_#].cells[4].innerHTML = '<input type="text" name="rel_detail_#pbs_id#" id="rel_detail_#pbs_id#" style="width:100px;" value="#XmlFormat(detail)#"/>';
		//Alis Iscilik
		table.rows[#attributes.satir_#].cells[5].innerHTML = '<input type="text" id="purchase_labour_amount_#pbs_id#" name="purchase_labour_amount_#pbs_id#" value="#TLFormat(purchase_labour_amount,2)#" style="width:25px;" />';
		table.rows[#attributes.satir_#].cells[6].innerHTML = '<select id="purchase_labour_unit_id_#pbs_id#" name="purchase_labour_unit_id_#pbs_id#" style="width:50px;"><cfloop query="get_unit"><option value="#get_unit.unit_id#" <cfif get_unit.unit_id eq get_relation_pbs_code.purchase_labour_unit_id>selected</cfif>>#get_unit.unit#</option></cfloop></select>';
		table.rows[#attributes.satir_#].cells[7].innerHTML = '<input type="text" id="purchase_labour_price_#pbs_id#" name="purchase_labour_price_#pbs_id#" value="#TLFormat(purchase_labour_price,2)#" style="width:40px;" class="moneybox" />';
		table.rows[#attributes.satir_#].cells[8].innerHTML = '<select id="purchase_labour_money_#pbs_id#" name="purchase_labour_money_#pbs_id#" style="width:50px;"><cfloop query="GET_MONEY"><option value="#GET_MONEY.money#" <cfif GET_MONEY.money is get_relation_pbs_code.purchase_labour_money>selected</cfif>>#GET_MONEY.MONEY#</option></cfloop></select>';
		//Alis malzeme
		table.rows[#attributes.satir_#].cells[9].innerHTML = '<input type="text" id="purchase_material_amount_#pbs_id#" name="purchase_material_amount_#pbs_id#" value="#TLFormat(purchase_material_amount,2)#" style="width:25px;" />';
		table.rows[#attributes.satir_#].cells[10].innerHTML = '<select id="purchase_material_unit_id_#pbs_id#" name="purchase_material_unit_id_#pbs_id#" style="width:50px;"><cfloop query="get_unit"><option value="#get_unit.unit_id#" <cfif get_unit.unit_id eq get_relation_pbs_code.purchase_material_unit_id>selected</cfif>>#get_unit.unit#</option></cfloop></select>';
		table.rows[#attributes.satir_#].cells[11].innerHTML = '<input type="text" id="purchase_material_price_#pbs_id#" name="purchase_material_price_#pbs_id#" value="#TLFormat(purchase_material_price,2)#" style="width:40px;" class="moneybox" />';
		table.rows[#attributes.satir_#].cells[12].innerHTML = '<select id="purchase_material_money_#pbs_id#" name="purchase_material_money_#pbs_id#" style="width:50px;"><cfloop query="GET_MONEY"><option value="#GET_MONEY.money#" <cfif GET_MONEY.money is get_relation_pbs_code.purchase_material_money>selected</cfif>>#GET_MONEY.MONEY#</option></cfloop></select>';
		//Alis muhendislik
		table.rows[#attributes.satir_#].cells[13].innerHTML = '<input type="text" id="purchase_engineering_amount_#pbs_id#" name="purchase_engineering_amount_#pbs_id#" value="#TLFormat(purchase_engineering_amount,2)#" style="width:25px;" />';
		table.rows[#attributes.satir_#].cells[14].innerHTML = '<select id="purchase_engineering_unit_id_#pbs_id#" name="purchase_engineering_unit_id_#pbs_id#" style="width:50px;"><cfloop query="get_unit"><option value="#get_unit.unit_id#" <cfif get_unit.unit_id eq get_relation_pbs_code.purchase_engineering_unit_id>selected</cfif>>#get_unit.unit#</option></cfloop></select>';
		table.rows[#attributes.satir_#].cells[15].innerHTML = '<input type="text" id="purchase_engineering_price_#pbs_id#" name="purchase_engineering_price_#pbs_id#" value="#TLFormat(purchase_engineering_price,2)#" style="width:40px;" class="moneybox" />';
		table.rows[#attributes.satir_#].cells[16].innerHTML = '<select id="purchase_engineering_money_#pbs_id#" name="purchase_engineering_money_#pbs_id#" style="width:50px;"><cfloop query="GET_MONEY"><option value="#GET_MONEY.money#" <cfif GET_MONEY.money is get_relation_pbs_code.purchase_engineering_money>selected</cfif>>#GET_MONEY.MONEY#</option></cfloop></select>';
		//Alis yonetim
		table.rows[#attributes.satir_#].cells[17].innerHTML = '<input type="text" id="purchase_management_amount_#pbs_id#" name="purchase_management_amount_#pbs_id#" value="#TLFormat(purchase_management_amount,2)#" style="width:25px;" />';
		table.rows[#attributes.satir_#].cells[18].innerHTML = '<select id="purchase_management_unit_id_#pbs_id#" name="purchase_management_unit_id_#pbs_id#" style="width:50px;"><cfloop query="get_unit"><option value="#get_unit.unit_id#" <cfif get_unit.unit_id eq get_relation_pbs_code.purchase_management_unit_id>selected</cfif>>#get_unit.unit#</option></cfloop></select>';
		table.rows[#attributes.satir_#].cells[19].innerHTML = '<input type="text" id="purchase_management_price_#pbs_id#" name="purchase_management_price_#pbs_id#" value="#TLFormat(purchase_management_price,2)#" style="width:40px;" class="moneybox" />';
		table.rows[#attributes.satir_#].cells[20].innerHTML = '<select id="purchase_management_money_#pbs_id#" name="purchase_management_money_#pbs_id#" style="width:50px;"><cfloop query="GET_MONEY"><option value="#GET_MONEY.money#" <cfif GET_MONEY.money is get_relation_pbs_code.purchase_management_money>selected</cfif>>#GET_MONEY.MONEY#</option></cfloop></select>';
		//satis iscilik
		table.rows[#attributes.satir_#].cells[21].innerHTML = '<input type="text" id="sales_labour_amount_#pbs_id#"  name="sales_labour_amount_#pbs_id#" value="#TLFormat(sales_labour_amount,2)#" style="width:25px;" />';
		table.rows[#attributes.satir_#].cells[22].innerHTML = '<select id="sales_labour_unit_id_#pbs_id#"  name="sales_labour_unit_id_#pbs_id#" style="width:50px;"><cfloop query="get_unit"><option value="#get_unit.unit_id#" <cfif get_unit.unit_id eq get_relation_pbs_code.sales_labour_unit_id>selected</cfif>>#get_unit.unit#</option></cfloop></select>';
		table.rows[#attributes.satir_#].cells[23].innerHTML = '<input type="text" id="sales_labour_price_#pbs_id#"  name="sales_labour_price_#pbs_id#" value="#TLFormat(sales_labour_price,2)#" style="width:40px;" class="moneybox" />';
		table.rows[#attributes.satir_#].cells[24].innerHTML = '<select id="sales_labour_money_#pbs_id#" name="sales_labour_money_#pbs_id#" style="width:50px;"><cfloop query="GET_MONEY"><option value="#GET_MONEY.money#" <cfif GET_MONEY.money is get_relation_pbs_code.sales_labour_money>selected</cfif>>#GET_MONEY.MONEY#</option></cfloop></select>';
		//satis malzeme
		table.rows[#attributes.satir_#].cells[25].innerHTML = '<input type="text" id="sales_material_amount_#pbs_id#" name="sales_material_amount_#pbs_id#" value="#TLFormat(sales_material_amount,2)#" style="width:25px;" />';
		table.rows[#attributes.satir_#].cells[26].innerHTML = '<select id="sales_material_unit_id_#pbs_id#" name="sales_material_unit_id_#pbs_id#" style="width:50px;"><cfloop query="get_unit"><option value="#get_unit.unit_id#" <cfif get_unit.unit_id eq get_relation_pbs_code.sales_material_unit_id>selected</cfif>>#get_unit.unit#</option></cfloop></select>';
		table.rows[#attributes.satir_#].cells[27].innerHTML = '<input type="text" id="sales_material_price_#pbs_id#"  name="sales_material_price_#pbs_id#" value="#TLFormat(purchase_material_price,2)#" style="width:40px;" class="moneybox" />';
		table.rows[#attributes.satir_#].cells[28].innerHTML = '<select id="sales_material_money_#pbs_id#"  name="sales_material_money_#pbs_id#" style="width:50px;"><cfloop query="GET_MONEY"><option value="#GET_MONEY.money#" <cfif GET_MONEY.money is get_relation_pbs_code.sales_material_money>selected</cfif>>#GET_MONEY.MONEY#</option></cfloop></select>';
		//satis muhendislik
		table.rows[#attributes.satir_#].cells[29].innerHTML = '<input type="text" id="sales_engineering_amount_#pbs_id#"  name="sales_engineering_amount_#pbs_id#" value="#TLFormat(sales_engineering_amount,2)#" style="width:25px;" />';
		table.rows[#attributes.satir_#].cells[30].innerHTML = '<select id="sales_engineering_unit_id_#pbs_id#"  name="sales_engineering_unit_id_#pbs_id#" style="width:50px;"><cfloop query="get_unit"><option value="#get_unit.unit_id#" <cfif get_unit.unit_id eq get_relation_pbs_code.sales_engineering_unit_id>selected</cfif>>#get_unit.unit#</option></cfloop></select>';
		table.rows[#attributes.satir_#].cells[31].innerHTML = '<input type="text" id="sales_engineering_price_#pbs_id#" name="sales_engineering_price_#pbs_id#" value="#TLFormat(sales_engineering_price,2)#" style="width:40px;" class="moneybox" />';
		table.rows[#attributes.satir_#].cells[32].innerHTML = '<select id="sales_engineering_money_#pbs_id#" name="sales_engineering_money_#pbs_id#" style="width:50px;"><cfloop query="GET_MONEY"><option value="#GET_MONEY.money#" <cfif GET_MONEY.money is get_relation_pbs_code.sales_engineering_money>selected</cfif>>#GET_MONEY.MONEY#</option></cfloop></select>';
		//satis yonetim
		table.rows[#attributes.satir_#].cells[33].innerHTML = '<input type="text" id="sales_management_amount_#pbs_id#" name="sales_management_amount_#pbs_id#" value="#TLFormat(sales_management_amount,2)#" style="width:25px;" />';
		table.rows[#attributes.satir_#].cells[34].innerHTML = '<select id="sales_management_unit_id_#pbs_id#"  name="sales_management_unit_id_#pbs_id#" style="width:50px;"><cfloop query="get_unit"><option value="#get_unit.unit_id#" <cfif get_unit.unit_id eq get_relation_pbs_code.sales_management_unit_id>selected</cfif>>#get_unit.unit#</option></cfloop></select>';
		table.rows[#attributes.satir_#].cells[35].innerHTML = '<input type="text" id="sales_management_price_#pbs_id#" name="sales_management_price_#pbs_id#" value="#TLFormat(sales_management_price,2)#" style="width:40px;" class="moneybox" />';
		table.rows[#attributes.satir_#].cells[36].innerHTML = '<select id="sales_management_money_#pbs_id#"  name="sales_management_money_#pbs_id#" style="width:50px;"><cfloop query="GET_MONEY"><option value="#GET_MONEY.money#" <cfif GET_MONEY.money is get_relation_pbs_code.sales_management_money>selected</cfif>>#GET_MONEY.MONEY#</option></cfloop></select>';
	</cfoutput>
}
upd_row_<cfoutput>#pbs_id#</cfoutput>();
</script>

<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.pid') and len(attributes.pid)>
	<cfset attribute_deger = 'pid=#attributes.pid#'>
	<cfset relation_deger = 'PRODUCT_ID=#attributes.pid#'>
<cfelseif isdefined('attributes.opp_id') and len(attributes.opp_id)>
	<cfset attribute_deger = 'opp_id=#attributes.opp_id#'>
	<cfset relation_deger = 'OPPORTUNITY_ID=#attributes.opp_id#'>
<cfelseif isdefined('attributes.project_id') and len(attributes.project_id)>
	<cfset attribute_deger = 'project_id=#attributes.project_id#'>
	<cfset relation_deger = 'PROJECT_ID=#attributes.project_id#'>
<cfelseif  isdefined('attributes.offer_id') and len(attributes.offer_id)>
	<cfset attribute_deger = 'offer_id=#attributes.offer_id#'>
	<cfset relation_deger = 'OFFER_ID=#attributes.offer_id#'>
</cfif>

<cfquery name="get_pbs_code" datasource="#dsn3#">
	SELECT 
		PBS_ID,
		PBS_CODE,
		PBS_DETAIL,
		PBS_DETAIL2,
		<cfif attributes.is_price eq 1>
			PURCHASE_LABOUR_PRICE,
			PURCHASE_LABOUR_MONEY,
			SALES_LABOUR_PRICE,
			SALES_LABOUR_MONEY,
			PURCHASE_LABOUR_UNIT_ID,
			SALES_LABOUR_UNIT_ID,
			PURCHASE_MATERIAL_PRICE,
			PURCHASE_MATERIAL_MONEY,
			SALES_MATERIAL_PRICE,
			SALES_MATERIAL_MONEY,
			PURCHASE_MATERIAL_UNIT_ID,
			SALES_MATERIAL_UNIT_ID,
			PURCHASE_ENGINEERING_PRICE,
			PURCHASE_ENGINEERING_MONEY,
			SALES_ENGINEERING_PRICE,
			SALES_ENGINEERING_MONEY,
			PURCHASE_ENGINEERING_UNIT_ID,
			SALES_ENGINEERING_UNIT_ID,
			PURCHASE_MANAGEMENT_PRICE,
			PURCHASE_MANAGEMENT_MONEY,
			SALES_MANAGEMENT_PRICE,
			SALES_MANAGEMENT_MONEY,
			PURCHASE_MANAGEMENT_UNIT_ID,
			SALES_MANAGEMENT_UNIT_ID
		<cfelse>
			0 AS PURCHASE_LABOUR_PRICE,
			'' AS PURCHASE_LABOUR_MONEY,
			0 AS SALES_LABOUR_PRICE,
			'' AS SALES_LABOUR_MONEY,
			'' AS PURCHASE_LABOUR_UNIT_ID,
			'' AS SALES_LABOUR_UNIT_ID,
			0 AS PURCHASE_MATERIAL_PRICE,
			'' AS PURCHASE_MATERIAL_MONEY,
			0 AS SALES_MATERIAL_PRICE,
			'' AS SALES_MATERIAL_MONEY,
			'' AS PURCHASE_MATERIAL_UNIT_ID,
			'' AS SALES_MATERIAL_UNIT_ID,
			0 AS PURCHASE_ENGINEERING_PRICE,
			'' AS PURCHASE_ENGINEERING_MONEY,
			0 AS SALES_ENGINEERING_PRICE,
			'' AS SALES_ENGINEERING_MONEY,
			'' AS PURCHASE_ENGINEERING_UNIT_ID,
			'' AS SALES_ENGINEERING_UNIT_ID,
			0 AS PURCHASE_MANAGEMENT_PRICE,
			'' AS PURCHASE_MANAGEMENT_MONEY,
			0 AS SALES_MANAGEMENT_PRICE,
			'' AS SALES_MANAGEMENT_MONEY,
			'' AS PURCHASE_MANAGEMENT_UNIT_ID,
			'' AS SALES_MANAGEMENT_UNIT_ID
		</cfif>
	FROM 
		SETUP_PBS_CODE 
	WHERE 
		PBS_ID = #attributes.pbs_id#
</cfquery>
<cfinclude template="../../product/query/get_money.cfm">
<cfinclude template="../../product/query/get_unit.cfm">
  <cfform name="add_relation_pbs" method="post" action="#request.self#?fuseaction=product.emptypopup_add_relation_pbs">
  	<cfif isdefined('attributes.pid') and len(attributes.pid)>
		<input type="hidden" name="pid_" id="pid_" value="<cfoutput>#attributes.pid#</cfoutput>" />
	<cfelseif isdefined('attributes.opp_id') and len(attributes.opp_id)>
		<input type="hidden" name="opp_id_" id="opp_id_" value="<cfoutput>#attributes.opp_id#</cfoutput>" />
	<cfelseif isdefined('attributes.project_id') and len(attributes.project_id)>
		<input type="hidden" name="project_id_" id="project_id_" value="<cfoutput>#attributes.project_id#</cfoutput>" />
	<cfelseif  isdefined('attributes.offer_id') and len(attributes.offer_id)>
		<input type="hidden" name="offer_id_" id="offer_id_" value="<cfoutput>#attributes.offer_id#</cfoutput>" />
	</cfif>
	  <cfoutput>
      <table>
          <tr height="20">
            <td><b><cf_get_lang dictionary_id='45155.PBS Code'></b> : #get_pbs_code.pbs_code#</td>
          </tr>
          <tr height="20">
            <td><b><cf_get_lang dictionary_id='58233.Tanım'></b> : #get_pbs_code.pbs_detail#</td>
          </tr>
          <tr height="20">
            <td><b><cf_get_lang dictionary_id='58233.Tanım'>2</b> : #get_pbs_code.pbs_detail2#</td>
          </tr>
          <tr height="20">
            <td><b><cf_get_lang dictionary_id='57629.Açıklama'></b> : <input type="text" name="rel_detail" id="rel_detail" value="" style="width:250px;" /></td>
          </tr>
      </table>
	  </cfoutput>
      	<cf_medium_list>
            <thead>
				<tr>
					<th style="text-align:center;" colspan="5" width="25%"><cf_get_lang dictionary_id='57784.İşçilik'></th>
					<th style="text-align:center;" colspan="4" width="25%"><cf_get_lang dictionary_id='38326.Malzeme'></th>
					<th style="text-align:center;" colspan="4" width="25%"><cf_get_lang dictionary_id='45607.Mühendislik'></th>
					<th style="text-align:center;" colspan="4" width="25%"><cf_get_lang dictionary_id='59352.Yönetim'></th>
				</tr>
				<tr class="color-list">
					<th width="50"></th>
					<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id='57636.Birim'></th>
					<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id='57638.B.Fiyat'></th>
					<th class="txtboldblue" style="text-align:center">P.B</th>
					
					<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id='57636.Birim'></th>
					<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id='57638.B.Fiyat'></th>
					<th class="txtboldblue" style="text-align:center">P.B</th>
					
					<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id='57636.Birim'></th>
					<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id='57638.B.Fiyat'></th>
					<th class="txtboldblue" style="text-align:center">P.B</th>
					
					<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id='57636.Birim'></th>
					<th class="txtboldblue" style="text-align:center"><cf_get_lang dictionary_id='57638.B.Fiyat'></th>
					<th class="txtboldblue" style="text-align:center">P.B</th>
				</tr>
              </thead>
              <tbody>
				<cfif get_pbs_code.recordcount>
					<cfoutput query="get_pbs_code">
						<input type="hidden" name="pbs_id" id="pbs_id" value="#get_pbs_code.pbs_id#" />
						<tr class="color-row">
							<!--- Alıs iscilik --->
							<td class="txtboldblue"><cf_get_lang dictionary_id='39821.Alış'></td>
							<td><input type="text" name="purchase_labour_amount" id="purchase_labour_amount" value="" style="width:25px;" /></td>
							<td>
								<select name="purchase_labour_unit_id" id="purchase_labour_unit_id" style="width:50px;">
									<cfloop query="get_unit">
										<option value="#get_unit.unit_id#" <cfif get_unit.unit_id eq get_pbs_code.purchase_labour_unit_id>selected</cfif>>#get_unit.unit#</option>
									</cfloop>
								</select>
							</td>
							<td><input type="text" name="purchase_labour_price" id="purchase_labour_price" value="#TLFormat(purchase_labour_price,2)#" style="width:40px;" class="moneybox" /></td>
							<td>
								<select name="purchase_labour_money" id="purchase_labour_money" style="width:50px;">
								  <cfloop query="GET_MONEY">
									<option value="#GET_MONEY.money#" <cfif GET_MONEY.money is get_pbs_code.purchase_labour_money>selected</cfif>>#GET_MONEY.MONEY#</option>
								  </cfloop>
								</select>
							</td>
							<!--- Alıs malzeme --->
							<td><input type="text" name="purchase_material_amount" id="purchase_material_amount" value="" style="width:25px;" /></td>
							<td>
								<select name="purchase_material_unit_id" id="purchase_material_unit_id" style="width:50px;">
									<cfloop query="get_unit">
										<option value="#get_unit.unit_id#" <cfif get_unit.unit_id eq get_pbs_code.purchase_material_unit_id>selected</cfif>>#get_unit.unit#</option>
									</cfloop>
								</select>
							</td>
							<td><input type="text" name="purchase_material_price" id="purchase_material_price" value="#TLFormat(purchase_material_price,2)#" style="width:40px;" class="moneybox" /></td>
							<td>
								<select name="purchase_material_money" id="purchase_material_money" style="width:50px;">
								  <cfloop query="GET_MONEY">
									<option value="#GET_MONEY.money#" <cfif GET_MONEY.money is get_pbs_code.purchase_material_money>selected</cfif>>#GET_MONEY.MONEY#</option>
								  </cfloop>
								</select>
							</td>
							<!--- Alıs muhendislik --->
							<td><input type="text" name="purchase_engineering_amount" id="purchase_engineering_amount" value="" style="width:25px;" /></td>
							<td>
								<select name="purchase_engineering_unit_id" id="purchase_engineering_unit_id" style="width:50px;">
									<cfloop query="get_unit">
										<option value="#get_unit.unit_id#" <cfif get_unit.unit_id eq get_pbs_code.purchase_engineering_unit_id>selected</cfif>>#get_unit.unit#</option>
									</cfloop>
								</select>
							</td>
							<td><input type="text" name="purchase_engineering_price" id="purchase_engineering_price" value="#TLFormat(purchase_engineering_price,2)#" style="width:40px;" class="moneybox" /></td>
							<td>
								<select name="purchase_engineering_money" id="purchase_engineering_money" style="width:50px;">
								  <cfloop query="GET_MONEY">
									<option value="#GET_MONEY.money#" <cfif GET_MONEY.money is get_pbs_code.purchase_engineering_money>selected</cfif>>#GET_MONEY.MONEY#</option>
								  </cfloop>
								</select>
							</td>
							<!--- Alıs yonetim --->
							<td><input type="text" name="purchase_management_amount" id="purchase_management_amount" value="" style="width:25px;" /></td>
							<td>
								<select name="purchase_management_unit_id" id="purchase_management_unit_id" style="width:50px;">
									<cfloop query="get_unit">
										<option value="#get_unit.unit_id#" <cfif get_unit.unit_id eq get_pbs_code.purchase_management_unit_id>selected</cfif>>#get_unit.unit#</option>
									</cfloop>
								</select>
							</td>
							<td><input type="text" name="purchase_management_price" id="purchase_management_price" value="#TLFormat(purchase_management_price,2)#" style="width:40px;" class="moneybox" /></td>
							<td>
								<select name="purchase_management_money" id="purchase_management_money" style="width:50px;">
								  <cfloop query="GET_MONEY">
									<option value="#GET_MONEY.money#" <cfif GET_MONEY.money is get_pbs_code.purchase_management_money>selected</cfif>>#GET_MONEY.MONEY#</option>
								  </cfloop>
								</select>
							</td>
						</tr>
						<tr class="color-row">
							<td class="txtboldblue"><cf_get_lang dictionary_id='32574.Satış'></td>
							<!--- satıs iscilik --->
							<td><input type="text" name="sales_labour_amount" id="sales_labour_amount" value="" style="width:25px;" /></td>
							<td>
								<select name="sales_labour_unit_id" id="sales_labour_unit_id" style="width:50px;">
									<cfloop query="get_unit">
										<option value="#get_unit.unit_id#" <cfif get_unit.unit_id eq get_pbs_code.sales_labour_unit_id>selected</cfif>>#get_unit.unit#</option>
									</cfloop>
								</select>
							</td>
							<td><input type="text" name="sales_labour_price" id="sales_labour_price" value="#TLFormat(sales_labour_price,2)#" style="width:40px;" class="moneybox" /></td>
							<td>
								<select name="sales_labour_money" id="sales_labour_money" style="width:50px;">
								  <cfloop query="GET_MONEY">
									<option value="#GET_MONEY.money#" <cfif GET_MONEY.money is get_pbs_code.sales_labour_money>selected</cfif>>#GET_MONEY.MONEY#</option>
								  </cfloop>
								</select>
							</td>
							<!--- satıs malzeme --->
							<td><input type="text" name="sales_material_amount" id="sales_material_amount" value="" style="width:25px;" /></td>
							<td>
								<select name="sales_material_unit_id" id="sales_material_unit_id" style="width:50px;">
									<cfloop query="get_unit">
										<option value="#get_unit.unit_id#" <cfif get_unit.unit_id eq get_pbs_code.sales_material_unit_id>selected</cfif>>#get_unit.unit#</option>
									</cfloop>
								</select>
							</td>
							<td><input type="text" name="sales_material_price" id="sales_material_price" value="#TLFormat(sales_material_price,2)#" style="width:40px;" class="moneybox" /></td>
							<td>
								<select name="sales_material_money" id="sales_material_money" style="width:50px;">
								  <cfloop query="GET_MONEY">
									<option value="#GET_MONEY.money#" <cfif GET_MONEY.money is get_pbs_code.sales_material_money>selected</cfif>>#GET_MONEY.MONEY#</option>
								  </cfloop>
								</select>
							</td>
							<!--- satıs muhendislik --->
							<td><input type="text" name="sales_engineering_amount" id="sales_engineering_amount" value="" style="width:25px;" /></td>
							<td>
								<select name="sales_engineering_unit_id" id="sales_engineering_unit_id" style="width:50px;">
									<cfloop query="get_unit">
										<option value="#get_unit.unit_id#" <cfif get_unit.unit_id eq get_pbs_code.sales_engineering_unit_id>selected</cfif>>#get_unit.unit#</option>
									</cfloop>
								</select>
							</td>
							<td><input type="text" name="sales_engineering_price" id="sales_engineering_price" value="#TLFormat(sales_engineering_price,2)#" style="width:40px;" class="moneybox" /></td>
							<td>
								<select name="sales_engineering_money" id="sales_engineering_money" style="width:50px;">
								  <cfloop query="GET_MONEY">
									<option value="#GET_MONEY.money#" <cfif GET_MONEY.money is get_pbs_code.sales_engineering_money>selected</cfif>>#GET_MONEY.MONEY#</option>
								  </cfloop>
								</select>
							</td>
							<!--- satıs yonetim --->
							<td><input type="text" name="sales_management_amount" id="sales_management_amount" value="" style="width:25px;" /></td>
							<td>
								<select name="sales_management_unit_id" id="sales_management_unit_id" style="width:50px;">
									<cfloop query="get_unit">
										<option value="#get_unit.unit_id#" <cfif get_unit.unit_id eq get_pbs_code.sales_management_unit_id>selected</cfif>>#get_unit.unit#</option>
									</cfloop>
								</select>
							</td>
							<td><input type="text" name="sales_management_price" id="sales_management_price" value="#TLFormat(sales_management_price,2)#" style="width:40px;" class="moneybox" /></td>
							<td>
								<select name="sales_management_money" id="sales_management_money" style="width:50px;">
								  <cfloop query="GET_MONEY">
									<option value="#GET_MONEY.money#" <cfif GET_MONEY.money is get_pbs_code.sales_management_money>selected</cfif>>#GET_MONEY.MONEY#</option>
								  </cfloop>
								</select>
							</td>
						</tr>
					</cfoutput>
				</cfif>
                </tbody>
                <tfoot>
                    <tr>
                        <td style="text-align:right;" colspan="17"><input type="button" value="Ekle" onClick="add_pbs();"></td>
                    </tr>
                </tfoot>
		</cf_medium_list>
  </cfform>
<div id="message_"></div>
<script language="javascript">
<cfoutput>
	function add_pbs()
	{
		pbs_id_ = document.getElementById('pbs_id').value;
		var getRelationPBS = wrk_query('SELECT PBS_ID FROM RELATION_PBS_CODE WHERE #relation_deger# AND PBS_ID = '+pbs_id_,'dsn3');
		if(getRelationPBS.recordcount != 0)
		{
			alert('İlişkili PBS Kaydı Bulunmaktadır.');
			return false;
		}
		AjaxFormSubmit('add_relation_pbs','message_','1','Kaydediliyor..','Kaydedildi','#request.self#?fuseaction=product.emptypopup_relation_pbs_list&#attribute_deger#','pbs_list');
	}
</cfoutput>
</script>

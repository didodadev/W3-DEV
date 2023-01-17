<cfsetting showdebugoutput="no">
<cfquery name="GET_BRANCH_RELATED" datasource="#DSN#">
	SELECT 
		CUSTOMER_TYPE_ID,
		TARGET_CUSTOMER_TYPE_ID,
		MAIN_LOCATION_CAT_ID,
		ENDORSEMENT_CAT_ID,
		PROFITABILITY_CAT_ID,
		RISK_CAT_ID,
		SPECIAL_STATE_CAT_ID
	FROM
		COMPANY_BRANCH_RELATED
	WHERE
		RELATED_ID = #attributes.related_id# AND
		CUSTOMER_TYPE_ID IS NOT NULL AND
		TARGET_CUSTOMER_TYPE_ID IS NOT NULL AND
		MAIN_LOCATION_CAT_ID IS NOT NULL AND
		ENDORSEMENT_CAT_ID IS NOT NULL AND
		PROFITABILITY_CAT_ID IS NOT NULL AND
		RISK_CAT_ID IS NOT NULL AND
		SPECIAL_STATE_CAT_ID IS NOT NULL
</cfquery>
<cfif get_branch_related.recordcount>
	<cfquery name="GET_CUSTOMER_TYPE" datasource="#DSN#">
		SELECT CUSTOMER_TYPE,DETAIL FROM SETUP_CUSTOMER_TYPE WHERE CUSTOMER_TYPE_ID = #get_branch_related.customer_type_id#
	</cfquery>
	<cfquery name="GET_CUSTOMER_TYPE2" datasource="#DSN#">
		SELECT CUSTOMER_TYPE_ID,CUSTOMER_TYPE,IS_CONTROL,CONTROL_RATE,DETAIL FROM SETUP_CUSTOMER_TYPE WHERE CUSTOMER_TYPE_ID = #get_branch_related.target_customer_type_id#
	</cfquery>
	<cfquery name="GET_MAIN_LOCATION_CAT" datasource="#DSN#">
		SELECT MAIN_LOCATION_CAT FROM SETUP_MAIN_LOCATION_CAT WHERE MAIN_LOCATION_CAT_ID = #get_branch_related.main_location_cat_id#
	</cfquery>
	<cfquery name="GET_ENDORSEMENT_CAT" datasource="#DSN#">
		SELECT ENDORSEMENT_CAT FROM SETUP_ENDORSEMENT_CAT WHERE ENDORSEMENT_CAT_ID = #get_branch_related.endorsement_cat_id#
	</cfquery>
	<cfquery name="GET_PROFITABILITY_CAT" datasource="#DSN#">
		SELECT PROFITABILITY_CAT FROM SETUP_PROFITABILITY_CAT WHERE PROFITABILITY_CAT_ID = #get_branch_related.profitability_cat_id#
	</cfquery>
	<cfquery name="GET_RISK_CAT" datasource="#DSN#">
		SELECT RISK_CAT FROM SETUP_RISK_CAT WHERE RISK_CAT_ID = #get_branch_related.risk_cat_id#
	</cfquery>
	<cfquery name="GET_SPECIAL_STATE_CAT" datasource="#DSN#">
		SELECT SPECIAL_STATE_CAT FROM SETUP_SPECIAL_STATE_CAT WHERE SPECIAL_STATE_CAT_ID = #get_branch_related.special_state_cat_id#
	</cfquery>
	
	<!--- Guncelleme sayfası ise --->
	<cfif isdefined("attributes.contract_id")>
		<cfquery name="GET_DUTY_TYPE" datasource="#DSN#">
			SELECT 
				SDUC.DUTY_UNIT_CAT,
				SDT.DUTY_TYPE,
				SDT.IS_VALUE,
				SDT.IS_TARGET,
				CBCR.DUTY_TYPE_ID,
				CBCR.COST_AMOUNT,
				CBCR.TARGET_PERIOD_ID,
				CBCR.TARGET_AMOUNT				
			FROM
				SETUP_DUTY_TYPE SDT,
				SETUP_DUTY_UNIT_CAT SDUC,
				COMPANY_BRANCH_CONTRACT_ROW CBCR
			WHERE				
				CBCR.CONTRACT_ID = #attributes.contract_id# AND
				SDT.DUTY_TYPE_ID = CBCR.DUTY_TYPE_ID AND
				SDT.DUTY_UNIT_CAT_ID = SDUC.DUTY_UNIT_CAT_ID AND
				SDT.IS_CATEGORY = 0
		</cfquery>
		<!--- Ek Hizmetler --->
		<cfquery name="GET_DUTY_TYPE_" datasource="#DSN#">
			SELECT 
				SDUC.DUTY_UNIT_CAT,
				SDT.DUTY_TYPE,
				SDT.IS_VALUE,
				SDT.IS_TARGET,
				CBCR.DUTY_TYPE_ID,
				CBCR.COST_AMOUNT,
				CBCR.TARGET_PERIOD_ID,
				CBCR.TARGET_AMOUNT				
			FROM
				SETUP_DUTY_TYPE SDT,
				SETUP_DUTY_UNIT_CAT SDUC,
				COMPANY_BRANCH_CONTRACT_ROW CBCR
			WHERE				
				CBCR.CONTRACT_ID = #attributes.contract_id# AND
				SDT.DUTY_TYPE_ID = CBCR.DUTY_TYPE_ID AND
				SDT.DUTY_UNIT_CAT_ID = SDUC.DUTY_UNIT_CAT_ID AND
				SDT.IS_CATEGORY = 1
		</cfquery>
	<!--- Ekleme sayfası ise --->
	<cfelse>
		<cfquery name="GET_DUTY_TYPE" datasource="#DSN#">
			SELECT 
				SDUC.DUTY_UNIT_CAT,
				SDT.*	
			FROM
				SETUP_DUTY_TYPE SDT,
				SETUP_DUTY_UNIT_CAT SDUC
			WHERE
				SDT.IS_CATEGORY = 0 AND
			<cfif not isdefined("attributes.target_customer_type")>
				SDT.CUSTOMER_TYPE_ID LIKE '%,#get_branch_related.target_customer_type_id#,%' AND
			<cfelse>
				SDT.CUSTOMER_TYPE_ID LIKE '%,#attributes.target_customer_type#,%' AND
			</cfif>
				SDT.DUTY_UNIT_CAT_ID = SDUC.DUTY_UNIT_CAT_ID
		</cfquery>
		<!--- Musteri Tipi Aciklama Icin Aciklama ve Uyari  --->
		<cfif isdefined("attributes.target_customer_type")>
			<cfquery name="GET_CUSTOMER_TYPE_TARGET" datasource="#DSN#">
				SELECT DETAIL,IS_CONTROL,CONTROL_RATE FROM SETUP_CUSTOMER_TYPE WHERE CUSTOMER_TYPE_ID = #attributes.target_customer_type#
			</cfquery>
			<script type="text/javascript">
				document.getElementById('customer_type_detail').value="<cfoutput>#get_customer_type_target.detail#</cfoutput>";
				document.getElementById('is_control').value="<cfoutput>#get_customer_type_target.is_control#</cfoutput>";
				document.getElementById('control_rate').value="<cfoutput>#get_customer_type_target.control_rate#</cfoutput>";
			</script>
		</cfif>
		<cfset get_duty_type_.recordcount = 0>
	</cfif>

	<cfquery name="GET_TARGET_PERIOD" datasource="#DSN#">
		SELECT TARGET_PERIOD_ID,TARGET_PERIOD FROM SETUP_TARGET_PERIOD ORDER BY TARGET_PERIOD
	</cfquery>
	<script type="text/javascript">
		<cfif get_customer_type2.recordcount and not isdefined("attributes.target_customer_type") and not isdefined("attributes.contract_id")>			
			<!--- document.getElementById('target_customer_type').value="<cfoutput>#get_customer_type2.customer_type_id#</cfoutput>"; --->
			document.getElementById('customer_type_detail').value="<cfoutput>#get_customer_type2.detail#</cfoutput>";
			document.getElementById('is_control').value="<cfoutput>#get_customer_type2.is_control#</cfoutput>";
			document.getElementById('control_rate').value="<cfoutput>#get_customer_type2.control_rate#</cfoutput>";	
		</cfif>
	</script>
	<table cellpadding="2" cellspacing="1" border="0" width="100%">
		<tr class="color-row">
			<td class="formbold"><a href="javascript:gizle_goster(contract_info);">&raquo;&nbsp;Anlaşma Bilgileri&nbsp;&raquo;</a></td>
		</tr>
		<tr class="color-row" id="contract_info">
			<td>	
			<cfoutput>
			<table width="100%">
				<tr>
					<td class="txtboldblue" width="150" rowspan="2">Müşterinin Mevcut Kategorisi : </td>
					<td width="100" rowspan="2">#get_customer_type.customer_type#</td>
					<td class="txtboldblue" width="150" rowspan="2">Müşterinin Hedeflenen Kategorosi : </td>
					<td width="100" rowspan="2">#get_customer_type2.customer_type#</td>
				</tr>
				<tr>
				</tr>
					<td colspan="4"></td>
				<tr>
					<td class="txtboldblue">Ana Konum Kategorisi : </td>
					<td>#get_main_location_cat.main_location_cat#</td>
					<td class="txtboldblue">Ciro Durumu : </td>
					<td>#get_endorsement_cat.endorsement_cat#</td>
				</tr>
				<tr>
					<td class="txtboldblue">Karlılık Kategorisi : </td>
					<td>#get_profitability_cat.profitability_cat#</td>
					<td class="txtboldblue">Risk Kategorisi : </td>
					<td>#get_risk_cat.risk_cat#</td>
				</tr>
				<tr>
					<td class="txtboldblue">Özel Durum Kategorisi : </td>
					<td>#get_special_state_cat.special_state_cat#</td>
					<td class="txtboldblue">Cirodan Kısıt Anlaşma</td>
					<td></td>
				</tr>	
			</table>
			</cfoutput>
			</td>
		</tr>	
	</table>
	<table cellpadding="2" cellspacing="1" border="0" width="100%">
		<tr class="color-row">
			<td class="formbold"><a href="javascript:gizle_goster(contract_content);">&raquo;&nbsp;Standart Hizmetler&nbsp;&raquo;</a></td>
		</tr>
		<tr id="contract_content">
			<td>
			<table name="table_1" id="table_1">
				<tr class="txtboldblue">
					<td width="15">
					<cfif isdefined("attributes.target_customer_type")>
						<input type="hidden" name="customer_type_id" id="customer_type_id" value="<cfoutput>#attributes.target_customer_type#</cfoutput>">
					<cfelse>
						<input type="hidden" name="customer_type_id" id="customer_type_id" value="<cfoutput>#get_branch_related.target_customer_type_id#</cfoutput>">
					</cfif>						
						<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_duty_type.recordcount#</cfoutput>">
						<input type="button" class="eklebuton" title="<cf_get_lang_main no='170.Ekle'>" onClick="window_duty_type('0');"><!--- add_row(1); --->
					</td>
					<td width="80"><cf_get_lang dictionary_id="51828.Hizmet Tipi">*</td>
					<td width="90"><cf_get_lang dictionary_id="33680.Hizmet Birimi"></td>
					<td width="100"><cf_get_lang dictionary_id="36493.Değer"></td>
					<td width="100"><cf_get_lang dictionary_id="30722.Hedef Dönemi"></td>
					<td width="100"><cf_get_lang dictionary_id="51835.Hedef Tutarı"></td>
				</tr>	
			<cfoutput query="get_duty_type">
				<tr id="contract_content_row#currentrow#">
					<td width="15">
						<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
						<a style="cursor:pointer" onclick="delete_row(#currentrow#);"><img  src="images/delete_list.gif" border="0"></a>
					</td>			
					<td>
						<input type="hidden" name="duty_type_id#currentrow#" id="duty_type_id#currentrow#" value="#duty_type_id#">
						<input type="text" name="duty_type#currentrow#" id="duty_type#currentrow#" value="#duty_type#" readonly style="width:80px;">
					</td>
					<td>
						<cfif is_value eq 1>
							<input type="text" name="duty_unit_cat#currentrow#" id="duty_unit_cat#currentrow#" value="#duty_unit_cat#" readonly style="width:90px;"></td>
						<cfelse>
							<input type="hidden" name="duty_unit_cat#currentrow#" id="duty_unit_cat#currentrow#" value="#duty_unit_cat#"></td>
						</cfif>
					<td>
						<input type="hidden" name="is_value#currentrow#" id="is_value#currentrow#" value="#is_value#">
						<cfif isdefined("attributes.contract_id")>
							<input type="text" name="cost_amount#currentrow#" id="cost_amount#currentrow#" value="#tlformat(cost_amount)#" onkeyup="return(FormatCurrency(this,event));" <cfif is_value eq 0> readonly</cfif> class="moneybox" style="width:100px;">
						<cfelse>
							<cfif is_value eq 1>
								<input type="text" name="cost_amount#currentrow#" id="cost_amount#currentrow#" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:100px;">
							<cfelse>
								<input type="hidden" name="cost_amount#currentrow#" id="cost_amount#currentrow#" value="#tlformat(1)#">
							</cfif>		
						</cfif>						
		
					</td>
					<td><input type="hidden" name="is_target#currentrow#" id="is_target#currentrow#" value="#is_target#">
						<cfif is_target eq 1>
							<select name="target_period#currentrow#" id="target_period#currentrow#" style="width:100px;">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfloop query="get_target_period">
									<option value="#target_period_id#" <cfif isdefined("attributes.contract_id") and (get_duty_type.target_period_id eq target_period_id)> selected</cfif>>#target_period#</option>
								</cfloop>
							</select>
						</cfif>				
					</td>
					<td>
					<cfif is_target eq 1>
						<input type="text" name="target_amount#currentrow#" id="target_amount#currentrow#" value="<cfif isdefined("attributes.contract_id")>#tlformat(target_amount)#</cfif>" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:100px;"><!--- #is_value#--#is_target# ---></td>
					</cfif>
				</tr>
			</cfoutput>
			</table>
			</td>
		</tr>
	</table>
	<table cellpadding="2" cellspacing="1" border="0" width="100%">
		<tr class="color-row">
			<td class="formbold"><a href="javascript:gizle_goster(contract_content_);">&raquo;&nbsp;Ek Hizmetler&nbsp;&raquo;</a></td>
		</tr>
		<tr id="contract_content_">
			<td>
			<table name="table_" id="table_">
				<tr class="txtboldblue">
					<td width="15">
						<input type="hidden" name="record_num_" id="record_num_" value="<cfoutput>#get_duty_type_.recordcount#</cfoutput>">
						<input type="button" class="eklebuton" title="<cf_get_lang_main no='170.Ekle'>" onClick="window_duty_type('1');">
					</td>
					<td width="80"><cf_get_lang dictionary_id="51828.Hizmet Tipi">*</td>
					<td width="90"><cf_get_lang dictionary_id="33680.Hizmet Birimi"></td>
					<td width="100"><cf_get_lang dictionary_id="36493.Değer"></td>
					<td width="100"><cf_get_lang dictionary_id="30722.Hedef Dönemi"></td>
					<td width="100"><cf_get_lang dictionary_id="51835.Hedef Tutarı"></td>
				</tr>
			<cfif get_duty_type_.recordcount>
			  <cfoutput query="get_duty_type_">
				<tr id="contract_content_row_#currentrow#">
					<td width="15">
						<input type="hidden" name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#" value="1">
						<a style="cursor:pointer" onclick="delete_row_(#currentrow#);"><img  src="images/delete_list.gif" border="0"></a>
					</td>			
					<td>
						<input type="hidden" name="duty_type_id_#currentrow#" id="duty_type_id_#currentrow#" value="#duty_type_id#">
						<input type="text" name="duty_type_#currentrow#" id="duty_type_#currentrow#" value="#duty_type#" readonly style="width:80px;">
					</td>
					<td>
						<cfif is_value eq 1>
							<input type="text" name="duty_unit_cat_#currentrow#" id="duty_unit_cat_#currentrow#" value="#duty_unit_cat#" readonly style="width:90px;"></td>
						<cfelse>
							<input type="hidden" name="duty_unit_cat_#currentrow#" id="duty_unit_cat_#currentrow#" value="#duty_unit_cat#"></td>
						</cfif>
					<td>
						<input type="hidden" name="is_value_#currentrow#" id="is_value_#currentrow#" value="#is_value#">
						<cfif is_value eq 1>
							<input type="text" name="cost_amount_#currentrow#" id="cost_amount_#currentrow#" value="#cost_amount#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:100px;">
						<cfelse>
							<input type="hidden" name="cost_amount_#currentrow#" id="cost_amount_#currentrow#" value="#tlformat(1)#">
						</cfif>		
					</td>
					<td>
						<input type="hidden" name="is_target_#currentrow#" id="is_target_#currentrow#" value="#is_target#">
						<cfif is_target eq 1>
							<select name="target_period_#currentrow#" id="target_period_#currentrow#" style="width:100px;">
								<option value=""><cf_get_lang_main no='322.Seciniz'></option>
								<cfloop query="get_target_period">
									<option value="#target_period_id#" <cfif isdefined("attributes.contract_id") and (get_duty_type_.target_period_id eq target_period_id)> selected</cfif>>#target_period#</option>
								</cfloop>
							</select>
						</cfif>				
					</td>
					<td>
					<cfif is_target eq 1>
						<input type="text" name="target_amount_#currentrow#" id="target_amount_#currentrow#" value="#tlformat(target_amount)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:100px;"></td>
					</cfif>
				</tr>
		  </cfoutput>
		</cfif>			
			</table>
			</td>
		</tr>
	</table>
	<script type="text/javascript">
		row_count = <cfoutput>#get_duty_type.recordcount#</cfoutput>;
		kontrol_row_count = <cfoutput>#get_duty_type.recordcount#</cfoutput>;
		row_count_ = <cfoutput>#get_duty_type_.recordcount#</cfoutput>;
		kontrol_row_count_ = <cfoutput>#get_duty_type_.recordcount#</cfoutput>;		
		function add_row(customer_type_id,is_category,duty_type_id,duty_type,duty_unit_cat,is_value,is_target)
		{
			//Standart Hizmet ise
			if(is_category ==0)
			{
				var list_duty_type_id='';
				var list_row=0;
				
				for(r=1;r<=branch_contract.record_num.value;r++)
				{
					if(eval("document.branch_contract.row_kontrol"+r).value == 1)
					{
						value_duty_type_id = eval("document.branch_contract.duty_type_id"+r).value;
						list_duty_type_id=list_duty_type_id+','+value_duty_type_id;
						
					}
				}
				//satirlarda bu hizmet tipi varmi ve hedeflenen musteri tipi ayni mi?
				if(!list_find(list_duty_type_id,duty_type_id,',') && (customer_type_id == document.branch_contract.target_customer_type.value) )
				{
					
					row_count++;
					kontrol_row_count++;
					var newRow;
					var newCell;
					
					newRow = document.getElementById("table_1").insertRow(document.getElementById("table_1").rows.length);	
					newRow.setAttribute("name","contract_content_row" + row_count);
					newRow.setAttribute("id","contract_content_row" + row_count);
					
					document.getElementById('record_num').value=row_count;
					
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="hidden" name="row_kontrol' + row_count +'" value="1"><a style="cursor:pointer" onClick="delete_row(' + row_count + ');"><img src="/images/delete_list.gif" align="absmiddle" border="0" alt="sil"></a>';//row_count
				
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="hidden" name="duty_type_id' + row_count +'" value="'+duty_type_id+'"><input type="text" name="duty_type' + row_count +'" value="'+duty_type+'" style="width:80px;">';
					
					newCell = newRow.insertCell(newRow.cells.length);
				  if(is_value == 1)
					newCell.innerHTML = '<input type="text" name="duty_unit_cat' + row_count +'" value="'+duty_unit_cat+'" readonly style="width:90px;">';
				  else
					newCell.innerHTML = '<input type="hidden" name="duty_unit_cat' + row_count +'" value="'+duty_unit_cat+'">';
					
					newCell = newRow.insertCell(newRow.cells.length);
				  if(is_value == 1)
					newCell.innerHTML = '<input type="hidden" name="is_value' + row_count +'" value="'+is_value+'"><input type="text" name="cost_amount' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:100px;">';
				  else
					newCell.innerHTML = '<input type="hidden" name="is_value' + row_count +'" value="'+is_value+'"><input type="hidden" name="cost_amount' + row_count +'" value="<cfoutput>#tlformat(1)#</cfoutput>" style="width:100px;">';
				
					newCell = newRow.insertCell(newRow.cells.length);
				  if(is_target == 1)
					newCell.innerHTML = '<input type="hidden" name="is_target' + row_count +'" value="'+is_target+'"><select name="target_period' + row_count +'" style="width:100px;"><option value=""><cf_get_lang_main no='322.Seciniz'></option><cfoutput query="get_target_period"><option value="#target_period_id#">#target_period#</option></cfoutput></select>';
				  else
					newCell.innerHTML = '<input type="hidden" name="is_target' + row_count +'" value="'+is_target+'">';
				  
					newCell = newRow.insertCell(newRow.cells.length);
				  if(is_target == 1)
					newCell.innerHTML = '<input type="text" name="target_amount' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:100px;">';
				}
			}			
			else //Ek Hizmet ise
			{
				var list_duty_type_id_='';
				var list_row_=0;
				
				for(r=1;r<=branch_contract.record_num_.value;r++)
				{
					if(eval("document.branch_contract.row_kontrol_"+r).value == 1)
					{
						value_duty_type_id = eval("document.branch_contract.duty_type_id_"+r).value;
						list_duty_type_id_=list_duty_type_id_+','+value_duty_type_id;						
					}
				}
				//satirlarda bu hizmet tipi varmi ve hedeflenen musteri tipi ayni mi?
				if(!list_find(list_duty_type_id_,duty_type_id,',') && (customer_type_id == document.branch_contract.target_customer_type.value) )
				{
					
					row_count_++;
					kontrol_row_count_++;
					var newRow;
					var newCell;
					
					newRow = document.getElementById("table_").insertRow(document.getElementById("table_").rows.length);	
					newRow.setAttribute("name","contract_content_row_" + row_count_);
					newRow.setAttribute("id","contract_content_row_" + row_count_);
					
					document.getElementById('record_num_').value=row_count_;
					
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="hidden" name="row_kontrol_' + row_count_ +'" value="1"><a style="cursor:pointer" onClick="delete_row_(' + row_count_ + ');"><img src="/images/delete_list.gif" align="absmiddle" border="0" alt="sil"></a>';
				
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="hidden" name="duty_type_id_' + row_count_ +'" value="'+duty_type_id+'"><input type="text" name="duty_type_' + row_count_ +'" value="'+duty_type+'" style="width:80px;">';
					
					newCell = newRow.insertCell(newRow.cells.length);
				  if(is_value == 1)
					newCell.innerHTML = '<input type="text" name="duty_unit_cat_' + row_count_ +'" value="'+duty_unit_cat+'" readonly style="width:90px;">';
				  else
					newCell.innerHTML = '<input type="hidden" name="duty_unit_cat_' + row_count_ +'" value="'+duty_unit_cat+'">';
					
					newCell = newRow.insertCell(newRow.cells.length);
				  if(is_value == 1)
					newCell.innerHTML = '<input type="hidden" name="is_value_' + row_count_ +'" value="'+is_value+'"><input type="text" name="cost_amount_' + row_count_ +'" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:100px;">';
				  else
					newCell.innerHTML = '<input type="hidden" name="is_value_' + row_count_ +'" value="'+is_value+'"><input type="hidden" name="cost_amount_' + row_count_ +'" value="<cfoutput>#tlformat(1)#</cfoutput>" style="width:100px;">';
				
					newCell = newRow.insertCell(newRow.cells.length);
				  if(is_target == 1)
					newCell.innerHTML = '<input type="hidden" name="is_target_' + row_count_ +'" value="'+is_target+'"><select name="target_period_' + row_count_ +'" style="width:100px;"><option value=""><cf_get_lang_main no='322.Seciniz'></option><cfoutput query="get_target_period"><option value="#target_period_id#">#target_period#</option></cfoutput></select>';
				  else
					newCell.innerHTML = '<input type="hidden" name="is_target_' + row_count_ +'" value="'+is_target+'">';
					  
					newCell = newRow.insertCell(newRow.cells.length);
				  if(is_target == 1)
					newCell.innerHTML = '<input type="text" name="target_amount_' + row_count_ +'" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:100px;">';
				}
		
			}
		}
		
		function delete_row(sy)
		{
			var my_element=eval("document.branch_contract.row_kontrol"+sy);		
			my_element.value=0;
		
			var my_element=eval("contract_content_row"+sy);
			my_element.style.display="none";	
			kontrol_row_count--;		
		}
		
		function delete_row_(sy)
		{
			var my_element=eval("document.branch_contract.row_kontrol_"+sy);		
			my_element.value=0;
		
			var my_element=eval("contract_content_row_"+sy);
			my_element.style.display="none";	
			kontrol_row_count_--;		
		}		
		
	</script>
<cfelse>
	<input type="hidden" name="record_num" id="record_num" value="0">
	<table cellpadding="2" cellspacing="1" border="0" width="100%">
		<tr class="color-row">
			<td class="formbold"><cf_get_lang dictionary_id="52312.Şubenin Anlaşma Bilgileri Girilmemiş.Kontrol Ediniz">!</td>
		</tr>
	</table>
	<script type="text/javascript">
		//document.getElementById('target_customer_type').value='';
		document.getElementById('customer_type_detail').value='';
		document.getElementById('is_control').value='';
		document.getElementById('control_rate').value='';			
	</script>
</cfif>



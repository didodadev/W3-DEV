<cfquery name="GET_PBS" datasource="#DSN3#">
	SELECT * FROM SETUP_PBS_CODE WHERE PBS_ID = #attributes.pbs_id#
</cfquery>
<cfquery name="get_pbs_cat" datasource="#dsn3#">
	SELECT PBS_CAT_ID,PBS_CAT_NAME FROM SETUP_PBS_CAT
</cfquery>
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_unit.cfm">
<cfparam name="attributes.modal_id" default="">

<cfif not isDefined("attributes.draggable")><cf_catalystHeader></cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfform name="upd_pbs_code" action="#request.self#?fuseaction=product.emptypopup_upd_pbs_code" method="post">
		<cf_box id="upd_pbs_code" title="#getLang('','PBS Kodu Güncelle',37137)#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
			<cf_box_elements>
				<cfoutput>
					<input type="hidden" name="pbs_id" id="pbs_id" value="#attributes.pbs_id#">
					<input type="hidden" name="hierarchy" id="hierarchy" value="#get_pbs.hierarchy#">
					<input type="hidden" name="old_pbs_code" id="old_pbs_code" value="#get_pbs.pbs_code#">
				</cfoutput>
				<cfif get_pbs.hierarchy eq 1>
					<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
						<label><font color="red"><cf_get_lang dictionary_id='60500.Bu PBS kodunu değiştirirseniz bağlı olduğu PBS kodlarıda güncellenecektir'></font></label>
					</div>
				</cfif>
				<div class="col col-12 col-md-4 col-sm-12" type="column" index="1" sort="true">
					<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_status">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_pbs.is_active eq 1>checked</cfif>/><cf_get_lang dictionary_id='57493.Aktif'>
                        </label>
                    </div>
					<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_status">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <input type="checkbox" name="is_special" id="is_special" value="1" <cfif get_pbs.is_special eq 1>checked</cfif>  /><cf_get_lang dictionary_id='57979.Özel'>
                        </label>
                    </div>
				</div>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-promotion_head">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='37088.PBS Kategorisi'></label>
                        <div class="col col-8 col-sm-12">
							<select name="pbs_cat_id" id="pbs_cat_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_pbs_cat">
									<option value="#pbs_cat_id#" <cfif pbs_cat_id eq get_pbs.pbs_cat_id>selected</cfif>>#pbs_cat_name#</option>
								</cfoutput>
							</select>
                        </div>
                    </div>
					<div class="form-group" id="item-promotion_head">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='60461.Üst PBS Kod'></label>
                        <div class="col col-8 col-sm-12">
							<cfset listuzun=listlen(get_pbs.pbs_code,".")>
							<cfset cat_code=listgetat(get_pbs.pbs_code,listuzun,".")>
							<cfset ust_cat_code=listdeleteat(get_pbs.pbs_code,listuzun,".")>
							<select name="exp_pbs_code" id="exp_pbs_code" onChange="document.upd_pbs_code.head_pbs_code.value=document.upd_pbs_code.exp_pbs_code[document.upd_pbs_code.exp_pbs_code.selectedIndex].value;">
								<option><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfquery name="GET_UPPER_PBS" datasource="#DSN3#">
									SELECT * FROM SETUP_PBS_CODE WHERE PBS_ID <> #attributes.pbs_id#
								</cfquery>
								<cfloop query="GET_UPPER_PBS">
									<option value="<cfoutput>#pbs_code#</cfoutput>"
									<cfif ust_cat_code eq pbs_code>Selected</cfif>>
										<cfif listlen(pbs_code,".") neq 1>
											<cfloop from="1" to="#listlen(pbs_code,".")#" index="i">&nbsp;</cfloop>
										</cfif>
										<cfoutput>#pbs_code#</cfoutput>
									</option>
								</cfloop>
							</select>
                        </div>
                    </div>
					<div class="form-group" id="item-promotion_head">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='45155.PBS Kodu'> *</label>
                        <div class="col col-4 col-sm-12">
							<input type="text" name="head_pbs_code" id="head_pbs_code" value="<cfoutput>#ust_cat_code#</cfoutput>" readonly >
                        </div>
						<div class="col col-4 col-sm-12">
							<cfinput type="Text" name="pbs_code"  value="#cat_code#">
                        </div>
                    </div>
				</div>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-promotion_head">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-sm-12">
							<textarea name="pbs_detail" id="pbs_detail"><cfoutput>#get_pbs.pbs_detail#</cfoutput></textarea>
                        </div>
                    </div>
					<div class="form-group" id="item-promotion_head">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57629.Açıklama'> 2</label>
                        <div class="col col-8 col-sm-12">
							<textarea name="pbs_detail2" id="pbs_detail2"><cfoutput>#get_pbs.pbs_detail2#</cfoutput></textarea>
                        </div>
                    </div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="GET_PBS">
				<cf_workcube_buttons button_type='1' is_upd='1' is_delete='0'  add_function='#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('upd_pbs_code' , #attributes.modal_id#)"),DE(""))#'>
			</cf_box_footer>
			<cf_grid_list>
				<thead>
					<tr>
						<th colspan="4" width="25%"><cf_get_lang dictionary_id='57784.İşçilik'></th>
						<th colspan="3" width="25%"><cf_get_lang dictionary_id='38326.Malzeme'></th>
						<th colspan="3" width="25%"><cf_get_lang dictionary_id='45607.Mühendislik'></th>
						<th colspan="3" width="25%"><cf_get_lang dictionary_id='59352.Yönetim'></th>
					</tr>
					<tr>
						<th width="50"></th>
						<th><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th>P.B</th>
						<th><cf_get_lang dictionary_id='57636.Birim'></th>
						<th><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th>P.B</th>
						<th><cf_get_lang dictionary_id='57636.Birim'></th>
						<th><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th>P.B</th>
						<th><cf_get_lang dictionary_id='57636.Birim'></th>
						<th><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th>P.B</th>
						<th><cf_get_lang dictionary_id='57636.Birim'></th>
					</tr>
					</thead>
					<tbody>
					<tr>
						<td class="txtboldblue">
							<div class="form-group">
								<cf_get_lang dictionary_id='39821.Alış'>
							</div>
						</td>
						<td>
							<div class="form-group"><cfinput type="text" class="moneybox" name="purchase_labour_price" value="#TlFormat(get_pbs.purchase_labour_price,2)#"  onkeyup="return(FormatCurrency(this,event));" />
							</div>
						</td>
						<td>
							<div class="form-group">
								<select name="purchase_labour_money" id="purchase_labour_money">
									<cfoutput query="GET_MONEY">
										<option value="#money#" <cfif money is get_pbs.purchase_labour_money>selected</cfif>>#MONEY#</option>
									</cfoutput>
								</select>
							</div>
						</td>
						<td>
							<div class="form-group">
								<select name="purchase_labour_unit_id" id="purchase_labour_unit_id">
									<cfoutput query="get_unit">
										<option value="#unit_id#" <cfif unit_id eq get_pbs.purchase_labour_unit_id>selected</cfif>>#unit#</option>
									</cfoutput>
								</select>
							</div>
						</td>
						<td>
							<div class="form-group"><cfinput type="text" class="moneybox" name="purchase_material_price" value="#TlFormat(get_pbs.purchase_material_price,2)#"  onkeyup="return(FormatCurrency(this,event));" />
							</div>
						</td>					
						<td>
							<div class="form-group">
								<select name="purchase_material_money" id="purchase_material_money">
								<cfoutput query="GET_MONEY">
									<option value="#money#" <cfif money is get_pbs.purchase_material_money>selected</cfif>>#MONEY#</option>
								</cfoutput>
								</select>
							</div>
						</td>
						<td>
							<div class="form-group">
								<select name="purchase_material_unit_id" id="purchase_material_unit_id">
									<cfoutput query="get_unit">
										<option value="#unit_id#" <cfif unit_id eq get_pbs.purchase_material_unit_id>selected</cfif>>#unit#</option>
									</cfoutput>
								</select>
							</div>
						</td>
						<td>
							<div class="form-group"><cfinput type="text" class="moneybox" name="purchase_engineering_price" value="#TlFormat(get_pbs.purchase_engineering_price,2)#"  onkeyup="return(FormatCurrency(this,event));" />
							</div>
						</td>
						<td>
							<div class="form-group">
								<select name="purchase_engineering_money" id="purchase_engineering_money">
								<cfoutput query="GET_MONEY">
									<option value="#money#" <cfif money is get_pbs.purchase_engineering_money>selected</cfif>>#MONEY#</option>
								</cfoutput>
								</select>
							</div>
						</td>
						<td>
							<div class="form-group">
								<select name="purchase_engineering_unit_id" id="purchase_engineering_unit_id">
									<cfoutput query="get_unit">
										<option value="#unit_id#" <cfif unit_id eq get_pbs.purchase_engineering_unit_id>selected</cfif>>#unit#</option>
									</cfoutput>
								</select>
							</div>
						</td>
						<td>
							<div class="form-group">
								<cfinput type="text" class="moneybox" name="purchase_management_price" value="#TlFormat(get_pbs.purchase_management_price,2)#"  onkeyup="return(FormatCurrency(this,event));" />
							</div>
						</td>
						<td>
							<div class="form-group">
								<select name="purchase_management_money" id="purchase_management_money">
									<cfoutput query="GET_MONEY">
										<option value="#money#" <cfif money is get_pbs.purchase_management_money>selected</cfif>>#MONEY#</option>
									</cfoutput>
								</select>
							</div>
						</td>
						<td>
							<div class="form-group">
								<select name="purchase_management_unit_id" id="purchase_management_unit_id">
									<cfoutput query="get_unit">
										<option value="#unit_id#" <cfif unit_id eq get_pbs.purchase_management_unit_id>selected</cfif>>#unit#</option>
									</cfoutput>
								</select>
							</div>
						</td>
					</tr>
					<tr class="color-row">
						<td class="txtboldblue">
							<div class="form-group">
								<cf_get_lang dictionary_id='32574.Satış'>
							</div>
						</td>
						<td><div class="form-group"><cfinput type="text" class="moneybox" name="sales_labour_price" value="#TlFormat(get_pbs.sales_labour_price,2)#"  onkeyup="return(FormatCurrency(this,event));"/></div></td>
						<td>
							<div class="form-group">
								<select name="sales_labour_money" id="sales_labour_money">
									<cfoutput query="GET_MONEY">
										<option value="#money#" <cfif money is get_pbs.sales_labour_money>selected</cfif>>#MONEY#</option>
									</cfoutput>
								</select>
							</div>
						</td>
						<td>
							<div class="form-group">
								<select name="sales_labour_unit_id" id="sales_labour_unit_id">
									<cfoutput query="get_unit">
										<option value="#unit_id#" <cfif unit_id eq get_pbs.sales_labour_unit_id>selected</cfif>>#unit#</option>
									</cfoutput>
								</select>
							</div>
						</td>
						<td>
							<div class="form-group">
								<cfinput type="text" class="moneybox" name="sales_material_price" value="#TlFormat(get_pbs.sales_material_price,2)#"  onkeyup="return(FormatCurrency(this,event));" />
							</div>
						</td>
						<td>
							<div class="form-group">
								<select name="sales_material_money" id="sales_material_money">
								<cfoutput query="GET_MONEY">
									<option value="#money#" <cfif money is get_pbs.sales_material_money>selected</cfif>>#MONEY#</option>
								</cfoutput>
								</select>
							</div>
						</td>
						<td>						
							<div class="form-group">
								<select name="sales_material_unit_id" id="sales_material_unit_id">
								<cfoutput query="get_unit">
									<option value="#unit_id#" <cfif unit_id eq get_pbs.sales_material_unit_id>selected</cfif>>#unit#</option>
									</cfoutput>
								</select>
							</div>
						</td>
						<td>
							<div class="form-group">
								<cfinput type="text" class="moneybox" name="sales_engineering_price" value="#TlFormat(get_pbs.sales_engineering_price,2)#" onkeyup="return(FormatCurrency(this,event));" />
							</div>
						</td>
						<td>
							<div class="form-group">
								<select name="sales_engineering_money" id="sales_engineering_money">
									<cfoutput query="GET_MONEY">
										<option value="#money#" <cfif money is get_pbs.sales_engineering_money>selected</cfif>>#MONEY#</option>
									</cfoutput>
								</select>
							</div>
						</td>
						<td>
							<div class="form-group">
								<select name="sales_engineering_unit_id" id="sales_engineering_unit_id">
									<cfoutput query="get_unit">
										<option value="#unit_id#" <cfif unit_id eq get_pbs.sales_engineering_unit_id>selected</cfif>>#unit#</option>
									</cfoutput>
								</select>
							</div>
						</td>
						<td>
							<div class="form-group">
								<cfinput type="text" class="moneybox" name="sales_management_price" value="#TlFormat(get_pbs.sales_management_price,2)#"  onkeyup="return(FormatCurrency(this,event));" />
							</div>
						</td>
						<td>
							<div class="form-group">
								<select name="sales_management_money" id="sales_management_money">
								<cfoutput query="GET_MONEY">
									<option value="#money#" <cfif money is get_pbs.sales_management_money>selected</cfif>>#MONEY#</option>
								</cfoutput>
								</select>
							</div>
						</td>
						<td>
							<div class="form-group">
								<select name="sales_management_unit_id" id="sales_management_unit_id">
									<cfoutput query="get_unit">
										<option value="#unit_id#" <cfif unit_id eq get_pbs.sales_management_unit_id>selected</cfif>>#unit#</option>
									</cfoutput>
								</select>
							</div>
						</td>
					</tr>
				</tbody>
			</cf_grid_list>
		</cf_box>
	</cfform>
</div>
		
		
			
<script type="text/javascript">
	function kontrol()
	{
		if(document.upd_pbs_code.pbs_cat_id.value == '')
		{
			alert("<cf_get_lang dictionary_id='60462.Lütfen PBS Kategorisi Seçiniz'>!");
			return false;
		}
		if(document.upd_pbs_code.pbs_code.value.length==0)
			{
				alert("<cf_get_lang dictionary_id='60501.PBS Kodu Girmelisiniz'> !");
				return false;
			}
		<cfif isdefined("attributes.draggable")>
			loadPopupBox('upd_pbs_code' , <cfoutput>#attributes.modal_id#</cfoutput>);
			return false;
		</cfif>
	}
</script>

<cfif not isdefined("attributes.is_process_row")>
	<cfset attributes.is_process_row = 0>
</cfif>
<cfif attributes.is_process_row eq 1>
	<cf_workcube_process_info>
	<cfif len(process_rowid_list)>
		<cfquery name="GET_STAGE" datasource="#DSN#">
		SELECT 
			STAGE,
			PROCESS_ROW_ID
		FROM
			PROCESS_TYPE_ROWS
		WHERE
			PROCESS_ROW_ID IN (#process_rowid_list#)
		</cfquery>
	</cfif>
</cfif>
<cfquery name="GET_RETURN_DETAIL" datasource="#DSN3#">
	SELECT
    	SPR.SERVICE_PARTNER_ID,
        SPR.SERVICE_CONSUMER_ID,
        SPR.RETURN_ID,
        SPR.INVOICE_ID,
        SPR.RETURN_TYPE,
        SPRR.IS_SHIP,
        SPRR.RETURN_ROW_ID,
        SPRR.ACCESSORIES,
        SPRR.PACKAGE,
        SPRR.DETAIL,
        SPRR.RETURN_STAGE,
        SPRR.STOCK_ID,
        SPRR.AMOUNT,
		SPR.PERIOD_ID
	FROM
		SERVICE_PROD_RETURN SPR,
		SERVICE_PROD_RETURN_ROWS SPRR
	WHERE
		SPR.RETURN_ID = SPRR.RETURN_ID AND
		SPR.RETURN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.return_id#">
</cfquery>
<cfquery name="GET_RETURN_CAT" datasource="#DSN3#">
	SELECT RETURN_CAT_ID, RETURN_CAT FROM SETUP_PROD_RETURN_CATS ORDER BY RETURN_CAT
</cfquery>
<cfquery name="GET_PERIOD" datasource="#DSN#">
	SELECT PERIOD_ID,PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_return_detail.period_id#">
</cfquery><br>
<table align="center" cellpadding="0" cellspacing="0" border="0" style="width:100%; height:35px;">
	<tr> 
		<td class="headbold" style="width:300px;"><cf_get_lang no='599.Ürün İade Talebi'></td>
	</tr>
	<tr>
		<td colspan="2">
			<table>
				<tr>
					<td class="txtbold" style="width:100px;"><cf_get_lang no='40.Başvuruyu Yapan'></td>
					<td> : 
						<cfoutput>
							<cfif len(get_return_detail.service_partner_id)>
								#get_par_info(get_return_detail.service_partner_id,0,0,0)#
							<cfelseif len(get_return_detail.service_consumer_id)>
								#get_cons_info(get_return_detail.service_consumer_id,0,0)#
							<cfelseif len(get_return_detail.service_employee_id)>
								#get_emp_info(get_return_detail.service_employee_id,0,0)#
							</cfif>
						</cfoutput>
					</td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang_main no='721.Fatura No'></td>
					<td> : 
						<cfset my_source = '#dsn#_#get_period.period_year#_#get_period.our_company_id#'>
						<cfquery name="GET_INV_NO" datasource="#my_source#">
							SELECT 
								INVOICE.INVOICE_NUMBER
							FROM
								INVOICE
							WHERE
								INVOICE.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_return_detail.invoice_id#">
						</cfquery>
						<cfoutput>#get_inv_no.invoice_number#</cfoutput>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<cfform action="#request.self#?fuseaction=objects2.emptypopup_upd_return" method="post" name="apply_form">
	<table cellspacing="1" cellpadding="2" border="0" class="color-border" align="center" style="width:100%;">
		<input type="hidden" name="is_process_row" id="is_process_row" value="<cfoutput>#attributes.is_process_row#</cfoutput>">
		<input type="hidden" name="return_id" id="return_id" value="<cfoutput>#url.return_id#</cfoutput>">
		<tr class="color-header" style="height:22px;"> 
			<td class="form-title" style="width:25px;"><cf_get_lang_main no='75.No'></td>
			<td class="form-title" style="width:100px;"><cf_get_lang_main no='1388.Ürün Kodu'></td>
			<td class="form-title" style="width:150px;"><cf_get_lang_main no='809.Ürün Adı'></td>
			<td class="form-title" style="width:80px;"><cf_get_lang no='580.İade Miktarı'></td>
			<td class="form-title" style="width:80px;"><cf_get_lang no='581.İade Nedeni'></td>
			<td class="form-title" style="width:100px;"><cf_get_lang_main no='217.Açıklama'></td>
			<td class="form-title" style="width:30px;"><cf_get_lang no='582.Ambalaj'></td>
			<cfif (isdefined("attributes.is_accessories_info") and attributes.is_accessories_info eq 1) or not isdefined("attributes.is_accessories_info")>
				<td class="form-title" style="width:50px;"><cf_get_lang no='583.Aksesuar'></td>
			</cfif>
			<td class="form-title" style="width:120px;"><cf_get_lang_main no='70.Aşama'></td>
			<td class="form-title"></td>
		</tr>
		<cfset stock_id_list = ''>
		<cfset stage_id_list = ''>
		<cfoutput query="get_return_detail">
			<cfif len(stock_id)>
				<cfif not listfind(stock_id_list,stock_id)>
					<cfset stock_id_list=listappend(stock_id_list,stock_id)>
				</cfif>
			</cfif>
			<cfif len(return_stage)>
				<cfif not listfind(stage_id_list,return_stage)>
					<cfset stage_id_list=listappend(stage_id_list,return_stage)>
				</cfif>	
			</cfif>
		</cfoutput>
		<cfset stage_id_list=listsort(stage_id_list,"numeric","ASC",",")>
		<cfset stock_id_list=listsort(stock_id_list,"numeric","ASC",",")>
		<cfif listlen(stock_id_list)>
			<cfquery name="GET_PRODUCTS" datasource="#DSN3#">
				SELECT
					S.PRODUCT_NAME,
					S.PRODUCT_ID,
					S.STOCK_ID,
					S.PROPERTY,
					S.STOCK_CODE
				FROM
					STOCKS S
				WHERE
					S.STOCK_ID IN (#stock_id_list#)
				ORDER BY
					S.STOCK_ID
			</cfquery>
			<cfset main_stock_id_list = listsort(listdeleteduplicates(valuelist(get_products.stock_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif len(stage_id_list)>
			<cfquery name="GET_STAGE_NAME" datasource="#DSN#">
				SELECT
					PTR.STAGE,
					PTR.PROCESS_ROW_ID 
				FROM
					PROCESS_TYPE_ROWS PTR,
					PROCESS_TYPE PT
				WHERE
					PTR.PROCESS_ID = PT.PROCESS_ID AND
					PTR.PROCESS_ROW_ID IN (#stage_id_list#)
				ORDER BY
					PTR.PROCESS_ROW_ID ASC
			</cfquery>
		</cfif>
		<cfoutput query="get_return_detail">
			<tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" style="height:20px;">
				<td>#currentrow#</td>
				<td>#get_products.stock_code[listfind(main_stock_id_list,stock_id,',')]#</td>
				<td>#get_products.product_name[listfind(main_stock_id_list,stock_id,',')]# #get_products.property[listfind(main_stock_id_list,stock_id,',')]#</td>
				<td>#amountformat(amount)#</td>
				<td>
					<cfif len(return_type)>
						<cfquery name="GET_CAT_NAME" dbtype="query">
							SELECT RETURN_CAT FROM get_return_cat WHERE RETURN_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#return_type#">
						</cfquery>
						#get_cat_name.return_cat#
					</cfif>
				</td>
				<td>#detail#</td>
				<td><cfif len(package) and package eq 1>
						<cf_get_lang no='586.Tam'>
					<cfelseif len(package) and package eq 2>
						<cf_get_lang no='585.Hasarlı'>
					</cfif>
				</td>
				<cfif (isdefined("attributes.is_accessories_info") and attributes.is_accessories_info eq 1) or not isdefined("attributes.is_accessories_info")>
					<td>
						<cfif len(accessories) and package eq 1>
							<cf_get_lang no='586.Tam'>
						<cfelseif len(accessories) and package eq 2>
							<cf_get_lang no='587.Eksik'>/<cf_get_lang no='585.Hasarlı'>
						</cfif>
					</td>
				</cfif>
				<td>
					<cfif attributes.is_process_row eq 1>
						<select name="row_stage_#return_row_id#" style="width:120px;">
							<cfloop query="get_stage">
								<option value="#process_row_id#"<cfif get_return_detail.return_stage eq process_row_id>selected</cfif>>#stage#</option>
							</cfloop>
						</select>
					<cfelse>
						#get_stage_name.stage[listfind(stage_id_list,return_stage,',')]#
					</cfif>
				</td>
				<td style="width:15px;"><cfif is_ship neq 1><input type="checkbox" name="is_check" id="is_check" value="#return_row_id#" <cfif attributes.is_process_row eq 1>checked</cfif>></cfif></td>
			</tr>
		</cfoutput>
		<tr class="color-row">
			<td align="right" style="text-align:right;" <cfif (isdefined("attributes.is_accessories_info") and attributes.is_accessories_info eq 1) or not isdefined("attributes.is_accessories_info")>colspan="10"<cfelse>colspan="9"</cfif>>
				<table>
					<tr>
						<cfif isdefined("attributes.is_return_type") and attributes.is_return_type eq 1>
							<td>
								İşlem Tipi
								<select name="return_type" id="return_type" style="width:70px;">
									<option value="1" <cfif get_return_detail.return_type eq 1>selected</cfif>>İade</option>
									<option value="2" <cfif get_return_detail.return_type eq 2>selected</cfif>>Değişim</option>
								</select>
							</td>
						</cfif>
						<cfif attributes.is_process_row eq 0>
							<td>
								<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
							</td>
						</cfif>
						<td><cf_workcube_buttons add_function='kontrol()'></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</cfform>

<script type="text/javascript">
	function kontrol()
	{
		kontrol_ = 0;
		if (document.apply_form.is_check.length != undefined)
		{
			for (i=0; i < document.apply_form.is_check.length; i++)
			{
				if (document.apply_form.is_check[i].checked)
					kontrol_ = 1;
			}							
		}
		else
		{
			if (document.getElementById('is_check').checked)
				kontrol_ = 1;	
		}		
		
		if(kontrol_ == 0)
		{
			alert("<cf_get_lang no='600.Hiçbir İade İşlemi Seçmediniz'>!");
			return false;
		}
		return true;
	}
</script>

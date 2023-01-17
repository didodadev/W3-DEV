<cf_xml_page_edit fuseact="objects.popup_add_product_return">
<cfif not isdefined("is_process_row")>
	<cfset is_process_row = 0>
</cfif>
<cfif not isdefined("is_cancel_cat")>
	<cfset is_cancel_cat = 0>
</cfif>
<cfif is_process_row eq 1>
	<cf_workcube_process_info>
	<cfif len(process_rowid_list)>
		<cfquery name="GET_STAGE" datasource="#DSN#">
			SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_rowid_list#)
		</cfquery>
	</cfif>
</cfif>

<cfquery name="GET_RETURN" datasource="#DSN3#">
	SELECT SERVICE_CONSUMER_ID,SERVICE_COMPANY_ID,SERVICE_PARTNER_ID FROM SERVICE_PROD_RETURN WHERE RETURN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.return_id#">
</cfquery>
<cfquery name="GET_RETURN_DETAIL" datasource="#DSN3#">
	SELECT
		SPR.RETURN_ID,
		SPR.PERIOD_ID,
		SPR.INVOICE_ID,
        SPR.PAPER_NO,
		SPR.SERVICE_PARTNER_ID,
		SPR.SERVICE_CONSUMER_ID,
		SPR.RECORD_EMP,
		SPR.RECORD_DATE,
		SPR.UPDATE_EMP,
        SPR.UPDATE_DATE,
		SPRR.IS_SHIP,
		SPRR.AMOUNT,
		SPRR.RETURN_ROW_ID,
		SPRR.RETURN_TYPE ROW_RETURN_TYPE,
		SPRR.RETURN_ACT_TYPE ROW_RETURN_ACT_TYPE,
		SPRR.RETURN_STAGE,
		SPRR.STOCK_ID,
		SPRR.RETURN_CANCEL_TYPE,
		SPRR.DETAIL,
		SPRR.ACCESSORIES,
		SPRR.PACKAGE,
		SPRR.INVOICE_ROW_ID,
        SPRR.RETURN_PERIOD_ID
	FROM
		SERVICE_PROD_RETURN SPR,
		SERVICE_PROD_RETURN_ROWS SPRR
	WHERE
		SPR.RETURN_ID = SPRR.RETURN_ID AND
		SPR.RETURN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.return_id#">
</cfquery>
<!--- Takip kayitlari cekiliyor --->
<cfquery name="GET_ORDER_DEMAND" datasource="#DSN3#">
	SELECT RETURN_ROW_ID FROM ORDER_DEMANDS WHERE RETURN_ROW_ID IN (#valuelist(get_return_detail.return_row_id)#) AND GIVEN_AMOUNT <> 0
</cfquery>

<cfquery name="GET_RETURN_AMOUNT" datasource="#DSN3#">
	SELECT 
	   SUM(SPRR.AMOUNT) AS SUM_AMOUNT,
	   SPRR.STOCK_ID,
	   SPRR.INVOICE_ROW_ID                             
	FROM 
	   SERVICE_PROD_RETURN_ROWS SPRR,
	   SERVICE_PROD_RETURN SPR
	WHERE
	   SPRR.RETURN_ID =  SPR.RETURN_ID AND
	   SPRR.INVOICE_ROW_ID IN (#valuelist(get_return_detail.invoice_row_id)#)
	<cfif len(get_return.service_consumer_id)>
	   AND SPR.SERVICE_CONSUMER_ID = #get_return.service_consumer_id#
	<cfelseif len(get_return.service_partner_id)>
	   AND SPR.SERVICE_PARTNER_ID = #get_return.service_partner_id#                              
	</cfif>
	<cfif is_return_control eq 1>
	   AND SPRR.RETURN_ACT_TYPE = 1
	</cfif>                  
	GROUP BY 
	   SPRR.STOCK_ID, 
	   SPRR.INVOICE_ROW_ID                             
</cfquery>

<cfquery name="GET_RETURN_CAT" datasource="#DSN3#">
	SELECT RETURN_CAT_ID, RETURN_CAT FROM SETUP_PROD_RETURN_CATS ORDER BY RETURN_CAT
</cfquery>
<cfquery name="GET_CANCEL_CAT" datasource="#DSN3#">
	SELECT CANCEL_CAT_ID, CANCEL_CAT FROM SETUP_PROD_CANCEL_CATS ORDER BY CANCEL_CAT
</cfquery>
<cfquery name="GET_PERIOD" datasource="#DSN#">
	SELECT PERIOD_ID,PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_return_detail.period_id#">
</cfquery>
<cfset my_source = '#dsn#_#get_period.period_year#_#get_period.our_company_id#'>
<cfquery name="GET_INV_NO" datasource="#my_source#">
	SELECT 
		IR.AMOUNT,
		I.INVOICE_NUMBER
	FROM
		INVOICE I,
		INVOICE_ROW IR
	WHERE
		IR.INVOICE_ID = I.INVOICE_ID AND
		I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_return_detail.invoice_id#">
</cfquery>

<cfquery name="GET_INV_ROW" datasource="#my_source#">
	SELECT 
		AMOUNT,
		INVOICE_ROW_ID
	FROM
		INVOICE_ROW 
	WHERE
		INVOICE_ROW_ID IN (#valuelist(get_return_detail.invoice_row_id)#)
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="upd_return" method="post" action="#request.self#?fuseaction=service.emptypopup_upd_return">
            <cf_grid_list>
                <thead>
                <tr>
                    <th colspan="17">
                        <b><cf_get_lang_main no='107.Cari Hesap'> :</b>
                        <cfoutput>
                            <cfif len(get_return_detail.service_partner_id)>
                                #get_par_info(get_return_detail.service_partner_id,0,0,0)#
                            <cfelseif len(get_return_detail.service_consumer_id)>
                                #get_cons_info(get_return_detail.service_consumer_id,0,0)#
                            <cfelseif len(get_return_detail.service_employee_id)>
                                #get_emp_info(get_return_detail.service_employee_id,0,0)#
                            </cfif>
                            &nbsp;&nbsp;
                            <b><cf_get_lang_main no='721.Fatura No'> :</b> #get_inv_no.invoice_number#
                        </cfoutput>
                    </th>
                </tr>
                <tr> 
                    <th style="width:30px;"><cf_get_lang_main no='75.No'></th>
                    <th><cf_get_lang_main no='809.Ürün Adı'></th>
                    <cfif is_product_code eq 1>
                        <th><cf_get_lang_main no='221.Barkod'></th>
                    </cfif>
                    <cfif is_stock_code eq 1>
                        <th><cf_get_lang_main no='106.Stok Kodu'></th>
                    </cfif>	
                    <cfif is_special_code eq 1>
                        <th><cf_get_lang_main no='377.Ozel kod'></th>
                    </cfif>	            			
                    <th style="width:60px; text-align:right"><cf_get_lang no='218.Satılan'></th>
                    <th style="width:50px; text-align:right"><cf_get_lang no='219.Dönen'></th>
                    <th style="width:85px; text-align:right"><cf_get_lang no='39.İade Miktarı'></th>
                    <th style="width:100px;"><cf_get_lang no='216.İade Nedeni'></th>
                    <cfif is_cancel_cat eq 1>
                        <th style="width:100px;"><cf_get_lang no='41.İade Red Nedeni'></th>
                    </cfif>
                    <th style="width:100px;"><cf_get_lang_main no='217.Açıklama'></th>
                    <th style="width:100px;"><cf_get_lang no='222.Ambalaj'></th>
                    <cfif (isdefined("is_accessories_info") and is_accessories_info eq 1) or not isdefined("is_accessories_info")>
                        <th style="width:100px;"><cf_get_lang no='181.Aksesuar'></th>
                    </cfif>
                    <cfif isdefined("is_return_type") and is_return_type eq 1>
                        <th style="width:100px;"><cf_get_lang_main no='388.İşlem Tipi'></th>
                    </cfif>
                    <th><cf_get_lang_main no='70.Aşama'></th>
                    <th style="width:25px;"><input type="checkbox" name="is_check_all" id="is_check_all" onclick="check_all()" title="<cf_get_lang_main no='70.Aşama'>" value="1" <cfif is_process_row eq 1>checked</cfif>></th>		
                    <th></th>
                </tr>
                </thead>
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
                            PRODUCT_NAME,
                            PRODUCT_ID,
                            STOCK_ID,
                            PROPERTY,
                            STOCK_CODE,
                            STOCK_CODE_2,
                            BARCOD
                        FROM
                            STOCKS
                        WHERE
                            STOCK_ID IN (#stock_id_list#)
                        ORDER BY
                            STOCK_ID
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
                            PROCESS_TYPE_OUR_COMPANY PTO,
                            PROCESS_TYPE PT
                        WHERE
                            PT.IS_ACTIVE = 1 AND
                            PTR.PROCESS_ID = PT.PROCESS_ID AND
                            PT.PROCESS_ID = PTO.PROCESS_ID AND
                            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                            PTR.PROCESS_ROW_ID IN (#stage_id_list#)
                        ORDER BY
                            PTR.PROCESS_ROW_ID
                    </cfquery>
                </cfif>
                
                    <input type="hidden" name="is_process_row" id="is_process_row" value="<cfoutput>#is_process_row#</cfoutput>">
                    <input type="hidden" name="return_id" id="return_id" value="<cfoutput>#attributes.return_id#</cfoutput>">
                    <input type="hidden" name="is_order_demand"  id="is_order_demand" value="<cfoutput>#is_order_demand#</cfoutput>">
                    <input type="hidden" name="is_order_demand_stage" id="is_order_demand_stage" value="<cfoutput>#is_order_demand_stage#</cfoutput>">
                    <input type="hidden" name="service_consumer_id" id="service_consumer_id" value="<cfoutput>#get_return.service_consumer_id#</cfoutput>">
                    <input type="hidden" name="service_company_id" id="service_company_id" value="<cfoutput>#get_return.service_company_id#</cfoutput>">		
                    <input type="hidden" name="service_partner_id" id="service_partner_id" value="<cfoutput>#get_return.service_partner_id#</cfoutput>">
                    <input type="hidden" name="invoice_number" id="invoice_number" value="<cfoutput>#get_inv_no.invoice_number#</cfoutput>">
                    <tbody>
                    <cfoutput query="get_return_detail">
                        <tr>
                            <input type="hidden" name="stock_id_#return_row_id#" id="stock_id_#return_row_id#" value="#stock_id#">
                            <td>#currentrow#</td>
                            <td nowrap="nowrap">#get_products.product_name[listfind(main_stock_id_list,stock_id,',')]# #get_products.property[listfind(main_stock_id_list,stock_id,',')]#</td>
                            <cfif is_product_code eq 1>
                                <td>#get_products.barcod[listfind(main_stock_id_list,stock_id,',')]#</td>
                            </cfif>
                            <cfif is_stock_code eq 1>
                                <td>#get_products.stock_code[listfind(main_stock_id_list,stock_id,',')]#</td>
                            </cfif>
                            <cfif is_special_code eq 1>
                                <td>#get_products.stock_code_2[listfind(main_stock_id_list,stock_id,',')]#</td>
                            </cfif>                                
                            <td style="text-align:right">
                                <cfquery name="GET_INV_ROW_ROW" dbtype="query">
                                    SELECT * FROM GET_INV_ROW WHERE INVOICE_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_return_detail.invoice_row_id#">
                                </cfquery>
                                #get_inv_row_row.amount#
                                <input type="hidden" name="invoice_amount_#return_row_id#" id="invoice_amount_#return_row_id#" value="#get_inv_row_row.amount#">
                            </td>
                            <td style="text-align:right">
                                <cfquery name="GET_RETURN_AMOUNT_ROW" dbtype="query">
                                    SELECT * FROM GET_RETURN_AMOUNT WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_return_detail.stock_id#"> AND INVOICE_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_return_detail.invoice_row_id#">
                                </cfquery>
                                <cfif get_return_amount_row.recordcount>
                                    #get_return_amount_row.sum_amount#
                                    <input type="hidden" name="return_amount_#return_row_id#" id="return_amount_#return_row_id#" value="#get_return_amount_row.sum_amount-amount#">
                                <cfelse>
                                    0
                                    <input type="hidden" name="return_amount_#return_row_id#" id="return_amount_#return_row_id#" value="0">
                                </cfif>
                            </td>
                            <td>
                                <!--- Degisim ise backorder kayitlari dusunuluyor ve rakam guncellenmiyor--->
                                <cfif row_return_act_type eq 2>					
                                    <cfquery name="GET_ORDER_DEMAND_ROW" dbtype="query">
                                        SELECT * FROM GET_ORDER_DEMAND WHERE RETURN_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_return_detail.return_row_id#">					
                                    </cfquery>
                                    <cfif get_order_demand_row.recordcount>
                                        <input type="text" name="amount_#return_row_id#" id="amount_#return_row_id#" value="#amount#" required="yes" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event,0));" readonly="readonly">
                                    <cfelse>
                                        <input type="text" name="amount_#return_row_id#" id="amount_#return_row_id#" value="#amount#" required="yes" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event,0));">
                                    </cfif>						
                                <cfelse>
                                    <input type="text" name="amount_#return_row_id#" id="amount_#return_row_id#" value="#amount#" required="yes" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event,0));">
                                </cfif>
                            </td>
                            <td nowrap="nowrap">
                                <cfif len(row_return_type) and row_return_type neq -1>
                                    <cfquery name="GET_CAT_NAME" dbtype="query">
                                        SELECT RETURN_CAT FROM get_return_cat WHERE RETURN_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#row_return_type#">
                                    </cfquery>
                                    #get_cat_name.return_cat#
                                </cfif>
                            </td>
                            <cfif is_cancel_cat eq 1>
                                <td>
                                    <select name="row_cancel_type_#return_row_id#" id="row_cancel_type_#return_row_id#" style="width:100px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfloop query="get_cancel_cat">
                                            <option value="#cancel_cat_id#"<cfif get_return_detail.return_cancel_type eq cancel_cat_id>selected</cfif>>#cancel_cat#</option>
                                        </cfloop>
                                    </select>
                                </td>
                            </cfif>
                            <td><input type="text" name="detail_#return_row_id#" id="detail_#return_row_id#" maxlength="400" value="#URLDecode(detail)#" style="width:100px;"></td>
                            <td>
                                <cfif isdefined("is_package_upd") and is_package_upd eq 1>
                                    <select name="package_#return_row_id#" id="package_#return_row_id#" style="width:100px">
                                        <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                        <option value="1" <cfif (len(get_return_detail.package) and get_return_detail.package eq 1) or (len(get_return_detail.package) and get_return_detail.package eq 0)>selected</cfif>><cf_get_lang no='149.Sağlam'></option>
                                        <option value="2" <cfif len(get_return_detail.package) and get_return_detail.package eq 2>selected</cfif>><cf_get_lang no='224.Hasarlı'></option>
                                    </select>
                                <cfelse>
                                    <cfif len(package) and package eq 1>
                                        <cf_get_lang no='149.Sağlam'>
                                    <cfelseif len(package) and package eq 2>
                                        <cf_get_lang no='224.Hasarlı'>
                                    </cfif>						
                                </cfif> 
                            </td>
                            <cfif (isdefined("is_accessories_info") and is_accessories_info eq 1) or not isdefined("is_accessories_info")>
                                <td>
                                    <cfif len(accessories) and package eq 1>
                                        <cf_get_lang no='223.Tam'>
                                    <cfelseif len(accessories) and package eq 2>
                                        <cf_get_lang no='225.Eksik'>/<cf_get_lang no='224.Hasarlı'>
                                    </cfif>
                                </td>
                            </cfif>
                            <cfif isdefined("is_return_type") and is_return_type eq 1>
                                <td>
                                    <cfif row_return_act_type eq 1><cf_get_lang_main no='1621.İade'>
                                    <cfelseif row_return_act_type eq 2><cf_get_lang_main no='604.Değişim'>
                                    <cfelse>Fazla Ürün
                                    </cfif>
                                    <input type="hidden" name="return_act_type_#return_row_id#" id="return_act_type_#return_row_id#" value="#row_return_act_type#">
                                </td>
                            </cfif>
                            <td>
                                <input type="hidden" name="old_row_stage_#return_row_id#" id="old_row_stage_#return_row_id#" value="#get_return_detail.return_stage#">
                                <cfif is_process_row eq 1>
                                    <select name="row_stage_#return_row_id#" id="row_stage_#return_row_id#" style="width:120px;">
                                        <cfloop query="get_stage">
                                            <option value="#process_row_id#" <cfif get_return_detail.return_stage eq process_row_id>selected="selected"</cfif>>#stage#</option>
                                        </cfloop>
                                    </select>
                                <cfelse>
                                    #get_stage_name.stage[listfind(stage_id_list,return_stage,',')]#
                                </cfif>
                            </td>
                            <td><input type="checkbox" name="is_check" id="is_check" value="#return_row_id#" <cfif is_process_row eq 1>checked</cfif>></td>
                            <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=#attributes.fuseaction#&action_name=return_row_id&action_id=#return_row_id#','list');"><i class="fa fa-bell" title="<cf_get_lang_main no='345.Uyarılar'>" border="0"></i></a></td>
                        </tr>
                    </cfoutput>
                    </tbody>
                    <tfoot>
                        <tr>
                            <cfset colspan_info = 14>
                            <cfif (isdefined("is_accessories_info") and is_accessories_info eq 1) or not isdefined("is_accessories_info")>
                                <cfset colspan_info = colspan_info + 1>
                            </cfif>
                            <cfif isdefined("is_return_type") and is_return_type eq 1>
                                <cfset colspan_info = colspan_info + 1>
                            </cfif>
                            <cfif isdefined("is_cancel_cat") and is_cancel_cat eq 1>
                                <cfset colspan_info = colspan_info + 1>
                            </cfif>
                            <td colspan="<cfoutput>#colspan_info#</cfoutput>" style="text-align:right">
                                <!---<cfif isdefined("is_ref_info") and is_ref_info eq 1 and len(get_return_detail.service_consumer_id)>--->
                                   
                            <!--- </cfif>--->
                                <cfif is_process_row eq 0>
                                    <cf_get_lang_main no="1447.Süreç"> :
                                    <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                                </cfif>
                                <cfquery name="GET_SHIP_INFO" dbtype="query">
                                    SELECT IS_SHIP FROM GET_RETURN_DETAIL WHERE IS_SHIP IS NOT NULL
                                </cfquery>
                            </td>
                        </tr>
                    </tfoot>
            </cf_grid_list>
            <cf_box_footer>
                <cf_record_info query_name="get_return_detail">
                <cfif get_ship_info.recordcount>
                    <cf_workcube_buttons add_function='kontrol()' type_format="1">
                <cfelse>
                    <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=service.emptypopup_del_return&return_id=#attributes.return_id#' add_function='kontrol()' type_format="1">
                </cfif>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function check_all()
	{
		if(document.getElementById('is_check_all').checked)
		{
			if(document.upd_return.is_check.length != undefined) {
				for (i=0; i < document.upd_return.is_check.length; i++)
				document.upd_return.is_check[i].checked= true;	
			}
			else document.upd_return.is_check.checked= true;		
		}
		else
		{	
			if(document.upd_return.is_check.length != undefined) {
				for (i=0; i < document.upd_return.is_check.length; i++)
					document.upd_return.is_check[i].checked= false;
			}
			else document.upd_return.is_check.checked= false;		
		}
	}
	
	function kontrol()
	{
		kontrol_ = 0;
		if (document.upd_return.is_check.length != undefined)
		{
			for (i=0; i < document.upd_return.is_check.length; i++)
			{
				if(document.upd_return.is_check[i].checked)
					kontrol_ = 1;
			}							
		}
		else
		{
			if (document.upd_return.is_check.checked)
				kontrol_ = 1;	
		}
		
		if(kontrol_ == 0)
		{
			alert("<cf_get_lang no='226.Hiçbir İade İşlemi Seçmediniz'>!");
			return false;
		}
		
		kontrol_temp = 0;
		
		<cfoutput query="get_return_detail">
			
			if(document.upd_return.amount_#return_row_id#.value <= 0)
			{
				alert("#currentrow#. Satır İçin İade Miktarı Girmelisiniz !");
				return false;
			}	
			
			cikan_ = parseInt(document.upd_return.invoice_amount_#return_row_id#.value);
			kabul_ = parseInt(document.upd_return.return_amount_#return_row_id#.value);
			kont_ = cikan_ - kabul_;
			
			if(kont_ < document.upd_return.amount_#return_row_id#.value)
			{
				alert("#currentrow#.  Satır İçin Çıkan Üründen Fazla İade Alamazsınız !");
				return false;
			}	
		
		</cfoutput>
		
		return true;
	}
</script>

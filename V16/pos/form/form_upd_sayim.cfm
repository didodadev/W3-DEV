<!--- stock_identity_type 1 ise barkod 2 ise stok kodu ile sayım dosyası olusturulmustur
file_import_id geliyorsa sayımlar listesinden geliyor
file_id geliyorsa devir sayımlardan geliyor
 --->
 <cfif isdefined("attributes.file_id")>
	<cfquery name="get_sayim_satirlar" datasource="#dsn2#">
		SELECT 
			SS.*,
			SY.STOCK_IDENTITY_TYPE,
			SY.DELIMITERS,
			SY.EXTRA_COLUMNS,
			SY.DEPARTMENT_IN,
			SY.LOCATION_IN,
			SY.RECORD_DATE,
			SY.RECORD_EMP,
			SY.UPDATE_DATE,
			SY.UPDATE_EMP,
			S.STOCK_CODE,
			S.STOCK_CODE_2,
			P.MANUFACT_CODE,
			PU.ADD_UNIT
		FROM 
			SAYIMLAR SY,
			SAYIM_SATIRLAR SS,
			#dsn3_alias#.PRODUCT P,
			#dsn3_alias#.STOCKS AS S,
			#dsn3_alias#.PRODUCT_UNIT AS PU
		WHERE
			SY.GIRIS_ID = SS.SAYIM_ID AND 
			SAYIM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.file_id#"> AND
			S.STOCK_ID = SS.STOCK_ID AND
			P.PRODUCT_ID = SS.PRODUCT_ID AND
			PU.IS_MAIN = 1 AND
			P.PRODUCT_ID = S.PRODUCT_ID AND
			PU.PRODUCT_ID = P.PRODUCT_ID
		ORDER BY
			S.STOCK_CODE
	</cfquery>
	<cfquery name="GET_PRODUCT_PLACE_ALL" datasource="#dsn3#">
		SELECT
			PRODUCT_PLACE_ID,
			SHELF_CODE
		FROM
			PRODUCT_PLACE
		WHERE
			PRODUCT_PLACE_ID IN (SELECT SHELF_NUMBER FROM #dsn2_alias#.SAYIM_SATIRLAR AS SS WHERE SS.SAYIM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.file_id#">)
	</cfquery>
<cfelse>
	<cfquery name="get_sayim_satirlar" datasource="#dsn2#">
		SELECT 
			SS.*,
			SS.FILE_AMOUNT MIKTAR,
			SY.RECORD_DATE,
			SY.RECORD_EMP,
			SY.UPDATE_DATE,
			SY.UPDATE_EMP,
			S.STOCK_CODE,
			S.STOCK_CODE_2,
			P.MANUFACT_CODE,
			PU.ADD_UNIT,
			S.BARCOD BARCODE,
			S.PRODUCT_NAME,
			S.PROPERTY STOCK_PROPERTY,
			(SELECT SM.SPECT_MAIN_NAME FROM #dsn3_alias#.SPECT_MAIN SM WHERE SM.SPECT_MAIN_ID = SS.SPECT_MAIN_ID) SPECT_MAIN_NAME
		FROM 
			FILE_IMPORTS_TOTAL_SAYIMLAR SY,
			FILE_IMPORTS_TOTAL SS,
			#dsn3_alias#.PRODUCT P,
			#dsn3_alias#.STOCKS AS S,
			#dsn3_alias#.PRODUCT_UNIT AS PU
		WHERE
			SY.FILE_IMPORTS_TOTAL_SAYIM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.file_import_id#"> AND
			SY.PROCESS_DATE = SS.PROCESS_DATE AND
			SY.DEPARTMENT_ID = SS.DEPARTMENT_ID AND
			SY.DEPARTMENT_LOCATION = SS.DEPARTMENT_LOCATION AND
			S.STOCK_ID = SS.STOCK_ID AND
			P.PRODUCT_ID = SS.PRODUCT_ID AND
			PU.IS_MAIN = 1 AND
			P.PRODUCT_ID = S.PRODUCT_ID AND
			PU.PRODUCT_ID = P.PRODUCT_ID
		ORDER BY
			SS.FILE_IMPORTS_TOTAL_ID
	</cfquery>	
	<cfquery name="GET_PRODUCT_PLACE_ALL" datasource="#dsn3#">
		SELECT
			PRODUCT_PLACE_ID,
			SHELF_CODE
		FROM
			PRODUCT_PLACE
	</cfquery>
</cfif>
<cfsavecontent variable="title_">
	<cfif isdefined("attributes.file_id")>
        <cf_get_lang dictionary_id ='36119.PHL Dökümanı İçeriği'>
    <cfelse>
		<cf_get_lang dictionary_id="36099.Birleştirilmiş Belge">
    </cfif>
</cfsavecontent>


<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#title_#">
        <cfform action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_write_document" method="post" name="add_ship_file">
            <cf_grid_list>
                <thead>
                    <cfif isdefined("attributes.file_id")>
                        <input type="hidden" name="file_id" id="file_id" value="<cfoutput>#attributes.file_id#</cfoutput>">
                        <input type="hidden" name="stock_identity_type" id="stock_identity_type" value="<cfif len(get_sayim_satirlar.stock_identity_type)><cfoutput>#get_sayim_satirlar.stock_identity_type#</cfoutput></cfif>">
                        <input type="hidden" name="seperator_type" id="seperator_type" value="<cfoutput>#get_sayim_satirlar.DELIMITERS#</cfoutput>">
                        <cfif listlen(get_sayim_satirlar.EXTRA_COLUMNS)>
                            <input type="hidden" name="add_file_format_1" id="add_file_format_1" value="<cfoutput>#listgetat(get_sayim_satirlar.EXTRA_COLUMNS,1,',')#</cfoutput>">
                            <cfif listlen(get_sayim_satirlar.EXTRA_COLUMNS) gte 2>
                            <input type="hidden" name="add_file_format_2" id="add_file_format_2" value="<cfoutput>#listgetat(get_sayim_satirlar.EXTRA_COLUMNS,2,',')#</cfoutput>">
                                <cfif listlen(get_sayim_satirlar.EXTRA_COLUMNS) gte 3>
                                    <input type="hidden" name="add_file_format_3" id="add_file_format_3" value="<cfoutput>#listgetat(get_sayim_satirlar.EXTRA_COLUMNS,3,',')#</cfoutput>">	
                                    <cfif listlen(get_sayim_satirlar.EXTRA_COLUMNS) gte 4>
                                        <input type="hidden" name="add_file_format_4" id="add_file_format_4" value="<cfoutput>#listgetat(get_sayim_satirlar.EXTRA_COLUMNS,4,',')#</cfoutput>">
                                        <cfif listlen(get_sayim_satirlar.EXTRA_COLUMNS) gte 5>
                                            <input type="hidden" name="add_file_format_5" id="add_file_format_5" value="<cfoutput>#listgetat(get_sayim_satirlar.EXTRA_COLUMNS,5,',')#</cfoutput>">
                                            <cfif listlen(get_sayim_satirlar.EXTRA_COLUMNS) gte 6>
                                                <input type="hidden" name="add_file_format_6" id="add_file_format_6" value="<cfoutput>#listgetat(get_sayim_satirlar.EXTRA_COLUMNS,6,',')#</cfoutput>">	
                                                <cfif listlen(get_sayim_satirlar.EXTRA_COLUMNS) gte 7>
                                                    <input type="hidden" name="add_file_format_7" id="add_file_format_7" value="<cfoutput>#listgetat(get_sayim_satirlar.EXTRA_COLUMNS,7,',')#</cfoutput>">	
                                                </cfif>
                                            </cfif>
                                        </cfif>
                                    </cfif>
                                </cfif>
                            </cfif>
                        </cfif>
                    <cfelse>
                        <input type="hidden" name="file_import_id" id="file_import_id" value="<cfoutput>#attributes.file_import_id#</cfoutput>">
                    </cfif>
                    <input type="hidden" name="line_count" id="line_count" value="<cfoutput>#get_sayim_satirlar.recordcount#</cfoutput>">
                    <tr>
                        <th width="20"><cf_get_lang dictionary_id ='58508.Satır'></th>
                        <th width="70"><cf_get_lang dictionary_id='57633.Barkod'></th>
                        <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                        <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                        <cfif isdefined("attributes.file_id")>
                            <th><cf_get_lang dictionary_id='57634.Üretici Kodu'></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id='57647.Spec'></th>
                        <cfif isdefined("attributes.file_id")>
                            <th><cf_get_lang dictionary_id ='36091.Finansal Yaş'></th>
                            <th><cf_get_lang dictionary_id ='36090.Fiziksel Yaş'></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id ='36088.Raf'></th>
                        <th><cf_get_lang dictionary_id ='36089.Son Kullanma Tarihi'></th>
                        <th><cf_get_lang dictionary_id ="42029.Lot No"></th>
                        <cfif isdefined("attributes.file_id")>
                            <th><cf_get_lang dictionary_id ='36121.Birim Maliyet'></th>
                            <th><cf_get_lang dictionary_id ='36098.Ek Maliyet'></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id='57636.Birim'></th>
                        <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <cfif isdefined("attributes.file_id")>
                            <cfif session.ep.isBranchAuthorization eq 0><th align="right" style="text-align:right;"><cf_get_lang dictionary_id ='36122.Toplam Alış Fiyatı'></th></cfif>
                        </cfif>
                    </tr>
                </thead>
                <tbody>
                    <cfset net_total = 0>
                    <cfset net_money = "">
                    <cfoutput query="get_sayim_satirlar">
                        <cfif isdefined("attributes.file_id")>
                            <input type="hidden" name="barcode_#currentrow#" id="barcode_#currentrow#" value="<cfif get_sayim_satirlar.stock_identity_type eq 1>#BARCODE#<cfelseif get_sayim_satirlar.stock_identity_type eq 3>#STOCK_CODE_2#<cfelse>#STOCK_CODE#</cfif>">
                        <cfelse>
                            <input type="hidden" name="file_imports_total_id_#currentrow#" id="file_imports_total_id_#currentrow#" value="#file_imports_total_id#">
                        </cfif>
                        <tr>
                            <td align="center">#currentrow#</td>
                            <td>#BARCODE#</td>
                            <td>#STOCK_CODE#</td>
                            <td>#PRODUCT_NAME# #STOCK_PROPERTY#</td>
                            <cfif isdefined("attributes.file_id")>
                                <td>#MANUFACT_CODE#</td>
                            </cfif>
                            <td width="170">
                                <input type="hidden" name="spect_main_id_#currentrow#" id="spect_main_id_#currentrow#" value="#SPECT_MAIN_ID#">
                                <input type="text" name="spect_main_name_#currentrow#" id="spect_main_name_#currentrow#" value="#SPECT_MAIN_NAME#" style="width:150px;">
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_spect_main&stock_id=#STOCK_ID#&field_main_id=add_ship_file.spect_main_id_#currentrow#&field_name=add_ship_file.spect_main_name_#currentrow#','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></a>
                            </td>
                            <cfif isdefined("attributes.file_id")>
                                <td><cfsavecontent variable="message"><cf_get_lang dictionary_id ='33748.Tarih Formatını Kontrol Ediniz !'></cfsavecontent>
                                    <input type="text" name="finance_date_#currentrow#" value="<cfif len(FINANCE_DATE)>#dateformat(FINANCE_DATE,dateformat_style)#</cfif>" message="#message#" validate="#validate_style#">
                                </td>
                                <td><input type="text" name="physical_age_#currentrow#" id="physical_age_#currentrow#" value="#PHYSICAL_AGE#" style="width:50px;" align="right"></td>
                            </cfif>
                            <td width="80">
                                <cfset satir_shelf=''>
                                <cfset satir_shelf_id=''>
                                <cfif len(SHELF_NUMBER)>
                                    <cfquery name="GET_PRODUCT_PLACE" dbtype="query">
                                        SELECT
                                            PRODUCT_PLACE_ID,
                                            SHELF_CODE
                                        FROM
                                            GET_PRODUCT_PLACE_ALL
                                        WHERE
                                            PRODUCT_PLACE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SHELF_NUMBER#">
                                    </cfquery>
                                    <cfset satir_shelf = GET_PRODUCT_PLACE.SHELF_CODE>
                                    <cfset satir_shelf_id = SHELF_NUMBER>
                                </cfif>
                                <input type="hidden" name="shelf_id_#currentrow#" id="shelf_id_#currentrow#" value="#satir_shelf_id#">
                                <input type="text" name="shelf_number_#currentrow#" id="shelf_number_#currentrow#" style="width:75;" value="#satir_shelf#">
                            </td>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='33748.Tarih Formatını Kontrol Ediniz !'></cfsavecontent>
                            <td width="120" style="text-align:right"><cfinput type="text" name="deliver_date_#currentrow#" maxlength="10" style="width:120px;" value="#dateformat(DELIVER_DATE,dateformat_style)#"  message="#message#" validate="#validate_style#"></td>
                            <td width="120" style="text-align:right"><cfinput type="text" name="lot_no_#currentrow#" maxlength="50" style="width:120px;" value="#lot_no#"></td>
                            <cfif isdefined("attributes.file_id")>
                                <td><input type="text" name="cost_price_#currentrow#" id="cost_price_#currentrow#" style="width:120px;" value="#TLformat(COST_PRICE,4)#" onKeyup="return(FormatCurrency(this,event,4));" class="moneybox"></td>
                                <td><input type="text" name="extra_cost_#currentrow#" id="extra_cost_#currentrow#" style="width:120px;" value="#TLformat(EXTRA_COST,4)#" onKeyup="return(FormatCurrency(this,event,4));" class="moneybox"></td>
                            </cfif>
                            <td>#ADD_UNIT#</td>
                            <td>
                                <cfif ADD_UNIT is 'Kg'>
                                    <input type="text" name="miktar_#currentrow#" id="miktar_#currentrow#" maxlength="10" style="width:50;" value="#MIKTAR*1000#">
                                <cfelse>
                                    <input type="text" name="miktar_#currentrow#" id="miktar_#currentrow#" maxlength="10" style="width:50;" value="#MIKTAR#">
                                </cfif>
                            </td>
                            <cfif isdefined("attributes.file_id")>
                                <cfset satir_toplam = MIKTAR * STANDART_ALIS>
                                <cfif session.ep.isBranchAuthorization eq 0><td align="right" style="text-align:right;">#TLFormat(satir_toplam)# #other_money#</td></cfif>
                                <cfif len(money_rate)><cfset satir_toplam=satir_toplam*money_rate></cfif>
                                <cfset net_total = net_total + satir_toplam>
                            </cfif>
                        </tr>
                    </cfoutput>
                    <cfif isdefined("attributes.file_id") and session.ep.isBranchAuthorization eq 0>
                        <cfoutput>
                            <tr class="color-list" height="22">
                                <td colspan="15" align="right" class="formbold" style="text-align:right;"><cf_get_lang dictionary_id ='36080.Toplam Maliyet'></td>
                                <td align="right" class="txtbold" style="text-align:right;">#TLFormat(net_total)# #session.ep.money#</td>
                            </tr>
                        </cfoutput>
                    </cfif>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="15">
                        <cf_record_info query_name="get_sayim_satirlar">
                        </td>
                        <td style="text-align:right">
                            <cf_workcube_buttons is_upd='0' type_format="1">
                        </td>
                    </tr>
                </tfoot>
            </cf_grid_list>
        </cfform>
    </cf_box>
</div>


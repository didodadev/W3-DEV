<cf_xml_page_edit>
<cfquery name="GET_BASKET" datasource="#DSN3#">
	SELECT AMOUNT_ROUND FROM SETUP_BASKET WHERE B_TYPE = 1 AND BASKET_ID = 4 ORDER BY BASKET_ID
</cfquery>
<cfset amount_round = get_basket.amount_round>
<cfquery name="GET_ORDERS_SHIP" datasource="#DSN3#">
	SELECT
		ORDERS_SHIP.PERIOD_ID AS SHIP_PERIOD_ID,
		'' AS INVOICE_PERIOD_ID
	FROM
		ORDERS_SHIP
	WHERE
		<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
			ORDERS_SHIP.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
		</cfif>
		<cfif isdefined('attributes.ship_id') and len(attributes.ship_id)>
			ORDERS_SHIP.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
		</cfif>
		<cfif isdefined('attributes.order_id') and len(attributes.order_id)>	
            UNION
                SELECT
                    '' SHIP_PERIOD_ID,
                    ORDERS_INVOICE.PERIOD_ID AS INVOICE_PERIOD_ID
                FROM
                    ORDERS_INVOICE
                WHERE		
                    ORDERS_INVOICE.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
        </cfif>
</cfquery>
<cfset ship_list="">
<cfset return_ship_list="">
<cfset invoice_list="">
<cfset period_list_ship = "">
<cfset period_list_invoice = "">
<cfif get_orders_ship.recordcount>
	<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
        <cfset period_list_ship = listsort(valuelist(get_orders_ship.ship_period_id),"numeric","asc",",")>
        <cfquery name="GET_PERIOD_SHIP_DSNS" datasource="#DSN3#">
            SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#period_list_ship#)
        </cfquery>
        <cfset period_list_invoice = listsort(valuelist(get_orders_ship.invoice_period_id),"numeric","asc",",")>
        <cfquery name="GET_PERIOD_INVOICE_DSNS" datasource="#DSN3#">
            SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#period_list_invoice#)
        </cfquery>
        <cfset period_list_invoice = listsort(valuelist(get_period_invoice_dsns.period_id),"numeric","asc",",")>
	</cfif>
</cfif>
<cfif get_orders_ship.recordcount>
	<cfquery name="GET_ORDER_DET" datasource="#DSN3#">
		SELECT
			ORR.STOCK_ID,
			<cfif isdefined('xml_is_stock_based_group') and xml_is_stock_based_group eq 0>
				ORR.QUANTITY QUANTITY,
			<cfelse>
				SUM(ORR.QUANTITY) QUANTITY,
			</cfif>
			ORD.ORDER_HEAD,
			ORD.ORDER_NUMBER,
			ORR.SPECT_VAR_ID,
			ORR.SPECT_VAR_NAME,
			ORR.WRK_ROW_ID,
			S.PRODUCT_NAME,
			S.STOCK_CODE,
			S.STOCK_CODE_2
		FROM
			ORDER_ROW ORR,
			ORDERS ORD,
			STOCKS S
		WHERE
			ORD.ORDER_ID = ORR.ORDER_ID AND
			ORR.STOCK_ID = S.STOCK_ID
			<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
				AND ORD.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
			</cfif>
			<cfif not (isdefined('xml_is_stock_based_group') and xml_is_stock_based_group eq 0)>
                GROUP BY
                    S.PRODUCT_NAME,
                    ORR.STOCK_ID,
                    ORD.ORDER_HEAD, 
                    ORD.ORDER_NUMBER,
                    ORR.SPECT_VAR_ID,
                    ORR.SPECT_VAR_NAME,
                    ORR.WRK_ROW_ID,
                    S.STOCK_CODE,
                    S.STOCK_CODE_2
            </cfif>
	</cfquery>
	<cfif listlen(period_list_ship) and period_list_ship neq 0>
		<cfquery name="GET_SHIP_DET" datasource="#DSN3#">
			<cfloop query="get_period_ship_dsns">
				SELECT
					S.SHIP_ID,S.SHIP_DATE,STOCK_ID,SR.SPECT_VAR_ID,SUM(AMOUNT) AS IRS_AMOUNT,SHIP_NUMBER
					<!--- <cfif isdefined('xml_is_stock_based_group') and xml_is_stock_based_group eq 0> --->
						,ISNULL(WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
					<!--- </cfif> --->
                    ,#get_period_ship_dsns.PERIOD_YEAR# AS PERIOD_YEAR
				FROM
					 #dsn#_#get_period_ship_dsns.PERIOD_YEAR#_#get_period_ship_dsns.OUR_COMPANY_ID#.SHIP S,
					 #dsn#_#get_period_ship_dsns.PERIOD_YEAR#_#get_period_ship_dsns.OUR_COMPANY_ID#.SHIP_ROW SR
				WHERE
					SR.SHIP_ID = S.SHIP_ID AND
					S.IS_WITH_SHIP = 0 AND<!--- faturaya cekilmis siparislerden olusan siparisleri tekrar burda çekmemesi icin --->
					SR.ROW_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> 
				GROUP BY
					S.SHIP_ID,S.SHIP_DATE,SR.SPECT_VAR_ID,STOCK_ID,SHIP_NUMBER
					<!--- <cfif isdefined('xml_is_stock_based_group') and xml_is_stock_based_group eq 0> --->
                        ,ISNULL(WRK_ROW_RELATION_ID,0)
					<!--- </cfif> --->
			<cfif currentrow neq get_period_ship_dsns.recordcount> UNION ALL </cfif> 
			</cfloop>	
			ORDER BY 
                PERIOD_YEAR,
            	S.SHIP_ID ASC
		</cfquery>
		<cfquery name="GET_SHIP_DET_IADE" datasource="#DSN3#">
			<cfloop query="get_period_ship_dsns">
				SELECT
					S.SHIP_ID,S.SHIP_DATE,SR.STOCK_ID,SR.SPECT_VAR_ID,SUM(SRR.AMOUNT) AS IRS_AMOUNT,SHIP_NUMBER
					<cfif isdefined('xml_is_stock_based_group') and xml_is_stock_based_group eq 0>
					,ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
					</cfif>
				FROM
					 #dsn#_#get_period_ship_dsns.PERIOD_YEAR#_#get_period_ship_dsns.OUR_COMPANY_ID#.SHIP S,
					 #dsn#_#get_period_ship_dsns.PERIOD_YEAR#_#get_period_ship_dsns.OUR_COMPANY_ID#.SHIP_ROW SR,
					 #dsn#_#get_period_ship_dsns.PERIOD_YEAR#_#get_period_ship_dsns.OUR_COMPANY_ID#.SHIP_ROW SRR
				WHERE
					S.SHIP_ID = SRR.SHIP_ID AND
					S.IS_WITH_SHIP = 0 AND<!--- faturaya cekilmis siparislerden olusan siparisleri tekrar burda çekmemesi icin --->
					SR.ROW_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND
					SR.WRK_ROW_ID = SRR.WRK_ROW_RELATION_ID
				GROUP BY
					S.SHIP_ID,S.SHIP_DATE,SR.SPECT_VAR_ID,SR.STOCK_ID,SHIP_NUMBER
					<cfif isdefined('xml_is_stock_based_group') and xml_is_stock_based_group eq 0>
                        ,ISNULL(SR.WRK_ROW_RELATION_ID,0)
					</cfif>
			<cfif currentrow neq get_period_ship_dsns.recordcount> UNION ALL </cfif> 
			</cfloop>	
			ORDER BY S.SHIP_ID ASC
		</cfquery>
		<cfset ship_list_2=listsort(valuelist(get_ship_det.ship_id),"numeric","asc",",")>
		<cfset return_ship_list_2=listsort(valuelist(get_ship_det_iade.ship_id),"numeric","asc",",")>
		<cfset ship_list=listsort(ListDeleteDuplicates(valuelist(get_ship_det.ship_id)),"numeric","asc",",")>
		<cfset return_ship_list=listsort(ListDeleteDuplicates(valuelist(get_ship_det_iade.ship_id)),"numeric","asc",",")>
	</cfif>
	<cfif listlen(period_list_invoice) and period_list_invoice neq 0>
		<cfquery name="GET_INV_DET" datasource="#DSN3#">
			<cfloop query="get_period_invoice_dsns">
				SELECT
					I.INVOICE_ID,
                    I.INVOICE_DATE,
                    STOCK_ID,
                    IR.SPECT_VAR_ID,
                    SUM(AMOUNT) AS IRS_AMOUNT,
                    INVOICE_NUMBER,
                    I.INVOICE_CAT
					<cfif isdefined('xml_is_stock_based_group') and xml_is_stock_based_group eq 0>
						,ISNULL(WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
					</cfif>
				FROM
					#dsn#_#get_period_invoice_dsns.PERIOD_YEAR#_#get_period_invoice_dsns.OUR_COMPANY_ID#.INVOICE I,
					#dsn#_#get_period_invoice_dsns.PERIOD_YEAR#_#get_period_invoice_dsns.OUR_COMPANY_ID#.INVOICE_ROW IR
				WHERE
					IR.INVOICE_ID = I.INVOICE_ID AND
                    IR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
                    AND ISNULL(I.IS_IPTAL,0) = 0
                    <cfif isdefined('attributes.is_purchase') and attributes.is_purchase eq 1>
                        AND I.PURCHASE_SALES = 0
                    <cfelseif isdefined('attributes.is_sale') and attributes.is_sale eq 1> 
                        AND I.PURCHASE_SALES = 1
                    </cfif>
				GROUP BY
					I.INVOICE_ID,
                    I.INVOICE_DATE,
                    IR.SPECT_VAR_ID,
                    STOCK_ID,
                    INVOICE_NUMBER,
                    I.INVOICE_CAT
					<cfif isdefined('xml_is_stock_based_group') and xml_is_stock_based_group eq 0>
						,ISNULL(WRK_ROW_RELATION_ID,0)
					</cfif>
				<cfif currentrow neq get_period_invoice_dsns.recordcount> UNION ALL </cfif> 
			</cfloop>				
		</cfquery>
		<cfset invoice_list=listsort(ListDeleteDuplicates(valuelist(get_inv_det.invoice_id)),"numeric","asc",",")>
		<cfset invoice_list_2=listsort(valuelist(get_inv_det.invoice_id),"numeric","asc",",")>
	</cfif>
	<!--- siparisin cekildigi irsaliye, bir faturaya cekilmiş ve o fatura da ithal mal girişine cekilmiş mi kontrol ediliyor  --->
	<cfif len(ship_list)>
		<cfquery name="GET_IMPORTS_INVOICE" datasource="#DSN2#">
			SELECT 
				INV_S.IMPORT_INVOICE_ID,
				INV_S.SHIP_ID,
				S.SHIP_NUMBER
			FROM 
				INVOICE_SHIPS INV_S,
				SHIP S
			WHERE 
				S.SHIP_ID = INV_S.SHIP_ID AND 
				INV_S.IMPORT_INVOICE_ID IN (SELECT INVOICE_ID FROM INVOICE_SHIPS WHERE SHIP_ID IN (#ship_list#) )
				AND INV_S.IMPORT_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
			ORDER BY 
				INV_S.IMPORT_INVOICE_ID
		</cfquery>
		<cfif get_imports_invoice.recordcount>
			<cfset customs_ship_list=listsort(valuelist(get_imports_invoice.ship_id),"numeric","asc",",")>
			<cfset import_invoice_list=listsort(valuelist(get_imports_invoice.import_invoice_id),"numeric","asc",",")>
			<cfquery name="GET_CUSTOMS_SHIP" datasource="#DSN2#">
				SELECT
					SHIP.SHIP_ID,
                    STOCK_ID,SUM(AMOUNT) AS IRS_AMOUNT,
                    SHIP_NUMBER,SHIP_ROW.IMPORT_INVOICE_ID
				FROM
					SHIP,
					SHIP_ROW
				WHERE
					SHIP_ROW.SHIP_ID = SHIP.SHIP_ID AND
					SHIP_ROW.IMPORT_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
					SHIP_ROW.IMPORT_INVOICE_ID IN (#import_invoice_list#) AND
					SHIP.SHIP_ID IN (#customs_ship_list#)
				GROUP BY
					SHIP.SHIP_ID,SHIP_ROW.IMPORT_INVOICE_ID,STOCK_ID,SHIP_NUMBER
				ORDER BY 		
					SHIP_ROW.IMPORT_INVOICE_ID
			</cfquery>
		</cfif>
	</cfif>
</cfif>

<cfsavecontent variable="title"><cf_get_lang dictionary_id='32721.Sipariş Karşılama Raporu'><cfif get_orders_ship.recordcount>: <cfoutput>#get_order_det.order_number# - #get_order_det.order_head#</cfoutput></cfif></cfsavecontent></td>

<cfsavecontent variable="message"><cf_get_lang dictionary_id='34295.İlişkili Fatura ve İrsaliyeler'></cfsavecontent>
    <cf_box title="#title#">
<cf_seperator id="iliskili_fatura" header="#message#">
<cf_grid_list id="iliskili_fatura" style="display:none;">
    <thead>
        <tr> 
            <th><cf_get_lang dictionary_id='57657.Ürün'></th>
            <cfif xml_stock_code eq 1>
                <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
            </cfif>
            <cfif xml_special_code eq 1>
                <th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
            </cfif>
            <cfif isdefined('xml_dsp_spec_info') and xml_dsp_spec_info eq 1>
                <th><cf_get_lang dictionary_id='57647.Spec'></th>
            </cfif>
            <th width="50"><cf_get_lang dictionary_id='57611.Sipariş'></th>
            <cfoutput>
            <cfif get_orders_ship.recordcount>
                <cfif len(ship_list)>
                <cfloop list="#ship_list#" index="i" delimiters=",">
                    <th width="70">
                        <!--- Siparişin ilişkili irsaliye kaydı çalışılan muhasebe dönemine ait değilse MT--->
                        <cfquery name="Get_Ship_Period" datasource="#dsn3#">
                            SELECT 
                                OS.PERIOD_ID,
                                YEAR(SHIP_DATE) AS SHIP_DATE
                            FROM 
                                ORDERS_SHIP OS
                                LEFT JOIN #dsn#_#get_period_ship_dsns.PERIOD_YEAR#_#get_period_ship_dsns.OUR_COMPANY_ID#.SHIP S ON S.SHIP_ID = OS.SHIP_ID
                            WHERE 
                                OS.ORDER_ID = #attributes.order_id# 
                                AND S.SHIP_ID = #i#
                        </cfquery>
                        <cfif session.ep.period_year eq Get_Ship_Period.Ship_Date>
                            <cf_get_lang dictionary_id='57773.İrsaliye'>:<br/>
                            <cfif isdefined("attributes.is_sale")>
                                <a href="#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=#i#" target="_blank" style="color:##FF0000">
                            <cfelseif isdefined("attributes.is_purchase")>
                                <a href="#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=#get_ship_det.ship_id[listfind(ship_list_2,i,',')]#" target="_blank" style=" color:##FF0000">
                            </cfif>
                            #get_ship_det.ship_number[listfind(ship_list_2,i,',')]#
                            </a>
                            (#dateformat(get_ship_det.ship_date[listfind(ship_list_2,i,',')],dateformat_style)#)
                        <cfelse>
                            <cf_get_lang dictionary_id='57773.İrsaliye'>:<br/>
                            <a href="javascript://" onclick="alert('Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Kayıt Bulunamadı,Lütfen İlgili Belgeye Ait Dönemi Kontrol Ediniz !');" target="_blank" style=" color:##FF0000">
                                #get_ship_det.ship_number[listfind(ship_list_2,i,',')]#
                            </a>
                            (#dateformat(get_ship_det.ship_date[listfind(ship_list_2,i,',')],dateformat_style)#)
                        </cfif>
                    </th>
                </cfloop>
                </cfif>
                <cfif len(return_ship_list)>
                    <cfloop list="#return_ship_list#" index="i" delimiters=",">
                        <th width="70">
                            <cf_get_lang dictionary_id='57773.İrsaliye'><font color="##FF0000">(<cf_get_lang dictionary_id='29418.İade'>)</font>:<br/>
                            <cfif isdefined("attributes.is_sale")>
                                <a href="#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=#i#" target="_blank" style="color:##FF0000">
                            <cfelseif isdefined("attributes.is_purchase")>
                                <a href="#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=#get_ship_det_iade.ship_id[listfind(return_ship_list_2,i,',')]#" target="_blank" style=" color:##FF0000">
                            </cfif>
                            #get_ship_det_iade.ship_number[listfind(return_ship_list_2,i,',')]#
                            </a>
                            (#dateformat(get_ship_det_iade.ship_date[listfind(return_ship_list_2,i,',')],dateformat_style)#)
                        </th>
                    </cfloop>
                </cfif>

                <cfif listlen(invoice_list)>
                    <cfquery name="GET_ALL_INV_DET" dbtype="query">
                        SELECT DISTINCT INVOICE_ID, INVOICE_NUMBER, INVOICE_DATE FROM GET_INV_DET 
                    </cfquery>
                    <cfloop list="#invoice_list#" index="y" delimiters=",">
                        <th width="70">
                            <cf_get_lang dictionary_id='57441.Fatura'>:<br/>
                            <cfif isdefined("attributes.is_sale")>
                                <a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#y#" target="_blank" style="color:##FF0000">
                            <cfelseif isdefined("attributes.is_purchase")>
                                <a href="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#get_all_inv_det.invoice_id[listfind(invoice_list,y,',')]#" target="_blank" style="color:##FF0000">
                            </cfif>
                            #get_all_inv_det.INVOICE_NUMBER[listfind(invoice_list,y,',')]#
                            </a>
                            (#dateformat(get_all_inv_det.INVOICE_DATE[listfind(invoice_list,y,',')],dateformat_style)#)
                        </th>
                    </cfloop>
                </cfif>
            </cfif>
            </cfoutput>
            <th width="50"><cf_get_lang dictionary_id='58444.Kalan'></th>
            <cfif len(ship_list) and get_imports_invoice.recordcount>
                <cfloop query="get_imports_invoice">
                    <th width="50" nowrap="nowrap"><cf_get_lang dictionary_id ='34003.İthal Giriş'>:<br/> <cfoutput>#get_imports_invoice.ship_number#</cfoutput></th>
                </cfloop>
            </cfif>
        </tr>
    </thead>
    <cfif get_orders_ship.recordcount>                   
        <tbody>
            <cfif get_order_det.recordcount>
                <cfoutput query="get_order_det">
                    <cfset irs_top=0>
                    <cfset inv_top=0>
                    <cfset irs_top_iade=0>
                    <cfset stock_id=get_order_det.stock_id>
                    <tr>
                        <td>#get_order_det.product_name#</td>
                        <cfif xml_stock_code eq 1>
                            <td>#get_order_det.stock_code#</td>
                        </cfif>
                        <cfif xml_special_code eq 1>
                            <td>#get_order_det.stock_code_2#</td>
                        </cfif>
                        <cfif isdefined('xml_dsp_spec_info') and xml_dsp_spec_info eq 1>
                            <td><cfif len(get_order_det.spect_var_id)>#get_order_det.spect_var_name#-#get_order_det.spect_var_id#</cfif></td>
                        </cfif>
                        <td style="text-align:right;">#TLFormat(get_order_det.quantity,amount_round)#</td>
                        <cfif get_orders_ship.recordcount>
                            <cfif len(ship_list)>
                                <cfloop list="#ship_list#" index="z">
                                    <cfquery name="GET_AMOUNT_SHP" dbtype="query">
                                        SELECT 
                                            IRS_AMOUNT,
                                            SHIP_ID 
                                        FROM 
                                            GET_SHIP_DET 
                                        WHERE 
                                            SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#z#"> AND 
                                            STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> 
                                            <cfif Len(spect_var_id)>
                                                AND SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#spect_var_id#">
                                            </cfif> 
                                            <!--- <cfif isdefined('xml_is_stock_based_group') and xml_is_stock_based_group eq 0> --->
                                                AND WRK_ROW_RELATION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_order_det.wrk_row_id#">
                                            <!--- </cfif> --->
                                    </cfquery>
                                    <td style="text-align:right;">
                                        <cfif get_amount_shp.recordcount neq 0 and len(get_amount_shp.irs_amount)>
                                            #TLFormat(get_amount_shp.irs_amount,amount_round)#
                                        <cfset irs_top=irs_top+get_amount_shp.irs_amount>
                                        <cfelse>
                                            -
                                        </cfif>
                                    </td>
                                </cfloop>
                            </cfif>
                            <cfif len(return_ship_list)>
                                <cfloop list="#return_ship_list#" index="z">
                                    <cfquery name="GET_AMOUNT_SHP" dbtype="query">
                                        SELECT 
                                            IRS_AMOUNT,
                                            SHIP_ID 
                                        FROM 
                                            GET_SHIP_DET_IADE 
                                        WHERE 
                                            SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#z#"> AND 
                                            STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> 
                                            <cfif Len(spect_var_id)>
                                                AND SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#spect_var_id#">
                                            </cfif> 
                                            <cfif isdefined('xml_is_stock_based_group') and xml_is_stock_based_group eq 0>
                                                AND WRK_ROW_RELATION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_order_det.WRK_ROW_ID#">
                                            </cfif>
                                    </cfquery>
                                    <td style="text-align:right;">
                                        <cfif get_amount_shp.recordcount neq 0 and len(get_amount_shp.irs_amount)>
                                            #TLFormat(get_amount_shp.irs_amount,amount_round)#
                                        <cfset irs_top_iade=irs_top_iade+get_amount_shp.irs_amount>
                                        <cfelse>
                                            -
                                        </cfif>
                                    </td>
                                </cfloop>
                            </cfif>
                            <cfif len(invoice_list)>
                                <cfloop list="#invoice_list#" index="inv_ii">
                                    <cfquery name="GET_AMOUNT_INV" dbtype="query">
                                        SELECT 
                                            IRS_AMOUNT,
                                            INVOICE_ID,
                                            INVOICE_CAT 
                                        FROM 
                                            GET_INV_DET 
                                        WHERE 
                                            INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#inv_ii#"> AND 
                                            STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> 
                                            <cfif Len(spect_var_id)>
                                                AND SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#spect_var_id#">
                                            </cfif> 
                                            <cfif isdefined('xml_is_stock_based_group') and xml_is_stock_based_group eq 0>
                                                AND WRK_ROW_RELATION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_order_det.wrk_row_id#">
                                            </cfif>
                                    </cfquery>
                                    <td style="text-align:right;">
                                        <cfif get_amount_inv.recordcount neq 0 and len(get_amount_inv.irs_amount)>
                                            <cfif listfind('55,62',get_amount_inv.invoice_cat)>
                                                #TLFormat(-1*get_amount_inv.irs_amount,amount_round)#
                                                <cfset inv_top=inv_top-get_amount_inv.irs_amount>
                                            <cfelse>
                                                #TLFormat(get_amount_inv.irs_amount,amount_round)#
                                            <cfset inv_top=inv_top+get_amount_inv.irs_amount>
                                            </cfif>
                                        <cfelse>
                                            -
                                        </cfif>
                                    </td>
                                </cfloop>
                            </cfif>
                        </cfif>
                        <td style="text-align:right;">#TLFormat(get_order_det.quantity-irs_top-inv_top+irs_top_iade,amount_round)#</td>
                        <cfif len(ship_list) and get_imports_invoice.recordcount>
                            <cfloop query="get_imports_invoice">
                                <cfset ith_inv_amount=''>
                                <cfquery name="IMPORTS_STOK_DETAIL" dbtype="query">
                                    SELECT * FROM GET_CUSTOMS_SHIP WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> AND SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_imports_invoice.ship_id#">
                                </cfquery>	
                                <cfset ith_inv_amount = imports_stok_detail.irs_amount>
                                <td style="text-align:right;"><cfif len(ith_inv_amount)>#ith_inv_amount#<cfelse>-</cfif></td>
                            </cfloop>
                        </cfif>
                    </tr>
                </cfoutput>
            </cfif>
        </tbody>				 
    <cfelse>
        <td colspan="6"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
    </cfif>
</cf_grid_list>
<cfif get_orders_ship.recordcount and isDefined("ship_list") and len(ship_list)><!--- fatura bilgilerini gösterir --->
    <cfset all_period_id_list = ListSort(ListDeleteDuplicates(ListAppend(period_list_ship,period_list_invoice)),"numeric","asc",",")>
    <!--- FBS 20110505 Burada yukaridaki queryler ile kopukluk var, bulundugumuz doneme ait bir irsaliye veya fatura olmayabilir iliskili olanlar, 
    ama bu yilinkileri gosteriyor iliskiliymis gibi, duzeltme yapildi, gerekirse daha saglikli bir duzenleme yapilabilir --->
    <cfquery name="GET_SHIP_INV_DETAILS" datasource="#DSN2#">
        <cfloop query="get_period_ship_dsns">
            SELECT
                SHIP.SHIP_DATE,
                SHIP.SHIP_ID,
                SHIP.SHIP_NUMBER,
                INVOICE.INVOICE_DATE,
                INVOICE.INVOICE_NUMBER,
                INVOICE.INVOICE_ID,
                INVOICE_SHIPS.SHIP_PERIOD_ID
            FROM
                #dsn#_#get_period_ship_dsns.PERIOD_YEAR#_#get_period_ship_dsns.OUR_COMPANY_ID#.INVOICE_SHIPS,
                #dsn#_#get_period_ship_dsns.PERIOD_YEAR#_#get_period_ship_dsns.OUR_COMPANY_ID#.INVOICE,
                #dsn#_#get_period_ship_dsns.PERIOD_YEAR#_#get_period_ship_dsns.OUR_COMPANY_ID#.SHIP
            WHERE
                INVOICE.INVOICE_ID = INVOICE_SHIPS.INVOICE_ID AND
                SHIP.SHIP_ID = INVOICE_SHIPS.SHIP_ID AND
                INVOICE_SHIPS.SHIP_PERIOD_ID IN (#get_period_ship_dsns.period_id#)
                <cfif ship_list eq 0>
                    AND INVOICE.INVOICE_ID IN (#invoice_list#)
                <cfelse>
                    AND INVOICE_SHIPS.INVOICE_ID IN (SELECT INVOICE_ID FROM #dsn#_#get_period_ship_dsns.PERIOD_YEAR#_#get_period_ship_dsns.OUR_COMPANY_ID#.INVOICE_SHIPS WHERE SHIP_ID IN (#ship_list#) AND SHIP_PERIOD_ID IN (#get_period_ship_dsns.period_id#))
                </cfif>
                <cfif get_period_ship_dsns.currentrow neq get_period_ship_dsns.recordcount>UNION</cfif>
            </cfloop>
            <cfif get_period_ship_dsns.currentrow eq get_period_ship_dsns.recordcount>
                ORDER BY
                    SHIP.SHIP_ID
            </cfif>
    </cfquery>
    <cf_flat_list>
        <thead>
            <tr> 
                <th><cf_get_lang dictionary_id='58138.İrsaliye No'></th>
                <th><cf_get_lang dictionary_id='33096.İrsaliye Tarihi'></th>
                <th><cf_get_lang dictionary_id='58133.Fatura No'></th>
                <th><cf_get_lang dictionary_id='58759.Fatura Tarihi'></th>
            </tr>
        </thead>
        <tbody>
        <cfif get_ship_inv_details.recordcount>
            <cfoutput query="get_ship_inv_details">
                <tr>
                    <td>
                        <cfif session.ep.period_id eq get_ship_inv_details.ship_period_id>
                            <cfif isdefined("attributes.is_sale")>
                                <a href="#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=#get_ship_inv_details.ship_id#" target="_blank">#ship_number#</a>
                            <cfelseif isdefined("attributes.is_purchase")>
                                <a href="#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=#get_ship_inv_details.ship_id#" target="_blank">#ship_number#</a>
                            </cfif>
                        <cfelse>
                            <a  href="javascript://" onclick="alert('Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Kayıt Bulunamadı,Lütfen İlgili Belgeye Ait Dönemi Kontrol Ediniz !');">#ship_number#</a>
                        </cfif>
                    </td>
                    <td>#dateformat(ship_date,dateformat_style)#</td>
                    <td>
                        <cfif session.ep.period_id eq get_ship_inv_details.ship_period_id>
                            <cfif isdefined("attributes.is_sale")>
                                <a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#invoice_id#" target="_blank">#invoice_number#</a>
                            <cfelseif isdefined("attributes.is_purchase")>
                                <a href="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#invoice_id#" target="_blank">#invoice_number#</a>
                            </cfif>
                        <cfelse>
                            <a  href="javascript://" onclick="alert('Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Kayıt Bulunamadı,Lütfen İlgili Belgeye Ait Dönemi Kontrol Ediniz !');">#invoice_number#</a>
                        </cfif>
                    </td>
                    <td>#dateformat(invoice_date,dateformat_style)#</td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
            </tr>
        </cfif>
        </tbody>
    </cf_flat_list>
</cfif>
<cfif isdefined("attributes.is_sale") and isdefined('attributes.order_id') and len(attributes.order_id)>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='32933.İlişkili Satınalma Siparişleri'></cfsavecontent>
	<cf_seperator id="iliskili_satinalma" header="#message#">
	<!--- Iliskili Satınalma Siparişleri --->
    <cfquery name="GET_RELATED_ORDERS" datasource="#DSN3#">
        SELECT 
            O.ORDER_ID,
            O.ORDER_NUMBER,
            O.ORDER_HEAD,
            O.ORDER_DATE,
            (SELECT PRODUCT_NAME FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = ORR.PRODUCT_ID) PRODUCT_NAME,
            ORR.QUANTITY
        FROM
            ORDER_ROW ORR,
            ORDERS O
        WHERE
            O.ORDER_ID = ORR.ORDER_ID
            AND 
            (
                ORR.WRK_ROW_ID IN(SELECT ORR_.WRK_ROW_RELATION_ID FROM ORDER_ROW ORR_ WHERE ORR_.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">)
                OR ORR.WRK_ROW_RELATION_ID IN(SELECT ORR_.WRK_ROW_ID FROM ORDER_ROW ORR_ WHERE ORR_.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">)
            )
    </cfquery>            
    <cf_flat_list id="iliskili_satinalma" width="100%" style="display:none;">
        <thead>
            <tr> 
                <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                <th><cf_get_lang dictionary_id='57635.Miktar'></th>
            </tr>
        </thead>
        <cfif get_related_orders.recordcount>
            <tbody>
                <cfoutput query="get_related_orders" group="order_number">
                    <tr>
                        <td colspan="3"><a href="#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#order_id#" target="_blank"><strong>#order_number# - #DateFormat(order_date,dateformat_style)#</strong></a></td>
                    </tr>
                    <cfoutput>
                    <tr>
                        <td>&nbsp;&nbsp;#product_name#</td>
                        <td>#TLFormat(quantity,amount_round)#</td>
                    </tr>
                    </cfoutput>
                </cfoutput>
            </tbody>            
        <cfelse>
            <td colspan="2"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
        </cfif>
    </cf_flat_list>
</cfif>
<cfif isdefined("attributes.is_purchase")>
	<!--- Iliskili satınalma Talepler --->
    <cfquery name="GET_RELATED_INTERNALDEMAND" datasource="#DSN3#">
        SELECT 
            I.INTERNAL_ID,
            I.INTERNAL_NUMBER,
            I.RECORD_DATE,
            (SELECT PRODUCT_NAME FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = IRR.PRODUCT_ID) PRODUCT_NAME,
            IRR.AMOUNT,
            I.DEMAND_TYPE
        FROM
            INTERNALDEMAND_RELATION_ROW IRR,
            INTERNALDEMAND I
        WHERE
            I.INTERNAL_ID = IRR.INTERNALDEMAND_ID
            AND ISNULL(I.DEMAND_TYPE,0) = 1
            <cfif isdefined('attributes.order_id') and len(attributes.order_id)>
                AND IRR.TO_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
            </cfif>
        <cfif isdefined('attributes.order_id') and len(attributes.order_id)>
            UNION
                <!--- Tekliften talebe donusturulmus talepler icin gecici cozum --->
                SELECT
                    I2.INTERNAL_ID,
                    I2.INTERNAL_NUMBER,
                    I2.RECORD_DATE,
                    IR2.PRODUCT_NAME,
                    IR2.QUANTITY AMOUNT,
                    I2.DEMAND_TYPE
                FROM
                    INTERNALDEMAND_RELATION_ROW IRR,
                    INTERNALDEMAND I2,
                    INTERNALDEMAND_ROW IR2
                WHERE
                    I2.INTERNAL_ID = IR2.I_ID AND
                    I2.INTERNAL_ID = IRR.INTERNALDEMAND_ID AND
                    IRR.TO_OFFER_ID IN (SELECT OFFER_ID FROM OFFER_ROW WHERE WRK_ROW_ID IN(SELECT WRK_ROW_RELATION_ID FROM ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">))
                    AND ISNULL(I2.DEMAND_TYPE,0) = 1
            UNION
                SELECT
                    I2.INTERNAL_ID,
                    I2.INTERNAL_NUMBER,
                    I2.RECORD_DATE,
                    IR2.PRODUCT_NAME,
                    IR2.QUANTITY AMOUNT,
                    I2.DEMAND_TYPE
                FROM
                    INTERNALDEMAND_RELATION_ROW IRR,
                    INTERNALDEMAND I2,
                    INTERNALDEMAND_ROW IR2,
                    OFFER O,
                    OFFER O2
                WHERE
                    I2.INTERNAL_ID = IR2.I_ID AND
                    I2.INTERNAL_ID = IRR.INTERNALDEMAND_ID AND
                    IRR.TO_OFFER_ID = O.OFFER_ID AND
                    O.OFFER_ID = O2.FOR_OFFER_ID AND
                    O2.OFFER_ID IN (SELECT OFFER_ID FROM OFFER_ROW WHERE WRK_ROW_ID IN(SELECT WRK_ROW_RELATION_ID FROM ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">))
                    AND ISNULL(I2.DEMAND_TYPE,0) = 1
                ORDER BY
                    INTERNAL_NUMBER
        </cfif>
    </cfquery>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='33263.Satınalma Talepleri'></cfsavecontent>
        <cf_seperator id="iliskili_satinalma_talepler" header="#message#">
        <cf_flat_list id="iliskili_satinalma_talepler" style="display:none;">
            <thead>
                <tr> 
                    <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                    <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                </tr>	
            </thead>
            <cfif get_related_internaldemand.recordcount>       
                <tbody>
                    <cfoutput query="get_related_internaldemand" group="internal_number">
                        <tr>
                            <td colspan="3">
                                <cfif demand_type eq 0>
                                    <a href="#request.self#?fuseaction=purchase.list_internaldemand&event=upd&id=#internal_id#" target="_blank"><strong>#internal_number# - #DateFormat(record_date,dateformat_style)#</strong></a>
                                <cfelse>
                                    <a href="#request.self#?fuseaction=purchase.list_purchasedemand&event=upd&id=#internal_id#" target="_blank"><strong>#internal_number# - #DateFormat(record_date,dateformat_style)#</strong></a>
                                </cfif>
                            </td>
                        </tr>
                        <cfoutput>
                            <tr>
                                <td>&nbsp;&nbsp;#product_name#</td>
                                <td>#TLFormat(amount,amount_round)#</td>
                            </tr>
                        </cfoutput>
                    </cfoutput>
                </tbody>
            
            <cfelse>
                <td colspan="2"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>           
            </cfif>
        </cf_flat_list>
</cfif>
<cfif isdefined("attributes.is_purchase")>
	<!--- Iliskili Ic Talepler --->
    <cfquery name="GET_RELATED_INTERNALDEMAND" datasource="#DSN3#">
        <cfif isDefined("get_related_internaldemand") and get_related_internaldemand.recordcount>
            <!--- Yukarda Iliskili Satinalma Talebi varsa Oradan Aliyoruz, Tekrar Talebi Bulmaya Calismiyoruz fbs 20130605--->
            SELECT
                INTERNAL_ID,
                INTERNAL_NUMBER,
                RECORD_DATE,
                PRODUCT_NAME,
                QUANTITY AMOUNT,
                DEMAND_TYPE
            FROM
                (
                    SELECT
                        I.INTERNAL_ID,
                        I.INTERNAL_NUMBER,
                        I.RECORD_DATE,
                        I.DEMAND_TYPE,
                        IR.STOCK_ID,
                        IR.PRODUCT_NAME,
                        SUM(IR.QUANTITY) QUANTITY
                    FROM 
                        INTERNALDEMAND I,
                        INTERNALDEMAND_ROW IR,
                        INTERNALDEMAND_ROW IR2
                    WHERE 
                        I.INTERNAL_ID = IR.I_ID AND
                        ISNULL(I.DEMAND_TYPE,0) = 0 AND
                        IR.WRK_ROW_ID = IR2.WRK_ROW_RELATION_ID AND
                        IR2.WRK_ROW_ID IN (SELECT PSA.WRK_ROW_RELATION_ID FROM INTERNALDEMAND_ROW PSA WHERE PSA.I_ID IN (#valuelist(get_related_internaldemand.internal_id)#))
                    GROUP BY
                        I.INTERNAL_ID,
                        I.INTERNAL_NUMBER,
                        I.RECORD_DATE,
                        I.DEMAND_TYPE,
                        IR.STOCK_ID,
                        IR.PRODUCT_NAME
                    UNION ALL
                    SELECT
                        I.INTERNAL_ID,
                        I.INTERNAL_NUMBER,
                        I.RECORD_DATE,
                        I.DEMAND_TYPE,
                        IR.STOCK_ID,
                        IR.PRODUCT_NAME,
                        SUM(IR.QUANTITY) QUANTITY
                    FROM 
                        INTERNALDEMAND I,
                        INTERNALDEMAND_ROW IR,
                        INTERNALDEMAND_ROW IR2,
                        INTERNALDEMAND_ROW IR3
                    WHERE 
                        I.INTERNAL_ID = IR.I_ID AND
                        ISNULL(I.DEMAND_TYPE,0) = 0 AND
                        IR.WRK_ROW_ID = IR2.WRK_ROW_RELATION_ID AND
                        IR2.WRK_ROW_ID = IR3.WRK_ROW_RELATION_ID AND
                        IR3.WRK_ROW_ID IN (SELECT PSA.WRK_ROW_RELATION_ID FROM INTERNALDEMAND_ROW PSA WHERE PSA.I_ID IN (#valuelist(get_related_internaldemand.internal_id)#))
                    GROUP BY
                        I.INTERNAL_ID,
                        I.INTERNAL_NUMBER,
                        I.RECORD_DATE,
                        I.DEMAND_TYPE,
                        IR.STOCK_ID,
                        IR.PRODUCT_NAME
                    UNION ALL
                    SELECT
                        I.INTERNAL_ID,
                        I.INTERNAL_NUMBER,
                        I.RECORD_DATE,
                        I.DEMAND_TYPE,
                        IR.STOCK_ID,
                        IR.PRODUCT_NAME,
                        SUM(IR.QUANTITY) QUANTITY
                    FROM 
                        INTERNALDEMAND I,
                        INTERNALDEMAND_ROW IR,
                        INTERNALDEMAND_ROW IR2,
                        INTERNALDEMAND_ROW IR3,
                        INTERNALDEMAND_ROW IR4
                    WHERE 
                        I.INTERNAL_ID = IR.I_ID AND
                        ISNULL(I.DEMAND_TYPE,0) = 0 AND
                        IR.WRK_ROW_ID = IR2.WRK_ROW_RELATION_ID AND
                        IR2.WRK_ROW_ID = IR3.WRK_ROW_RELATION_ID AND
                        IR3.WRK_ROW_ID = IR4.WRK_ROW_RELATION_ID AND
                        IR4.WRK_ROW_ID IN (SELECT PSA.WRK_ROW_RELATION_ID FROM INTERNALDEMAND_ROW PSA WHERE PSA.I_ID IN (#valuelist(get_related_internaldemand.internal_id)#))
                    GROUP BY
                        I.INTERNAL_ID,
                        I.INTERNAL_NUMBER,
                        I.RECORD_DATE,
                        I.DEMAND_TYPE,
                        IR.STOCK_ID,
                        IR.PRODUCT_NAME
                ) AS TABLE1
             UNION ALL
		</cfif>
        <!--- ic talep - satinalma siparisi --->
        SELECT 
            I.INTERNAL_ID,
            I.INTERNAL_NUMBER,
            I.RECORD_DATE,
            (SELECT PRODUCT_NAME FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = IRR1.PRODUCT_ID) PRODUCT_NAME,
            IRR1.QUANTITY AMOUNT,
            I.DEMAND_TYPE
        FROM
            INTERNALDEMAND_RELATION_ROW IRR,
            INTERNALDEMAND_ROW IRR1,
            INTERNALDEMAND I
        WHERE
            I.INTERNAL_ID = IRR.INTERNALDEMAND_ID AND
            I.INTERNAL_ID = IRR1.I_ID AND 
            ISNULL(I.DEMAND_TYPE,0) = 0 AND 
            IRR.TO_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
        UNION ALL
        SELECT 
            I.INTERNAL_ID,
            I.INTERNAL_NUMBER,
            I.RECORD_DATE,
            (SELECT PRODUCT_NAME FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = IRR2.PRODUCT_ID) PRODUCT_NAME,
            IRR2.QUANTITY AMOUNT,
            I.DEMAND_TYPE
        FROM
            INTERNALDEMAND_ROW IRR1,
            INTERNALDEMAND_ROW IRR2,
            INTERNALDEMAND I
        WHERE
            I.INTERNAL_ID = IRR2.I_ID
            AND IRR1.WRK_ROW_RELATION_ID = IRR2.WRK_ROW_ID
            AND ISNULL(I.DEMAND_TYPE,0) = 0
            AND IRR1.I_ID IN
            (
                SELECT 
                    I.INTERNAL_ID
                FROM
                    INTERNALDEMAND_RELATION_ROW IRR,
                    INTERNALDEMAND I
                WHERE
                    I.INTERNAL_ID = IRR.INTERNALDEMAND_ID
                    AND ISNULL(I.DEMAND_TYPE,0) = 1
                    AND IRR.TO_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
            UNION
                SELECT
                    I2.INTERNAL_ID
                FROM
                    INTERNALDEMAND_RELATION_ROW IRR,
                    INTERNALDEMAND I2,
                    INTERNALDEMAND_ROW IR2
                WHERE
                    I2.INTERNAL_ID = IR2.I_ID AND
                    I2.INTERNAL_ID = IRR.INTERNALDEMAND_ID AND
                    IRR.TO_OFFER_ID IN (SELECT OFFER_ID FROM OFFER_ROW WHERE WRK_ROW_ID IN(SELECT WRK_ROW_RELATION_ID FROM ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">))
                    AND ISNULL(I2.DEMAND_TYPE,0) = 1
            UNION
                SELECT
                    I2.INTERNAL_ID
                FROM
                    INTERNALDEMAND_RELATION_ROW IRR,
                    INTERNALDEMAND I2,
                    INTERNALDEMAND_ROW IR2,
                    OFFER O,
                    OFFER O2
                WHERE
                    I2.INTERNAL_ID = IR2.I_ID AND
                    I2.INTERNAL_ID = IRR.INTERNALDEMAND_ID AND
                    IRR.TO_OFFER_ID = O.OFFER_ID AND
                    O.OFFER_ID = O2.FOR_OFFER_ID AND
                    O2.OFFER_ID IN (SELECT OFFER_ID FROM OFFER_ROW WHERE WRK_ROW_ID IN(SELECT WRK_ROW_RELATION_ID FROM ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">))
            )
            ORDER BY
                INTERNAL_NUMBER
    </cfquery>
    <!---  Alt kirilimlarla birlikte satinalma taleplerinden dogru iliskili olan ic talepler icin kapatilip yukardaki sekilde duzenlendi (isbak) fbs 20130605
     <cfquery name="get_related_internaldemand" datasource="#DSN3#">
        SELECT 
            I.INTERNAL_ID,
            I.INTERNAL_NUMBER,
            I.RECORD_DATE,
            (SELECT PRODUCT_NAME FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = IRR.PRODUCT_ID) PRODUCT_NAME,
            IRR.AMOUNT,
            I.DEMAND_TYPE
        FROM
            INTERNALDEMAND_RELATION_ROW IRR,
            INTERNALDEMAND I
        WHERE
            I.INTERNAL_ID = IRR.INTERNALDEMAND_ID
            AND ISNULL(I.DEMAND_TYPE,0) = 0
            <cfif isdefined('attributes.order_id') and len(attributes.order_id)>
                AND IRR.TO_ORDER_ID = #attributes.order_id#
            </cfif>
    <cfif isdefined('attributes.order_id') and len(attributes.order_id)>
    UNION
        <!--- Tekliften talebe donusturulmus talepler icin gecici cozum --->
        SELECT
            I2.INTERNAL_ID,
            I2.INTERNAL_NUMBER,
            I2.RECORD_DATE,
            IR2.PRODUCT_NAME,
            IR2.QUANTITY AMOUNT,
            I2.DEMAND_TYPE
        FROM
            INTERNALDEMAND_RELATION_ROW IRR,
            INTERNALDEMAND I2,
            INTERNALDEMAND_ROW IR2
        WHERE
            I2.INTERNAL_ID = IR2.I_ID AND
            I2.INTERNAL_ID = IRR.INTERNALDEMAND_ID AND
            IRR.TO_OFFER_ID IN (SELECT OFFER_ID FROM OFFER_ROW WHERE WRK_ROW_ID IN(SELECT WRK_ROW_RELATION_ID FROM ORDER_ROW WHERE ORDER_ID = #attributes.order_id#))
            AND ISNULL(I2.DEMAND_TYPE,0) = 0
    UNION
        SELECT
            I2.INTERNAL_ID,
            I2.INTERNAL_NUMBER,
            I2.RECORD_DATE,
            IR2.PRODUCT_NAME,
            IR2.QUANTITY AMOUNT,
            I2.DEMAND_TYPE
        FROM
            INTERNALDEMAND_RELATION_ROW IRR,
            INTERNALDEMAND I2,
            INTERNALDEMAND_ROW IR2,
            OFFER O,
            OFFER O2
        WHERE
            I2.INTERNAL_ID = IR2.I_ID AND
            I2.INTERNAL_ID = IRR.INTERNALDEMAND_ID AND
            IRR.TO_OFFER_ID = O.OFFER_ID AND
            O.OFFER_ID = O2.FOR_OFFER_ID AND
            O2.OFFER_ID IN (SELECT OFFER_ID FROM OFFER_ROW WHERE WRK_ROW_ID IN(SELECT WRK_ROW_RELATION_ID FROM ORDER_ROW WHERE ORDER_ID = #attributes.order_id#))
            AND ISNULL(I2.DEMAND_TYPE,0) = 0
        ORDER BY
            INTERNAL_NUMBER
        </cfif>
    </cfquery>
     --->
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='32937.İlişkili İç Talepler'></cfsavecontent>
    <cf_seperator id="iliskili_ic_talepler" header="#message#">
    <cf_flat_list id="iliskili_ic_talepler" style="display:none;">
        <thead>
            <tr> 
                <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                <th><cf_get_lang dictionary_id='57635.Miktar'></th>
            </tr>	
        </thead>
        <cfif get_related_internaldemand.recordcount>
            <tbody>
                <cfoutput query="get_related_internaldemand" group="internal_number">
                    <tr>
                        <td colspan="3">
                            <cfif demand_type eq 0>
                                <a href="#request.self#?fuseaction=purchase.list_internaldemand&event=upd&id=#internal_id#" target="_blank"><strong>#internal_number# - #DateFormat(record_date,dateformat_style)#</strong></a>
                            <cfelse>
                                <a href="#request.self#?fuseaction=purchase.list_purchasedemand&event=upd&id=#internal_id#" target="_blank"><strong>#internal_number# - #DateFormat(record_date,dateformat_style)#</strong></a>
                            </cfif>
                        </td>
                    </tr>
                    <cfoutput>
                    <tr>
                        <td>&nbsp;&nbsp;#product_name#</td>
                        <td>#TLFormat(amount,amount_round)#</td>
                    </tr>
                    </cfoutput>
                </cfoutput>
            </tbody>                    
        <cfelse>
            <td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </cfif>
    </cf_flat_list>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32656.İlişkili Teklifler'></cfsavecontent>
<cf_seperator id="iliskili_teklifler" header="#message#">
<!--- Iliskili Teklifler --->
<cfquery name="GET_RELATED_OFFER" datasource="#DSN3#">
	SELECT
		DISTINCT 
		OFFER_ID,
		OFFER_NUMBER,
		RECORD_DATE,
		PURCHASE_SALES,
		OFFER_ZONE,
		QUANTITY,
		PRODUCT_NAME,
		OFFER_ROW_ID
	FROM
	(
		SELECT
			O.OFFER_ID,
			O.OFFER_NUMBER,
			O.RECORD_DATE,
			O.PURCHASE_SALES,
			O.OFFER_ZONE,
			OFR.QUANTITY,
			OFR.PRODUCT_NAME,
			OFFER_ROW_ID
		FROM
			OFFER O,
			OFFER_ROW OFR
		WHERE
			O.OFFER_ID = OFR.OFFER_ID
			AND O.OFFER_ID IN (SELECT ORDERS.OFFER_ID FROM ORDERS WHERE ORDERS.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND ORDERS.OFFER_ID=O.OFFER_ID)
		UNION ALL
		SELECT
			O.OFFER_ID,
			O.OFFER_NUMBER,
			O.RECORD_DATE,
			O.PURCHASE_SALES,
			O.OFFER_ZONE,
			OFR.QUANTITY,
			OFR.PRODUCT_NAME,
			OFFER_ROW_ID
		FROM
			OFFER O,
			OFFER_ROW OFR
		WHERE
			O.OFFER_ID = OFR.OFFER_ID
			AND OFR.WRK_ROW_ID IN (SELECT ORDER_ROW.WRK_ROW_RELATION_ID FROM ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND ORDER_ROW.WRK_ROW_RELATION_ID=OFR.WRK_ROW_ID)
	)T1
</cfquery>
<cf_flat_list id="iliskili_teklifler" style="display:none;">
    <thead>
        <tr> 
            <th><cf_get_lang dictionary_id='57657.Ürün'></th>
            <th><cf_get_lang dictionary_id='57635.Miktar'></th>
        </tr>
    </thead>
    <cfif get_related_offer.recordcount>
        <tbody>
            <cfoutput query="get_related_offer" group="offer_number">
                <!--- <cfif (purchase_sales eq 1 and offer_zone eq 0) or (purchase_sales eq 0 and offer_zone eq 1)> --->
                <cfif isdefined("attributes.is_sale")>
                    <cfset module_ = "sales.list_offer&event=upd">
                <cfelse>
                    <cfset module_ = "purchase.list_offer&event=upd">
                </cfif>
                <tr>
                    <td colspan="3"><a href="#request.self#?fuseaction=#module_#&offer_id=#offer_id#" target="_blank"><strong>#offer_number# - #DateFormat(record_date,dateformat_style)#</strong></a></td>
                </tr>
                <cfoutput>
                    <tr>
                        <td>&nbsp;#product_name#</td>
                        <td>#TLFormat(quantity,amount_round)#</td>
                    </tr>
                </cfoutput>
            </cfoutput>
        </tbody>       
    <cfelse>
        <tr> 
            <td colspan="2"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</cf_flat_list>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57611.Sipariş'></cfsavecontent>
<cf_seperator id="siparis" title="#message#">
    <div id="siparis">
<cfinclude template="ajax_order_stock_detail.cfm">
    </div>
</cf_box>


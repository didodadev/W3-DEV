<cfif not isdefined("attributes.inv_row_ids") or not len(attributes.inv_row_ids)>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfset attributes.import_invoice_period = ListDeleteDuplicates(attributes.import_invoice_period)>
<cfquery name="GET_PERIOD" datasource="#dsn#">
	SELECT
		PERIOD_YEAR,
		OUR_COMPANY_ID
	FROM
		SETUP_PERIOD
	WHERE
		OUR_COMPANY_ID=#session.ep.company_id#
		AND PERIOD_ID = #attributes.import_invoice_period#
</cfquery>
<cfif GET_PERIOD.recordcount>
	<cfset new_dsn="#dsn#_#GET_PERIOD.PERIOD_YEAR#_#GET_PERIOD.OUR_COMPANY_ID#">
	<cfquery name="GET_INVOICE_ROW" datasource="#new_dsn#">
		SELECT 
			INVOICE_ROW.*,
			STOCKS.IS_SERIAL_NO,
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			STOCKS.BARCOD,
			STOCKS.PROPERTY,
			STOCKS.IS_INVENTORY,
			STOCKS.IS_PRODUCTION,
			STOCKS.MANUFACT_CODE
		FROM 
			INVOICE_ROW, 
			#dsn3_alias#.STOCKS AS STOCKS
		WHERE
			INVOICE_ROW.INVOICE_ID IN (#attributes.invoice_id#)
			AND INVOICE_ROW.INVOICE_ROW_ID IN (#attributes.inv_row_ids#)
			AND INVOICE_ROW.STOCK_ID=STOCKS.STOCK_ID
		ORDER BY
			INVOICE_ROW_ID
	</cfquery>

<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_INVOICE_ROW.ROW_PROJECT_ID)),'numeric','asc',',')>
<cfif len(row_project_id_list_)>
	<cfquery name="GET_ROW_PROJECTS" datasource="#dsn#">
		SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#row_project_id_list_#) ORDER BY PROJECT_ID
	</cfquery>
	<cfset row_project_id_list_=valuelist(GET_ROW_PROJECTS.PROJECT_ID)>
</cfif>
	<script language="JavaScript1.3">
		<cfoutput query="GET_INVOICE_ROW">
			<cfset new_amount= evaluate("inv_amount_#GET_INVOICE_ROW.INVOICE_ROW_ID#")>
			<cfif new_amount gt 0>
				<cfset attributes.location_id = DELIVER_LOC >
				<cfset attributes.department_id = DELIVER_DEPT >
				<cfif len(attributes.location_id)>
					<cfinclude template="../query/get_location_for_orders.cfm">
				<cfelseif len(attributes.department_id)>
					<cfinclude template="../query/get_dep_name.cfm">
				</cfif>
				<cfscript>
					if (len(DISCOUNT1)) d1 = DISCOUNT1; else d1=0;
					if (len(DISCOUNT2)) d2 = DISCOUNT2; else d2=0;
					if (len(DISCOUNT3)) d3 = DISCOUNT3; else d3=0;
					if (len(DISCOUNT4)) d4 = DISCOUNT4; else d4=0;
					if (len(DISCOUNT5)) d5 = DISCOUNT5; else d5=0;
					if (len(DISCOUNT6)) d6 = DISCOUNT6; else d6=0;
					if (len(DISCOUNT7)) d7 = DISCOUNT7; else d7=0;
					if (len(DISCOUNT8)) d8 = DISCOUNT8; else d8=0;
					if (len(DISCOUNT9)) d9 = DISCOUNT9; else d9=0;
					if (len(DISCOUNT10)) d10 = DISCOUNT10; else d10=0;
					if (len(DELIVER_DATE)) d_date = dateformat(DELIVER_DATE,dateformat_style); else d_date="";
					if (len(DELIVER_LOC)) 
						{
							d_dept_id = attributes.department_id & "-" & attributes.location_id;
							d_dept_name = GET_LOCATION.comment & "-" & GET_LOCATION.department_head;
						}
					else if (len(attributes.department_id))
						{
							d_dept_id = attributes.department_id;
							d_dept_name = get_dep.department_head;
						}
					else
						{
							d_dept_id = "";
							d_dept_name = "";
						}
					if(len(price)) net_maliyet =NETTOTAL/AMOUNT; else net_maliyet = 0;
					if(len(MARGIN)) marj = TLFormat(MARGIN,4); else marj = 0;
					if(len(EXTRA_COST)) temp_extra_cost = EXTRA_COST; else temp_extra_cost = 0;
					if (len(PROM_COST)) temp_prom_cost = PROM_COST; else temp_prom_cost = 0;
					if(len(NUMBER_OF_INSTALLMENT)) temp_installment_number_= NUMBER_OF_INSTALLMENT; else temp_installment_number_ ='';
					if(len(BASKET_EXTRA_INFO_ID)) temp_basket_extra_info= BASKET_EXTRA_INFO_ID; else temp_basket_extra_info='';
					if(len(SELECT_INFO_EXTRA)) temp_select_info_extra = SELECT_INFO_EXTRA; else temp_select_info_extra="";
					if(len(DETAIL_INFO_EXTRA)) temp_detail_info_extra = DETAIL_INFO_EXTRA; else temp_detail_info_extra="";
					if(len(PROM_RELATION_ID)) temp_prom_relation_id = PROM_RELATION_ID; else temp_prom_relation_id ='';
					if(len(LIST_PRICE)) temp_list_price = LIST_PRICE; else temp_list_price = '';
					if(len(PRICE_CAT)) temp_price_cat = PRICE_CAT; else temp_price_cat = '';
					if(len(KARMA_PRODUCT_ID)) temp_karma_product_id = KARMA_PRODUCT_ID; else temp_karma_product_id = ''; 
					if(len(EK_TUTAR_PRICE)) temp_ek_tutar_price = EK_TUTAR_PRICE; else temp_ek_tutar_price =0;
					if(Len(WRK_ROW_ID)) temp_row_wrk_relation_id = WRK_ROW_ID; else temp_row_wrk_relation_id = '';
					temp_related_action_id = INVOICE_ID;
					temp_related_action_table = 'INVOICE';
					if(len(WIDTH_VALUE)) temp_row_width = WIDTH_VALUE; else temp_row_width = '';
					if(len(DEPTH_VALUE)) temp_row_depth = DEPTH_VALUE; else  temp_row_depth = '';
					if(len(HEIGHT_VALUE))temp_row_height = HEIGHT_VALUE; else  temp_row_height = '';
					if(len(ROW_PROJECT_ID))temp_row_project_id =ROW_PROJECT_ID; else temp_row_project_id='';
					is_production=IS_PRODUCTION;
					is_inventory=IS_INVENTORY;
				</cfscript>
				toplam_hesapla=0;
				<cfif GET_INVOICE_ROW.currentrow eq GET_INVOICE_ROW.recordcount>
					toplam_hesapla=1;
				</cfif>
				opener.add_basket_row('#product_id#', '#stock_id#', '#stock_code#', '#barcod#', '#manufact_code#', '#name_product#', '#unit_id#', '#unit#', '#spect_var_id#', '#spect_var_name#', '#price#', '#price_other#', '#tax#', '', '#d1#', '#d2#', '#d3#', '#d4#', '#d5#', '#d6#', '#d7#', '#d8#', '#d9#', '#d10#', '#d_date#', '#d_dept_id#', '#d_dept_name#', '#LOT_NO#', '#OTHER_MONEY#', '#get_invoice_row.INVOICE_ID#;#attributes.import_invoice_period#', '#new_amount#', '', '#IS_INVENTORY#','#IS_PRODUCTION#','#net_maliyet#','#TLFormat(MARJ)#','#wrk_round(temp_extra_cost,4)#','#PROM_ID#','#PROM_COMISSION#','#temp_prom_cost#','#DISCOUNT_COST#','#IS_PROMOTION#','#prom_stock_id#','0','','#amount2#','#unit2#','0','','','',toplam_hesapla,0,'#temp_basket_extra_info#','#temp_prom_relation_id#','','','#temp_installment_number_#','#temp_price_cat#','#temp_karma_product_id#','','','#temp_row_wrk_relation_id#','#temp_related_action_id#','#temp_related_action_table#','#temp_row_width#','#temp_row_depth#','#temp_row_height#','','#temp_row_project_id#','',0,'','','','','','','','','','','','','#SELECT_INFO_EXTRA#','#detail_info_extra#','','','','','','','','','','','','','','');
			</cfif>
		</cfoutput>
		//faturanın deposu ithal girisi cıkıs depoya atanıyor
			<cfif len(attributes.invoice_departmen) and len(attributes.invoice_location)>
				<cfset attributes.department_id=attributes.invoice_departmen>
				<cfset attributes.location_id=attributes.invoice_location>
				<cfinclude template="../query/get_location_for_orders.cfm">
				<cfoutput>
					opener.form_basket.department_id.value = '#attributes.invoice_departmen#';	
					opener.form_basket.location_id.value = '#attributes.invoice_location#';
					opener.form_basket.txt_departman_.value = '#GET_LOCATION.DEPARTMENT_HEAD#-#GET_LOCATION.COMMENT#';
				</cfoutput>
			</cfif>
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		window.close();
	</script>
</cfif>

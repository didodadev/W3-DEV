<cfparam name="attributes.employee" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.price_rec_date" default="">
<cfif len(attributes.price_rec_date)>
	<cf_date tarih='attributes.price_rec_date'>
</cfif>
<cfparam name="attributes.get_company_id" default="">
<cfparam name="attributes.get_company" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.date1" default="#dateformat(now(),dateformat_style)#" >
<cfparam name="attributes.date2" default="#dateformat(now(),dateformat_style)#" >
<cfif len(attributes.date2) and len(attributes.date1) >
	<cf_date tarih='attributes.date1'>
	<cf_date tarih='attributes.date2'>	
	<cfset attributes.date2=date_add("h",23,attributes.date2)>
	<cfset attributes.date2=date_add("n",59,attributes.date2)>
	<cfset attributes.date2=date_add("s",59,attributes.date2)>
</cfif>
<cfset kayit_sayisi_ = 0>
<cfset red = "red">
<cfset black = "black">
<cfset blue = "blue">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_product" method="post" action="">
			<input type="hidden" name="form_varmi" id="form_varmi" value="1">
			<cf_box_search>
				<div class="form-group" id="item-employee">
					<div class="input-group">
						<input type="hidden" maxlength="50" name="employee_id" id="employee_id"  value="<cfoutput>#attributes.employee_id#</cfoutput>">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57544.Sorumlu'></cfsavecontent>
						<cfinput type="text" name="employee"  value="#attributes.employee#" maxlength="50" placeholder="#message#">
						<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=search_product.employee_id&field_name=search_product.employee&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.search_product.employee.value),'list');"></span>
					</div>
				</div>
				<div class="form-group" id="item-get_company">
					<div class="input-group">
						<input type="hidden" maxlength="50" name="get_company_id" id="get_company_id" value="<cfif not isdefined("attributes.allproducts")><cfoutput>#attributes.get_company_id#</cfoutput></cfif>">
						<cfif not isdefined("attributes.allproducts")>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='29533.Tedarikçi'></cfsavecontent>
							<cfinput type="text" name="get_company" id="get_company"  value="#attributes.get_company#" maxlength="50" placeholder="#message#">
							<cfelse>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='29533.Tedarikçi'></cfsavecontent>
								<cfinput type="text" name="get_company" id="get_company"  value="" maxlength="50" placeholder="#message#">
						</cfif>
						<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=search_product.get_company&field_comp_id=search_product.get_company_id&select_list=2,3&keyword='+encodeURIComponent(document.search_product.get_company.value),'list');"></span>
					</div>
				</div>
				<div class="form-group" id="item-product_name">
					<div class="input-group">
						<input type="hidden" maxlength="50" name="product_id" id="product_id" <cfif len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57657.Ürün'></cfsavecontent>
						<cfinput type="text" name="product_name" id="product_name"  value="#attributes.product_name#" maxlength="50" placeholder="#message#">
						<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=search_product.product_id&field_name=search_product.product_name','list');"></span>
					</div>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="input_control2()">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-date1">
						<label class="col col-12"><cf_get_lang dictionary_id='37628.Fiyat Başlama Tarihi'>*</label>
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='37822.Fiyat Başlama Tarihi Zorunludur'></cfsavecontent>
								<cfinput value="#dateformat(attributes.date1,dateformat_style)#" maxlength="10" type="text" name="date1" style="width:65px;" required="yes" message="#alert#" validate="#validate_style#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-date2">
						<label class="col col-12"><cf_get_lang dictionary_id='37629.Fiyat Bitiş Tarihi'>*</label>
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='37823.Fiyat Bitiş Tarihi Zorunludur'></cfsavecontent>
								<cfinput value="#dateformat(attributes.date2,dateformat_style)#" maxlength="10" type="text" name="date2" style="width:65px;" required="yes" message="#alert#" validate="#validate_style#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-price_rec_date">
						<label class="col col-12"><cf_get_lang dictionary_id='37555.Fiyat Kayıt Tarihi'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='37630.Fiyat kayıt tarihinde hata'> !</cfsavecontent>
								<cfinput type="text" name="price_rec_date" value="#DateFormat(attributes.price_rec_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="price_rec_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-price_rec_date">
						<label class="col col-12"><cf_get_lang dictionary_id='37600.Standart Satış Fiyatı'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="checkbox" name="price_st_sale" id="price_st_sale" <cfif isdefined("attributes.price_st_sale")>checked</cfif>>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='37599.Ürün Maliyet ve Kar Marjları'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th><cf_get_lang dictionary_id='37374.Min Marj'></th>
					<th><cf_get_lang dictionary_id='37375.Max Marj'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='37631.Alış KDV'></th>
					<th><cf_get_lang dictionary_id='37632.Brüt Alış'> (<cf_get_lang dictionary_id='30024.KDV siz'>)</th>
					<th><cf_get_lang dictionary_id='57641.İsk'> 1</th>
					<th><cf_get_lang dictionary_id='57641.İsk'> 2</th>
					<th><cf_get_lang dictionary_id='57641.İsk'> 3</th>
					<th><cf_get_lang dictionary_id='57641.İsk'> 4</th>
					<th><cf_get_lang dictionary_id='57641.İsk'> 5</th>
					<th><cf_get_lang dictionary_id='37633.Net Alış'> (<cf_get_lang dictionary_id='30024.KDV siz'>)</th>
					<th><cf_get_lang dictionary_id='37042.Satış Fiyatı'> (<cf_get_lang dictionary_id='58716.KDV li'>)</th>
					<th><cf_get_lang dictionary_id='37634.Satış Marjı'> (<cf_get_lang dictionary_id='30024.KDV siz'>)</th>
					<th><cf_get_lang dictionary_id='57448.Satış'><cf_get_lang dictionary_id ='57639.KDV'></th>		  
				</tr>
			</thead>
			<tbody>
				<cfif IsDefined("attributes.form_varmi")>
				<cfquery name="GET_PRICE_STANDART_PURCHASE" datasource="#DSN3#">
					SELECT 
						PS.PRICE,
						PS.START_DATE,
						PS.PRODUCT_ID
					FROM 
						PRICE_STANDART PS,
						PRODUCT
					WHERE
						PS.PURCHASESALES = 0 AND
						PS.START_DATE <= #attributes.date2# AND
						PS.PRODUCT_ID = PRODUCT.PRODUCT_ID
						<cfif len(attributes.get_company) and len(attributes.get_company_id)>
						AND PRODUCT.COMPANY_ID = #attributes.get_company_id#
						</cfif>
						<cfif len(attributes.product_id) and len(attributes.product_name)>
						AND PRODUCT.PRODUCT_ID = #attributes.product_id#
						</cfif>
						<cfif len(attributes.employee) and len(attributes.employee_id)>
						AND PRODUCT.PRODUCT_MANAGER=#attributes.employee_id#
						</cfif>
					ORDER BY
						PS.START_DATE DESC
				</cfquery>
				<cfif isdefined("attributes.price_st_sale")>
					<cfquery name="GET_PRICE_STANDART_SALES" datasource="#DSN3#">
						SELECT 
							PRODUCT.PRODUCT_NAME,
							PRODUCT.COMPANY_ID,
							PRODUCT.MIN_MARGIN,
							PRODUCT.MAX_MARGIN,
							PRODUCT.TAX,
							PRODUCT.TAX_PURCHASE,
							PRODUCT.PRODUCT_ID,
							PS.PRICE_KDV,
							PS.PRICE,
							PS.START_DATE AS STARTDATE,
							NULL AS FINISHDATE,
							PS.PRODUCT_ID,
							'Standart Satış' AS PRICE_CAT
						FROM 
							PRICE_STANDART PS,
							PRODUCT
						WHERE
							PS.PURCHASESALES = 1 AND
							PS.START_DATE <= #attributes.date2# AND
							PS.PRODUCT_ID = PRODUCT.PRODUCT_ID
							<cfif len(attributes.get_company) and len(attributes.get_company_id)>
							AND PRODUCT.COMPANY_ID = #attributes.get_company_id#
							</cfif>
							<cfif len(attributes.product_id) and len(attributes.product_name)>
							AND PRODUCT.PRODUCT_ID = #attributes.product_id#
							</cfif>
							<cfif len(attributes.employee) and len(attributes.employee_id)>
							AND PRODUCT.PRODUCT_MANAGER=#attributes.employee_id#
							</cfif>
							<cfif len(attributes.price_rec_date)>
							AND PS.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.price_rec_date#">
							AND PS.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.price_rec_date)#">
							</cfif>
						ORDER BY
							STARTDATE DESC
					</cfquery>
				<cfelse>
					<cfquery name="GET_PRICE_PRICES" datasource="#DSN3#">
						SELECT 
							PRODUCT.PRODUCT_NAME,
							PRODUCT.COMPANY_ID,
							PRODUCT.MIN_MARGIN,
							PRODUCT.MAX_MARGIN,
							PRODUCT.TAX,
							PRODUCT.TAX_PURCHASE,
							PRICE.PRICE_KDV,
							PRICE.PRICE,
							PRICE.STARTDATE,
							PRICE.FINISHDATE,
							PRICE.PRODUCT_ID,
							PRICE_CAT.PRICE_CAT
						FROM 
							PRICE_HISTORY AS PRICE,
							PRICE_CAT,
							PRODUCT
						WHERE
							PRICE.STARTDATE <= #attributes.date2# AND
							PRICE.PRICE_CATID = PRICE_CAT.PRICE_CATID AND
							PRICE.PRODUCT_ID = PRODUCT.PRODUCT_ID
							<cfif len(attributes.get_company) and len(attributes.get_company_id)>
							AND PRODUCT.COMPANY_ID = #attributes.get_company_id#
							</cfif>
							<cfif len(attributes.product_id) and len(attributes.product_name)>
							AND PRODUCT.PRODUCT_ID = #attributes.product_id#
							</cfif>
							<cfif len(attributes.employee) and len(attributes.employee_id)>
							AND PRODUCT.PRODUCT_MANAGER=#attributes.employee_id#
							</cfif>
							<cfif len(attributes.price_rec_date)>
							AND PRICE.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.price_rec_date#">
							AND PRICE.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.price_rec_date)#">
							</cfif>
						ORDER BY
							PRODUCT.PRODUCT_NAME
					</cfquery>						
				</cfif>						
				<cfquery name="get_catalog_promotions" datasource="#dsn3#">
					SELECT
						CPP.DISCOUNT1,
						CPP.DISCOUNT2,
						CPP.DISCOUNT3,
						CPP.DISCOUNT4,
						CPP.DISCOUNT5,
						CPP.PRODUCT_ID,
						CP.KONDUSYON_DATE AS STARTDATE,
						CP.KONDUSYON_FINISH_DATE AS FINISHDATE,
						CP.CATALOG_ID
					FROM
						CATALOG_PROMOTION AS CP,
						CATALOG_PROMOTION_PRODUCTS AS CPP,
						PRODUCT
					WHERE
						CP.KONDUSYON_DATE <= #attributes.date2# AND
						CPP.CATALOG_ID = CP.CATALOG_ID AND
						CPP.PRODUCT_ID = PRODUCT.PRODUCT_ID
						<cfif len(attributes.get_company) and len(attributes.get_company_id)>
						AND PRODUCT.COMPANY_ID = #attributes.get_company_id#
						</cfif>
						<cfif len(attributes.product_id) and len(attributes.product_name)>
						AND CPP.PRODUCT_ID = #attributes.product_id#
						</cfif>
						<cfif len(attributes.employee) and len(attributes.employee_id)>
						AND PRODUCT.PRODUCT_MANAGER=#attributes.employee_id#
						</cfif>
					ORDER BY
						CP.CATALOG_ID DESC
				</cfquery>
				<cfquery name="get_conditions" datasource="#dsn3#">
					SELECT
						CPPD.DISCOUNT1,
						CPPD.DISCOUNT2,
						CPPD.DISCOUNT3,
						CPPD.DISCOUNT4,
						CPPD.DISCOUNT5,
						CPPD.PRODUCT_ID,
						CPPD.START_DATE,
						CPPD.FINISH_DATE,
						CPPD.C_P_PROD_DISCOUNT_ID,
						CPPD.COMPANY_ID
					FROM
						CONTRACT_PURCHASE_PROD_DISCOUNT CPPD,
						PRODUCT
					WHERE
						CPPD.START_DATE <= #attributes.date2# AND
						CPPD.C_P_PROD_DISCOUNT_ID IS NOT NULL AND
						CPPD.PRODUCT_ID = PRODUCT.PRODUCT_ID
						<cfif len(attributes.get_company) and len(attributes.get_company_id)>
						AND PRODUCT.COMPANY_ID = #attributes.get_company_id#
						</cfif>
						<cfif len(attributes.product_id) and len(attributes.product_name)>
						AND PRODUCT.PRODUCT_ID = #attributes.product_id#
						</cfif>
						<cfif len(attributes.employee) and len(attributes.employee_id)>
						AND PRODUCT.PRODUCT_MANAGER=#attributes.employee_id#
						</cfif>
					ORDER BY
						CPPD.C_P_PROD_DISCOUNT_ID DESC
				</cfquery>
				
				<cfloop from="1" to="#datediff('d',attributes.date1,attributes.date2)+1#" index="i">
					<cfset thedate = date_add('d',i-1,attributes.date1)>
					<cfset thedate_plus1 = date_add('d',i,attributes.date1)>
					<cfquery name="GET_PRICE_STANDART_PURCHASE_THEDATE_1" dbtype="query">
						SELECT 
							PRICE AS PURC_PRICE,PRODUCT_ID
						FROM 
							GET_PRICE_STANDART_PURCHASE 
						WHERE 
							START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#thedate_plus1#"> AND
							START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#thedate#">
					</cfquery>
					<cfquery name="GET_PRICE_STANDART_PURCHASE_THEDATE_2A" dbtype="query">
						SELECT 
							PRODUCT_ID, MAX(START_DATE) AS MAX_REC_DATE
						FROM 
							GET_PRICE_STANDART_PURCHASE 
						WHERE 
							START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#thedate_plus1#">
						GROUP BY
							PRODUCT_ID
					</cfquery>
					<cfquery name="GET_PRICE_STANDART_PURCHASE_THEDATE_2B" dbtype="query">
						SELECT 
							GET_PRICE_STANDART_PURCHASE.PRICE AS PURC_PRICE,
							GET_PRICE_STANDART_PURCHASE_THEDATE_2A.PRODUCT_ID AS PRODUCT_ID
						FROM 
							GET_PRICE_STANDART_PURCHASE,
							GET_PRICE_STANDART_PURCHASE_THEDATE_2A 
						WHERE 
							GET_PRICE_STANDART_PURCHASE.PRODUCT_ID = GET_PRICE_STANDART_PURCHASE_THEDATE_2A.PRODUCT_ID AND
							GET_PRICE_STANDART_PURCHASE.START_DATE = GET_PRICE_STANDART_PURCHASE_THEDATE_2A.MAX_REC_DATE 
					</cfquery>
					<cfquery name="GET_PRICE_STANDART_PURCHASE_THEDATE" dbtype="query">
						SELECT * FROM GET_PRICE_STANDART_PURCHASE_THEDATE_1
						
						UNION
					
						SELECT * FROM GET_PRICE_STANDART_PURCHASE_THEDATE_2B
					</cfquery>
						<cfif isdefined("attributes.price_st_sale")>
						<!--- STANDART SATIŞLAR ALINIYOR --->
							<cfquery name="GET_PRICE_STANDART_SALES_THEDATE_1" dbtype="query">
								SELECT 
									PRICE,PRICE_KDV,FINISHDATE,PRICE_CAT,STARTDATE,
									PRODUCT_NAME,
									COMPANY_ID,
									MIN_MARGIN,
									MAX_MARGIN,
									TAX,
									TAX_PURCHASE,
									PRODUCT_ID
								FROM 
									GET_PRICE_STANDART_SALES 
								WHERE 
									STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#thedate_plus1#"> AND
									STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#thedate#">
								</cfquery>
								<cfquery name="GET_PRICE_STANDART_SALES_THEDATE_2A" dbtype="query">
									SELECT 
										PRODUCT_ID, MAX(STARTDATE) AS STARTDATE
									FROM 
										GET_PRICE_STANDART_SALES 
									WHERE 
										STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#thedate_plus1#">
									GROUP BY
										PRODUCT_ID
								</cfquery>
								<cfquery name="GET_PRICE_STANDART_SALES_THEDATE_2B" dbtype="query">
									SELECT 
										GET_PRICE_STANDART_SALES.PRICE,
										GET_PRICE_STANDART_SALES.PRICE_KDV,
										GET_PRICE_STANDART_SALES.FINISHDATE,
										GET_PRICE_STANDART_SALES.PRICE_CAT,
										GET_PRICE_STANDART_SALES.STARTDATE,
										GET_PRICE_STANDART_SALES.PRODUCT_NAME,
										GET_PRICE_STANDART_SALES.COMPANY_ID,
										GET_PRICE_STANDART_SALES.MIN_MARGIN,
										GET_PRICE_STANDART_SALES.MAX_MARGIN,
										GET_PRICE_STANDART_SALES.TAX,
										GET_PRICE_STANDART_SALES.TAX_PURCHASE,
										GET_PRICE_STANDART_SALES_THEDATE_2A.PRODUCT_ID AS PRODUCT_ID
									FROM 
										GET_PRICE_STANDART_SALES,
										GET_PRICE_STANDART_SALES_THEDATE_2A 
									WHERE 
										GET_PRICE_STANDART_SALES.PRODUCT_ID = GET_PRICE_STANDART_SALES_THEDATE_2A.PRODUCT_ID AND
										GET_PRICE_STANDART_SALES.STARTDATE = GET_PRICE_STANDART_SALES_THEDATE_2A.STARTDATE 
								</cfquery>
								<cfquery name="GET_PRICE_PRICES_THEDATE" dbtype="query">
									SELECT * FROM GET_PRICE_STANDART_SALES_THEDATE_1
								
									UNION
								
									SELECT * FROM GET_PRICE_STANDART_SALES_THEDATE_2B
								</cfquery>
							<cfelse>
								<cfquery name="GET_PRICE_PRICES_THEDATE" dbtype="query">
									SELECT 
										*
									FROM 
										GET_PRICE_PRICES 
									WHERE 
										STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#thedate#"> AND
										(FINISHDATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#thedate#"> OR FINISHDATE IS NULL)
								</cfquery>
							</cfif>
								<cfquery dbtype="query" name="join_number_2">
								SELECT
									GET_PRICE_PRICES_THEDATE.PRICE_CAT,
									GET_PRICE_PRICES_THEDATE.PRODUCT_NAME,
									GET_PRICE_PRICES_THEDATE.PRODUCT_ID,
									GET_PRICE_PRICES_THEDATE.PRICE_KDV,
									GET_PRICE_PRICES_THEDATE.PRICE,
									GET_PRICE_PRICES_THEDATE.MIN_MARGIN,
									GET_PRICE_PRICES_THEDATE.MAX_MARGIN,
									GET_PRICE_PRICES_THEDATE.TAX,
									GET_PRICE_PRICES_THEDATE.TAX_PURCHASE,
									GET_PRICE_STANDART_PURCHASE_THEDATE.PURC_PRICE
								FROM
									GET_PRICE_PRICES_THEDATE,
									GET_PRICE_STANDART_PURCHASE_THEDATE
								WHERE
									GET_PRICE_PRICES_THEDATE.PRODUCT_ID = GET_PRICE_STANDART_PURCHASE_THEDATE.PRODUCT_ID
								ORDER BY
									GET_PRICE_PRICES_THEDATE.PRODUCT_NAME,
									GET_PRICE_PRICES_THEDATE.PRICE_CAT
							</cfquery>
								<cfoutput query="join_number_2">
								<cfset tarih_odbc = thedate>
								<!--- <cf_date tarih="tarih_odbc"> --->
								<cfscript>
								d1 = 0;
								d2 = 0;
								d3 = 0;
								d4 = 0;
								d5 = 0;
								</cfscript>
								<cfquery name="GET_AKSIYON_THEDATE" dbtype="query" maxrows="1">
									SELECT 
										DISCOUNT1,
										DISCOUNT2,
										DISCOUNT3,
										DISCOUNT4,
										DISCOUNT5
									FROM 
										get_catalog_promotions 
									WHERE 
										STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#tarih_odbc#"> AND
										(FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#tarih_odbc#"> OR FINISHDATE IS NULL) AND
										PRODUCT_ID = #PRODUCT_ID#					
									ORDER BY
										CATALOG_ID DESC
								</cfquery>
								<cfif GET_AKSIYON_THEDATE.RecordCount>
									<cfscript>
										if (len(GET_AKSIYON_THEDATE.DISCOUNT1)) d1 = GET_AKSIYON_THEDATE.DISCOUNT1;
										if (len(GET_AKSIYON_THEDATE.DISCOUNT2)) d2 = GET_AKSIYON_THEDATE.DISCOUNT2;
										if (len(GET_AKSIYON_THEDATE.DISCOUNT3)) d3 = GET_AKSIYON_THEDATE.DISCOUNT3;
										if (len(GET_AKSIYON_THEDATE.DISCOUNT4)) d4 = GET_AKSIYON_THEDATE.DISCOUNT4;
										if (len(GET_AKSIYON_THEDATE.DISCOUNT5)) d5 = GET_AKSIYON_THEDATE.DISCOUNT5;
									</cfscript>
								</cfif>
								<cfif not GET_AKSIYON_THEDATE.RecordCount>
									<cfquery name="GET_CONDITION_THEDATE_1" dbtype="query" maxrows="1">
										SELECT 
											DISCOUNT1,
											DISCOUNT2,
											DISCOUNT3,
											DISCOUNT4,
											DISCOUNT5
										FROM 
											get_conditions 
										WHERE 
											START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#tarih_odbc#"> AND
											(FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#tarih_odbc#"> OR FINISH_DATE IS NULL) AND
											PRODUCT_ID = #PRODUCT_ID# 
											<cfif len(attributes.get_company) and len(attributes.get_company_id)>
											AND COMPANY_ID = #attributes.get_company_id#
											</cfif>
										ORDER BY
											C_P_PROD_DISCOUNT_ID DESC
									</cfquery>
									<cfif GET_CONDITION_THEDATE_1.RecordCount>
										<cfscript>
											if (len(GET_CONDITION_THEDATE_1.DISCOUNT1)) d1 = GET_CONDITION_THEDATE_1.DISCOUNT1;
											if (len(GET_CONDITION_THEDATE_1.DISCOUNT2)) d2 = GET_CONDITION_THEDATE_1.DISCOUNT2;
											if (len(GET_CONDITION_THEDATE_1.DISCOUNT3)) d3 = GET_CONDITION_THEDATE_1.DISCOUNT3;
											if (len(GET_CONDITION_THEDATE_1.DISCOUNT4)) d4 = GET_CONDITION_THEDATE_1.DISCOUNT4;
											if (len(GET_CONDITION_THEDATE_1.DISCOUNT5)) d5 = GET_CONDITION_THEDATE_1.DISCOUNT5;
										</cfscript>
									</cfif>
									<cfif not GET_CONDITION_THEDATE_1.RecordCount and len(attributes.get_company) and len(attributes.get_company_id)>
										<cfquery name="GET_CONDITION_THEDATE_2" dbtype="query" maxrows="1">
											SELECT 
												DISCOUNT1,DISCOUNT2,DISCOUNT3,DISCOUNT4,DISCOUNT5
											FROM 
												get_conditions 
											WHERE 
												START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#tarih_odbc#"> AND
												(FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#tarih_odbc#"> OR FINISH_DATE IS NULL) AND
												PRODUCT_ID = #PRODUCT_ID# 
											ORDER BY
												C_P_PROD_DISCOUNT_ID DESC
										</cfquery>
										<cfif GET_CONDITION_THEDATE_2.RecordCount>
										<cfscript>
											if (len(GET_CONDITION_THEDATE_2.DISCOUNT1)) d1 = GET_CONDITION_THEDATE_2.DISCOUNT1;
											if (len(GET_CONDITION_THEDATE_2.DISCOUNT2)) d2 = GET_CONDITION_THEDATE_2.DISCOUNT2;
											if (len(GET_CONDITION_THEDATE_2.DISCOUNT3)) d3 = GET_CONDITION_THEDATE_2.DISCOUNT3;
											if (len(GET_CONDITION_THEDATE_2.DISCOUNT4)) d4 = GET_CONDITION_THEDATE_2.DISCOUNT4;
											if (len(GET_CONDITION_THEDATE_2.DISCOUNT5)) d5 = GET_CONDITION_THEDATE_2.DISCOUNT5;
										</cfscript>
									</cfif>
								</cfif>
							</cfif>
							<cfset net_purc_price = PURC_PRICE*((100-d1)/100)*((100-d2)/100)*((100-d3)/100)*((100-d4)/100)*((100-d5)/100)>
							<cfif net_purc_price>
								<cfset raf_marj = 100 * ((PRICE - net_purc_price) / net_purc_price)>
							<cfelse>
								<cfset raf_marj = 0>
							</cfif>
						<cfif raf_marj lt MIN_MARGIN or raf_marj gt MAX_MARGIN>
							<cfset kayit_sayisi_ = kayit_sayisi_ + 1>
							<tr>
								<td>#currentrow#</td>
								<td>#dateformat(thedate,dateformat_style)#</td>
								<td>#PRODUCT_NAME#</td>
								<td>#MIN_MARGIN#</td>
								<td>#MAX_MARGIN#</td>
								<td>#PRICE_CAT#</td>
								<td>#TAX_PURCHASE#</td>
								<td style="text-align:right;">#TLFormat(PURC_PRICE,4)#</td>			  
								<td style="text-align:right;">#TLFormat(d1)#</td>
								<td style="text-align:right;">#TLFormat(d2)#</td>
								<td style="text-align:right;">#TLFormat(d3)#</td>
								<td style="text-align:right;">#TLFormat(d4)#</td>
								<td style="text-align:right;">#TLFormat(d5)#</td>
								<td style="text-align:right;">#TLFormat(net_purc_price,4)#</td>
								<td style="text-align:right;">#TLFormat(PRICE_KDV)#</td>
								<td style="color:#iif(raf_marj lt MIN_MARGIN,red,blue)#">#TLFormat(raf_marj)#</td>
								<td>#TAX#</td>
							</tr>
						</cfif>
						</cfoutput>
					</cfloop>		
					<cfif kayit_sayisi_ eq 0>
						<tr>
							<td colspan="21"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
						</tr>
					</cfif>
				<cfelse>
					<tr>
						<td colspan="21"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>
<script type="text/javascript">
	function input_control2()
	{
		if ( (search_product.product_id.value == '' || search_product.product_name.value == '') && (search_product.get_company_id.value == '' || search_product.get_company.value == '') &&  (search_product.employee_id.value == '' || search_product.employee.value == '') && (search_product.price_rec_date.value == '') )
		{
			alert("<cf_get_lang dictionary_id='58950.En az bir alanda filtre etmelisiniz'>!");
			return false;
		}
		return true;
	}
</script>

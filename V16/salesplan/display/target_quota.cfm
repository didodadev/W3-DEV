<cfquery name="get_sales_quota_row" datasource="#DSN3#">
	SELECT 
		PLAN_DATE,
		FINISH_DATE,
        PERIOD_TYPE,
        TEAM_ID,
		EMPLOYEE_ID,
		SUPPLIER_ID,
		MULTI_CATEGORY_ID,
		CATEGORY_ID,
		PRODUCT_ID,
		BRAND_ID,
		STOCK_ID,
		QUANTITY,
		ROW_TOTAL,
		ROW_OTHER_TOTAL,
		ROW_PREMIUM_PERCENT,
		ROW_PREMIUM_TOTAL,
		OTHER_MONEY,
		PRODUCT_NAME,
		IS_RETURNS,
		IS_PURCHASE_DISCOUNTS,
		IS_ACTION_DISCOUNTS,
		IS_TOTAL_INSIDE_DISCOUNTS
	FROM
		SALES_QUOTAS,
		SALES_QUOTAS_ROW 
	WHERE 
		SALES_QUOTAS.SALES_QUOTA_ID = SALES_QUOTAS_ROW.SALES_QUOTA_ID AND 
		SALES_QUOTAS.SALES_QUOTA_ID = #attributes.q_id#
</cfquery>
<cfset category_list = "">
<cfset brand_list = "">
<cfset company_list = "">
<cfset product_list = "">
<cfoutput query="get_sales_quota_row">
	<cfif len(category_id) and not listfind(category_list,category_id)>
		<cfset category_list = listappend(category_list,category_id)>
	<cfelseif len(multi_category_id) and not listfind(category_list,multi_category_id)>
		<cfset category_list = listappend(category_list,multi_category_id)>
	</cfif>
	<cfif len(brand_id) and not listfind(brand_list,brand_id)>
		<cfset brand_list = listappend(brand_list,brand_id)>
	</cfif>
	<cfif len(supplier_id) and not listfind(company_list,supplier_id)>
		<cfset company_list = listappend(company_list,supplier_id)>
	</cfif>
	<cfif len(product_id) and not listfind(product_list,product_id)>
		<cfset product_list = listappend(product_list,product_id)>
	</cfif>
</cfoutput>
<cfif listlen(category_list)>
	<cfset category_list=listsort(category_list,"numeric","ASC",',')>
	<cfquery name="get_category" datasource="#dsn3#">
		SELECT PRODUCT_CAT, PRODUCT_CATID,HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID IN (#ListDeleteDuplicates(category_list)#) ORDER BY PRODUCT_CATID
	</cfquery>
	<cfset main_category_list = listsort(listdeleteduplicates(valuelist(get_category.product_catid,',')),'numeric','ASC',',')>
</cfif>
<cfif listlen(brand_list)>
	<cfset brand_list=listsort(brand_list,"numeric","ASC",',')>
	<cfquery name="get_brand" datasource="#dsn3#">
		SELECT BRAND_ID, BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID IN (#brand_list#) ORDER BY BRAND_ID
	</cfquery>
	<cfset main_brand_list = listsort(listdeleteduplicates(valuelist(get_brand.brand_id,',')),'numeric','ASC',',')>
</cfif>
<cfif listlen(company_list)>
	<cfset company_list=listsort(company_list,"numeric","ASC",',')>
	<cfquery name="get_company" datasource="#dsn#">
		SELECT FULLNAME, COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN (#company_list#) ORDER BY COMPANY_ID
	</cfquery>
	<cfset main_company_list = listsort(listdeleteduplicates(valuelist(get_company.company_id,',')),'numeric','ASC',',')>
</cfif>
<cfif listlen(product_list)>
	<cfset product_list=listsort(product_list,"numeric","ASC",',')>
	<cfquery name="get_product" datasource="#dsn3#">
		SELECT PRODUCT_NAME, PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID IN (#product_list#) ORDER BY PRODUCT_ID
	</cfquery>
	<cfset main_product_list = listsort(listdeleteduplicates(valuelist(get_product.product_id,',')),'numeric','ASC',',')>
</cfif>
<cf_box title="#getLang('salesplan','Kota Karşılaştırma Raporu',41629)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>
		<thead>
			<tr>
				<th width="20"></th>
				<th width="20%" class="text-center" colspan="3"><cf_get_lang dictionary_id='58869.Planlanan'></th>
				<th width="50%" class="text-center" colspan="<cfif attributes.purchase_sales neq 1>10<cfelse>3</cfif>"><cf_get_lang dictionary_id ='55688.Gerçekleşen'></th>
			</tr>
			<tr>
				<th><cf_get_lang dictionary_id ='57630.Tip'></th>
				<th class="text-right"><cf_get_lang dictionary_id ='57635.Miktar'></th>
				<th class="text-right"><cf_get_lang dictionary_id ='57673.Tutar'> <cfoutput>#session.ep.money#</cfoutput></th>
				<th class="text-right"><cf_get_lang dictionary_id ='41631.Tutar Döviz'></th>
				<th class="text-right"><cf_get_lang dictionary_id ='57635.Miktar'></th>
				<th class="text-right"><cf_get_lang dictionary_id ='57673.Tutar'><cfoutput>#session.ep.money#</cfoutput></th>
				<th class="text-right"><cf_get_lang dictionary_id ='41631.Tutar Döviz'></th>
				<cfif attributes.purchase_sales neq 1>
					<th class="text-right"><cf_get_lang dictionary_id='55776.Prim'> %</th>
					<th class="text-right"><cf_get_lang dictionary_id='55776.Prim'> <cf_get_lang dictionary_id='57673.Tutar'></th>
					<th class="text-right"><cf_get_lang dictionary_id='50335.İade'> <cf_get_lang dictionary_id='57635.Miktar'></th>
					<th class="text-right"><cf_get_lang dictionary_id='50335.İade'> <cf_get_lang dictionary_id='57673.Tutar'></th>
					<th class="text-right"><cf_get_lang dictionary_id='58083.Net'> <cf_get_lang dictionary_id='57635.Miktar'></th>
					<th class="text-right"><cf_get_lang dictionary_id='58083.Net'> <cf_get_lang dictionary_id='57673.Tutar'></th>
					<th class="text-right"><cf_get_lang dictionary_id='58083.Net'> <cf_get_lang dictionary_id='48246.Prim Tutar'></th>
				</cfif>
			</tr>
		</thead>
		<tbody>
			<cfset Other_Money_List = "">
			<cfset Main_Cat_List = "">
			<cfquery name="Get_Money" datasource="#dsn#">
				SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id#
			</cfquery>
			<cfset Main_Product_Code_ = "">
			<cfoutput query="get_sales_quota_row">
				<!--- XmlDen Ana Kategorilerin Alt Kirilimlari Da Hesaplansin Secilirse Bunların Kodlari Alinip Asagida % Olarak Cekiliyor  --->
				<cfif isDefined("attributes.sub_category") and Len(attributes.sub_category) and attributes.sub_category eq 1>
					<cfif Len(Category_Id)>
						<cfset Category_List = Category_Id>
					<cfelseif Len(Multi_Category_Id)>
						<cfset Category_List = Multi_Category_Id>
					</cfif>
					<cfif isDefined("Category_List") and Len(Category_List)>
						<cfquery name="Get_Product_Code" datasource="#dsn3#">
							SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID IN (#ListDeleteDuplicates(category_list)#)
						</cfquery>
						<cfset Main_Cat_List = ListSort(ListDeleteDuplicates(ValueList(Get_Product_Code.Hierarchy,',')),'text','asc',',')>
					</cfif>
				</cfif>
				<cfloop query="Get_Money">
					<cfset General_Total_Amount_ = 0>
					<cfset 'General_Total_Value_#Money#' = 0>
					<cfset 'General_Other_Total_Value_#Money#' = 0>
					<cfset General_Total_Amount_Return_ = 0>
					<cfset 'General_Total_Value_Return_#Money#' = 0>
					<cfset 'General_Other_Total_Value_Return_#Money#' = 0>
				</cfloop>
				
				<cfset Last_Total_Amount = 0>
				<cfset Last_Total_Value = 0>
				<cfset Last_Other_Total_Value = 0>
				<cfset Last_Total_Amount_Return = 0>
				<cfset Last_Total_Value_Return = 0>
				<cfset Last_Other_Total_Value_Return = 0>
				
				<cfset Prim_Total = 0>
				<cfset Prim_Net_Total = 0>
				<cfset Row_Total_ = 0>
				<cfset Amount_Total = 0>
				<cfset Total_Amount_Return_ = 0>
				<cfset Total_Value_Return_ = 0>
				
				<cfset Cat_CurrentRow = 0>
                
                <cfif x_period_type eq 1>
                	<cfif period_type eq 0>
                    	<cfset plan_date1 = createdate(year(now()),1,1)>
						<cfset finish_date1 = createdate(year(now()),3,31)>
                    <cfelseif period_type eq 1>
                    	<cfset plan_date1 = createdate(year(now()),4,1)>
						<cfset finish_date1 = createdate(year(now()),6,30)>
                    <cfelseif period_type eq 2>
                    	<cfset plan_date1 = createdate(year(now()),7,1)>
						<cfset finish_date1 = createdate(year(now()),9,30)>
                    <cfelseif period_type eq 3>
                    	<cfset plan_date1 = createdate(year(now()),10,1)>
						<cfset finish_date1 = createdate(year(now()),12,31)>
                    </cfif>
                <cfelse>
                	<cfset plan_date1 = plan_date>
					<cfset finish_date1 = finish_date>
                </cfif>
                
				<cfquery name="Get_Related_Invoice" datasource="#dsn2#">
					SELECT 
						SUM(TOTAL_AMOUNT_RETURN) TOTAL_AMOUNT_RETURN,
						SUM(TOTAL_VALUE_RETURN) TOTAL_VALUE_RETURN,
						SUM(OTHER_TOTAL_VALUE_RETURN) OTHER_TOTAL_VALUE_RETURN,
						SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
						SUM(TOTAL_VALUE) TOTAL_VALUE,
						SUM(OTHER_TOTAL_VALUE) OTHER_TOTAL_VALUE,
						<cfif attributes.purchase_sales neq 1>
							PRODUCT_ID,
							UNIT,
							INVOICE_DATE,
						</cfif>
						OTHER_MONEY
					FROM
					(
						SELECT
							<cfif attributes.purchase_sales eq 1>
								0 AS TOTAL_AMOUNT_RETURN,
								0 AS TOTAL_VALUE_RETURN,
								0 AS OTHER_TOTAL_VALUE_RETURN,
								
								CASE WHEN I.INVOICE_CAT IN(54,49,51,63) THEN -1*IR.AMOUNT ELSE IR.AMOUNT END AS TOTAL_AMOUNT,
								CASE WHEN INVOICE_CAT IN(54,49,51,63) THEN -1*((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL) ELSE ((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL) END AS TOTAL_VALUE,
								CASE WHEN INVOICE_CAT IN(54,49,51,63) THEN -1*(((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)/(INV_M.RATE2/INV_M.RATE1)) ELSE (((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)/(INV_M.RATE2/INV_M.RATE1)) END AS OTHER_TOTAL_VALUE,
							<cfelse>
								CASE WHEN INVOICE_CAT IN (62) THEN IR.AMOUNT ELSE 0 END AS TOTAL_AMOUNT_RETURN,
								CASE WHEN INVOICE_CAT IN (62) THEN (IR.AMOUNT*IR.PRICE) ELSE 0 END AS TOTAL_VALUE_RETURN,
								CASE WHEN INVOICE_CAT IN (62) THEN ((IR.AMOUNT*IR.PRICE)/INV_M.RATE2) ELSE 0 END AS OTHER_TOTAL_VALUE_RETURN,
							
								CASE WHEN INVOICE_CAT NOT IN (48,58,62) THEN IR.AMOUNT ELSE 0 END AS TOTAL_AMOUNT,
								CASE WHEN INVOICE_CAT NOT IN (48,58,62) THEN (IR.AMOUNT*IR.PRICE) ELSE 0 END AS TOTAL_VALUE,
								CASE WHEN INVOICE_CAT NOT IN (48,58,62) THEN ((IR.AMOUNT*IR.PRICE)/INV_M.RATE2) ELSE 0 END AS OTHER_TOTAL_VALUE,
								IR.PRODUCT_ID,
								IR.UNIT,
								I.INVOICE_DATE,
							</cfif>
							IR.OTHER_MONEY
						FROM 
							INVOICE I,
							INVOICE_ROW IR,
							#dsn3_alias#.PRODUCT P,
							INVOICE_MONEY INV_M
						WHERE 
							IR.PRODUCT_ID = P.PRODUCT_ID AND
							I.INVOICE_ID = IR.INVOICE_ID AND
							IR.INVOICE_ID = INV_M.ACTION_ID AND 
							INV_M.MONEY_TYPE = IR.OTHER_MONEY AND
							I.NETTOTAL > 0 AND
							I.IS_IPTAL = 0 AND
							I.INVOICE_DATE BETWEEN #CreateODBCDateTime(plan_date1)# AND #CreateODBCDateTime(Finish_Date1)# AND 
							<cfif len(Supplier_Id)>
								I.COMPANY_ID = #Supplier_Id# AND
							</cfif>
							<cfif Len(Main_Cat_List)><!--- Yukarida Xml e Bagli Islem Gerceklestirilirse Burada Sonuc Donuyor --->
							(	<cfloop list="#Main_Cat_List#" index="MCL" delimiters=",">
									(P.PRODUCT_CODE LIKE '#MCL#' OR P.PRODUCT_CODE LIKE '#MCL#.%') <cfif ListLast(Main_Cat_List) neq MCL> OR </cfif>
								</cfloop>
							) AND
							<cfelse>
								<cfif len(Category_Id)>
									P.PRODUCT_CATID = #Category_Id# AND
								<cfelseif len(Multi_Category_Id)><!--- Coklu kategori girisi Xml --->
									P.PRODUCT_CATID IN (#Multi_Category_Id#) AND
								</cfif>
							</cfif>
							<cfif len(Product_Id)>
								P.PRODUCT_ID = #Product_Id# AND
							</cfif>
							<cfif len(Brand_Id)>
								P.BRAND_ID = #Brand_Id# AND
							</cfif>
                            <cfif x_period_type eq 0>
                            	<cfif len(employee_id)>
                                	SALE_EMP = #EMPLOYEE_ID# AND
								<cfelseif len(team_id)>
                                	SALES_TEAM_ID = #TEAM_ID# AND
                                </cfif>
                            </cfif>
							<cfif attributes.purchase_sales eq 1>
								I.INVOICE_CAT IN (50,52,53,531,58,561,54,55,51,63,48,49)
							<cfelse>
								(I.PURCHASE_SALES = #attributes.purchase_sales# OR I.INVOICE_CAT IN (48,58,62))
							</cfif>
						)T1 
					GROUP BY
						<cfif attributes.purchase_sales neq 1>
							PRODUCT_ID,
							UNIT,
							INVOICE_DATE,
						</cfif>
						OTHER_MONEY
				</cfquery>
				<cfif Get_Related_Invoice.RecordCount>
					<cfset Only_Disc_1 = 0>
					<cfset Only_Disc_2 = 0>
					<cfloop query="Get_Related_Invoice">
						<cfset Net_Total_Value_ = 0>
						<cfset Total_Value_ = 0>
						<cfset Total_Amount_= 0>
						<cfif Len(Other_Money) and not ListFind(Other_Money_List,Other_Money,',')>
							<cfset Other_Money_List = ListAppend(Other_Money_List,Other_Money,',')>
						</cfif>
						<cfset General_Total_Amount_ = General_Total_Amount_ + Get_Related_Invoice.Total_Amount>
						<cfset 'General_Total_Value_#Other_Money#' = Evaluate('General_Total_Value_#Other_Money#') + Get_Related_Invoice.Total_Value>
						<cfset 'General_Other_Total_Value_#Other_Money#' = Evaluate('General_Other_Total_Value_#Other_Money#') + Get_Related_Invoice.Other_Total_Value>
						<cfset General_Total_Amount_Return_ = General_Total_Amount_Return_ + Get_Related_Invoice.Total_Amount_Return>
						<cfset 'General_Total_Value_Return_#Other_Money#' = Evaluate('General_Total_Value_Return_#Other_Money#') + Get_Related_Invoice.Total_Value_Return>
						<cfset 'General_Other_Total_Value_Return_#Other_Money#' = Evaluate('General_Other_Total_Value_Return_#Other_Money#') + Get_Related_Invoice.Other_Total_Value_Return>
					</cfloop>
				</cfif>
				<cfif Get_Sales_Quota_Row.Is_Total_Inside_Discounts eq 1>
				<!--- Prim Yuzdesi Tutardan Indirimler Dusuldukten Sonra Hesaplansin --->
					<cfset Row_Total_ = Prim_Total>
				<cfelse>
					<cfset Row_Total_ = Prim_Net_Total>
				</cfif>
				<tr>
					<td>
						<cfif len(supplier_id)>
							Tedarikçi&nbsp;&nbsp;
							<font color="FFF0000">(#get_company.fullname[listfind(main_company_list,supplier_id,',')]#)</font><br/>
						</cfif>
						<cfif len(category_id)>
							Kategori&nbsp;&nbsp;
							<font color="FFF0000">(#get_category.product_cat[listfind(main_category_list,category_id,',')]#)</font><br/>
						<cfelseif Len(multi_category_id)>
							Kategori&nbsp;&nbsp;
							<font color="FFF0000">(
							<cfloop list="#Multi_Category_Id#" index="mc">
								#get_category.hierarchy[listfind(main_category_list,mc,',')]# - #get_category.product_cat[listfind(main_category_list,mc,',')]#
								<cfif ListLast(Multi_Category_Id) neq mc><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</cfif>
							</cfloop>
							)</font><br/>
						</cfif>
						<cfif len(brand_id)>
							Marka&nbsp;&nbsp;
							<font color="FFF0000">(#get_brand.brand_name[listfind(main_brand_list,brand_id,',')]#)</font><br/>
						</cfif>
						<cfif len(product_id)>
							Ürün&nbsp;&nbsp;
							<font color="FFF0000">(#get_product.product_name[listfind(main_product_list,product_id,',')]#)</font><br/>
						</cfif>
                        #dateformat(plan_date1,'#dateformat_style#')#-#dateformat(finish_date1,'#dateformat_style#')#
					</td>
					<td class="text-right">#TLFormat(Quantity)#</td>
					<td class="text-right">#tlformat(Row_Total,2)#</td>
					<td class="text-right">#tlformat(Row_Other_Total,2)# #Other_Money#</td>
					<cfif Get_Related_Invoice.recordcount>
						<td class="text-right">#TLFormat(General_Total_Amount_)#</td>
						<td class="text-right"><cfloop list="#Other_Money_List#" index="Om" delimiters=","><cfif Evaluate('General_Total_Value_#Om#') gt 0>#TLFormat(Evaluate('General_Total_Value_#Om#'))#<br/></cfif></cfloop></td>
						<td class="text-right"><cfloop list="#Other_Money_List#" index="Om" delimiters=","><cfif Evaluate('General_Other_Total_Value_#Om#') gt 0>#TLFormat(Evaluate('General_Other_Total_Value_#Om#'))# #Om#<br/></cfif></cfloop></td>
					<cfelse>
						<td class="text-right">#TLFormat(0)#</td>
						<td class="text-right">#TLFormat(0)#</td>
						<td class="text-right">#TLFormat(0)#</td>
					</cfif>
					<cfif attributes.purchase_sales neq 1>
						<td class="text-right">#Row_Premium_Percent#</td>
						<td class="text-right"><cfloop list="#Other_Money_List#" index="Om" delimiters=","><cfif Evaluate('General_Other_Total_Value_#Om#') gt 0>#TLFormat(Evaluate('General_Other_Total_Value_#Om#')*Row_Premium_Percent/100,2)# #Om#<br/></cfif></cfloop></td>
						<td class="text-right">#TLFormat(General_Total_Amount_Return_)#</td>
						<td class="text-right"><cfloop list="#Other_Money_List#" index="Om" delimiters=","><cfif Evaluate('General_Other_Total_Value_Return_#Om#') gt 0>#TLFormat(Evaluate('General_Other_Total_Value_Return_#Om#'))# #Om#<br/></cfif></cfloop></td>
						<td class="text-right">#TLFormat(General_Total_Amount_-General_Total_Amount_Return_)#</td>
						<td class="text-right"><cfloop list="#Other_Money_List#" index="Om" delimiters=","><cfif Evaluate('General_Total_Value_#Om#') gt 0>#TLFormat(Evaluate('General_Other_Total_Value_#Om#')-Evaluate('General_Other_Total_Value_Return_#Om#'))# #Om#<br/></cfif></cfloop></td>
						<td class="text-right"><cfloop list="#Other_Money_List#" index="Om" delimiters=","><cfif Evaluate('General_Other_Total_Value_#Om#') gt 0>#TLFormat(Evaluate('General_Other_Total_Value_#Om#')-Evaluate('General_Other_Total_Value_Return_#Om#')*Row_Premium_Percent/100,2)# #Om#<br/></cfif></cfloop></td>
					</cfif>
				</tr>
			</cfoutput>
		</tbody>
	</cf_grid_list>
</cf_box>

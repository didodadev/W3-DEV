<cfif attributes.fuseaction eq 'sales.form_add_opportunity'>
	<cf_xml_page_edit fuseact="sales.form_add_opportunity">
</cfif>
<!--- Uye Kategorileri Ayristiriliyor --->
<cfset Company_Member = "">
<cfset Consumer_Member = "">
<cfif ListLen(attributes.customer_cat_type)>
	<cfset Number_=ListLen(attributes.customer_cat_type)>
	<cfloop from="1" to="#Number_#" index="n">
		<cfset CatList = listgetat(attributes.customer_cat_type,n,',')>
		<cfif listlen(CatList) and listfirst(CatList,'-') eq 1>
			<cfset Company_Member = listappend(Company_Member,ListLast(CatList,'-'))>
		<cfelseif listlen(CatList) and listfirst(CatList,'-') eq 2>
			<cfset Consumer_Member = listappend(Consumer_Member,ListLast(CatList,'-'))>
		</cfif>
	</cfloop>
	<cfset Company_Member = ListSort(Company_Member,'numeric','asc',',')>
	<cfset Consumer_Member = ListSort(Consumer_Member,'numeric','asc',',')>
</cfif>
<!--- Detayli Satis Teklif Raporu Query --->
<cfquery name="get_detail_sale_offer" datasource="#dsn3#">
	SELECT 
		<cfif report_type eq 1>
			SUM(PRICE) AS SUM_PRICE,
            PROBABILITY,
			<cfif xml_net_maliyet eq 1>
			SUM(NET_MALIYET) AS NET_MALIYET,
			</cfif>
		<cfelse>
			QUANTITY,
			UNIT,
			ROW_MONEY_TYPE,
			PRODUCT_ID,
			PRODUCT_NAME,
			ROW_PRICE_OTHER,
			NET_MALIYET,
			PRICE,
			TAX,
			DISCOUNT_1,
			DISCOUNT_2,
			DISCOUNT_3,
			DISCOUNT_4,
			DISCOUNT_5,
			DISCOUNT_6,
			DISCOUNT_7,
			DISCOUNT_8,
			DISCOUNT_9,
			DISCOUNT_10,
			ROW_DISC_COST,
			EXTRA_PRICE_TOTAL,
			ROW_OTHER_MONEY,
			ROW_OTHER_MONEY_VALUE,
			ROW_PROVIDER_ID,
			OTHER_MONEY_RATE,
			OFFER_DETAIL,
			OPP_ID,
		</cfif>
		OFFER_NUMBER,
		OFFER_ID,
		REF_NO,
		CONSUMER_ID,
		PARTNER_ID,
		COMPANY_ID,		
		OFFER_TO_PARTNER,
		SALES_EMP_ID,
		SALES_PARTNER_ID,
		RECORD_DATE,
		OFFER_HEAD,
		OTHER_MONEY,
		OTHER_MONEY_VALUE,
		OFFER_STATUS,
		COMMETHOD_ID,
		RECORD_MEMBER,
		OFFER_CURRENCY,
		IS_PARTNER_ZONE,
		IS_PUBLIC_ZONE,
		OFFER_DATE,
		OFFER_STAGE,
		SALES_ADD_OPTION_ID
		<cfif attributes.report_type eq 3>
			,STOCK_ID
			,STOCK_CODE
			,PRODUCT_CATID
			,BRAND_ID
			,SHORT_CODE_ID
			<cfif attributes.order_quantity eq 1>
				,ORDER_QUANTITY
			</cfif>
		</cfif>
		 <cfif xml_country eq 1>
			 ,COUNTRY_NAME
			 ,SZ_NAME
		 </cfif>
	FROM 
	(
		SELECT
			OFR.QUANTITY,
			OFR.UNIT,
			OFR.OTHER_MONEY ROW_MONEY_TYPE,
			OFR.PRODUCT_ID,
			OFR.PRODUCT_NAME,
			ISNULL(OFR.PRICE_OTHER,0) ROW_PRICE_OTHER,
			ISNULL(OFR.NET_MALIYET,0)NET_MALIYET,
			OFR.PRICE,
			OFR.TAX,
			OFR.DISCOUNT_1,
			OFR.DISCOUNT_2,
			OFR.DISCOUNT_3,
			OFR.DISCOUNT_4,
			OFR.DISCOUNT_5,
			OFR.DISCOUNT_6,
			OFR.DISCOUNT_7,
			OFR.DISCOUNT_8,
			OFR.DISCOUNT_9,
			OFR.DISCOUNT_10,
			ISNULL(OFR.DISCOUNT_COST,0) ROW_DISC_COST,
			ISNULL(OFR.EXTRA_PRICE_TOTAL,0) EXTRA_PRICE_TOTAL,
			OFR.OTHER_MONEY ROW_OTHER_MONEY,
			OFR.OTHER_MONEY_VALUE ROW_OTHER_MONEY_VALUE,
			(SELECT COMPANY_ID FROM PRODUCT WHERE PRODUCT_ID = OFR.PRODUCT_ID) ROW_PROVIDER_ID,
			ISNULL((SELECT TOP 1 RATE2 FROM OFFER_MONEY WHERE ACTION_ID = OFR.OFFER_ID AND MONEY_TYPE = OFR.OTHER_MONEY),1) OTHER_MONEY_RATE,
			O.OFFER_DETAIL,
			O.OPP_ID,
			O.OFFER_ID,
			O.REF_NO,
			O.CONSUMER_ID,
			O.PARTNER_ID,
			O.COMPANY_ID,		
			O.OFFER_TO_PARTNER,
			O.SALES_EMP_ID,
			O.SALES_PARTNER_ID,
			O.OFFER_NUMBER,
			O.RECORD_DATE,
			O.OFFER_HEAD,
			O.OTHER_MONEY,
			ISNULL(O.OTHER_MONEY_VALUE,0) OTHER_MONEY_VALUE,
			O.OFFER_STATUS,
			O.COMMETHOD_ID,
			O.RECORD_MEMBER,
			O.OFFER_CURRENCY,
			O.IS_PARTNER_ZONE,
			O.IS_PUBLIC_ZONE,
			O.OFFER_DATE,
			O.OFFER_STAGE,
            O.PROBABILITY,
			O.SALES_ADD_OPTION_ID
			<cfif attributes.report_type eq 3>
				,S.STOCK_ID
				,S.STOCK_CODE
				,S.PRODUCT_CATID
				,P.BRAND_ID
				,P.SHORT_CODE_ID
				<cfif attributes.order_quantity eq 1>
					,(SELECT SUM(QUANTITY) QUANTITY FROM ORDER_ROW WHERE WRK_ROW_RELATION_ID = OFR.WRK_ROW_ID) ORDER_QUANTITY
				</cfif>
			</cfif>
			<cfif xml_country eq 1>
				,O.COUNTRY_ID
				,O.SZ_ID
				,(SELECT COUNTRY_NAME FROM #dsn_alias#.SETUP_COUNTRY SC WHERE SC.COUNTRY_ID=O.COUNTRY_ID) COUNTRY_NAME
				,(SELECT SZ_NAME FROM #dsn_alias#.SALES_ZONES SZ WHERE SZ.SZ_ID=O.SZ_ID) SZ_NAME
			</cfif>
		FROM
			OFFER_ROW OFR,
			OFFER O
			<cfif attributes.report_type eq 3>
			,STOCKS S
			,PRODUCT P
			</cfif>
		WHERE 
			( (O.PURCHASE_SALES = 1 AND O.OFFER_ZONE = 0)	OR (O.PURCHASE_SALES = 0 AND O.OFFER_ZONE = 1) )
			AND OFR.OFFER_ID = O.OFFER_ID
			<cfif attributes.report_type eq 3>
				AND S.STOCK_ID = OFR.STOCK_ID
				AND S.PRODUCT_ID = OFR.PRODUCT_ID 
				AND S.PRODUCT_ID = P.PRODUCT_ID 
				AND P.PRODUCT_ID = OFR.PRODUCT_ID
			</cfif>
			<cfif len(attributes.sale_employee_id) and len(attributes.sale_employee_id)>
				AND O.SALES_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sale_employee_id#">
			</cfif>
			<cfif len(attributes.customer_id) and len(attributes.member_name)>
				AND O.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_id#">
			<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>
				AND O.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			</cfif>
			<cfif len(attributes.product_id) and len(attributes.product_name)>
				AND OFR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
			</cfif>
			<cfif len(attributes.probability)>
				AND O.PROBABILITY IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.probability#" list="yes">)
			</cfif>
			<cfif len(attributes.country)>
				AND O.COUNTRY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#">
			</cfif>
			<cfif len(attributes.sales_zone)>
				AND O.SZ_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_zone#">
			</cfif>
			<cfif 	(len(attributes.product_cat_id) and len(attributes.product_cat_name)) or (len(attributes.brand_id) and len(attributes.brand_name)) or
					(len(attributes.product_employee_id) and len(attributes.product_employee_name)) or (len(attributes.product_target_market)) or (len(attributes.provider_id) and len(attributes.provider_name))>
				AND OFR.PRODUCT_ID IN
					(	SELECT
							PRODUCT_ID
						FROM
							PRODUCT
						WHERE
							PRODUCT_ID IS NOT NULL
							<cfif len(attributes.product_cat_id) and len(attributes.product_cat_name)>
								AND PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_cat_id#">
							</cfif>
							<cfif len(attributes.brand_id) and len(attributes.brand_name)>
								AND BRAND_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.brand_id#">)
							</cfif>
							<cfif len(attributes.product_employee_id) and len(attributes.product_employee_name)>
								AND PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#">
							</cfif>
							<cfif len(attributes.product_target_market)>
								AND SEGMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_target_market#">
							</cfif>
							<cfif len(attributes.provider_id) and len(attributes.provider_name)>
								AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.provider_id#">
							</cfif>
					)
			</cfif>
			<cfif 	len(attributes.customer_value) or (len(attributes.customer_cat_type) and listfirst(attributes.customer_cat_type,'-') eq 1) or len(attributes.customer_relation_type) or
					len(attributes.customer_sector_cat) or len(attributes.city)>
				AND (	
						O.COMPANY_ID IN
						(
							SELECT
								COMPANY_ID
							FROM
								#dsn_alias#.COMPANY
							WHERE
								COMPANY_ID IS NOT NULL
								<cfif len(attributes.customer_value)>
									AND COMPANY_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#">
								</cfif>
								<cfif Len(Company_Member)>
									AND COMPANYCAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#Company_Member#">)
								</cfif>
								<cfif len(attributes.customer_relation_type)>
									AND RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_relation_type#">
								</cfif>
								<cfif len(attributes.customer_sector_cat)>
									AND SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_sector_cat#">
								</cfif>
								<cfif len(attributes.city)>
									AND CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#">
								</cfif>
						)
						OR
						O.CONSUMER_ID IN
						(
							SELECT
								CONSUMER_ID
							FROM
								#dsn_alias#.CONSUMER
							WHERE
								CONSUMER_ID IS NOT NULL
								<cfif len(attributes.customer_value)>
									AND CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#">
								</cfif>
								<cfif Len(Consumer_Member)>
									AND CONSUMER_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#Consumer_Member#">)
								</cfif>
								<cfif len(attributes.customer_relation_type)>
									AND RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_relation_type#">
								</cfif>
								<cfif len(attributes.customer_sector_cat)>
									AND SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_sector_cat#">
								</cfif>
								<cfif len(attributes.city)>
									AND TAX_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#">
								</cfif>
						)
					)
			</cfif>		
			<cfif len(attributes.customer_position_code) and len(attributes.customer_position_name)>
				AND (
						O.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_position_code#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND IS_MASTER = 1)
						OR
						O.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_position_code#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND IS_MASTER = 1)
					)
			</cfif>
			<cfif len(attributes.to_convert_order)>
				AND (	O.OFFER_ID <cfif attributes.to_convert_order eq 0>NOT</cfif> IN (SELECT OFFER_ID FROM ORDERS WHERE OFFER_ID = O.OFFER_ID)
						<cfif attributes.to_convert_order eq 1> OR <cfelse> AND </cfif>
						O.OFFER_ID <cfif attributes.to_convert_order eq 0>NOT</cfif> IN (SELECT RELATED_ACTION_ID FROM ORDER_ROW WHERE RELATED_ACTION_TABLE = 'OFFER' AND RELATED_ACTION_ID = O.OFFER_ID)
					)
			</cfif>
			<cfif len(attributes.reference_customer_id) and len(attributes.reference_member_name)>
				AND O.REF_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.reference_customer_id#">
			<cfelseif len(attributes.reference_consumer_id) and len(attributes.reference_member_name)>
				AND O.REF_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.reference_consumer_id#">
			</cfif>
			<cfif len(attributes.project_id) and len(attributes.project_name)>
				AND O.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			</cfif>
			<cfif len(attributes.private_definition)>
				AND O.SALES_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.private_definition#">
			</cfif>
			<cfif len(attributes.offer_start_date)>
				AND O.OFFER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.offer_start_date#">
			</cfif>
			<cfif len(attributes.offer_finish_date)>
				AND O.OFFER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.offer_finish_date#">
			</cfif>
			<cfif len(attributes.valid_start_date)>
				AND O.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.valid_start_date#">
			</cfif>
			<cfif len(attributes.valid_finish_date)>
				AND O.FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.valid_finish_date#">
			</cfif>
			<cfif len(attributes.process_stage)>
				AND O.OFFER_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.process_stage#">)
			</cfif>
			<cfif len(attributes.status)>
				AND O.OFFER_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.status#">
			</cfif>
			<cfif Len(attributes.sales_partner)>
				<cfif isdefined("xml_sales_cari") and xml_sales_cari eq 1>
				    AND O.SALES_PARTNER_ID IN 
						(SELECT 
							CP.PARTNER_ID
						FROM 
							#dsn_alias#.COMPANY_PARTNER CP,
							#dsn_alias#.COMPANY C
						WHERE 
							CP.COMPANY_ID = C.COMPANY_ID AND
							C.COMPANY_ID IN (SELECT CP.COMPANY_ID FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_partner_id#">)
						)
			    <cfelse>
					AND O.SALES_PARTNER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.sales_partner_id#">)
			    </cfif>
			</cfif>
		)T1
		<cfif report_type eq 1>
			GROUP BY 
            	PROBABILITY,
				OFFER_NUMBER,
				OFFER_ID,
				REF_NO,
				CONSUMER_ID,
				PARTNER_ID,
				COMPANY_ID,		
				OFFER_TO_PARTNER,
				SALES_EMP_ID,
				SALES_PARTNER_ID,
				OFFER_NUMBER,
				RECORD_DATE,
				OFFER_HEAD,
				OTHER_MONEY,
				OTHER_MONEY_VALUE,
				OFFER_STATUS,
				COMMETHOD_ID,
				RECORD_MEMBER,
				OFFER_CURRENCY,
				IS_PARTNER_ZONE,
				IS_PUBLIC_ZONE,
				OFFER_DATE,
				OFFER_STAGE,
				SALES_ADD_OPTION_ID
			   <cfif xml_country eq 1>
					,COUNTRY_NAME
					,SZ_NAME
			   </cfif>
		</cfif>
	ORDER BY 
		OFFER_ID DESC
</cfquery>

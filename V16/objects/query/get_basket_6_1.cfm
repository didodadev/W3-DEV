<!--- 
20050917
	order_type : stok staratejisi cesitleri (1:Yok Stok,2:Acil Siparis Ver,3:Siparis Ver)
	order_base : (1:depolar bazında,2:Tüm Depolar)
	tarih:19022004 
	Amac:
		Toplu Siparis Sayfasi
		Sayfadan Korkmayin 3 sorgu var. siparis tipine ve stok turune gore calisan kodlar eski yapilan kodlar.
		Son olan ise en yeni yaptigimiz.Form sayfasinda secilen Firmanin 
		tedarikcisi oldugu tum urunlerin  basket te listelenmesini saglar.
		Eger Formda depolara gore derse;
		Firmanin tum depolari icin , tum urunleri icin birer siparis satiri olusturur.
OZDEN20070228
	related_order_id : satınalma siparisini olusturacak urunlerin alındıgı satıs siparisinin id 'si
	order_all_products : tedarikci-sorumlu kontrolu yapılmadan satıs siparisindeki tum urunlerin secilen cariye ait aynı satınalma siparisinde gelmesini kontrol eder
	attributes.internaldemand_id : ic talepden satınalma siparisi olusturma
	form.offer_row_check_info : satinalma teklifinden satinalma siparisi olusturma FBS 20090428
--->

<!--- Bu if blogu Satinalma Teklifi listede satir bazinda siparise donusturme icin eklendi FS 20090428 --->
<cfif isDefined("form.offer_row_check_info") and len(form.offer_row_check_info)>
	<cfset offer_row_list = "">
	<cfset wrk_row_list = "">
	<cfloop list="#form.offer_row_check_info#" index="rci">
		<cfset offer_row_list = ListAppend(offer_row_list,ListFirst(rci,'_'),',')>
		<cfset wrk_row_list = ListAppend(wrk_row_list,ListLast(rci,'_'),',')>
	</cfloop>
</cfif>
<cf_date tarih='attributes.deliverdate'>
<cfif isdefined('attributes.order_date') and len(attributes.order_date)>
	<cf_date tarih='attributes.order_date'>
</cfif>
<cfquery name="GET_STOCKS" datasource="#DSN3#">
	SELECT
		<cfif isdefined("attributes.stock_control_type") and attributes.stock_control_type eq 1>
            (	SELECT 
                    ISNULL(SUM(STOCK_AZALT),0) 
                FROM 
                    GET_STOCK_RESERVED 
                WHERE 
                    GET_STOCK_RESERVED.STOCK_ID = S.STOCK_ID
            ) 
            <cfif isdefined("attributes.is_real_stock")>
            -
            (	SELECT
                    ISNULL(SUM(SR.STOCK_IN - SR.STOCK_OUT),0)
                FROM
                    #dsn2_alias#.STOCKS_ROW SR
                WHERE
                    SR.PRODUCT_ID = S.PRODUCT_ID
            )
            </cfif>
            AS STOCK_SAYISI,
        <cfelseif isdefined("attributes.stock_control_type") and attributes.stock_control_type eq 2> 
			<cfif not isdefined("attributes.is_real_stock")>
                (	SELECT 
                        CASE 
                            WHEN #dsn_alias#.IS_ZERO(REPEAT_STOCK_VALUE,0) < #dsn_alias#.IS_ZERO(MINIMUM_ORDER_STOCK_VALUE,0) THEN MINIMUM_ORDER_STOCK_VALUE
                        ELSE 
                            REPEAT_STOCK_VALUE
                        END
                        AS REPEAT_STOCK_VALUE
                    FROM 
                        #dsn2_alias#.GET_STOCK_STRATEGY GS_STRATEGY
                    WHERE 
                        GS_STRATEGY.STOCK_ID=S.STOCK_ID AND 
                        GS_STRATEGY.DEPARTMENT_ID IS NULL
                ) AS STOCK_SAYISI,
            <cfelse><!--- yeniden sipariş noktası - stok < minimum sipar nok then min sip nok else yeniden sipariş noktası - stok --->
                CASE WHEN 
                    (
                        ( 
                            SELECT 
                                #dsn_alias#.IS_ZERO(GS_STRATEGY.REPEAT_STOCK_VALUE,0) REPEAT_STOCK_VALUE
                            FROM 
                                #dsn2_alias#.GET_STOCK_STRATEGY GS_STRATEGY
                            WHERE 
                                GS_STRATEGY.STOCK_ID= S.STOCK_ID AND 
                                GS_STRATEGY.DEPARTMENT_ID IS NULL
                        )
                        -
                        (	SELECT
                                ISNULL(SUM(SR.STOCK_IN - SR.STOCK_OUT),0)
                            FROM
                               #dsn2_alias#.STOCKS_ROW SR
                            WHERE
                                SR.PRODUCT_ID = S.PRODUCT_ID
                        ) 
                    )
                    < 
                        (
                            SELECT 
                                #dsn_alias#.IS_ZERO(GS_STRATEGY.MINIMUM_ORDER_STOCK_VALUE,0) REPEAT_STOCK_VALUE
                            FROM 
                                #dsn2_alias#.GET_STOCK_STRATEGY GS_STRATEGY
                            WHERE 
                                GS_STRATEGY.STOCK_ID= S.STOCK_ID AND 
                                GS_STRATEGY.DEPARTMENT_ID IS NULL
                        )
                THEN
                        (
                            SELECT 
                                #dsn_alias#.IS_ZERO(GS_STRATEGY.MINIMUM_ORDER_STOCK_VALUE,0) REPEAT_STOCK_VALUE
                            FROM 
                                #dsn2_alias#.GET_STOCK_STRATEGY GS_STRATEGY
                            WHERE 
                                GS_STRATEGY.STOCK_ID= S.STOCK_ID AND 
                                GS_STRATEGY.DEPARTMENT_ID IS NULL
                        )
                ELSE
                ( 
                    SELECT 
                        #dsn_alias#.IS_ZERO(GS_STRATEGY.REPEAT_STOCK_VALUE,0) REPEAT_STOCK_VALUE
                    FROM 
                        #dsn2_alias#.GET_STOCK_STRATEGY GS_STRATEGY
                    WHERE 
                        GS_STRATEGY.STOCK_ID= S.STOCK_ID AND 
                        GS_STRATEGY.DEPARTMENT_ID IS NULL
                )
                -
                (	SELECT
                        ISNULL(SUM(SR.STOCK_IN - SR.STOCK_OUT),0)
                    FROM
                       #dsn2_alias#.STOCKS_ROW SR
                    WHERE
                        SR.PRODUCT_ID = S.PRODUCT_ID
                )
                END AS 
            STOCK_SAYISI,
            </cfif>
	<cfelseif isdefined("attributes.stock_control_type") and attributes.stock_control_type eq 3>
		(	SELECT 
				ISNULL(SUM(STOCK_AZALT),0) 
			FROM
				GET_STOCK_RESERVED
			WHERE 
				GET_STOCK_RESERVED.STOCK_ID = S.STOCK_ID
		) 
		+ 
		(	SELECT 
				ISNULL(SUM(GS_STRATEGY.REPEAT_STOCK_VALUE),0) 
			FROM 
				#dsn2_alias#.GET_STOCK_STRATEGY GS_STRATEGY
			WHERE 
				GS_STRATEGY.STOCK_ID=S.STOCK_ID AND 
				GS_STRATEGY.DEPARTMENT_ID IS NULL
		)
		<cfif isdefined("attributes.is_real_stock")>
		-
		(	SELECT
				ISNULL(SUM(SR.STOCK_IN - SR.STOCK_OUT),0)
			FROM
				#dsn2_alias#.STOCKS_ROW SR
			WHERE
				SR.PRODUCT_ID = S.PRODUCT_ID
		)
		</cfif>
		AS STOCK_SAYISI,
	<cfelseif isdefined("attributes.stock_control_type") and attributes.stock_control_type eq 4>
		CASE
			WHEN 
			(SELECT ISNULL(SUM(MINIMUM_ORDER_STOCK_VALUE),0) FROM STOCK_STRATEGY WHERE STOCK_STRATEGY.STOCK_ID = S.STOCK_ID)
			>
			(SELECT ISNULL(SUM(MAXIMUM_STOCK),0) FROM STOCK_STRATEGY WHERE STOCK_STRATEGY.STOCK_ID = S.STOCK_ID) 
			<cfif isdefined("attributes.is_real_stock")>
				- 
				(
					SELECT 
						SALEABLE_STOCK
					FROM 
						#dsn2_alias#.GET_STOCK_LAST
					WHERE 
						GET_STOCK_LAST.STOCK_ID = S.STOCK_ID
				)
			</cfif>
		THEN  
			(SELECT ISNULL(SUM(MINIMUM_ORDER_STOCK_VALUE),0)  FROM STOCK_STRATEGY WHERE STOCK_STRATEGY.STOCK_ID = S.STOCK_ID)
		ELSE  
			(SELECT ISNULL(SUM(MAXIMUM_STOCK),0) FROM STOCK_STRATEGY WHERE STOCK_STRATEGY.STOCK_ID = S.STOCK_ID) 
			<cfif isdefined("attributes.is_real_stock")>
				- 
				(
					SELECT 
						SALEABLE_STOCK
					FROM 
						#dsn2_alias#.GET_STOCK_LAST
					WHERE 
						GET_STOCK_LAST.STOCK_ID = S.STOCK_ID
				)
			</cfif>
		END AS STOCK_SAYISI,
    <cfelse>
    	<cfif isdefined("attributes.is_real_stock")>
            ORDER_ROW.QUANTITY
            -
            (	SELECT
                    ISNULL(SUM(SR.STOCK_IN - SR.STOCK_OUT),0)
                FROM
                    #dsn2_alias#.STOCKS_ROW SR
                WHERE
                    SR.PRODUCT_ID = S.PRODUCT_ID
            )
            AS STOCK_SAYISI,
		</cfif>
	</cfif>
		S.PRODUCT_ID,
		S.STOCK_ID,
		S.MANUFACT_CODE,
		S.PROPERTY,
		S.BARCOD,
		S.STOCK_CODE,
		S.PRODUCT_NAME,
		S.STOCK_CODE_2,
		S.IS_INVENTORY,
		S.IS_PRODUCTION,
		S.TAX,
		S.TAX_PURCHASE,
		PRODUCT_UNIT.MAIN_UNIT,
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.PRODUCT_UNIT_ID,
		PS.PRICE,
		PS.PRICE_KDV,
		PS.MONEY
		<cfif isdefined('attributes.related_order_id') and len(attributes.related_order_id)>
			,ORDER_ROW.WIDTH_VALUE
			,ORDER_ROW.DEPTH_VALUE
			,ORDER_ROW.HEIGHT_VALUE
			,ORDER_ROW.WRK_ROW_ID
			,ORDER_ROW.SPECT_VAR_ID
			,ORDER_ROW.SPECT_VAR_NAME
			,ORDER_ROW.RESERVE_DATE
			,ORDER_ROW.QUANTITY
			,ORDER_ROW.PROM_RELATION_ID
			, '' AS ROW_DELIVER_DATE
			,'-1' AS ORDER_ROW_CURRENCY
			,'-1' AS RESERVE_TYPE
            ,ORDER_ROW.PRODUCT_NAME2 PRODUCT_NAME2
            ,ORDER_ROW.BASKET_EXTRA_INFO_ID
			,ORDER_ROW.SELECT_INFO_EXTRA
			,ORDER_ROW.DETAIL_INFO_EXTRA
            ,ORDER_ROW.LOT_NO
			,ORDER_ROW.UNIT2
			,ORDER_ROW.AMOUNT2
			,ORDER_ROW.EXPENSE_CENTER_ID
			,ORDER_ROW.EXPENSE_ITEM_ID
			,ORDER_ROW.ACTIVITY_TYPE_ID
			,ORDER_ROW.ACC_CODE
			,ORDER_ROW.BSMV_RATE
			,ORDER_ROW.BSMV_AMOUNT
			,ORDER_ROW.BSMV_CURRENCY
			,ORDER_ROW.OIV_RATE
			,ORDER_ROW.OIV_AMOUNT
			,ORDER_ROW.TEVKIFAT_RATE
			,ORDER_ROW.TEVKIFAT_AMOUNT
			,EXC.EXPENSE
			,EXI.EXPENSE_ITEM_NAME
		<cfelseif isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id)>
			,INT_D.WRK_ROW_ID
			,INT_D.I_ID AS INTERNALDEMAND_ID
			,INT_D.I_ROW_ID
			,INT_D.DISCOUNT_1
			,INT_D.DISCOUNT_2
			,INT_D.DISCOUNT_3
			,INT_D.DISCOUNT_4
			,INT_D.DISCOUNT_5
			,INT_D.DISCOUNT_6
			,INT_D.DISCOUNT_7
			,INT_D.DISCOUNT_8
			,INT_D.DISCOUNT_9
			,INT_D.DISCOUNT_10
			,INT_D.DISCOUNT_COST
			,INT_D.SPECT_VAR_ID
			,INT_D.SPECT_VAR_NAME
			,INT_D.QUANTITY
			,INT_D.PRODUCT_NAME ORW_PRODUCT_NAME
			,INT_D.PRODUCT_NAME2 PRODUCT_NAME2
			,INT_D.PRICE INT_PRICE
			,ISNULL(INT_D.PRICE_OTHER,0) INT_PRICE_OTHER
			,INT_D.OTHER_MONEY INT_OTHER_MONEY
			,INT_D.EXTRA_PRICE_TOTAL EXTRA_PRICE_TOTAL
			,INT_D.COST_PRICE COST_PRICE
			,INT_D.EXTRA_COST EXTRA_COST
			,INT_D.TAX INT_TAX
			,INT_D.PROM_RELATION_ID
			,INT_D.DELIVER_DATE AS ROW_DELIVER_DATE
			,ISNULL(INT_D.DELIVER_DEPT,I.DEPARTMENT_IN) AS DELIVER_DEPT
			,ISNULL(INT_D.DELIVER_LOCATION,I.LOCATION_IN) AS DELIVER_LOCATION
			,'-1' AS ORDER_ROW_CURRENCY
			,'-1' AS RESERVE_TYPE
			,INT_D.ROW_PROJECT_ID
            ,INT_D.ROW_WORK_ID
            ,INT_D.BASKET_EXTRA_INFO_ID
			,INT_D.SELECT_INFO_EXTRA
			,INT_D.DETAIL_INFO_EXTRA
			,INT_D.BASKET_EMPLOYEE_ID
			,INT_D.OTV_ORAN
			,INT_D.OTVTOTAL
			,INT_D.UNIT2
			,INT_D.AMOUNT2
			,INT_D.LOT_NO
			,INT_D.EXPENSE_CENTER_ID
			,INT_D.EXPENSE_ITEM_ID
			,INT_D.ACTIVITY_TYPE_ID
			,EXC.EXPENSE
			,EXI.EXPENSE_ITEM_NAME
			,INT_D.ACC_CODE
			,'' BSMV_RATE
			,'' BSMV_AMOUNT
			,'' BSMV_CURRENCY
			,INT_D.OIV_RATE
			,INT_D.OIV_AMOUNT
			,'' TEVKIFAT_RATE
			,'' TEVKIFAT_AMOUNT
		<cfelseif isdefined("attributes.offer_row_check_info") and len(attributes.offer_row_check_info)>
			,ORW.WRK_ROW_ID
			,ORW.OFFER_ID
			,ORW.SPECT_VAR_ID
			,ORW.SPECT_VAR_NAME
			,ORW.QUANTITY
			,ORW.PRODUCT_NAME ORW_PRODUCT_NAME
			,ORW.PRODUCT_NAME2 PRODUCT_NAME2
			,ORW.PRICE ORW_PRICE
			,ORW.PRICE_OTHER ORW_PRICE_OTHER
			,ORW.OTHER_MONEY ORW_OTHER_MONEY
			,ORW.TAX ORW_TAX
            ,ORW.BASKET_EXTRA_INFO_ID
			,ORW.SELECT_INFO_EXTRA
			,ORW.DETAIL_INFO_EXTRA
			,ORW.EXPENSE_CENTER_ID
			,ORW.EXPENSE_ITEM_ID
			,ORW.ACTIVITY_TYPE_ID
			,ORW.ACC_CODE
			,ORW.BSMV_RATE
			,ORW.BSMV_AMOUNT
			,ORW.BSMV_CURRENCY
			,ORW.OIV_RATE
			,ORW.OIV_AMOUNT
			,ORW.TEVKIFAT_RATE
			,ORW.TEVKIFAT_AMOUNT
			,EXC.EXPENSE
			,EXI.EXPENSE_ITEM_NAME
			, '' AS ROW_DELIVER_DATE
			,'-1' AS ORDER_ROW_CURRENCY
			,'-1' AS RESERVE_TYPE
            ,ORW.LOT_NO
		<cfelse>
			,'' ROW_DELIVER_DATE
			,'' AS WRK_ROW_ID
			,'' UNIT2
			,'' AMOUNT2
			,'' BASKET_EXTRA_INFO_ID
			,'' SELECT_INFO_EXTRA
			,'' DETAIL_INFO_EXTRA
            ,'' LOT_NO
		</cfif>	
	FROM
	<cfif isdefined('attributes.related_order_id') and len(attributes.related_order_id)>
		ORDER_ROW
		LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON ORDER_ROW.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
        LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON ORDER_ROW.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID,
	<cfelseif isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id)>
		INTERNALDEMAND I,
		INTERNALDEMAND_ROW INT_D
		LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON INT_D.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
        LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON INT_D.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID,
	<cfelseif isdefined("attributes.offer_row_check_info") and len(attributes.offer_row_check_info)>
		OFFER_ROW ORW
		LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON ORW.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
        LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON ORW.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID,
	</cfif>
		STOCKS S,
		PRODUCT_UNIT,
		PRICE_STANDART AS PS 
	WHERE
		<cfif isdefined("attributes.stock_control_type") and attributes.stock_control_type eq 1>
		(SELECT ISNULL(SUM(STOCK_AZALT),0) FROM GET_STOCK_RESERVED WHERE GET_STOCK_RESERVED.STOCK_ID = S.STOCK_ID) > 0 AND
		<cfelseif isdefined("attributes.stock_control_type") and attributes.stock_control_type eq 2> 
		(SELECT GS_STRATEGY.REPEAT_STOCK_VALUE FROM #dsn2_alias#.GET_STOCK_STRATEGY GS_STRATEGY WHERE GS_STRATEGY.STOCK_ID=S.STOCK_ID AND GS_STRATEGY.DEPARTMENT_ID IS NULL) >= (SELECT GET_STOCK_LAST.SALEABLE_STOCK FROM #dsn2_alias#.GET_STOCK_LAST WHERE GET_STOCK_LAST.STOCK_ID=S.STOCK_ID) AND S.PRODUCT_STATUS = 1 AND<!--- satilabilir stoguyla karsilastiriliyor --->
		<cfelseif isdefined("attributes.stock_control_type") and attributes.stock_control_type eq 3>
		(		
		(SELECT ISNULL(SUM(STOCK_AZALT),0) FROM GET_STOCK_RESERVED WHERE GET_STOCK_RESERVED.STOCK_ID = S.STOCK_ID) > 0 
		OR
		(SELECT ISNULL(SUM(GST.REPEAT_STOCK_VALUE),0) FROM #dsn2_alias#.GET_STOCK_STRATEGY GST WHERE GST.STOCK_ID=S.STOCK_ID AND GST.DEPARTMENT_ID IS NULL) > 0
		) AND
		<cfelseif isdefined("attributes.stock_control_type") and attributes.stock_control_type eq 4>
			(
			(SELECT ISNULL(SUM(MAXIMUM_STOCK),0) FROM STOCK_STRATEGY WHERE STOCK_STRATEGY.STOCK_ID = S.STOCK_ID) 
			<cfif isdefined("attributes.is_real_stock")>
				- 
				(
					SELECT 
						SALEABLE_STOCK
					FROM 
						#dsn2_alias#.GET_STOCK_LAST
					WHERE 
						GET_STOCK_LAST.STOCK_ID = S.STOCK_ID
				)
			</cfif>
			 )> 0 AND
			<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and isdefined("attributes.cat_id") and len(attributes.cat_id)>
				S.BRAND_ID = #attributes.brand_id# AND
				S.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cat_id#%"> AND
			<cfelseif isdefined("attributes.brand_id") and len(attributes.brand_id)> 
				S.BRAND_ID = #attributes.brand_id# AND
			</cfif>
		</cfif>
		<cfif isdefined('attributes.related_order_id') and len(attributes.related_order_id)>
			ORDER_ROW.ORDER_ID=#attributes.related_order_id# AND
			S.STOCK_ID =ORDER_ROW.STOCK_ID AND
		<cfelseif isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id)>
			<cfif isdefined('attributes.internaldemand_row_id') and len(attributes.internaldemand_row_id)><!--- iç talepten siparis olusturuluyorsa --->
			<!--- satır bazlı iç talepten siparis olusturma --->
				INT_D.I_ROW_ID IN (#attributes.internaldemand_row_id#) AND
			</cfif>
			INT_D.I_ID IN (#attributes.internaldemand_id#) AND
			S.STOCK_ID =INT_D.STOCK_ID AND
			I.INTERNAL_ID =INT_D.I_ID AND
		<cfelseif isdefined("attributes.offer_row_check_info") and len(attributes.offer_row_check_info)>
			S.STOCK_ID = ORW.STOCK_ID AND
			ORW.WRK_ROW_ID IN (#ListQualify(wrk_row_list,"'",",")#) AND
			ORW.OFFER_ID IN (#ListDeleteDuplicates(offer_row_list)#) AND
		</cfif>
		PRODUCT_UNIT.PRODUCT_ID = S.PRODUCT_ID AND
		PS.PRODUCT_ID = S.PRODUCT_ID AND
		<cfif isdefined('attributes.stock_id') and len(attributes.stock_id)> <!--- stok detaydan tek urun icin siparis verilmisse --->
			S.STOCK_ID = #attributes.stock_id# AND
		</cfif>
		<cfif isdefined('attributes.related_order_id') and len(attributes.related_order_id)>
			PRODUCT_UNIT.PRODUCT_UNIT_ID = ORDER_ROW.UNIT_ID AND
		<cfelseif isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id)>
			(
				(	
					PRODUCT_UNIT.PRODUCT_UNIT_ID = INT_D.UNIT_ID AND 
					PRODUCT_UNIT.ADD_UNIT = INT_D.UNIT
				)
				OR
				PRODUCT_UNIT.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID
			) AND
		<cfelse>
			PRODUCT_UNIT.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND
		</cfif>
		--PS.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
		PS.PRICESTANDART_STATUS = 1 AND
		PS.PURCHASESALES = 0
		<cfif not isdefined('attributes.all_product_convert')><!--- Eğer "Tüm ürünleri siparişe dönüştür" seçili değilse. (İç talepten siparis ekleme) --->
			<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined('attributes.company_name') and len(attributes.company_name)>
				AND S.COMPANY_ID = #attributes.company_id#
			</cfif>
		</cfif>
		<cfif isdefined("attributes.product_employee_id") and len(attributes.product_employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)><!--- Sorumlu seçildiyse sadece onun ürünleri gelecek --->
			AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
		</cfif>
		<cfif (isdefined("attributes.order_all_products") and attributes.order_all_products eq 1) or (isdefined("attributes.order_all_products") and not len(attributes.order_all_products))><!--- toplu siparis verme --->
			<cfif isdefined("attributes.product_manager") and len(attributes.product_manager)>
				AND S.PRODUCT_MANAGER=#attributes.product_manager#
			<cfelse>	
				<cfset is_query_none = 1><!--- hem product_manager hem comp_id yoksa kayit donmesin istemisiz--->
			</cfif>				
			<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
				AND	S.COMPANY_ID = #attributes.comp_id#
			<cfelseif isdefined("is_query_none")>
				AND 1 = 0
			</cfif> 
		</cfif>
		<cfif isdefined("attributes.order_stage_products") and attributes.order_stage_products eq 1>
			AND ORDER_ROW.ORDER_ROW_CURRENCY = -2
		</cfif>
	ORDER BY
	<cfif isdefined('attributes.related_order_id') and len(attributes.related_order_id)>
		ORDER_ROW.ORDER_ROW_ID
	<cfelseif isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id)>
		INT_D.I_ROW_ID
	<cfelseif isdefined("attributes.offer_row_check_info") and len(attributes.offer_row_check_info)>
		ORW.OFFER_ROW_ID
	<cfelse>
		S.PRODUCT_ID,
		S.STOCK_ID
	</cfif>
</cfquery>
<cfif isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id)>
	<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(get_stocks.ROW_PROJECT_ID)),'numeric','asc',',')>
    <cfset row_work_id_list_=listsort(ListDeleteDuplicates(valuelist(get_stocks.ROW_WORK_ID)),'numeric','asc',',')>
	<cfset basket_emp_id_list=listsort(ListDeleteDuplicates(valuelist(get_stocks.BASKET_EMPLOYEE_ID)),'numeric','asc',',')>
</cfif>
<cfif isdefined("row_project_id_list_") and len(row_project_id_list_)>
	<cfquery name="GET_ROW_PROJECTS" datasource="#dsn#">
		SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#row_project_id_list_#) ORDER BY PROJECT_ID
	</cfquery>
	<cfset row_project_id_list_=valuelist(GET_ROW_PROJECTS.PROJECT_ID)>
</cfif>
<cfif isdefined("row_work_id_list_") and len(row_work_id_list_)>
	<cfquery name="GET_ROW_WORKS" datasource="#dsn#">
		SELECT WORK_HEAD,WORK_ID FROM PRO_WORKS WHERE WORK_ID IN (#row_work_id_list_#) ORDER BY WORK_ID
	</cfquery>
	<cfset row_work_id_list_=valuelist(GET_ROW_WORKS.WORK_ID)>
</cfif>
<cfif isdefined("basket_emp_id_list") and len(basket_emp_id_list)>
	<cfquery name="GET_BASKET_EMPLOYEES" datasource="#dsn#">
		SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS BASKET_EMPLOYEE, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#basket_emp_id_list#) ORDER BY EMPLOYEE_ID
	</cfquery>
	<cfset basket_emp_id_list = valuelist(GET_BASKET_EMPLOYEES.EMPLOYEE_ID)> <!--- bulunan kayıtlara gore liste yeniden set ediliyor --->
</cfif>
<cfif get_stocks.recordcount>
	<cfset price_prod_list=''>
	<cfif isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id) and not (isdefined('attributes.internaldemand_row_id') and isdefined('attributes.interd_row_amount_list') )>
	 <!--- satır bazlı ic talepten siparis olusturma cagrılmamıssa miktar kontrolu yapılır,satır bazlı da zaten miktar kontrolu yapılıp kalan miktar siparise gönderiliyor--->
		<cfquery name="get_order_internaldemands" datasource="#dsn3#">
			SELECT 
				SUM(AMOUNT) AS TOTAL_AMOUNT,STOCK_ID,PRODUCT_ID 
			FROM 
				INTERNALDEMAND_RELATION_ROW 
			WHERE 
				INTERNALDEMAND_ID IN (#attributes.internaldemand_id#)
				AND TO_ORDER_ID IS NOT NULL
			GROUP BY
				STOCK_ID,PRODUCT_ID 
		</cfquery>
	<cfelse>
		<cfset get_order_internaldemands.recordcount=0>
	</cfif>
	<cfset product_id_list = listdeleteduplicates(Valuelist(get_stocks.PRODUCT_ID,','),',')>
	<!--- aksiyonlar --->
	<cfquery name="GET_PROMOTION_ALL" datasource="#DSN3#">
		SELECT
			CPP.DISCOUNT1,
			CPP.DISCOUNT2,
			CPP.DISCOUNT3,
			CPP.DISCOUNT4,
			CPP.DISCOUNT5,
			CPP.DISCOUNT6,
			CPP.DISCOUNT7,
			CPP.DISCOUNT8,
			CPP.DISCOUNT9,
			CPP.DISCOUNT10,
			CPP.PURCHASE_PRICE,
			CPP.MONEY,
			CPP.PRODUCT_ID,
			PCAT.BRANCH,
			PCAT.PRICE_CATID,
			CP.KONDUSYON_DATE,
			CP.KONDUSYON_FINISH_DATE,
			CP.CATALOG_ID
		FROM
			CATALOG_PROMOTION AS CP,
			CATALOG_PROMOTION_PRODUCTS AS CPP,
			CATALOG_PRICE_LISTS CPL,
			PRICE_CAT PCAT
		WHERE
			CP.CATALOG_STATUS = 1 AND 
			CPP.PRODUCT_ID IN (#product_id_list#) AND
			CP.IS_APPLIED = 1 AND
			KONDUSYON_DATE <= #attributes.deliverdate# AND
			KONDUSYON_FINISH_DATE > #attributes.deliverdate# AND
			CPP.CATALOG_ID = CP.CATALOG_ID AND
			CPL.CATALOG_PROMOTION_ID = CP.CATALOG_ID AND
			CPL.PRICE_LIST_ID = PCAT.PRICE_CATID
		ORDER BY
			CP.CATALOG_ID DESC
	</cfquery>
	<!--- anlasmalar --->
	<cfquery name="GET_CONTRACT_ALL" datasource="#DSN3#">
		SELECT
			DISCOUNT1,
			DISCOUNT2,
			DISCOUNT3,
			DISCOUNT4,
			DISCOUNT5,
			START_DATE,
			FINISH_DATE,
			PRODUCT_ID,
			COMPANY_ID,
			C_P_PROD_DISCOUNT_ID AS DISCOUNT_ID
		FROM
			CONTRACT_PURCHASE_PROD_DISCOUNT
		WHERE
			CONTRACT_PURCHASE_PROD_DISCOUNT.PRODUCT_ID IN (#product_id_list#) AND
			START_DATE <= #attributes.deliverdate# AND
			(FINISH_DATE >= #attributes.deliverdate# OR FINISH_DATE IS NULL)
			<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
			AND COMPANY_ID=#attributes.company_id#
			</cfif>
	</cfquery>
	<cfif isdefined('attributes.phl_price_catid_') and len(attributes.phl_price_catid_) and attributes.phl_price_catid_ neq -2>
	<!--- iç talep satınalma siparişine cevirilirken, seçilen fiyat listesine göre fiyatlar alınıyor.  --->
		<cfquery name="GET_NEW_PRICE_ALL_" datasource="#DSN3#">
			SELECT
				PRICE,
				PRODUCT_ID,
				MONEY,
				PRICE_CATID
			FROM
				PRICE
			WHERE
				PRODUCT_ID IN (#product_id_list#)
				AND PRICE_CATID = #attributes.phl_price_catid_#
				AND STARTDATE <= #attributes.order_date#
				AND (FINISHDATE >= #attributes.order_date# OR FINISHDATE IS NULL)
				AND ISNULL(PRICE.CATALOG_ID,0) IN (SELECT 0 CATALOG_ID UNION ALL SELECT CATALOG_ID FROM CATALOG_PROMOTION WHERE CATALOG_STATUS = 1)
		</cfquery>
		<cfif GET_NEW_PRICE_ALL_.recordcount>
			<cfset price_prod_list=valuelist(GET_NEW_PRICE_ALL_.PRODUCT_ID)>
		</cfif>
	</cfif>
<cfelse>
	<cfset get_promotion_all.recordcount = 0>
	<cfset get_contract_all.recordcount = 0>
</cfif>
<cfscript>
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.otv_array = ArrayNew(2);
	sepet.total = 0;
	sepet.toplam_indirim = 0;
	sepet.total_tax = 0;
	sepet.total_otv = 0;
	sepet.net_total = 0;
	sepet.genel_indirim = 0;
</cfscript>
<cfif not isdefined("attributes.order_base") or (isdefined("attributes.order_base") and attributes.order_base eq 2)>
	<cfscript>
	i=0;
	for (k = 1; k lte get_stocks.recordcount;k=k+1)
	{
		used_stock_amount=0;
		if (isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id))
		{
			if(isdefined('attributes.interd_row_amount_list') and isdefined('attributes.internaldemand_row_id')) //satır bazlı iç talepten siparis olusturulurken formdan gonderilen miktar alınır
			{
				if(len(listgetat(attributes.interd_row_amount_list,listfind(attributes.internaldemand_row_id,get_stocks.I_ROW_ID) )) ) 
					new_row_amount = listgetat(attributes.interd_row_amount_list,listfind(attributes.internaldemand_row_id,get_stocks.I_ROW_ID[k]) );
				else
					new_row_amount = get_stocks.QUANTITY[k];
			}
			else if(get_order_internaldemands.recordcount) //siparisin cekildigi irsaliye varsa
			{
				SQLString = "SELECT TOTAL_AMOUNT FROM get_order_internaldemands WHERE PRODUCT_ID=#get_stocks.PRODUCT_ID[k]# AND STOCK_ID=#get_stocks.STOCK_ID[k]#";
				check_order_amount = cfquery(SQLString : SQLString, Datasource : DSN3, dbtype:'1');
				
				if(len(check_order_amount.total_amount))
				{
					if(isdefined('stock_left_amount_#get_stocks.STOCK_ID[k]#') and len(evaluate('stock_left_amount_#get_stocks.STOCK_ID[k]#')))
						used_stock_amount=evaluate('stock_left_amount_#get_stocks.STOCK_ID[k]#');
					else
						used_stock_amount=check_order_amount.total_amount;
					if(used_stock_amount gte get_stocks.QUANTITY[k])
					{	
						'stock_left_amount_#get_stocks.STOCK_ID[k]#'=used_stock_amount-get_stocks.QUANTITY[k];
						new_row_amount = 0;
					}
					else if(used_stock_amount lt get_stocks.QUANTITY[k])
					{
						new_row_amount = (get_stocks.QUANTITY[k]-used_stock_amount);
						'stock_left_amount_#get_stocks.STOCK_ID[k]#'=0;
					}
				}
				else
					new_row_amount = get_stocks.QUANTITY[k];
			 }
			 else
			 	new_row_amount = get_stocks.QUANTITY[k];
		}
		else if (isdefined('attributes.related_order_id') and len(attributes.related_order_id))
			if(isdefined("attributes.stock_control_type") and len(attributes.stock_control_type) or isdefined("attributes.is_real_stock"))//ilişkili sipariştede stok düşme işlemleri için ekledim py 0814
				new_row_amount = get_stocks.stock_sayisi[k];
			else
				new_row_amount = get_stocks.QUANTITY[k];
		else if(isdefined("attributes.stock_control_type") and len(attributes.stock_control_type))
			new_row_amount = get_stocks.stock_sayisi[k];
		//satinalma teklifi satir bazinda geliyorsa istenen miktarlar belirleniyor
		else if(isdefined("attributes.offer_row_check_info") and len(attributes.offer_row_check_info))
		{
			if(len(Evaluate('offer_amount_'&get_stocks.offer_id[k]&"_"&get_stocks.wrk_row_id[k])))
				new_row_amount = filternum(Evaluate('offer_amount_'&get_stocks.offer_id[k]&"_"&get_stocks.wrk_row_id[k]));
			else
				new_row_amount = get_stocks.QUANTITY[k];
		}
		else
			new_row_amount =1;
	
		if(new_row_amount gt 0)
		{
			i =i+1;
			sepet.satir[i] = StructNew();
			if(isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id))
				sepet.satir[i].row_ship_id="#get_stocks.INTERNALDEMAND_ID[k]#;#get_stocks.I_ROW_ID[k]#"; //iç talep siparişe donusturulurken ic talebin satır id si de tutuluyor
			else
				sepet.satir[i].row_ship_id='';
			
			sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			if(len(get_stocks.WRK_ROW_ID[k])) //diger belgenin wrk_row id si yeni belgede wrk_row_relation_id ye taşınır
				sepet.satir[i].wrk_row_relation_id = get_stocks.WRK_ROW_ID[k];
			else
				sepet.satir[i].wrk_row_relation_id ='';
				
			if(isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id) or isdefined("attributes.offer_row_check_info") and len(attributes.offer_row_check_info)) //FBS 20090119 talepten geliyorsa
			{
				if(isdefined("attributes.offer_row_check_info") and len(attributes.offer_row_check_info))
				{
					sepet.satir[i].related_action_table = 'OFFER';
					sepet.satir[i].related_action_id = get_stocks.offer_id[k];
				}
				sepet.satir[i].product_name = get_stocks.ORW_PRODUCT_NAME[k];
			}
			else
				sepet.satir[i].product_name = get_stocks.PRODUCT_NAME[k]&' '&get_stocks.PROPERTY[k];
				
			sepet.satir[i].product_id = get_stocks.PRODUCT_ID[k];
			sepet.satir[i].is_inventory = get_stocks.IS_INVENTORY[k];
			sepet.satir[i].is_production = get_stocks.IS_PRODUCTION[k];				
			if(isdefined('attributes.related_order_id') and len(attributes.related_order_id))
			{
				if(len(get_stocks.WIDTH_VALUE)) sepet.satir[i].row_width = get_stocks.WIDTH_VALUE[k]; else sepet.satir[i].row_width = '';
				if(len(get_stocks.DEPTH_VALUE)) sepet.satir[i].row_depth = get_stocks.DEPTH_VALUE[k]; else  sepet.satir[i].row_depth = '';
				if(len(get_stocks.HEIGHT_VALUE)) sepet.satir[i].row_height = get_stocks.HEIGHT_VALUE[k]; else  sepet.satir[i].row_height = '';
			}
			sepet.satir[i].barcode = get_stocks.BARCOD[k];
			sepet.satir[i].special_code = get_stocks.STOCK_CODE_2[k];
			sepet.satir[i].stock_code = get_stocks.STOCK_CODE[k];
			sepet.satir[i].paymethod_id = "";
			sepet.satir[i].catalog_id = 0;
			sepet.satir[i].stock_id = get_stocks.STOCK_ID[k];
			sepet.satir[i].duedate = "";
			if(len(get_stocks.ROW_DELIVER_DATE[k]))
				sepet.satir[i].deliver_date = dateformat(get_stocks.ROW_DELIVER_DATE[k],dateformat_style);
			else
				sepet.satir[i].deliver_date = "";
			sepet.satir[i].amount =new_row_amount;
			if (isdefined('attributes.related_order_id') and len(attributes.related_order_id))//Satış siparişinden satınalma siparişi eklerken satırdaki miktarlar alınır.
			{	
				sepet.satir[i].order_currency =get_stocks.ORDER_ROW_CURRENCY[k];
				sepet.satir[i].reserve_date = dateformat(get_stocks.RESERVE_DATE[k],dateformat_style);
				sepet.satir[i].reserve_type = get_stocks.RESERVE_TYPE[k];
			}
			else{
				sepet.satir[i].reserve_date = "";
				sepet.satir[i].reserve_type = get_stocks.RESERVE_TYPE[k];
				sepet.satir[i].order_currency =get_stocks.ORDER_ROW_CURRENCY[k];
			}
			sepet.satir[i].prom_relation_id = ""; 
			if(isdefined("get_stocks.deliver_dept"))
				sepet.satir[i].deliver_dept = "#get_stocks.deliver_dept[k]#-#get_stocks.deliver_location[k]#";
			else
				sepet.satir[i].deliver_dept = "";
			//ic talepten geliyorsa ya da satinalma satir bazli tekliften geliyorsa
			if((isdefined('attributes.related_order_id') and len(attributes.related_order_id)) or (isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id)) or (isdefined("attributes.offer_row_check_info") and len(attributes.offer_row_check_info)))
			{
				sepet.satir[i].spect_id = get_stocks.SPECT_VAR_ID[k];
				sepet.satir[i].spect_name = get_stocks.SPECT_VAR_NAME[k];
			}
			else
			{
				sepet.satir[i].spect_id = "";
				sepet.satir[i].spect_name = "";
			}
			
			sepet.satir[i].price = 0;
			sepet.satir[i].price_other = 0;
			sepet.satir[i].other_money = session.ep.money;
			
			sepet.satir[i].lot_no = get_stocks.LOT_NO[k];
			
			//isbak add_option(add_company_to_order) icin duzenlendi, silmeyiniz
			if(isdefined("attributes.list_price_discount_1_#k#") && len(evaluate("attributes.list_price_discount_1_#k#")))
				sepet.satir[i].indirim1 = evaluate("attributes.list_price_discount_1_#k#");
			else if(isdefined("get_stocks.discount_1") && len(evaluate("get_stocks.discount_1[#k#]")))
				sepet.satir[i].indirim1 = evaluate("get_stocks.discount_1[#k#]");
			else
				sepet.satir[i].indirim1 = 0;
			if(isdefined("attributes.list_price_discount_2_#k#") && len(evaluate("attributes.list_price_discount_2_#k#")))
				sepet.satir[i].indirim2 = evaluate("attributes.list_price_discount_2_#k#");
			else if(isdefined("get_stocks.discount_2") && len(evaluate("get_stocks.discount_2[#k#]")))
				sepet.satir[i].indirim2 = evaluate("get_stocks.discount_2[#k#]");
			else
				sepet.satir[i].indirim2 = 0;
			if(isdefined("attributes.list_price_discount_3_#k#") && len(evaluate("attributes.list_price_discount_3_#k#")))
				sepet.satir[i].indirim3 = evaluate("attributes.list_price_discount_3_#k#");
			else if(isdefined("get_stocks.discount_3") && len(evaluate("get_stocks.discount_3[#k#]")))
				sepet.satir[i].indirim3 = evaluate("get_stocks.discount_3[#k#]");
			else
				sepet.satir[i].indirim3 = 0;
			if(isdefined("attributes.list_price_discount_4_#k#") && len(evaluate("attributes.list_price_discount_4_#k#")))
				sepet.satir[i].indirim4 = evaluate("attributes.list_price_discount_4_#k#");
			else if(isdefined("get_stocks.discount_4") && len(evaluate("get_stocks.discount_4[#k#]")))
				sepet.satir[i].indirim4 = evaluate("get_stocks.discount_4[#k#]");
			else
				sepet.satir[i].indirim4 = 0;
			if(isdefined("attributes.list_price_discount_5_#k#") && len(evaluate("attributes.list_price_discount_5_#k#")))
				sepet.satir[i].indirim5 = evaluate("attributes.list_price_discount_5_#k#");
			else if(isdefined("get_stocks.discount_5") && len(evaluate("get_stocks.discount_5[#k#]")))
				sepet.satir[i].indirim5 = evaluate("get_stocks.discount_5[#k#]");
			else
				sepet.satir[i].indirim5 = 0;
			if(isdefined("get_stocks.discount_6") && len(evaluate("get_stocks.discount_6[#k#]")))
				sepet.satir[i].indirim6 = evaluate("get_stocks.discount_6[#k#]");
			else
				sepet.satir[i].indirim6 = 0;
			if(isdefined("get_stocks.discount_7") && len(evaluate("get_stocks.discount_7[#k#]")))
				sepet.satir[i].indirim7 = evaluate("get_stocks.discount_7[#k#]");
			else
				sepet.satir[i].indirim7 = 0;
			if(isdefined("get_stocks.discount_8") && len(evaluate("get_stocks.discount_8[#k#]")))
				sepet.satir[i].indirim8 = evaluate("get_stocks.discount_8[#k#]");
			else
				sepet.satir[i].indirim8 = 0;
			if(isdefined("get_stocks.discount_9") && len(evaluate("get_stocks.discount_9[#k#]")))
				sepet.satir[i].indirim9 = evaluate("get_stocks.discount_9[#k#]");
			else
				sepet.satir[i].indirim9 = 0;
			if(isdefined("get_stocks.discount_10") && len(evaluate("get_stocks.discount_10[#k#]")))
				sepet.satir[i].indirim10 = evaluate("get_stocks.discount_10[#k#]");
			else
				sepet.satir[i].indirim10 = 0;

			if(isdefined("get_stocks.discount_cost") && len(evaluate("get_stocks.discount_cost[#k#]")))
				sepet.satir[i].iskonto_tutar = evaluate("get_stocks.discount_cost[#k#]");
			else
				sepet.satir[i].iskonto_tutar = 0;
			/*sepet.satir[i].indirim6 = 0;
			sepet.satir[i].indirim7 = 0;
			sepet.satir[i].indirim8 = 0;
			sepet.satir[i].indirim9 = 0;
			sepet.satir[i].indirim10 = 0;*/
			
			promotion_price = 0;
			sql_promotion = "SELECT * FROM GET_PROMOTION_ALL WHERE PRODUCT_ID = #get_stocks.product_id[k]#";
			get_promotion = cfquery(SQLString : sql_promotion, Datasource : DSN3,dbtype:'query');
			if(get_promotion.recordcount)//aksiyonda kayıt varsa
			{
				if(len(get_promotion.PURCHASE_PRICE))
				{
					promotion_price = 1;
					sepet.satir[i].price = get_promotion.PURCHASE_PRICE;
					sepet.satir[i].price_other = get_promotion.PURCHASE_PRICE;
					if(len(get_promotion.PRICE_CATID))sepet.satir[i].price_cat = get_promotion.PRICE_CATID;					
					if(len(get_promotion.MONEY))sepet.satir[i].other_money = get_promotion.MONEY;
					if(sepet.satir[i].other_money is not session.ep.money)
					{
						for (mm = 1; mm lte get_money_bskt.recordcount;mm=mm+1)
						{
							if(sepet.satir[i].other_money eq get_money_bskt.MONEY_TYPE[mm])
							{
								sepet.satir[i].price = get_promotion.PURCHASE_PRICE * get_money_bskt.rate2[mm];
							}
						}
					}
				}
				if(len(get_promotion.DISCOUNT1))sepet.satir[i].indirim1 = get_promotion.DISCOUNT1;
				if(len(get_promotion.DISCOUNT2))sepet.satir[i].indirim2 = get_promotion.DISCOUNT2;
				if(len(get_promotion.DISCOUNT3))sepet.satir[i].indirim3 = get_promotion.DISCOUNT3;
				if(len(get_promotion.DISCOUNT4))sepet.satir[i].indirim4 = get_promotion.DISCOUNT4;
				if(len(get_promotion.DISCOUNT5))sepet.satir[i].indirim5 = get_promotion.DISCOUNT5;
				if(len(get_promotion.DISCOUNT6))sepet.satir[i].indirim6 = get_promotion.DISCOUNT6;
				if(len(get_promotion.DISCOUNT7))sepet.satir[i].indirim7 = get_promotion.DISCOUNT7;
				if(len(get_promotion.DISCOUNT8))sepet.satir[i].indirim8 = get_promotion.DISCOUNT8;
				if(len(get_promotion.DISCOUNT9))sepet.satir[i].indirim9 = get_promotion.DISCOUNT9;
				if(len(get_promotion.DISCOUNT10))sepet.satir[i].indirim10 = get_promotion.DISCOUNT10;
			}
			else
			{
				if( not (isdefined('attributes.order_all_products') and attributes.order_all_products eq 1) and isdefined('attributes.comp_id') and len(attributes.comp_id))
				{
					sql_contract  = "SELECT * FROM GET_CONTRACT_ALL WHERE COMPANY_ID = #attributes.comp_id# AND PRODUCT_ID = #get_stocks.product_id[k]#";
					get_contract = cfquery(SQLString : sql_contract, Datasource : DSN3,dbtype:'query');
				}
				else
					get_contract.recordcount =0;
					
				if(get_contract.recordcount)//anlasmada sirketli kayıt varmi?
				{
					if(len(get_contract.DISCOUNT1))sepet.satir[i].indirim1 = get_contract.DISCOUNT1;
					if(len(get_contract.DISCOUNT2))sepet.satir[i].indirim2 = get_contract.DISCOUNT2;
					if(len(get_contract.DISCOUNT3))sepet.satir[i].indirim3 = get_contract.DISCOUNT3;
					if(len(get_contract.DISCOUNT4))sepet.satir[i].indirim4 = get_contract.DISCOUNT4;
					if(len(get_contract.DISCOUNT5))sepet.satir[i].indirim5 = get_contract.DISCOUNT5;
				}
				else
				{
					sql_contract2 = "SELECT * FROM GET_CONTRACT_ALL WHERE PRODUCT_ID = #get_stocks.product_id[k]#";
					get_contract2 = cfquery(SQLString : sql_contract2, Datasource : DSN3,dbtype:'query');	
					if(get_contract2.recordcount)//anlasmada kayıt varmi?
					{
						if(len(get_contract2.DISCOUNT1))sepet.satir[i].indirim1 = get_contract2.DISCOUNT1;
						if(len(get_contract2.DISCOUNT2))sepet.satir[i].indirim2 = get_contract2.DISCOUNT2;
						if(len(get_contract2.DISCOUNT3))sepet.satir[i].indirim3 = get_contract2.DISCOUNT3;
						if(len(get_contract2.DISCOUNT4))sepet.satir[i].indirim4 = get_contract2.DISCOUNT4;
						if(len(get_contract2.DISCOUNT5))sepet.satir[i].indirim5 = get_contract2.DISCOUNT5;
					}
				}
			}		
			//sepet.satir[i].net_maliyet = 0;	
			if (isdefined("get_stocks.COST_PRICE") and len(get_stocks.COST_PRICE[k])) sepet.satir[i].net_maliyet = get_stocks.COST_PRICE[k]; else sepet.satir[i].net_maliyet=0;
			if (isdefined("get_stocks.EXTRA_COST") and len(get_stocks.EXTRA_COST[k])) sepet.satir[i].extra_cost = get_stocks.EXTRA_COST[k]; else sepet.satir[i].extra_cost =0; 
			sepet.satir[i].marj = 0;			
			sepet.satir[i].unit = get_stocks.MAIN_UNIT[k];
			sepet.satir[i].manufact_code = get_stocks.MANUFACT_CODE[k];
			sepet.satir[i].unit_id = get_stocks.PRODUCT_UNIT_ID[k];		
			sepet.satir[i].row_unique_relation_id = "";
			if(isdefined('get_stocks.UNIT2') and len(get_stocks.UNIT2[k])) sepet.satir[i].unit_other = get_stocks.UNIT2[k]; else sepet.satir[i].unit_other = "";
			if(isdefined('get_stocks.AMOUNT2') and len(get_stocks.AMOUNT2[k])) sepet.satir[i].amount_other = get_stocks.AMOUNT2[k]; else sepet.satir[i].amount_other = "";
			if(isdefined("row_project_id_list_") and len(get_stocks.ROW_PROJECT_ID[i]))
			{
				sepet.satir[i].row_project_id=get_stocks.ROW_PROJECT_ID[i];
				sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,get_stocks.ROW_PROJECT_ID[i])];
			}	
			if(isdefined("row_work_id_list_") and len(get_stocks.ROW_WORK_ID[i]))
			{
				sepet.satir[i].row_work_id=get_stocks.ROW_WORK_ID[i];
				sepet.satir[i].row_work_name=GET_ROW_WORKS.WORK_HEAD[listfind(row_work_id_list_,get_stocks.ROW_WORK_ID[i])];
			}	
			if( len(get_stocks.BASKET_EXTRA_INFO_ID[i]) ) sepet.satir[i].basket_extra_info = get_stocks.BASKET_EXTRA_INFO_ID[i]; else sepet.satir[i].basket_extra_info="";
			if( len(get_stocks.SELECT_INFO_EXTRA[i]) ) sepet.satir[i].select_info_extra = get_stocks.SELECT_INFO_EXTRA[i]; else sepet.satir[i].select_info_extra="";
			if( len(get_stocks.DETAIL_INFO_EXTRA[i]) ) sepet.satir[i].detail_info_extra = get_stocks.DETAIL_INFO_EXTRA[i]; else sepet.satir[i].detail_info_extra="";
			if(isdefined("basket_emp_id_list") and len(get_stocks.BASKET_EMPLOYEE_ID[i]))
			{	
				sepet.satir[i].basket_employee_id = get_stocks.BASKET_EMPLOYEE_ID[i]; 
				sepet.satir[i].basket_employee = GET_BASKET_EMPLOYEES.BASKET_EMPLOYEE[listfind(basket_emp_id_list,get_stocks.BASKET_EMPLOYEE_ID[i])]; 
			}
			else
			{		
				sepet.satir[i].basket_employee_id = '';
				sepet.satir[i].basket_employee = '';
			}
			//ic talepten geliyorsa ya da satinalma satir bazli tekliften geliyorsa
			if(isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id) or isdefined("attributes.offer_row_check_info") and len(attributes.offer_row_check_info) or isdefined("attributes.related_order_id") and len(attributes.related_order_id)) //FBS 20090119 talepten geliyorsa
			{
				if(len(get_stocks.PRODUCT_NAME2[k]))
					sepet.satir[i].product_name_other = get_stocks.PRODUCT_NAME2[k];
			}
			else
				sepet.satir[i].product_name_other = "";

			if(isdefined("get_stocks.EXTRA_PRICE_TOTAL") and len(get_stocks.EXTRA_PRICE_TOTAL[k]) and get_stocks.EXTRA_PRICE_TOTAL[k] neq 0)
			{
				sepet.satir[i].ek_tutar=(get_stocks.EXTRA_PRICE_TOTAL[k]/get_stocks.QUANTITY[k]);
				sepet.satir[i].ek_tutar_total=(get_stocks.EXTRA_PRICE_TOTAL[k]/get_stocks.QUANTITY[k])*sepet.satir[i].amount;
				sepet.satir[i].ek_tutar_other_total=(get_stocks.EXTRA_PRICE_TOTAL[k]/get_stocks.QUANTITY[k])*sepet.satir[i].amount;
			}
			else
			{
				sepet.satir[i].ek_tutar=0;
				sepet.satir[i].ek_tutar_total=0;
				sepet.satir[i].ek_tutar_other_total=0;
			}
			sepet.satir[i].shelf_number = "";
			if(isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id)) //FBS 20090119 talepten geliyorsa
			{	if(len(get_stocks.INT_TAX[k]))
					sepet.satir[i].tax_percent = get_stocks.INT_TAX[k];
			}
			else if(isdefined("attributes.offer_row_check_info") and len(attributes.offer_row_check_info))
			{
				if(len(get_stocks.ORW_TAX[k]))
					sepet.satir[i].tax_percent = get_stocks.ORW_TAX[k];
			}
			else if(len(get_stocks.TAX_PURCHASE[k]))
				sepet.satir[i].tax_percent = get_stocks.TAX_PURCHASE[k];
			else if(len(get_stocks.TAX))
				sepet.satir[i].tax_percent = get_stocks.TAX_PURCHASE[k];
			else
				sepet.satir[i].tax_percent = 0;
			
			if(isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id)){
				if(len(get_stocks.otv_oran[k]))
					sepet.satir[i].otv_oran = get_stocks.otv_oran[k];
				if(len(get_stocks.OTVTOTAL[k]))
					sepet.satir[i].row_otvtotal = get_stocks.OTVTOTAL[k];
			}else{
				sepet.satir[i].otv_oran = 0; //ozel tuketim vergisi
				sepet.satir[i].row_otvtotal = 0; //otv satır toplam tutarı
			}
			
			if (isdefined('attributes.phl_price_catid_') and len(attributes.phl_price_catid_) and attributes.phl_price_catid_ neq -2)
			{
				/*iç talep satınalma siparişine dönüştürme sayfasında xmle baglı fiyat listesi secilebiliyor. fiyat listesi seçilmiş ise ürün satır fiyatları o fiyat listesinden getiriliyor. 
				seçilen fiyat listesinde sipariş tarihinde geçerli fiyatı yoksa, standart fiyattan değer getirilir*/
				if(len(price_prod_list) and listfind(price_prod_list,get_stocks.product_id[k]))
				{
					if(promotion_price eq 0)
					{
						sql_row_price_  = "SELECT * FROM GET_NEW_PRICE_ALL_ WHERE PRODUCT_ID =#get_stocks.product_id[k]#";
						get_row_price_ = cfquery(SQLString : sql_row_price_, Datasource : DSN3,dbtype:'query');
						if((session.ep.period_year gte 2009 and get_row_price_.MONEY is 'YTL') or (session.ep.period_year lt 2009 and get_row_price_.MONEY is 'TL'))
							sepet.satir[i].other_money=session.ep.money;
						else
							sepet.satir[i].other_money = get_row_price_.MONEY;
						sepet.satir[i].price_other = get_row_price_.PRICE;
						sepet.satir[i].price_cat=attributes.phl_price_catid_;	
					}
				}
				else if(len(get_stocks.PRICE[k]))
				{
					if((session.ep.period_year gte 2009 and get_stocks.MONEY[k] is 'YTL') or (session.ep.period_year lt 2009 and get_stocks.MONEY[k] is 'TL'))
						sepet.satir[i].other_money=session.ep.money;
					else
						sepet.satir[i].other_money = get_stocks.MONEY[k];//Ürün para birimini yaz
					sepet.satir[i].price_other = get_stocks.PRICE[k];
					sepet.satir[i].price_cat=-1;
				}
				if(sepet.satir[i].other_money is not session.ep.money)
				{
					for (tt2=1; tt2 lte get_money_bskt.recordcount;tt2=tt2+1)
					{
						if(sepet.satir[i].other_money eq get_money_bskt.MONEY_TYPE[tt2])
						{
							sepet.satir[i].price = sepet.satir[i].price_other * get_money_bskt.rate2[tt2];
							sepet.satir[i].list_price =sepet.satir[i].price;
						}
					}
				}
				else
				{
					sepet.satir[i].price =sepet.satir[i].price_other;
					sepet.satir[i].list_price =sepet.satir[i].price;
				}			
			}
			else
			{
				if(isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id)) //FBS 20090119 talepten geliyorsa
				{
					sepet.satir[i].other_money = get_stocks.INT_OTHER_MONEY[k];
					if(sepet.satir[i].other_money is not session.ep.money)
					{
						for (tt = 1; tt lte get_money_bskt.recordcount;tt=tt+1)
						{
							if(sepet.satir[i].other_money eq get_money_bskt.MONEY_TYPE[tt])
							{
								sepet.satir[i].price = get_stocks.INT_PRICE_OTHER[k] * get_money_bskt.rate2[tt];
								sepet.satir[i].price_other = get_stocks.INT_PRICE_OTHER[k] ;
							}
						}
					}
					else
					{
						if(isdefined("attributes.price#k#") && len(evaluate("attributes.price#k#")))//isbak add_option(add_company_to_order) icin duzenlendi, silmeyiniz
						{
							sepet.satir[i].price = evaluate("attributes.price#k#");
							sepet.satir[i].price_other = evaluate("attributes.price_other#k#");
							
						}
						else
						{
							sepet.satir[i].price = get_stocks.INT_PRICE[k];
							sepet.satir[i].price_other = get_stocks.INT_PRICE_OTHER[k];
						}
					}					
				}
				else if(isdefined("attributes.offer_row_check_info") and len(attributes.offer_row_check_info))
				{
					sepet.satir[i].price = get_stocks.ORW_PRICE[k];
					sepet.satir[i].price_other = get_stocks.ORW_PRICE_OTHER[k];
					sepet.satir[i].other_money = get_stocks.ORW_OTHER_MONEY[k];
				}
				else if(len(get_stocks.PRICE[k]))
				{
					if((session.ep.period_year gte 2009 and get_stocks.MONEY[k] is 'YTL') or (session.ep.period_year lt 2009 and get_stocks.MONEY[k] is 'TL'))
						sepet.satir[i].other_money=session.ep.money;
					else
						sepet.satir[i].other_money = get_stocks.MONEY[k];//Ürün para birimini yaz
					if(sepet.satir[i].other_money is not session.ep.money)
					{
						for (tt = 1; tt lte get_money_bskt.recordcount;tt=tt+1)
						{
							if(sepet.satir[i].other_money eq get_money_bskt.MONEY_TYPE[tt])
							{
								sepet.satir[i].price = get_stocks.PRICE[k] * get_money_bskt.rate2[tt];
								sepet.satir[i].price_other = get_stocks.PRICE[k];
							}
						}
					}
					else
					{
						sepet.satir[i].price = get_stocks.PRICE[k] ;
						sepet.satir[i].price_other = get_stocks.PRICE[k];
					}					
				}
			}
			if(not len(sepet.satir[i].price_other))
			{
				sepet.satir[i].price_other = sepet.satir[i].price;
				sepet.satir[i].other_money = session.ep.money;
			}
			
			sepet.satir[i].other_money_value = sepet.satir[i].price_other * sepet.satir[i].amount;//Satır Döviz Tutarı
			sepet.satir[i].other_money_grosstotal = sepet.satir[i].other_money_value + ((sepet.satir[i].other_money_value * get_stocks.TAX_PURCHASE[k])/100);//Satır Döviz Vergi Toplamı
			
			sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
			sepet.satir[i].row_total = sepet.satir[i].amount * sepet.satir[i].price;
			sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan,price_round_number);
			sepet.satir[i].row_taxtotal = wrk_round(sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100),price_round_number);
			sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
			
			sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
			sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
			sepet.net_total = sepet.net_total + sepet.satir[i].row_nettotal; //nettotal_
			sepet.satir[i].assortment_array = ArrayNew(1);
			
			// kdv array
			kdv_flag = 0;
			for (kk=1;kk lte arraylen(sepet.kdv_array);kk=kk+1)
				{
				if (sepet.kdv_array[kk][1] eq sepet.satir[i].tax_percent)
					{
					kdv_flag = 1;
					sepet.kdv_array[kk][2] = sepet.kdv_array[kk][2] + 0;
					if (ListFindNoCase(display_list, "otv_from_tax_price"))
					sepet.kdv_array[kk][3] = sepet.kdv_array[kk][3] + wrk_round((sepet.satir[i].row_nettotal+sepet.satir[i].row_otvtotal),basket_total_round_number);
				else
					sepet.kdv_array[kk][3] = sepet.kdv_array[kk][3] + wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);		
					}
				}
			if (not kdv_flag)
				{
				sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = sepet.satir[i].tax_percent;
				sepet.kdv_array[arraylen(sepet.kdv_array)][2] = 0;
				if (ListFindNoCase(display_list, "otv_from_tax_price"))
				sepet.kdv_array[arraylen(sepet.kdv_array)][3] = wrk_round((sepet.satir[i].row_nettotal+sepet.satir[i].row_otvtotal),basket_total_round_number);
			else
				sepet.kdv_array[arraylen(sepet.kdv_array)][3] = wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);
				}
			
			
			// ötv array
			otv_flag = 0;
			for (z=1;z lte arraylen(sepet.otv_array);z=z+1)
				{
				if (sepet.otv_array[z][1] eq sepet.satir[i].otv_oran)
					{
					otv_flag = 1;
					sepet.otv_array[z][2] = sepet.otv_array[z][2] + sepet.satir[i].row_otvtotal;
					}
				}
			if (not otv_flag)
				{
				sepet.otv_array[arraylen(sepet.otv_array)+1][1] = sepet.satir[i].otv_oran;
				sepet.otv_array[arraylen(sepet.otv_array)][2] = sepet.satir[i].row_otvtotal;
				}

				/*Masraf Merkezi*/
				if( len(GET_STOCKS.EXPENSE_CENTER_ID[i]) )
				{
					sepet.satir[i].row_exp_center_id = GET_STOCKS.EXPENSE_CENTER_ID[i];
					sepet.satir[i].row_exp_center_name = GET_STOCKS.EXPENSE[i];
				}
		
				//Aktivite Tipi
				sepet.satir[i].row_activity_id = GET_STOCKS.ACTIVITY_TYPE_ID[i];
		
				//Bütçe Kalemi
				if( len(GET_STOCKS.EXPENSE_ITEM_ID[i]) )
				{
					sepet.satir[i].row_exp_item_id = GET_STOCKS.EXPENSE_ITEM_ID[i];
					sepet.satir[i].row_exp_item_name = GET_STOCKS.EXPENSE_ITEM_NAME[i];
				}
		
				//Muhasebe Kodu
				if(len(GET_STOCKS.ACC_CODE[i]))
				{
					sepet.satir[i].row_acc_code = GET_STOCKS.ACC_CODE[i];
				}

				sepet.satir[i].row_oiv_rate = ( len( GET_STOCKS.OIV_RATE ) ) ? GET_STOCKS.OIV_RATE : '';
				sepet.satir[i].row_oiv_amount = ( len( GET_STOCKS.OIV_AMOUNT ) ) ? GET_STOCKS.OIV_AMOUNT : '';
				sepet.satir[i].row_bsmv_rate = ( len( GET_STOCKS.BSMV_RATE ) ) ? GET_STOCKS.BSMV_RATE : '';
				sepet.satir[i].row_bsmv_amount = ( len( GET_STOCKS.BSMV_AMOUNT ) ) ? GET_STOCKS.BSMV_AMOUNT : '';
				sepet.satir[i].row_bsmv_currency = ( len( GET_STOCKS.BSMV_CURRENCY ) ) ? GET_STOCKS.BSMV_CURRENCY : '';
				sepet.satir[i].row_tevkifat_rate = ( len( GET_STOCKS.TEVKIFAT_RATE ) ) ? GET_STOCKS.TEVKIFAT_RATE : '';
				sepet.satir[i].row_tevkifat_amount = ( len( GET_STOCKS.TEVKIFAT_AMOUNT ) ) ? GET_STOCKS.TEVKIFAT_AMOUNT : '';
		}
			if(isdefined("attributes.other_money_#k#") && len(evaluate("attributes.other_money_#k#")))//isbak add_option(add_company_to_order) icin duzenlendi, silmeyiniz
		sepet.satir[i].other_money = evaluate("attributes.other_money_#k#");
	}
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
		
	
	for (t=1;t lte arraylen(sepet.otv_array);t=t+1)
		sepet.total_otv = sepet.total_otv + wrk_round(sepet.otv_array[t][2],price_round_number);
	
	sepet.net_total = sepet.net_total + sepet.total_tax + sepet.total_otv;
</cfscript>
</cfif>

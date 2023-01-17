<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfinclude template="check_our_period.cfm"> 
<cfquery name="GET_NUMBER" datasource="#dsn2#">
	SELECT SHIP_ID, SHIP_NUMBER, IS_WITH_SHIP, SHIP_TYPE FROM SHIP WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd_id#">
</cfquery>
<cfif not get_number.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='537.Böyle Bir İrsaliye Kaydı Bulunamadı'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.welcome</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfinclude template="get_process_cat.cfm">
<cfset attributes.SHIP_TYPE = get_process_type.process_type>
<cfif form.del_ship eq 1>
	<cfinclude template="upd_dispatch_del.cfm">
	<cfabort>
</cfif>

<cfif attributes.rows_ eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='815.Ürün Seçiniz !'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>
	<cfabort>	
</cfif>

<cfquery name="GET_UNIQUE" datasource="#DSN2#">
	SELECT 
		SHIP_NUMBER,
		PURCHASE_SALES,
		SHIP_ID
	FROM 
		SHIP
	WHERE 
		SHIP_NUMBER = '#SHIP_NUMBER#' AND 
		PURCHASE_SALES = 1
</cfquery>

<cfif get_unique.recordcount and get_unique.ship_id neq attributes.upd_id>
	<script type="text/javascript">
		alert("<cf_get_lang no='32.Fiş Numaranızı Kontrol Ediniz !'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>
	<cfabort>	
</cfif>

<!--- history --->
<cfinclude template="add_ship_history.cfm">

<cfif len(attributes.DELIVER_DATE_FRM)>
	<cf_date tarih = 'attributes.DELIVER_DATE_FRM'>
	<cfset attributes.PROCESS_DATE=attributes.DELIVER_DATE_FRM>
</cfif>
<cf_date tarih = 'attributes.SHIP_DATE'>
<cfset attributes.deliver_date_frm = createdatetime(year(attributes.deliver_date_frm),month(attributes.deliver_date_frm),day(attributes.deliver_date_frm),attributes.deliver_date_h,attributes.deliver_date_m,0)>
<cfif len(attributes.LOCATION_IN_ID)>
	<cfset int_loc_in = attributes.LOCATION_IN_ID>
	<cfset int_dep_in = attributes.DEPARTMENT_IN_ID>
<cfelse>
	<cfset int_loc_in = "NULL">
	<cfset int_dep_in = attributes.DEPARTMENT_IN_ID>
</cfif>
<cfif len(attributes.LOCATION_ID)>
	<cfset attributes.LOCATION_ID_OUT = attributes.LOCATION_ID>
	<cfset attributes.DEPARTMENT_ID_OUT = attributes.DEPARTMENT_ID>
<cfelse>
	<cfset attributes.LOCATION_ID_OUT = "NULL">
	<cfset attributes.DEPARTMENT_ID_OUT = attributes.DEPARTMENT_ID>
</cfif>
 
<cftransaction>
	<cfquery name="UPD_SALE" datasource="#DSN2#">
		UPDATE
			SHIP
		SET
			SHIP_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SHIP_NUMBER#">,
			<cfif len(attributes.SHIP_TYPE)>SHIP_TYPE = #attributes.SHIP_TYPE#,</cfif>
			PROCESS_CAT=#attributes.PROCESS_CAT#,
		<cfif isDefined('attributes.SHIP_METHOD') and len(attributes.SHIP_METHOD)>
			SHIP_METHOD = #attributes.SHIP_METHOD#,
		</cfif>
			SHIP_DATE = #attributes.SHIP_DATE#,
			SHIP_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
			<cfif len(attributes.DELIVER_DATE_FRM)>DELIVER_DATE = #attributes.DELIVER_DATE_FRM#,</cfif>
			DELIVER_EMP = <cfif isdefined("attributes.deliver_get") and len(attributes.deliver_get)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.deliver_get#"><cfelse>NULL</cfif>,
			DELIVER_EMP_ID= <cfif isdefined("attributes.deliver_get_id") and len(attributes.deliver_get_id)>#attributes.deliver_get_id#<cfelse>NULL</cfif>,
			DISCOUNTTOTAL = <cfif isdefined("attributes.BASKET_DISCOUNT_TOTAL")>#attributes.BASKET_DISCOUNT_TOTAL#,<cfelse>0,</cfif>
			NETTOTAL = <cfif isdefined("attributes.basket_net_total")>0#attributes.basket_net_total#,<cfelse>0,</cfif>
			GROSSTOTAL = <cfif isdefined("attributes.basket_gross_total")>0#attributes.basket_gross_total#,<cfelse>0,</cfif>
			TAXTOTAL = <cfif isdefined("attributes.basket_tax_total")>0#attributes.basket_tax_total#,<cfelse>0,</cfif>
			OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.basket_money#">,
			OTHER_MONEY_VALUE = #((form.BASKET_NET_TOTAL*form.BASKET_RATE1)/form.BASKET_RATE2)#,
			DELIVER_STORE_ID = #attributes.DEPARTMENT_ID_OUT#,
			LOCATION = #attributes.LOCATION_ID_OUT#,
			DEPARTMENT_IN = #int_dep_in#,
			LOCATION_IN = #int_loc_in#,
			REF_NO = <cfif isdefined("attributes.ref_no") and len(attributes.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#"><cfelse>NULL</cfif>,
			PROJECT_ID = <cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
            PROJECT_ID_IN = <cfif isdefined("attributes.project_id_in") and len(attributes.project_id_in) and len(attributes.project_head_in)>#attributes.project_id_in#<cfelse>NULL</cfif>,
			WORK_ID=<cfif isdefined("attributes.work_id") and len(attributes.work_id) and len(attributes.work_head)>#attributes.work_id#<cfelse>NULL</cfif>,
			IS_SHIP_IPTAL = <cfif isdefined("attributes.irsaliye_iptal") and attributes.irsaliye_iptal eq 1>1,<cfelse>0,</cfif>
			IS_DELIVERED = <cfif isdefined("attributes.is_delivered") and len(int_dep_in) and not isdefined("attributes.irsaliye_iptal")>1,<cfelse>0,</cfif><!--- irsaliye iptal secilmis ise teslim al işlemi uygulanmaz, stok hareketleri iptal edilir. --->
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#
		WHERE
			SHIP_ID = #attributes.UPD_ID#
	</cfquery>	
	<cfquery name="DEL_SHIP_ROWS" datasource="#DSN2#">
		DELETE FROM  SHIP_ROW WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd_id#">
	</cfquery>
	<cfloop from="1" to="#attributes.rows_#" index="i">
		<cf_date tarih="attributes.deliver_date#i#">
		<cfif session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1>
			<cfset dsn_type=dsn2>
			<cfset specer_spec_id=''>
			<cfif not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#'))>
				<cfinclude template="../../objects/query/add_basket_spec.cfm">
			<cfelseif attributes.basket_spect_type eq 7><!--- satırda da guncellenebilmeli bu spec tipinde--->
				<cfset specer_spec_id=evaluate('attributes.spect_id#i#')>
				<cfinclude template="../../objects/query/add_basket_spec.cfm">
			</cfif>
		</cfif>
		<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))>
			<cfset product_name_other_ = evaluate('attributes.product_name_other#i#')>
		</cfif>
        <!---
         <cfif isdefined("attributes.is_delivered")>
        	<cfif len(attributes.DELIVER_DATE_FRM)>
            	<cfset my_date = attributes.DELIVER_DATE_FRM>
            <cfelse>
            	<cfset my_date = attributes.SHIP_DATE>
            </cfif>
            <cfquery name="get_stock_age" datasource="#dsn2#">
                SELECT * FROM
                    (
                        SELECT 
                            I.SHIP_ID,
                            S.PRODUCT_ID,
                            ISNULL(I.DELIVER_DATE,I.SHIP_DATE) AS ISLEM_TARIHI,
                            ISNULL(DATEDIFF(day,I.DELIVER_DATE,#my_date#),DATEDIFF(day,I.SHIP_DATE,#my_date#))  AS GUN_FARKI,
                            IR.AMOUNT
                        FROM 
                            SHIP I WITH (NOLOCK),
                            SHIP_ROW IR WITH (NOLOCK),
                            #dsn3_alias#.STOCKS S
                        WHERE 
                            I.SHIP_ID = IR.SHIP_ID AND
                            S.STOCK_ID=IR.STOCK_ID AND	
                            I.SHIP_TYPE IN(76,87) AND
                            I.IS_SHIP_IPTAL = 0 AND
                            I.SHIP_DATE <= #now()#
                            AND S.STOCK_ID = #evaluate("attributes.stock_id#i#")#
                        UNION ALL
                        SELECT 
                            I.FIS_ID SHIP_ID,
                            S.PRODUCT_ID,
                            I.FIS_DATE ISLEM_TARIHI,
                            DATEDIFF(day,FIS_DATE,#my_date#) + ISNULL(DUE_DATE,0) GUN_FARKI,
                            IR.AMOUNT
                        FROM 
                            STOCK_FIS I,
                            STOCK_FIS_ROW IR,
                            #dsn3_alias#.STOCKS S
                        WHERE 
                            I.FIS_ID = IR.FIS_ID AND
                            S.STOCK_ID=IR.STOCK_ID AND
                            I.FIS_TYPE IN (110,114,115,119) AND
                            I.FIS_DATE <= #now()#
                            AND S.STOCK_ID = #evaluate("attributes.stock_id#i#")#
                    ) T1
                    ORDER BY
                        ISLEM_TARIHI DESC,
                        SHIP_ID DESC
            </cfquery>
            <cfif get_stock_age.recordcount>
                <cfquery name="get_total_stock" datasource="#dsn2#">
                    SELECT 
                        SUM(STOCK_IN-STOCK_OUT) TOTAL_STOCK
                    FROM
                        STOCKS_ROW
                    WHERE
                        PRODUCT_ID = #evaluate("attributes.product_id#i#")#
                        AND PROCESS_DATE <= #NOW()#	
                        AND PROCESS_TYPE NOT IN (81,811)
                </cfquery>
                <cfset genel_agirlikli_toplam=0>
                <cfset toplam_donem_sonu_stok=0>
				<cfif get_total_stock.recordcount>
                    <cfquery name="get_product_detail" dbtype="query">
                        SELECT 
                            AMOUNT AS PURCHASE_AMOUNT,
                            GUN_FARKI
                        FROM 
                            GET_STOCK_AGE 
                        WHERE 
                            PRODUCT_ID = #evaluate("attributes.product_id#i#")#
                    </cfquery>
                    <cfset donem_sonu_stok=get_total_stock.TOTAL_STOCK>
                    <cfset toplam_donem_sonu_stok = toplam_donem_sonu_stok + donem_sonu_stok>
                    <cfset agirlikli_toplam=0>
                    <cfset kalan = donem_sonu_stok>
                    <cfloop query="get_product_detail">
                        <cfif kalan gt 0 and PURCHASE_AMOUNT lte kalan>
                            <cfset kalan = kalan - PURCHASE_AMOUNT>
                            <cfset agırlıklı_toplam=  agırlıklı_toplam + (PURCHASE_AMOUNT*GUN_FARKI)>
                        <cfelseif kalan gt 0 and PURCHASE_AMOUNT gt kalan>
                            <cfset agırlıklı_toplam=  agırlıklı_toplam + (kalan*GUN_FARKI)>
                            <cfset kalan = 0>
                        </cfif>
                    </cfloop>
                </cfif>	
				<cfif toplam_donem_sonu_stok gt 0><cfset 'attributes.set_duedate#i#' = agirlikli_toplam/toplam_donem_sonu_stok></cfif>
            </cfif> 
        </cfif>
        --->
	 	<cfquery name="ADD_SHIP_ROW" datasource="#DSN2#">
			INSERT INTO
				SHIP_ROW
				(
					NAME_PRODUCT,
					SHIP_ID,
					STOCK_ID,
					PRODUCT_ID,
					AMOUNT,
					UNIT,
					UNIT_ID,					
					TAX,
					<cfif len(evaluate("attributes.price#i#"))>
					PRICE,
					</cfif>
					PURCHASE_SALES,
					DISCOUNT,
					DISCOUNT2,
					DISCOUNT3,
					DISCOUNT4,
					DISCOUNT5,
					DISCOUNT6,
					DISCOUNT7,
					DISCOUNT8,
					DISCOUNT9,
					DISCOUNT10,	
                    DISCOUNTTOTAL,
                    GROSSTOTAL,
                    NETTOTAL,
                    TAXTOTAL,				
					DELIVER_DATE,
					DELIVER_DEPT,
					DELIVER_LOC,
					<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>					
					SPECT_VAR_ID,
					SPECT_VAR_NAME,
					</cfif>
					LOT_NO,
					PRICE_OTHER,
					IS_PROMOTION,
					DISCOUNT_COST,
					OTHER_MONEY,
					OTHER_MONEY_VALUE,
					UNIQUE_RELATION_ID,
					PRODUCT_NAME2,
					AMOUNT2,
					UNIT2,
					EXTRA_PRICE,
					EXTRA_PRICE_TOTAL,
					SHELF_NUMBER,
					TO_SHELF_NUMBER,
					PRODUCT_MANUFACT_CODE,
					BASKET_EXTRA_INFO_ID,
                    SELECT_INFO_EXTRA,
                	DETAIL_INFO_EXTRA,
					ROW_INTERNALDEMAND_ID,
					CATALOG_ID,
					OTV_ORAN,
					OTVTOTAL,
					DARA,
					DARALI,
					WRK_ROW_ID,
					WRK_ROW_RELATION_ID,
					WIDTH_VALUE,
					DEPTH_VALUE,
					HEIGHT_VALUE,
					EXTRA_COST,
					ROW_PROJECT_ID,
					COST_PRICE,
                    DUE_DATE,
                    ROW_WORK_ID
                    <cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,EXPENSE_CENTER_ID</cfif>
                    <cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,EXPENSE_ITEM_ID</cfif>
                    <cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
                    <cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,ACC_CODE</cfif>
				)
			VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.product_name#i#'),250)#">,
					#attributes.upd_id#,
					#evaluate("attributes.stock_id#i#")#,
					#evaluate("attributes.product_id#i#")#,
					#evaluate("attributes.amount#i#")#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit#i#')#">,
					#evaluate("attributes.unit_id#i#")#,					
					#evaluate("attributes.tax#i#")#,
					<cfif len(evaluate("attributes.price#i#"))>
					#evaluate("attributes.price#i#")#,
					</cfif>
					1,
					<cfif isdefined('attributes.indirim1#i#') and len(evaluate('attributes.indirim1#i#'))>#evaluate('attributes.indirim1#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim2#i#') and len(evaluate('attributes.indirim2#i#'))>#evaluate('attributes.indirim2#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim3#i#') and len(evaluate('attributes.indirim3#i#'))>#evaluate('attributes.indirim3#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim4#i#') and len(evaluate('attributes.indirim4#i#'))>#evaluate('attributes.indirim4#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim5#i#') and len(evaluate('attributes.indirim5#i#'))>#evaluate('attributes.indirim5#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim6#i#') and len(evaluate('attributes.indirim6#i#'))>#evaluate('attributes.indirim6#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim7#i#') and len(evaluate('attributes.indirim7#i#'))>#evaluate('attributes.indirim7#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim8#i#') and len(evaluate('attributes.indirim8#i#'))>#evaluate('attributes.indirim8#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim9#i#') and len(evaluate('attributes.indirim9#i#'))>#evaluate('attributes.indirim9#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim10#i#') and len(evaluate('attributes.indirim10#i#'))>#evaluate('attributes.indirim10#i#')#<cfelse>NULL</cfif>,
                    #evaluate("attributes.row_total#i#")-evaluate("attributes.row_nettotal#i#")#,
                    #evaluate("attributes.row_lasttotal#i#")#,
                    #evaluate("attributes.row_nettotal#i#")#,
                    #evaluate("attributes.row_taxtotal#i#")#,
					<cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
						#listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
					<cfelseif isdefined('attributes.int_dep_in') and len(attributes.int_dep_in)>
						#attributes.int_dep_in#,
					<cfelse>
						NULL,
					</cfif>
					<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
						#listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
					<cfelseif isdefined('attributes.location_in_id') and len(attributes.location_in_id)>
						#attributes.location_in_id#,
					<cfelse>
						NULL,
					</cfif>
					<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
						#evaluate('attributes.spect_id#i#')#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.spect_name#i#')#">,
					</cfif>
					<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
					0,
					<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#,<cfelse>NULL,</cfif>
					<cfif isdefined('attributes.other_money_#i#')><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.other_money_#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#product_name_other_#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.to_shelf_number#i#') and len(evaluate('attributes.to_shelf_number#i#')) and isdefined('attributes.to_shelf_number_txt#i#') and len(evaluate('attributes.to_shelf_number_txt#i#'))>#evaluate('attributes.to_shelf_number#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and evaluate('attributes.row_ship_id#i#') neq 0 and listlen(evaluate('attributes.row_ship_id#i#'),';') eq 2>#listgetat(evaluate('attributes.row_ship_id#i#'),2,';')#<cfelseif isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and evaluate('attributes.row_ship_id#i#') neq 0>#evaluate('attributes.row_ship_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))>'#evaluate('attributes.otv_oran#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.dara#i#') and len(evaluate('attributes.dara#i#'))>#evaluate('attributes.dara#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.darali#i#') and len(evaluate('attributes.darali#i#'))>#evaluate('attributes.darali#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
					<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
                    <cfif isdefined('attributes.set_duedate#i#') and len(evaluate('attributes.set_duedate#i#'))>#evaluate('attributes.set_duedate#i#')#<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.row_work_id#i#') and len(evaluate('attributes.row_work_id#i#'))>#evaluate('attributes.row_work_id#i#')#<cfelse>NULL</cfif>
                    <cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_center_id#i#')#"></cfif>
					<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_item_id#i#')#"></cfif>
					<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#"></cfif>
					<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.row_acc_code#i#')#"></cfif>
                )
		</cfquery>
	</cfloop>
	<cfquery name="DEL_STOCKS_ROW" datasource="#DSN2#">
		DELETE FROM STOCKS_ROW WHERE UPD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd_id#"> AND PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#">
	</cfquery>
	<cfif not (isdefined("attributes.irsaliye_iptal") and (attributes.irsaliye_iptal eq 1))><!--- irsaliye iptal secili degilse stok hareketi yapılır --->
		<cfif get_process_type.IS_STOCK_ACTION eq 1><!--- Stok hareketi yapılsın --->
			<cfloop from="1" to="#attributes.rows_#" index="i">
				<cfif isdefined('attributes.is_inventory#i#') and evaluate('attributes.is_inventory#i#') eq 1><!--- urun envantere dahilse --->
					<cfinclude template="get_unit_add_fis.cfm">
					<cfif get_unit.recordcount  and len(get_unit.multiplier) >
						<cfset multi=get_unit.multiplier*evaluate("attributes.amount#i#")>
					<cfelse>
						<cfset multi=evaluate("attributes.amount#i#")>
					</cfif>
					<cfset form_spect_main_id="">
					<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
						<cfset form_spect_id="#evaluate('attributes.spect_id#i#')#">
						<cfif len(form_spect_id) and len(form_spect_id)>
							<cfquery name="GET_MAIN_SPECT" datasource="#DSN2#">
								SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form_spect_id#">
							</cfquery>
							<cfif GET_MAIN_SPECT.RECORDCOUNT>
								<cfset form_spect_main_id=GET_MAIN_SPECT.SPECT_MAIN_ID>
							</cfif>
						</cfif>
					</cfif>
                     <cfquery name="GET_KARMA_PRODUCTS" datasource="#dsn2#"><!--- karma koli olan ürünler --->
							SELECT PRODUCT_ID FROM #dsn3_alias#.PRODUCT WHERE PRODUCT_ID IN (#evaluate("attributes.product_id#i#")#) AND IS_KARMA = 1
					</cfquery>
                    <cfif GET_KARMA_PRODUCTS.recordcount>
                            <cfquery name="GET_KARMA_PRODUCT" datasource="#dsn2#">
                                SELECT PRODUCT_ID,STOCK_ID,SPEC_MAIN_ID,PRODUCT_AMOUNT FROM #dsn1_alias#.KARMA_PRODUCTS WHERE KARMA_PRODUCT_ID =#evaluate("attributes.product_id#i#")#
                            </cfquery>
                    		<cfif GET_KARMA_PRODUCT.recordcount>
            						<cfloop query="GET_KARMA_PRODUCT"> 
										<cfif len(GET_KARMA_PRODUCT.SPEC_MAIN_ID)><!--- karma koli satırındaki urun için spec seçilmisse, hem o ürün hem de sevkte birleştirilen urunleri için stok hareketi yazılır --->
                                                <cfquery name="GET_SPEC_PRODUCT" datasource="#dsn2#">
                                                    SELECT 
                                                        PRODUCT_ID,
                                                        STOCK_ID,
                                                        AMOUNT,
                                                        RELATED_MAIN_SPECT_ID
                                                    FROM
                                                        #dsn3_alias#.SPECT_MAIN_ROW
                                                    WHERE
                                                        IS_SEVK = 1 AND
                                                        STOCK_ID IS NOT NULL AND
                                                        PRODUCT_ID IS NOT NULL AND
                                                        SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_KARMA_PRODUCT.SPEC_MAIN_ID#">
                                                </cfquery>
                                            <cfif GET_SPEC_PRODUCT.recordcount>
                                                <cfloop query="GET_SPEC_PRODUCT">
                                                     <cfquery name="ADD_STOCK_ROW" datasource="#DSN2#">
                                                            INSERT INTO 
                                                                STOCKS_ROW
                                                                (
                                                                    PROCESS_DATE,
                                                                    PROCESS_TIME,
                                                                    UPD_ID,
                                                                    PRODUCT_ID,
                                                                    STOCK_ID,
                                                                    PROCESS_TYPE,
                                                                    STOCK_OUT,
                                                                    STORE,
                                                                    STORE_LOCATION,
                                                                <cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
                                                                    SPECT_VAR_ID,
                                                                </cfif>
                                                                    DELIVER_DATE,
                                                                    SHELF_NUMBER, <!--- stock_out işlemlerinde Shelf_number olarak basketteki shelf_number alanı gönderilir. --->
                                                                            
                                                                    AMOUNT2,
                                                                    UNIT2,
                                                                    DEPTH_VALUE,
                                                                    WIDTH_VALUE,
                                                                    HEIGHT_VALUE
                                                                )
                                                            VALUES
                                                                (
                                                                    <cfif len(attributes.DELIVER_DATE_FRM)>#attributes.PROCESS_DATE#<cfelse>#attributes.SHIP_DATE#</cfif>,
                                                                     #attributes.deliver_Date_frm#,
                                                                    #attributes.UPD_ID#,
                                                                    #GET_SPEC_PRODUCT.product_id#,
                                                                    #GET_SPEC_PRODUCT.stock_id#,
                                                                    #attributes.SHIP_TYPE#,
                                                                    #multi*GET_SPEC_PRODUCT.product_amount#,
                                                                    #attributes.DEPARTMENT_ID_OUT#,
                                                                    #attributes.LOCATION_ID_OUT#,
                                                                <cfif isdefined('form_spect_main_id') and len(evaluate('form_spect_main_id'))>
                                                                   <cfif len(GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID)>#GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID#<cfelse>NULL</cfif>,
                                                                </cfif>
                                                                <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                                                                <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                                                                
                                                                <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                                                <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
                                                                <cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
                                                                <cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
                                                                <cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>
                                                                )
                                                        </cfquery>
                                                </cfloop>
                                            </cfif>
                                        </cfif>
                       				<cfquery name="ADD_STOCK_ROW" datasource="#DSN2#">
                                            INSERT INTO 
                                                STOCKS_ROW
                                                (
                                                    PROCESS_DATE,
                                                    PROCESS_TIME,
                                                    UPD_ID,
                                                    PRODUCT_ID,
                                                    STOCK_ID,
                                                    PROCESS_TYPE,
                                                    STOCK_OUT,
                                                    STORE,
                                                    STORE_LOCATION,
                                                <cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
                                                    SPECT_VAR_ID,
                                                </cfif>
                                                    DELIVER_DATE,
                                                    SHELF_NUMBER, <!--- stock_out işlemlerinde Shelf_number olarak basketteki shelf_number alanı gönderilir. --->
                                                   			
                                                    AMOUNT2,
                                                    UNIT2,
                                                    DEPTH_VALUE,
                                                    WIDTH_VALUE,
                                                    HEIGHT_VALUE
                                                )
                                            VALUES
                                                (
                                                    <cfif len(attributes.DELIVER_DATE_FRM)>#attributes.PROCESS_DATE#<cfelse>#attributes.SHIP_DATE#</cfif>,
                                                     #attributes.deliver_Date_frm#,
                                                    #attributes.UPD_ID#,
                                                    #GET_KARMA_PRODUCT.product_id#,
                                    				#GET_KARMA_PRODUCT.stock_id#,
                                                    #attributes.SHIP_TYPE#,
                                                    #multi*GET_KARMA_PRODUCT.product_amount#,
                                                    #attributes.DEPARTMENT_ID_OUT#,
                                                    #attributes.LOCATION_ID_OUT#,
                                                <cfif isdefined('form_spect_main_id') and len(evaluate('form_spect_main_id'))>
                                                   <cfif len(GET_KARMA_PRODUCT.SPEC_MAIN_ID)>#GET_KARMA_PRODUCT.SPEC_MAIN_ID#<cfelse>NULL</cfif>,
                                                </cfif>
                                                <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                                                <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                                                
                                                <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                                <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
                                                <cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
                                                <cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
                                                <cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>
                                                )
                                        </cfquery>
                       			   </cfloop>
           					</cfif>
                    <cfelse>
                        <cfquery name="ADD_STOCK_ROW" datasource="#DSN2#">
                            INSERT INTO 
                                STOCKS_ROW
                                (
                                    PROCESS_DATE,
                                    PROCESS_TIME,
                                    UPD_ID,
                                    PRODUCT_ID,
                                    STOCK_ID,
                                    PROCESS_TYPE,
                                    STOCK_OUT,
                                    STORE,
                                    STORE_LOCATION,
                                <cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
                                    SPECT_VAR_ID,
                                </cfif>
                                    LOT_NO,
                                    DELIVER_DATE,
                                    SHELF_NUMBER, <!--- stock_out işlemlerinde Shelf_number olarak basketteki shelf_number alanı gönderilir. --->
                                    PRODUCT_MANUFACT_CODE,				
                                    AMOUNT2,
                                    UNIT2,
                                    DEPTH_VALUE,
                                    WIDTH_VALUE,
                                    HEIGHT_VALUE
                                )
                            VALUES
                                (
                                <cfif len(attributes.DELIVER_DATE_FRM)>#attributes.PROCESS_DATE#<cfelse>#attributes.SHIP_DATE#</cfif>,
                                 #attributes.deliver_Date_frm#,
                                    #attributes.UPD_ID#,
                                    #evaluate("attributes.product_id#i#")#,
                                    #evaluate("attributes.stock_id#i#")#,
                                    #attributes.SHIP_TYPE#,
                                    #MULTI#,
                                    #attributes.DEPARTMENT_ID_OUT#,
                                    #attributes.LOCATION_ID_OUT#,
                                <cfif isdefined('form_spect_main_id') and len(evaluate('form_spect_main_id'))>
                                    #form_spect_main_id#,
                                </cfif>
                                <cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>
                                )
                        </cfquery>
                    </cfif>
				</cfif>
			</cfloop>
		</cfif>
		<!---  Sevk irsaliyesi teslim alan secilmis --->
		<cfif isdefined("attributes.is_delivered") and len(int_dep_in) and attributes.is_delivered eq 1 and get_process_type.IS_STOCK_ACTION eq 1><!--- Stok hareketi yapılsın --->
		<cfloop from="1" to="#attributes.rows_#" index="i">
			<cfif isdefined('attributes.is_inventory#i#') and evaluate('attributes.is_inventory#i#') eq 1><!--- urun envantere dahilse --->
				<cfinclude template="get_unit_add_fis.cfm">
				<cfif get_unit.recordcount  and len(get_unit.multiplier) >
					<cfset multi=get_unit.multiplier*evaluate("attributes.amount#i#")>
				<cfelse>
					<cfset multi=evaluate("attributes.amount#i#")>
				</cfif>
				<cfset form_spect_main_id="">
				<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
					<cfset form_spect_id="#evaluate('attributes.spect_id#i#')#">
					<cfif len(form_spect_id) and len(form_spect_id)>
						<cfquery name="GET_MAIN_SPECT" datasource="#DSN2#">
							SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECT_VAR_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#form_spect_id#">
						</cfquery>
						<cfif GET_MAIN_SPECT.RECORDCOUNT>
							<cfset form_spect_main_id=GET_MAIN_SPECT.SPECT_MAIN_ID>
						</cfif>
					</cfif>
				</cfif>
                <cfquery name="GET_KARMA_PRODUCTS" datasource="#dsn2#"><!--- karma koli olan ürünler --->
							SELECT PRODUCT_ID FROM #dsn3_alias#.PRODUCT WHERE PRODUCT_ID IN (#evaluate("attributes.product_id#i#")#) AND IS_KARMA = 1
				</cfquery>
                <cfif GET_KARMA_PRODUCTS.recordcount>
                    <cfquery name="GET_KARMA_PRODUCT" datasource="#dsn2#">
                        SELECT PRODUCT_ID,STOCK_ID,SPEC_MAIN_ID,PRODUCT_AMOUNT FROM #dsn1_alias#.KARMA_PRODUCTS WHERE KARMA_PRODUCT_ID =#evaluate("attributes.product_id#i#")#
                    </cfquery>
                    <cfif GET_KARMA_PRODUCT.recordcount>
                        <cfloop query="GET_KARMA_PRODUCT"> 
                        <cfif len(GET_KARMA_PRODUCT.SPEC_MAIN_ID)><!--- karma koli satırındaki urun için spec seçilmisse, hem o ürün hem de sevkte birleştirilen urunleri için stok hareketi yazılır --->
                                    <cfquery name="GET_SPEC_PRODUCT" datasource="#dsn2#">
                                        SELECT 
                                            PRODUCT_ID,
                                            STOCK_ID,
                                            AMOUNT,
                                            RELATED_MAIN_SPECT_ID
                                        FROM
                                            #dsn3_alias#.SPECT_MAIN_ROW
                                        WHERE
                                            IS_SEVK = 1 AND
                                            STOCK_ID IS NOT NULL AND
                                            PRODUCT_ID IS NOT NULL AND
                                            SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_KARMA_PRODUCT.SPEC_MAIN_ID#">
                                    </cfquery>
                                <cfif GET_SPEC_PRODUCT.recordcount>
                                    <cfloop query="GET_SPEC_PRODUCT">
                                          <cfquery name="ADD_STOCK_ROW" datasource="#DSN2#">
                                                INSERT INTO STOCKS_ROW
                                                    (
                                                        PROCESS_DATE,
                                                        PROCESS_TIME,
                                                        UPD_ID,
                                                        PRODUCT_ID,
                                                        STOCK_ID,
                                                        PROCESS_TYPE,
                                                        STOCK_IN,
                                                        STORE,
                                                        STORE_LOCATION,
                                                    <cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
                                                        SPECT_VAR_ID,
                                                    </cfif>
                                                        DELIVER_DATE,
                                                        SHELF_NUMBER,<!--- stock_out işlemlerinde Shelf_number olarak basketteki to_shelf_number alanı gönderilir. --->
                                                       
                                                        AMOUNT2,
                                                        UNIT2,
                                                        DEPTH_VALUE,
                                                        WIDTH_VALUE,
                                                        HEIGHT_VALUE
                                                    )
                                                VALUES
                                                    (
                                                    <cfif len(attributes.DELIVER_DATE_FRM)>#attributes.PROCESS_DATE#<cfelse>#attributes.SHIP_DATE#</cfif>,
                                                     #attributes.deliver_Date_frm#,
                                                        #attributes.UPD_ID#,
                                                        #GET_SPEC_PRODUCT.product_id#,
                                                        #GET_SPEC_PRODUCT.stock_id#,
                                                        #attributes.SHIP_TYPE#,
                                                        #multi*GET_SPEC_PRODUCT.product_amount#,
                                                        #int_dep_in#,
                                                        #int_loc_in#,
                                                    <cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
                                                        <cfif len(GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID)>#GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID#<cfelse>NULL</cfif>,
                                                    </cfif>
                                                    <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                                                    <cfif isdefined('attributes.to_shelf_number#i#') and len(evaluate('attributes.to_shelf_number#i#')) and isdefined('attributes.to_shelf_number_txt#i#') and len(evaluate('attributes.to_shelf_number_txt#i#'))>#evaluate('attributes.to_shelf_number#i#')#<cfelse>NULL</cfif>,
                                                    
                                                    <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                                    <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
                                                    <cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
                                                    <cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
                                                    <cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>
                                                    )
                                            </cfquery>
                                    </cfloop>
                                </cfif>
                        </cfif>
                         <cfquery name="ADD_STOCK_ROW" datasource="#DSN2#">
                            INSERT INTO STOCKS_ROW
                                (
                                    PROCESS_DATE,
                                    PROCESS_TIME,
                                    UPD_ID,
                                    PRODUCT_ID,
                                    STOCK_ID,
                                    PROCESS_TYPE,
                                    STOCK_IN,
                                    STORE,
                                    STORE_LOCATION,
                                <cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
                                    SPECT_VAR_ID,
                                </cfif>
                                    DELIVER_DATE,
                                    SHELF_NUMBER,<!--- stock_out işlemlerinde Shelf_number olarak basketteki to_shelf_number alanı gönderilir. --->
                                   
                                    AMOUNT2,
                                    UNIT2,
                                    DEPTH_VALUE,
                                    WIDTH_VALUE,
                                    HEIGHT_VALUE
                                )
                            VALUES
                                (
                                <cfif len(attributes.DELIVER_DATE_FRM)>#attributes.PROCESS_DATE#<cfelse>#attributes.SHIP_DATE#</cfif>,
                                 #attributes.deliver_Date_frm#,
                                    #attributes.UPD_ID#,
                                    #GET_KARMA_PRODUCT.product_id#,
                                    #GET_KARMA_PRODUCT.stock_id#,
                                    #attributes.SHIP_TYPE#,
                                    #multi*GET_KARMA_PRODUCT.product_amount#,
                                    #int_dep_in#,
                                    #int_loc_in#,
                                <cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
                                    <cfif len(GET_KARMA_PRODUCT.SPEC_MAIN_ID)>#GET_KARMA_PRODUCT.SPEC_MAIN_ID#<cfelse>NULL</cfif>,
                                </cfif>
                                <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.to_shelf_number#i#') and len(evaluate('attributes.to_shelf_number#i#')) and isdefined('attributes.to_shelf_number_txt#i#') and len(evaluate('attributes.to_shelf_number_txt#i#'))>#evaluate('attributes.to_shelf_number#i#')#<cfelse>NULL</cfif>,
                                
                                <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>
                                )
                        </cfquery>
                       </cfloop>
                    </cfif>
                <cfelse>
					<cfquery name="ADD_STOCK_ROW" datasource="#DSN2#">
					INSERT INTO STOCKS_ROW
						(
							PROCESS_DATE,
                            PROCESS_TIME,
							UPD_ID,
							PRODUCT_ID,
							STOCK_ID,
							PROCESS_TYPE,
							STOCK_IN,
							STORE,
							STORE_LOCATION,
						<cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
							SPECT_VAR_ID,
						</cfif>
							LOT_NO,
							DELIVER_DATE,
							SHELF_NUMBER,<!--- stock_out işlemlerinde Shelf_number olarak basketteki to_shelf_number alanı gönderilir. --->
							PRODUCT_MANUFACT_CODE,
							AMOUNT2,
							UNIT2,
							DEPTH_VALUE,
							WIDTH_VALUE,
							HEIGHT_VALUE
						)
					VALUES
						(
						<cfif len(attributes.DELIVER_DATE_FRM)>#attributes.PROCESS_DATE#<cfelse>#attributes.SHIP_DATE#</cfif>,
                         #attributes.deliver_Date_frm#,
							#attributes.UPD_ID#,
							#evaluate("attributes.product_id#i#")#,
							#evaluate("attributes.stock_id#i#")#,
							#attributes.SHIP_TYPE#,
							#MULTI#,
							#int_dep_in#,
							#int_loc_in#,
						<cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
							#form_spect_main_id#,
						</cfif>
						<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.to_shelf_number#i#') and len(evaluate('attributes.to_shelf_number#i#')) and isdefined('attributes.to_shelf_number_txt#i#') and len(evaluate('attributes.to_shelf_number_txt#i#'))>#evaluate('attributes.to_shelf_number#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>
						)
				</cfquery>
                </cfif>
			</cfif>
		</cfloop>
		</cfif>
	</cfif>
	<cfif isdefined("attributes.irsaliye_iptal")>
		<cfscript>
		del_serial_no(
		process_id : attributes.UPD_ID,
		process_cat : form.old_process_type,
		period_id : session.ep.period_id
		);
		</cfscript>
		<!--- seri no kayitlari silinir --->
	</cfif>
    <cfif isdefined("attributes.is_delivered") and  attributes.is_delivered eq 1>
    	<cfquery name="upd_seri" datasource="#dsn2#">
        	SELECT * FROM #dsn3_alias#.SERVICE_GUARANTY_NEW WHERE PROCESS_ID = #attributes.upd_id# AND PERIOD_ID = #session.ep.period_id# AND PROCESS_CAT = 81 AND IN_OUT = 0 AND SERIAL_NO NOT IN (SELECT SERIAL_NO FROM #dsn3_alias#.SERVICE_GUARANTY_NEW WHERE PROCESS_ID = #attributes.upd_id# AND PERIOD_ID = #session.ep.period_id# AND PROCESS_CAT = 81 AND IN_OUT = 1)
        </cfquery>
        <cfif upd_seri.recordcount>
        <cfloop query="upd_seri">
        	 <cfif isDefined('session.ep.userid')>
				<cfset wrk_id = '#UPD_SERI.SERIAL_NO#1' & dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>	
            <cfelse>
                <cfset wrk_id = '#UPD_SERI.SERIAL_NO#1' & dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_'&round(rand()*100)>	                    
            </cfif>
        	 <cfquery name="add_guaranty" datasource="#dsn2#"> 
               INSERT INTO
                    #dsn3_alias#.SERVICE_GUARANTY_NEW
                (
                    WRK_ID,
                    WRK_ROW_ID,
                    STOCK_ID,
                    LOT_NO,
                    RMA_NO,
                    REFERENCE_NO,
                    PURCHASE_GUARANTY_CATID,
                    PURCHASE_START_DATE,
                    PURCHASE_FINISH_DATE,
                    PURCHASE_COMPANY_ID,
                    PURCHASE_CONSUMER_ID,
                    PURCHASE_PARTNER_ID,
                    IN_OUT,
                    IS_SALE,
                    IS_PURCHASE,
                    IS_SERVICE,
                    IS_SARF,
                    IS_RMA,
                    IS_SERI_SONU,
                    IS_RETURN,
                    PROCESS_ID,
                    PROCESS_NO,
                    PROCESS_CAT,
                    PERIOD_ID,
                    DEPARTMENT_ID,
                    LOCATION_ID,
                    SERIAL_NO,
                    SPECT_ID,
	                RECORD_EMP,
                    RECORD_IP,
                    RECORD_DATE
                )
                VALUES
                (
                	'#WRK_ID#',
                    '#upd_seri.WRK_ROW_ID#',
                     #upd_seri.STOCK_ID#,
                    '#upd_seri.LOT_NO#',
                    '#upd_seri.RMA_NO#',
                    '#upd_seri.REFERENCE_NO#',
                    <cfif len(upd_seri.SALE_GUARANTY_CATID)>#upd_seri.SALE_GUARANTY_CATID#<cfelse>NULL</cfif>,
                     <cfif len(upd_seri.SALE_START_DATE)>'#upd_seri.SALE_START_DATE#'<cfelse>NULL</cfif>,
                     <cfif len(upd_seri.SALE_FINISH_DATE)>'#upd_seri.SALE_FINISH_DATE#'<cfelse>NULL</cfif>,
                     <cfif len(upd_seri.SALE_COMPANY_ID)>#upd_seri.SALE_COMPANY_ID#<cfelse>NULL</cfif>,
                     <cfif len(upd_seri.SALE_CONSUMER_ID)>#upd_seri.SALE_CONSUMER_ID#<cfelse>NULL</cfif>,
                     <cfif len(upd_seri.SALE_PARTNER_ID)>#upd_seri.SALE_PARTNER_ID#<cfelse>NULL</cfif>,
                    1,
                    0,
                    1,
                    #upd_seri.IS_SERVICE#,
                    #upd_seri.IS_SARF#,
                    #upd_seri.IS_RMA#,
                    #upd_seri.IS_SERI_SONU#,
                    #upd_seri.IS_RETURN#,
                    #upd_seri.PROCESS_ID#,
                    '#upd_seri.PROCESS_NO#',
                    #upd_seri.PROCESS_CAT#,
                    #upd_seri.PERIOD_ID#,
                    #int_dep_in#,
                    #int_loc_in#,
                    '#upd_seri.SERIAL_NO#',
                    '#upd_seri.SPECT_ID#',
                    #session.ep.userid#,
                    '#cgi.REMOTE_ADDR#',
                    #now()#
                )
              </cfquery>
              </cfloop>
        </cfif>
    </cfif>
    <!--- eğer ürün silinirse girilmiş serilerde delete edilir PY 1114 --->
        <cfquery name="get_stock_info" datasource="#dsn2#">
            DELETE FROM #DSN3_ALIAS#.SERVICE_GUARANTY_NEW 
            WHERE 
                GUARANTY_ID IN (
                                    SELECT 
                                        GUARANTY_ID 
                                    FROM 
                                        #DSN3_ALIAS#.SERVICE_GUARANTY_NEW 
                                    WHERE 
                                        PROCESS_NO = '#ship_number#' 
                                        AND PROCESS_CAT = #get_process_type.process_type# 
                                        AND WRK_ROW_ID NOT IN (SELECT WRK_ROW_ID FROM SHIP_ROW WHERE SHIP_ID = #attributes.upd_id# )
                                        AND WRK_ROW_ID IS NOT NULL
                                        AND WRK_ROW_ID <> ''
                                 )
                                 
        </cfquery>
        <cfquery name="upd_guaranty_old" datasource="#dsn2#">
            UPDATE  
                #dsn3_alias#.SERVICE_GUARANTY_NEW 
            SET
                PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ship_number#">,
                PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_type.process_type#">,
                UPDATE_DATE = #now()#,
                UPDATE_EMP = #session.ep.userid#,
                UPDATE_IP = '#cgi.REMOTE_ADDR#'
            WHERE
                PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd_id#"> AND
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                AND PROCESS_CAT IN (81)
        </cfquery>
	<cfscript>
		if(isdefined("attributes.irsaliye_iptal") and attributes.irsaliye_iptal eq 1) /*irsaliye iptal secilmisse muhasebe hareketi silinir*/
			muhasebe_sil(action_id:attributes.UPD_ID, process_type:form.old_process_type);
		else
		{
			if( len(int_loc_in) and len(int_dep_in)) //giris deposu kontrol ediliyor
			{
				LOCATION_IN=cfquery(datasource:"#dsn2#",sqlstring:"SELECT SL.LOCATION_TYPE,D.BRANCH_ID,IS_SCRAP FROM #dsn_alias#.STOCKS_LOCATION SL, #dsn_alias#.DEPARTMENT D WHERE D.DEPARTMENT_ID=SL.DEPARTMENT_ID AND SL.DEPARTMENT_ID=#int_dep_in# AND SL.LOCATION_ID=#int_loc_in#");
				location_type_in = LOCATION_IN.LOCATION_TYPE;
				branch_id_in=LOCATION_IN.BRANCH_ID;
				is_scrap_in = LOCATION_IN.IS_SCRAP;
			}
			else
			{	location_type_in ='';branch_id_in=''; is_scrap_in='';}

			if( len(attributes.LOCATION_ID_OUT) and len(attributes.DEPARTMENT_ID_OUT)) //cikis deposu kontrol ediliyor
			{
				LOCATION_OUT=cfquery(datasource:"#dsn2#",sqlstring:"SELECT SL.LOCATION_TYPE,D.BRANCH_ID,IS_SCRAP FROM #dsn_alias#.STOCKS_LOCATION SL, #dsn_alias#.DEPARTMENT D WHERE D.DEPARTMENT_ID=SL.DEPARTMENT_ID AND SL.DEPARTMENT_ID=#attributes.DEPARTMENT_ID_OUT# AND SL.LOCATION_ID=#attributes.LOCATION_ID_OUT#");
				location_type_out = LOCATION_OUT.LOCATION_TYPE;
				branch_id_out= LOCATION_OUT.BRANCH_ID;
				is_scrap_out = LOCATION_OUT.IS_SCRAP;
			}
			else
			{	location_type_out ='';branch_id_out= ''; is_scrap_out='';}

			if(get_process_type.is_account eq 1 and (location_type_in neq location_type_out or is_dept_based_acc eq 1))
			{
				include('ship_account_process.cfm');
				muhasebeci(
					action_id :attributes.UPD_ID,
					workcube_process_type : get_process_type.process_type,
					workcube_old_process_type : form.old_process_type,
					workcube_process_cat:attributes.process_cat,
					account_card_type : 13,
					islem_tarihi : attributes.SHIP_DATE,
					borc_hesaplar : str_borclu_hesaplar,
					borc_tutarlar : borc_alacak_tutar,
					other_amount_borc : str_dovizli_tutarlar,
					other_currency_borc : str_doviz_currency,
					borc_miktarlar : str_miktar,
					borc_birim_tutar : str_tutar,
					alacak_hesaplar : str_alacakli_hesaplar,
					alacak_tutarlar : borc_alacak_tutar,
					other_amount_alacak : str_dovizli_tutarlar,
					other_currency_alacak: str_doviz_currency,
					from_branch_id : branch_id_out,
					to_branch_id : branch_id_in,
					alacak_miktarlar : str_miktar,
					alacak_birim_tutar : str_tutar,
					fis_detay : 'DEPO SEVK İRSALİYESİ',
					fis_satir_detay : satir_detay_list,
					belge_no : SHIP_NUMBER,
					is_account_group : get_process_type.is_account_group,
					currency_multiplier : currency_multiplier,
					acc_project_list_alacak : acc_project_list_alacak,
					acc_project_list_borc : acc_project_list_borc
				);
			}
			else
				muhasebe_sil(action_id:attributes.UPD_ID, process_type:form.old_process_type);
		}
		basket_kur_ekle(action_id:attributes.UPD_ID,table_type_id:2,process_type:1);
		if(isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list)) //depo sevk ic talepten olusturulmussa
		{
			add_internaldemand_row_relation(
				to_related_action_id:attributes.UPD_ID,
				to_related_action_type:1,
				is_related_action_iptal :iif((isdefined("attributes.irsaliye_iptal") and (attributes.irsaliye_iptal eq 1)),1,0),
				action_status:1,
				process_db:dsn2
				);
		}
	</cfscript>
	<cf_workcube_process_cat 
		process_cat="#form.process_cat#"
		action_id = "#attributes.upd_id#"
		action_table="SHIP"
		action_column="SHIP_ID"
		is_action_file = 1
		action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch&event=upd&ship_id=#attributes.UPD_ID#'
		action_file_name='#get_process_type.action_file_name#'
		action_db_type = '#dsn2#'
		is_template_action_file = '#get_process_type.action_file_from_template#'>
        <cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#attributes.upd_id#" action_name="#attributes.ship_number# Güncellendi" paper_no="#attributes.ship_number#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">

        <!--- E-İrsaliye Onay islemi--->
        <cfif not isdefined("attributes.irsaliye_iptal") and isdefined("attributes.is_delivered")>
            <cfset ADD_PURCHASE_MAX_ID.IDENTITYCOL = attributes.upd_id>
            <cfinclude template="../../e_government/query/eshipment_approval.cfm" />
        </cfif>
</cftransaction>
  
<cfif session.ep.our_company_info.is_cost eq 1 and get_process_type.IS_COST eq 1><!--- sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor --->
	<cfscript>
		if(not isdefined("attributes.irsaliye_iptal") and isdefined("attributes.is_delivered"))
			cost_action(action_type:2,action_id:attributes.UPD_ID,query_type:2);
		else
			cost_action(action_type:2,action_id:attributes.UPD_ID,query_type:3);
	</cfscript>
</cfif>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch&event=upd&ship_id=#attributes.UPD_ID#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

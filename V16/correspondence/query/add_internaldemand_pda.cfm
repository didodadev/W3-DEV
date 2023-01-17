<cf_get_lang_set module_name="correspondence"><!--- sayfanin en altinda kapanisi var --->
<cfif len(attributes.target_date)>
	<cf_date tarih="attributes.target_date">
</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="get_gen_paper" datasource="#dsn3#">
		SELECT 
			INTERNAL_NO,
			INTERNAL_NUMBER
		FROM
			GENERAL_PAPERS 
		WHERE 
			PAPER_TYPE IS NULL
	</cfquery>
	<cfset paper_code = evaluate('get_gen_paper.INTERNAL_NO')>
	<cfset paper_number = evaluate('get_gen_paper.INTERNAL_NUMBER') +1>
	<cfset paper_full = '#paper_code#-#paper_number#'>
	<cfquery name="SET_MAX_PAPER" datasource="#DSN3#">
		UPDATE
			GENERAL_PAPERS
		SET
			INTERNAL_NUMBER = INTERNAL_NUMBER+1
		WHERE
			PAPER_TYPE IS NULL
	</cfquery>
	<cfquery name="ADD_INTERNALDEMAND" datasource="#dsn3#" result="MAX_ID">
		INSERT INTO 
			INTERNALDEMAND
			(
				INTERNAL_NUMBER,
				TO_POSITION_CODE,
				<cfif len(attributes.from_position_code) and len(attributes.from_position_name)>FROM_POSITION_CODE,</cfif>
				<cfif len(attributes.target_date)>TARGET_DATE,</cfif>
				TOTAL,
				DISCOUNT,
				TOTAL_TAX,
				OTV_TOTAL,
				NET_TOTAL,
				SUBJECT,
				PRIORITY,
				INTERNALDEMAND_STATUS,
				IS_ACTIVE,
				NOTES,
				PROJECT_ID,
				INTERNALDEMAND_STAGE,
				DEPARTMENT_IN,
				LOCATION_IN,
				DEPARTMENT_OUT,
				LOCATION_OUT,
				REF_NO,
				DEMAND_TYPE,
				SHIP_METHOD,
			<cfif isdefined('form.basket_money')>
				OTHER_MONEY,
				OTHER_MONEY_VALUE,
			</cfif>
				RECORD_EMP,
				RECORD_DATE
		)
			VALUES
		(
				'#paper_full#',
				#attributes.TO_POSITION_CODE#,
				<cfif len(attributes.from_position_code) and len(attributes.from_position_name)>#attributes.from_position_code#,</cfif>
				<cfif len(attributes.target_date)>#attributes.target_date#,</cfif>
				<cfif isdefined("attributes.basket_gross_total") and len(attributes.basket_gross_total)>#attributes.basket_gross_total#<cfelse>0</cfif>,
				<cfif isdefined("attributes.basket_discount_total") and len(attributes.basket_discount_total)>#attributes.basket_discount_total#<cfelse>0</cfif>,
				<cfif isdefined("attributes.basket_tax_total") and len(attributes.basket_tax_total)>#attributes.basket_tax_total#<cfelse>0</cfif>,
				<cfif isdefined("attributes.basket_otv_total") and len(attributes.basket_otv_total)>#attributes.basket_otv_total#<cfelse>0</cfif>,
				<cfif isdefined("attributes.basket_net_total") and len(attributes.basket_net_total)>#attributes.basket_net_total#<cfelse>0</cfif>,
				'#attributes.subject#',
				<cfif isdefined('attributes.priority') and len(attributes.priority)>#attributes.priority#<cfelse>NULL</cfif>,
				0,
				<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
				'#attributes.notes#',
				<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				#attributes.process_stage#,
				<cfif isdefined('attributes.department_in_id') and len(attributes.department_in_id)>#attributes.department_in_id#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.location_in_id') and len(attributes.location_in_id)>#attributes.location_in_id#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.department_id') and len(attributes.department_id)>#attributes.department_id#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.location_id') and len(attributes.location_id)>#attributes.location_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.ref_no") and len(attributes.ref_no)>'#attributes.ref_no#'<cfelse>NULL</cfif>,
                0,
				<cfif isDefined('attributes.SHIP_METHOD') and len(attributes.SHIP_METHOD)>
					#SHIP_METHOD#
				<cfelse>
					NULL
				</cfif>,
				<cfif isdefined('form.basket_money')>
					'#form.basket_money#',
					#((form.basket_net_total*form.basket_rate1)/form.basket_rate2)#,
				</cfif>
				#session.pda.userid#,
				#now()#
		)
	</cfquery>
	<cfif attributes.rows_  neq 0>
		<cfloop from="1" to="#attributes.rows_#" index="i">
			<cf_date tarih="attributes.deliver_date#i#">
			<cf_date tarih="attributes.reserve_date#i#">
			<cfif evaluate('attributes.row_kontrol#i#')>
                <cfif isDefined("session.ep")>
                    <cfif session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#'))>
                        <cfinclude template="../../objects/query/add_basket_spec.cfm">
                    </cfif>
                </cfif>
                <cfset product_name_ = evaluate("attributes.product_name#i#")>
                <cfquery name="ADD_INTERNALDEMAND_ROW" datasource="#DSN3#">
                    INSERT INTO 
                        INTERNALDEMAND_ROW 
                        (
                            I_ID, 
                            PRODUCT_ID,
                            STOCK_ID,
                            QUANTITY,
                            UNIT,
                            UNIT_ID,
                            PRICE,
                            PRICE_OTHER,
                            OTHER_MONEY,
                            OTHER_MONEY_VALUE,
                            TAX,
                            DUEDATE,
                            PRODUCT_NAME,
                            PAY_METHOD_ID,
                            DELIVER_DATE,
                            DELIVER_DEPT,
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
                            TAXTOTAL,
                            NETTOTAL,				
                            OTV_ORAN,
                            OTVTOTAL,
                            COST_PRICE,
                            EXTRA_COST,
                            MARJ,
                            PROM_COMISSION,
                            PROM_COST,
                            DISCOUNT_COST,
                            PROM_ID,
                            IS_PROMOTION,
                            PROM_STOCK_ID,
                            IS_COMMISSION,
                            UNIQUE_RELATION_ID,
                            PROM_RELATION_ID,
                            AMOUNT2,
                            UNIT2,
                            EXTRA_PRICE,
                            EK_TUTAR_PRICE,
                            EXTRA_PRICE_TOTAL,
                            EXTRA_PRICE_OTHER_TOTAL,
                            SHELF_NUMBER,
                            BASKET_EXTRA_INFO_ID,
                            SELECT_INFO_EXTRA,
                            DETAIL_INFO_EXTRA,
                            PRICE_CAT,
                            CATALOG_ID,
                            LIST_PRICE,
                            NUMBER_OF_INSTALLMENT,
                            BASKET_EMPLOYEE_ID,
                            KARMA_PRODUCT_ID,
                            RESERVE_DATE,
                            PRODUCT_NAME2,
                            PRODUCT_MANUFACT_CODE,
                            WRK_ROW_ID,
                            WRK_ROW_RELATION_ID,
                            PRO_MATERIAL_ID
                            <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
                            ,SPECT_VAR_ID
                            ,SPECT_VAR_NAME
                            </cfif>
                        )
                    VALUES 
                        (
                            #MAX_ID.IDENTITYCOL#,
                            #evaluate("attributes.product_id#i#")#,
                            #evaluate("attributes.stock_id#i#")#,
                            #evaluate("attributes.amount#i#")#,
                            '#evaluate("attributes.unit#i#")#',
                            #evaluate("attributes.unit_id#i#")#,
                            <cfif isdefined('attributes.price#i#') and len(trim(evaluate('attributes.price#i#')))>#evaluate("attributes.price#i#")#,<cfelse>0,</cfif>
                            <cfif isdefined('attributes.price_other#i#') and len(evaluate("attributes.price_other#i#"))>#evaluate('attributes.price_other#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.other_money_#i#') and len(evaluate("attributes.other_money_#i#"))>'#evaluate('attributes.other_money_#i#')#'<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.other_money_value_#i#') and len(evaluate("attributes.other_money_value_#i#"))>#evaluate('attributes.other_money_value_#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.tax#i#') and len(trim(evaluate('attributes.tax#i#')))>#evaluate("attributes.tax#i#")#<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.duedate#i#") and len(evaluate("attributes.duedate#i#"))>#evaluate("attributes.duedate#i#")#<cfelse>0</cfif>,
                            '#left(product_name_,250)#',
                            <cfif isdefined("attributes.paymethod_id#i#") and len(evaluate("attributes.paymethod_id#i#"))>#evaluate("attributes.paymethod_id#i#")#<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,						
                            <cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
                                #listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
                            <cfelse>
                                NULL,
                            </cfif>
                            <cfif isdefined('attributes.indirim1#i#')>#evaluate('attributes.indirim1#i#')#<cfelse>0</cfif>,
                            <cfif isdefined('attributes.indirim2#i#')>#evaluate('attributes.indirim2#i#')#<cfelse>0</cfif>,
                            <cfif isdefined('attributes.indirim3#i#')>#evaluate('attributes.indirim3#i#')#<cfelse>0</cfif>,
                            <cfif isdefined('attributes.indirim4#i#')>#evaluate('attributes.indirim4#i#')#<cfelse>0</cfif>,
                            <cfif isdefined('attributes.indirim5#i#')>#evaluate('attributes.indirim5#i#')#<cfelse>0</cfif>,
                            <cfif isdefined('attributes.indirim6#i#')>#evaluate('attributes.indirim6#i#')#<cfelse>0</cfif>,
                            <cfif isdefined('attributes.indirim7#i#')>#evaluate('attributes.indirim7#i#')#<cfelse>0</cfif>,
                            <cfif isdefined('attributes.indirim8#i#')>#evaluate('attributes.indirim8#i#')#<cfelse>0</cfif>,
                            <cfif isdefined('attributes.indirim9#i#')>#evaluate('attributes.indirim9#i#')#<cfelse>0</cfif>,
                            <cfif isdefined('attributes.indirim10#i#')>#evaluate('attributes.indirim10#i#')#<cfelse>0</cfif>,
                            <cfif isdefined('attributes.row_taxtotal#i#') and len(evaluate("attributes.row_taxtotal#i#"))>#evaluate("attributes.row_taxtotal#i#")#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.row_nettotal#i#') and len(evaluate("attributes.row_nettotal#i#"))>#evaluate("attributes.row_nettotal#i#")#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))>'#evaluate('attributes.otv_oran#i#')#'<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
                            <cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
                            <cfif isdefined('attributes.marj#i#') and len(evaluate('attributes.marj#i#'))>#evaluate('attributes.marj#i#')#<cfelse>0</cfif>,
                            <cfif isdefined('attributes.promosyon_yuzde#i#') and len(evaluate('attributes.promosyon_yuzde#i#'))>#evaluate('attributes.promosyon_yuzde#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.promosyon_maliyet#i#') and len(evaluate('attributes.promosyon_maliyet#i#'))>#evaluate('attributes.promosyon_maliyet#i#')#<cfelse>0</cfif>,
                            <cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.row_promotion_id#i#') and len(evaluate('attributes.row_promotion_id#i#'))>#evaluate('attributes.row_promotion_id#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.is_promotion#i#') and len(evaluate('attributes.is_promotion#i#'))>#evaluate('attributes.is_promotion#i#')#<cfelse>0</cfif>,
                            <cfif isdefined('attributes.prom_stock_id#i#') and len(evaluate('attributes.prom_stock_id#i#'))>#evaluate('attributes.prom_stock_id#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.is_commission#i#') and len(evaluate('attributes.is_commission#i#'))>#evaluate('attributes.is_commission#i#')#<cfelse>0</cfif>,
                            <cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))>'#evaluate('attributes.row_unique_relation_id#i#')#'<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))>'#evaluate('attributes.prom_relation_id#i#')#'<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))>'#evaluate('attributes.unit_other#i#')#'<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.ek_tutar_price#i#') and len(evaluate('attributes.ek_tutar_price#i#'))>#evaluate('attributes.ek_tutar_price#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.ek_tutar_other_total#i#') and len(evaluate('attributes.ek_tutar_other_total#i#'))>#evaluate('attributes.ek_tutar_other_total#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.karma_product_id#i#') and len(evaluate('attributes.karma_product_id#i#'))>#evaluate('attributes.karma_product_id#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.reserve_date#i#") and isdate(evaluate('attributes.reserve_date#i#'))>#evaluate('attributes.reserve_date#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))>'#evaluate('attributes.product_name_other#i#')#'<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#evaluate('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))>'#evaluate('attributes.wrk_row_id#i#')#'<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>'#evaluate('attributes.wrk_row_relation_id#i#')#'<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and evaluate('attributes.row_ship_id#i#') neq 0>#evaluate('attributes.row_ship_id#i#')#<cfelse>NULL</cfif>
                            <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
                                ,#evaluate('attributes.spect_id#i#')#
                                ,'#evaluate('attributes.spect_name#i#')#'
                            </cfif>						
                        )
                </cfquery>
        	</cfif>            
		</cfloop>	
	</cfif>
	<cfscript>
		if(isdefined('attributes.pro_material_id_list') and len(attributes.pro_material_id_list)) //proje malzeme planı ile baglantısı olusturuluyor
		{
			include('add_paper_relation.cfm','\objects\functions'); 
			add_paper_relation(
				to_paper_id :MAX_ID.IDENTITYCOL,
				to_paper_table : 'INTERNALDEMAND',
				to_paper_type :3,
				from_paper_table : 'PRO_MATERIAL',
				from_paper_type :2,
				relation_type : 1,
				action_status:0
				);
		}
		basket_kur_ekle(action_id:MAX_ID.IDENTITYCOL,table_type_id:7,process_type:0);
	</cfscript>
	</cftransaction>
</cflock>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

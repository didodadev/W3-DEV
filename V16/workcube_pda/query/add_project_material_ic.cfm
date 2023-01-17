<cfquery name="UPD_GEN_PAP" datasource="#DSN#">
	UPDATE 
		#dsn3_alias#.GENERAL_PAPERS
	SET
		PRO_MATERIAL_NUMBER = <cfif isdefined("system_paper_no_add")>#system_paper_no_add#<cfelse>1</cfif><!--- action file icin 1 atandi --->
	WHERE
		PRO_MATERIAL_NUMBER IS NOT NULL
</cfquery>				
<cfquery name="ADD_PRO_MATERIAL" datasource="#DSN#" result="MAX_ID">
	INSERT INTO
		#dsn_alias#.PRO_MATERIAL 
        (
            PRO_MATERIAL_NO,
            COMPANY_ID,
            PARTNER_ID,
            CONSUMER_ID,
            ACTION_DATE,
            PROJECT_ID,
            BUDGET_ID,
            WORK_ID,
            DETAIL,
            PLANNER_EMP_ID,
            DISCOUNTTOTAL,
            GROSSTOTAL,
            NETTOTAL,
            TAXTOTAL,
            <cfif isdefined('attributes.basket_money') and len(attributes.basket_money)>
                OTHER_MONEY,
                OTHER_MONEY_VALUE,
            </cfif>
           	<!--- MATERIAL_STAGE, --->
            RECORD_DATE,
            RECORD_IP,
            RECORD_EMP
        )
        VALUES 
        (
            '#paper_full#',
			<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
                #attributes.company_id#,
                <cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
                NULL,
            <cfelse>
                NULL,
                NULL,
                <cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
            </cfif>
            <cfif len(attributes.action_date)>#attributes.action_date#<cfelse>NULL</cfif>,
            <cfif len(attributes.project_id) and Len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
            <cfif isDefined('attributes.budget_id') and len(attributes.budget_id)>#attributes.budget_id#<cfelse>NULL</cfif>,
            <cfif len(attributes.work_id)>#attributes.work_id#<cfelse>NULL</cfif>,
            <cfif len(attributes.pro_material_detail)>'#attributes.pro_material_detail#'<cfelse>NULL</cfif>,
            <cfif len(attributes.planner_emp_id) and len(attributes.planner_emp_name)>#attributes.planner_emp_id#<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.basket_discount_total")>#attributes.basket_discount_total#,<cfelse>0,</cfif>
            <cfif isdefined("attributes.basket_net_total")>#attributes.basket_net_total#,<cfelse>0,</cfif>
            <cfif isdefined("attributes.basket_gross_total")>#attributes.basket_gross_total#,<cfelse>0,</cfif>
            <cfif isdefined("attributes.basket_tax_total")>#attributes.basket_tax_total#,<cfelse>0,</cfif>
            <cfif isdefined('attributes.basket_money') and len(attributes.basket_money)>
                '#form.basket_money#',
                #((form.basket_net_total*form.basket_rate1)/form.basket_rate2)#,
            </cfif>
           <!--- #attributes.process_stage#, --->
            #now()#,
            '#cgi.remote_addr#',
            #session.pda.userid#
        )
</cfquery>
<cfif isdefined('attributes.row_count')>
<cfloop from="1" to="#attributes.row_count#" index="I">
	<cf_date tarih="attributes.deliver_date#i#">
	<!---<cfif session.pda.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#'))>
		<cfset dsn_type=dsn>
		<cfinclude template="../../objects/query/add_basket_spec.cfm">
	</cfif>--->
	<cfif isdefined('attributes.row_total#i#') and len(evaluate("attributes.row_total#i#"))>
		<cfset discount_amount = evaluate("attributes.row_total#i#")-evaluate("attributes.row_nettotal#i#") >
	<cfelse>
		<cfset discount_amount = 0>
	</cfif>
	<cfquery name="ADD_PRO_MATERIAL_ROW" datasource="#DSN#">
		INSERT INTO
			#dsn_alias#.PRO_MATERIAL_ROW
		(
			PRO_MATERIAL_ID,
			PRODUCT_ID,
			STOCK_ID,
			AMOUNT,
			UNIT,
			UNIT_ID,
		<cfif len(evaluate('attributes.price#i#'))>				
			PRICE,
		</cfif>	
			TAX,
			DUEDATE,
			PRODUCT_NAME,
			DELIVER_DATE,
			DELIVER_DEPT,
			DELIVER_LOCATION,
			DISCOUNT1,
			DISCOUNT2,
			DISCOUNT3,
			DISCOUNT4,
			DISCOUNT5,
			OTHER_MONEY,
			OTHER_MONEY_VALUE,
		<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
			SPECT_VAR_ID,
			SPECT_VAR_NAME,
		</cfif>
			PRICE_OTHER,
			COST_PRICE,
			COST_ID,
			EXTRA_COST,
			MARGIN,
			PROM_COMISSION,
			PROM_COST,
			DISCOUNT_COST,
			PROM_ID,
			IS_PROMOTION,
			PROM_STOCK_ID,
			UNIQUE_RELATION_ID,
			PRODUCT_NAME2,
			AMOUNT2,
			UNIT2,
			EXTRA_PRICE,
			EK_TUTAR_PRICE,
			EXTRA_PRICE_TOTAL,
			SHELF_NUMBER,
			PRODUCT_MANUFACT_CODE,
			OTV_ORAN,
			OTVTOTAL,
			BASKET_EXTRA_INFO_ID,
			SELECT_INFO_EXTRA,
            DETAIL_INFO_EXTRA,
			DISCOUNTTOTAL,
			GROSSTOTAL,
			NETTOTAL,
			LIST_PRICE,
			PRICE_CAT,
			CATALOG_ID,
			KARMA_PRODUCT_ID,
			TAXTOTAL,
			WRK_ROW_ID,
			WRK_ROW_RELATION_ID,
			WIDTH_VALUE,
			DEPTH_VALUE,
			HEIGHT_VALUE,
			ROW_PROJECT_ID
		)
		VALUES
		(
			#MAX_ID.IDENTITYCOL#,
			#evaluate('attributes.product_id#i#')#,
			#evaluate('attributes.stock_id#i#')#,
			#evaluate('attributes.amount#i#')#,
			'#wrk_eval('attributes.unit#i#')#',
			#evaluate('attributes.unit_id#i#')#,
		<cfif len(evaluate('attributes.price#i#'))>#evaluate('attributes.price#i#')#,</cfif>
			#evaluate('attributes.tax#i#')#,
		<cfif isdefined("attributes.duedate#i#") and len(evaluate('attributes.duedate#i#'))>#evaluate('attributes.duedate#i#')#<cfelse>NULL</cfif>,
			'#wrk_eval('attributes.product_name#i#')#',
		<cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
			#listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
		<cfelse>
			NULL,
		</cfif>
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
		<cfif isdefined('attributes.other_money_#i#')>'#wrk_eval('attributes.other_money_#i#')#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.other_money_value_#i#') and len(evaluate("attributes.other_money_value_#i#"))>#evaluate('attributes.other_money_value_#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
			#evaluate('attributes.spect_id#i#')#,
			'#wrk_eval('attributes.spect_name#i#')#',
		</cfif>
		<cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate('attributes.price_other#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
		<cfif isdefined('attributes.cost_id#i#') and len(evaluate('attributes.cost_id#i#'))>#evaluate('attributes.cost_id#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
		<cfif isdefined('attributes.marj#i#') and len(evaluate('attributes.marj#i#'))>#evaluate('attributes.marj#i#')#,<cfelse>0,</cfif>			
		<cfif isdefined('attributes.promosyon_yuzde#i#') and len(evaluate('attributes.promosyon_yuzde#i#'))>#evaluate('attributes.promosyon_yuzde#i#')#,<cfelse>NULL,</cfif>
		<cfif isdefined('attributes.promosyon_maliyet#i#') and len(evaluate('attributes.promosyon_maliyet#i#'))>#evaluate('attributes.promosyon_maliyet#i#')#,<cfelse>0,</cfif>
		<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#,<cfelse>NULL,</cfif>
		<cfif isdefined('attributes.row_promotion_id#i#') and len(evaluate('attributes.row_promotion_id#i#'))>#evaluate('attributes.row_promotion_id#i#')#,<cfelse>NULL,</cfif>
		<cfif isdefined('attributes.is_promotion#i#') and len(evaluate('attributes.is_promotion#i#'))>#evaluate('attributes.is_promotion#i#')#,<cfelse>NULL,</cfif>
		<cfif isdefined('attributes.prom_stock_id#i#') and len(evaluate('attributes.prom_stock_id#i#'))>#evaluate('attributes.prom_stock_id#i#')#,<cfelse>NULL,</cfif>
		<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))>'#wrk_eval('attributes.row_unique_relation_id#i#')#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))>'#wrk_eval('attributes.product_name_other#i#')#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))>'#wrk_eval('attributes.unit_other#i#')#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.ek_tutar_price#i#') and len(evaluate('attributes.ek_tutar_price#i#'))>#evaluate('attributes.ek_tutar_price#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))>'#wrk_eval('attributes.otv_oran#i#')#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
		<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
		<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
		#DISCOUNT_AMOUNT#,
		<cfif isdefined('attributes.row_lasttotal#i#') and len(evaluate('attributes.row_lasttotal#i#'))>#evaluate("attributes.row_lasttotal#i#")#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.row_nettotal#i#') and len(evaluate('attributes.row_nettotal#i#'))>#evaluate("attributes.row_nettotal#i#")#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.karma_product_id#i#') and len(evaluate('attributes.karma_product_id#i#'))>#evaluate('attributes.karma_product_id#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.row_taxtotal#i#') and len(evaluate('attributes.row_taxtotal#i#'))>#evaluate("attributes.row_taxtotal#i#")#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))>'#wrk_eval('attributes.wrk_row_id#i#')#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>'#wrk_eval('attributes.wrk_row_relation_id#i#')#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>
		)
	</cfquery>
</cfloop>
</cfif>
<!---<cfscript>
	if (not isdefined("new_dsn")) new_dsn = dsn; //action file vb dosyalardan tanim farkli gelebiliyor, bunun icin boyle bir duzenleme yapildi fbs 20110906
	basket_kur_ekle(action_id:get_max_pro_m.max_id,table_type_id:14,process_type:0,transaction_dsn:dsn,basket_money_db:new_dsn);
</cfscript>--->

<!--- faturanın önceki kendi irsaliyesi silinip yeniden oluşturulacak --->
<cfif ListFindNoCase("690,64", form.old_process_type, ",") and len(get_ship_id.ship_id)> <!---len(get_ship_id.ship_id) ifadesi iptal edilmis fatura iptal secenegi kaldırılarak güncellendiginde sorun olmaması için eklendi.zaten bir fatura iptal edilmişse kendi oluşturduğu irsaliye silinmiştir  --->
	<cfquery name="DEL_SHIP_ROW4" datasource="#dsn2#">
		DELETE FROM SHIP_MONEY WHERE ACTION_ID = #get_ship_id.ship_id#
	</cfquery>	
	<cfquery name="DEL_SHIP_RESULT_ROWS" datasource="#dsn2#">
		DELETE FROM SHIP_RESULT_ROW WHERE SHIP_ID = #get_ship_id.ship_id#
	</cfquery>		
	<cfquery name="DEL_SHIP_ROW" datasource="#dsn2#">
		DELETE FROM SHIP_ROW WHERE SHIP_ID = #get_ship_id.ship_id#
	</cfquery>
	<cfquery name="DEL_SHIP" datasource="#dsn2#">
		DELETE FROM SHIP WHERE SHIP_ID = #get_ship_id.ship_id#
	</cfquery>	
	<cfquery name="DEL_INVOICE_SHIPS" datasource="#dsn2#"><!--- invoice ve ship baglantilarının tutuldugu tablo --->
		DELETE FROM INVOICE_SHIPS WHERE SHIP_ID = #get_ship_id.ship_id# AND SHIP_PERIOD_ID=#session.ep.period_id#
	</cfquery>
     <cfset seri_ship_id_ = get_ship_id.ship_id>
</cfif>
<cfif ListFindNoCase("690,64", INVOICE_CAT, ",")>
	<cfscript>
		get_ship_process = createObject("component", "V16.invoice.cfc.get_ship_process_cat");
		get_ship_process.dsn2 = dsn2;
		get_ship_process.dsn3_alias = dsn3_alias;
	</cfscript>
	<cfif INVOICE_CAT eq 64> <!--- Müstahsil Makbuzu --->
		<cfset int_ship_process_type = 80>
        <cfset int_ship_process_cat = get_ship_process.get_ship_process_cat(process_cat:PROCESS_CAT)>
    <cfelse> <!--- 690 : Gider Pusula (Mal)--->
        <cfset int_ship_process_type = 84>
        <cfset int_ship_process_cat = get_ship_process.get_ship_process_cat(process_cat:PROCESS_CAT)>
    </cfif>
    
	<cfquery name="ADD_PURCHASE" datasource="#dsn2#" result="MAX_ID">
		INSERT INTO
			SHIP
			(
			PAYMETHOD_ID,
			PURCHASE_SALES,
			SHIP_NUMBER,
			SHIP_TYPE,
            PROCESS_CAT,
			SHIP_DATE,
			DELIVER_DATE,
		<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
			COMPANY_ID,
			<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>
			PARTNER_ID,
			</cfif>
		<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
			CONSUMER_ID,
		</cfif>
		<cfif session.ep.our_company_info.project_followup eq 1>
			PROJECT_ID,
		</cfif>
			DELIVER_EMP,
			DELIVER_EMP_ID,
			DISCOUNTTOTAL,
			NETTOTAL,
			GROSSTOTAL,
			TAXTOTAL,
			DEPARTMENT_IN,
			LOCATION_IN,
			RECORD_DATE,
			RECORD_EMP,
			IS_WITH_SHIP
			)
		VALUES
			(
			<cfif isdefined('attributes.paymethod_id') and len(attributes.paymethod_id)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
			0,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
			#int_ship_process_type#,
       		<cfif len(int_ship_process_cat)>#int_ship_process_cat#<cfelse>NULL</cfif>,
			#attributes.invoice_date#,
			#attributes.invoice_date#,
		<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
			#attributes.company_id#,
			<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>
			#attributes.partner_id#,
			</cfif>
		<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
			#attributes.consumer_id#,
		</cfif>
		<cfif session.ep.our_company_info.project_followup eq 1>
			<cfif isdefined("attributes.project_id") and len(attributes.project_id)  and isdefined("attributes.project_head") and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
		</cfif>
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(TRIM(attributes.deliver_get),50)#">,
		<cfif isdefined("attributes.deliver_get_id") and len(attributes.deliver_get_id)>#attributes.deliver_get_id#<cfelse>NULL</cfif>,	
			#form.basket_discount_total#,
			#form.basket_net_total#,
			#form.basket_gross_total#,
			#form.basket_tax_total#,
			#attributes.department_id#,
			#attributes.location_id#,
			#now()#,
			#SESSION.EP.USERID#,
			1
			)
	</cfquery>
     <cfset SHIP_MAX_ID = MAX_ID.IDENTITYCOL>
	<cfloop from="1" to="#attributes.rows_#" index="i">
		<cfinclude template="get_dis_amount.cfm">
		<cfset row_temp_wrk_id="#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#">
		<cfquery name="ADD_SHIP_ROW" datasource="#dsn2#">
			INSERT INTO SHIP_ROW
				(
				NAME_PRODUCT,
				SHIP_ID,
				STOCK_ID,
				PRODUCT_ID,
				AMOUNT,
				UNIT,
				UNIT_ID,					
				TAX,
				PRICE,
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
				OTHER_MONEY,
				OTHER_MONEY_VALUE,
				OTHER_MONEY_GROSS_TOTAL,
				SPECT_VAR_ID,
				SPECT_VAR_NAME,
				LOT_NO,
				PRICE_OTHER,
				IS_PROMOTION,
				DISCOUNT_COST,
				UNIQUE_RELATION_ID,
				PROM_RELATION_ID,
				PRODUCT_NAME2,
				AMOUNT2,
				UNIT2,
				EXTRA_PRICE,
				EXTRA_PRICE_TOTAL,
				SHELF_NUMBER,
				PRODUCT_MANUFACT_CODE,
				LIST_PRICE,
				PRICE_CAT,
				CATALOG_ID,
				NUMBER_OF_INSTALLMENT,
				WRK_ROW_ID,
				WRK_ROW_RELATION_ID,
				OTV_ORAN,
				OTVTOTAL,
				WIDTH_VALUE,
				DEPTH_VALUE,
				HEIGHT_VALUE,
				ROW_PROJECT_ID
				<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,EXPENSE_CENTER_ID</cfif>
				<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,EXPENSE_ITEM_ID</cfif>
				<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
				<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,ACC_CODE</cfif>
				<cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>,SUBSCRIPTION_ID</cfif>
				<cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>,ASSETP_ID</cfif>
				<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,BSMV_RATE</cfif>
				<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,BSMV_AMOUNT</cfif>
				<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,BSMV_CURRENCY</cfif>
				<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,OIV_RATE</cfif>
				<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,OIV_AMOUNT</cfif>
				<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,TEVKIFAT_RATE</cfif>
				<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,TEVKIFAT_AMOUNT</cfif>
				)
			VALUES
				(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(wrk_eval('attributes.product_name#i#'),250)#">,
				#MAX_ID.IDENTITYCOL#,
				#evaluate("attributes.stock_id#i#")#,
				#evaluate("attributes.product_id#i#")#,
				#evaluate("attributes.amount#i#")#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.unit#i#')#">,
				#evaluate("attributes.unit_id#i#")#,		
				#evaluate("attributes.tax#i#")#,
				#evaluate("attributes.price#i#")#,
				0,
				#indirim1#,
				#indirim2#,
				#indirim3#,
				#indirim4#,
				#indirim5#,
				#indirim6#,
				#indirim7#,
				#indirim8#,
				#indirim9#,
				#indirim10#,
				#DISCOUNT_AMOUNT#,
				#evaluate("attributes.row_lasttotal#i#")#,
				#evaluate("attributes.row_nettotal#i#")#,
				#evaluate("attributes.row_taxtotal#i#")#,			
				<cfif isdefined("attributes.deliver_date#i#") and len(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
					#listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
				<cfelseif isdefined('attributes.department_id') and len(attributes.department_id)>
					#attributes.department_id#,
				<cfelse>
					NULL,
				</cfif>
				<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
					#listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
				<cfelseif isdefined('attributes.location_id') and len(attributes.location_id)>
					#attributes.location_id#,
				<cfelse>
					NULL,
				</cfif>
				<cfif isdefined("attributes.other_money_#i#") and len(evaluate("attributes.other_money_#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.other_money_#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.other_money_gross_total#i#') and len(evaluate('attributes.other_money_gross_total#i#'))>#evaluate('attributes.other_money_gross_total#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>
					#evaluate("attributes.spect_id#i#")#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.spect_name#i#')#">,
				<cfelse>
					NULL,
					NULL,
				</cfif>
				<cfif isdefined("attributes.lot_no#i#")><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate('attributes.price_other#i#')#<cfelse>NULL</cfif>,
					0,
				<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
				#row_temp_wrk_id#,
				<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,<!--- faturanın wrk_row_id si olusturdugu irsaliyenin wrk_row_relation_id sine gonderiliyor --->
				<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>
				<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_center_id#i#')#"></cfif>
				<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_item_id#i#')#"></cfif>
				<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#"></cfif>
				<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.row_acc_code#i#')#"></cfif>
				<cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_subscription_id#i#')#"></cfif>
				<cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_assetp_id#i#')#"></cfif>
				<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_rate#i#')#"></cfif>
				<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_amount#i#')#"></cfif>
				<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_currency#i#')#"></cfif>
				<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_rate#i#')#"></cfif>
				<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_amount#i#')#"></cfif>
				<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_rate#i#')#"></cfif>
				<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_amount#i#')#"></cfif>
				)
		</cfquery>
	</cfloop>
      <cfif isdefined("seri_ship_id_")>
        <cfquery name="del_serial_numbers" datasource="#dsn2#">
            UPDATE 
                #dsn3_alias#.SERVICE_GUARANTY_NEW 
            SET
                PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_max_id#">,
                PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
                PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_ship_process_type#">,
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
            WHERE
                PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#seri_ship_id_#"> AND
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
        </cfquery>
        <!--- eğer ürün silinirse girilmiş serilerde delete edilir PY 1114 --->
        <cfif GET_SHIP_ID.recordcount and len(GET_SHIP_ID.SHIP_TYPE)>
            <cfquery name="get_stock_info" datasource="#dsn2#">
                DELETE
                FROM 
                    #DSN3_ALIAS#.SERVICE_GUARANTY_NEW 
                WHERE 
                    PROCESS_NO = '#form.INVOICE_NUMBER#' 
                    AND PROCESS_CAT = #int_ship_process_type# 
                    AND WRK_ROW_ID NOT IN (SELECT WRK_ROW_ID FROM SHIP_ROW WHERE SHIP_ID = #ship_max_id# )
                    AND WRK_ROW_ID IS NOT NULL
                    AND WRK_ROW_ID <> ''
                    AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                    AND PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#seri_ship_id_#">
            </cfquery>
        </cfif>
        <!--- eğer ürün silinirse girilmiş serilerde delete edilir PY 1114 --->
    </cfif>
	<cfquery name="ADD_INVOICE_SHIPS" datasource="#dsn2#">
		INSERT INTO
			INVOICE_SHIPS
			(
			INVOICE_ID,
			INVOICE_NUMBER,
			SHIP_ID,
			SHIP_NUMBER,
			IS_WITH_SHIP,
			SHIP_PERIOD_ID
			)
		VALUES
			(
			#form.invoice_id#,					
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
			#MAX_ID.IDENTITYCOL#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
			1, <!--- faturanın kendi irsaliyesi --->
			#session.ep.period_id#
			)
	</cfquery>
</cfif>

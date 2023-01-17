 <!---E.Y 22.08.2012 queryparam ifadeleri eklendi.--->
<cfloop from="1" to="#attributes.rows_#" index="i">
	<cfif session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and not (isdefined("attributes.spect_id#i#") and len(evaluate('attributes.spect_id#i#')))>
		<cfset dsn_type=dsn2>
		<cfinclude template="../../objects/query/add_basket_spec.cfm">
	</cfif>
	<cfscript>
		if(isdefined("attributes.amount#i#"))amount_rw=evaluate("attributes.amount#i#"); else amount_rw=0;
		if(isdefined("attributes.price#i#"))price_rw=evaluate("attributes.price#i#");else price_rw=0;
		if(isdefined("attributes.price_other#i#") and len(evaluate("attributes.price_other#i#")))price_other_rw=evaluate("attributes.price_other#i#");else price_other_rw=0;
		if(isdefined("attributes.INDIRIM1#i#") and len(evaluate("attributes.INDIRIM1#i#")))discount_rw=evaluate("attributes.INDIRIM1#i#");else discount_rw=0;
		if(isdefined("attributes.INDIRIM2#i#") and len(evaluate("attributes.INDIRIM1#i#")))discount2_rw=evaluate("attributes.INDIRIM2#i#");else discount2_rw=0;
		if(isdefined("attributes.INDIRIM3#i#") and len(evaluate("attributes.INDIRIM3#i#")))discount3_rw=evaluate("attributes.INDIRIM3#i#");else discount3_rw=0;
		if(isdefined("attributes.INDIRIM4#i#") and len(evaluate("attributes.INDIRIM4#i#")))discount4_rw=evaluate("attributes.INDIRIM4#i#");else discount4_rw=0;
		if(isdefined("attributes.INDIRIM5#i#") and len(evaluate("attributes.INDIRIM1#i#")))discount5_rw=evaluate("attributes.INDIRIM5#i#");else discount5_rw=0;						
		if(isdefined("attributes.tax#i#"))tax_rw=evaluate("attributes.tax#i#");else tax_rw=0;
		indirim_carpan=10000000000 - ((100-discount_rw) * (100-discount2_rw) * (100-discount3_rw) * (100-discount4_rw) * (100-discount5_rw));
		if(isdefined("attributes.row_total#i#"))subtotal = evaluate("attributes.row_total#i#");	else subtotal = 0;
		if(isdefined("attributes.row_nettotal#i#"))total = evaluate("attributes.row_nettotal#i#");else total = 0;
		if(isdefined("attributes.row_taxtotal#i#"))	ship_fis_total_tax_ = evaluate("attributes.row_taxtotal#i#"); else ship_fis_total_tax_ = 0;
		ship_fis_net_total_ = total ;
		//ship_fis_discount_ = (subtotal* indirim_carpan) / 10000000000;
		ship_fis_total_ = total;
	</cfscript>
	<cf_date tarih="attributes.deliver_date#i#">
	<cf_date tarih="attributes.reserve_date#i#">
    <cfif get_process_type.process_type eq 113>
    	<!---<cfif len(attributes.department_in_txt)>
		
        	<cfif isdefined('attributes.DELIVER_DATE_FRM') and len(attributes.DELIVER_DATE_FRM)>
            	<cfset my_date = attributes.DELIVER_DATE_FRM>
            <cfelse>
            	<cfset my_date = attributes.FIS_DATE>
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
           <!--- <pre>
            <cfdump var="#get_stock_age#">
            <cfdump var="#get_total_stock#">
            <cfdump var="#get_product_detail#">
            
            <cfabort>--->
            </cfif>
			--->
    </cfif>
	<cfquery name="UPD_X" datasource="#dsn2#">
		INSERT INTO 
			STOCK_FIS_ROW
			(
				FIS_ID,
				FIS_NUMBER,
				STOCK_ID,
				AMOUNT,
				UNIT,
				UNIT_ID,				
				PRICE,
				PRICE_OTHER,
				TAX,
				DISCOUNT1,
				DISCOUNT2,
				DISCOUNT3,
				DISCOUNT4,
				DISCOUNT5,
				TOTAL,
				TOTAL_TAX,
				NET_TOTAL,
				DELIVER_DATE,
				RESERVE_DATE,
				<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
				SPECT_VAR_ID,
				SPECT_VAR_NAME,
				</cfif>
				LOT_NO,
				OTHER_MONEY,
				COST_PRICE,
				EXTRA_COST,
				DISCOUNT_COST,
				UNIQUE_RELATION_ID,
				PRODUCT_NAME2,
				AMOUNT2,
				UNIT2,
				EXTRA_PRICE,
				EXTRA_PRICE_TOTAL,
				SHELF_NUMBER,
				TO_SHELF_NUMBER,
				PRODUCT_MANUFACT_CODE,
				<!---DUE_DATE,--->
				ROW_INTERNALDEMAND_ID,
				WRK_ROW_ID,
				WRK_ROW_RELATION_ID,
				PBS_ID,
				WIDTH_VALUE,
				DEPTH_VALUE,
				HEIGHT_VALUE,
				ROW_PROJECT_ID,
                ROW_WORK_ID,
				BASKET_EXTRA_INFO_ID,
				SELECT_INFO_EXTRA,
                DETAIL_INFO_EXTRA,
                BASKET_EMPLOYEE_ID
                <cfif get_process_type.process_type eq 113>
                    ,DUE_DATE
                </cfif>
				<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,EXPENSE_CENTER_ID</cfif>
				<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,EXPENSE_ITEM_ID</cfif>
				<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
				<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,ACC_CODE</cfif>
			)
		VALUES
			(
				#attributes.UPD_ID#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.FIS_NO#">,
				#evaluate("attributes.stock_id#i#")#,
				#amount_rw#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit#i#')#">,
				#evaluate("attributes.unit_id#i#")#,
				#price_rw#,
				#price_other_rw#,
				#tax_rw#,
				#discount_rw#,
				#discount2_rw#,
				#discount3_rw#,
				#discount4_rw#,
				#discount5_rw#,
				#ship_fis_total_#,
				#ship_fis_total_tax_#,
				#ship_fis_net_total_#,
				<cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.reserve_date#i#") and len(evaluate("attributes.reserve_date#i#"))>#evaluate("attributes.reserve_date#i#")#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
					#evaluate('attributes.spect_id#i#')#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.spect_name#i#')#">,
				</cfif>
				<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.other_money_#i#') and len(evaluate('attributes.other_money_#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.other_money_#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.to_shelf_number#i#') and len(evaluate('attributes.to_shelf_number#i#')) and isdefined('attributes.to_shelf_number_txt#i#') and len(evaluate('attributes.to_shelf_number_txt#i#'))>#evaluate('attributes.to_shelf_number#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
				<!---<cfif isdefined('attributes.duedate#i#') and len(evaluate('attributes.duedate#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.duedate#i#')#"><cfelse>0</cfif>,--->
				<cfif isdefined("attributes.row_ship_id#i#") and listlen(evaluate('attributes.row_ship_id#i#'),";") eq 2 and len(listgetat(evaluate('attributes.row_ship_id#i#'),2,';'))>#listgetat(evaluate('attributes.row_ship_id#i#'),2,';')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.pbs_code#i#') and len(evaluate('attributes.pbs_code#i#')) and isdefined('attributes.pbs_id#i#') and len(evaluate('attributes.pbs_id#i#'))>#evaluate('attributes.pbs_id#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
                <cfif isdefined('attributes.row_work_id#i#') and len(evaluate('attributes.row_work_id#i#')) and isdefined('attributes.row_work_name#i#') and len(evaluate('attributes.row_work_name#i#'))>#evaluate('attributes.row_work_id#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>
				<cfif get_process_type.process_type eq 113>
                    ,<cfif isdefined('attributes.set_duedate#i#') and len(evaluate('attributes.set_duedate#i#'))>#evaluate('attributes.set_duedate#i#')#<cfelse>NULL</cfif>
                </cfif>
				<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_center_id#i#')#"></cfif>
				<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_item_id#i#')#"></cfif>
				<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#"></cfif>
				<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.row_acc_code#i#')#"></cfif>
			)
	</cfquery>
</cfloop>
<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
	DELETE FROM STOCKS_ROW WHERE PROCESS_TYPE=#attributes.TYPE_ID# AND UPD_ID=#attributes.UPD_ID#
</cfquery>
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
                                PROCESS_NO = '#FIS_NO#' 
                                AND PROCESS_CAT = #attributes.TYPE_ID# 
                                AND WRK_ROW_ID NOT IN (SELECT WRK_ROW_ID FROM STOCK_FIS_ROW WHERE FIS_ID = #attributes.upd_id# )
                                AND WRK_ROW_ID IS NOT NULL
                                AND WRK_ROW_ID <> ''
                         )

</cfquery>

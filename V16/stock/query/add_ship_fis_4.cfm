<cfif not isdefined("new_comp_id")><cfset new_comp_id = session.ep.company_id></cfif>
<cfif not isdefined("new_dsn3_group")><cfset new_dsn3_group = dsn3></cfif>
<cfif not isdefined("new_dsn2_group")><cfset new_dsn2_group = dsn2></cfif>
<cfif not isdefined("new_dsn3_group_alias")><cfset new_dsn3_group_alias = dsn3_alias></cfif>
<cfif not isdefined("new_dsn2_group_alias")><cfset new_dsn2_group_alias = dsn2_alias></cfif>
<cfif not isdefined("new_period_id")><cfset new_period_id = session.ep.period_id></cfif>
<cfloop from="1" to="#attributes.rows_#" index="i">
	<cfscript>
		if(isdefined("attributes.amount#i#"))amount_rw=evaluate("attributes.amount#i#"); else amount_rw=0;
		if(isdefined("attributes.price#i#"))price_rw=evaluate("attributes.price#i#");else price_rw=0;
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
		ship_fis_discount_ = (subtotal* indirim_carpan) / 10000000000;
		ship_fis_total_ = total;
	</cfscript>
	<cfinclude template="get_unit_add_fis.cfm">
	<cfif get_unit.recordcount and len(get_unit.multiplier)>
		<cfset multi=get_unit.multiplier*amount_rw>
	<cfelse>
		<cfset multi=amount_rw>
	</cfif>
	<cfif isDefined("attributes.is_inventory#i#") and Evaluate("attributes.is_inventory#i#") eq 1><!--- Envantere Dahilse Stok Hareketi Yapar --->
		<cfif get_process_type.IS_STOCK_ACTION eq 1>
		<!--- stock_row tablosuna spec id degil main spec ider atılmali --->
			<cfset form_spect_main_id="">
			<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
				<cfset form_spect_id="#evaluate('attributes.spect_id#i#')#">
				<cfif len(form_spect_id) and len(form_spect_id)>
					<cfquery name="GET_MAIN_SPECT" datasource="#dsn2#">
						SELECT SPECT_MAIN_ID FROM #new_dsn3_group_alias#.SPECTS WHERE SPECT_VAR_ID=#form_spect_id#
					</cfquery>
					<cfif GET_MAIN_SPECT.RECORDCOUNT>
						<cfset form_spect_main_id=GET_MAIN_SPECT.SPECT_MAIN_ID>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
        <cfquery name="GET_KARMA_PRODUCTS" datasource="#dsn2#"><!--- karma koli olan ürünler --->
				SELECT PRODUCT_ID FROM #dsn3_alias#.PRODUCT WHERE PRODUCT_ID IN (#evaluate("attributes.product_id#i#")#) AND IS_KARMA = 1
		</cfquery>
		<cfif attributes.fis_type eq 115 and get_process_type.IS_STOCK_ACTION eq 1><!--- Stok hareketi yapılsın --->
        	<cfif GET_KARMA_PRODUCTS.recordcount>
                <cfquery name="GET_KARMA_PRODUCT" datasource="#dsn2#">
                    SELECT PRODUCT_ID,STOCK_ID,SPEC_MAIN_ID,PRODUCT_AMOUNT FROM #dsn1_alias#.KARMA_PRODUCTS WHERE KARMA_PRODUCT_ID = #evaluate("attributes.product_id#i#")#
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
                                        <cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
                                            INSERT INTO 
                                                #new_dsn2_group_alias#.STOCKS_ROW
                                                (
                                                    UPD_ID,
                                                    PRODUCT_ID,
                                                    STOCK_ID,
                                                    PROCESS_TYPE,
                                                    STOCK_IN,
                                                    STORE,
                                                    STORE_LOCATION,
                                                    PROCESS_DATE,
                                                    PROCESS_TIME,
													LOT_NO,
                                                    SPECT_VAR_ID,
                                                    DELIVER_DATE,
                                                    SHELF_NUMBER,
                                                    AMOUNT2,
                                                    UNIT2
                                                )
                                            VALUES
                                                (
                                                    #GET_ID.MAX_ID#,
                                                    #GET_SPEC_PRODUCT.product_id#,
                                                    #GET_SPEC_PRODUCT.stock_id#,
                                                    115,
                                                    #multi*GET_SPEC_PRODUCT.product_amount#,
                                                    #attributes.department_in#,
                                                    #attributes.location_in#,
                                                    #attributes.FIS_DATE#,
                                                    #attributes.fis_date_time#,
													<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                                                    <cfif len(GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID)>#GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID#<cfelse>NULL</cfif>,
                                                    <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                                                    <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                                                    <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                                    <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>
                                                )
                                    </cfquery>
                                </cfloop>
                            </cfif>
					</cfif>                   
                        <cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
                            INSERT INTO 
                                #new_dsn2_group_alias#.STOCKS_ROW
                                (
                                    UPD_ID,
                                    PRODUCT_ID,
                                    STOCK_ID,
                                    PROCESS_TYPE,
                                    STOCK_IN,
                                    STORE,
                                    STORE_LOCATION,
                                    PROCESS_DATE,
                                    PROCESS_TIME,
									LOT_NO,
                                    SPECT_VAR_ID,
                                    DELIVER_DATE,
                                    SHELF_NUMBER,
                                    AMOUNT2,
                                    UNIT2
                                )
                            VALUES
                                (
                                    #GET_ID.MAX_ID#,
                                    #GET_KARMA_PRODUCT.product_id#,
                                    #GET_KARMA_PRODUCT.stock_id#,
                                    115,
                                    #multi*GET_KARMA_PRODUCT.product_amount#,
                                    #attributes.department_in#,
                                    #attributes.location_in#,
                                    #attributes.FIS_DATE#,
                                    #attributes.fis_date_time#,
									<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                                    <cfif len(GET_KARMA_PRODUCT.SPEC_MAIN_ID)>#GET_KARMA_PRODUCT.SPEC_MAIN_ID#<cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>
                                )
                    </cfquery>
                    </cfloop>
                </cfif>
            <cfelse>
            	  <cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
                        INSERT INTO 
                            #new_dsn2_group_alias#.STOCKS_ROW
                            (
                                UPD_ID,
                                PRODUCT_ID,
                                STOCK_ID,
                                PROCESS_TYPE,
                                STOCK_IN,
                                STORE,
                                STORE_LOCATION,
                                PROCESS_DATE,
                                PROCESS_TIME,
                                SPECT_VAR_ID,
                                LOT_NO,
                                DELIVER_DATE,
                                SHELF_NUMBER,
                                PRODUCT_MANUFACT_CODE,
                                AMOUNT2,
                                UNIT2
                            )
                        VALUES
                            (
                                #GET_ID.MAX_ID#,
                                #evaluate("attributes.product_id#i#")#,
                                #evaluate("attributes.stock_id#i#")#,
                                115,
                                #MULTI#,
                                #attributes.department_in#,
                                #attributes.location_in#,
                                #attributes.FIS_DATE#,
                                #attributes.fis_date_time#,
                                <cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>#form_spect_main_id#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>
                            )
                </cfquery>   
            </cfif>				
		</cfif>
		<cfif listfind('111,112',attributes.fis_type) and get_process_type.IS_STOCK_ACTION eq 1>
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
                                        <cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
                                            INSERT INTO 
                                                    #new_dsn2_group_alias#.STOCKS_ROW
                                                    (
                                                        UPD_ID,
                                                        PRODUCT_ID,
                                                        STOCK_ID,
                                                        PROCESS_TYPE,
                                                        STOCK_OUT,
                                                        STORE,
                                                        STORE_LOCATION,
                                                        PROCESS_DATE,
                                                        PROCESS_TIME,
														LOT_NO,
                                                        SPECT_VAR_ID,
                                                        DELIVER_DATE,
                                                        SHELF_NUMBER,
                                                        AMOUNT2,
                                                        UNIT2
                                                    )
                                                    VALUES
                                                    (
                                                        #GET_ID.MAX_ID#,
                                                        #GET_SPEC_PRODUCT.product_id#,
                                                        #GET_SPEC_PRODUCT.stock_id#,
                                                        #attributes.FIS_TYPE#,
                                                        #multi*GET_SPEC_PRODUCT.product_amount#,
                                                        #attributes.department_out#,
                                                        #attributes.location_out#,
                                                        #attributes.FIS_DATE#,
                                                        #attributes.fis_date_time#,
														<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                                                        <cfif len(GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID)>#GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID#<cfelse>NULL</cfif>,
                                                        <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                                                        <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                                                        <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                                        <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>
                                                    )
                                        </cfquery>
                                </cfloop>
                            </cfif>
					</cfif>                      
                       <cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
                            INSERT INTO 
                                    #new_dsn2_group_alias#.STOCKS_ROW
                                    (
                                        UPD_ID,
                                        PRODUCT_ID,
                                        STOCK_ID,
                                        PROCESS_TYPE,
                                        STOCK_OUT,
                                        STORE,
                                        STORE_LOCATION,
                                        PROCESS_DATE,
                                        PROCESS_TIME,
										LOT_NO,
                                        SPECT_VAR_ID,
                                        DELIVER_DATE,
                                        SHELF_NUMBER,
                                        AMOUNT2,
                                        UNIT2
                                    )
                                    VALUES
                                    (
                                        #GET_ID.MAX_ID#,
                                        #GET_KARMA_PRODUCT.product_id#,
                                        #GET_KARMA_PRODUCT.stock_id#,
                                        #attributes.FIS_TYPE#,
                                        #multi*GET_KARMA_PRODUCT.product_amount#,
                                        #attributes.department_out#,
                                        #attributes.location_out#,
                                        #attributes.FIS_DATE#,
                                        #attributes.fis_date_time#,
										<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                                        <cfif len(GET_KARMA_PRODUCT.SPEC_MAIN_ID)>#GET_KARMA_PRODUCT.SPEC_MAIN_ID#<cfelse>NULL</cfif>,
                                        <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                                        <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                						<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                        <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>
                                    )
                        </cfquery>
                    </cfloop>
                </cfif>
            <cfelse>
                <cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
                    INSERT INTO 
                            #new_dsn2_group_alias#.STOCKS_ROW
                            (
                                UPD_ID,
                                PRODUCT_ID,
                                STOCK_ID,
                                PROCESS_TYPE,
                                STOCK_OUT,
                                STORE,
                                STORE_LOCATION,
                                PROCESS_DATE,
                                PROCESS_TIME,
                                SPECT_VAR_ID,
                                LOT_NO,
                                DELIVER_DATE,
                                SHELF_NUMBER,
                                PRODUCT_MANUFACT_CODE,
                                AMOUNT2,
                                UNIT2
                            )
                            VALUES
                            (
                                #GET_ID.MAX_ID#,
                                #evaluate("attributes.product_id#i#")#,
                                #evaluate("attributes.stock_id#i#")#,
                                #attributes.FIS_TYPE#,
                                #MULTI#,
                                #attributes.department_out#,
                                #attributes.location_out#,
                                #attributes.FIS_DATE#,
                                #attributes.fis_date_time#,
                                <cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>#form_spect_main_id#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>
                            )
                </cfquery>
            </cfif>
		<cfelseif attributes.fis_type eq 110 and get_process_type.IS_STOCK_ACTION eq 1>
			<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
				INSERT INTO 
					#new_dsn2_group_alias#.STOCKS_ROW
					(
						UPD_ID,
						PRODUCT_ID,
						STOCK_ID,
						PROCESS_TYPE,
						STOCK_IN,
						STORE,
						STORE_LOCATION,
						PROCESS_DATE,
                        PROCESS_TIME,
						SPECT_VAR_ID,
						LOT_NO,
						DELIVER_DATE,
						SHELF_NUMBER,
						PRODUCT_MANUFACT_CODE,
						AMOUNT2,
						UNIT2
					)
					VALUES
					(
						#GET_ID.MAX_ID#,
						#evaluate("attributes.product_id#i#")#,
						#evaluate("attributes.stock_id#i#")#,
						#attributes.FIS_TYPE#,
						#MULTI#,
						#attributes.department_in#,
						#attributes.location_in#,
						#attributes.FIS_DATE#,
                        #attributes.fis_date_time#,
						<cfif isdefined("#form_spect_main_id#") and len(#form_spect_main_id#)>#form_spect_main_id#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>
					)
			</cfquery>
		<cfelseif listfind('113,1131',attributes.fis_type) and get_process_type.IS_STOCK_ACTION eq 1>
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
                                    <cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
                                        INSERT INTO 
                                            STOCKS_ROW
                                                (
                                                    UPD_ID,
                                                    PRODUCT_ID,
                                                    STOCK_ID,
                                                    PROCESS_TYPE,
                                                    STOCK_OUT,
                                                    STORE,
                                                    STORE_LOCATION,
                                                    PROCESS_DATE,
                                                    PROCESS_TIME,
													LOT_NO,
                                                    SPECT_VAR_ID,
                                                    SHELF_NUMBER,
                                                    AMOUNT2,
                                                    UNIT2
                                                )
                                            VALUES
                                                (
                                                    #GET_ID.MAX_ID#,
                                                   #GET_SPEC_PRODUCT.product_id#,
                                                    #GET_SPEC_PRODUCT.stock_id#,
                                                    #attributes.FIS_TYPE#,
                                                    #multi*GET_SPEC_PRODUCT.product_amount#,
                                                    #attributes.department_out#,
                                                    #attributes.location_out#,
                                                    #attributes.FIS_DATE#,
                                                    #attributes.fis_date_time#,
													<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                                                    <cfif len(GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID)>#GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID#<cfelse>NULL</cfif>,
                                                    <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                                                    <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                                    <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>
                                                )
                                    </cfquery>
                                    <cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
                                        INSERT INTO 
                                            STOCKS_ROW
                                                (
                                                    UPD_ID,
                                                    PRODUCT_ID,
                                                    STOCK_ID,
                                                    PROCESS_TYPE,
                                                    STOCK_IN,
                                                    STORE,
                                                    STORE_LOCATION,
                                                    PROCESS_DATE,
                                                    PROCESS_TIME,
													LOT_NO,
                                                    SPECT_VAR_ID,
                                                    SHELF_NUMBER,
                                                    AMOUNT2,
                                                    UNIT2
                                                )
                                            VALUES
                                                (
                                                    #GET_ID.MAX_ID#,
                                                    #GET_SPEC_PRODUCT.product_id#,
                                                    #GET_SPEC_PRODUCT.stock_id#,
                                                    #attributes.FIS_TYPE#,
                                                    #multi*GET_SPEC_PRODUCT.product_amount#,
                                                    #attributes.department_in#,
                                                    #attributes.location_in#,
                                                    #attributes.FIS_DATE#,
                                                    #attributes.fis_date_time#,
													<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                                                    <cfif len(GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID)>#GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID#<cfelse>NULL</cfif>,
                                                    <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                                                    <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                                    <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>
                                                )
                                    </cfquery>
                                </cfloop>
                            </cfif>
                    	</cfif>
                   		<cfquery name="ADD_STOCK_ROW_IN" datasource="#dsn2#">
                            INSERT INTO 
                                STOCKS_ROW
                                (
                                    UPD_ID,
                                    PRODUCT_ID,
                                    STOCK_ID,
                                    PROCESS_TYPE,
                                    PROCESS_TIME,
                                    STOCK_IN,
                                    STORE,
                                    STORE_LOCATION,
                                    PROCESS_DATE,
									LOT_NO,
                                    SPECT_VAR_ID,
                                    DELIVER_DATE,
                                    SHELF_NUMBER,
                                    AMOUNT2,
                                    UNIT2
                                )
                            VALUES
                                (
                                    #GET_ID.MAX_ID#,
                                     #GET_KARMA_PRODUCT.product_id#,
                                     #GET_KARMA_PRODUCT.stock_id#,
                                    #attributes.FIS_TYPE#,
                                     #multi*GET_KARMA_PRODUCT.product_amount#,
                                    #attributes.department_in#,
                                    #attributes.location_in#,
                                    #attributes.FIS_DATE#,
                                    #attributes.fis_date_time#,
									<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                                    <cfif len(GET_KARMA_PRODUCT.SPEC_MAIN_ID)>#GET_KARMA_PRODUCT.SPEC_MAIN_ID#<cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.to_shelf_number#i#') and len(evaluate('attributes.to_shelf_number#i#')) and isdefined('attributes.to_shelf_number_txt#i#') and len(evaluate('attributes.to_shelf_number_txt#i#'))>#evaluate('attributes.to_shelf_number#i#')#<cfelse>NULL</cfif>,                       
                                    <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>
                                )
                        </cfquery>                      
                   		<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
                            INSERT INTO 
                                STOCKS_ROW
                                    (
                                        UPD_ID,
                                        PRODUCT_ID,
                                        STOCK_ID,
                                        PROCESS_TYPE,
                                        STOCK_OUT,
                                        STORE,
                                        STORE_LOCATION,
                                        PROCESS_DATE,
                                        PROCESS_TIME,
										LOT_NO,
                                        SPECT_VAR_ID,
                                        SHELF_NUMBER,
                                        AMOUNT2,
                                        UNIT2
                                    )
                                VALUES
                                    (
                                        #GET_ID.MAX_ID#,
                                         #GET_KARMA_PRODUCT.product_id#,
                                        #GET_KARMA_PRODUCT.stock_id#,
                                        #attributes.FIS_TYPE#,
                                       #multi*GET_KARMA_PRODUCT.product_amount#,
                                        #attributes.department_out#,
                                        #attributes.location_out#,
                                        #attributes.FIS_DATE#,
                                        #attributes.fis_date_time#,
										<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                                        <cfif len(GET_KARMA_PRODUCT.SPEC_MAIN_ID)>#GET_KARMA_PRODUCT.SPEC_MAIN_ID#<cfelse>NULL</cfif>,
                                        <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                                        <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                        <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>
                                    )
                    	</cfquery>
                	</cfloop>
                <cfelse>
                		<cfquery name="ADD_STOCK_ROW_IN" datasource="#dsn2#">
                            INSERT INTO 
                                STOCKS_ROW
                                (
                                    UPD_ID,
                                    PRODUCT_ID,
                                    STOCK_ID,
                                    PROCESS_TYPE,
                                    STOCK_IN,
                                    STORE,
                                    STORE_LOCATION,
                                    PROCESS_DATE,
                                    PROCESS_TIME,
									LOT_NO,
                                    SPECT_VAR_ID,
                                    DELIVER_DATE,
                                    SHELF_NUMBER,
                                    AMOUNT2,
                                    UNIT2
                                )
                            VALUES
                                (
                                    #GET_ID.MAX_ID#,
                                    #evaluate("attributes.product_id#i#")#,
                                     #evaluate("attributes.stock_id#i#")#,
                                    #attributes.FIS_TYPE#,
                                     #multi#,
                                    #attributes.department_in#,
                                    #attributes.location_in#,
                                    #attributes.FIS_DATE#,
                                    #attributes.fis_date_time#,
									<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                                    <cfif len(GET_KARMA_PRODUCT.SPEC_MAIN_ID)>#GET_KARMA_PRODUCT.SPEC_MAIN_ID#<cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.to_shelf_number#i#') and len(evaluate('attributes.to_shelf_number#i#')) and isdefined('attributes.to_shelf_number_txt#i#') and len(evaluate('attributes.to_shelf_number_txt#i#'))>#evaluate('attributes.to_shelf_number#i#')#<cfelse>NULL</cfif>,                       
                                    <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>
                                )
                        </cfquery>                      
                   		<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
                            INSERT INTO 
                                STOCKS_ROW
                                    (
                                        UPD_ID,
                                        PRODUCT_ID,
                                        STOCK_ID,
                                        PROCESS_TYPE,
                                        STOCK_OUT,
                                        STORE,
                                        STORE_LOCATION,
                                        PROCESS_DATE,
                                        PROCESS_TIME,
										LOT_NO,
                                        SPECT_VAR_ID,
                                        SHELF_NUMBER,
                                        AMOUNT2,
                                        UNIT2
                                    )
                                VALUES
                                    (
                                        #GET_ID.MAX_ID#,
                                        #evaluate("attributes.product_id#i#")#,
                                        #evaluate("attributes.stock_id#i#")#,
                                        #attributes.FIS_TYPE#,
                                        #multi#,
                                        #attributes.department_out#,
                                        #attributes.location_out#,
                                        #attributes.FIS_DATE#,
                                        #attributes.fis_date_time#,
										<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                                        <cfif len(GET_KARMA_PRODUCT.SPEC_MAIN_ID)>#GET_KARMA_PRODUCT.SPEC_MAIN_ID#<cfelse>NULL</cfif>,
                                        <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                                        <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                        <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>
                                    )
                    	</cfquery>
                </cfif>
             <cfelse>
             	<cfquery name="ADD_STOCK_ROW_IN" datasource="#dsn2#">
                    INSERT INTO 
                        STOCKS_ROW
                        (
                            UPD_ID,
                            PRODUCT_ID,
                            STOCK_ID,
                            PROCESS_TYPE,
                            STOCK_IN,
                            STORE,
                            STORE_LOCATION,
                            PROCESS_DATE,
                            PROCESS_TIME,
							LOT_NO,
                            SPECT_VAR_ID,
                            DELIVER_DATE,
                            SHELF_NUMBER,
                            AMOUNT2,
                            UNIT2
                        )
                    VALUES
                        (
                            #GET_ID.MAX_ID#,
                            #evaluate("attributes.product_id#i#")#,
                             #evaluate("attributes.stock_id#i#")#,
                            #attributes.FIS_TYPE#,
                             #multi#,
                            #attributes.department_in#,
                            #attributes.location_in#,
                            #attributes.FIS_DATE#,
                            #attributes.fis_date_time#,
							<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>#form_spect_main_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.to_shelf_number#i#') and len(evaluate('attributes.to_shelf_number#i#')) and isdefined('attributes.to_shelf_number_txt#i#') and len(evaluate('attributes.to_shelf_number_txt#i#'))>#evaluate('attributes.to_shelf_number#i#')#<cfelse>NULL</cfif>,                       
                            <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>
                        )
                </cfquery>                      
                 <cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
                            INSERT INTO 
                                STOCKS_ROW
                                    (
                                        UPD_ID,
                                        PRODUCT_ID,
                                        STOCK_ID,
                                        PROCESS_TYPE,
                                        STOCK_OUT,
                                        STORE,
                                        STORE_LOCATION,
                                        PROCESS_DATE,
                                        PROCESS_TIME,
										LOT_NO,
                                        SPECT_VAR_ID,
                                        SHELF_NUMBER,
                                        AMOUNT2,
                                        UNIT2
                                    )
                                VALUES
                                    (
                                        #GET_ID.MAX_ID#,
                                        #evaluate("attributes.product_id#i#")#,
                                        #evaluate("attributes.stock_id#i#")#,
                                        #attributes.FIS_TYPE#,
                                        #multi#,
                                        #attributes.department_out#,
                                        #attributes.location_out#,
                                        #attributes.FIS_DATE#,
                                        #attributes.fis_date_time#,
										<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                                		<cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>#form_spect_main_id#<cfelse>NULL</cfif>,
                                        <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                                        <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                        <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>
                                    )
                    	</cfquery>
             </cfif>
		</cfif>
    </cfif>
</cfloop>

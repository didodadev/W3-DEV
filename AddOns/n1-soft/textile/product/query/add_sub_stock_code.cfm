<!---
<cfdump var="#attributes#"><cfabort>
--->
<cfset attributes.is_barkod=1>
<cfset attributes.is_auto_barcode=0>
<cfquery name="stock_count" datasource="#dsn3#">
	SELECT STOCK_ID,STOCK_CODE_2,PRODUCT_UNIT_ID,PRODUCT_NAME FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
</cfquery>
<cfquery name="get_product_unit_id" datasource="#dsn3#">
	SELECT PRODUCT_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND IS_MAIN = 1
</cfquery>

<cfset stock_count_ = stock_count.recordcount>
<!--- color-size id --->
<cfset property_detail_id = attributes.color_detail_id>
<cfset property_detail_id = listappend(property_detail_id,attributes.size_detail_id)>
<cfset property_detail_id = listappend(property_detail_id,attributes.len_detail_id)>
<!--- //color-size id --->
<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
		<cfif isdefined('attributes.recordnum') and attributes.recordnum gt 0>
			<!--- listeden gelen color-size id leri sira ile kaydeder --->
		<cfloop from="1" to="#attributes.recordnum#" index="i">
			<cfquery name="get_color_property_det" datasource="#dsn1#">
					SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.color_id#i#")#" list="yes">
				</cfquery>
				<cfquery name="get_len_property_det" datasource="#dsn1#">
					SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.len_id#i#")#" list="yes"> 
				</cfquery>
			<cfif not len(evaluate("attributes.color_id#i#")) or not len(evaluate("attributes.len_id#i#"))>
				<cfcontinue>
			</cfif>
			<cfloop from="1" to="#attributes.recordnum_size#" index="k">
			<cfif not isdefined("attributes.assortment#i#_#k#")>
				<cfcontinue>
			</cfif>
				<cfquery name="get_size_property_det" datasource="#dsn1#">
					SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.assortment_id#i#_#k#")#" list="yes"> 
				</cfquery>
			
            	
	
			<cfif isdefined("attributes.stock_id#i#_#k#") and len(evaluate("attributes.stock_id#i#_#k#"))>
				<cfset updstock_id=evaluate("attributes.stock_id#i#_#k#")>
				<cfquery name="update_sub_stock"  datasource="#DSN1#">
					 UPDATE 
						STOCKS 
					SET 
						PROPERTY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_color_property_det.PROPERTY_DETAIL#-#get_len_property_det.PROPERTY_DETAIL#-#get_size_property_det.PROPERTY_DETAIL#">,
						UPDATE_EMP = #session.ep.userid#,
						UPDATE_IP = '#REMOTE_ADDR#',
						UPDATE_DATE =  #now()# 
					WHERE 
						STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#updstock_id#">	
				</cfquery>
				 <cfquery name="DEL_PROPERTIES" datasource="#DSN1#">
					DELETE FROM STOCKS_PROPERTY WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#updstock_id#">
				</cfquery>
				<cfset dd = 1><!--- dd = 1  listeden gelen birinci deger color id anlamina gelir--->
				<cfloop  list="#property_detail_id#" index="j">
					<cfquery name="ADD_STOCK_PROPERTY" datasource="#DSN1#">
						INSERT INTO
							STOCKS_PROPERTY
						(
							STOCK_ID,
							PROPERTY_ID,
							PROPERTY_DETAIL_ID
						)
						VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#updstock_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#j#">,
							<cfif dd eq 1>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#get_color_property_det.property_detail_id#">
							<cfelseif dd eq 2>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#get_size_property_det.property_detail_id#">
							<cfelseif dd eq 3>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#get_len_property_det.property_detail_id#">
							</cfif>
						)
					</cfquery> 
					<cfset dd = dd+1><!--- dd = 2  listeden gelen ikinci deger size id anlamina gelir--->
				</cfloop>
				<cfcontinue>
			</cfif>	
		
				<cfset stock_count_ = stock_count_ + 1>
				<cftry>
					<cfif isdefined("attributes.is_barkod")>
						<cfquery name="GET_BARCODE_NO_" datasource="#DSN1#">
							SELECT BARCODE FROM PRODUCT_NO
						</cfquery>
						<cfif GET_BARCODE_NO_.recordcount>
							<cfset wrk_barcode = left(trim(GET_BARCODE_NO_.BARCODE),12)>
							<cfquery name="UPDATE_BARCODE_NO_" datasource="#DSN1#">
								UPDATE PRODUCT_NO SET BARCODE = '#wrk_barcode+1#X'<!--- 20050107 buradaki X in onemi yok kontorl karakteri yerine temporary bir deger --->
							</cfquery>
						<cfelse>
							<cfset wrk_barcode = ''>
						</cfif>
						<cfset barkod_no=wrk_barcode>
					</cfif>
					<cfcatch>
	
					</cfcatch>
				</cftry>
				<cfquery name="ADD_SUB_STOCK_CODE" datasource="#DSN1#">
					INSERT INTO 
						STOCKS 
						(
							STOCK_CODE,
							STOCK_CODE_2,
							PRODUCT_ID,
							PROPERTY,
							STOCK_STATUS,
							RECORD_EMP, 
							RECORD_IP, 
							RECORD_DATE,
                            BARCOD,
                            PRODUCT_UNIT_ID
						)
						VALUES 
						(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#pcode#.#stock_count_#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#stock_count.STOCK_CODE_2#.#stock_count_#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_color_property_det.PROPERTY_DETAIL#-#get_size_property_det.PROPERTY_DETAIL#-#get_len_property_det.PROPERTY_DETAIL#">,
							1,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">, 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                            <cfif isdefined("barkod_no") and len(barkod_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#barkod_no#"><cfelse>NULL</cfif>,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_unit_id.product_unit_id#">
						)
				</cfquery>
				<!--- son kaydin ozelliklerini ekler  --->
				<cfquery name="get_max_stock" datasource="#dsn1#">
					SELECT MAX(STOCK_ID) AS MAX_STOCK FROM STOCKS
				</cfquery>
                <!--- stok barkod tablosuna kayit atilir 20140718 --->
                <cfif isdefined("barkod_no") and len(barkod_no)>
                    <cfquery name="ADD_STOCK_BARCODE" datasource="#DSN1#">
                        INSERT INTO
                            STOCKS_BARCODES
                        (
                            STOCK_ID,
                            BARCODE,
                            UNIT_ID
                        )
                        VALUES 
                        (
                            #get_max_stock.MAX_STOCK#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#barkod_no#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_unit_id.product_unit_id#">
                        )
                    </cfquery>
                </cfif>
                <!--- stok barkod tablosuna kayit atilir 20140718 --->
				<cfset dd = 1><!--- dd = 1  listeden gelen birinci deger color id anlamina gelir--->
				<cfloop  list="#property_detail_id#" index="j">
					<cfquery name="ADD_STOCK_PROPERTY" datasource="#DSN1#">
						INSERT INTO
							STOCKS_PROPERTY
						(
							STOCK_ID,
							PROPERTY_ID,
							PROPERTY_DETAIL_ID
						)
						VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_stock.max_stock#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#j#">,
							<cfif dd eq 1>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#get_color_property_det.property_detail_id#">
							<cfelseif dd eq 2>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#get_size_property_det.property_detail_id#">
							<cfelseif dd eq 3>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#get_len_property_det.property_detail_id#">
							</cfif>
						)
					</cfquery> 
					<cfset dd = dd+1><!--- dd = 2  listeden gelen ikinci deger size id anlamina gelir--->
				</cfloop>
                <cfquery name="get_my_periods" datasource="#dsn1#">
                    SELECT * FROM #dsn_alias#.SETUP_PERIOD WHERE OUR_COMPANY_ID IN (SELECT OUR_COMPANY_ID FROM #dsn1_alias#.PRODUCT_OUR_COMPANY WHERE PRODUCT_ID = #product_id#)
                </cfquery>
                <cfloop query="get_my_periods">
                    <cfset temp_dsn = "#DSN#_#PERIOD_YEAR#_#OUR_COMPANY_ID#">
                    <cfquery name="INSRT_STK_ROW" datasource="#dsn1#">
                        INSERT INTO 
                            #temp_dsn#.STOCKS_ROW 
                        (
                            STOCK_ID, 
                            PRODUCT_ID
                        )
                        VALUES 
                        (
                            #GET_MAX_STOCK.MAX_STOCK#, 
                            #PRODUCT_ID#
                        )
					</cfquery>
				</cfloop>
			  </cfloop>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

<cfquery name="stock_count" datasource="#dsn3#">
	SELECT STOCK_ID,STOCK_CODE_2,PRODUCT_UNIT_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
</cfquery>
<cfquery name="get_product_unit_id" datasource="#dsn3#">
	SELECT PRODUCT_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND IS_MAIN = 1
</cfquery>

<cfset stock_count_ = stock_count.recordcount>
<!--- color-size id --->
<cfset property_detail_id = attributes.color_detail_id>
<cfif isdefined("attributes.collar_detail_id_") >
<cfset property_detail_id = listappend(property_detail_id,attributes.collar_detail_id_)>
</cfif>

<cfset property_detail_id = listappend(property_detail_id,attributes.size_detail_id)>
<cfif isdefined("attributes.body_detail_id") >
	<cfset property_detail_id = listappend(property_detail_id,attributes.body_detail_id)>
</cfif>
<!--- //color-size id --->
<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction> 
		<cfif isdefined('attributes.assortment_count') and len(attributes.assortment_count)>
			<!--- listeden gelen color-size id leri sira ile kaydeder --->
			<cfloop from="1" to="#attributes.assortment_count#" index="item">
				<cfif isDefined("attributes.assortment_#item#") >
					<cfloop from="1" to="#listlen(evaluate("attributes.assortment_#item#"))#" index="assorti">
						<cfif listgetat(evaluate("attributes.assortment_#item#"),assorti,',') gt 0 >
							
							<cfif isdefined("attributes.is_barkod")>
								<cfif isdefined("attributes.is_auto_barcode") and attributes.is_auto_barcode eq 0>
									<cfset barkod_no = get_barcode_no()>
								<cfelse>
									<cfset barkod_no = get_barcode_no(1)>
								</cfif>
							</cfif>
							<cfset assort_id = listgetat(evaluate("attributes.assortment_hidden_#item#"),assorti,',')>
							
							<cfquery name="get_color_property_det" datasource="#dsn1#">
								SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(assort_id,1,'-')#" list="yes">
							</cfquery>
								<cfif ListLen(assort_id,'-') eq 4  >
								<cfquery name="get_collar_property_det" datasource="#dsn1#">
									SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(assort_id,2,'-')#" list="yes">
								</cfquery> 
								<cfquery name="get_size_property_det" datasource="#dsn1#">
									SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(assort_id,3,'-')#" list="yes"> 
								</cfquery>
								<cfquery name="get_body_size_property_det" datasource="#dsn1#">
									SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(assort_id,4,'-')#" list="yes"> 
								</cfquery>
							<cfelse>
								<cfquery name="get_size_property_det" datasource="#dsn1#">
									SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(assort_id,2,'-')#" list="yes"> 
								</cfquery>
							</cfif>
							<cfset stock_count_ = stock_count_ + 1>
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
										PRODUCT_UNIT_ID,
										ASSORTMENT_DEFAULT_AMOUNT
									)
									VALUES 
									(
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.pcode#.#stock_count_#">,
										<cfif ListLen(assort_id,'-') eq 4 and   listgetat(assort_id,4,'-') neq 0 and listgetat(assort_id,2,'-') neq 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_id#.#get_color_property_det.PROPERTY_DETAIL#.#get_collar_property_det.PROPERTY_DETAIL#.#get_size_property_det.PROPERTY_DETAIL#.#get_body_size_property_det.PROPERTY_DETAIL#"><cfelseif ListLen(assort_id,'-') eq 4 and  listgetat(assort_id,4,'-') eq 0 and listgetat(assort_id,2,'-') neq 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_id#.#get_color_property_det.PROPERTY_DETAIL#.#get_collar_property_det.PROPERTY_DETAIL#.#get_size_property_det.PROPERTY_DETAIL#"><cfelseif ListLen(assort_id,'-') eq 4 and  listgetat(assort_id,4,'-') neq 0 and listgetat(assort_id,2,'-') eq 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_id#.#get_color_property_det.PROPERTY_DETAIL#.#get_size_property_det.PROPERTY_DETAIL#.#get_body_size_property_det.PROPERTY_DETAIL#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_id#.#get_color_property_det.PROPERTY_DETAIL#.#get_size_property_det.PROPERTY_DETAIL#"></cfif>,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">,
										<cfif ListLen(assort_id,'-') eq 4 and  listgetat(assort_id,4,'-') neq 0 and listgetat(assort_id,2,'-') neq 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_color_property_det.PROPERTY_DETAIL#.#get_collar_property_det.PROPERTY_DETAIL#.#get_size_property_det.PROPERTY_DETAIL#.#get_body_size_property_det.PROPERTY_DETAIL#"><cfelseif ListLen(assort_id,'-') eq 4 and  listgetat(assort_id,4,'-') eq 0 and listgetat(assort_id,2,'-') neq 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_color_property_det.PROPERTY_DETAIL#.#get_collar_property_det.PROPERTY_DETAIL#.#get_size_property_det.PROPERTY_DETAIL#"><cfelseif ListLen(assort_id,'-') eq 4 and listgetat(assort_id,4,'-') neq 0 and listgetat(assort_id,2,'-') eq 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_color_property_det.PROPERTY_DETAIL#.#get_size_property_det.PROPERTY_DETAIL#.#get_body_size_property_det.PROPERTY_DETAIL#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_color_property_det.PROPERTY_DETAIL#.#get_size_property_det.PROPERTY_DETAIL#"></cfif>,
										1,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">, 
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
										<cfif isdefined("barkod_no") and len(barkod_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#barkod_no#"><cfelse>NULL</cfif>,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_unit_id.product_unit_id#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(evaluate("attributes.assortment_#item#"),assorti,',')#">
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
										<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(assort_id,dd,'-')#" list="yes">
									)
								</cfquery> 
								<cfset dd = 2><!--- dd = 2  listeden gelen ikinci deger size id anlamina gelir--->
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
										#attributes.PRODUCT_ID#
									)
								</cfquery>
							</cfloop>
						</cfif>
					</cfloop>
				</cfif>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=product.list_product&event=det&pid=#attributes.product_id#</cfoutput>";
</script>

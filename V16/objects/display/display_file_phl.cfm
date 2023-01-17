<cfset upload_folder = "#upload_folder#store#dir_seperator#" >
<cftry>
	<cffile action = "upload" 
		  fileField = "uploaded_file" 
		  destination = "#upload_folder#"
		  nameConflict = "MakeUnique"  
		  mode="777">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">	
	<!---Script dosyalarını engelle  02092010 FA-ND --->
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
	<cfif listfind(blackList,assetTypeName,',')>
		<cffile action="delete" file="#upload_folder##file_name#">
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='52628.\php\,\jsp\,\asp\,\cfm\,\cfml\ Formatlarında Dosya Girmeyiniz!'>");
			history.back();
		</script>
		<cfabort>
	</cfif>
	
	<cfset file_size = cffile.filesize>
	<cfset dosya_yolu = "#upload_folder##file_name#">
	<cffile action="read" file="#dosya_yolu#" variable="dosya">
	<cffile action="delete" file="#dosya_yolu#">
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='57455.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<cfscript>
	CRLF = Chr(13)&Chr(10); // satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
</cfscript>
<cfif isDefined('attributes.process_cat') and listfind('78,79',evaluate("attributes.ct_process_type_#attributes.process_cat#"),',')>
	<cfset attributes.is_iade = true>
<cfelse>
	<cfset attributes.is_iade = false>
</cfif>

<cfset barcod_list="">
<cfloop from="1" to="#line_count#" index="k">
	<cfif not listfind(barcod_list,trim(ListGetAt(dosya[k],1,";")),",")>
		<cfset barcod_list = ListAppend(barcod_list,trim(ListGetAt(dosya[k],1,";")),",")>
	</cfif>
</cfloop>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33853.PHL Döküman İçeriği'></cfsavecontent>
	<cfsavecontent variable="right_images"><li><a href="<cfoutput>#request.self#?fuseaction=objects.add_order_from_file&from_where=#attributes.from_where#</cfoutput>"><i class="fa fa-barcode"></i></a></li></cfsavecontent>

<cf_box title="#message#" right_images="#right_images#" uidrop="1">
<cf_grid_list>
	<thead>
		<tr>
			<th width="70"><cf_get_lang dictionary_id='57633.Barkod'></th>
			<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
			<th><cf_get_lang dictionary_id='57657.Ürün'></th>
			<th><cf_get_lang dictionary_id='57634.Üretici Kodu'></th>			
			<th><cf_get_lang dictionary_id='57635.Miktar'></th>						
		</tr>
    </thead>
    <tbody>
		<cftry>
			<cfquery name="get_product_main_all" datasource="#dsn3#">
				SELECT
				<cfif not isdefined('from_add_order_report') and not (isdefined('attributes.stock_identity_type_') and listfind('2,3',attributes.stock_identity_type_))>
					GSB.BARCODE,
				<cfelse>
					S.BARCOD AS BARCODE,
				</cfif>
					S.STOCK_ID,
					S.PRODUCT_ID,
					S.STOCK_CODE,
					S.STOCK_CODE_2,
					S.PRODUCT_NAME,
					S.PROPERTY,
					S.IS_INVENTORY,
					S.IS_PRODUCTION,
					S.MANUFACT_CODE,
					S.TAX_PURCHASE,
					S.TAX,
					S.OTV,
					PU.ADD_UNIT,
					PU.PRODUCT_UNIT_ID,
					PU.MULTIPLIER,
					P.PRICE,
					<cfif session.ep.period_year gte 2009>
						CASE WHEN MONEY ='YTL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE P.MONEY END AS MONEY
					<cfelseif session.ep.period_year lt 2009>
						CASE WHEN MONEY ='TL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE P.MONEY END AS MONEY
					<cfelse>
						P.MONEY
					</cfif> 
				FROM
					STOCKS AS S,
					PRODUCT_UNIT AS PU,
					<cfif not isdefined('from_add_order_report') and not (isdefined('attributes.stock_identity_type_') and listfind('2,3',attributes.stock_identity_type_))>
					GET_STOCK_BARCODES AS GSB,
					</cfif>
					<cfif isdefined('attributes.phl_price_catid_') and len(attributes.phl_price_catid_) and attributes.phl_price_catid_ neq -2><!--- phl dosyasında fiyat listesi secilmis ise --->
					PRICE P
					<cfelse>
					PRICE_STANDART P
					</cfif>
				WHERE
				<cfif isdefined('attributes.phl_price_catid_') and len(attributes.phl_price_catid_) and attributes.phl_price_catid_ neq -2><!--- phl dosyasında fiyat listesi secilmis ise --->
					P.PRICE_CATID=#attributes.phl_price_catid_# AND
				<cfelse>
					<cfif attributes.is_iade>
							P.PURCHASESALES = 0 AND
					<cfelse>
							P.PURCHASESALES = 1 AND
					</cfif>
					P.PRICESTANDART_STATUS = 1 AND
				</cfif>
				<cfif not isdefined('from_add_order_report')>
					<cfif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 3><!--- özel kod --->
						S.STOCK_CODE_2 IN (#trim(ListQualify(barcod_list,"'",","))#) AND
					<cfelseif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 2><!--- stok kodu--->
						S.STOCK_CODE IN (#trim(ListQualify(barcod_list,"'",","))#) AND
					<cfelse><!--- barkod--->
						GSB.BARCODE IN (#trim(ListQualify(barcod_list,"'",","))#) AND
					</cfif>
				<cfelseif isdefined('attributes.row_stock_id') and len(attributes.row_stock_id)>
					S.STOCK_ID IN (#attributes.row_stock_id#) AND
				</cfif>
					S.PRODUCT_STATUS = 1 AND
					S.STOCK_STATUS = 1 AND
				<cfif not (isDefined('attributes.process_cat') and evaluate("attributes.ct_process_type_#attributes.process_cat#") eq 78)>
				<!--- alım iade irsaliyelerinde, alısı yapılmıs bi urunun tedarik ediliyor secenegini kaldırıldıktan sonra iade edilebilmesi icin --->
					<cfif attributes.is_iade>
						S.IS_PURCHASE = 1 AND
					<cfelse>
						S.IS_SALES = 1 AND
					</cfif>
				</cfif>
				<cfif isdefined('attributes.phl_price_catid_') and len(attributes.phl_price_catid_) and attributes.phl_price_catid_ neq -2><!---phl ekranında fiyat listesi secilmisse --->
					<cfif isdefined("attributes.ship_date") and isdate(attributes.ship_date)>
						P.STARTDATE <= #attributes.ship_date# AND (P.FINISHDATE >= #attributes.ship_date# OR P.FINISHDATE IS NULL) AND
					<cfelseif isdefined("attributes.order_date") and isdate(attributes.order_date)> 
						P.STARTDATE <= #attributes.order_date# AND (P.FINISHDATE >= #attributes.order_date# OR P.FINISHDATE IS NULL) AND
					<cfelseif isdefined("attributes.target_date") and isdate(attributes.target_date)> 
						P.STARTDATE <= #attributes.target_date# AND (P.FINISHDATE >= #attributes.target_date# OR P.FINISHDATE IS NULL) AND
					</cfif>
				<cfelse>
					<cfif isdefined("attributes.ship_date") and isdate(attributes.ship_date)>
						P.START_DATE <= #attributes.ship_date# AND
					<cfelseif isdefined("attributes.order_date") and isdate(attributes.order_date)> 
						P.START_DATE <= #attributes.order_date# AND
					<cfelseif isdefined("attributes.target_date") and isdate(attributes.target_date)> 
						P.START_DATE <= #attributes.target_date# AND
					</cfif>
					
				</cfif>
					P.PRODUCT_ID = S.PRODUCT_ID AND
				<cfif isdefined('attributes.phl_price_catid_') and len(attributes.phl_price_catid_) and attributes.phl_price_catid_ neq -2>
					PU.PRODUCT_UNIT_ID = P.UNIT AND
				<cfelse>
					PU.PRODUCT_UNIT_ID = P.UNIT_ID AND
				</cfif>
				<cfif not isdefined('from_add_order_report') and not (isdefined('attributes.stock_identity_type_') and listfind('2,3',attributes.stock_identity_type_))>
					S.STOCK_ID = GSB.STOCK_ID AND
				</cfif>
					S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
					S.PRODUCT_ID = PU.PRODUCT_ID
				ORDER BY
					<cfif isdefined('attributes.phl_price_catid_') and len(attributes.phl_price_catid_) and attributes.phl_price_catid_ neq -2>STARTDATE<cfelse>START_DATE</cfif> DESC,
					<cfif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 3>
						S.STOCK_CODE_2
					<cfelseif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 2>
						S.STOCK_CODE
					<cfelse>
						GSB.BARCODE
					</cfif>
			</cfquery>
		<cfif not get_product_main_all.recordcount>
			<cfquery name="get_product_main_all" datasource="#dsn3#">
				SELECT
					<cfif not (isdefined('attributes.stock_identity_type_') and listfind('2,3',attributes.stock_identity_type_))>
					GSB.BARCODE,
					<cfelse>
					S.BARCOD AS BARCODE,
					</cfif>
					S.STOCK_ID,
					S.PRODUCT_ID,
					S.STOCK_CODE,
					S.PROPERTY,					
					P.PRODUCT_NAME,
					P.MANUFACT_CODE,
					S.STOCK_CODE_2
				FROM
					PRODUCT P,
					STOCKS AS S
					<cfif not (isdefined('attributes.stock_identity_type_') and listfind('2,3',attributes.stock_identity_type_))>
					,GET_STOCK_BARCODES AS GSB
					</cfif>
				WHERE
					P.PRODUCT_ID=S.PRODUCT_ID AND
					<cfif not (isdefined('attributes.stock_identity_type_') and listfind('2,3',attributes.stock_identity_type_))>
					S.STOCK_ID=GSB.STOCK_ID AND
					</cfif>
					<cfif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 3><!--- özel kod --->
						S.STOCK_CODE_2 IN (#trim(ListQualify(barcod_list,"'",","))#)
					<cfelseif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 2><!--- stok kodu--->
					S.STOCK_CODE IN (#trim(ListQualify(barcod_list,"'",","))#)
					<cfelse><!--- barkod--->
					GSB.BARCODE IN (#trim(ListQualify(barcod_list,"'",","))#)
					</cfif>
				ORDER BY
					<cfif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 3>
						S.STOCK_CODE_2
					<cfelseif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 2>
						S.STOCK_CODE
					<cfelse>
						GSB.BARCODE
					</cfif>
			</cfquery>
			</cfif>
			<cfif get_product_main_all.recordcount>
				<cfloop from="1" to="#line_count#" index="k">
					<cfset barkod_no = ListGetAt(dosya[k],1,";")>
					<cfquery name="get_product_main" dbtype="query" maxrows="1">
						SELECT
							BARCODE,
							STOCK_ID,
							PRODUCT_ID,
							STOCK_CODE,
							PROPERTY,
							PRODUCT_NAME,
							MANUFACT_CODE
						FROM
							get_product_main_all
						WHERE
							<cfif not (isdefined('attributes.row_stock_id') and len(attributes.row_stock_id))>
								<cfif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 3><!--- özel kod --->
								STOCK_CODE_2 = '#barkod_no#'
								<cfelseif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 2><!--- stok kodu--->
								STOCK_CODE = '#barkod_no#'
								<cfelse><!--- barkod--->
								BARCODE = '#barkod_no#'
								</cfif>
							<cfelseif isdefined('attributes.row_stock_id') and len(attributes.row_stock_id)>
								STOCK_ID=#listgetat(attributes.row_stock_id,k)#
							</cfif>
						ORDER BY
							<cfif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 3>
								STOCK_CODE_2
							<cfelseif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 2>
								STOCK_CODE
							<cfelse>
								BARCODE
							</cfif>
					</cfquery>
					<cfif get_product_main.recordcount>
						<cfoutput>
						<tr>
							<td>#get_product_main.BARCODE#</td>
							  <td>#get_product_main.STOCK_CODE#</td>
							  <td>#get_product_main.PRODUCT_NAME# #get_product_main.PROPERTY#</td>
							  <td>#get_product_main.MANUFACT_CODE#</td>
							  <td>#ListGetAt(dosya[k],2,";")#</td>
						</tr>
						</cfoutput>
					</cfif>
				</cfloop>
			</cfif>
			<cfcatch></cfcatch>
		</cftry>
	  </tbody>
	</cf_grid_list>
</cf_box>
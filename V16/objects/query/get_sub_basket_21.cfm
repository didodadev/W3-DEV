<cfif not isdefined('from_add_order_report')>
	<cfset upload_folder = "#upload_folder#store#dir_seperator#" >
	<cftry>
		<cfif not isDefined("attributes.dosya_content")>		
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
					alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
					history.back();
				</script>
				<cfabort>
			</cfif>
			<cfset file_size = cffile.filesize>
		</cfif>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
	<cffile action="read" file="#upload_folder##file_name#" variable="dosya">
</cfif>
<cfscript>
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.total = 0;
	sepet.toplam_indirim = 0;
	sepet.total_tax = 0;
	sepet.total_otv = 0;
	sepet.net_total = 0;
	sepet.genel_indirim = 0;
	i = 0;
	if(not isdefined('from_add_order_report'))
	{
		CRLF = Chr(13) & Chr(10);
		dosya = Replace(dosya,';;','; ;','all');
		dosya = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya);
	}
	else if(isdefined('attributes.row_stock_id') and len(attributes.row_stock_id)) //stock_id listesi
	{
		line_count=listlen(attributes.row_stock_id);
	}
</cfscript>
<cfif isDefined('attributes.process_cat') and listfind('78,79',evaluate("attributes.ct_process_type_#attributes.process_cat#"),',')>
	<cfset attributes.is_iade = true>
<cfelse>
	<cfset attributes.is_iade = false>
</cfif>
<cfif isdefined("attributes.ship_date")>
	<cf_date tarih = "attributes.ship_date">
<cfelseif isdefined("attributes.order_date")> 
	<cf_date tarih = "attributes.order_date">
<cfelseif isdefined("attributes.target_date")> 
	<cf_date tarih = "attributes.target_date">
</cfif>
<cfset barcod_list="">
<cfif not isdefined('from_add_order_report')>
	<cffile action="delete" file="#upload_folder##file_name#">
	<!--- tum datalarin query of queris yapmak icin onceden alinmasi --->
	<cfloop from="1" to="#line_count#" index="k">
		<cfif not listfind(barcod_list,trim(ListGetAt(dosya[k],1,";")),",")>
			<cfset barcod_list = ListAppend(barcod_list,trim(ListGetAt(dosya[k],1,";")),",")>
		</cfif>
	</cfloop>
	<cfif not listlen(barcod_list)>
		<script type="text/javascript">
			alert('Belgenizde Barkod Listesi Bulunamadı. Lütfen Belgenizi Kontrol Ediniz !');
			window.history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<!--- fiyatları stock_id ye göre çekiyor, lütfen bozmayın Mahmut Çifçi 13.07.2019 --->
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
		,PU2.ADD_UNIT AS UNIT2
	FROM
		STOCKS AS S
		LEFT JOIN PRODUCT_UNIT AS PU2 ON S.PRODUCT_ID = PU2.PRODUCT_ID AND PU2.IS_ADD_UNIT = 1,
		PRODUCT_UNIT AS PU,
		<cfif not isdefined('from_add_order_report') and not (isdefined('attributes.stock_identity_type_') and listfind('2,3',attributes.stock_identity_type_))>
		GET_STOCK_BARCODES AS GSB,
		</cfif>
		<cfif (isdefined('attributes.phl_price_catid_') and len(attributes.phl_price_catid_) and attributes.phl_price_catid_ neq -2) OR ( isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head))><!--- phl dosyasında fiyat listesi secilmis ise --->
		PRICE P
		<cfelse>
		PRICE_STANDART P
		</cfif>
	WHERE
    <cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
    	P.PRICE_CATID IN (SELECT TOP 1 PRICE_CATID FROM PROJECT_DISCOUNTS WHERE PROJECT_ID = #attributes.project_id#) AND
	<cfelseif isdefined('attributes.phl_price_catid_') and len(attributes.phl_price_catid_) and attributes.phl_price_catid_ neq -2><!--- phl dosyasında fiyat listesi secilmis ise --->
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
    <cfelseif  isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)><!---projeden fiyat listesi --->
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
	<cfif isdefined('attributes.phl_price_catid_') and len(attributes.phl_price_catid_) and attributes.phl_price_catid_ neq -2>
		P.STOCK_ID = S.STOCK_ID AND
		PU.PRODUCT_UNIT_ID = P.UNIT AND
	<cfelseif  isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
		P.PRODUCT_ID = S.PRODUCT_ID AND
    	PU.PRODUCT_UNIT_ID = P.UNIT AND
	<cfelse>
		P.PRODUCT_ID = S.PRODUCT_ID AND
		PU.PRODUCT_UNIT_ID = P.UNIT_ID AND
	</cfif>
	<cfif not isdefined('from_add_order_report') and not (isdefined('attributes.stock_identity_type_') and listfind('2,3',attributes.stock_identity_type_))>
		S.STOCK_ID = GSB.STOCK_ID AND
	</cfif>
		S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
		S.PRODUCT_ID = PU.PRODUCT_ID
	ORDER BY
		<cfif isdefined('attributes.phl_price_catid_') and len(attributes.phl_price_catid_) and attributes.phl_price_catid_ neq -2>
        	STARTDATE
        <cfelseif  isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
        	STARTDATE
        <cfelse>
        	START_DATE
        </cfif> DESC,
		<cfif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 3>
			S.STOCK_CODE_2
		<cfelseif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 2>
			S.STOCK_CODE
		<cfelse>
			GSB.BARCODE
		</cfif>
</cfquery>
<cfset urun_listesi = listdeleteduplicates(ValueList(get_product_main_all.PRODUCT_ID),',')>
<cfif not listlen(urun_listesi)>
	<script type="text/javascript">
		<cfif not isdefined('from_add_order_report')>
			alert('Belgenizdeki <cfif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 3>Özel Kodlara<cfelseif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 2>Stok Kodlarına<cfelse>Barkodlara</cfif> Ait Hiçbir Ürün Bulunamadı. Lütfen Belgenizi Kontrol Ediniz !');
		<cfelse>
			alert('Seçilen Fiyat Listesi İçin, Ürün Fiyatları Tanımlı Değil!');
		</cfif>
		window.history.back();
	</script>
	<cfabort>
</cfif>
<cfif attributes.is_iade>
	<cfquery name="get_aksiyons_all" datasource="#dsn3#">
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
			CP.KONDUSYON_DATE,
			CP.KONDUSYON_FINISH_DATE,
			CP.CATALOG_ID
		FROM
			CATALOG_PROMOTION AS CP,
			CATALOG_PROMOTION_PRODUCTS AS CPP,
			CATALOG_PRICE_LISTS CPL,
			PRICE_CAT PCAT
		WHERE
			CPP.PRODUCT_ID IN (#urun_listesi#) AND
			CP.IS_APPLIED = 1 AND
		<cfif isdate(attributes.ship_date)>
			KONDUSYON_DATE <= #attributes.ship_date# AND
			KONDUSYON_FINISH_DATE > #attributes.ship_date# AND
		<cfelse>
			KONDUSYON_DATE <= #now()# AND
			KONDUSYON_FINISH_DATE > #now()# AND
		</cfif>
		<cfif len(attributes.branch_id)>
			BRANCH LIKE ',#attributes.branch_id#,' AND
		</cfif>
			CPP.CATALOG_ID = CP.CATALOG_ID AND
			CPL.CATALOG_PROMOTION_ID = CP.CATALOG_ID AND
			CPL.PRICE_LIST_ID = PCAT.PRICE_CATID
		ORDER BY
			CP.CATALOG_ID DESC
	</cfquery>
	<cfquery name="get_contracts_all" datasource="#dsn3#">
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
			CONTRACT_PURCHASE_PROD_DISCOUNT.PRODUCT_ID IN (#urun_listesi#) AND
		<cfif isdate(attributes.ship_date)>
			(
				START_DATE <= #attributes.ship_date# AND
				(FINISH_DATE >= #attributes.ship_date# OR FINISH_DATE IS NULL)
			)
		<cfelse>
			START_DATE <= #now()# AND
			FINISH_DATE >= #now()#
		</cfif>
	</cfquery>
	<cfif isdefined('attributes.company_id') and len(attributes.company_id) and isdefined("attributes.branch_id") and isnumeric(attributes.branch_id)><!--- // indirimler anlaşmada genel indirimler tanımlı ise --->
		<cfquery name="get_c_general_discounts" datasource="#dsn3#" maxrows="5">
			SELECT
				DISCOUNT
			FROM
				CONTRACT_PURCHASE_GENERAL_DISCOUNT AS CPGD,
				CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES CPGD_B
			WHERE
				CPGD.GENERAL_DISCOUNT_ID = CPGD_B.GENERAL_DISCOUNT_ID
				AND CPGD_B.BRANCH_ID = #attributes.branch_id#
				AND CPGD.COMPANY_ID=#attributes.company_id#
			<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
				AND CPGD.START_DATE <= #attributes.search_process_date#
				AND CPGD.FINISH_DATE >= #attributes.search_process_date#
			<cfelse>
				AND CPGD.START_DATE <= #now()#
				AND CPGD.FINISH_DATE >= #now()#
			</cfif>
			ORDER BY
				CPGD.GENERAL_DISCOUNT_ID
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_aksiyons_all.recordcount = 0>
	<cfquery name="get_contracts_all" datasource="#dsn3#">
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
			C_S_PROD_DISCOUNT_ID AS DISCOUNT_ID
		FROM
			CONTRACT_SALES_PROD_DISCOUNT
		WHERE
			CONTRACT_SALES_PROD_DISCOUNT.PRODUCT_ID IN (#urun_listesi#) AND
		<cfif isdefined("attributes.ship_date") and isdate(attributes.ship_date)>
			(
				START_DATE <= #attributes.ship_date# AND
				(FINISH_DATE >= #attributes.ship_date# OR FINISH_DATE IS NULL)
			)
		<cfelseif isdefined("attributes.order_date") and isdate(attributes.order_date)> 
			(
				START_DATE <= #attributes.order_date# AND
				(FINISH_DATE >= #attributes.order_date# OR FINISH_DATE IS NULL)
			)
		<cfelseif isdefined("attributes.target_date") and isdate(attributes.target_date)> 
			(
				START_DATE <= #attributes.target_date# AND
				(FINISH_DATE >= #attributes.target_date# OR FINISH_DATE IS NULL)
			)
		<cfelse>
			START_DATE <= #now()# AND
			FINISH_DATE >= #now()#
		</cfif>
	</cfquery>
	<cfif isdefined('attributes.company_id') and len(attributes.company_id) and isdefined("attributes.branch_id") and isnumeric(attributes.branch_id)><!--- // indirimler anlaşmada genel indirimler tanımlı ise --->
		<cfquery name="get_c_general_discounts" datasource="#dsn3#" maxrows="5">
			SELECT
				DISCOUNT
			FROM
				CONTRACT_SALES_GENERAL_DISCOUNT AS CS_GD,
				CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES CS_GDB
			WHERE
				CS_GD.GENERAL_DISCOUNT_ID = CS_GDB.GENERAL_DISCOUNT_ID
				AND CS_GDB.BRANCH_ID = #attributes.branch_id#
				AND CS_GD.COMPANY_ID = #attributes.company_id#
			<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
				AND CS_GD.START_DATE <= #attributes.search_process_date#
				AND CS_GD.FINISH_DATE >= #attributes.search_process_date#
			<cfelse>
				AND CS_GD.START_DATE <= #now()#
				AND CS_GD.FINISH_DATE >= #now()#
			</cfif>
			ORDER BY
				CS_GD.GENERAL_DISCOUNT_ID
		</cfquery>
	</cfif>
</cfif>
<!--- //tum datalarin query of queris yapmak icin onceden alinmasi --->
<cfloop from="1" to="#line_count#" index="k">
	<cfset dosya[k] = Replace(dosya[k],';;','; ;','all')>
	<cfset dosya[k] = Replace(dosya[k],';;','; ;','all')>
	<cfset project_name = "">
	<cfset project_id = "">
	<cfset row_lot_no = "">
	
	<cftry>
		<cfif not (isdefined('attributes.row_stock_id') and len(attributes.row_stock_id))>
			<cfset miktar = replace(ListGetAt(dosya[k],2,";"),",",".","all")>
			<cfset barkod_no = ListGetAt(dosya[k],1,";")>
            <cfif listlen(dosya[k],';') gte 4>
                <cfset spect_main_id = trim(ListGetAt(dosya[k],4,";"))>
            <cfelse>
                <cfset spect_main_id = ''>
            </cfif>
			<cfif attributes.from_where eq 3>
            	<cfif listlen(dosya[k],';') gte 5>
					<cfset row_lot_no = trim(ListGetAt(dosya[k],5,";"))>
                <cfelse>
                    <cfset row_lot_no = ''>
				</cfif>
                <cfif listlen(dosya[k],';') gte 6>
					<cfset project_id = trim(ListGetAt(dosya[k],6,";"))>
					<cfif len(project_id)>
						<cfquery name="GET_PROJECT" datasource="#dsn#">
							SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #project_id#
						</cfquery>
						<cfset project_name = GET_PROJECT.PROJECT_HEAD>
					<cfelse>
						<cfset project_name = "">
					</cfif>
                <cfelse>
                    <cfset project_id = ''>
                    <cfset project_name = ''>
				</cfif>
                <cfif listlen(dosya[k],';') gte 7><!--- Açıklama 2--->
                    <cfset row_detail = trim(ListGetAt(dosya[k],7,";"))>
                <cfelse>
                    <cfset row_detail = ''>
                </cfif>
                <cfset deliver_date = ''>
			<cfelse>
				<cfset row_lot_no = ''>
				<cfif listlen(dosya[k],';') gte 5>
                    <cfset deliver_date = trim(ListGetAt(dosya[k],5,";"))>
                <cfelse>
                    <cfset deliver_date = ''>
				</cfif>
				<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
					<cfset project_id = attributes.project_id>
					<cfquery name="GET_PROJECT" datasource="#dsn#">
						SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #project_id#
					</cfquery>
					<cfset project_name = GET_PROJECT.PROJECT_HEAD>
				<cfelse>
					<cfset project_id = ''>
                    <cfset project_name = ''>
				</cfif>
                <cfif listlen(dosya[k],';') gte 6>
                    <cfset row_detail = trim(ListGetAt(dosya[k],6,";"))>
                <cfelse>
                    <cfset row_detail = ''>
                </cfif>
            </cfif>
		<cfelse>
			<cfif isdefined('stock_order_amount_#listgetat(attributes.row_stock_id,k)#') and len(evaluate('stock_order_amount_#listgetat(attributes.row_stock_id,k)#'))>
				<cfset miktar = filterNum(evaluate('stock_order_amount_#listgetat(attributes.row_stock_id,k)#'),price_round_number)>
			<cfelse>
				<cfset miktar =1>
			</cfif>
			<cfif listlen(dosya[k],';') gte 4>
				<cfset spect_main_id = trim(ListGetAt(dosya[k],4,";"))>
			<cfelse>
				<cfset spect_main_id = ''>
			</cfif>
			<cfif listlen(dosya[k],';') gte 5>
				<cfset deliver_date = trim(ListGetAt(dosya[k],5,";"))>
			<cfelse>
				<cfset deliver_date = ''>
			</cfif>
		</cfif>
		<cfcatch>
			<cfset miktar = 1>
		</cfcatch>
	</cftry>
	<cfif isnumeric(miktar) and miktar neq 0>
		<cfquery name="get_product_main" dbtype="query">
			SELECT 
				BARCODE,
				STOCK_ID,
				PRODUCT_ID,
				STOCK_CODE,
				PRODUCT_NAME,
				IS_INVENTORY,
				IS_PRODUCTION,
				MANUFACT_CODE,
				TAX_PURCHASE,
				TAX,
				OTV,
				ADD_UNIT,
				PRODUCT_UNIT_ID,
				MULTIPLIER,
				PRICE,
				MONEY,
				PROPERTY,
				STOCK_CODE_2,
				UNIT2
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
			<cfset row_rate_info=1>
			<cfif isdefined('attributes.row_stock_id') and len(attributes.row_stock_id)>
				<cfset barkod_no=get_product_main.BARCODE>
			</cfif>
			<cfif not (isdefined('attributes.row_stock_id') and len(attributes.row_stock_id)) and listlen(dosya[k],';') gte 3 and len(trim(ListGetAt(dosya[k],3,";")))>
				<cfif get_product_main.MONEY eq SESSION.EP.MONEY>
					<cfset FIYAT =  replace(ListGetAt(dosya[k],3,";"),",",".","all")>
					<cfset FIYAT_OTHER = replace(ListGetAt(dosya[k],3,";"),",",".","all")>
				<cfelse>
					<cfquery name="get_rate" datasource="#DSN#">SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY='#get_product_main.MONEY#'</cfquery>
					<cfset row_rate_info=(get_rate.RATE2/get_rate.RATE1)>
					<cfset FIYAT = replace(ListGetAt(dosya[k],3,";"),",",".","all") * (get_rate.RATE2/get_rate.RATE1)>
					<cfset FIYAT_OTHER = replace(ListGetAt(dosya[k],3,";"),",",".","all")>	
				</cfif>
			<cfelseif get_product_main.MONEY eq SESSION.EP.MONEY>
				<cfset FIYAT = get_product_main.PRICE>
				<cfset FIYAT_OTHER = get_product_main.PRICE>
			<cfelse>
				<cfquery name="get_rate" datasource="#DSN#">SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY='#get_product_main.MONEY#'</cfquery>
				<cfset row_rate_info=(get_rate.RATE2/get_rate.RATE1)>
				<cfset FIYAT = get_product_main.PRICE * (get_rate.RATE2/get_rate.RATE1)>
				<cfset FIYAT_OTHER = get_product_main.PRICE >	
			</cfif>
			<cfif isdefined("spect_main_id") and len(spect_main_id)>
				<cfquery name="control_spect_main" datasource="#dsn3#">
                	SELECT SPECT_MAIN_ID FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #spect_main_id# AND STOCK_ID = #get_product_main.stock_id#
                </cfquery>
            	<cfif control_spect_main.recordcount>
					<cfscript>
                        new_cre_spect_id = specer(
                            dsn_type:dsn3,
                            add_to_main_spec:1,
                            main_spec_id:spect_main_id
                        );
                    </cfscript>
                </cfif>
				<cfif isdefined("new_cre_spect_id") and len(new_cre_spect_id)>
					<cfset spect_var_id_row = listgetat(new_cre_spect_id,2,',')>
					<cfset spect_var_name_row = listgetat(new_cre_spect_id,3,',')>
				<cfelse>
					<cfset spect_var_id_row = ''>
					<cfset spect_var_name_row = ''>
				</cfif>
			<cfelse>
				<cfset spect_var_id_row = ''>
				<cfset spect_var_name_row = ''>
			</cfif>
			<cfscript>
				i = i+1;
				sepet.satir[i] = StructNew();
				
				sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
				sepet.satir[i].wrk_row_relation_id = '';
				sepet.satir[i].spect_id = spect_var_id_row;
				sepet.satir[i].spect_name = spect_var_name_row;
				sepet.satir[i].product_id = get_product_main.PRODUCT_ID;
				sepet.satir[i].is_inventory = get_product_main.IS_INVENTORY;
				sepet.satir[i].is_production = get_product_main.IS_PRODUCTION;
				sepet.satir[i].product_name = get_product_main.PRODUCT_NAME&' '&get_product_main.PROPERTY;
				sepet.satir[i].amount = Int(miktar);
				sepet.satir[i].unit = get_product_main.add_unit;
				sepet.satir[i].unit_id = get_product_main.PRODUCT_UNIT_ID;
				if(len(get_product_main.unit2) ) sepet.satir[i].unit_other = get_product_main.unit2; else sepet.satir[i].unit_other = "";
				sepet.satir[i].product_name_other = row_detail;
				if(len(trim(FIYAT)))
				{
					sepet.satir[i].price = FIYAT;	
					sepet.satir[i].price_other = FIYAT_OTHER;
				}
				else
				{
					sepet.satir[i].price = 0;	
					sepet.satir[i].price_other = 0;
				}
				sepet.satir[i].indirim1 =0;
				sepet.satir[i].indirim2 =0;
				sepet.satir[i].indirim3 =0;
				sepet.satir[i].indirim4 =0;
				sepet.satir[i].indirim5 =0;
				sepet.satir[i].indirim6 = 0;
				sepet.satir[i].indirim7 = 0;
				sepet.satir[i].indirim8 = 0;
				sepet.satir[i].indirim9 = 0;
				sepet.satir[i].indirim10= 0;
				sepet.satir[i].row_project_id = project_id;
				sepet.satir[i].row_project_name = project_name;
			</cfscript>
			<cfif get_aksiyons_all.recordcount>
				<cfquery name="get_aksiyons" dbtype="query" maxrows="1">
					SELECT
						DISCOUNT1,
						DISCOUNT2,
						DISCOUNT3,
						DISCOUNT4,
						DISCOUNT5,
						DISCOUNT6,
						DISCOUNT7,
						DISCOUNT8,
						DISCOUNT9,
						DISCOUNT10,
						PURCHASE_PRICE,
						MONEY
					FROM
						get_aksiyons_all
					WHERE
						PRODUCT_ID = #get_product_main.PRODUCT_ID#
					ORDER BY
						CATALOG_ID DESC
				</cfquery>
			<cfelse>
				<cfset get_aksiyons.recordcount = 0>
			</cfif>
			<!--- EGER IADE ISE CALISACAK --->
			<cfif attributes.is_iade>
				<cfscript>
				if(get_aksiyons.recordcount){
					if(len(get_aksiyons.discount1))sepet.satir[i].indirim1 = get_aksiyons.discount1;
					if(len(get_aksiyons.discount2))sepet.satir[i].indirim2 = get_aksiyons.discount2;
					if(len(get_aksiyons.discount3))sepet.satir[i].indirim3 = get_aksiyons.discount3;
					if(len(get_aksiyons.discount4))sepet.satir[i].indirim4 = get_aksiyons.discount4;
					if(len(get_aksiyons.discount5))sepet.satir[i].indirim5 = get_aksiyons.discount5;
					if(len(get_aksiyons.PURCHASE_PRICE))sepet.satir[i].price = get_aksiyons.PURCHASE_PRICE;
					}
				</cfscript>
			</cfif>
			<cfif (not get_aksiyons.recordcount) and get_contracts_all.recordcount>
				<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
					<cfquery name="get_contracts" dbtype="query" maxrows="1">
						SELECT DISCOUNT1,DISCOUNT2,DISCOUNT3,DISCOUNT4,DISCOUNT5
						FROM
							get_contracts_all
						WHERE
							PRODUCT_ID = #get_product_main.PRODUCT_ID# AND
							COMPANY_ID = #attributes.company_id#
						ORDER BY
							 DISCOUNT_ID DESC
					</cfquery>
					<cfif not get_contracts.recordcount>
						<cfquery name="get_contracts" dbtype="query" maxrows="1">
							SELECT DISCOUNT1,DISCOUNT2,DISCOUNT3,DISCOUNT4,DISCOUNT5
							FROM
								get_contracts_all
							WHERE
								PRODUCT_ID = #get_product_main.PRODUCT_ID# AND
								COMPANY_ID IS NULL
							ORDER BY
								DISCOUNT_ID DESC
						</cfquery>
					</cfif>
				<cfelse>
					<cfquery name="get_contracts" dbtype="query" maxrows="1">
						SELECT DISCOUNT1,DISCOUNT2,DISCOUNT3,DISCOUNT4,DISCOUNT5
						FROM
							get_contracts_all
						WHERE
							PRODUCT_ID = #get_product_main.PRODUCT_ID# AND
							COMPANY_ID IS NULL
						ORDER BY
							DISCOUNT_ID DESC
					</cfquery>
				</cfif>
				<!--- EGER IADE ISE CALISACAK --->
				<!--- <cfif attributes.is_iade> --->
					<cfscript>
						if(get_contracts.recordcount){
						if(len(get_contracts.discount1))sepet.satir[i].indirim1 = get_contracts.discount1;
						if(len(get_contracts.discount2))sepet.satir[i].indirim2 = get_contracts.discount2;
						if(len(get_contracts.discount3))sepet.satir[i].indirim3 = get_contracts.discount3;
						if(len(get_contracts.discount4))sepet.satir[i].indirim4 = get_contracts.discount4;
						if(len(get_contracts.discount5))sepet.satir[i].indirim5 = get_contracts.discount5;
						}
					</cfscript>
				<!--- </cfif> --->
			</cfif>
			<cfif isdefined('get_c_general_discounts') and get_c_general_discounts.recordcount><!--- genel indirimlerden gelen iskontolar --->
				<cfloop query="get_c_general_discounts">
					<cfset 'row_disc_#currentrow+5#' = get_c_general_discounts.DISCOUNT>
				</cfloop>
			</cfif>
			<cfscript>
				/* doğtaş irsaliye importu için kapatıldı.
				if( listlen(dosya[k],";") gte 4 and len(ListGetAt(dosya[k],4,";")) )
					sepet.satir[i].indirim1 =ListGetAt(dosya[k],4,";");
					
				if( listlen(dosya[k],";") gte 5 and len(ListGetAt(dosya[k],5,";")) )
					sepet.satir[i].indirim2 =ListGetAt(dosya[k],5,";");
					
				if( listlen(dosya[k],";") gte 6 and len(ListGetAt(dosya[k],6,";")) )
					sepet.satir[i].indirim3 =ListGetAt(dosya[k],6,";");
					
				if( listlen(dosya[k],";") gte 7 and len(ListGetAt(dosya[k],7,";")) )
					sepet.satir[i].indirim4 =ListGetAt(dosya[k],7,";");
					*/
				
				if(isdefined('row_disc_6') and len(row_disc_6)) sepet.satir[i].indirim6 = row_disc_6;
				if(isdefined('row_disc_7') and len(row_disc_7)) sepet.satir[i].indirim7 = row_disc_7;
				if(isdefined('row_disc_8') and len(row_disc_8)) sepet.satir[i].indirim8 = row_disc_8;
				if(isdefined('row_disc_9') and len(row_disc_9)) sepet.satir[i].indirim9 = row_disc_9;
				if(isdefined('row_disc_10') and len(row_disc_10)) sepet.satir[i].indirim10 = row_disc_10;
				
				
				if(attributes.is_iade)// BK 20060425 islem tipi alım iade veya Konsinye Giris Iade
					sepet.satir[i].tax_percent = get_product_main.TAX_PURCHASE;
				else
					sepet.satir[i].tax_percent = get_product_main.TAX;
				if(len(get_product_main.OTV))
					sepet.satir[i].otv_oran = get_product_main.OTV;
				else
					sepet.satir[i].otv_oran = 0;
				if(isdefined('attributes.phl_price_catid_') and len(attributes.phl_price_catid_)) //phlde fiyat listesi secilmisse
					sepet.satir[i].price_cat = attributes.phl_price_catid_;
				sepet.satir[i].paymethod_id = 0;
				sepet.satir[i].stock_id = get_product_main.stock_id;
				sepet.satir[i].barcode = barkod_no;
				sepet.satir[i].special_code = get_product_main.STOCK_CODE_2;
				sepet.satir[i].stock_code = get_product_main.STOCK_CODE;
				sepet.satir[i].manufact_code = get_product_main.MANUFACT_CODE;
				sepet.satir[i].duedate = "";
				sepet.satir[i].row_total = miktar * sepet.satir[i].price ;
				sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
				sepet.satir[i].row_total = sepet.satir[i].amount * sepet.satir[i].price;
				sepet.satir[i].row_nettotal = (sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan;
				sepet.satir[i].other_money = get_product_main.MONEY;
				sepet.satir[i].other_money_value = (sepet.satir[i].row_nettotal/row_rate_info);
				sepet.satir[i].row_taxtotal = sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100);
				if(len(sepet.satir[i].otv_oran))
					sepet.satir[i].row_otvtotal = sepet.satir[i].row_nettotal * (sepet.satir[i].otv_oran/100);
				else
					sepet.satir[i].row_otvtotal = 0;
				sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal + sepet.satir[i].row_otvtotal;
				sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
				sepet.toplam_indirim = sepet.toplam_indirim + (round(sepet.satir[i].row_total) - round(sepet.satir[i].row_nettotal)); //discount_
				sepet.total_tax = sepet.total_tax + sepet.satir[i].row_taxtotal; //totaltax_
				sepet.total_otv = sepet.total_otv + sepet.satir[i].row_otvtotal; //totaltax_
				sepet.net_total = sepet.net_total + sepet.satir[i].row_lasttotal; //nettotal_
	
				sepet.satir[i].deliver_date = "#deliver_date#";
				sepet.satir[i].deliver_dept = "" ;
			
				sepet.satir[i].lot_no = row_lot_no;
				sepet.satir[i].product_name_other = row_detail;
	
				// kdv array
				kdv_flag = 0;
				for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
					{
					if (sepet.kdv_array[k][1] eq sepet.satir[i].tax_percent)
						{
						kdv_flag = 1;
						sepet.kdv_array[k][2] = sepet.kdv_array[k][2] + 0;
						sepet.kdv_array[k][3] = sepet.kdv_array[k][3] + wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);			
						}
					}
				if (not kdv_flag)
					{
					sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = sepet.satir[i].tax_percent;
					sepet.kdv_array[arraylen(sepet.kdv_array)][2] = 0;
					sepet.kdv_array[arraylen(sepet.kdv_array)][3] = wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);
					}
				sepet.satir[i].assortment_array = ArrayNew(1); //20041212 basket inputta gozukmuyor neden set ediliyor,incelenecek?
			</cfscript> 
		</cfif>
	</cfif>
</cfloop>


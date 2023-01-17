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
			alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<cffile action="read" file="#upload_folder##file_name#" variable="dosya">
<cfscript>
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.total = 0;
	sepet.toplam_indirim = 0;
	sepet.total_tax = 0;
	sepet.net_total = 0;
	sepet.genel_indirim = 0;
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	TOTAL_PRODUCTS = 0;
	ArrayDeleteAt(dosya,1);//header satırını silmek için
	line_count = ArrayLen(dosya);
</cfscript>
<cfset i = 0>
<cfif isdefined("attributes.ship_date")>
	<cf_date tarih = "attributes.ship_date">
<cfelseif isdefined("attributes.order_date")> 
	<cf_date tarih = "attributes.order_date">
<cfelseif isdefined("attributes.target_date")> 
	<cf_date tarih = "attributes.target_date">
</cfif>
<cfset barcod_list="">
<cffile action="delete" file="#upload_folder##file_name#">
<!--- tum datalarin query of query yapmak icin onceden alinmasi --->
<cfloop from="1" to="#line_count#" index="k">
	<cfif len(dosya[k]) and len(ListGetAt(dosya[k],1,";"))>
		<cfset barcod_list = ListAppend(barcod_list,"'#trim(ListGetAt(dosya[k],1,";"))#'",",")>
	<cfelse>
		<script type="text/javascript">
			alert('Belgeniz Standart Değil. Lütfen Belgenizi Kontrol Ediniz !');
			window.history.back();
		</script>
		<cfabort>
	</cfif>
</cfloop>
<cfif not listlen(barcod_list)>
	<script type="text/javascript">
		alert('Belgenizde Ürün Listesi Bulunamadı. Lütfen Belgenizi Kontrol Ediniz !');
		window.history.back();
	</script>
	<cfabort>
</cfif>
<!--- fiyatları stock_id ye göre çekiyor, lütfen bozmayın Mahmut Çifçi 13.07.2019 --->
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
		S.STOCK_CODE_2,
		S.PRODUCT_NAME,
		S.PROPERTY,
		S.IS_INVENTORY,
		S.MANUFACT_CODE,
		S.TAX_PURCHASE,
		S.IS_PRODUCTION,
		PU.ADD_UNIT,
		PU.PRODUCT_UNIT_ID,
		PU.MULTIPLIER,
		<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
			ISNULL((SELECT TOP 1 PP.PRICE FROM PRICE PP WHERE PP.STOCK_ID = S.STOCK_ID AND PU.PRODUCT_UNIT_ID = PP.UNIT AND PP.PRICE_CATID = #attributes.price_catid# AND (PP.STARTDATE <=#now()# AND (PP.FINISHDATE IS NULL OR PP.FINISHDATE >=#now()#))),P.PRICE) PRICE,
			ISNULL((SELECT TOP 1 PP.MONEY FROM PRICE PP WHERE PP.STOCK_ID = S.STOCK_ID AND PU.PRODUCT_UNIT_ID = PP.UNIT AND PP.PRICE_CATID = #attributes.price_catid# AND (PP.STARTDATE <=#now()# AND (PP.FINISHDATE IS NULL OR PP.FINISHDATE >=#now()#))),P.MONEY) MONEY,
		<cfelse>	
			P.PRICE,
			<cfif session.ep.period_year gte 2009>
				'#session.ep.money#' MONEY,
			<cfelseif session.ep.period_year lt 2009>
				CASE WHEN MONEY ='TL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE P.MONEY END AS MONEY,
			<cfelse>
				PRICE_STANDART.MONEY,
			</cfif>
		</cfif>
		P.START_DATE
	FROM
		STOCKS AS S,
		PRODUCT_UNIT AS PU,
	<cfif not (isdefined('attributes.stock_identity_type_') and listfind('2,3',attributes.stock_identity_type_))>
		GET_STOCK_BARCODES AS GSB,
	</cfif>
		PRICE_STANDART P
	WHERE
		<cfif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 3><!--- özel kod --->
		S.STOCK_CODE_2 IN (#preservesinglequotes(barcod_list)#) AND
		<cfelseif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 2><!--- stok kodu--->
		S.STOCK_CODE IN (#preservesinglequotes(barcod_list)#) AND
		<cfelse><!--- barkod--->
		GSB.BARCODE IN (#preservesinglequotes(barcod_list)#) AND
		</cfif>
		S.PRODUCT_STATUS = 1 AND
		S.STOCK_STATUS = 1 AND
		<!--- S.IS_PURCHASE = 1 AND --->
		P.PURCHASESALES = 0 AND
		P.PRICESTANDART_STATUS = 1 AND	
		PU.PRODUCT_UNIT_ID = P.UNIT_ID AND
		P.PRODUCT_ID = S.PRODUCT_ID AND
	<cfif not (isdefined('attributes.stock_identity_type_') and listfind('2,3',attributes.stock_identity_type_))>
		S.STOCK_ID = GSB.STOCK_ID AND
	</cfif>
		S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
		S.PRODUCT_ID = PU.PRODUCT_ID
</cfquery>
<cfset urun_listesi = listdeleteduplicates(ValueList(get_product_main_all.PRODUCT_ID,','),',')>
<cfif not listlen(urun_listesi)>
	<script type="text/javascript">
		alert('Belgenizdeki <cfif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 3>Özel Kodlara<cfelseif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 2>Stok Kodlarına<cfelse>Barkodlara</cfif> Ait Hiçbir Ürün Bulunamadı. Lütfen Belgenizi Kontrol Ediniz !');
		window.history.back();
	</script>
	<cfabort>
</cfif>
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
	<cfif isdefined("attributes.ship_date") and isdate(attributes.ship_date)>
		KONDUSYON_DATE <= #attributes.ship_date# AND
		KONDUSYON_FINISH_DATE > #attributes.ship_date# AND
	<cfelseif isdefined("attributes.order_date") and isdate(attributes.order_date)> 
		KONDUSYON_DATE <= #attributes.order_date# AND
		KONDUSYON_FINISH_DATE > #attributes.order_date# AND
	<cfelseif isdefined("attributes.target_date") and isdate(attributes.target_date)> 
		KONDUSYON_DATE <= #attributes.target_date# AND
		KONDUSYON_FINISH_DATE > #attributes.target_date# AND
	<cfelse>
		KONDUSYON_DATE <= #NOW()# AND
		KONDUSYON_FINISH_DATE > #NOW()# AND
	</cfif>
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		BRANCH LIKE ',#attributes.branch_id#,' AND
	</cfif>
		CPP.CATALOG_ID = CP.CATALOG_ID AND
		CP.IS_APPLIED = 1 AND
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
		DISCOUNT6,
		DISCOUNT7,
		DISCOUNT8,
		DISCOUNT9,
		DISCOUNT10,
		START_DATE,
		FINISH_DATE,
		PRODUCT_ID,
		COMPANY_ID,
		C_P_PROD_DISCOUNT_ID
	FROM
		CONTRACT_PURCHASE_PROD_DISCOUNT
	WHERE
		CONTRACT_PURCHASE_PROD_DISCOUNT.PRODUCT_ID IN (#urun_listesi#) AND
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
	ORDER BY C_P_PROD_DISCOUNT_ID DESC
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
<!--- //tum datalarin query of queris yapmak icin onceden alinmasi --->
<cfset order_id_list = ''>
<cfset order_no_list = ''>
<cfset ref_no_value = ''>
<cfloop from="1" to="#line_count#" index="k">
	<cfset barkod_no = trim(ListGetAt(dosya[k],1,";"))>
	<cftry>
		<cfset miktar = replace(ListGetAt(dosya[k],2,";"),",",".","all")>
		<cfif isdefined("is_from_ship")>
			<cfif listlen(dosya[k],';') gte 3>
				<cfset price_row = trim(ListGetAt(dosya[k],3,";"))>
			<cfelse>
				<cfset price_row = ''>
			</cfif>
			<cfif listlen(dosya[k],';') gte 4>
				<cfset money = trim(ListGetAt(dosya[k],4,";"))>
			<cfelse>
				<cfset money = ''>
			</cfif>
			<cfif listlen(dosya[k],';') gte 5>
				<cfset spect_main_id_row = trim(ListGetAt(dosya[k],5,";"))>
			<cfelse>
				<cfset spect_main_id_row = ''>
			</cfif>
			<cfif listlen(dosya[k],';') gte 6>
                <cfset row_lot_no = trim(ListGetAt(dosya[k],6,";"))>
            <cfelse>
                <cfset row_lot_no = ''>
            </cfif>
            <cfif listlen(dosya[k],';') gte 7>
				<cfset project_id = trim(ListGetAt(dosya[k],7,";"))>
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
            <cfif listlen(dosya[k],';') gte 8><!---Açıklama 2--->
                <cfset row_detail = trim(ListGetAt(dosya[k],7,";"))>
            <cfelse>
                <cfset row_detail = ''>
            </cfif>
			<cfset date_row = ''>
		<cfelse>
			<cfif listlen(dosya[k],';') gte 4>
				<cfset price_row = trim(ListGetAt(dosya[k],4,";"))>
			<cfelse>
				<cfset price_row = ''>
			</cfif>
			<cfif listlen(dosya[k],';') gte 3>
				<cfset spect_main_id_row = trim(ListGetAt(dosya[k],3,";"))>
			<cfelse>
				<cfset spect_main_id_row = ''>
			</cfif>
			<cfif listlen(dosya[k],';') gte 5>
				<cfset date_row = trim(ListGetAt(dosya[k],5,";"))>
			<cfelse>
				<cfset date_row = ''>
			</cfif>
			<cfif listlen(dosya[k],';') gte 6>
                <cfset row_detail = trim(ListGetAt(dosya[k],6,";"))>
            <cfelse>
                <cfset row_detail = ''>
            </cfif>
            <cfif from_where eq 1> 
				<cfif listlen(dosya[k],';') gte 7>
                    <cfset order_row_id_ = trim(ListGetAt(dosya[k],7,";"))>
                <cfelse>
                    <cfset order_row_id_ = ''>
				</cfif>
				<cfset project_id = ''>
                <cfset project_name = ''>
            <cfelse>
				<cfif listlen(dosya[k],';') gte 7>
                    <cfset project_id = trim(ListGetAt(dosya[k],7,";"))>
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
                <cfif listlen(dosya[k],';') gte 8>
                    <cfset work_id = trim(ListGetAt(dosya[k],8,";"))>
                    <cfquery name="GET_ROW_WORKS" datasource="#dsn#">
                        SELECT WORK_HEAD FROM PRO_WORKS WHERE WORK_ID IN (#work_id#)
                    </cfquery>
                    <cfset work_name = GET_ROW_WORKS.WORK_HEAD>
                <cfelse>
                    <cfset work_id = ''>
                    <cfset work_name = ''>
                </cfif>
            </cfif>
		</cfif>
		<cfcatch>
			<cfset miktar = 1>
		</cfcatch>
	</cftry>
	<cfif len(miktar) and miktar neq 0>
		<cfquery name="get_product_main" dbtype="query" maxrows="1">
			SELECT 
				BARCODE,
				STOCK_ID,
				PRODUCT_ID,
				STOCK_CODE,
				STOCK_CODE_2,
				PRODUCT_NAME,
				IS_INVENTORY,
				IS_PRODUCTION,
				MANUFACT_CODE,
				TAX_PURCHASE,
				ADD_UNIT,
				PRODUCT_UNIT_ID,
				MULTIPLIER,
				PRICE,
				MONEY,
				PROPERTY,
				START_DATE
			FROM
				get_product_main_all
			WHERE
				<cfif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 3><!--- özel kod --->
				STOCK_CODE_2 = '#barkod_no#'
				<cfelseif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 2><!--- stok kodu--->
				STOCK_CODE = '#barkod_no#'
				<cfelse><!--- barkod--->
				BARCODE = '#barkod_no#'
				</cfif>
			ORDER BY
				START_DATE DESC
		</cfquery>				
		<cfif get_product_main.recordcount>
			<cfif len(spect_main_id_row)>
				<cfquery name="get_price_" datasource="#dsn3#">
					SELECT TOP 1	
						PRICE,
						MONEY
					FROM 
						PRICE
					WHERE 
						PRODUCT_ID = #get_product_main.product_id# AND 
						UNIT = #get_product_main.product_unit_id# AND 
					<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
						PRICE_CATID = #attributes.price_catid# AND 
					<cfelse>
						PRICE_CATID = -1 AND				
					</cfif>
						(STARTDATE <=#now()# AND (FINISHDATE IS NULL OR FINISHDATE >=#now()#)) AND
						SPECT_VAR_ID = #spect_main_id_row#
				</cfquery>
				<cfif get_price_.recordcount>
					<cfset spect_price = 1>
				<cfelse>
					<cfset spect_price = 0>
				</cfif>
			<cfelse>
				<cfset spect_price = 0>
			</cfif>
			<cfif spect_price eq 1>
				<cfif get_price_.MONEY eq SESSION.EP.MONEY>
					<cfset FIYAT = replace(get_price_.price,",",".","all")>
					<cfset FIYAT_OTHER = replace(get_price_.price,",",".","all")>
					<cfset temp_rate_=1>
				<cfelse>
					<cfquery name="get_rate" datasource="#DSN#">SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY='#get_price_.MONEY#'</cfquery>
					<cfset FIYAT = replace(get_price_.price,",",".","all") * (get_rate.RATE2/get_rate.RATE1)>
					<cfset FIYAT_OTHER = replace(get_price_.price,",",".","all")>	
					<cfset temp_rate_=(get_rate.RATE2/get_rate.RATE1)>
				</cfif>
			<cfelseif len(price_row)>
				<cfif isdefined("is_from_ship") and isdefined("money") and len(money)>
					<cfset other_money_ = money>
					<cfif other_money_ eq SESSION.EP.MONEY>
						<cfset FIYAT = replace(price_row,",",".","all")>
						<cfset FIYAT_OTHER = replace(price_row,",",".","all")>
						<cfset temp_rate_=1>
					<cfelse>
						<cfquery name="get_rate" datasource="#DSN#">SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY='#other_money_#'</cfquery>
						<cfset FIYAT = replace(price_row,",",".","all") * (get_rate.RATE2/get_rate.RATE1)>
						<cfset FIYAT_OTHER = replace(price_row,",",".","all")>	
						<cfset temp_rate_=(get_rate.RATE2/get_rate.RATE1)>
					</cfif>
				<cfelse>
					<cfif get_product_main.MONEY eq SESSION.EP.MONEY>
						<cfset FIYAT = replace(price_row,",",".","all")>
						<cfset FIYAT_OTHER = replace(price_row,",",".","all")>
						<cfset temp_rate_=1>
					<cfelse>
						<cfquery name="get_rate" datasource="#DSN#">SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY='#get_product_main.MONEY#'</cfquery>
						<cfset FIYAT = replace(price_row,",",".","all") * (get_rate.RATE2/get_rate.RATE1)>
						<cfset FIYAT_OTHER = replace(price_row,",",".","all")>	
						<cfset temp_rate_=(get_rate.RATE2/get_rate.RATE1)>
					</cfif>
				</cfif>
			<cfelseif get_product_main.MONEY eq SESSION.EP.MONEY>
				<cfset FIYAT = get_product_main.PRICE>
				<cfset FIYAT_OTHER = get_product_main.PRICE>
				<cfset temp_rate_=1>
			<cfelse>
				<cfquery name="get_rate" datasource="#DSN#">SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY='#get_product_main.MONEY#'</cfquery>
				<cfset FIYAT = get_product_main.PRICE * (get_rate.RATE2/get_rate.RATE1)>
				<cfset FIYAT_OTHER = get_product_main.PRICE>
				<cfset temp_rate_=(get_rate.RATE2/get_rate.RATE1)>
			</cfif>
			<cfif len(spect_main_id_row)>
				<cfquery name="control_spect_main" datasource="#dsn3#">
                	SELECT SPECT_MAIN_ID FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #spect_main_id_row# AND STOCK_ID = #get_product_main.stock_id#
                </cfquery>
            	<cfif control_spect_main.recordcount>
					<cfscript>
                        new_cre_spect_id = specer(
                            dsn_type:dsn3,
                            add_to_main_spec:1,
                            main_spec_id:spect_main_id_row
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
			
			<cfif isdefined("order_row_id_") and len(order_row_id_)>
				<cfquery name="get_wrk_id" datasource="#dsn3#">
					SELECT WRK_ROW_ID,O.ORDER_NUMBER FROM ORDER_ROW ORR,ORDERS O WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.ORDER_ROW_ID = #order_row_id_#
				</cfquery>
				<cfset ref_no_value = listappend(ref_no_value,get_wrk_id.order_number)>
			</cfif>
			<cfif isdefined("attributes.is_order_relation")><!--- Eğer otomatik sipariş bağlantısı oluşturulsun seçildiyse --->
				<cfinclude template="get_sub_basket_order_relation.cfm">
			<cfelse>
				<cfscript>
					i = i+1;
					sepet.satir[i] = StructNew();
					
					sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
					
					if(isdefined("get_wrk_id") and get_wrk_id.recordcount)
						sepet.satir[i].wrk_row_relation_id = get_wrk_id.wrk_row_id;
					else
						sepet.satir[i].wrk_row_relation_id = '';
					
					sepet.satir[i].product_id = get_product_main.PRODUCT_ID;
					sepet.satir[i].is_inventory = get_product_main.IS_INVENTORY;
					sepet.satir[i].is_production = get_product_main.IS_PRODUCTION;
					sepet.satir[i].product_name = get_product_main.PRODUCT_NAME&' '&get_product_main.PROPERTY;
					sepet.satir[i].amount = miktar;
					sepet.satir[i].unit = get_product_main.add_unit;
					sepet.satir[i].unit_id = get_product_main.PRODUCT_UNIT_ID;
					sepet.satir[i].price = FIYAT;
					sepet.satir[i].indirim1 =0;
					sepet.satir[i].indirim2 =0;
					sepet.satir[i].indirim3 =0;
					sepet.satir[i].indirim4 =0;
					sepet.satir[i].indirim5 =0;
					sepet.satir[i].indirim6 =0;
					sepet.satir[i].indirim7 =0;
					sepet.satir[i].indirim8 =0;
					sepet.satir[i].indirim9 =0;
					sepet.satir[i].indirim10=0;
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
				<cfscript>
					if(get_aksiyons.recordcount){
					if(len(get_aksiyons.discount1))sepet.satir[i].indirim1 = get_aksiyons.discount1;
					if(len(get_aksiyons.discount2))sepet.satir[i].indirim2 = get_aksiyons.discount2;
					if(len(get_aksiyons.discount3))sepet.satir[i].indirim3 = get_aksiyons.discount3;
					if(len(get_aksiyons.discount4))sepet.satir[i].indirim4 = get_aksiyons.discount4;
					if(len(get_aksiyons.discount5))sepet.satir[i].indirim5 = get_aksiyons.discount5;
					if(len(get_aksiyons.discount6))sepet.satir[i].indirim6 = get_aksiyons.discount6;
					if(len(get_aksiyons.discount7))sepet.satir[i].indirim7 = get_aksiyons.discount7;
					if(len(get_aksiyons.discount8))sepet.satir[i].indirim8 = get_aksiyons.discount8;
					if(len(get_aksiyons.discount9))sepet.satir[i].indirim9 = get_aksiyons.discount9;
					if(len(get_aksiyons.discount10))sepet.satir[i].indirim10 = get_aksiyons.discount10;
					if(len(get_aksiyons.PURCHASE_PRICE))sepet.satir[i].price = get_aksiyons.PURCHASE_PRICE;
					}
				</cfscript>
				<cfif not get_aksiyons.recordcount and get_contracts_all.recordcount>
					<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
						<cfquery name="get_contracts" dbtype="query" maxrows="1">
							SELECT DISCOUNT1,DISCOUNT2,DISCOUNT3,DISCOUNT4,DISCOUNT5,DISCOUNT6,DISCOUNT7,DISCOUNT8,DISCOUNT9,DISCOUNT10
							FROM
								get_contracts_all
							WHERE
								PRODUCT_ID = #get_product_main.PRODUCT_ID# AND
								COMPANY_ID = #attributes.company_id#
							ORDER BY
								C_P_PROD_DISCOUNT_ID DESC
						</cfquery>
						<cfif not get_contracts.recordcount>
							<cfquery name="get_contracts" dbtype="query" maxrows="1">
								SELECT DISCOUNT1,DISCOUNT2,DISCOUNT3,DISCOUNT4,DISCOUNT5,DISCOUNT6,DISCOUNT7,DISCOUNT8,DISCOUNT9,DISCOUNT10
								FROM
									get_contracts_all
								WHERE
									PRODUCT_ID = #get_product_main.PRODUCT_ID# AND
									COMPANY_ID IS NULL
								ORDER BY
									C_P_PROD_DISCOUNT_ID DESC
							</cfquery>
						</cfif>
					<cfelse>
						<cfquery name="get_contracts" dbtype="query" maxrows="1">
							SELECT DISCOUNT1,DISCOUNT2,DISCOUNT3,DISCOUNT4,DISCOUNT5,DISCOUNT6,DISCOUNT7,DISCOUNT8,DISCOUNT9,DISCOUNT10
							FROM
								get_contracts_all
							WHERE
								PRODUCT_ID = #get_product_main.PRODUCT_ID#
							ORDER BY
								C_P_PROD_DISCOUNT_ID DESC
						</cfquery>
					</cfif>
					<cfscript>
						if(get_contracts.recordcount){
							if(len(get_contracts.discount1))sepet.satir[i].indirim1 = get_contracts.discount1;
							if(len(get_contracts.discount2))sepet.satir[i].indirim2 = get_contracts.discount2;
							if(len(get_contracts.discount3))sepet.satir[i].indirim3 = get_contracts.discount3;
							if(len(get_contracts.discount4))sepet.satir[i].indirim4 = get_contracts.discount4;
							if(len(get_contracts.discount5))sepet.satir[i].indirim5 = get_contracts.discount5;
							if(len(get_contracts.discount6))sepet.satir[i].indirim6 = get_contracts.discount6;
							if(len(get_contracts.discount7))sepet.satir[i].indirim7 = get_contracts.discount7;
							if(len(get_contracts.discount8))sepet.satir[i].indirim8 = get_contracts.discount8;
							if(len(get_contracts.discount9))sepet.satir[i].indirim9 = get_contracts.discount9;
							if(len(get_contracts.discount10))sepet.satir[i].indirim10 = get_contracts.discount10;
						}
					</cfscript>
				</cfif>
				<cfif isdefined('get_c_general_discounts') and get_c_general_discounts.recordcount><!--- genel indirimlerden gelen iskontolar --->
					<cfloop query="get_c_general_discounts">
						<cfset 'row_disc_#currentrow+5#' = get_c_general_discounts.DISCOUNT>
					</cfloop>
				</cfif>
				<cfscript>
					if(isdefined('row_disc_6') and len(row_disc_6)) sepet.satir[i].indirim6 = row_disc_6;
					if(isdefined('row_disc_7') and len(row_disc_7)) sepet.satir[i].indirim7 = row_disc_7;
					if(isdefined('row_disc_8') and len(row_disc_8)) sepet.satir[i].indirim8 = row_disc_8;
					if(isdefined('row_disc_9') and len(row_disc_9)) sepet.satir[i].indirim9 = row_disc_9;
					if(isdefined('row_disc_10') and len(row_disc_10)) sepet.satir[i].indirim10 = row_disc_10;
					sepet.satir[i].tax_percent = get_product_main.TAX_PURCHASE;
					sepet.satir[i].paymethod_id = 0;
					sepet.satir[i].stock_id = get_product_main.stock_id;
					sepet.satir[i].barcode = barkod_no;
					sepet.satir[i].stock_code = get_product_main.STOCK_CODE;
					sepet.satir[i].manufact_code = get_product_main.MANUFACT_CODE;
					sepet.satir[i].special_code = get_product_main.STOCK_CODE_2;
					sepet.satir[i].duedate = "";
					sepet.satir[i].row_total = miktar * sepet.satir[i].price ;
					sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
					sepet.satir[i].row_total = sepet.satir[i].amount * sepet.satir[i].price;
					sepet.satir[i].row_nettotal = (sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan;
					sepet.satir[i].row_taxtotal = sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100);
					sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
					if(isdefined("other_money_") and len(other_money_))
						sepet.satir[i].other_money = other_money_;
					else
						sepet.satir[i].other_money = get_product_main.MONEY;
					sepet.satir[i].other_money_value =(sepet.satir[i].row_nettotal*temp_rate_);
					sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
					sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
					sepet.total_tax = sepet.total_tax + sepet.satir[i].row_taxtotal; //totaltax_
					sepet.net_total = sepet.net_total + sepet.satir[i].row_lasttotal; //nettotal_
					if(len(date_row) and IsDate(date_row)) /*phl de fiyat gönderilme durumuna karsı listlast kullanıldı*/
						sepet.satir[i].deliver_date = date_row;
					else
						sepet.satir[i].deliver_date = "";
					sepet.satir[i].deliver_dept = "" ;
					sepet.satir[i].spect_id = spect_var_id_row;
					sepet.satir[i].spect_name = spect_var_name_row;
					sepet.satir[i].product_name_other = row_detail;
					if(isdefined("row_lot_no"))
                    sepet.satir[i].lot_no = row_lot_no;
					sepet.satir[i].price_other = FIYAT_OTHER;
					if(isdefined('work_name') and len(work_name)) sepet.satir[i].row_work_name = work_name;
					if(isdefined('work_id') and len(work_id)) sepet.satir[i].row_work_id = work_id;						
					sepet.satir[i].row_project_id = project_id;
					sepet.satir[i].row_project_name = project_name;
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
					sepet.satir[i].assortment_array = ArrayNew(1); //20041212 basket inputta gozukmuyor neden set ediliyor,incelensin?
				</cfscript> 
			</cfif>
		</cfif>
	</cfif>
</cfloop>

<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
	<cfquery name="get_project_discounts" datasource="#dsn3#">
		SELECT
			ISNULL(PD.DISCOUNT_1,0) DISCOUNT_1,
			ISNULL(PD.DISCOUNT_2,0) DISCOUNT_2,
			ISNULL(PD.DISCOUNT_3,0) DISCOUNT_3,
			ISNULL(PD.DISCOUNT_4,0) DISCOUNT_4,
			ISNULL(PD.DISCOUNT_5,0) DISCOUNT_5,
			ISNULL(PD.IS_CHECK_PRJ_PRODUCT,0) IS_CHECK_PRJ_PRODUCT,PD.PRO_DISCOUNT_ID,
			PDC.BRAND_ID,PDC.PRODUCT_CATID,PDC.PRODUCT_ID
		FROM 
			PROJECT_DISCOUNTS PD,
			PROJECT_DISCOUNT_CONDITIONS PDC
		WHERE
			PD.PRO_DISCOUNT_ID=PDC.PRO_DISCOUNT_ID
			AND PD.PROJECT_ID=#attributes.project_id#
			<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
				AND (PD.IS_CHECK_PRJ_MEMBER=0 OR PD.COMPANY_ID=#attributes.company_id#)
			<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
				AND (PD.IS_CHECK_PRJ_MEMBER=0 OR PD.CONSUMER_ID=#attributes.consumer_id#)
			</cfif>
			<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
				AND PD.START_DATE <= #attributes.search_process_date#
				AND PD.FINISH_DATE >= #attributes.search_process_date#
			<cfelse>
				AND PD.START_DATE <= #now()#
				AND PD.FINISH_DATE >= #now()#
			</cfif>
			<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)><!--- fiyat listesi secilmemisse standart alıs fiyatından kontrol eder --->
				AND (PD.IS_CHECK_PRJ_PRICE_CAT = 0 OR PD.PRICE_CATID = #attributes.price_catid#)
			<cfelse>
				AND (PD.IS_CHECK_PRJ_PRICE_CAT = 0 OR PD.PRICE_CATID = -1)
			</cfif>
		ORDER BY PRODUCT_ID DESC,BRAND_ID DESC,PRODUCT_CATID DESC
	</cfquery>
	<cfoutput query="get_product_main_all">
		<cfif get_project_discounts.recordcount and get_project_discounts.IS_CHECK_PRJ_PRODUCT eq 1>
			<cfset prj_prod_list_=listsort(valuelist(get_project_discounts.PRODUCT_ID),'numeric','asc')>
			<cfset prj_brand_list_=listsort(valuelist(get_project_discounts.BRAND_ID),'numeric','asc')>
			<cfset prj_prod_cat_list=listsort(valuelist(get_project_discounts.PRODUCT_CATID),'numeric','asc')>
			<cfquery name="get_project_prods" datasource="#dsn3#">
				SELECT
					PRODUCT_ID,PRODUCT_NAME
				FROM
					PRODUCT
				WHERE
					PRODUCT_ID=#get_order_products.product_id#
					<cfif len(prj_brand_list_)>
					AND ISNULL(BRAND_ID,0) IN (#prj_brand_list_#)
					</cfif>
					<cfif len(prj_prod_cat_list)>
					AND ISNULL(PRODUCT_CATID,0) IN (#prj_prod_cat_list#) 
					</cfif>
					<cfif len(prj_prod_list_)>
					AND PRODUCT_ID IN (#prj_prod_list_#) 
					</cfif>
			</cfquery>
		</cfif>
		<cfif get_project_discounts.recordcount neq 0 and ( (get_project_discounts.IS_CHECK_PRJ_PRODUCT eq 0) or (get_project_discounts.IS_CHECK_PRJ_PRODUCT eq 1 and get_project_prods.recordcount neq 0) )>
			<cfset use_other_discounts=0> <!--- proje iskontoları kullanılacak --->
			<cfscript>
				sepet.satir[currentrow].indirim1 = get_project_discounts.DISCOUNT_1;
				sepet.satir[currentrow].indirim2 = get_project_discounts.DISCOUNT_2;
				sepet.satir[currentrow].indirim3 = get_project_discounts.DISCOUNT_3;
				sepet.satir[currentrow].indirim4 = get_project_discounts.DISCOUNT_4;
				sepet.satir[currentrow].indirim5 = get_project_discounts.DISCOUNT_5;
			</cfscript>
			<cfset use_other_discounts=0>
		</cfif>	
	</cfoutput>
</cfif>
<cfif isdefined("attributes.is_order_relation")>
	<script type="text/javascript">
		form_basket.order_id_listesi.value = "<cfoutput>#order_id_list#</cfoutput>";
		form_basket.order_id.value = "<cfoutput>#order_no_list#</cfoutput>";
	</script>
</cfif>
<cfif isdefined("ref_no_value")>
	<script type="text/javascript">
		form_basket.ref_no.value = "<cfoutput>#ref_no_value#</cfoutput>";
	</script>	
</cfif>

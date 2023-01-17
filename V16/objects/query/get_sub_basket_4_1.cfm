<cfset upload_folder = "#upload_folder#store#dir_seperator#" >
<cfif not directoryexists("#upload_folder#")>
	<cfdirectory action="create" directory="#upload_folder#">
</cfif>
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
				alert("<cf_get_lang dictionary_id='52628.php,jsp,asp,cfm,cfml Formatlarda Dosya Girmeyiniz !'>");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset file_size = cffile.filesize>
	</cfif>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
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
	CRLF = Chr(13) & Chr(10);
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	TOTAL_PRODUCTS = 0;
	line_count = ArrayLen(dosya);
</cfscript>
<cfset i = 0>
<cf_date tarih = "attributes.ship_date">
<cfset barcod_list="">
<cffile action="delete" file="#upload_folder##file_name#">
<!--- tum datalarin query of query yapmak icin onceden alinmasi --->
<cfloop from="1" to="#line_count#" index="k">
	<cfset dosya[k] = replace(dosya[k],' ','0','all')>
	<cfif len(dosya[k]) and len(ListGetAt(dosya[k],1,";"))>
		<cfset barcod_list = ListAppend(barcod_list,"'#trim(ListGetAt(dosya[k],1,";"))#'",",")>
	<cfelse>
		<script type="text/javascript">
			alert('Belgeniz Standart Değil. Lütfen Belgenizi Kontrol Ediniz !:'+<cfoutput>#k#</cfoutput>);
			window.history.back();
		</script>
		<cfabort>
	</cfif>
</cfloop>
<cfif not listlen(barcod_list)>
	<script type="text/javascript">
		alert('Belgenizdeki <cfif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 3>Özel Kodlara<cfelseif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 2>Stok Kodlarına<cfelse>Barkodlara</cfif> Ait Hiçbir Ürün Bulunamadı. Lütfen Belgenizi Kontrol Ediniz !');
		window.history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name="get_product_main_all" datasource="#dsn3#">
	SELECT
	<cfif not (isdefined('attributes.stock_identity_type_') and listfind('2,3',attributes.stock_identity_type_))>
		GSB.BARCODE,
	<cfelse>
		S.BARCOD AS BARCODE,
	</cfif>
		S.STOCK_ID,
		S.PRODUCT_ID,
		S.PRODUCT_DETAIL2,
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
		PRICE_STANDART.PRICE,
		<cfif session.ep.period_year gte 2009>
			CASE WHEN MONEY ='YTL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE PRICE_STANDART.MONEY END AS MONEY,
		<cfelseif session.ep.period_year lt 2009>
			CASE WHEN MONEY ='TL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE PRICE_STANDART.MONEY END AS MONEY,
		<cfelse>
			PRICE_STANDART.MONEY,
		</cfif> 
		PRICE_STANDART.START_DATE
	FROM
		STOCKS AS S,
		PRODUCT_UNIT AS PU,
	<cfif not (isdefined('attributes.stock_identity_type_') and listfind('2,3',attributes.stock_identity_type_))>
		GET_STOCK_BARCODES AS GSB,
	</cfif>
		PRICE_STANDART
	WHERE
		PRICE_STANDART.PURCHASESALES = 0 AND
		<cfif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 3><!--- özel kod --->
		S.STOCK_CODE_2 IN (#preservesinglequotes(barcod_list)#) AND
		<cfelseif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 2><!--- stok kodu--->
		S.STOCK_CODE IN (#preservesinglequotes(barcod_list)#) AND
		<cfelse><!--- barkod--->
		GSB.BARCODE IN (#preservesinglequotes(barcod_list)#) AND
		</cfif>
		<!--- (GSB.BARCODE IN (#preservesinglequotes(barcod_list)#) OR
		S.STOCK_CODE IN (#preservesinglequotes(barcod_list)#)) AND --->
		S.PRODUCT_STATUS = 1 AND
		S.STOCK_STATUS = 1 AND
	<cfif isdate(attributes.ship_date)>
		PRICE_STANDART.START_DATE <= #attributes.ship_date# AND
	</cfif>
		PRICE_STANDART.PRODUCT_ID = S.PRODUCT_ID AND
		PU.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND
	<cfif not (isdefined('attributes.stock_identity_type_') and listfind('2,3',attributes.stock_identity_type_))>
		S.STOCK_ID = GSB.STOCK_ID AND
	</cfif>
		S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
		S.PRODUCT_ID = PU.PRODUCT_ID
</cfquery>
<cfset urun_listesi = listdeleteduplicates(ValueList(get_product_main_all.PRODUCT_ID,','),',')>
<cfif not listlen(urun_listesi)>
	<script type="text/javascript">
		alert('Belgenizdeki Barkodlara Ait Hiçbir Ürün Bulunamadı. Lütfen Belgenizi Kontrol Ediniz !');
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
	<cfif isdate(attributes.ship_date)>
		KONDUSYON_DATE <= #attributes.ship_date# AND
		KONDUSYON_FINISH_DATE > #attributes.ship_date# AND
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
	<cfif isdate(attributes.ship_date)>
		(
			START_DATE <= #attributes.ship_date# AND
			(FINISH_DATE >= #attributes.ship_date# OR FINISH_DATE IS NULL)
		)
	<cfelse>
		START_DATE <= #now()# AND
		FINISH_DATE >= #now()#
	</cfif>
	ORDER BY C_P_PROD_DISCOUNT_ID DESC
</cfquery>
<!--- //tum datalarin query of queris yapmak icin onceden alinmasi --->
<cfloop from="2" to="#line_count#" index="k">
	<cfset dosya[k] = Replace(dosya[k],';;','; ;','all')>
	<cfset dosya[k] = Replace(dosya[k],';;','; ;','all')>
	<cfset barkod_no = trim(ListGetAt(dosya[k],1,";"))>
	<cftry>
		<cfset miktar = replace(ListGetAt(dosya[k],2,";"),",",".","all")>
		<cfif listlen(dosya[k],';') gte 4>
			<cfset spect_main_id = trim(ListGetAt(dosya[k],4,";"))>
		<cfelse>
			<cfset spect_main_id = ''>
		</cfif>
		<cfif listlen(dosya[k],';') gte 5>
			<cfset to_shelf_number = trim(ListGetAt(dosya[k],5,";"))>
		<cfelse>
			<cfset to_shelf_number = ''>
		</cfif>
		<cfif listlen(dosya[k],';') gte 6>
			<cfset shelf_number = trim(ListGetAt(dosya[k],6,";"))>
		<cfelse>
			<cfset shelf_number = ''>
		</cfif>
        <cfif listlen(dosya[k],';') gte 7>
			<cfset row_lot_no = trim(ListGetAt(dosya[k],7,";"))>
        <cfelse>
            <cfset row_lot_no = ''>
        </cfif>
        <cfif listlen(dosya[k],';') gte 8>
            <cfset project_id = trim(ListGetAt(dosya[k],8,";"))>
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
        <cfif listlen(dosya[k],';') gte 9><!---Açıklama 2--->
			<cfset row_detail = trim(ListGetAt(dosya[k],9,";"))>
        <cfelse>
            <cfset row_detail = ''>
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
				PRODUCT_DETAIL2,
				STOCK_CODE,
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
				START_DATE,
				STOCK_CODE_2
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
			<cfif listlen(dosya[k],';') gte 3 and len(ListGetAt(dosya[k],3,";"))>
				<cfif get_product_main.MONEY eq SESSION.EP.MONEY>
					<cfset FIYAT = ListGetAt(dosya[k],3,";")>
					<cfset FIYAT_OTHER = ListGetAt(dosya[k],3,";")>
				<cfelse>
					<cfquery name="get_rate" datasource="#DSN#">SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY='#get_product_main.MONEY#'</cfquery>
					<cfset FIYAT = ListGetAt(dosya[k],3,";") * (get_rate.RATE2/get_rate.RATE1)>
					<cfset FIYAT_OTHER = ListGetAt(dosya[k],3,";")>	
				</cfif>
			<cfelseif get_product_main.MONEY eq SESSION.EP.MONEY>
				<cfset FIYAT = get_product_main.PRICE>
				<cfset FIYAT_OTHER = get_product_main.PRICE>
			<cfelse>
				<cfquery name="get_rate" datasource="#DSN#">SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY='#get_product_main.MONEY#'</cfquery>
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
			<cfif len(to_shelf_number)>
				<cfquery name="get_to_shelf_number" datasource="#dsn3#">
					SELECT PP.PRODUCT_PLACE_ID FROM PRODUCT_PLACE PP,#dsn_alias#.SHELF WHERE SHELF.SHELF_ID = PP.SHELF_TYPE AND PLACE_STATUS=1 AND SHELF_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#to_shelf_number#"> 
				</cfquery>
			<cfelse>
				<cfset get_to_shelf_number.PRODUCT_PLACE_ID = "">
			</cfif>
			<cfif len(shelf_number)>
				<cfquery name="get_shelf_number" datasource="#dsn3#">
					SELECT PP.PRODUCT_PLACE_ID FROM PRODUCT_PLACE PP,#dsn_alias#.SHELF WHERE SHELF.SHELF_ID = PP.SHELF_TYPE AND PLACE_STATUS=1 AND SHELF_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#shelf_number#">  
				</cfquery>
			<cfelse>
				<cfset get_shelf_number.PRODUCT_PLACE_ID = "">
			</cfif>
			<cfscript>
				i = i+1;
				sepet.satir[i] = StructNew();
				
				sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
				sepet.satir[i].wrk_row_relation_id = '';
				
				sepet.satir[i].product_id = get_product_main.PRODUCT_ID;
				sepet.satir[i].is_inventory = get_product_main.IS_INVENTORY;
				sepet.satir[i].is_production = get_product_main.IS_PRODUCTION;
				sepet.satir[i].product_name = get_product_main.PRODUCT_NAME&' '&get_product_main.PROPERTY;
				sepet.satir[i].amount = miktar;
				sepet.satir[i].unit = get_product_main.add_unit;
				sepet.satir[i].unit_id = get_product_main.PRODUCT_UNIT_ID;
				sepet.satir[i].price = FIYAT;	
				sepet.satir[i].other_money_value = FIYAT_OTHER;
				sepet.satir[i].other_money = get_product_main.MONEY;
				sepet.satir[i].other_money_value = FIYAT_OTHER;
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
							COMPANY_ID = #ATTRIBUTES.COMPANY_ID#
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
							DISCOUNT10
						FROM
							get_contracts_all
						WHERE
							PRODUCT_ID = #get_product_main.PRODUCT_ID#
							<!--- AND COMPANY_ID IS NULL 20050322 ic (30 GUNE silinebilir) company_id secilmeyen yerlerde sirket kosulunu almiyordu--->
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
			<cfscript>
				sepet.satir[i].tax_percent = get_product_main.TAX_PURCHASE;
				sepet.satir[i].paymethod_id = 0;
				sepet.satir[i].stock_id = get_product_main.stock_id;
				sepet.satir[i].barcode = get_product_main.BARCODE;
				sepet.satir[i].special_code = get_product_main.STOCK_CODE_2;
				sepet.satir[i].stock_code = get_product_main.STOCK_CODE;
				sepet.satir[i].manufact_code = get_product_main.MANUFACT_CODE;
				sepet.satir[i].duedate = "";
				sepet.satir[i].row_total = miktar * sepet.satir[i].price ;
				sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
				sepet.satir[i].row_total = sepet.satir[i].amount * sepet.satir[i].price;
				sepet.satir[i].row_nettotal = (sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan;
				sepet.satir[i].row_taxtotal = sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100);
				sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
				sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
				sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
				sepet.total_tax = sepet.total_tax + sepet.satir[i].row_taxtotal; //totaltax_
				sepet.net_total = sepet.net_total + sepet.satir[i].row_lasttotal; //nettotal_
	
				sepet.satir[i].deliver_date = "";
				sepet.satir[i].deliver_dept = "" ;
			
				sepet.satir[i].spect_id = spect_var_id_row;
				sepet.satir[i].spect_name = spect_var_name_row;
				sepet.satir[i].price_other = FIYAT_OTHER;
				sepet.satir[i].product_name_other =( len(row_detail)) ? row_detail : get_product_main.PRODUCT_DETAIL2;
				sepet.satir[i].lot_no = row_lot_no;
				sepet.satir[i].row_project_id = project_id;
				sepet.satir[i].row_project_name = project_name;
				sepet.satir[i].to_shelf_number = get_to_shelf_number.PRODUCT_PLACE_ID;
				sepet.satir[i].shelf_number = get_shelf_number.PRODUCT_PLACE_ID;
				

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
</cfloop>

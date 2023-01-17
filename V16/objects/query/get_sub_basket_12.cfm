<cfset upload_folder = "#upload_folder#store#dir_seperator#">
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
	CRLF = Chr(13) & Chr(10);
	dosya = Replace(dosya,';','; ','all');//Hepsinin basina bosluk koyuyoruz asagida trim ediyoruz, bosluk atmazsak aradaki veya son degeri gormuyor fbs 20130427
	dosya = ListToArray(dosya,CRLF);
	
	TOTAL_PRODUCTS = 0;
	line_count = ArrayLen(dosya);
</cfscript>
<cfset i = 0>
<cf_date tarih = "attributes.fis_date">
<cfset barcod_list="">
<cffile action="delete" file="#upload_folder##file_name#">
<cfloop from="1" to="#line_count#" index="k">
	<!--- contains 'E-' ifadesi dosyada miktar kolonundaki 1,66533E-16 ifadeleri almamak icin eklendi BK 20100222 --->
	<cfif len(dosya[k]) and listlen(dosya[k],';') gte 2 and len(ListGetAt(dosya[k],1,";")) and not((ListGetAt(dosya[k],2,";") contains 'E-'))>
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
		alert('Belgenizde Barkod Listesi Bulunamadı. Lütfen Belgenizi Kontrol Ediniz !');
		window.history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_PRODUCT_MAIN_ALL" datasource="#DSN3#">
	SELECT
	<cfif not (isdefined('attributes.stock_identity_type_') and listfind('2,3',attributes.stock_identity_type_))>
		GSB.BARCODE,
	<cfelse>
		S.BARCOD AS BARCODE,
	</cfif>
		S.STOCK_ID,
		S.STOCK_CODE_2,
		S.PRODUCT_ID,
		S.STOCK_CODE,
		S.STOCK_CODE_2,
		S.PRODUCT_NAME,
		S.PROPERTY,
		S.IS_INVENTORY,
		S.MANUFACT_CODE,
		S.TAX,
		S.IS_PRODUCTION,
		PU.ADD_UNIT,
		PU.PRODUCT_UNIT_ID,
		PU.MULTIPLIER,
		PRICE_STANDART.PRICE,
	<cfif session.ep.period_year gte 2009>
		CASE WHEN PRICE_STANDART.MONEY ='YTL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE PRICE_STANDART.MONEY END AS MONEY,
	<cfelseif session.ep.period_year lt 2009>
		CASE WHEN PRICE_STANDART.MONEY ='TL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE PRICE_STANDART.MONEY END AS MONEY,
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
		S.PRODUCT_STATUS = 1 AND
		S.STOCK_STATUS = 1 AND
		<cfif isdefined('attributes.fis_date') and isdate(attributes.fis_date)>
		PRICE_STANDART.START_DATE <= #attributes.fis_date# AND
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
		alert('Belgenizdeki <cfif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 3>Özel Kodlara<cfelseif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 2>Stok Kodlarına<cfelse>Barkodlara</cfif> Ait Hiçbir Ürün Bulunamadı. Lütfen Belgenizi Kontrol Ediniz !');
		window.history.back();
	</script>
	<cfabort>
</cfif>
<!--- sarf ve fire fislerinde dosyada fiyat belirtilmemisse,fiyat alanına net maliyet yazılır --->
<cfif isdefined("attributes.process_cat")>
	<cfset attributes.sepet_process_type = evaluate("ct_process_type_#attributes.process_cat#")>
</cfif>
<cfif session.ep.our_company_info.is_cost_location eq 1 and isdefined('attributes.sepet_process_type') and listfind("111,112,113,116,119,141",attributes.sepet_process_type)>
    <cfquery name="GET_PRODUCT_COST" datasource="#dsn3#">
        SELECT
        	PC.PRODUCT_ID,
            PC.PURCHASE_NET_MONEY,
            PC.PURCHASE_NET_LOCATION_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
            PC.PURCHASE_NET_SYSTEM_LOCATION_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET_SYSTEM,
            PC.PURCHASE_EXTRA_COST_SYSTEM_LOCATION * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST_SYSTEM,
            PC.START_DATE,
            PC.RECORD_DATE,
            PC.PRODUCT_COST_ID
        FROM
            PRODUCT_COST PC,
            #dsn2_alias#.SETUP_MONEY SM
        WHERE 
            SM.MONEY = PC.PURCHASE_NET_MONEY AND
            PC.PRODUCT_COST IS NOT NULL AND
            <cfif isdefined("attributes.fis_date") and len(attributes.fis_date)>
                PC.START_DATE < #DATEADD('d',1,attributes.fis_date)# AND 
            <cfelse>
                PC.START_DATE < #now()# AND
            </cfif>
            PC.PRODUCT_ID IN (#urun_listesi#)
            <cfif isdefined("attributes.department_out") and len(attributes.department_out)>
                AND PC.DEPARTMENT_ID = #listfirst(attributes.department_out)#	
            </cfif>
            <cfif isdefined("attributes.location_out") and len(attributes.location_out)>
                AND PC.LOCATION_ID = #attributes.location_out#	
            </cfif>
        ORDER BY 
            PC.START_DATE DESC,PC.RECORD_DATE DESC,PC.PRODUCT_COST_ID DESC
    </cfquery>
<cfelse>
    <cfquery name="GET_PRODUCT_COST" datasource="#DSN2#"> 
        SELECT
            PRODUCT_ID,
            PURCHASE_NET_MONEY,
            PURCHASE_NET,
            PURCHASE_NET_SYSTEM,
            PURCHASE_EXTRA_COST_SYSTEM,
            START_DATE,
            RECORD_DATE,
            PRODUCT_COST_ID
        FROM
            GET_PRODUCT_COST_PERIOD
        WHERE 
        <cfif isdefined('attributes.fis_date') and isdate(attributes.fis_date)>
            START_DATE < #DATEADD('d',1,attributes.fis_date)# AND 
        <cfelse>
            START_DATE < #now()# AND
        </cfif>
            PRODUCT_ID IN (#urun_listesi#)
    </cfquery>
</cfif>
<cfloop from="1" to="#line_count#" index="k">
	<cfset barkod_no = trim(ListGetAt(dosya[k],1,";"))>
	<cftry>
		<cfset miktar = replace(trim(ListGetAt(dosya[k],2,";")),",",".","all")>
		<cfif listlen(dosya[k],';') gte 3><cfset spect_main_id = trim(ListGetAt(dosya[k],3,";"))><cfelse><cfset spect_main_id = ""></cfif>
		<cfif listlen(dosya[k],';') gte 4><cfset to_shelf_number = trim(ListGetAt(dosya[k],4,";"))><cfelse><cfset to_shelf_number = ""></cfif>
		<cfif listlen(dosya[k],';') gte 5><cfset shelf_number = trim(ListGetAt(dosya[k],5,";"))><cfelse><cfset shelf_number = ""></cfif>
		<cfif listlen(dosya[k],';') gte 6><cfset lot_no_ = trim(ListGetAt(dosya[k],6,";"))><cfelse><cfset lot_no_ = ""></cfif>
        <cfif listlen(dosya[k],';') gte 7>
			<cfset row_project_id = trim(ListGetAt(dosya[k],7,";"))>
            <cfif len(row_project_id)>
                <cfquery name="GET_PROJECT" datasource="#dsn#">
                    SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #row_project_id#
                </cfquery>
                <cfset row_project_name = GET_PROJECT.PROJECT_HEAD>
            <cfelse>
                <cfset row_project_id = ''>
                <cfset row_project_name = ''>
            </cfif>
        <cfelse>
            <cfset row_project_id = ''>
            <cfset row_project_name = ''>
		</cfif>
		<cfif listlen(dosya[k],';') gte 8><cfset detail = trim(ListGetAt(dosya[k],8,";"))><cfelse><cfset detail = ""></cfif>
		<cfcatch>
			<cfset miktar = 1>
		</cfcatch>
	</cftry>
	<cfif len(miktar) and miktar neq 0>
		<cfquery name="GET_PRODUCT_MAIN" dbtype="query" maxrows="1">
			SELECT 
				BARCODE,
				STOCK_CODE_2,
				STOCK_ID,
				PRODUCT_ID,
				STOCK_CODE,
				PRODUCT_NAME,
				IS_INVENTORY,
				IS_PRODUCTION,
				MANUFACT_CODE,
				TAX,
				ADD_UNIT,
				PRODUCT_UNIT_ID,
				PRICE,
				MONEY,
				PROPERTY,
				START_DATE
			FROM
				GET_PRODUCT_MAIN_ALL
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
			<cfquery name="GET_COST_AMOUNT" dbtype="query"  maxrows="1">
				SELECT * FROM GET_PRODUCT_COST WHERE PRODUCT_ID = #get_product_main.product_id# 
				ORDER BY 
				START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC
			</cfquery>
			<cfif len(spect_main_id)>
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
			<cfif len(to_shelf_number) and isnumeric(to_shelf_number)>
				<cfquery name="get_to_shelf_number" datasource="#dsn3#">
					SELECT PP.PRODUCT_PLACE_ID FROM PRODUCT_PLACE PP,#dsn_alias#.SHELF WHERE SHELF.SHELF_ID = PP.SHELF_TYPE AND PLACE_STATUS=1 AND PRODUCT_PLACE_ID = #to_shelf_number#
				</cfquery>
			<cfelse>
				<cfset get_to_shelf_number.PRODUCT_PLACE_ID = "">
			</cfif>
			<cfif len(shelf_number) and isnumeric(shelf_number)>
				<cfquery name="get_shelf_number" datasource="#dsn3#">
					SELECT PP.PRODUCT_PLACE_ID FROM PRODUCT_PLACE PP,#dsn_alias#.SHELF WHERE SHELF.SHELF_ID = PP.SHELF_TYPE AND PLACE_STATUS=1 AND PRODUCT_PLACE_ID = #shelf_number#
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
				sepet.satir[i].spect_id = spect_var_id_row;
				sepet.satir[i].spect_name = spect_var_name_row;
				
				sepet.satir[i].to_shelf_number = get_to_shelf_number.PRODUCT_PLACE_ID;
				sepet.satir[i].shelf_number = get_shelf_number.PRODUCT_PLACE_ID;
				
				sepet.satir[i].row_project_id = row_project_id;
				sepet.satir[i].row_project_name = row_project_name;

				sepet.satir[i].product_name_other = detail;
				
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
				if( listlen(dosya[k],';') eq 3 and len(trim(ListGetAt(dosya[k],3,";"))) ) //dosyada yazılan fiyat, sistem para birimi cinsinden
				{
					sepet.satir[i].price = trim(ListGetAt(dosya[k],3,";"));
					sepet.satir[i].price_other = trim(ListGetAt(dosya[k],3,";"));
					sepet.satir[i].other_money = #session.ep.money#;
					sepet.satir[i].other_money_value = trim(ListGetAt(dosya[k],3,";"));
				}
				else if(len(get_cost_amount.PURCHASE_NET)) //urunun kayıtlı maliyeti fiyatı olarak yazdırılıyor
				{
					sepet.satir[i].price = get_cost_amount.PURCHASE_NET_SYSTEM;
					sepet.satir[i].price_other = get_cost_amount.PURCHASE_NET;
					sepet.satir[i].net_maliyet = get_cost_amount.PURCHASE_NET_SYSTEM;
					sepet.satir[i].extra_cost = get_cost_amount.PURCHASE_EXTRA_COST_SYSTEM;
					sepet.satir[i].other_money = get_cost_amount.PURCHASE_NET_MONEY;
					sepet.satir[i].other_money_value = get_cost_amount.PURCHASE_NET;
				}
				else  //urunun standart alıs fiyatı atanıyor
				{
					if(get_product_main.MONEY eq SESSION.EP.MONEY)
					{
						sepet.satir[i].price = get_product_main.PRICE;
						sepet.satir[i].price_other = get_product_main.PRICE;
						sepet.satir[i].other_money = #session.ep.money#;
						sepet.satir[i].other_money_value = get_product_main.PRICE;
					}
					else
					{
						get_rate = cfquery(datasource : "#DSN#", sqlstring : "SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY='#get_product_main.MONEY#'");
						sepet.satir[i].price = get_product_main.PRICE * (get_rate.RATE2/get_rate.RATE1);
						sepet.satir[i].price_other = get_product_main.PRICE;
						sepet.satir[i].other_money = get_product_main.MONEY;
						sepet.satir[i].other_money_value = get_product_main.PRICE;
					}
				}
				
				sepet.satir[i].tax_percent = get_product_main.TAX;
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
				sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan,price_round_number);
				sepet.satir[i].row_taxtotal = wrk_round(sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100),price_round_number);
				sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
				sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
				sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
				sepet.total_tax = sepet.total_tax + sepet.satir[i].row_taxtotal; //totaltax_
				sepet.net_total = sepet.net_total + sepet.satir[i].row_lasttotal; //nettotal_
	
				sepet.satir[i].deliver_date = "";
				sepet.satir[i].deliver_dept = "" ;
				if(isdefined("lot_no_")  and len(lot_no_))
					sepet.satir[i].lot_no = lot_no_;
				else
					sepet.satir[i].lot_no = "";
	
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
				sepet.satir[i].assortment_array = ArrayNew(1); 
			</cfscript> 
		</cfif>
	</cfif>
</cfloop>

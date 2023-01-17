<cfset kontrol_file = 0>
<cfset upload_folder = "#upload_folder#sales#dir_seperator#">
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
			alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	
	<cfset file_size = cffile.filesize>
	<cfset dosya_yolu = "#upload_folder##file_name#">
	<cffile action="read" file="#dosya_yolu#" variable="dosya">
	<cfcatch type="Any">
		<cfset kontrol_file = 1>
	</cfcatch>
</cftry>
<cfif kontrol_file eq 0>
	<cfscript>
		CRLF = Chr(13) & Chr(10);// satır atlama karakteri
		dosya = Replace(dosya,';;','; ;','all');
		dosya = Replace(dosya,';;','; ;','all');
		dosya = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya);
	</cfscript>
	
	<cfloop from="2" to="#line_count#" index="k">
		<cfset j= 1>
		<cfscript>
			quantity = Listgetat(dosya[k],j,";"); // Miktar
			quantity = trim(quantity);
			j=j+1;

			row_company_no = Listgetat(dosya[k],j,";"); // Üye
			row_company_no = trim(row_company_no);
			j=j+1;
			
			product_stock_code = Listgetat(dosya[k],j,";"); // Ürün //Stok Kodu yerine kullanılıyor
			product_stock_code = trim(product_stock_code);
			j=j+1;
			
			row_brand_id = Listgetat(dosya[k],j,";"); // Marka
			row_brand_id = trim(row_brand_id);
			j=j+1;
			
			row_category = Listgetat(dosya[k],j,";"); // Kategori
			row_category = trim(row_category);
			j=j+1;
						
			period_type = Listgetat(dosya[k],j,";"); // Dönem
			period_type = trim(period_type);
			j=j+1;
						
			row_total = Listgetat(dosya[k],j,";"); // Min Total
			row_total = trim(row_total);
			j=j+1;
			
			row_total_max = Listgetat(dosya[k],j,";"); // Max Total
			row_total_max = trim(row_total_max);
			j=j+1;
			
			row_other_total = Listgetat(dosya[k],j,";"); // Min Döviz Tutar
			row_other_total = trim(row_other_total);
			j=j+1;
			
			row_other_total_max = Listgetat(dosya[k],j,";"); // Max Döviz Tutar
			row_other_total_max = trim(row_other_total_max);
			j=j+1;
			
			premium_per_ = Listgetat(dosya[k],j,";"); // Prim 1
			premium_per_ = trim(premium_per_);
			j=j+1;
			
			premium_per2_ = Listgetat(dosya[k],j,";"); // Prim2
			premium_per2_ = trim(premium_per2_);
			j=j+1;
			
			premium_per3_ = Listgetat(dosya[k],j,";"); // Prim3
			premium_per3_ = trim(premium_per3_);
			j=j+1;
			
			row_premium_total = Listgetat(dosya[k],j,";"); // Prim Tutar
			row_premium_total = trim(row_premium_total);
			j=j+1;
			
			extra_stock = Listgetat(dosya[k],j,";"); // Mal Fazlası
			extra_stock = trim(extra_stock);
			j=j+1;
			
			profit_per = Listgetat(dosya[k],j,";"); // Kâr
			profit_per = trim(profit_per);
			j=j+1;
			
			row_profit_total = Listgetat(dosya[k],j,";"); // Kâr Toplam
			row_profit_total = trim(row_profit_total);
			j=j+1;
			
			row_detail = Listgetat(dosya[k],j,";"); // Açıklama
			row_detail = trim(row_detail);
			j=j+1;
			
		</cfscript>
		<cfif len(row_company_no)>
			<cfquery name="GET_COMPANY_NAME" datasource="#dsn#">
				SELECT FULLNAME,COMPANY_ID FROM COMPANY WHERE MEMBER_CODE = '#row_company_no#'
			</cfquery>
            <cfset row_company_id = GET_COMPANY_NAME.COMPANY_ID>
			<cfset fullname = GET_COMPANY_NAME.FULLNAME>
		<cfelse>
        	<cfset row_company_id = ''>
			<cfset fullname = ''>
		</cfif>
		<cfif len(row_brand_id)>
			<cfquery name="GET_BRAND_NAME" datasource="#dsn1#">
				SELECT BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID = #row_brand_id#
			</cfquery>
			<cfset brandname = GET_BRAND_NAME.BRAND_NAME>
		<cfelse>
			<cfset brandname = ''>
		</cfif>
		<cfif len(row_category)>
			<cfquery name="GET_PRODUCT_CAT_NAME" datasource="#dsn1#">
				SELECT PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID = #row_category#
			</cfquery>
			<cfset category_name = GET_PRODUCT_CAT_NAME.PRODUCT_CAT>
		<cfelse>
			<cfset category_name = ''>
		</cfif>
		<cfif len(product_stock_code)>
			<cfquery name="GET_PRODUCT_NAME" datasource="#dsn1#">
				SELECT STOCKS.STOCK_ID,PRODUCT.PRODUCT_NAME,PRODUCT.PRODUCT_ID FROM PRODUCT LEFT JOIN STOCKS ON PRODUCT.PRODUCT_ID = STOCKS.STOCK_ID WHERE PRODUCT.PRODUCT_CODE = '#product_stock_code#'
			</cfquery>
			<cfset product_id = GET_PRODUCT_NAME.PRODUCT_ID>
			<cfset product_name = GET_PRODUCT_NAME.PRODUCT_NAME>
			<cfset stock_id = GET_PRODUCT_NAME.STOCK_ID>
		<cfelse>
        	<cfset product_id = ''>
			<cfset product_name = ''>
			<cfset stock_id = ''>
		</cfif>
		<cfoutput>
			<script type="text/javascript">
				<cfif isdefined("attributes.choose_option") and len(attributes.choose_option)>
					<cfif attributes.choose_option contains '0'>
						document.getElementById('is_wiew_purveyor').checked = true;
						document.getElementById('g_tedarikci').style.display = '';
					</cfif>
					<cfif attributes.choose_option contains '1'>
						document.getElementById('is_wiew_mark').checked = true;
						document.getElementById('g_marka').style.display = '';
					<cfelse>
						document.getElementById('g_marka').style.display = 'none';
					</cfif>
					<cfif attributes.choose_option contains '2'>
						document.getElementById('is_wiew_cat').checked = true;
						document.getElementById('g_kategori').style.display = '';
					<cfelse>
						document.getElementById('g_kategori').style.display = 'none';
					</cfif>
					<cfif attributes.choose_option contains '3'>
						document.getElementById('is_wiew_product').checked = true;
						document.getElementById('g_mal_fazlasi').style.display = '';
						document.getElementById('g_urun').style.display = '';
					<cfelse>
						document.getElementById('g_urun').style.display = 'none';
					</cfif>
				</cfif>
				add_row("#row_company_id#","#fullname#","#row_brand_id#","#brandname#","#row_category#","#category_name#","#product_id#","#stock_id#","#product_name#","#period_type#","#quantity#","#row_total#","#row_total_max#","#row_other_total#","#row_other_total_max#","#premium_per_#","#premium_per2_#","#premium_per3_#","#row_premium_total#","#extra_stock#","#profit_per#","#row_profit_total#","#row_detail#");
			</script>
		</cfoutput>
	</cfloop>
</cfif>

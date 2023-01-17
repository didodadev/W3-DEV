<!---Daha Sonra İlgilenilmesi Gereken Parametreler--->
<cfset record_num_yrm = 0>
<cfset record_num_hzm = 0>
<cfset record_num = 0>
<cfset attributes.piece_detail =''>
<!---Daha Sonra İlgilenilmesi Gereken Parametreler--->
<cfset attributes.import_files = 1>
<cfquery name="get_main_defaults" datasource="#dsn3#">
	SELECT        
    	DEFAULT_YONGA_LEVHA_THICKNESS, 
        DEFAULT_YONGA_LEVHA_FIRE_RATE, 
        DEFAULT_PVC_THICKNESS, 
        DEFAULT_PVC_FIRE_AMOUNT, 
        DEFAULT_MASTER_PVC_STOCK_ID,
        DEFAULT_PIECE_TYPE, 
        DEFAULT_TRIM_TYPE, 
    	DEFAULT_TRIM_AMOUNT,
        (SELECT THICKNESS_VALUE FROM EZGI_THICKNESS WHERE THICKNESS_ID = EZGI_DESIGN_DEFAULTS.DEFAULT_YONGA_LEVHA_THICKNESS) AS DEFAULT_THICKNESS,
        (SELECT THICKNESS_VALUE FROM EZGI_THICKNESS_EXT WHERE THICKNESS_ID = EZGI_DESIGN_DEFAULTS.DEFAULT_PVC_THICKNESS) AS DEFAULT_EXT_THICKNESS
	FROM            
    	EZGI_DESIGN_DEFAULTS
</cfquery>

<!---Defaultlar--->
<cfparam name="attributes.piece_type" default="#get_main_defaults.DEFAULT_PIECE_TYPE#">
<cfparam name="attributes.trim_type" default="#get_main_defaults.DEFAULT_PIECE_TYPE#">
<cfparam name="attributes.trim_rate" default="#TlFormat(get_main_defaults.DEFAULT_TRIM_AMOUNT,1)#">
<cfparam name="attributes.pvc_fire_amount" default="#get_main_defaults.DEFAULT_PVC_FIRE_AMOUNT#">
<cfparam name="attributes.yonga_levha_fire_rate" default="#get_main_defaults.DEFAULT_YONGA_LEVHA_FIRE_RATE#">
<cfparam name="attributes.pvc_stock_id" default="#get_main_defaults.DEFAULT_MASTER_PVC_STOCK_ID#">
<cfset default_thickness = get_main_defaults.DEFAULT_YONGA_LEVHA_THICKNESS>
<cfset attributes.PIECE_TYPE = 1>
<!---Defaultlar--->
<!---Parça Defaultlarını Çekme--->
<cfquery name="get_piece_defaults" datasource="#dsn3#">
	SELECT PIECE_DEFAULT_ID, PIECE_DEFAULT_CODE, PIECE_DEFAULT_NAME FROM EZGI_DESIGN_PIECE_DEFAULTS ORDER BY PIECE_DEFAULT_NAME
</cfquery>
<!---Parça Defaultlarını Çekme--->
<!---Renkler Bilgisi Çekme--->
<cfquery name="get_colors" datasource="#dsn3#">
	SELECT * FROM EZGI_COLORS ORDER BY COLOR_NAME
</cfquery>
<!---Renkler Bilgisi Çekme--->
<!---Kalınlıklar Bilgisi Çekme--->
<cfquery name="get_thickness" datasource="#dsn3#">
	SELECT THICKNESS_ID, THICKNESS_VALUE FROM EZGI_THICKNESS
</cfquery>
<!---Kalınlıklar Bilgisi Çekme--->
<!---PVC Stoklarını Çekme--->
<cfquery name="get_pvc_stock" datasource="#dsn3#">
	SELECT 
    	STOCK_ID, 
        PRODUCT_NAME
	FROM            
    	STOCKS
	WHERE        
    	PRODUCT_CATID IN
                   		(
                        	SELECT        
                            	PRODUCT_CATID
                         	FROM            
                            	STOCKS AS STOCKS_1
                         	WHERE        
                            	STOCK_ID = #attributes.pvc_stock_id#
                     	)
</cfquery>
<!---PVC Stoklarını Çekme--->
<!---Paket Bilgisi Çekme--->
<cfquery name="get_design_package_row" datasource="#dsn3#">
	SELECT PACKAGE_NUMBER, PACKAGE_ROW_ID FROM EZGI_DESIGN_PACKAGE WHERE DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id# ORDER BY PACKAGE_NUMBER
</cfquery>
<!---Paket Bilgisi Çekme--->
<!---Modül Bilgisi Çekme--->
<cfquery name="get_design_main_row" datasource="#dsn3#">
	SELECT 
    	*, 
        (SELECT MAIN_ROW_SETUP_NAME FROM EZGI_DESIGN_MAIN_ROW_SETUP WHERE MAIN_ROW_SETUP_ID = EZGI_DESIGN_MAIN_ROW.MAIN_ROW_SETUP_ID) as MAIN_ROW_SETUP_NAME,
        (SELECT COLOR_NAME FROM EZGI_COLORS WHERE COLOR_ID = EZGI_DESIGN_MAIN_ROW.DESIGN_MAIN_COLOR_ID) as COLOR_NAME
  	FROM 
    	EZGI_DESIGN_MAIN_ROW 
  	WHERE 
    	DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id#
</cfquery>
<cfset main_setup_name = get_design_main_row.MAIN_ROW_SETUP_NAME>
<cfset attributes.design_id =  get_design_main_row.DESIGN_ID>
<!---Modül Bilgisi Çekme--->
<!---Tasarım Bilgisi Çekme--->
<cfquery name="get_design" datasource="#dsn3#">
	SELECT  * FROM EZGI_DESIGN WHERE DESIGN_ID = #get_design_main_row.DESIGN_ID#
</cfquery>
<!---Tasarım Bilgisi Çekme--->
<!---Default PVC Stoklarını Çekme--->
<cfquery name="get_default_pvc_stock" datasource="#dsn3#">
	SELECT 
    	STOCK_ID, 
        THICKNESS_ID, 
        PRODUCT_NAME 
  	FROM 
    	EZGI_DESIGN_PRODUCT_PROPERTIES_UST 
  	WHERE 
    	KALINLIK_ETKISI_ID = #get_main_defaults.DEFAULT_PVC_THICKNESS# AND 
        COLOR_ID = #get_design_main_row.DESIGN_MAIN_COLOR_ID#
</cfquery>
<!---Default PVC Stoklarını Çekme--->
<cfset upload_folder = "#upload_folder#temp#dir_seperator#">
<cftry>
	<cffile action = "upload" 
			fileField = "uploaded_file" 
			destination = "#upload_folder#"
			nameConflict = "MakeUnique"  
			mode="777" charset="#attributes.file_format#">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">	
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
        	<cfoutput>#cfcatch.detail#</cfoutput>
		<cfabort>
	</cfcatch>  
</cftry>

<cftry>
	<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="#attributes.file_format#">
	<cffile action="delete" file="#upload_folder##file_name#">
    <cfcatch>
        <script type="text/javascript">
            alert("<cf_get_lang_main no='1653.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir'>.");
            history.back();
        </script>
        <cfabort>
    </cfcatch>
</cftry>
<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
</cfscript>
<cfset counter = 0>
<cfset tree_error_flag = 0>
<cfset satirlar = queryNew("design_code_piece_row, default_type, color_type, piece_amount, piece_kalinlik, piece_boy, piece_en, piece_su_yonu, piece_package_no, anahtar_1, pvc_materials_1, anahtar_2, pvc_materials_2, anahtar_3, pvc_materials_3, anahtar_4, pvc_materials_4","VarChar, integer, integer, Decimal, integer, Decimal, Decimal, Bit, integer, Bit, integer, Bit, integer, Bit, integer, Bit, integer") />
<cfloop from="2" to="#line_count#" index="i">
	<cfset temp = QueryAddRow(satirlar)>
	<cfset j = 1>
    <cfset error_flag = 0>
    <cftry>
        <cfscript>
			counter = counter + 1;
            if(Right(dosya[i],1) is ';')
                dosya[i] = '#dosya[i]#0';
			//Parça Kodu
            design_code_piece_row = Listgetat(dosya[i],j,";");
            design_code_piece_row = trim(design_code_piece_row);
            j=j+1;
            //Default Parça Türü
            default_type = Listgetat(dosya[i],j,";");
            default_type = trim(default_type);
            j=j+1;
			//Parça Rengi ID
            color_type = Listgetat(dosya[i],j,";");
            color_type = trim(color_type);
            j=j+1;	
			//Parça Miktarı
            piece_amount = Listgetat(dosya[i],j,";");
            piece_amount = trim(piece_amount);
            j=j+1;
			//Parça Kalınlık ID
            piece_kalinlik = Listgetat(dosya[i],j,";");
            piece_kalinlik = trim(piece_kalinlik);
            j=j+1;
			//Parça Boy
            piece_boy = Listgetat(dosya[i],j,";");
            piece_boy = trim(piece_boy);
            j=j+1;
			//Parça En
            piece_en = Listgetat(dosya[i],j,";");
            piece_en = trim(piece_en);
            j=j+1;
			//Parça Desen Yönü
            piece_su_yonu = Listgetat(dosya[i],j,";");
            piece_su_yonu = trim(piece_su_yonu);
            j=j+1;
			//Paket No
            piece_package_no = Listgetat(dosya[i],j,";");
            piece_package_no = trim(piece_package_no);
            j=j+1;
			//Kısa Kenar 1 Varmı
            anahtar_1 = Listgetat(dosya[i],j,";");
            anahtar_1 = trim(anahtar_1);
            j=j+1;
			//Kısa Kenar 1 Stock_ID
            pvc_materials_1 = Listgetat(dosya[i],j,";");
            pvc_materials_1 = trim(pvc_materials_1);
            j=j+1;
			//Kısa Kenar 2 Varmı
            anahtar_2 = Listgetat(dosya[i],j,";");
            anahtar_2 = trim(anahtar_2);
            j=j+1;
			//Kısa Kenar 2 Stock_ID
            pvc_materials_2 = Listgetat(dosya[i],j,";");
            pvc_materials_2 = trim(pvc_materials_2);
            j=j+1;
			//Uzun Kenar 1 Varmı
            anahtar_3 = Listgetat(dosya[i],j,";");
            anahtar_3 = trim(anahtar_3);
            j=j+1;
			//Uzun Kenar 1 Stock_ID
            pvc_materials_3 = Listgetat(dosya[i],j,";");
            pvc_materials_3 = trim(pvc_materials_3);
            j=j+1;
			//Uzun Kenar 2 Varmı
            anahtar_4 = Listgetat(dosya[i],j,";");
            anahtar_4 = trim(anahtar_4);
            j=j+1;
			//Uzun Kenar 2 Stock_ID
            pvc_materials_4 = Listgetat(dosya[i],j,";");
            pvc_materials_4 = trim(pvc_materials_4);
            j=j+1;
        </cfscript>
        
        <cfset Temp = QuerySetCell(satirlar, "design_code_piece_row", design_code_piece_row)>
        <!---PIECE_DEFAULT_ID arama--->
		<cfif attributes.file_type eq 1> <!---Excel--->
            <cfquery name="get_default_name" dbtype="query">
                SELECT PIECE_DEFAULT_NAME,PIECE_DEFAULT_ID FROM get_piece_defaults WHERE PIECE_DEFAULT_NAME = '#default_type#'
            </cfquery>
            <cfif not get_default_name.recordcount>
				<script type="text/javascript">
                 	alert("<cf_get_lang_main no='3447.Geçersiz Bilgi'> ! <cfoutput>#i#. <cf_get_lang_main no='1096.Satır'> #default_type# <cf_get_lang_main no='3026.Default Parça Adı ile uyumlu olmalıdır'> .</cfoutput>");
                    history.back();
                </script>
                <cfabort>
            <cfelse>
            	<cfset Temp = QuerySetCell(satirlar, "default_type", get_default_name.PIECE_DEFAULT_ID)>
            </cfif>
        <cfelseif attributes.file_type eq 3> <!---Topsolid--->
            <cfquery name="get_default_name" dbtype="query">
                SELECT PIECE_DEFAULT_NAME,PIECE_DEFAULT_ID FROM get_piece_defaults WHERE PIECE_DEFAULT_ID = #ListGetAt(default_type,1,'-')#
            </cfquery>
           	<cfif not get_default_name.recordcount>
				<script type="text/javascript">
                 	alert("<cf_get_lang_main no='3447.Geçersiz Bilgi'> ! <cfoutput>#i#. <cf_get_lang_main no='1096.Satır'> #default_type# <cf_get_lang_main no='3026.Default Parça Adı ile uyumlu olmalıdır'>.</cfoutput>");
                    history.back();
                </script>
                <cfabort>
            <cfelse> 
            	<cfset Temp = QuerySetCell(satirlar, "default_type", get_default_name.PIECE_DEFAULT_ID)>
            </cfif>
        <cfelseif attributes.file_type eq 2> <!---Autocad--->
        	<cfset Temp = QuerySetCell(satirlar, "default_type", default_type)>
        </cfif>
        <!---PIECE_DEFAULT_ID arama--->
        <!---COLOR_ID arama--->
		<cfif attributes.file_type eq 1> <!---Excel--->
        	<cfif len(color_type)>
                <cfquery name="get_color_name" dbtype="query">
                    SELECT COLOR_ID, COLOR_NAME FROM get_colors WHERE COLOR_NAME = '#color_type#'
                </cfquery>
                <cfif not get_color_name.recordcount>
                    <script type="text/javascript">
                        alert("<cf_get_lang_main no='3447.Geçersiz Bilgi'> ! <cfoutput>#i#. <cf_get_lang_main no='1096.Satır'> #color_type# <cf_get_lang_main no='2914.Renk Adı'>.</cfoutput>");
                        history.back();
                    </script>
                    <cfabort>
                <cfelse>
                    <cfset Temp = QuerySetCell(satirlar, "color_type", get_color_name.COLOR_ID)>
                </cfif>
            <cfelse>
            	<cfset Temp = QuerySetCell(satirlar, "color_type", get_design_main_row.DESIGN_MAIN_COLOR_ID)>
            </cfif>
        <cfelse><!---Autocad ve Top Solid--->
        	<cfset Temp = QuerySetCell(satirlar, "color_type", color_type)>
        </cfif>
        <!---COLOR_ID arama--->
        <!---THICKNESS_ID arama--->
        <cfif len(piece_kalinlik)>
			<cfif attributes.file_type eq 1 or attributes.file_type eq 3> <!---Excel ve Top Solid--->	 
            	<cfquery name="get_thickness_id" dbtype="query">
                	SELECT * FROM get_thickness WHERE THICKNESS_VALUE = '#piece_kalinlik#'
                </cfquery>
                <cfif not get_thickness_id.recordcount>
                	<script type="text/javascript">
						alert("<cf_get_lang_main no='3447.Geçersiz Bilgi'> ! <cfoutput>#i#. <cf_get_lang_main no='1096.Satır'> #piece_kalinlik# <cf_get_lang_main no='2878.Kalınlık'> <cf_get_lang_main no='1248.Değeri'>.</cfoutput>");
						history.back();
					</script>
					<cfabort>
                <cfelse>
                    <cfset Temp = QuerySetCell(satirlar, "piece_kalinlik", get_thickness_id.THICKNESS_ID)>
                    <cfset kalinlik = get_thickness_id.THICKNESS_ID>
                </cfif>
            <cfelse><!---Autocad--->
            	<cfquery name="get_thickness_id" dbtype="query">
                	SELECT * FROM get_thickness WHERE THICKNESS_ID = #piece_kalinlik#
                </cfquery>
                <cfif not get_thickness_id.recordcount>
                	<script type="text/javascript">
						alert("<cf_get_lang_main no='3447.Geçersiz Bilgi'> ! <cfoutput>#i#. <cf_get_lang_main no='1096.Satır'> #piece_kalinlik# <cf_get_lang_main no='2878.Kalınlık'> <cf_get_lang_main no='1248.Değeri'>.</cfoutput>");
						history.back();
					</script>
					<cfabort>
                <cfelse>
                    <cfset Temp = QuerySetCell(satirlar, "piece_kalinlik", get_thickness_id.THICKNESS_ID)>
                    <cfset kalinlik = get_thickness_id.THICKNESS_ID>
                </cfif>
            </cfif>
        <cfelse>
        	<cfset Temp = QuerySetCell(satirlar, "piece_kalinlik", get_main_defaults.DEFAULT_YONGA_LEVHA_THICKNESS)>
            <cfset kalinlik = get_main_defaults.DEFAULT_YONGA_LEVHA_THICKNESS>
        </cfif>
        <!---THICKNESS_ID arama--->
        <!---PVC STOCK ID arama--->
		<cfif attributes.file_type eq 1> <!---Excel--->
        	<cfif anahtar_1 eq 1> <!---PVC Var Denmişse--->
                <cfif len(pvc_materials_1)> <!---PVC Stok Adı Belirtilmişse--->
               		<cfquery name="get_pvc_stock_id_1" dbtype="query">
                     	SELECT * FROM get_pvc_stock WHERE PRODUCT_NAME = '#pvc_materials_1#'
                 	</cfquery>
                    <cfif not get_pvc_stock_id_1.recordcount>
                    	<script type="text/javascript">
							alert("<cf_get_lang_main no='3447.Geçersiz Bilgi'> ! <cfoutput>#i#. <cf_get_lang_main no='1096.Satır'> #pvc_materials_1# PVC <cf_get_lang_main no='1922.Birim Adını Kontrol Ediniz'>.</cfoutput>");
							history.back();
						</script>
                		<cfabort>
                    <cfelse> 
                    	<cfset Temp = QuerySetCell(satirlar, "anahtar_1", 1)>
						<cfset Temp = QuerySetCell(satirlar, "pvc_materials_1", get_pvc_stock_id_1.STOCK_ID)>
                    </cfif>
                <cfelse><!---PVC Stok Adı Belirtilmemişse--->
                	<cfquery name="get_default_pvc_stock_id_1" dbtype="query">
                   		SELECT STOCK_ID FROM get_default_pvc_stock WHERE THICKNESS_ID = #kalinlik# 
                 	</cfquery>
                    <cfif not get_default_pvc_stock_id_1.recordcount>
                    	<script type="text/javascript">
							alert("<cf_get_lang_main no='3447.Geçersiz Bilgi'> ! <cfoutput>#i#. <cf_get_lang_main no='1096.Satır'> #get_main_defaults.DEFAULT_THICKNESS# <cf_get_lang_main no='283.Genişlik'>, #get_main_defaults.DEFAULT_EXT_THICKNESS# <cf_get_lang_main no='2878.Kalınlık'>, #get_design_main_row.color_name# <cf_get_lang_main no='3002.Renk'> PVC <cf_get_lang_main no='3144.Ürün Bulunamadı'>.</cfoutput>");
							history.back();
						</script>
                		<cfabort>
                    <cfelse> 
                    	<cfset Temp = QuerySetCell(satirlar, "anahtar_1", 1)>
						<cfset Temp = QuerySetCell(satirlar, "pvc_materials_1", get_default_pvc_stock_id_1.STOCK_ID)>
                    </cfif>
                </cfif>
         	<cfelse>
            	<cfset Temp = QuerySetCell(satirlar, "anahtar_1", anahtar_1)>
				<cfset Temp = QuerySetCell(satirlar, "pvc_materials_1", pvc_materials_1)>
         	</cfif>
            <cfif anahtar_2 eq 1> <!---PVC Var Denmişse--->
                <cfif len(pvc_materials_2)> <!---PVC Stok Adı Belirtilmişse--->
               		<cfquery name="get_pvc_stock_id_2" dbtype="query">
                     	SELECT * FROM get_pvc_stock WHERE PRODUCT_NAME = '#pvc_materials_2#'
                 	</cfquery>
                    <cfif not get_pvc_stock_id_2.recordcount>
                    	<script type="text/javascript">
							alert("<cf_get_lang_main no='3447.Geçersiz Bilgi'> ! <cfoutput>#i#. <cf_get_lang_main no='1096.Satır'> #pvc_materials_2# PVC <cf_get_lang_main no='1922.Birim Adını Kontrol Ediniz'>.</cfoutput>");
							history.back();
						</script>
                		<cfabort>
                    <cfelse> 
                    	<cfset Temp = QuerySetCell(satirlar, "anahtar_2", 1)>
						<cfset Temp = QuerySetCell(satirlar, "pvc_materials_2", get_pvc_stock_id_2.STOCK_ID)>
                    </cfif>
                <cfelse><!---PVC Stok Adı Belirtilmemişse--->
                	<cfquery name="get_default_pvc_stock_id_2" dbtype="query">
                   		SELECT STOCK_ID FROM get_default_pvc_stock WHERE THICKNESS_ID = #kalinlik# 
                 	</cfquery>
                    <cfif not get_default_pvc_stock_id_2.recordcount>
                    	<script type="text/javascript">
							alert("<cf_get_lang_main no='3447.Geçersiz Bilgi'> ! <cfoutput>#i#. <cf_get_lang_main no='1096.Satır'> #get_main_defaults.DEFAULT_THICKNESS# <cf_get_lang_main no='283.Genişlik'>, #get_main_defaults.DEFAULT_EXT_THICKNESS# <cf_get_lang_main no='2878.Kalınlık'>, #get_design_main_row.color_name# <cf_get_lang_main no='3002.Renk'> PVC <cf_get_lang_main no='3144.Ürün Bulunamadı'>.</cfoutput>");
							history.back();
						</script>
                		<cfabort>
                    <cfelse> 
                    	<cfset Temp = QuerySetCell(satirlar, "anahtar_2", 1)>
						<cfset Temp = QuerySetCell(satirlar, "pvc_materials_2", get_default_pvc_stock_id_2.STOCK_ID)>
                    </cfif>
                </cfif>
         	<cfelse>
            	<cfset Temp = QuerySetCell(satirlar, "anahtar_2", anahtar_2)>
				<cfset Temp = QuerySetCell(satirlar, "pvc_materials_2", pvc_materials_2)>
         	</cfif>
            <cfif anahtar_3 eq 1> <!---PVC Var Denmişse--->
                <cfif len(pvc_materials_3)> <!---PVC Stok Adı Belirtilmişse--->
               		<cfquery name="get_pvc_stock_id_3" dbtype="query">
                     	SELECT * FROM get_pvc_stock WHERE PRODUCT_NAME = '#pvc_materials_3#'
                 	</cfquery>
                    <cfif not get_pvc_stock_id_3.recordcount>
                    	<script type="text/javascript">
							alert("<cf_get_lang_main no='3447.Geçersiz Bilgi'>! <cfoutput>#i#. <cf_get_lang_main no='1096.Satır'> #pvc_materials_3# PVC <cf_get_lang_main no='1922.Birim Adını Kontrol Ediniz'>.</cfoutput>");
							history.back();
						</script>
                		<cfabort>
                    <cfelse> 
                    	<cfset Temp = QuerySetCell(satirlar, "anahtar_3", 1)>
						<cfset Temp = QuerySetCell(satirlar, "pvc_materials_3", get_pvc_stock_id_3.STOCK_ID)>
                    </cfif>
                <cfelse><!---PVC Stok Adı Belirtilmemişse--->
                	<cfquery name="get_default_pvc_stock_id_3" dbtype="query">
                   		SELECT STOCK_ID FROM get_default_pvc_stock WHERE THICKNESS_ID = #kalinlik# 
                 	</cfquery>
                    <cfif not get_default_pvc_stock_id_3.recordcount>
                    	<script type="text/javascript">
							alert("<cf_get_lang_main no='3447.Geçersiz Bilgi'> ! <cfoutput>#i#. <cf_get_lang_main no='1096.Satır'> #get_main_defaults.DEFAULT_THICKNESS# <cf_get_lang_main no='283.Genişlik'>, #get_main_defaults.DEFAULT_EXT_THICKNESS# <cf_get_lang_main no='2878.Kalınlık'>, #get_design_main_row.color_name# <cf_get_lang_main no='3002.Renk'> PVC <cf_get_lang_main no='3144.Ürün Bulunamadı'>.</cfoutput>");
							history.back();
						</script>
                		<cfabort>
                    <cfelse> 
                    	<cfset Temp = QuerySetCell(satirlar, "anahtar_3", 1)>
						<cfset Temp = QuerySetCell(satirlar, "pvc_materials_3", get_default_pvc_stock_id_3.STOCK_ID)>
                    </cfif>
                </cfif>
         	<cfelse>
            	<cfset Temp = QuerySetCell(satirlar, "anahtar_3", anahtar_3)>
				<cfset Temp = QuerySetCell(satirlar, "pvc_materials_3", pvc_materials_3)>
         	</cfif>
            <cfif anahtar_4 eq 1> <!---PVC Var Denmişse--->
                <cfif len(pvc_materials_4)> <!---PVC Stok Adı Belirtilmişse--->
               		<cfquery name="get_pvc_stock_id_4" dbtype="query">
                     	SELECT * FROM get_pvc_stock WHERE PRODUCT_NAME = '#pvc_materials_4#'
                 	</cfquery>
                    <cfif not get_pvc_stock_id_4.recordcount>
                    	<script type="text/javascript">
							alert("<cf_get_lang_main no='3447.Geçersiz Bilgi'>! <cfoutput>#i#. <cf_get_lang_main no='1096.Satır'> #pvc_materials_3# PVC <cf_get_lang_main no='1922.Birim Adını Kontrol Ediniz'>.</cfoutput>");
							history.back();
						</script>
                		<cfabort>
                    <cfelse> 
                    	<cfset Temp = QuerySetCell(satirlar, "anahtar_4", 1)>
						<cfset Temp = QuerySetCell(satirlar, "pvc_materials_4", get_pvc_stock_id_4.STOCK_ID)>
                    </cfif>
                <cfelse><!---PVC Stok Adı Belirtilmemişse--->
                	<cfquery name="get_default_pvc_stock_id_4" dbtype="query">
                   		SELECT STOCK_ID FROM get_default_pvc_stock WHERE THICKNESS_ID = #kalinlik# 
                 	</cfquery>
                    <cfif not get_default_pvc_stock_id_4.recordcount>
                    	<script type="text/javascript">
							alert("<cf_get_lang_main no='3447.Geçersiz Bilgi'> ! <cfoutput>#i#. <cf_get_lang_main no='1096.Satır'> #get_main_defaults.DEFAULT_THICKNESS# <cf_get_lang_main no='283.Genişlik'>, #get_main_defaults.DEFAULT_EXT_THICKNESS# <cf_get_lang_main no='2878.Kalınlık'>, #get_design_main_row.color_name# <cf_get_lang_main no='3002.Renk'> PVC <cf_get_lang_main no='3144.Ürün Bulunamadı'>.</cfoutput>");
							history.back();
						</script>
                		<cfabort>
                    <cfelse> 
                    	<cfset Temp = QuerySetCell(satirlar, "anahtar_4", 1)>
						<cfset Temp = QuerySetCell(satirlar, "pvc_materials_4", get_default_pvc_stock_id_4.STOCK_ID)>
                    </cfif>
                </cfif>
         	<cfelse>
            	<cfset Temp = QuerySetCell(satirlar, "anahtar_4", anahtar_4)>
				<cfset Temp = QuerySetCell(satirlar, "pvc_materials_4", pvc_materials_4)>
         	</cfif>
        <cfelse> <!---Autocad ve Top Solid--->	
        	<cfset Temp = QuerySetCell(satirlar, "anahtar_1", anahtar_1)>
			<cfset Temp = QuerySetCell(satirlar, "pvc_materials_1", pvc_materials_1)>
            <cfset Temp = QuerySetCell(satirlar, "anahtar_2", anahtar_2)>
            <cfset Temp = QuerySetCell(satirlar, "pvc_materials_2", pvc_materials_2)>
            <cfset Temp = QuerySetCell(satirlar, "anahtar_3", anahtar_3)>
            <cfset Temp = QuerySetCell(satirlar, "pvc_materials_3", pvc_materials_3)>
            <cfset Temp = QuerySetCell(satirlar, "anahtar_4", anahtar_4)>
            <cfset Temp = QuerySetCell(satirlar, "pvc_materials_4", pvc_materials_4)>
        </cfif>
        <!---PVC STOCK ID arama--->
        <cfset Temp = QuerySetCell(satirlar, "piece_amount", piece_amount)>
        <cfset Temp = QuerySetCell(satirlar, "piece_boy", piece_boy)>
        <cfset Temp = QuerySetCell(satirlar, "piece_en", piece_en)>
        <cfset Temp = QuerySetCell(satirlar, "piece_su_yonu", piece_su_yonu)>
        <cfset Temp = QuerySetCell(satirlar, "piece_package_no", piece_package_no)>
        <cfcatch type="Any">
            <cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu. <br/>
            <cfset error_flag = 1>
        </cfcatch>
    </cftry>
</cfloop>
<cfif error_flag eq 0>
 	<cfinclude template="cnt_ezgi_product_tree_creative_import_piece_row.cfm">
    <script type="text/javascript">
		alert("<cfoutput>#satirlar.recordcount# <cf_get_lang_main no='3070.Satır Transfer Edilmiştir'>.</cfoutput>")
        wrk_opener_reload();
        window.close();
    </script>
<cfelse>
	<cf_get_lang_main no='1096.Satır'> <cf_get_lang_main no='2177.Hatalı Kayıt Bilgileri'>
    <cfabort>
</cfif>

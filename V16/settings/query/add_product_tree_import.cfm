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
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz. '>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>

<cftry>
	<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="#attributes.file_format#">
	<cffile action="delete" file="#upload_folder##file_name#">
<cfcatch>
	<script type="text/javascript">
		alert("Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.");
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
	product_tree_id_list = '';
	spec_main_id_list ='';
</cfscript>
<cfset treeCounter = 0>
<cfset counter = 0>
<cfset liste = "">
<cfset old_tree_id = "">
<cfset tree_error_flag = 0>
<cfloop from="2" to="#line_count#" index="i">
	<cfset j = 1>
    <cfset error_flag = 0>
    <cfset barcode_no_list="">
    <cfset tree_kontrol = 0>
    <cftry>
        <cfscript>
            counter = counter + 1;
            if(Right(dosya[i],1) is ';')
                dosya[i] = '#dosya[i]#0';
            //kırılım
            deep_level= Listgetat(dosya[i],j,";");
            deep_level = trim(deep_level);
            j=j+1;

            //operasyon kodu
            operation_code = Listgetat(dosya[i],j,";");
            operation_code = trim(operation_code);
            j=j+1;
            //stok kodu/özel kod
            stock_code= Listgetat(dosya[i],j,";");
            stock_code = trim(stock_code);
            j=j+1;	
            
            //spec_id
            spec_id= Listgetat(dosya[i],j,";");
            spec_id = trim(spec_id);
            j=j+1;
            
            //miktar
            quantity= Listgetat(dosya[i],j,";");
            quantity = trim(quantity);
            j=j+1;
            
            //fire miktarı
            fire_amount=Listgetat(dosya[i],j,";");
            fire_amount=trim(fire_amount);
            j=j+1;
            
            //fire oranı
            fire_rate=Listgetat(dosya[i],j,";");
            fire_rate=trim(fire_rate);
            j=j+1;
            
            //sıra no
            line_number= Listgetat(dosya[i],j,";");
            line_number = trim(line_number);
            j=j+1;
            
            //Alternatif sorusu
            question_id= Listgetat(dosya[i],j,";");
            question_id = trim(question_id);
            j=j+1;
            
            //Konfigure
            is_configure= Listgetat(dosya[i],j,";");
            is_configure = trim(is_configure);
            j=j+1;
            
            //SevkteBirleştir
            is_sevk= Listgetat(dosya[i],j,";");
            is_sevk = trim(is_sevk);
            j=j+1;
            
            //Fantom
            is_phantom= Listgetat(dosya[i],j,";");
            is_phantom = trim(is_phantom);
            j=j+1;
            
            //Açıklama
			detail= Listgetat(dosya[i],j,";");
			detail = trim(detail);
			j=j+1;
        </cfscript>
        <cfcatch type="Any">
            <cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu. <br/>
            <cfset error_flag = 1>
        </cfcatch>
    </cftry>
	<cfif error_flag eq 0 and len(deep_level)>
    	<cfset row_stock_id = 0>
        <cfset row_product_id = 0>
        <cfset row_product_name = ''>
		<cfset unit_id = '' >
		<cfset operation_type_id = 0>
        <cfset related_tree_id = ''>
        <cfif not len(spec_id)><cfset spec_id = 0></cfif>
        <cfif deep_level eq 0>
			<cfset tree_error_flag = 0>
        	<cfif i gt 2 and isdefined('stock_id_list') and len(stock_id_list)><!--- bir ürün bitmiş diğer ürüne geçiyorsa,geçmeden spec oluşsun.. --->
				<cfscript>
                    new_spec_cre=specer(
                            dsn_type: dsn3,
                            spec_type: 1,
                            spec_is_tree: 1,
                            only_main_spec: 0,
                            main_stock_id: main_stock_id,
                            main_product_id: main_product_id,
                            spec_name: spec_name,
                            spec_row_count: row_count,
                            stock_id_list: stock_id_list,
                            product_id_list: product_id_list,
                            product_name_list: product_name_list,
                            amount_list: amount_list,
                            is_sevk_list: sevk_list,	
                            is_configure_list: configure_list,
                            is_property_list: is_property_list,
                            property_id_list: property_id_list,
                            is_phantom_list : is_phantom_list,
                            variation_id_list: variation_id_list,
                            total_min_list: total_min_list,
                            total_max_list : total_max_list,
                            tolerance_list : tolerance_list,
                            related_spect_id_list : related_spect_main_id_list,
                            line_number_list : line_number_list,
                            upd_spec_main_row:1,
                            related_tree_id_list : related_tree_id_list,
                            operation_type_id_list:operation_type_id_list
                        );
						treeCounter = treeCounter+1;
						spec_main_id_list = ListAppend(spec_main_id_list,ListGetAt(new_spec_cre,1,','));
                </cfscript>
				<cfif len(spec_main_id_list) and len(main_stock_id)>
                    <cfquery name="upd_spec_main_row" datasource="#dsn3#">
                        UPDATE 
                            SPECT_MAIN_ROW 
                        SET 
                            FIRE_AMOUNT = <cfif len(fire_amount)>#fire_amount#<cfelse>NULL</cfif>,
                            FIRE_RATE = <cfif len(fire_rate)>#fire_rate#<cfelse>NULL</cfif>
                        WHERE 
                            SPECT_MAIN_ID = #ListGetAt(new_spec_cre,1,',')# AND STOCK_ID = #main_stock_id#
                    </cfquery>
                </cfif>
			</cfif>
            <cfquery name="GET_MAIN_STOCK_INFO" datasource="#dsn3#">
                SELECT PRODUCT_UNIT_ID,STOCK_ID,PRODUCT_ID,PRODUCT_NAME,PROPERTY FROM STOCKS WHERE PRODUCT_CODE_2 = '#stock_code#' OR STOCK_CODE = '#stock_code#'
            </cfquery>
            <!--- 0 ana ürün demek..Ana ürün için spec oluşacağı için öncelikle ana ürün için spec listelerini oluşturuyoruz... --->
            <cfscript>
				if (GET_MAIN_STOCK_INFO.recordcount){
					main_stock_id = GET_MAIN_STOCK_INFO.STOCK_ID;
					main_product_id =GET_MAIN_STOCK_INFO.PRODUCT_ID;
					spec_name='#GET_MAIN_STOCK_INFO.PRODUCT_NAME# #GET_MAIN_STOCK_INFO.PROPERTY#';
					row_count = 0;
					stock_id_list="";
					related_tree_id_list='';
					operation_type_id_list='';
					product_id_list="";
					product_name_list="";
					amount_list="";
					sevk_list="";
					configure_list="";
					is_property_list="";
					property_id_list = "";
					variation_id_list = "";
					total_min_list = "";
					total_max_list = "";
					tolerance_list = "";
					line_number_list ="";
					related_spect_main_id_list ="";
					question_id_list ="";
                    detail_list ="";
                    is_phantom_list = "";
				}
            </cfscript>
			<cfquery name="get_kontrol" datasource="#dsn3#">
				SELECT 
    	            PRODUCT_TREE_ID, 
                    RELATED_ID, 
                    PRODUCT_ID, 
                    IS_TREE, 
                    AMOUNT,
                    FIRE_AMOUNT,
                    FIRE_RATE,
                    UNIT_ID, 
                    STOCK_ID, 
                    IS_CONFIGURE, 
                    IS_SEVK, 
                    SPECT_MAIN_ID, 
                    LINE_NUMBER, 
                    OPERATION_TYPE_ID, 
                    IS_PHANTOM, 
                    QUESTION_ID, 
                    RELATED_PRODUCT_TREE_ID, 
                    PROCESS_STAGE,
                    MAIN_STOCK_ID, 
                    UPDATE_EMP, 
                    UPDATE_IP, 
                    UPDATE_DATE, 
                    RECORD_EMP, 
                    RECORD_DATE, 
                    DETAIL 
                FROM 
	                PRODUCT_TREE 
                WHERE 
                	STOCK_ID = #main_stock_id#
			</cfquery>
			<cfif get_kontrol.recordcount>
				<cfset tree_error_flag = 1>
				<cfset tree_kontrol = 1>
			</cfif>
			<cfif tree_kontrol eq 1>
				<cfoutput>#i#.Satırdaki #stock_code# Kodlu </cfoutput>Ürünün Ağacı Olduğu İçin İmport Yapılamaz !<br/>
			</cfif>		
            <!--- <cfquery name="DELETE_PRODUCT_TREE" datasource="#DSN3#">
            	DELETE PRODUCT_TREE  WHERE STOCK_ID = #main_stock_id#
            </cfquery> --->
        <cfelse>   
			<cfif len(stock_code)><!--- stock_id bilgisini almak için --->
                <cfquery name="GET_STOCK_INFO" datasource="#dsn3#">
                    SELECT PROPERTY,PRODUCT_NAME,PRODUCT_UNIT_ID,STOCK_ID,PRODUCT_ID FROM STOCKS WHERE PRODUCT_CODE_2 = '#stock_code#' OR STOCK_CODE = '#stock_code#'
                </cfquery>
                <cfif GET_STOCK_INFO.recordcount>
                    <cfset row_stock_id = GET_STOCK_INFO.STOCK_ID>
					<cfset row_product_id = GET_STOCK_INFO.PRODUCT_ID>
                    <cfset unit_id = GET_STOCK_INFO.PRODUCT_UNIT_ID>
                    <cfset row_product_name ='#GET_STOCK_INFO.PRODUCT_NAME#-#GET_STOCK_INFO.PROPERTY#'>
                </cfif>
            <cfelseif len(operation_code)><!--- operaion_id bilgisini almak için --->
                <cfquery name="GET_OP_INFO" datasource="#dsn3#">
                    SELECT OPERATION_TYPE_ID,OPERATION_TYPE FROM OPERATION_TYPES WHERE OPERATION_CODE = '#operation_code#'
                </cfquery>
                <cfif GET_OP_INFO.recordcount>
                    <cfset operation_type_id = GET_OP_INFO.OPERATION_TYPE_ID>
                    <cfset row_product_name =GET_OP_INFO.OPERATION_TYPE>
                </cfif>
            </cfif>
			<cfif error_flag neq 1 and deep_level gt 0 and tree_error_flag neq 1>	
            	<cfif operation_type_id eq 0 and row_stock_id eq 0><!--- eğer operasyonda stokda 0 ise bir sorun var demektir burda product_tree'ye kayıt atmıyoruz ve kullanıyaca bilgi veriyoruz... --->
                	<cfoutput>
						<cfif isdefined('GET_MAIN_STOCK_INFO') and GET_MAIN_STOCK_INFO.recordcount>
                            #GET_MAIN_STOCK_INFO.PRODUCT_NAME# isimli Ürün Ağacının İçinde Bulunan :   
                        </cfif>
                        <cfif len(stock_code)>
                            #stock_code# Stok Kodlu Ürün Bulunamadı.
                        <cfelseif len(operation_code)>    
                            #operation_code# Kodlu Operasyon Bulunamadı.
                        </cfif> Aktarımda Sorunlar Oluşmasını Engellemek İçin Lütfen Düzgün Veriler Giriniz!
                        <br/>
                    </cfoutput>
				<cfelse>
                    <cfquery name="ADD_TREE" datasource="#dsn3#">
                        INSERT INTO
                        PRODUCT_TREE
                        (
                            STOCK_ID,
                            RELATED_ID,
                            AMOUNT,
                            FIRE_AMOUNT,
                            FIRE_RATE,
                            UNIT_ID,
                            SPECT_MAIN_ID,
                            IS_CONFIGURE,
                            IS_SEVK,
                            LINE_NUMBER,
                            OPERATION_TYPE_ID,
                            IS_PHANTOM,
                            RELATED_PRODUCT_TREE_ID,
                            QUESTION_ID,
							PROCESS_STAGE,
							DETAIL
                        )
                        VALUES
                        (
                            <cfif deep_level eq 1>#main_stock_id#<cfelse>NULL</cfif>,
                            <cfif row_stock_id GT 0>#row_stock_id#<cfelse>NULL</cfif>,
                            #quantity#,
                            <cfif len(fire_amount)>#fire_amount#<cfelse>NULL</cfif>,
                            <cfif len(fire_rate)>#fire_rate#<cfelse>NULL</cfif>,
                            <cfif len(unit_id)>#unit_id#<cfelse>NULL</cfif>,
                            <cfif len(spec_id)>#spec_id#<cfelse>NULL</cfif>,
                            <cfif len(is_configure) and is_configure eq 1>1<cfelse>0</cfif>,
                            <cfif len(is_sevk) and is_sevk eq 1>1<cfelse>0</cfif>,
                            <cfif len(line_number)>#line_number#<cfelse>NULL</cfif>,
                            <cfif operation_type_id GT 0>#operation_type_id#<cfelse>NULL</cfif>,
                            <cfif len(is_phantom) and is_phantom eq 1>1<cfelse>0</cfif>,
                            <cfif deep_level gt 1>#Evaluate('related_tree_id_#deep_level-1#')#<cfelse>NULL</cfif>,
                            <cfif len(question_id)>#question_id#<cfelse>NULL</cfif>,
							#process_stage#,
							<cfif len(detail) and detail neq 0>'#detail#'<cfelse>NULL</cfif>
                        )
                    </cfquery>
                    <cfquery name="GET_MAX_TREE" datasource="#dsn3#">
                        SELECT MAX(PRODUCT_TREE_ID) PRODUCT_TREE_ID FROM PRODUCT_TREE
                    </cfquery>
                    <cfset product_tree_id_list = ListAppend(product_tree_id_list,GET_MAX_TREE.PRODUCT_TREE_ID,',')>
                    <cfset 'related_tree_id_#deep_level#' = GET_MAX_TREE.PRODUCT_TREE_ID>
                    <cfscript>
                        row_count = row_count+1;
                        stock_id_list = listappend(stock_id_list,row_stock_id,',');
                        product_id_list = listappend(product_id_list,row_product_id,',');
                        amount_list = listappend(amount_list,quantity,',');
                        product_name_list = listappend(product_name_list,row_product_name,'@');
                        if(row_stock_id gt 0){
                        if((len(is_sevk) and is_sevk eq 1))
                            sevk_list = listappend(sevk_list,1,',');
                        else
                            sevk_list = listappend(sevk_list,0,',');
                        }
                        else
                        sevk_list = listappend(sevk_list,0,',');

                        if(row_stock_id gt 0){
                            if(len(is_phantom) and is_phantom eq 1)
                                is_phantom_list = listappend(is_phantom_list,1,',');
                            else  
                                is_phantom_list = listappend(is_phantom_list,0,',');    
                        }
                        else 
                            is_phantom_list = listappend(is_phantom_list,0,',');          
                        
                        if(row_stock_id gt 0){
                        if((len(is_configure) and is_configure eq 1))
                            configure_list = listappend(configure_list,1,',');
                        else
                            configure_list = listappend(configure_list,0,',');
                        }
                        else
                        configure_list = listappend(configure_list,1,',');
                        related_spect_main_id_list  = ListAppend(related_spect_main_id_list,spec_id,',');
                        if(deep_level eq 1){
                        if(row_stock_id gt 0)
                            is_property_list=listappend(is_property_list,0,',');//sarf
                        else
                            is_property_list=listappend(is_property_list,3,',');//operasyon..
                            
                        }
                        else{
                        is_property_list=listappend(is_property_list,4,',');//operasyon altından gelen ürünler anlamına geliyor...
                        }
                        property_id_list = listappend(property_id_list,0,',');
                        
                        variation_id_list = listappend(variation_id_list,0,',');
                        total_min_list = listappend(total_min_list,'-',',');
                        total_max_list = listappend(total_max_list,'-',',');
                        tolerance_list = listappend(tolerance_list,'-',',');
                        related_tree_id_list = listappend(related_tree_id_list,GET_MAX_TREE.PRODUCT_TREE_ID,',');
                        operation_type_id_list = listappend(operation_type_id_list,operation_type_id,',');
                        if(len(line_number))
                        line_number_list = listappend(line_number_list,line_number,',');
                        else
                        line_number_list = listappend(line_number_list,0,',');
						if(len(detail))
                        detail_list = listappend(detail_list,detail,',');
                        else
                        detail_list = listappend(detail_list,'-',',');
                    </cfscript>
                    <cfif line_count eq i and ListLen(stock_id_list,',')><!--- sadece 1 belge içeri alınmışsa yada son ürün olduğu durumda spec oluşsun diye... --->
						<cfscript>
                            new_spec_cre=specer(
                                    dsn_type: dsn3,
                                    spec_type: 1,
                                    spec_is_tree: 1,
                                    only_main_spec: 0,
                                    main_stock_id: main_stock_id,
                                    main_product_id: main_product_id,
                                    spec_name: spec_name,
                                    spec_row_count: row_count,
                                    stock_id_list: stock_id_list,
                                    product_id_list: product_id_list,
                                    product_name_list: product_name_list,
                                    amount_list: amount_list,
                                    is_sevk_list: sevk_list,	
                                    is_phantom_list: is_phantom_list,
                                    is_configure_list: configure_list,
                                    is_property_list: is_property_list,
                                    property_id_list: property_id_list,
                                    variation_id_list: variation_id_list,
                                    total_min_list: total_min_list,
                                    total_max_list : total_max_list,
                                    tolerance_list : tolerance_list,
                                    related_spect_id_list : related_spect_main_id_list,
                                    line_number_list : line_number_list,
                                    upd_spec_main_row:1,
                                    related_tree_id_list : related_tree_id_list,
                                    operation_type_id_list:operation_type_id_list,
									is_product_tree_import:1,
									detail_list : detail_list
                                );
                                treeCounter = treeCounter+1;
                                spec_main_id_list = ListAppend(spec_main_id_list,ListGetAt(new_spec_cre,1,','));
                        </cfscript>
						<cfif len(ListGetAt(new_spec_cre,1,',')) and len(main_stock_id)>
                            <cfquery name="upd_spec_main_row" datasource="#dsn3#">
                                UPDATE 
                                    SPECT_MAIN_ROW 
                                SET 
                                    FIRE_AMOUNT = <cfif len(fire_amount)>#fire_amount#<cfelse>NULL</cfif>,
                                    FIRE_RATE = <cfif len(fire_rate)>#fire_rate#<cfelse>NULL</cfif>
                                WHERE 
                                    SPECT_MAIN_ID = #ListGetAt(new_spec_cre,1,',')# AND STOCK_ID = #main_stock_id#
                            </cfquery>
                        </cfif>
                    </cfif>
                </cfif>
			 <cfelse>
				<cfif tree_kontrol eq 1>
					<cfoutput>#i#.Satırdaki #stock_code# Kodlu </cfoutput>Ürünün Ağacı Olduğu İçin İmport Yapılamaz !<br/>
				</cfif>		
             </cfif>
		</cfif>
	<cfelse>
		<cfoutput>#i#</cfoutput>.Satırda Ürün Yok<br/>
	</cfif>
</cfloop>
<cfoutput>Toplam #treeCounter# Adet Ürün Ağacı İmport Edildi!!!</cfoutput>
<cfif len(product_tree_id_list)>
    <cfquery name="upd_product_tree" datasource="#dsn3#">
        UPDATE 
        	PRODUCT_TREE 
		SET 
        	SPECT_MAIN_ID = (SELECT TOP 1 SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID =PRODUCT_TREE.RELATED_ID AND SM.IS_TREE = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC) 
		WHERE 
        	PRODUCT_TREE_ID IN (#product_tree_id_list#)
    </cfquery>
</cfif>
<cfif len(spec_main_id_list)>
    <cfquery name="get_spec_main" datasource="#dsn3#">
    	UPDATE 
        	SPECT_MAIN_ROW
		SET
        	RELATED_MAIN_SPECT_ID = (SELECT TOP 1 SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID =SPECT_MAIN_ROW.STOCK_ID AND SM.IS_TREE = 1  ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC) 
		WHERE
        	SPECT_MAIN_ID IN (#spec_main_id_list#)
    </cfquery>
</cfif>
<!--- <cfloop from="1" to="20" index="kk">
    <cfquery name="del_tree" datasource="#dsn3#">
		DELETE FROM PRODUCT_TREE WHERE RELATED_PRODUCT_TREE_ID IS NOT NULL
		AND RELATED_PRODUCT_TREE_ID NOT IN(SELECT PRODUCT_TREE_ID FROM PRODUCT_TREE)
	</cfquery>
</cfloop>
<cfquery name="del_spec" datasource="#dsn3#">
	DELETE FROM SPECT_MAIN_ROW WHERE RELATED_TREE_ID IS NOT NULL
	AND RELATED_TREE_ID NOT IN(SELECT PRODUCT_TREE_ID FROM PRODUCT_TREE)
</cfquery> --->
<cfabort>
<script>
	location.href = document.referrer;
</script>
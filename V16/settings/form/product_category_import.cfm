<!--- Ürün Kategori Import --->
<cf_get_lang_set module_name="settings">
    <cfif not isdefined('attributes.uploaded_file')>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <cf_box title="#getLang('','Ürün Kategori Aktarım','43564')#">
                <cfform name="formimport" action="#request.self#?fuseaction=settings.product_category_import" enctype="multipart/form-data" method="post">
                    <input type="hidden" name="is_form_submitted" value="1" />
                    <cf_box_elements>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-project_name">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="file_format" id="file_format">
                                        <option value="utf-8"><cf_get_lang dictionary_id='32802.UTF-8'></option>
                                    </select>      
                                </div>
                            </div>
                            <div class="form-group" id="item-uploaded_file">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'> *</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <input type="file" name="uploaded_file" id="uploaded_file">  
                                </div>
                            </div>   
                            <div class="form-group" id="item-example_file">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <a  href="/IEF/standarts/import_example_file/urun_Kategori_Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                                </div>
                            </div>                                       
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-format">
                                <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                            </div> 
                            <div class="form-group" id="item-exp1">
                                <cf_get_lang dictionary_id='44342.Dosya uzantısı csv olmalı,alan araları noktalı virgül (;) ile ayrılmalı ve kaydedilirken karakter desteği olarak UTF-8 seçilmelidir'>
                            </div> 
                            <div class="form-group" id="item-exp2">
                                <cf_get_lang dictionary_id='54238.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır.'>
                            </div>
                            <div class="form-group" id="item-exp3">
                                <cf_get_lang dictionary_id='44951.Bu belgede olması gereken alan sayısı'> : 13
                            </div>
                            <div class="form-group" id="item-exp4">
                                <cf_get_lang dictionary_id='44197.Alanlar sırasıyla'>;
                            </div>
                            <div class="form-group" id="item-exp5">
                                1-<cf_get_lang dictionary_id='32775.Kategori Kodu'>* : <cf_get_lang dictionary_id='63331.Kategorinin kodu yazılmalı ve varsa öncesinde aralarına nokta konulmuş halde tüm üst kategorisinin kodu ile beraber yazılması gerekmektedir. Önce üst kategoriler daha sonra alt kategoriler yazılmalıdır'>.</br>
                                2-<cf_get_lang dictionary_id='37163.Kategori Adı'>* : <cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'></br>
                                3-<cf_get_lang dictionary_id='63315.Minimum Marj'> : <cf_get_lang dictionary_id='63334.Minimum marj girilecek'></br>
                                4-<cf_get_lang dictionary_id='63316.Maximum Marj'> : <cf_get_lang dictionary_id='63333.Maximum marj girilecek.'></br>
                                5-<cf_get_lang dictionary_id='36199.Açıklama'> : <cf_get_lang dictionary_id='63335.Kategorinin Açıklaması'></br>
                                6-<cf_get_lang dictionary_id='37545.Listeleme Sırası'> : <cf_get_lang dictionary_id='63336.Listeleme sırası girilecek.'></br>
                                7-<cf_get_lang dictionary_id='37161.Webde Göster'> : <cf_get_lang dictionary_id='63337.Webde göster seçeneği için 1, gösterilmemesi için 0 girilmesi gerekiyor.'></br>
                                8-<cf_get_lang dictionary_id='37342.Konfigure Edilebilir'> : <cf_get_lang dictionary_id='63338.Konfigure edilebilir seçeneği için 1, aksi durum için 0 girilmesi gerekiyor.'></br>
                                9-<cf_get_lang dictionary_id='58017.İlişkili Şirketler'> * : <cf_get_lang dictionary_id='63339.İlişkilendirilecek şirketlerin IDlerinin virgül ile ayrılarak girilmesi gerekmektedir.'></br>
                                10-<cf_get_lang dictionary_id='30182.İlişkili Markalar'> : <cf_get_lang dictionary_id='63340.İlişkilendirilecek markaların IDlerinin virgül ile ayrılarak girilmesi gerekmektedir.'></br>
                                11-<cf_get_lang dictionary_id='57544.Sorumlu'> <cf_get_lang dictionary_id='31253.Sıra No'> : <cf_get_lang dictionary_id='63341.Sorumlu olacak kişilerin sıra numaraları virgül ile ayrılarak girilecek.'></br>
                                12-<cf_get_lang dictionary_id='57544.Sorumlu'> : <cf_get_lang dictionary_id='63342.Sorumlu olacak kişilerin pozisyon IDleri virgül ile ayrılarak girilecek.'></br>
                                13-<cf_get_lang dictionary_id='61459.Stok Kodu Sayacı'></br>
                            </div>
                            <div class="form-group" id="item-exp6">
                                <cf_get_lang dictionary_id='63343.NOT : (*) Yıldızlı Olanlar Zorunlu Alanlardır.'>
                            </div>
                        </div>
                    </cf_box_elements>
                    <cf_box_footer>
                        <cf_workcube_buttons is_upd='0'> 
                    </cf_box_footer>
                </cfform>
            </cf_box>
        </div>
    <cfelse>
        <cfif isdefined("attributes.is_form_submitted") and attributes.is_form_submitted eq 1>
        <cfset upload_folder_ = "#upload_folder#">
        <cftry> 
            <cffile action = "upload" fileField = "uploaded_file" destination = "#upload_folder_#" nameConflict = "MakeUnique" mode="777" charset="#attributes.file_format#">
            <cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
            <cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="#attributes.file_format#">	
            <cfset file_size = cffile.filesize>
            <cfcatch type="Any">
                <script type="text/javascript">
                    alert("<cf_get_lang dictionary_id='63329.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz'>!");
                    history.back();
                </script>
                <cfabort>
            </cfcatch>  
        </cftry>
        
        <cftry> 
        <cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="#attributes.file_format#">
        <cffile action="delete" file="#upload_folder_##file_name#">
        <cfcatch> 
            <script type="text/javascript">
                alert("<cf_get_lang dictionary_id='29450.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir'>.");
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
        <cfset records = 0>
        <cfset counter = 0>
        <cfset liste = "">
            <cfloop from="2" to="#line_count#" index="i">
                <cfset j = 1>
                <cfset error_flag = 0>
                <cftry>  
                    <cfscript>				
                        
                        cat_code = Listgetat(dosya[i],j,";");
                        cat_code = trim(cat_code);
                        j=j+1;
                        
                        cat_name = Listgetat(dosya[i],j,";");
                        cat_name = trim(cat_name);
                        j=j+1;
                        
                        min_margin = Listgetat(dosya[i],j,";");
                        min_margin = trim(min_margin);
                        j=j+1;
                        
                        max_margin = Listgetat(dosya[i],j,";");
                        max_margin = trim(max_margin);
                        j=j+1;
                        
                        detail = Listgetat(dosya[i],j,";");
                        detail = trim(detail);
                        j=j+1;
                        
                        list_order_no = Listgetat(dosya[i],j,";");
                        list_order_no = trim(list_order_no);
                        j=j+1;
                        
                        is_public = Listgetat(dosya[i],j,";");
                        is_public = trim(is_public);
                        j=j+1;
                        
                        is_customizable = Listgetat(dosya[i],j,";");
                        is_customizable = trim(is_customizable);
                        j=j+1;
                        
                        company_ids = Listgetat(dosya[i],j,";");
                        company_ids = trim(company_ids);
                        j=j+1;
                        
                        brand_ids = Listgetat(dosya[i],j,";");
                        brand_ids = trim(brand_ids);
                        j=j+1;				
                        
                        responsible_sequence_numbers = Listgetat(dosya[i],j,";");
                        responsible_sequence_numbers = trim(responsible_sequence_numbers);
                        j=j+1;				
                        
                        if(listlen(dosya[i],';') gte j)
                        {
                            responsible_ids = Listgetat(dosya[i],j,";");
                            responsible_ids = trim(responsible_ids);
                        }				
                        else
                        {
                            responsible_ids = '';
                        }
                        j=j+1;
                        
                        if(listlen(dosya[i],';') gte j)
                        {
                            stock_code_counter  = Listgetat(dosya[i],j,";");
                            stock_code_counter  = trim(stock_code_counter);
                        }				
                        else
                        {
                            stock_code_counter = 0;
                        }	
                        
                    </cfscript>
                    
                    <cfcatch type="Any">
                        <cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='63328.satır 1. adımda sorun oluştu'> <br/>
                        <cfset error_flag = 1>
                    </cfcatch>
                    
                </cftry> 
                
                <cfif not len(cat_code) or not len(cat_name)  or not len(company_ids)>
                    <cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='63255.Satırda zorunlu alan boş'>. <br/>        
                    <cfset error_flag = 1>
                </cfif>
                
                <cfif error_flag eq 0>
                    <cfquery name="CHECK" datasource="#DSN1#">
                        SELECT
                            HIERARCHY
                        FROM
                            PRODUCT_CAT
                        WHERE
                            HIERARCHY = '#cat_code#'
                    </cfquery>
                    
                    <cfif check.recordcount>
                        <script type="text/javascript">
                            alert("<cf_get_lang dictionary_id='44854.Bu Kod Kullanılmakta; Başka Kod Kullanınız'>!");
                            history.back();
                        </script>
                        <cfabort>
                    </cfif>
                
                        
                    <cfquery name="ADD_PRODUCT_CAT" datasource="#DSN1#" result="MAX_ID">
                        INSERT INTO 
                            PRODUCT_CAT
                        (
                            HIERARCHY,
                            PRODUCT_CAT,
                            PROFIT_MARGIN,
                            PROFIT_MARGIN_MAX,
                            DETAIL,
                            LIST_ORDER_NO,
                            IS_PUBLIC,
                            IS_CUSTOMIZABLE,                   
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_EMP_IP,
                            STOCK_CODE_COUNTER
                        )
                        VALUES
                        (
                            <cfif len(cat_code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cat_code#"><cfelse>NULL</cfif>,
                            <cfif len(cat_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cat_name#"><cfelse>NULL</cfif>,
                            <cfif len(min_margin)><cfqueryparam cfsqltype="cf_sql_float" value="#min_margin#"><cfelse>NULL</cfif>,
                            <cfif len(max_margin)><cfqueryparam cfsqltype="cf_sql_float" value="#max_margin#"><cfelse>NULL</cfif>,
                            <cfif len(detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#detail#"><cfelse>NULL</cfif>,
                            <cfif len(list_order_no)><cfqueryparam cfsqltype="cf_sql_integer" value="#list_order_no#"><cfelse>NULL</cfif>,
                            <cfif len(is_public)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_public#"><cfelse>NULL</cfif>,
                            <cfif len(is_customizable)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_customizable#"><cfelse>NULL</cfif>,                
                            #now()#,
                            #session.ep.userid#,
                            '#CGI.REMOTE_ADDR#',
                            <cfif len(stock_code_counter)><cfqueryparam cfsqltype="cf_sql_integer" value="#stock_code_counter#"><cfelse>0</cfif>
                        )
                    </cfquery>
            
                    <cfloop from="1" to="#listlen(responsible_ids,",")#" index="i">
                        <cfif len(listgetat(responsible_ids, i, ",")) and len(listgetat(responsible_sequence_numbers, i, ","))>
                            <cfquery name="get_pos_code" datasource="#dsn#">
                                SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE POSITION_ID =  #listgetat(responsible_ids, i, ",")#
                            </cfquery>
                            <cfquery name="AddResponsible" datasource="#dsn1#">
                                INSERT INTO PRODUCT_CAT_POSITIONS 
                                (
                                    PRODUCT_CAT_ID,
                                    POSITION_CODE,
                                    SEQUENCE_NO
                                )
                                VALUES
                                (
                                    #MAX_ID.IDENTITYCOL#,
                                    #get_pos_code.POSITION_CODE#,
                                    #listgetat(responsible_sequence_numbers, i, ",")#
                                )
                            </cfquery>
                        </cfif>
                    </cfloop>
                    
        <!---                 <!--- üst kategorinin alt kategorisi var --->
                    <cfquery name="ADD_SUB_PRODUCT_CAT" datasource="#DSN1#">
                        UPDATE 
                            PRODUCT_CAT
                        SET
                            IS_SUB_PRODUCT_CAT = 1
                        WHERE
                            HIERARCHY = '#cat_code#'
                    </cfquery> --->
                    <cfquery name="HAS_SUB_CAT" datasource="#DSN1#">
                        SELECT
                            HIERARCHY
                        FROM
                            PRODUCT_CAT
                        WHERE
                            HIERARCHY LIKE '#cat_code#.%'
                    </cfquery>
                    <cfif HAS_SUB_CAT.recordCount>
                    <!--- eklenen kategorinin alt kategorisi var --->	
                        <cfquery name="ADD_IS_SUB_PRODUCT_CAT" datasource="#DSN1#">
                            UPDATE 
                                PRODUCT_CAT
                            SET
                                IS_SUB_PRODUCT_CAT = 1
                            WHERE
                                HIERARCHY = '#cat_code#'
                        </cfquery>
                    <cfelse>
                    <!--- eklenen kategorinin alt kategorisi yok --->	
                        <cfquery name="ADD_IS_SUB_PRODUCT_CAT" datasource="#DSN1#">
                            UPDATE 
                                PRODUCT_CAT
                            SET
                                IS_SUB_PRODUCT_CAT = 0
                            WHERE
                                HIERARCHY = '#cat_code#'
                        </cfquery>
                    </cfif>            
                    
                    <cfloop from="1" to="#listlen(company_ids)#" index="i">
                        <cfif len(listgetat(company_ids, i, ","))>
                            <cftry>
                                <cfquery name="ADD_PRODUCT_CAT_COMPANIES" datasource="#DSN1#">
                                    INSERT INTO
                                        PRODUCT_CAT_OUR_COMPANY
                                    (
                                        PRODUCT_CATID,
                                        OUR_COMPANY_ID
                                    )				
                                    VALUES
                                    (
                                        #MAX_ID.IDENTITYCOL#,
                                        #listgetat(company_ids, i)#
                                    )
                                </cfquery>
                                <cfcatch type="Any">
                                    <script type="text/javascript">
                                        alert("<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='63328.satır 1. adımda sorun oluştu'>!");
                                        history.back();
                                    </script>
                                </cfcatch>
                            </cftry>
                        </cfif>        
                    </cfloop>
                    
                    <cfloop from="1" to="#listlen(brand_ids)#" index="i">	
                        <cfif len(listgetat(brand_ids, i, ","))>	  
                            <cfquery name="ADD_PRODUCT_CAT_BRANDS" datasource="#DSN1#">
                                INSERT INTO
                                    PRODUCT_CAT_BRANDS
                                (
                                    PRODUCT_CAT_ID,
                                    BRAND_ID
                                )				
                                VALUES
                                (
                                    #MAX_ID.IDENTITYCOL#,
                                    #listgetat(brand_ids, i)#
                                )
                            </cfquery>
                        </cfif>
                    </cfloop>
            
                    <cfset records = records + 1>
                <cfelse>
                    <cfoutput>#i#. <cf_get_lang dictionary_id='63257.Satırda hata oluştu'></cfoutput>
                </cfif>
            </cfloop>
        </cfif>
        <cfif isdefined("records")>
            <cfoutput><font style="font-weight:bold"><cfoutput>#records# <cf_get_lang dictionary_id='63256.Kayıt import edildi'></cfoutput></font></cfoutput>  
            <script type="text/javascript">
                window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=settings.product_category_import';
            </script>
        </cfif>
    </cfif>
    
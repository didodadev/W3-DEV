<cfif not isdefined("attributes.file_format")>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','Raf Aktarım','63300')#">
            <cfform name="formexport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=settings.import_shelves">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-file_format">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="file_format" id="file_format">
                                    <option value="utf-8"><cf_get_lang dictionary_id='32802.UTF-8'></option>
                                    <option value="iso-8859-9"><cf_get_lang dictionary_id='32979.ISO-8859-9 (Türkçe)'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-file_format">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="file" name="uploaded_file" id="uploaded_file">   
                            </div>
                        </div>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-format">
                            <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                        </div>      
                        <div class="form-group" id="item-exp1">
                            <label><b><cf_get_lang dictionary_id='44147.Dosya İçeriği'></b></label>
                        </div>       
                        <div class="form-group" id="item-exp2">
                            *<cf_get_lang dictionary_id='44153.Dosya Virgüller İle Ayrılmış .txt formatında olmalıdır'>
                        </div>      
                        <div class="form-group" id="item-exp3">
                            *<cf_get_lang dictionary_id='44154.Dosya içersindeki elemanlar virgül sayısına göre alınacağı için boş geçilecek eleman içinde  şeklinde diziliş tamamlanmalıdır!'>
                        </div>      
                        <div class="form-group" id="item-exp4">
                            <label><b><cf_get_lang dictionary_id='44148.Eleman Sırası'></b></label>
                        </div>     
                        <div class="form-group" id="item-exp5">
                            1-<cf_get_lang dictionary_id='34081.Raf No'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)</br>
                            2-<cf_get_lang dictionary_id='58763.Depo'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)</br>
                            3-<cf_get_lang dictionary_id='30031.Lokasyon'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)</br>
                            4-<cf_get_lang dictionary_id='33142.Raf Tipi'> <cf_get_lang dictionary_id='58527.ID'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)</br>
                            5-<cf_get_lang dictionary_id='57713.Boyut'> (a*b*h)</br>
                            6-<cf_get_lang dictionary_id='57655.Başlama Tarihi'> - <cf_get_lang dictionary_id='63301.gg.aa.yyyy'></br>
                            7-<cf_get_lang dictionary_id='57700.Bitiş Tarihi'> - <cf_get_lang dictionary_id='63301.gg.aa.yyyy'>    
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
                alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
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
            alert("<cf_get_lang dictionary_id='29450.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir'>");
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
        counter = 0;
        liste = "";
    </cfscript>
    <cfloop from="2" to="#line_count#" index="i">
        <cfset error_flag = 0>
        <cftry>
            <cfscript>
                counter = counter + 1;
                satir=dosya[i];
                shelf_code = trim(listgetat(satir,1,";"));
                department = trim(listgetat(satir,2,";"));
                location = trim(listgetat(satir,3,";"));
                shelf_type = trim(listgetat(satir,4,";"));
                dimention = trim(listgetat(satir,5,";"));
                if(len(dimention))
                    width = listfirst(dimention,'*');
                if(len(dimention) and listlen(dimention,'*') gt 1)
                    depth = listgetat(dimention,2,'*');
                if(len(dimention) and listlen(dimention,'*') gt 2)	
                    height = listgetat(dimention,3,'*');
                start_date=trim(listgetat(satir,6,";"));
                if(listlen(satir,';') gt 6)
                    finish_date=trim(listgetat(satir,7,";"));
            </cfscript>
            <cfcatch type="Any">
                <cfoutput>#i#. <cf_get_lang dictionary_id='63251.Satırda okuma sırasında hata oluştu'></cfoutput><br />
                <cfset error_flag = 1>
            </cfcatch>
        </cftry>
        <cftry>
            <cfif isdefined("start_date") and len(start_date)>
                <cfset start_date = replace(start_date,'.','/','all')>
                <cf_date tarih="start_date">
            </cfif>
            <cfif isdefined("finish_date") and len(finish_date)>
                <cfset finish_date = replace(finish_date,'.','/','all')>
                <cf_date tarih="finish_date">
            </cfif>
            <cfif len(shelf_code) and len(department) and len(location) and len(shelf_type)>
                <cflock name="#CreateUUID()#" timeout="90">
                    <cftransaction>
                        <cfquery name="ADD_PRODUCT_PLACE" datasource="#DSN3#">
                            INSERT INTO
                                PRODUCT_PLACE
                            (
                                STORE_ID,
                                LOCATION_ID,
                                SHELF_TYPE,
                                SHELF_CODE,  
                                START_DATE,    
                                FINISH_DATE,  
                                HEIGHT,
                                WIDTH,
                                DEPTH,
                                PLACE_STATUS,
                                RECORD_EMP,  
                                RECORD_EMP_IP,                              
                                RECORD_DATE		
                            )
                            VALUES
                            (
                                #department#,
                                #location#,
                                #shelf_type#,
                                '#shelf_code#',
                                <cfif isdefined("start_date") and len(start_date)>#start_date#<cfelse>NULL</cfif>,
                                <cfif isdefined("finish_date") and len(finish_date)>#finish_date#<cfelse>NULL</cfif>,
                                <cfif isdefined("height") and len(height)>#height#<cfelse>NULL</cfif>,
                                <cfif isdefined("width") and len(width)>#width#<cfelse>NULL</cfif>,
                                <cfif isdefined("depth") and len(depth)>#depth#<cfelse>NULL</cfif>,				
                                1,
                                #session.ep.userid#,
                                '#cgi.remote_addr#',		
                                #now()#
                            )	
                        </cfquery>
                    </cftransaction>
                </cflock>
            <cfelse>
                <cfoutput>#i#. <cf_get_lang dictionary_id='63352.Satırda zorunlu alanlar eksik.'></cfoutput>
                <cfset error_flag = 1>
            </cfif>
            <cfcatch type="Any">
                <cfoutput>#i#. <cf_get_lang dictionary_id='63351.Satırda yazma sırasında hata oluştu.'></cfoutput>
                <cfset error_flag = 1>
            </cfcatch>
        </cftry>
        <cfif error_flag eq 0>
            <cf_get_lang dictionary_id='44493.Aktarım Tamamlandı'>
        </cfif>
    </cfloop>
    <script type="text/javascript">
        window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=settings.import_shelves';
    </script>
</cfif>
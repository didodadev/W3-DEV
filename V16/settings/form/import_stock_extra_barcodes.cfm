<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Ek Barkod Aktarım','44548')#" closable="0">
        <cfform name="formexport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=settings.emptypopup_import_stock_extra_barcodes">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" item="file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>            
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">            
                            <select name="file_format" id="file_format">            
                                <option value="utf-8"><cf_get_lang dictionary_id='55929.UTF-8'></option>            
                                <option value="iso-8859-9"><cf_get_lang dictionary_id='53845.ISO-8859-9 (Türkçe)'></option>            
                            </select>            
                        </div>    
                    </div>                    
                    <div class="form-group" item="item-upload_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>            
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">            
                            <input type="file" name="uploaded_file" id="uploaded_file">              
                        </div>           
                    </div>                    
                    <div class="form-group" item="file_type">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31402.Kayıt Tipi'></label>            
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">            
                            <select name="file_type" id="file_type">            
                                <option value="1"><cf_get_lang dictionary_id='57789.Özel Kod'></option>          
                                <option value="2"><cf_get_lang dictionary_id='57518.Stok Kodu'></option>   
                            </select>            
                        </div>    
                    </div>
                    <div class="form-group" item="record_field">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63226.Kayıt Alanı'></label>            
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">            
                            <select name="record_field" id="record_field">            
                                <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>          
                                <option value="1"><cf_get_lang dictionary_id='57633.Barkod'></option>          
                                <option value="2"><cf_get_lang dictionary_id='37428.Diğer Barkod'></option>   
                            </select>            
                        </div>    
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>                
                    </div>
                    <div class="form-group" id="item-exp1">
                        <cf_get_lang dictionary_id='44683.Belgede toplam 3 alan olacaktır'>.<cf_get_lang dictionary_id='45042.Alanlar sırası ile'>                           
                    </div> 
                    <div class="form-group" id="item-exp2">
                        1-<cf_get_lang dictionary_id='57518.Stok Kodu'>/<cf_get_lang dictionary_id='57633.Barkod'>(<cf_get_lang dictionary_id='44241.alanlarından biri'>)
                        </br>    
                        2-<cf_get_lang dictionary_id='37186.Ek Birim'>
                        </br>
                        3-<cf_get_lang dictionary_id='57633.Barkod'>,<cf_get_lang dictionary_id='44746.olmalıdır'>.                       
                    </div> 
                    <br/>
                    <div class="form-group" id="item-exp3">
                        <cf_get_lang dictionary_id='44246.Dosya uzantısı csv veya txt olacak ve alan araları noktalı virgül (;) ile ayrılacaktır'>
                    </div>
                    <div class="form-group" id="item-exp4">
                        <cf_get_lang dictionary_id='36511.Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>
                    </div>
                    <div class="form-group" id="item-exp5">
                        <cf_get_lang dictionary_id='44247.Ayıraç noktalı virgul olduğundan notlar içinde olmaması gerekmektedir'>
                    </div>
                    <div class="form-group" id="item-exp6">
                        <cf_get_lang dictionary_id='44684.Ek Birim olarak ürün için önceden tanımlanmış olan birimlerden biri seçilmelidir.'>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
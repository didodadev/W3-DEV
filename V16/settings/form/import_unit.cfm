<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#getLang('','Birim Aktarım','43756')#" closable="0">
            <cfform name="formexport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=settings.emptypopup_import_unit">
            <input type="hidden" name="action_type" id="action_type" value="0"><!--- simdilik bu parametrenin 1 olma kosuluna gore yazılmadı oralrdada gerekiyorsa buda action_section a gore ayarlanmalı --->                       
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
                        <div class="form-group" item="example_file">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>            
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">            
                                <a  href="/IEF/standarts/import_example_file/Birim_7Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>              
                            </div>            
                        </div>
                        <div class="form-group" item="file_type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31402.Kayıt Tipi'></label>            
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">            
                                <select name="file_type" id="file_type">            
                                    <option value="0"><cf_get_lang dictionary_id='57633.Barkod'></option>            
                                    <option value="1"><cf_get_lang dictionary_id='57789.Özel Kod'></option>            
                                    <option value="2"><cf_get_lang dictionary_id='57518.Stok Kodu'></option>   
                                </select>            
                            </div>    
                        </div>                        
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-format">
                            <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>                
                        </div>
                        <div class="form-group" id="item-exp1">
                            <cf_get_lang dictionary_id='35596.Belgede toplam 7 alan olacaktır alanlar sırasi ile'>;                 
                        </div> 
                        <div class="form-group" id="item-exp2">
                            1-<cf_get_lang dictionary_id='57518.Stok Kodu'>; <cf_get_lang dictionary_id='57633.Barkod'>;<cf_get_lang dictionary_id='57789.Özel Kod'>;(<cf_get_lang dictionary_id='44241.alanlarından biri'>)<br/>
                            2-<cf_get_lang dictionary_id='37186.Ek Birim'><br/>
                            3-<cf_get_lang dictionary_id='58865.Çarpan'><br/>    
                            4-<cf_get_lang dictionary_id='42999.Boyut (a*b*h)'><br/>    
                            5-<cf_get_lang dictionary_id='29784.Ağırlık'><br/>
                            6-<cf_get_lang dictionary_id='30114.Hacim'><br/>
                            7-<cf_get_lang dictionary_id='30115.2.Birim'>;(<cf_get_lang dictionary_id='63219.2.Birim varsa 1, yoksa 0 olarak girilmeli'>)<br/>
                            *<cf_get_lang dictionary_id='63220.Alanlar Büyük - Küçük Harfe Duyarlıdır.'>
                        </div> 
                        <div class="form-group" id="item-exp3">
                            <cf_get_lang dictionary_id='44246.Dosya uzantısı csv veya txt olacak ve alan araları noktalı virgül (;) ile ayrılacaktır'><cf_get_lang dictionary_id='36511.Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>.<cf_get_lang dictionary_id='44247.Ayıraç noktalı virgul olduğundan notlar içinde olmaması gerekmektedir'>.                
                        </div> 
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons is_upd='0'>
                </cf_box_footer>
            </cfform>
        </cf_box>          
</div>
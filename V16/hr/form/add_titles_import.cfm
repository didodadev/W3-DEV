<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Ünvan Aktarım','64558')#" closable="0">
        <cfform name="formimport" action="#request.self#?fuseaction=hr.emptypopup_title_import" enctype="multipart/form-data" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" item="file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>            
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">            
                            <select name="file_format" id="file_format">            
                                <option value="utf-8"><cf_get_lang dictionary_id='55929.UTF-8'></option>            
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
                            <a  href="/IEF/standarts/import_example_file/Unvan_Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>              
                        </div>            
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>                
                    </div>
                    <div class="form-group" id="item-exp1">
                        <cf_get_lang dictionary_id='33719.NOT: Dosya uzantısı csv olacak ve alan araları noktalı virgül (;) ile ayrılacaktır. Format UTF-8 Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır.'>
                    </div> 
                    <div class="form-group" id="item-exp2">
                        <cf_get_lang dictionary_id='44951.Bu belgede olması gereken alan sayısı'>:3
                    </div> 
                    <div class="form-group" id="item-exp3">
                        <cf_get_lang dictionary_id='44197.Alanlar sırasıyla'>;
                    </div> 
                    
                    <div class="form-group" id="item-exp4">
                        1-<cf_get_lang dictionary_id='57571.Ünvan'>*<br/>
                        2-<cf_get_lang dictionary_id='57629.Açıklama'><br/>
                        3-<cf_get_lang dictionary_id='57761.Hiyerarşi'><br/>    
                    </div> 
                </div>
            </cf_box_elements>   
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>                 
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	if(formimport.uploaded_file.value.length==0)
	{
		alert("<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'>!");
		return false;
	}
		return true;
}
</script>

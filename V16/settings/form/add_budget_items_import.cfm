<!--- Butce Kalemleri Import hgul20110131 --->

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Bütçe Kalemi Aktarım','45167')#"> 
    <cfform name="formimport" action="#request.self#?fuseaction=settings.emptypopup_add_budget_items_import" enctype="multipart/form-data" method="post">
    <cf_box_elements>   
        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
            <div class="form-group" item="file_format">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                    <select name="file_format" id="file_format" style="width:200px;">
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
                    <a  href="/IEF/standarts/import_example_file/Butce_Kalemleri_Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>   
                </div>
            </div>
        </div>
        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
            <div class="form-group" id="item-format">
                <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>                
            </div>
            <div>
                <a valign="top"><cfset getImportExpFormat("butcekalemi")></a>
            </div>
        </cf_box_elements>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </div>
    
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
    
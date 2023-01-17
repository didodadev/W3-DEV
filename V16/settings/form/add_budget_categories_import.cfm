<!--- Bütçe Kategorileri Aktarım İmport --->
<cfif isdefined("attributes.imp") and attributes.imp eq 1>
    <cfset aa = 1 >
<cfelse>
    <cfset aa = 0>
</cfif>
<div class="col col-12 col-xs-12">
    <cf_box title="#getlang(61461,'Bütçe Kategorileri Aktarım',61461)#" draggable="#aa#" closable="#aa#">
        <cfform name="formimport" enctype="multipart/form-data" method="post">
            <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        
                        <div class="form-group" id="item-comp_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                            <div class="col col-8 col-xs-12"> 
                                <input type="file" name="uploaded_file" id="uploaded_file">
                            </div>
                        </div>
                        <div class="form-group" id="item-comp_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43671.Ornek Urun Dosyasi'></label>
                            <div class="col col-8 col-xs-12"> 
                                <a  href="/IEF/standarts/import_example_file/Butce_Kategorileri_Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                            </div>
                        </div>
                        
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="false">
                        <div class="form-group">
                            <label class="col col-12 bold"><cf_get_lang dictionary_id='58594.Format'></label>
                        </div>
                        <div class="form-group" id="item-format">
                            <div class="col col-12"> 
                                <p><cf_get_lang dictionary_id='35657.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır'>. <cf_get_lang dictionary_id ='44193.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır'>.<br> </p>
                                    <cf_get_lang dictionary_id='44951.Bu belgede olması gereken alan sayısı'> : 4.<br/><br/>
                                        <cf_get_lang dictionary_id='53860.Alanlar sırasıyla'>;<br><br/>
                                        1-<cf_get_lang dictionary_id='64280.Top Category Code'> (<cf_get_lang dictionary_id='64281.Bir kategorinin altına yeni bir kategori ekleyecek iseniz Üst Kategori Kodunu mutlaka belirtmelisiniz.'>)<br/>
                                        2-<cf_get_lang dictionary_id='42003.Kategori Adı'>*<br/>
                                        3-<cf_get_lang dictionary_id='36199.Açıklama'><br/>
                                        4-<cf_get_lang dictionary_id='45278.Kategori Kodu'> *<br/><br/><br/>
                                        <cf_get_lang_main no='55.NOT'>: (*) <cf_get_lang no ='3129.Yıldızlı Olanlar Zorunlu Alanlardır'>.                           
                            </div>
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
		alert("<cf_get_lang no='1441.Belge Seçmelisiniz'>!");
		return false;
	}
		return true;
}
</script>
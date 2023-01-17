<cfquery name="get_our_companies" datasource="#DSN#">
	SELECT 
		COMP_ID,
		NICK_NAME
	FROM
		OUR_COMPANY
	ORDER BY
		NICK_NAME
</cfquery>
<cf_box title="#getLang('','settings',43595)#">
    <cfform name="brand_import" action="#request.self#?fuseaction=settings.emptypopup_brand_import" method="post" enctype="multipart/form-data">
        <cf_box_elements>
        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
            <div class="form-group">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43385.Belge Formatı'></label>
                <div class="col col-8 col-md-6 col-xs-12">
                    <select name="file_format" id="file_format">
                        <option value="UTF-8"><cf_get_lang dictionary_id='43388.UTF-8'></option>
                        <option value="iso-8859-9"><cf_get_lang dictionary_id='43386.ISO-8859-9 (Türkçe)'></option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57691.Dosya'></label>
                <div class="col col-8 col-md-6 col-xs-12">
                    <cfinput name="asset" id="asset" type="file" message="Dosya eksik!" required="yes">
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                <div class="col col-8 col-md-6 col-xs-12">
                <a  href="/IEF/standarts/import_example_file/Marka_Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='29531.Şirketler'></label>
                <div class="col col-8 col-md-6 col-xs-12">
                    <select multiple name="our_company_ids" id="our_company_ids">
                        <cfoutput query="get_our_companies">
                            <option value="#comp_id#">#nick_name#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
        </div>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
             
                    <h3><cf_get_lang dictionary_id='58594.Format'></h3>
                        <cf_get_lang dictionary_id='30106.Dosya uzantısı csv olmalı kaydedilirken karakter desteği olarak UTF-8 seçilmelidir Alan araları noktalı virgül(;) ile ayrılmalı sayısal değerler için nokta( ) ayrac olarak kullanılmalıdır'> <br />
                        <cf_get_lang dictionary_id='44960.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'><br />
                        <cf_get_lang dictionary_id='43092.Seçilen şirketler markalarla ilişkilendirilecektir'>
                        <cf_get_lang dictionary_id='45041.Belgede olması gereken alan sayısı'> : 3<br/>
                        <cf_get_lang dictionary_id='44197.Alanlar sırasıyla'>: <br />
                        1- <cf_get_lang dictionary_id='58585.Kod'>*<br/>
                        2- <cf_get_lang dictionary_id='58847.Marka'>*<br/>
                        3- <cf_get_lang dictionary_id='57629.Açıklama'><br/>
                        <cf_get_lang dictionary_id='57467.Not'> : <cf_get_lang dictionary_id='43095.* ile işaretli alanlar zorunludur'>
        </div
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0'>
        </cf_box_footer>
    </cfform>
</cf_box>


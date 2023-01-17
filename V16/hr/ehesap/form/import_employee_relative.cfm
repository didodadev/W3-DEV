<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="get_education_level" datasource="#dsn#">
    SELECT 
    EDU_LEVEL_ID,
    #DSN#.#dsn#.Get_Dynamic_Language(EDU_LEVEL_ID,'#session.ep.language#','SETUP_EDUCATION_LEVEL','EDUCATION_NAME',NULL,NULL,SETUP_EDUCATION_LEVEL.EDUCATION_NAME ) AS EDUCATION_NAME 
    FROM 
    SETUP_EDUCATION_LEVEL
</cfquery> 
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Çalışan Yakını Aktarım','42784')#">
        <cfform name="formimport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_import_employee_relative">
            <cf_box_elements>
                <input type="hidden" name="html_file" id="html_file" value="<cfoutput>#createUUID()#</cfoutput>.html">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">               
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format">
                                <option value="utf-8"><cf_get_lang dictionary_id='43388.UTF-8'></option>
                                <option value="iso-8859-9"><cf_get_lang dictionary_id='43386.ISO-8859-9 (Türkçe)'></option>     
                           </select>
                        </div>
                    </div> 
                    <div class="form-group" id="item-file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">
                        </div>
                    </div>        
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <a href="/IEF/standarts/import_example_file/calisan_yakini_aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                        </div>
                    </div>                                  
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                    </div>  
                    <div class="form-group" id="item-exp1">
                        <cf_get_lang dictionary_id='44707.İlk satır başlıklar olur.'> <cf_get_lang dictionary_id='44708.Dosya Okumaya 2 satırdan başlar.'> <cf_get_lang dictionary_id='44709.CSV formatında'>(;)<cf_get_lang dictionary_id='44710.ile ayrılmış dosya upload edilmelidir!'>
                    </div> 
                    <div class="form-group" id="item-exp2">
                        1-<cf_get_lang dictionary_id = '58487.Çalışan No'></br>
                        2-<cf_get_lang dictionary_id = '44688.Çalışan Adı'></br>
                        3-<cf_get_lang dictionary_id = '44689.Çalışan Soyadı'></br>
                        4-<cf_get_lang dictionary_id = '44690.Çalışan TC Kimlik No'>* </br>
                        5-<cf_get_lang dictionary_id = '44691.Çalışan Yakın Adı'></br>
                        6-<cf_get_lang dictionary_id = '44692.Çalışan Yakın Soyadı'></br>
                        7-<cf_get_lang dictionary_id = '44693.Çalışan Yakınlık Derecesi'>*(<cf_get_lang dictionary_id='44694.Baba'>:1,<cf_get_lang dictionary_id='44695.Anne'>:2,<cf_get_lang dictionary_id='44696.Eş'>:3,<cf_get_lang dictionary_id='44697.Erkek Çocuk'>:4,<cf_get_lang dictionary_id='44698.Kız Çocuk'>:5,<cf_get_lang dictionary_id='44699.Kardeş'>:6)</br>
                        8-<cf_get_lang dictionary_id = "29911.Evlilik Tarihi">(15.07.1981 <cf_get_lang dictionary_id='44704.Şeklinde Olmalıdır'>)</br>
                        9-<cf_get_lang dictionary_id = '44700.Çalışan Yakın TC Kimlik No'>*</br>
                        10-<cf_get_lang dictionary_id = '44701.Çalışan Yakın Cinsiyeti'>(<cf_get_lang dictionary_id='58959.Erkek'>:1,<cf_get_lang dictionary_id='58958..Kadın'>:0)</br>
                        11-<cf_get_lang dictionary_id = '44703.Çalışan Yakın Doğum Tarihi'>* (15.07.1981 <cf_get_lang dictionary_id='44704.Şeklinde Olmalıdır'>)</br>
                        12-<cf_get_lang dictionary_id = '44705.Çalışan Yakın Doğum Yeri'></br>
                        13-<cf_get_lang dictionary_id = '44706.Çalışan Yakın Vergi Durumu'>* (1 <cf_get_lang dictionary_id='57998.veya'> 0 <cf_get_lang dictionary_id='44072.olacak'>)</br>
                        14-<cf_get_lang dictionary_id = '58624.Geçerlilik Tarihi'>* (01.11.1991 <cf_get_lang dictionary_id='44704.Şeklinde Olmalıdır'>)</br>
                        15-<cf_get_lang dictionary_id = "31332.Okuyor"> / <cf_get_lang dictionary_id = "40131.okumuyor"> *(1 <cf_get_lang dictionary_id='57998.veya'> 0 <cf_get_lang dictionary_id='44072.olacak'>)</br>
                        16-<cf_get_lang dictionary_id = "46080.Çocuk yardımı"> (1 <cf_get_lang dictionary_id='57998.veya'> 0 <cf_get_lang dictionary_id='44072.olacak'>)</br>
                        17-<cf_get_lang dictionary_id = "56185.MAlül">(1 <cf_get_lang dictionary_id='57998.veya'> 0 <cf_get_lang dictionary_id='44072.olacak'>)</br>
                        18-<cf_get_lang dictionary_id = "30501.Evli">(1 <cf_get_lang dictionary_id='57998.veya'> 0 <cf_get_lang dictionary_id='44072.olacak'>)</br>
                        19-<cf_get_lang dictionary_id = "56186.Kurum Çalışanı">(1 <cf_get_lang dictionary_id='57998.veya'> 0 <cf_get_lang dictionary_id='44072.olacak'>)</br>
                        20-<cf_get_lang dictionary_id = "58541.Emekli">(1 <cf_get_lang dictionary_id='57998.veya'> 0 <cf_get_lang dictionary_id='44072.olacak'>)</br>
                        21-<cf_get_lang dictionary_id = "40137.Çalışıyor">(1 <cf_get_lang dictionary_id='57998.veya'> 0 <cf_get_lang dictionary_id='44072.olacak'>)</br>
                        22-<cf_get_lang dictionary_id = "55495.Eğitim durumu">(<cfoutput query="get_education_level">#education_name#=#edu_level_id#,</cfoutput>)</br>
                        23-<cf_get_lang dictionary_id = "59671.Kreş Yardımı">(1 <cf_get_lang dictionary_id='57998.veya'> 0 <cf_get_lang dictionary_id='44072.olacak'>)</br>
                        24-<cf_get_lang dictionary_id = "56359.Taahhütname">(1 <cf_get_lang dictionary_id='57998.veya'> 0 <cf_get_lang dictionary_id='44072.olacak'>)</br>
                        25-<cf_get_lang dictionary_id='43058.Kolon'> <cf_get_lang dictionary_id = "59672.Poliçe">(1 <cf_get_lang dictionary_id='57998.veya'> 0 <cf_get_lang dictionary_id='44072.olacak'>)</br>
                    </div>
                    <div class="form-group" id="item-exp3">
                        * <cf_get_lang dictionary_id="35867.Doldurulması zorunlu alanlar">.
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
			alert("<cf_get_lang dictionary_id ='43930.İmport Edilecek Belge Girmelisiniz'>!");
			return false;
		}
		return true;
		
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

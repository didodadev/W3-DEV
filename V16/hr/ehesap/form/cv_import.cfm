<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','Cv Aktarım','43561')#" closable="0">
            <cfform name="formexport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_import_cv">
            	<input type="hidden" name="html_file" id="html_file" value="<cfoutput>#createUUID()#</cfoutput>.html">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-file_format">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>    
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">    
                                <select name="file_format" id="file_format">    
                                    <option value="utf-8"><cf_get_lang dictionary_id='55929.UTF-8'></option>    
                                    <option value="iso-8859-9"><cf_get_lang dictionary_id='53845.ISO-8859-9 (Türkçe)'></option> 
                                </select>
                            </div>    
                        </div>
                        <div class="form-group" id="item-uploaded_file">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>    
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">    
                                <input type="file" name="uploaded_file" id="uploaded_file">    
                            </div>
                        </div>  
                        <div class="form-group" id="item-download-link">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>    
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">    
                                <a href="/IEF/standarts/import_example_file/CV_aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>    
                            </div>
                        </div>
                        <div class="form-group" id="item-file_process">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç">*</label>    
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">                                    
                                <cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'>                              
                            </div>    
                        </div>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-format">
                            <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>    
                        </div>                          
                        <div class="form-group" id="item-exp1">
                            <cf_get_lang dictionary_id='44331.Belgede toplam 127 alan olacaktır alanlar sırasi ile'>;
                        </div>                         
                        <div class="form-group" id="item-exp2">
                            1-<cf_get_lang dictionary_id ='57631.Ad'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
                            2-<cf_get_lang dictionary_id ='58726.Soyad'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
                            3-<cf_get_lang dictionary_id ='58025.TC Kimlik No'><br/>
                            4-<cf_get_lang dictionary_id ='44256.Medeni Durum'> :<cf_get_lang dictionary_id ='44257.Evli-->1 Bekar-->0 olacak şekilde girilmelidir'>.<br/>
                            5-<cf_get_lang dictionary_id='57764.Cinsiyet'> : <cf_get_lang dictionary_id ='44258.Erkek-->1 Kadın-->0 olacak şekilde girilmelidir'>.<br/>
                            6-<cf_get_lang dictionary_id ='58727.Doğum Tarihi'> :15.06.2007 <cf_get_lang dictionary_id ='44253.formatında olmalıdır'>.<br/>
                            7-<cf_get_lang dictionary_id='57790.Doğum Yeri'><br/>
                            8-<cf_get_lang dictionary_id ='57428.E-mail'>(<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
                            9-<cf_get_lang dictionary_id ='44180.Ev Adresi'><br/>
                            10-<cf_get_lang dictionary_id='58638.İlçe'> : <cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'>.<br/>
                            11-<cf_get_lang dictionary_id='57971.Şehir'>: <cf_get_lang dictionary_id ='44268.Sayısal Olarak şehrin ID si girilmelidir'>.<br/>
                            12-<cf_get_lang dictionary_id ='44269.Ev Telefonu Alan Kodu'><br/>
                            13-<cf_get_lang dictionary_id='58814.Ev Telefon'> <br/>
                            14-<cf_get_lang dictionary_id ='44178.Cep Telefonu Alan Kodu'><br/>
                            15-<cf_get_lang dictionary_id ='44179.Cep Telefon No'> <br/>
                                <cfquery name="get_education_level" datasource="#dsn#">
                                    SELECT EDU_LEVEL_ID,
                                    #DSN#.#dsn#.Get_Dynamic_Language(EDU_LEVEL_ID,'#session.ep.language#','SETUP_EDUCATION_LEVEL','EDUCATION_NAME',NULL,NULL,SETUP_EDUCATION_LEVEL.EDUCATION_NAME ) AS EDUCATION_NAME 
                                    FROM 
                                    SETUP_EDUCATION_LEVEL
                                </cfquery>
                            16-<cf_get_lang dictionary_id ='44208.Eğitim Seviyesi'> :<cf_get_lang dictionary_id ='44274.Sayısal Olarak eğitim seviyesi ID si girilmelidir'>.(
                                <cfoutput query="get_education_level">
                                #education_name#=#edu_level_id#,
                                </cfoutput>
                            )<br/>
                            17-<cf_get_lang dictionary_id ='44208.Eğitim Seviyesi'> <cf_get_lang dictionary_id="58527.ID"> :(
                                <cfoutput query="get_education_level">
                                #education_name#=#edu_level_id#,
                                </cfoutput>
                            )<br />
                            18-<cf_get_lang dictionary_id="56482.Okul Adı"> :(<cf_get_lang dictionary_id="59579.İlköğretim ve Lise okul türündeki eğitim seviyeleri için bu alan yazı ile girilmelidir."> <cf_get_lang dictionary_id="59581.ID değildir."> <cf_get_lang dictionary_id="59582.Üniversite okul türündeki eğitim seviyeleri için bu alan sayısal olarak ID girilmelidir">)<br />
                            19-<cf_get_lang dictionary_id="56496.Giriş Yılı"><br />
                            20-<cf_get_lang dictionary_id="55845.Mezuniyet Yılı"><br />
                            21-<cf_get_lang dictionary_id="56153.Not Ortalaması"><br />
                            22-<cf_get_lang dictionary_id="57995.Bölüm"> (<cf_get_lang dictionary_id="59583.İlköğretim okul türündeki eğitim seviyeleri için bu alan boş bırakılmalıdır."> <cf_get_lang dictionary_id="59584.Lise ve Üniversite okul türlerindeki eğitim seviyeleri için bu alan sayısal olarak ID girilmelidir">)<br />
                            23-<cf_get_lang dictionary_id='58527.ID'>  :(
                                <cfoutput query="get_education_level">
                                #education_name#=#edu_level_id#,
                                </cfoutput>
                            )<br />
                            24-<cf_get_lang dictionary_id="56482.Okul Adı"> :(<cf_get_lang dictionary_id="59579.İlköğretim ve Lise okul türündeki eğitim seviyeleri için bu alan yazı ile girilmelidir."> <cf_get_lang dictionary_id="59581.ID değildir."> <cf_get_lang dictionary_id="59582.Üniversite okul türündeki eğitim seviyeleri için bu alan sayısal olarak ID girilmelidir">)<br />
                            25-<cf_get_lang dictionary_id="56496.Giriş Yılı"><br />
                            26-<cf_get_lang dictionary_id="55845.Mezuniyet Yılı"><br />
                            27-<cf_get_lang dictionary_id="56153.Not Ortalaması"><br />
                            28-<cf_get_lang dictionary_id="57995.Bölüm"> (<cf_get_lang dictionary_id="59583.İlköğretim okul türündeki eğitim seviyeleri için bu alan boş bırakılmalıdır."> <cf_get_lang dictionary_id="59584.Lise ve Üniversite okul türlerindeki eğitim seviyeleri için bu alan sayısal olarak ID girilmelidir">)<br />
                            29-<cf_get_lang dictionary_id ='44208.Eğitim Seviyesi'> <cf_get_lang dictionary_id='58527.ID'> :(
                                <cfoutput query="get_education_level">
                                #education_name#=#edu_level_id#,
                                </cfoutput>
                            )<br />
                            30-<cf_get_lang dictionary_id="56482.Okul Adı"> :(<cf_get_lang dictionary_id="59579.İlköğretim ve Lise okul türündeki eğitim seviyeleri için bu alan yazı ile girilmelidir."> <cf_get_lang dictionary_id="59581.ID değildir."> <cf_get_lang dictionary_id="59582.Üniversite okul türündeki eğitim seviyeleri için bu alan sayısal olarak ID girilmelidir">)<br />
                            31-<cf_get_lang dictionary_id="56496.Giriş Yılı"><br />
                            32-<cf_get_lang dictionary_id="55845.Mezuniyet Yılı"><br />
                            33-<cf_get_lang dictionary_id="56153.Not Ortalaması"><br />
                            34-<cf_get_lang dictionary_id="57995.Bölüm"> (<cf_get_lang dictionary_id="59583.İlköğretim okul türündeki eğitim seviyeleri için bu alan boş bırakılmalıdır."> <cf_get_lang dictionary_id="59584.Lise ve Üniversite okul türlerindeki eğitim seviyeleri için bu alan sayısal olarak ID girilmelidir">)<br />
                            35-<cf_get_lang dictionary_id ='44208.Eğitim Seviyesi'> <cf_get_lang dictionary_id='58527.ID'> :(
                                <cfoutput query="get_education_level">
                                #education_name#=#edu_level_id#,
                                </cfoutput>
                            )<br />
                            36-<cf_get_lang dictionary_id="56482.Okul Adı"> :(<cf_get_lang dictionary_id="59579.İlköğretim ve Lise okul türündeki eğitim seviyeleri için bu alan yazı ile girilmelidir."> <cf_get_lang dictionary_id="59581.ID değildir."> <cf_get_lang dictionary_id="59582.Üniversite okul türündeki eğitim seviyeleri için bu alan sayısal olarak ID girilmelidir">)<br />
                            37-<cf_get_lang dictionary_id="56496.Giriş Yılı"><br />
                            38-<cf_get_lang dictionary_id="55845.Mezuniyet Yılı"><br />
                            39-<cf_get_lang dictionary_id="56153.Not Ortalaması"><br />
                            40-<cf_get_lang dictionary_id="57995.Bölüm"> (<cf_get_lang dictionary_id="59583.İlköğretim okul türündeki eğitim seviyeleri için bu alan boş bırakılmalıdır."> <cf_get_lang dictionary_id="59584.Lise ve Üniversite okul türlerindeki eğitim seviyeleri için bu alan sayısal olarak ID girilmelidir">)<br />
                            41-<cf_get_lang dictionary_id ='44208.Eğitim Seviyesi'> <cf_get_lang dictionary_id='58527.ID'> :(
                                <cfoutput query="get_education_level">
                                #education_name#=#edu_level_id#,
                                </cfoutput>
                            )<br />
                            42-<cf_get_lang dictionary_id="56482.Okul Adı"> :(<cf_get_lang dictionary_id="59579.İlköğretim ve Lise okul türündeki eğitim seviyeleri için bu alan yazı ile girilmelidir."> <cf_get_lang dictionary_id="59581.ID değildir."> <cf_get_lang dictionary_id="59582.Üniversite okul türündeki eğitim seviyeleri için bu alan sayısal olarak ID girilmelidir">)<br />
                            43-<cf_get_lang dictionary_id="56496.Giriş Yılı"><br />
                            44-<cf_get_lang dictionary_id="55845.Mezuniyet Yılı"><br />
                            45-<cf_get_lang dictionary_id="56153.Not Ortalaması"><br />
                            46-<cf_get_lang dictionary_id="57995.Bölüm"> (<cf_get_lang dictionary_id="59583.İlköğretim okul türündeki eğitim seviyeleri için bu alan boş bırakılmalıdır."> <cf_get_lang dictionary_id="59584.Lise ve Üniversite okul türlerindeki eğitim seviyeleri için bu alan sayısal olarak ID girilmelidir">)<br />
                            47-<cf_get_lang dictionary_id ='44208.Eğitim Seviyesi'> <cf_get_lang dictionary_id='58527.ID'> :(
                                <cfoutput query="get_education_level">
                                #education_name#=#edu_level_id#,
                                </cfoutput>
                            )<br />
                            48-<cf_get_lang dictionary_id="56482.Okul Adı"> :(<cf_get_lang dictionary_id="59579.İlköğretim ve Lise okul türündeki eğitim seviyeleri için bu alan yazı ile girilmelidir."> <cf_get_lang dictionary_id="59581.ID değildir."> <cf_get_lang dictionary_id="59582.Üniversite okul türündeki eğitim seviyeleri için bu alan sayısal olarak ID girilmelidir">)<br />
                            49-<cf_get_lang dictionary_id="56496.Giriş Yılı"><br />
                            50-<cf_get_lang dictionary_id="55845.Mezuniyet Yılı"><br />
                            51-<cf_get_lang dictionary_id="56153.Not Ortalaması"><br />
                            52-<cf_get_lang dictionary_id="57995.Bölüm"> (<cf_get_lang dictionary_id="59583.İlköğretim okul türündeki eğitim seviyeleri için bu alan boş bırakılmalıdır."> <cf_get_lang dictionary_id="59584.Lise ve Üniversite okul türlerindeki eğitim seviyeleri için bu alan sayısal olarak ID girilmelidir">)<br />					
                            53-<cf_get_lang dictionary_id ='44300.Yabancı Dil'> 1 <cf_get_lang dictionary_id ='57897.Adı'> :<cf_get_lang dictionary_id ='44330.Sayısal Olarak  ID  girilmelidir'>.<br/>
                            54-<cf_get_lang dictionary_id ='44301.Konuşma Seviyesi'> : <cf_get_lang dictionary_id ='44330.Sayısal Olarak  ID  girilmelidir'>.<br/>
                            55-<cf_get_lang dictionary_id ='44302.Anlama Seviyesi'> : <cf_get_lang dictionary_id ='44330.Sayısal Olarak  ID  girilmelidir'>.<br/>
                            56-<cf_get_lang dictionary_id ='44303.Yazma Seviyesi'> : <cf_get_lang dictionary_id ='44330.Sayısal Olarak  ID  girilmelidir'>.<br/>
                            57-<cf_get_lang dictionary_id ='44304.Öğrenildiği Yer'><br/>
                            58-<cf_get_lang dictionary_id ='44300.Yabancı Dil'> 2<cf_get_lang dictionary_id ='57897.Adı'> : <cf_get_lang dictionary_id ='44330.Sayısal Olarak  ID  girilmelidir'>.<br/>
                            59-<cf_get_lang dictionary_id ='44301.Konuşma Seviyesi'> : <cf_get_lang dictionary_id ='44330.Sayısal Olarak  ID  girilmelidir'>.<br/>
                            60-<cf_get_lang dictionary_id ='44302.Anlama Seviyesi'> : <cf_get_lang dictionary_id ='44330.Sayısal Olarak  ID  girilmelidir'>.<br/>
                            61-<cf_get_lang dictionary_id ='44303.Yazma Seviyesi'>: <cf_get_lang dictionary_id ='44330.Sayısal Olarak  ID  girilmelidir'>.<br/>
                            62-<cf_get_lang dictionary_id ='44304.Öğrenildiği Yer'><br/>
                            63-<cf_get_lang dictionary_id ='44300.Yabancı Dil'> 3 <cf_get_lang dictionary_id ='57897.Adı'> : <cf_get_lang dictionary_id ='44330.Sayısal Olarak  ID  girilmelidir'>.<br/>
                            64-<cf_get_lang dictionary_id ='44301.Konuşma Seviyesi'> :<cf_get_lang dictionary_id ='44330.Sayısal Olarak  ID  girilmelidir'>.<br/>
                            65-<cf_get_lang dictionary_id ='44302.Anlama Seviyesi'> : <cf_get_lang dictionary_id ='44330.Sayısal Olarak  ID  girilmelidir'>.<br/>
                            66-<cf_get_lang dictionary_id ='44303.Yazma Seviyesi'> : <cf_get_lang dictionary_id ='44330.Sayısal Olarak  ID  girilmelidir'>.<br/>
                            67-<cf_get_lang dictionary_id ='44304.Öğrenildiği Yer'><br/>
                            68-<cf_get_lang dictionary_id ='44305.İş Tecrübesi '> 1<cf_get_lang dictionary_id ='58485.Şirket Adı'> : <cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'>.<br/>
                            69-<cf_get_lang dictionary_id ='58497.Pozisyon'> : <cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'>.<br/>
                            70-<cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'> : 15.06.2007 <cf_get_lang dictionary_id='44253.formatında olmalıdır'>.<br/>
                            71-<cf_get_lang dictionary_id ='57700.Bitiş Tarihi'> : 15.06.2007 <cf_get_lang dictionary_id='44253.formatında olmalıdır'>.<br/>
                            72-<cf_get_lang dictionary_id ='44306.Görev Ve Sorumluluk'><br/>
                            73-<cf_get_lang dictionary_id ='44307.Ayrılma Nedeni'><br/>
                            74-<cf_get_lang dictionary_id ='44305.İş Tecrübesi '>  2<cf_get_lang dictionary_id ='58485.Şirket Adı'> :<cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'>.<br/>
                            75-<cf_get_lang dictionary_id ='58497.Pozisyon'> : <cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'>.<br/>
                            76-<cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'><br/>
                            77-<cf_get_lang dictionary_id ='57700.Bitiş Tarihi'><br/>
                            78-<cf_get_lang dictionary_id ='44306.Görev Ve Sorumluluk'><br/>
                            79-<cf_get_lang dictionary_id ='44307.Ayrılma Nedeni'><br/>
                            80-<cf_get_lang dictionary_id ='44305.İş Tecrübesi '>3 <cf_get_lang dictionary_id ='58485.Şirket Adı'> : <cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'>.<br/>
                            81-<cf_get_lang dictionary_id ='58497.Pozisyon'> : <cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'>.<br/>
                            82-<cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'><br/>
                            83-<cf_get_lang dictionary_id ='57700.Bitiş Tarihi'><br/>
                            84-<cf_get_lang dictionary_id ='44306.Görev Ve Sorumluluk'><br/>
                            85-<cf_get_lang dictionary_id ='44307.Ayrılma Nedeni'><br/>
                            86-<cf_get_lang dictionary_id ='44305.İş Tecrübesi '> 4 <cf_get_lang dictionary_id ='58485.Şirket Adı'> :<cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'>.<br/>
                            87-<cf_get_lang dictionary_id ='58497.Pozisyon'> : <cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'>.<br/>
                            88-<cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'><br/>
                            89-<cf_get_lang dictionary_id ='57700.Bitiş Tarihi'><br/>
                            90-<cf_get_lang dictionary_id ='44306.Görev Ve Sorumluluk'><br/>
                            91-<cf_get_lang dictionary_id ='44307.Ayrılma Nedeni'><br/>
                            92-<cf_get_lang dictionary_id ='44309.Kurs'>1 <cf_get_lang dictionary_id='57480.Konu'> :<cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'> .<br/>
                            93-<cf_get_lang dictionary_id ='44309.Kurs'>1 <cf_get_lang dictionary_id ='58455.Yıl'><br/>
                            94-<cf_get_lang dictionary_id ='44309.Kurs'>1 <cf_get_lang dictionary_id ='44310.Yer ID değildir Yazı ile girilmesi gerekir'>.<br/>
                            95-<cf_get_lang dictionary_id ='44309.Kurs'>1 <cf_get_lang dictionary_id ='57490.Gün'><br/>
                            96-<cf_get_lang dictionary_id ='44309.Kurs'>2 <cf_get_lang dictionary_id ='57480.Konu'> : <cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'>.<br/>
                            97-<cf_get_lang dictionary_id ='44309.Kurs'>2 <cf_get_lang dictionary_id ='58455.Yıl'><br/>
                            98-<cf_get_lang dictionary_id ='44309.Kurs'>2 <cf_get_lang dictionary_id ='44310.Yer ID değildir Yazı ile girilmesi gerekir'>.<br/>
                            99-<cf_get_lang dictionary_id ='44309.Kurs'>2 <cf_get_lang dictionary_id ='57490.Gün'><br/>
                            100-<cf_get_lang dictionary_id ='44309.Kurs'>3 <cf_get_lang dictionary_id ='57480.Konu'> : <cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'>.<br/>
                            101-<cf_get_lang dictionary_id ='44309.Kurs'>3 <cf_get_lang dictionary_id ='58455.Yıl'><br/>
                            102-<cf_get_lang dictionary_id ='44309.Kurs'>3<cf_get_lang dictionary_id ='44310.Yer ID değildir Yazı ile girilmesi gerekir'>.<br/>
                            103-<cf_get_lang dictionary_id ='44309.Kurs'>3 <cf_get_lang dictionary_id ='57490.Gün'><br/>
                            104-<cf_get_lang dictionary_id ='44311.Askerlik Durumu'> :<cf_get_lang dictionary_id ='44330.Sayısal Olarak  ID  girilmelidir'>(<cf_get_lang dictionary_id='44594.Yapmadı'>:0,<cf_get_lang dictionary_id='44595.Yaptı'>:1,<cf_get_lang dictionary_id='44596.Muaf'>:2,<cf_get_lang dictionary_id='44597.Yabancı'>:3,<cf_get_lang dictionary_id='44598.Tecilli'>:4)<br/>
                            105-<cf_get_lang dictionary_id ='44312.Askerlik Terhis Tarihi'>:15.06.2007<cf_get_lang dictionary_id ='44253.formatında olmalıdır'> .<br/>
                            106-<cf_get_lang dictionary_id ='44313.Devam eden hastalık sorununuz var mı:varsa 1, yoksa 0 girilmelidir'>?  .<br/>
                            107-<cf_get_lang dictionary_id ='44314.Sigara Kullanıyor mu? : kullanıyorsanız 1, kullanmıyorsanız 0 girilmelidir'>.<br/>
                            108-<cf_get_lang dictionary_id ='44315.Özürlü mü? : özürlüyseniz 1, değilseniz 0 girilmelidir'>.<br/>
                            109-<cf_get_lang dictionary_id ='44316.Hüküm Giydi mi? : Evet-->1 Hayır-->0 olacak şekilde girilmelidir'>.<br/>
                            110-<cf_get_lang dictionary_id ='44317.Kovuşturma'><br/>
                            111-<cf_get_lang dictionary_id ='42051.Ehliyet Veriliş Yılı'> :17.02.2009<cf_get_lang dictionary_id ='44253.formatında olmalıdır'>.<br/>
                            112-<cf_get_lang dictionary_id ='44318.Ehliyet Tipi '> :<cf_get_lang dictionary_id ='42052.A,B,C,D,E,F Şeklinde Girilmelidir'><br/> 
                            113-<cf_get_lang dictionary_id ='44320.Seyahat edebilir mi? : edebilirseniz 1, edemiyorsanız 0 girilmelidir'>.<br/>
                            114-<cf_get_lang dictionary_id='58784.Referans'>1 <cf_get_lang dictionary_id='57570.Ad Soyad'><br/>
                            115-<cf_get_lang dictionary_id='58784.Referans'>1 <cf_get_lang dictionary_id='57574.Şirket'> : <cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'>.<br/>
                            116-<cf_get_lang dictionary_id='58784.Referans'>1 <cf_get_lang dictionary_id='58497.Pozisyon'> : <cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'>.<br/>
                            117-<cf_get_lang dictionary_id='58784.Referans'>1 <cf_get_lang dictionary_id='44177.Tel Alan Kodu'> <br/>
                            118-<cf_get_lang dictionary_id='58784.Referans'>1 <cf_get_lang dictionary_id='57499.Telefon'><br/>
                            119-<cf_get_lang dictionary_id='58784.Referans'>1 <cf_get_lang dictionary_id='57428.E-mail'><br/>
                            120-<cf_get_lang dictionary_id='58784.Referans'>2 <cf_get_lang dictionary_id='57570.Ad Soyad'><br/>
                            121-<cf_get_lang dictionary_id='58784.Referans'>2 <cf_get_lang dictionary_id='57574.Şirket'> : <cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'>.<br/>
                            122-<cf_get_lang dictionary_id='58784.Referans'>2 <cf_get_lang dictionary_id='58497.Pozisyon'> : <cf_get_lang dictionary_id ='44263.ID değildir Yazı ile girilmesi gerekir'>.<br/>
                            123-<cf_get_lang dictionary_id='58784.Referans'>2 <cf_get_lang dictionary_id='44177.Tel Alan Kodu'> <br/>
                            124-<cf_get_lang dictionary_id='58784.Referans'>2 <cf_get_lang dictionary_id='57499.Telefon'><br/>
                            125-<cf_get_lang dictionary_id='58784.Referans'>2 <cf_get_lang dictionary_id='57428.E-mail'><br/>
                            126-<cf_get_lang dictionary_id ='44326.İstenilen Net Ücret'><br/>
                            127-<cf_get_lang dictionary_id ='44327.Eklemek İstedikleriniz'> (<cf_get_lang dictionary_id ='57467.Not'>)<br/><br/>
                            &nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id ='57629.Açıklama'>:<cf_get_lang dictionary_id ='44342.Dosya uzantısı csv olamalı ,alan araları noktalı virgül (;) ile ayrılmalı ve kaydedilirken karakter desteği olarak UTF-8 seçilmelidir'>
                            <cf_get_lang dictionary_id ='44193.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır'>.
                            <cf_get_lang dictionary_id ='44328.ad,soyad,email dışındaki alanlar boş bırakılabilir Ama 1 satırda isimler ve email mutlaka olmalıdır'>.<br/>
                            &nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id ='44329.En az emailad ve soyad bilgileri girilerek import yapılması gerekir Diğer alanlar zorunlu değil'>.<br/>

                        </div>
                    </div>
                </cf_box_elements> 
                <cf_box_footer>
                    <cf_workcube_buttons is_upd='0'>
                </cf_box_footer>                   
            </cfform>
        </cf_box>
    </div>
<br />
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

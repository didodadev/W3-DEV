<cf_get_lang_set module_name="settings">
    <cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
        SELECT COMP_ID,COMPANY_NAME,NICK_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
    </cfquery>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','Ürün Aktarım','43255')#">
            <cfform name="formimport" action="#request.self#?fuseaction=settings.add_product_import" enctype="multipart/form-data" method="post">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-file_format">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <select name="file_format" id="file_format">
                                    <option value="UTF-8"><cf_get_lang dictionary_id='55929.UTF-8'></option>
                                    <option value="iso-8859-9"><cf_get_lang dictionary_id='32979.ISO-8859-9 (Türkçe)'></option>
                                </select>
                            </div>
                        </div>  
                        <div class="form-group" id="item-file">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <input type="file" name="uploaded_file" id="uploaded_file">
                            </div>
                        </div>     
                        <div class="form-group" id="item-example_file">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <a href="/IEF/standarts/import_example_file/import_data.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                            </div>
                        </div>        
                        <div class="form-group" id="item-category_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43422.Kategori ID'></label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="default_kategori" id="default_kategori"> (<cf_get_lang dictionary_id='58967.Örnek'>:91)
                            </div>
                        </div>        
                        <div class="form-group" id="item-hierarchy">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57761.Hiyerarşi'></label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="default_hierarchy" id="default_hierarchy"> (<cf_get_lang dictionary_id='58967.Örnek'>:1.02.3.34)
                            </div>
                        </div>           
                        <div class="form-group" id="item-company">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29531.Şirketler'></label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <select name="comp_id" id="comp_id" multiple onchange="get_branch_list(this.value)">
                                    <cfoutput query="get_our_company">
                                        <option value="#comp_id#">#company_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>           
                        <div class="form-group" id="item-branch">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <select name="branch" id="branch" multiple="multiple">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                </select>
                            </div>
                        </div>    
                        <div class="form-group" id="item-same_product">
                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                <input type="checkbox" name="is_product_name" id="is_product_name" value="1" />
                                <cf_get_lang dictionary_id='44937.Aynı İsimli Ürünler İmport Edilebilsin'>
                            </div>
                        </div>                                                                                       
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-format">
                            <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                        </div>  
                        <div class="form-group" id="item-exp1">
                            <cf_get_lang dictionary_id='35657.Dosya uzantısı csv olmalı ve alan araları virgül (;) ile ayrılmalıdır'>
                        </div>
                        <div class="form-group" id="item-exp2">
                            <cf_get_lang dictionary_id='53889.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>
                        </div>
                        <div class="form-group" id="item-exp3">
                            <cf_get_lang dictionary_id='63302.Ürün adlarında özel karakterler kesinlikle kullanılmamalıdır.'>
                        </div>
                        <div class="form-group" id="item-exp4">
                            <cf_get_lang dictionary_id='44195.Belgede toplam'> 43 <cf_get_lang dictionary_id='44196.alan olacaktır'>.
                        </div>
                        <div class="form-group" id="item-exp5">
                            <cf_get_lang dictionary_id='44197.Alanlar sırasıyla'>;
                        </div>
                        <div class="form-group" id="item-exp6">
                            1-<cf_get_lang dictionary_id='31402.Kayıt Tipi'> : <cf_get_lang dictionary_id='44210.1 veya 0. 1 ise ürün kaydedilecek 0 ise sadece stocks tablosuna ürün kaydı yapılacak(boş olabilir)'>.<cf_get_lang dictionary_id='44211.Kayıt tipi 0 olan ürün kendinden önceki 1 olan ürünün çeşidi olarak kayıt edilir'></br>
                            2-<cf_get_lang dictionary_id='57633.Barkod'> : <cf_get_lang dictionary_id='63304.Ürünün Barkod Numarası'></br>
                            3-<cf_get_lang dictionary_id='57633.Barkod'> 2 : <cf_get_lang dictionary_id='44213.varsa ürünün ikinci barcode numarası (boş olabilir)'></br>
                            4-<cf_get_lang dictionary_id='58221.Ürün Adı'> : <cf_get_lang dictionary_id='44215.ürünün adı'></br>
                            5-<cf_get_lang dictionary_id='37845.Çeşit'><cf_get_lang dictionary_id='57897.Adı'> : <cf_get_lang dictionary_id='44217.stocks tablosundaki property alanı için stok ismi'></br>
                            6-<cf_get_lang dictionary_id='57636.Birim'> : <cf_get_lang dictionary_id='37381.ürünün birimi'></br>
                            7-<cf_get_lang dictionary_id='40247.Alış KDV'> : <cf_get_lang dictionary_id='44219.ürünü alıştaki kdv oranı'></br>
                            8-<cf_get_lang dictionary_id='40248.Satış KDV'> : <cf_get_lang dictionary_id='44220.ürünün satıştaki kdv oranı'></br>
                            9-<cf_get_lang dictionary_id='61559.Alış fiyatı (KDVli)'> : <cf_get_lang dictionary_id='63427.Ürün alış fiyatı kdv dahil'></br>
                            10-<cf_get_lang dictionary_id='37041.Alış Fiyatı'>(<cf_get_lang dictionary_id="30024.KDVsiz">) : <cf_get_lang dictionary_id='63428.ürün alış fiyatı kdv hariç(alış fiyatlarının ikiside dolu ise kdvsiz fiyat kullanılır)'></br>
                            11-<cf_get_lang dictionary_id='44223.Alış Para Birimi: Alış fiyatının para birimi (Girilmezse YTL kaydedilir)'></br>
                            12-<cf_get_lang dictionary_id='32763.Satış Fiyatı'>(<cf_get_lang dictionary_id='58716.KDVli'>) : <cf_get_lang dictionary_id='44225.ürünün kdv dahil satış fiyatı'></br>
                            13-<cf_get_lang dictionary_id='32763.Satış Fiyatı'>(<cf_get_lang dictionary_id='30024.KDVsiz'>) : <cf_get_lang dictionary_id='44227.ürünün kdvsiz satış fiyatı (satış fiyatlarından ikiside dolu ise kdvli fiyat kullanılır)'></br>
                            14-<cf_get_lang dictionary_id='44228.Satış Para Birimi'> : <cf_get_lang dictionary_id='44229.Satış fiyatının para birimi (Girilmezse YTL kaydedilir)'></br>
                            15-<cf_get_lang dictionary_id='57486.Kategori'> : <cf_get_lang dictionary_id='44230.product_catid (Belgede Girilmeyecek ise formdaki default değerler girilmeli)'></br>
                            16-<cf_get_lang dictionary_id='29533.Tedarikçi'> : <cf_get_lang dictionary_id='42055.Cari Kodu (C12 gibi girilmezse boş bırakılır)'></br>
                            17-<cf_get_lang dictionary_id='37379.Üretici Ürün Kodu'> : <cf_get_lang dictionary_id='44233.üreticinin ürün kodu'> - <cf_get_lang dictionary_id='58909.Max'> : 100 <cf_get_lang dictionary_id='39797.Karakter'></br>
                            18-<cf_get_lang dictionary_id='37372.Fiyat Yetkisi'> : <cf_get_lang dictionary_id='44235.Ürünün fiyat yetkisi (id girilmelidir)'></br>
                            19-<cf_get_lang dictionary_id='57482.Aşama'> : <cf_get_lang dictionary_id='44236.Ürünün hangi aşamaya kaydedileceği (aşamanın id si girilmelidir)'></br>
                            20-<cf_get_lang dictionary_id='57789.Özel Kod'> : <cf_get_lang dictionary_id='44237.Ürünün müşterideki kodu'></br>
                            21-<cf_get_lang dictionary_id='58847.Marka'> <cf_get_lang dictionary_id='58527.ID'> : <cf_get_lang dictionary_id='44238.Marka ID sini yazınız'></br>
                            22-<cf_get_lang dictionary_id='58225.Model'> : <cf_get_lang dictionary_id='44941.Model Id sini giriniz'></br>
                            23-<cf_get_lang dictionary_id='36199.Açıklama'> :</br>
                            24-<cf_get_lang dictionary_id='36199.Açıklama'> 2 :</br>
                            25-<cf_get_lang dictionary_id='32512.Envanter'> : <cf_get_lang dictionary_id='45077.Envantere dahil İse 1, değilse 0 girilmelidir. Eğer değer girilmezse barkodu dolu olan ürünler envantere dahil olarak yazılır.'></br>
                            26-<cf_get_lang dictionary_id='57456.Üretim'> : <cf_get_lang dictionary_id='63305.Üretimde İse 1, değilse 0 girilmelidir. Eğer değer girilmezse üretimde değildir'></br>
                            27-<cf_get_lang dictionary_id='57448.Satış'> : <cf_get_lang dictionary_id='63308.Satışta ise 1, değilse 0 girilmelidir. Eğer değer girilmezse satışta değildir.'></br>
                            28-<cf_get_lang dictionary_id='29745.Tedarik'> : <cf_get_lang dictionary_id='63309.Tedarikte ise 1, değilse 0 girilmelidir. Eğer değer girilmezse tedarikte değildir.'></br>
                            29-<cf_get_lang dictionary_id='58079.İnternet'> : <cf_get_lang dictionary_id='63310.İnternet varsa 1, yoksa 0 girilmelidir. Eğer değer girilmezse yoktur.'></br>
                            30-<cf_get_lang dictionary_id='58019.Extranet'> : <cf_get_lang dictionary_id='63311.Extranet varsa 1, yoksa 0 girilmelidir. Eğer değer girilmezse yoktur.'></br>
                            31-<cf_get_lang dictionary_id='37558.Sıfır Stok İle Çalış'> : <cf_get_lang dictionary_id='63312.Sıfır Stok ile Çalış  ise 1 , yoksa 0 girilmelidir. Eğer değer girilmezse yoktur.'></br>
                            32-<cf_get_lang dictionary_id='33055.Stoklarla Sınırlı'> : <cf_get_lang dictionary_id='63313.Stoklarla Sınırlı ise 1, yoksa 0 girilmelidir. Eğer değer girilmezse yoktur.'></br>
                            33-<cf_get_lang dictionary_id='32063.Kalite'> : <cf_get_lang dictionary_id='63314.Kalite takip ediliyor ise 1, yoksa 0 girilmelidir. Eğer değer girilmezse yoktur.'></br>
                            34-<cf_get_lang dictionary_id='63315.Minimum Marj'></br>
                            35-<cf_get_lang dictionary_id='63316.Maximum Marj'></br>
                            36-<cf_get_lang dictionary_id='38372.Muhasebe Kod Grubu'> : <cf_get_lang dictionary_id='63297.Id Girilmelidir'></br>
                            37-<cf_get_lang dictionary_id='32538.Raf Ömrü'></br>
                            38-<cf_get_lang dictionary_id='57713.Boyut'> : <cf_get_lang dictionary_id='63317.Birim tanımındaki boyut bilgisidir.'></br>
                            39-<cf_get_lang dictionary_id='30114.Hacim'> : <cf_get_lang dictionary_id='63318.Birim tanımındaki hacim bilgisidir.'></br>
                            40-<cf_get_lang dictionary_id='29784.Ağırlık'> : <cf_get_lang dictionary_id='63319.Birim tanımındaki ağırlık bilgisidir.'></br>
                            41-<cf_get_lang dictionary_id='32095.Hedef Pazar'> : <cf_get_lang dictionary_id='63320.Ürün Hedef Pazar Id'></br>
                            42-<cf_get_lang dictionary_id='50923.BSMV'> : <cf_get_lang dictionary_id='63321.Ürüne uygulanacak BSMV oranı. Eğer değer girilmezse yoktur.'></br>
                            43-<cf_get_lang dictionary_id='50982.ÖİV'> : <cf_get_lang dictionary_id='63322.Ürüne uygulanacak ÖİV oranı. Eğer değer girilmezse yoktur.'></br>
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
        function get_branch_list(gelen)
        {
            var val_list = $("#comp_id").val();
            $('#branch').empty();
            var get_branch_name = wrk_safe_query('rpr_get_branch_dep_name','dsn',0,val_list);
            for ( var i = 0; i < get_branch_name.recordcount; i++ ) {
                    $("#branch").append('<option value='+get_branch_name.BRANCH_ID[i]+'>'+get_branch_name.BRANCH_NAME[i]+'</option>');
                }
        }
    
        function kontrol()
        {
            if(formimport.uploaded_file.value.length==0)
            {
                alert("<cf_get_lang dictionary_id='43930.İmport Edilecek Belge Girmelisiniz'>!");
                return false;
            }
            return true;
        }
    </script>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
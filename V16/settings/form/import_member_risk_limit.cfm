<cfinclude template="../query/get_our_companies.cfm">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Üye Risk Bilgileri İmport','58532')#">
        <cfform name="formimport" action="" enctype="multipart/form-data" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format">
                                <option value="UTF-8"><cf_get_lang dictionary_id='55929.UTF-8'></option>
                            </select>
                        </div>
                    </div>  
                    <div class="form-group" id="item-file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">
                        </div>
                    </div>    
                    <div class="form-group" id="item-example_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <a href="/IEF/standarts/import_example_file/uye_risk_bilgileri_aktarimi.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                        </div>
                    </div>   
                    <div class="form-group" id="item-company">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="our_company" id="our_company">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="our_company">
                                    <option value="#comp_id#">#company_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>     
                    <div class="form-group" id="item-company">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58531.Aktarım Formatı'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="import_format" id="import_format">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1"><cf_get_lang dictionary_id='30266.Kurumsal'> - <cf_get_lang dictionary_id='57558.Üye No'></option>
                                <option value="2"><cf_get_lang dictionary_id='30266.Kurumsal'> - <cf_get_lang dictionary_id='43937.Cari Özel Kod'></option>
                                <option value="3"><cf_get_lang dictionary_id='30266.Kurumsal'> - <cf_get_lang dictionary_id='57752.Vergi No'></option>
                                <option value="4"><cf_get_lang dictionary_id='57256.Bireysel'> - <cf_get_lang dictionary_id='57558.Üye No'></option>
                                <option value="5"><cf_get_lang dictionary_id='57256.Bireysel'> - <cf_get_lang dictionary_id='58025.TC Kimlik No'></option>
                                <option value="6"><cf_get_lang dictionary_id='57256.Bireysel'> - <cf_get_lang dictionary_id='57789.Özel Kod'></option>
                            </select>
                        </div>
                    </div>                                                                                  
                </div>     
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                    </div>      
                    <div class="form-group" id="item-exp1">
                        <cf_get_lang dictionary_id='57629.Açıklama'>:
                    </div>     
                    <div class="form-group" id="item-exp2">
                        <cf_get_lang dictionary_id='44342.Dosya uzantısı csv olmalı,alan araları noktalı virgül (;) ile ayrılmalı ve kaydedilirken karakter desteği olarak UTF-8 seçilmelidir'>                                              
                    </div>  
                    <div class="form-group" id="item-exp3">
                        <cf_get_lang dictionary_id='54238.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır.'>                        
                    </div>    
                    <div class="form-group" id="item-exp4">
                        <cf_get_lang dictionary_id='44359.Üye risk bilgilerinin geçerli olacağı şirket formdan seçilmelidir'>                    </div> 
                    <div class="form-group" id="item-exp5">
                        <cf_get_lang dictionary_id='44951.Bu belgede olması gereken alan sayısı'> : 17
                    </div> 
                    <div class="form-group" id="item-exp6">
                        <cf_get_lang dictionary_id='53860.Alanlar sırasıyla'>;
                    </div>      
                    <div class="form-group" id="item-exp7">
                        1-<cf_get_lang dictionary_id='57519.Cari Hesap'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)  : <cf_get_lang dictionary_id='44350.Aktarım sırasında formdan seçtiğiniz formata göre üye no özel kod  vergi no veya tc kimlik no olmalıdır'> .<br/>
                        2-<cf_get_lang dictionary_id='57482.Aşama'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) : <cf_get_lang dictionary_id='44361.Üye risk sürecinin satır ID si'>.<br/>
                        3-<cf_get_lang dictionary_id='44362.Alış Ödeme Yöntemi : Üye için tanımlanmış alış ödeme yöntemi varsa ID si girilmelidir'>.<br/>
                        4-<cf_get_lang dictionary_id='44363.Satış Ödeme Yöntemi : Üye için tanımlanmış satış ödeme yöntemi varsa ID si girilmelidir'>. <cf_get_lang dictionary_id='44364.Alış ve satış ödeme yöntemlerinin ikisi de boş olamaz biri mutlaka dolu olmalıdır'>.<br/>
                        5-<cf_get_lang dictionary_id='44365.Sevk Yöntemi : Üye için tanımlanmış sevk yöntemi varsa ID si girilmelidir'>.<br/>
                        6-<cf_get_lang dictionary_id='44366.Taşıyıcı Firma : Üyenin çalıştığı taşıyıcı firma varsa ID si girilmelidir'>.<br/>
                        7- **<cf_get_lang dictionary_id='44367.Açık Hesap Limiti İşlem Dövizli(Zorunlu) : Float olarak üyenin açık hesap limiti işlem para birimi cinsinden girilmelidir'>. <cf_get_lang dictionary_id='44368.Limit olmayan üyeler için 0 girilmelidir. Örn : 20065'><br/>
                        8- **<cf_get_lang dictionary_id='44369.Vadeli Ödeme Aracı Limiti İşlem Dövizli'>(<cf_get_lang dictionary_id='29801.Zorunlu'>)  : <cf_get_lang dictionary_id='44370.Float olarak üyenin açık hesap limiti işlem para birimi cinsinden girilmelidir. Limit olmayan üyeler için 0 girilmelidir. Örn : 31065'> <br/>
                        9-<cf_get_lang dictionary_id='44372.İşlem Para Birimi (Zorunlu) :Text olarak limit değerlerinin işlem dövizi girilmelidir. Örn : USD'><br/>
                        10-<cf_get_lang dictionary_id='44373.Açık Hesap Limiti Sistem Dövizli: Float olarak üyenin açık hesap limiti sistem para birimi cinsinden girilebilir'>.<cf_get_lang dictionary_id='44375.Girilmezse işlem dövizli değer baz alınarak bugünün kurundan hesaplanır'>.<br/>
                        11-<cf_get_lang dictionary_id='44374.Vadeli Ödeme Aracı Limiti Sistem Dövizli: Float olarak üyenin vadeli ödeme aracı limiti sistem para birimi cinsinden girilebilir'>.<cf_get_lang dictionary_id='44375.Girilmezse işlem dövizli değer baz alınarak bugünün kurundan hesaplanır'>.<br/>
                        12-<cf_get_lang dictionary_id='44376.Erken Ödeme İndirimi : Erken ödeme indirimi virgülden sonra basamak olacak şekilde float olarak girilebilir. Örn : 265'><br/>
                        13-<cf_get_lang dictionary_id='44377.Vade Farkı : Vade Farkı virgülden sonra basamak olacak şekilde float olarak girilebilir. Örn : 065'><br/>
                        14-<cf_get_lang dictionary_id='44378.Ödeme Blokajı : Ödeme Blokajı virgülden sonra basamak olacak şekilde float olarak girilebilir. Örn: 165'><br/>
                        15-<cf_get_lang dictionary_id='44379.Fiyat Listesi : Üye için tanımlanan fiyat listesi varsa ID si girilebilir'>.<br/>
                        16-<cf_get_lang dictionary_id='44380.Taksitli İşlem : Üye taksitli işlem yapıyorsa 1 yapmıyorsa 0 girilmelidir Boş gelirse 0 atanır'>.<br/>
                        17-<cf_get_lang dictionary_id='51036.Kur Tipi'>(1:<cf_get_lang dictionary_id='58176.Alış'>, 2:<cf_get_lang dictionary_id='57448.Satış'>, 3:<cf_get_lang dictionary_id='32368.Efektif Alış'>, 4:<cf_get_lang dictionary_id='30760.Efektif Satış'>)                        
                    </div>   
                    <div class="form-group" id="item-exp8">
                        **<cf_get_lang dictionary_id='44371.Açık Hesap ve Vadeli Ödeme Aracı Limitleri aynı işlem dövizi cinsinden girilmelidir'>
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
	if(formimport.our_company.value.length== '')
	{
		alert("<cf_get_lang dictionary_id='55700.Şirket Seçmelisiniz'>!");
		return false;
	}
	if(formimport.import_format.value.length== '')
	{
		alert("<cf_get_lang dictionary_id='43942.Aktarım Formatı Seçmelisiniz'>!");
		return false;
	}
	windowopen('','small','cc_che');
	formimport.action='<cfoutput>#request.self#?fuseaction=settings.emptypopup_add_member_risk_import</cfoutput>';
	formimport.target='cc_che';
	formimport.submit();
	return false;
}
</script>


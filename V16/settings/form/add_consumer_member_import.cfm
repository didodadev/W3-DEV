<!--- Bireysel Uye Import hgul 20111010 --->
<!--- Bireysel Uye Import hgul 20111010 --->
<cfquery name="PERIODS" datasource="#DSN#">
	SELECT PERIOD_ID,PERIOD FROM SETUP_PERIOD ORDER BY PERIOD
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Bireysel Üye Aktarım','45160')#">
        <cfform name="formimport" action="#request.self#?fuseaction=settings.emptypopup_consumer_member_import" enctype="multipart/form-data" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format">
                                <option value="utf-8"><cf_get_lang dictionary_id='32802.UTF-8'></option>
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
                            <a  href="/IEF/standarts/import_example_file/Bireysel_uye_Aktarimi.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                        </div>
                    </div>      
                    <div class="form-group" id="item-period">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="period_id" id="period_id">
                                <cfoutput query="periods">
                                    <option value="#period_id#" <cfif periods.period_id eq session.ep.period_id> selected</cfif>>#period#</option>
                                </cfoutput>
                            </select>                        
                        </div>
                    </div>    
                    <div class="form-group" id="item-potential">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <input type="checkbox" name="ispotential" id="ispotential" value="1" tabindex="5"><cf_get_lang dictionary_id='57577.Potansiyel'>
                        </label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12"></div>        
                    </div>     
                    <div class="form-group" id="item-potential">
                        <input type="checkbox" name="is_consumer_name_control" id="is_consumer_name_control" value="1" tabindex="6"><cf_get_lang dictionary_id='63214.Aynı İsimli Bireysel Üyeler İmport Edilebilsin'>         
                    </div>     
                    <div class="form-group" id="item-tc">
                        <input type="checkbox" name="is_tcnum_control" id="is_tcnum_control" value="1" tabindex="6"><cf_get_lang dictionary_id='63215.Aynı TC Kimlik Nolu Bireysel Üyeler İmport Edilebilsin'>       
                    </div>                                 
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">            
					<div class="form-group" id="item-format">
						<label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
					</div>  
                    <div class="form-group" id="item-exp1">
						<cf_get_lang dictionary_id='35657.Dosya uzantısı csv olmalı ve alan araları virgül (;) ile ayrılmalıdır'>
					</div>  
                    <div class="form-group" id="item-exp2">
						<cf_get_lang dictionary_id='63216.Belgede toplam 71 alan olacaktır'>
					</div>  
                    <div class="form-group" id="item-exp3">
                        <cf_get_lang dictionary_id='44197.Alanlar sırasıyla'>;
                    </div>
                    <div class="form-group" id="item-exp4">
                        1-<cf_get_lang dictionary_id='57897.Adı'>(*)</br>
                        2-<cf_get_lang dictionary_id='58550.Soyadı'>(*)</br>
                        3-<cf_get_lang dictionary_id='58609.Üye Kategorisi'>(*)(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        4-<cf_get_lang dictionary_id='57482.Aşama'>(*)(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        5-<cf_get_lang dictionary_id='58025.TC Kimlik No'></br>
                        6-<cf_get_lang dictionary_id='57789.Özel Kod'></br>
                        7-<cf_get_lang dictionary_id='58552.Müşteri Değeri'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        8-<cf_get_lang dictionary_id='31263.Ev Adresi'>-<cf_get_lang dictionary_id='58219.Ülke'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        9-<cf_get_lang dictionary_id='31263.Ev Adresi'>-<cf_get_lang dictionary_id='57971.Şehir'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        10-<cf_get_lang dictionary_id='31263.Ev Adresi'>-<cf_get_lang dictionary_id='58638.İlçe'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        11-<cf_get_lang dictionary_id='31263.Ev Adresi'>-<cf_get_lang dictionary_id='58132.Semt'></br>
                        12-<cf_get_lang dictionary_id='31263.Ev Adresi'>-<cf_get_lang dictionary_id='58735.Mahalle'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        13-<cf_get_lang dictionary_id='31263.Ev Adresi'>-<cf_get_lang dictionary_id='32306.Adres Detay'></br>
                        14-<cf_get_lang dictionary_id='31263.Ev Adresi'>-<cf_get_lang dictionary_id='57472.Posta Kodu'></br>
                        15-<cf_get_lang dictionary_id='31263.Ev Adresi'>-<cf_get_lang dictionary_id='44177.Tel Alan Kodu'>(<cf_get_lang dictionary_id='63183.5 haneli'>)</br>
                        16-<cf_get_lang dictionary_id='31263.Ev Adresi'>-<cf_get_lang dictionary_id='49272.Tel'>(<cf_get_lang dictionary_id='63184.10 haneli'>)</br>
                        17-<cf_get_lang dictionary_id='32508.E-mail'></br>
                        18-<cf_get_lang dictionary_id='63217.İnternet Adresi'></br>
                        19-<cf_get_lang dictionary_id='44178.Cep Tel Alan Kodu'></br>
                        20-<cf_get_lang dictionary_id='35459.Cep Tel.'></br>
                        21-<cf_get_lang dictionary_id='32872.Cinsiyeti'>(<cf_get_lang dictionary_id='44174.Bay - Bayan'>)</br>
                        22-<cf_get_lang dictionary_id='57574.Şirket'></br>
                        23-<cf_get_lang dictionary_id='32332.Görev'>/<cf_get_lang dictionary_id='58497.Pozisyon'> <cf_get_lang dictionary_id='57989.ve'> <cf_get_lang dictionary_id='57571.Ünvan'></br>
                        24-<cf_get_lang dictionary_id='35449.Departman'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        25-<cf_get_lang dictionary_id='57579.Sektör'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        26-<cf_get_lang dictionary_id='30500.Meslek Tipi'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        27-<cf_get_lang dictionary_id='31991.İş Adresi'>-<cf_get_lang dictionary_id='58219.Ülke'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        28-<cf_get_lang dictionary_id='31991.İş Adresi'>-<cf_get_lang dictionary_id='57971.Şehir'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        29-<cf_get_lang dictionary_id='31991.İş Adresi'>-<cf_get_lang dictionary_id='58638.İlçe'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        30-<cf_get_lang dictionary_id='31991.İş Adresi'>-<cf_get_lang dictionary_id='58132.Semt'></br>
                        31-<cf_get_lang dictionary_id='31991.İş Adresi'>-<cf_get_lang dictionary_id='58735.Mahalle'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        32-<cf_get_lang dictionary_id='31991.İş Adresi'>-<cf_get_lang dictionary_id='32306.Adres Detay'></br>
                        33-<cf_get_lang dictionary_id='31991.İş Adresi'>-<cf_get_lang dictionary_id='57472.Posta Kodu'></br>
                        34-<cf_get_lang dictionary_id='58815.İş Telefonu'>-<cf_get_lang dictionary_id='35668.Alan Kodu'></br>
                        35-<cf_get_lang dictionary_id='58815.İş Telefonu'></br>
                        36-<cf_get_lang dictionary_id='31991.İş Adresi'>-<cf_get_lang dictionary_id='63218.Fax Kodu'></br>
                        37-<cf_get_lang dictionary_id='31991.İş Adresi'>-<cf_get_lang dictionary_id='57488.Fax'></br>
                        38-<cf_get_lang dictionary_id='58830.İlişki Şekli'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        39-<cf_get_lang dictionary_id='44172.Vergi Dairesi İsmi'></br>
                        40-<cf_get_lang dictionary_id='57752.Vergi No'></br>
                        41-<cf_get_lang dictionary_id='32270.Fatura Adresi'></br>
                        42-<cf_get_lang dictionary_id='32270.Fatura Adresi'><cf_get_lang dictionary_id='58219.Ülke'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        43-<cf_get_lang dictionary_id='32270.Fatura Adresi'>-<cf_get_lang dictionary_id='57971.Şehir'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        44-<cf_get_lang dictionary_id='32270.Fatura Adresi'>-<cf_get_lang dictionary_id='58638.İlçe'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        45-<cf_get_lang dictionary_id='32270.Fatura Adresi'>-<cf_get_lang dictionary_id='58132.Semt'></br>
                        46-<cf_get_lang dictionary_id='32270.Fatura Adresi'>-<cf_get_lang dictionary_id='58735.Mahalle'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        47-<cf_get_lang dictionary_id='32270.Fatura Adresi'>-<cf_get_lang dictionary_id='32306.Adres Detay'></br>
                        48-<cf_get_lang dictionary_id='32270.Fatura Adresi'>-<cf_get_lang dictionary_id='57472.Posta Kodu'></br>
                        49-<cf_get_lang dictionary_id='44188.Not Başlığı'></br>   
                        50-<cf_get_lang dictionary_id='57467.Not'></br>       
                        51-<cf_get_lang dictionary_id='63187.2. Not Başlığı'></br>          
                        52-<cf_get_lang dictionary_id='63188.2. Not'></br>
                        53-<cf_get_lang dictionary_id='33915.Üye Kodu'></br>
                        54-<cf_get_lang dictionary_id='30448.Üyelik Başlama Tarihi'></br>
                        55-<cf_get_lang dictionary_id='30489.Sosyal Güvenlik Kurumu'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        56-<cf_get_lang dictionary_id='31245.Sosyal Güvenlik No'></br>
                        57-<cf_get_lang dictionary_id='58441.Kan Grubu'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        58-<cf_get_lang dictionary_id='34657.Anne Adı'></br>
                        59-<cf_get_lang dictionary_id='58033.Baba Adı'></br>
                        60-<cf_get_lang dictionary_id='57659.Satış Bölgesi'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        61-<cf_get_lang dictionary_id='57908.Temsilci'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        62-<cf_get_lang dictionary_id='57551.Kullanıcı Adı'></br>
                        63-<cf_get_lang dictionary_id='57552.Şifre'></br>
                        64-<cf_get_lang dictionary_id='63222.Yetki Verilecek Site'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        65-<cf_get_lang dictionary_id='58727.Doğum Tarihi'></br>
                        66-<cf_get_lang dictionary_id='63223.E-posta İle Haberdar Olmak İstiyorum'>(<cf_get_lang dictionary_id='57495.Evet'>-<cf_get_lang dictionary_id='57496.Hayır'>)</br>
                        67-<cf_get_lang dictionary_id='63224.SMS İle Haberdar Olmak İstiyorum'>(<cf_get_lang dictionary_id='57495.Evet'>-<cf_get_lang dictionary_id='57496.Hayır'>)</br>
                        68-<cf_get_lang dictionary_id='57493.Aktif'>(<cf_get_lang dictionary_id='57495.Evet'>-<cf_get_lang dictionary_id='57496.Hayır'>)</br>
                        69-<cf_get_lang dictionary_id='63225.Referans Üye Kodu'></br>
                        70-<cf_get_lang dictionary_id='30200.Üye Özel Tanımı'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)</br>
                        71-<cf_get_lang dictionary_id='59876.Kep Adresi'>
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
		if(document.formimport.uploaded_file.value.length==0)
		{
			alert("<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'>!");
			return false;
		}
		if(document.formimport.period_id.value.length ==0)
		{
			alert("<cf_get_lang dictionary_id='43274.Dönem Seçmelisiniz'>");
			return false;
		}
		return true;
	}
</script>
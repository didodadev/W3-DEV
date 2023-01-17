<!--- sanal poslardan bankalardan alınmış olan hata dönüş kodlarıdır(işlem onay almadığı durumlar için) ,yapıkredi için kendi dönüş kodunda vardır..Ayşenur20080328 --->
<cfif pos_type eq 7><!--- vakıfbank --->
	<cfif attributes.response_code eq "69">
		<cfset response_code_detail = "Eksik Parametre!">
	<cfelseif attributes.response_code eq "68">
		<cfset response_code_detail = "Hatalı İşlem Tipi!">
	<cfelseif attributes.response_code eq "67">
		<cfset response_code_detail = "Parametre Uzunluklarında Uyuşmazlık!">
	<cfelseif attributes.response_code eq "66">
		<cfset response_code_detail = "Numeric Değer Hatası!">
	<cfelseif attributes.response_code eq "65">
		<cfset response_code_detail = "Hatalı Tutar!">
	<cfelseif attributes.response_code eq "64">
		<cfset response_code_detail = "İşlem Tipi Taksit'e Uygun Değil!">
	<cfelseif attributes.response_code eq "63">
		<cfset response_code_detail = "Request Mesajında İllegal Karakter Var!">
	<cfelseif attributes.response_code eq "62">
		<cfset response_code_detail = "Yetkisiz ya da Tanımsız Kullanıcı!">
	<cfelseif attributes.response_code eq "61">
		<cfset response_code_detail = "Hatalı Tarih!">
	<cfelseif attributes.response_code eq "60">
		<cfset response_code_detail = "Hareket Bulunamadı!">
	<cfelseif attributes.response_code eq "59">
		<cfset response_code_detail = "Günsonu Yapilacak Hareket Yok!">
	<cfelseif attributes.response_code eq "90">
		<cfset response_code_detail = "Kayıt Bulunamadı!">
	<cfelseif attributes.response_code eq "91">
		<cfset response_code_detail = "Transaction Hatası!">
	<cfelseif attributes.response_code eq "92">
		<cfset response_code_detail = "Insert Update Hatası!">
	<cfelseif attributes.response_code eq "96">
		<cfset response_code_detail = "DLL Hatası!">
	<cfelseif attributes.response_code eq "97">
		<cfset response_code_detail = "IP Hatası!">
	<cfelseif attributes.response_code eq "98">
		<cfset response_code_detail = "İletişim Hatası!">
	<cfelseif attributes.response_code eq "99">
		<cfset response_code_detail = "Bağlantı Hatası!">
	<cfelseif attributes.response_code eq "70">
		<cfset response_code_detail = "XCIP Hatalı!">
	<cfelseif attributes.response_code eq "71">
		<cfset response_code_detail = "Üye İşyeri Blokeli ya da Tanımsız!">
	<cfelseif attributes.response_code eq "72">
		<cfset response_code_detail = "Tanımsız POS!">
	<cfelseif attributes.response_code eq "73">
		<cfset response_code_detail = "POS Table Update Hatası!">
	<cfelseif attributes.response_code eq "76">
		<cfset response_code_detail = "Taksit'e Kapalı!">
	<cfelseif attributes.response_code eq "74">
		<cfset response_code_detail = "Hatalı Taksit Sayısı!">
	<cfelseif attributes.response_code eq "75">
		<cfset response_code_detail = "Illegal State!">
	<cfelseif attributes.response_code eq "85">
		<cfset response_code_detail = "Kayit Reversal Durumda!">
	<cfelseif attributes.response_code eq "86">
		<cfset response_code_detail = "Kayit Değiştirilemez!">
	<cfelseif attributes.response_code eq "87">
		<cfset response_code_detail = "Kayit Iade Durumda!">
	<cfelseif attributes.response_code eq "88">
		<cfset response_code_detail = "Kayit İptal Durumda!">
	<cfelseif attributes.response_code eq "89">
		<cfset response_code_detail = "Geçersiz Kayıt!">
	<cfelse>
		<cfset response_code_detail = "Dönüş Kodu :" & "#attributes.response_code#">
	</cfif>
<cfelseif pos_type eq 8><!--- garanti --->
	<cfset response_code_detail = "Dönüş Kodu :" & "#attributes.response_code#">
	<cfswitch expression = "#attributes.response_code#">
		<cfcase value="1,2"><cfset response_code_detail="Bankasından Provizyon Alınız"></cfcase>
		<cfcase value="3"><cfset response_code_detail="Üye İşyeri Kategori Kodu Hatalı"></cfcase>
		<cfcase value="4"><cfset response_code_detail="Karta El Koyunuz"></cfcase>
		<cfcase value="5"><cfset response_code_detail="İşlem Onaylanmadı"></cfcase>
		<cfcase value="6"><cfset response_code_detail="İşleminiz Kabul Edilmedi"></cfcase>
		<cfcase value="7"><cfset response_code_detail="Karta El Koyunuz"></cfcase>
		<cfcase value="8"><cfset response_code_detail="Kimliğini Kontrol Ederek İşlem Yapınız"></cfcase>
		<cfcase value="9"><cfset response_code_detail="Kart Yenilenmiş Müşteriden İsteyin"></cfcase>
		<cfcase value="10"><cfset response_code_detail="Yetkisiz İşlem"></cfcase>
		<cfcase value="11"><cfset response_code_detail="İşlem Gerçekleştirildi(VIP)"></cfcase>
		<cfcase value="12"><cfset response_code_detail="Geçersiz İşlem"></cfcase>
		<cfcase value="13"><cfset response_code_detail="Geçersiz Tutar"></cfcase>
		<cfcase value="14"><cfset response_code_detail="Kart Numarası Hatalı"></cfcase>
		<cfcase value="15"><cfset response_code_detail="Bankası Bulunamadı"></cfcase>
		<cfcase value="16"><cfset response_code_detail="Bakiye Yetersiz.Yarın Tekrar Deneyin"></cfcase>
		<cfcase value="17"><cfset response_code_detail="İşlem İptal Edildi"></cfcase>	
		<cfcase value="18"><cfset response_code_detail="Kapalı Kart.Tekrar Denemeyin"></cfcase>
		<cfcase value="19"><cfset response_code_detail="Bir Kere Daha Provizyon Talep Ediniz"></cfcase>
		<cfcase value="21"><cfset response_code_detail="İşlem İptal Edilemedi"></cfcase>	
		<cfcase value="25"><cfset response_code_detail="Böyle Bir Bilgi Bulunamadı"></cfcase>
		<cfcase value="28"><cfset response_code_detail="Orijinali Reddedilmiş/Dosya Servis Dışı"></cfcase>
		<cfcase value="29"><cfset response_code_detail="İptal Yapılamadı.(Orjinali Bulunamadı)"></cfcase>	
		<cfcase value="30"><cfset response_code_detail="Mesajın Formatı Hatalı"></cfcase>
		<cfcase value="32"><cfset response_code_detail="İşlem Kısmen Gerçekleştirilebildi"></cfcase>	
		<cfcase value="33"><cfset response_code_detail="Kartın Süresi Dolmuş!Karta El Koyunuz"></cfcase>	
		<cfcase value="34"><cfset response_code_detail="Muhtemelen Çalıntı Kart!ElKoyunuz"></cfcase>
		<cfcase value="36"><cfset response_code_detail="Sınırlandırılmış Kart!ElKoyunuz"></cfcase>
		<cfcase value="37"><cfset response_code_detail="Lütfen Banka Güvenliğini Arayınız"></cfcase>
		<cfcase value="38"><cfset response_code_detail="Şifre Giriş Limiti Aşıldı!ElKoyunuz"></cfcase>
		<cfcase value="39"><cfset response_code_detail="Kredi Hesabı Tanımsız"></cfcase>
		<cfcase value="41"><cfset response_code_detail="Kayıp Kart!Karta El Koyunuz"></cfcase>
		<cfcase value="43"><cfset response_code_detail="Çalıntı Kart!Karta El Koyunuz"></cfcase>
		<cfcase value="51"><cfset response_code_detail="Hesap Müsait Değil/Yetersiz Bakiye"></cfcase>
		<cfcase value="52"><cfset response_code_detail="Çek Hesabı Tanımsız"></cfcase>
		<cfcase value="53"><cfset response_code_detail="Hesap Tanımsız"></cfcase>
		<cfcase value="54"><cfset response_code_detail="Vadesi Dolmuş Kart/Kart Son Kullanım Tarihi Hatalı"></cfcase>
		<cfcase value="55"><cfset response_code_detail="Şifresi Hatalı"></cfcase>
		<cfcase value="56"><cfset response_code_detail="Bu Kart Mevcut Değil"></cfcase>
		<cfcase value="57"><cfset response_code_detail="Kart Sahibi Bu İşlemi Yapamaz"></cfcase>
		<cfcase value="58"><cfset response_code_detail="Bu İşlemi Yapmanıza Müsade Edilmiyor"></cfcase>
		<cfcase value="61"><cfset response_code_detail="Para Çekme Limiti Aşılıyor"></cfcase>
		<cfcase value="62"><cfset response_code_detail="Kısıtlı Kart/Kendi Ülkesinde Geçerli"></cfcase>
		<cfcase value="63"><cfset response_code_detail="Bu İşlemi Yapmaya Yetkili Değilsiniz"></cfcase>
		<cfcase value="65"><cfset response_code_detail="Günlük İşlem Adedi Dolmuş"></cfcase>
		<cfcase value="68"><cfset response_code_detail="Cevap Çok Geç Geldi.İşlemi İptal Ediniz"></cfcase>
		<cfcase value="75"><cfset response_code_detail="Şifre Giriş Limiti Aşıldı"></cfcase>
		<cfcase value="76"><cfset response_code_detail="Şifre Hatalı.Şifre Giriş Limiti Aşıldı"></cfcase>
		<cfcase value="77"><cfset response_code_detail="Orjinal İşlem ile Uyumsuz Bilgi Alındı"></cfcase>
		<cfcase value="80"><cfset response_code_detail="Hatalı Tarih./Network Hatası"></cfcase>
		<cfcase value="81"><cfset response_code_detail="Şifreleme/Yabancı Network Hatası"></cfcase>
		<cfcase value="82"><cfset response_code_detail="Hatalı CVV"></cfcase>
		<cfcase value="83"><cfset response_code_detail="Şifre Doğrulanamıyor./İletişim Hatası"></cfcase>
		<cfcase value="85"><cfset response_code_detail="Hesap Doğrulandı"></cfcase>
		<cfcase value="86"><cfset response_code_detail="Şifre Doğrulanamıyor"></cfcase>
		<cfcase value="88"><cfset response_code_detail="Şifreleme Hatası"></cfcase>
		<cfcase value="90"><cfset response_code_detail="Günsonu İşlemleri Yapılıyor"></cfcase>
		<cfcase value="91"><cfset response_code_detail="Bankasına Ulaşılamıyor"></cfcase>
		<cfcase value="92"><cfset response_code_detail="İşlem Gerekli Yere Yönlendirilemedi"></cfcase>
		<cfcase value="93"><cfset response_code_detail="Hukuki Nedenlerle İşleminiz Rededildi/Bonus Kullanım Hatası"></cfcase>
		<cfcase value="94"><cfset response_code_detail="Günlük Toplamlar Hatalı/İptal Reddedildi"></cfcase>
		<cfcase value="96"><cfset response_code_detail="Sistem Hatası"></cfcase>
		<cfcase value="99"><cfset response_code_detail="KrediKart Numarası Geçerli Değil/Kart Son Kullanım Tarihi Mantıksız/Kullanıcı Hatası"></cfcase>
	</cfswitch>
<cfelseif pos_type eq 11><!--- Türkiye Finans --->
	<cfset response_code_detail = "Dönüş Kodu :" & "#attributes.response_code#">
	<cfswitch expression = "#attributes.response_code#">
		<cfcase value="1,2"><cfset response_code_detail="Bankanızı Arayınız"></cfcase>
		<cfcase value="3"><cfset response_code_detail="Üye İşyeri Kategori Kodu Hatalı"></cfcase>
		<cfcase value="4"><cfset response_code_detail="Sahte kart"></cfcase>
		<cfcase value="5"><cfset response_code_detail="Provizyon Alınamadı"></cfcase>
		<cfcase value="6"><cfset response_code_detail="Isteminiz Kabul Edilmedi"></cfcase>
		<cfcase value="7"><cfset response_code_detail="Karta El Koyunuz"></cfcase>
		<cfcase value="8"><cfset response_code_detail="Kimliğini Kontrol Ederek İşlem Yapınız"></cfcase>
		<cfcase value="11"><cfset response_code_detail="İşlem Gerçekleştirildi(VIP)"></cfcase>
		<cfcase value="12"><cfset response_code_detail="Geçersiz İşlem"></cfcase>
		<cfcase value="13"><cfset response_code_detail="Meblağ Geçersiz"></cfcase>
		<cfcase value="14"><cfset response_code_detail="Kart Numarası Hatalı"></cfcase>
		<cfcase value="15"><cfset response_code_detail="BIN (Banka Kodu) Hatali"></cfcase>
		<cfcase value="17"><cfset response_code_detail="İşlem İptal Edildi"></cfcase>	
		<cfcase value="19"><cfset response_code_detail="Bir Kere Daha Provizyon Talep Ediniz"></cfcase>
		<cfcase value="20"><cfset response_code_detail="Geçersiz Yanit"></cfcase>
		<cfcase value="21"><cfset response_code_detail="İşlemin Aslina Dönülemediği İçin İşlem Gerçekleşmedi"></cfcase>
		<cfcase value="24"><cfset response_code_detail="Alici,Bu Islemi Yapmiyor"></cfcase>
		<cfcase value="25"><cfset response_code_detail="Böyle Bir Bilgi Bulunamadı"></cfcase>
		<cfcase value="26"><cfset response_code_detail="Bu Kayit Zaten Mevcut"></cfcase>
		<cfcase value="27"><cfset response_code_detail="Mesaj Formati Hatali"></cfcase>
		<cfcase value="28"><cfset response_code_detail="Daha Sonra İşlemi Yineleyiniz"></cfcase>
		<cfcase value="30"><cfset response_code_detail="Mesajin Formati Hatali"></cfcase>
		<cfcase value="32"><cfset response_code_detail="Islem Kismen Gerçeklestirilebildi,Iptal Ediniz"></cfcase>	
		<cfcase value="33"><cfset response_code_detail="Kartın Süresi Dolmuş!Karta El Koyunuz"></cfcase>	
		<cfcase value="34"><cfset response_code_detail="Muhtemelen Çalıntı Kart!ElKoyunuz"></cfcase>
		<cfcase value="38"><cfset response_code_detail="Şifre Giriş Limiti Aşıldı!ElKoyunuz"></cfcase>
		<cfcase value="41"><cfset response_code_detail="Kayıp Kart!Karta El Koyunuz"></cfcase>
		<cfcase value="43"><cfset response_code_detail="Çalıntı Kart!Karta El Koyunuz"></cfcase>
		<cfcase value="51"><cfset response_code_detail="Hesap Müsait Değil"></cfcase>
		<cfcase value="52"><cfset response_code_detail="Çek Hesabı Tanımsız"></cfcase>
		<cfcase value="53"><cfset response_code_detail="Hesap Tanımsız"></cfcase>
		<cfcase value="54"><cfset response_code_detail="Vadesi Dolmuş Kart/Kart Son Kullanım Tarihi Hatalı"></cfcase>
		<cfcase value="55"><cfset response_code_detail="Şifresi Hatalı"></cfcase>
		<cfcase value="56"><cfset response_code_detail="Bu Kart Mevcut Değil"></cfcase>
		<cfcase value="57"><cfset response_code_detail="Kart Sahibi Bu İşlemi Yapamaz"></cfcase>
		<cfcase value="58"><cfset response_code_detail="Bu İşlemi Yapmanıza Müsade Edilmiyor"></cfcase>
		<cfcase value="61"><cfset response_code_detail="Para Çekme Limiti Aşılıyor"></cfcase>
		<cfcase value="62"><cfset response_code_detail="Kısıtlı Kart/Kendi Ülkesinde Geçerli"></cfcase>
		<cfcase value="63"><cfset response_code_detail="Bu İşlemi Yapmaya Yetkili Değilsiniz"></cfcase>
		<cfcase value="65"><cfset response_code_detail="Günlük İşlem Adedi Dolmuş"></cfcase>
		<cfcase value="68"><cfset response_code_detail="Cevap Çok Geç Geldi.İşlemi İptal Ediniz"></cfcase>
		<cfcase value="75"><cfset response_code_detail="Şifre Giriş Limiti Aşıldı"></cfcase>
		<cfcase value="76"><cfset response_code_detail="Şifre Hatalı.Şifre Giriş Limiti Aşıldı"></cfcase>
		<cfcase value="77"><cfset response_code_detail="Orjinal İşlem ile Uyumsuz Bilgi Alındı"></cfcase>
		<cfcase value="80"><cfset response_code_detail="Hatalı Tarih./Network Hatası"></cfcase>
		<cfcase value="81"><cfset response_code_detail="Şifreleme/Yabancı Network Hatası"></cfcase>
		<cfcase value="82"><cfset response_code_detail="Yetersiz Bakiye"></cfcase>
		<cfcase value="83"><cfset response_code_detail="Şifre Doğrulanamıyor./İletişim Hatası"></cfcase>
		<cfcase value="85"><cfset response_code_detail="Hesap Doğrulanamıyor"></cfcase>
		<cfcase value="90"><cfset response_code_detail="Günsonu İşlemleri Yapılıyor"></cfcase>
		<cfcase value="91"><cfset response_code_detail="Bankasına Ulaşılamıyor"></cfcase>
		<cfcase value="92"><cfset response_code_detail="EM Kapali"></cfcase>
		<cfcase value="93"><cfset response_code_detail="Hukuki Nedenlerle Isleminiz Rededildi"></cfcase>
		<cfcase value="95"><cfset response_code_detail="Günlük Toplamlar hatali"></cfcase>
		<cfcase value="96,-1,99"><cfset response_code_detail="Sistem Hatası"></cfcase>
		<cfcase value="31"><cfset response_code_detail="Kayip / Çalinti Kart"></cfcase>
	</cfswitch>
<cfelseif pos_type eq 12><!--- Bank Asya --->
	<cfset response_code_detail = "Dönüş Kodu :" & "#attributes.response_code#">
	<cfswitch expression = "#attributes.response_code#">
		<cfcase value="0001"><cfset response_code_detail="Bankanızı Arayınız"></cfcase>
		<cfcase value="0002"><cfset response_code_detail="Bankanızı Arayınız"></cfcase>
		<cfcase value="0004"><cfset response_code_detail="Red-Karta El Koyunuz"></cfcase>
		<cfcase value="0005"><cfset response_code_detail="Red-Onaylanmadi"></cfcase>
		<cfcase value="0008"><cfset response_code_detail="Kimlik Kontrolü/Onay Kodu"></cfcase>
		<cfcase value="0011"><cfset response_code_detail="Onay kodu Bekleniyor"></cfcase>
		<cfcase value="0012"><cfset response_code_detail="Red-Geçersiz İşlem"></cfcase>
		<cfcase value="0013"><cfset response_code_detail="Red-Geçersiz Tutar"></cfcase>
		<cfcase value="0014"><cfset response_code_detail="Red-Hatalı Kart"></cfcase>
		<cfcase value="0015"><cfset response_code_detail="Red-Gecersiz Kart"></cfcase>
		<cfcase value="0030"><cfset response_code_detail="Bankanızı Arayınız"></cfcase>
		<cfcase value="0033,0034,0038,0041,0043,"><cfset response_code_detail="Red-Karta El Koyunuz"></cfcase>
		<cfcase value="0051"><cfset response_code_detail="Red-Yetersiz Bakiye"></cfcase>
		<cfcase value="0055"><cfset response_code_detail="Red-Şifre Tekrar"></cfcase>
		<cfcase value="0057,0058,0062,0065,0075"><cfset response_code_detail="Red-Onaylanmadı"></cfcase>
		<cfcase value="0091"><cfset response_code_detail="Red-Bağlantı Yok"></cfcase>
		<cfcase value="0092"><cfset response_code_detail="Red-Gecersiz Kart"></cfcase>
		<cfcase value="0096"><cfset response_code_detail="Red Bağlantı Yok"></cfcase>
		<cfcase value="1010,1020,1030,5000,5001,5002,5003,5101,5102,5103,5201,5301,5302,5303,5401,5402,5403,5501,5502,5503,5504,5601,5602,5603"><cfset response_code_detail="Sistem Hatası-Firmanıza Bildiriniz"></cfcase>
		<cfcase value="6000"><cfset response_code_detail="Hatalı İstek"></cfcase>
		<cfcase value="6010"><cfset response_code_detail="Tutar Sayısal Değil"></cfcase>
		<cfcase value="6011"><cfset response_code_detail="Para Birimi Değeri Sayısal Değil"></cfcase>
		<cfcase value="6012"><cfset response_code_detail="Kart Numarası Sayısal Değil"></cfcase>
		<cfcase value="6014"><cfset response_code_detail="Geçersiz Son Kullanım Tarihi"></cfcase>
		<cfcase value="6015"><cfset response_code_detail="Tutar 20000 YTLden Büyük"></cfcase>
		<cfcase value="6016"><cfset response_code_detail="İşlem Numarasi Kabul Edilemiyor"></cfcase>
		<cfcase value="6020"><cfset response_code_detail="Para Tipi Sistemde Tanımlı Değil"></cfcase>
		<cfcase value="6021"><cfset response_code_detail="Kart tipi Sistemde Tanımlı Değil"></cfcase>
		<cfcase value="6030"><cfset response_code_detail="Kart Son Kullanım Tarihi Geçmiş"></cfcase>
		<cfcase value="6040"><cfset response_code_detail="Firma Geçerli Değil"></cfcase>
		<cfcase value="6041"><cfset response_code_detail="Firma Şifresi Hatalı"></cfcase>
		<cfcase value="6042"><cfset response_code_detail="Firma Meşgul"></cfcase>
		<cfcase value="6050"><cfset response_code_detail="Terminal Geçerli Değil"></cfcase>
		<cfcase value="6051"><cfset response_code_detail="Terminal Meşgul"></cfcase>
		<cfcase value="6060"><cfset response_code_detail="Firma Bu İşlemi Gerçekleştirmek İçin Yetkili Değil"></cfcase>
		<cfcase value="6061"><cfset response_code_detail="Terminal Bu İşlemi Gerçeklestirmek İcin Yetkili Değil"></cfcase>
		<cfcase value="6062"><cfset response_code_detail="Kullanıcı Bu İşlemi Gerçeklestirmek İcin Yetkili Değil"></cfcase>
		<cfcase value="6070"><cfset response_code_detail="Sistem Hatası"></cfcase>
		<cfcase value="6071"><cfset response_code_detail="Sıra Numarası Oluşturulamıyor"></cfcase>
		<cfcase value="6072,6079,6080,6085,6086,6087,6088,6089,6090,6091,6093,6094,6095,6096,6097,7001"><cfset response_code_detail="Sistem Hatası"></cfcase>
		<cfcase value="6073"><cfset response_code_detail="Orjinal İşlem Bilgisi Boş"></cfcase>
		<cfcase value="6074"><cfset response_code_detail="Orjinal İşlem Değiştirilemez"></cfcase>
		<cfcase value="6075"><cfset response_code_detail="Değiştirilecek Tutar Orjinal İşlem Tutarından Büyük"></cfcase>
		<cfcase value="6076"><cfset response_code_detail="İşlem Süresi Geçmiş"></cfcase>
		<cfcase value="6077"><cfset response_code_detail="Orjinal İşlem Meşgul"></cfcase>
		<cfcase value="6078"><cfset response_code_detail="Orjinal İşlem Bulunamadı"></cfcase>
		<cfcase value="6081"><cfset response_code_detail="Zaman Aşımı"></cfcase>
		<cfcase value="6082,6083"><cfset response_code_detail="Bu İşlem Numarası ile Baska Bir İşlem Daha Önce Gerçekleşmiştir"></cfcase>
		<cfcase value="6084"><cfset response_code_detail="Uygun Para Birimi Bulunamadı"></cfcase>
		<cfcase value="6098"><cfset response_code_detail="İşlem Bilgisi Boş"></cfcase>
		<cfcase value="6099"><cfset response_code_detail="İşlem Alanları Orjinal İşlem ile Aynı Değil"></cfcase>
		<cfcase value="6100,6101"><cfset response_code_detail="Tutarda Birden Fazla Hane Ayracı Var"></cfcase>
		<cfcase value="6103"><cfset response_code_detail="Geçersiz Tutar Biçimi"></cfcase>
		<cfcase value="6104"><cfset response_code_detail="Firmaya Ait Terminal Bulunmuyor"></cfcase>
		<cfcase value="7000"><cfset response_code_detail="Zorunlu Alan Eksik"></cfcase>
		<cfcase value="7011"><cfset response_code_detail="Orjinal Kart Numarası ile Değişiklik İşlemi Pan Numarası Farklı"></cfcase>
		<cfcase value="7012"><cfset response_code_detail="Orjinal Son Kullanma Tarihi ile Değişiklik İşlemi Son Kullanma Tarihi Farklı"></cfcase>
		<cfcase value="7013"><cfset response_code_detail="Orjinal CVV Değeri ile Değisiklik İşlemi CVV Değeri Farklı"></cfcase>
		<cfcase value="7014"><cfset response_code_detail="Orjinal Otorizasyon Kodu ile Değişiklik İşlemi Otorizasyon Kodu Farklı"></cfcase>
		<cfcase value="7015"><cfset response_code_detail="Orjinal Para Kodu ile Değişiklik İşlemi Para Kodu Farklı"></cfcase>
		<cfcase value="7016"><cfset response_code_detail="Orjinal Taksit Sayisi ile Değişiklik İşlemi Taksit Sayisi Farklı"></cfcase>
		<cfcase value="7019"><cfset response_code_detail="Değişiklik İşlemi Tutari ile Orjinal İşlem Tutari Eşit Olmak Zorundadir"></cfcase>
		<cfcase value="9000"><cfset response_code_detail="İşlem Devam Ediyor"></cfcase>
		<cfcase value="9005"><cfset response_code_detail="Dahili Hata, POS Sıra Numarası Alınamadı"></cfcase>
		<cfcase value="9006,9997,9998,9999"><cfset response_code_detail="Sonuç Bildirilemedi,İşleminizi Takip Ediniz"></cfcase>
	</cfswitch>
<cfelse><!--- vakıfbank,garanti vs dışındaki est ile çalışanlar --->
	<cfif attributes.response_code eq "1">
		<cfset response_code_detail = "Kartı Veren Bankayı Arayınız!">
	<cfelseif attributes.response_code eq "3">
		<cfset response_code_detail = "Geçersiz Üye İşyeri!">
	<cfelseif attributes.response_code eq "4">
		<cfset response_code_detail = "İşlem Onaylanmadı!">
	<cfelseif attributes.response_code eq "5">
		<cfset response_code_detail = "İşlem Onaylanmadı!">
	<cfelseif attributes.response_code eq "8">
		<cfset response_code_detail = "Kimlik Kontrolu İle Onay Yapilmalıdır!">
	<cfelseif attributes.response_code eq "12">
		<cfset response_code_detail = "Geçersiz İşlem!">
	<cfelseif attributes.response_code eq "13">
		<cfset response_code_detail = "Geçersiz İşlem Tutarı!">
	<cfelseif attributes.response_code eq "14">
		<cfset response_code_detail = "Geçersiz Kart No!">
	<cfelseif attributes.response_code eq "15">
		<cfset response_code_detail = "Boyle Bir Kartı Veren Kuruluş Mevcut Değildir!">
	<cfelseif attributes.response_code eq "33">
		<cfset response_code_detail = "Kartınızın Kullanim Tarihi Geçmiş!">
	<cfelseif attributes.response_code eq "34">
		<cfset response_code_detail = "Sahte Kart!">
	<cfelseif attributes.response_code eq "38">
		<cfset response_code_detail = "Hatalı Şifre!">
	<cfelseif attributes.response_code eq "41">
		<cfset response_code_detail = "Kayıp Kart!">
	<cfelseif attributes.response_code eq "43">
		<cfset response_code_detail = "Çalıntı Kart!">
	<cfelseif attributes.response_code eq "51">
		<cfset response_code_detail = "Limitiniz Yeterli Değil!">
	<cfelseif attributes.response_code eq "54">
		<cfset response_code_detail = "Kartınızın Kullanim Tarihi Geçmiş!">
	<cfelseif attributes.response_code eq "55">
		<cfset response_code_detail = "Hatalı Pin Numarası!">
	<cfelseif attributes.response_code eq "56">
		<cfset response_code_detail = "Kart Tanımlı Değil!">
	<cfelseif attributes.response_code eq "57">
		<cfset response_code_detail = "Kart Sahibine İşlem İzni Verilmiyor!">
	<cfelseif attributes.response_code eq "58">
		<cfset response_code_detail = "Terminale İşlem İzni Verilmiyor!">
	<cfelseif attributes.response_code eq "59">
		<cfset response_code_detail = "Sahte Kart!">
	<cfelseif attributes.response_code eq "61">
		<cfset response_code_detail = "Limit Aşımı!">
	<cfelseif attributes.response_code eq "62">
		<cfset response_code_detail = "Sınırlandırılmış Kart!">
	<cfelseif attributes.response_code eq "63">
		<cfset response_code_detail = "Güvenlik İhlali!">
	<cfelseif attributes.response_code eq "75">
		<cfset response_code_detail = "İzin Verilen Pin Numarasi Denemesi Aşılmıştır!">
	<cfelseif attributes.response_code eq "84">
		<cfset response_code_detail = "Guvenlik kodu (CVV-CVC) Hatası!">
	<cfelseif attributes.response_code eq "91">
		<cfset response_code_detail = "Karti Veren Bankanin veya Aracilik Eden Kart Kuruluşunun Sistemi Çalışmıyor!">
	<cfelseif attributes.response_code eq "96">
		<cfset response_code_detail = "Sistem Arızası!">
	<cfelse>
		<cfset response_code_detail = "Dönüş Kodu :" & "#attributes.response_code#">
	</cfif>
</cfif>

<cfif isDefined('session.ww.userid')>  <!--- Parapuan tekerrürünü önlemek için eklendi. Olumsuz dönüşte parapuanlar siliniyor --->
	<cfquery name="DEL" datasource="#DSN3#">
		DELETE FROM ORDER_PRE_ROWS WHERE RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND PRODUCT_ID = -1
	</cfquery>
</cfif>

<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border">
	<tr class="color-list" valign="middle">
		<td height="35" class="headbold"><font size="+1"><cf_get_lang no ='1221.Tahsilat Bilgisi'> :</font></td>
	</tr>
	<tr class="color-row" valign="top">
		<td>
			<table>
				<cfif isDefined("attributes.response_code")><!--- session ı kaybettiği durumlarda hata vermesin diye --->
					<tr>
						<td><cfoutput><font size="+2">#response_code_detail#</font></cfoutput><br/></td>
					</tr>
				</cfif>
				<tr height="40">
					<td><cf_get_lang no ='1222.İşleminiz Onay Almamıştır'>.<br/><cf_get_lang no ='1223.Detaylı Bilgi İçin Müşteri Hizmetlerine Başvurabilirsiniz'>.</td>
				</tr>
				<cfif isDefined("attributes.order_related")>
					<tr height="35">
						<td>
							<!---<cfsavecontent variable="content"><cf_get_lang no='1225.Tekrar Ödeme'></cfsavecontent>
							<input type="button" style="width:85px;" value="<cfoutput>#content#</cfoutput>" onclick="window.history.back(-1);"> --->
							<cfif isdefined("attributes.is_repay_order") and attributes.is_repay_order eq 1>
								<br/><br/><input type="button" value="Ödeme Seçeneklerimi Değiştirmek İstiyorum" onclick="change_paym();">
							</cfif>
						</td>
					</tr>
				</cfif>
			</table>
		</td>
	</tr>
</table>
<cfif isDefined("attributes.order_related")>
	<script type="text/javascript">
		function change_paym()
		{
			if(confirm("Ödeme Seçeneklerinizi Değiştirmek İstediğinize Emin Misiniz?"))
				<cfoutput>window.location.href='http://#cgi.http_host#/#request.self#?fuseaction=objects2.form_add_orderww&is_add_orderww=1<cfif isDefined('attributes.grosstotal')>&grosstotal=#attributes.grosstotal#</cfif>';</cfoutput>
		}
	</script>
</cfif>


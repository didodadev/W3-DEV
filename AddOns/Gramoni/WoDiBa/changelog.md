# Changelog

All notable changes to this project will be documented here: http://release.workcube.com/index.cfm?fuseaction=objects.popup_about_workcube and summarized in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

----

## [1.4.5] => 2022-05-07

#### Improvements

- Manuel kayıt ekranında virman işlem tipi için bütçe merkezi ve bütçe kalemi zorunluluğu kaldırıldı.

#### Bugs

- [#130981](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=130981) Wodiba döviz virman işleminde sistem para birimi tutar hatası giderildi.

## [1.4.4] => 2021-12-31

#### Improvements

- Manuel kayıt ekranında kayıt eden kişinin Wodiba kullanıcısı değil de oturumdaki kullanıcıdan alınması sağlandı.

#### Bugs

- [#127701](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=127701) Wodiba manuel kayıt ekranında company_id banka işleminden gelen IBAN ya da VKN ile yeniden belirleniyordu, yeniden belirleme devre dışı bırakıldı.
- [#127602](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=127602) Wodiba Banka işlemlerini kayıt eden arka plan görevinde acc_type_id değeri varsayılan olarak -1 atılıyordu, devre dışı bırakıldı.
- [#127961](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=127961) Dövizli gelen giden havalelerde muhasebe kayıtlarındaki hata giderildi.
- [#128188](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=128188) Fatura kapama toplam tutarının fatura tutarını aşmaması için düzenleme yapıldı.

## [1.4.3] => 2021-11-01

#### New Features

- [#127451](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=127451) Wodiba API tanımları ekranına çoklu şirket özelliği getirildi.

#### Improvements

- Wodiba Banka Hesap Tanım ekranında Halkbank için şirket kodu alanı zorunlu hale getirildi.
- [#127825](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=127825) Wodiba Dövizli kredilerin TL ödenmesi durumunda kur farkı bedeli banka tarafından faiz olarak yansıtılır, ana para ödemesi ile aynı hesapta kayıt edilecek şekilde düzenleme yapıldı.

#### Bugs

- [#127153](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=127153) Wodiba manuel kayıt ekranında hata yönetimi düzenlemesi yapıldı.
- Wodiba Banka İşlemleri sayfalama tarih hatası giderildi.
- Wodiba Banka İşlemleri tutar aralık filtresinde bigint hatası giderildi.

## [1.4.2] => 2021-09-30

#### New Features

- [#126930](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=126930) Kural setine bankadan gelen açıklama alanındaki fatura numarasına göre carinin tespit edilmesi özelliği eklendi.

#### Improvements

- [#126079](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=126079) Wodiba Banka İşlemleri sayfasındaki GDPR özelliği hassaslık derecesi eğer işlem kayıtlı ise ve COMPANY ya da CONSUMER olarak tayin edilmiş ise Finansal Veri Gizli \(7\), diğer durumlar için Finansal Veri Çok Gizli \(7\) olarak belirlendi.

- [#126079](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=126079) Wodiba Banka İşlemi manuel kayıt ekranına GDPR özelliği eklendi.

- [#124655](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=124655) Wodiba Kredi Ödeme özelliği ödeme planı taksit gün aralığı 5 günden 10 güne çıkartıldı.

- [#126599](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=126599) Wodiba Garanti bankası mevduat işlemleri için işlem kodu kısıtlaması kaldırıldı.

- [#124842](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=124842) Wodiba kural seti tanım ekranına personel cari hesap tipi alanı eklendi.

- [#126930](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=126930) Muhasebe kaydının IFRS kodu ile birlikte atılabilmesi sağlandı.

- Hata yönetimi iyileştirildi.

- get_employee_period metodu hatalı çalıştığı için çalışan muhasebe hesabı tanımları sorgu ile alınacak şekilde düzenleme yapıldı.


## [1.4.1] => 2021-07-28

#### New Features

- [#124655](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=124655) Wodiba Kredi Ödeme özelliği eklendi.

#### Improvements
- [#124842](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=124842) VKN ve IBAN bazında cari eşlemesi yapılırken kurumsal üye, bireysel üye ya da çalışanın aktif/pasif kontrolü ve potansiyel olmaması kontrolü eklendi.
- Banka işleminin çalışana ait olması durumunda cari hesap tipi maaş olarak düzenlendi.
- [#126079](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=126079) Wodiba Banka İşlemleri sayfasına GDPR özelliği eklendi, hassaslık derecesi Finansal Veri Çok Gizli \(7\) olarak belirlendi.

## [1.3.1] => 2021-07-02

#### Bugs

- [#124645](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=124645) Cari muhasebe kodu belirleyememe durumu için get_company_period fonksiyonu yerine sorgu yazıldı.
- [#124537](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=124537) Virman işleminde karşı işlemi tespit eden fonksiyonda tip değişikliği yapıldı. Miktar alan tipi DOUBLE olarak değiştirildi.
- Muhasebe kaydının gerçekleştiği aşamalarda borç veya alacak hesaplardan biri tanımlı olmadığında muhasebe kaydını atmaması için kontrol eklendi.

#### New Features

- [#124580](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=124580) Wodiba Kredi Kartı Borcu Ödeme özelliği eklendi.
- Wodiba banka hesabını Gateway üzerinden silme özelliği eklendi

## [1.2.1] => 2021-07-01

#### New Features

- [#124561](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=124561) Wodiba Çek Ödeme özelliği eklendi.

## [1.1.1] => 2021-06-29

#### New Features

- [#123911](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=123911) Wodiba Vadeli Mevduat İşlemleri özelliği eklendi.
- [#123734](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=123734) Wodiba Banka İşlemleri sayfasında kaynak belgesi silinmiş olan bir banka hareketinin kaynak belge ile olan bağlantısının silinebilme özelliği eklendi.

#### Improvements
- [#123734](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=123734) Wodiba kural seti aktif/pasif özelliği eklendi.




## [1.1.0] => 2021-06-03

#### Bugs

- Virman işlem tipi için kayıtlı belge ilişkilendirme özelliği kaldırıldı, çift belge olduğu için farklı bir çözüm yoluna gidilecek.
- Masraf ve Gelir fişi işlem tipi için belge no ile eşleme kısmından dönen masraf fişi ID ile Wodiba işleminin ilişkilendirmesi yapıldı.
- Dashboard Son İşlemler alanında gelen kayıt sorgusundaki join hatası giderildi, GetWodibaBankActions\(\) metodunda düzenleme yapıldı.
- [#124209](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=124209) Masraf fişi dövizli işlemlerde mahsup fişinde hatalı kayıt atmaması için düzenleme yapıldı.

#### Improvements

- [#123734](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=123734) Kural seti ekleme ekranına kayıt ve güncelleyen bilgisi alanı eklendi.
- Wodiba banka işlemleri sayfasında kaynak belge silinmiş ise uyarı eklendi.
- Karşı VKN ya da IBAN sistem şirketine ait olduğu durumlarda ve kural seti tanımlı olduğu durumda is_our_company değerini engellemek için kontrol eklendi.
- Debug modda iken debug çıktısının kademeli olarak ekrana basılması sağlandı.
- [#123435](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=123435) Wodiba kural seti ekleme ve güncelleme masraf merkezi ve masraf kalemi alanlarına kod eklendi. Wodiba zaman ayarlı görev tanımları teknik ad olacak şekilde düzenleme yapıldı. Wodiba işlem tipleri servisinde gelen JSON yanıtın prefix değerlerin replace edilmesi sağlandı.
- Açıklama olmadan kural seti tespit eden kısım devre dışı bırakıldı. Artık kural setlerinin çalışabilmesi için IBAN, VKN ya da açıklama filtresinin mutlak girilmesi gerekecek, diğer türlü işlem kayıt edilmeyecek.
- Kural seti ekleme ekranında IBAN, VKN ya da Açıklama alanlarından en az biri zorunlu kılındı.
- [#124210](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=124210) İş bankası için virman işlemlerinde karşı IBAN tanımlı gelmese bile açıklamadan işlemin kayıt edilebilmesi için düzenleme yapıldı.

#### New Features

- Wodiba sürüm 1.1.0 yayınlandı.
- Wodiba uygulama versiyonlama özelliği getirildi.
- [#123960](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=123960) Kural setinde birden fazla bütçe kalemi seçimi eklenerek masraf kaydının girilen oranda dağıtılması özelliği eklendi.
- [#123960](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=123960) Kural setlerine dinamik parametre özelliği getirildi, WODIBA_RULE_SET_ROW_PARAMS tablosu eklendi, GetRuleSetRowParam\(\), AddRuleSetRowParam\(\), DelRuleSetRowParam\(\) metodları eklendi.
- [#123479](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=123479) Banka işlemleri sayfasına işlem kodu filtresi eklendi.
- [#123520](https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=123520) Kural setlerinde ön tanımlı KDV oranı seçilebilmesi sağlandı, seçilen kdv oranına göre banka işleminin KDV hesaplaması yapılarak kayıt edilmesi özelliği eklendi.




## [1.0.0] => 2019-04-05

- Wodiba ilk sürüm yayınlandı.
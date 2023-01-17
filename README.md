### WORKCUBE HOLISTIC 21


## Sürüm Filozofisi
Catalyst, Holistic, Lean ve Cognitive stratejisi doğrultusunda Workcube Catalyst serisi Holistic serisi ile devam edecek. Holistic serisi bütüncüllük ve tutarlılık üzerine kuruldu. Workcube çekirdek ekibi ve iş ortakları kooperatifçilik anlayışı ile Lean ve Cognitive için çalışmalara devam ediyor. 

Amacımız kullanıcı işletmelerimizin rekabet gücünü yükseltmek için onlara dijital kaldıraçlar sunmak. Kullanıcılarımızın ise hayatlarına, işlerine değer katmak...Bu doğrultuda çalışmaya devam edeceğiz...

## Altyapı, Framework Yenilikleri

Dockerize Workcube ve Clustering
Workcube Docker imaj ve servisleri Docker Swarm ve Kubernetes ile ölçeklenebilir servislere dönüştürüldü.

Workcloud Install
1 MB dosya büyüklüğündeki Workcube Install uygulaması ile kurulum işlemleri basitleştirildi.

Workcube Params
Sistem parametreleri JSON dosyası olarak DB'de saklanıyor. Arayüzde düzenleniyor.
Holistic Compositor ve NoCode Designer
NoCode uygulamasına Event Designer eklendi. Widgetlar, Custom Tagler drag&drop sayfaya yerleştirilerek eventler oluşturuluyor. Eventlerin tab menüleri de event designer ile tasarlanıyor.

Mockup Designer
Workcube ekran geliştirimleri kod yazmayanları bilmeyenler için tasarlanıyor.

Sevice Worker ve Push Notification
Push Notification özelliği Chrome Servis Worker uygulaması üzerine taşındı. Uygulama sunucuda Socket portu ve servisleri açılmalıdır. Kullanıcılar push notification mesajı almak için Chatflow ve Workflow uygulamasında bildirim al seçeneğini işaretlemelidir.

Data Import Library
üçüncü bir parti uygulama üzerinden doğrudan veri tabanı bağlantısı yapmak ve verileri çekmek için geliştirildi. örneğin Logo veri tabanına bağlanarak 47 hazır seçenek ile veriler import edilebilir.

Veri Servisleri
Başta sosyal güvenlik, vergi uygulamaları olmak üzere değişen kural ve parametreleri Workcube'den otomatik çekmek için kullanılır.

Şifre Güvenliği
Şifre güvenliği ve kriptolama seviyesi arttırıldı. 

MFA ve Login
çok faktörlü yetkilendirme uygulaması opsiyonel olmaktan çıkartılarak standart içine alındı. SMS servisi satın alarak login seviyesini kullanıcı adı ve şifre, captcha ve SMS Pin ile doğrulama seviyesine çekilebiliyor.

Basket V2
Knockout ile yenilenen Basket V2 standart kullanıma alınarak eski versiyon kullanımı kaldırılacak. 31 Aralık 2021'e kadar Basket V1 tamamen end of life olacak.

DUXI 
Data + User Experince +Interface bileşiminde oluşan DUXI geliştiricilerin kod yazmayı %75 oranında azaltarak geliştirmeyi kolaylaştırıyor. wrk_duxi etiketi input, selectbox, radiobuton, checkbox, txt, image, textarea, upload gibi HTML 5 uyumlu input type standartlarına göre çalışıyor. Labellar için doğrudan dictionary ID kullanılıyor. cfc.metod ile çağrılan tüm veriler, sorgular çok kolaylıkla kullanılabiliyor. 

WUXI
WOC - Workcube Output Center içinde kullanılan tüm çıktı şablonlarının sürükle bırak kullanılmasını sağlayan bir DUXI türevi olan WUXI özel etiketi ile şablon geliştirmek kolaylaştırıldı. 

JSON-LD ve Friendly URL
Schema.org standartlarına uygun olarak tüm veriler için web sayfalarına JSON-LD linked data schemaları eklenebiliyor. Mailler, B2B, B2C ve kurumsal web sitelerine dinamik backoffice verileri Json-LD ile verilebiliyor. Protein sitelerinde SEO performansını arttırıyor. 

Data.cfc ve Datagate
Data.cfc bir WO'nun eventleri ve Child WO'ları için tek bir veri component yazarak standartlaştırıyor. Eventlerin butonları data.cfc metotlarını kullanarak action oluşturuyor. Datagate katmanından geçirerek güvenlik kontrolü yapıyor.

Plevne Essential
Plevne Web Application Security uygulaması temel fonksiyonları ücretsiz olarak sunulmaya başladı. İleri seviye koruma için üst sürümlere ve Workcube sertifikalı  güvenlik uzmanları ile çalışmak tavsiye edilmektedir.

WBP
Workcube Best Practise kısaltmasından oluşan WBP sektörel çözümler veya özel eklentiler geliştirmek isteyenler için hazırlandı. Dev Tools, WBP, DB Manager araçları ile yapılan WBP geliştirmek isteyenlere destek verilmektedir.

Speech to Text
Chrome çekirdeği kullanılarak sesler yazıya dönüştürüldü.

CSS Standartları
Yeni box stilleri olmak üzere Workcube arayüz kütüphanesine yenilikler eklendi. Bu yenilikleri Dev Tools CSS standartlarını inceleyerek geliştiriciler kullanabilir.

DATE : 03.12.2018
AUTHOR : UĞUR HAMURPET
DESCRIPTION : moduleMenus klasörü içindeki dosyaların düzenleme kuralını içerir.

* Klasör içindeki tüm dosyaların insert sorguları v16_catalyst tablosundan ayrı ayrı generate scripts yardımıyla alınmıştır.
* Alınan sorgularda gereksiz boşluklar temizlenmiştir.

WRK_OBJECTS.cfm dosyası için uyarılar!

* Bu dosyada herhangi bir ekleme silme ya da düzenleme yapılacaksa mssql üzerinden generate scripts olarak tüm sorguları almayın!
* Yeni object eklendiğinde bu dosyanın en alt satırına yeni bir insert sorgusu olarak ekleyin.
* Herhangi bir object düzenlendiğinde ya da silindiğinde dosya üzerinde sadece ilgili satırı silin ya da düzenleyin.
* Aksi durumlarda DETAIL kolonunda yer alan içerik sebebiyle satır kaymaları olmakta ve dosya istenilen şekilde çalışmamaktadır.
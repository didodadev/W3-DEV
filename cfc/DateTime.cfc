<cfscript>
	// Ayları Liste olarak getir  | MG 20110510
	function getMonthsList()
	{
		return "Ocak,Şubat,Mart,Nisan,Mayıs,Haziran,Temmuz,Ağustos,Eylül,Ekim,Kasım,Aralık";
	}

	function sifirEkle(zamanDegeri) // Bir tarih veya saat değerinin başına, (eğer tek haneli ise) sıfır ekler.
	{
		if (Len(zamanDegeri) == 1)
			return "0" & zamanDegeri;
		else
			return zamanDegeri;
	}
</cfscript>

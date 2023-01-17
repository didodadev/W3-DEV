<cfsetting enablecfoutputonly="Yes">
<cfprocessingdirective suppressWhiteSpace = "Yes">
<!--- 
İşlevi : Verilen Tarihi Türkçe Dödürür

Girdiler :
	tarih(isteğe bağlı) : çevirilmesi istenen tarih "ODBCDate()"
	format(isteğe bağlı) : Çıktının nasıl alınacağı "ayrıntılı bilgi için bkz. dateformat()"
	output(isteğe bağlı) : Ekrana çıktı vermesi için herhangi bir değer verilebilir
				Tanımlanmazsa çıktı vermez. Sadece turkce_tarih değişkenini atar

Çıktılar :
	Çağıran sayfadaki turkce_tarih değişkenine verilen tarihin türkçe
	halini atar. turkce_tarih değişkeni yoksa oluşturur.

Örnekler :
	<cfmodule template="tr_tarih.cfm" output="1">
	<cf_tr_tarih output="1">
	
Yazan :
	Ergün KOÇAK
	12 Şubat 2002 Salı
 --->

<cfif not isDefined("attributes.tarih")> 
	<cfset tarih = now()>
<cfelse>
	<cfset tarih = attributes.tarih>
</cfif>

<cfif not isDefined("attributes.format")> 
	<cfset format =  "dd mmm yyyy dddd">
<cfelse>
	<cfset format = attributes.format>
</cfif>

	<cfset tarih = DateFormat(tarih,format)>
	
	<cfset ay_kisa_eng="Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec">
	<cfset ay_kisa_tr="Ocak,Şubat,Mart,Nisan,Mayıs,Haziran,Temmuz,Ağustos,Eylül,Ekim,Kasım,Aralık">
	
	<cfset ay_uzun_eng="January,February,March,April,May,June,July,August,September,October,November,December">
	<cfset ay_uzun_tr="Ocak,Şubat,Mart,Nisan,Mayıs,Haziran,Temmuz,Ağustos,Eylül,Ekim,Kasım,Aralık">
	
	<cfset gun_uzun_eng = "Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday">
	<cfset gun_uzun_tr = "Pazartesi,Salı,Çarşamba,Perşembe,Cuma,Cumartesi,Pazar">
	
	<cfset gun_kisa_eng = "Mon,Tue,Wed,Thu,Fri,Sat,Sun">
	<cfset gun_kisa_tr = "Pzt,Sal,Çrş,Prş,Cum,Cmt,Paz">
	
	<cfset tarih = ReplaceList(tarih, ay_uzun_eng, ay_kisa_tr)>
	<cfset tarih = ReplaceList(tarih, ay_kisa_eng, ay_kisa_tr)>
	<cfset tarih = ReplaceList(tarih, gun_uzun_eng, gun_uzun_tr)>
	<cfset tarih = ReplaceList(tarih, gun_kisa_eng, gun_kisa_tr)>
	
	<cfset caller.turkce_tarih=tarih>

	<cfif isDefined("attributes.output")>
		<cfoutput>#tarih#</cfoutput>
	</cfif>
	
</cfprocessingdirective>
<cfsetting enablecfoutputonly="No">

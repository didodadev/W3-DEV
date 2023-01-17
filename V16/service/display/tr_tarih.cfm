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

	<cfsavecontent variable="ay1"><cfoutput>#caller.getLang('main',180)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="ay2"><cfoutput>#caller.getLang('main',181)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="ay3"><cfoutput>#caller.getLang('main',182)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="ay4"><cfoutput>#caller.getLang('main',183)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="ay5"><cfoutput>#caller.getLang('main',184)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="ay6"><cfoutput>#caller.getLang('main',185)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="ay7"><cfoutput>#caller.getLang('main',186)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="ay8"><cfoutput>#caller.getLang('main',187)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="ay9"><cfoutput>#caller.getLang('main',188)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="ay10"><cfoutput>#caller.getLang('main',189)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="ay11"><cfoutput>#caller.getLang('main',190)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="ay12"><cfoutput>#caller.getLang('main',191)#</cfoutput></cfsavecontent>
	
	<cfsavecontent variable="gun1"><cfoutput>#caller.getLang('main',192)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="gun2"><cfoutput>#caller.getLang('main',193)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="gun3"><cfoutput>#caller.getLang('main',194)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="gun4"><cfoutput>#caller.getLang('main',195)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="gun5"><cfoutput>#caller.getLang('main',196)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="gun6"><cfoutput>#caller.getLang('main',197)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="gun7"><cfoutput>#caller.getLang('main',198)#</cfoutput></cfsavecontent>
	
	<cfsavecontent variable="gunkısa1"><cfoutput>#caller.getLang('main',207)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="gunkısa2"><cfoutput>#caller.getLang('main',208)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="gunkısa3"><cfoutput>#caller.getLang('main',209)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="gunkısa4"><cfoutput>#caller.getLang('main',210)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="gunkısa5"><cfoutput>#caller.getLang('main',211)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="gunkısa6"><cfoutput>#caller.getLang('main',212)#</cfoutput></cfsavecontent>
	<cfsavecontent variable="gunkısa7"><cfoutput>#caller.getLang('main',213)#</cfoutput></cfsavecontent>
	
	<cfset tarih = DateFormat(tarih,format)>
	
	<cfset ay_kisa_eng="Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec">
	<cfset ay_kisa_tr="#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
	
	<cfset ay_uzun_eng="January,February,March,April,May,June,July,August,September,October,November,December">
	<cfset ay_uzun_tr="#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
	
	<cfset gun_uzun_eng = "Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday">
	<cfset gun_uzun_tr = "#gun1#,#gun2#,#gun3#,#gun4#,#gun5#,#gun6#,#gun7#">
	
	<cfset gun_kisa_eng = "Mon,Tue,Wed,Thu,Fri,Sat,Sun">
	<cfset gun_kisa_tr = "#gunkısa1#,#gunkısa2#,#gunkısa3#,#gunkısa4#,#gunkısa5#,#gunkısa6#,#gunkısa7#">
	
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

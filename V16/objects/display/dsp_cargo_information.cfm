<cfif attributes.cargo_type eq 1>
	<cfset urlAddress="http://www.yurticikargo.com.tr/02.hizmet/gonderi_takip_xml.asp?lgn=datateknik&psw=74792088&ozel_alan=#attributes.order_number#">
<cfelse>
	<cfset urlAddress="http://www.yurticikargo.com.tr/02.hizmet/gonderi_takip_xml.asp?lgn=datateknik&psw=74792088&ozel_alan=#attributes.service_no#">
</cfif>

<!--- linkde sorun olursa --->
<cftry>
	<cfset xmlDoc = XmlParse(CFHTTP.FileContent)>
<cfcatch type="any">
	<cfoutput><cf_get_lang dictionary_id="33009.Sistem Yoğunluğu Nedeniyle İşleminiz Gerçekleştirilemedi veya Kargonuz Taşıyıcı Firmaya Teslim Aşamasındadır"> ! <br/> <cf_get_lang dictionary_id="33012.Lütfen Daha Sonra Tekrar Deneyiniz"> !</cfoutput>
	<cfabort>
</cfcatch>
</cftry>

<cfset resources=xmlDoc.xmlroot.xmlChildren>

<cfset numresources=ArrayLen(resources)>

<table cellspacing="1" cellpadding="2" width="100%" border="0">
  <tr class="color-header" height="20">
	<td class="form-title" width="120"><cfif attributes.cargo_type eq 1><cf_get_lang dictionary_id="33015.Şipariş Takip"><cfelse><cf_get_lang dictionary_id="33020.Servis Takip"></cfif></td>
  </tr>
  <tr class="color-list">
	<td class="txtbold"><cfoutput><cfif attributes.cargo_type eq 1><cf_get_lang dictionary_id="33024.Sipariş Numarası"> : #attributes.order_number#<cfelse><cf_get_lang dictionary_id="33026.Servis Numarası"> : #attributes.service_no#</cfif></cfoutput></td>
  </tr>
</table>
<br/>

<!--- Bolum 1 :Kargo Bilgileri --->
<cfset item1=resources[1]>
<cfset xml_dizi1 = item1.XmlChildren>

<table cellspacing="1" cellpadding="2" width="100%" border="0">
  <tr class="color-header" height="20">
	<td class="form-title" width="120"><cf_get_lang dictionary_id="33014.Gönderen Adı"></td>
  </tr>
  <tr class="color-list">
	<td class="txtbold"><cfoutput>#xml_dizi1[1].XmlText#</cfoutput></td>
  </tr>
</table>
<br/>

<!--- Bolum 2 :Kargo Bilgileri  --->
<cfif numresources eq 4>
	<cfset item2=resources[3]>
<cfelse>
	<cfset item2=resources[2]>
</cfif>

<cfset xml_dizi2 = item2.XmlChildren>
<cfset numresources2=ArrayLen(xml_dizi2)>

<table cellspacing="1" cellpadding="2" width="100%" border="0">
  <tr class="color-header" height="20">
	<td class="form-title"><cf_get_lang dictionary_id="33028.Çıkış Şehri"></td>
	<td class="form-title"><cf_get_lang dictionary_id="33029.Çıkış Birimi"></td>
	<td class="form-title"><cf_get_lang dictionary_id="33031.Çıkış Zamanı"></td>
	<td class="form-title"><cf_get_lang dictionary_id="33033.Varış Şehri"></td>
	<td class="form-title"><cf_get_lang dictionary_id="33035.Varış Birimi"></td>
	<td class="form-title"><cf_get_lang dictionary_id="33036.Varış Zamanı"></td>
	<td class="form-title"><cf_get_lang dictionary_id="33037.Kargo Durumu"></td>
  </tr>
<cfif numresources2 gte 1>
<cfloop index="i" from="1" to="#numresources2#">
<cfset xml_dizi_main=xml_dizi2[i]>
<cfoutput>
  <tr class="color-list">
	<td class="txtbold">#xml_dizi_main.Çıkış_Şehri.XmlText#</td>
	<td class="txtbold">#xml_dizi_main.Çıkış_Birimi.XmlText#</td>
	<td class="txtbold">#xml_dizi_main.Çıkış_Zamanı.XmlText#</td>
	<td class="txtbold">#xml_dizi_main.Varış_Şehri.XmlText#</td>
	<td class="txtbold">#xml_dizi_main.Varış_Birimi.XmlText#</td>
	<td class="txtbold">#xml_dizi_main.Varış_Zamanı.XmlText#</td>
	<td class="txtbold">#xml_dizi_main.Kargo_Durumu.XmlText#</td>
  </tr>
</cfoutput>
</cfloop>
</cfif>
</table>
<br/>

<!--- Bolum 3 :Teslim Bilgileri  --->
<cfif numresources eq 4>
	<cfset item3=resources[4]>
<cfelse>
	<cfset item3=resources[3]>
</cfif>

<cfset xml_dizi3 = item3.XmlChildren>

<table cellspacing="1" cellpadding="2" width="100%" border="0">
  <tr class="color-header" height="20">
	<td class="form-title"><cf_get_lang dictionary_id="33038.Teslim Durumu"></td>
	<td class="form-title"><cf_get_lang dictionary_id="57645.Teslim Tarihi"></td>
	<td class="form-title"><cf_get_lang dictionary_id="33039.Teslim Merkezi"></td>
	<td class="form-title"><cf_get_lang dictionary_id="33040.Teslim Alan Kişi"></td>
	<td class="form-title"><cf_get_lang dictionary_id="33041.Devir Nedeni"></td>
  </tr>
  <tr class="color-list">
  <cfoutput>
	<td class="txtbold">#xml_dizi3[1].XmlText#</td>
	<td class="txtbold">#xml_dizi3[2].XmlText#</td>
	<td class="txtbold">#xml_dizi3[3].XmlText#</td>		
	<td class="txtbold">#xml_dizi3[4].XmlText#</td>
	<td class="txtbold">#xml_dizi3[5].XmlText#</td>	
  </cfoutput>	
  </tr>
</table>
<br/>

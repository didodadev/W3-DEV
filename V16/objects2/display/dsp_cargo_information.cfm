<!--- Sadece o firmanın siparisleri icin --->
<cfif attributes.cargo_type eq 1>
	<!--- <cfset urlAddress="http://www.yurticikargo.com.tr/02.hizmet/gonderi_takip_xml.asp?lgn=datateknik&psw=74792088&ozel_alan=#attributes.order_number#"> --->
	<cfset urlAddress="http://www.yurticikargo.com.tr/02.hizmet/gonderi_takip_xml.asp?lgn=datateknik&psw=74792088&ozel_alan=#url.ozel_alan#">
    <cfquery name="GET_CONTROL" datasource="#DSN3#">
		SELECT 
			ORDER_ID
		FROM 
			ORDERS
		WHERE
			<cfif isdefined("session.pp.company_id")>
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
			<cfelse>
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
			</cfif>
			ORDER_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.order_number#">
	</cfquery>
<cfelse>
	<cfset urlAddress="http://www.yurticikargo.com.tr/02.hizmet/gonderi_takip_xml.asp?lgn=datateknik&psw=74792088&ozel_alan=#attributes.service_no#">
	<cfquery name="GET_CONTROL" datasource="#DSN3#">
		SELECT
			SERVICE_ID
		FROM
			SERVICE
		WHERE
			<cfif isdefined("session.pp.company_id")>
			(
				RELATED_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
				SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
				SERVICE_ID IN (SELECT SERVICE_ID FROM #dsn_alias#.PRO_WORKS WHERE OUTSRC_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND SERVICE_ID IS NOT NULL AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">) OR
				RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
			) 
			<cfelse>
				SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
			</cfif>
			AND SERVICE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.service_no#">
	</cfquery>
</cfif>

<cfif not get_control.recordcount>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
	<cfabort>
</cfif>


<!--- linkde sorun olursa --->
<cftry>
	<cfhttp url="#urladdress#" method="get" resolveurl="Yes" charset="iso-8859-9" throwOnError="Yes">
	<cfset xmlDoc = XmlParse(CFHTTP.FileContent)>
<cfcatch type="any">
	<cfoutput><cf_get_lang no='241.Sistem Yoğunluğu Nedeniyle İşleminiz Gerçekleştirilemedi veya Kargonuz Taşıyıcı Firmaya Teslim Aşamasındadır'> ! <br/> <cf_get_lang no='242.Lütfen Daha Sonra Tekrar Deneyiniz'> !</cfoutput>
	<cfabort>
</cfcatch>
</cftry>

<cfset resources=xmlDoc.xmlroot.xmlChildren>

<cfset numresources=ArrayLen(resources)>

<table cellspacing="1" cellpadding="2" width="100%" border="0">
	<tr class="color-header" height="20">
		<td class="form-title" width="120"><cfif attributes.cargo_type eq 1><cf_get_lang no='243.Sipariş Takip'><cfelse><cf_get_lang no='244.Servis Takip'></cfif></td>
  	</tr>
  	<tr class="color-list">
		<td class="txtbold"><cfoutput><cfif attributes.cargo_type eq 1><cf_get_lang_main no='799.Siparis No'> : #attributes.order_number#<cfelse><cf_get_lang no='246.Servis Numarası'> : #attributes.service_no#</cfif></cfoutput></td>
  	</tr>
</table>
<br/>

<!--- Bolum 1 :Kargo Bilgileri --->
<cfset item1=resources[1]>
<cfset xml_dizi1 = item1.XmlChildren>

<table cellspacing="1" cellpadding="2" width="100%" border="0">
  	<tr class="color-header" height="20">
		<td class="form-title" width="120"><cf_get_lang no='166.Gönderen Adı'></td>
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
	<td class="form-title"><cf_get_lang no='247.Çıkış Şehri'></td>
	<td class="form-title"><cf_get_lang no='248.Çıkış Birimi'></td>
	<td class="form-title"><cf_get_lang no='249.Çıkış Zamanı'></td>
	<td class="form-title"><cf_get_lang no='250.Varış Şehri'></td>
	<td class="form-title"><cf_get_lang no='251.Varış Birimi'></td>
	<td class="form-title"><cf_get_lang no='252.Varış Zamanı'></td>
	<td class="form-title"><cf_get_lang no='253.Kargo Durumu'></td>
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
	<td class="form-title"><cf_get_lang no='254.Teslim Durumu'></td>
	<td class="form-title"><cf_get_lang_main no='233.Teslim Tarihi'></td>
	<td class="form-title"><cf_get_lang_main no='1037.Teslim Merkezi'></td>
	<td class="form-title"><cf_get_lang_main no='363.Teslim Alan Kişi'></td>
	<td class="form-title"><cf_get_lang no='255.Devir Nedeni'></td>
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

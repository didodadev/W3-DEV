<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
	SELECT CARGO_CUSTOMER_CODE,CARGO_CUSTOMER_PASSWORD FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id#
</cfquery>
<cfif not len(get_our_company_info.cargo_customer_code) or not len(get_our_company_info.cargo_customer_password)>
	<cfoutput><cf_get_lang dictionary_id="33042.Sistem Akış Parametrelerindeki Kargo Kullanıcı Tanımlarınızı Kontrol Ediniz"> !</cfoutput>
	<cfabort>
</cfif>

<cftry>
	<cfhttp url="http://www.mngkargo.com.tr/musteri/MusteriKargoDurumu.service/MusteriKargoDurumu.asmx/MusteriKargoTakipBySiparis" method="Post" timeout="60">
		<cfhttpparam type="formfield" name="pMusteriNo" value="#get_our_company_info.cargo_customer_code#">
		<cfhttpparam type="formfield" name="pSifre" value="#get_our_company_info.cargo_customer_password#">
		<cfhttpparam type="formfield" name="pSiparisNo" value="#attributes.order_number#"><!--- SA-10348 #attributes.order_number#--->
		<cfhttpparam type="formfield" name="pKriter" value="1">
	</cfhttp>
	<cfset xmlDoc = xmlparse(CFHTTP.FileContent)>
	<!--- Donen degerdeki kolon sayisi bulunur --->
	<cfset column_count = arraylen(xmlDoc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[1].XmlChildren[1].XmlChildren[1].XmlChildren[1].XmlChildren[1].XmlChildren)>
<cfcatch type="any">
	<cfoutput><cf_get_lang dictionary_id="33009.Sistem Yoğunluğu Nedeniyle İşleminiz Gerçekleştirilemedi veya Kargonuz Taşıyıcı Firmaya Teslim Aşamasındadır"> ! <br/><cf_get_lang dictionary_id="33012.Lütfen Daha Sonra Tekrar Deneyiniz"> !</cfoutput>
	<cfabort>
</cfcatch>
</cftry>

<cfif len(xmlDoc)>
	<cfset list_column =''>
	<cfset list_column_value = 'Fatura Seri,Fatura No,İşlem Şube,Hareket Tarihi, Hareket Saati, Hareket Açıklama,Gönderici Müşteri,Alıcı Müşteri,Teslim Alan,Teslim Tarihi,Sipariş No'>
	<cfloop from="1" to="#column_count#" index="i_column">
		<cfset column_name = xmlDoc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[1].XmlChildren[1].XmlChildren[1].XmlChildren[1].XmlChildren[1].XmlChildren[i_column].XmlAttributes.Name>
		<cfif column_name neq 'ALICI_SUBE'>
			<cfset list_column = listappend(list_column,column_name)>
		<cfelse>	
			<cfset column_count = column_count -1>
		</cfif>
	</cfloop>

	<cfoutput>
	<table cellspacing="1" cellpadding="2" width="100%" border="0">
  		<tr class="color-header" height="20">
		<cfloop from="1" to="#column_count#" index="i_row2">
			<td class="form-title">#listgetat(list_column_value,i_row2)#</td>
		</cfloop>
		</tr>
		<cfset row_count = arraylen(xmlDoc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren)>
		<cfloop from="1" to="#row_count#" index="i_row"><tr class="color-list">
		  <cfloop from="1" to="#column_count#" index="i_row2">
			<cfset temp_column = listgetat(list_column,i_row2)>
			<td class="txtbold" nowrap>
				<cfset value_column = evaluate("xmlDoc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[#i_row#].#temp_column#.XmlText")>
				<cfif temp_column eq 'TESLIM_TARIHI'>#mid(value_column,1,10)#/#mid(value_column,12,8)#<cfelse>#value_column#</cfif>
			</td>
		  </cfloop>
		</tr>
		</cfloop>
	</table>
	</cfoutput>
</cfif>

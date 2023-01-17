<!--- BU sayfa Datateknik için add_options tadır --->
<cfquery name="GET_SERVICE_DETAIL" datasource="#DSN3#">
	SELECT 
		SERVICE_NO,
		PRO_SERIAL_NO,
		SERVICE_ADDRESS,
		SERVICE_HEAD,
		APPLICATOR_NAME,
		INSIDE_DETAIL,
		ACCESSORY_DETAIL,
		SERVICE_DETAIL,
		APPLY_DATE,
		MAIN_SERIAL_NO,
		PRODUCT_NAME,
		BRING_NAME,
		BRING_TEL_NO,
		SERVICE_ID,
		SERVICE_PARTNER_ID
	FROM
		SERVICE
	WHERE 
		SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
</cfquery>
<cfquery name="COMPANY_NAME" datasource="#DSN#">
	SELECT
		COMPANY_ADDRESS,
		SEMT,
		COUNTY,
		CITY,
		COUNTRY,
		COMPANY_EMAIL,
		FULLNAME,
		COMPANY_TELCODE,
		COMPANY_TEL1,
		COMPANY_FAX,
		COMPANY_ID,
		MEMBER_CODE
	FROM
		COMPANY
	WHERE
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
</cfquery>
<h1>ARIZALI ÜRÜN GÖNDERİM FORMU</h1>

<cfoutput>
<table width="720" border="1" cellspacing="0" cellpadding="2" align="center" bordercolor="CCCCCC">
    <tr>
        <td><b>Kayıt No</b> &nbsp;&nbsp;#get_service_detail.service_no#</td>
        <td colspan="2"><b>Gönderici Firma</b> &nbsp;&nbsp;#company_name.FULLNAME#</td>
        <td><b>Tarih</b> &nbsp;&nbsp;#dateformat(get_service_detail.apply_date,'dd/mm/yyyy')#</td>
    </tr>
    <tr>
        <td colspan="3">
            <b>Adres</b>
            &nbsp;&nbsp;
            <cfif len(get_service_detail.service_address)>
                #get_service_detail.service_address#
            <cfelse>
                #company_name.company_address# #company_name.semt#
                <cfif len (company_name.country)>
                    <cfquery name="GET_COUNTY" datasource="#dsn#">
                        SELECT
                            COUNTY_ID,
                            COUNTY_NAME
                        FROM
                            SETUP_COUNTY
                        WHERE
                            COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#COMPANY_NAME.county#">
                    </cfquery>
                #GET_COUNTY.COUNTY_NAME#
                </cfif>
                <cfif len (COMPANY_NAME.CITY)>
                    <cfquery name="GET_CITY" datasource="#DSN#">
                        SELECT
                            CITY_ID,
                            CITY_NAME
                        FROM
                            SETUP_CITY
                        WHERE 
                            CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#COMPANY_NAME.city#">
                    </cfquery>
                    #GET_CITY.CITY_NAME#
                </cfif>		
                <cfif len (company_name.country)>
                    <cfquery name="GET_COUNTRY" datasource="#dsn#">
                        SELECT
                            COUNTRY_ID,
                            COUNTRY_NAME
                        FROM
                            SETUP_COUNTRY
                        WHERE
                            COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#COMPANY_NAME.country#">
                    </cfquery>
                #GET_COUNTRY.COUNTRY_NAME#
                </cfif>
            </cfif>
        </td>
        <td><b>E-mail</b> &nbsp;&nbsp;#COMPANY_NAME.COMPANY_EMAIL#</td>
    </tr>
    <tr>
        <td width="25%"><b>Sorumlu</b> &nbsp;&nbsp;#get_service_detail.applicator_name#</td>
        <td width="25%"><b>Firma Kodu</b> &nbsp;&nbsp;#company_name.member_code#</td>
        <td width="25%"><b>Telefon</b> &nbsp;&nbsp;#company_name.COMPANY_TELCODE# #company_name.COMPANY_TEL1#</td>
        <td width="25%"><b>Fax</b> &nbsp;&nbsp;#company_name.COMPANY_FAX#</td>
    </tr>
    <tr>
        <td colspan="2"><b>Müşteri Ad</b> &nbsp;&nbsp;#get_service_detail.BRING_NAME#</td>
        <td colspan="2"><b>Müşteri Telefonu</b> &nbsp;&nbsp;#get_service_detail.BRING_TEL_NO#</td>
    </tr>
    <tr>
        <td colspan="2"><b>Gönderilen Ürün Seri No</b> &nbsp;&nbsp;#get_service_detail.pro_serial_no#</td>
        <td colspan="2"><b>Notebook Orjinal Seri No</b> </td>
    </tr>
    <tr>
        <td colspan="2"><b>Ait olduğu Sistem Seri No</b> &nbsp;&nbsp;#get_service_detail.main_serial_no#</td>
        <td colspan="2"><b>Notebook Orjinal Model No</b> </td>
    </tr>
    <tr>
        <td colspan="2"><b>Ürün Tanımı</b> &nbsp;&nbsp;#get_service_detail.product_name#</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2"><b>Aksesuar</b> &nbsp;&nbsp;#get_service_detail.ACCESSORY_DETAIL#</td>
        <td colspan="2"><b>Fiziksel Hasarlar</b> &nbsp;&nbsp;#get_service_detail.INSIDE_DETAIL#</td>
    </tr>
    <tr>
        <td height="80" colspan="4" valign="top"><b>Problemin Açıklanması</b> &nbsp;&nbsp;#get_service_detail.service_DETAIL#</td>
    </tr>
    <tr>
        <td colspan="4" valign="top">
            <ol>
                <li>Gönderimde bulunan, ilgili prosedürdeki tüm maddeleri kabul etmiş sayılır.</li> 
                <li>Form, 1 kopyası göndericide kalacak şekilde 2 kopya olarak düzenlenir.  </li>
                <li>Açıklamaların tamamının gönderici tarafından doldurulması mecburidir. </li>
                <li>Parçalar hasarsız gelecek şekilde paketlenmelidir. Kargodan doğabilecek veya parçayı garanti dışı bırakacak bozulmalardan Datateknik sorumlu değildir. </li>
                <li>Garanti harici onarımlarda garanti süresi 3 (üç) aydır.</li>
                <li>İşletim sistemi problemleri garanti dahilinde değildir.</li>
                <li>Bilgi yedekleme hizmeti  ücrete tabidir.</li>
                <li>Önemli bilgi mevcuttur kaydı yapılmasına rağmen elimizde olmadan gerçekleşebilecek bilgi kayıpları Datateknik sorumluluğunda değildir.</li>
                <li>Azami onarım süresi 30 iş günüdür.</li>
                <li>Garanti uygulaması sırasında değiştirilen malın garanti süresi, satın alınan malın kalan garanti süresi ile sınırlıdır.</li>
                <li>Tüketicinin, malı kullanma kılavuzunda yer alan hususlara aykırı kullanmasından veya yetkisiz kişiler tarafından yapılan müdahalelerden kaynaklanan arızalar garanti dışıdır. </li>
                <li>90(Doksan) iş günü içerisinde teslim alınmayan ürünlerde oluşabilecek hasar, kayıp gibi durumlardan Datateknik sorumlu tutulamaz.</li>
            </ol>
        </td>
    </tr>
</table>
</cfoutput>
<br/><br/>
<table width="720" border="1" cellspacing="0" cellpadding="4" align="center" bordercolor="CCCCCC">
    <tr>
        <td>
            <table class="headbold" width="100%">
                <tr>
                    <td height="50">Sevk Adresi: </td>
                </tr>
                <tr>
                    <td height="50">DATATEKNİK BİLGİSAYAR SİSTEMLERİ TİCARET VE SANAYİ A.Ş.</td>
                </tr>
                <tr>
                    <td align="center" height="50">İÇ RMA BİRİMİNİN DİKKATİNE!</td>
                </tr>
                <tr>
                    <td align="center" height="50">ÇOBANÇEŞME MAH.GENÇ OSMAN SOK. NO:14 34196</td>
                </tr>
                <tr>
                    <td height="50" align="right" style="text-align:right;">YENİBOSNA / İSTANBUL</td>
                </tr>
            </table>	
        </td>
    </tr>
</table>

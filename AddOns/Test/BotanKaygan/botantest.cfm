<p>Sistem yönetim yetki grubu için</p>
<p>statik pattern, 3 nolu gdpr yetki grubu, orijinal veri döner</p>
<cf_wrk_crypto_gdpr mode="3" pattern="1" sensitive_label="3" data="orijinal veri 1" static_value="**1**">

<p>statik pattern, 1 nolu gdpr yetki grubu, pattern döner</p>
<cf_wrk_crypto_gdpr mode="3" pattern="1" sensitive_label="1" data="orijinal veri 2" static_value="**2**">

<p>statik pattern, 1 nolu gdpr yetki grubu, pattern döner</p>
<cfset myresultvalue = "">
<cf_wrk_crypto_gdpr mode="3" pattern="1" sensitive_label="1" data="orijinal veri 2" static_value="**2**" result="myresultvalue">
<cfoutput>#myresultvalue#</cfoutput>

<p>telefon pattern, 3 nolu gdpr yetki grubu, telefon açık döner</p>
<cf_wrk_crypto_gdpr mode="3" pattern="2" sensitive_label="3" data="05367126975">

<p>telefon pattern, 1 nolu gdpr yetki grubu, telefon formatlı döner</p>
<cf_wrk_crypto_gdpr mode="3" pattern="2" sensitive_label="1" data="05367126975">

<p>telefon pattern, 1 nolu gdpr yetki grubu, telefon formatlı döner</p>
<cf_wrk_crypto_gdpr mode="3" pattern="2" sensitive_label="1" data="0536 712 6975">

<p>email pattern, 3 nolu gdpr yetki grubu, email açık döner</p>
<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="3" data="halityurttas@workcube.com">

<p>email pattern, 1 nolu gdpr yetki grubu, email formatlı döner</p>
<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="1" data="halityurttas@yandex.com.tr">
    
<p>email pattern, 1 nolu gdpr yetki grubu, email bulunamaz *** döner</p>
<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="1" data="halityurttas.com.tr">

<cfheader name="Strict-Transport-Security" value="max-age=31536000; includeSubDomains"><!-----İlk ve sonraki tüm isteklerin https üzerinden yapmaya zorlar------>
<cfheader name="Content-Type" value="X-Content-Type-Options=nosniff; text/html; charset=utf-8"><!----internet tarayıcılarının MIME Type sniffing yaparak içerik üzerinde karar vermesi engelle----->
<cfheader name="referrer" value="origin"><!----"Referer" istek headerını kontrol etmemizi sağlıyor------>
<cfheader name="X-XSS-Protection" value="1; mode=block"><!----kullanıcıları xss saldırılarından korur---->
<cfheader name="Content-Type" value="text/html; charset=utf-8"> <!---- firefox türkçe karakter sorunundan dolayı eklenmiştir ---->
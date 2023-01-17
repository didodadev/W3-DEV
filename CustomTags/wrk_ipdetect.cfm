<cfsetting enablecfoutputonly="yes">
<cfprocessingdirective suppresswhitespace="Yes">
<!---
	Note: IP Tabanlı Ülke Kontrolü
	Date: 20130926
	Update: 
	User: OD
	
	IP üzerinden HostIP Webservisi kullanılarak ülke tespiti yapılıp, Türkiye değilse İngilizce sayfalara yönlendirme yapılır. 
	Bu kontrol her kullanıcı için sadece ilk girişte yapılmaktadır. Aynı kullanıcının oturumu devam ederken test tekrar edilmez.
	
	Modified: 20130930 - FA - Ülke kodu ve yönlendirilecek site parametrik hale getirildi. Yönlendirilecek site ve ülke bilgisi gönderilmez ise IP'ye ait ülke bilgisini çeker.
	
	Parameters: country - ülke bilgisi bu ülke haricindeki girişleri yönlendir
				redirected_site - yönlenmesini istediğimiz site zorunlu değildir
				
	Used: <cf_wrk_ipdetect country="TR" redirected_site="http://eng.workcube.com">
	
--->


<cfparam name="attributes.country" default="">
<cfparam name="attributes.redirected_site" default="">

<cfif len(attributes.country) and len(attributes.redirected_site)>
	<!--- Dil kontrolüne gerek olup olmadığı tespit edilir. --->
	<cfif NOT IsDefined('session.ip.country')>
		<!--- Ülke tespiti hiç yapılmamışsa kontrol edilip karar verilir. --->
		<cfset session.ip.userip = cgi.REMOTE_ADDR>
        <cfif session.ip.userip NEQ '127.0.0.1'>
            <cftry>
                    <!--- Ülke tespiti için HostIP Webservice kullanılıyor.  --->	
                    <cfhttp url="http://api.hostip.info/get_json.php?ip=#session.ip.userip#" result="ipInfo" resolveurl="no"></cfhttp>
                
                    <!--- JSON içerisinden ülke kodu alınıyor --->
                    <cfset detectedCountry = DeserializeJSON(ipInfo.filecontent).country_code>
                <cfcatch>
                    <!--- Hata Var! session language kullanılsın. --->
                    <cfset detectedCountry = session_base.language>
                </cfcatch>      
            </cftry>
        <cfelse>
            <!--- localde, o yüzden test edilmedi, session language tanımlandı. --->
            <cfset detectedCountry = session_base.language>
        </cfif>
        
        <cfif detectedCountry EQ attributes.country or detectedCountry EQ 'XX'>
            <cfset session.ip.country = attributes.country>
            <!--- gönderilen ülke ile aynı ise yönlendirme yapılmasın. ---> 			
        <cfelse>
            <cfset session.ip.country = detectedCountry>
            <!--- gönderilen ülkeden değilse ve site yönlendirilmesi istenmiş ise istenilen yere yönlenilsin. ---> 
            <cflocation url="#attributes.redirected_site#" addtoken="no">
        </cfif>
	<cfelse>
		<!--- Session tanımı var ve kontrol daha önce yapıldığı için tekrar kontrol yapılmıyor! --->
	</cfif>
<cfelse>
	<!--- eger site yönlendirilmesi istenmemiş ise IP'nin ülke kodunu yazar --->
	<cfif cgi.remote_addr NEQ '127.0.0.1'>
		<cftry>
				<!--- Ülke tespiti için HostIP Webservice kullanılıyor.  --->	
				<cfhttp url="http://api.hostip.info/get_json.php?ip=#session.ip.userip#" result="ipInfo" resolveurl="no"></cfhttp>
			
				<!--- JSON içerisinden ülke kodu alınıyor --->
				<cfset detectedCountry = DeserializeJSON(ipInfo.filecontent).country_code>
			<cfcatch>
				<!--- Hata Var! session language kullanılsın. --->
				<cfset detectedCountry = session_base.language>
			</cfcatch>      
		</cftry>
	<cfelse>
		<!--- localde, o yüzden test edilmedi, session language tanımlandı. --->
		<cfset detectedCountry = session_base.language>
	</cfif>
	
	<cfoutput>#detectedCountry#</cfoutput>
</cfif>

</cfprocessingdirective><cfsetting enablecfoutputonly="no">

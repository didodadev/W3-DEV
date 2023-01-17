<cfprocessingdirective suppresswhitespace="Yes">
	<cfif not isdefined("session.ep.language")>
        <cfset session.ep.language = 'tr'>
        <cfset setLanguage = true />
    </cfif>
    <cf_get_lang_set_main>
    <cfset lang_array_main = variables.lang_array_main>
    
    <cfif isdefined("attributes.fuseaction")>
        <cfinclude template="V16/add_options/fbx_Switch.cfm">
    </cfif>

    <cfif application.pageDenied>
        <cfset denied_alert = getLang("main",120)>
        <cfif application.pageDenied eq 2>
            <cfset denied_alert = getLang("main",2156)>
        </cfif>
        <!--- hangi modüle yetki olmadığını gösterebilmek için eklendi --->
        <cfset GET_MODULE = createObject("component", "WMO.getModulesName")>
        <cfset GET_MODULE_NAME = GET_MODULE.ModuleName('#dsn#','#attributes.fuseaction#')>
		<cfif GET_MODULE_NAME.recordcount>
			<cfset hata = 5>
			<cfset hata_mesaj = "#denied_alert# - #GET_MODULE_NAME.MODULE# #getLang("settings",1244)# <br> #getLang("main",169)# : #attributes.fuseaction#<br>">
		<cfelse>
			<cfset hata = 6>
			<cfset hata_mesaj = "Fuseaction or Module not found: #attributes.fuseaction#">
		</cfif>
        <cfif attributes.fuseaction neq "settings.form_add_user_group">
            <cfset pageDeniedThrowError = true>
        <cfelse>
            <script>window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.welcome"</script>
            <cfabort>
        </cfif>
		<!---
		<cfoutput>
            <script type="text/javascript">
                alert("#denied_alert# - #GET_MODULE_NAME.MODULE# #getLang("settings",1244)#");
                <cfif attributes.fuseaction contains 'emptypopup'>
                    alert("#attributes.fuseaction#");
                <cfelseif attributes.fuseaction contains 'popup'>
                    window.close();
                <cfelse>
                    window.location="#user_domain##request.self#?fuseaction=myhome.welcome";
                </cfif>
            </script>
            <cfabort>
        </cfoutput>
		--->
    </cfif>
    <!---ERU20190517 httpHeaderlar tarayıcıların sunduğu güvenlik önlemlerinden faydalanmak için eklendi.---->
    <!--- Uğur Hamurpet : 13/04/2020 Content-Security-Policy : CDN scriptleri dahil edemediğimizden dolayı geçici bir süreliğine kapatıldı --->
    <!--- <cfheader name="Content-Security-Policy" value="script-src 'self' 'unsafe-inline' 'unsafe-eval'" > ---><!----Hangi kaynaklardan kaynak dosyalarının kaynak dosyalarının yükleneyeceği------>
    <cfheader name="Strict-Transport-Security" value="max-age=31536000; includeSubDomains"><!-----İlk ve sonraki tüm isteklerin https üzerinden yapmaya zorlar------>
    <cfheader name="Content-Type" value="X-Content-Type-Options=nosniff; text/html; charset=utf-8"><!----internet tarayıcılarının MIME Type sniffing yaparak içerik üzerinde karar vermesi engelle----->
    <cfheader name="referrer" value="origin"><!----"Referer" istek headerını kontrol etmemizi sağlıyor------>
    <cfheader name="X-XSS-Protection" value="1; mode=block"><!----kullanıcıları xss saldırılarından korur---->
    <cfheader name="Content-Type" value="text/html; charset=utf-8"> <!---- firefox türkçe karakter sorunundan dolayı eklenmiştir ---->
	<cfif isdefined("attributes.fuseaction") and len(attributes.fuseaction) and listFirst(attributes.fuseaction,'.') is 'home'>
        <cftry> <!--- home sayfası bulunamadığında switch kırılmaktaydı ve hataya düşmekteydi --->
    	<cfinclude template="fbx_Switch.cfm">
        <cfcatch>
            <script>document.location.href = "/index.cfm?ex=notfound";</script>
            <cfheader statuscode="404" statustext="Page not found">
        </cfcatch>
        </cftry>
	<cfelseif isdefined("attributes.fuseaction") and len(attributes.fuseaction) and listFirst(attributes.fuseaction,'.') is 'objects2'>
    	<cf_denied_control>
    	<cfinclude template="WMO/wrkTemplate.cfm">
    <cfelseif isdefined("session.ep.userid") and isdefined("attributes.fuseaction") and len(attributes.fuseaction)> 
        <cf_denied_control>
		<!--- <cfset GET_LICENCE = createObject("component", "WMO.functions")>
        <cfset GET_LICENCE_INFO = GET_LICENCE.GET_USER_LICENCE()> --->

        <cfif application.control_time_cost.control_time_cost('#attributes.fuseaction#','#dsn#') neq 0>
            <cfset controlTimeCostDictionaryId = application.control_time_cost.control_time_cost('#attributes.fuseaction#','#dsn#')>
            <script type="text/javascript">
                <cfoutput>
                    alert("#getLang('main',controlTimeCostDictionaryId)#");
                    window.location.href = '#request.self#?fuseaction=myhome.upd_myweek';
                </cfoutput>
            </script>
		<!--- <cfelseif GET_LICENCE_INFO.recordcount>
        	<cfset GET_USER_LICENCE_RESULT = GET_LICENCE.GET_USER_LICENCE_RESULT(session.ep.userid)>
            <cfif not GET_USER_LICENCE_RESULT.recordcount>
				<cfif not attributes.fuseaction is 'myhome.welcome' and not isdefined("attributes.ajax")>
                    <script type="text/javascript">
                        <cfoutput>
                            alert("You should complete licencing process.");
                            window.location.href = '#request.self#?fuseaction=myhome.welcome';
                        </cfoutput>
                    </script>
				<cfelse>
            		<cfinclude template="WMO/wrkTemplate.cfm">
                </cfif>
			<cfelse>
				<cfinclude template="WMO/wrkTemplate.cfm">
            </cfif> --->
        <cfelse>
            <cfinclude template="WMO/wrkTemplate.cfm">
        </cfif>
    <cfelse>
    	<cfif not isdefined("session.ep.userid")>
			<cfif isdefined("attributes.ajax")><!--- ajax sayfaları direk kes --->
                <cfsetting showdebugoutput="no">
                <cfsavecontent variable="session.error_text"><cf_get_lang_main no='126.session_error'></cfsavecontent>
                <cfoutput><a onClick="javascript://" class="tableyazi" href="#request.self#?fuseaction=home.login">#session.error_text#</a></cfoutput>
                <cfexit method="exittemplate">
            <cfelse>
            	<cfif not isdefined('attributes.fuseaction')><cfset attributes.fuseaction = ''></cfif>
                <cfif not listfindnocase(free_actions,attributes.fuseaction, ',')>
                    <cfinclude template="dsp_login.cfm">
		        <cfelse>
			        <cfinclude template="WMO/wrkTemplate.cfm">
                </cfif>
            </cfif>
		<cfelse>
        	<cfinclude template="dsp_login.cfm">
        </cfif>
    </cfif>
</cfprocessingdirective>
<cfif isDefined("session.ep.userid") and isDefined("session.ep.COMPANY_ID") and len(session.ep.COMPANY_ID) and len(session.ep.userid)>
    <cfif isDefined('attributes.fuseaction') and attributes.fuseaction eq 'myhome.welcome'>
        <cfset googleapi = createObject("component","WEX.google.cfc.google_api")>
        <cfset get_api_key = googleapi.get_api_key()>
        <cfif isDefined("get_api_key.GOOGLE_API_KEY") and len(get_api_key.GOOGLE_API_KEY)>
            <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=<cfoutput>#get_api_key.GOOGLE_API_KEY#</cfoutput>"></script>
        <cfelse>
            <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js"></script>
        </cfif>
        <script type="text/javascript">
            const errorFunc = (e) => {
                <!--- console.error(e); console.error(e.message); --->
                if(e.code === 1 || e.message === 'User denied Geolocation'){
                    document.getElementById("lat").value = 0;
                    document.getElementById("lng").value = 0;
                    /* console.log("İzin verilmedi") */
                }
            };
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function (p) {
                    var LatLng = new google.maps.LatLng(p.coords.latitude, p.coords.longitude);
                    <cfset login_cfc = createObject("component", "WMO.login")>
                    <cfset login_cfc.dsn = dsn/>
                    <cfset last_login = login_cfc.get_last_login()>
                    document.getElementById("lat").value = p.coords.latitude;
                    document.getElementById("lng").value = p.coords.longitude;
                    var lat = document.getElementById('lat').value;
                    var lng = document.getElementById('lng').value;
                    $.ajax({url: "/WMO/login.cfc?method=add_user_login_coord&dsn=<cfoutput>#login_cfc.dsn#</cfoutput>&login_id=<cfoutput>#last_login.login_id#</cfoutput>&coordinate1="+lat+"&coordinate2="+lng, success: function(result){
                        /* console.log("<cfoutput>#last_login.login_id#</cfoutput>");
                        console.log(lat);
                        console.log(lng); */
                    }});
                }, errorFunc);
            } else {
                alert('Tarayıcınız konum özelliğini desteklemiyor.');
            }
        </script>
        <div id="coordinats">
            <input type="hidden" id="lat" name="lat" />
            <input type="hidden" id="lng" nam="lng" />
        </div>
        <!--- //kullanıcı giriş konumu db'ye atılıyor --->
    </cfif>
</cfif>
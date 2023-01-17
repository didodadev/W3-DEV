<!---
File: plevne.cfc
Author: Workcube-Esma Uysal <esmauysal@workcube.com>, Halit Yurttaş <halityurttas@workcube.org>
Date: 30.08.2019, 20.05.2020
Description: XSS ve SQL Injection saldırıları kontrollerinin yapıldığı cfc'dir.
Notes:  
        Yeni V2 Motoru

        WBO lar Security seçeneğine göre çalışır. Security alanı update edilmemiş WBO larda Standart olarak algılar.

        cfhttp post metotlarına eklenmesi gereken http_referer parametresi ve değeri ;
        <cfhttpparam type="CGI" name="http_referer"  value="#cgi.http_referer#">
--->
<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>

    <cfset error_noreferer = 3001>
    <cfset error_referer_notmatch = 3002>
    <cfset error_find_nemo = 3011>
    <cfset error_find_dory = 3012>

    <cfset check_referer = 1>

    <cffunction name="register">
        <cfif structKeyExists(application.systemParam.systemParam(), "plevne_enabled") and application.systemParam.systemParam().plevne_enabled eq 1>
            <cfset application.plevneService = this>
        </cfif>
    </cffunction>

    <cffunction name="plevne" returntype="string" output="false">
        <cfargument name="employee_url" required="true">
        <cfargument name="form_values" required="true">

        <cflock name="#createUUID()#" timeout="20">
            <cfquery name="query_rules" datasource="#dsn#" cachedwithin="#createTimespan(0,2,0,0)#">
                SELECT * FROM WRK_PLEVNE_RULE WHERE ACTIVE = 1
            </cfquery>
            <cfquery name="query_rules_standart" dbtype="query">
                SELECT RULE_ID, PATTERN FROM query_rules WHERE SECURITY_LEVEL = 'Standart'
            </cfquery>
            <cfquery name="query_rules_light" dbtype="query">
                SELECT RULE_ID, PATTERN FROM query_rules WHERE SECURITY_LEVEL = 'Light'
            </cfquery>
            <cfquery name="query_rules_dark" dbtype="query">
                SELECT RULE_ID, PATTERN FROM query_rules WHERE SECURITY_LEVEL = 'Dark'
            </cfquery>
            <cfscript>

                if (check_referer) {
                    checkReferer(arguments.employee_url);
                }
                querystringargs = listToArray(cgi.QUERY_STRING, "&");
                fuseaction = "myhome.welcome";
                for (fi = 1; fi < arrayLen(querystringargs); fi++) {
                    if (listGetAt(querystringargs[fi], 1, "=") neq "fuseaction") continue;
                    fuseaction = listGetAt(querystringargs[fi], 2, "=");
                }
                if (not structKeyExists(application.objects, fuseaction)) {
                    fuseaction = "myhome.welcome";
                }
                request_level = application.objects[fuseaction]["SECURITY"];
                
                /**
                 * Light mode zaman çalışır
                 */
                findNemo( query_rules_light, cgi.QUERY_STRING );
                if (cgi.REQUEST_METHOD eq "POST") {
                    findDory( query_rules_light, arguments.form_values );
                }
                if (request_level eq "Light") {
                    return 1;
                }

                /**
                 * Standart mode herhangi bir mod seçilmemiş ise çalışır
                 */
                findNemo( query_rules_standart, cgi.QUERY_STRING );
                if (cgi.REQUEST_METHOD eq "POST") {
                    findDory( query_rules_standart, arguments.form_values );
                }
                
                if (request_level neq "Dark") {
                    return 1;
                }
                /**
                 * Dark mode light mode aktif değilse her 
                 */
                findNemo( query_rules_dark, cgi.QUERY_STRING );
                if (cgi.REQUEST_METHOD eq "POST") {
                    findDory( query_rules_dark, arguments.form_values );
                }
                return 1;

            </cfscript>
        </cflock>
        <cfreturn true>
    </cffunction>

    <cffunction name="checkReferer">
        <cfargument name="employee_url">
        <cfif cgi.REQUEST_METHOD eq "POST">
            <cfset referer = canonicalize(cgi.HTTP_REFERER, 'no', 'no')>
            <cfif not len(referer)>
                <cfif isDefined("GetHttpRequestData().headers.http_referer")>
                    <cfset referer = canonicalize(getHTTPRequestData().headers.HTTP_REFERER, 'no', 'no')>
                </cfif>
            </cfif>
            <cfif not len(referer)>
                <cfthrow message="Sunucuya gelen istek içerisinde referans verisi bulunamamıştır!" errorcode="#error_noreferer#" detail="Erişmek istediğiniz sayfaya ulaşabilmeniz için sizi referans eden http isteğini bilinmesi gerekir. Bu http referer olarak bilinen bir yöntemdir. Eğer http referer verisi taşımayan direk bir istek başlatmış iseniz sisteme aşırı yüklenmeye çalışan bir kullanıcı ile aynı işlemi yapıyorsunuzdur. DDOS ve benzeri ataklara karşı sizi engellemek zorundayız. Eğer bir cfhttp ile sistem içi erişimde bulunmuş iseniz lütfen kodlarınızda http_referer değerini çağırdığınız url'yi verin.">
            </cfif>
            <cfscript> 
                javaUri = createObject( "java", "java.net.URL" ).init(
                javaCast( "string", referer )
                );
            </cfscript>
            <cfset referer_host = javaUri.getHost()>
            <cfif arguments.employee_url neq referer_host>
                <cfthrow message="İstek yaptığınız sayfayı tanıyamıyoruz!" errorcode="#error_referer_notmatch#" detail="İstek yaptığınız sayfa veya kaynak tarafından gönderilen referer bilgisi talebinize uygun gözükmüyor. Lütfen workcube içerisinde ki bir sayfadan eriştiğinize emin olun.">
            </cfif>
        </cfif>
    </cffunction>

    <cffunction name="findNemo">
        <cfargument name="query_patterns">
        <cfargument name="bruce">
        <cfscript>
            patterns = valueArray( arguments.query_patterns, "PATTERN" );
            rule_ids = valueArray( arguments.query_patterns, "RULE_ID" );

            for (pidx = 1; pidx <= arrayLen(patterns); pidx++) {
                p = patterns[pidx];
                nemo = reFind(p, arguments.bruce);
                if (nemo gt 0) {
                    throw( message: "Yasaklı metin veya veri bulundu!", detail: "Sisteme yapmış olduğunuz veri gönderiminde yasaklanmış bir veri veya metinle karşılaşıldı. Bu sistem için önemli bir risk olabilir. Lütfen " & rule_ids[pidx] & " nolu kuralı kontrol edin.", errorcode: error_find_nemo);
                }
            }
        </cfscript>
    </cffunction>

    <cffunction name="findDory">
        <cfargument name="query_patterns">
        <cfargument name="chum">
        <cfscript>
            patterns = valueArray( arguments.query_patterns, "PATTERN" );
            rule_ids = valueArray( arguments.query_patterns, "RULE_ID" );
            chum_keys = structKeyArray(arguments.chum);
            for (pidx = 1; pidx <= arrayLen(patterns); pidx++) {
                p = patterns[pidx];
                for (cidx = 1; cidx < arrayLen(chum_keys); cidx++) {
                    c = arguments.chum[chum_keys[cidx]];
                    dory = reFind(p, c);
                    if (dory gt 0) {
                        throw( message: "Yasaklı metin veya veri bulundu!", detail: "Sisteme yapmış olduğunuz veri gönderiminde yasaklanmış bir veri veya metinle karşılaşıldı. Bu sistem için önemli bir risk olabilir. Lütfen " & rule_ids[pidx] & " nolu kuralı kontrol edin.", errorcode: error_find_dory);
                    }
                }
            }
        </cfscript>
    </cffunction>
</cfcomponent>
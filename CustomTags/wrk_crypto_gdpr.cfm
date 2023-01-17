<!---
    File :          wrk_crypto_gdpr
    Author :        Halit Yurttaş <halityurttas@gmail.com>, Tolga Sütlü
    Date :          13.12.2019
    Description :   GDPR uygun şifreleme işlemlerini yapar
    Notes :         
    Attributes :    
        mode        : 1- tablo bazında işlem yapar
                      2- değer bazında gdpr kurallarına göre işlem yapar
                      3- değer bazında parametrik işlem yapar

        isenc       : 1 ise şifreleme 0 ise çözme işlemini yapar (default 0) ve 2 ile temizleme yapılır

        [           : bu grup tablo bazında işlem yapar
            [query] : Sayfada ki query adı (şifreleme yapıldığında boş bırakılır, çözümleme işleminde mecburidir)
            [alias] : Alias listesi | COLUMNA:ALIASA,COLUMNB:ALIASB,...
            [filters]: Filtreler elle belirtilir [SCHEMA, TABLE, COLUMN, FILTER_VALUE]
        ]
        
        [           : bu grup değer bazında işlem yapar
        [refid]     : Referans id değeri (PK veya identitycol)
        schema      : Şema tipi (main vs..)
        table       : Tablo adı
        column      : Kolon adı
        [data]      : Patternleme işleminde direk değeri aktarmak için kullanılır
        ]

        [           : bu grup değer bazında parametrik işlem yapar
        sensitive_label : sensitive yetki grubu
        pattern     : pattern tipi
        data        : patternlenecek veri
        [static_value] : statik değer. pattern tipi 1 de sadece gönderilir bu değer çıktı olarak verilir
        [result]    : dönen değer bir değişkene atanacak ise
        ]
--->
<cfparam name="attributes.mode" default="">
<cfparam name="attributes.isenc" default="0">
<cfparam name="attributes.alias" default="">

<!--- mode 1 : tablo veya query üzerinde işlem yapar --->
<cfif attributes.mode eq 1>
    <!--- query ancak okunduğunda yani çözümleme işleminde kullanılır --->
    <cfif isDefined("attributes.query") and len(attributes.query) and attributes.isenc eq 0>
        
        <cfset querydecyptor = createObject("component", "WDO.gdpr.services.decryption_query")>
        <cfset caller[attributes.query] = querydecyptor.decrypt( build_fuseaction(), caller[attributes.query], attributes.alias )>

    <!--- bir tabloyu şifrelemek için column adı yeterli diğer değerler fuseaction ile gdpr üzerinden alınır --->
    <cfelseif attributes.isenc eq 1>

        <cfset tableencryptor = createObject("component", "WDO.gdpr.services.encryption_table")>
        <cfset tableencryptor.encrypt( build_fuseaction() )>

    <!--- bir tabloya verileri geri doldurma işlemi --->
    <cfelseif attributes.isenc eq 0>

        <cfset tabledecryptor = createObject("component", "WDO.gdpr.services.decryption_table")>
        <cfset tabledecryptor.decrypt( build_fuseaction(), attributes.filters )>

    <!--- bir tabloyu temizleme için isenc 2 --->
    <cfelseif attributes.isenc eq 2>
        <cfset tablecleaner = createObject("component", "WDO.gdpr.services.clear_table")>
        <cfset tablecleaner.clear( build_fuseaction() )>

    <cfelse>
        <cfthrow message="Geçersiz yapılandırma. Lütfen GDPR kullanım detayına bakınız!">
    </cfif>

<!--- mode 2 : veriyi gdpr kayıtlarına göre patternler --->
<cfelseif attributes.mode eq 2>
    <!--- patternleme --->
    <cfif attributes.isenc eq 3>

        <cfset patternbuilder = createObject("component", "WDO.gdpr.services.pattern_service")>
        <cfset patternbuilder.pattern( build_fuseaction(), attributes.schema, attributes.table, attributes.column, attributes.data )>

    <!--- veri şifreleme veya çözümleme işlemleri --->
    <cfelseif isDefined("attributes.refid") and len(attributes.refid) and isDefined("attributes.schema") and isDefined("attributes.table") and isDefined("attributes.column")>

        <cfset singlederyptor = createObject("component", "WDO.gdpr.services.single_decrypt")>
        <cfoutput>
            #singlederyptor.decrypt(attributes.refid, attributes.schema, attributes.table, attributes.column)#
        </cfoutput>

    <cfelse>
        <cfthrow message="Geçersiz yapılandırma. Lütfen GDPR kullanım detayına bakınız!">
    </cfif>

<!--- mode 3 : veriyi statik patternleme işlemi yapar --->
<cfelseif attributes.mode eq 3>

    <cfset result = "">
    <cfif isDefined("attributes.sensitive_label") and len(attributes.sensitive_label)>
        <cfif listContains(session.ep.dockphone, attributes.sensitive_label)>
            <cfset result = attributes.data>
        <cfelseif attributes.pattern eq "1">
            <cfset result = attributes.static_value>
        <cfelse>
            <cfobject name="patternobj" component="WDO.gdpr.patterns.pattern#attributes.pattern#">
            <cfset result = patternobj.pattern(attributes.data)>
        </cfif>
    <cfelse>
        <cfthrow message="Geçersiz yapılandırma. Lütfen GDPR kullanım detayına bakınız!">
    </cfif>
    
    <cfif isDefined("attributes.result")>
        <cfset caller[attributes.result] = result>
    <cfelse>
        <cfoutput>#result#</cfoutput>
    </cfif>

<!--- eksik yapılandırma yapılmıştır --->
<cfelse>
    <cfthrow message="Geçersiz yapılandırma. Lütfen GDPR kullanım detayına bakınız!">
</cfif>

<!--- helpers --->
<cffunction name="build_fuseaction">
    <cfscript>
        fa = isDefined("caller.attributes.fuseaction") ? caller.attributes.fuseaction : attributes.fuseaction;
        ev = isDefined("caller.attributes.event") ? "&event=" & caller.attributes.event : ( 
            isDefined("attributes.event") ? "&event=" & attributes.event : ""
            );
    </cfscript>
    <cfreturn fa & ev>
</cffunction>
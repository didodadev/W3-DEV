<!---
    File: WebService.cfc
    Author: Gramoni-Mahmut <mahmut.cifci@gramoni.com>
    Date: 03.11.2018
    Controller:
    Description:
		Banka sistemlerine bağlantı sağlayan bileşen
--->

<cfcomponent name="WebService">

    <cffunction name="init" returntype="Any" access="public" hint="Constructor" output="false">
        <cfargument name="our_company_id" type="numeric" required="true" />

        <cfscript>
            functions   = createObject('component','Functions');
            wodiba      = functions.GetSettings(our_company_id: arguments.our_company_id);

            variables.WDB_API_URI       = wodiba.WDB_API_URI;
            variables.WDB_API_USERNAME  = wodiba.WDB_API_USERNAME;
            variables.WDB_API_PASSWORD  = wodiba.WDB_API_PASSWORD;

            return this;
        </cfscript>
    </cffunction>

    <cffunction name="BankaBilgi" access="public" returntype="Array" output="false" hint="Bermuda web servisinden banka bilgilerini alır.">

        <cfhttp
            url="#variables.WDB_API_URI#/api/bankabilgi/"
            method="GET"
            timeout="36000"
            result="REST_Response">
                <cfhttpparam type="header" name="Content-Type" value="application/json;charset=UTF-8" />
        </cfhttp>

        <cfscript>
            if(isJSON(REST_Response.FileContent)){
                resultArray = deserializeJSON(REST_Response.FileContent);
            }
            else{
                resultArray = arrayNew(1);
            }
        </cfscript>

        <cfreturn resultArray />

    </cffunction>

    <cffunction name="SirketHesap" access="public" returntype="struct" output="false" hint="Gateway sistemine banka parametrelerinin tanımlanması için kullanılır">
        <cfargument name="vkn" type="string" required="true" />
        <cfargument name="erpSirketKodu" type="string" required="true" />
        <cfargument name="bankaKodu" type="numeric" required="true" />
        <cfargument name="uid" type="string" required="true" />
        <cfargument name="bankaAdi" type="string" required="true" />
        <cfargument name="pwd" type="string" required="true" />
        <cfargument name="sirketKodu" type="string" required="false" default="" />
        <cfargument name="islemAraligi" type="numeric" required="false" default="0" />
        <cfargument name="islemAraligiGeri" type="numeric" required="false" default="0" />
        <cfargument name="calismaAraligi" type="numeric" required="false" default="0" />
        <cfargument name="ekstraParametreler" type="struct" required="true" />
        <cfargument name="aktif" type="boolean" required="false" default="1" />
        <cfargument name="deleteAccount" type="boolean" required="false" default="0" />

        <cfsavecontent variable="REST_Request"><cfoutput>
            {
                "vkn": "#arguments.vkn#",
                "erpSirketKodu": #arguments.erpSirketKodu#,
                "bankaKodu": #int(arguments.bankaKodu)#,
                "uid": "#arguments.uid#",
                "bankaAdi": "#arguments.bankaAdi#",
                "pwd": "#arguments.pwd#",
                "sirketKodu": "#arguments.sirketKodu#",
                "islemAraligi": #arguments.islemAraligi#, <!--- varsayılan 86400 1 gün --->
                "islemAraligiGeri": #arguments.islemAraligiGeri#, <!--- varsayılan 3600 1 saat --->
                "calismaAraligi": #arguments.calismaAraligi#,
                "ekstraParametreler": [
                    <cfloop collection="#arguments.ekstraParametreler#" item="item">
				    {"key":"#item#","value":"#args[item]#"}<cfif ListFind(StructKeyList(arguments.ekstraParametreler),'#item#') Lt structCount(arguments.ekstraParametreler)>,</cfif>
				    </cfloop>
                ],
                "aktif": #arguments.aktif#
            }</cfoutput>
        </cfsavecontent>
        <cfset REST_Request = replace("#REST_Request#","\","\\","ALL") />

        <cfif arguments.deleteAccount>
            <cfset method = 'DELETE' />
        <cfelse>
            <cfset method = 'PUT' />
        </cfif>
        <cfhttp
            url="#variables.WDB_API_URI#/api/SirketHesap/"
            method="#method#"
            username="#variables.WDB_API_USERNAME#"
            password="#variables.WDB_API_PASSWORD#"
            timeout="36000"
            result="REST_Response">

                <cfhttpparam type="header" name="Content-Type" value="application/json;charset=UTF-8" />
                <cfhttpparam type="body" value="#Trim(REST_Request)#" />

        </cfhttp>

        <cfscript>
            response_data   = structNew();
            if(isJSON(REST_Response.FileContent)){
                response_data = deserializeJSON(REST_Response.FileContent);
            }
            else if(structKeyExists(REST_Response,'Errordetail')){
                response_data.mesaj = REST_Response.Errordetail & '\n' & REST_Response.FileContent;
            }
            else if(Len(REST_Response.FileContent)){
                response_data.mesaj = REST_Response.FileContent;
            }
            else {
                response_data.mesaj = REST_Response.Header;
            }
        </cfscript>

        <cfreturn response_data />

    </cffunction>

    <cffunction name="IslemGecmisi" access="public" returntype="Array" output="true" hint="Gateway sisteminden banka işlem geçmişi loglarını çeker">
        <cfargument name="baslangicTarihi" type="string" required="false" default="" />
        <cfargument name="bitisTarihi" type="string" required="false" default="" />
        <cfargument name="bankaKodu" type="numeric" required="false" default="0" />
        <cfargument name="durum" type="numeric" required="false" default="0" />

        <cfsavecontent variable="REST_Request"><cfoutput>
            {
                "baslangicTarihi" : "<cfif Len(arguments.baslangicTarihi)>#DateFormat(arguments.baslangicTarihi,'YYYY-mm-dd')#<cfelse>#DateFormat(Now(),'YYYY-mm-dd')#</cfif>"
                <cfif Len(arguments.bitisTarihi)>,"bitisTarihi" : "#DateFormat(arguments.bitisTarihi,'YYYY-mm-dd')#"</cfif>
                <cfif arguments.bankaKodu Gt 0>,"bankaKodu" : "#Int(arguments.bankaKodu)#"</cfif>
                <cfif arguments.durum Gt 0>,"durum" : "#arguments.durum#"</cfif>
            }</cfoutput>
        </cfsavecontent>

        <cfhttp
            url="#variables.WDB_API_URI#/api/islemgecmisi/"
            method="POST"
            username="#variables.WDB_API_USERNAME#"
            password="#variables.WDB_API_PASSWORD#"
            timeout="36000"
            result="REST_Response">
                <cfhttpparam type="header" name="Content-Type" value="application/json;charset=UTF-8" />
                <cfhttpparam type="body" value="#Trim(REST_Request)#" />
        </cfhttp>

        <cfscript>
            if(isJSON(REST_Response.FileContent)){
                resultArray = deserializeJSON(REST_Response.FileContent);
            }
            else{
                resultArray = arrayNew(1);
            }
        </cfscript>

        <cfreturn resultArray />

    </cffunction>

    <cffunction name="Hesaplar" access="public" returntype="Array" output="false" hint="Gateway sistemine bağlanarak banka hesap bilgileri ve bakiyelerini çeker.">

        <cfhttp
            url="#variables.WDB_API_URI#/api/hesaplar/"
            method="POST"
            username="#variables.WDB_API_USERNAME#"
            password="#variables.WDB_API_PASSWORD#"
            timeout="36000"
            result="REST_Response">
                <cfhttpparam type="header" name="Content-Type" value="application/json;charset=UTF-8" />
                <cfhttpparam type="body" value="{}" />
        </cfhttp>

        <cfscript>
            if(isJSON(REST_Response.FileContent)){
                resultArray = deserializeJSON(REST_Response.FileContent);
            }
            else{
                resultArray = arrayNew(1);
            }
        </cfscript>

        <cfreturn resultArray />

    </cffunction>

    <cffunction name="HesapHareketleri" access="public" returntype="Array" output="true" hint="Gateway sistemine bağlanarak banka hesap hareketleri çeker.">
        <cfargument name="BaslangicTarihi" type="date" required="true" hint="Banka hareketlerinin verilen tarihten itibaren alınması içindir" />
        <cfargument name="BitisTarihi" type="date" required="false" default="#dateFormat(DateAdd("d",1,now()),'YYYY-mm-dd')#" hint="" />

        <cfset bankAccounts = functions.GetBankAccounts(dsn=dsn) />

        <cfsavecontent variable="REST_Request"><cfoutput>
            {
                "baslangicTarihi" : "#arguments.BaslangicTarihi#",
                "bitisTarihi" : "#arguments.BitisTarihi#",
                "hesaplar" :
                [
                    <cfloop query="bankAccounts">
                    {
                        "bankaKodu": "#BANKAKODU#",
                        "subeKodu": "#SUBEKODU#",
                        "hesapNo": "#HESAPNO#"
                    }<cfif CurrentRow Lt RecordCount>,</cfif>
                    </cfloop>
                ]
            }
        </cfoutput></cfsavecontent>

        <cfhttp
            url="#variables.WDB_API_URI#/api/hesaphareketleri/"
            method="POST"
            username="#variables.WDB_API_USERNAME#"
            password="#variables.WDB_API_PASSWORD#"
            timeout="36000"
            result="REST_Response">
                <cfhttpparam type="header" name="Content-Type" value="application/json;charset=UTF-8" />
                <cfhttpparam type="body" value="#Trim(REST_Request)#" />
        </cfhttp>

        <cfscript>
            if(isJSON(REST_Response.FileContent)){
                resultArray = deserializeJSON(REST_Response.FileContent);
            }
            else{
                resultArray = arrayNew(1);
            }
        </cfscript>

        <cfreturn resultArray />

    </cffunction>

</cfcomponent>
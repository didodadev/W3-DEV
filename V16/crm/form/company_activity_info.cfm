<cfsavecontent variable="ay1"><cf_get_lang_main no ='180.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang_main no ='181.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang_main no='182.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang_main no='183.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang_main no='184.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang_main no='185.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang_main no='186.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang_main no='187.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang_main no='188.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang_main no='189.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang_main no='190.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang_main no='191.Aralık'></cfsavecontent>
<cfset aylar = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
<cfset color_list = 'FFFFCC,CCFFCC,FFFFCC,FF0000,99CC99,FF0000,FFCC99,FF0000,FF0000,FF0000'>
<cfparam name="attributes.start_year" default="#dateformat(now(),'yyyy')#">
<cfparam name="attributes.start_month" default="#iif(dateformat(now(),'mm') is '01',1,dateformat(now(),'mm')-1)#">
<cfparam name="attributes.finish_year" default="#dateformat(now(),'yyyy')#">
<cfparam name="attributes.finish_month" default="#iif(dateformat(now(),'mm') is '01',1,dateformat(now(),'mm')-1)#">
<cfset attributes.is_errror = true>
<cfquery name="GET_BRANCH_RELATED" datasource="#dsn#">
	SELECT 
		BRANCH.BRANCH_ID, 
		BRANCH.BRANCH_NAME, 
		COMPANY_BOYUT_DEPO_KOD.BOYUT_KODU, 
		COMPANY_BRANCH_RELATED.CARIHESAPKOD,
		OUR_COMPANY.COMP_ID
	FROM 
		BRANCH, 
		COMPANY_BRANCH_RELATED, 
		COMPANY_BOYUT_DEPO_KOD,
		OUR_COMPANY 
	WHERE 
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID AND
		COMPANY_BRANCH_RELATED.IS_SELECT = 1 AND
		COMPANY_BRANCH_RELATED.COMPANY_ID = #attributes.cpid# AND 
		COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND 
		COMPANY_BOYUT_DEPO_KOD.W_KODU = COMPANY_BRANCH_RELATED.BRANCH_ID AND 
		BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
</cfquery>
<cfsavecontent variable="title">
    <cf_get_lang no='179.Faaliyet Bilgileri'> - 
        <cfoutput>
        <cfif not len(attributes.start_month) or not len(attributes.finish_month)>
            <cf_get_lang dictionary_id="52192.Kümüle">
        <cfelse>
            <cfif len(attributes.start_month)>#listgetat(aylar,attributes.start_month,',')#/#attributes.start_year#</cfif><cfif len(attributes.finish_month)> - #listgetat(aylar,attributes.finish_month,',')#/#attributes.finish_year#</cfif>
        </cfif>
        </cfoutput>
</cfsavecontent>
<cf_box title="#title#">

<cfform name="activity_info" method="post" action="#request.self#?fuseaction=crm.popup_company_activity_info">
<input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.cpid#</cfoutput>">


    <cf_box_search>
        <cfoutput>
            <div class="form-group">
                <select name="start_year" id="start_year">
                    <cfloop from="2005" to="#year(now())#" index="i">
                        <option value="#i#" <cfif i eq attributes.start_year>selected</cfif>>#i#</option>
                    </cfloop>
                </select>
            </div>
            <div class="form-group">
                <select name="start_month" id="start_month">
                    <option value=""><cf_get_lang dictionary_id="31841.Tüm Aylar"></option>
                    <cfloop from="1" to="12" index="sm">
                        <option value="#sm#" <cfif attributes.start_month eq sm>selected</cfif>>#Evaluate("ay#sm#")#</option>
                    </cfloop>
                </select>
            </div>
            <div class="form-group">
                <select name="finish_year" id="finish_year">
                    <cfloop from="2005" to="#year(now())#" index="i">
                        <option value="#i#" <cfif i eq attributes.finish_year>selected</cfif>>#i#</option>
                    </cfloop>
                </select>
            </div>
            <div class="form-group"> 
                <select name="finish_month" id="finish_month">
                    <option value=""><cf_get_lang dictionary_id="31841.Tüm Aylar"></option>
                    <cfloop from="1" to="12" index="fm">
                        <option value="#fm#" <cfif attributes.finish_month eq fm>selected</cfif>>#Evaluate("ay#fm#")#</option>		
                    </cfloop>
                </select>
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4">
            </div> 
            <div class="form-group">
                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=crm.popup_print_activity_info#page_code#','page');" class="ui-btn ui-btn-gray2"><i class="fa fa-print"></i></a>                
            </div>
        </cfoutput>
    </cf_box_search>
</cfform>
<cf_flat_list>
    <cfscript>
        x1 = 0;		x2 = 0;		x3 = 0;		x4 = 0;		x5 = 0;
        x6 = 0;		x7 = 0;		x8 = 0;		x9 = 0;		x10 = 0;
        x11 = 0;	x12 = 0;	x13 = 0;	x14 = 0;	x15 = 0;
        x16 = 0;	x17 = 0;	x18 = 0;	x19 = 0;	x20 = 0;
        x21 = 0;	x22 = 0;	x23 = 0;	x24 = 0;	x25 = 0;
        x26 = 0;	x27 = 0;	x28 = 0;	x55 = 0;	x56=0;
    </cfscript>
    <cfoutput query="get_branch_related">
        <cftry>
        <cfscript>
            fatura_toplam = 0;
            fatura_adet = 0;
            hizmet_fatura_toplami = 0;
            hizmet_fatura_adet = 0;
            iade_toplam = 0;
            iade_adet = 0;
            odenen_tutar = 0;
            ortalama_gun_tutar = 0;
            degerkademe1 = 0;
            degerkademe2 = 0;
            degerkademe3 = 0;
            degerkademe4 = 0;
            degerkademe5 = 0;
            acik_tutar = 0;
            ortalama_vade = 0;
            brut_tutar = 0;
            kdvtenzildeger = 0;
            mfadet = 0;
            eczacikar = 0;
            mfiskonto = 0;
            kurumiskonto = 0;
            ticariiskonto = 0;
            pesiniskonto = 0;
            kdvtoplam = 0;
            kutu_adet = 0;
            nettutar = 0;
            digerkdv = 0;
            nettoplam_deger = 0;
            toplam_fattop = 0;
            toplamortvade = 0;
            aciktoplam = 0;
        </cfscript>
        <cfquery name="GET_COMPANY_BOYUT" datasource="mushizgun">
            SELECT ETICARETKOD, ETICARETIP,DEHA FROM DEPOLAR WHERE DEPOKODU = '#get_branch_related.boyut_kodu#'
        </cfquery>
       
        <cffunction name="convertDotNetDataset1" returnType="any">
            <cfargument name="dataset" type="struct" required="true">
            <!--- BK Eski Hali 20160216 6 aya kaldirilsin
			<cfset var result = structNew() />
            <cfset var aDataset = dataset.get_any() />
            <cfset var xSchema  = xmlParse(aDataset[1]) />
            <cfset var xTables = xSchema["xs:schema"]["xs:element"]["xs:complexType"]["xs:choice"] />
            <cfset var xData  = xmlParse(aDataset[2]) />
            <cfset var xRows = xData["diffgr:diffgram"]["AktiviteRaporu"] />
            <cfset var tableName = "" />
            <cfset var thisRow = "" />
            <cfset var i = "" />
            <cfset var j = "" />
            <cfloop from="1" to="#arrayLen(xTables.xmlChildren)#" index="i">
                <cfset tableName = xTables.xmlChildren[i].xmlAttributes.name />
                <cfset xColumns = xTables.xmlChildren[i].xmlChildren[1].xmlChildren[1].xmlChildren/>
                <cfset result[tableName] = queryNew("") />
                <cfloop from="1" to="#arrayLen(xColumns)#" index="j">
                    <cfset queryAddColumn(result[tableName], xColumns[j].xmlAttributes.name, arrayNew(1)) />
                </cfloop>
            </cfloop>
            <cfloop from="1" to="#arrayLen(xRows.xmlChildren)#" index="i">
                <cfset thisRow = xRows.xmlChildren[i] />
                <cfset tableName = thisRow.xmlName />
                <cfset queryAddRow(result[tableName], 1) />
                <cfloop from="1" to="#arrayLen(thisRow.xmlChildren)#" index="j">
                    <cfset querySetCell(result[tableName], thisRow.xmlChildren[j].xmlName, thisRow.xmlChildren[j].xmlText, result[tableName].recordCount) />
                </cfloop>
            </cfloop> --->
            
			
            <cfset var result = structNew() />
            <cfset xTables = "#xmlParse(dataset.Filecontent).Envelope.Body.MusteriAktivite2Response.MusteriAktivite2Result.diffgram.AktiviteRaporu.DonemRaporu.XmlChildren#"><!--- .Envelope.Body.MusteriAktivite2Response.MusteriAktivite2Result.diffgram.AktiviteRaporu.DonemRaporu.XmlChildren#" --->
            <cfset xTables2 = "#xmlParse(dataset.Filecontent).Envelope.Body.MusteriAktivite2Response.MusteriAktivite2Result.diffgram.AktiviteRaporu.DonemRaporu#">
            
			<cfset var qOne = "" />
            <cfset qOneArray = ArrayNew(1)> 
            <cfset qOne = queryNew("") />            

            <cfloop from="1" to="#arrayLen(xTables)#" index="i">
				<cfset ColumnName = xTables[i].XmlName />
                <cfset QueryAddColumn(qOne,ColumnName,qOneArray)/>
            </cfloop>
			<cfset queryAddRow(qOne, arrayLen(xTables2)) />
			
            <cfloop from="1" to="#arrayLen(xTables2)#" index="j">
				<cfset thisRow = xmlParse(dataset.Filecontent).Envelope.Body.MusteriAktivite2Response.MusteriAktivite2Result.diffgram.AktiviteRaporu.DonemRaporu[j].XmlChildren />
                <cfloop from="1" to="#arrayLen(xTables)#" index="i">
					<cfset ColumnName = thisRow[i].XmlName />
                    <cfset ColumnValue = thisRow[i].XmlText />
					<cfset querySetCell(qOne, ColumnName, ColumnValue,j )/>
                </cfloop>
			</cfloop>
            <cfreturn qOne>
            
        </cffunction>
        
        <cffunction name="convertDotNetDataset" returnType="struct">
            <cfargument name="dataset" required="true">
            <cfset var result = structNew() />
            <cfset var aDataset = dataset.get_any() />
            <cfset var xSchema  = xmlParse(aDataset[1]) />
            <cfset var xTables = xSchema["xs:schema"]["xs:element"]["xs:complexType"]["xs:choice"] />
            <cfset var xData  = xmlParse(aDataset[2]) />
            <cfset var xRows = xData["diffgr:diffgram"]["NewDataSet"] />
            <cfset var tableName = "" />
            <cfset var thisRow = "" />
            <cfset var i = "" />
            <cfset var j = "" />
            <cfloop from="1" to="#arrayLen(xTables.xmlChildren)#" index="i">
                <cfset tableName = xTables.xmlChildren[i].xmlAttributes.name />
                <cfset xColumns = xTables.xmlChildren[i].xmlChildren[1].xmlChildren[1].xmlChildren/>
                <cfset result[tableName] = queryNew("") />
                <cfloop from="1" to="#arrayLen(xColumns)#" index="j">
                    <cfset queryAddColumn(result[tableName], xColumns[j].xmlAttributes.name, arrayNew(1)) />
                </cfloop>
            </cfloop>
            <cfloop from="1" to="#arrayLen(xRows.xmlChildren)#" index="i">
                <cfset thisRow = xRows.xmlChildren[i] />
                <cfset tableName = thisRow.xmlName />
                <cfset queryAddRow(result[tableName], 1) />
                <cfloop from="1" to="#arrayLen(thisRow.xmlChildren)#" index="j">
                    <cfset querySetCell(result[tableName], thisRow.xmlChildren[j].xmlName, thisRow.xmlChildren[j].xmlText, result[tableName].recordCount) />
                </cfloop>
            </cfloop>
            <cfreturn result>
        </cffunction>
        
        <cfif get_company_boyut.deha eq 1>
            <!--- BK Eski Hali 20160216 6 aya kaldirilsin
			<cfinvoke 
                webservice="http://#get_company_boyut.eticaretip#//DepoWebServisleri/musteriaktiviteraporu.asmx?wsdl"
                method="MusteriAktivite2"
                returnvariable="get_invoice_info">
                <cfinvokeargument name="DepoKod" value="#get_branch_related.boyut_kodu#"/>
                <cfinvokeargument name="Kullanici" value="#get_company_boyut.eticaretip#"/>
                <cfinvokeargument name="Sifre" value="#get_company_boyut.eticaretkod#"/>
                <cfinvokeargument name="CariHesapKod" value="#get_branch_related.carihesapkod#"/>
                <cfif len(attributes.start_month)>
                    <cfinvokeargument name="Donem1" value="#numberformat(attributes.start_year,'0000')##numberformat(attributes.start_month,'00')#"/>
                <cfelse>
                    <cfinvokeargument name="Donem1" value=""/>
                </cfif>
                <cfif len(attributes.finish_month)>
                    <cfinvokeargument name="Donem2" value="#numberformat(attributes.finish_year,'0000')##numberformat(attributes.finish_month,'00')#"/>
                <cfelse>
                    <cfinvokeargument name="Donem2" value=""/>
                </cfif>
            </cfinvoke> --->
            
            <cfsavecontent variable="aktivite_data"><cfoutput>
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
               <soapenv:Header/>
               <soapenv:Body>
                  <tem:MusteriAktivite2>
                     <tem:DepoKod>#get_branch_related.boyut_kodu#</tem:DepoKod>
                     <tem:Kullanici>#get_company_boyut.eticaretip#</tem:Kullanici>
                     <tem:Sifre>#get_company_boyut.eticaretkod#</tem:Sifre>
                     <tem:CariHesapKod>#get_branch_related.carihesapkod#</tem:CariHesapKod>
                     <tem:Donem1><cfif len(attributes.start_month)>#numberformat(attributes.start_year,'0000')##numberformat(attributes.start_month,'00')#<cfelse></cfif></tem:Donem1>
                     <tem:Donem2><cfif len(attributes.finish_month)>#numberformat(attributes.finish_year,'0000')##numberformat(attributes.finish_month,'00')#<cfelse></cfif></tem:Donem2>
                  </tem:MusteriAktivite2>
               </soapenv:Body>
            </soapenv:Envelope>
            </cfoutput>
            </cfsavecontent>

            <cfhttp url="http://#get_company_boyut.eticaretip#//DepoWebServisleri/musteriaktiviteraporu.asmx?wsdl" method="post" result="get_invoice_info">
                <cfhttpparam type="header" name="content-type" value="text/xml">
                <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/MusteriAktivite2">
                <cfhttpparam type="header" name="content-length" value="#len(aktivite_data)#">
                <cfhttpparam type="header" name="charset" value="utf-8">
                <cfhttpparam type="xml" name="message" value="#trim(aktivite_data)#">
            </cfhttp>             
        <cfelse>
            <cfinvoke 
                webservice="http://#get_company_boyut.eticaretip#/CRMTOC100WS/BoyutIslem.asmx?wsdl"
                method="MusteriAktivite"
                returnvariable="get_invoice_info">
                <cfinvokeargument name="DepoKod" value="#get_branch_related.boyut_kodu#"/>
                <cfinvokeargument name="Kullanici" value="#get_company_boyut.eticaretip#"/>
                <cfinvokeargument name="Sifre" value="#get_company_boyut.eticaretkod#"/>
                <cfinvokeargument name="CariHesapKod" value="#get_branch_related.carihesapkod#"/>
                <cfif len(attributes.start_month)>
                    <cfinvokeargument name="Donem1" value="#numberformat(attributes.start_year,'0000')##numberformat(attributes.start_month,'00')#"/>
                <cfelse>
                    <cfinvokeargument name="Donem1" value=""/>
                </cfif>
                <cfif len(attributes.finish_month)>
                    <cfinvokeargument name="Donem2" value="#numberformat(attributes.finish_year,'0000')##numberformat(attributes.finish_month,'00')#"/>
                <cfelse>
                    <cfinvokeargument name="Donem2" value=""/>
                </cfif>
            </cfinvoke>
        </cfif> 
        <cfif get_company_boyut.deha eq 1>
            <cfset myquery = convertDotNetDataset1(get_invoice_info)>
            <!--- <cfset myquery = get_invoice_info.DonemRaporu> --->
            <cfloop query="myquery">
				<cfscript>
                    aciktoplam = aciktoplam + replace(myquery.aciktut,',','.')*replace(myquery.acikvade,',','.');
                    toplam_fattop = toplam_fattop + replace(myquery.fattop,',','.')*replace(myquery.ortvade,',','.');
                    toplamortvade = toplamortvade + replace(myquery.fattop,',','.');
                    fatura_toplam = fatura_toplam + replace(myquery.fattop,',','.');
                    fatura_adet = fatura_adet + replace(myquery.fatadet,',','.');
                    hizmet_fatura_toplami = hizmet_fatura_toplami + replace(myquery.hfattop,',','.');
                    hizmet_fatura_adet = replace(myquery.hfatadet,',','.');
                    iade_toplam = iade_toplam + replace(myquery.iadetop,',','.');
                    iade_adet = iade_adet + replace(myquery.iadeadet,',','.');
                    odenen_tutar = odenen_tutar + replace(myquery.odenentut,',','.');
                    degerkademe1 = degerkademe1 + replace(myquery.kademe1,',','.');
                    degerkademe2 = degerkademe2 + replace(myquery.kademe2,',','.');
                    degerkademe3 = degerkademe3 + replace(myquery.kademe3,',','.');
                    degerkademe4 = degerkademe4 + replace(myquery.kademe4,',','.');
                    degerkademe5 = degerkademe5 + replace(myquery.kademe5,',','.');
                    acik_tutar = acik_tutar + replace(myquery.aciktut,',','.');
                    mfadet = mfadet + replace(myquery.mftop,',','.');
                    
                    brut_tutar = brut_tutar + replace(myquery.bruttutar,',','.');
                    kdvtenzildeger = kdvtenzildeger + replace(myquery.kdvtenzil,',','.');
                    eczacikar = eczacikar + replace(myquery.eczkari,',','.');
                    mfiskonto = mfiskonto + replace(myquery.mfisk,',','.');
                    kurumiskonto = kurumiskonto + replace(myquery.kurumisk,',','.');
                    ticariiskonto = ticariiskonto + replace(myquery.ticariisk,',','.');
                    pesiniskonto = pesiniskonto + replace(myquery.pesinisk,',','.');
                    kdvtoplam = kdvtoplam + replace(myquery.kdvtop,',','.');
                    kutu_adet = kutu_adet + replace(myquery.adettop,',','.');
                    nettutar = nettutar + replace(myquery.fattop,',','.');
                    digerkdv = digerkdv + replace(myquery.kademe0,',','.');
                    nettoplam_deger = degerkademe1 + degerkademe2 + degerkademe3 + degerkademe4 + degerkademe5 + digerkdv;
                </cfscript>
            </cfloop>
        <cfelse>
            <cfset get_invoice_info = convertDotNetDataset(get_invoice_info)>
            <cfset myquery = get_invoice_info.MusteriAktiviteKayit>
            <cfloop query="myquery">
                <cfif donem lte year(now())&numberformat((month(now())-1),'00')>
                <cfscript>
                    aciktoplam = aciktoplam + myquery.aciktut*myquery.acikvade;
                    toplam_fattop = toplam_fattop + myquery.fattop*myquery.ortvade;
                    toplamortvade = toplamortvade + myquery.fattop;
                    fatura_toplam = fatura_toplam + myquery.fattop;
                    fatura_adet = fatura_adet + myquery.fatadet;
                    hizmet_fatura_toplami = hizmet_fatura_toplami + myquery.hfattop;
                    hizmet_fatura_adet = myquery.hfatadet;
                    iade_toplam = iade_toplam + myquery.iadetop;
                    iade_adet = iade_adet + myquery.iadeadet;
                    odenen_tutar = odenen_tutar + myquery.odenentut;
                    degerkademe1 = degerkademe1 + myquery.kademe1;
                    degerkademe2 = degerkademe2 + myquery.kademe2;
                    degerkademe3 = degerkademe3 + myquery.kademe3;
                    degerkademe4 = degerkademe4 + myquery.kademe4;
                    degerkademe5 = degerkademe5 + myquery.kademe5;
                    acik_tutar = acik_tutar + myquery.aciktut;
                    
                    brut_tutar = brut_tutar + myquery.bruttutar;
                    kdvtenzildeger = kdvtenzildeger + myquery.kdvtenzil;
                    mfadet = mfadet + myquery.mftop;
                    eczacikar = eczacikar + myquery.eczkari;
                    mfiskonto = mfiskonto + myquery.mfisk;
                    kurumiskonto = kurumiskonto + myquery.kurumisk;
                    ticariiskonto = ticariiskonto + myquery.ticariisk;
                    pesiniskonto = pesiniskonto + myquery.pesinisk;
                    kdvtoplam = kdvtoplam + myquery.kdvtop;
                    kutu_adet = kutu_adet + myquery.adettop;
                    nettutar = nettutar + myquery.fattop;
                    digerkdv = digerkdv + myquery.kademe0;
                    nettoplam_deger = degerkademe1 + degerkademe2 + degerkademe3 + degerkademe4 + degerkademe5 + digerkdv;
                </cfscript>
                </cfif>
            </cfloop>
        </cfif>
        
        <cfscript>
            if(acik_tutar neq 0) {
                ortalama_vade = aciktoplam / acik_tutar; }
            else {
                ortalama_vade = 0; }
            if(toplamortvade neq 0) {
                ortalama_gun_tutar = toplam_fattop/toplamortvade; }
            else {
                ortalama_gun_tutar = 0; }
                
            x56 = x56 + aciktoplam;
            x55 = x55 + toplam_fattop;
            x1 = x1 + fatura_toplam;
            x2 = x2 + fatura_adet;
            x3 = x3 + hizmet_fatura_toplami;
            x4 = x4 + hizmet_fatura_adet;
            x5 = x5 + iade_toplam;
            x6 = x6 + iade_adet;
            x7 = x7 + odenen_tutar;
            x9 = x9 + degerkademe1;
            x10 = x10 + degerkademe2;
            x11 = x11 + degerkademe3;
            x12 = x12 + degerkademe4;
            x13 = x13 + degerkademe5;
            x14 = x14 + acik_tutar;
            x15 = x15 + ortalama_vade;
            x16 = x16 + brut_tutar;
            x17 = x17 + kdvtenzildeger;
            x18 = x18 + mfadet;
            x19 = x19 + eczacikar;
            x20 = x20 + mfiskonto;
            x21 = x21 + kurumiskonto;
            x22 = x22 + ticariiskonto;
            x23 = x23 + pesiniskonto;
            x24 = x24 + kdvtoplam;
            x25 = x25 + kutu_adet;
            x26 = x26 + nettutar;
            x27 = x27 + digerkdv;
            x28 = x28 + nettoplam_deger;
        </cfscript>
        <tr>
            <th bgcolor="#listgetat(color_list,comp_id,',')#">
                #branch_name#
            </th>
        </tr>
        <tr>
            <td>
            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td>
                    <table cellspacing="0" cellpadding="0" border="0">
                        <tr>
                            <td>
                            <table cellspacing="1" cellpadding="2" border="0" width="100%">
                                <tr class="color-row">
                                    <td width="180" class="txtboldblue"><cf_get_lang dictionary_id="48962.Fatura Toplamı"></td>
                                    <td width="150"  style="text-align:right;">#tlformat(fatura_toplam)# #session.ep.money#</td>
                                    <td width="40"></td>
                                    <td width="150" class="txtboldblue"><cf_get_lang dictionary_id="50112.Fatura Sayısı"></td>
                                    <td width="150"  style="text-align:right;">#fatura_adet# <cf_get_lang dictionary_id="58082.Adet"></td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue"><cf_get_lang dictionary_id="30548.Hizmet Fatura Toplamı"></td>
                                    <td style="text-align:right;">#tlformat(hizmet_fatura_toplami)# #session.ep.money#</td>
                                    <td>&nbsp;</td>
                                    <td class="txtboldblue"><cf_get_lang dictionary_id="30547.Hizmet Fatura Sayısı"></td>
                                    <td style="text-align:right;">#hizmet_fatura_adet# <cf_get_lang dictionary_id="58082.Adet"></td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue"><cf_get_lang dictionary_id="30546.İade Toplamı"></td>
                                    <td style="text-align:right;">#tlformat(iade_toplam)# #session.ep.money#</td>
                                    <td>&nbsp;</td>
                                    <td class="txtboldblue"><cf_get_lang dictionary_id="30545.İade Sayısı"></td>
                                    <td style="text-align:right;">#iade_adet# <cf_get_lang dictionary_id="58082.Adet"></td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue"><cf_get_lang dictionary_id="48289.Ödenen Tutar"></td>
                                    <td style="text-align:right;">#tlformat(odenen_tutar)# #session.ep.money#</td>
                                    <td>&nbsp;</td>
                                    <td class="txtboldblue"><cf_get_lang dictionary_id="51926.Ortalama Gün"> <cf_get_lang dictionary_id="57448.Satış"></td>
                                    <td style="text-align:right;">#listfirst(ortalama_gun_tutar,'.')# <cf_get_lang dictionary_id="57490.Gün"></td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue"><cf_get_lang dictionary_id="30533.Açık Tutar"></td>
                                    <td style="text-align:right;">#tlformat(acik_tutar)# #session.ep.money#</td>
                                    <td>&nbsp;</td>
                                    <td class="txtboldblue"><cf_get_lang dictionary_id="30582.Açık Tutar Ortalama Vade"></td>
                                    <td style="text-align:right;">#listfirst(ortalama_vade,'.')# <cf_get_lang dictionary_id="57490.Gün"></td>
                                </tr>
                            </table>
                            </td>
                        </tr>
                    </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>
                    <table cellspacing="0" cellpadding="0" border="0">
                        <tr>
                            <td>
                            <table cellspacing="1" cellpadding="2" width="100%" border="0">
                                <tr class="color-row">
                                    <td width="180" class="txtboldblue"><cf_get_lang dictionary_id="30577.P S F Üzerinden"></td>
                                    <td width="150"  style="text-align:right;">#tlformat(brut_tutar)# #session.ep.money#</td>
                                    <td width="40"></td>
                                    <td width="150" class="txtboldblue"><cf_get_lang dictionary_id="51754.Kutu Adedi"></td>
                                    <td width="150"  style="text-align:right;">#kutu_adet# <cf_get_lang dictionary_id="58082.Adet"></td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue"><cf_get_lang dictionary_id="30746.KDV Tenzil"></td>
                                    <td style="text-align:right;">#tlformat(kdvtenzildeger)# #session.ep.money#</td>
                                    <td style="text-align:right;">&nbsp;</td>
                                    <td class="txtboldblue"><cf_get_lang dictionary_id="30730.M F Adedi"></td>
                                    <td style="text-align:right;">#mfadet# <cf_get_lang dictionary_id="58082.Adet"></td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue" bgcolor="##C6FBFA"><b><cf_get_lang dictionary_id="33986.Kalan Tutar"></b></td>
                                    <td bgcolor="##C6FBFA" style="text-align:right;"><b>#tlformat(brut_tutar-kdvtenzildeger)# #session.ep.money#</b></td>
                                    <td style="text-align:right;">&nbsp;</td>
                                    <td class="txtboldblue">&nbsp;</td>
                                    <td style="text-align:right;">&nbsp;</td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue"><cf_get_lang dictionary_id="30576.Eczacı Kar Top."></td>
                                    <td style="text-align:right;">#tlformat(eczacikar)# #session.ep.money#</td>
                                    <td style="text-align:right;">%<cfif brut_tutar-kdvtenzildeger neq 0>#tlformat((eczacikar/(brut_tutar-kdvtenzildeger))*100)#<cfelse>0</cfif></td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue" bgcolor="##E6FBBD"><b><cf_get_lang dictionary_id="33986.Kalan Tutar"></b></td>
                                    <td bgcolor="##E6FBBD" style="text-align:right;"><b>#tlformat(brut_tutar-kdvtenzildeger-eczacikar)# #session.ep.money#</b></td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue"><cf_get_lang dictionary_id="30575.M F İskontosu"></td>
                                    <td style="text-align:right;">#tlformat(mfiskonto)# #session.ep.money#</td>
                                    <td style="text-align:right;">%<cfif brut_tutar-kdvtenzildeger-eczacikar neq 0>#tlformat((mfiskonto/(brut_tutar-kdvtenzildeger-eczacikar))*100)#<cfelse>0</cfif></td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue" bgcolor="##F5D2B8"><b><cf_get_lang dictionary_id="33986.Kalan Tutar"></b></td>
                                    <td bgcolor="##F5D2B8" style="text-align:right;"><b>#tlformat(brut_tutar-kdvtenzildeger-eczacikar-mfiskonto)# #session.ep.money#</b></td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue"><cf_get_lang dictionary_id="30755.Kurum İskontosu"></td>
                                    <td style="text-align:right;">#tlformat(kurumiskonto)# #session.ep.money#</td>
                                    <td style="text-align:right;">%<cfif brut_tutar-kdvtenzildeger-eczacikar-mfiskonto neq 0>#tlformat((kurumiskonto/(brut_tutar-kdvtenzildeger-eczacikar-mfiskonto))*100)#<cfelse>0</cfif></td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue" bgcolor="##FFFFCC"><b><cf_get_lang dictionary_id="33986.Kalan Tutar"></b></td>
                                    <td bgcolor="##FFFFCC" style="text-align:right;"><b>#tlformat(brut_tutar-kdvtenzildeger-eczacikar-mfiskonto-kurumiskonto)# #session.ep.money#</b></td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue"><cf_get_lang dictionary_id="30752.Ticari İskonto"></td>
                                    <td style="text-align:right;">#tlformat(ticariiskonto)# #session.ep.money#</td>
                                    <td style="text-align:right;">%<cfif brut_tutar-kdvtenzildeger-eczacikar-mfiskonto-kurumiskonto neq 0>#tlformat((ticariiskonto/(brut_tutar-kdvtenzildeger-eczacikar-mfiskonto-kurumiskonto))*100)#<cfelse>0</cfif></td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue" bgcolor="##FEB8CB"><b><cf_get_lang dictionary_id="33986.Kalan tutar"></b></td>
                                    <td bgcolor="##FEB8CB" style="text-align:right;"><b>#tlformat(brut_tutar-kdvtenzildeger-eczacikar-mfiskonto-kurumiskonto-ticariiskonto)# #session.ep.money#</b></td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr class="color-row"> 
                                    <td class="txtboldblue"><cf_get_lang dictionary_id="50861.Peşin İskonto"></td>
                                    <td style="text-align:right;">#tlformat(pesiniskonto)# #session.ep.money#</td>
                                    <td style="text-align:right;">%<cfif brut_tutar-kdvtenzildeger-eczacikar-mfiskonto-kurumiskonto-ticariiskonto neq 0>#tlformat((pesiniskonto/(brut_tutar-kdvtenzildeger-eczacikar-mfiskonto-kurumiskonto-ticariiskonto))*100)#<cfelse>0</cfif></td>
                                    <td><b>#tlformat(eczacikar+mfiskonto+kurumiskonto+pesiniskonto+ticariiskonto)# #session.ep.money#</b></td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue"><br/><cf_get_lang dictionary_id="57643.KDV Toplamı"></td>
                                    <td colspan="2"  style="text-align:right;"><br/>#tlformat(kdvtoplam)# #session.ep.money#</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue"><cf_get_lang dictionary_id="39432.Net Tutar"></td>
                                    <td colspan="2"  style="text-align:right;">#tlformat(nettutar)# #session.ep.money#</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                            </table>
                            </td>
                        </tr>
                    </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>
                    <table cellspacing="0" cellpadding="0" border="0">
                        <tr>
                            <td>
                            <table cellspacing="1" cellpadding="2" width="100%" border="0">
                                <tr class="color-row">
                                    <td class="txtboldblue" width="180">1.<cf_get_lang dictionary_id="30751.Kademe Tutarı ( KDV 'siz )"></td>
                                    <td width="150"  style="text-align:right;">#tlformat(degerkademe1)# #session.ep.money#</td>
                                    <td width="40"  style="text-align:right;">%<cfif nettoplam_deger neq 0>#tlformat((degerkademe1/nettoplam_deger)*100)#<cfelse>0</cfif></td>
                                    <td colspan="2" width="300" rowspan="9" valign="top">
                                        <cfchart 
                                            chartheight="200" 
                                            chartwidth="400" 
                                            show3d="no" 
                                            showlegend="yes" 
                                            font="arial" 
                                            format="jpg" fontsize="10">
                                            <cfchartseries type="bar" colorlist="yellow,red,blue,gray,green,black">
                                            <cfif nettoplam_deger neq 0>	
                                                <cfchartdata item="1 Kademe" value="#((degerkademe1/nettoplam_deger)*100)#">
                                                <cfchartdata item="2 Kademe" value="#((degerkademe2/nettoplam_deger)*100)#">
                                                <cfchartdata item="3 Kademe" value="#((degerkademe3/nettoplam_deger)*100)#">
                                                <cfchartdata item="4 Kademe" value="#((degerkademe4/nettoplam_deger)*100)#">
                                                <cfchartdata item="5 Kademe" value="#((degerkademe5/nettoplam_deger)*100)#">
                                                <cfchartdata item="Diğer" value="#((digerkdv/nettoplam_deger)*100)#">
                                            <cfelse>
                                                <cfchartdata item="1 Kademe" value="0">
                                                <cfchartdata item="2 Kademe" value="0">
                                                <cfchartdata item="3 Kademe" value="0">
                                                <cfchartdata item="4 Kademe" value="0">
                                                <cfchartdata item="5 Kademe" value="0">
                                                <cfchartdata item="Diğer" value="0">
                                            </cfif>
                                            </cfchartseries>
                                        </cfchart>
                                    </td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue">2.<cf_get_lang dictionary_id="30751.Kademe Tutarı ( KDV 'siz )"></td>
                                    <td style="text-align:right;">#tlformat(degerkademe2)# #session.ep.money#</td>
                                    <td style="text-align:right;">%<cfif nettoplam_deger neq 0>#tlformat((degerkademe2/nettoplam_deger)*100)#<cfelse>0</cfif></td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue">3.<cf_get_lang dictionary_id="30751.Kademe Tutarı ( KDV 'siz )"></td>
                                    <td style="text-align:right;">#tlformat(degerkademe3)# #session.ep.money#</td>
                                    <td style="text-align:right;">%<cfif nettoplam_deger neq 0>#tlformat((degerkademe3/nettoplam_deger)*100)#<cfelse>0</cfif></td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue">4.<cf_get_lang dictionary_id="30751.Kademe Tutarı ( KDV 'siz )"></td>
                                    <td style="text-align:right;">#tlformat(degerkademe4)# #session.ep.money#</td>
                                    <td style="text-align:right;">%<cfif nettoplam_deger neq 0>#tlformat((degerkademe4/nettoplam_deger)*100)#<cfelse>0</cfif></td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue">5.<cf_get_lang dictionary_id="30751.Kademe Tutarı ( KDV 'siz )"></td>
                                    <td style="text-align:right;">#tlformat(degerkademe5)# #session.ep.money#</td>
                                    <td style="text-align:right;">%<cfif nettoplam_deger neq 0>#tlformat((degerkademe5/nettoplam_deger)*100)#<cfelse>0</cfif></td>
                                </tr>
                                <tr class="color-row">
                                    <td class="txtboldblue"><cf_get_lang dictionary_id="30747.Diğer ( KDV 'siz )"></td>
                                    <td style="text-align:right;">#tlformat(digerkdv)# #session.ep.money#</td>
                                    <td style="text-align:right;">%<cfif nettoplam_deger neq 0>#tlformat((digerkdv/nettoplam_deger)*100)#<cfelse>0</cfif></td>
                                </tr>
                                <tr class="color-row">
                                    <td colspan="3">&nbsp;</td>
                                </tr>
                                <tr class="color-row">
                                    <td colspan="3">&nbsp;</td>
                                </tr>
                                <tr class="color-row">
                                    <td colspan="3">&nbsp;</td>
                                </tr>
                            </table>
                            </td>
                        </tr>
                    </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>
            </table>
            </td>
        </tr>
        <cfcatch type="any">
            <cfset attributes.is_errror = false>
            <tr height="22">
                <th class="txtboldblue">#branch_name#</th>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id="57484.Kayıt Yok">!</td>
            </tr>
        </cfcatch>
        </cftry>
    </cfoutput>
    <cfif get_branch_related.recordcount>
        <cfif attributes.is_errror>
        <cfoutput>
            <tr height="22">
                <td class="txtboldblue"><cf_get_lang dictionary_id="50969.Grup Toplam"></td>
            </tr>
            <tr>
                <td>
                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td>
                        <table cellspacing="0" cellpadding="0" border="0">
                            <tr>
                                <td>
                                <table cellspacing="1" cellpadding="2" border="0" width="100%">
                                    <tr class="color-row">
                                        <td width="180" class="txtboldblue"><cf_get_lang dictionary_id="48962.Fatura Toplamı"></td>
                                        <td width="150" style="text-align:right;">#tlformat(x1)# #session.ep.money#</td>
                                        <td width="40">&nbsp;</td>
                                        <td width="150" class="txtboldblue"><cf_get_lang dictionary_id="50112.Fatura Sayısı"></td>
                                        <td width="150" style="text-align:right;">#x2# <cf_get_lang dictionary_id="58082.Adet"></td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue"><cf_get_lang dictionary_id="30548.Hizmet Fatura Toplamı"></td>
                                        <td style="text-align:right;">#tlformat(x3)# #session.ep.money#</td>
                                        <td>&nbsp;</td>
                                        <td class="txtboldblue"><cf_get_lang dictionary_id="30547.Hizmet Fatura Sayısı"></td>
                                        <td style="text-align:right;">#x4# <cf_get_lang dictionary_id="58082.Adet"></td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue"><cf_get_lang dictionary_id="30546.İade Toplamı"></td>
                                        <td style="text-align:right;">#tlformat(x5)# #session.ep.money#</td>
                                        <td>&nbsp;</td>
                                        <td class="txtboldblue"><cf_get_lang dictionary_id="30545.İade Sayısı"></td>
                                        <td style="text-align:right;">#x6# <cf_get_lang dictionary_id="58082.Adet"></td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue"><cf_get_lang dictionary_id="48289.Ödenen Tutar"></td>
                                        <td style="text-align:right;">#tlformat(x7)# #session.ep.money#</td>
                                        <td>&nbsp;</td>
                                        <td class="txtboldblue"><cf_get_lang dictionary_id="30543.Ortalama Gün Satış"></td>
                                        <td style="text-align:right;"><cfif x1 neq 0>#listfirst(x55/x1,'.')#<cfelse>0</cfif><cf_get_lang dictionary_id="57490.Gün"></td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue"><cf_get_lang dictionary_id="30533.Açık Tutar"></td>
                                        <td style="text-align:right;">#tlformat(x14)# #session.ep.money#</td>
                                        <td>&nbsp;</td>
                                        <td class="txtboldblue"><cf_get_lang dictionary_id="30582.Açık Tutar Ortalama Vade"></td>
                                        <td style="text-align:right;"><cfif x14 neq 0>#listfirst(x56/x14,'.')#<cfelse>0</cfif><cf_get_lang dictionary_id="57490.Gün"></td>
                                    </tr>
                                </table>
                                </td>
                            </tr>
                        </table>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                        <table cellspacing="0" cellpadding="0" border="0">
                            <tr>
                                <td>
                                <table cellspacing="1" cellpadding="2" width="100%" border="0">
                                    <tr class="color-row">
                                        <td width="180" class="txtboldblue"><cf_get_lang dictionary_id="30577.P S F Üzerinden"></td>
                                        <td width="150"  style="text-align:right;">#tlformat(x16)# #session.ep.money#</td>
                                        <td width="40"></td>
                                        <td width="150" class="txtboldblue"><cf_get_lang dictionary_id="51754.Kutu Adedi"></td>
                                        <td width="150"  style="text-align:right;">#x25# <cf_get_lang dictionary_id="58082.Adet"></td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue"><cf_get_lang dictionary_id="30746.KDV Tenzil"></td>
                                        <td style="text-align:right;" >#tlformat(x17)# #session.ep.money#</td>
                                        <td style="text-align:right;" >&nbsp;</td>
                                        <td class="txtboldblue"><cf_get_lang dictionary_id="30730.M F Adedi"></td>
                                        <td style="text-align:right;">#x18# <cf_get_lang dictionary_id="58082.Adet"></td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue" bgcolor="##C6FBFA"><b><cf_get_lang dictionary_id="33986.Kalan Tutar"></b></td>
                                        <td bgcolor="##C6FBFA" style="text-align:right;"><b>#tlformat(x16-x17)# #session.ep.money#</b></td>
                                        <td style="text-align:right;">&nbsp;</td>
                                        <td class="txtboldblue">&nbsp;</td>
                                        <td style="text-align:right;">&nbsp;</td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue"><cf_get_lang dictionary_id="30576.Eczacı Kar Top"></td>
                                        <td style="text-align:right;">#tlformat(x19)# #session.ep.money#</td>
                                        <td style="text-align:right;">%<cfif (x16-x17) neq 0>#tlformat((x19/(x16-x17))*100)#<cfelse>0</cfif></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue" bgcolor="##E6FBBD"><b><cf_get_lang dictionary_id="33986.Kalan Tutar"></b></td>
                                        <td bgcolor="##E6FBBD" style="text-align:right;"><b>#tlformat(x16-x17-x19)# #session.ep.money#</b></td>
                                        <td style="text-align:right;">&nbsp;</td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue"><cf_get_lang dictionary_id="30575.M F İskontosu"></td>
                                        <td style="text-align:right;">#tlformat(x20)# #session.ep.money#</td>
                                        <td style="text-align:right;">%<cfif (x16-x17-x19) neq 0>#tlformat((x20/(x16-x17-x19))*100)#<cfelse>0</cfif></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue" bgcolor="##F5D2B8"><b><cf_get_lang dictionary_id="33986.Kalan Tutar"></b></td>
                                        <td bgcolor="##F5D2B8" style="text-align:right;"><b>#tlformat(x16-x17-x19-x20)# #session.ep.money#</b></td>
                                        <td style="text-align:right;">&nbsp;</td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue"><cf_get_lang dictionary_id="30755.Kurum İskontosu"></td>
                                        <td style="text-align:right;">#tlformat(x21)# #session.ep.money#</td>
                                        <td style="text-align:right;">%<cfif (x16-x17-x19-x20) neq 0>#tlformat((x21/(x16-x17-x19-x20))*100)#<cfelse>0</cfif></td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue" bgcolor="##FFFFCC"><b><cf_get_lang dictionary_id="33986.Kalan tutar"></b></td>
                                        <td bgcolor="##FFFFCC" style="text-align:right;"><b>#tlformat(x16-x17-x19-x20-x21)# #session.ep.money#</b></td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue"><cf_get_lang dictionary_id="30752.Ticari İskonto"></td>
                                        <td style="text-align:right;">#tlformat(x22)# #session.ep.money#</td>
                                        <td style="text-align:right;">%<cfif (x16-x17-x19-x20-x21) neq 0>#tlformat((x22/(x16-x17))*100)#<cfelse>0</cfif></td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue" bgcolor="##FEB8CB"><b><cf_get_lang dictionary_id="33986.Kalan tutar"></b></td>
                                        <td bgcolor="##FEB8CB" style="text-align:right;"><b>#tlformat(x16-x17-x19-x20-x21-x22)# #session.ep.money#</b></td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr class="color-row"> 
                                        <td class="txtboldblue"><cf_get_lang dictionary_id="50861.Peşin İskonto"></td>
                                        <td style="text-align:right;">#tlformat(x23)# #session.ep.money#</td>
                                        <td style="text-align:right;">%<cfif (x16-x17-x19-x20-x21-x22) neq 0>#tlformat((x23/(x16-x17-x19-x20-x21-x22))*100)#<cfelse>0</cfif></td>
                                        <td><b>#tlformat(x19+x20+x21+x22+x23)# #session.ep.money#</b></td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr class="color-row" height="25px;">
                                        <td class="txtboldblue"><br/><cf_get_lang dictionary_id="57643.KDV Toplamı"></td>
                                        <td style="text-align:right;"><br/>#tlformat(x24)# #session.ep.money#</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue"><cf_get_lang dictionary_id="48991.Net Tutar"></td>
                                        <td style="text-align:right;">#tlformat(x26)# #session.ep.money#</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                    </tr>
                                </table>
                                </td>
                            </tr>
                        </table>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                        <table cellspacing="0" cellpadding="0" border="0">
                            <tr>
                                <td>
                                <table cellspacing="1" cellpadding="2" width="100%" border="0">
                                    <tr class="color-row">
                                        <td class="txtboldblue" width="180">1.<cf_get_lang dictionary_id="30751.Kademe Tutarı (KDV'siz)"></td>
                                        <td width="150"  style="text-align:right;">#tlformat(x9)# #session.ep.money#</td>
                                        <td width="40"  style="text-align:right;">%<cfif x28 neq 0>#tlformat((x9/x28)*100)#<cfelse>0</cfif></td>
                                        <td colspan="2" width="300" rowspan="9" valign="top">
                                            <cfchart 
                                                chartheight="200" 
                                                chartwidth="400" 
                                                show3d="no" 
                                                showlegend="yes" 
                                                font="arial" 
                                                format="jpg" fontsize="10">
                                                <cfchartseries type="bar" colorlist="yellow,red,blue,gray,green,black">
                                                <cfif x28 neq 0>	
                                                    <cfchartdata item="1 Kademe" value="#((x9/x28)*100)#">
                                                    <cfchartdata item="2 Kademe" value="#((x10/x28)*100)#">
                                                    <cfchartdata item="3 Kademe" value="#((x11/x28)*100)#">
                                                    <cfchartdata item="4 Kademe" value="#((x12/x28)*100)#">
                                                    <cfchartdata item="5 Kademe" value="#((x13/x28)*100)#">
                                                    <cfchartdata item="Diğer" value="#((x27/x28)*100)#">
                                                <cfelse>
                                                    <cfchartdata item="1 Kademe" value="0">
                                                    <cfchartdata item="2 Kademe" value="0">
                                                    <cfchartdata item="3 Kademe" value="0">
                                                    <cfchartdata item="4 Kademe" value="0">
                                                    <cfchartdata item="5 Kademe" value="0">
                                                    <cfchartdata item="Diğer" value="0">
                                                </cfif>
                                                </cfchartseries>
                                            </cfchart>
                                        </td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue">2.<cf_get_lang dictionary_id="30751.Kademe Tutarı (KDV'siz)"></td>
                                        <td style="text-align:right;">#tlformat(x10)# #session.ep.money#</td>
                                        <td style="text-align:right;">%<cfif x28 neq 0>#tlformat((x10/x28)*100)#<cfelse>0</cfif></td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue">3.<cf_get_lang dictionary_id="30751.Kademe Tutarı (KDV'siz)"></td>
                                        <td style="text-align:right;">#tlformat(x11)# #session.ep.money#</td>
                                        <td style="text-align:right;">%<cfif x28 neq 0>#tlformat((x11/x28)*100)#<cfelse>0</cfif></td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue">4.<cf_get_lang dictionary_id="30751.Kademe Tutarı (KDV'siz)"></td>
                                        <td style="text-align:right;">#tlformat(x12)# #session.ep.money#</td>
                                        <td style="text-align:right;">%<cfif x28 neq 0>#tlformat((x12/x28)*100)#<cfelse>0</cfif></td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue">5.<cf_get_lang dictionary_id="30751.Kademe Tutarı (KDV'siz)"></td>
                                        <td style="text-align:right;">#tlformat(x13)# #session.ep.money#;</td>
                                        <td style="text-align:right;">%<cfif x28 neq 0>#tlformat((x13/x28)*100)#<cfelse>0</cfif></td>
                                    </tr>
                                    <tr class="color-row">
                                        <td class="txtboldblue"><cf_get_lang dictionary_id="30747.Diğer ( KDV 'siz )"></td>
                                        <td style="text-align:right;">#tlformat(x27)# #session.ep.money#</td>
                                        <td style="text-align:right;">%<cfif x28 neq 0>#tlformat((x27/x28)*100)#<cfelse>0</cfif></td>
                                    </tr>
                                    <tr class="color-row">
                                        <td colspan="3">&nbsp;</td>
                                    </tr>
                                    <tr class="color-row">
                                        <td colspan="3">&nbsp;</td>
                                    </tr>
                                    <tr class="color-row">
                                        <td colspan="3">&nbsp;</td>
                                    </tr>
                                </table>
                                </td>
                            </tr>
                        </table>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                </cfoutput>
                </cfif>
            <cfelse>
                <tr>
                    <td><cf_get_lang dictionary_id="57484.Kayıt Yok">!</td>
                </tr>
            </cfif>
        </table>
        </td>
    </tr>
</cf_flat_list>
</cf_box>

<cfcomponent>

   <cffunction name="kimlikDogrulama">

      <cfargument name="KimlikNO">
      <cfargument name="Sifre">

      <cfsavecontent variable="gibxml">
         <cfoutput>
            <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:tem="http://tempuri.org/">
               <soap:Header/>
               <soap:Body>
                  <tem:DisKullaniciKimlikDogrula2>
                     <tem:disKullaniciKimlik>
                        <tem:KimlikNO>#arguments.KimlikNO#</tem:KimlikNO>
                        <tem:KimlikNOTipi>TCKN</tem:KimlikNOTipi>
                        <tem:DisKullaniciTipi>MaliMusavir</tem:DisKullaniciTipi>
                        <tem:Sifre>#arguments.Sifre#</tem:Sifre>
                     </tem:disKullaniciKimlik>
                     <tem:islemTipi>DefterOnayi</tem:islemTipi>
                     <tem:istemciZamani>
                        <tem:Yil>#year(now())#</tem:Yil>
                        <tem:Ay>#month(now())#</tem:Ay>
                        <tem:Gun>#day(now())#</tem:Gun>
                        <tem:Saat>#hour(now())#</tem:Saat>
                        <tem:Dakika>#minute(now())#</tem:Dakika>
                        <tem:Saniye>#second(now())#</tem:Saniye>
                     </tem:istemciZamani>
                  </tem:DisKullaniciKimlikDogrula2>
               </soap:Body>
            </soap:Envelope>
         </cfoutput>
      </cfsavecontent>


      <cfhttp url="http://smmmservis.tnb.org.tr/NPSKimlikDogrulamaServisi/Service.asmx" method="POST" result="gibdata">
         <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/DisKullaniciKimlikDogrula2">
         <cfhttpparam type="header" name="Content-Type" value="text/xml;charset=UTF-8">
         <cfhttpparam type="body" value="#trim(gibxml)#">
      </cfhttp>

      <cfif gibdata.statuscode neq "200 OK">
         <cfreturn "Unauthorized">
      </cfif>
      
      <cfxml variable="xmldata"><cfoutput>#gibdata.Filecontent#</cfoutput></cfxml>
   
      <cfif isDefined("xmldata.Envelope.Header.ServisHataHeader.ServisHata.Mesaj")>
         <cfreturn xmldata.Envelope.Header.ServisHataHeader.ServisHata.Mesaj.XmlText>
      </cfif>
      
      <cfreturn xmldata.Envelope.Body.DisKullaniciKimlikDogrula2Response.DisKullaniciKimlikDogrula2Result.XmlText>
      
   </cffunction>

   <cffunction name="GercekSahisMukellefMerkezBilgiSorgu">
      

      <cfargument name="KimlikNO">
      <cfargument name="Sifre">
      <cfargument  name="tckn">
      <!--- <cfdump  var="#arguments#" abort> --->
      <cfset belgeno = kimlikDogrulama(arguments.KimlikNO, arguments.Sifre)>

      <cfsavecontent variable="gibxml">
         <cfoutput>
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:gbs="http://gbs.nps.tnb.org.tr/">
         <soapenv:Header>
            <gbs:BilgiServisHeader>
               <gbs:IslemTipi>DefterOnayi</gbs:IslemTipi>
               <gbs:Program>Belirtilmemis</gbs:Program>
               <gbs:NPSBelgeNO>#belgeno#</gbs:NPSBelgeNO>
            </gbs:BilgiServisHeader>
         </soapenv:Header>
         <soapenv:Body>
            <gbs:GercekSahisMukellefMerkezBilgiSorgu>
               <gbs:tckn>#arguments.tckn#</gbs:tckn>
            </gbs:GercekSahisMukellefMerkezBilgiSorgu>
         </soapenv:Body>
      </soapenv:Envelope>
      </cfoutput>
      </cfsavecontent>

      <cfhttp url="http://smmmservis.tnb.org.tr/GIBBilgiServisi/GBS.asmx" method="POST" result="gibdata">
         <cfhttpparam type="header" name="SOAPAction" value="http://gbs.nps.tnb.org.tr/GercekSahisMukellefMerkezBilgiSorgu">
         <cfhttpparam type="header" name="Content-Type" value="text/xml;charset=UTF-8">
         <cfhttpparam type="body" value="#trim(gibxml)#">
      </cfhttp>
         
      <cfxml  variable="xmldata"><cfoutput>#gibdata.Filecontent#</cfoutput></cfxml>
      <cfif isDefined("xmldata.Envelope.Header.ServisHataHeader.ServisHata.Mesaj")>
         <cfreturn xmldata.Envelope.Header.ServisHataHeader.ServisHata.Mesaj.XmlText>
      </cfif>

      <cfif xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.SonucKod.XmlText neq "201">
         <cfreturn xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.SonucAciklama.XmlText>
      </cfif>
      
      <cfset result = structNew()>
      <cfset result.Adi = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.Adi.XmlText>
      <cfset result.Soyadi = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.Soyadi.XmlText>
      <cfset result.BabaAdi = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.BabaAdi.XmlText>
      <cfset result.VergiDairesiAdi = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.VergiDairesiAdi.XmlText>
      <cfset result.VergiDairesiKodu = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.VergiDairesiKodu.XmlText>
      <cfset result.VKN = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.VKN.XmlText>

      <cfif isdefined("xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.IsAdresi.IlAdi")>
         <cfset result.IsAdresi = structNew()>
         <cfset result.IsAdresi.MahalleSemt = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.IsAdresi.MahalleSemt.XmlText>
         <cfset result.IsAdresi.CaddeSokak = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.IsAdresi.CaddeSokak.XmlText>
         <cfset result.IsAdresi.KapiNO = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.IsAdresi.KapiNO.XmlText>
         <cfset result.IsAdresi.DaireNO = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.IsAdresi.DaireNO.XmlText>
         <cfset result.IsAdresi.IlceAdi = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.IsAdresi.IlceAdi.XmlText>
         <cfset result.IsAdresi.IlKodu = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.IsAdresi.IlKodu.XmlText>
         <cfset result.IsAdresi.IlAdi = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.IsAdresi.IlAdi.XmlText>
      </cfif>

      <cfif isdefined("xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.IkametgahAdresi.IlAdi")>
         <cfset result.IkametgahAdresi = structNew()>
         <cfset result.IkametgahAdresi.MahalleSemt = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.IkametgahAdresi.MahalleSemt.XmlText>
         <cfset result.IkametgahAdresi.CaddeSokak = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.IkametgahAdresi.CaddeSokak.XmlText>
         <cfset result.IkametgahAdresi.KapiNO = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.IkametgahAdresi.KapiNO.XmlText>
         <cfset result.IkametgahAdresi.DaireNO = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.IkametgahAdresi.DaireNO.XmlText>
         <cfset result.IkametgahAdresi.IlceAdi = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.IkametgahAdresi.IlceAdi.XmlText>
         <cfset result.IkametgahAdresi.IlKodu = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.IkametgahAdresi.IlKodu.XmlText>
         <cfset result.IkametgahAdresi.IlAdi = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.IkametgahAdresi.IlAdi.XmlText>
      </cfif>

      <cfloop from="1" to="#arrayLen(xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.MeslekListesi)#" index="i">
         <cfset Meslek = structNew()>
         <cfset Meslek.MeslekAdi = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.MeslekListesi[i].Meslek.MeslekAdi.XmlText>
         <cfset Meslek.MeslekKodu = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.MeslekListesi[i].Meslek.MeslekKodu.XmlText>
         <cfset result.MeslekListesi = []>
         <cfset arrayAppend(result.MeslekListesi, Meslek)>
      </cfloop>

      <cfset result.FaalTerkBilgisi = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.FaalTerkBilgisi.XmlText>
      <cfset result.SirketTuru = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.SirketTuru.XmlText>
      <cfset result.SorguKimlikNOTipi = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.SorguKimlikNOTipi.XmlText>
      <cfset result.SorguKimlikNO = xmldata.Envelope.Body.GercekSahisMukellefMerkezBilgiSorguResponse.GercekSahisMukellefMerkezBilgiSorguResult.SorguKimlikNO.XmlText>

      <cfreturn result>

   </cffunction>

   <cffunction name="TuzelSahisMukellefMerkezBilgiSorgu">


      <cfargument name="KimlikNO">
      <cfargument name="Sifre">

      <cfargument name="vkn">
      
      <cfset belgeno = kimlikDogrulama(arguments.KimlikNO, arguments.Sifre)>

      <cfsavecontent variable="gibxml">
         <cfoutput>
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:gbs="http://gbs.nps.tnb.org.tr/">
               <soapenv:Header>
                  <gbs:BilgiServisHeader>
                  <gbs:IslemTipi>DefterOnayi</gbs:IslemTipi>
                  <gbs:Program>Belirtilmemis</gbs:Program>
                  <gbs:NPSBelgeNO>#belgeno#</gbs:NPSBelgeNO>
               </gbs:BilgiServisHeader>
               </soapenv:Header>
               <soapenv:Body>
                  <gbs:TuzelSahisMukellefMerkezBilgiSorgu>
                     <gbs:vkn>#arguments.vkn#</gbs:vkn>
                  </gbs:TuzelSahisMukellefMerkezBilgiSorgu>
               </soapenv:Body>
            </soapenv:Envelope>
      </cfoutput>
      </cfsavecontent>

      <cfhttp url="http://smmmservis.tnb.org.tr/GIBBilgiServisi/GBS.asmx" method="POST" result="gibdata">
         <cfhttpparam type="header" name="SOAPAction" value="http://gbs.nps.tnb.org.tr/TuzelSahisMukellefMerkezBilgiSorgu">
         <cfhttpparam type="header" name="Content-Type" value="text/xml;charset=UTF-8">
         <cfhttpparam type="body" value="#trim(gibxml)#">
      </cfhttp>

      <cfxml  variable="xmldata"><cfoutput>#gibdata.Filecontent#</cfoutput></cfxml>
      
      <cfif isDefined("xmldata.Envelope.Header.ServisHataHeader.ServisHata.Mesaj")>
         <cfreturn xmldata.Envelope.Header.ServisHataHeader.ServisHata.Mesaj.XmlText>
      </cfif>

      <cfif xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.SonucKod.XmlText neq "201">
         <cfreturn xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.SonucAciklama.XmlText>
      </cfif>

      <cfset result = structNew()>
      
      <cfset result.VergiDairesiAdi = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.VergiDairesiAdi.XmlText>
      <cfset result.VergiDairesiKodu = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.VergiDairesiKodu.XmlText>
      <cfset result.VKN = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.VKN.XmlText>
      <cfif isDefined("xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.Unvan")>
         <cfset result.Unvan = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.Unvan.XmlText>
      </cfif>
      <cfset result.IsAdresi = structNew()>
      <cfset result.IsAdresi.MahalleSemt = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.IsAdresi.MahalleSemt.XmlText>
      <cfset result.IsAdresi.CaddeSokak = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.IsAdresi.CaddeSokak.XmlText>
      <cfset result.IsAdresi.KapiNO = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.IsAdresi.KapiNO.XmlText>
      <cfset result.IsAdresi.DaireNO = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.IsAdresi.DaireNO.XmlText>
      <cfset result.IsAdresi.IlceAdi = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.IsAdresi.IlceAdi.XmlText>
      <cfset result.IsAdresi.IlKodu = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.IsAdresi.IlKodu.XmlText>
      <cfset result.IsAdresi.IlAdi = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.IsAdresi.IlAdi.XmlText>

      <!--- <cfset result.IkametgahAdresi = structNew()>
      <cfset result.IkametgahAdresi.MahalleSemt = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.IkametgahAdresi.MahalleSemt.XmlText>
      <cfset result.IkametgahAdresi.CaddeSokak = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.IkametgahAdresi.CaddeSokak.XmlText>
      <cfset result.IkametgahAdresi.KapiNO = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.IkametgahAdresi.KapiNO.XmlText>
      <cfset result.IkametgahAdresi.DaireNO = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.IkametgahAdresi.DaireNO.XmlText>
      <cfset result.IkametgahAdresi.IlceAdi = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.IkametgahAdresi.IlceAdi.XmlText>
      <cfset result.IkametgahAdresi.IlKodu = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.IkametgahAdresi.IlKodu.XmlText>
      <cfset result.IkametgahAdresi.IlAdi = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.IkametgahAdresi.IlAdi.XmlText> --->
      
      <cfloop from="1" to="#arrayLen(xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.MeslekListesi)#" index="i">
         <cfset Meslek = structNew()>
         <cfset Meslek.MeslekAdi = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.MeslekListesi[i].Meslek.MeslekAdi.XmlText>
         <cfset Meslek.MeslekKodu = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.MeslekListesi[i].Meslek.MeslekKodu.XmlText>
         <cfset result.MeslekListesi = []>
         <cfset arrayAppend(result.MeslekListesi, Meslek)>
      </cfloop>

      <cfset result.FaalTerkBilgisi = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.FaalTerkBilgisi.XmlText>
      <cfset result.SirketTuru = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.SirketTuru.XmlText>
      <cfset result.SorguKimlikNOTipi = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.SorguKimlikNOTipi.XmlText>
      <cfset result.SorguKimlikNO = xmldata.Envelope.Body.TuzelSahisMukellefMerkezBilgiSorguResponse.TuzelSahisMukellefMerkezBilgiSorguResult.SorguKimlikNO.XmlText>

      <cfreturn result>


   </cffunction>

</cfcomponent>
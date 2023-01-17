<!--- 
	Burada en önemli mesele her depo açıldıkça branch_list içerisine eklenmesidir. 
 --->
<cffunction name="convertDotNetDataset" returnType="struct">
	<cfargument name="dataset" required="true">
		 <cfscript>
			result = structNew() ;
			aDataset = dataset.get_any() ;
			xSchema  = xmlParse(aDataset[1]) ;
			xTables = xSchema["xs:schema"]["xs:element"]["xs:complexType"]["xs:choice"] ;
			xData  = xmlParse(aDataset[2]) ;
			xRows = xData["diffgr:diffgram"]["NewDataSet"] ;
			tableName = "" ;
			thisRow = "" ;
			i = "" ;
			j = "" ;
			for(i = 1 ; i lte arrayLen(xTables.xmlChildren); i=i+1)
			{
				tableName = xTables.xmlChildren[i].xmlAttributes.name;
				xColumns = xTables.xmlChildren[i].xmlChildren[1].xmlChildren[1].xmlChildren;
				result[tableName] = queryNew("");
				for(j = 1 ; j lte arrayLen(xColumns) ; j=j+1)
				{
					queryAddColumn(result[tableName], xColumns[j].xmlAttributes.name, arrayNew(1));
				}
			}
			for(i = 1 ; i lte arrayLen(xRows.xmlChildren); i=i+1)
			{
				thisRow = xRows.xmlChildren[i] ;
				tableName = thisRow.xmlName ;
				queryAddRow(result[tableName], 1) ;
				for(j = 1 ; j lte arrayLen(thisRow.xmlChildren); j=j+1)
				{
					querySetCell(result[tableName], thisRow.xmlChildren[j].xmlName, thisRow.xmlChildren[j].xmlText, result[tableName].recordCount);
				}
			}
		 </cfscript>
	<cfreturn result>
</cffunction>
<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT
		BRANCH.BRANCH_ID,
		COMPANY_BOYUT_DEPO_KOD.BOYUT_KODU
	FROM
		BRANCH,
		COMPANY_BOYUT_DEPO_KOD
	WHERE
		BRANCH.BRANCH_ID = COMPANY_BOYUT_DEPO_KOD.W_KODU
</cfquery>
<cfscript>
	start_date = numberformat(year(date_add("m",-1,now())),'0000')&numberformat(month(date_add("m",-2,now())),'00');
	finish_date = numberformat(year(now()),'0000')&numberformat(month(date_add("m",-1,now())),'00');
</cfscript>
<cfoutput query="get_company">
	<cfquery name="GET_COMPANY_BOYUT" datasource="mushizgun">
		SELECT ETICARETKOD, ETICARETIP FROM DEPOLAR WHERE DEPOKODU = '#get_company.boyut_kodu#'
	</cfquery>
	<cfinvoke 
		webservice="http://#get_company_boyut.eticaretip#/CRMTOC100WS/BoyutIslem.asmx?WSDL"
		method="MusteriAktivite"
		returnvariable="get_invoice_info">
			<cfinvokeargument name="DepoKod" value="#get_company.boyut_kodu#"/>
  			<cfinvokeargument name="Kullanici" value="#get_company_boyut.eticaretip#"/>
			<cfinvokeargument name="Sifre" value="#get_company_boyut.eticaretkod#"/>
			<cfinvokeargument name="CariHesapKod" value=""/>
			<cfinvokeargument name="Donem1" value="#start_date#"/>
			<cfinvokeargument name="Donem2" value="#finish_date#"/>
	</cfinvoke>
	<cfset get_invoice_info = convertDotNetDataset(get_invoice_info)>
	<cfset myquery_value = get_invoice_info.MusteriAktiviteKayit>
	<cfquery name="DEL_BOYUT_DATA" datasource="#dsn#">
		DELETE FROM COMPANY_BOYUT_CIRO
	</cfquery>
	<cfloop query="myquery_value">
		<cfset donem_degeri = createdatetime(left(myquery_value.DONEM,4),right(myquery_value.DONEM,2),1,0,0,0)>
		<cf_date tarih='donem_degeri'>
		İşlem Bitti Tamamdır !
		<cfquery name="ADD_BOYUT_DATA" datasource="#dsn#">
			INSERT
			INTO
				COMPANY_BOYUT_CIRO
				(
					HEDEF_KODU,
					HESAP_KODU,
					DONEM,
					FATTOP,
					IADETOP,
					HFATTOP,
					FATADET,
					IADEADET,
					HFATADET,
					ODENENTUT,
					ORTVADE,
					BRUTTUTAR,
					KDVTENZIL,
					ECZKARI,
					ACIKTUT,
					ACIKVADE,
					PESINISK,
					KURUMISK,
					TICARIISK,
					MFISK,
					ADETTOP,
					MFTOP,
					KADAME0,
					KADEME1,
					KADEME2,
					KADEME3,
					KADEME4,
					KADEME5
				)
				VALUES
				(
					#myquery_value.HEDEFKODU#,
					'#myquery_value.HESAPKODU#',
					<cfif len(donem_degeri)>#donem_degeri#,<cfelse>NULL,</cfif>
					<cfif len(myquery_value.FATTOP)>#myquery_value.FATTOP#,<cfelse>0,</cfif>
					<cfif len(myquery_value.IADETOP)>#myquery_value.IADETOP#,<cfelse>0,</cfif>
					<cfif len(myquery_value.HFATTOP)>#myquery_value.HFATTOP#,<cfelse>0,</cfif>
					<cfif len(myquery_value.FATADET)>#myquery_value.FATADET#,<cfelse>0,</cfif>
					<cfif len(myquery_value.IADEADET)>#myquery_value.IADEADET#,<cfelse>0,</cfif>
					<cfif len(myquery_value.HFATADET)>#myquery_value.HFATADET#,<cfelse>0,</cfif>
					<cfif len(myquery_value.ODENENTUT)>#myquery_value.ODENENTUT#,<cfelse>0,</cfif>
					<cfif len(myquery_value.ORTVADE)>#myquery_value.ORTVADE#,<cfelse>0,</cfif>
					<cfif len(myquery_value.BRUTTUTAR)>#myquery_value.BRUTTUTAR#,<cfelse>0,</cfif>
					<cfif len(myquery_value.KDVTENZIL)>#myquery_value.KDVTENZIL#,<cfelse>0,</cfif>
					<cfif len(myquery_value.ECZKARI)>#myquery_value.ECZKARI#,<cfelse>0,</cfif>
					<cfif len(myquery_value.ACIKTUT)>#myquery_value.ACIKTUT#,<cfelse>0,</cfif>
					<cfif len(myquery_value.ACIKVADE)>#myquery_value.ACIKVADE#,<cfelse>0,</cfif>
					<cfif len(myquery_value.PESINISK)>#myquery_value.PESINISK#,<cfelse>0,</cfif>
					<cfif len(myquery_value.KURUMISK)>#myquery_value.KURUMISK#,<cfelse>0,</cfif>
					<cfif len(myquery_value.TICARIISK)>#myquery_value.TICARIISK#,<cfelse>0,</cfif>
					<cfif len(myquery_value.MFISK)>#myquery_value.MFISK#,<cfelse>0,</cfif>
					<cfif len(myquery_value.ADETTOP)>#myquery_value.ADETTOP#,<cfelse>0,</cfif>
					<cfif len(myquery_value.MFTOP)>#myquery_value.MFTOP#,<cfelse>0,</cfif>
					<cfif len(myquery_value.KADEME0)>#myquery_value.KADEME0#,<cfelse>0,</cfif>
					<cfif len(myquery_value.KADEME1)>#myquery_value.KADEME1#,<cfelse>0,</cfif>
					<cfif len(myquery_value.KADEME2)>#myquery_value.KADEME2#,<cfelse>0,</cfif>
					<cfif len(myquery_value.KADEME3)>#myquery_value.KADEME3#,<cfelse>0,</cfif>
					<cfif len(myquery_value.KADEME4)>#myquery_value.KADEME4#,<cfelse>0,</cfif>
					<cfif len(myquery_value.KADEME5)>#myquery_value.KADEME5#<cfelse>0,</cfif>
				)
		</cfquery>
	</cfloop>
</cfoutput>
İşlem Bitti !

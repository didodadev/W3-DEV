<cffile action="read" file="#attributes.import_file#" variable="dosya" charset="iso-8859-9">
<cfscript>
	add_inv_row = arraynew(1);
	CRLF = Chr(13) & Chr(10);
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
</cfscript>
<cfloop from="1" to="#line_count#" index="i">
	<cfscript>
			satir = dosya[i];
			
			//Hedef Kodu
			hedefkodu = listgetat(satir,1,',');
			
			//Muhasebe Kodu
			muhkod = listgetat(satir,2,',');
			muhkod = right(muhkod,(len(muhkod)-1));
			if((len(muhkod)-1) neq 0)
			{
				muhkod = left(muhkod,(len(muhkod)-1));
			}
			else
			{
				muhkod = "";
			}
			
			//Ödeme Şekli
			odemesekli = listgetat(satir,3,',');
			odemesekli = right(odemesekli,(len(odemesekli)-1));
			if((len(odemesekli)-1) neq 0)
			{
				odemesekli = left(odemesekli,(len(odemesekli)-1));
			}
			else
			{
				odemesekli = "";
			}
			
			//Puan
			puan = listgetat(satir,4,',');
			
			//Risk Limit
			risklimit = listgetat(satir,5,',');
			
			//Bölge
			bolge = listgetat(satir,6,',');
			bolge = right(bolge,(len(bolge)-1));
			if((len(bolge)-1) neq 0)
			{
				bolge = left(bolge,(len(bolge)-1));
			}
			else
			{
				bolge = "";
			}
			
			//Alt Bölge
			altbolge = listgetat(satir,7,',');
			
			//Cep Sıra
			cepsira = listgetat(satir,8,',');
			cepsira = right(cepsira,(len(cepsira)-1));
			if((len(cepsira)-1) neq 0)
			{
				cepsira = left(cepsira,(len(cepsira)-1));
			}
			else
			{
				cepsira = "";
			}
			cepsira = listchangedelims(cepsira,',','-');
			
			//Uzaklık
			uzaklik = listgetat(satir,9,',');
			
	</cfscript>
	<cfquery name="UPDATE" datasource="#dsn#">
		UPDATE
			COMPANY_BRANCH_RELATED
		SET
			MUHASEBEKOD = '#muhkod#',
			CALISMA_SEKLI = '#odemesekli#',
			PUAN = <cfif len(puan)>#puan#,<cfelse>NULL,</cfif>
			BOLGE_KODU = '#bolge#',
			ALTBOLGE_KODU = '#altbolge#',
			CEP_SIRA = '#cepsira#',
			DEPOT_KM = <cfif isnumeric(uzaklik) and len(uzaklik)>#uzaklik#<cfelse>NULL</cfif>
		WHERE
			COMPANY_ID = #hedefkodu# AND
			BRANCH_ID = #attributes.branch_id#
	</cfquery>
	<cfquery name="GET_RISK" datasource="#dsn#">
		SELECT RELATED_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND COMPANY_ID = #hedefkodu# AND BRANCH_ID = #attributes.branch_id#
	</cfquery>
	<cfif len(get_risk.related_id)>
		<cfquery name="GET_KONTROL" datasource="#dsn#">
			SELECT COMPANY_ID FROM COMPANY_CREDIT WHERE COMPANY_ID = #hedefkodu# AND BRANCH_ID = #get_risk.related_id#
		</cfquery>
		<cfif get_kontrol.recordcount>
			<cfquery name="UPD_RISK_LIMIT" datasource="#dsn#">
				UPDATE
					COMPANY_CREDIT
				SET
					TOTAL_RISK_LIMIT = <cfif len(risklimit)>#risklimit#,<cfelse>NULL,</cfif>
					MONEY = '#session.ep.money#',
					UPDATE_DATE = #now()#,
					UPDATE_EMP = #session.ep.userid#,
					UPDATE_IP = '#cgi.remote_addr#'
				WHERE
					COMPANY_ID = #hedefkodu# AND 
					BRANCH_ID = #get_risk.related_id#
			</cfquery>
		<cfelse>
			<cfquery name="GET_COMP" datasource="#dsn#">
				SELECT COMPANY_ID FROM BRANCH WHERE BRANCH_ID = #attributes.branch_id#
			</cfquery>
			<cfquery name="ADD_RISK_LIMIT" datasource="#dsn#">
				INSERT INTO
					COMPANY_CREDIT
					(
						OUR_COMPANY_ID,
						COMPANY_ID,
						TOTAL_RISK_LIMIT,
						MONEY,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP,
						BRANCH_ID
					)
					VALUES
					(
						#get_comp.company_id#,
						#hedefkodu#,
						<cfif len(risklimit)>#risklimit#<cfelse>NULL</cfif>,
						'#session.ep.money#',
						#now()#,
						#session.ep.userid#,
						'#cgi.remote_addr#',
						#get_risk.related_id#
					)
			</cfquery>
		</cfif>
	</cfif>
	<table width="98%" border="0">
		<tr>
			<td><font style="font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : #333333;"><cfoutput>#hedefkodu#</cfoutput> No'lu Müşteri Bilgileri Başarı ile Güncellendi !</font></td>
		</tr>
	</table>
</cfloop>
<script type="text/javascript">
	location.href = document.referrer;
</script>


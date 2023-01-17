<cfscript>
function tr_to_iso(attributes_list)
{
	var return_value = '';
	return_value = replacelist(attributes_list,'ü,ğ,ı,ş,ç,ö,Ü,Ğ,İ,Ş,Ç,Ö','U,G,I,S,C,O,U,G,I,S,C,O');
	return_value = replace(return_value,"'"," ","ALL");
	return return_value;
}
</cfscript>
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
			for(i = 1 ; i lte arrayLen(xTables.xmlChildren); i=i+1){
				tableName = xTables.xmlChildren[i].xmlAttributes.name;
				xColumns = xTables.xmlChildren[i].xmlChildren[1].xmlChildren[1].xmlChildren;
				result[tableName] = queryNew("");
				for(j = 1 ; j lte arrayLen(xColumns) ; j=j+1)
				{
					queryAddColumn(result[tableName], xColumns[j].xmlAttributes.name, arrayNew(1));
			}}
			for(i = 1 ; i lte arrayLen(xRows.xmlChildren); i=i+1){
				thisRow = xRows.xmlChildren[i] ;
				tableName = thisRow.xmlName ;
				queryAddRow(result[tableName], 1) ;
				for(j = 1 ; j lte arrayLen(thisRow.xmlChildren); j=j+1)
				{
					querySetCell(result[tableName], thisRow.xmlChildren[j].xmlName, thisRow.xmlChildren[j].xmlText, result[tableName].recordCount);
			}}
		 </cfscript>
	<cfreturn result>
</cffunction>
<cfif isdefined("attributes.is_type") and attributes.is_type eq 1>
	<cfif isdefined("attributes.is_sales")>
		<cfquery name="UPDATE_POSITION1" datasource="#DSN#">
			UPDATE 
				COMPANY_BRANCH_RELATED 
			SET 
				SALES_DIRECTOR = #attributes.yeni_gorevli_id#,
				BOYUT_BSM = '#attributes.yeni_boyut#'
			WHERE
				MUSTERIDURUM IS NOT NULL AND
				BRANCH_ID = #attributes.branch_id#
				<cfif len(attributes.tr_status)>AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.tr_status#</cfif>
				<cfif isdefined("attributes.is_sifir") and len(attributes.eski_gorevli_id)>
					AND (SALES_DIRECTOR = #attributes.eski_gorevli_id# OR SALES_DIRECTOR = 0)
				<cfelseif len(attributes.eski_gorevli_id)>
					AND SALES_DIRECTOR = #attributes.eski_gorevli_id#
				<cfelseif isdefined("attributes.is_sifir")>
					AND SALES_DIRECTOR = 0
				</cfif>
		</cfquery>
	</cfif>
	<cfif isdefined("attributes.is_telefon")>
		<cfquery name="UPDATE_POSITION2" datasource="#DSN#">
			UPDATE 
				COMPANY_BRANCH_RELATED 
			SET 
				TEL_SALE_PREID = #attributes.yeni_gorevli_id#,
				BOYUT_TELEFON = '#attributes.yeni_boyut#'
			WHERE
				MUSTERIDURUM IS NOT NULL AND
				BRANCH_ID = #attributes.branch_id#
				<cfif len(attributes.tr_status)>AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.tr_status#</cfif>
				<cfif isdefined("attributes.is_sifir") and len(attributes.eski_gorevli_id)>
					AND (TEL_SALE_PREID = #attributes.eski_gorevli_id# OR TEL_SALE_PREID = 0)
				<cfelseif len(attributes.eski_gorevli_id)>
					AND TEL_SALE_PREID = #attributes.eski_gorevli_id#
				<cfelseif isdefined("attributes.is_sifir")>
					AND TEL_SALE_PREID = 0
				</cfif>
		</cfquery>
	</cfif>
	<cfif isdefined("attributes.is_saha")>
		<cfquery name="UPDATE_POSITION3" datasource="#DSN#">
			UPDATE
				COMPANY_BRANCH_RELATED
			SET
				PLASIYER_ID = #attributes.yeni_gorevli_id#,
				BOYUT_PLASIYER = '#attributes.yeni_boyut#'
			WHERE
				MUSTERIDURUM IS NOT NULL AND
				BRANCH_ID = #attributes.branch_id#
				<cfif len(attributes.tr_status)>AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.tr_status#</cfif>
				<cfif isdefined("attributes.is_sifir") and len(attributes.eski_gorevli_id)>
					AND (PLASIYER_ID = #attributes.eski_gorevli_id# OR PLASIYER_ID = 0)
				<cfelseif len(attributes.eski_gorevli_id)>
					AND PLASIYER_ID = #attributes.eski_gorevli_id#
				<cfelseif isdefined("attributes.is_sifir")>
					AND PLASIYER_ID = 0
				</cfif>
		</cfquery>
	</cfif>
	<cfif isdefined("attributes.is_itriyat")>
		<cfquery name="UPDATE_POSITION3" datasource="#DSN#">
			UPDATE 
				COMPANY_BRANCH_RELATED 
			SET 
				ITRIYAT_GOREVLI = #attributes.yeni_gorevli_id#,
				BOYUT_ITRIYAT = '#attributes.yeni_boyut#'
			WHERE
				MUSTERIDURUM IS NOT NULL AND
				BRANCH_ID = #attributes.branch_id#
				<cfif len(attributes.tr_status)>AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.tr_status#</cfif>
				<cfif isdefined("attributes.is_sifir") and len(attributes.eski_gorevli_id)>
				AND (ITRIYAT_GOREVLI = #attributes.eski_gorevli_id# OR ITRIYAT_GOREVLI = 0)
				<cfelseif len(attributes.eski_gorevli_id)>
				AND ITRIYAT_GOREVLI = #attributes.eski_gorevli_id#
				<cfelseif isdefined("attributes.is_sifir")>
				AND ITRIYAT_GOREVLI = 0
				</cfif>
		</cfquery>
	</cfif>
	<cfif isdefined("attributes.is_tahsilat")>
		<cfquery name="UPDATE_POSITION3" datasource="#DSN#">
			UPDATE 
				COMPANY_BRANCH_RELATED 
			SET 
				TAHSILATCI = #attributes.yeni_gorevli_id#,
				BOYUT_TAHSILAT = '#attributes.yeni_boyut#'
			WHERE
				MUSTERIDURUM IS NOT NULL AND
				BRANCH_ID = #attributes.branch_id#
				<cfif len(attributes.tr_status)>AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.tr_status#</cfif>
				<cfif isdefined("attributes.is_sifir") and len(attributes.eski_gorevli_id)>
				AND (TAHSILATCI = #attributes.eski_gorevli_id# OR TAHSILATCI = 0)
				<cfelseif len(attributes.eski_gorevli_id)>
				AND TAHSILATCI = #attributes.eski_gorevli_id#
				<cfelseif isdefined("attributes.is_sifir")>
				AND TAHSILATCI = 0
				</cfif>
		</cfquery>
	</cfif>
	<cfif isdefined("attributes.is_boyut")>
		<cfif isdefined("attributes.is_sales") or isdefined("attributes.is_telefon") or isdefined("attributes.is_saha") or isdefined("attributes.is_itriyat") or isdefined("attributes.is_tahsilat")>
			<cfset sql_string = ''>
			<cfset degisken_value = ''>
			<cfif isdefined("attributes.is_sales")>
				<cfset degisken_value = 'OR'>
				<cfset sql_string = sql_string & 'COMPANY_BRANCH_RELATED.SALES_DIRECTOR = #attributes.yeni_gorevli_id#'>
			</cfif>
			<cfif isdefined("attributes.is_telefon")>
				<cfset sql_string = sql_string & ' #degisken_value# COMPANY_BRANCH_RELATED.TEL_SALE_PREID = #attributes.yeni_gorevli_id#'>
				<cfset degisken_value = 'OR'>
			</cfif>
			<cfif isdefined("attributes.is_saha")> 
				<cfset sql_string = sql_string & ' #degisken_value# COMPANY_BRANCH_RELATED.PLASIYER_ID = #attributes.yeni_gorevli_id#'>
				<cfset degisken_value = 'OR'>
			</cfif>
			<cfif isdefined("attributes.is_itriyat")> 
				<cfset sql_string = sql_string & ' #degisken_value# COMPANY_BRANCH_RELATED.ITRIYAT_GOREVLI = #attributes.yeni_gorevli_id#'>
				<cfset degisken_value = 'OR'>
			</cfif>
			<cfif isdefined("attributes.is_tahsilat")>
				<cfset sql_string = sql_string & ' #degisken_value# COMPANY_BRANCH_RELATED.TAHSILATCI = #attributes.yeni_gorevli_id#'>
			</cfif>
			<cfquery name="GET_COMPANY" datasource="#DSN#">
				SELECT 
					COMPANY.COMPANY_ID,
					COMPANY.GLNCODE,
					COMPANY.FULLNAME,
					COMPANY.DISTRICT,
					COMPANY.STREET,
					COMPANY.MAIN_STREET,
					COMPANY.DUKKAN_NO,
					COMPANY.SEMT,
					COMPANY.COMPANY_TELCODE,
					COMPANY.COMPANY_TEL1,
					COMPANY.COMPANY_FAX,
					COMPANY.COMPANY_FAX_CODE,
					COMPANY.COMPANY_POSTCODE,
					COMPANY.TAXNO,
					COMPANY.TAXOFFICE,
					COMPANY.OLD_COMPANY_ID,
					COMPANY.COMPANY_EMAIL,
					COMPANY.COMPANY_ADDRESS,
					COMPANY.COMPANYCAT_ID,
					COMPANY.GRUP_RISK_LIMIT,
					COMPANY_BOYUT_DEPO_KOD.BOYUT_KODU,
					COMPANY_BRANCH_RELATED.RELATED_ID,
					COMPANY_BRANCH_RELATED.MUHASEBEKOD,
					COMPANY_BRANCH_RELATED.CARIHESAPKOD,
					COMPANY_BRANCH_RELATED.MUSTERIDURUM,
					COMPANY_BRANCH_RELATED.BOYUT_BSM,
					COMPANY_BRANCH_RELATED.SALES_DIRECTOR,
					COMPANY_BRANCH_RELATED.BOYUT_ITRIYAT,
					COMPANY_BRANCH_RELATED.ITRIYAT_GOREVLI,
					COMPANY_BRANCH_RELATED.BOYUT_PLASIYER,
					COMPANY_BRANCH_RELATED.PLASIYER_ID,
					COMPANY_BRANCH_RELATED.BOYUT_TAHSILAT,
					COMPANY_BRANCH_RELATED.TAHSILATCI,
					COMPANY_BRANCH_RELATED.BOYUT_TELEFON,
					COMPANY_BRANCH_RELATED.TEL_SALE_PREID,
					COMPANY_BRANCH_RELATED.OPEN_DATE,
					COMPANY_BRANCH_RELATED.CEP_SIRA,
					COMPANY_BRANCH_RELATED.BOLGE_KODU,
					COMPANY_BRANCH_RELATED.ALTBOLGE_KODU,
					COMPANY_BRANCH_RELATED.DEPOT_KM,
					COMPANY_BRANCH_RELATED.CALISMA_SEKLI,
					COMPANY_BRANCH_RELATED.PUAN,
					COMPANY_BRANCH_RELATED.IS_SELECT,
					COMPANY_BRANCH_RELATED.LOGO_MUSTERI_TIP,					
					COMPANY_PARTNER.COMPANY_PARTNER_NAME,
					COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
					COMPANY_PARTNER.TC_IDENTITY,
					SETUP_COUNTY.COUNTY_NAME,
					SETUP_COUNTY.COUNTY_ID,
					SETUP_CITY.CITY_NAME,
					SETUP_CITY.PLATE_CODE,
					SETUP_IMS_CODE.IMS_CODE,
					SETUP_IMS_CODE.IMS_CODE_501
				FROM
					COMPANY,
					COMPANY_BRANCH_RELATED,
					COMPANY_BOYUT_DEPO_KOD,
					COMPANY_PARTNER, 
					SETUP_COUNTY,
					BRANCH,
					SETUP_CITY,
					SETUP_IMS_CODE
				WHERE
					COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
					COMPANY.COMPANY_STATUS = 1 AND
					COMPANY_BRANCH_RELATED.COMPANY_ID = COMPANY.COMPANY_ID AND 
					COMPANY_BRANCH_RELATED.BRANCH_ID = COMPANY_BOYUT_DEPO_KOD.W_KODU AND
					COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
					COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND
					COMPANY.COUNTY = SETUP_COUNTY.COUNTY_ID AND
					COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND
					COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND
					COMPANY.CITY = SETUP_CITY.CITY_ID AND
					COMPANY_BRANCH_RELATED.BRANCH_ID = #attributes.branch_id#
				  <cfif len(attributes.tr_status)>
					AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.tr_status#
				  </cfif>
					AND SETUP_IMS_CODE.IMS_CODE_ID = COMPANY.IMS_CODE_ID AND
					(
						#sql_string#
					)
					<!--- BK ekledi 20080917 Aydın Ersoz istegi  --->
					AND COMPANY_BRANCH_RELATED.MUSTERIDURUM NOT IN (1,4,66) 
			</cfquery>
			<cfset attributes.kayittipi = 3>
			<cfif get_company.recordcount>
			<cfoutput query="get_company">
			 	<cfif get_company.is_select eq 1><!--- Sadece cari olanlar icin potansiyler icin kayit atilmayacak BK 20071109 --->
					<cfquery name="GET_COMPANY_BOYUT" datasource="mushizgun">
						SELECT ETICARETKOD, ETICARETIP FROM DEPOLAR WHERE DEPOKODU = '#get_company.boyut_kodu#'
					</cfquery>
					<cfset attributes.action_id = get_company.company_id>
						<cftry>
							<cfscript>
								tarih_open = dateformat(get_company.open_date,dateformat_style);
								if(len(get_company.muhasebekod))
								{
									muhasebekod1 = mid(get_company.muhasebekod,1,3);
									muhasebekod2 = mid(get_company.muhasebekod,4,2);
									muhasebekod3 = mid(get_company.muhasebekod,6,(len(get_company.muhasebekod)-5));
								}
								else
								{
									muhasebekod1 = '';
									muhasebekod2 = '';
									muhasebekod3 = '';
								}
							</cfscript>
							<cfquery name="GET_COMPANY_BOYUT" datasource="mushizgun">
								SELECT ETICARETKOD, ETICARETIP FROM DEPOLAR WHERE DEPOKODU = '#get_company.boyut_kodu#'
							</cfquery>
							<cfquery name="GET_CREDIT" datasource="#DSN#">
								SELECT TOTAL_RISK_LIMIT, MONEY FROM COMPANY_CREDIT WHERE COMPANY_ID = #get_company.company_id# AND BRANCH_ID = #get_company.related_id#
							</cfquery>
							<!--- Muhasebe kodu ve cari hesap karakteri 10 ve ilk 3 karekteri 120 ise CRMTOBOYUT a kayit at--->
							<cfif (len(get_company.muhasebekod) eq 10) and (len(get_company.carihesapkod) eq 10) and (left(get_company.muhasebekod,3) eq 120) and (left(get_company.carihesapkod,3) eq 120)>
								<cfquery name="ADD_COMPANY" datasource="mushizgun">
									INSERT INTO
										CRMTOBOYUT 
									(
										HEDEFKODU,
										GLNCODE,
										DEPOKOD,
										HESAPKODU,
										ISYERIADI,
										ADI,
										SOYADI,
										MDURUM,								
										MAHALLE,
										CADDE,
										SOKAK,
										NUMARA,
										SEMT,
										ILCE,
										IL,
										ILCEKODU,
										TELEFON,
										FAX,
										POSTAKODU,
										VERGIDAIRE,
										VERGINO,
										BSM,
										TELEFONCU,
										TAHSILDAR,
										PLASIYER,
										PLASIYER2,
										MUHKOD,
										IMSKOD501,
										IMSKOD101,
										ACTAR,
										CARITIP,
										CEPSIRA,
										BOLGEKODU,
										ALTBOLGEKD,
										UZAKLIK,
										PLAKA,
										CALISSEKLI,
										PUAN,
										KAYITTIPI,
										EKLENMETAR,
										EKLEMETALEP,
										EKLEMEIP,
										KAYITDURUM,
										RISKTOP,																
										GRUPRISKTOP,
										MTIP,
										INKABSM,
										INKATELEFONCU,
										INKATAHSILDAR,
										INKAPLASIYER,
										INKAPLASIYER2,
										EMAIL,
										ADRES,
										TCKIMLIKNO,
										RELATED_ID,
										TYPE_ID,
										LOGO_MUSTERI_TIP																
									)
									VALUES
									(
										#get_company.company_id#,
										'#get_company.glncode#',
										'#get_company.boyut_kodu#',
										<cfif len(get_company.carihesapkod)>'#get_company.carihesapkod#'<cfelse>'0'</cfif>,
										'#tr_to_iso(get_company.fullname)#',
										'#tr_to_iso(get_company.company_partner_name)#',
										'#tr_to_iso(get_company.company_partner_surname)#',
										<cfif len(get_company.musteridurum)>#get_company.musteridurum#<cfelse>0</cfif>,
										'#tr_to_iso(get_company.district)#',
										'#tr_to_iso(get_company.main_street)#',
										'#tr_to_iso(get_company.street)#',								
										'#tr_to_iso(get_company.dukkan_no)#',
										'#tr_to_iso(get_company.semt)#',
										'#tr_to_iso(get_company.county_name)#',
										'#tr_to_iso(get_company.city_name)#',
										#get_company.county_id#,
										'#get_company.company_telcode# #get_company.company_tel1#',
										<cfif len(get_company.company_fax)>'#get_company.company_fax_code# #get_company.company_fax#'<cfelse>'0'</cfif>,
										<cfif len(get_company.company_postcode)>'#get_company.company_postcode#'<cfelse>'0'</cfif>,
										'#tr_to_iso(get_company.taxoffice)#',
										'#get_company.taxno#',
										<cfif len(get_company.boyut_bsm)>'#get_company.boyut_bsm#'<cfelse>'0'</cfif>,
										<cfif len(get_company.boyut_telefon)>'#get_company.boyut_telefon#'<cfelse>'0'</cfif>,
										<cfif len(get_company.boyut_tahsilat)>'#get_company.boyut_tahsilat#'<cfelse>'0'</cfif>,
										<cfif len(get_company.boyut_plasiyer)>'#get_company.boyut_plasiyer#'<cfelse>'0'</cfif>,
										<cfif len(get_company.boyut_itriyat)>'#get_company.boyut_itriyat#'<cfelse>'0'</cfif>,
										'#muhasebekod1# #muhasebekod2# #muhasebekod3#',
										'#tr_to_iso(get_company.ims_code_501)#',
										'#tr_to_iso(get_company.ims_code)#',
										'#tarih_open#',
										'E',
										<cfif len(get_company.cep_sira)>'#tr_to_iso(get_company.cep_sira)#'<cfelse>'0'</cfif>,
										<cfif len(get_company.bolge_kodu)>'#tr_to_iso(get_company.bolge_kodu)#'<cfelse>'0'</cfif>,
										<cfif len(get_company.altbolge_kodu)>'#tr_to_iso(get_company.altbolge_kodu)#'<cfelse>'0'</cfif>,
										<cfif len(get_company.depot_km)>#get_company.depot_km#<cfelse>'0'</cfif>,
										#get_company.plate_code#,
										<cfif len(get_company.calisma_sekli)>'#get_company.calisma_sekli#'<cfelse>'0'</cfif>,
										<cfif len(get_company.puan)>'#tr_to_iso(get_company.puan)#'<cfelse>'0'</cfif>,
										#attributes.kayittipi#,
										#now()#,
										#session.ep.userid#,
										'#cgi.remote_addr#',
										0,
										<cfif len(get_credit.total_risk_limit)>#get_credit.total_risk_limit#<cfelse>0</cfif>,								
										<cfif len(get_company.grup_risk_limit)>#get_company.grup_risk_limit#<cfelse>0</cfif>,
										<cfif len(get_company.companycat_id)>#get_company.companycat_id#<cfelse>0</cfif>,
										<cfif len(get_company.sales_director)>#get_company.sales_director#<cfelse>0</cfif>,
										<cfif len(get_company.tel_sale_preid)>#get_company.tel_sale_preid#<cfelse>0</cfif>,
										<cfif len(get_company.tahsilatci)>#get_company.tahsilatci#<cfelse>0</cfif>,
										<cfif len(get_company.plasiyer_id)>#get_company.plasiyer_id#<cfelse>0</cfif>,
										<cfif len(get_company.itriyat_gorevli)>#get_company.itriyat_gorevli#<cfelse>0</cfif>,
										<cfif len(get_company.company_email)>'#tr_to_iso(get_company.company_email)#'<cfelse>'-'</cfif>,
										<cfif len(get_company.company_address)>'#tr_to_iso(get_company.company_address)#'<cfelse>'-'</cfif>,
										<cfif len(get_company.tc_identity)>'#get_company.tc_identity#'<cfelse>' '</cfif>,
										#get_company.related_id#,
										22,
										<cfif len(get_company.logo_musteri_tip)>'#get_company.logo_musteri_tip#'<cfelse>'0'</cfif>		
									)
								</cfquery>
							</cfif>
							<cfquery name="GET_MAXBOYUT" datasource="mushizgun">
								SELECT MAX(KAYITNO) AS MAX_KAYIT FROM CRMTOBOYUT
							</cfquery>
							<cfset attributes.is_boyut_insert = true>
							<cfcatch type="any">
								<script type="text/javascript">
									alert("<cf_get_lang no ='979.Müşteri Eklenirken Bir Problem Oluştu Lütfen Sistem Yöneticisine Başvurun'> !");
								</script>
							</cfcatch>
						</cftry>
					</cfif>
				</cfoutput>
			  <cfelse>
			</cfif>
		</cfif>
	</cfif>
<!--- iste Buradan Başlıyor . Ikinci Secenek --->	
<cfelseif isdefined("attributes.is_type") and attributes.is_type eq 2>
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif evaluate("attributes.row_kontrol#i#")>
			<cfset form_company_id = evaluate("attributes.company_id#i#")>
			<cfif len(form_company_id)>
				<cfif isdefined("attributes.is_sales")>
					<cfquery name="UPDATE_POSITION1" datasource="#DSN#">
						UPDATE 
							COMPANY_BRANCH_RELATED 
						SET 
							SALES_DIRECTOR = #attributes.yeni_gorevli_id#,
							BOYUT_BSM = '#attributes.yeni_boyut#'
						WHERE
							MUSTERIDURUM IS NOT NULL AND
							BRANCH_ID = #attributes.branch_id# AND
							COMPANY_ID = #form_company_id#
						  <cfif len(attributes.tr_status)>
							AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.tr_status#
						  </cfif>
						  <cfif isdefined("attributes.is_sifir") and len(attributes.eski_gorevli_id)>
							AND (SALES_DIRECTOR = #attributes.eski_gorevli_id# OR SALES_DIRECTOR = 0)
						  <cfelseif len(attributes.eski_gorevli_id)>
							AND SALES_DIRECTOR = #attributes.eski_gorevli_id#
						  <cfelseif isdefined("attributes.is_sifir")>
							AND SALES_DIRECTOR = 0
						  </cfif>
					</cfquery>
				</cfif>
				<cfif isdefined("attributes.is_telefon")>
					<cfquery name="UPDATE_POSITION2" datasource="#DSN#">
						UPDATE
							COMPANY_BRANCH_RELATED
						SET
							TEL_SALE_PREID = #attributes.yeni_gorevli_id#,
							BOYUT_TELEFON = '#attributes.yeni_boyut#'
						WHERE
							MUSTERIDURUM IS NOT NULL AND
							BRANCH_ID = #attributes.branch_id# AND
							COMPANY_ID = #form_company_id#
						  <cfif len(attributes.tr_status)>
							AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.tr_status#
						  </cfif>
						  <cfif isdefined("attributes.is_sifir") and len(attributes.eski_gorevli_id)>
							AND (TEL_SALE_PREID = #attributes.eski_gorevli_id# OR TEL_SALE_PREID = 0)
						  <cfelseif len(attributes.eski_gorevli_id)>
							AND TEL_SALE_PREID = #attributes.eski_gorevli_id#
						  <cfelseif isdefined("attributes.is_sifir")>
							AND TEL_SALE_PREID = 0
						  </cfif>
					</cfquery>
				</cfif>
				<cfif isdefined("attributes.is_saha")>
					<cfquery name="UPDATE_POSITION3" datasource="#DSN#">
						UPDATE 
							COMPANY_BRANCH_RELATED 
						SET 
							PLASIYER_ID = #attributes.yeni_gorevli_id#,
							BOYUT_PLASIYER = '#attributes.yeni_boyut#'
						WHERE
							MUSTERIDURUM IS NOT NULL AND
							BRANCH_ID = #attributes.branch_id# AND
							COMPANY_ID = #form_company_id# 
						  <cfif len(attributes.tr_status)>
							AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.tr_status#
						  </cfif>
						  <cfif isdefined("attributes.is_sifir") and len(attributes.eski_gorevli_id)>
							AND (PLASIYER_ID = #attributes.eski_gorevli_id# OR PLASIYER_ID = 0)
						  <cfelseif len(attributes.eski_gorevli_id)>
							AND PLASIYER_ID = #attributes.eski_gorevli_id#
						  <cfelseif isdefined("attributes.is_sifir")>
							AND PLASIYER_ID = 0
						  </cfif>
					</cfquery>
				</cfif>
				<cfif isdefined("attributes.is_itriyat")>
					<cfquery name="UPDATE_POSITION3" datasource="#DSN#">
						UPDATE 
							COMPANY_BRANCH_RELATED 
						SET 
							ITRIYAT_GOREVLI = #attributes.yeni_gorevli_id#,
							BOYUT_ITRIYAT = '#attributes.yeni_boyut#'
						WHERE
							MUSTERIDURUM IS NOT NULL AND
							BRANCH_ID = #attributes.branch_id# AND
							COMPANY_ID = #form_company_id# 
						  <cfif len(attributes.tr_status)>
							AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.tr_status#
						  </cfif>
						  <cfif isdefined("attributes.is_sifir") and len(attributes.eski_gorevli_id)>
							AND (ITRIYAT_GOREVLI = #attributes.eski_gorevli_id# OR ITRIYAT_GOREVLI = 0)
						  <cfelseif len(attributes.eski_gorevli_id)>
							AND ITRIYAT_GOREVLI = #attributes.eski_gorevli_id#
						  <cfelseif isdefined("attributes.is_sifir")>
							AND ITRIYAT_GOREVLI = 0
						  </cfif>
					</cfquery>
				</cfif>
				<cfif isdefined("attributes.is_tahsilat")>
					<cfquery name="UPDATE_POSITION3" datasource="#DSN#">
						UPDATE 
							COMPANY_BRANCH_RELATED 
						SET 
							TAHSILATCI = #attributes.yeni_gorevli_id#,
							BOYUT_TAHSILAT = '#attributes.yeni_boyut#'
						WHERE
							MUSTERIDURUM IS NOT NULL AND						
							BRANCH_ID = #attributes.branch_id# AND
							COMPANY_ID = #form_company_id# 
						  <cfif len(attributes.tr_status)>
							AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.tr_status#
						  </cfif>
						  <cfif isdefined("attributes.is_sifir") and len(attributes.eski_gorevli_id)>
							AND (TAHSILATCI = #attributes.eski_gorevli_id# OR TAHSILATCI = 0)
						<cfelseif len(attributes.eski_gorevli_id)>
							AND TAHSILATCI = #attributes.eski_gorevli_id#
						<cfelseif isdefined("attributes.is_sifir")>
							AND TAHSILATCI = 0
						</cfif>
					</cfquery>
				</cfif>
				<cfif isdefined("attributes.is_boyut")>
					<cfif isdefined("attributes.is_sales") or isdefined("attributes.is_telefon") or isdefined("attributes.is_saha") or isdefined("attributes.is_itriyat") or isdefined("attributes.is_tahsilat")>
						<cfset sql_string = ''>
						<cfset degisken_value = ''>
						<cfif isdefined("attributes.is_sales")>
							<cfset degisken_value = 'OR'>
							<cfset sql_string = sql_string & 'COMPANY_BRANCH_RELATED.SALES_DIRECTOR = #attributes.yeni_gorevli_id#'>
						</cfif>
						<cfif isdefined("attributes.is_telefon")>
							<cfset sql_string = sql_string & ' #degisken_value# COMPANY_BRANCH_RELATED.TEL_SALE_PREID = #attributes.yeni_gorevli_id#'>
							<cfset degisken_value = 'OR'>
						</cfif>
						<cfif isdefined("attributes.is_saha")> 
							<cfset sql_string = sql_string & ' #degisken_value# COMPANY_BRANCH_RELATED.PLASIYER_ID = #attributes.yeni_gorevli_id#'>
							<cfset degisken_value = 'OR'>
						</cfif>
						<cfif isdefined("attributes.is_itriyat")> 
							<cfset sql_string = sql_string & ' #degisken_value# COMPANY_BRANCH_RELATED.ITRIYAT_GOREVLI = #attributes.yeni_gorevli_id#'>
							<cfset degisken_value = 'OR'>
						</cfif>
						<cfif isdefined("attributes.is_tahsilat")>
							<cfset sql_string = sql_string & ' #degisken_value# COMPANY_BRANCH_RELATED.TAHSILATCI = #attributes.yeni_gorevli_id#'>
						</cfif>
						<cfquery name="GET_COMPANY" datasource="#DSN#">
							SELECT 
								COMPANY.COMPANY_ID,
								COMPANY.GLNCODE,
								COMPANY.FULLNAME,
								COMPANY.DISTRICT,
								COMPANY.STREET,
								COMPANY.MAIN_STREET,
								COMPANY.DUKKAN_NO,
								COMPANY.SEMT,
								COMPANY.COMPANY_TELCODE,
								COMPANY.COMPANY_TEL1,
								COMPANY.COMPANY_FAX,
								COMPANY.COMPANY_FAX_CODE,
								COMPANY.COMPANY_POSTCODE,
								COMPANY.TAXNO,
								COMPANY.TAXOFFICE,
								COMPANY.OLD_COMPANY_ID,
								COMPANY.COMPANY_EMAIL,
								COMPANY.COMPANY_ADDRESS,
								COMPANY.COMPANYCAT_ID,
								COMPANY.GRUP_RISK_LIMIT,
								COMPANY_BOYUT_DEPO_KOD.BOYUT_KODU,
								COMPANY_BRANCH_RELATED.RELATED_ID,
								COMPANY_BRANCH_RELATED.MUHASEBEKOD,
								COMPANY_BRANCH_RELATED.CARIHESAPKOD,
								COMPANY_BRANCH_RELATED.MUSTERIDURUM,
								COMPANY_BRANCH_RELATED.BOYUT_BSM,
								COMPANY_BRANCH_RELATED.SALES_DIRECTOR,
								COMPANY_BRANCH_RELATED.BOYUT_ITRIYAT,
								COMPANY_BRANCH_RELATED.ITRIYAT_GOREVLI,
								COMPANY_BRANCH_RELATED.BOYUT_PLASIYER,
								COMPANY_BRANCH_RELATED.PLASIYER_ID,
								COMPANY_BRANCH_RELATED.BOYUT_TAHSILAT,
								COMPANY_BRANCH_RELATED.TAHSILATCI,
								COMPANY_BRANCH_RELATED.BOYUT_TELEFON,
								COMPANY_BRANCH_RELATED.TEL_SALE_PREID,
								COMPANY_BRANCH_RELATED.OPEN_DATE,
								COMPANY_BRANCH_RELATED.CEP_SIRA,
								COMPANY_BRANCH_RELATED.BOLGE_KODU,
								COMPANY_BRANCH_RELATED.ALTBOLGE_KODU,
								COMPANY_BRANCH_RELATED.DEPOT_KM,
								COMPANY_BRANCH_RELATED.CALISMA_SEKLI,
								COMPANY_BRANCH_RELATED.PUAN,
								COMPANY_BRANCH_RELATED.LOGO_MUSTERI_TIP,
								COMPANY_PARTNER.COMPANY_PARTNER_NAME,
								COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
								COMPANY_PARTNER.TC_IDENTITY,
								SETUP_COUNTY.COUNTY_NAME,
								SETUP_COUNTY.COUNTY_ID,
								SETUP_CITY.CITY_NAME,
								SETUP_CITY.PLATE_CODE,
								SETUP_IMS_CODE.IMS_CODE,
								SETUP_IMS_CODE.IMS_CODE_501
							FROM
								COMPANY,
								COMPANY_BRANCH_RELATED,
								COMPANY_BOYUT_DEPO_KOD,
								COMPANY_PARTNER, 
								SETUP_COUNTY,
								BRANCH,
								SETUP_CITY,
								SETUP_IMS_CODE
							WHERE
								COMPANY.COMPANY_STATUS = 1 AND
								COMPANY.COMPANY_ID = #form_company_id# AND
								COMPANY_BRANCH_RELATED.COMPANY_ID = COMPANY.COMPANY_ID AND 
								COMPANY_BRANCH_RELATED.BRANCH_ID = COMPANY_BOYUT_DEPO_KOD.W_KODU AND
								COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
								COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND
								COMPANY.COUNTY = SETUP_COUNTY.COUNTY_ID AND
								COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND
								COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND
								COMPANY.CITY = SETUP_CITY.CITY_ID AND
								COMPANY_BRANCH_RELATED.BRANCH_ID = #attributes.branch_id#
								<cfif len(attributes.tr_status)>AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.tr_status#</cfif>
								AND SETUP_IMS_CODE.IMS_CODE_ID = COMPANY.IMS_CODE_ID AND
								(
									#sql_string#
								)
						</cfquery>
						<cfset attributes.kayittipi = 3>
						<cfif get_company.recordcount>
						<cfoutput query="get_company">
							<cfquery name="GET_COMPANY_BOYUT" datasource="mushizgun">
								SELECT ETICARETKOD, ETICARETIP FROM DEPOLAR WHERE DEPOKODU = '#get_company.boyut_kodu#'
							</cfquery>
							<cfset attributes.action_id = get_company.company_id>
								<cftry>
									<cfscript>
										tarih_open = dateformat(get_company.open_date,dateformat_style);
										if(len(get_company.muhasebekod))
										{
											muhasebekod1 = mid(get_company.muhasebekod,1,3);
											muhasebekod2 = mid(get_company.muhasebekod,4,2);
											muhasebekod3 = mid(get_company.muhasebekod,6,(len(get_company.muhasebekod)-5));
										}
										else
										{
											muhasebekod1 = '';
											muhasebekod2 = '';
											muhasebekod3 = '';
										}
									</cfscript>
									<cfquery name="GET_COMPANY_BOYUT" datasource="mushizgun">
										SELECT ETICARETKOD, ETICARETIP FROM DEPOLAR WHERE DEPOKODU = '#get_company.boyut_kodu#'
									</cfquery>
									<cfquery name="GET_CREDIT" datasource="#DSN#">
										SELECT TOTAL_RISK_LIMIT, MONEY FROM COMPANY_CREDIT WHERE COMPANY_ID = #get_company.company_id# AND BRANCH_ID = #get_company.related_id#
									</cfquery>
									<!--- Muhasebe kodu ve cari hesap karakteri 10 ve ilk 3 karekteri 120 ise CRMTOBOYUT a kayit at--->
									<cfif (len(get_company.muhasebekod) eq 10) and (len(get_company.carihesapkod) eq 10) and (left(get_company.muhasebekod,3) eq 120) and (left(get_company.carihesapkod,3) eq 120)>
										<cfquery name="ADD_COMPANY" datasource="mushizgun">
											INSERT INTO
												CRMTOBOYUT 
											(
												HEDEFKODU,
												GLNCODE,
												DEPOKOD,
												HESAPKODU,
												ISYERIADI,
												ADI,
												SOYADI,
												MDURUM,
												MAHALLE,
												CADDE,
												SOKAK,
												NUMARA,
												SEMT,
												ILCE,
												IL,
												ILCEKODU,
												TELEFON,
												FAX,
												POSTAKODU,
												VERGIDAIRE,
												VERGINO,
												BSM,
												TELEFONCU,
												TAHSILDAR,
												PLASIYER,
												PLASIYER2,
												MUHKOD,
												IMSKOD501,
												IMSKOD101,
												ACTAR,
												CARITIP,
												CEPSIRA,
												BOLGEKODU,
												ALTBOLGEKD,
												UZAKLIK,
												PLAKA,
												CALISSEKLI,
												PUAN,
												KAYITTIPI,
												EKLENMETAR,
												EKLEMETALEP,
												EKLEMEIP,
												KAYITDURUM,
												RISKTOP,											
												GRUPRISKTOP,
												MTIP,
												INKABSM,
												INKATELEFONCU,
												INKATAHSILDAR,
												INKAPLASIYER,
												INKAPLASIYER2,
												EMAIL,
												ADRES,
												TCKIMLIKNO,
												RELATED_ID,
												TYPE_ID,
												LOGO_MUSTERI_TIP
											)
											VALUES
											(
												#get_company.company_id#,
												'#get_company.glncode#',
												'#get_company.boyut_kodu#',
												<cfif len(get_company.carihesapkod)>'#get_company.carihesapkod#',<cfelse>'0',</cfif>
												'#tr_to_iso(get_company.fullname)#',
												'#tr_to_iso(get_company.company_partner_name)#',
												'#tr_to_iso(get_company.company_partner_surname)#',
												<cfif len(get_company.musteridurum)>#get_company.musteridurum#,<cfelse>0,</cfif>
												'#tr_to_iso(get_company.district)#',
												'#tr_to_iso(get_company.main_street)#',
												'#tr_to_iso(get_company.street)#',
												'#tr_to_iso(get_company.dukkan_no)#',
												'#tr_to_iso(get_company.semt)#',
												'#tr_to_iso(get_company.county_name)#',
												'#tr_to_iso(get_company.city_name)#',
												#get_company.county_id#,
												'#get_company.company_telcode# #get_company.company_tel1#',
												<cfif len(get_company.company_fax)>'#get_company.company_fax_code# #get_company.company_fax#',<cfelse>'0',</cfif>
												<cfif len(get_company.company_postcode)>'#get_company.company_postcode#',<cfelse>'0',</cfif>
												'#tr_to_iso(get_company.taxoffice)#',
												'#get_company.taxno#',
												<cfif len(get_company.boyut_bsm)>'#get_company.boyut_bsm#',<cfelse>'0',</cfif>
												<cfif len(get_company.boyut_telefon)>'#get_company.boyut_telefon#',<cfelse>'0',</cfif>
												<cfif len(get_company.boyut_tahsilat)>'#get_company.boyut_tahsilat#',<cfelse>'0',</cfif>
												<cfif len(get_company.boyut_plasiyer)>'#get_company.boyut_plasiyer#',<cfelse>'0',</cfif>
												<cfif len(get_company.boyut_itriyat)>'#get_company.boyut_itriyat#',<cfelse>'0',</cfif>
												'#muhasebekod1# #muhasebekod2# #muhasebekod3#',
												'#tr_to_iso(get_company.ims_code_501)#',
												'#tr_to_iso(get_company.ims_code)#',
												'#tarih_open#',
												'E',
												<cfif len(get_company.cep_sira)>'#tr_to_iso(get_company.cep_sira)#',<cfelse>'0',</cfif>
												<cfif len(get_company.bolge_kodu)>'#tr_to_iso(get_company.bolge_kodu)#',<cfelse>'0',</cfif>
												<cfif len(get_company.altbolge_kodu)>'#tr_to_iso(get_company.altbolge_kodu)#',<cfelse>'0',</cfif>
												<cfif len(get_company.depot_km)>#get_company.depot_km#,<cfelse>'0',</cfif>
												#get_company.plate_code#,
												<cfif len(get_company.calisma_sekli)>'#get_company.calisma_sekli#',<cfelse>'0',</cfif>
												<cfif len(get_company.puan)>'#tr_to_iso(get_company.puan)#',<cfelse>'0',</cfif>
												#attributes.kayittipi#,
												#now()#,
												#session.ep.userid#,
												'#cgi.remote_addr#',
												0,
												<cfif len(get_credit.total_risk_limit)>#get_credit.total_risk_limit#<cfelse>0</cfif>,	
												<cfif len(get_company.grup_risk_limit)>#get_company.grup_risk_limit#<cfelse>0</cfif>,
												<cfif len(get_company.companycat_id)>#get_company.companycat_id#<cfelse>0</cfif>,
												<cfif len(get_company.sales_director)>#get_company.sales_director#<cfelse>0</cfif>,
												<cfif len(get_company.tel_sale_preid)>#get_company.tel_sale_preid#<cfelse>0</cfif>,
												<cfif len(get_company.tahsilatci)>#get_company.tahsilatci#<cfelse>0</cfif>,
												<cfif len(get_company.plasiyer_id)>#get_company.plasiyer_id#<cfelse>0</cfif>,
												<cfif len(get_company.itriyat_gorevli)>#get_company.itriyat_gorevli#<cfelse>0</cfif>,
												<cfif len(get_company.company_email)>'#tr_to_iso(get_company.company_email)#'<cfelse>'-'</cfif>,
												<cfif len(get_company.company_address)>'#tr_to_iso(get_company.company_address)#'<cfelse>'-'</cfif>,
												<cfif len(get_company.tc_identity)>'#get_company.tc_identity#'<cfelse>' '</cfif>,
												#get_company.related_id#,
												22,
												<cfif len(get_company.logo_musteri_tip)>'#get_company.logo_musteri_tip#'<cfelse>'0'</cfif>
											)
										</cfquery>
									</cfif>										
									<cfquery name="GET_MAXBOYUT" datasource="mushizgun">
										SELECT MAX(KAYITNO) AS MAX_KAYIT FROM CRMTOBOYUT
									</cfquery>
									<cfset attributes.is_boyut_insert = true>
									<cfcatch type="any">
										<script type="text/javascript">
											alert("<cf_get_lang no ='979.Müşteri Eklenirken Bir Problem Oluştu Lütfen Sistem Yöneticisine Başvurun'>!");
										</script>
									</cfcatch>
								</cftry>
							</cfoutput>
						  <cfelse>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
<!--- Iste Burada Basliyor . Ucuncu Secenek --->
<cfelseif isdefined("attributes.is_type") and attributes.is_type eq 3>
	<cfloop from="1" to="#attributes.record_num1#" index="i">
		<cfif evaluate("attributes.row_kontrol1#i#")>
			<cfset form_ims_code_id = evaluate("attributes.ims_code_id#i#")>
			<cfquery name="GET_COMPANY_VALUE" datasource="#DSN#">
				SELECT COMPANY_ID FROM COMPANY WHERE IMS_CODE_ID = #form_ims_code_id#
			</cfquery>
			<cfloop query="get_company_value">
				<cfif isdefined("attributes.is_sales")>
					<cfquery name="UPDATE_POSITION1" datasource="#DSN#">
						UPDATE 
							COMPANY_BRANCH_RELATED 
						SET
							SALES_DIRECTOR = #attributes.yeni_gorevli_id#,
							BOYUT_BSM = '#attributes.yeni_boyut#'
						WHERE
							MUSTERIDURUM IS NOT NULL AND
							BRANCH_ID = #attributes.branch_id# AND
							COMPANY_ID = #get_company_value.company_id# 
						  <cfif len(attributes.tr_status)>
							AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.tr_status#
						  </cfif>
						  <cfif isdefined("attributes.is_sifir") and len(attributes.eski_gorevli_id)>
							AND (SALES_DIRECTOR = #attributes.eski_gorevli_id# OR SALES_DIRECTOR = 0)
						  <cfelseif len(attributes.eski_gorevli_id)>
							AND SALES_DIRECTOR = #attributes.eski_gorevli_id#
						  <cfelseif isdefined("attributes.is_sifir")>
							AND SALES_DIRECTOR = 0
						  </cfif>
					</cfquery>
				</cfif>
				<cfif isdefined("attributes.is_telefon")>
					<cfquery name="UPDATE_POSITION2" datasource="#DSN#">
						UPDATE 
							COMPANY_BRANCH_RELATED 
						SET 
							TEL_SALE_PREID = #attributes.yeni_gorevli_id#,
							BOYUT_TELEFON = '#attributes.yeni_boyut#'
						WHERE
							MUSTERIDURUM IS NOT NULL AND
							BRANCH_ID = #attributes.branch_id# AND
							COMPANY_ID = #get_company_value.company_id#
						  <cfif len(attributes.tr_status)>
							AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.tr_status#
						  </cfif>
						  <cfif isdefined("attributes.is_sifir") and len(attributes.eski_gorevli_id)>
							AND (TEL_SALE_PREID = #attributes.eski_gorevli_id# OR TEL_SALE_PREID = 0)
						  <cfelseif len(attributes.eski_gorevli_id)>
							AND TEL_SALE_PREID = #attributes.eski_gorevli_id#
						  <cfelseif isdefined("attributes.is_sifir")>
							AND TEL_SALE_PREID = 0
						  </cfif>
					</cfquery>
				</cfif>
				<cfif isdefined("attributes.is_saha")>
					<cfquery name="UPDATE_POSITION3" datasource="#DSN#">
						UPDATE 
							COMPANY_BRANCH_RELATED 
						SET 
							PLASIYER_ID = #attributes.yeni_gorevli_id#,
							BOYUT_PLASIYER = '#attributes.yeni_boyut#'
						WHERE
							MUSTERIDURUM IS NOT NULL AND
							BRANCH_ID = #attributes.branch_id# AND
							COMPANY_ID = #get_company_value.company_id#
						  <cfif len(attributes.tr_status)>
							AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.tr_status#
						  </cfif>							
						  <cfif isdefined("attributes.is_sifir") and len(attributes.eski_gorevli_id)>
							AND (PLASIYER_ID = #attributes.eski_gorevli_id# OR PLASIYER_ID = 0)
						  <cfelseif len(attributes.eski_gorevli_id)>
							AND PLASIYER_ID = #attributes.eski_gorevli_id#
						  <cfelseif isdefined("attributes.is_sifir")>
							AND PLASIYER_ID = 0
						  </cfif>
					</cfquery>
				</cfif>
				<cfif isdefined("attributes.is_itriyat")>
					<cfquery name="UPDATE_POSITION3" datasource="#DSN#">
						UPDATE 
							COMPANY_BRANCH_RELATED 
						SET 
							ITRIYAT_GOREVLI = #attributes.yeni_gorevli_id#,
							BOYUT_ITRIYAT = '#attributes.yeni_boyut#'
						WHERE
							MUSTERIDURUM IS NOT NULL AND
							BRANCH_ID = #attributes.branch_id# AND
							COMPANY_ID = #get_company_value.company_id#
						  <cfif len(attributes.tr_status)>
							AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.tr_status#
						  </cfif>
						  <cfif isdefined("attributes.is_sifir") and len(attributes.eski_gorevli_id)>
							AND (ITRIYAT_GOREVLI = #attributes.eski_gorevli_id# OR ITRIYAT_GOREVLI = 0)
						  <cfelseif len(attributes.eski_gorevli_id)>
							AND ITRIYAT_GOREVLI = #attributes.eski_gorevli_id#
						  <cfelseif isdefined("attributes.is_sifir")>
							AND ITRIYAT_GOREVLI = 0
						  </cfif>
					</cfquery>
				</cfif>
				<cfif isdefined("attributes.is_tahsilat")>
					<cfquery name="UPDATE_POSITION3" datasource="#DSN#">
						UPDATE 
							COMPANY_BRANCH_RELATED 
						SET 
							TAHSILATCI = #attributes.yeni_gorevli_id#,
							BOYUT_TAHSILAT = '#attributes.yeni_boyut#'
						WHERE
							MUSTERIDURUM IS NOT NULL AND
							BRANCH_ID = #attributes.branch_id# AND
							COMPANY_ID = #get_company_value.company_id#
						  <cfif len(attributes.tr_status)>
							AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.tr_status#
						  </cfif>
						  <cfif isdefined("attributes.is_sifir") and len(attributes.eski_gorevli_id)>
							AND (TAHSILATCI = #attributes.eski_gorevli_id# OR TAHSILATCI = 0)
						  <cfelseif len(attributes.eski_gorevli_id)>
							AND TAHSILATCI = #attributes.eski_gorevli_id#
						  <cfelseif isdefined("attributes.is_sifir")>
							AND TAHSILATCI = 0
						  </cfif>
					</cfquery>
				</cfif>
				<cfif isdefined("attributes.is_boyut")>
					<cfif isdefined("attributes.is_sales") or isdefined("attributes.is_telefon") or isdefined("attributes.is_saha") or isdefined("attributes.is_itriyat") or isdefined("attributes.is_tahsilat")>
						<cfset sql_string = ''>
						<cfset degisken_value = ''>
						<cfif isdefined("attributes.is_sales")>
							<cfset degisken_value = 'OR'>
							<cfset sql_string = sql_string & 'COMPANY_BRANCH_RELATED.SALES_DIRECTOR = #attributes.yeni_gorevli_id#'>
						</cfif>
						<cfif isdefined("attributes.is_telefon")>
							<cfset sql_string = sql_string & ' #degisken_value# COMPANY_BRANCH_RELATED.TEL_SALE_PREID = #attributes.yeni_gorevli_id#'>
							<cfset degisken_value = 'OR'>
						</cfif>
						<cfif isdefined("attributes.is_saha")> 
							<cfset sql_string = sql_string & ' #degisken_value# COMPANY_BRANCH_RELATED.PLASIYER_ID = #attributes.yeni_gorevli_id#'>
							<cfset degisken_value = 'OR'>
						</cfif>
						<cfif isdefined("attributes.is_itriyat")> 
							<cfset sql_string = sql_string & ' #degisken_value# COMPANY_BRANCH_RELATED.ITRIYAT_GOREVLI = #attributes.yeni_gorevli_id#'>
							<cfset degisken_value = 'OR'>
						</cfif>
						<cfif isdefined("attributes.is_tahsilat")>
							<cfset sql_string = sql_string & ' #degisken_value# COMPANY_BRANCH_RELATED.TAHSILATCI = #attributes.yeni_gorevli_id#'>
						</cfif>
						<cfquery name="GET_COMPANY" datasource="#DSN#">
							SELECT 
								COMPANY.COMPANY_ID,
								COMPANY.GLNCODE,
								COMPANY.FULLNAME,
								COMPANY.DISTRICT,
								COMPANY.STREET,
								COMPANY.MAIN_STREET,
								COMPANY.DUKKAN_NO,
								COMPANY.SEMT,
								COMPANY.COMPANY_TELCODE,
								COMPANY.COMPANY_TEL1,
								COMPANY.COMPANY_FAX,
								COMPANY.COMPANY_FAX_CODE,
								COMPANY.COMPANY_POSTCODE,
								COMPANY.TAXNO,
								COMPANY.TAXOFFICE,
								COMPANY.OLD_COMPANY_ID,
								COMPANY.COMPANY_EMAIL,
								COMPANY.COMPANY_ADDRESS,
								COMPANY.COMPANYCAT_ID,
								COMPANY.GRUP_RISK_LIMIT,
								COMPANY_BOYUT_DEPO_KOD.BOYUT_KODU,
								COMPANY_BRANCH_RELATED.RELATED_ID,
								COMPANY_BRANCH_RELATED.MUHASEBEKOD,
								COMPANY_BRANCH_RELATED.CARIHESAPKOD,
								COMPANY_BRANCH_RELATED.MUSTERIDURUM,
								COMPANY_BRANCH_RELATED.BOYUT_BSM,
								COMPANY_BRANCH_RELATED.SALES_DIRECTOR,
								COMPANY_BRANCH_RELATED.BOYUT_ITRIYAT,
								COMPANY_BRANCH_RELATED.ITRIYAT_GOREVLI,
								COMPANY_BRANCH_RELATED.BOYUT_PLASIYER,
								COMPANY_BRANCH_RELATED.PLASIYER_ID,
								COMPANY_BRANCH_RELATED.BOYUT_TAHSILAT,
								COMPANY_BRANCH_RELATED.TAHSILATCI,
								COMPANY_BRANCH_RELATED.BOYUT_TELEFON,
								COMPANY_BRANCH_RELATED.TEL_SALE_PREID,
								COMPANY_BRANCH_RELATED.OPEN_DATE,
								COMPANY_BRANCH_RELATED.CEP_SIRA,
								COMPANY_BRANCH_RELATED.BOLGE_KODU,
								COMPANY_BRANCH_RELATED.ALTBOLGE_KODU,
								COMPANY_BRANCH_RELATED.DEPOT_KM,
								COMPANY_BRANCH_RELATED.CALISMA_SEKLI,
								COMPANY_BRANCH_RELATED.PUAN,
								COMPANY_BRANCH_RELATED.LOGO_MUSTERI_TIP,
								COMPANY_PARTNER.COMPANY_PARTNER_NAME,
								COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
								COMPANY_PARTNER.TC_IDENTITY,
								SETUP_COUNTY.COUNTY_NAME,
								SETUP_COUNTY.COUNTY_ID,
								SETUP_CITY.CITY_NAME,
								SETUP_CITY.PLATE_CODE,
								SETUP_IMS_CODE.IMS_CODE,
								SETUP_IMS_CODE.IMS_CODE_501
							FROM
								COMPANY,
								COMPANY_BRANCH_RELATED,
								COMPANY_BOYUT_DEPO_KOD,
								COMPANY_PARTNER, 
								SETUP_COUNTY,
								BRANCH,
								SETUP_CITY,
								SETUP_IMS_CODE
							WHERE
								COMPANY.COMPANY_STATUS = 1 AND
								COMPANY.COMPANY_ID = #get_company_value.company_id# AND
								COMPANY_BRANCH_RELATED.COMPANY_ID = COMPANY.COMPANY_ID AND 
								COMPANY_BRANCH_RELATED.BRANCH_ID = COMPANY_BOYUT_DEPO_KOD.W_KODU AND
								COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
								COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND
								COMPANY.COUNTY = SETUP_COUNTY.COUNTY_ID AND
								COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND
								COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND
								COMPANY.CITY = SETUP_CITY.CITY_ID AND
								COMPANY_BRANCH_RELATED.BRANCH_ID = #attributes.branch_id#
								<cfif len(attributes.tr_status)>AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.tr_status#</cfif>
								AND SETUP_IMS_CODE.IMS_CODE_ID = COMPANY.IMS_CODE_ID AND
								(
									#sql_string#
								)
						</cfquery>
						<cfset attributes.kayittipi = 3>
						<cfif get_company.recordcount>
						<cfoutput query="get_company">
							<cfquery name="GET_COMPANY_BOYUT" datasource="mushizgun">
								SELECT ETICARETKOD, ETICARETIP FROM DEPOLAR WHERE DEPOKODU = '#get_company.boyut_kodu#'
							</cfquery>
							<cfset attributes.action_id = get_company.company_id>
								<cftry>
									<cfscript>
										tarih_open = dateformat(get_company.open_date,dateformat_style);
										if(len(get_company.muhasebekod))
										{
											muhasebekod1 = mid(get_company.muhasebekod,1,3);
											muhasebekod2 = mid(get_company.muhasebekod,4,2);
											muhasebekod3 = mid(get_company.muhasebekod,6,(len(get_company.muhasebekod)-5));
										}
										else
										{
											muhasebekod1 = '';
											muhasebekod2 = '';
											muhasebekod3 = '';
										}
									</cfscript>
									<cfquery name="GET_COMPANY_BOYUT" datasource="mushizgun">
										SELECT ETICARETKOD, ETICARETIP FROM DEPOLAR WHERE DEPOKODU = '#get_company.boyut_kodu#'
									</cfquery>
									<cfquery name="GET_CREDIT" datasource="#DSN#">
										SELECT TOTAL_RISK_LIMIT, MONEY FROM COMPANY_CREDIT WHERE COMPANY_ID = #get_company.company_id# AND BRANCH_ID = #get_company.related_id#
									</cfquery>
									<!--- Muhasebe kodu ve cari hesap karakteri 10 ve ilk 3 karekteri 120 ise CRMTOBOYUT a kayit at--->
									<cfif (len(get_company.muhasebekod) eq 10) and (len(get_company.carihesapkod) eq 10) and (left(get_company.muhasebekod,3) eq 120) and (left(get_company.carihesapkod,3) eq 120)>
										<cfquery name="ADD_COMPANY" datasource="mushizgun">
											INSERT INTO
												CRMTOBOYUT 
											(
												HEDEFKODU,
												GLNCODE,
												DEPOKOD,
												HESAPKODU,
												ISYERIADI,
												ADI,
												SOYADI,
												MDURUM,
												MAHALLE,
												CADDE,
												SOKAK,
												NUMARA,
												SEMT,
												ILCE,
												IL,
												ILCEKODU,
												TELEFON,
												FAX,
												POSTAKODU,
												VERGIDAIRE,
												VERGINO,
												BSM,
												TELEFONCU,
												TAHSILDAR,
												PLASIYER,
												PLASIYER2,
												MUHKOD,
												IMSKOD501,
												IMSKOD101,
												ACTAR,
												CARITIP,
												CEPSIRA,
												BOLGEKODU,
												ALTBOLGEKD,
												UZAKLIK,
												PLAKA,
												CALISSEKLI,
												PUAN,
												KAYITTIPI,
												EKLENMETAR,
												EKLEMETALEP,
												EKLEMEIP,
												KAYITDURUM,
												RISKTOP,												
												GRUPRISKTOP,
												MTIP,
												INKABSM,
												INKATELEFONCU,
												INKATAHSILDAR,
												INKAPLASIYER,
												INKAPLASIYER2,
												EMAIL,
												ADRES,
												TCKIMLIKNO,
												RELATED_ID,
												TYPE_ID,
												LOGO_MUSTERI_TIP																					
											)
											VALUES
											(
												#get_company.company_id#,
												'#get_company.glncode#',
												'#get_company.boyut_kodu#',
												<cfif len(get_company.carihesapkod)>'#get_company.carihesapkod#',<cfelse>'0',</cfif>
												'#tr_to_iso(get_company.fullname)#',
												'#tr_to_iso(get_company.company_partner_name)#',
												'#tr_to_iso(get_company.company_partner_surname)#',
												<cfif len(get_company.musteridurum)>#get_company.musteridurum#,<cfelse>0,</cfif>
												'#tr_to_iso(get_company.district)#',
												'#tr_to_iso(get_company.main_street)#',
												'#tr_to_iso(get_company.street)#',											
												'#tr_to_iso(get_company.dukkan_no)#',
												'#tr_to_iso(get_company.semt)#',
												'#tr_to_iso(get_company.county_name)#',
												'#tr_to_iso(get_company.city_name)#',
												#get_company.county_id#,
												'#get_company.company_telcode# #get_company.company_tel1#',
												<cfif len(get_company.company_fax)>'#get_company.company_fax_code# #get_company.company_fax#',<cfelse>'0',</cfif>
												<cfif len(get_company.company_postcode)>'#get_company.company_postcode#',<cfelse>'0',</cfif>
												'#tr_to_iso(get_company.taxoffice)#',
												'#get_company.taxno#',
												<cfif len(get_company.boyut_bsm)>'#get_company.boyut_bsm#',<cfelse>'0',</cfif>
												<cfif len(get_company.boyut_telefon)>'#get_company.boyut_telefon#',<cfelse>'0',</cfif>
												<cfif len(get_company.boyut_tahsilat)>'#get_company.boyut_tahsilat#',<cfelse>'0',</cfif>
												<cfif len(get_company.boyut_plasiyer)>'#get_company.boyut_plasiyer#',<cfelse>'0',</cfif>
												<cfif len(get_company.boyut_itriyat)>'#get_company.boyut_itriyat#',<cfelse>'0',</cfif>
												'#muhasebekod1# #muhasebekod2# #muhasebekod3#',
												'#tr_to_iso(get_company.ims_code_501)#',
												'#tr_to_iso(get_company.ims_code)#',
												'#tarih_open#',
												'E',
												<cfif len(get_company.cep_sira)>'#tr_to_iso(get_company.cep_sira)#',<cfelse>'0',</cfif>
												<cfif len(get_company.bolge_kodu)>'#tr_to_iso(get_company.bolge_kodu)#',<cfelse>'0',</cfif>
												<cfif len(get_company.altbolge_kodu)>'#tr_to_iso(get_company.altbolge_kodu)#',<cfelse>'0',</cfif>
												<cfif len(get_company.depot_km)>#get_company.depot_km#,<cfelse>'0',</cfif>
												#get_company.plate_code#,
												<cfif len(get_company.calisma_sekli)>'#get_company.calisma_sekli#',<cfelse>'0',</cfif>
												<cfif len(get_company.puan)>'#tr_to_iso(get_company.puan)#',<cfelse>'0',</cfif>
												#attributes.kayittipi#,
												#now()#,
												#session.ep.userid#,
												'#cgi.remote_addr#',
												0,
												<cfif len(get_credit.total_risk_limit)>#get_credit.total_risk_limit#<cfelse>0</cfif>,	
												<cfif len(get_company.grup_risk_limit)>#get_company.grup_risk_limit#<cfelse>0</cfif>,
												<cfif len(get_company.companycat_id)>#get_company.companycat_id#<cfelse>0</cfif>,
												<cfif len(get_company.sales_director)>#get_company.sales_director#<cfelse>0</cfif>,
												<cfif len(get_company.tel_sale_preid)>#get_company.tel_sale_preid#<cfelse>0</cfif>,
												<cfif len(get_company.tahsilatci)>#get_company.tahsilatci#<cfelse>0</cfif>,
												<cfif len(get_company.plasiyer_id)>#get_company.plasiyer_id#<cfelse>0</cfif>,
												<cfif len(get_company.itriyat_gorevli)>#get_company.itriyat_gorevli#<cfelse>0</cfif>,
												<cfif len(get_company.company_email)>'#tr_to_iso(get_company.company_email)#'<cfelse>'-'</cfif>,
												<cfif len(get_company.company_address)>'#tr_to_iso(get_company.company_address)#'<cfelse>'-'</cfif>,
												<cfif len(get_company.tc_identity)>'#get_company.tc_identity#'<cfelse>' '</cfif>,
												#get_company.related_id#,
												22,
												<cfif len(get_company.logo_musteri_tip)>'#get_company.logo_musteri_tip#'<cfelse>'0'</cfif>									
											)
										</cfquery>
									</cfif>
									<cfquery name="GET_MAXBOYUT" datasource="mushizgun">
										SELECT MAX(KAYITNO) AS MAX_KAYIT FROM CRMTOBOYUT
									</cfquery>
									<cfset attributes.is_boyut_insert = true>
									<cfcatch type="any">
										<script type="text/javascript">
											alert("<cf_get_lang no ='979.Müşteri Eklenirken Bir Problem Oluştu Lütfen Sistem Yöneticisine Başvurun'>!");
										</script>
									</cfcatch>
								</cftry>
							</cfoutput>
						  <cfelse>
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cfloop>
</cfif>
<script type="text/javascript">
	alert("<cf_get_lang dictionary_id ='52427.Aktarım Tamamlandı'> !");
	closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	location.reload();
</script>

<cfquery name="ADD_RELATED" datasource="#DSN#">
	UPDATE
		COMPANY_BRANCH_RELATED
	SET
		IS_SELECT = <cfif isdefined("attributes.is_select")>1<cfelse>0</cfif>,
		MUSTERIDURUM = #attributes.cat_status#,
		DEPO_STATUS = #attributes.pro_rows#
	WHERE
		RELATED_ID = #attributes.related_id#
</cfquery>
<!--- 9 Merkez kapatmis, 66 sube degisikligi --->
<cfif not ListFind("9,66",attributes.old_cat_status)>
	<cfscript>
		attributes.kayittipi = 2;
		attributes.is_boyut_insert = false ;
		function tr_to_iso(attributes_list)
		{
			var return_value = '';
			return_value = replacelist(attributes_list,'ü,ğ,ı,ş,ç,ö,Ü,Ğ,İ,Ş,Ç,Ö,|','U,G,I,S,C,O,U,G,I,S,C,O, ');
			return return_value;
		}
	
	</cfscript>
	<cfquery name="GET_COMPANY" datasource="#DSN#">
		SELECT 
			COMPANY.COMPANY_ID,
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
			COMPANY_PARTNER.COMPANY_PARTNER_NAME,
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
			COMPANY_PARTNER.TC_IDENTITY,
			COMPANY_BOYUT_DEPO_KOD.BOYUT_KODU,
			COMPANY_BRANCH_RELATED.MUHASEBEKOD,
			COMPANY_BRANCH_RELATED.CARIHESAPKOD,
			COMPANY_BRANCH_RELATED.MUSTERIDURUM,
			COMPANY_BRANCH_RELATED.BOYUT_BSM,
			COMPANY_BRANCH_RELATED.SALES_DIRECTOR,
			COMPANY_BRANCH_RELATED.RELATED_ID,
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
			COMPANY_BRANCH_RELATED.RELATED_ID = #attributes.related_id# AND
			COMPANY.COMPANY_STATUS = 1 AND
			COMPANY.COMPANY_ID = #attributes.company_id# AND
			COMPANY_BRANCH_RELATED.COMPANY_ID = COMPANY.COMPANY_ID AND 
			COMPANY_BRANCH_RELATED.BRANCH_ID = COMPANY_BOYUT_DEPO_KOD.W_KODU AND
			COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
			COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND
			COMPANY.COUNTY = SETUP_COUNTY.COUNTY_ID AND
			COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND
			COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND
			COMPANY.CITY = SETUP_CITY.CITY_ID AND
			SETUP_IMS_CODE.IMS_CODE_ID = COMPANY.IMS_CODE_ID AND
			COMPANY_BRANCH_RELATED.IS_SELECT <> 0 AND
			<!--- BK ekledi 20080917 Aydın Ersoz istegi  --->
			COMPANY_BRANCH_RELATED.MUSTERIDURUM NOT IN (1,4,66) 
	</cfquery>
	<cfif get_company.recordcount>
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
			SELECT TOTAL_RISK_LIMIT, MONEY FROM COMPANY_CREDIT WHERE COMPANY_ID = #attributes.company_id# AND BRANCH_ID = #get_company.related_id#
		</cfquery>
		<cftry>
			<!--- Muhasebe kodu ve cari hesap karakteri 10 ve ilk 3 karekteri 120 ise CRMTOBOYUT a kayit at--->
			<cfif (len(get_company.muhasebekod) eq 10) and (len(get_company.carihesapkod) eq 10) and (left(get_company.muhasebekod,3) eq 120) and (left(get_company.carihesapkod,3) eq 120)>
				<cflock name="AddCrmBoyut" timeout="60">
					<cftransaction>
						<cfquery name="ADD_COMPANY" datasource="mushizgun">
							INSERT INTO
								CRMTOBOYUT 
							(
								HEDEFKODU,
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
								#attributes.related_id#,
								20,
								<cfif len(get_company.logo_musteri_tip)>'#get_company.logo_musteri_tip#'<cfelse>'0'</cfif>
							)
						</cfquery>
				 	</cftransaction>
				</cflock>
				<cfset attributes.is_boyut_insert = true>
			<cfelse>
				<cfset attributes.is_boyut_insert = false>	
			</cfif>
			<cfcatch>
				<cfset attributes.is_boyut_insert = false>
			</cfcatch>
		</cftry>
		<cfif attributes.is_boyut_insert>
			<script type="text/javascript">
				alert("<cf_get_lang no ='970.Güncelleme Başarı İle Tamamlandı ! Kaydınız Başarı İle Boyuta Aktarıldı'> !");
			</script>
		<cfelse>
			<cfquery name="ADD_COMPANY_BOYUT_DEPO_KONTROL" datasource="#DSN#">
				INSERT INTO
					COMPANY_BOYUT_DEPO_CONTROL
				(
					COMPANY_ID,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
				VALUES
				(
					#attributes.company_id#,
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'
				)
			</cfquery>
			<cfsavecontent variable="insert_error_message">
			<table cellspacing="0" cellpadding="0" width="500" border="0" align="center">
			<cfoutput>
			  <tr>
				<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">CRM <cf_get_lang no ='969.Admin Şube Güncelleme Sürecinde Hata Meydana Gelmiştir Müşteri Mushizgun(CRMTOBOYUT) tablolarına kayıt eklenmemiştir Hata Bilgileri Aşağıdaki Gibidir'>.</td>
			  </tr>
			  <tr>
				<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;"><cf_get_lang_main no='45.Müşteri'> Workcube ID : #attributes.company_id#</td>
			  </tr>
			  <tr>
				<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;"><cf_get_lang_main no ='388.İşlem Tip'> : #attributes.kayittipi# (CRM Admin)</td>
			  </tr>
			  <tr>
				<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;"><cf_get_lang_main no ='487.Kaydeden'> : #session.ep.name# #session.ep.surname#</td>
			  </tr>			  
			</cfoutput>
			</table>
			</cfsavecontent>
			<cffile action="write" file="#upload_folder#member#dir_seperator#mushiz_hata#attributes.company_id#.txt" output="#toString(insert_error_message)#" charset="UTF-8">
		</cfif>
	</cfif>
</cfif>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

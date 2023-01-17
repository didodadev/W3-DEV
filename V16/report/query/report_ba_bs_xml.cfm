<!--- 	
	BA-BS Raporu XML FBS 20090223
	5000 altindaki tutarlar digerMalHizBedelTop alanina tek satirda yazilir, digerleri kalem kalem dokulur.
	Degerler alinirken kurus bilgisi girilmez ve silinen kurus haneleri icin yuvarlama yapilmaz.
	Ulke kodlari olarak simdilik sadece 052 Turkiye kullaniliyor, diger ulkeler icin deger kaydedilmiyor.
	Dosya documents/report_ba_bs klasoru altinda tutuluyor.
	
	Durgan20150508 artık 052 kullanılmıyor, ülkeye göre ülke kodu getiriliyor. E-Defter kullanılıyor ise,
	muhasebecinin ad-soyad-tckno bilgilerini de getiriyor.
 --->
<cfset Limit_ = 5000>
<cfif len(attributes.process_type_ba)>
	<cfset reporttip_ = "ba">
	<cfset kodver_ = "FORMBA_6">
	<cfset bildirim_ = "alisBildirimi">
	<cfset toplambedel_ = "toplamAlimBedeli">
<cfelse>
	<cfset reporttip_ = "bs">
	<cfset kodver_ = "FORMBS_6">
	<cfset bildirim_ = "satisBildirimi">
	<cfset toplambedel_ = "toplamSatisBedeli">
</cfif>
<cfquery name="get_our_company_info" datasource="#dsn#">
	SELECT * FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfif session.ep.our_company_info.is_edefter eq 1>
    <cfquery name="get_accountant_info" datasource="#dsn#">
        SELECT TOP 1 CP.COMPANY_PARTNER_NAME, CP.COMPANY_PARTNER_SURNAME, CP.TC_IDENTITY FROM ACCOUNTANT A LEFT JOIN COMPANY_PARTNER CP ON A.ACC_PARTNER_ID = CP.PARTNER_ID WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfquery>
    <cfset acc_firstname = get_accountant_info.COMPANY_PARTNER_NAME>
    <cfset acc_lastname = get_accountant_info.COMPANY_PARTNER_SURNAME>
    <cfset acc_taxno = get_accountant_info.TC_IDENTITY>
<cfelse>
    <cfset acc_firstname = ''>
    <cfset acc_lastname = ''>
    <cfset acc_taxno = ''>
</cfif>
<cfsetting enablecfoutputonly="yes" requesttimeout="3600">
	<cfprocessingdirective suppresswhitespace="Yes">
		<cfscript>
			toplam_deger = 0;
			diger_toplam_deger = 0;
			
			my_doc = XmlNew();
			my_doc.xmlRoot = XmlElemNew(my_doc,"beyanname");
				my_doc.xmlRoot.XmlAttributes["kodVer"] = kodver_;
				//my_doc.xmlRoot.XmlAttributes["paraBirimi"] = "YTL";
				my_doc.xmlRoot.XmlAttributes["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance";
				my_doc.xmlRoot.XmlAttributes["xsi:noNamespaceSchemaLocation"] = kodver_&".xsd";

				my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"genel");
					my_doc.xmlRoot.XmlChildren[1].XmlChildren[1] = XmlElemNew(my_doc,"idari");
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[1] = XmlElemNew(my_doc,"vdKodu"); // bos (sistemden secilsin)
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2] = XmlElemNew(my_doc,"donem"); // rapor baslangic tarihi

						my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2].XmlChildren[1] = XmlElemNew(my_doc,"tip");
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2].XmlChildren[1].XmlText = "aylik"; // standart olarak aylik
		
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2].XmlChildren[2] = XmlElemNew(my_doc,"yil");
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2].XmlChildren[2].XmlText = year(attributes.startdate); // baslangic tarihi yil
		
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2].XmlChildren[3] = XmlElemNew(my_doc,"ay");
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2].XmlChildren[3].XmlText = month(attributes.startdate); // baslangic tarihi ay
			
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[2] = XmlElemNew(my_doc,"mukellef"); // our_company_info
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[2].XmlChildren[1] = XmlElemNew(my_doc,"vergiNo"); //vno
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[2].XmlChildren[1].XmlText = get_our_company_info.tax_no;
						
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[2].XmlChildren[2] = XmlElemNew(my_doc,"soyadi"); //fullname
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[2].XmlChildren[2].XmlText = left(get_our_company_info.company_name,30);
						
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[2].XmlChildren[3] = XmlElemNew(my_doc,"ticSicilNo"); //ticsicil
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[2].XmlChildren[3].XmlText = get_our_company_info.t_no;
						
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[2].XmlChildren[4] = XmlElemNew(my_doc,"alanKodu"); //telkodu
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[2].XmlChildren[4].XmlText = get_our_company_info.tel_code;
						
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[2].XmlChildren[5] = XmlElemNew(my_doc,"telNo"); //telefon
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[2].XmlChildren[5].XmlText = get_our_company_info.tel;
					
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[3] = XmlElemNew(my_doc,"hsv"); // hangi sifatla verildigi bilgileri
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[3].XmlAttributes["sifat"] = "kendisi"; // kendisi veya temsilci secilebilir

						my_doc.xmlRoot.XmlChildren[1].XmlChildren[3].XmlChildren[1] = XmlElemNew(my_doc,"vergiNo");
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[3].XmlChildren[1].XmlText = get_our_company_info.tax_no;
						
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[3].XmlChildren[2] = XmlElemNew(my_doc,"soyadi");
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[3].XmlChildren[2].XmlText = left(get_our_company_info.company_name,30);
						
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[3].XmlChildren[3] = XmlElemNew(my_doc,"ticSicilNo");
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[3].XmlChildren[3].XmlText = get_our_company_info.t_no;
						
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[3].XmlChildren[4] = XmlElemNew(my_doc,"alanKodu"); //telkodu
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[3].XmlChildren[4].XmlText = get_our_company_info.tel_code;
						
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[3].XmlChildren[5] = XmlElemNew(my_doc,"telNo"); //telefon
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[3].XmlChildren[5].XmlText = get_our_company_info.tel;
					
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[4] = XmlElemNew(my_doc,"duzenleyen"); // bos gonderilecek
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[4].XmlChildren[1] = XmlElemNew(my_doc,"vergiNo");
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[4].XmlChildren[2] = XmlElemNew(my_doc,"soyadi");
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[4].XmlChildren[3] = XmlElemNew(my_doc,"adi");
					
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[5] = XmlElemNew(my_doc,"gonderen"); // bos gonderilecek
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[5].XmlChildren[1] = XmlElemNew(my_doc,"vergiNo");
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[5].XmlChildren[2] = XmlElemNew(my_doc,"soyadi");
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[5].XmlChildren[3] = XmlElemNew(my_doc,"adi");
					
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[6] = XmlElemNew(my_doc,"ymm"); // bos gonderilecek
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[6].XmlChildren[1] = XmlElemNew(my_doc,"vergiNo");
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[6].XmlChildren[2] = XmlElemNew(my_doc,"soyadi");
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[6].XmlChildren[3] = XmlElemNew(my_doc,"adi");
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[6].XmlChildren[1].XmlText = acc_taxno;
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[6].XmlChildren[2].XmlText = acc_lastname;
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[6].XmlChildren[3].XmlText = acc_firstname;
				
					my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"ozel");
					my_doc.xmlRoot.XmlChildren[2].XmlChildren[1] = XmlElemNew(my_doc,bildirim_);
					counterFirst = 0;
					if(x_company_group) {

						if(xml_ba_bs.recordcount)
						{
							for (k = 1; k lte xml_ba_bs.recordcount; k = k + 1)
							{
								if (len(attributes.process_type_ba))
								{
									total_value = xml_ba_bs.ba_total[k];
									paper_count_value = xml_ba_bs.ba_paper_count[k];
								}
								else
								{
									total_value = xml_ba_bs.bs_total[k];
									paper_count_value = xml_ba_bs.bs_paper_count[k];
								}	
								if(total_value lt Limit_)
									diger_toplam_deger = diger_toplam_deger + fix(total_value);
								else
								{
									toplam_deger = toplam_deger + fix(total_value);
									
									my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k] = XmlElemNew(my_doc,reporttip_);
									
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[1] = XmlElemNew(my_doc,"siraNo");
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[1].XmlText = k;
										
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[2] = XmlElemNew(my_doc,"unvan");
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[2].XmlText = left(xml_ba_bs.fullname[k],60);
										
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[3] = XmlElemNew(my_doc,"ulke"); // ulke kodu
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[3].XmlText = "052";
										
										if(not len(xml_ba_bs.taxno[k]))
										{
											my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[4] = XmlElemNew(my_doc,"tckimlikno");
											my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[4].XmlText = xml_ba_bs.tc_identy_no[k];
										}
										else
										{
											my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[4] = XmlElemNew(my_doc,"vkno");
											my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[4].XmlText = xml_ba_bs.taxno[k];
										}
																
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[5] = XmlElemNew(my_doc,"belgeSayisi");
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[5].XmlText = paper_count_value;
										
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[6] = XmlElemNew(my_doc,"malHizmetBedeli");
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[6].XmlText = fix(total_value);
									counterFirst++;
								}
							}
							
						}
						
						if(get_ba_bs.recordcount)
						{
							counter = 0; 
							for (k = counterFirst; k lte xml_ba_bs.recordcount + get_ba_bs.recordcount ; k = k + 1)
							{
								queryObj = new query();
								queryObj.setDatasource("#dsn#");
								result = queryObj.execute(sql = "
									SELECT
										COMPANY.FULLNAME FULLNAME,
										COMPANY.MEMBER_CODE MEMBER_CODE,
										COMPANY.COMPANY_TELCODE FAX_CODE,
										COMPANY.COMPANY_FAX FAX,
										COMPANY.COMPANY_EMAIL EMAIL,
										COMPANY.COMPANY_ADDRESS ADDRESS,
										SC.CITY_NAME CITY,
										SCT.COUNTRY_NAME COUNTRY,
										COMPANY.IS_PERSON IS_PERSON,
										COMPANY.COMPANY_ID COMPANY_ID,
										NULL CONSUMER_ID
									FROM
										COMPANY
										LEFT JOIN SETUP_CITY SC ON SC.CITY_ID = COMPANY.CITY
										LEFT JOIN SETUP_COUNTRY SCT ON SCT.COUNTRY_ID = COMPANY.COUNTRY
									WHERE
										COMPANY.TAXNO = '#get_ba_bs.TAXNO[counter]#'

									UNION ALL
										SELECT 
											COMPANY.FULLNAME FULLNAME,
											COMPANY.MEMBER_CODE MEMBER_CODE,
											COMPANY.COMPANY_TELCODE FAX_CODE,
											COMPANY.COMPANY_FAX FAX,
											COMPANY.COMPANY_EMAIL EMAIL,
											COMPANY.COMPANY_ADDRESS ADDRESS,
											SC.CITY_NAME CITY,
											SCT.COUNTRY_NAME COUNTRY,
											COMPANY.IS_PERSON IS_PERSON,
											COMPANY.COMPANY_ID COMPANY_ID,
											NULL CONSUMER_ID
										FROM
											COMPANY_PARTNER CP
											RIGHT JOIN COMPANY ON CP.COMPANY_ID = COMPANY.COMPANY_ID
											LEFT JOIN SETUP_CITY SC ON SC.CITY_ID = COMPANY.CITY
											LEFT JOIN SETUP_COUNTRY SCT ON SCT.COUNTRY_ID = COMPANY.COUNTRY
										WHERE
											CP.TC_IDENTITY = '#get_ba_bs.TAXNO[counter]#'

									UNION ALL 
										SELECT
											C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME FULLNAME,
											C.MEMBER_CODE MEMBER_CODE,
											C.CONSUMER_FAXCODE FAX_CODE,
											C.CONSUMER_FAX FAX,
											C.CONSUMER_EMAIL EMAIL,
											C.TAX_ADRESS ADDRESS,
											SC.CITY_NAME CITY,
											SCT.COUNTRY_NAME COUNTRY,
											NULL IS_PERSON,
											NULL COMPANY_ID,
											C.CONSUMER_ID
										FROM
											CONSUMER C
											LEFT JOIN SETUP_CITY SC ON SC.CITY_ID = C.HOME_CITY_ID
											LEFT JOIN SETUP_COUNTRY SCT ON SCT.COUNTRY_ID = C.HOME_COUNTRY_ID
										WHERE
											C.TAX_NO = '#get_ba_bs.TAXNO[counter]#'
								");
								get_cmp_cns = result.getResult();
								if (len(attributes.process_type_ba))
								{
									total_value = get_ba_bs.ba_total[counter];
									paper_count_value = get_ba_bs.ba_paper_count[counter];
								}
								else
								{
									total_value = get_ba_bs.bs_total[counter];
									paper_count_value = get_ba_bs.bs_paper_count[counter];
								}
								
								if(total_value lt Limit_)
									{
										total_value = 0;
										diger_toplam_deger = diger_toplam_deger + fix(total_value);
									}
								else
								{
									toplam_deger = toplam_deger + fix(total_value);
									my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k] = XmlElemNew(my_doc,reporttip_);
									
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[1] = XmlElemNew(my_doc,"siraNo");
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[1].XmlText = k;
										
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[2] = XmlElemNew(my_doc,"unvan");
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[2].XmlText = left(get_cmp_cns.fullname,60);
										
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[3] = XmlElemNew(my_doc,"ulke"); // ulke kodu
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[3].XmlText = "052";
										
										if(not len(get_ba_bs.taxno[counter]))
										{
											my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[4] = XmlElemNew(my_doc,"tckimlikno");
											my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[4].XmlText = get_ba_bs.taxno[counter];
											/*my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[4].XmlText = get_ba_bs.tc_identy_no[counter];*/
										}
										else
										{
											my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[4] = XmlElemNew(my_doc,"vkno");
											my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[4].XmlText = get_ba_bs.taxno[counter];
										}
																
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[5] = XmlElemNew(my_doc,"belgeSayisi");
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[5].XmlText = paper_count_value;
										
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[6] = XmlElemNew(my_doc,"malHizmetBedeli");
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[6].XmlText = fix(total_value);
										
								}
								counter++;
							}
							
						} 
					}
					else{
						if(get_ba_bs.recordcount)
						{
							for (k = 1; k lte get_ba_bs.recordcount; k = k + 1)
							{
								if (len(attributes.process_type_ba))
								{
									total_value = get_ba_bs.ba_total[k];
									paper_count_value = get_ba_bs.ba_paper_count[k];
								}
								else
								{
									total_value = get_ba_bs.bs_total[k];
									paper_count_value = get_ba_bs.bs_paper_count[k];
								}	
								if(total_value lt Limit_)
									diger_toplam_deger = diger_toplam_deger + fix(total_value);
								else
								{
									toplam_deger = toplam_deger + fix(total_value);
									
									my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k] = XmlElemNew(my_doc,reporttip_);
									
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[1] = XmlElemNew(my_doc,"siraNo");
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[1].XmlText = k;
										
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[2] = XmlElemNew(my_doc,"unvan");
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[2].XmlText = left(get_ba_bs.fullname[k],60);
										
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[3] = XmlElemNew(my_doc,"ulke"); // ulke kodu
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[3].XmlText = "052";
										
										if(not len(get_ba_bs.taxno[k]))
										{
											my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[4] = XmlElemNew(my_doc,"tckimlikno");
											my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[4].XmlText = get_ba_bs.tc_identy_no[k];
										}
										else
										{
											my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[4] = XmlElemNew(my_doc,"vkno");
											my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[4].XmlText = get_ba_bs.taxno[k];
										}
																
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[5] = XmlElemNew(my_doc,"belgeSayisi");
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[5].XmlText = paper_count_value;
										
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[6] = XmlElemNew(my_doc,"malHizmetBedeli");
										my_doc.xmlRoot.XmlChildren[2].XmlChildren[1].XmlChildren[k].XmlChildren[6].XmlText = fix(total_value);
								}
							}
							
						}
					}
					
					my_doc.xmlRoot.XmlChildren[2].XmlChildren[2] = XmlElemNew(my_doc,toplambedel_);
					my_doc.xmlRoot.XmlChildren[2].XmlChildren[2].XmlText = toplam_deger;
					
					/*my_doc.xmlRoot.XmlChildren[2].XmlChildren[3] = XmlElemNew(my_doc,"digerMalHizBedelTop");
					my_doc.xmlRoot.XmlChildren[2].XmlChildren[3].XmlText = diger_toplam_deger;
					
					my_doc.xmlRoot.XmlChildren[2].XmlChildren[4] = XmlElemNew(my_doc,"genelToplam");
					my_doc.xmlRoot.XmlChildren[2].XmlChildren[4].XmlText = toplam_deger+diger_toplam_deger;*/
		</cfscript>
        <cfset dosya = "#filterSpecialChars(session.ep.company_nick)#_#year(attributes.startdate)#-#month(attributes.startdate)#_#reporttip_#_Formu_#dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')#"> 
		<cffile action="write" file="#upload_folder#report_ba_bs/#dosya#.xml" output="#toString(my_doc)#" charset="utf-8">
        <cfzip action="zip" file = "#upload_folder#report_ba_bs/#dosya#.zip" source = "#upload_folder#report_ba_bs/#dosya#.xml">
	</cfprocessingdirective>
<cfsetting enablecfoutputonly="no">
<script type="text/javascript">
	<cfoutput>
		get_wrk_message_div("#getLang('main',1931)#","Zip","documents/report_ba_bs/#dosya#.zip")  
	</cfoutput>
</script>


<!---
	FBS 20080410 Kurumsal ve Bireysel Uyelerin history kayitlarini goruntulemek icin olusturuldu
	member_type -- consumer veya company - required
	member_id   -- company_id veya consumer_id - required
	Ornek Link : <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=member.popup_member_history&member_type=company&member_id=#attributes.cpid#</cfoutput>','medium','popup_member_history');"><img src="/images/history.gif" alt="<cf_get_lang_main no='61.Tarihçe'>" border="0"></a>
--->
<cfif attributes.member_type is "company">
	<cfquery name="GET_MEMBER_HISTORY" datasource="#DSN#"><!---#76393 Listeye Alınıp Ardından SQL sorgusu çalıştırılan yapıdan, Tek sorguda ihtiyaç olan alanlar çekildi. Sorgu İçerisindeki Paremetre <cfqueryparam> içerisine Alındı(By:MCP) --->
		SELECT
			1 TYPE,
			(SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = COMPANY_STATE) SUREC,
			'' RECORD_CONS,
			COMPANY_HISTORY.FULLNAME,
			COMPANY_HISTORY.RECORD_DATE,
			COMPANY_HISTORY.RECORD_EMP,
			COMPANY_HISTORY.COMPANY_STATUS,
			COMPANY_HISTORY.IS_BUYER ,
			COMPANY_HISTORY.IS_SELLER ,
			COMPANY_HISTORY.ISPOTANTIAL,
			COMPANY_HISTORY.IS_RELATED_COMPANY ,
			COMPANY_HISTORY.NICKNAME,
			COMPANY_HISTORY.MEMBER_CODE,
			COMPANY_HISTORY.MANAGER_PARTNER_ID,
			COMPANY_HISTORY.COMPANY_EMAIL ,
			COMPANY_HISTORY.TAXOFFICE ,
			COMPANY_HISTORY.TAXNO ,
			COMPANY_HISTORY.COMPANY_TELCODE ,
			COMPANY_HISTORY.COMPANY_TEL1,
			COMPANY_HISTORY.COMPANY_FAX,
			COMPANY_HISTORY.COMPANY_TEL2,
			COMPANY_HISTORY.COMPANY_TEL3 ,
			COMPANY_HISTORY.COMPANY_ADDRESS,
			COMPANY_HISTORY.SEMT ,
			COMPANY_HISTORY.COMPANY_POSTCODE,
            ISNULL(COMPANY_HISTORY.UPDATE_DATE,COMPANY_HISTORY.RECORD_DATE) AS UPDATE_DATE,
            COMPANY_HISTORY.UPDATE_EMP,
            EMP.EMPLOYEE_NAME,
            EMP.EMPLOYEE_SURNAME,
            SZ.SZ_NAME,
            SP.PERIOD,
            EMP_POS.EMPLOYEE_NAME AGENT_EMPLOYEE_NAME,
			EMP_POS.EMPLOYEE_SURNAME AGENT_EMPLOYEE_SURNAME,
            S_COU.COUNTRY_NAME,
            CITY.CITY_NAME,
            COUNTY.COUNTY_NAME,
            UPD_EMP.EMPLOYEE_NAME AS 'UPD_EMPLOYEE_NAME',
            UPD_EMP.EMPLOYEE_SURNAME AS 'UPD_EMPLOYEE_SURNAME',
            COM_CAT.COMPANYCAT CAT_NAME,
			COM_PART.COMPANY_PARTNER_NAME + ' ' + COM_PART.COMPANY_PARTNER_SURNAME TP_NAME,
            EMP_POS2.EMPLOYEE_NAME + ' ' + EMP_POS2.EMPLOYEE_SURNAME TEMSILCI
		FROM 
			COMPANY_HISTORY
            	LEFT JOIN  EMPLOYEES EMP ON EMP.EMPLOYEE_ID = COMPANY_HISTORY.RECORD_EMP
                LEFT JOIN  SALES_ZONES SZ ON SZ.SZ_ID = COMPANY_HISTORY.SALES_COUNTY AND SZ.IS_ACTIVE = 1
                LEFT JOIN  SETUP_PERIOD SP ON SP.PERIOD_ID =COMPANY_HISTORY.PERIOD_ID
            	LEFT JOIN  SETUP_COUNTRY S_COU ON  S_COU.COUNTRY_ID = COMPANY_HISTORY.COUNTRY
            	LEFT JOIN  SETUP_CITY CITY ON CITY.CITY_ID = COMPANY_HISTORY.CITY
            	LEFT JOIN  SETUP_COUNTY COUNTY ON COUNTY.COUNTY_ID = COMPANY_HISTORY.COUNTY
                LEFT JOIN  EMPLOYEES UPD_EMP ON UPD_EMP.EMPLOYEE_ID = COMPANY_HISTORY.UPDATE_EMP
                LEFT JOIN  EMPLOYEE_POSITIONS EMP_POS ON EMP_POS.POSITION_CODE = COMPANY_HISTORY.AGENT_POS_CODE
                LEFT JOIN  COMPANY_CAT COM_CAT ON  COM_CAT.COMPANYCAT_ID = COMPANY_HISTORY.COMPANYCAT_ID
                LEFT JOIN  COMPANY_PARTNER COM_PART ON COM_PART.PARTNER_ID =COMPANY_HISTORY.MANAGER_PARTNER_ID
				LEFT JOIN  EMPLOYEE_POSITIONS EMP_POS2 ON EMP_POS2.POSITION_CODE = COMPANY_HISTORY.POS_CODE
                
		WHERE
			COMPANY_HISTORY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#"> 	
		ORDER BY
			COMPANY_HISTORY.UPDATE_DATE DESC
	</cfquery>
<cfelseif attributes.member_type is "consumer">
	<cfquery name="GET_MEMBER_HISTORY" datasource="#DSN#"><!---#76393 Listeye Alınıp Ardından SQL sorgusu çalıştırılan yapıdan, Tek sorguda ihtiyaç olan alanlar çekildi. Sorgu İçerisindeki Paremetre <cfqueryparam> içerisine Alındı(By:MCP) --->
		SELECT
			2 TYPE,
			<cfif (database_type is 'MSSQL')>
				CONSUMER_HISTORY.CONSUMER_NAME + ' ' + CONSUMER_HISTORY.CONSUMER_SURNAME AS MEMBER_NAME,
			<cfelseif (database_type is 'DB2')>
				CONSUMER_HISTORY.CONSUMER_NAME || ' ' || CONSUMER_HISTORY.CONSUMER_SURNAME AS MEMBER_NAME,	
			</cfif>
			(SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = CONSUMER_HISTORY.CONSUMER_STAGE) SUREC,  
			EMP.EMPLOYEE_NAME,
            EMP.EMPLOYEE_SURNAME,
			CONSUMER_HISTORY.CONSUMER_STATUS,
			CONSUMER_HISTORY.RECORD_DATE,
			CONSUMER_HISTORY.RECORD_EMP,
			CONSUMER_HISTORY.ISPOTANTIAL,
			CONSUMER_HISTORY.IS_RELATED_CONSUMER ,
			CONSUMER_HISTORY.TC_IDENTY_NO ,
			CONSUMER_HISTORY.MEMBER_CODE ,
			CONSUMER_HISTORY.CONSUMER_EMAIL,
			CONSUMER_HISTORY.CONSUMER_REFERENCE_CODE ,
			CONSUMER_HISTORY.TAX_OFFICE,
			CONSUMER_HISTORY.TAX_NO,
			CONSUMER_HISTORY.MOBIL_CODE,
			CONSUMER_HISTORY.MOBILTEL,
			CONSUMER_HISTORY.MOBIL_CODE_2,
			CONSUMER_HISTORY.MOBILTEL_2, 
			CONSUMER_HISTORY.CONSUMER_HOMETELCODE ,
			CONSUMER_HISTORY.CONSUMER_HOMETEL ,
			CONSUMER_HISTORY.CONSUMER_WORKTELCODE ,
			CONSUMER_HISTORY.CONSUMER_WORKTEL ,
			CONSUMER_HISTORY.CONSUMER_FAXCODE ,
			CONSUMER_HISTORY.CONSUMER_FAX,
			CONSUMER_HISTORY.HOMEADDRESS,
			CONSUMER_HISTORY.HOMESEMT,
			CONSUMER_HISTORY.HOMEPOSTCODE ,
			CONSUMER_HISTORY.WORKADDRESS,
			CONSUMER_HISTORY.WORKSEMT ,
			CONSUMER_HISTORY.WORKPOSTCODE ,
			CONSUMER_HISTORY.TAX_ADRESS ,
			CONSUMER_HISTORY.TAX_SEMT ,
			CONSUMER_HISTORY.TAX_POSTCODE,
			CONSUMER_HISTORY.RECORD_CONS,
            SZ.SZ_NAME,
            SP.PERIOD,
            EMP_POS.EMPLOYEE_NAME AGENT_EMPLOYEE_NAME,
			EMP_POS.EMPLOYEE_SURNAME AGENT_EMPLOYEE_SURNAME,
            CTRY_HOME.COUNTRY_NAME AS HOME_COUNTRY,
			CTRY_WORK.COUNTRY_NAME AS WORK_COUNTRY,
			CTRY_TAX.COUNTRY_NAME  AS TAX_COUNTRY,
			CTY_HOME.CITY_NAME AS HOME_CITY,
			CTY_WORK.CITY_NAME AS WORK_CITY,
			CTY_TAX.CITY_NAME  AS TAX_CITY,
			CNTY_HOME.COUNTY_NAME AS HOME_COUNTY,
			CNTY_WORK.COUNTY_NAME AS WORK_COUNTY,
			CNTY_TAX.COUNTY_NAME AS TAX_COUNTY,
            UPD_EMP.EMPLOYEE_NAME AS 'UPD_EMPLOYEE_NAME',
            UPD_EMP.EMPLOYEE_SURNAME AS 'UPD_EMPLOYEE_SURNAME',
            CON.CONSUMER_NAME AS REF_CONSUMER_NAME,
            CON.CONSUMER_SURNAME AS REF_CONSUMER_SURNAME,
            SDIS_HOME.DISTRICT_NAME AS 'HOME_DISTRICT_NAME',
	 		SDIS_WORK.DISTRICT_NAME AS 'WORK_DISTRICT_NAME',
	 		SDIS_TAX.DISTRICT_NAME  AS 'TAX_DISTRICT_NAME',
            CON_CAT.CONSCAT,
            SVT.VOCATION_TYPE
		FROM
			CONSUMER_HISTORY
            	LEFT  JOIN EMPLOYEES EMP ON EMP.EMPLOYEE_ID = CONSUMER_HISTORY.RECORD_EMP
                LEFT JOIN  SALES_ZONES SZ ON SZ.SZ_ID = CONSUMER_HISTORY.SALES_COUNTY AND SZ.IS_ACTIVE = 1
                LEFT JOIN  SETUP_PERIOD SP ON SP.PERIOD_ID =CONSUMER_HISTORY.PERIOD_ID
               	LEFT JOIN SETUP_COUNTRY CTRY_HOME ON CTRY_HOME.COUNTRY_ID = CONSUMER_HISTORY.HOME_COUNTRY_ID 
				LEFT JOIN SETUP_COUNTRY CTRY_WORK ON CTRY_WORK.COUNTRY_ID = CONSUMER_HISTORY.WORK_COUNTRY_ID
				LEFT JOIN SETUP_COUNTRY CTRY_TAX  ON CTRY_TAX.COUNTRY_ID = CONSUMER_HISTORY.TAX_COUNTRY_ID
				LEFT JOIN SETUP_CITY CTY_HOME     ON CTY_HOME.CITY_ID = CONSUMER_HISTORY.HOME_CITY_ID 
				LEFT JOIN SETUP_CITY CTY_WORK     ON CTY_WORK.CITY_ID = CONSUMER_HISTORY.WORK_CITY_ID
				LEFT JOIN SETUP_CITY CTY_TAX      ON CTY_TAX.CITY_ID =  CONSUMER_HISTORY.TAX_CITY_ID
				LEFT JOIN SETUP_COUNTY CNTY_HOME  ON CNTY_HOME.COUNTY_ID = CONSUMER_HISTORY.HOME_COUNTY_ID 
				LEFT JOIN SETUP_COUNTY CNTY_WORK  ON CNTY_WORK.COUNTY_ID = CONSUMER_HISTORY.WORK_COUNTY_ID
				LEFT JOIN SETUP_COUNTY CNTY_TAX   ON CNTY_TAX.COUNTY_ID =  CONSUMER_HISTORY.TAX_COUNTY_ID
                LEFT JOIN EMPLOYEES UPD_EMP ON UPD_EMP.EMPLOYEE_ID = CONSUMER_HISTORY.MEMBER_UPDATE_EMP
                LEFT JOIN CONSUMER CON ON CON.CONSUMER_ID = CONSUMER_HISTORY.REF_POS_CODE
                LEFT JOIN EMPLOYEE_POSITIONS EMP_POS ON EMP_POS.POSITION_CODE = CONSUMER_HISTORY.AGENT_POS_CODE
                LEFT JOIN SETUP_DISTRICT SDIS_HOME ON SDIS_HOME.DISTRICT_ID = CONSUMER_HISTORY.HOME_DISTRICT_ID
				LEFT JOIN SETUP_DISTRICT SDIS_WORK ON SDIS_WORK.DISTRICT_ID = CONSUMER_HISTORY.WORK_DISTRICT_ID
				LEFT JOIN SETUP_DISTRICT SDIS_TAX ON SDIS_TAX.DISTRICT_ID = CONSUMER_HISTORY.TAX_DISTRICT_ID
                LEFT JOIN CONSUMER_CAT CON_CAT ON  CON_CAT.CONSCAT_ID = CONSUMER_HISTORY.CONSUMER_CAT_ID
                LEFT JOIN SETUP_VOCATION_TYPE SVT ON SVT.VOCATION_TYPE_ID = CONSUMER_HISTORY.VOCATION_TYPE_ID 
		WHERE
			CONSUMER_HISTORY.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
		ORDER BY
			CONSUMER_HISTORY.RECORD_DATE DESC
	</cfquery>
	
</cfif>

<cf_box title="#getLang('','Tarihçe',57473)#" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfif attributes.member_type is "company" and get_member_history.recordcount>
		<cfset temp_ = 0>
        <cfoutput query="get_member_history">
			<cfset temp_ = temp_ +1>
            <cfsavecontent variable="txt">
                #DateFormat(update_date,dateformat_style)# (#TimeFormat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#) - 
                <cfif len(update_emp)>
                    #upd_employee_name# #upd_employee_surname#
                <cfelseif len(record_cons)>
                    #consumer_name# #consumer_surname#
                </cfif>
            </cfsavecontent>
            <cf_seperator id="history_#temp_#" header="#txt#" is_closed="1">
            <table id="history_#temp_#" style="display:none;">
                <tr align="left">
                    <td colspan="4" height="25" align="left"><strong>#fullname##temp_#</strong></td>
                </tr>
                <tr>
                    <td class="txtbold" width="80"><cf_get_lang dictionary_id='57493.Aktif'></td>
                    <td width="220"><cfif company_status eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
                    <td width="80" class="txtbold"><cf_get_lang dictionary_id ='58472.Dönem'></td>
                    <td width="180">#period#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='58733.Alıcı'></td>
                    <td><cfif is_buyer eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
                    <td class="txtbold"><cf_get_lang dictionary_id='58873.Satıcı'></td>
                    <td><cfif is_seller eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57577.Potansiyel'></td>
                    <td><cfif ispotantial eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
                    <td class="txtbold"><cf_get_lang dictionary_id='30559.Bağlı üye'></td>
                    <td><cfif is_related_company eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57751.Kısa Ad'></td>
                    <td>#nickname#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57558.Üye No'></td>
                    <td>#member_code#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='30367.Yonetici '></td>
                    <td><cfif len(manager_partner_id)>#tp_name#</cfif></td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57908.Temsilci'></td>
                    <td>#TEMSILCI#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57428.E-Mail'></td>
                    <td>#company_email#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57756.Süreç'></td>
                    <td>#surec#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57486.Kategori'></td>
                    <td>#cat_name#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></td>
                    <td>#SZ_NAME#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></td>
                    <td>#taxoffice#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57752.Vergi No'></td>
                    <td>#taxno#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57499.Telefon'></td>
                    <td>#company_telcode# #company_tel1#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57488.Fax'></td>
                    <td>#company_telcode# #company_fax#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57499.Telefon'>2</td>
                    <td>#company_telcode# #company_tel2#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57499.Telefon'>3</td>
                    <td>#company_telcode# #company_tel3#</td>
                </tr>
                <tr>
                    <td class="txtbold" valign="top"><cf_get_lang dictionary_id='58723.Adres'></td>
                    <td colspan="3" align="left" width="480">
                        #company_address# #semt#
                        #county_name#
                        #company_postcode#
                        #city_name#
                        #country_name#
                    </td>
                </tr>
         	</table>
		</cfoutput>
    <cfelseif attributes.member_type is "consumer" and get_member_history.recordcount>
		<cfset temp_ = 0>
        <cfoutput query="get_member_history">
            <cfsavecontent variable="txt">
                   #DateFormat(record_date,dateformat_style)# (#TimeFormat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#) - 
                    <cfif len(record_emp)>
                    #employee_name# #employee_surname#
                        <cfelseif len(record_cons)>
                    #consumer_name# #consumer_surname#
                </cfif>
            </cfsavecontent>
            <cfset temp_ = temp_ +1>
            <cf_seperator id="history_#temp_#" header="#txt#" is_closed="1">
            <table id="history_#temp_#" style="display:none;">
                <tr align="left">
                    <td colspan="4" height="25" align="left"><strong>#member_name# </strong></td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57493.Aktif'></td>
                    <td><cfif consumer_status eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
                    <td class="txtbold"><cf_get_lang dictionary_id ='58472.Dönem'></td>
                    <td>#period#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57577.Potansiyel'></td>
                    <td><cfif ispotantial eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
                    <td class="txtbold"><cf_get_lang dictionary_id='30559.Bağlı'></td>
                    <td><cfif is_related_consumer eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
                </tr>
                <tr>
                    <td class="txtbold" width="80"><cf_get_lang dictionary_id='58025.TC Kimlik No'></td>
                    <td width="210">#tc_identy_no#</td>
                    <td width="90" class="txtbold"><cf_get_lang dictionary_id='57558.Üye No'></td>
                    <td width="180">#member_code#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='30500.Meslek Tipi'></td>
                    <td>#vocation_type#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57908.Temsilci'></td>
                    <td>#agent_employee_name# #agent_employee_surname#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57428.E-Mail'></td>
                    <td>#consumer_email#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57756.Süreç'></td>
                    <td>#surec#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57486.Kategori'></td>
                    <td>#conscat#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></td>
                    <td>#SZ_NAME#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='58636.Referans Üye'></td>
                    <td>#ref_consumer_name# #ref_consumer_surname#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='30593.Referans Kod'></td>
                    <td><cfif len(consumer_reference_code)>#consumer_reference_code#</cfif></td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></td>
                    <td>#tax_office#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57752.Vergi No'></td>
                    <td>#tax_no#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id ='58473.Mobil'><cf_get_lang dictionary_id='57499.Tel'></td>
                    <td>#mobil_code# #mobiltel#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id ='58473.Mobil'><cf_get_lang dictionary_id='57499.Tel'> 2</td>
                    <td>#mobil_code_2# #mobiltel_2#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='30506.Ev'><cf_get_lang dictionary_id='57499.Tel'></td>
                    <td>#consumer_hometelcode# #consumer_hometel#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='58445.İş'><cf_get_lang dictionary_id='57499.Tel'></td>
                    <td>#consumer_worktelcode# #consumer_worktel#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57488.Fax'></td>
                    <td>#consumer_faxcode# #consumer_fax#</td>
                </tr>
                <tr>
                    <td class="txtbold" valign="top"><cf_get_lang dictionary_id='58723.Adres'></td>
                    <td colspan="3" align="left" width="480">
                        <cf_get_lang dictionary_id='30506.Ev'>: 
                        #home_district_name# 
                        #homeaddress# #homesemt# #homepostcode#
                        #home_county#
                        #home_city#
                        #home_country#
                        <br/>
                        <cf_get_lang dictionary_id='58445.İş'>: 
                        #work_district_name# 
                        #workaddress# #worksemt# #workpostcode#
                        #work_county#
                        #work_city#
                        #work_country#
                        <br/>
                        <cf_get_lang dictionary_id='57441.Fatura'>: 
                        #tax_district_name# 
                        #tax_adress# #tax_semt# #tax_postcode#
                        #tax_county#
                        #tax_city#
                        #tax_country#
                    </td>
                </tr>
            </table>
		</cfoutput>
    </cfif>
</cf_box>


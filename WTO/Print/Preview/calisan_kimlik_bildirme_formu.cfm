<cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
    <cfset COMPANY_IDS = session.ep.company_id>
<cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>  
    <cfset COMPANY_IDS = session.pp.company_id>
<cfelseif isDefined("session.ww.our_company_id") and len(session.ww.company_id)>
    <cfset COMPANY_IDS = session.ww.company_id>
<cfelseif isDefined("session.cp.our_company_id") and len(session.cp.company_id)>
    <cfset COMPANY_IDS = session.cp.company_id>
</cfif> 
<cfquery name="get_sector_name" datasource="#dsn#">
    SELECT 
        SECTOR_CAT
    FROM
       SETUP_SECTOR_CATS LEFT JOIN 
       COMPANY_SECTOR_RELATION ON SETUP_SECTOR_CATS.SECTOR_CAT_ID=COMPANY_SECTOR_RELATION.SECTOR_ID
    WHERE 
        COMPANY_ID = #COMPANY_IDS#
</cfquery>
<cfquery name="GET_EMPLOYEE" datasource="#DSN#">
	SELECT 
        EMPLOYEE_ID,
        EMPLOYEE_NO,
        EMPLOYEE_NAME,
        EMPLOYEE_SURNAME,
        GROUP_STARTDATE
    FROM 
        EMPLOYEES
	WHERE
        EMPLOYEE_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
</cfquery>

<cfquery name="GET_EMPLOYEE_DETAIL" datasource="#DSN#">
	SELECT
        EMPLOYEE_ID,
        EMPLOYEE_DETAIL_ID,
        IDENTYCARD_NO,
        HOMETEL_CODE,
        HOMETEL	,
        HOMEADDRESS,
        CITY_NAME=(SELECT SETUP_CITY.CITY_NAME FROM SETUP_CITY WHERE SETUP_CITY.CITY_ID = EMPLOYEES_DETAIL.HOMECITY),
        HOMECOUNTRY
    FROM 
        EMPLOYEES_DETAIL
	WHERE
        EMPLOYEE_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
</cfquery>

<cfquery name="GET_PREPARED_IDENTITY" datasource="#DSN#">
	SELECT
        EI.EMPLOYEE_ID,
        EI.TC_IDENTY_NO,
        EI.FATHER,
        EI.BIRTH_DATE,
        EI.BIRTH_PLACE,
        NATIONALITY_COUNTRY=(SELECT SETUP_COUNTRY.COUNTRY_NAME FROM SETUP_COUNTRY WHERE SETUP_COUNTRY.COUNTRY_ID= EI.NATIONALITY),
        PREPARED_BIRTH_CITY=(SELECT SETUP_CITY.CITY_NAME FROM SETUP_CITY WHERE SETUP_CITY.CITY_ID = EI.BIRTH_CITY),
        EI.GIVEN_PLACE,
        EI.GIVEN_DATE,
        CITY,
        COUNTY,
        EI.WARD,
        EI.VILLAGE,
        E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME,
        ED.HOMETEL_CODE,
        ED.HOMETEL	,
        ED.HOMEADDRESS,
        CITY_NAME=(SELECT SETUP_CITY.CITY_NAME FROM SETUP_CITY WHERE SETUP_CITY.CITY_ID = ED.HOMECITY)
    FROM
        EMPLOYEES_IDENTY as EI,
        EMPLOYEES AS E,
        EMPLOYEES_DETAIL AS ED

	WHERE
        E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
        AND EI.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
        AND ED.EMPLOYEE_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<cfquery name="GET_EMPLOYEE_EXP" datasource="#dsn#">
    SELECT
        EXP_POS =(SELECT PARTNER_POSITION FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID = EMPLOYEES_APP_WORK_INFO.EXP_TASK_ID),
        EXP,
        EXP_FINISH,
        EXP_ADDR,
        EXP_POSITION
    FROM
        EMPLOYEES_APP_WORK_INFO
    WHERE
         EXP_FINISH= ( SELECT MAX(EXP_FINISH) FROM EMPLOYEES_APP_WORK_INFO WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">  )
</cfquery>
<cfquery name="GET_EMPLOYEE_IDENTITY" datasource="#DSN#">
	SELECT
        EMPLOYEE_ID,
        TC_IDENTY_NO,
        FATHER,
        BIRTH_DATE,
        BIRTH_PLACE,
        NATIONALITY_COUNTRY=(SELECT SETUP_COUNTRY.COUNTRY_NAME FROM SETUP_COUNTRY WHERE SETUP_COUNTRY.COUNTRY_ID= EMPLOYEES_IDENTY.NATIONALITY),
        BIRTH_CITY= (SELECT SETUP_CITY.CITY_NAME FROM SETUP_CITY WHERE SETUP_CITY.CITY_ID = EMPLOYEES_IDENTY.BIRTH_CITY),
        GIVEN_PLACE,
        GIVEN_DATE,
        CITY,
        COUNTY,
        WARD,
        VILLAGE
    FROM
        EMPLOYEES_IDENTY
	WHERE
        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
</cfquery>

<cfquery name="CHECK" datasource="#DSN#">
	SELECT 
        ASSET_FILE_NAME2,
		ASSET_FILE_NAME2_SERVER_ID,
        COMP_ID,
	    COMPANY_NAME,
        COUNTY_NAME=(SELECT SETUP_COUNTY.COUNTY_NAME FROM SETUP_COUNTY WHERE  SETUP_COUNTY.COUNTY_ID=OUR_COMPANY.COUNTY_ID),
        CITY_NAME=(SELECT SETUP_CITY.CITY_NAME FROM SETUP_CITY WHERE SETUP_CITY.CITY_ID = OUR_COMPANY.CITY_ID),
        STREET_NAME,
        CITY_SUBDIVISION_NAME,
        ADDRESS,
        TEL_CODE,
        TEL,
        TAX_OFFICE,
        TAX_NO
	FROM 
		OUR_COMPANY
    WHERE COMP_ID = #COMPANY_IDS#
</cfquery>
<cfquery name="branch" datasource="#dsn#">
    SELECT
        BRANCH.SSK_M + '' + BRANCH.SSK_JOB + '' + BRANCH.SSK_BRANCH + '' + BRANCH.SSK_BRANCH_OLD + '' + BRANCH.SSK_NO + '' + BRANCH.SSK_CITY + '' + BRANCH.SSK_COUNTRY AS ISYERI_NO
    FROM
        BRANCH
    WHERE
        COMPANY_ID= #COMPANY_IDS#
</cfquery>
<cfquery name="GET_POSITIONS" datasource="#dsn#">
    SELECT
        POSITION_NAME	
    FROM
        EMPLOYEE_POSITIONS
    WHERE
        EMPLOYEE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
</cfquery>
<cfquery name="get_work_info" datasource="#dsn#">
	SELECT EXP_START FROM EMPLOYEES_APP_WORK_INFO WHERE EMPLOYEE_ID = #attributes.iid# ORDER BY EXP_START
</cfquery>
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">

<cfoutput>
	<table style="width:210mm">
		<tr>
			<td>
				<table width="100%">
					<tr>
						<td class="print-head">
							<table style="width:100%;">
								<tr>
									<td class="print_title"><b><cf_get_lang dictionary_id='59487.Çalışanlara Ait Kimlik Bildirme Belgesi'> (FORM-2)</b></td>
										<td style="text-align:right;">
											<cfif len(check.asset_file_name2)>
											<cfset attributes.type = 1>
												<cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
											</cfif>
										</td>
									</td>
								</tr> 
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
            <td><b>A) <cf_get_lang dictionary_id='62786.Tesis Bilgileri'></b></td>
        </tr>
        <tr>
            <td>
				<table class="print_border" style="width:210mm">
                    <tr>
                        <th><cf_get_lang dictionary_id='58651.Türü'></th>
                        <th><cf_get_lang dictionary_id='57897.Adı'></th>
                        <th><cf_get_lang dictionary_id='41196.İl-İlçe'></th>
                        <th><cf_get_lang dictionary_id='58723.Adres'></th>
                        <th><cf_get_lang dictionary_id='48176.Telefon No'></th>
                    </tr>
                    <tr>
                        <td>#get_sector_name.SECTOR_CAT#</td>
                        <td>#check.company_name#</td>
                        <td>#check.city_name#/ #check.COUNTY_NAME#</td>
                        <td>#check.ADDRESS#</td>
                        <td>(#check.tel_code#) #check.tel#</td>
                    </tr>
				</table>
			</td>
		</tr>
        <tr>
            <td>
				<table style="width:120mm" >
                    <tr>
                        <td style="width:140px"><b><cf_get_lang dictionary_id='46564.Sgk İşyeri Sicil Numarası'></b></td>
                        <td style="width:170px">#branch.ISYERI_NO#</td>
                    </tr>
                    <tr>
                        <td  style="width:140px"><b><cf_get_lang dictionary_id='53806.İşyeri'> <cf_get_lang dictionary_id='57752.Vergi No'></b></td>
                        <td style="width:170px">#check.tax_office#- #check.tax_no#</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td><b>B) <cf_get_lang dictionary_id='36209.Çalışanın'></b></td>
        </tr>
        <tr>
            <td>
				<table class="print_border" style="width:210mm">
                    <tr>
                        <td><b><cf_get_lang dictionary_id='58025.TC Kimlik No'></b></td>
                        <td width="170">#GET_EMPLOYEE_IDENTITY.TC_IDENTY_NO#</td>
                        <td rowspan="2" colspan="3"><b><cf_get_lang dictionary_id='31247.Nüfusa Kayıtlı Olduğu'></b></td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='32370.Adı Soyadı'></b></td>
                        <td>#GET_EMPLOYEE.EMPLOYEE_NAME# #GET_EMPLOYEE.EMPLOYEE_SURNAME#</td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='58033.Baba Adı'></b></td>
                        <td>#GET_EMPLOYEE_IDENTITY.FATHER#</td>
                        <td><b><cf_get_lang dictionary_id='41196.İl-İlçe'></b></td>
                        <td colspan="2"> #GET_EMPLOYEE_IDENTITY.CITY# -#GET_EMPLOYEE_IDENTITY.COUNTY#</td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='57790.Doğum Yeri'>/ <cf_get_lang dictionary_id='58593.Tarihi'></b></td>
                        <td>#GET_EMPLOYEE_IDENTITY.BIRTH_PLACE#- #dateFormat(GET_EMPLOYEE_IDENTITY.BIRTH_DATE,dateformat_style)#</td>
                        <td><b><cf_get_lang dictionary_id='53928.Mahalle / Köy'></b></td>
                        <td colspan="2">#GET_EMPLOYEE_IDENTITY.VILLAGE# #GET_EMPLOYEE_IDENTITY.WARD#</td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='30502.Uyruğu'></b></td>
                        <td>#GET_EMPLOYEE_IDENTITY.NATIONALITY_COUNTRY#</td>
                        <td><b><cf_get_lang dictionary_id='55659.Veriliş Tarihi'></b></td>
                        <td colspan="2">#dateFormat(GET_EMPLOYEE_IDENTITY.GIVEN_DATE,dateformat_style)#</td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='53164.Pozisyonu'></b></td>
                        <td>#GET_POSITIONS.POSITION_NAME#</td>
                        <td><b><cf_get_lang dictionary_id='31622.İşe Başlama Tarihi'></b></td>
                        <td colspan="2">#dateFormat(GET_EMPLOYEE.GROUP_STARTDATE,dateformat_style)#</td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='30606.Ev Adresi'><cf_get_lang dictionary_id='57989.ve'><cf_get_lang dictionary_id='58814.Ev Telefonu'> </b></td>
                        <td  width="170">#GET_EMPLOYEE_DETAIL.HOMEADDRESS# <cfif len(GET_EMPLOYEE_DETAIL.CITY_NAME)>- #GET_EMPLOYEE_DETAIL.CITY_NAME#</cfif>- (#GET_EMPLOYEE_DETAIL.HOMETEL_CODE#) #GET_EMPLOYEE_DETAIL.HOMETEL#</td>
                        <td><b><cf_get_lang dictionary_id='62789.İşyerinde barınıyor mu?'></b></td>
                        <td colspan="2"><div class="form-group"><input type="text"></div></td>
                    </tr>
                    <tr>
                        <td rowspan="2"><b><cf_get_lang dictionary_id='59492.Önceki İşinin'></b></td>
                        <td><b><cf_get_lang dictionary_id='58445.İş'></b></td>
                        <td><b><cf_get_lang dictionary_id='57750.İşyeri Adı'></b></td>
                        <td><b><cf_get_lang dictionary_id='49318.Adresi'></b></td>
                        <td><b><cf_get_lang dictionary_id='62790.Ayrılış Tarihi'></b></td>
                    </tr>
                    <tr>
                        <td><cfif len(GET_EMPLOYEE_EXP.EXP_POS)>#GET_EMPLOYEE_EXP.EXP_POS#<cfelse>&nbsp</cfif></td>
                        <td>#GET_EMPLOYEE_EXP.EXP#</td>
                        <td>#GET_EMPLOYEE_EXP.EXP_ADDR#</td>
                        <td>#dateFormat(GET_EMPLOYEE_EXP.EXP_FINISH,dateformat_style)#</td>

                    </tr>
				</table>
			</td>
		</tr>
        <tr>
            <td><b>C) <cf_get_lang dictionary_id='62791.Belgeyi Düzenleyenin'></b></td>
        </tr>
        <tr>
            <td>
                <table class="print_border" style="width:210mm">
                    <tr>
                        <td width="70"><b><cf_get_lang dictionary_id='58025.TC Kimlik No'></b></td>
                        <td>#GET_PREPARED_IDENTITY.TC_IDENTY_NO#</td>
                        <td colspan="4" class="text-center"><b><cf_get_lang dictionary_id='30111.Durumu'></b></td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='32370.Adı Soyadı'></td>
                        <td>#GET_PREPARED_IDENTITY.EMPLOYEE_NAME# #GET_PREPARED_IDENTITY.EMPLOYEE_SURNAME#</td>
                        <td><b><cf_get_lang dictionary_id='62793.Sahip'></b></td>
                        <td><b><cf_get_lang dictionary_id='62794.Kanuni Temsilci'></b></td>
                        <td><b><cf_get_lang dictionary_id='59495.Kiracı'></b></td>
                        <td><b><cf_get_lang dictionary_id='29666.Amir'></b></td>

                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='58033.Baba Adı'></b></td>
                        <td>#GET_PREPARED_IDENTITY.FATHER#</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='57790.Doğum Yeri'>- <cf_get_lang dictionary_id='58593.Tarihi'></b></td>
                        <td>#GET_PREPARED_IDENTITY.BIRTH_PLACE#- #dateFormat(GET_PREPARED_IDENTITY.BIRTH_DATE,dateformat_style)#</td>
                        <td colspan="4"><b><cf_get_lang dictionary_id='31247.Nüfusa Kayıtlı Olduğu'></b></td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='30502.Uyruğu'></b></td>
                        <td>#GET_PREPARED_IDENTITY.NATIONALITY_COUNTRY#</td>
                        <td colspan="2"><b><cf_get_lang dictionary_id='41196.İl-İlçe'></b></td>
                        <td colspan="2">#GET_PREPARED_IDENTITY.CITY# - #GET_PREPARED_IDENTITY.COUNTY#</td>

                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='30606.Ev Adresi'></b></td>
                        <td>#GET_PREPARED_IDENTITY.HOMEADDRESS# - #GET_PREPARED_IDENTITY.CITY_NAME#</td>
                        <td colspan="2"><b><cf_get_lang dictionary_id='31254.Köy'></b></td>
                        <td colspan="2"><cfif len(GET_PREPARED_IDENTITY.village)>#GET_PREPARED_IDENTITY.village#<cfelseif  len(GET_PREPARED_IDENTITY.ward)>#GET_PREPARED_IDENTITY.ward#</cfif></td>

                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='58814.Ev Telefonu'></b></td>
                        <td>(#GET_PREPARED_IDENTITY.HOMETEL_CODE#) #GET_PREPARED_IDENTITY.HOMETEL#</td>
                        <td colspan="2"><b><cf_get_lang dictionary_id='62792.İkamet Tez. Tarihi ve Sayısı'></b></td>
                        <td colspan="2">#dateFormat(GET_PREPARED_IDENTITY.GIVEN_DATE,dateformat_style)#</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
           <td></br></td>
        </tr>
        <tr>
            <td>
                <table style="width:100%">
                    <tr>
                        <td width="300">
                            <table align="left" class="print_border" width:"300px">
                                <tr>
                                    <td colspan="2">(<cf_get_lang dictionary_id='62809.Polis Merkezi Tarafından Doldurulacak'>.)</td>
                                </tr>
                                <tr>
                                    <td colspan="2"><b><cf_get_lang dictionary_id='59499.Belgeyi Teslim Alanın'></b></td>
                                </tr>
                                <tr>
                                    <td><b><cf_get_lang dictionary_id='32370.Adı Soyadı'></b></td>
                                    <td width="130">&nbsp</td>
                                </tr>
                                <tr>
                                    <td><b><cf_get_lang dictionary_id='59500.Rütbesi'></b></td>
                                    <td>&nbsp</td>
                                </tr>
                                <tr>
                                    <td><b><cf_get_lang dictionary_id='59501.Alınış Tarihi'></b></td>
                                    <td>&nbsp</td>
                                </tr>
                                <tr>
                                    <td><b><cf_get_lang dictionary_id='58957.İmza'></b></td>
                                    <td>&nbsp</td>
                                </tr>
                            </table>
                        </td>
                        <td width="240">&nbsp</td>
                        <td style="align:right">
                            <table align="right" style="border:solid 1px gray; width:300px">
                                <tr>
                                    <td style="align:right"><cf_get_lang dictionary_id='62808.Yukarıdaki bilgilerin doğruluğunu onaylarım'>. &nbsp #dateformat(now(),dateformat_style)#</td>
                                </tr>
                                <tr>
                                    <td class="text-center"><b><cf_get_lang dictionary_id='46466.Kaşe/Mühür/İmza'></b></td>
                                </tr>
                                <tr style="height:100px;border-bottom:1px solid gray">
                                    <td>&nbsp</td>
                                </tr>
                                <tr>
                                    <td class="text-center">#check.COMPANY_NAME#</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr style="border-bottom:2px dashed black">
            <td>&nbsp</td>
        </tr>
        <tr><td class="text-center"><cf_get_lang dictionary_id='62810.Çalışanın Ayrılması Durumunda Belgeyi Düzenleyen ile Polis Merkezi Arasında Değiştirilecek Kısım'></td></tr>
        <tr>
            <td>
                <table class="print_border" style="width:100%" >
                    <tr>
                        <td width="170"><b><cf_get_lang dictionary_id='32370.Adı Soyadı'></b></td>
                        <td width="130">&nbsp</td>
                        <td width="170"><b><cf_get_lang dictionary_id='62811.Çalışılan Yerin Adresi'></b></td>
                        <td width="130">&nbsp</td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='58033.Baba Adı'></b></td>
                        <td>&nbsp</td>
                        <td><b><cf_get_lang dictionary_id='62790.Ayrılış Tarihi'></b></td>
                        <td>&nbsp</td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='57790.Doğum Yeri'><cf_get_lang dictionary_id='57989.ve'> <cf_get_lang dictionary_id='58593.Tarihi'></b></td>
                        <td>&nbsp</td>
                        <td><b><cf_get_lang dictionary_id='58957.İmza'></b></td>
                        <td>&nbsp</td>
                    </tr>
                </table>
            </td>
        </tr>
	</table>
	<table>
		<tr class="fixed">
			<td style="font-size:9px!important;"><b><cf_get_lang dictionary_id='61710.© Copyright'></b> <cfoutput>#check.COMPANY_NAME#</cfoutput> <cf_get_lang dictionary_id='61711.dışında kullanılamaz, paylaşılamaz.'></td>
		</tr>
	</table> 
</cfoutput>	
		

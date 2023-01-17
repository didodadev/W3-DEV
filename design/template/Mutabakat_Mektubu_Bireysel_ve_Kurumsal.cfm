<cfif not isdefined('attributes.iid')>
	<cfset attributes.iid = attributes.action_id>
</cfif>
<cfif isDefined("attributes.date1") and len(attributes.date1)><cf_date tarih="attributes.date1"></cfif>
<cfif isDefined("attributes.date2") and len(attributes.date2)><cf_date tarih="attributes.date2"></cfif>
<cfif isDefined("attributes.action_date1") and len(attributes.action_date1)><cf_date tarih="attributes.action_date1"></cfif>
<cfif isDefined("attributes.action_date2") and len(attributes.action_date2)><cf_date tarih="attributes.action_date2"></cfif>
<!--- attributes.money_type_info : Gonderilen Islem Dovizine Gore Bakiyeyi Getirir --->
<cfif isdefined("attributes.keyword") and attributes.keyword is 'consumer'>
	<cfquery name="Get_Comp" datasource="#dsn#">
		SELECT
			ALL_ROWS.CONSUMER_NAME + ' ' + ALL_ROWS.CONSUMER_SURNAME FULLNAME,
			ALL_ROWS.CONSUMER_ID MEMBER_ID,
			ALL_ROWS.MEMBERCAT,
			ALL_ROWS.MEMBER_CODE,
			ALL_ROWS.CITY,
			SUM(BORC1) BORC,
			SUM(ALACAK1) ALACAK,
			SUM(BORC1-ALACAK1) BAKIYE
		FROM 
		(
			SELECT
				SUM(CRS.ACTION_VALUE) BORC1,
				0 ALACAK1,
				CRS.TO_CONSUMER_ID CONSUMER_ID,
				C.CONSUMER_NAME CONSUMER_NAME,
				C.CONSUMER_SURNAME CONSUMER_SURNAME,
				C.MEMBER_CODE,
				C.WORK_CITY_ID AS CITY,
				CC.CONSCAT MEMBERCAT
			FROM
				#dsn2_alias#.CARI_ROWS CRS,
				CONSUMER C,
				CONSUMER_CAT CC
			WHERE
				CRS.TO_CONSUMER_ID IS NOT NULL AND
				C.CONSUMER_ID = CRS.TO_CONSUMER_ID AND
				C.CONSUMER_CAT_ID = CC.CONSCAT_ID
				<cfif isdefined("attributes.iid") and len(attributes.iid)>
					AND	C.CONSUMER_ID = #attributes.iid# 
				</cfif>
				<cfif isdefined("attributes.date1") and len(attributes.date1)>
					AND (CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (91,94,98,101)) THEN #attributes.date1# ELSE CRS.DUE_DATE END OR CRS.DUE_DATE IS NULL)
					AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (91,94,98,101)) THEN #attributes.date1# ELSE CRS.ACTION_DATE END)
				</cfif>
				<cfif isdefined("attributes.date2") and len(attributes.date2)>
					AND	(CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (91,94,98,101)) THEN #attributes.date2# ELSE CRS.DUE_DATE END OR CRS.DUE_DATE IS NULL)
					AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (91,94,98,101)) THEN #attributes.date2# ELSE CRS.ACTION_DATE END)
				</cfif>
				<cfif isdefined("attributes.action_date1") and len(attributes.action_date1)>
					AND CRS.ACTION_DATE >= #attributes.action_date1#
				</cfif>
				<cfif isdefined("attributes.action_date2") and len(attributes.action_date2)>
					AND CRS.ACTION_DATE <= #attributes.action_date2#
				</cfif>
			GROUP BY 
				CRS.TO_CONSUMER_ID,
				C.CONSUMER_NAME,
				C.CONSUMER_SURNAME,
				CC.CONSCAT,
				C.MEMBER_CODE,
				C.WORK_CITY_ID,
				CRS.ACTION_DATE,
				CRS.DUE_DATE
				
		UNION ALL
		
			SELECT
				0 BORC1,		
				SUM(CRS.ACTION_VALUE) ALACAK1,
				CRS.FROM_CONSUMER_ID CONSUMER_ID,
				C.CONSUMER_NAME CONSUMER_NAME,
				C.CONSUMER_SURNAME CONSUMER_SURNAME,
				C.MEMBER_CODE,
				C.WORK_CITY_ID AS CITY,
				CC.CONSCAT MEMBERCAT
			FROM
				#dsn2_alias#.CARI_ROWS CRS,
				CONSUMER C,
				CONSUMER_CAT CC
			WHERE
				CRS.FROM_CONSUMER_ID IS NOT NULL AND
				C.CONSUMER_ID = CRS.FROM_CONSUMER_ID AND
				C.CONSUMER_CAT_ID = CC.CONSCAT_ID
				<cfif isdefined("attributes.iid") and len(attributes.iid)>
					AND	C.CONSUMER_ID = #attributes.iid# 
				</cfif>
				<cfif isdefined("attributes.date1") and len(attributes.date1)>
					AND (CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108)) THEN #attributes.date1# ELSE CRS.DUE_DATE END OR CRS.DUE_DATE IS NULL)
					AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108)) THEN #attributes.date1# ELSE CRS.ACTION_DATE END)
				</cfif>
				<cfif isdefined("attributes.date2") and len(attributes.date2)>
					AND	(CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108)) THEN #attributes.date2# ELSE CRS.DUE_DATE END OR CRS.DUE_DATE IS NULL)
					AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108)) THEN #attributes.date2# ELSE CRS.ACTION_DATE END)
				</cfif>
				<cfif isdefined("attributes.action_date1") and len(attributes.action_date1)>
					AND CRS.ACTION_DATE >= #attributes.action_date1#
				</cfif>
				<cfif isdefined("attributes.action_date2") and len(attributes.action_date2)>
					AND CRS.ACTION_DATE <= #attributes.action_date2#
				</cfif>
			GROUP BY 
				CRS.FROM_CONSUMER_ID,
				C.CONSUMER_NAME,
				C.CONSUMER_SURNAME,				
				CC.CONSCAT,
				C.MEMBER_CODE,
				C.WORK_CITY_ID,
				CRS.ACTION_DATE,
				CRS.DUE_DATE	) AS ALL_ROWS
		GROUP BY
			ALL_ROWS.CONSUMER_NAME + ' ' + ALL_ROWS.CONSUMER_SURNAME,
			ALL_ROWS.CONSUMER_ID,
			ALL_ROWS.MEMBERCAT,
			ALL_ROWS.MEMBER_CODE,
			ALL_ROWS.CITY
		ORDER BY 
			FULLNAME,
			MEMBER_ID
	</cfquery>
	<cfquery name="Get_Member_Info" datasource="#dsn#">
		SELECT
			CONSUMER_NAME + ' ' +CONSUMER_SURNAME MEMBER_NAME,
			TAX_OFFICE TAXOFFICE,
			TAX_NO TAXNO,
			TAX_ADRESS MEMBER_ADRESS,
			TAX_COUNTY_ID COUNTY,
			TAX_CITY_ID CITY,
			TAX_COUNTRY_ID COUNTRY,
			CONSUMER_WORKTELCODE TELCODE,
			CONSUMER_WORKTEL TEL1,
			CONSUMER_FAX FAKS,
            MEMBER_CODE
		FROM
			CONSUMER
		WHERE 
			CONSUMER_ID = #attributes.iid#
	</cfquery>
<cfelseif isdefined("attributes.keyword") and attributes.keyword is 'partner'>
    <cfquery name="Get_Comp" datasource="#dsn#">
        SELECT 	
            ALL_ROWS.FULLNAME AS FULLNAME,
            ALL_ROWS.COMP_ID AS COMPANY_ID,	
            SUM(BORC1) AS BORC,
            SUM(ALACAK1) AS ALACAK,
            SUM(BORC1-ALACAK1) AS BAKIYE
        FROM 
        (	
            SELECT
                <cfif isDefined("attributes.money_info") and Len(attributes.money_info)>
                    <cfif attributes.money_info eq 2 and isDefined("attributes.money_type_info") and Len(attributes.money_type_info)><!--- Islem Dovizi --->
                       SUM(CRS.OTHER_CASH_ACT_VALUE) AS BORC1,
                    <cfelse><!--- 2.Doviz --->
                       SUM(CRS.ACTION_VALUE_2) AS BORC1,
                    </cfif>
                <cfelse><!--- Sistem Dovizi --->
                    SUM(CRS.ACTION_VALUE) AS BORC1,
                </cfif>
                0 AS ALACAK1,
                CRS.TO_CMP_ID AS COMP_ID,
                CRS.ACTION_DATE AS TARIH,
                C.FULLNAME AS FULLNAME
            FROM
                #DSN2#.CARI_ROWS CRS,
                COMPANY C
            WHERE
                CRS.TO_CMP_ID IS NOT NULL AND
                C.COMPANY_ID = CRS.TO_CMP_ID AND
                ISPOTANTIAL = 0 AND
                COMPANY_STATUS = 1 AND
                C.COMPANY_ID = CRS.TO_CMP_ID
                <cfif isDefined("attributes.money_type_info") and Len(attributes.money_type_info)>
                    AND CRS.OTHER_MONEY = '#attributes.money_type_info#'
                </cfif>
                <cfif isdefined("attributes.iid") and len(attributes.iid)>
                    AND	C.COMPANY_ID = #attributes.iid# 
                </cfif>
                <cfif isdefined("attributes.date1") and len(attributes.date1)>
                    AND (CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (91,94,98,101)) THEN #attributes.date1# ELSE CRS.DUE_DATE END OR CRS.DUE_DATE IS NULL)
                    AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (91,94,98,101)) THEN #attributes.date1# ELSE CRS.ACTION_DATE END)
                </cfif>
                <cfif isdefined("attributes.date2") and len(attributes.date2)>
                    AND	(CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (91,94,98,101)) THEN #attributes.date2# ELSE CRS.DUE_DATE END OR CRS.DUE_DATE IS NULL)
                    AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (91,94,98,101)) THEN #attributes.date2# ELSE CRS.ACTION_DATE END)
                </cfif>
                <cfif isdefined("attributes.action_date1") and len(attributes.action_date1)>
                    AND CRS.ACTION_DATE >= #attributes.action_date1#
                </cfif>
                <cfif isdefined("attributes.action_date2") and len(attributes.action_date2)>
                    AND CRS.ACTION_DATE <= #attributes.action_date2#
                </cfif> 
            GROUP BY 
                C.FULLNAME,
                CRS.TO_CMP_ID,
                CRS.ACTION_DATE
            
            UNION
            
            SELECT
                0 AS BORC1,		
                <cfif isDefined("attributes.money_info") and Len(attributes.money_info)>
                    <cfif attributes.money_info eq 2 and isDefined("attributes.money_type_info") and Len(attributes.money_type_info)><!--- Islem Dovizi --->
                       SUM(CRS.OTHER_CASH_ACT_VALUE) AS ALACAK1,
                    <cfelse><!--- 2.Doviz --->
                       SUM(CRS.ACTION_VALUE_2) AS ALACAK1,
                    </cfif>
                <cfelse><!--- Sistem Dovizi --->
                    SUM(CRS.ACTION_VALUE) AS ALACAK1,
                </cfif>
               <!---  SUM(CRS.ACTION_VALUE) AS ALACAK1, --->
                CRS.FROM_CMP_ID AS COMP_ID,
                CRS.ACTION_DATE,
                C.FULLNAME
            FROM
                #DSN2#.CARI_ROWS CRS,
                COMPANY C
            WHERE
                CRS.FROM_CMP_ID IS NOT NULL AND
                C.COMPANY_ID = CRS.FROM_CMP_ID AND
                ISPOTANTIAL = 0 AND
                COMPANY_STATUS = 1 AND
                C.COMPANY_ID = CRS.FROM_CMP_ID
                <cfif isDefined("attributes.money_type_info") and Len(attributes.money_type_info)>
                    AND CRS.OTHER_MONEY = '#attributes.money_type_info#'
                </cfif>
                <cfif isdefined("attributes.iid") and len(attributes.iid)>
                    AND	C.COMPANY_ID = #attributes.iid# 
                </cfif>
                <cfif isdefined("attributes.date1") and len(attributes.date1)>
                    AND (CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (91,94,98,101)) THEN #attributes.date1# ELSE CRS.DUE_DATE END OR CRS.DUE_DATE IS NULL)
                    AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (91,94,98,101)) THEN #attributes.date1# ELSE CRS.ACTION_DATE END)
                </cfif>
                <cfif isdefined("attributes.date2") and len(attributes.date2)>
                    AND	(CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (91,94,98,101)) THEN #attributes.date2# ELSE CRS.DUE_DATE END OR CRS.DUE_DATE IS NULL)
                    AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (91,94,98,101)) THEN #attributes.date2# ELSE CRS.ACTION_DATE END)
                </cfif>
                <cfif isdefined("attributes.action_date1") and len(attributes.action_date1)>
                    AND CRS.ACTION_DATE >= #attributes.action_date1#
                </cfif>
                <cfif isdefined("attributes.action_date2") and len(attributes.action_date2)>
                    AND CRS.ACTION_DATE <= #attributes.action_date2#
                </cfif> 
            GROUP BY 
                C.FULLNAME,
                CRS.FROM_CMP_ID,
                CRS.ACTION_DATE
        ) AS ALL_ROWS
        GROUP BY
            ALL_ROWS.COMP_ID,
            ALL_ROWS.FULLNAME
    </cfquery>
    <cfquery name="Get_Member_Info" datasource="#dsn#">
		SELECT
			FULLNAME MEMBER_NAME,
            TAXOFFICE TAXOFFICE,
            TAXNO TAXNO,
			COMPANY_ADDRESS MEMBER_ADRESS,
			COUNTY COUNTY,
			CITY CITY,
			COUNTRY COUNTRY,
			COMPANY_TELCODE TELCODE,
			COMPANY_TEL1 TEL1,
			COMPANY_FAX FAKS,
            MEMBER_CODE
		FROM
			COMPANY
		WHERE 
			Company_Id = #attributes.iid#
	</cfquery>
</cfif>
<cfif len(Get_Comp.Borc)><cfset BORC = Get_Comp.Borc><cfelse><cfset BORC = 0></cfif>
<cfif len(Get_Comp.Alacak)><cfset ALACAK = Get_Comp.Alacak><cfelse><cfset ALACAK = 0></cfif>
<!--- uye bilgileri --->
<cfset member_name = "">
<cfset member_code = "">
<cfset member_address = "">
<cfset member_phone = "">
<cfset member_fax = "">
<cfset member_taxoffice = "">
<cfset member_taxno = "">
<cfset county = "">
<cfset city = "">
<cfset country = "">
<!--- <cfif len(Get_Comp.Company_Id)>
	<cfquery name="Get_Member_Info" datasource="#dsn#">
		SELECT
			FULLNAME MEMBER_NAME,
            TAXOFFICE TAXOFFICE,
            TAXNO,
			COMPANY_ADDRESS MEMBER_ADRESS,
			COUNTY COUNTY,
			CITY CITY,
			COUNTRY COUNTRY,
			COMPANY_TELCODE TELCODE,
			COMPANY_TEL1 TEL1,
			COMPANY_FAX FAKS,
            MEMBER_CODE
		FROM
			COMPANY
		WHERE 
			Company_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Comp.Company_Id#">
	</cfquery>
	<cfelseif len(Get_Comp.Consumer_Id)>
	<cfquery name="Get_Member_Info" datasource="#dsn#">
		SELECT 
			CONSUMER_NAME + ' ' + CONSUMER_SURNAME MEMBER_NAME,
            '' TAXOFFICE,
            '' TAXNO,
			TAX_ADRESS MEMBER_ADRESS,
			TAX_COUNTY_ID COUNTY,
			TAX_CITY_ID CITY,
			TAX_COUNTRY_ID COUNTRY,
			CONSUMER_WORKTELCODE TELCODE,
			CONSUMER_WORKTEL TEL1,
			CONSUMER_FAX FAKS,
            MEMBER_CODE            
		FROM 
			CONSUMER
		WHERE 
			Consumer_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Comp.Consumer_Id#">
	</cfquery>
</cfif> --->
<cfif isdefined("Get_Comp") and Get_Member_Info.RecordCount>
	<cfset member_name = Get_Member_Info.MEMBER_NAME>
    <cfset member_code = Get_Member_Info.MEMBER_CODE>
	<cfset member_phone = Get_Member_Info.telcode & ' ' & Get_Member_Info.TEL1>
	<cfset member_fax = Get_Member_Info.TELCODE & ' ' & Get_Member_Info.FAKS>
	<cfset member_address = Get_Member_Info.MEMBER_ADRESS>
    <cfset member_taxoffice = Get_Member_Info.TAXOFFICE>
    <cfset member_taxno = Get_Member_Info.TAXNO>
	<cfif len(Get_Member_Info.county)>
		<cfquery name="Get_County" datasource="#dsn#">
			SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.county#">
		</cfquery>
		<cfset county = get_county.county_name>
	</cfif>
	<cfif len(Get_Member_Info.city)>
		<cfquery name="Get_City" datasource="#dsn#">
			SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.city#">
		</cfquery>
		<cfset city = ucase(get_city.city_name)>
	</cfif>
	<cfif len(Get_Member_Info.country)>
		<cfquery name="Get_Country_Name" datasource="#dsn#">
			SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.country#">
		</cfquery>
		<cfset country = ucase(get_country_name.country_name)>
	</cfif>
</cfif>
<cfif not GET_comp.recordcount or not get_comp.recordcount>
	<script type="text/javascript">
		alert("Belge Tipi Seçtiğiniz Kritere Uygun Değil!");
	</script>
	<cfabort>
</cfif>
<cfset tarih_ = "">
<cfset islem_ = "">
<!--- Islem Tarihi veya Vade Tarihi, yoksa da bugunun tarihini getirir --->
<cfif (isdefined("attributes.action_date1") and len(attributes.action_date1)) or (isdefined("attributes.action_date2") and len(attributes.action_date2))>
	<cfif isdefined("attributes.action_date1") and len(attributes.action_date1)><cfset tarih_ = tarih_ & dateformat(attributes.action_date1,dateformat_style)></cfif>
	<cfif isdefined("attributes.action_date1") and len(attributes.action_date1) and isdefined("attributes.action_date2") and len(attributes.action_date2)><cfset tarih_ = tarih_ & ' - '></cfif>
	<cfif isdefined("attributes.action_date2") and len(attributes.action_date2)><cfset tarih_ = tarih_ & ' ' & dateformat(attributes.action_date2,dateformat_style)></cfif>
	<cfset islem_ = "(İşlem Tarihi)">
<cfelseif (isdefined("attributes.date1") and len(attributes.date1)) or (isdefined("attributes.date2") and len(attributes.date2))>
	<cfif isdefined("attributes.date1") and len(attributes.date1)><cfset tarih_ = tarih_ & dateformat(attributes.date1,dateformat_style)></cfif>
	<cfif isdefined("attributes.date1") and len(attributes.date1) and isdefined("attributes.date2") and len(attributes.date2)><cfset tarih_ = tarih_ & ' - '></cfif>
	<cfif isdefined("attributes.date2") and len(attributes.date2)><cfset tarih_ = tarih_ & ' - ' & dateformat(attributes.date2,dateformat_style)></cfif>
	<cfset islem_ = "(Vade Tarihi)">
<cfelse><!--- if not (isdefined("attributes.date1")  and isdefined("attributes.date2") and len(attributes.date2)) and (isdefined("attributes.action_date1") and len(attributes.action_date1) and isdefined("attributes.action_date2") and len(attributes.action_date2)) --->
	<cfset tarih_ = tarih_ & ' ' & dateformat(now(),dateformat_style)>
</cfif>
<table style="width:195mm;height:270mm;" border="0" cellspacing="1" cellpadding="1">
    <tr>
		<td valign="top">
		<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td style="width:10mm;height:10mm">&nbsp;</td>
                <td>&nbsp;</td>
                <td style="width:10mm"></td>
            </tr>
            <tr>
                <td colspan="3" style="text-align:center">
                    <cfquery name="CHECK" datasource="#DSN#">
                        SELECT
                            ASSET_FILE_NAME3
                        FROM
                            OUR_COMPANY
                        WHERE
                        <cfif isDefined("session.ep.company_id")>
                            COMP_ID = #session.ep.company_id#
                        <cfelseif isDefined("session.pp.company")>	
                            COMP_ID = #session.pp.company_id#
                        </cfif> 
                    </cfquery>
                    <cfif len(check.asset_file_name3)>
                    	<cfoutput><img src="#user_domain##file_web_path#settings/#check.asset_file_name3#" border="0"></cfoutput>
                    </cfif>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td valign="top">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td>&nbsp;</td>
                        <td style="text-align:right" class="txtbold"><cfoutput><cf_get_lang_main no='330.Tarih'>: #dateformat(now(),dateformat_style)#</cfoutput><br></td>
                    </tr>
                </table>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td>
                        <cfoutput>
                            <b>#member_name#</b><br>
                            #member_address# <br>				
                            #county# /#city# /#country#<br>
                            <cf_get_lang_main no='1350.Vergi Dairesi'>: #member_taxoffice# - <cf_get_lang_main no='340.Vergi No'> : #member_taxno#<br>
                            <cf_get_lang_main no='87.Tel'> : #member_phone# - <cf_get_lang_main no='76.Fax'> : #member_fax#
                        </cfoutput><br>
                        </td>
                    </tr>
                </table>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
	                <tr><td>&nbsp;</td></tr>
                    <tr>
                    	<td>
                		<cfoutput>
                        <cfif isDefined("attributes.money_info") and Len(attributes.money_info)>
            				<cfif attributes.money_info eq 2 and isDefined("attributes.money_type_info") and Len(attributes.money_type_info)><!--- Islem Dovizi --->
                           		<cfset mybirim = attributes.money_type_info>
                            <cfelse>
                           		<cfset mybirim = session.ep.money2>
                            </cfif>
                        <cfelse>
                         	<cfset mybirim = session.ep.money>
                        </cfif>
						<cfset myNumber = abs(get_comp.bakiye)>
                        <cf_n2txt number="myNumber" para_birimi="#mybirim#">

                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#getLang('objects',896)#<strong>&nbsp;#tarih_#&nbsp;</strong> #getLang('objects',897)# 
                       <strong>#TLFormat(ABS(get_comp.bakiye))# #mybirim# (#myNumber#) <cfif BORC gt ALACAK><cf_get_lang_main no='175.Borç'><cfelseif BORC lt ALACAK><cf_get_lang_main no='176.Alacak'></cfif></strong>
                        #getLang('objects',900)#.<br>
                        #getLang('objects',899)#.
						</cfoutput><br><br>
                        </td>
					</tr>
                </table><br><br><br><br><br><br><br><br><br><br><br><br><br>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                		<td>
                        <cfquery name="get_our_company_info" datasource="#DSN#">
                            SELECT * FROM OUR_COMPANY WHERE COMP_ID = #session.ep.company_id# 
                        </cfquery>
						<cfoutput query="get_our_company_info">
                            <p><u><strong><cf_get_lang dictionary_id='49048.HATA VE UNUTMA İSTİSNADIR'></strong></u><br><br>
							1-) <cf_get_lang dictionary_id='49053.Mutabakat veya itirazınızı 7 gün içerisinde bildirmediğiniz takdirde T.T.K. nun 92. maddesi gereğince bakiyede mutabıksayılacağımızı hatırlatırız.'><br>
                            2-) <cf_get_lang dictionary_id='49373.Bakiyede Mutabık olmadığınız takdirde hesap ekstrenizi'> 0 #tel_code# #fax# <cf_get_lang dictionary_id='49374.nolu faksa veya'> #email# <cf_get_lang dictionary_id='49376.mail adresine göndermenizi rica ederiz'>.<br>
                        </cfoutput>
                        </td>
                    </tr>
                </table><br><hr>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td>&nbsp;</td>
                        <td style="text-align:right" class="txtbold"><cfoutput><cf_get_lang_main no='330.Tarih'>: #dateformat(now(),dateformat_style)#</cfoutput></td>
                    </tr>
                    <tr>
                        <td valign="top"><cfoutput>#getLang('main',1368)#</cfoutput>,&nbsp;</td>
                        <td>       
                            <cfoutput query="get_our_company_info">
                                <strong>#company_name#</strong><br>
                                #address#<br>
                                <cf_get_lang_main no='1350.Vergi Dairesi'> / <cf_get_lang_main no='75.No'>: #tax_office# - #tax_no#<br>
                                <cf_get_lang_main no='87.Tel'>: <cfif Len(tel) or Len(tel2)>(#tel_code#) #tel# - #tel2#</cfif> - <cf_get_lang_main no='76.Fax'>: (#tel_code#) #fax# - #fax2#</p>
                                <br><br><cfoutput>
                                #getLang('objects',896)# ................ #getLang('objects',897)# ...................... #mybirim# #getLang('main',175)#/#getLang('main',176)# <cf_get_lang dictionary_id='49088.bakiye vermektedir.'>.
                                <cf_get_lang dictionary_id='33289.Mutabık olduğumuzu/olmadığımızı bildiririz.'></cfoutput>
                            </cfoutput>
                        </td>
                    </tr>
                </table><br><br><br><br>
                </tr>
		</table>
		</td>
	</tr>
</table>

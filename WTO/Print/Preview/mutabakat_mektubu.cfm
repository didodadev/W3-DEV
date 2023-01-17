<cfif not isdefined('attributes.iid')><cfset attributes.iid = attributes.action_id></cfif>
<cfif isDefined("attributes.date1") and len(attributes.date1)><cf_date tarih="attributes.date1"></cfif>
<cfif isDefined("attributes.date2") and len(attributes.date2)><cf_date tarih="attributes.date2"></cfif>
<cfif isDefined("attributes.action_date1") and len(attributes.action_date1)><cf_date tarih="attributes.action_date1"></cfif>
<cfif isDefined("attributes.action_date2") and len(attributes.action_date2)><cf_date tarih="attributes.action_date2"></cfif>
<!--- attributes.money_type_info : Gonderilen Islem Dovizine Gore Bakiyeyi Getirir --->
<cfquery name="GET_COMP" datasource="#DSN#">
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
			C.FULLNAME,
			CRS.FROM_CMP_ID,
			CRS.ACTION_DATE
	) AS ALL_ROWS
	GROUP BY
		ALL_ROWS.COMP_ID,
		ALL_ROWS.FULLNAME
</cfquery>

<cfif len(get_comp.borc)>
	<cfset BORC = get_comp.borc>
<cfelse>
	<cfset BORC = 0>
</cfif>
<cfif len(get_comp.alacak)>
	<cfset ALACAK = get_comp.alacak>
<cfelse>
	<cfset ALACAK = 0>
</cfif>

<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY FROM SETUP_MONEY
</cfquery>

<cfquery name="GET_COMP_NAME" datasource="#DSN#">
	SELECT
		C.FULLNAME,
		C.TAXOFFICE,
		C.TAXNO,
        (SELECT CP.TC_IDENTITY FROM #dsn#.COMPANY_PARTNER CP WHERE CP.PARTNER_ID = C.MANAGER_PARTNER_ID) TC_IDENTY_NO,
		C.COMPANY_ADDRESS,
		C.COMPANY_TELCODE,
		C.COMPANY_TEL1,
		C.COMPANY_FAX,
		C.COUNTY,
		C.CITY,
		C.COUNTRY,
		C.SEMT
	FROM
		COMPANY C
	WHERE 
		C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
</cfquery>
<!---<cfquery name="GET_COMP_NAME" datasource="#DSN#">
	SELECT
		FULLNAME,
		TAXOFFICE,
		TAXNO,
		COMPANY_ADDRESS,
		COMPANY_TELCODE,
		COMPANY_TEL1,
		COMPANY_FAX,
		COUNTY,
		CITY,
		COUNTRY,
		SEMT
	FROM
		COMPANY
	WHERE 
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
</cfquery>--->
<cfif len(get_comp_name.city)>
	<cfquery name="GET_CITY" datasource="#DSN#">
		SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_comp_name.city#">
	</cfquery>
</cfif>
<cfif len(get_comp_name.county)>
	<cfquery name="GET_COUNTY" datasource="#DSN#">
		SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_comp_name.county#">
	</cfquery>
</cfif>
<cfif len(get_comp_name.country)>
	<cfquery name="GET_COUNTRY" datasource="#dsn#">
		SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_comp_name.country#">
	</cfquery>
</cfif>
<cfif not GET_comp_NAME.recordcount or not get_comp.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='64271.Belge Tipi Seçtiğiniz Kriterlere Uygun Değil'>!");
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
                        <td style="text-align:right" class="txtbold"><cfoutput><cf_get_lang dictionary_id='57742.Date'>: #dateformat(now(),dateformat_style)#</cfoutput><br/></td>
                    </tr>
                </table>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td>
                        <cfoutput>
                            <b>#get_comp_name.fullname#</b><br/>
                            #get_comp_name.company_address# #get_comp_name.semt#<br/>				
                            <cfif len(get_comp_name.county)>#get_county.county_name# /</cfif>
                            <cfif len(get_comp_name.city)>#get_city.city_name# /</cfif>
                            <cfif len(get_comp_name.country)>#get_country.country_name#</cfif><br/>
                            <cf_get_lang_main no='1350.Vergi Dairesi'>: #get_comp_name.taxoffice# - <cf_get_lang dictionary_id='58762.Tax Office'> : <cfif len(get_comp_name.taxno)>#get_comp_name.taxno#<cfelse>#get_comp_name.tc_identy_no#</cfif><br/>
							<cf_get_lang dictionary_id='57499.Phone'> : <cfif Len(get_comp_name.company_tel1)>#get_comp_name.company_telcode# #get_comp_name.company_tel1#</cfif> - <cf_get_lang dictionary_id='57488.Fax'> : #get_comp_name.company_fax#
                        </cfoutput><br/>
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
                        <cfset zero_value = 0.00>
                        <cfif get_comp.BAKIYE eq zero_value>
							<cfset myNumber = TLFormat(abs(get_comp.BAKIYE))>
						<cfelse>
							<cfset myNumber = ABS(get_comp.BAKIYE)>                        	                            
                        </cfif>
                        <cf_n2txt number="myNumber" para_birimi="#mybirim#">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='33286.Your Current Account'><strong>&nbsp;#tarih_#&nbsp;</strong> <cf_get_lang dictionary_id='33287.by date'> 
                       <strong>#TLFormat(ABS(get_comp.bakiye))# #mybirim# (#myNumber#)<cfif BORC gt ALACAK><cf_get_lang dictionary_id='57587.Debit'><cfelseif BORC lt ALACAK><cf_get_lang dictionary_id='57588.Credit'></cfif></strong>
                        <cf_get_lang dictionary_id='33290.shows balance'>.<br/>
						<cf_get_lang dictionary_id='33289.Please let us know whether you agree or disagree'>.
						</cfoutput><br/><br/>
                        </td>
                    </tr>
                </table><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                		<td>
                        <cfquery name="get_our_company_info" datasource="#DSN#">
                            SELECT * FROM OUR_COMPANY WHERE COMP_ID = #session.ep.company_id# 
                        </cfquery>
						<cfoutput query="get_our_company_info">
                            <p><u><strong><cf_get_lang dictionary_id='49048.HATA VE UNUTMA İSTİSNADIR'></strong></u><br/><br/>
                            1-) <cf_get_lang dictionary_id='49053.?Mutabakat veya itirazınızı 7 gün içerisinde bildirmediğiniz takdirde T.T.K. nun 92. maddesi gereğince bakiyede mutabık sayılacağımızı hatırlatırız.'><br/>
                            2-) <cf_get_lang dictionary_id='49373.Bakiyede Mutabık olmadığınız takdirde hesap ekstrenizi'> 0 #tel_code# #fax# <cf_get_lang dictionary_id='49374.nolu faksa veya'> #email# <cf_get_lang dictionary_id='49376.mail adresine göndermenizi rica ederiz'>.<br/>
                        </cfoutput>
                        </td>
                    </tr>
                </table><br/><hr>
                <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td>&nbsp;</td>
                        <td style="text-align:right" class="txtbold"><cfoutput><cf_get_lang_main no='330.Tarih'>: #dateformat(now(),dateformat_style)#</cfoutput></td>
                    </tr>
                    <tr>
                        <td valign="top">Sayın,&nbsp;</td>
                        <td>       
                            <cfoutput query="get_our_company_info">
                                <strong>#company_name#</strong><br/>
                                #address#<br/>
                                <cf_get_lang dictionary_id='58762.Tax Office'> / <cf_get_lang dictionary_id='57487.Number'>: #tax_office# - #tax_no#<br/>
								<cf_get_lang dictionary_id='57499.Phone'>: <cfif Len(tel) or Len(tel2)>(#tel_code#) #tel# - #tel2#</cfif> - <cf_get_lang dictionary_id='57488.Fax'>: (#tel_code#) #fax# - #fax2#</p>
                                <br/><br/>
                                <cf_get_lang dictionary_id='33286.Nezdimizdeki Cari Hesabınız'> ................ <cf_get_lang dictionary_id='61429.tarihi itibariyle'> ...................... #mybirim# <cf_get_lang dictionary_id='61430.Borç/Alacak bakiye vermektedir'>.
									<cf_get_lang dictionary_id='30410.Mutabık olduğumuzu/olmadığımızı bildiririz'>.
                            </cfoutput>
                        </td>
                    </tr>
                </table><br/><br/><br/><br/>
                </tr>
		</table>
		</td>
	</tr>
</table>

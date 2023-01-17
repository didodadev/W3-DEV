<cfif isdefined("attributes.start_Date_") and len(attributes.start_Date_)>
	<cf_date tarih='attributes.start_Date_'>
</cfif>
<cfif isdefined("attributes.finish_date_") and len(attributes.finish_date_)>
	<cf_date tarih='attributes.finish_date_'>
</cfif>
<cfquery name="GETCOMPANY" datasource="#dsn#">
	SELECT  
	DISTINCT
		<cfif isDefined("attributes.money_type") and attributes.money_type eq '#session.ep.money#'>
			SUM(CARI_ROWS_TOPLAM.BORC3-CARI_ROWS_TOPLAM.ALACAK3) BAKIYE,
		<cfelseif isDefined("attributes.money_type") and len(session.ep.money2) and attributes.money_type eq '#session.ep.money2#'>
			SUM(CARI_ROWS_TOPLAM.BORC2-CARI_ROWS_TOPLAM.ALACAK2) BAKIYE,
		<cfelse>
			SUM(CARI_ROWS_TOPLAM.BORC - CARI_ROWS_TOPLAM.ALACAK) BAKIYE,
		</cfif>
		COMPANY.COMPANY_ID,
		COMPANY.MEMBER_CODE,
		COMPANY.FULLNAME,
		COMPANY.COMPANY_EMAIL,
		COMPANY.COMPANY_ADDRESS,
		COMPANY.COMPANY_POSTCODE,
		COMPANY.CITY,
		COMPANY.COUNTY,
		COMPANY_CAT.COMPANYCAT,
		COMPANY.COMPANY_TELCODE, 
		COMPANY.COMPANY_TEL1, 
		COMPANY.COMPANY_FAX
	FROM 
		COMPANY 
		INNER JOIN COMPANY_CAT ON COMPANY.COMPANYCAT_ID = COMPANY_CAT.COMPANYCAT_ID  
		INNER JOIN COMPANY_CAT_OUR_COMPANY ON COMPANY_CAT.COMPANYCAT_ID = COMPANY_CAT_OUR_COMPANY.COMPANYCAT_ID 
		LEFT OUTER JOIN #dsn2_alias#.CARI_ROWS_TOPLAM CARI_ROWS_TOPLAM ON CARI_ROWS_TOPLAM.COMPANY_ID = COMPANY.COMPANY_ID 
		<cfif isdefined("attributes.start_Date_") and len(attributes.start_Date_)>AND CARI_ROWS_TOPLAM.ACTION_DATE >= #attributes.start_Date_#</cfif>
		<cfif isdefined("attributes.finish_date_") and len(attributes.finish_date_)>AND CARI_ROWS_TOPLAM.ACTION_DATE < #dateadd("d",1,attributes.finish_date_)#</cfif>
	WHERE 
		COMPANY.COMPANY_STATUS = 1 AND 
		COMPANY_CAT_OUR_COMPANY.OUR_COMPANY_ID = #session.ep.company_id# AND 
		COMPANY.COMPANY_ID = #attributes.company_id# 
		<cfif IsDefined("attributes.money_type") and Len(attributes.money_type)>
			AND CARI_ROWS_TOPLAM.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type#">
		</cfif>
	GROUP BY 
		COMPANY.COMPANY_ID,
		COMPANY.MEMBER_CODE,
		COMPANY.FULLNAME,
		COMPANY.COMPANY_EMAIL,
		COMPANY.COMPANY_ADDRESS,
		COMPANY.COMPANY_POSTCODE,
		COMPANY.CITY,
		COMPANY.COUNTY,
		COMPANY_CAT.COMPANYCAT,
		COMPANY.COMPANY_TELCODE, 
		COMPANY.COMPANY_TEL1, 
		COMPANY.COMPANY_FAX
</cfquery>
<cfquery name="GETOURCOMPANY" datasource="#dsn#">
	SELECT * FROM OUR_COMPANY WHERE COMP_ID = #session.ep.company_id#
</cfquery>
<table width="98%" align="center">
	<tr>
		<td style="text-align:right"><cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td style="text-align:left"><b><cfoutput>#GETCOMPANY.FULLNAME#</cfoutput></b></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td style="text-align:left"><cfoutput>#GETCOMPANY.COMPANY_ADDRESS# #GETCOMPANY.COMPANY_POSTCODE#</cfoutput></td>
	</tr>
	<tr>
		<td style="text-align:left"><cfoutput>
		<cfif len(GETCOMPANY.city)>
			<cfquery name="GETCITY" datasource="#dsn#">
				SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #GETCOMPANY.city#
			</cfquery>#GETCITY.CITY_NAME#
		</cfif> / 
		<cfif len(GETCOMPANY.county)>
			<cfquery name="GETCITY" datasource="#dsn#">
				SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #GETCOMPANY.county#
			</cfquery>#GETCITY.COUNTY_NAME#
		</cfif>
		</cfoutput></td>
	</tr>
	<cfoutput>
	<tr class="font_text">
		<td>Telefon : #GETCOMPANY.COMPANY_TELCODE# #GETCOMPANY.COMPANY_TEL1#</td>
	</tr>
	<tr class="font_text">
		<td>Fax : #GETCOMPANY.COMPANY_TELCODE# #GETCOMPANY.COMPANY_FAX#</td>
	</tr>
	</cfoutput>
	<tr>
		<td style="text-align:center" height="60"><font style="font-size:14px"><b><cf_get_lang dictionary_id='49865.Mutabakat Mektubu'></b></font></td>
	</tr>
	<tr>
		<td style="text-align:left" height="40"><font style="font-size:12px"><b>Sn. <cfoutput>#GETCOMPANY.fullname#</cfoutput></b></font></td>
	</tr>
	<tr>
		<td colspan="2">						
			<br>
			<cf_get_lang dictionary_id='64447.Şirketimiz nezdindeki hesap bakiyeniz'> <cfif isdefined("attributes.finish_date_")><cfoutput>#dateformat(attributes.finish_date_,'dd/mm/yyyy')#</cfoutput><cfelse><cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput></cfif> <cf_get_lang dictionary_id='33287.tarihi itibari ile'>
			<cfoutput>
			<cfset mynumber = GETCOMPANY.BAKIYE>
			&nbsp;<cfoutput><b><cfif len(GETCOMPANY.BAKIYE) and GETCOMPANY.BAKIYE gt 0>#tlformat(GETCOMPANY.BAKIYE)# <cfif IsDefined("attributes.money_type") and Len(attributes.money_type)>#attributes.money_type#<cfelse>#session.ep.money#</cfif></cfif><cfif len(GETCOMPANY.BAKIYE) and GETCOMPANY.BAKIYE lt 0>#tlformat(-1*GETCOMPANY.BAKIYE)# <cfif IsDefined("attributes.money_type") and Len(attributes.money_type)>#attributes.money_type#<cfelse>#session.ep.money#</cfif></cfif><cfif not len(GETCOMPANY.BAKIYE)>#tlformat(0)# <cfif IsDefined("attributes.money_type") and Len(attributes.money_type)>#attributes.money_type#<cfelse>#session.ep.money#</cfif></cfif></b></cfoutput>&nbsp;&nbsp;
			</cfoutput>
			<cfif GETCOMPANY.BAKIYE gt 0><cf_get_lang dictionary_id='57587.Borç'></cfif><cfif GETCOMPANY.BAKIYE lt 0><cf_get_lang dictionary_id='57588.Alacak'></cfif> <cf_get_lang dictionary_id='64448.bakiyesi vermektedir.'> <cf_get_lang dictionary_id='64446.Bu tutarı hakkında mutabık olup olmadığınızı bildirmenizi rica ederiz.'> <cf_get_lang dictionary_id='64450.Mutabık olmamanız durumunda aşağıdaki alana bakiyeyi yazınız.'><br /><br /><br />
			<cfoutput><cf_get_lang dictionary_id='57587.Borç'>..................................................(<cfif IsDefined("attributes.money_type") and Len(attributes.money_type)>#attributes.money_type#<cfelse>#session.ep.money#</cfif>)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='57588.Alacak'>..................................................(<cfif IsDefined("attributes.money_type") and Len(attributes.money_type)>#attributes.money_type#<cfelse>#session.ep.money#</cfif>)<br /><br /><br />
			<cf_get_lang dictionary_id='48814.Saygılarımızla'>,<br /><br /><br /><br /></cfoutput>
			<b><cfoutput>#GETOURCOMPANY.COMPANY_NAME#</cfoutput></b><br>	
			<b><cf_get_lang dictionary_id='49272.Tel'>: </b><cfoutput>#GETOURCOMPANY.TEL_CODE# #GETOURCOMPANY.TEL#</cfoutput><br>
			<b><cf_get_lang dictionary_id='57488.Fax'>: </b><cfoutput>#GETOURCOMPANY.TEL_CODE# #GETOURCOMPANY.FAX#</cfoutput><br>
			<!--- <b>E-mail: </b>info@inpakmakina.com.tr<br><br> --->
			<cf_get_server_file output_file="settings/#GETOURCOMPANY.asset_file_name2#" output_server="#GETOURCOMPANY.asset_file_name2_server_id#" output_type="5"> 
			<br /><br /><br />
			<b><cf_get_lang dictionary_id='57422.Notlar'> :</b><br /><br />
			1- <cf_get_lang dictionary_id='49048.HATA VE UNUTMA İSTİSNADIR'><br />
			2- <cf_get_lang dictionary_id='49053.Mutabakat veya itirazınızı 7 gün içerisinde bildirmediğiniz takdirde T.T.K. nun 92. maddesi gereğince bakiyede mutabık sayılacağımızı hatırlatırız.'><br />
			3- <cf_get_lang dictionary_id='49373.Bakiyede Mutabık olmadığınız takdirde hesap ekstrenizi'> <cf_get_lang dictionary_id='64445.tarafımıza göndermenizi rica ederiz.'>
		</td>
	</tr>
</table><BR /><BR />
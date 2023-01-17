<cfsetting requesttimeout = "21600">

<cfif isDefined('attributes.all') and attributes.all eq 1>
	<cfset start_date = '2013-01-01'>
<cfelse>
	<cfset start_date = dateFormat(dateAdd('d', -7, now()),'yyy-mm-dd')>
</cfif>

<cfobject name="soap" type="component" component="v16.e_government.cfc.dogan.efatura.soap">
<cfobject name="common" type="component" component="V16.e_government.cfc.dogan.efatura.common">
<cfobject name="mapper" type="component" component="v16.e_government.cfc.dogan.efatura.mapper">
<cfobject name="javaziphelper" type="component" component="cfc.javaziphelper">
<cfset soap.init()>

<cffile action = "write" file = "C:/muk.zip" output = "#toBinary(soap.GetEFaturaCustomerFullList(startdate : start_date).serviceresult)#">
<cfzip action = "read" file = "C:/muk.zip" variable = "res" entryPath = "users" charset = "utf-8">

<cfset xmlx = xmlParse(res).GetUserListResponse.XmlChildren>

<cfif isDefined('attributes.all') and attributes.all eq 1>
	<!---<cfset common.truncate_efatura_alias()>--->

	<cfquery name = "truncate_einvoice_alias_new" datasource = "#dsn#">
		TRUNCATE TABLE EINVOICE_COMPANY_IMPORT
	</cfquery>

	<cfloop from = "1" to = "#arrayLen(xmlx)#" index = "i">
		<cftry>
			<cfset child = xmlx[i]>

			<cfquery name = "add_einvoice_alias" datasource = "#dsn#">
				INSERT INTO EINVOICE_COMPANY_IMPORT (TAX_NO, ALIAS, COMPANY_FULLNAME, TYPE, REGISTER_DATE, ALIAS_CREATION_DATE) VALUES ('#child.identifier.XmlText#','#child.alias.XmlText#','#replace(child.title.XmlText,'''','','all')#','#child.type.XmlText#','#child.register_time.XmlText#','#child.alias_creation_time.XmlText#');
			</cfquery>

			<cfcatch>
				<cfsavecontent variable="catch_alias">
					<cfdump  var="#cfcatch#">
				</cfsavecontent>

				<cffile  action="write" file = "C:\alias_error_#child.identifier.XmlText#.html" output = "#catch_alias#">
			</cfcatch>
		</cftry>
	</cfloop>
<cfelse>
	<cfloop from = "1" to = "#arrayLen(xmlx)#" index = "i">
		<cftry>
			<cfset child = xmlx[i]>
			<cfquery name = "del_einvoice_alias" datasource = "#dsn#">
				DELETE FROM EINVOICE_COMPANY_IMPORT WHERE ALIAS = '#child.alias.XmlText#' AND TAX_NO = '#child.identifier.XmlText#'
			</cfquery>
			<cfquery name = "add_einvoice_alias" datasource = "#dsn#">
				INSERT INTO EINVOICE_COMPANY_IMPORT (TAX_NO, ALIAS, COMPANY_FULLNAME, TYPE, REGISTER_DATE, ALIAS_CREATION_DATE) VALUES ('#child.identifier.XmlText#','#child.alias.XmlText#','#replace(child.title.XmlText,'''','','all')#','#child.type.XmlText#','#child.register_time.XmlText#','#child.alias_creation_time.XmlText#');
			</cfquery>

			<cfcatch>
				<cfsavecontent variable="catch_alias">
					<cfdump  var="#cfcatch#">
				</cfsavecontent>

				<cffile  action="write" file = "C:\alias_error_#i#.html" output = "#catch_alias#">
			</cfcatch>
		</cftry>
	</cfloop>
</cfif>

<cfoutput>
	#arrayLen(xmlx)# mükellef içeri aktarıldı!
</cfoutput>

<cfset temp_earchive = 0>

<!---Kurumsal uye guncelleme--->    
<cfquery name="UPD_COMP" datasource="#DSN#" result="xxx2">
	UPDATE COMPANY SET USE_EFATURA = 0,<cfif temp_earchive eq 1>USE_EARCHIVE = 1,</cfif>EFATURA_DATE = NULL
</cfquery>

<cfquery name="UPD_COMP" datasource="#DSN#" result="xxx">
	UPDATE 
		C
	SET 
		USE_EFATURA = 1,<cfif temp_earchive eq 1>USE_EARCHIVE = 0,EARCHIVE_SENDING_TYPE = NULL,</cfif> EFATURA_DATE = ECI.REGISTER_DATE
	FROM 
		COMPANY C, EINVOICE_COMPANY_IMPORT ECI
	WHERE 
		ECI.TAX_NO = C.TAXNO AND
		LEN(ECI.TAX_NO) = 10
</cfquery>

<cfquery name="UPD_COP_WITH_TC" datasource="#DSN#"><!---#77353 Vergi Numarası Olmayıp TC Numarası olan kurumsal üyeler içinde güncelleme yapılması sağlandı (Add by: MCP) --->
	IF NOT EXISTS( SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMPANY' AND COLUMN_NAME = 'IS_PERSON')
		BEGIN
			UPDATE 
				COMPANY
			SET 
				USE_EFATURA=1,
				<cfif temp_earchive eq 1>USE_EARCHIVE = 0,EARCHIVE_SENDING_TYPE = NULL,</cfif>
				EFATURA_DATE=ECI.REGISTER_DATE
			FROM 
				COMPANY C
				INNER JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = C.MANAGER_PARTNER_ID
				INNER JOIN EINVOICE_COMPANY_IMPORT ECI ON ECI.TAX_NO = CP.TC_IDENTITY
			WHERE
				C.TAXNO IS NULL AND
				CP.TC_IDENTITY IS NOT NULL
		END
   ELSE
		BEGIN
			UPDATE 
				COMPANY
			SET 
				USE_EFATURA=1,
				<cfif temp_earchive eq 1>USE_EARCHIVE = 0,EARCHIVE_SENDING_TYPE = NULL,</cfif>
				EFATURA_DATE=ECI.REGISTER_DATE
			FROM 
				COMPANY C
				INNER JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = C.MANAGER_PARTNER_ID
				INNER JOIN EINVOICE_COMPANY_IMPORT ECI ON ECI.TAX_NO = CP.TC_IDENTITY
			WHERE
				C.IS_PERSON = 1 AND
				CP.TC_IDENTITY IS NOT NULL
		END
</cfquery>

<!---Bireysel uye guncelleme--->    
	
<cfquery name="UPD_COMP" datasource="#DSN#" result="yyy2">
	UPDATE CONSUMER SET USE_EFATURA = 0,<cfif temp_earchive eq 1>USE_EARCHIVE = 1,</cfif>EFATURA_DATE = NULL
</cfquery>
		
<cfquery name="UPD_COMP" datasource="#DSN#" result="yyy">
	UPDATE 
		C
	SET 
		USE_EFATURA = 1,<cfif temp_earchive eq 1>USE_EARCHIVE = 0,</cfif> EFATURA_DATE = ECI.REGISTER_DATE
	FROM 
		CONSUMER C, EINVOICE_COMPANY_IMPORT ECI
	WHERE 

		ECI.TAX_NO = C.TC_IDENTY_NO AND
		LEN(ECI.TAX_NO) = 11
</cfquery>

<cfquery name = "del_multi_alias" datasource = "#dsn#">
	WITH CTE1 AS (
		SELECT
			EINVOICE_COMP_ID,
			TAX_NO,
			ALIAS,
			COMPANY_FULLNAME,
			TYPE,
			REGISTER_DATE,
			EINVOICE_TYPE,
			ROW_NUMBER() OVER (PARTITION BY TAX_NO, ALIAS, COMPANY_FULLNAME, TYPE, REGISTER_DATE ORDER BY EINVOICE_COMP_ID) AS ROWNUM
		FROM
			#dsn#.EINVOICE_COMPANY_IMPORT ECI
	)
	DELETE FROM #dsn#.EINVOICE_COMPANY_IMPORT WHERE EINVOICE_COMP_ID IN (
		SELECT
			EINVOICE_COMP_ID
		FROM
			CTE1
		WHERE
			ROWNUM > 1
	)
</cfquery>
<cfsetting requesttimeout = "99999">
<cfobject name="javaziphelper" type="component" component="cfc.javaziphelper">
<cfobject name="eisoap" type="component" component="V16.e_government.cfc.super.einvoice.soap">
<cfobject name="mapper" type="component" component="V16.e_government.cfc.super.einvoice.mapper">

<cfset eisoap.init()>


<cfif isDefined('attributes.all') and attributes.all eq 1>
	<cffile action="write" file="C:/mukellef.xml" output="#toString(javaziphelper.DecompressFirstEntry(toBinary(eisoap.GetEFaturaCustomerFullList().serviceresult)))#" charset="utf-8" />
	<cffile action="read" file = "C:/mukellef.xml" variable = "res" charset = "utf-8">

	<cfxml variable="xmlx"><cfoutput>#res#</cfoutput></cfxml>
	<cfquery name = "truncate_einvoice_alias_new" datasource = "#dsn#">
		TRUNCATE TABLE EINVOICE_COMPANY_IMPORT
	</cfquery>
	
	<cfloop array="#xmlx.UserList.XmlChildren#" index="child">
		<cfset return_map = mapper.map_einvoice_alias( child ) >
		<cftry>
			<cfquery name = "add_einvoice_alias" datasource = "#dsn#">
				INSERT INTO 
					EINVOICE_COMPANY_IMPORT(
						TAX_NO, 
						ALIAS, 
						COMPANY_FULLNAME, 
						TYPE, 
						REGISTER_DATE, 
						ALIAS_CREATION_DATE
					) 
				VALUES(
					'#return_map.VKNTCKN#',
					'#return_map.ALIAS#',
					'#return_map.NAME#',
					'#return_map.TYPE#',
					'#return_map.FIRSTCREATIONTIME#',
					'#return_map.ALIASCREATIONTIME#'
				);
			</cfquery>
	
			<cfcatch>
				<cfsavecontent variable="catch_alias">
					<cfdump  var="#cfcatch#">
				</cfsavecontent>
			</cfcatch>
		</cftry>
	</cfloop>
	mükellefler içeri aktarıldı
	<cfset temp_earchive = 0>
<cfelse>
	<cfset xmlx = eisoap.EFaturaCustomerListWithDay()>
	<cfobject name="helper" type="component" component="V16.e_government.cfc.helper">
	<cfloop array="#xmlx.UserList#" index="child">
		<cftry>
			<cfquery name = "add_einvoice_alias" datasource = "#dsn#">
				INSERT INTO 
					EINVOICE_COMPANY_IMPORT(
						TAX_NO, 
						ALIAS, 
						COMPANY_FULLNAME, 
						TYPE, 
						REGISTER_DATE, 
						ALIAS_CREATION_DATE
					) 
				VALUES(
					'#child.Identifier#',
					'#child.ALIAS#',
					'#mid(child.name, 1, 250)#',
					'#child.TYPE#',
					'#helper.webtime2date( child.firstcreationtime )#',
					'#helper.webtime2date( child.aliascreationtime )#'
				);
			</cfquery>
	
			<cfcatch>
				<cfsavecontent variable="catch_alias">
					<cfdump  var="#cfcatch#">
				</cfsavecontent>
			</cfcatch>
		</cftry>
	</cfloop>
	Son 7 gün mükellefleri içeri aktarıldı
	<cfset temp_earchive = 0>
</cfif>

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

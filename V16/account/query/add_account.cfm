<cfset attributes.account_name=replacelist(attributes.account_name,"',"""," ")><!--- hesap adına tek ve cift tirnak yazilmamali --->
<cfif isDefined('attributes.db_source') and isDefined('attributes.period_year') and len(attributes.db_source) and len(attributes.period_year)>
	<cfset DSN2 = dsn&'_'&attributes.period_year&'_'&attributes.db_source>
</cfif>
<cfscript>
	url_string = "";
	if(isdefined("attributes.field_id") and len(attributes.field_id))
		url_string = "#url_string#&field_id=#field_id#";
	if(isdefined("attributes.field_name") and len(attributes.field_name))
		url_string = "#url_string#&field_name=#attributes.field_name#";
	if(isdefined("attributes.code") and len(attributes.code))
		url_string = "#url_string#&code=#attributes.code#";
	if(isdefined("attributes.db_source") and len(attributes.db_source))
		url_string = "#url_string#&db_source=#attributes.db_source#";
	if(isdefined("attributes.period_year") and len(attributes.period_year))
		url_string = "#url_string#&period_year=#attributes.period_year#";
	if(isdefined("attributes.nereden_geldi") and len(attributes.nereden_geldi))
		url_string = "#url_string#&nereden_geldi=#attributes.nereden_geldi#";
	if(isdefined("attributes.search_account_code") and len(attributes.search_account_code))
		url_string = "#url_string#&account_code=#attributes.search_account_code#";
	if(isdefined('attributes.db_source'))
	{
		if(database_type is "MSSQL")
		{
			db_source = "#DSN#_#attributes.PERIOD_YEAR#_#attributes.db_source#";
			db_source3_alias = "#DSN#_#attributes.db_source#";
		}else if (database_type is "DB2")
		{
			db_source="#DSN#_#attributes.db_source#_#Right(Trim(attributes.PERIOD_YEAR),2)#";
			db_source3_alias="#DSN#_#attributes.db_source#_dbo";
		}
	}
	else
	{
		db_source = DSN2 ;
		db_source3_alias = DSN3_ALIAS;
	}
</cfscript> 
<cfquery name="UNIQUE" datasource="#db_source#">
	SELECT 
		ACCOUNT_CODE 
	FROM
		ACCOUNT_PLAN 
	WHERE 
		ACCOUNT_CODE = '#attributes.ACCOUNT_CODE#'
</cfquery>
<cfif len(attributes.account_code) lt 3>
	<script type="text/javascript">
		alert("Hesap Kod uzunluğu Hatalı!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif UNIQUE.RECORDCOUNT gt 0>
	<script type="text/javascript">
		alert("<cf_get_lang no='107.Seçilen Kod Mevcut'>");
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfset list = "',""">
	<cfset list2 = " , ">
	<cfset attributes.ACCOUNT_CODE = replacelist(attributes.ACCOUNT_CODE,list,list2)>
	<cfset attributes.ACCOUNT_NAME = replacelist(attributes.ACCOUNT_NAME,list,list2)>	
	<cfquery name="add_account" datasource="#db_source#">
		INSERT INTO 
		ACCOUNT_PLAN
		(
			ACCOUNT_CODE,
			ACCOUNT_NAME,
			SUB_ACCOUNT,
		<cfif session.ep.our_company_info.is_ifrs eq 1>
			IFRS_CODE,
			IFRS_NAME,
			ACCOUNT_CODE2,
			ACCOUNT_NAME2,
		</cfif>			
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE
		)
		VALUES
		(
			'#Trim(attributes.ACCOUNT_CODE)#',
			'#attributes.ACCOUNT_NAME#',
			0,
		<cfif session.ep.our_company_info.is_ifrs eq 1>
			<cfif isdefined('attributes.ifrs_code') and len(attributes.ifrs_code)>'#attributes.ifrs_code#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ifrs_name') and len(attributes.ifrs_name)>'#attributes.ifrs_name#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.account_code2') and len(attributes.account_code2)>'#attributes.account_code2#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.account_name2') and len(attributes.account_name2)>'#attributes.account_name2#'<cfelse>NULL</cfif>,
		</cfif>
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#',
			#now()#			
		)
	</cfquery>

	<!--- Hesap Plan Bilgileri Servis ile Farklı W3' e Gönderilecek İse Bu Blok Çalışır --->
	<cfset create_accounter_wex = createObject("component","WEX.accounter.components.WorkcubetoAccounter").init( sessions: session_base )>
	<cfset comp_info = create_accounter_wex.COMP_INFO()>
	<cfif isdefined("comp_info") and comp_info.IS_ACCOUNTER_INTEGRATED eq 1 and len( comp_info.ACCOUNTER_DOMAIN ) and len( comp_info.ACCOUNTER_KEY )>
		<cfset get_result = create_accounter_wex.WRK_PLAN_TO_ACCOUNTER( account_code : attributes.account_code )>
		<cfif get_result.STATUS >
			<script>
				alert("<cfoutput>#get_result.MESSAGE#</cfoutput>");
			</script>
		<cfelse>
			<script>
				alert("<cfoutput>#get_result.MESSAGE#</cfoutput>");
			</script>
		</cfif>
	</cfif>
	<!--- Hesap Plan Bilgileri Servis ile Farklı W3' e Gönderilecek İse Bu Blok Çalışır --->

	<cfif len(url_string)>
		<cflocation url="#request.self#?fuseaction=objects.popup_account_plan#url_string#&account_code=#attributes.account_code#" addtoken="No">	
	<cfelse>
		<script type="text/javascript">
			wrk_opener_reload();
			window.close();
		</script>
	</cfif>
</cfif>

<cfset attributes.sub_account_name=replacelist(attributes.sub_account_name,"',"""," ")><!--- hesap adına tek ve cift tirnak yazilmamali --->
<cfif isDefined('attributes.db_source') and isDefined('attributes.period_year') and len(attributes.db_source) and len(attributes.period_year)>
	<cfset DSN2 = dsn&'_'&attributes.period_year&'_'&attributes.db_source>
</cfif>
<cfscript>
	url_string = "&form_submitted=1";
	if(isdefined("attributes.field_id") and len(attributes.field_id))
		url_string = "#url_string#&field_id=#attributes.field_id#";
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
		url_string = "#url_string#&account_code=#URLEncodedFormat(attributes.search_account_code)#";
	else if(isdefined("attributes.sub_account_code") and len(attributes.sub_account_code))
		url_string = "#url_string#&account_code=#URLEncodedFormat(attributes.account_code & "." & attributes.sub_account_code)#";	

	
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
<cfquery name="CHECK" datasource="#db_source#">
	SELECT ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#ACCOUNT_CODE#.#SUB_ACCOUNT_CODE#'
</cfquery>

<cfif check.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='64421.Bu Hesap Kodu Başka Bir Hesap Tarafından Kullanılıyor Lütfen Kontrol Ediniz'>!");
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfquery name="GET_CHECK" datasource="#db_source#">
		SELECT
			ACCOUNT_ID
		FROM
			ACCOUNT_CARD_ROWS
		WHERE 
			ACCOUNT_ID = '#ACCOUNT_CODE#'	
	</cfquery>
	
	<cfif get_check.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='64422.Üst Hesap ile daha önce İşlem yapılmış.Hesabı Başka Bir Hesaba Aktarınız!'>");
			history.back();
		</script>
		<cfabort>
	<cfelse> 
		<cfquery name="ADD_ACCOUNT" datasource="#db_source#">
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
				'#account_code#.#trim(sub_account_code)#',
				'#attributes.sub_account_name#',
				0,
			<cfif session.ep.our_company_info.is_ifrs eq 1>
				<cfif isdefined('attributes.ifrs_code') and len(attributes.ifrs_code)>'#attributes.ifrs_code#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.ifrs_name') and len(attributes.ifrs_name)>'#attributes.ifrs_name#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.account_code2') and len(attributes.account_code2)>'#attributes.account_code2#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.account_name2') and len(attributes.account_name2)>'#attributes.account_name2#'<cfelse>NULL</cfif>,
			</cfif>
				#session.ep.userid#,
				'#cgi.remote_addr#',
				#now()#
			)
		</cfquery>
		<cfquery name="UPD_MAIN_ACCOUNT" datasource="#db_source#">
			UPDATE 
				ACCOUNT_PLAN 
			SET	
				SUB_ACCOUNT = 1,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_DATE = #now()#
			WHERE 
				ACCOUNT_CODE = '#account_code#'
		</cfquery>

		<!--- Hesap Plan Bilgileri Servis ile Farklı W3' e Gönderilecek İse Bu Blok Çalışır --->
		<cfset create_accounter_wex = createObject("component","WEX.accounter.components.WorkcubetoAccounter").init( sessions: session_base )>
		<cfset comp_info = create_accounter_wex.COMP_INFO()>
		<cfif isdefined("comp_info") and comp_info.IS_ACCOUNTER_INTEGRATED eq 1 and len( comp_info.ACCOUNTER_DOMAIN ) and len( comp_info.ACCOUNTER_KEY )>
			<cfset get_result = create_accounter_wex.WRK_PLAN_TO_ACCOUNTER( account_code : account_code )>
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

	</cfif>	
</cfif>

<cfif isdefined("attributes.nereden_geldi") and attributes.nereden_geldi eq 3>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
      window.location.href="<cfoutput>#request.self#?fuseaction=objects.popup_account_plan#url_string#</cfoutput>";
    </script>
</cfif>



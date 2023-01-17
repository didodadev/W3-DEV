 <!--- islem yapilan donem session dakine uygun mu? --->
<cfif form.active_period neq session.ep.period_id>	
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.close();
	</script>
	<cfabort>
</cfif>

<cfif attributes.birlestir eq 1>
	<cfset new_acc_code= "#first_line#.#trim(attributes.account_code)#">
<cfelse>
	<cfset new_acc_code = trim(attributes.account_code)>
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
<cfif len(new_acc_code) lt 3 >
	<script type="text/javascript">
		alert("Hesap Kod Uzunluğu Hatalı!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfif new_acc_code neq form.old_account>
	<cfquery name="get_new" datasource="#db_source#">
		SELECT ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#new_acc_code#'	
	</cfquery>
	<cfif get_new.recordcount>
		<script type="text/javascript">
			alert("Tanımladığınız Muhasebe Kodu Sistemde vardır!");
			history.back();
		</script>
		<cfabort>	
	</cfif>
</cfif>
<cfquery name="UPD_ACCOUNT" datasource="#db_source#">
	UPDATE
		ACCOUNT_PLAN 
	SET
		<cfif not sub_account>
			ACCOUNT_CODE = '#new_acc_code#',
		</cfif>		
		ACCOUNT_NAME = '#ACCOUNT_NAME#',
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_DATE = #now()#
	WHERE
		ACCOUNT_ID = #form.account_id#
</cfquery>
<cfif not sub_account>
	<cfquery name="SUB_ACCOUNTS" datasource="#db_source#">
		UPDATE
			ACCOUNT_CARD_ROWS
		SET
			ACCOUNT_ID = '#new_acc_code#'
		WHERE
			ACCOUNT_ID ='#form.old_account#'
	</cfquery>
	<cfquery name="SUB_ACCOUNTS" datasource="#db_source#">
		UPDATE
			ACCOUNT_CARD_SAVE_ROWS
		SET
			ACCOUNT_ID = '#new_acc_code#'
		WHERE
			ACCOUNT_ID ='#form.old_account#'
	</cfquery>	
</cfif>

<cflocation url="#request.self#?fuseaction=objects.popup_account_plan#url_string#" addtoken="No">

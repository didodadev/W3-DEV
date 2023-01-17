<cfquery name="CONTROL_ACCOUNT2" datasource="#DSN2#" >
	SELECT
		ACCOUNT_CODE
	FROM
		ACCOUNT_PLAN
	WHERE
		ACCOUNT_CODE LIKE '#attributes.OLD_ACCOUNT#.%'
</cfquery>
<cfif CONTROL_ACCOUNT2.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang no='93.Bu Muhasebe Koduna Ait Alt Hesap Bulunmaktadır!'>");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="CONTROL_ACCOUNT" datasource="#DSN2#" >
	SELECT
		ACCOUNT_ID
	FROM
		ACCOUNT_CARD_ROWS		
	WHERE
		ACCOUNT_ID = '#attributes.old_account#'	
</cfquery>
<cfif CONTROL_ACCOUNT.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang no='81.Bu Muhasebe Koduna Ait Muhasebe İşlemi Bulunmaktadır'> <cf_get_lang no='79.Silmek İçin İlk Önce Hesap Aktarımı Yapınız !'>");
		window.close();
	</script>
	<cfabort>
</cfif>

<!--- Fiş Bilgileri Servis ile Farklı W3' e Gönderiliyor İse Bu Blok Çalışır --->
<cfset create_accounter_wex = createObject("component","WEX.accounter.components.WorkcubetoAccounter").init( sessions: session_base )>
<cfset comp_info = create_accounter_wex.COMP_INFO()>
<cfif isdefined("comp_info") and comp_info.IS_ACCOUNTER_INTEGRATED eq 1 and len( comp_info.ACCOUNTER_DOMAIN ) and len( comp_info.ACCOUNTER_KEY )>
	<cfset get_result = create_accounter_wex.WRK_PLAN_TO_ACCOUNTER( account_code: listdeleteat(attributes.old_account,listlen(attributes.old_account,"."),".") , event: 'del' )>
</cfif>
<!--- Fiş Bilgileri Servis ile Farklı W3' e Gönderiliyor İse Bu Blok Çalışır --->

<cfquery name="DEL_ACCOUNT" datasource="#dsn2#">
	DELETE FROM	ACCOUNT_PLAN WHERE ACCOUNT_ID = #attributes.ACCOUNT_ID#
</cfquery>
<cfif listlen(attributes.old_account,".") gt 1>
	<cfset upper_code = listdeleteat(attributes.old_account,listlen(attributes.old_account,"."),".")>
	<cfquery name="GET_SUBS" datasource="#dsn2#">
		SELECT
			ACCOUNT_ID
		FROM
			ACCOUNT_PLAN
		WHERE
			ACCOUNT_CODE LIKE '#UPPER_CODE#.%'
	</cfquery>
	<cfif get_subs.recordcount eq 0>
		<cfquery name="UPD_UPPER" datasource="#dsn2#">
			UPDATE
				ACCOUNT_PLAN
			SET
				SUB_ACCOUNT = 0
			WHERE
				ACCOUNT_CODE = '#UPPER_CODE#'
		</cfquery>
	</cfif>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

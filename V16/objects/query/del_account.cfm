<cfquery name="CONTROL_ACCOUNT2" datasource="#DSN2#" >
	SELECT
		ACCOUNT_CODE
	FROM
		ACCOUNT_PLAN	
	WHERE
		ACCOUNT_CODE LIKE '#attributes.old_account#.%'
</cfquery>

<cfif control_account2.recordcount>
	<script type="text/javascript">
		alert('Bu Muhasebe Koduna Ait Alt Hesap Bulunmaktadır!');
		window.close();
	</script>
	<cfabort>
</cfif>

<cfquery name="CONTROL_ACCOUNT" datasource="#DSN2#">
	SELECT
		ACCOUNT_ID
	FROM
		ACCOUNT_CARD_ROWS		
	WHERE
		ACCOUNT_ID = '#attributes.old_account#'	
</cfquery>

<cfif control_account.recordcount>
	<script type="text/javascript">
		alert('Bu Muhasebe Koduna Ait Muhasebe İşlemi Bulunmaktadır\r Silmek İçin İlk Önce Hesap Aktarımı Yapınız!');
		window.close();
	</script>
	<cfabort>
</cfif>

<cfset url_string = "">
<cfif isdefined("field_id")>
	<cfset url_string = "#url_string#&field_id=#field_id#">
</cfif>
<cfif isdefined("field_name")>
	<cfset url_string = "#url_string#&field_name=#field_name#">
</cfif>
<cfif isdefined("code")>
	<cfset url_string = "#url_string#&code=#code#">
</cfif>
<cfquery name="DEL_ACCOUNT" datasource="#dsn2#">
	DELETE FROM ACCOUNT_PLAN WHERE ACCOUNT_ID = #attributes.account_id#
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
			UPDATE ACCOUNT_PLAN SET SUB_ACCOUNT = 0	WHERE ACCOUNT_CODE = '#UPPER_CODE#'
		</cfquery>
	</cfif>
</cfif>

<cflocation url="#request.self#?fuseaction=objects.popup_account_plan#url_string#" addtoken="No">

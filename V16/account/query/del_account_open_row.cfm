<cfset actionDate = "01/01/#SESSION.EP.PERIOD_YEAR#">
<cf_date tarih='actionDate'>
<!--- e-defter islem kontrolu FA --->
<cfif session.ep.our_company_info.is_edefter eq 1>
    <cfstoredproc procedure="GET_NETBOOK" datasource="#DSN2#">
    	<cfprocparam cfsqltype="cf_sql_timestamp" value="#actionDate#">
        <cfprocparam cfsqltype="cf_sql_timestamp" value="#actionDate#">
        <cfprocparam cfsqltype="cf_sql_varchar" value="">
        <cfprocresult name="getNetbook">
    </cfstoredproc>
	<cfif getNetbook.recordcount>
		<script language="javascript">
            alert('<cf_get_lang dictionary_id="63221.Muhasebeci : İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.">');
			history.back();
        </script>
        <cfabort>
    </cfif>
</cfif>
<cfquery name="DEL_ACC_ROWS" datasource="#DSN2#">
	DELETE
	FROM
		ACCOUNT_CARD_ROWS
	WHERE
		CARD_ID=#ATTRIBUTES.CARD_ID# AND
		ACCOUNT_ID = '#attributes.acc_code#' AND
		CARD_ROW_ID =#CARD_ROW_ID#
</cfquery>
<cfquery name="DEL_ACC_ROWS" datasource="#DSN2#">
	DELETE
	FROM
		ACCOUNT_ROWS_IFRS
	WHERE
		CARD_ID=#ATTRIBUTES.CARD_ID# AND
		ACCOUNT_ID = '#attributes.acc_code#' AND
		CARD_ROW_ID =#CARD_ROW_ID#
</cfquery>
<cfquery name="DEL_ACC_ROWS_MONEY" datasource="#DSN2#">
	DELETE FROM ACCOUNT_CARD_ROWS_MONEY WHERE ACTION_ID=#attributes.card_id# AND ACTION_ROW_ID=#CARD_ROW_ID#
</cfquery>
<cf_add_log employee_id="#session.ep.userid#" log_type="-1" action_id="#CARD_ROW_ID#" action_name="#attributes.acc_code# Silindi" paper_no="#attributes.acc_code#" period_id="#session.ep.period_id#">
<script language="JavaScript">
	<cfif not isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
</script> 


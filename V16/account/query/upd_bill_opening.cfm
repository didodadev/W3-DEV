<!--- <cfinclude template="get_account_plan.cfm"> --->
<!--- account_card add --->
<cfif isDefined('session.ep.period_start_date') and len(session.ep.period_start_date)>
	<cfset attributes.open_date= dateformat(session.ep.period_start_date,dateformat_style)>
<cfelse>
    <cfset attributes.open_date= dateformat(session.ep.period_date,dateformat_style)>
</cfif>
<cf_date tarih='attributes.open_date'>
<!--- e-defter islem kontrolu FA --->
<cfif session.ep.our_company_info.is_edefter eq 1>
    <cfstoredproc procedure="GET_NETBOOK" datasource="#DSN2#">
    	<cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.open_date#">
        <cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.open_date#">
        <cfprocparam cfsqltype="cf_sql_varchar" value="">
        <cfprocresult name="getNetbook">
    </cfstoredproc>
	<cfif getNetbook.recordcount>
		<script language="javascript">
            alert('Muhasebeci : İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.');
			history.back();
        </script>
        <cfabort>
    </cfif>
</cfif>
<!--- e-defter islem kontrolu FA --->

<cfinclude template="get_acc_process_cat.cfm"><!---işlem kategorisi--->
<cfquery name="ADD_ACCOUNT_CARD" datasource="#DSN2#">
	UPDATE
		ACCOUNT_CARD
	SET
		CARD_DETAIL = '#attributes.BILL_DETAIL#',
		CARD_TYPE = <cfif isdefined('acc_process_type') and len(acc_process_type)>#acc_process_type#<cfelse>10</cfif>,
		CARD_CAT_ID = <cfif isdefined('form.process_cat') and len(form.process_cat)>#form.process_cat#<cfelse>0</cfif>,
        CARD_DOCUMENT_TYPE = <cfif len(get_process_type.document_type)>#get_process_type.document_type#<cfelse>NULL</cfif>,
        CARD_PAYMENT_METHOD = <cfif len(get_process_type.payment_type)>#get_process_type.payment_type#<cfelse>NULL</cfif>,
		UPDATE_DATE= #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP= '#CGI.REMOTE_ADDR#'
	WHERE
		CARD_ID=#ATTRIBUTES.CARD_ID#
</cfquery>
 <cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#ATTRIBUTES.CARD_ID#" action_name= "#form.BILL_NO# Güncellendi" paper_no= "#form.BILL_NO#" period_id="#session.ep.period_id#" process_type="#acc_process_type#" data_source="#dsn2#">
<cfif attributes.fuseaction eq 'account.emptypopup_upd_bill_opening_act'> 
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script> 
	<cfabort>
<cfelse>
	<cflocation url="#request.self#?fuseaction=account.list_cards" addtoken="no">
</cfif>
    

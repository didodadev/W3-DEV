<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=account.list_cards</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfif isDefined('session.ep.period_start_date') and len(session.ep.period_start_date)>
	<cfset acc_card_date_= dateformat(session.ep.period_start_date,dateformat_style)>
<cfelse>
	<cfset acc_card_date_= dateformat(session.ep.period_date,dateformat_style)>
</cfif>
<cf_date tarih='acc_card_date_'>
<cfinclude template="get_acc_process_cat.cfm"><!---işlem kategorisi--->
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfinclude template="../query/get_bill_no.cfm">
		<cfif not get_bill_no.recordcount>
			<script type="text/javascript">
				alert('Muhasebe Tanımlarından Fiş Numaralarını Giriniz!');
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfquery name="ADD_ACCOUNT_CARD" datasource="#dsn2#" result="MAX_ID">
			INSERT INTO
				ACCOUNT_CARD
				(
                    CARD_DETAIL,
                    BILL_NO,
                    CARD_TYPE,
                    CARD_CAT_ID,
                    ACTION_DATE,
                    CARD_DOCUMENT_TYPE,
                    CARD_PAYMENT_METHOD,
                    RECORD_EMP,
                    RECORD_IP,
                    RECORD_DATE
				)
			VALUES
				(
					<cfif isdefined('attributes.bill_detail') and len(attributes.bill_detail)>'#attributes.bill_detail#'<cfelse>'Açılış Fişi'</cfif>,
                    #get_bill_no.BILL_NO#,
                    <cfif isdefined('acc_process_type') and len(acc_process_type)>#acc_process_type#<cfelse>10</cfif>,
                    #form.process_cat#,
                    #acc_card_date_#,
                    <cfif len(get_process_type.document_type)>#get_process_type.document_type#<cfelse>NULL</cfif>,
                    <cfif len(get_process_type.payment_type)>#get_process_type.payment_type#<cfelse>NULL</cfif>,
                    #SESSION.EP.USERID#,
                    '#CGI.REMOTE_ADDR#',
                    #NOW()#
				)
		</cfquery>
		<cfset max_acc_card_id = MAX_ID.IDENTITYCOL>
		<cfquery name="UPD_BILL_NO" datasource="#dsn2#">
			UPDATE BILLS SET BILL_NO = BILL_NO+1
		</cfquery>
	</cftransaction>
    <cf_add_log employee_id="#session.ep.userid#" log_type="1" action_id="#form.process_cat#" action_name= "#get_bill_no.BILL_NO# Eklendi" paper_no= "#get_bill_no.BILL_NO#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
</cflock>
<script type="text/javascript">
		<cfif not isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
</script>

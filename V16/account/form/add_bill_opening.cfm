<cfinclude template="../query/control_bill_no.cfm">
<cfquery name="CONTROL_ACC_PROCESS_" datasource="#dsn3#"> <!---fiş türüne ait default olarak tanımlanmış işlem kategorisi bulunuyor --->
	SELECT
		PROCESS_CAT_ID,
        PROCESS_TYPE,
        PROCESS_CAT
	FROM
		SETUP_PROCESS_CAT
	WHERE
		PROCESS_TYPE=10
		AND IS_DEFAULT=1		
</cfquery>
<cfif not control_acc_process_.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='56769.Standart Açılış Fişi İşlem Kategorisi Tanımlı Değil'>! <cf_get_lang dictionary_id='56845.İşlem Kategorileri Bölümünde Fiş Tanımlarınızı Yapınız'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_account_open_card" datasource="#dsn2#">
	SELECT 
		CARD_ID 
	FROM
		ACCOUNT_CARD 
	WHERE	
		CARD_TYPE = #CONTROL_ACC_PROCESS_.PROCESS_TYPE#
		AND CARD_CAT_ID = #CONTROL_ACC_PROCESS_.PROCESS_CAT_ID#
</cfquery>
<cfif not get_account_open_card.RECORDCOUNT>
	<cfif isDefined('session.ep.period_start_date') and len(session.ep.period_start_date)>
        <cfset open_date= dateformat(session.ep.period_start_date,dateformat_style)>
    <cfelse>
        <cfset open_date= dateformat(session.ep.period_date,dateformat_style)>
    </cfif>
	<cf_date tarih='open_date'>
    <!--- e-defter islem kontrolu FA --->
	<cfif session.ep.our_company_info.is_edefter eq 1>
        <cfstoredproc procedure="GET_NETBOOK" datasource="#DSN2#">
            <cfprocparam cfsqltype="cf_sql_timestamp" value="#open_date#">
            <cfprocparam cfsqltype="cf_sql_timestamp" value="#open_date#">
            <cfprocparam cfsqltype="cf_sql_varchar" value="">
            <cfprocresult name="getNetbook">
        </cfstoredproc>
        <cfif getNetbook.recordcount>
            <script language="javascript">
                alert("<cf_get_lang dictionary_id='56853.Muhasebeci'> : <cf_get_lang dictionary_id='52606.İşlemi yapamazsınız'>. <cf_get_lang dictionary_id='51859.İşlem tarihine ait e-defter bulunmaktadır'>");
                history.back();
            </script>
            <cfabort>
        </cfif>
    </cfif>
    <!--- e-defter islem kontrolu FA --->
	<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfinclude template="../query/get_bill_no.cfm">
		<cfif not get_bill_no.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='51242.Muhasebe Tanımlarından Fiş Numaralarını Giriniz'>!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfquery name="CONTROL_ACC_CARD_PROCESS_" datasource="#dsn2#"> <!---fiş türüne ait default olarak tanımlanmış işlem kategorisi bulunuyor --->
			SELECT
				PROCESS_CAT_ID,
                PROCESS_CAT,
				PROCESS_TYPE,
                DISPLAY_FILE_NAME,
				DISPLAY_FILE_FROM_TEMPLATE,
                DOCUMENT_TYPE,
                PAYMENT_TYPE
			FROM
				#dsn3_alias#.SETUP_PROCESS_CAT
			WHERE
				PROCESS_TYPE = 10
				AND IS_DEFAULT = 1		
		</cfquery>
		<cfif not len(CONTROL_ACC_CARD_PROCESS_.PROCESS_CAT_ID)>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='56855.Açılış Fişi Tanımı Yapılmamış'>.<cf_get_lang dictionary_id='56845.İşlem Kategorileri Bölümünde Fiş Tanımlarınızı Yapınız'>!");
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
                    'Açılış Fişi',
                    #get_bill_no.bill_no#,
                    #control_acc_card_process_.process_type#,
                    #control_acc_card_process_.process_cat_id#,
                    #open_date#,
                    <cfif len(control_acc_card_process_.document_type)>#control_acc_card_process_.document_type#<cfelse>NULL</cfif>,
                    <cfif len(control_acc_card_process_.payment_type)>#control_acc_card_process_.payment_type#<cfelse>NULL</cfif>,
                    #session.ep.userid#,
                    '#cgi.remote_addr#',
                    #now()#
				)
		</cfquery>
		<cfset acilis_card_id = MAX_ID.IDENTITYCOL>
		<cfquery name="UPD_BILL_NO" datasource="#dsn2#">
			UPDATE BILLS SET BILL_NO = BILL_NO+1
		</cfquery>
	</cftransaction>
	</cflock>
<cfelse>
	<cfif isdefined("attributes.card_id")>
		<cfset acilis_card_id = attributes.CARD_ID>
	<cfelse>
		<cfset acilis_card_id = get_account_open_card.CARD_ID>
	</cfif>
</cfif>
<script>
	window.location.href="<cfoutput>#request.self#?fuseaction=account.form_upd_bill_opening&var_=opening_card&CARD_ID=#acilis_card_id#</cfoutput>";
</script>
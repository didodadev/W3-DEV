<cfsetting showdebugoutput="no">
<cfparam name="attributes.x_puantaj_lock_permission" default="">
<cfif attributes.lock eq 1>
	<cfquery name="get_" datasource="#dsn#">
		SELECT 
    	    PUANTAJ_ID, 
            SAL_MON, 
            SAL_YEAR, 
            IS_ACCOUNT, 
            IS_LOCKED, 
            SSK_OFFICE, 
            SSK_OFFICE_NO, 
            RECORD_DATE, 
            RECORD_IP, 
            RECORD_EMP, 
            PUANTAJ_TYPE 
        FROM 
	        EMPLOYEES_PUANTAJ 
        WHERE 
        	PUANTAJ_ID = #attributes.PUANTAJ_ID#
	</cfquery>
	<cfquery name="UPD_PUANTAJ_LOCK_STATUS" datasource="#DSN#">
		UPDATE
			EMPLOYEES_PUANTAJ
		SET
			IS_LOCKED = 0
		WHERE
			PUANTAJ_ID = #attributes.PUANTAJ_ID#
	</cfquery>
	<cf_add_log log_type="1" action_id="#attributes.PUANTAJ_ID#" action_name="#get_.ssk_office# - #get_.ssk_office_no# / #get_.sal_year# - #get_.sal_mon#   Puantaj Kilit Açıldı.">
<cfelseif attributes.lock eq 0>
	<cfquery name="get_" datasource="#dsn#">
		SELECT 
    	    PUANTAJ_ID, 
            SAL_MON, 
            SAL_YEAR, 
            IS_ACCOUNT, 
            IS_LOCKED, 
            SSK_OFFICE, 
            SSK_OFFICE_NO, 
            RECORD_DATE, 
            RECORD_IP, 
            RECORD_EMP, 
            PUANTAJ_TYPE 
        FROM
	        EMPLOYEES_PUANTAJ 
        WHERE 
        	PUANTAJ_ID = #attributes.PUANTAJ_ID#
	</cfquery>
	<cfquery name="UPD_PUANTAJ_LOCK_STATUS" datasource="#DSN#">
		UPDATE
			EMPLOYEES_PUANTAJ
		SET
			IS_LOCKED = 1
		WHERE
			PUANTAJ_ID = #attributes.PUANTAJ_ID#
	</cfquery>
	<cf_add_log  log_type="1" action_id="#attributes.PUANTAJ_ID#" action_name="#get_.ssk_office# - #get_.ssk_office_no# / #get_.sal_year# - #get_.sal_mon#  Puantaj Kilitlendi.">
</cfif>
<script type="text/javascript">
	adres_menu_1 = '<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_ajax_menu_puantaj_sube&puantaj_id=#attributes.PUANTAJ_ID#&x_select_process=#x_select_process#&x_puantaj_lock_permission=#attributes.x_puantaj_lock_permission#&x_payment_day=#x_payment_day#&branch_id=#attributes.branch_id#</cfoutput>';
	AjaxPageLoad(adres_menu_1,'menu_puantaj_1','1','Puantaj Menüsü Yükleniyor');
	
	adres_ = '<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_ajax_view_puantaj&puantaj_id=#attributes.PUANTAJ_ID#&branch_or_user_=1&x_select_process=#x_select_process#&x_puantaj_lock_permission=#attributes.x_puantaj_lock_permission#&branch_id=#attributes.branch_id#</cfoutput>';
	AjaxPageLoad(adres_,'puantaj_list_layer','1','Puantaj Listeleniyor');
</script>

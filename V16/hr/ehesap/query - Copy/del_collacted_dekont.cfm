<cfquery name="get_puantaj" datasource="#dsn#">
	SELECT 
    	PUANTAJ_ID, 
        SAL_YEAR,
        SAL_MON, 
        SSK_OFFICE, 
        SSK_OFFICE_NO,
        SSK_BRANCH_ID,
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP
    FROM 
	    EMPLOYEES_PUANTAJ 
    WHERE 
    	PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_id#">
</cfquery>
<cfquery name="get_company" datasource="#dsn#">
	SELECT COMPANY_ID FROM BRANCH WHERE BRANCH_ID = #get_puantaj.SSK_BRANCH_ID# AND SSK_OFFICE = '#get_puantaj.SSK_OFFICE#' AND SSK_NO = '#get_puantaj.SSK_OFFICE_NO#'
</cfquery>
<cfquery name="get_period" datasource="#dsn#">
	SELECT 
    	PERIOD_ID, 
        PERIOD, 
        PERIOD_YEAR, 
        OUR_COMPANY_ID, 
        OTHER_MONEY, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP
    FROM 
    	SETUP_PERIOD 
    WHERE 
	    OUR_COMPANY_ID = #get_company.COMPANY_ID# 
   		AND (PERIOD_YEAR = #get_puantaj.sal_year# OR YEAR(FINISH_DATE) = #get_puantaj.sal_year#)
        AND (FINISH_DATE IS NULL OR (FINISH_DATE IS NOT NULL AND FINISH_DATE >= #createdate(get_puantaj.sal_year,get_puantaj.sal_mon,1)#))
</cfquery>
<cfif get_period.recordcount eq 0>
	<script type="text/javascript">
		alert("İlgili Şubenin Muhasebe Dönemi Tanımlı Değil.\rMuhasebe Döneminizi Kontrol Ediniz!");
		history.back();	
	</script>
	<cfabort>
<cfelse>
	<cfset new_dsn2 = '#dsn#_#get_period.period_year#_#get_company.COMPANY_ID#'>
</cfif>
<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="GET_ALL_DEKONT" datasource="#new_dsn2#">
			SELECT DEKONT_ROW_ID FROM #dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS_ROW WHERE DEKONT_ID = #attributes.dekont_id#
		</cfquery>
		<cfquery name="GET_TRANSFER" datasource="#new_dsn2#">
			SELECT BANK_ACTION_MULTI_ID, BANK_PERIOD_ID FROM #dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS WHERE DEKONT_ID = #attributes.dekont_id#
		</cfquery>
		<cfscript>
			for (k = 1; k lte get_all_dekont.recordcount;k=k+1)
			{
				cari_sil(action_id:get_all_dekont.DEKONT_ROW_ID[k],process_type:attributes.process_type,cari_db : new_dsn2);
				butce_sil(action_id:get_all_dekont.DEKONT_ROW_ID[k],process_type:attributes.process_type,muhasebe_db:new_dsn2);
			}
		</cfscript>
		<cfquery name="DEL_DEKONT" datasource="#new_dsn2#">
			DELETE FROM #dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS WHERE DEKONT_ID = #attributes.dekont_id#
		</cfquery>
		<cfquery name="DEL_DEKONT_ROW" datasource="#new_dsn2#">
			DELETE FROM #dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS_ROW WHERE DEKONT_ID = #attributes.dekont_id#
		</cfquery>
		<cfquery name="DEL_MONEY" datasource="#new_dsn2#">
			DELETE FROM #dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS_MONEY WHERE ACTION_ID = #attributes.dekont_id#
		</cfquery>	
		<cfif len(GET_TRANSFER.BANK_ACTION_MULTI_ID)>  <!---ilgili havale kayıtları siliniyor --->
			<cfquery name="get_all_action" datasource="#new_dsn2#">
				SELECT ACTION_ID,ACTION_TYPE_ID FROM BANK_ACTIONS WHERE MULTI_ACTION_ID = #GET_TRANSFER.BANK_ACTION_MULTI_ID#
			</cfquery>
			<!--- havale kayıtlarının cari ve bütçe hareketleri siliniyor --->
			<cfscript>
				for (k = 1; k lte get_all_action.recordcount;k=k+1)
				{
					cari_sil(action_id:get_all_action.action_id[k],process_type:get_all_action.action_type_id[k]);
					butce_sil(action_id:get_all_action.action_id[k],process_type:get_all_action.action_type_id[k]);
				}
			</cfscript>
			<cfquery name="del_all_actions" datasource="#new_dsn2#">
				DELETE FROM BANK_ACTIONS WHERE MULTI_ACTION_ID = #GET_TRANSFER.BANK_ACTION_MULTI_ID#
			</cfquery>
			<cfscript>
				muhasebe_sil(action_id:GET_TRANSFER.BANK_ACTION_MULTI_ID,process_type:250);
			</cfscript>		
			<cfquery name="del_action_money" datasource="#new_dsn2#">
				DELETE FROM BANK_ACTION_MULTI_MONEY WHERE ACTION_ID=#GET_TRANSFER.BANK_ACTION_MULTI_ID#
			</cfquery>
			<cfquery name="del_from_bank_actions" datasource="#new_dsn2#">
				DELETE FROM BANK_ACTIONS_MULTI WHERE MULTI_ACTION_ID = #GET_TRANSFER.BANK_ACTION_MULTI_ID#
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	opener.open_form_ajax(1);
	window.close();
</script>

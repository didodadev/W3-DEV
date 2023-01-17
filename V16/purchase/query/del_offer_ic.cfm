<!--- del_offer.cfm sayfasinda include edilerek kullaniliyor, transactionlardan kurtarmak amaciyla ic sayfaya alindi FBS 20130220 --->
<cfscript>
	add_relation_rows(
		action_type:'del',
		action_dsn : '#dsn3#',
		to_table:'OFFER',
		to_action_id : attributes.offer_id
		);
</cfscript>
<!--- Teklif iç talep baglantısı siliniyor --->
<cfquery name="DEL_ORDER_RESERVE" datasource="#dsn3#">
	DELETE FROM INTERNALDEMAND_RELATION_ROW WHERE TO_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>
<!--- urun asortileri siliniyor --->
<cfquery name="DEL_OFFER_ASSORT_ROWS" datasource="#DSN3#">
	DELETE FROM
		PRODUCTION_ASSORTMENT
	WHERE
		ACTION_TYPE = 1 AND 
		ASSORTMENT_ID IN ( SELECT OFFER_ROW_ID FROM OFFER_ROW WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#"> )
</cfquery>
<cfquery name="DEL_OFFER_ROW" datasource="#dsn3#">
	DELETE OFFER_ROW WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>
<cfquery name="DEL_OFFER" datasource="#dsn3#">
	DELETE OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>
<!--- rezerv işlemleri siliniyor --->
<cfif len(get_process.PROCESS_CAT)>
<cfscript>
	butce_sil(action_id:attributes.offer_id,process_type:get_type.PROCESS_TYPE,muhasebe_db:dsn3,reserv_type:1);
</cfscript>
</cfif>

<!--- History Kayitlari Silinir --->
<cfquery name="Del_History_Row" datasource="#dsn3#">
	DELETE FROM OFFER_ROW_HISTORY WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>
<cfquery name="Del_History" datasource="#dsn3#">
	DELETE FROM OFFER_HISTORY WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>
<!--- Belge Silindiginde Bagli Uyari/Onaylar Da Silinir --->
<cfquery name="Del_Relation_Warnings" datasource="#dsn3#">
	DELETE FROM #dsn_alias#.PAGE_WARNINGS WHERE ACTION_TABLE = 'OFFER' AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cf_add_log  log_type="-1" action_id="#attributes.offer_id#" action_name="#get_process.OFFER_HEAD#" paper_no="#get_process.OFFER_NUMBER#" process_stage="#get_process.OFFER_STAGE#" data_source="#dsn3#">

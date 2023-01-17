<!--- del_internaldemand.cfm sayfasinda include edilerek kullaniliyor, transactionlardan kurtarmak amaciyla ic sayfaya alindi FBS 20130220 --->
<cfif fusebox.circuit eq 'myhome'>
	<cfset id_ = contentEncryptingandDecodingAES(isEncode:0,content:attributes.id,accountKey:'wrk')>
<cfelse>
    <cfset id_ = attributes.id>
</cfif>
<cfquery name="get_process" datasource="#dsn3#">
	SELECT INTERNAL_NUMBER,INTERNALDEMAND_STAGE,PROCESS_CAT FROM INTERNALDEMAND WHERE INTERNAL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#id_#">
</cfquery>

<cfquery name="DEL_PAPER_RELATION" datasource="#dsn3#">
	DELETE FROM
		#dsn_alias#.PAPER_RELATION
	WHERE
		PAPER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#id_#">
		AND PAPER_TABLE = 'INTERNALDEMAND'
		AND PAPER_TYPE_ID = 3
</cfquery>
<cfquery name="DEL_RELATED_ROS" datasource="#dsn3#">
	DELETE FROM INTERNALDEMAND_RELATION_ROW WHERE TO_INTERNALDEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#id_#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>
<cfquery name="DEL_ROWS" datasource="#dsn3#">
	DELETE FROM INTERNALDEMAND_ROW WHERE I_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#id_#">
</cfquery>
<cfquery name="DEL_DEMAND" datasource="#dsn3#">
	DELETE FROM INTERNALDEMAND WHERE INTERNAL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#id_#">
</cfquery>

<!--- History Kayitlari Silinir --->
<cfquery name="Del_History_Row" datasource="#dsn3#">
	DELETE FROM INTERNALDEMAND_ROW_HISTORY WHERE I_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#id_#">
</cfquery>
<cfquery name="Del_History" datasource="#dsn3#">
	DELETE FROM INTERNALDEMAND_HISTORY WHERE INTERNAL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#id_#">
</cfquery>
<!--- Belge Silindiginde Bagli Uyari/Onaylar Da Silinir --->
<cfquery name="Del_Relation_Warnings" datasource="#dsn3#">
	DELETE FROM #dsn_alias#.PAGE_WARNINGS WHERE ACTION_TABLE = 'INTERNALDEMAND' AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#id_#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfif len(get_process.PROCESS_CAT)> <!--- bütçe rezerv işlemi siliniyor --->
	<cfquery name="get_type" datasource="#dsn3#">
		SELECT PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #get_process.PROCESS_CAT#
	</cfquery>
	<cfscript>
		butce_sil(action_id:id_,process_type:get_type.PROCESS_TYPE,muhasebe_db:dsn3,reserv_type:1);
	</cfscript>
</cfif>

<cf_add_log log_type="-1" action_id="#id_#" action_name="#attributes.head#" paper_no="#get_process.internal_number#" process_stage="#get_process.internaldemand_stage#" data_source="#dsn3#">

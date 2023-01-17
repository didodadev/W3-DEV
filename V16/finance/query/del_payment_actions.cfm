<cf_get_lang_set module_name="finance"><!--- sayfanin en altinda kapanisi var --->
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfif attributes.act_type eq 3>
			<!--- odeme emri ile iliskili talep varsa kayitlar guncellenir, yoksa kayitlar CARI_CLOSED tablosundan silinir --->
			<cfquery name="get_related_demand" datasource="#dsn2#">
				SELECT
					CLOSED_ID
				FROM
					CARI_CLOSED
				WHERE
					CLOSED_ID = #attributes.closed_id# AND
					IS_DEMAND = 1
			</cfquery>
			<cfif get_related_demand.recordcount>
				<cfquery name="UPD_CLOSED_ROW" datasource="#DSN2#">
					UPDATE 
						CARI_CLOSED
					SET 
						IS_ORDER = NULL,
						P_ORDER_DEBT_AMOUNT_VALUE = NULL,
						P_ORDER_CLAIM_AMOUNT_VALUE = NULL,
						P_ORDER_DIFF_AMOUNT_VALUE = NULL
					WHERE
						CLOSED_ID = #attributes.closed_id#
				</cfquery>
				<cfquery name="UPD_CLOSED_ROW" datasource="#DSN2#">
					UPDATE 
						CARI_CLOSED_ROW 
					SET 
						P_ORDER_VALUE = NULL,
						OTHER_P_ORDER_VALUE = NULL
					WHERE
						CLOSED_ID = #attributes.closed_id#
				</cfquery>
				<cf_add_log log_type="-1" action_id="#attributes.closed_id#" action_name="Ödeme Emri" paper_no="#attributes.closed_id#" data_source="#dsn2#">
			<cfelse>
				<cfquery name="DEL_CLOSED_ROW" datasource="#DSN2#">
					DELETE FROM CARI_CLOSED_ROW WHERE CLOSED_ID = #attributes.closed_id#
				</cfquery>
				<cfquery name="DEL_CLOSED" datasource="#DSN2#">
					DELETE FROM CARI_CLOSED WHERE CLOSED_ID = #attributes.closed_id#
				</cfquery>
				<!--- Belge Silindiginde Bagli Uyari/Onaylar Da Silinir --->
				<cfquery name="Del_Relation_Warnings" datasource="#dsn2#">
					DELETE FROM #dsn_alias#.PAGE_WARNINGS WHERE ACTION_TABLE = 'CARI_CLOSED' AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.closed_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				</cfquery>
				<cf_add_log log_type="-1" action_id="#attributes.closed_id#" action_name="Ödeme Emri" paper_no="#attributes.closed_id#" data_source="#dsn2#">
			</cfif>
		<cfelseif ListFind('1,2',attributes.act_type)>
			<cfquery name="DEL_CLOSED_ROW" datasource="#DSN2#">
				DELETE FROM CARI_CLOSED_ROW WHERE CLOSED_ID = #attributes.closed_id#
			</cfquery>
			<cfquery name="DEL_CLOSED" datasource="#DSN2#">
				DELETE FROM CARI_CLOSED WHERE CLOSED_ID = #attributes.closed_id#
			</cfquery>
			<!--- Belge Silindiginde Bagli Uyari/Onaylar Da Silinir --->
			<cfquery name="Del_Relation_Warnings" datasource="#dsn2#">
				DELETE FROM #dsn_alias#.PAGE_WARNINGS WHERE ACTION_TABLE = 'CARI_CLOSED' AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.closed_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			</cfquery>
			<cf_add_log log_type="-1" action_id="#attributes.closed_id#" action_name="Ödeme Talebi" paper_no="#attributes.closed_id#" data_source="#dsn2#">
		</cfif>
	</cftransaction>
</cflock>
	<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_payment_actions_demand&act_type=#attributes.act_type#" addtoken="no">
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

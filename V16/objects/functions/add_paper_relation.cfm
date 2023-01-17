<!---Proje malzeme planlarının iç talep ve siparişle baglantısını tutar. OZDEN 20080711 --->
<!--- PAPER TYPE :  1-ORDERS 
					2-PRO_MATERIAL
					3-INTERNALDEMAND --->
<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="yes">
<cffunction name="add_paper_relation" returntype="boolean" output="false">
	<cfargument name="to_paper_id" required="yes"> <!--- olusturulan belge--->
	<cfargument name="to_paper_table" required="yes"> <!--- olusturulan belgenin tablosu--->
	<cfargument name="to_paper_type" required="yes"><!---olusturulan belgenin type --->
	<cfargument name="from_paper_id"> <!--- baglantılı oldugu belge id si --->
	<cfargument name="from_paper_table"><!--- baglantılı oldugu belgenin tablosu --->
	<cfargument name="from_paper_type"><!--- baglantılı oldugu belgenin type--->
	<cfargument name="action_status" required="yes" type="numeric"><!--- 0: ekleme 1: guncelleme 2: sil--->
	<cfargument name="process_db" required="yes" default="#dsn3#" type="string">
	<cfargument name="process_db_alias" type="string">
	<cfif arguments.process_db is not 'dsn'>
		<cfset arguments.process_db_alias = '#dsn_alias#.'>
	<cfelse>
		<cfset arguments.process_db_alias = ''>
	</cfif>
	<cfif listfind('1,2',arguments.action_status)>
		<!--- guncelleme ve silme islemlerinden cagrıldıgında kayıtlar temizleniyor.--->
		<cfquery name="DEL_INT_RELATION_" datasource="#arguments.process_db#">
			DELETE 
				FROM #arguments.process_db_alias#PAPER_RELATION
			WHERE
				PAPER_ID = #arguments.to_paper_id#
				AND PAPER_TABLE = '#arguments.to_paper_table#'
				AND PAPER_TYPE_ID = #arguments.to_paper_type#
		</cfquery>
	</cfif>
	<cfif listfind('0,1',arguments.action_status)>
		<cfif arguments.to_paper_table is 'ORDERS' and arguments.to_paper_type eq 1>
			<cfquery name="GET_RELATED_PAPER_INFO" datasource="#arguments.process_db#">
				SELECT 
					DISTINCT ROW_PRO_MATERIAL_ID AS RELATED_PAPER_ID
				FROM 
					#dsn3_alias#.ORDER_ROW
				WHERE
					ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.to_paper_id#">
			</cfquery>
		<cfelse>
			<cfquery name="GET_RELATED_PAPER_INFO" datasource="#arguments.process_db#">
				SELECT 
					DISTINCT PRO_MATERIAL_ID AS RELATED_PAPER_ID
				FROM 
					#dsn3_alias#.INTERNALDEMAND_ROW
				WHERE
					I_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.to_paper_id#">
			</cfquery>
		</cfif>
		<cfif GET_RELATED_PAPER_INFO.recordcount>
			<cfset related_action_list_=valuelist(GET_RELATED_PAPER_INFO.RELATED_PAPER_ID)>
		<cfelse>
			<cfset related_action_list_=''>
		</cfif>
	<cfelse>
		<cfset related_action_list_=''>
	</cfif>
	<cfif len(related_action_list_)>
		<cfloop list="#related_action_list_#" index="related_ind_i">
			<cfquery name="ADD_PAPER_RELATION_" datasource="#arguments.process_db#">
				INSERT INTO
					#arguments.process_db_alias#PAPER_RELATION
				(
					PAPER_ID,
					PAPER_TABLE,
					PAPER_TYPE_ID,
					RELATED_PAPER_ID,
					RELATED_PAPER_TABLE,
					RELATED_PAPER_TYPE_ID,
					COMP_ID,
					PERIOD_ID
				)
				VALUES
				(
					#arguments.to_paper_id#,
					'#arguments.to_paper_table#',
					#arguments.to_paper_type#,
					#related_ind_i#,
					<cfif len(arguments.from_paper_table)>'#arguments.from_paper_table#'<cfelse>NULL</cfif>,
					#arguments.from_paper_type#,		
					#session.ep.company_id#,
					#session.ep.period_id#
				)
			</cfquery>
		</cfloop>
	</cfif>
	<cfreturn true>
</cffunction>
</cfprocessingdirective>

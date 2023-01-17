<!--- İç talep belgelerinin (satır bazlı olarak ) depo-sevk, ambar fişi ve satınalma siparişi bağlantılarını tutar.
OZDEN20080704 --->
<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="yes">
<cffunction name="add_internaldemand_row_relation" returntype="boolean" output="false">
	<cfargument name="internaldemand_id" default=""> <!--- ic talep id si --->
	<cfargument name="to_related_action_id" required="yes" default=""> <!--- iç talebin ilişkili oldugu işlemin action_id si --->
	<cfargument name="to_related_action_type" required="yes" default=""><!---iç talep hangi işlemle ilişkilendirilmis  0: satınalma siparişi, 1: depolararası sevk irs. ,2: ambar fişi --->
	<cfargument name="is_related_action_iptal"> <!--- ilgili işlem iptal --->
	<cfargument name="action_status" required="yes" type="numeric"><!--- 0: ekleme 1: guncelleme--->
	<cfargument name="process_db" required="yes" default="#dsn3#" type="string">
	<cfargument name="process_db_alias" type="string">
	<cfif arguments.process_db is not 'dsn3'>
		<cfset arguments.process_db_alias = '#dsn3_alias#.'>
	<cfelse>
		<cfset arguments.process_db_alias = ''>
	</cfif>
	<cfset related_ships = "">
	<cfset related_ship_periods = "">
	<cfif arguments.action_status eq 1>
		<!--- guncelleme ve silme islemlerinden cagrıldıgında kayıtlar temizleniyor.--->
		<cfquery name="DEL_INT_RELATION_" datasource="#arguments.process_db#">
			DELETE 
				FROM #arguments.process_db_alias#INTERNALDEMAND_RELATION_ROW
			WHERE
				<cfif to_related_action_type eq 0> <!--- satınalma siparisi --->
					TO_ORDER_ID = #to_related_action_id#
				<cfelseif to_related_action_type eq 1>
					TO_SHIP_ID = #to_related_action_id#
					AND PERIOD_ID =#session.pda.period_id#
				<cfelseif to_related_action_type eq 2>
					TO_STOCK_FIS_ID =#to_related_action_id#
					AND PERIOD_ID =#session.pda.period_id#
				</cfif>
		</cfquery>
	</cfif>
	<cfif listfind('0,1',arguments.action_status) and not (isdefined('arguments.is_related_action_iptal') and arguments.is_related_action_iptal eq 1) > <!--- ekleme ve guncellemede kayıtlar ekleniyor --->
		<cfloop from="1" to="#attributes.rows_#" index="row_shp_ind">
			<cfif evaluate('attributes.row_kontrol#row_shp_ind#')>
			<cfif (listlen(evaluate("attributes.row_ship_id#row_shp_ind#"),';') eq 2 and evaluate("listfirst(attributes.row_ship_id#row_shp_ind#,';')") neq 0 ) or ( listlen(evaluate("attributes.row_ship_id#row_shp_ind#"),';') eq 1 and evaluate("attributes.row_ship_id#row_shp_ind#") neq 0)>
				<!--- row_ship_id 2 haneli ise interdemand_id;period_id bilgilerini tutar
				row_ship_id 0 olanlar alınmaz cunku bu satırlar manuel eklenmiş urunleri gosterir --->
				<cfquery name="ADD_INTERD_RELATION_ROW_" datasource="#arguments.process_db#">
					INSERT INTO
						#arguments.process_db_alias#INTERNALDEMAND_RELATION_ROW
					(
						INTERNALDEMAND_ID,
						INTERNALDEMAND_ROW_ID,
						PRODUCT_ID,
						STOCK_ID,
						SPECT_VAR_ID,
						SHELF_NUMBER,
						AMOUNT,
						<cfif to_related_action_type eq 0> <!--- satınalma siparisi --->
						TO_ORDER_ID,
						<cfelseif to_related_action_type eq 1>
						TO_SHIP_ID,
						<cfelseif to_related_action_type eq 2>
						TO_STOCK_FIS_ID,
						</cfif>
						DEPARTMENT_ID,
						LOCATION_ID,
						PERIOD_ID
					)
					VALUES
					(
						#evaluate("listfirst(attributes.row_ship_id#row_shp_ind#,';')")#,
					<cfif listlen(evaluate("attributes.row_ship_id#row_shp_ind#"),';') eq 2 and len(listgetat(evaluate("attributes.row_ship_id#row_shp_ind#"),2,';'))>#listgetat(evaluate("attributes.row_ship_id#row_shp_ind#"),2,';')#<cfelse>NULL</cfif>,
						#evaluate('attributes.product_id#row_shp_ind#')#,
						#evaluate('attributes.stock_id#row_shp_ind#')#,
					<cfif isdefined('attributes.spect_id#row_shp_ind#') and len(evaluate('attributes.spect_id#row_shp_ind#'))>#evaluate('attributes.spect_id#row_shp_ind#')#,<cfelse>NULL,</cfif>
					<cfif isdefined('attributes.shelf_number#row_shp_ind#') and len(evaluate('attributes.shelf_number#row_shp_ind#'))>#evaluate('attributes.shelf_number#row_shp_ind#')#,<cfelse>NULL,</cfif>
						#evaluate('attributes.amount#row_shp_ind#')#,
						#to_related_action_id#,
					<cfif to_related_action_type eq 0> <!--- satınalma siparisi--->
						<cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
							#listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
						<cfelseif len(attributes.deliver_dept_id)>
							#attributes.deliver_dept_id#,						
						<cfelse>
							NULL,
						</cfif>
						<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
							#listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
						<cfelseif len(attributes.deliver_loc_id)>
							#attributes.deliver_loc_id#,
						<cfelse>
							NULL,
						</cfif>
					<cfelseif to_related_action_type eq 1> <!--- depolararası sevk--->
						<cfif isdefined('attributes.department_id') and len(attributes.department_id)>#attributes.department_id#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.location_id') and len(attributes.location_id)>#attributes.location_id#<cfelse>NULL</cfif>,
					<cfelse>
						NULL,
						NULL,
					</cfif>
						#session.pda.period_id#
					)
				</cfquery>
			</cfif>
			</cfif>
		</cfloop>
	</cfif>
	<cfreturn true>
</cffunction>
</cfprocessingdirective>

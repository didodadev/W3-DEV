<!--- FATURAYA VEYA IRSALIYEYE CEKILEN KONSINYE IRSALIYE SATIRLARINI KAYDEDER--->
<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="yes">
<cffunction name="add_ship_row_relation" returntype="boolean" output="false">
	<cfargument name="to_related_process_id" required="yes" default=""> <!---to_ship_id aktif donemdeki irsaliye. bu irsaliyeye konsinye irsaliyesi cekilir.--->
	<cfargument name="to_related_process_type"><!--- to_ship_type --->
	<cfargument name="old_related_process_type"><!---old_to_ship_type guncelleme ve silme islemlerinde kullanılır --->
	<cfargument name="ship_related_action_type" required="yes" type="numeric"> <!--- 0: ekleme 1: guncelleme 2: silme --->
	<cfargument name="is_related_action_iptal"> <!--- ilgili işlem iptal --->
	<cfargument name="is_invoice_ship" required="yes" default="1"> <!--- 0: invoice , 1: irsaliye işlemlerinden cagrılıyor --->
	<cfargument name="process_db" required="yes" default="#dsn3#" type="string">
	<cfargument name="process_db_alias" type="string">
	<cfif arguments.process_db is not 'dsn2'>
		<cfset arguments.process_db_alias = '#dsn2_alias#.'>
	<cfelse>
		<cfset arguments.process_db_alias = ''>
	</cfif>
	<cfset related_ships = "">
	<cfset related_ship_periods = "">
	<cfif listfind('1,2',arguments.ship_related_action_type) and len(arguments.to_related_process_id)><!--- guncelleme ve silme islemleri --->
		<!--- guncelleme ve silme islemlerinden cagrıldıgında kayıtlar temizleniyor.--->
		<cfquery name="DEL_SHIP_ROW_RELATION_" datasource="#arguments.process_db#">
			DELETE 
				FROM #arguments.process_db_alias#SHIP_ROW_RELATION
			WHERE
				<cfif is_invoice_ship eq 1>
					TO_SHIP_ID=#arguments.to_related_process_id# AND TO_SHIP_TYPE=#arguments.old_related_process_type#
				<cfelse>
					TO_INVOICE_ID=#arguments.to_related_process_id# AND TO_INVOICE_CAT=#arguments.old_related_process_type#
				</cfif> 
		</cfquery>
		<cfif arguments.is_invoice_ship eq 1><!---fonksiyon irsaliyeden cagrılmıssa --->
			<cfquery name="DEL_SHIP_REL" datasource="#arguments.process_db#">
				DELETE FROM #arguments.process_db_alias#SHIP_TO_SHIP WHERE TO_SHIP_ID=#arguments.to_related_process_id# AND TO_SHIP_TYPE=#arguments.old_related_process_type#
			</cfquery>
		</cfif>
	</cfif>
	<cfif listfind('0,1',arguments.ship_related_action_type) and not (isdefined('arguments.is_related_action_iptal') and arguments.is_related_action_iptal eq 1) 
	and (( is_invoice_ship eq 1 and listfind('71,72,73,74,75,76,77,78,79',arguments.to_related_process_type) ) or is_invoice_ship eq 0)> <!--- ekleme ve guncellemede kayıtlar ekleniyor --->
	<!---irsaliyeden cagrıldıgı durumlar için ship_type kontrolu özellikle eklendi, önce konsinye irs. secip ardından işlem tipi degiştirildiginde olusabilecek sorunları engellemek için --->
		<cfloop from="1" to="#attributes.rows_#" index="row_shp_ind">
			<cfif (listlen(evaluate("attributes.row_ship_id#row_shp_ind#"),';') eq 2 and evaluate("listfirst(attributes.row_ship_id#row_shp_ind#,';')") ) or ( listlen(evaluate("attributes.row_ship_id#row_shp_ind#"),';') eq 1 and evaluate("attributes.row_ship_id#row_shp_ind#") neq 0 and listfind('592',arguments.to_related_process_type) )>
				<!--- row_ship_id 2 haneli ise ship_id;period_id bilgilerini tutar
				hal faturalarında (process_type:592) ise tek hanelidir ve aktif donemden irsaliye cekilir.
				row_ship_id 0 olanlar alınmaz cunku bu satırlar manuel eklenmiş urunleri gosterir --->
				<cfif not listfind(related_ships,evaluate("listfirst(attributes.row_ship_id#row_shp_ind#,';')"))>
					<cfset related_ships = listappend(related_ships,evaluate("listfirst(attributes.row_ship_id#row_shp_ind#,';')"))>
					<cfif listlen(evaluate("attributes.row_ship_id#row_shp_ind#"),';') eq 2>
						<cfset related_ship_periods = listappend(related_ship_periods,evaluate("listlast(attributes.row_ship_id#row_shp_ind#,';')"))>
					<cfelse> 
						<cfset related_ship_periods = listappend(related_ship_periods,session.ep.period_id)>
					</cfif>
				</cfif>
				<cfquery name="ADD_SHIP_ROW_RELATION_" datasource="#arguments.process_db#">
					INSERT INTO
						#arguments.process_db_alias#SHIP_ROW_RELATION
					(
						PRODUCT_ID,
						STOCK_ID,
						SPECT_VAR_ID,
						SHELF_NUMBER,
						AMOUNT,
						SHIP_ID,
						SHIP_PERIOD,
						SHIP_WRK_ROW_ID,
						<cfif arguments.is_invoice_ship eq 1>
						TO_SHIP_ID,
						TO_SHIP_TYPE
						<cfelse>
						TO_INVOICE_ID,
						TO_INVOICE_CAT
						</cfif>
					)
					VALUES
					(
						#evaluate('attributes.product_id#row_shp_ind#')#,
						#evaluate('attributes.stock_id#row_shp_ind#')#,
					<cfif isdefined('attributes.spect_id#row_shp_ind#') and len(evaluate('attributes.spect_id#row_shp_ind#'))>#evaluate('attributes.spect_id#row_shp_ind#')#,<cfelse>NULL,</cfif>
					<cfif isdefined('attributes.shelf_number#row_shp_ind#') and len(evaluate('attributes.shelf_number#row_shp_ind#'))>#evaluate('attributes.shelf_number#row_shp_ind#')#,<cfelse>NULL,</cfif>
						#evaluate('attributes.amount#row_shp_ind#')#,
						#evaluate("listfirst(attributes.row_ship_id#row_shp_ind#,';')")#,
					<cfif listlen(evaluate("attributes.row_ship_id#row_shp_ind#"),';') eq 2>#evaluate("listlast(attributes.row_ship_id#row_shp_ind#,';')")#,<cfelse>#session.ep.period_id#,</cfif>
					<cfif arguments.is_invoice_ship eq 1 and not listfind('71,72,73,74,75,76,77,78,79',arguments.to_related_process_type)>
						<cfif isdefined('attributes.wrk_row_id#row_shp_ind#') and len(evaluate('attributes.wrk_row_id#row_shp_ind#'))>'#wrk_eval('attributes.wrk_row_id#row_shp_ind#')#'<cfelse>NULL</cfif>,	
					<cfelse>
						<cfif isdefined('attributes.wrk_row_relation_id#row_shp_ind#') and len(evaluate('attributes.wrk_row_relation_id#row_shp_ind#'))>'#wrk_eval('attributes.wrk_row_relation_id#row_shp_ind#')#'<cfelse>NULL</cfif>,	
					</cfif>
						#arguments.to_related_process_id#,
						#arguments.to_related_process_type#
					)
				</cfquery>
			</cfif>
		</cfloop>
		<cfif arguments.is_invoice_ship eq 1> <!--- fonksiyon irsaliyeden cagrılmıssa belge bazında irsaliye-irsaliye ilişkisi ekleniyor --->
			<cfif len(related_ships)>
				<cfloop list="#related_ships#" index="ship_i">#listfind(related_ships,ship_i)#
					<cfquery name="ADD_SHIP_TO_SHIP_" datasource="#arguments.process_db#">
						INSERT INTO
							#arguments.process_db_alias#SHIP_TO_SHIP
						(
							TO_SHIP_ID,
							TO_SHIP_TYPE,
							FROM_SHIP_ID,
							FROM_SHIP_PERIOD
						)
						VALUES
						(
							#arguments.to_related_process_id#,
							#arguments.to_related_process_type#,
							#ship_i#,
							#listgetat(related_ship_periods,listfind(related_ships,ship_i))#
						)
					</cfquery>
				</cfloop>
			</cfif>
		</cfif>
	</cfif>
	<cfreturn true>
</cffunction>
</cfprocessingdirective>

<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfinclude template="check_our_period.cfm"> 
<cfif attributes.rows_ eq 0 >
	<script type="text/javascript">
		alert("<cf_get_lang no='4.Ürün Seçmediniz !'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>
	<cfabort>
</cfif>
<cf_date tarih = 'attributes.deliver_date_frm'>
<cf_date tarih = 'attributes.ship_date' >

<cfif not len(attributes.location_id) >
	<cfset attributes.location_id = "NULL">
</cfif>
<cfif not len(attributes.location_in_id) >
	<cfset attributes.location_in_id = "NULL">
</cfif>
 
<cflock name="#CreateUUID()#" timeout="60">
  <cftransaction>
	<cfquery name="ADD_SALE" datasource="#DSN2#" result="MAX_ID">
		INSERT INTO
			SHIP_INTERNAL
		(
			<cfif isDefined('attributes.ship_method') and len(attributes.ship_method)>SHIP_METHOD,</cfif>
			SHIP_DATE,
			<cfif isdate(attributes.deliver_date_frm)>DELIVER_DATE,</cfif>
			PROCESS_STAGE,
			DISCOUNTTOTAL,
			NETTOTAL,
			GROSSTOTAL,
			TAXTOTAL,
			MONEY,
			RATE1,
			RATE2,
			DEPARTMENT_OUT,
			LOCATION_OUT,
			DEPARTMENT_IN,
			LOCATION_IN,
			DETAIL,
			RECORD_DATE,
			RECORD_EMP,
			PAPER_NO
		)
		VALUES
		(
			<cfif isDefined('attributes.ship_method') and len(attributes.ship_method)>#attributes.ship_method#,</cfif>
			#attributes.ship_date#,
			<cfif isdate(attributes.deliver_date_frm)>#attributes.deliver_date_frm#,</cfif>
			#attributes.process_stage#,
			<cfif isdefined("attributes.BASKET_DISCOUNT_TOTAL")>0#attributes.BASKET_DISCOUNT_TOTAL#<cfelse>0</cfif>,
			<cfif isdefined("attributes.basket_net_total")>0#attributes.basket_net_total#<cfelse>0</cfif>,
			<cfif isdefined("attributes.basket_gross_total")>0#attributes.basket_gross_total#<cfelse>0</cfif>,
			<cfif isdefined("attributes.basket_tax_total")>0#attributes.basket_tax_total#<cfelse>0</cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
			#attributes.basket_rate1#,
			#attributes.basket_rate2#,
			#attributes.department_id#,
			#attributes.location_id#,
			#attributes.department_in_id#,
			#attributes.location_in_id#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
			#now()#,
			#session.ep.userid#,
			<cfif isdefined("attributes.ship_internal_number") and len(attributes.ship_internal_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_internal_number#"><cfelse>NULL</cfif>
		)
	</cfquery>
	<cfloop from="1" to="#attributes.rows_#" index="i">
		<cf_date tarih="attributes.deliver_date#i#">
	 	<cfquery name="ADD_SHIP_ROW" datasource="#DSN2#">
			INSERT INTO
				SHIP_INTERNAL_ROW
			(
				NAME_PRODUCT,
				PAYMETHOD_ID,
				DISPATCH_SHIP_ID,
				STOCK_ID,
				PRODUCT_ID,
				AMOUNT,
				AMOUNT2,
				UNIT2,
				UNIT,
				UNIT_ID,
				TAX,
			<cfif isdefined('attributes.price#i#') and len(evaluate("attributes.price#i#"))>
				PRICE,
			</cfif>
				DISCOUNT,
				DISCOUNT2,
				DISCOUNT3,
				DISCOUNT4,
				DISCOUNT5,
				DISCOUNT6,
				DISCOUNT7,
				DISCOUNT8,
				DISCOUNT9,
				DISCOUNT10,					
				DELIVER_DATE,
				DELIVER_DEPT,
				DELIVER_LOC,
			<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>					
				SPECT_VAR_ID,
				SPECT_VAR_NAME,
			</cfif>
				LOT_NO,
				PRICE_OTHER,
				OTHER_MONEY_GROSS_TOTAL,
				PRODUCT_MANUFACT_CODE,
				WRK_ROW_ID,
				WRK_ROW_RELATION_ID,
				PRODUCT_NAME2,
				ROW_PROJECT_ID,
				BASKET_EXTRA_INFO_ID,
				SELECT_INFO_EXTRA,
                DETAIL_INFO_EXTRA,
				OTHER_MONEY
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(wrk_eval('attributes.product_name#i#'),250)#">,
				<cfif isdefined("attributes.paymethod_id#i#") and len(evaluate("attributes.paymethod_id#i#"))>#evaluate("attributes.paymethod_id#i#")#,<cfelse>NULL,</cfif>
				#MAX_ID.IDENTITYCOL#,
				#evaluate("attributes.stock_id#i#")#,
				#evaluate("attributes.product_id#i#")#,
				#evaluate("attributes.amount#i#")#,
				<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.amount_other#i#")#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.unit_other#i#")#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.unit#i#')#">,
				#evaluate("attributes.unit_id#i#")#,
				#evaluate("attributes.tax#i#")#,
			<cfif len(evaluate("attributes.price#i#"))>
				#evaluate("attributes.price#i#")#,
			</cfif>
				<cfif isdefined('attributes.indirim1#i#') and len(evaluate('attributes.indirim1#i#'))>#evaluate('attributes.indirim1#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.indirim2#i#') and len(evaluate('attributes.indirim2#i#'))>#evaluate('attributes.indirim2#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.indirim3#i#') and len(evaluate('attributes.indirim3#i#'))>#evaluate('attributes.indirim3#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.indirim4#i#') and len(evaluate('attributes.indirim4#i#'))>#evaluate('attributes.indirim4#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.indirim5#i#') and len(evaluate('attributes.indirim5#i#'))>#evaluate('attributes.indirim5#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.indirim6#i#') and len(evaluate('attributes.indirim6#i#'))>#evaluate('attributes.indirim6#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.indirim7#i#') and len(evaluate('attributes.indirim7#i#'))>#evaluate('attributes.indirim7#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.indirim8#i#') and len(evaluate('attributes.indirim8#i#'))>#evaluate('attributes.indirim8#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.indirim9#i#') and len(evaluate('attributes.indirim9#i#'))>#evaluate('attributes.indirim9#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.indirim10#i#') and len(evaluate('attributes.indirim10#i#'))>#evaluate('attributes.indirim10#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
				#attributes.department_id#,
				#attributes.location_id#,
			<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
				#evaluate('attributes.spect_id#i#')#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.spect_name#i#')#">,
			</cfif>
				<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>#evaluate('attributes.lot_no#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.other_money_gross_total#i#") and len(evaluate("attributes.other_money_gross_total#i#"))>#evaluate("attributes.other_money_gross_total#i#")#<cfelse>0</cfif>,
				<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.other_money_#i#') and len(evaluate('attributes.other_money_#i#'))>'#evaluate("attributes.other_money_#i#")#'<cfelse>NULL</cfif>
			)
		</cfquery>
	</cfloop>
	<cfscript>basket_kur_ekle(action_id:MAX_ID.IDENTITYCOL,table_type_id:10,process_type:0);</cfscript>
	<!--- Belge No update ediliyor --->
	<cfset paper_number = listlast(attributes.ship_internal_number,'-')>
	<cfif len(paper_number)>
		<cfquery name="UPD_GENERAL_PAPERS" datasource="#dsn2#">
			UPDATE 
				#dsn3_alias#.GENERAL_PAPERS
			SET
				SHIP_INTERNAL_NUMBER = #paper_number#
			WHERE
			SHIP_INTERNAL_NUMBER IS NOT NULL
		</cfquery>
	</cfif>
	<cf_workcube_process
		is_upd='1' 
		data_source='#dsn2#' 
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_table='SHIP_INTERNAL'
		action_column='DISPATCH_SHIP_ID'
		action_id='#MAX_ID.IDENTITYCOL#'
		action_page='index.cfm?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_dispatch_internaldemand&event=upd&ship_id=#MAX_ID.IDENTITYCOL#' 
		warning_description='Sevk Talebi : #MAX_ID.IDENTITYCOL#'>
  </cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=stock.add_dispatch_internaldemand&event=upd&ship_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

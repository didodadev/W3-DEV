<!--- wrk_not : 20040315 bu dosyada
	- eger islem bir irsaliye ile yapilmissa stok hareketi irsaliyeye bagli olacak
	- irsaliye yoksa (ki process_type IN (64,690) disinda yok) direk faturaya kendi prosess tipi ile baglanacak/güncellenecek/silinecek
--->
<cfif ListFindNoCase("690,64", form.old_process_type, ",")> <!--- gider pusulası mal ve müstahsil makbuzu --->
	<cfif len(get_ship_id.ship_id)> <!--- fatura onceden iptal edilmisse faturanın iliskili oldugu irsaliye ve stok hareketleri zaten silinmis olacagından tekrar silinemez. --->
		<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
			DELETE FROM STOCKS_ROW WHERE UPD_ID = #get_ship_id.ship_id# AND PROCESS_TYPE = #get_ship_id.ship_type#
		</cfquery>
	</cfif>
<cfelse> <!--- hizmet faturası ise stok hareketleri direk faturaya bağlıdır --->
	<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
		DELETE FROM STOCKS_ROW WHERE UPD_ID = #form.invoice_id# AND PROCESS_TYPE = #form.old_process_type#
	</cfquery>
</cfif>
<cfif get_process_type.IS_STOCK_ACTION eq 1><!--- Stok hareketi yapılsın --->
<cfloop from="1" to="#attributes.rows_#" index="i">
	<cfif evaluate('attributes.is_inventory#i#') eq 1><!--- envantere dahil ürün satırı ise --->
		<cfinclude template="get_unit_add_fis.cfm">
		<cfif (get_unit.recordcount) and len(get_unit.multiplier)>
			<cfset multi = get_unit.multiplier * evaluate("attributes.amount#i#")>
		<cfelse>
			<cfset multi = evaluate("attributes.amount#i#")>
		</cfif>
		<!---  specli bir satirsa main_spec id yazilacak stok row a --->
		<cfset form_spect_main_id="">
		<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
			<cfset form_spect_id="#evaluate('attributes.spect_id#i#')#">
			<cfif len(form_spect_id) and len(form_spect_id)>
				<cfquery name="GET_MAIN_SPECT" datasource="#DSN2#">
					SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECT_VAR_ID=#form_spect_id#
				</cfquery>
				<cfif GET_MAIN_SPECT.RECORDCOUNT>
					<cfset form_spect_main_id=GET_MAIN_SPECT.SPECT_MAIN_ID>
				</cfif>
			</cfif>
		</cfif>
		<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
			INSERT INTO STOCKS_ROW
				(
				UPD_ID,
				PRODUCT_ID,
				STOCK_ID,
				PROCESS_TYPE,
				STOCK_IN,
				STORE,
				STORE_LOCATION,
				PROCESS_DATE,
				SPECT_VAR_ID,
				LOT_NO,
				DELIVER_DATE,
				SHELF_NUMBER,
				PRODUCT_MANUFACT_CODE
				)
			VALUES
				(
			<cfif ListFindNoCase("690,64",INVOICE_CAT, ",")>
				#MAX_ID.IDENTITYCOL#,
			<cfelse>
				#form.invoice_id#,
			</cfif>
				#evaluate("attributes.product_id#i#")#,
				#evaluate("attributes.stock_id#i#")#,
			<cfif INVOICE_CAT eq 64>
				80,  <!--- 76 idi --->
			<cfelseif INVOICE_CAT eq 690>
				84,
			<cfelse>
				#INVOICE_CAT#,
			</cfif>
				#multi#,
				#attributes.department_id#,
				#attributes.location_id#,
				#attributes.invoice_date#,
			<cfif isdefined("form_spect_main_id") and len(form_spect_main_id)>#form_spect_main_id#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.lot_no#i#") and len(evaluate("attributes.lot_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.deliver_date#i#") and len(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>
				)
		</cfquery>
	</cfif>
</cfloop>
</cfif>

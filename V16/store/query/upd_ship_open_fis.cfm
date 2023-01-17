 <!--- GARANTİ EKLENDİYSE --->
<cfloop from="1" to="#attributes.rows_#" index="i">
	<cfif isdefined("attributes.serial_no_start_number#i#") and  isdefined("attributes.is_serial_no#i#")>
		<cfif ( evaluate("attributes.is_serial_no#i#") eq 1) and evaluate("attributes.amount#i#") neq listlen(evaluate("attributes.serial_no_start_number#i#"))  >
			<script type="text/javascript">
				alert("<cf_get_lang no='44.Eklediğiniz ürün için seri no eksik girilmiş'>! <cf_get_lang_main no ='245.Ürün'>:<cfoutput>#evaluate("attributes.product_name#i#")# (#evaluate("attributes.amount#i#")#) </cfoutput>");
				window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
				//history.back();
			</script>
			<cfabort>
		</cfif>
	</cfif>
   
	<cfif (isdefined("attributes.guaranty_purchasesales#i#") and evaluate("attributes.guaranty_purchasesales#i#") eq "") and ( isdefined("attributes.is_serial_no#i#") and evaluate("attributes.is_serial_no#i#")eq 1)>
		<script type="text/javascript">
			alert("<cf_get_lang no='43.Eklediğiniz ürün için seri no girmeniz gerekir'>! <cf_get_lang_main no ='245.Ürün'>:<cfoutput>#evaluate("attributes.product_name#i#")# (#evaluate("attributes.amount#i#")#) </cfoutput> ");
			window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
			//history.back();
		</script>
		<cfabort>
	</cfif>
</cfloop>
<!--- //GARANTİ EKLENDİYSE --->	 

<!---------SILME ISLEMI MI YAPILACAK --------->
<cfif  isDefined("url.del") and url.del eq 1 >
	<cfinclude template="upd_del_open_fis.cfm">
<cfelse>	
	<!-------------guncelleme islemi yapiliyor.--------------->
	<cfif len(attributes.DEPARTMENT_IN) AND NOT ISNUMERIC(attributes.DEPARTMENT_IN)>
		<cfset LOC_IN=LISTGETAT(attributes.DEPARTMENT_IN,2,"-")>
		<cfset attributes.DEPARTMENT_IN=LISTGETAT(attributes.DEPARTMENT_IN,1,"-")>
	</cfif>
	<cfquery name="GET_FIS_NUMBER" datasource="#dsn2#">
		SELECT 
			FIS_NUMBER,FIS_ID
		FROM 
			STOCK_FIS
		WHERE 
			FIS_NUMBER = '#attributes.FIS_NO#'
	</cfquery>
	<cf_date tarih = 'attributes.DELIVER_DATE_FRM'>
	<cf_date tarih = 'attributes.FIS_DATE'> 
	<cfquery name="UPD_SALE" datasource="#dsn2#">
		UPDATE
			STOCK_FIS
		SET
			FIS_TYPE=#attributes.fis_type#,
			FIS_NUMBER='#FIS_NO#',
			DEPARTMENT_IN=#attributes.DEPARTMENT_IN#,
			LOCATION_IN=<cfif isDefined("LOC_IN")>#LOC_IN#,<cfelse>NULL,</cfif>
			FIS_DATE=#attributes.FIS_DATE#,
			DELIVER_DATE=#attributes.DELIVER_DATE_FRM#,
			RECORD_DATE=#NOW()#				
		WHERE
			FIS_ID = #attributes.UPD_ID#
	</cfquery>	
	

		<cfquery name="del_stock_fis_row" datasource="#dsn2#">
			DELETE 
			FROM 
				STOCK_FIS_ROW
			WHERE 
				FIS_ID = #attributes.UPD_ID#
		</cfquery>
		<cfloop from="1" to="#attributes.rows_#" index="i">

			<cfscript>
				if(isdefined("attributes.amount#i#"))amount_rw=evaluate("attributes.amount#i#"); else amount_rw=0;
				if(isdefined("attributes.price#i#"))price_rw=evaluate("attributes.price#i#");else price_rw=0;
				if(isdefined("attributes.INDIRIM1#i#") and len(evaluate("attributes.INDIRIM1#i#")))discount_rw=evaluate("attributes.INDIRIM1#i#");else discount_rw=0;
				if(isdefined("attributes.INDIRIM2#i#") and len(evaluate("attributes.INDIRIM1#i#")))discount2_rw=evaluate("attributes.INDIRIM2#i#");else discount2_rw=0;
				if(isdefined("attributes.INDIRIM3#i#") and len(evaluate("attributes.INDIRIM3#i#")))discount3_rw=evaluate("attributes.INDIRIM3#i#");else discount3_rw=0;
				if(isdefined("attributes.INDIRIM4#i#") and len(evaluate("attributes.INDIRIM4#i#")))discount4_rw=evaluate("attributes.INDIRIM4#i#");else discount4_rw=0;
				if(isdefined("attributes.INDIRIM5#i#") and len(evaluate("attributes.INDIRIM1#i#")))discount5_rw=evaluate("attributes.INDIRIM5#i#");else discount5_rw=0;						
				if(isdefined("attributes.tax#i#"))tax_rw=evaluate("attributes.tax#i#");else tax_rw=0;
				indirim_carpan=10000000000 - ((100-discount_rw) * (100-discount2_rw) * (100-discount3_rw) * (100-discount4_rw) * (100-discount5_rw));
				if(isdefined("attributes.row_total#i#"))subtotal = evaluate("attributes.row_total#i#");	else subtotal = 0;
				if(isdefined("attributes.row_nettotal#i#"))total = evaluate("attributes.row_nettotal#i#");else total = 0;
				if(isdefined("attributes.row_taxtotal#i#"))	ship_fis_total_tax_ = evaluate("attributes.row_taxtotal#i#"); else ship_fis_total_tax_ = 0;
				ship_fis_net_total_ = total ;
				ship_fis_discount_ = (subtotal* indirim_carpan) / 10000000000;
				ship_fis_total_ = total;
			</cfscript>

			<cfquery name="add_stock_row" datasource="#DSN2#">
			INSERT INTO 
				STOCK_FIS_ROW
					(
					FIS_ID,
					FIS_NUMBER,
					STOCK_ID,
					AMOUNT,
					UNIT,
					UNIT_ID,					
					PRICE,
					TAX,
					TOTAL,
					DISCOUNT,
					TOTAL_TAX,
					NET_TOTAL,
					<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
					SPECT_VAR_ID,
					SPECT_VAR_NAME,
					</cfif>
					LOT_NO,
					UNIQUE_RELATION_ID,
					PRODUCT_NAME2,
					AMOUNT2,
					UNIT2,
					EXTRA_PRICE,
					EXTRA_PRICE_TOTAL,
					SHELF_NUMBER,
					PRODUCT_MANUFACT_CODE,
					WIDTH_VALUE,
					DEPTH_VALUE,
					HEIGHT_VALUE,
					ROW_PROJECT_ID
					)
			VALUES
					(
					#attributes.UPD_ID#,
					'#FIS_NO#',							
					#evaluate("attributes.stock_id#i#")#,
					#amount_rw#,
					'#wrk_eval("attributes.unit#i#")#',
					#evaluate("attributes.unit_id#i#")#,
					#price_rw#,
					#tax_rw#,
					#ship_fis_total_#,
					#ship_fis_discount_#,
					#ship_fis_total_tax_#,
					#ship_fis_net_total_#,
					<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
					#evaluate('attributes.spect_id#i#')#,
					'#wrk_eval('attributes.spect_name#i#')#',
					</cfif>
					<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>#evaluate('attributes.lot_no#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))>'#wrk_eval('attributes.row_unique_relation_id#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))>'#wrk_eval('attributes.product_name_other#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))>'#wrk_eval('attributes.unit_other#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>
					)
			</cfquery>
		</cfloop>

	<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
		DELETE FROM STOCKS_ROW WHERE PROCESS_TYPE=#attributes.fis_type# AND UPD_ID=#attributes.UPD_ID#
	</cfquery>
	<cfif get_process_type.IS_STOCK_ACTION eq 1><!--- Stok hareketi yapılsın --->
		<cfloop from="1" to="#attributes.rows_#" index="i">
			<cfinclude template="get_unit_add_fis.cfm">
			<cfscript>
					if(isdefined("attributes.amount#i#"))amount_rw=evaluate("attributes.amount#i#"); else amount_rw=0;
					if (get_unit.recordcount and len(get_unit.multiplier))
						multi=get_unit.multiplier*amount_rw;
					else
						multi=amount_rw;			
			</cfscript>
			<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
				INSERT INTO 
					STOCKS_ROW
					(
					UPD_ID,
					PRODUCT_ID,
					STOCK_ID,
					PROCESS_TYPE,
					STOCK_IN,
					STORE,
					STORE_LOCATION,
					PROCESS_DATE,
				<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
					SPECT_VAR_ID,
				</cfif>
					LOT_NO,
					SHELF_NUMBER,
					PRODUCT_MANUFACT_CODE
					)
				VALUES
					(
					#attributes.UPD_ID#,
					#evaluate("attributes.product_id#i#")#,
					#evaluate("attributes.stock_id#i#")#,
					#attributes.fis_type#,
					#MULTI#,
					#attributes.DEPARTMENT_IN#,
				<cfif isDefined("LOC_IN")>#LOC_IN#,<cfelse>NULL,</cfif>					
					#attributes.FIS_DATE#,
				<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
					#evaluate('attributes.spect_id#i#')#,
				</cfif>
				<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>#evaluate('attributes.lot_no#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>
					)
			</cfquery>
		</cfloop>
	</cfif> 
	<cfscript>
		basket_kur_ekle(action_id:attributes.UPD_ID,table_type_id:6,process_type:1);
	</cfscript>	
</cfif>

<cflocation url="#request.self#?fuseaction=store.list_ship" addtoken="no">

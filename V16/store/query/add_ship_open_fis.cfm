<cfif attributes.rows_ eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang no='88.Ürün Seçmediniz ! Lütfen Ürün Seçiniz !'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>	
	<cfabort>
</cfif>
<cf_papers paper_type="STOCK_FIS">
<cfset system_paper_no=paper_code & '-' & paper_number>
<cfset system_paper_no_add=paper_number>
<cfset attributes.FIS_NO= system_paper_no>

<!--- GARANTİ EKLENDİYSE --->
<cfloop from="1" to="#attributes.rows_#" index="i">
	<cfif isdefined("attributes.serial_no_start_number#i#") and  isdefined("attributes.is_serial_no#i#")>
		<cfif ( evaluate("attributes.is_serial_no#i#") eq 1) and evaluate("attributes.amount#i#") neq listlen(evaluate("attributes.serial_no_start_number#i#"))  >
			<script type="text/javascript">
				alert("<cf_get_lang no='44.Eklediğiniz ürün için seri no eksik girilmiş'>! <cf_get_lang_main no ='245.Ürün'>: <cfoutput>#evaluate("attributes.product_name#i#")# (#evaluate("attributes.amount#i#")#) </cfoutput> ");
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

<!----  Depo lokaysyon kodlarini ayrimi ----->

<cfif len(attributes.DEPARTMENT_IN) AND NOT ISNUMERIC(attributes.DEPARTMENT_IN)>
	<cfset LOC_IN = LISTGETAT(attributes.DEPARTMENT_IN,2,"-")>
	<cfset attributes.DEPARTMENT_IN=LISTGETAT(attributes.DEPARTMENT_IN,1,"-")>
</cfif>

<cfquery name="GET_RECORD_OPEN_FIS" datasource="#DSN2#">
	SELECT 
		* 
	FROM 
		STOCK_FIS
	WHERE 
		DEPARTMENT_IN=#attributes.DEPARTMENT_IN#
		AND 
		FIS_TYPE =#attributes.fis_type#
	<cfif isDefined('LOC_IN')>
		AND LOCATION_IN=#LOC_IN#
	</cfif>
</cfquery>

<!-------- ACILIS FISI VE DEPO KONTROL --------->
<cfif GET_RECORD_OPEN_FIS.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang no='144.Seçtiğiniz Depoya Ait Açılış Fişi Bulunmaktadır'>!");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>	
	<cfabort>
</cfif>

<cfquery name="GET_FIS_NO" datasource="#dsn2#">
	SELECT 
		FIS_NUMBER 
	FROM 
		STOCK_FIS
	WHERE 
		FIS_NUMBER = '#attributes.FIS_NO#'
</cfquery>

<cfif get_fis_no.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='145.Fiş Numaranızı Kontrol Ediniz'>!");
		history.back();
	</script>	
	<cfabort>
</cfif>

<cf_date tarih='attributes.deliver_date_frm'>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_STOCK_FIS" datasource="#dsn2#" result="MAX_ID">
			INSERT INTO STOCK_FIS
				(
				FIS_NUMBER,
				FIS_TYPE,
				DEPARTMENT_IN,
				LOCATION_IN,
				FIS_DATE,
				DELIVER_DATE,
				RECORD_DATE ,
				EMPLOYEE_ID 
				)
			VALUES
				(
				'#attributes.FIS_NO#',
				#attributes.FIS_TYPE#,
				#attributes.DEPARTMENT_IN#,
				<cfif isDefined("LOC_IN") >#LOC_IN#,<cfelse>NULL,</cfif>
				#NOW()#,
				#attributes.deliver_date_frm#,
				#NOW()#,
				#SESSION.EP.USERID#
				)
		</cfquery>
		<cfloop from="1" to="#attributes.rows_#" index="i">
			<cfinclude template="get_unit_add_fis.cfm">
			<cfscript>
				if(isdefined("attributes.amount#i#"))amount_rw=evaluate("attributes.amount#i#"); else amount_rw=0;
				if(isdefined("attributes.price#i#"))price_rw=evaluate("attributes.price#i#");else price_rw=0;
				if(isdefined("attributes.INDIRIM1#i#") and len(evaluate("attributes.INDIRIM1#i#")))discount_rw=evaluate("attributes.INDIRIM1#i#");else discount_rw=0;
				if(isdefined("attributes.INDIRIM2#i#") and len(evaluate("attributes.INDIRIM1#i#")))discount2_rw=evaluate("attributes.INDIRIM2#i#");else discount2_rw=0;
				if(isdefined("attributes.INDIRIM3#i#") and len(evaluate("attributes.INDIRIM3#i#")))discount3_rw=evaluate("attributes.INDIRIM3#i#");else discount3_rw=0;
				if(isdefined("attributes.INDIRIM4#i#") and len(evaluate("attributes.INDIRIM4#i#")))discount4_rw=evaluate("attributes.INDIRIM4#i#");else discount4_rw=0;
				if(isdefined("attributes.INDIRIM5#i#") and len(evaluate("attributes.INDIRIM1#i#")))discount5_rw=evaluate("attributes.INDIRIM5#i#");else discount5_rw=0;						
				if(isdefined("attributes.tax#i#")) tax_rw=evaluate("attributes.tax#i#"); else tax_rw=0;
				indirim_carpan=10000000000 - ((100-discount_rw) * (100-discount2_rw) * (100-discount3_rw) * (100-discount4_rw) * (100-discount5_rw));
				if(isdefined("attributes.row_total#i#")) subtotal = evaluate("attributes.row_total#i#");	else subtotal = 0;
				if(isdefined("attributes.row_nettotal#i#"))total = evaluate("attributes.row_nettotal#i#");else total = 0;
				if(isdefined("attributes.row_taxtotal#i#"))	ship_fis_total_tax_ = evaluate("attributes.row_taxtotal#i#"); else ship_fis_total_tax_ = 0;
				ship_fis_net_total_ = total ;
				ship_fis_discount_ = (subtotal* indirim_carpan) / 10000000000;
				ship_fis_total_ = total;
				if (get_unit.recordcount and len(get_unit.multiplier))
					multi=get_unit.multiplier*amount_rw;
				else
					multi=amount_rw;			
			</cfscript>
	
			<cfquery name="add_STOCK_FIS_ROW" datasource="#DSN2#">
				INSERT INTO STOCK_FIS_ROW
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
						#MAX_ID.IDENTITYCOL#,
						'#attributes.FIS_NO#',							
						#evaluate("attributes.stock_id#i#")#,
						#amount_rw#,
						'#wrk_eval("attributes.unit_id#i#")#',
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
		<cfif get_process_type.IS_STOCK_ACTION eq 1><!--- Stok hareketi yapılsın --->
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
						<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>						
						SPECT_VAR_ID,
						</cfif>
						LOT_NO,
						SHELF_NUMBER,
						PRODUCT_MANUFACT_CODE
					)
				VALUES
					(
						#MAX_ID.IDENTITYCOL#,
						#evaluate("attributes.product_id#i#")#,
						#evaluate("attributes.stock_id#i#")#,
						#attributes.FIS_TYPE#,
						#MULTI#,
						#attributes.DEPARTMENT_IN#,
						<cfif isDefined("LOC_IN")>#LOC_IN#,<cfelse>NULL,</cfif>
						#NOW()#,
						<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
						#evaluate('attributes.spect_id#i#')#,
						</cfif>
						<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>#evaluate('attributes.lot_no#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>
					)
			</cfquery>
		</cfif>
		</cfloop>	
	</cftransaction>
</cflock>

<!--- TODO:SERIALNO--->
<cfinclude template="../../objects/functions/add_serial_no.cfm">
<cfloop from="1" to="#attributes.rows_#" index="i">
	<cfif isdefined("attributes.is_serial_no#i#")>
	<cfif len(evaluate('attributes.guaranty_purchasesales#i#')) and (evaluate('attributes.is_serial_no#i#') eq 1)>
		<cfif len(evaluate('attributes.deliver_dept#i#')) and not isnumeric(evaluate('attributes.deliver_dept#i#'))>
			<cfset department_id = listgetat(evaluate('attributes.deliver_dept#i#'),1,'-')>
			<cfset location_id = listgetat(evaluate('attributes.deliver_dept#i#'),2,'-')>
		<cfelseif len(evaluate('attributes.deliver_dept#i#'))  and isnumeric(evaluate('attributes.deliver_dept#i#'))>
			<cfset department_id = evaluate('attributes.deliver_dept#i#')>
			<cfset location_id = 0>
		<cfelseif not len(evaluate('attributes.deliver_dept#i#')) and len(attributes.DEPARTMENT_IN) and not isnumeric(attributes.DEPARTMENT_IN)>
			<cfset department_id = listgetat(attributes.DEPARTMENT_IN,1,'-')>
			<cfset location_id = listgetat(attributes.DEPARTMENT_IN,2,'-')>
		<cfelseif  not len(evaluate('attributes.deliver_dept#i#')) and len(attributes.DEPARTMENT_IN) and isnumeric(attributes.DEPARTMENT_IN)>  
			<cfset department_id = attributes.DEPARTMENT_IN>
			<cfset location_id = 0>
		</cfif>
		<cfscript>
			add_serial_no(
			is_insert : true,
			session_row : i,
			action_id : MAX_ID.IDENTITYCOL,
			action_type :3,
			action_number : '#attributes.FIS_NO#',
			dpt_id : department_id,
			loc_id : location_id
			);
		</cfscript>
	</cfif>
	</cfif>
</cfloop> 

<cfscript>
	basket_kur_ekle(action_id:MAX_ID.IDENTITYCOL,table_type_id:6,process_type:0);
</cfscript>

<cfquery name="UPD_GEN_PAP" datasource="#dsn3#">
	UPDATE GENERAL_PAPERS SET STOCK_FIS_NUMBER=#system_paper_no_add# WHERE STOCK_FIS_NUMBER IS NOT NULL
</cfquery>
<!--- burası stocks_row ekleme sonu--->

<cflocation url="#request.self#?fuseaction=store.list_purchase" addtoken="No">

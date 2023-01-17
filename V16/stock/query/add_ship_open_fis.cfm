<cfinclude template="check_our_period.cfm"> 
<cfinclude template="get_process_cat.cfm">
<cfset attributes.FIS_TYPE = get_process_type.PROCESS_TYPE>
<cfif attributes.rows_ eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='815.Lütfen Ürün Seçiniz !'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>
	<cfabort>
</cfif>
<cf_papers paper_type="stock_fis">
<cfset system_paper_no = paper_code & '-' & paper_number>
<cfset system_paper_no_add = paper_number >
<cfset attributes.FIS_NO = system_paper_no >
<!--- Garanti Eklendiyse --->
<cfloop from="1" to="#attributes.rows_#" index="i">
  <cfif isdefined("attributes.serial_no_start_number#i#") and  isdefined("attributes.is_serial_no#i#")>
	<cfif (evaluate("attributes.is_serial_no#i#") eq 1) and evaluate("attributes.amount#i#") neq listlen(evaluate("attributes.serial_no_start_number#i#"))>
	  <script type="text/javascript">
	  	alert("<cf_get_lang no ='542.Eklediğiniz ürün için seri no eksik girilmiş'>.<cf_get_lang_main no ='245.Ürün'> :<cfoutput>#evaluate("attributes.product_name#i#")# (#evaluate("attributes.amount#i#")#) </cfoutput>  !");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	  </script>
	  <cfabort>
    </cfif>
  </cfif>
  <cfif (isdefined("attributes.guaranty_purchasesales#i#") and evaluate("attributes.guaranty_purchasesales#i#") eq "") and ( isdefined("attributes.is_serial_no#i#") and evaluate("attributes.is_serial_no#i#")eq 1)>
  	<script type="text/javascript">
		alert("<cf_get_lang no ='543.Eklediğiniz ürün için seri no girmeniz gerekir'>.<cf_get_lang_main no ='245.Ürün'> :<cfoutput>#evaluate("attributes.product_name#i#")# (#evaluate("attributes.amount#i#")#) </cfoutput>  !");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		 //history.back();
    </script>
   	<cfabort>
  </cfif>
</cfloop>
<!--- //GARANTİ EKLENDİYSE --->	 
<!--- acilis fisi depo bazinda kontrol edilmeyecek
<cfquery name="GET_RECORD_OPEN_FIS" datasource="#DSN2#">
	SELECT 
		* 
	FROM 
		STOCK_FIS
	WHERE 
		DEPARTMENT_IN = #attributes.DEPARTMENT_IN#
		AND FIS_TYPE = #attributes.fis_type#
	<cfif attributes.location_in neq "NULL" >
		AND LOCATION_IN = #attributes.location_in#
	</cfif>
</cfquery>
<cfif GET_RECORD_OPEN_FIS.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang no='31.Seçtiğiniz Depoya Ait Açılış Fişi Bulunmaktadır !'>");
		history.back();
	</script>	
	<cfabort>
</cfif> --->
<cfquery name="GET_FIS_NO" datasource="#DSN2#">
	SELECT 
		FIS_NUMBER 
	FROM 
		STOCK_FIS
	WHERE 
		FIS_NUMBER = '#attributes.FIS_NO#'
</cfquery>
<cfif get_fis_no.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='32.Fiş Numaranızı Kontrol Ediniz !'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>	
	<cfabort>
</cfif>
<cf_date tarih='attributes.deliver_date_frm'>
<cfset attributes.deliver_date_time = createdatetime(year(attributes.deliver_date_frm),month(attributes.deliver_date_frm),day(attributes.deliver_date_frm),attributes.deliver_date_h,attributes.deliver_date_m,0)>
<cflock name="#CREATEUUID()#" timeout="20">
  <cftransaction>
	<cfquery name="ADD_STOCK_FIS" datasource="#dsn3#" result="MAX_ID">
		INSERT INTO
			#dsn2_alias#.STOCK_FIS
		(
			FIS_NUMBER,
			FIS_TYPE,
			PROCESS_CAT,
			DEPARTMENT_IN,
			LOCATION_IN,
			FIS_DATE,
			DELIVER_DATE,
			RECORD_DATE,
			EMPLOYEE_ID,
			RECORD_EMP,
			RECORD_IP
		)
		VALUES
		(
			'#attributes.FIS_NO#',
			#attributes.FIS_TYPE#,
			#attributes.PROCESS_CAT#,			
			#attributes.department_id#,
			#attributes.location_id#,
			#attributes.deliver_date_frm#, 
			#attributes.deliver_date_time#,
			#now()#,
			#session.ep.userid#,
			#session.ep.userid#,
			'#cgi.remote_addr#'
		)
	</cfquery>
	<cfloop from="1" to="#attributes.rows_#" index="i">
	  <cfif isdefined("attributes.is_serial_no#i#")>
		<cfif isdefined('attributes.guaranty_purchasesales#i#') and len(evaluate('attributes.guaranty_purchasesales#i#')) and (evaluate('attributes.is_serial_no#i#') eq 1)>		
		  <cfscript>
			add_serial_no(
				session_row : i,
				is_insert : true,
				action_id : MAX_ID.IDENTITYCOL,
				action_type : 3,
				action_number :'#attributes.FIS_NO#',
				dpt_id : attributes.department_id,
				loc_id : attributes.location_id);
		  </cfscript>
		</cfif>
	  </cfif>
	</cfloop>
    <cfset dsn_type=dsn3>
	<cfloop from="1" to="#attributes.rows_#" index="i">
		<cfif session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#'))>
		</cfif>
		<cfquery name="GET_UNIT" datasource="#DSN3#">
			SELECT 
				ADD_UNIT,
				MULTIPLIER,
				MAIN_UNIT,
				PRODUCT_UNIT_ID
			FROM
				PRODUCT_UNIT 
			WHERE 
				PRODUCT_ID = #evaluate("attributes.product_id#i#")# AND
                PRODUCT_UNIT_STATUS = 1 AND
				ADD_UNIT = '#evaluate("attributes.unit#i#")#'
		</cfquery>
		<cfscript>
			if(isdefined("attributes.amount#i#"))amount_rw=evaluate("attributes.amount#i#"); else amount_rw=0;
			if(isdefined("attributes.price#i#"))price_rw=evaluate("attributes.price#i#");else price_rw=0;
			if(isdefined("attributes.price_other#i#"))price_other_rw=evaluate("attributes.price_other#i#");else price_other_rw=0;
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
			
			if (get_unit.recordcount and len(get_unit.multiplier))
				multi=get_unit.multiplier*amount_rw;
			else
				multi=amount_rw;			
		</cfscript>
		<cf_date tarih="attributes.deliver_date#i#">
		<cf_date tarih="attributes.reserve_date#i#">
		<cfquery name="add_STOCK_FIS_ROW" datasource="#DSN3#">
			INSERT INTO
				#dsn2_alias#.STOCK_FIS_ROW
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
				DISCOUNT1,
				DISCOUNT2,
				DISCOUNT3,
				DISCOUNT4,
				DISCOUNT5,				
				TOTAL_TAX,
				NET_TOTAL,
			  <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
				SPECT_VAR_ID,
				SPECT_VAR_NAME,
			  </cfif>
				LOT_NO,
				OTHER_MONEY,
				PRICE_OTHER,
				COST_PRICE,
				EXTRA_COST,
				DUE_DATE,
				UNIQUE_RELATION_ID,
				PRODUCT_NAME2,
				AMOUNT2,
				UNIT2,
				EXTRA_PRICE,
				EXTRA_PRICE_TOTAL,
				SHELF_NUMBER,
				PRODUCT_MANUFACT_CODE,
				DELIVER_DATE,
				RESERVE_DATE,
                WRK_ROW_ID,
                WRK_ROW_RELATION_ID,
                ROW_PROJECT_ID,
                ROW_WORK_ID,
                BASKET_EMPLOYEE_ID,
				TO_SHELF_NUMBER
			)
			VALUES
			(
				#MAX_ID.IDENTITYCOL#,
				'#attributes.FIS_NO#',							
				#evaluate("attributes.stock_id#i#")#,
				#amount_rw#,
				'#wrk_eval("attributes.unit#i#")#',
				#evaluate("attributes.unit_id#i#")#,					
				#price_rw#,
				#tax_rw#,
				#ship_fis_total_#,
				#discount_rw#,
				#discount2_rw#,
				#discount3_rw#,
				#discount4_rw#,
				#discount5_rw#,
				#ship_fis_total_tax_#,
				#ship_fis_net_total_#,																						
			  <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
				#evaluate('attributes.spect_id#i#')#,
				'#wrk_eval('attributes.spect_name#i#')#',
			  </cfif>
			  <cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>
			  	'#evaluate('attributes.lot_no#i#')#'
			  <cfelse>
			  	NULL
			  </cfif>,
			  <cfif isdefined('attributes.other_money_#i#') and len(evaluate('attributes.other_money_#i#'))>
			  	'#wrk_eval('attributes.other_money_#i#')#'
			  <cfelse>
			  	NULL
			  </cfif>,
				#price_other_rw#,
			<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
			<cfif isdefined("attributes.duedate#i#") and len(Evaluate("attributes.duedate#i#"))>#Evaluate("attributes.duedate#i#")#<cfelse>0</cfif>,
			<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))>'#wrk_eval('attributes.row_unique_relation_id#i#')#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))>'#wrk_eval('attributes.product_name_other#i#')#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))>'#wrk_eval('attributes.unit_other#i#')#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.reserve_date#i#") and len(evaluate("attributes.reserve_date#i#"))>#evaluate("attributes.reserve_date#i#")#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.wrk_row_id#i#") and len(evaluate("attributes.wrk_row_id#i#"))>'#evaluate("attributes.wrk_row_id#i#")#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.wrk_row_relation_id#i#") and len(evaluate("attributes.wrk_row_relation_id#i#"))>'#evaluate("attributes.wrk_row_relation_id#i#")#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
            <cfif isdefined('attributes.row_work_id#i#') and len(evaluate('attributes.row_work_id#i#')) and isdefined('attributes.row_work_name#i#') and len(evaluate('attributes.row_work_name#i#'))>#evaluate('attributes.row_work_id#i#')#<cfelse>NULL</cfif>,
            <cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.to_shelf_number#i#') and len(evaluate('attributes.to_shelf_number#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.to_shelf_number#i#')#"><cfelse>NULL</cfif>
            )
		</cfquery>
		<cfset form_spect_main_id="">
		<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
			<cfset form_spect_id="#evaluate('attributes.spect_id#i#')#">
			<cfif len(form_spect_id) and len(form_spect_id)>
				<cfquery name="GET_MAIN_SPECT" datasource="#DSN3#">
					SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECT_VAR_ID=#form_spect_id#
				</cfquery>
				<cfif GET_MAIN_SPECT.RECORDCOUNT>
					<cfset form_spect_main_id=GET_MAIN_SPECT.SPECT_MAIN_ID>
				</cfif>
			</cfif>
		</cfif>
		<cfquery name="ADD_STOCK_ROW" datasource="#DSN3#">
			INSERT INTO
				#dsn2_alias#.STOCKS_ROW
			(
				UPD_ID,
				PRODUCT_ID,
				STOCK_ID,
				PROCESS_TYPE,
				STOCK_IN,
				STORE,
				STORE_LOCATION,
				PROCESS_DATE,
				PROCESS_TIME,
			<cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
				SPECT_VAR_ID,
			</cfif>
				LOT_NO,
				DELIVER_DATE,
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
				#attributes.department_id#,
				#attributes.location_id#,					
				#attributes.deliver_date_frm#,
				#attributes.deliver_date_time#, 
			<cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
				#form_spect_main_id#,
			</cfif>
			<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>'#evaluate('attributes.lot_no#i#')#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>

			)
		</cfquery>
	</cfloop>
	<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
		UPDATE
			GENERAL_PAPERS
		SET
			STOCK_FIS_NUMBER = #system_paper_no_add#
		WHERE
			STOCK_FIS_NUMBER IS NOT NULL
	</cfquery>	
	</cftransaction>
	<cfscript>
		basket_kur_ekle(action_id:MAX_ID.IDENTITYCOL,table_type_id:6,process_type:0);
	</cfscript>
</cflock>
<cfif session.ep.our_company_info.is_cost eq 1 and get_process_type.IS_COST eq 1><!--- sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor --->
	<cfscript>cost_action(action_type:3,action_id:MAX_ID.IDENTITYCOL,query_type:1);</cfscript>
</cfif>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=stock.form_add_ship_open_fis&event=upd&upd_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
</script>

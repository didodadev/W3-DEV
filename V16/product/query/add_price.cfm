<cfif form.active_company neq session.ep.company_id>
	<script type="text/javascript">
		alert("<cf_get_lang no ='862.İşlemin Muhasebe Dönemi İle Aktif Muhasebe Döneminiz Farklı'>...<cf_get_lang no ='863.Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.opener.location.href='<cfoutput>#request.self#?fuseaction=product.list_product</cfoutput>';
		<cfif not isDefined('attributes.draggable') or attributes.draggable eq 1>
			window.close();
		</cfif>
	</script>
	<cfabort>
</cfif>
<cf_get_lang no ='864.Fiyat Oluşturma İşlemi Başladı, Lütfen Bekleyiniz'>...<br/>

<cfsetting showdebugoutput="no">
<cfset attributes.rounding = 0>
<cf_date tarih="form.startdate">
<cfset startdate_00 = form.startdate>
<cfset form.startdate = date_add("h", form.start_clock, form.startdate)>
<cfset form.startdate = date_add("n", form.start_min, form.startdate)>
<cfif not isdefined("pass_dates")><!--- fiyat önerisi güncellemeden gelebilir erk 20040119 --->
	<cfif (not isDefined("attributes.price_cat_list")) or (NOT len(attributes.price_cat_list))>
		<script type="text/javascript">
		alert("<cf_get_lang no ='872.Fiyat Listesi Seçiniz'>!");
		history.back();
		</script>
		<cfabort>
	</cfif>
	<cfset price_cat_arr=ListToArray(attributes.price_cat_list,",")>
</cfif>
<cfset sp_array = ArrayNew(2)>
<cfloop from="1" to="#arraylen(price_cat_arr)#" index="i">
	<cfif arraylen(price_cat_arr) eq 1>
		<cfset attributes.price_catid=attributes.price_cat_list>
	<cfelse>
		<cfset attributes.price_catid=price_cat_arr[i]>
	</cfif>
	
	<cfset is_kdv_f = 0>
	
	<cfif attributes.price_catid eq "-1">
		<cfif isdefined("form.is_kdv_minus_1")>
			<cfset is_kdv_f = 1>
		</cfif>		
		<cfset end_price = attributes.price_minus_1>
		<cfset gelen_money = attributes.money_minus_1>
		<cfset end_price_with_kdv = wrk_round(end_price+((end_price*attributes.alis_kdv)/100),session.ep.our_company_info.purchase_price_round_num)>
		<cfset end_price_without_kdv = wrk_round((end_price*100)/(attributes.alis_kdv+100),session.ep.our_company_info.purchase_price_round_num)>
	<cfelseif attributes.price_catid eq "-2">
		<cfif isdefined("form.is_kdv_minus_2")>
			<cfset is_kdv_f = 1>
		</cfif>		
		<cfset end_price = attributes.price_minus_2>
		<cfset gelen_money = attributes.money_minus_2>
		<cfset end_price_with_kdv = wrk_round(end_price+((end_price*attributes.satis_kdv)/100),session.ep.our_company_info.sales_price_round_num)>
		<cfset end_price_without_kdv = wrk_round((end_price*100)/(attributes.satis_kdv+100),session.ep.our_company_info.sales_price_round_num)>
	<cfelse>
		<cfif isdefined("form.is_kdv_#attributes.price_catid#")>
			<cfset is_kdv_f = 1>
		</cfif>		
		<cfset end_price = evaluate('attributes.price_#ListGetAt(attributes.price_cat_list,i)#')>
		<cfset gelen_money = evaluate('attributes.money_#ListGetAt(attributes.price_cat_list,i)#')>
		<cfset end_price_with_kdv = wrk_round(end_price+((end_price*attributes.satis_kdv)/100),session.ep.our_company_info.sales_price_round_num)>
		<cfset end_price_without_kdv = wrk_round((end_price*100)/(attributes.satis_kdv+100),session.ep.our_company_info.sales_price_round_num)>
	</cfif>
	<cfif attributes.price_catid eq "-1">
		<cfquery name="DEL_PRODUCT_PRICE_PURCHASE" datasource="#DSN3#">
			DELETE FROM
				#dsn1_alias#.PRICE_STANDART
			WHERE
				PRODUCT_ID = #attributes.pid# AND
				PURCHASESALES = 0 AND
				UNIT_ID = #attributes.unit_id# AND
				START_DATE = #startdate_00#						
		</cfquery>
		<cfquery name="ADD_PRODUCT_PRICE_PURCHASE" datasource="#DSN3#">
			INSERT INTO
				#dsn1_alias#.PRICE_STANDART
			(
				PRICESTANDART_STATUS,
				PRODUCT_ID,
				PURCHASESALES,
				PRICE,
				PRICE_KDV,
				IS_KDV,
				ROUNDING,
				MONEY,
				UNIT_ID,
				START_DATE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				PROCESS_STAGE
			)
			VALUES
			(
				0,
				#attributes.pid#,
				0,
			<cfif is_kdv_f>
				#end_price_without_kdv#,
				#end_price#,
			<cfelse>
				#end_price#,
				#end_price_with_kdv#,
			</cfif>
				#is_kdv_f#,
				#attributes.rounding#,
				'#gelen_money#',
				#attributes.unit_id#,
				#startdate_00#,
				#NOW()#,
				#SESSION.EP.USERID#,
				'#CGI.REMOTE_ADDR#',
				#attributes.process_stage#
			)
		</cfquery>
		<cfquery name="UPD_PRICE_STANDART_PURCHASE_STAT_0" datasource="#DSN3#">
			UPDATE
				#dsn1_alias#.PRICE_STANDART
			SET
				PRICESTANDART_STATUS = 0
			WHERE
				PRODUCT_ID = #attributes.pid# AND
				PURCHASESALES = 0 AND
				UNIT_ID = #attributes.unit_id# AND
				PRICESTANDART_STATUS = 1
		</cfquery>
		<cfquery name="GET_MAX_ST_DATE_ID_PURC" datasource="#DSN3#" maxrows="1">
			SELECT 
				MAX(PRICESTANDART_ID) AS PRICESTANDART_ID
			FROM 
				#dsn1_alias#.PRICE_STANDART 
			WHERE 
				PRODUCT_ID = #attributes.pid# AND
				PURCHASESALES = 0 AND
				UNIT_ID = #attributes.unit_id# AND 
				START_DATE = (	SELECT MAX(START_DATE) AS START_DATE 
								FROM #dsn1_alias#.PRICE_STANDART 
								WHERE PRODUCT_ID = #attributes.pid# AND PURCHASESALES = 0 AND UNIT_ID = #attributes.unit_id#)
		</cfquery>
		<cfquery name="UPD_PRICE_STANDART_SALES_STAT_1" datasource="#DSN3#" maxrows="1">
			UPDATE
				#dsn1_alias#.PRICE_STANDART
			SET
				PRICESTANDART_STATUS = 1
			WHERE	
				PRICESTANDART_ID = #GET_MAX_ST_DATE_ID_PURC.PRICESTANDART_ID#
		</cfquery>
<!---        <cfquery name="GET_PRICE_CHANGE" datasource="#DSN3#">
        	SELECT PRICE_CHANGE_ID FROM PRICE_CHANGE  WHERE PRODUCT_ID = #attributes.pid# AND PRICE_CATID = -1
        </cfquery>
--->        <cf_workcube_process
            data_source='#dsn3#'  
            is_upd='1' 
            old_process_line='0'
            process_stage='#attributes.process_stage#' 
            record_member='#session.ep.userid#' 
            record_date='#now()#' 
            action_table='PRICE_STANDART'
            action_column='PRICESTANDART_ID'
            action_id='#GET_MAX_ST_DATE_ID_PURC.PRICESTANDART_ID#'
            action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_price_change&event=det&pid=#attributes.pid#' 
            warning_description='Standart Alış'>
	<cfelseif attributes.price_catid eq "-2">
		<cfquery name="DEL_PRODUCT_PRICE_SALES" datasource="#DSN3#">
			DELETE FROM
				#dsn1_alias#.PRICE_STANDART
			WHERE
				PRODUCT_ID = #attributes.pid# AND
				PURCHASESALES = 1 AND
				UNIT_ID = #attributes.unit_id# AND
				START_DATE = #startdate_00#						
		</cfquery>
		<cfquery name="ADD_PRODUCT_PRICE_SALES" datasource="#DSN3#">
			INSERT INTO
				#dsn1_alias#.PRICE_STANDART
			(
				PRICESTANDART_STATUS,
				PRODUCT_ID,
				PURCHASESALES,
				PRICE,
				PRICE_KDV,
				IS_KDV,
				ROUNDING,
				MONEY,
				UNIT_ID,
				START_DATE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				PROCESS_STAGE
			)
			VALUES
			(
				0,
				#attributes.pid#,
				1,
			<cfif is_kdv_f>
				#end_price_without_kdv#,
				#end_price#,
			<cfelse>
				#end_price#,
				#end_price_with_kdv#,
			</cfif>
				#is_kdv_f#,
				#attributes.rounding#,
				'#gelen_money#',
				#attributes.unit_id#,
				#startdate_00#,
				#NOW()#,
				#SESSION.EP.USERID#,
				'#CGI.REMOTE_ADDR#',
				#attributes.process_stage#
			)
		</cfquery>
		<cfquery name="UPD_PRICE_STANDART_SALES_STAT" datasource="#DSN3#">
			UPDATE
				#dsn1_alias#.PRICE_STANDART
			SET
				PRICESTANDART_STATUS = 0
			WHERE
				PRODUCT_ID = #attributes.pid# AND
				PURCHASESALES = 1 AND
				UNIT_ID = #attributes.unit_id# AND
				PRICESTANDART_STATUS = 1
		</cfquery>
		<cfquery name="GET_MAX_ST_DATE_ID" datasource="#DSN3#" maxrows="1">
			SELECT 
				MAX(PRICESTANDART_ID) AS PRICESTANDART_ID
			FROM 
				#dsn1_alias#.PRICE_STANDART 
			WHERE 
				PRODUCT_ID = #attributes.pid# AND
				PURCHASESALES = 1 AND
				UNIT_ID = #attributes.unit_id# AND 
				START_DATE = (	SELECT MAX(START_DATE) AS START_DATE 
								FROM #dsn1_alias#.PRICE_STANDART 
								WHERE PRODUCT_ID = #attributes.pid# AND PURCHASESALES = 1 AND UNIT_ID = #attributes.unit_id#)
		</cfquery>
		<cfquery name="UPD_PRICE_STANDART_SALES_STAT_1" datasource="#DSN3#">
			UPDATE
				#dsn1_alias#.PRICE_STANDART
			SET
				PRICESTANDART_STATUS = 1
			WHERE
				PRICESTANDART_ID = #GET_MAX_ST_DATE_ID.PRICESTANDART_ID#
		</cfquery>
        <!--- <cfquery name="GET_PRICE_CHANGE2" datasource="#DSN3#">
        	SELECT PRICE_CHANGE_ID FROM PRICE_CHANGE  WHERE PRODUCT_ID = #attributes.pid# AND PRICE_CATID = -2
        </cfquery>--->
        <cf_workcube_process
            data_source='#dsn3#'  
            is_upd='1' 
            old_process_line='0'
            process_stage='#attributes.process_stage#' 
            record_member='#session.ep.userid#' 
            record_date='#now()#' 
            action_table='PRICE_STANDART'
            action_column='PRICESTANDART_ID'
            action_id='#GET_MAX_ST_DATE_ID.PRICESTANDART_ID#'
            action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_price_change&event=det&pid=#attributes.pid#' 
            warning_description='Standart Satış'>
	<cfelse>
		<cfscript>
			uzunluk = ArrayLen(sp_array) + 1;
			sp_array[uzunluk][1] = '#attributes.pid#';			//product_id
			sp_array[uzunluk][2] = '#attributes.unit_id#';		//product_unit_id
			sp_array[uzunluk][3] = '#attributes.price_catid#';	//price_cat
			sp_array[uzunluk][4] = '#form.startdate#';			//start_date
			sp_array[uzunluk][5] = '#iif(is_kdv_f,end_price_without_kdv,end_price)#';	//price
			sp_array[uzunluk][6] = '#gelen_money#';				//price_money
			sp_array[uzunluk][7] = '#is_kdv_f#';				//is_kdv
			sp_array[uzunluk][8] = '#iif(is_kdv_f,end_price,end_price_with_kdv)#';		//price_with_kdv
		if(isdefined('attributes.stock_id_') and len(attributes.stock_id_) and isdefined('attributes.product_name_') and len('attributes.product_name_'))
			sp_array[uzunluk][9] = '#attributes.stock_id_#';	//stock_id
		else
			sp_array[uzunluk][9] =0;
			
		if(isdefined('attributes.spect_main_id') and len(attributes.spect_main_id) and isdefined('attributes.spect_name') and len('attributes.spect_name'))
			sp_array[uzunluk][10] = '#attributes.spect_main_id#';	//spect_main_id
		else
			sp_array[uzunluk][10] =0;
		</cfscript>
	</cfif>
	<cfoutput><cfif attributes.price_catid eq -1><cf_get_lang_main no='1310.Standart alış'> <cfelseif attributes.price_catid eq -2><cf_get_lang_main no='1309.Standart satış'> <cfelse>#attributes.price_catid# no lu </cfif><cf_get_lang no ='873.fiyat listesine fiyat eklendi'>  !</cfoutput> <br/>
</cfloop>
<cfif ArrayLen(sp_array)>
	<cfquery datasource="#dsn3#" name="new_price_add_method" timeout="600" result="xx">
		<cfloop from="1" to="#ArrayLen(sp_array)#" index="i">
			exec add_price
					#sp_array[i][1]#,
					#sp_array[i][2]#,
					#sp_array[i][3]#,
					#sp_array[i][4]#,
					#sp_array[i][5]#,
					'#sp_array[i][6]#',
					#sp_array[i][7]#,
					#sp_array[i][8]#,
					-1,
					#session.ep.userid#,
					'#cgi.remote_addr#',
					0,
					#sp_array[uzunluk][9]#,
					#sp_array[uzunluk][10]#
		</cfloop>
	</cfquery>
    <cfquery name="GET_MAX_ID" datasource="#dsn3#">
    	SELECT TOP 1 PRICE_ID,PRICE_CATID FROM PRICE  WHERE PRODUCT_ID =#attributes.pid# ORDER BY PRICE_ID DESC 
    </cfquery>
    <!---<cfquery name="GET_PRICE_CHANGE2" datasource="#DSN3#">
        SELECT PRICE_CHANGE_ID FROM PRICE_CHANGE  WHERE PRODUCT_ID = #attributes.pid# AND PRICE_CATID = #GET_MAX_ID.PRICE_CATID#
    </cfquery>--->
    <cfquery name="get_name" datasource="#dsn3#">
    	SELECT PRICE_CAT FROM PRICE_CAT WHERE PRICE_CATID = #GET_MAX_ID.PRICE_CATID#
    </cfquery>
        <cf_workcube_process
            data_source='#dsn3#'  
            is_upd='1' 
            old_process_line='0'
            process_stage='#attributes.process_stage#' 
            record_member='#session.ep.userid#' 
            record_date='#now()#' 
            action_table='PRICE'
            action_column='PRICE_ID'
            action_id='#GET_MAX_ID.PRICE_ID#'
            action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_price_change&event=det&pid=#attributes.pid#' 
            warning_description='#get_name.PRICE_CAT#'>
</cfif>
<script type="text/javascript">
	<cfif cgi.referer contains "popup" and (not cgi.referer contains "collected=1")>
		wrk_opener_reload();
		<cfif not isDefined('attributes.draggable') or attributes.draggable eq 1>
			window.close();
		</cfif>
		location.href = document.referrer;
	<cfelseif cgi.referer contains "collected=1">
		<cfif not isDefined('attributes.draggable') or attributes.draggable eq 1>
			window.close();
		</cfif>
		location.href = document.referrer;
	<cfelse>
		window.location = '<cfoutput>#cgi.referer#</cfoutput>';
	</cfif>	
</script>

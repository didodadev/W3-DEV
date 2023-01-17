<cfquery name="GET_EXCHANGE" datasource="#dsn2#">
	SELECT
		*
	FROM
		STOCK_EXCHANGE
	WHERE
		STOCK_EXCHANGE_ID = #attributes.exchange_id#
</cfquery>
<cfif GET_EXCHANGE.STOCK_EXCHANGE_TYPE eq 1>
	<cfquery name="get_spect_id" datasource="#dsn3#">
		SELECT
			SM.SPECT_MAIN_ID,
			SM.SPECT_MAIN_NAME,
			SMR.AMOUNT,
			SMR.PRODUCT_NAME,
			IS_SEVK,
			S.STOCK_CODE
		FROM
			SPECT_MAIN SM,
			SPECT_MAIN_ROW SMR,
			#dsn1_alias#.STOCKS S
		WHERE 
			SM.SPECT_MAIN_ID = SMR.SPECT_MAIN_ID AND
			SM.SPECT_MAIN_ID = #GET_EXCHANGE.SPECT_MAIN_ID# AND
			SMR.STOCK_ID = S.STOCK_ID
	</cfquery>
	<cfquery name="get_spect_old" datasource="#dsn3#">
		SELECT
			SM.SPECT_MAIN_ID,
			SM.SPECT_MAIN_NAME,
			SMR.AMOUNT,
			SMR.PRODUCT_NAME,
			IS_SEVK,
			S.STOCK_CODE
		FROM
			SPECT_MAIN SM,
			SPECT_MAIN_ROW SMR,
			#dsn1_alias#.STOCKS S
		WHERE 
			SM.SPECT_MAIN_ID = SMR.SPECT_MAIN_ID AND
			SM.SPECT_MAIN_ID = #GET_EXCHANGE.EXIT_SPECT_MAIN_ID# AND
			SMR.STOCK_ID = S.STOCK_ID
	</cfquery>
	<br/>
	<table width="98%" cellpadding="2" cellspacing="1" align="center" class="color-border">
		<tr height="35" class="color-row">
			<td valign="top" colspan="2">
			<table width="100%" align="center" border="0" cellpadding="2" height="100%">
				<cfoutput>
					<tr>
						<td width="50%"><cf_get_lang dictionary_id='57742.Tarih'>: #dateformat(get_exchange.process_date,dateformat_style)#</td>
						<td width="50%"><cf_get_lang dictionary_id='33654.Eski Spec'>:#get_spect_old.spect_main_id# #get_spect_old.spect_main_name#</td>
					</tr>
					<tr>
						<td width="50%"><cf_get_lang dictionary_id='57899.Kaydeden'>: #get_emp_info(get_exchange.record_emp,0,0)#</td>
						<td width="50%"><cf_get_lang dictionary_id='33655.Yeni Spec'>:#get_spect_id.spect_main_id# #get_spect_id.spect_main_name#</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='57635.Miktar'>: #TLFormat(get_exchange.amount,3)#</td>
					</tr>
				</cfoutput>
			</table>
			</td>
		</tr>
		<tr class="color-row" valign="top" height="100%">
			<td>
			<table width="100%" align="center" border="0" cellpadding="2" height="100%">	
				<tr class="color-row" height="100%">
					<td class="txtbold"><cf_get_lang dictionary_id='33656.Giren'>: <cfoutput>#get_spect_old.spect_main_name#</cfoutput></td>
				</tr>
				<tr>
					<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="2" class="color-border">
						<tr class="color-header" height="100%"> 
							<td class="form-title"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
							<td class="form-title"><cf_get_lang dictionary_id='58221.Ürün Adı'></td>
							<td class="form-title"><cf_get_lang dictionary_id='57635.Miktar'></td>
							<td class="form-title">SB</td>
						</tr>
						<cfoutput query="get_spect_old">
							<tr class="color-row">
								<td>#stock_code#</td>
								<td>#product_name#</td>
								<td>#amount#</td>
								<td>#is_sevk#</td>
							</tr>
						</cfoutput>
					</table>					
					</td>
				</tr>
			</table>
			</td>
			<td>
			<table width="100%" height="100%" align="center" border="0" cellpadding="2">	
				<tr class="color-row" height="100%">
					<td class="txtbold"><cf_get_lang dictionary_id='33657.Çıkan'>: <cfoutput>#get_spect_id.spect_main_name#</cfoutput></td>
				</tr>
				<tr>
					<td> 
					<table width="100%" border="0" cellspacing="1" cellpadding="2" class="color-border">
						<tr class="color-header" height="100%"> 
							<td class="form-title"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
							<td class="form-title"><cf_get_lang dictionary_id='58221.Ürün Adı'></td>
							<td class="form-title"><cf_get_lang dictionary_id='57635.Miktar'></td>
							<td class="form-title">SB</td>
						</tr>
						<cfoutput query="get_spect_id">
							<tr class="color-row">
								<td>#stock_code#</td>
								<td>#product_name#</td>
								<td>#amount#</td>
								<td>#is_sevk#</td>
							</tr>
						</cfoutput>
					</table>
					</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
<cfelse>
	<cfquery name="GET_EXCHANGE" datasource="#dsn2#">
		SELECT
		STOCK_EXCHANGE.STOCK_EXCHANGE_ID,
		STOCK_EXCHANGE.EXCHANGE_NUMBER,
		STOCK_EXCHANGE.PROCESS_CAT,
		STOCK_EXCHANGE.PROCESS_DATE,
		STOCK_EXCHANGE.RECORD_EMP,
		STOCK_EXCHANGE.RECORD_DATE,
		STOCK_EXCHANGE.UPDATE_EMP,
		STOCK_EXCHANGE.UPDATE_DATE,
		STOCK_EXCHANGE.DEPARTMENT_ID,
		STOCK_EXCHANGE.LOCATION_ID,
		STOCK_EXCHANGE.STOCK_ID,
		STOCK_EXCHANGE.PRODUCT_ID,
		S1.STOCK_CODE,
		S1.PRODUCT_NAME,
		STOCK_EXCHANGE.SPECT_MAIN_ID,
		STOCK_EXCHANGE.AMOUNT,
		STOCK_EXCHANGE.SPECT_MAIN_ID,
		STOCK_EXCHANGE.UNIT,
		STOCK_EXCHANGE.UNIT_ID,
		STOCK_EXCHANGE.UNIT2,
		STOCK_EXCHANGE.EXIT_DEPARTMENT_ID,
		STOCK_EXCHANGE.EXIT_LOCATION_ID,
		STOCK_EXCHANGE.EXIT_STOCK_ID,
		STOCK_EXCHANGE.EXIT_PRODUCT_ID,
		S2.STOCK_CODE EXIT_STOCK_CODE,
		S2.PRODUCT_NAME EXIT_PRODUCT_NAME,
		STOCK_EXCHANGE.EXIT_SPECT_MAIN_ID,
		STOCK_EXCHANGE.EXIT_AMOUNT,
		STOCK_EXCHANGE.EXIT_UNIT,
		STOCK_EXCHANGE.EXIT_UNIT_ID,
		STOCK_EXCHANGE.EXIT_UNIT2
	FROM
		STOCK_EXCHANGE,
		#dsn3_alias#.STOCKS S1,
		#dsn3_alias#.STOCKS S2
	WHERE
		STOCK_EXCHANGE.EXCHANGE_NUMBER = '#GET_EXCHANGE.EXCHANGE_NUMBER#' AND
		S1.STOCK_ID = STOCK_EXCHANGE.STOCK_ID AND
		S2.STOCK_ID = STOCK_EXCHANGE.EXIT_STOCK_ID 
	</cfquery>
	<cfset exchange_spec_list=listsort(valuelist(GET_EXCHANGE.SPECT_MAIN_ID,','),'numeric','ASC')>
	<cfset exchange_spec_list=listsort(listappend(exchange_spec_list,valuelist(GET_EXCHANGE.EXIT_SPECT_MAIN_ID,',')),'numeric','ASC')>
	<cfif listlen(exchange_spec_list,',')>
		<cfquery name="GET_SPEC_NAME_ALL" datasource="#dsn3#">
			SELECT 
				SPECT_MAIN_ID,
				SPECT_MAIN_NAME 
			FROM 
				SPECT_MAIN 
			WHERE 
				SPECT_MAIN_ID IN (#exchange_spec_list#)
		</cfquery>
	</cfif>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58824.Stok Virman'></cfsavecontent>
	<cf_popup_box title='#message#'>
	<table width="100%" align="center" border="0" cellpadding="2" height="100%" >
        <tr>
            <td class="txtbold"><cf_get_lang dictionary_id="57880.Belge No">:</td><td><cfoutput>#GET_EXCHANGE.EXCHANGE_NUMBER#</cfoutput></td>
            <td class="txtbold"><cf_get_lang dictionary_id='57742.Tarih'>:</td><td><cfoutput>#dateformat(GET_EXCHANGE.PROCESS_DATE,dateformat_style)#</cfoutput></td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang dictionary_id="33658.Giriş Depo">:</td><td><cfoutput>#listfirst(get_location_info(GET_EXCHANGE.DEPARTMENT_ID,GET_EXCHANGE.LOCATION_ID,1,1))#</cfoutput></td>
            <td class="txtbold"><cf_get_lang dictionary_id="29428.Çıkış Depo">:</td><td><cfoutput>#listfirst(get_location_info(GET_EXCHANGE.EXIT_DEPARTMENT_ID,GET_EXCHANGE.EXIT_LOCATION_ID,1,1))#</cfoutput></td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang dictionary_id='57899.Kaydeden'>:</td><td><cfoutput>#get_emp_info(GET_EXCHANGE.RECORD_EMP,0,0)# (#dateformat(GET_EXCHANGE.RECORD_DATE,dateformat_style)#)</cfoutput></td>
            <td class="txtbold"><cfif len(GET_EXCHANGE.UPDATE_EMP)><cf_get_lang dictionary_id='57891.Güncelleyen'>:</td><td><cfoutput>#get_emp_info(GET_EXCHANGE.UPDATE_EMP,0,0)# (#dateformat(GET_EXCHANGE.UPDATE_DATE,dateformat_style)#)</cfoutput></td></cfif>
        </tr>
	</table>
	<br />
	<cf_form_list>
		<thead>
			<tr>
				<th colspan="6" class="txtbold"><cf_get_lang dictionary_id="32957.Çıkan Ürünler"></th>
				<th></th>
				<th colspan="6" class="txtbold"><cf_get_lang dictionary_id="32958.Giren Ürünler"></th>
			</tr>
			<tr class="color-header" height="35">
				<th class="form-title" ><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
				<th class="form-title"><cf_get_lang dictionary_id='57657.Ürün Adı'></th>
				<th class="form-title"><cf_get_lang dictionary_id='57647.Spec adı'></th>
				<th class="form-title"><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th class="form-title"><cf_get_lang dictionary_id='57636.Birim'></th>
				<th class="form-title">2.<cf_get_lang dictionary_id='57636.Birim'></th>
				<th style="width:3px;" class="color-row">&nbsp;</th>
				<th class="form-title"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
				<th class="form-title"><cf_get_lang dictionary_id='57657.Ürün Adı'></th>
				<th class="form-title"><cf_get_lang dictionary_id='57647.Spec'></th>
				<th class="form-title"><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th class="form-title"><cf_get_lang dictionary_id='57636.Birim'></th>
				<th class="form-title">2.<cf_get_lang dictionary_id='57636.Birim'></th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="GET_EXCHANGE">
				<tr valign="top">
					<td>#EXIT_STOCK_CODE#</td>
					<td>#EXIT_PRODUCT_NAME#</td>
					<td>
						<cfif len(EXIT_SPECT_MAIN_ID)>
							<cfquery name="GET_SPEC_NAME" dbtype="query">
							SELECT 
								SPECT_MAIN_NAME 
							FROM 
								GET_SPEC_NAME_ALL 
							WHERE 
								SPECT_MAIN_ID =#EXIT_SPECT_MAIN_ID#
							</cfquery>
						#GET_SPEC_NAME.SPECT_MAIN_NAME#
						</cfif>
					</td>
					<td>#TLFormat(EXIT_AMOUNT,3)#</td>
					<td>#EXIT_UNIT#</td>
					<td>#EXIT_UNIT2#</td>
					<td style="width:3px;">&nbsp;</td>
					<td>#STOCK_CODE#</td>
					<td>#PRODUCT_NAME#</td>
					<td>
						<cfif len(SPECT_MAIN_ID)>
							<cfquery name="GET_SPEC_NAME" dbtype="query">
							SELECT 
								SPECT_MAIN_NAME 
							FROM 
								GET_SPEC_NAME_ALL 
							WHERE 
								SPECT_MAIN_ID =#SPECT_MAIN_ID#
							</cfquery>
						#GET_SPEC_NAME.SPECT_MAIN_NAME#
						</cfif>
					</td>
					<td>#AMOUNT#</td>
					<td>#UNIT#</td>
					<td>#UNIT2#</td>
				</tr>
			</cfoutput>
		</tbody>
	</cf_form_list>
</cf_popup_box>
</cfif>

<cfsetting requesttimeout="3000">
<script>
	function basamak_1()
	{
		if(confirm(" <cf_get_lang dictionary_id='867.Konsinye Aktarım İşlemi Yapacaksınız ! Bu İşlem Geri Alınamaz ! Emin misiniz'>?"))
			document.form_.submit();
		else 
			return false;
	}
	function basamak_2()
	{
		if(confirm(" <cf_get_lang dictionary_id='867.Konsinye Aktarım İşlemi Yapacaksınız ! Bu İşlem Geri Alınamaz ! Emin misiniz'>?"))
			document.form1_.submit();
		else 
			return false;
	}
	$(document).ready(function(){
		<cfif NOT (isdefined("attributes.source_period") and len(attributes.source_period))>
			var company_id = document.getElementById('source_period').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'kaynak_period_1',1,'Dönemler');
		</cfif>
	}
	)
	function show_periods_departments(number)
	{
		if(number == 1)
		{
			if(document.getElementById('source_period').value != '')
			{
				var company_id = document.getElementById('source_period').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'kaynak_period_1',1,'Dönemler');
			}
		}
	}
</script>
<cfquery name="get_periods" datasource="#dsn#">
	SELECT 
    	PERIOD_ID, 
        PERIOD, 
        PERIOD_YEAR, 
        OUR_COMPANY_ID, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE,
        UPDATE_IP, 
        UPDATE_EMP
    FROM 
    	SETUP_PERIOD 
    ORDER BY 
	    OUR_COMPANY_ID,PERIOD_YEAR
</cfquery>
<cfquery name="get_companies" datasource="#dsn#">
	SELECT 
    	COMP_ID, 
        COMPANY_NAME
    FROM 
	    OUR_COMPANY 
</cfquery>
<cfsavecontent variable = "title">
	<cf_get_lang no='30.Konsinye Aktarımı'>
</cfsavecontent>
<cf_box title="#title#">
<cfif not isdefined("attributes.hedef_period")>
<form name="form_" method="post"action="">
	<cf_area width="50%">
		<table>
			<tr>
				<td><cf_get_lang no ='1784.Kaynak Dönem'></td>
				<td>
					<select name="source_period" id="source_period" onchange="show_periods_departments(1)">
						<cfoutput query="get_companies">
							<option value="#comp_id#" <cfif isdefined("attributes.kaynak_period_1") and attributes.kaynak_period_1 eq comp_id>selected<cfelseif comp_id eq session.ep.company_id>selected</cfif>>#COMPANY_NAME#</option>
						</cfoutput>
					</select>
				</td>
				<td>
				<div id="period_div">
					<select name="kaynak_period_1" id="kaynak_period_1" style="width:220px;">
						<cfif isdefined("attributes.source_period") and len(attributes.source_period)>
							<cfquery name="get_periods" datasource="#dsn#">
								SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #attributes.source_period# ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
							</cfquery>
							<cfoutput query="get_periods">				
								<option value="#period_id#" <cfif isdefined("attributes.kaynak_period_1") and attributes.kaynak_period_1 eq period_id>selected</cfif>>#period#</option>						
							</cfoutput>
						</cfif>
					</select>				
				</div>
			</td>
				<td colspan="2" align="right"><input type="button" value="<cf_get_lang dictionary_id='43996.Dönem Aktar'>" onClick="basamak_1();"></td>
			</tr>
		</table>
	</cf_area>
	<cf_area width="50%">
		<table>
			<tr height="30">
				<td class="headbold" valign="top"><cf_get_lang_main no='21.Yardım'></td>
			</tr>    
			<tr>
				<td valign="top"> 
					<cftry>
						<cfinclude template="#file_web_path#templates/period_help/consignmentTransfer_#session.ep.language#.html">
						<cfcatch>
							<script type="text/javascript">
								alert("<cf_get_lang_main no='1963.Yardım Dosyası Bulunamadı Lutfen Kontrol Ediniz'>");
							</script>
						</cfcatch>
					</cftry>
				</td>
			</tr>
		</table>
	</cf_area>
</form>
</cfif>
<cfif isdefined("attributes.kaynak_period_1")>
	<cfif not len(attributes.kaynak_period_1)>
		<script>
			alert("<cf_get_lang no ='2064.Kaynak Dönem Secmelisiniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>	
	<cfquery name="get_kaynak_period" datasource="#dsn#">
		SELECT 
            PERIOD_ID, 
            PERIOD, 
            PERIOD_YEAR, 
            OUR_COMPANY_ID, 
            RECORD_DATE, 
            RECORD_IP, 
            RECORD_EMP, 
            UPDATE_DATE,
            UPDATE_IP, 
            UPDATE_EMP
        FROM 
	        SETUP_PERIOD 
        WHERE 
        	PERIOD_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.kaynak_period_1#">
	</cfquery>
	<cfquery name="get_hedef_period" datasource="#dsn#">
		SELECT 
            PERIOD_ID, 
            PERIOD, 
            PERIOD_YEAR, 
            OUR_COMPANY_ID, 
            RECORD_DATE, 
            RECORD_IP, 
            RECORD_EMP, 
            UPDATE_DATE,
            UPDATE_IP, 
            UPDATE_EMP
        FROM 
	        SETUP_PERIOD 
        WHERE 
        	PERIOD_YEAR= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_kaynak_period.period_year+1#">
			AND OUR_COMPANY_ID = #get_kaynak_period.OUR_COMPANY_ID#
	</cfquery>
	<cfif get_hedef_period.recordcount eq 0>
		<script>
			alert("Seçtiğiniz Şirkete Ait Dönem Tanımı Bulunmamaktadır !");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<table align="center" width="98%">
		<tr>
			<td>
			<form action="" name="form1_" method="post">
				<input type="hidden" name="aktarim_hedef_period" id="aktarim_hedef_period" value="<cfoutput>#get_hedef_period.period_id#</cfoutput>">
				<input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#get_kaynak_period.period_id#</cfoutput>">
				<input type="hidden" name="aktarim_kaynak_year" id="aktarim_kaynak_year" value="<cfoutput>#get_kaynak_period.period_year#</cfoutput>">
				<input type="hidden" name="aktarim_kaynak_company" id="aktarim_kaynak_company" value="<cfoutput>#get_kaynak_period.our_company_id#</cfoutput>">
				<input type="hidden" name="aktarim_hedef_year" id="aktarim_hedef_year" value="<cfoutput>#get_kaynak_period.period_year+1#</cfoutput>">
				<input type="hidden" name="aktarim_hedef_company" id="aktarim_hedef_company" value="<cfoutput>#get_kaynak_period.OUR_COMPANY_ID#</cfoutput>">
				<cf_get_lang no ='2028.Kaynak Veri Tabanı'>: <cfoutput>#get_kaynak_period.period# (#get_kaynak_period.period_year#)</cfoutput><br/>
				<cf_get_lang no ='2029.Hedef Veri Tabanı'> : <cfoutput>#get_hedef_period.period# (#get_kaynak_period.period_year+1#)</cfoutput><br/>
				<input type="button" value="<cf_get_lang no ='2027.Aktarımı Başlat'>" onClick="basamak_2();">
			</form>
			</td>
		</tr>
	</table>
</cfif>	
<cfif isdefined("attributes.aktarim_hedef_company")>
	<cfset hedef_dsn2 = '#dsn#_#attributes.aktarim_hedef_year#_#attributes.aktarim_hedef_company#'>
	<cfset hedef_dsn3 = '#dsn#_#attributes.aktarim_hedef_company#'>
	<cfset kaynak_dsn3 = '#dsn#_#attributes.aktarim_kaynak_company#'>
	<cfset kaynak_dsn2 = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#'>
	<cfquery name="get_all_periods" dbtype="query">
		SELECT 
			* 
		FROM 
			get_periods
		WHERE
			OUR_COMPANY_ID = #attributes.aktarim_kaynak_company#
			AND PERIOD_YEAR = #attributes.aktarim_kaynak_year#
		ORDER BY 
			PERIOD_YEAR
	</cfquery> 
	<cfquery name="get_all_periods_new" dbtype="query">
		SELECT 
			* 
		FROM 
			get_periods
		WHERE
			OUR_COMPANY_ID = #attributes.aktarim_kaynak_company#
			AND PERIOD_YEAR < #attributes.aktarim_hedef_year#
		ORDER BY 
			PERIOD_YEAR
	</cfquery>
	<cfset list_period_years=valuelist(get_all_periods_new.period_year)>
	<cfquery name="check_table_ship" datasource="#kaynak_dsn2#">
		SELECT * FROM sysobjects WHERE TYPE='U' AND NAME='GET_ALL_SHIP_TEMP_TABLE_TRANSFER'
	</cfquery>
	<cfif check_table_ship.recordcount>
		<cfquery name="check_table_drop" datasource="#kaynak_dsn2#">
			DROP TABLE GET_ALL_SHIP_TEMP_TABLE_TRANSFER
		</cfquery>
	</cfif>
	<cfquery name="del_old_record" datasource="#hedef_dsn2#">
		DELETE FROM PRE_CONSIGNMENT_SHIP WHERE PERIOD_ID = #attributes.aktarim_kaynak_period#
	</cfquery>
	<cfquery name="EditTableGelAllShip" datasource="#kaynak_dsn2#">
		SELECT
			* ,ROW_NUMBER() OVER(ORDER BY TABLE1.ISLEM_TARIHI) AS RowNum
		INTO 
			GET_ALL_SHIP_TEMP_TABLE_TRANSFER
		FROM 
			(
				<cfloop query="get_all_periods">
					SELECT
						#get_all_periods.period_id# AS SHIP_PERIOD,
						SHIP.SHIP_ID,
						SHIP.SHIP_NUMBER AS BELGE_NO,
						SHIP.SHIP_DATE AS ISLEM_TARIHI,
						SHIP.COMPANY_ID,
						SHIP.CONSUMER_ID,
						SHIP.PARTNER_ID,
						SHIP.SALE_EMP,
						DELIVER_EMP AS DELIVER_EMP,
						SHIP.DELIVER_STORE_ID AS DEPARTMENT_ID_2,
						SHIP.LOCATION,
						SPC.PROCESS_CAT BELGE_TURU,
						SHIP.PROCESS_CAT,
						SHIP.PROJECT_ID,
						SHIP.SHIP_TYPE,
						SHIP.SUBSCRIPTION_ID,
						S.STOCK_CODE,
						S.PRODUCT_ID,
						S.STOCK_ID,
						S.PRODUCT_NAME,
						ABS(SUM(GSRC.STOCK_IN-GSRC.STOCK_OUT)) AS PAPER_AMOUNT,
						GSRC.MALIYET COST_AMOUNT,
						(SELECT SM.SPECT_MAIN_ID FROM #hedef_dsn3#.SPECTS SM WHERE SM.SPECT_VAR_ID = SRR.SPECT_VAR_ID) SPECT_MAIN_ID
					FROM 
						#kaynak_dsn2#.SHIP SHIP,
						#kaynak_dsn2#.SHIP_ROW SRR,
						#kaynak_dsn2#.GET_STOCKS_ROW_COST GSRC,
						#kaynak_dsn3#.STOCKS S,
						#kaynak_dsn3#.SETUP_PROCESS_CAT SPC
					WHERE 
						GSRC.UPD_ID = SHIP.SHIP_ID
						AND GSRC.PROCESS_TYPE = SHIP.SHIP_TYPE
						AND SRR.SHIP_ID = SHIP.SHIP_ID
						AND SRR.STOCK_ID = S.STOCK_ID
						AND SHIP.IS_SHIP_IPTAL = 0 
						AND GSRC.STOCK_ID = S.STOCK_ID
						AND SHIP.IS_WITH_SHIP=0
						AND SHIP.SHIP_TYPE = SPC.PROCESS_TYPE
						AND SHIP.PROCESS_CAT = 	SPC.PROCESS_CAT_ID
						AND SHIP.SHIP_TYPE =  72
					GROUP BY
						SHIP.SHIP_ID,
						SHIP.SHIP_NUMBER,
						SHIP.SHIP_DATE,
						SHIP.COMPANY_ID,
						SHIP.CONSUMER_ID,
						SHIP.PARTNER_ID,
						SHIP.SALE_EMP,
						DELIVER_EMP,
						DELIVER_EMP,
						SHIP.DELIVER_STORE_ID,
						SHIP.LOCATION,
						SPC.PROCESS_CAT,
						SHIP.PROCESS_CAT,
						SHIP.PROJECT_ID,
						SHIP.SHIP_TYPE,
						SHIP.SUBSCRIPTION_ID,
						S.STOCK_CODE,
						S.PRODUCT_ID,
						S.STOCK_ID,
						S.PRODUCT_NAME,
						GSRC.MALIYET,
						SRR.SPECT_VAR_ID
				<cfif get_all_periods.recordcount neq currentrow>UNION ALL</cfif>
				</cfloop>
				UNION ALL
				<cfloop query="get_all_periods_new">
					SELECT
						PERIOD_ID AS SHIP_PERIOD,
						SHIP.SHIP_ID,
						SHIP.SHIP_NUMBER AS BELGE_NO,
						SHIP.SHIP_DATE AS ISLEM_TARIHI,
						SHIP.COMPANY_ID,
						SHIP.CONSUMER_ID,
						SHIP.PARTNER_ID,
						'' SALE_EMP,
						'' AS DELIVER_EMP,
						DEPARTMENT_ID AS DEPARTMENT_ID_2,
						SHIP.LOCATION_ID LOCATION,
						'' BELGE_TURU,
						SHIP.PROCESS_CAT,
						SHIP.PROJECT_ID,
						SHIP.SHIP_TYPE,
						SHIP.SUBSCRIPTION_ID,
						'' STOCK_CODE,
						SHIP.PRODUCT_ID,
						SHIP.STOCK_ID,
						'' PRODUCT_NAME,
						REMAIN_AMOUNT AS PAPER_AMOUNT,
						COST_VALUE COST_AMOUNT,
						SHIP.SPECT_MAIN_ID
					FROM 
						#kaynak_dsn2#.PRE_CONSIGNMENT_SHIP SHIP
					<cfif get_all_periods_new.recordcount neq currentrow>UNION ALL</cfif>
				</cfloop>
			)
		TABLE1
		ORDER BY RowNum
	</cfquery>
	<cfquery name="check_table_ship" datasource="#kaynak_dsn2#">
		SELECT * FROM sysobjects WHERE TYPE='U' AND NAME='GET_ALL_SHIP_TEMP_TABLE_TRANSFER'
	</cfquery>
	<cfif check_table_ship.recordcount>
		<cfquery name="GET_ALL_SHIP" datasource="#kaynak_dsn2#" cachedwithin="#fusebox.general_cached_time#">
			SELECT * FROM GET_ALL_SHIP_TEMP_TABLE_TRANSFER  ORDER BY RowNum  
		</cfquery>
		<cfoutput query="GET_ALL_SHIP">
			<cfif isdefined('ship_list_#GET_ALL_SHIP.SHIP_PERIOD#') and not listfind(evaluate('ship_list_#GET_ALL_SHIP.SHIP_PERIOD#'),ship_id)>
				<cfset 'ship_list_#GET_ALL_SHIP.SHIP_PERIOD#' = listappend(evaluate('ship_list_#GET_ALL_SHIP.SHIP_PERIOD#'),ship_id,',')>
			<cfelse>
				<cfset 'ship_list_#GET_ALL_SHIP.SHIP_PERIOD#' = ship_id>
			</cfif>
		</cfoutput>
		<cfset count_ship =0>
		<cfsavecontent variable="all_query">
			<cfoutput>
			<cfloop query="get_all_periods_new">
			<cfif isdefined('ship_list_#get_all_periods_new.PERIOD_ID#') and len(evaluate('ship_list_#get_all_periods_new.PERIOD_ID#'))>
				<cfset count_ship =count_ship+1>
				<cfif count_ship neq 1> UNION ALL </cfif>					
				SELECT
					SUM(AMOUNT) AS AMOUNT,
					PRODUCT_ID,
					STOCK_ID,
					TO_SHIP_ID,
					TO_SHIP_TYPE,
					S.SHIP_NUMBER AS TO_SHIP_NUMBER,
					YEAR(S.SHIP_DATE) AS SHIP_YEAR,
					SRR.SHIP_ID,
					SRR.SHIP_PERIOD,
					ISNULL((SELECT
						TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
					FROM 
						#dsn#_#get_all_periods_new.PERIOD_YEAR#_#get_all_periods_new.OUR_COMPANY_ID#.GET_PRODUCT_COST_PERIOD GPCP
					WHERE
						GPCP.START_DATE <= S.SHIP_DATE
						AND GPCP.PRODUCT_ID = SRR.PRODUCT_ID
					ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC, GPCP.PURCHASE_NET_SYSTEM DESC
						),0) AS SHIP_TOTAL_COST			
				FROM
					#dsn#_#get_all_periods_new.PERIOD_YEAR#_#get_all_periods_new.OUR_COMPANY_ID#.SHIP_ROW_RELATION SRR,
					#dsn#_#get_all_periods_new.PERIOD_YEAR#_#get_all_periods_new.OUR_COMPANY_ID#.SHIP S
				WHERE
					SRR.SHIP_ID IN (#evaluate('ship_list_#get_all_periods_new.PERIOD_ID#')#)
					AND SRR.TO_SHIP_ID = S.SHIP_ID
					AND SRR.TO_SHIP_TYPE = S.SHIP_TYPE
					AND SHIP_PERIOD=#get_all_periods_new.PERIOD_ID#
					AND S.IS_WITH_SHIP = 0
					AND S.SHIP_TYPE IN (75,79)
					AND SRR.TO_SHIP_ID IS NOT NULL
				GROUP BY
					SRR.SHIP_ID,
					SRR.SHIP_PERIOD,
					TO_SHIP_ID,
					TO_SHIP_TYPE,
					S.SHIP_DATE,
					YEAR(S.SHIP_DATE),
					SHIP_NUMBER,
					PRODUCT_ID,
					STOCK_ID
				<cfif isdefined('list_period_years') and listfind(list_period_years,(get_all_periods_new.PERIOD_YEAR+1))>
				UNION ALL
				SELECT
					SUM(AMOUNT) AS AMOUNT,
					PRODUCT_ID,
					STOCK_ID,
					TO_SHIP_ID,
					TO_SHIP_TYPE,
					S.SHIP_NUMBER AS TO_SHIP_NUMBER,
					YEAR(S.SHIP_DATE) AS SHIP_YEAR,
					SRR.SHIP_ID,
					SRR.SHIP_PERIOD,
					ISNULL((SELECT
						TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
					FROM 
						#dsn#_#get_all_periods_new.PERIOD_YEAR#_#get_all_periods_new.OUR_COMPANY_ID#.GET_PRODUCT_COST_PERIOD GPCP
					WHERE
						GPCP.START_DATE <= S.SHIP_DATE
						AND GPCP.PRODUCT_ID = SRR.PRODUCT_ID
					ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC, GPCP.PURCHASE_NET_SYSTEM DESC
						),0) AS SHIP_TOTAL_COST			
				FROM
					#dsn#_#get_all_periods_new.PERIOD_YEAR+1#_#get_all_periods_new.OUR_COMPANY_ID#.SHIP_ROW_RELATION SRR,
					#dsn#_#get_all_periods_new.PERIOD_YEAR+1#_#get_all_periods_new.OUR_COMPANY_ID#.SHIP S
				WHERE
					SRR.SHIP_ID IN (#evaluate('ship_list_#get_all_periods_new.PERIOD_ID#')#)
					AND SRR.TO_SHIP_ID = S.SHIP_ID
					AND SRR.TO_SHIP_TYPE = S.SHIP_TYPE
					AND SHIP_PERIOD=#get_all_periods_new.PERIOD_ID#
					AND S.IS_WITH_SHIP = 0
					AND S.SHIP_TYPE IN (75,79)
					AND SRR.TO_SHIP_ID IS NOT NULL
				GROUP BY
					SRR.SHIP_ID,
					SRR.SHIP_PERIOD,
					TO_SHIP_ID,
					TO_SHIP_TYPE,
					S.SHIP_DATE,
					SHIP_NUMBER,
					YEAR(S.SHIP_DATE),
					PRODUCT_ID,
					STOCK_ID
				</cfif>
			</cfif>
			</cfloop>
			</cfoutput>
		</cfsavecontent>
		<cfif len(all_query)>
			<cfquery name="get_all_ship_amount_2" datasource="#dsn#">
				SELECT
					SUM(AMOUNT) AS AMOUNT,
					PRODUCT_ID,
					STOCK_ID,
					TO_SHIP_ID,
					TO_SHIP_TYPE,
					TO_SHIP_NUMBER,
					SHIP_YEAR,
					SHIP_ID,
					SHIP_PERIOD,
					SUM(SHIP_TOTAL_COST*AMOUNT) AS SHIP_TOTAL_COST
				FROM
				(
					#all_query#
				) AS A1
				GROUP BY
					PRODUCT_ID,
					STOCK_ID,
					TO_SHIP_ID,
					TO_SHIP_TYPE,
					TO_SHIP_NUMBER,
					SHIP_ID,
					SHIP_PERIOD,
					SHIP_YEAR
				ORDER BY TO_SHIP_ID
			</cfquery>
		<cfelse>
			<cfset get_all_ship_amount_2.recordcount = 0>
		</cfif>
		<cfif get_all_ship_amount_2.recordcount>
			<cfquery name="get_all_ship_amount" dbtype="query">
				SELECT
					SUM(AMOUNT) AS AMOUNT,
					PRODUCT_ID,
					STOCK_ID,
					TO_SHIP_ID,
					TO_SHIP_TYPE,
					TO_SHIP_NUMBER,
					SHIP_ID,
					SHIP_PERIOD,
					SUM(SHIP_TOTAL_COST) AS SHIP_TOTAL_COST
				FROM
					get_all_ship_amount_2
				GROUP BY
					PRODUCT_ID,
					STOCK_ID,
					TO_SHIP_ID,
					TO_SHIP_TYPE,
					TO_SHIP_NUMBER,
					SHIP_ID,
					SHIP_PERIOD
				ORDER BY TO_SHIP_ID
			</cfquery>
		<cfelse>
			<cfset get_all_ship_amount.recordcount=0>
		</cfif>
		<cfsavecontent variable="all_query_2">
			<cfoutput>
			<cfset count_ship =0>
			<cfloop query="get_all_periods_new">
			<cfif isdefined('ship_list_#get_all_periods_new.PERIOD_ID#') and len(evaluate('ship_list_#get_all_periods_new.PERIOD_ID#'))>
				<cfset count_ship =count_ship+1>
				<cfif count_ship neq 1> UNION ALL </cfif>
				SELECT
					SUM(AMOUNT) AS AMOUNT,
					YEAR(INVOICE_DATE) AS INVOICE_YEAR,
					PRODUCT_ID,
					STOCK_ID,
					SRR.TO_INVOICE_ID,
					SRR.TO_INVOICE_CAT,
					INV.INVOICE_NUMBER AS TO_INVOICE_NUMBER,
					SRR.SHIP_ID,
					SRR.SHIP_PERIOD,
					ISNULL((SELECT
						TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
					FROM 
						#dsn#_#get_all_periods_new.PERIOD_YEAR#_#get_all_periods_new.OUR_COMPANY_ID#.GET_PRODUCT_COST_PERIOD GPCP
					WHERE
						GPCP.START_DATE <= INV.INVOICE_DATE
						AND GPCP.PRODUCT_ID = SRR.PRODUCT_ID
					ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC, GPCP.PURCHASE_NET_SYSTEM DESC
						),0) AS INV_TOTAL_COST							
				FROM
					#dsn#_#get_all_periods_new.PERIOD_YEAR#_#get_all_periods_new.OUR_COMPANY_ID#.SHIP_ROW_RELATION SRR,
					#dsn#_#get_all_periods_new.PERIOD_YEAR#_#get_all_periods_new.OUR_COMPANY_ID#.INVOICE INV
				WHERE
					SRR.SHIP_ID IN (#evaluate('ship_list_#get_all_periods_new.PERIOD_ID#')#)
					AND SRR.TO_INVOICE_ID =INV.INVOICE_ID
					AND SRR.TO_INVOICE_CAT = INV.INVOICE_CAT
					AND SHIP_PERIOD=#get_all_periods.period_id#
					AND SRR.TO_INVOICE_ID IS NOT NULL
				GROUP BY
					SRR.SHIP_ID,
					SRR.SHIP_PERIOD,
					YEAR(INVOICE_DATE),
					SRR.TO_INVOICE_ID,
					SRR.TO_INVOICE_CAT,
					INV.INVOICE_DATE,
					INVOICE_NUMBER,
					PRODUCT_ID,
					STOCK_ID
				<cfif isdefined('list_period_years') and listfind(list_period_years,(get_all_periods_new.PERIOD_YEAR+1))>
				UNION ALL
				SELECT
					SUM(AMOUNT) AS AMOUNT,
					YEAR(INVOICE_DATE) AS INVOICE_YEAR,
					PRODUCT_ID,
					STOCK_ID,
					SRR.TO_INVOICE_ID,
					SRR.TO_INVOICE_CAT,
					INV.INVOICE_NUMBER AS TO_INVOICE_NUMBER,
					SRR.SHIP_ID,
					SRR.SHIP_PERIOD,
					ISNULL((SELECT
						TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
					FROM 
						#dsn#_#get_all_periods_new.PERIOD_YEAR+1#_#get_all_periods_new.OUR_COMPANY_ID#.GET_PRODUCT_COST_PERIOD GPCP
					WHERE
						GPCP.START_DATE <= INV.INVOICE_DATE
						AND GPCP.PRODUCT_ID = SRR.PRODUCT_ID
					ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC, GPCP.PURCHASE_NET_SYSTEM DESC
						),0) AS INV_TOTAL_COST							
				FROM
					#dsn#_#get_all_periods_new.PERIOD_YEAR+1#_#get_all_periods_new.OUR_COMPANY_ID#.SHIP_ROW_RELATION SRR,
					#dsn#_#get_all_periods_new.PERIOD_YEAR+1#_#get_all_periods_new.OUR_COMPANY_ID#.INVOICE INV
				WHERE
					SRR.SHIP_ID IN (#evaluate('ship_list_#get_all_periods_new.PERIOD_ID#')#)
					AND SRR.TO_INVOICE_ID =INV.INVOICE_ID
					AND SRR.TO_INVOICE_CAT = INV.INVOICE_CAT
					AND SHIP_PERIOD=#get_all_periods_new.period_id#
					AND SRR.TO_INVOICE_ID IS NOT NULL
				GROUP BY
					SRR.SHIP_ID,
					SRR.SHIP_PERIOD,
					YEAR(INVOICE_DATE),
					SRR.TO_INVOICE_ID,
					SRR.TO_INVOICE_CAT,
					INV.INVOICE_DATE,
					INVOICE_NUMBER,
					PRODUCT_ID,
					STOCK_ID
				</cfif>
			</cfif>			
			</cfloop>
			</cfoutput>
		</cfsavecontent>
		<cfif len(all_query_2)>
			<cfquery name="get_all_inv_amount_2" datasource="#dsn#">
				SELECT
					SUM(AMOUNT) AS AMOUNT,
					SUM(INV_TOTAL_COST*AMOUNT) AS INV_TOTAL_COST,
					INVOICE_YEAR,
					PRODUCT_ID,
					STOCK_ID,
					TO_INVOICE_ID,
					TO_INVOICE_CAT,
					TO_INVOICE_NUMBER,
					SHIP_ID,
					SHIP_PERIOD
				FROM
				(
					#all_query_2#
				) AS A1
					GROUP BY
						PRODUCT_ID,
						STOCK_ID,
						TO_INVOICE_ID,
						TO_INVOICE_CAT,
						TO_INVOICE_NUMBER,
						SHIP_ID,
						SHIP_PERIOD
						,INVOICE_YEAR
					ORDER BY TO_INVOICE_ID
			</cfquery>
		<cfelse>
			<cfset get_all_inv_amount_2.recordcount=0>
		</cfif>
		<cfif get_all_inv_amount_2.recordcount>
			<cfquery name="get_all_inv_amount" dbtype="query">
				SELECT
					SUM(AMOUNT) AS AMOUNT,
					SUM(INV_TOTAL_COST) AS INV_TOTAL_COST,
					PRODUCT_ID,
					STOCK_ID,
					TO_INVOICE_ID,
					TO_INVOICE_CAT,
					TO_INVOICE_NUMBER,
					SHIP_ID,
					SHIP_PERIOD
				FROM
					get_all_inv_amount_2
				GROUP BY
					PRODUCT_ID,
					STOCK_ID,
					TO_INVOICE_ID,
					TO_INVOICE_CAT,
					TO_INVOICE_NUMBER,
					SHIP_ID,
					SHIP_PERIOD
				ORDER BY TO_INVOICE_ID
			</cfquery>
		<cfelse>
			<cfset get_all_inv_amount.recordcount=0>
		</cfif>
		<cfscript>
			for(shp_t=1; shp_t lte get_all_ship_amount.recordcount; shp_t=shp_t+1)
			{
				if(isdefined('used_ship_amount_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#')) //miktarlar
					'used_ship_amount_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#' = evaluate('used_ship_amount_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#')+get_all_ship_amount.AMOUNT[shp_t];
				else
					'used_ship_amount_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#' = get_all_ship_amount.AMOUNT[shp_t];
				
				if(isdefined('used_ship_cost_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#')) //maliyet
					'used_ship_cost_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#' = evaluate('used_ship_cost_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#')+get_all_ship_amount.SHIP_TOTAL_COST[shp_t];
				else
					'used_ship_cost_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#' = get_all_ship_amount.SHIP_TOTAL_COST[shp_t];
			
				if(isdefined('to_ship_number_list_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#')) //cekildigi irsaliyeler
					'to_ship_number_list_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#' = listappend(evaluate('to_ship_number_list_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#'),get_all_ship_amount.TO_SHIP_NUMBER[shp_t]);
				else
					'to_ship_number_list_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#' = get_all_ship_amount.TO_SHIP_NUMBER[shp_t];
			}
			for(inv_k=1; inv_k lte get_all_inv_amount.recordcount; inv_k=inv_k+1)
			{
				if(isdefined('used_inv_amount_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#'))
					'used_inv_amount_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#' = evaluate('used_inv_amount_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#')+get_all_inv_amount.AMOUNT[inv_k];
				else
					'used_inv_amount_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#' = get_all_inv_amount.AMOUNT[inv_k];
				
				if(isdefined('used_inv_cost_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#'))
					'used_inv_cost_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#' = evaluate('used_inv_cost_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#')+get_all_inv_amount.INV_TOTAL_COST[inv_k];
				else
					'used_inv_cost_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#' = get_all_inv_amount.INV_TOTAL_COST[inv_k];
		
				if(isdefined('to_inv_number_list_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#'))
					'to_inv_number_list_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#' = listappend(evaluate('to_inv_number_list_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#'),get_all_inv_amount.TO_INVOICE_NUMBER[inv_k]);
				else
					'to_inv_number_list_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#' = get_all_inv_amount.TO_INVOICE_NUMBER[inv_k];
			}
		</cfscript>
		<cfoutput query="GET_ALL_SHIP">
			<cfif isdefined('used_inv_amount_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#') and len(evaluate('used_inv_amount_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#'))>
				<cfset invoice_amount = wrk_round(evaluate('used_inv_amount_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#'))>
			<cfelse>
				<cfset invoice_amount = 0>
			</cfif>
			<cfif isdefined('used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#') and len(evaluate('used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#'))>
				<cfset invoice_cost = wrk_round(evaluate('used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#'))>
			<cfelse>
				<cfset invoice_cost = 0>
			</cfif>
			<cfif isdefined('used_ship_amount_#SHIP_ID#_#STOCK_ID#') and len(evaluate('used_ship_amount_#SHIP_ID#_#STOCK_ID#'))>
				<cfset ship_amount = wrk_round(evaluate('used_ship_amount_#SHIP_ID#_#STOCK_ID#'))>
			<cfelse>
				<cfset ship_amount = 0>
			</cfif>
			<cfif isdefined('used_ship_cost_#SHIP_ID#_#STOCK_ID#') and len(evaluate('used_ship_cost_#SHIP_ID#_#STOCK_ID#'))>
				<cfset ship_cost = wrk_round(evaluate('used_ship_cost_#SHIP_ID#_#STOCK_ID#'))>
			<cfelse>
				<cfset ship_cost = 0>
			</cfif>
			<cfif PAPER_AMOUNT-invoice_amount-ship_amount gt 0>
				<cfquery name="add_consignment_transfer" datasource="#hedef_dsn2#">
					INSERT INTO
						PRE_CONSIGNMENT_SHIP
					(
						PERIOD_ID,
						SHIP_ID,
						SHIP_NUMBER,
						SHIP_DATE,
						SHIP_TYPE,
						PROCESS_CAT,
						COMPANY_ID,
						PARTNER_ID,
						CONSUMER_ID,
						STOCK_ID,
						PRODUCT_ID,
						SPECT_MAIN_ID,
						PROJECT_ID,
						SUBSCRIPTION_ID,
						DEPARTMENT_ID,
						LOCATION_ID,
						AMOUNT,
						INV_AMOUNT,
						SHIP_AMOUNT,
						SHIP_COST,
						INV_COST,
						REMAIN_AMOUNT,
						COST_VALUE,
						INVOICE_NUMBER_LIST,
						SHIP_NUMBER_LIST,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						#attributes.aktarim_kaynak_period#,
						#SHIP_ID#,
						<cfif len(BELGE_NO)>'#BELGE_NO#'<cfelse>NULL</cfif>,
						<cfif len(ISLEM_TARIHI)>#CreateODBCDate(ISLEM_TARIHI)#<cfelse>NULL</cfif>,
						#SHIP_TYPE#,
						<cfif len(PROCESS_CAT)>#PROCESS_CAT#<cfelse>NULL</cfif>,
						<cfif len(COMPANY_ID)>#COMPANY_ID#<cfelse>NULL</cfif>,
						<cfif len(PARTNER_ID)>#PARTNER_ID#<cfelse>NULL</cfif>,
						<cfif len(CONSUMER_ID)>#CONSUMER_ID#<cfelse>NULL</cfif>,
						#STOCK_ID#,
						#PRODUCT_ID#,
						<cfif len(SPECT_MAIN_ID)>#SPECT_MAIN_ID#<cfelse>NULL</cfif>,
						<cfif len(PROJECT_ID)>#PROJECT_ID#<cfelse>NULL</cfif>,
						<cfif len(SUBSCRIPTION_ID)>#SUBSCRIPTION_ID#<cfelse>NULL</cfif>,
						<cfif len(DEPARTMENT_ID_2)>#DEPARTMENT_ID_2#<cfelse>NULL</cfif>,
						<cfif len(LOCATION)>#LOCATION#<cfelse>NULL</cfif>,
						#PAPER_AMOUNT#,
						#invoice_amount#,
						#ship_amount#,
						#invoice_cost#,
						#ship_cost#,
						#PAPER_AMOUNT-invoice_amount-ship_amount#,
						#COST_AMOUNT#,
						<cfif isdefined('to_inv_number_list_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#') and len(evaluate('to_inv_number_list_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#'))>
							'#evaluate('to_inv_number_list_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#')#'
						<cfelse>
							NULL
						</cfif>,
						<cfif isdefined('to_ship_number_list_#SHIP_ID#_#STOCK_ID#') and len(evaluate('to_ship_number_list_#SHIP_ID#_#STOCK_ID#'))>
							'#evaluate('to_ship_number_list_#SHIP_ID#_#STOCK_ID#')#'
						<cfelse>
							NULL
						</cfif>,
						#now()#,
						#session.ep.userid#,
						'#CGI.REMOTE_ADDR#'
					)
				</cfquery>
			</cfif>
		</cfoutput>
	</cfif>
	<script>
		alert("<cf_get_lang no ='2020.İşlem Başarıyla Tamamlanmıştır'>!");
	</script>
</cfif>
</cf_box>

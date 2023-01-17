<!--- TolgaS 20070310 istenilen tipe göre gelen kayıtlardan ürünlere maliyet ekler --->
<cfflush interval="1000">
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.date2" default="">
<cfquery name="get_periods" datasource="#dsn#">
	SELECT 
    	PERIOD_ID, 
        PERIOD, 
        PERIOD_YEAR, 
        OUR_COMPANY_ID, 
        OTHER_MONEY, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE,
        UPDATE_IP, 
        UPDATE_EMP 
    FROM 
    	SETUP_PERIOD 
    ORDER BY 
	    OUR_COMPANY_ID,PERIOD_YEAR DESC
</cfquery>
<cfif not isdefined("attributes.step")>
<!--- form --->
	<table width="98%" align="center">
		<tr>
			<td class="headbold" height="35"><cf_get_lang no ='2105.Maliyet İşlemleri'></td>
		</tr>
	</table>
	<table cellpadding="2" cellspacing="1" width="98%" align="center" class="color-border">
		<tr class="color-row">
			<td>
				<table>
					<cfform name="form_" method="post" action="">
					<tr>
						<td><cf_get_lang no ='2132.Maliyet Oluşturma Tipi'></td>
						<td><select name="cost_type" id="cost_type" style="width:210px">
								<option value="1" <cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>selected</cfif>><cf_get_lang no ='2133.Standart Alış Fiyatından'></option>
								<option value="2" <cfif isdefined('attributes.cost_type') and attributes.cost_type eq 2>selected</cfif>><cf_get_lang no ='2134.Son Alış Fiyatından'></option>
								<option value="4" <cfif isdefined('attributes.cost_type') and attributes.cost_type eq 4>selected</cfif>><cf_get_lang no ='2135.Standart Alış Fiyatından (iskontolar düşülerek)'></option>
							</select>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no="1447.Süreç"></td>
                 		<td><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'></td>
					</tr>
					<tr>
						<td><cf_get_lang_main no ='641.Başlangıç Tarihi'></td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no ='326.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="date1" value="#attributes.date1#" validate="#validate_style#" message="#message#" style="width:65px;">
							<cf_wrk_date_image date_field="date1">
						</td>
					</tr>
					<tr>
						<td><cf_get_lang no ='1784.Kaynak Dönem'></td>
						<td>
							<select name="kaynak_period" id="kaynak_period" style="width:175px">
								<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
								<cfoutput query="get_periods">
									<option value="#period_id#" <cfif isdefined("attributes.kaynak_period") and attributes.kaynak_period eq period_id>selected</cfif>>#period# - (#period_year#)</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang no ='1277.Hedef Dönem'></td>
						<td>
							<select name="hedef_period" id="hedef_period" style="width:175px">
								<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
								<cfoutput query="get_periods">
									<option value="#period_id#" <cfif isdefined("attributes.hedef_period") and attributes.hedef_period eq period_id>selected</cfif>>#period# - (#period_year#)</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="2"><input type="button" value="<cf_get_lang_main no ='1264.Aktar'>" onClick="basamak_1();"></td>
					</tr>
					</cfform>
				</table>
				<br/>
				<font color="red"><cf_get_lang no ='2131.Kaynak Dönemden, Hedef Döneme maliyet kayıtları yapılacaktır Sayfa Görüntülendikten sonra maliyet işlemleri çalışmaya başlayacaktır Lütfen Sayfayı Yenilemeyin'></font>
			</td>
		</tr>
	</table>
</cfif>
<cfif isdefined("attributes.kaynak_period")>
    <cfif not len(attributes.hedef_period)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2075.Hedef Dönem Secmelisiniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfif not len(attributes.kaynak_period)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2064.Kaynak Dönem Secmelisiniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="get_kaynak_period" datasource="#dsn#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.kaynak_period#">
	</cfquery>
	<cfquery name="get_hedef_period" datasource="#dsn#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.hedef_period#">
	</cfquery>
	<form action="<cfoutput>#request.self#?fuseaction=settings.popupflush_add_new_cost_price</cfoutput>" name="form1_" method="post">
		<input type="hidden" name="aktarim_cost_type" id="aktarim_cost_type" value="<cfoutput>#attributes.cost_type#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#get_kaynak_period.period_id#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_year" id="aktarim_kaynak_year" value="<cfoutput>#get_kaynak_period.period_year#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_company" id="aktarim_kaynak_company" value="<cfoutput>#get_kaynak_period.our_company_id#</cfoutput>">
		<input type="hidden" name="aktarim_hedef_period" id="aktarim_hedef_period" value="<cfoutput>#get_hedef_period.period_id#</cfoutput>">
		<input type="hidden" name="aktarim_hedef_year" id="aktarim_hedef_year" value="<cfoutput>#get_hedef_period.period_year#</cfoutput>">
		<input type="hidden" name="aktarim_hedef_company" id="aktarim_hedef_company" value="<cfoutput>#get_hedef_period.our_company_id#</cfoutput>">
		<input type="hidden" name="aktarim_date1" id="aktarim_date1" value="<cfoutput>#attributes.date1#</cfoutput>">
		<input type="hidden" name="aktarim_process_stage" id="aktarim_process_stage" value="<cfoutput>#attributes.process_stage#</cfoutput>">
		<cf_get_lang no ='2028.Kaynak Veri Tabanı'> : <cfoutput>#get_kaynak_period.period# (#get_kaynak_period.period_year#)</cfoutput><br/>
		<cf_get_lang no ='2029.Hedef Veri Tabanı'>: <cfoutput>#get_hedef_period.period# (#get_hedef_period.period_year#)</cfoutput><br/>
		<input type="button" value="Aktarimi Baslat" onClick="basamak_2();">
	</form>
</cfif>
<cfif isdefined("attributes.aktarim_kaynak_period")>
	<cfset kaynak_dsn1 = '#dsn#_product'>
	<cfset kaynak_dsn1_alias = '#dsn#_product'>
	<cfset kaynak_dsn3 = '#dsn#_#attributes.aktarim_kaynak_company#'>
	<cfif database_type is 'MSSQL'>
		<cfset kaynak_dsn2 = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#'>
		<cfset kaynak_dsn2_alias = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#'>
	<cfelseif database_type is 'DB2'>
		<cfset kaynak_dsn2 = '#dsn#_#right(attributes.aktarim_kaynak_year,2)#_#attributes.aktarim_kaynak_company#'>
		<cfset kaynak_dsn2_alias = '#dsn#_#right(attributes.aktarim_kaynak_year,2)#_#attributes.aktarim_kaynak_company#'>
	</cfif>
	<cfset kaynak_dsn3_alias = '#dsn#_#attributes.aktarim_kaynak_company#'>
	<cfset hedef_dsn1 = '#dsn#_product'>
	<cfset hedef_dsn1_alias = '#dsn#_product'>
    <cfset hedef_dsn3 = '#dsn#_#attributes.aktarim_hedef_company#'>
	<cfquery name="get_period" datasource="#dsn#">
		SELECT 
			SP.INVENTORY_CALC_TYPE
		FROM 
			SETUP_PERIOD SP
		WHERE 
			SP.PERIOD_ID = <cfqueryparam value="#aktarim_hedef_period#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfif isdefined('attributes.aktarim_date1') or not len(attributes.aktarim_date1)>
		<cf_date tarih='attributes.aktarim_date1'>
	</cfif>
	<cfif attributes.aktarim_cost_type eq 1><!--- Standart Alış --->
		<cfquery name="GET_PRICE" datasource="#kaynak_dsn1#">
			SELECT
				P.PRODUCT_CODE,
				P.PRODUCT_ID,
				PS.PRICE PRICE,
				PS.MONEY MONEY,
				PU.PRODUCT_UNIT_ID,
				PU.ADD_UNIT ADD_UNIT,
				PU.MAIN_UNIT MAIN_UNIT
			FROM 
				PRODUCT P,
				PRICE_STANDART PS,
				PRODUCT_UNIT PU
			WHERE
				PS.PURCHASESALES = 0 AND
				PS.PRICESTANDART_STATUS = 1 AND	
				P.PRODUCT_ID = PS.PRODUCT_ID AND
				PS.UNIT_ID = PU.PRODUCT_UNIT_ID
		</cfquery>
	<cfelseif attributes.aktarim_cost_type eq 2><!--- Son Alış ---> 
		<cfquery name="GET_PRICE" datasource="#kaynak_dsn1#">
			SELECT
				P.PRODUCT_CODE,
				PU.PRODUCT_UNIT_ID,
				PU.PRODUCT_ID,
				ISNULL((SELECT TOP 1 IR.OTHER_MONEY_VALUE/#dsn_alias#.IS_ZERO(IR.AMOUNT,1) FROM  #kaynak_dsn2_alias#.INVOICE_ROW AS IR, #kaynak_dsn2_alias#.INVOICE AS I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = 0 AND PU.PRODUCT_UNIT_ID = IR.UNIT_ID AND IR.PRODUCT_ID = P.PRODUCT_ID ORDER BY I.INVOICE_DATE DESC),0) AS PRICE,
				ISNULL((SELECT TOP 1 IR.OTHER_MONEY FROM #kaynak_dsn2_alias#.INVOICE_ROW AS IR, #kaynak_dsn2_alias#.INVOICE AS I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = 0 AND PU.PRODUCT_UNIT_ID = IR.UNIT_ID AND IR.PRODUCT_ID = P.PRODUCT_ID ORDER BY I.INVOICE_DATE DESC),'#session.ep.money#') AS MONEY,
				PU.PRODUCT_UNIT_ID,
				PU.ADD_UNIT ADD_UNIT,
				PU.MAIN_UNIT MAIN_UNIT
			FROM 
				PRODUCT_UNIT PU,
				PRODUCT P
			WHERE
				PU.PRODUCT_ID=P.PRODUCT_ID
		</cfquery>
	<cfelseif attributes.aktarim_cost_type eq 4><!--- Satış --->
		<cfquery name="GET_PRICE" datasource="#kaynak_dsn1#">
			SELECT
				P.PRODUCT_CODE,
				P.PRODUCT_ID,
				PS.NET_PRICE PRICE,
				PS.MONEY MONEY,
                PS.PRICE AS _PRICE_,
				PU.PRODUCT_UNIT_ID,
				PU.ADD_UNIT ADD_UNIT,
				PU.MAIN_UNIT MAIN_UNIT
			FROM 
				#kaynak_dsn3_alias#.PRICE_STANDART_DISCOUNT PS,
                PRODUCT P,
				PRODUCT_UNIT PU
			WHERE
            	PU.PRODUCT_ID=P.PRODUCT_ID AND
				P.PRODUCT_ID = PS.PRODUCT_ID 
		</cfquery>
	</cfif>
	<cfquery name="GET_SETUP_MONEY" datasource="#dsn#">
		SELECT (RATE1/RATE2) RATE, MONEY FROM SETUP_MONEY WHERE PERIOD_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#aktarim_hedef_period#">
	</cfquery>
	<cfoutput query="GET_SETUP_MONEY">
		<cfset '#money#_rate'=RATE>
	</cfoutput>
	<cfoutput query="GET_PRICE">
    	<!--- Eğer iskontolar düşülerek oluşturulmak isteniyorsa bir fiyat bulamazsa standart alış fiyatı alsın... --->
    	<cfif attributes.aktarim_cost_type eq 4 and not len(PRICE)>
			<cfset PS_PRICE = _PRICE_>
        <cfelse>
        	<cfset PS_PRICE = PRICE>
		</cfif>
		<cfif len(PS_PRICE) and PS_PRICE gt 0>
        	<cfset _MONEY_ = MONEY>
        	<cfif (AKTARIM_HEDEF_YEAR eq 2008 or AKTARIM_KAYNAK_YEAR eq 2008) and MONEY is 'TL'>
				<cfset _MONEY_ = 'YTL'>
			</cfif>
			<cfif isdefined('#_MONEY_#_rate')>
				<cfset price_system=PS_PRICE/evaluate('#_MONEY_#_rate')>
				<cfif isdefined('session.ep.money2') and len(session.ep.money2)>
					<cfset price_system_2=PS_PRICE/evaluate('#session.ep.money2#_rate')>
				<cfelse>
					<cfset price_system_2=PS_PRICE/evaluate('USD_rate')>
				</cfif>
				<cfquery name="UPD_COST" datasource="#dsn1#">
					UPDATE
						PRODUCT_COST
					SET
						PRODUCT_COST_STATUS = 0
					WHERE
						PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
						AND START_DATE <= #attributes.aktarim_date1#
				</cfquery>
				<cfquery name="GET_COST_STATUS" datasource="#dsn1#">
					SELECT
						PRODUCT_COST_STATUS
					FROM
						PRODUCT_COST
					WHERE
						PRODUCT_COST_STATUS = 1
						AND	PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
						AND START_DATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.aktarim_date1#">
				</cfquery>

				<cfquery name="ADD_COST" datasource="#hedef_dsn1#">
					INSERT INTO
						PRODUCT_COST
							(
								PRODUCT_COST_STATUS,
								PROCESS_STAGE,
								INVENTORY_CALC_TYPE,
								COST_TYPE_ID,
								START_DATE,
								PRODUCT_ID,
								UNIT_ID,
								IS_SPEC,
								<!---SPECT_MAIN_ID,--->
								IS_STANDARD_COST,
								IS_ACTIVE_STOCK,
								IS_PARTNER_STOCK,
								COST_DESCRIPTION,
								ACTION_ID,
								ACTION_TYPE,
								ACTION_PERIOD_ID,
								ACTION_AMOUNT,
								ACTION_ROW_ID,
								
								AVAILABLE_STOCK,
								PARTNER_STOCK,
								ACTIVE_STOCK,
								PRODUCT_COST,
								MONEY,
								STANDARD_COST,
								STANDARD_COST_MONEY,
								STANDARD_COST_RATE,
								PURCHASE_NET,
								PURCHASE_NET_MONEY,
								PURCHASE_EXTRA_COST,
								PRICE_PROTECTION,
								PRICE_PROTECTION_MONEY,
								PURCHASE_NET_SYSTEM,
								PURCHASE_NET_SYSTEM_MONEY,
								PURCHASE_EXTRA_COST_SYSTEM,
								PURCHASE_NET_SYSTEM_2,
								PURCHASE_NET_SYSTEM_MONEY_2,
								PURCHASE_EXTRA_COST_SYSTEM_2,
		
								IS_SUGGEST,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
						VALUES
							(
								<cfif GET_COST_STATUS.RECORDCOUNT>0<cfelse>1</cfif>,
								#attributes.aktarim_process_stage#,
								#get_period.INVENTORY_CALC_TYPE#,
								NULL,
								<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1)>#attributes.aktarim_date1#<cfelse>NULL</cfif>,
								#product_id#,
								#PRODUCT_UNIT_ID#,
								0,<!---<cfif len(trim(attributes.spect_main_id))>1<cfelse>0</cfif>,
								<cfif len(trim(attributes.spect_main_id))>#attributes.spect_main_id#<cfelse>NULL</cfif>,
								--->
								0,
								0,
								0,
								NULL,
								
								NULL,
								NULL,
								#attributes.aktarim_hedef_period#,
								0,
								NULL,
							
								0,
								0,
								0,
								#wrk_round(PS_PRICE,4)#,
								'#_MONEY_#',
								0,
								'#session.ep.money#',
								0,
								#PS_PRICE#,
								'#_MONEY_#',
								0,
								0,
								'#session.ep.money#',
								#price_system#,
								'#SESSION.EP.MONEY#',
								0,
								#price_system_2#,
								<cfif isdefined('session.ep.money2') and len(session.ep.money2)>'#session.ep.money2#'<cfelse>'USD'</cfif>,
								0,
												
								<cfif isdefined('attributes.is_suggest')>#attributes.is_suggest#<cfelse>NULL</cfif>,
								#NOW()#,
								#SESSION.EP.USERID#,
								'#cgi.REMOTE_ADDR#'
							)
				</cfquery>
               <cfquery name="GET_P_COST_ID" datasource="#kaynak_dsn3#">
                    SELECT
                        MAX(PRODUCT_COST_ID) AS MAX_ID 
                    FROM 
                        #hedef_dsn1_alias#.PRODUCT_COST
                </cfquery>
                <cfset purchase_net_all = 0>
                <cfset purchase_net_all_location = 0>
                <cfset rate_other =1>
                <cfset rate_price = 1>
                <cfif price_system_2 neq 0>
                    <cfset rate_2 = wrk_round(PS_PRICE/price_system_2,4)>
                <cfelse>
                    <cfset rate_2 =1>
                </cfif>
                <cfquery name="upd_cost" datasource="#hedef_dsn1#">
                    UPDATE
                        PRODUCT_COST
                    SET
                        PURCHASE_NET_ALL = PURCHASE_NET + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#),
                        PURCHASE_NET_SYSTEM_ALL = (PURCHASE_NET_SYSTEM + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*#rate_other#,
                        PURCHASE_NET_SYSTEM_2_ALL = (PURCHASE_NET_SYSTEM_2 + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*(#rate_other#/#rate_2#),
                        PURCHASE_NET_LOCATION_ALL = PURCHASE_NET_LOCATION + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#),
                        PURCHASE_NET_SYSTEM_LOCATION_ALL = (PURCHASE_NET_SYSTEM_LOCATION + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*#rate_other#,
                        PURCHASE_NET_SYSTEM_2_LOCATION_ALL = (PURCHASE_NET_SYSTEM_2_LOCATION + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*(#rate_other#/#rate_2#)
                    WHERE
                        PRODUCT_COST_ID = #GET_P_COST_ID.MAX_ID# 
                </cfquery>
			<cfelse>
				[#currentrow#]---#_MONEY_# <cf_get_lang no ='2129.parabirimine ait kur bilgisi bulunamadı'><br/>
			</cfif>
		<cfelse>
			[#currentrow#]---#PRODUCT_CODE# <cf_get_lang no ='2128.kodlu ürünün maliyet degeri bulunamadı'><br/>
		</cfif>
	</cfoutput>
</cfif>﻿

<script type="text/javascript">
	function basamak_1()
	{
		if(document.form_.date1.value=='')
		{
			alert("<cf_get_lang no ='2127.Maliyetin Kayıt Tarihini Girmelisiniz'>!");
			return false;
		}
	
		if(confirm("<cf_get_lang no ='2106.Maliyet İşlemini Çalıştıracaksınız Emin misiniz'>?"))
			document.form_.submit();
		else 
			return false;
	}
		
	function basamak_2()
	{
		if(confirm("<cf_get_lang no ='2106.Maliyet İşlemini Çalıştıracaksınız Emin misiniz'>?"))
			document.form1_.submit();
		else
			return false;
	}
</script>

<cf_xml_page_edit>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.search_order_id" default="0">
<cfparam name="attributes.search_type_id" default="">
<cfparam name="attributes.start_date_" default="01/01/#session.ep.period_year#">
<cfparam name="attributes.finish_date_" default="#dateformat(dateadd('d',1,now()),'dd/mm/yyyy')#">
<cfparam name="attributes.is_zero" default="0">
<cfparam name="attributes.is_open" default="0">
<cfparam name="attributes.is_action" default="0">
<cfparam name="attributes.babs_limit" default="5.000">
<cfparam name="attributes.is_babs" default="0">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.money_type_info" default="">
<cfparam name="attributes.money_info" default="">
<cfif len(attributes.start_date_)>
	<cf_date tarih='attributes.start_date_'>
</cfif>
<cfif len(attributes.finish_date_)>
	<cf_date tarih='attributes.finish_date_'>
</cfif>
<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY FROM SETUP_MONEY
</cfquery>
<cfoutput query="get_money">
	<cfset 'toplam_sistem_#money#' = 0>
</cfoutput>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="searchform" method="post" action="index.cfm?fuseaction=finance.list_cari_letter&event=add">
			<input type="hidden" name="issubmit" id="issubmit" value="1">
			<cf_box_search plus="0">
				<div class="form-group">
					<input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih giriniz'></cfsavecontent>
						<cfinput type="text" name="start_Date_" value="#dateformat(attributes.start_Date_,dateformat_style)#" maxlength="10" style="width:65px" validate="#validate_style#" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_Date_"></span>
						<span class="input-group-addon no-bg"></span>
						<cfinput type="text" name="finish_date_" value="#dateformat(attributes.finish_date_,dateformat_style)#" maxlength="10" style="width:65px" validate="#validate_style#" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date_"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="search_type_id">
						<option value=""><cf_get_lang dictionary_id="58081.Hepsi"></option>
						<option value="0" <cfif attributes.search_type_id eq 0>selected</cfif>><cf_get_lang dictionary_id="33749.Alacaklılar"></option>
						<option value="1" <cfif attributes.search_type_id eq 1>selected</cfif>><cf_get_lang dictionary_id="33957.Borçlular"></option>
					</select>
				</div>
				<div class="form-group">
					<select name="is_babs" id="is_babs" onchange="is_babs_change()">
						<option value="0" <cfif attributes.is_babs eq 0>selected</cfif>><cf_get_lang dictionary_id="57800.İşlem Tipi"></option>
						<option value="1" <cfif attributes.is_babs eq 1>selected</cfif>><cf_get_lang dictionary_id="31568.Mutabakat"></option>
						<option value="2" <cfif attributes.is_babs eq 2>selected</cfif>><cf_get_lang dictionary_id="33786.Cari Hatırlatma"></option>
						<option value="3" <cfif attributes.is_babs eq 3>selected</cfif>><cf_get_lang dictionary_id="60230.BA"></option>
						<option value="4" <cfif attributes.is_babs eq 4>selected</cfif>><cf_get_lang dictionary_id="33806.BS"></option>
						
					</select>
				</div>
				<div class="form-group">
					<select name="search_order_id" style="width:120px;">
						<option value="0" <cfif attributes.search_order_id eq 0>selected</cfif>><cf_get_lang dictionary_id="33944.İsim A'dan Z'ye"></option>
						<option value="1" <cfif attributes.search_order_id eq 1>selected</cfif>><cf_get_lang dictionary_id="33931.İsim Z'dan A'ye"></option>
					</select>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='searchkontrol()'>
				</div>
			</cf_box_search> 
			<cf_box_search_detail>
				<div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="1">
					<div class="form-group" id="item-money_info">
                        <label class="col col-12"><cf_get_lang dictionary_id='50174.Döviz Seçiniz'></label>
                        <div class="col col-12">
                            <select name="money_info" id="money_info" onchange="show_money_type();">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>
                                <option value="1" <cfif isDefined("attributes.money_info") and attributes.money_info eq 1>selected<cfelseif  xml_is_money_info eq 1>selected</cfif>>2.<cf_get_lang dictionary_id='57677.Döviz'>
                                <option value="2" <cfif isDefined("attributes.money_info") and attributes.money_info eq 2>selected</cfif>><cf_get_lang dictionary_id='58121.Islem Dövizi'></option>
                            </select>                        
                        </div>
                    </div>
                    <cfif isdefined("attributes.money_type_info") and len(attributes.money_type_info)>
                        <cfset style = "">
                    <cfelse>
                        <cfset style = "display:none">
                    </cfif>
                    <div class="form-group" id="item-money_type" style="<cfoutput>#style#</cfoutput>">
                        <label class="col col-12"><cf_get_lang dictionary_id='57489.Para Birimi'></label>
                        <div class="col col-12">
                            <select name="money_type_info" id="money_type_info">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_money">
                                    <option value="#MONEY#" <cfif get_money.money eq attributes.money_type_info>selected</cfif>>#MONEY#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
					<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
						SELECT DISTINCT	
							COMPANYCAT_ID,
							COMPANYCAT
						FROM
							GET_MY_COMPANYCAT
						WHERE
							EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
							OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> 
						ORDER BY
							COMPANYCAT
					</cfquery>
					<div class="form-group" id="item-member_cat_type">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'></label>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<select name="member_cat_type" id="member_cat_type" multiple>
								<optgroup label="<cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'>">
								<cfoutput query="get_company_cat">
								<option value="#COMPANYCAT_ID#" <cfif listfind(attributes.member_cat_type,'#COMPANYCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#COMPANYCAT#</option></cfoutput>
							</select>
						</div>
					</div>							
				</div>
				<div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="2">
					<div class="form-group">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='33804.BA/BS Limiti'></label>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<input type="text" name="babs_limit" id="babs_limit" value="<cfoutput>#attributes.babs_limit#</cfoutput>" onkeyup="return(FormatCurrency(this,event,2,'float'));"/>
						</div>
					</div>	
					<div class="form-group">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<select name="is_zero">
								<option value="" <cfif attributes.is_zero eq 0>selected</cfif>><cf_get_lang dictionary_id="58081.Hepsi"></option>
								<option value="0" <cfif attributes.is_zero eq 1>selected</cfif>><cf_get_lang dictionary_id="33913.Sıfır Bakiyelileri Getirme"></option>
								<option value="1" <cfif attributes.is_zero eq 2>selected</cfif>><cf_get_lang dictionary_id="33912.Sıfır Bakiyelileri Getir"></option>
							</select>
						</div>
					</div>
					<div id="efatura_earchive" style="display:">
						<div class="form-group">
							<div class="col col-12 col-xs-12">
								<div class="col col-12 col-xs-12">
									<input type="checkbox" name="is_efatura" id="is_efatura" value="1" <cfif isdefined('attributes.is_efatura') and attributes.is_efatura eq 1>checked</cfif>><cf_get_lang dictionary_id='29872.E-Fatura'><cf_get_lang dictionary_id='32924.Dahil'>
								</div>
							</div>											
						</div>
						<div class="form-group">
							<div class="col col-12 col-xs-12">
								<div class="col col-12 col-xs-12">
									<input type="checkbox" name="is_earchive" id="is_earchive" value="1" <cfif isdefined('attributes.is_earchive') and attributes.is_earchive eq 1>checked</cfif>><cf_get_lang dictionary_id='57145.E-Arşiv'><cf_get_lang dictionary_id='32924.Dahil'>
								</div>
							</div>											
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="3">
					<div class="form-group">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<select name="is_action">
								<option value="0" <cfif attributes.is_action eq 0>selected</cfif>><cf_get_lang dictionary_id="33911.Son Mutabakattan Sonra Hareket Yoksa Getirme"></option>
								<option value="1" <cfif attributes.is_action eq 1>selected</cfif>><cf_get_lang dictionary_id="33910.Son Mutabakattan Sonra Hareket Yoksa Getir"></option>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="4">
					<div class="form-group">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<select name="is_open">
								<option value="" <cfif attributes.is_open eq "">selected</cfif>><cf_get_lang dictionary_id="58081.Hepsi"></option>
								<option value="0" <cfif attributes.is_open eq 0>selected</cfif>><cf_get_lang dictionary_id="33909.Mutabakat Yapılabilecekler"></option>
								<option value="1" <cfif attributes.is_open eq 1>selected</cfif>><cf_get_lang dictionary_id="33908.Mutabakat Yapılmayacaklar"></option>
							</select>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id="33967.Mutabakat Mektubu Gönder"></cfsavecontent>
	<cf_box title="#title#" uidrop="1" hide_table_column="1">
		<cfif isDefined("attributes.issubmit")>
			<cfquery name="GETPERIOD" datasource="#dsn#">
				SELECT PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_YEAR = #year(now())# AND OUR_COMPANY_ID = #session.ep.company_id#
			</cfquery> 
			<cfset bs_process_types = "6,48,50,52,53,56,57,58,62,66,531,532,561,121,533,5311">
			<cfset ba_process_types = "12,49,51,54,55,59,60,61,63,64,65,68,591,592,601,690,691,120,1201">
			<cfquery name="GET_BA_BS" datasource="#DSN2#">
				SELECT 
					COMPANY_ID,
					CONSUMER_ID,
					FULLNAME,
					MEMBER_CODE,
					TAXOFFICE,
					TAXNO,
					TELCODE,
					TEL,
					FAX,
					TC_IDENTY_NO,
					CITY_ID,
					COUNTRY_ID,
					SUM(PAPER_COUNT_BA) BA_PAPER_COUNT,
					SUM(PAPER_COUNT_BS) BS_PAPER_COUNT,
					<cfif isDefined("BA_OTVTOTAL") and len(BA_OTVTOTAL)>
						SUM(BA_TOTAL+BA_OTVTOTAL) BA_TOTAL,
					<cfelse>
						SUM(BA_TOTAL) BA_TOTAL,
					</cfif>
					SUM(BS_TOTAL+BS_OTVTOTAL) BS_TOTAL,
					SUM(TAX_TOTAL) TAX_TOTAL,
					SUM(OTV_TOTAL) OTV_TOTAL
				FROM
				(
					SELECT
						COMPANY_ID,
						CONSUMER_ID,
						FULLNAME,
						MEMBER_CODE,
						TAXOFFICE,
						TAXNO,
						TELCODE,
						TEL,
						FAX,
						TC_IDENTY_NO,
						CITY_ID,
						COUNTRY_ID,
						COUNT(BA_COUNT) PAPER_COUNT_BA,
						COUNT(BS_COUNT) PAPER_COUNT_BS,
						SUM(BA_NETTOTAL-BA_DISCOUNT) BA_TOTAL,
						SUM(BS_NETTOTAL-BS_DISCOUNT) BS_TOTAL,
						SUM(TAX_TOTAL) TAX_TOTAL,
						SUM(BS_OTVTOTAL) BS_OTVTOTAL,
						SUM(BA_OTVTOTAL) BA_OTVTOTAL,
						SUM(BS_OTVTOTAL+BA_OTVTOTAL) OTV_TOTAL
					FROM
					(
						SELECT
							CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.INVOICE_ID ELSE NULL END AS BS_COUNT,
							CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN NULL ELSE I.INVOICE_ID END AS BA_COUNT,
							CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(IR.NETTOTAL) ELSE 0 END AS BS_NETTOTAL,
							CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(IR.NETTOTAL) END AS BA_NETTOTAL,
							CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.SA_DISCOUNT ELSE 0 END AS BS_DISCOUNT,
							CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE I.SA_DISCOUNT END AS BA_DISCOUNT,				
							I.COMPANY_ID,
							NULL CONSUMER_ID,
							C.FULLNAME,
							C.MEMBER_CODE,
							C.TAXOFFICE,
							C.TAXNO,
							C.COMPANY_TELCODE TELCODE,
							C.COMPANY_TEL1 TEL,
							C.COMPANY_FAX FAX,
							(SELECT CP.TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.PARTNER_ID = C.MANAGER_PARTNER_ID) TC_IDENTY_NO,
							C.CITY CITY_ID,
							C.COUNTRY COUNTRY_ID,
							SUM(I.TAXTOTAL)/COUNT(IR.INVOICE_ID) TAX_TOTAL,
							CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OTVTOTAL,
							CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_OTVTOTAL
						FROM
							#dsn_alias#.COMPANY C,
							INVOICE_ROW IR,
							INVOICE I
							<cfif session.ep.our_company_info.is_earchive>
								LEFT JOIN EARCHIVE_RELATION ERA ON ERA.ACTION_ID = I.INVOICE_ID AND ERA.ACTION_TYPE = 'INVOICE'
								LEFT JOIN EARCHIVE_SENDING_DETAIL ES ON ES.ACTION_ID = I.INVOICE_ID AND ES.ACTION_TYPE = 'INVOICE' AND ES.SENDING_DETAIL_ID = (SELECT MAX(ES2.SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ES2 WHERE ES2.ACTION_ID=I.INVOICE_ID AND ES2.ACTION_TYPE = 'INVOICE')
							</cfif>
							<cfif session.ep.our_company_info.is_efatura>
								LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = I.INVOICE_ID AND ER.ACTION_TYPE = 'INVOICE'
								LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = I.INVOICE_ID
							</cfif>
						WHERE
							I.COMPANY_ID = C.COMPANY_ID AND
							IR.INVOICE_ID = I.INVOICE_ID AND
							I.IS_IPTAL = 0
							<cfif isdate(attributes.start_date_)>
								AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date_#">
							</cfif>
							<cfif isdate(attributes.finish_date_)>
								AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date_#">
							</cfif>
							<cfif attributes.is_babs eq 3 or attributes.is_babs eq 4>
								<cfif not isDefined("attributes.is_earchive")>
									AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 
								</cfif>
								<cfif not isDefined("attributes.is_efatura")>
									AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 
									AND ERD.IS_APPROVE IS NULL
								</cfif>
							</cfif>
						GROUP BY
							I.INVOICE_CAT,
							I.INVOICE_ID,
							I.COMPANY_ID,
							C.FULLNAME,
							C.MEMBER_CODE,
							C.TAXOFFICE,
							C.TAXNO,
							C.COMPANY_TELCODE,
							C.COMPANY_TEL1,
							C.COMPANY_FAX,
							C.MANAGER_PARTNER_ID,
							C.CITY,
							C.COUNTRY,
							I.SA_DISCOUNT
					UNION ALL
						SELECT
							CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.INVOICE_ID ELSE NULL END AS BS_COUNT,
							CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN NULL ELSE I.INVOICE_ID END AS BA_COUNT,
							CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(IR.NETTOTAL) ELSE 0 END AS BS_NETTOTAL,
							CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(IR.NETTOTAL) END AS BA_NETTOTAL,
							CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.SA_DISCOUNT ELSE 0 END AS BS_DISCOUNT,
							CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE I.SA_DISCOUNT END AS BA_DISCOUNT,				
							NULL,
							I.CONSUMER_ID,
							C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME,
							C.MEMBER_CODE,
							C.TAX_OFFICE TAXOFFICE,
							C.TAX_NO TAXNO,
							C.MOBIL_CODE TELCODE,
							C.MOBILTEL TEL,
							C.CONSUMER_FAX FAX,
							C.TC_IDENTY_NO,
							C.HOME_CITY_ID CITY_ID,
							C.HOME_COUNTRY_ID COUNTRY_ID,
							SUM(I.TAXTOTAL)/COUNT(I.INVOICE_ID) TAX_TOTAL,
							<!--- SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) OTV_TOTAL --->
							CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OTVTOTAL,
							CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_OTVTOTAL
						FROM
						#dsn_alias#.CONSUMER C,
						INVOICE_ROW IR,
						INVOICE I
						<cfif session.ep.our_company_info.is_earchive>
							LEFT JOIN EARCHIVE_RELATION ERA ON ERA.ACTION_ID = I.INVOICE_ID AND ERA.ACTION_TYPE = 'INVOICE'
							LEFT JOIN EARCHIVE_SENDING_DETAIL ES ON ES.ACTION_ID = I.INVOICE_ID AND ES.ACTION_TYPE = 'INVOICE' AND ES.SENDING_DETAIL_ID = (SELECT MAX(ES2.SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ES2 WHERE ES2.ACTION_ID=I.INVOICE_ID AND ES2.ACTION_TYPE = 'INVOICE')
						</cfif>
						<cfif session.ep.our_company_info.is_efatura>
							LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = I.INVOICE_ID AND ER.ACTION_TYPE = 'INVOICE'
							LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = I.INVOICE_ID
						</cfif>
						WHERE
							I.CONSUMER_ID = C.CONSUMER_ID AND
							IR.INVOICE_ID = I.INVOICE_ID AND
							I.IS_IPTAL = 0
							<cfif isdate(attributes.start_date_)>
								AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date_#">
							</cfif>
							<cfif isdate(attributes.finish_date_)>
								AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date_#">
							</cfif>
							<cfif attributes.is_babs eq 3 or attributes.is_babs eq 4>
								<cfif not isDefined("attributes.is_earchive")>
									AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 
								</cfif>
								<cfif not isDefined("attributes.is_efatura")>
									AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = I.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 
									AND ERD.IS_APPROVE IS NULL
								</cfif>
							</cfif>
						GROUP BY
							I.INVOICE_CAT,
							I.INVOICE_ID,
							I.CONSUMER_ID,
							C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME,
							C.MEMBER_CODE,
							C.TAX_OFFICE,
							C.TAX_NO,
							C.MOBIL_CODE,
							C.MOBILTEL,
							C.CONSUMER_FAX,
							C.TC_IDENTY_NO,
							C.HOME_CITY_ID,
							C.HOME_COUNTRY_ID,
							I.SA_DISCOUNT
					) T1
					GROUP BY
						COMPANY_ID,
						CONSUMER_ID,
						FULLNAME,
						MEMBER_CODE,
						TAXOFFICE,
						TAXNO,
						TELCODE,
						TEL,
						FAX,
						TC_IDENTY_NO,
						CITY_ID,
						COUNTRY_ID
				UNION ALL
					SELECT
						COMPANY_ID,
						CONSUMER_ID,
						FULLNAME,
						MEMBER_CODE,
						TAXOFFICE,
						TAXNO,
						TELCODE,
						TEL,
						FAX,
						TC_IDENTY_NO,
						CITY_ID,
						COUNTRY_ID,
						COUNT(BA_COUNT) PAPER_COUNT_BA,
						COUNT(BS_COUNT) PAPER_COUNT_BS,
						SUM(BA_NETTOTAL) BA_TOTAL,
						SUM(BS_NETTOTAL) BS_TOTAL,
						SUM(TAX_TOTAL) TAX_TOTAL,
						SUM(BS_OTVTOTAL) BS_OTVTOTAL,
						SUM(BA_OTVTOTAL) BA_OTVTOTAL,
						SUM(BS_OTVTOTAL+BA_OTVTOTAL) OTV_TOTAL
					FROM
						(
							SELECT
								CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN E.EXPENSE_ID ELSE NULL END AS BS_COUNT,
								CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN NULL ELSE E.EXPENSE_ID END AS BA_COUNT,
								CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(TOTAL_AMOUNT) ELSE 0 END AS BS_NETTOTAL,
								CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(TOTAL_AMOUNT) END AS BA_NETTOTAL,
								E.CH_COMPANY_ID COMPANY_ID,
								NULL CONSUMER_ID,
								FULLNAME,
								C.MEMBER_CODE,
								C.TAXOFFICE TAXOFFICE,
								C.TAXNO TAXNO,
								C.COMPANY_TELCODE TELCODE,
								C.COMPANY_TEL1 TEL,
								C.COMPANY_FAX FAX,
								(SELECT CP.TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.PARTNER_ID = C.MANAGER_PARTNER_ID) TC_IDENTY_NO,
								C.CITY CITY_ID,
								C.COUNTRY COUNTRY_ID,
								SUM(E.KDV_TOTAL) TAX_TOTAL,
								<!--- SUM(OTV_TOTAL) OTV_TOTAL --->
								CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(OTV_TOTAL) ELSE 0 END AS BS_OTVTOTAL,
								CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(OTV_TOTAL) END AS BA_OTVTOTAL
							FROM
								EXPENSE_ITEM_PLANS E,
								#dsn_alias#.COMPANY C
							WHERE
								E.CH_COMPANY_ID = C.COMPANY_ID
								<cfif isdate(attributes.start_date_)>
									AND E.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date_#">
								</cfif>
								<cfif isdate(attributes.finish_date_)>
									AND E.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date_#">
								</cfif>	
							GROUP BY
								E.ACTION_TYPE,
								E.EXPENSE_ID,
								E.CH_COMPANY_ID,
								CH_CONSUMER_ID,
								FULLNAME,
								C.MEMBER_CODE,
								C.TAXOFFICE,
								C.TAXNO,
								C.COMPANY_TELCODE,
								C.COMPANY_TEL1,
								C.COMPANY_FAX,
								C.MANAGER_PARTNER_ID,
								C.CITY,
								C.COUNTRY
						UNION ALL
							SELECT
								CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN E.EXPENSE_ID ELSE NULL END AS BS_COUNT,
								CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN NULL ELSE E.EXPENSE_ID END AS BA_COUNT,
								CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(TOTAL_AMOUNT) ELSE 0 END AS BS_NETTOTAL,
								CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(TOTAL_AMOUNT) END AS BA_NETTOTAL,
								NULL CH_COMPANY_ID,
								E.CH_CONSUMER_ID CONSUMER_ID,
								C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME,
								C.MEMBER_CODE,
								C.TAX_OFFICE TAXOFFICE,
								C.TAX_NO TAXNO,
								C.MOBIL_CODE TELCODE,
								C.MOBILTEL TEL,
								C.CONSUMER_FAX FAX,
								C.TC_IDENTY_NO,
								C.HOME_CITY_ID CITY_ID,
								C.HOME_COUNTRY_ID COUNTRY_ID,
								SUM(E.KDV_TOTAL) TAX_TOTAL,
								<!--- SUM(OTV_TOTAL) OTV_TOTAL --->
								CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(OTV_TOTAL) ELSE 0 END AS BS_OTVTOTAL,
								CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(OTV_TOTAL) END AS BA_OTVTOTAL
							FROM
								EXPENSE_ITEM_PLANS E,
								#dsn_alias#.CONSUMER C
							WHERE
								E.CH_CONSUMER_ID = C.CONSUMER_ID
								<cfif isdate(attributes.start_date_)>
									AND E.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date_#">
								</cfif>
								<cfif isdate(attributes.finish_date_)>
									AND E.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date_#">
								</cfif>
							GROUP BY
								E.ACTION_TYPE,
								E.EXPENSE_ID,
								E.CH_CONSUMER_ID,
								C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME,
								C.MEMBER_CODE,
								C.TAX_OFFICE,
								C.TAX_NO,
								C.MOBIL_CODE,
								C.MOBILTEL,
								C.CONSUMER_FAX,
								C.TC_IDENTY_NO,
								C.HOME_CITY_ID,
								C.HOME_COUNTRY_ID
						)EXP1
					GROUP BY
						COMPANY_ID,
						CONSUMER_ID,
						FULLNAME,
						MEMBER_CODE,
						TAXOFFICE,
						TAXNO,
						TELCODE,
						TEL,
						FAX,
						TC_IDENTY_NO,
						CITY_ID,
						COUNTRY_ID
				) BA_BS
				GROUP BY
					COMPANY_ID,
					CONSUMER_ID,
					FULLNAME,
					MEMBER_CODE,
					TAXOFFICE,
					TAXNO,
					TELCODE,
					TEL,
					FAX,
					TC_IDENTY_NO,
					CITY_ID,
					COUNTRY_ID
				<cfif isDefined("attributes.babs_limit") and len(attributes.babs_limit)>
				HAVING
					<cfif attributes.is_babs eq 0>
						SUM(BS_TOTAL) > = #filternum(attributes.babs_limit)# OR SUM(BA_TOTAL) > = #filternum(attributes.babs_limit)#
					<cfelseif attributes.is_babs eq 3>
						SUM(BA_TOTAL) > = #filternum(attributes.babs_limit)#
					<cfelseif attributes.is_babs eq 4>
						SUM(BS_TOTAL) > = #filternum(attributes.babs_limit)#
					<cfelse>
						SUM(BS_TOTAL) > = #filternum(attributes.babs_limit)# OR SUM(BA_TOTAL) > = #filternum(attributes.babs_limit)#
					</cfif>	
				</cfif> 
				ORDER BY
					BA_TOTAL DESC,
					BS_TOTAL DESC,
					FULLNAME
			</cfquery>
			<cfquery name="GETCOMPANY" datasource="#dsn#">
				SELECT 
					BAKIYE,
					<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
						BAKIYE_OTHER,
						OTHER_MONEY,
					<cfelseif isDefined("attributes.money_info") and len(session.ep.money2) and attributes.money_info eq 1>
						BAKIYE2,
					</cfif>
					COMPANY_ID,
					MEMBER_CODE,
					FULLNAME,
					COMPANY_EMAIL,
					COMPANYCAT,
					ACCOUNT_NAME,
					ACCOUNT_CODE
				FROM 
					(
						SELECT  
						DISTINCT							
							<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
								SUM(CARI_ROWS_TOPLAM.BORC3-CARI_ROWS_TOPLAM.ALACAK3) BAKIYE_OTHER,
								CARI_ROWS_TOPLAM.OTHER_MONEY,
							<cfelseif isDefined("attributes.money_info") and len(session.ep.money2) and attributes.money_info eq 1>
								SUM(CARI_ROWS_TOPLAM.BORC2-CARI_ROWS_TOPLAM.ALACAK2) BAKIYE2,
							</cfif>
							SUM(CARI_ROWS_TOPLAM.BORC - CARI_ROWS_TOPLAM.ALACAK) BAKIYE,
							COMPANY.COMPANY_ID,
							COMPANY.MEMBER_CODE,
							COMPANY.FULLNAME,
							COMPANY.COMPANY_EMAIL,
							COMPANY_CAT.COMPANYCAT,
							ACCOUNT_PLAN.ACCOUNT_NAME,
							ACCOUNT_PLAN.ACCOUNT_CODE
						FROM 
							COMPANY 
							INNER JOIN COMPANY_CAT ON COMPANY.COMPANYCAT_ID = COMPANY_CAT.COMPANYCAT_ID  
							INNER JOIN COMPANY_CAT_OUR_COMPANY ON COMPANY_CAT.COMPANYCAT_ID = COMPANY_CAT_OUR_COMPANY.COMPANYCAT_ID 
							LEFT OUTER JOIN #dsn2_alias#.CARI_ROWS_TOPLAM CARI_ROWS_TOPLAM ON CARI_ROWS_TOPLAM.COMPANY_ID = COMPANY.COMPANY_ID 
							LEFT OUTER JOIN COMPANY_PERIOD ON COMPANY_PERIOD.COMPANY_ID = COMPANY.COMPANY_ID AND COMPANY_PERIOD.PERIOD_ID = #getperiod.period_id# 
							LEFT OUTER JOIN #dsn2_alias#.ACCOUNT_PLAN ON ACCOUNT_PLAN.ACCOUNT_CODE = COMPANY_PERIOD.ACCOUNT_CODE 
						WHERE 
							(COMPANY.MEMBER_ADD_OPTION_ID IS NULL OR  COMPANY.MEMBER_ADD_OPTION_ID = 1) AND 
							COMPANY.COMPANY_STATUS = 1 AND 
							COMPANY_CAT_OUR_COMPANY.OUR_COMPANY_ID = #session.ep.company_id# 
							<cfif len(attributes.keyword)>AND COMPANY.FULLNAME LIKE '%#attributes.keyword#%'</cfif>
							<cfif len(attributes.start_Date_)>AND CARI_ROWS_TOPLAM.ACTION_DATE >= #attributes.start_Date_#</cfif>
							<cfif len(attributes.finish_date_)>AND CARI_ROWS_TOPLAM.ACTION_DATE < #dateadd("d",1,attributes.finish_date_)#</cfif>
							<cfif len(attributes.is_open) and attributes.is_open eq 0>AND COMPANY.COMPANY_ID NOT IN ( SELECT OWNER_ID FROM INFO_PLUS WHERE PROPERTY1 = 'Mutabakat Yapılmayacak' AND INFO_OWNER_TYPE = -1 )</cfif>
							<cfif len(attributes.is_open) and attributes.is_open eq 1>AND COMPANY.COMPANY_ID IN ( SELECT OWNER_ID FROM INFO_PLUS WHERE PROPERTY1 = 'Mutabakat Yapılmayacak' AND INFO_OWNER_TYPE = -1 )</cfif>
							<cfif len(attributes.member_cat_type)> AND COMPANY.COMPANYCAT_ID IN (#attributes.member_cat_type#)</cfif>
							<cfif len(attributes.money_info) and attributes.money_info eq 2 and isDefined("attributes.money_type_info") and len(attributes.money_type_info)>
								AND CARI_ROWS_TOPLAM.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type_info#">
							</cfif>
						GROUP BY 
						<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
							CARI_ROWS_TOPLAM.OTHER_MONEY,
						</cfif>
							COMPANY.COMPANY_ID,
							COMPANY.MEMBER_CODE,
							COMPANY.FULLNAME,
							COMPANY.COMPANY_EMAIL,
							COMPANY_CAT.COMPANYCAT,
							ACCOUNT_PLAN.ACCOUNT_NAME,
							ACCOUNT_PLAN.ACCOUNT_CODE
					) T1 
					WHERE 
						COMPANY_ID IS NOT NULL 
						<cfif len(attributes.search_type_id) and attributes.search_type_id eq 0>AND BAKIYE < 0</cfif>
						<cfif len(attributes.search_type_id) and attributes.search_type_id eq 1>AND BAKIYE > 0</cfif> 
						<cfif len(attributes.is_zero) and attributes.is_zero eq 0>AND ROUND(BAKIYE,2) <> 0</cfif>
						<cfif len(attributes.is_zero) and attributes.is_zero eq 1>AND ROUND(BAKIYE,2) = 0</cfif>
						<cfif attributes.is_babs eq 3 or attributes.is_babs eq 4>AND COMPANY_ID IN (<cfif get_ba_bs.recordcount gt 0>#valuelist(get_ba_bs.company_id,',')#<cfelse>0</cfif>)</cfif>
					ORDER BY 
						<cfif attributes.search_order_id eq 0>FULLNAME</cfif>
						<cfif attributes.search_order_id eq 1>FULLNAME DESC</cfif> 
			</cfquery>
				<cfform method="post" name="sendaction" action="index.cfm?fuseaction=finance.add_cari_letter">
					<input type="hidden" name="search_order_id" value="<cfoutput>#attributes.search_order_id#</cfoutput>">
					<input type="hidden" name="search_type_id" value="<cfoutput>#attributes.search_type_id#</cfoutput>">
					<input type="hidden" name="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>">
					<input type="hidden" name="issubmit" value="1">
					<input type="hidden" name="is_zero" value="<cfoutput>#attributes.is_zero#</cfoutput>">
					<input type="hidden" name="is_open" value="<cfoutput>#attributes.is_open#</cfoutput>">
					<input type="hidden" name="is_action" value="<cfoutput>#attributes.is_action#</cfoutput>">
					<cf_grid_list sort="0">
						<thead>
							<tr>
								<cfif isDefined("attributes.money_info") and attributes.money_info neq 2><th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th></cfif>
								<th height="22"><cf_get_lang dictionary_id="40314.Cari Kodu"></th>
								<th height="22"><cf_get_lang dictionary_id="33907.Cari Adı"></th>
								
								<cfif attributes.is_babs eq 1 or attributes.is_babs eq 2>
									<th height="22"><cf_get_lang dictionary_id="33903.Muhasebe Kodu/Muhasebe Adı"></th>
									<th style="text-align:right"><cf_get_lang dictionary_id="57589.Bakiye"></th>
									<th style="text-align:center"><cf_get_lang dictionary_id="33873.D"></th>
									<th style="text-align:right"><cf_get_lang dictionary_id="57589.Bakiye"></th>
									<th style="text-align:center"><cf_get_lang dictionary_id="33873.D"></th>
									<th style="text-align:right"><cf_get_lang dictionary_id="58583.Fark"></th>
									<th><cf_get_lang dictionary_id="33842.Son Mutabakat Tarihi"></th>
									<th><cf_get_lang dictionary_id="34068.Son Mutabakatı Yapan"></th>
									<th><cf_get_lang dictionary_id="34066.Mutabakat Email"></th>
								</cfif>
								
								<cfif attributes.is_babs eq 3>
									<th><cf_get_lang dictionary_id="57487.No"><cf_get_lang dictionary_id="57589.Bakiye"></th>
									<th style="text-align:center "><cf_get_lang dictionary_id="33873.D"></th>
									<th><cf_get_lang dictionary_id="34027.BA Email"></th>
									<th style="text-align:right"><cf_get_lang dictionary_id="34017.BA Belge Adedi"></th>
									<th style="text-align:right"><cf_get_lang dictionary_id="33997.BA Net Tutar"></th>
									<th><cf_get_lang dictionary_id="33995.Son BA Tarihi"></th>
									<th><cf_get_lang dictionary_id="33989.Son BA Yapan"></th>
								</cfif>
								<cfif attributes.is_babs eq 4>
									<th><cf_get_lang dictionary_id="57589.Bakiye"></th>
									<th style="text-align:center "><cf_get_lang dictionary_id="33873.D"></th>
									<th><cf_get_lang dictionary_id="33982.BS Email"></th>
									<th style="text-align:right"><cf_get_lang dictionary_id="33977.BS Belge Adedi"></th>
									<th style="text-align:right"><cf_get_lang dictionary_id="33976.BS Net Tutar"></th>
									<th><cf_get_lang dictionary_id="33974.Son BS Tarihi"></th>
									<th><cf_get_lang dictionary_id="33973.Son BS Yapan"></th>
								</cfif>
								<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
									<th class="moneybox"><cf_get_lang dictionary_id="57589.Bakiye"></th>
									<th><cf_get_lang dictionary_id='30636.Para Birimi'></th>
									<th style="text-align:center "><cf_get_lang dictionary_id="33873.D"></th>										
								</cfif>
								<cfif isDefined("attributes.money_info") and len(session.ep.money2) and attributes.money_info eq 1>
									<th class="moneybox"><cfoutput>#session.ep.money2# </cfoutput> <cf_get_lang dictionary_id='57589.Bakiye'></th>
									<th style="text-align:center "><cf_get_lang dictionary_id="33873.D"></th>
								</cfif>
								<th height="22" style="text-align:center"><input type="checkbox" name="is_all" id="is_all" onclick="checkhepsi();" /></th>
								<th><a><i class="fa fa-print" align="absmiddle" border="0" /></i></a></th>
							</tr>
						</thead>
						<tbody>	
							<cfset totalloop = 0>
							<cfset toplam = 0>
							<cfset toplam_sistem_1 = 0>
							<cfset total1 = 0>
							<cfset total2 = 0>
							<cfset total3 = 0>
							<cfset total4 = 0>
							<cfset company_list = ''>
							<cfset company_count_list = ''>
							<cfif isDefined("attributes.money_info") and attributes.money_info eq 2> 
								<cfoutput query="getcompany">
									<cfif listfindnocase(company_list,company_id)>
										<cfset sira_ = listfindnocase(company_list,company_id)>
										<cfset sayi_ = listgetat(company_count_list,sira_)>
										<cfset sayi_ = sayi_ + 1>
										<cfset company_count_list = listsetat(company_count_list,sira_,sayi_)>								
									<cfelseif not listfindnocase(company_list,company_id)>
										<cfset company_list = listappend(company_list,company_id)>
										<cfset company_count_list = listappend(company_count_list,1)>									
									</cfif>
								</cfoutput>
							</cfif>
							<cfoutput query="getcompany"> 
								<cfquery name="GETREMINDER" datasource="#dsn2#">
									SELECT SUM(BORC - ALACAK) AS BAKIYEOTHER FROM ACCOUNT_ACCOUNT_REMAINDER WHERE ACCOUNT_ID = '#account_code#'
								</cfquery>
								<cfset fark = 0>
								<cfif len(getreminder.bakiyeother)>
									<cfset fark = round(getreminder.bakiyeother*100)/100>
								</cfif>
								<cfif len(bakiye)>
									<cfset fark = fark - round(bakiye*100)/100>
								</cfif>
								<cfquery name="GETLETTER" datasource="#dsn2#" maxrows="1">
									SELECT 
										CARI_LETTER_ROW.RECORD_DATE, 
										CARI_LETTER_ROW.RECORD_EMP 
									FROM 
										CARI_LETTER,
										CARI_LETTER_ROW
									WHERE 
										CARI_LETTER.CARI_LETTER_ID = CARI_LETTER_ROW.CARI_LETTER_ID AND 
										CARI_LETTER_ROW.COMPANY_ID = #company_id# 
										<cfif attributes.is_babs eq 1>AND CARI_LETTER.IS_CH = 1</cfif>
										<cfif attributes.is_babs eq 2>AND CARI_LETTER.IS_CR = 1</cfif>
										<cfif attributes.is_babs eq 3>AND CARI_LETTER.IS_BA = 1</cfif>
										<cfif attributes.is_babs eq 4>AND CARI_LETTER.IS_BS = 1</cfif>
									ORDER BY 
										CARI_LETTER.RECORD_DATE DESC
								</cfquery>
								<cfquery name="GETCARI" datasource="#dsn2#" maxrows="1">
									SELECT CARI_ACTION_ID FROM CARI_ROWS WHERE ( FROM_CMP_ID = #company_id# OR TO_CMP_ID = #company_id# ) AND ACTION_DATE > <cfif getletter.recordcount>#CreateDateTime(year(getletter.record_date),month(getletter.record_date),day(getletter.record_date),hour(getletter.record_date),minute(getletter.record_date),second(getletter.record_date))#<cfelse>#dateadd("d",9999,now())#</cfif>
								</cfquery>
								<cfif attributes.is_action eq 0>
									<cfif getletter.recordcount gt 0 and getcari.recordcount eq 0>
										<cfset showline = 0>
									</cfif>
									<cfif getletter.recordcount gt 0 and getcari.recordcount gt 0>
										<cfset showline = 1>
									</cfif>
									<cfif getletter.recordcount eq 0>
										<cfset showline = 1>
									</cfif>
								</cfif>
								<cfif attributes.is_action eq 1>
									<cfset showline = 1>
								</cfif>
								<cfif showline eq 1>
									<cfset totalloop = totalloop + 1>
									<cfquery name="GETMUTABAKAT" datasource="#dsn#">
										SELECT COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER WHERE COMPANY_ID = #company_id# AND (MISSION = 2 or MISSION = 3)
									</cfquery>
									<cfquery name="GETFINANCE" datasource="#dsn#">
										SELECT COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER WHERE COMPANY_ID = #company_id# AND MISSION = 9999
									</cfquery>
									<cfquery name="GETBABS" datasource="#dsn#">
										SELECT COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER WHERE COMPANY_ID = #company_id# AND (MISSION = 1 or MISSION = 3)
									</cfquery>
									<cfquery name="GETBABSVALUE" dbtype="query">
										SELECT * FROM GET_BA_BS WHERE COMPANY_ID = #company_id#
									</cfquery>
									<cfscript>
										this_sira_ = listfindnocase(company_list,company_id);
										if(this_sira_ gt 0)
											this_rows_ = listgetat(company_count_list,this_sira_);
										else
										this_rows_ = 1;									
									</cfscript>
									<tr>
										<cfif isDefined("attributes.money_info") and attributes.money_info neq 2><td width="20">#totalloop#</td></cfif>
										<cfif ((totalloop eq 1 or MEMBER_CODE[currentrow] neq MEMBER_CODE[currentrow-1]))>
											<td rowspan="#this_rows_#"><a href="index.cfm?fuseaction=member.form_list_company&event=det&cpid=#company_id#" class="tableyazi" target="_blank">#member_code#</a></td>
											<td rowspan="#this_rows_#"><a href="index.cfm?fuseaction=member.form_list_company&event=det&cpid=#company_id#" class="tableyazi" target="_blank">#fullname#</a></td>											
											<cfif attributes.is_babs eq 1 or attributes.is_babs eq 2>	<td rowspan="#this_rows_#">#account_code#<br>#account_name#</td></cfif>
										</cfif>
										<cfif attributes.is_babs eq 1 or attributes.is_babs eq 2>										
											<td style="text-align:right"><a href="index.cfm?fuseaction=account.list_account_card_rows&acc_code1_1=#account_code#&acc_code2_1=#account_code#&form_is_submitted=1&date1=#dateformat(attributes.start_date_,'dd/mm/yyyy')#&date2=#dateformat(attributes.finish_date_,'dd/mm/yyyy')#" class="tableyazi" target="_blank"><cfif len(getreminder.bakiyeother)><cfif getreminder.bakiyeother lt 0>#tlformat(-1*getreminder.bakiyeother)#<cfelse>#tlformat(getreminder.bakiyeother)#</cfif></cfif></a></td>
											<td style="text-align:center"><cfif len(getreminder.bakiyeother)><cfif getreminder.bakiyeother lt 0>(A)</cfif><cfif getreminder.bakiyeother gt 0>(B)</cfif></cfif></td>
											<td style="text-align:right" nowrap><input type="text" id="cariamount#currentrow#" name="cariamount#currentrow#" value="<cfif len(bakiye)><cfif bakiye lt 0><cfset toplam = toplam + bakiye>#tlformat(-1*bakiye)#<cfelse><cfset toplam = toplam + bakiye>#tlformat(bakiye)#</cfif><cfif filternum(tlformat(bakiye)) lt 0><cfelseif filternum(tlformat(bakiye)) gt 0><cfelseif filternum(tlformat(bakiye)) eq 0></cfif><cfelse>#tlformat(0)#</cfif>" class="moneybox"  onkeyup="return(FormatCurrency(this,event));"> #session.ep.money#</td>
											<td style="text-align:center"><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#company_id#','page');" class="tableyazi"><cfif len(bakiye)><cfif bakiye lt 0>A<cfelseif bakiye gt 0>B<cfelseif filternum(tlformat(bakiye)) eq 0></cfif></cfif></a></td>
											<td style="text-align:right">#tlformat(fark)#</td>
											<td nowrap="nowrap">#dateformat(getletter.record_date,'dd/mm/yyyy')#</td>
											<td>#get_emp_info(getletter.record_emp,0,0)#</td>
											<td><cfif len(getmutabakat.company_partner_email)>#getmutabakat.company_partner_email#<cfelseif len(getfinance.company_partner_email)>#getfinance.company_partner_email#<cfelse>#company_email#</cfif></td>
										</cfif>
										<input type="hidden" name="caristatus#currentrow#" id="caristatus#currentrow#" value="<cfif len(bakiye)><cfif bakiye lt 0>0</cfif><cfif bakiye gt 0>1</cfif><cfif bakiye eq 0>1</cfif><cfelse>1</cfif>">
										<input type="hidden" name="chemail#currentrow#" id="chemail#currentrow#" value="<cfif len(getmutabakat.company_partner_email)>#getmutabakat.company_partner_email#<cfelseif len(getfinance.company_partner_email)>#getfinance.company_partner_email#<cfelse>#company_email#</cfif>">
										<input type="hidden" name="asemail#currentrow#" id="asemail#currentrow#" value="<cfif len(getbabs.company_partner_email)>#getbabs.company_partner_email#<cfelseif len(getfinance.company_partner_email)>#getfinance.company_partner_email#<cfelse>#company_email#</cfif>">
										<input type="hidden" name="accountamount#currentrow#" value="#getreminder.bakiyeother#" />
										<input type="hidden" name="accountcode#currentrow#" value="#account_code#" />
										<cfif attributes.is_babs eq 3>
											<td style="text-align:right" nowrap><cfif len(bakiye)><cfif bakiye lt 0><cfset toplam = toplam + bakiye>#tlformat(-1*bakiye)#<cfelse><cfset toplam = toplam + bakiye>#tlformat(bakiye)#</cfif><cfif filternum(tlformat(bakiye)) lt 0><cfelseif filternum(tlformat(bakiye)) gt 0><cfelseif filternum(tlformat(bakiye)) eq 0></cfif><cfelse>#tlformat(0)#</cfif> #session.ep.money#</td>
											<td style="text-align:center"><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#company_id#','page');" class="tableyazi"><cfif len(bakiye)><cfif bakiye lt 0>A<cfelseif bakiye gt 0>B<cfelseif filternum(tlformat(bakiye)) eq 0>-</cfif></cfif></a></td>
											<td><cfif len(getbabs.company_partner_email)>#getbabs.company_partner_email#<cfelseif len(getfinance.company_partner_email)>#getfinance.company_partner_email#<cfelse>#company_email#</cfif></td>
											<td style="text-align:right"><cfif attributes.is_babs eq 3><input name="batotal#currentrow#" id="batotal#currentrow#" type="text" style="width:40px;" value="#getbabsvalue.ba_paper_count#<cfif len(getbabsvalue.ba_paper_count)><cfset total1 = total1 +  getbabsvalue.ba_paper_count></cfif>"></cfif></td>
											<td style="text-align:right" nowrap><cfif attributes.is_babs eq 3><input name="baamount#currentrow#" id="baamount#currentrow#" type="text" style="width:100px;" value="<cfif len(getbabsvalue.ba_total)>#tlformat(getbabsvalue.ba_total,2)#</cfif><cfif len(getbabsvalue.ba_total)><cfset total2 = total2 +  getbabsvalue.ba_total></cfif>" class="moneybox"  onkeyup="return(FormatCurrency(this,event));"> #session.ep.money#</cfif></td>
											<td nowrap="nowrap">#dateformat(getletter.record_date,'dd/mm/yyyy')#</td>
											<td>#get_emp_info(getletter.record_emp,0,0)#</td>
										</cfif>
										
										<cfif attributes.is_babs eq 4>
											<td style="text-align:right" nowrap><cfif len(bakiye)><cfif bakiye lt 0><cfset toplam = toplam + bakiye>#tlformat(-1*bakiye)#<cfelse><cfset toplam = toplam + bakiye>#tlformat(bakiye)#</cfif><cfif filternum(tlformat(bakiye)) lt 0><cfelseif filternum(tlformat(bakiye)) gt 0><cfelseif filternum(tlformat(bakiye)) eq 0></cfif><cfelse>#tlformat(0)#</cfif> #session.ep.money#</td>
											<td style="text-align:center"><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#company_id#','page');" class="tableyazi"><cfif len(bakiye)><cfif bakiye lt 0>A<cfelseif bakiye gt 0>B<cfelseif filternum(tlformat(bakiye)) eq 0>-</cfif></cfif></a></td>
											<td><cfif len(getbabs.company_partner_email)>#getbabs.company_partner_email#<cfelseif len(getfinance.company_partner_email)>#getfinance.company_partner_email#<cfelse>#company_email#</cfif></td>
											<td style="text-align:right"><cfif attributes.is_babs eq 4><input name="bstotal#currentrow#" id="bstotal#currentrow#" type="text" style="width:40px;" value="#getbabsvalue.bs_paper_count#<cfif len(getbabsvalue.bs_paper_count)><cfset total3 = total3 +  getbabsvalue.bs_paper_count></cfif>"></cfif></td>
											<td style="text-align:right" nowrap><cfif attributes.is_babs eq 4><input name="bsamount#currentrow#" id="bsamount#currentrow#" type="text" style="width:100px;" value="<cfif len(getbabsvalue.bs_total)>#tlformat(getbabsvalue.bs_total,2)#</cfif><cfif len(getbabsvalue.bs_total)><cfset total4 = total4 +  getbabsvalue.bs_total></cfif>" onkeyup="return(FormatCurrency(this,event));"> #session.ep.money#</cfif></td>
											<td nowrap="nowrap">#dateformat(getletter.record_date,'dd/mm/yyyy')#</td>
											<td>#get_emp_info(getletter.record_emp,0,0)#</td>
										</cfif>
										<cfset money_type = (isDefined("attributes.money_info") and attributes.money_info eq 1) ? session.ep.money2 : (isDefined("attributes.money_info") and attributes.money_info eq 2) ? OTHER_MONEY : (IsDefined("attributes.money_type_info") and len(attributes.money_type_info) ? attributes.money_type_info : "" )>
										<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
											<td style="text-align:right" nowrap><input type="hidden" name="moneytype#currentrow#" id="moneytype#currentrow#" value="#money_type#"><input type="text" id="cariamount_sistem#currentrow#" name="cariamount_sistem#currentrow#" value="<cfif len(BAKIYE_OTHER)><cfif BAKIYE_OTHER lt 0><cfset 'toplam_sistem_TL' = evaluate('toplam_sistem_TL') + BAKIYE_OTHER>#tlformat(-1*BAKIYE_OTHER)#<cfelse><cfset 'toplam_sistem_TL' = evaluate('toplam_sistem_TL') + BAKIYE_OTHER>#tlformat(BAKIYE_OTHER)#</cfif><cfif filternum(tlformat(BAKIYE_OTHER)) lt 0><cfelseif filternum(tlformat(BAKIYE_OTHER)) gt 0><cfelseif filternum(tlformat(BAKIYE_OTHER)) eq 0></cfif><cfelse>#tlformat(0)#</cfif>" class="moneybox"  onkeyup="return(FormatCurrency(this,event));"></td>
												<td>#OTHER_MONEY#</td>
												<td style="text-align:center"><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#company_id#','page');" class="tableyazi"><cfif len(BAKIYE_OTHER)><cfif BAKIYE_OTHER lt 0>A<cfelseif BAKIYE_OTHER gt 0>B<cfelseif filternum(tlformat(BAKIYE_OTHER)) eq 0></cfif></cfif></a></td>										
										</cfif>										
										<cfif isDefined("attributes.money_info") and len(session.ep.money2) and attributes.money_info eq 1>
											<td style="text-align:right" nowrap><input type="hidden" name="moneytype#currentrow#" id="moneytype#currentrow#" value="#money_type#"><input type="text" id="cariamount_sistem#currentrow#" name="cariamount_sistem#currentrow#" value="<cfif len(BAKIYE2)><cfif BAKIYE2 lt 0><cfset toplam_sistem_1 = toplam_sistem_1 + BAKIYE2>#tlformat(-1*BAKIYE2)#<cfelse><cfset toplam_sistem_1= toplam_sistem_1 + BAKIYE2>#tlformat(BAKIYE2)#</cfif><cfif filternum(tlformat(BAKIYE2)) lt 0><cfelseif filternum(tlformat(BAKIYE2)) gt 0><cfelseif filternum(tlformat(BAKIYE2)) eq 0></cfif><cfelse>#tlformat(0)#</cfif>" class="moneybox"  onkeyup="return(FormatCurrency(this,event));"></td>
											<td style="text-align:center"><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#company_id#','page');" class="tableyazi"><cfif len(BAKIYE2)><cfif BAKIYE2 lt 0>A<cfelseif BAKIYE2 gt 0>B<cfelseif filternum(tlformat(BAKIYE2)) eq 0></cfif></cfif></a></td>
										</cfif>
										<td bgcolor="##FFFFFF" align="center" style="text-align:center">
										<input type="hidden" name="company_id_#currentrow#" id="company_id_#currentrow#" value="#company_id#">
										<input type="checkbox" name="company_id" id="company_id" value="#currentrow#" /></td>
										<td bgcolor="##FFFFFF" align="center" style="text-align:center"><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=finance.popup_form_print_cari&money_type=#money_type#&money_info_=#attributes.money_info#&company_id=#company_id#&start_Date_=#dateformat(attributes.start_date_,'dd/mm/yyyy')#&finish_date_=#dateformat(attributes.finish_date_,'dd/mm/yyyy')#','project')"><i class="fa fa-print" align="absmiddle" border="0" /></i></a></td>
									</tr>
								</cfif>
							</cfoutput>
							<tr>
								<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
								<td colspan="<cfif attributes.is_babs eq 3 or attributes.is_babs eq 4><cfif isDefined("attributes.money_info") and attributes.money_info eq 2>2<cfelse>3</cfif><cfelse><cfif isDefined("attributes.money_info") and attributes.money_info eq 2>5<cfelse>6</cfif></cfif>"><b><cf_get_lang dictionary_id="57492.Toplam"></b></td>
								<td height="24" style="text-align:right"><b><cfoutput><cfif toplam gt 0>#tlformat(toplam)# #session.ep.money#</cfif><cfif toplam lt 0>#tlformat(-1*toplam)# #session.ep.money#</cfif></cfoutput></b></td>
								<td height="24" style="text-align:center"><b><cfoutput><cfif toplam gt 0>B</cfif><cfif toplam lt 0>A</cfif></cfoutput></b></td>
								<td colspan="<cfif attributes.is_babs eq 3 or attributes.is_babs eq 4>1<cfelse>4</cfif>">&nbsp;</td>								
								<cfif attributes.is_babs eq 3>
									<td style="text-align:right"><b><cfoutput>#tlformat(total1)#</cfoutput></b></td>
									<td style="text-align:right"><b><cfoutput>#tlformat(total2)# #session.ep.money#</cfoutput></b></td>
								</cfif>
								<cfif attributes.is_babs eq 4>
									<td style="text-align:right"><b><cfoutput>#tlformat(total3)#</cfoutput></b></td>
									<td style="text-align:right"><b><cfoutput>#tlformat(total4)# #session.ep.money#</cfoutput></b></td>
								</cfif>
								<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
									<td <cfif attributes.is_babs eq 3 or attributes.is_babs eq 4> colspan="3"</cfif> height="24" style="text-align:right"><b>
										<cfoutput query="get_money">
											<cfif evaluate('toplam_sistem_#money#') neq 0>
												<cfif evaluate('toplam_sistem_#money#') gt 0>
													#Tlformat(evaluate('toplam_sistem_#money#'))#<br/>
												<cfelseif toplam lt 0>
													#Tlformat(-1*(evaluate('toplam_sistem_#money#')))#<br/>
												</cfif>												
											</cfif>
										</cfoutput>
									</td>
									<td><b>								
										<cfoutput query="get_money">
											<cfif evaluate('toplam_sistem_#money#') neq 0>
												#money#<br/>
											</cfif>
										</cfoutput>
									</td>
									<td class="text-center">
										<cfoutput query="get_money">
											<cfset bakiye_ = evaluate('toplam_sistem_#get_money.money#')>
											<cfif bakiye_ neq 0>
												<cfif bakiye_ gt 0>(B)<cfelse>(A)</cfif><br/>
											</cfif>
										</cfoutput>
									</td>
								</cfif>
								<cfif isDefined("attributes.money_info") and len(session.ep.money2) and attributes.money_info eq 1>
									<td <cfif attributes.is_babs eq 3 or attributes.is_babs eq 4> colspan="3"</cfif> height="24" style="text-align:right"><b><cfoutput><cfif toplam_sistem_1 gt 0>#tlformat(toplam_sistem_1)# #session.ep.money2#</cfif><cfif toplam_sistem_1 lt 0>#tlformat(-1*toplam_sistem_1)# #session.ep.money2#</cfif></cfoutput></b></td>
									<td height="24" style="text-align:center"><b><cfoutput>
										<cfif toplam_sistem_1 gt 0>B</cfif><cfif toplam_sistem_1 lt 0>A</cfif>
									</cfoutput></b></td>
								</cfif>
								<td colspan="4">&nbsp;</td>
							</tr>
							<tr height="20">
								<td colspan="20" align="right" style="text-align:right">
								<input type="hidden" name="babs_limit" id="babs_limit" value="<cfoutput>#attributes.babs_limit#</cfoutput>" onkeyup="return(FormatCurrency(this,event,2,'float'));"/>
								<input type="hidden" name="is_babs" id="is_babs" value="<cfoutput>#attributes.is_babs#</cfoutput>">
								<input type="hidden" name="start_date_" id="start_date_" value="<cfoutput>#dateformat(attributes.start_date_,'dd/mm/yyyy')#</cfoutput>">
								<input type="hidden" name="finish_date_" id="finish_date_" value="<cfoutput>#dateformat(attributes.finish_date_,'dd/mm/yyyy')#</cfoutput>">
								<cfsavecontent variable="message_start"><cf_get_lang dictionary_id='64386.Lütfen Dönem Başlangıç-Bitiş Tarihi Giriniz'></cfsavecontent>
								<cfif len(attributes.start_Date_)>
									<cfinput value="#dateformat(attributes.start_date_,'dd/mm/yyyy')#" validate="eurodate" required="Yes" message="#message_start#!" type="text" name="start_date" style="width:75px;" readonly="yes">
								<cfelse>
									<cfinput value="" validate="eurodate" required="Yes" message="#message_start#!" type="text" name="start_Date" style="width:75px;" readonly="yes">
								</cfif>
								&nbsp;&nbsp;
								<cfif len(attributes.finish_date_)>
									<cfinput value="#dateformat(attributes.finish_date_,'dd/mm/yyyy')#" validate="eurodate" required="Yes" message="#message_start#!" type="text" name="finish_date" style="width:75px;" readonly="yes">
								<cfelse>	
									<cfinput value="" validate="eurodate" required="Yes" message="#message_start#!" type="text" name="finish_date" style="width:75px;" readonly="yes">
								</cfif>
								&nbsp;<cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
							</tr>
						</tbody>
					</cf_grid_list>
				</cfform>
		<cfelse>
			<cf_grid_list>
				<tbody>
					<tr>
						<td><cf_get_lang dictionary_id="57701.Filtre Ediniz">!</td>
					</tr>
				</tbody>
			</cf_grid_list>
		</cfif>
	</cf_box>
</div>
<script language="JavaScript">
	function is_babs_change() {
		if($("#is_babs").val() == 3 || $("#is_babs").val() == 4)
		{
			$('#efatura_earchive').css("display", "block");
		}
		else{
			$('#efatura_earchive').css("display", "none");
		}
	}
<cfif isdefined("getcompany")>
function checkhepsi()
{
	if(document.sendaction.is_all.checked==true)
	{
		<cfoutput query="getcompany">
			document.sendaction.company_id[#currentrow-1#].checked=true;
		</cfoutput> 
	}
	else 
	{
		<cfoutput query="getcompany">
			document.sendaction.company_id[#currentrow-1#].checked=false;
		</cfoutput> 
	}
}
</cfif>
function searchkontrol()
{
	if(document.searchform.is_babs.value==0)
	{
		alert("<cf_get_lang dictionary_id='45500.İşlem Tipi Seçmelisiniz!'>");
		return false;
	}
	else 
	{
		return true;
	}
}
function show_money_type()
	{
		if(document.getElementById('money_info').value == 2)//islem dövizi seçilmisse
			document.getElementById('item-money_type').style.display = '';
		else
		{
			document.getElementById('item-money_type').style.display = 'none';
			document.getElementById('money_type_info').value='';
		}
	}
function kontrol()
{
	
}
document.getElementById('keyword').focus();
</script>
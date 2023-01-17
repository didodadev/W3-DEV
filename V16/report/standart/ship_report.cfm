<cfparam name="attributes.module_id_control" default="13">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.belge_no" default="">
<cfparam name="attributes.cat" default=''>
<cfparam name="attributes.invoice_action" default=''>
<cfparam name="attributes.oby" default=1>
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.member_cat_type" default="1">
<cfparam name="attributes.is_excel" default="">
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY HIERARCHY
</cfquery>
<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
	<cf_date tarih="attributes.date2">
<cfelse>
	<cfset attributes.date2 = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
</cfif>
<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
	<cf_date tarih="attributes.date1">
<cfelse>
	<cfset attributes.date1 = date_add('ww',-1,attributes.date2)>
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
<!--- irsaliye bir sonraki donemde faturaya cekilebilecegi icin bi sonraki donem dsn bilgisi set ediliyor --->
	<cfquery name="GET_OTHER_PERIOD" datasource="#dsn#" maxrows="1">
		SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID=#session.ep.company_id# AND PERIOD_YEAR > #session.ep.period_year# ORDER BY PERIOD_YEAR ASC
	</cfquery>
	<cfif GET_OTHER_PERIOD.recordcount>
		<cfset new_perido_dsn = '#dsn#_#GET_OTHER_PERIOD.PERIOD_YEAR#_#GET_OTHER_PERIOD.OUR_COMPANY_ID#'>
	<cfelse>
		<cfset new_perido_dsn =''>
	</cfif>
	<cfif isdefined("attributes.report_type") and attributes.report_type eq 1>
	<cfquery name="GET_SHIP_FIS" datasource="#dsn2#">
		SELECT
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID,
			P.PRODUCT_ID,
			P.PRODUCT_NAME,
			P.BARCOD,
			P.PRODUCT_CODE,
			SUM(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK,
			PU.MAIN_UNIT AS BIRIM
		FROM
			SHIP,
			SHIP_ROW SR,		
			#dsn3_alias#.STOCKS S,
			#dsn3_alias#.PRODUCT_CAT PC,
			#dsn3_alias#.PRODUCT P,
			#dsn3_alias#.PRODUCT_UNIT PU
		WHERE
			SHIP.PURCHASE_SALES = 0 AND	
			SHIP.IS_SHIP_IPTAL = 0 AND 
			PC.PRODUCT_CATID = P.PRODUCT_CATID AND	
			S.PRODUCT_ID = P.PRODUCT_ID AND	
			SR.STOCK_ID = S.STOCK_ID AND	
			SHIP.SHIP_ID = SR.SHIP_ID AND 
			PU.PRODUCT_ID = P.PRODUCT_ID AND	
			S.PRODUCT_ID = SR.PRODUCT_ID AND 
			PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID
			AND SHIP.SHIP_DATE BETWEEN #attributes.date1# and #attributes.date2#
            <cfif len(attributes.cat)>AND SHIP.SHIP_TYPE = #attributes.cat#<cfelse>AND SHIP.SHIP_ID IS NOT NULL</cfif>
			<cfif len(attributes.belge_no)>AND (SHIP.SHIP_NUMBER LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%')</cfif>
			<cfif len(attributes.consumer_id) and attributes.consumer_id gt 0>AND SHIP.CONSUMER_ID = #attributes.consumer_id#</cfif>
			<cfif len(attributes.company_id) and attributes.company_id gt 0>AND SHIP.COMPANY_ID = #attributes.company_id#</cfif>
			<cfif len(attributes.stock_id) and len(attributes.product_name)>AND S.STOCK_ID = #attributes.stock_id#</cfif>
			<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '1'>
				AND SHIP.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID = #listlast(attributes.member_cat_type,'-')#)
			</cfif>
			<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '2'>
				AND SHIP.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID = #listlast(attributes.member_cat_type,'-')#)
			</cfif>
			<cfif isDefined("attributes.DEPARTMENT_ID") and len(attributes.DEPARTMENT_ID)>AND (SHIP.DEPARTMENT_IN = #attributes.DEPARTMENT_ID# OR SHIP.DELIVER_STORE_ID = #attributes.DEPARTMENT_ID#)</cfif>
		GROUP  BY	
			PC.PRODUCT_CAT,
			PC.PRODUCT_CATID,			
			PC.HIERARCHY,
			P.PRODUCT_ID,
			P.BARCOD,
			P.PRODUCT_NAME,
			P.PRODUCT_CODE,
			SR.PRODUCT_ID,
			PU.MAIN_UNIT	
	</cfquery>
	<cfelse>
	<cfquery name="GET_SHIP_FIS" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
	<cfif (len(attributes.cat) and listFind("70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,761,85,86,140,141",attributes.cat)) or not len(attributes.cat)>
		<cfif len(attributes.invoice_action)>
			<!--- faturali mi veya faturasiz mi soruldugu icin INVOICE_SHIPS iliskisi her halukarda aranacak --->
			SELECT
				SHIP.SHIP_ID,
				SHIP.SHIP_NUMBER AS BELGE_NO,
				SHIP.SHIP_TYPE AS ISLEM_TIPI,
				SHIP.SHIP_DATE AS ISLEM_TARIHI,
				SHIP.COMPANY_ID,
				SHIP.CONSUMER_ID,
				SHIP.PARTNER_ID,
				0 AS EMPLOYEE_ID,
				DEPARTMENT_IN AS DEPARTMENT_ID,
				SHIP.DELIVER_STORE_ID AS DEPARTMENT_ID_2,
				DELIVER_EMP AS DELIVER_EMP,
				S.STOCK_CODE,
				S.STOCK_ID,
				S.PRODUCT_NAME,
				SHIP_ROW.AMOUNT,
				SHIP.PURCHASE_SALES
			FROM 	
				SHIP,
				SHIP_ROW,
				#DSN3_alias#.STOCKS S
			WHERE 
				SHIP_ROW.SHIP_ID = SHIP.SHIP_ID AND
				SHIP.IS_SHIP_IPTAL = 0 AND 
				SHIP_ROW.STOCK_ID = S.STOCK_ID AND
				<cfif attributes.invoice_action eq 1>
				SHIP.SHIP_ID IN (
								SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID=#session.ep.period_id#
								<cfif isdefined('new_perido_dsn') and len(new_perido_dsn)>
								UNION ALL SELECT SHIP_ID FROM #new_perido_dsn#.INVOICE_SHIPS INVOICE_SHIPS WHERE SHIP_PERIOD_ID=#session.ep.period_id#
								</cfif>
							)
				<cfelse>
				SHIP.SHIP_ID NOT IN (
									SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID=#session.ep.period_id#
									<cfif isdefined('new_perido_dsn') and len(new_perido_dsn)>
									UNION ALL SELECT SHIP_ID FROM #new_perido_dsn#.INVOICE_SHIPS INVOICE_SHIPS WHERE SHIP_PERIOD_ID=#session.ep.period_id#
									</cfif>
									)
				</cfif>
				<cfif len(attributes.cat)>AND SHIP.SHIP_TYPE = #attributes.cat#<cfelse>AND SHIP.SHIP_ID IS NOT NULL</cfif>
				AND SHIP.SHIP_DATE BETWEEN #attributes.date1# and #attributes.date2#
				<cfif isDefined("attributes.DEPARTMENT_ID") and len(attributes.DEPARTMENT_ID)>AND (DEPARTMENT_IN = #attributes.DEPARTMENT_ID# OR DELIVER_STORE_ID = #attributes.DEPARTMENT_ID#)</cfif>
				<cfif len(attributes.belge_no)>AND (SHIP.SHIP_NUMBER LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%')</cfif>
				<cfif len(attributes.consumer_id) and attributes.consumer_id gt 0>AND SHIP.CONSUMER_ID = #attributes.consumer_id#</cfif>
				<cfif len(attributes.company_id) and attributes.company_id gt 0>AND SHIP.COMPANY_ID = #attributes.company_id#</cfif>
				<cfif len(attributes.stock_id) and len(attributes.product_name)>AND S.STOCK_ID = #attributes.stock_id#</cfif>
				<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '1'>
					AND SHIP.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID = #listlast(attributes.member_cat_type,'-')#)
				</cfif>
				<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '2'>
					AND SHIP.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID = #listlast(attributes.member_cat_type,'-')#)
				</cfif>
		<cfelse>
			SELECT
				SHIP.SHIP_ID,
				SHIP.SHIP_NUMBER AS BELGE_NO,
				SHIP.SHIP_TYPE AS ISLEM_TIPI,
				SHIP.SHIP_DATE AS ISLEM_TARIHI,
				SHIP.COMPANY_ID,
				SHIP.CONSUMER_ID,
				SHIP.PARTNER_ID,
				0 AS EMPLOYEE_ID,
				DEPARTMENT_IN AS DEPARTMENT_ID,
				SHIP.DELIVER_STORE_ID AS DEPARTMENT_ID_2,
				NULL AS INVOICE_NUMBER, 
				DELIVER_EMP AS DELIVER_EMP,
				S.STOCK_CODE,
				S.STOCK_ID,
				S.PRODUCT_NAME,
				SHIP_ROW.AMOUNT,
				SHIP.PURCHASE_SALES
			FROM 	
				SHIP,
				SHIP_ROW,
				#DSN3_alias#.STOCKS S
			WHERE 
				SHIP_ROW.SHIP_ID = SHIP.SHIP_ID AND
				SHIP.IS_SHIP_IPTAL = 0 AND 
				SHIP_ROW.STOCK_ID = S.STOCK_ID AND
				<cfif len(attributes.cat)>SHIP.SHIP_TYPE = #attributes.cat#<cfelse>SHIP.SHIP_ID IS NOT NULL</cfif>
				AND SHIP.SHIP_DATE BETWEEN #attributes.date1# and #attributes.date2#
				<cfif isDefined("attributes.DEPARTMENT_ID") and len(attributes.DEPARTMENT_ID)>AND (DEPARTMENT_IN = #attributes.DEPARTMENT_ID# OR DELIVER_STORE_ID = #attributes.DEPARTMENT_ID#)</cfif>
				<cfif len(attributes.belge_no)>AND (SHIP.SHIP_NUMBER LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%')</cfif>
				<cfif len(attributes.consumer_id) and attributes.consumer_id gt 0>AND SHIP.CONSUMER_ID = #attributes.consumer_id#</cfif>
				<cfif len(attributes.company_id) and attributes.company_id gt 0>AND SHIP.COMPANY_ID = #attributes.company_id#</cfif>
				<cfif len(attributes.stock_id) and len(attributes.product_name)>AND S.STOCK_ID = #attributes.stock_id#</cfif>
				<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '1'>
					AND SHIP.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID = #listlast(attributes.member_cat_type,'-')#)
				</cfif>
				<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '2'>
					AND SHIP.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID = #listlast(attributes.member_cat_type,'-')#)
				</cfif>
		</cfif>	
	</cfif>
	<cfif attributes.oby eq 2>
		ORDER BY ISLEM_TARIHI
	<cfelseif attributes.oby eq 3>
		ORDER BY BELGE_NO
	<cfelseif attributes.oby eq 4>
		ORDER BY BELGE_NO DESC
	<cfelseif attributes.oby eq 5>
		ORDER BY S.PRODUCT_NAME ASC
	<cfelse>
		ORDER BY ISLEM_TARIHI DESC
	</cfif>	
</cfquery>
</cfif>	
	<cfset arama_yapilmali = 0 >
<cfelse>
	<cfset get_ship_fis.recordcount = 0 >
	<cfset arama_yapilmali = 1 >
</cfif>
<cfquery name="STORES" datasource="#DSN#">
	SELECT
		*
	FROM
		DEPARTMENT D
	WHERE 
		D.IS_STORE <> 2 AND
		D.DEPARTMENT_STATUS = 1
		<cfif isDefined("GET_OFFER_DETAIL.DELIVER_PLACE") and len(GET_OFFER_DETAIL.DELIVER_PLACE)>AND D.DEPARTMENT_ID = #GET_OFFER_DETAIL.DELIVER_PLACE#</cfif>
		<cfif isDefined("GET_ORDER_DETAIL.SHIP_ADDRESS") and len(GET_ORDER_DETAIL.SHIP_ADDRESS) and isnumeric(GET_ORDER_DETAIL.SHIP_ADDRESS)>AND D.DEPARTMENT_ID = #GET_ORDER_DETAIL.SHIP_ADDRESS#</cfif>
		AND  BRANCH_ID IN (SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID = #SESSION.EP.COMPANY_ID#)
	ORDER BY
		D.DEPARTMENT_HEAD
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_ship_fis.recordcount#">
<cfform name="frm_search" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
<cf_report_list_search title="#getLang('report',305)#">
	<cf_report_list_search_area>
		<div class="row">
			<div class="col col-12 col-xs-12">
				<div class="row formContent">
					<div class="row" type="row">
							<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
						<div class="col col-3 col-md-6 col-xs-12">
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no ='74.Kategori'></label>
								<div class="col col-9 col-xs-12">
									<select name="member_cat_type" id="member_cat_type" multiple style="height:150px;">
										<option value="1" <cfif attributes.member_cat_type eq 1>selected</cfif>><cf_get_lang_main no='627.Kurumsal Üye Kategorileri'></option>
										<cfoutput query="get_company_cat">
											<option value="1-#COMPANYCAT_ID#" <cfif attributes.member_cat_type is '1-#COMPANYCAT_ID#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#COMPANYCAT#</option>
										</cfoutput>
										<option value="2" <cfif attributes.member_cat_type eq 2>selected</cfif>><cf_get_lang_main no='628.Bireysel Üye Kategorileri'></option>
										<cfoutput query="get_consumer_cat">
											<option value="2-#CONSCAT_ID#" <cfif attributes.member_cat_type is '2-#CONSCAT_ID#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#CONSCAT#</option>
										</cfoutput>
									</select>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-6 col-xs-12">
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang no='487.Tüm Depolar'></label>
								<div class="col col-9 col-xs-12">
									<select name="department_id" id="department_id">
										<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
										<cfoutput query="stores"> 
											<option value="#department_id#" <cfif isDefined('attributes.department_id') and attributes.department_id eq stores.department_id>selected</cfif>>#department_head# </option>
										</cfoutput> 
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang no='1546.Sıralama Tipi'></label>
								<div class="col col-9 col-xs-12">
									<select name="oby" id="oby">
										<option selected value=""><cf_get_lang_main no='322.Seçiniz'></option>
										<option value="1" <cfif attributes.oby eq 1>selected</cfif>><cf_get_lang_main no='514.Azalan Tarih'></option>
										<option value="2" <cfif attributes.oby eq 2>selected</cfif>><cf_get_lang_main no='513.Artan Tarih'></option>
										<option value="3" <cfif attributes.oby eq 3>selected</cfif>><cf_get_lang_main no='1662.Artan No'></option>
										<option value="4" <cfif attributes.oby eq 4>selected</cfif>><cf_get_lang_main no='1661.Azalan No'></option>
										<option value="5" <cfif attributes.oby eq 5>selected</cfif>><cf_get_lang_main no='809.Ürün Adı'></option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no ='2614.Fatura Hareketleri'></label>
								<div class="col col-9 col-xs-12">
									<select name="invoice_action" id="invoice_action">
										<option selected value=""><cf_get_lang_main no='322.Seçiniz'></option>
										<option value="1" <cfif isDefined('attributes.invoice_action') and attributes.invoice_action eq 1>selected</cfif>><cf_get_lang no='495.Faturalanmış'></option>
										<option value="2" <cfif isDefined('attributes.invoice_action') and attributes.invoice_action eq 2>selected</cfif>><cf_get_lang no='496.Faturalanmamış'></option>
									</select> 
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='1548.Rapor Tipi'></label>
								<div class="col col-9 col-xs-12">
									<select name="report_type" id="report_type" style="width:150px;">
										<option selected value=""><cf_get_lang_main no='322.Seçiniz'></option>
										<option value="1"<cfif isDefined('attributes.report_type') and attributes.report_type eq 1>selected</cfif>><cf_get_lang no='332.Ürün Bazında'></option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='1633.İrsaliye Tipi'></label>
								<div class="col col-9 col-xs-12">
									<select name="cat" id="cat" style="width:150px;">
										<option selected value=""><cf_get_lang_main no='322.Seçiniz'></option>
										<option value="78" <cfif attributes.cat eq 78>selected</cfif>><cf_get_lang_main no='1787.Alım İade İrsaliyesi'></option>
										<option value="140" <cfif attributes.cat eq 140>selected</cfif>><cf_get_lang no='466.Servis Giriş'></option>
										<option value="141" <cfif attributes.cat eq 141>selected</cfif>><cf_get_lang no='467.Servis Çıkış'></option> 
										<option value="82" <cfif attributes.cat eq 82>selected</cfif>><cf_get_lang_main no='1792.Demirbaş Alım İrsaliyesi'></option>
										<option value="83" <cfif attributes.cat eq 83>selected</cfif>><cf_get_lang_main no='1793.Demirbaş Satış İrsaliyesi'></option>
										<option value="81" <cfif attributes.cat eq 81>selected</cfif>><cf_get_lang no='471.Depolararası Sevk İrsaliyesi'></option>
										<option value="761" <cfif attributes.cat eq 761>selected</cfif>><cf_get_lang_main no='1785.Hal İrsaliyesi'></option>
										<option value="76" <cfif attributes.cat eq 76>selected</cfif>><cf_get_lang_main no='1784.Mal Alım İrsaliyesi'></option>
										<option value="80" <cfif attributes.cat eq 80>selected</cfif>><cf_get_lang no='474.Müstahsil Makbuz'></option> 
										<option value="84" <cfif attributes.cat eq 84>selected</cfif>><cf_get_lang no='475.Gider Pusulası(Mal)İrsaliyesi'></option> 
										<option value="77" <cfif attributes.cat eq 77>selected</cfif>><cf_get_lang no='476.Konsinye Giriş'></option>
										<option value="79" <cfif attributes.cat eq 79>selected</cfif>><cf_get_lang no='477.Konsinye Giriş İade'></option>
										<option value="72" <cfif attributes.cat eq 72>selected</cfif>><cf_get_lang_main no='1341.Konsinye Çıkış İrsaliyesi'></option>
										<option value="75" <cfif attributes.cat eq 75>selected</cfif>><cf_get_lang_main no='1343.Konsinye Çıkış İade İrsaliyesi'></option>
										<option value="70" <cfif attributes.cat eq 70>selected</cfif>><cf_get_lang no='480.Parekande Satış İrsaliyesi'></option>
										<option value="73" <cfif attributes.cat eq 73>selected</cfif>><cf_get_lang no='481.Parekande Satış İade İrsaliyesi'></option>
										<option value="71" <cfif attributes.cat eq 71>selected</cfif>><cf_get_lang_main no='1340.Toptan Satış İrsaliyesi'></option>
										<option value="74" <cfif attributes.cat eq 74>selected</cfif>><cf_get_lang_main no='1783.Toptan Satış İade İrsaliyesi'></option>
										<option value="85" <cfif attributes.cat eq 85>selected</cfif>><cf_get_lang no='485.Üreticiye Çıkış İrsaliyesi'></option>
										<option value="86" <cfif attributes.cat eq 86>selected</cfif>><cf_get_lang no='486.Üreticiden Giriş İrsaliyesi'></option>
									</select>
								</div>
							</div>
						</div>						
						<div class="col col-3 col-md-6 col-xs-12">
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='468.Belge No'></label>
								<div class="col col-9 col-xs-12">
            						<cfinput type="text" name="belge_no" style="width:150px;" value="#attributes.belge_no#">
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='107.Cari Hesap'></label>
								<div class="col col-9 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">				
										<input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
										<input type="text" name="company" id="company" style="width:150px;" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'0\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','250');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_consumer=frm_search.consumer_id&field_comp_name=frm_search.company&field_comp_id=frm_search.company_id&select_list=2,3&keyword='+encodeURIComponent(document.frm_search.company.value),'list');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='245.Ürün'></label>
								<div class="col col-9 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="stock_id" id="stock_id" <cfif len("attributes.stock_id") and len(attributes.product_name)>value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
										<input type="text" name="product_name" id="product_name" style="width:150px;" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_ID','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','200');" autocomplete="off" value="<cfif len(attributes.stock_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" passthrough="readonly=yes" >
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=frm_search.stock_id&field_name=frm_search.product_name&keyword='+encodeURIComponent(document.frm_search.product_name.value),'list');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='467.İşlem Tarihi'></label>
								<div class="col col-9 col-xs-12">
									<div class="input-group">										 
										<cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
										<cfinput type="text" name="date1" value="#dateformat(attributes.date1,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" required="yes" style="width:65px;">
										<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
										<span class="input-group-addon no-bg"></span>
										<cfinput type="text" name="date2" value="#dateformat(attributes.date2,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" required="yes" style="width:65px;">
										<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="row ReportContentBorder">
					<div class="ReportContentFooter">
					 <label><cf_get_lang_main no='446.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
						<cfelse>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
						</cfif>
						<cf_wrk_report_search_button search_function='control()' button_type='1' is_excel="1">
					</div>
				</div>
			</div>
		</div>
	</cf_report_list_search_area>
</cf_report_list_search>
</cfform>


<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset filename="ship_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-8">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="content-type" content="text/plain; charset=utf-8">
</cfif>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
			<cfset attributes.startrow=1>
			<cfset attributes.maxrows="#get_ship_fis.recordcount#">
		</cfif>
<cf_report_list>				
	<thead>
	<tr>
		<cfif isdefined("attributes.report_type") and attributes.report_type eq 1>
			<th width="100"><cf_get_lang_main no='74.Kategori'></th>
			<th width="100"><cf_get_lang_main no='1388.Ürün Kodu'></th>
			<th width="100"><cf_get_lang_main no='245.Ürün'></th>
			<th width="65"><cf_get_lang_main no='223.Miktar'></th>
		<cfelse>
			<th width="60"><cf_get_lang_main no='330.Tarih'></th>
			<th width="70"><cf_get_lang_main no='726.İrsaliye No'></th>
			<th width="100"><cf_get_lang_main no='1166.Belge Türü'></th>
			<th><cf_get_lang_main no='107.Cari Hesap'></th>
			<th><cf_get_lang_main no='74.Kategori'></th>
			<th><cf_get_lang_main no='106.Stok Kodu'></th>
			<th><cf_get_lang_main no='809.Ürün Adı'></th>
			<th width="100"><cf_get_lang no='509.Depo Giriş'></th>
			<th width="100"><cf_get_lang no='510.Depo Çıkış'></th>
			<th><cf_get_lang_main no ='223.Miktar'></th>
			<th><cf_get_lang_main no='1621.İade'></th>
			<cfif attributes.invoice_action neq 2><th width="60"><cf_get_lang no='514.Faturalanan Miktar'></th></cfif>
			<th><cf_get_lang_main no='1032.Kalan'></th> 
			<cfif attributes.invoice_action neq 2><th><cf_get_lang_main no='721.Fatura No'></th></cfif>
		</cfif>
	</tr>
    </thead>
	<cfif get_ship_fis.recordcount>
    	
		<cfif isdefined("attributes.report_type") and attributes.report_type eq 1>
        	<tbody>
			<cfoutput query="get_ship_fis" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#product_cat#</td>
					<td>#product_code#</td>
					<td>#product_name#</td>
					<td>#TLFormat(product_stock)#&nbsp;#birim#</td>
				</tr>
			</cfoutput>
            </tbody>
		<cfelse>
			<cfscript>
				employee_id_list='';
				company_id_list='';
				consumer_id_list='';
				deliver_emp_list='';
				dept_id_list='';
				ship_list='';
				invoice_number_list = '';
				toplam_miktar = 0;
				toplam_faturalanan_miktar = 0;
				iade_toplam = 0;
				kalan = 0;
				toplam_kalan = 0;
			</cfscript>
			<cfoutput query="get_ship_fis" startrow="#attributes.startrow#" maxrows="#attributes.maxrowS#">
				<cfif len(get_ship_fis.EMPLOYEE_ID) and (get_ship_fis.EMPLOYEE_ID neq 0) and not listfind(employee_id_list,get_ship_fis.EMPLOYEE_ID)>
					<cfset employee_id_list=listappend(employee_id_list,get_ship_fis.EMPLOYEE_ID)>
				</cfif>
				<cfif len(COMPANY_ID) and (COMPANY_ID neq 0) and not listfind(company_id_list,COMPANY_ID)>
					<cfset company_id_list=listappend(company_id_list,COMPANY_ID)>
				<cfelseif len(CONSUMER_ID) and (CONSUMER_ID neq 0) and not listfind(consumer_id_list,CONSUMER_ID)>
					<cfset consumer_id_list=listappend(consumer_id_list,CONSUMER_ID)>
				</cfif>
				<cfif len(DEPARTMENT_ID) and (DEPARTMENT_ID neq 0) or len(DEPARTMENT_ID_2)>
					<cfif not listfind(dept_id_list,DEPARTMENT_ID)>
						<cfset dept_id_list=listappend(dept_id_list,DEPARTMENT_ID)>
					</cfif>
					<cfif not listfind(dept_id_list,DEPARTMENT_ID_2)>
						<cfset dept_id_list=listappend(dept_id_list,DEPARTMENT_ID_2)>
					</cfif>
				</cfif>
				<cfset ship_list = listappend(ship_list,ship_id,',')>
			</cfoutput>
			<cfquery name="GET_ALL_INVOICE_SHIPS" datasource="#dsn2#">
				SELECT INVOICE_NUMBER,SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID = #session.ep.period_id# AND SHIP_ID IN (#ship_list#)
				<cfif isdefined('new_perido_dsn') and len(new_perido_dsn)>
					UNION ALL SELECT INVOICE_NUMBER,SHIP_ID FROM #new_perido_dsn#.INVOICE_SHIPS WHERE SHIP_PERIOD_ID = #session.ep.period_id# AND SHIP_ID IN (#ship_list#)
				</cfif>
			</cfquery>
			<cfif listlen(employee_id_list)>
				<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
				<cfquery name="get_employee_detail" datasource="#dsn#">
					SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
				</cfquery>
			</cfif>
			<cfif listlen(company_id_list)>
				<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
				<cfquery name="get_company_detail" datasource="#dsn#">
					SELECT 
						COMPANY.COMPANY_ID,
						COMPANY.NICKNAME,
						COMPANY.FULLNAME ,
						COMPANY_CAT.COMPANYCAT
					FROM 
						COMPANY,
						COMPANY_CAT
					WHERE 
						COMPANY.COMPANYCAT_ID = COMPANY_CAT.COMPANYCAT_ID AND
						COMPANY_ID IN (#company_id_list#) 
					ORDER BY 
						COMPANY.COMPANY_ID
				</cfquery>
			</cfif>
			<cfif listlen(consumer_id_list)>
				<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
				<cfquery name="get_consumer_detail" datasource="#dsn#">
					SELECT 
						CONSUMER.CONSUMER_ID,
						CONSUMER.CONSUMER_NAME,
						CONSUMER.CONSUMER_SURNAME,
						CONSUMER_CAT.CONSCAT
					FROM 
						CONSUMER,
						CONSUMER_CAT
					WHERE 
						CONSUMER.CONSUMER_CAT_ID = CONSUMER_CAT.CONSCAT_ID AND 
						CONSUMER_ID IN (#consumer_id_list#) 
					ORDER BY 
						CONSUMER.CONSUMER_ID
				</cfquery>
			</cfif>
			<cfif listlen(deliver_emp_list)>
				<cfset deliver_emp_list=listsort(deliver_emp_list,"numeric","ASC",",")>
				<cfquery name="get_deliver_emp_detail" datasource="#dsn#" >
					SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#deliver_emp_list#) ORDER BY EMPLOYEE_ID
				</cfquery> 
			</cfif>
			<cfif listlen(dept_id_list)>
				<cfset dept_id_list=listsort(dept_id_list,"numeric","ASC",",")>
				<cfquery name="get_dept_detail" datasource="#dsn#" >
					SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#dept_id_list#) ORDER BY DEPARTMENT_ID
				</cfquery> 
			</cfif>
			<cfquery name="GET_ALL_INVOICE_ROW" datasource="#dsn2#">
				SELECT 
					AMOUNT,
					STOCK_ID,
					SHIP_ID
				FROM 
					INVOICE_ROW IROW
				WHERE 
					SHIP_ID IN (#ship_list#) AND
					SHIP_PERIOD_ID = #session.ep.period_id#
				<cfif isdefined('new_perido_dsn') and len(new_perido_dsn)>
				UNION ALL
				SELECT 
					AMOUNT,
					STOCK_ID,
					SHIP_ID
				FROM 
					#new_perido_dsn#.INVOICE_ROW IROW
				WHERE 
					SHIP_ID IN (#ship_list#) AND
					SHIP_PERIOD_ID = #session.ep.period_id#
				</cfif>
			</cfquery>	
            <tbody>	 
			<cfoutput query="get_ship_fis" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfquery name="get_invoice_row" dbtype="query">
					SELECT SUM(AMOUNT) AS TOTAL_AMOUNT FROM GET_ALL_INVOICE_ROW WHERE SHIP_ID = #get_ship_fis.ship_id# AND STOCK_ID = #get_ship_fis.stock_id#
				</cfquery>
				<tr>
					<td>#dateformat(ISLEM_TARIHI,dateformat_style)#</td>
					<td>
						<cfif purchase_sales eq 0>
							<cfswitch expression="#islem_tipi#">
								<cfcase value="761">
									<cfset url_param="#request.self#?fuseaction=stock.upd_marketplace_ship&ship_id=">
								</cfcase>
								<cfcase value="82">
									<cfset url_param = "#request.self#?fuseaction=invent.upd_purchase_invent&ship_id=">
								</cfcase>
								<cfdefaultcase>
									<cfset url_param = "#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=">
								</cfdefaultcase>
							</cfswitch>
						<cfelseif purchase_sales eq 1>
							<cfswitch expression="#islem_tipi#">
								<cfcase value="81">
									<cfset url_param = "#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=">
								</cfcase>
								<cfcase value="83">
									<cfset url_param = "#request.self#?fuseaction=invent.upd_invent_sale&ship_id=">
								</cfcase>
								<cfdefaultcase>
									<cfset url_param = "#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=">
								</cfdefaultcase>
							</cfswitch>				
						<cfelse>
							<cfswitch expression="#islem_tipi#">
								<cfcase value="114">
									<cfset url_param="#request.self#?fuseaction=stock.form_add_open_fis&event=upd&upd_id=">
								</cfcase>
								<cfcase value="118">
									<cfset url_param="#request.self#?fuseaction=invent.upd_invent_stock_fis&fis_id=">
								</cfcase>
								<cfcase value="1182">
									<cfset url_param="#request.self#?fuseaction=invent.upd_invent_stock_fis_return&fis_id=">
								</cfcase>
								<cfcase value="116">
									<cfif stock_exchange_type eq 0>
										<cfset url_param="#request.self#?fuseaction=stock.form_upd_stock_exchange&exchange_id=">
									<cfelse>
										<cfset url_param="#request.self#?fuseaction=stock.form_upd_spec_exchange&exchange_id=">
									</cfif>
								</cfcase>
								<cfdefaultcase>
									<cfset url_param="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=">
								</cfdefaultcase>
							</cfswitch>
						</cfif>
						<a href="#url_param##SHIP_ID#"class="tableyazi">#BELGE_NO#</a>
					</td>
					<td>#get_process_name(ISLEM_TIPI)#</td>
					<td>
						<cfif len(get_ship_fis.EMPLOYEE_ID) and get_ship_fis.EMPLOYEE_ID neq 0>
							#get_employee_detail.EMPLOYEE_NAME[listfind(employee_id_list,get_ship_fis.EMPLOYEE_ID,',')]#&nbsp;#get_employee_detail.EMPLOYEE_SURNAME[listfind(employee_id_list,get_ship_fis.EMPLOYEE_ID,',')]#
						<cfelse>
							<cfif len(COMPANY_ID)>
								#get_company_detail.FULLNAME[listfind(company_id_list,COMPANY_ID,',')]#
							<cfelseif len(CONSUMER_ID)>
								#get_consumer_detail.CONSUMER_NAME[listfind(consumer_id_list,CONSUMER_ID,',')]#
								#get_consumer_detail.CONSUMER_SURNAME[listfind(consumer_id_list,CONSUMER_ID,',')]#
							<cfelseif len(DELIVER_EMP) and isnumeric(DELIVER_EMP)>
								#get_deliver_emp_detail.EMPLOYEE_NAME[listfind(deliver_emp_list,DELIVER_EMP,',')]#&nbsp;
								#get_deliver_emp_detail.EMPLOYEE_SURNAME[listfind(deliver_emp_list,DELIVER_EMP,',')]#
							</cfif>
						</cfif>
					</td>
					<td><cfif len(company_id)>#get_company_detail.COMPANYCAT[listfind(company_id_list,COMPANY_ID,',')]#<cfelseif len(consumer_id)>#get_consumer_detail.CONSCAT[listfind(consumer_id_list,CONSUMER_ID,',')]#</cfif></td>
					<td>#stock_code#</td>
					<td>#product_name#</td>
					<td><cfif len(DEPARTMENT_ID) and (DEPARTMENT_ID neq 0)>#get_dept_detail.DEPARTMENT_HEAD[listfind(dept_id_list,DEPARTMENT_ID,',')]#</cfif></td>
					<td><cfif len(DEPARTMENT_ID_2) and (DEPARTMENT_ID_2 neq 0)>#get_dept_detail.DEPARTMENT_HEAD[listfind(dept_id_list,DEPARTMENT_ID_2,',')]#</cfif></td>
					<td><cfif not listfind("73,74,78,75,79",get_ship_fis.islem_tipi)><cfset miktar = amount><cfelse><cfset miktar = 0></cfif>#miktar#</td>
					<cfset toplam_miktar = toplam_miktar + miktar>
					<td><cfif listfind("73,74,78,75,79",get_ship_fis.islem_tipi)><cfset iade_miktar = amount><cfelse><cfset iade_miktar = 0></cfif>#iade_miktar#</td>
					<cfset iade_toplam = iade_toplam + iade_miktar>
					<cfif attributes.invoice_action neq 2>
						<cfif get_invoice_row.total_amount gt 0>
							<cfset faturalanan = get_invoice_row.total_amount>
							<cfset kalan = miktar - (iade_miktar + faturalanan)>
						<cfelse>
							<cfset faturalanan = 0>
							<cfset kalan = miktar - iade_miktar>
						</cfif>
						<td>#faturalanan#</td>
					<cfelse>
						<cfset faturalanan = 0>
						<cfset kalan = miktar - iade_miktar>
					</cfif>
					<td>#kalan#</td>
					<cfset toplam_faturalanan_miktar = toplam_faturalanan_miktar + faturalanan>
					<cfset toplam_kalan = toplam_kalan + kalan>
					<cfif attributes.invoice_action neq 2>
						<td>
							<cfquery name="get_invoice_ship" dbtype="query">
								SELECT INVOICE_NUMBER FROM GET_ALL_INVOICE_SHIPS WHERE SHIP_ID = #get_ship_fis.ship_id#
							</cfquery>
							<cfset invoice_number_list = valuelist(get_invoice_ship.invoice_number,',')>
							<cfif len(invoice_number_list)>#invoice_number_list#</cfif>
						</td>
					</cfif>
				</tr>
			</cfoutput>
            </tbody>
            <tfoot>
			<tr>
				<td colspan="9" align="left" class="txtbold" height="25"><cf_get_lang_main no='80.Toplam'></td>
				<td><cfoutput>#TLFormat(toplam_miktar)#</cfoutput></td>
				<cfif attributes.invoice_action neq 2><td><cfoutput>#TLFormat(iade_toplam)#</cfoutput></td></cfif>
				<td><cfoutput>#TLFormat(toplam_faturalanan_miktar)#</cfoutput></td>
				<td><cfoutput>#TLFormat(toplam_kalan)#</cfoutput></td>
				<cfif attributes.invoice_action neq 2><td></td></cfif>
			</tr>
            </tfoot>
		</cfif>
	<cfelse>
		<tbody>
        <tr>
			<td colspan="14" height="20"><cfif arama_yapilmali eq 1 ><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'> !</cfif></td>
		</tr>
        </tbody>
	</cfif>

</cf_report_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset adres = attributes.fuseaction >
	<cfif isDefined('attributes.cat') and len(attributes.cat)>
	  <cfset adres = adres & "&cat=" & attributes.cat >
	</cfif>
	<cfif isdefined("attributes.belge_no") and len(attributes.belge_no)>
	  <cfset adres = adres & "&belge_no=" & attributes.belge_no >
	</cfif>
	<cfif isDefined('attributes.oby') and len(attributes.oby) >
	  <cfset adres = adres & '&oby=' & attributes.oby >
	</cfif>
	<cfif isDefined('attributes.invoice_action') and len(attributes.invoice_action)>
		<cfset adres = adres &'&invoice_action=' & attributes.invoice_action >
	</cfif> 
	<cfif isDefined('attributes.department_id') and len(attributes.department_id) >
	  <cfset adres = adres & '&department_id=' & attributes.department_id >
	</cfif>
	<cfif isDefined('attributes.consumer_id') and len(attributes.consumer_id) >
	  <cfset adres = adres & '&consumer_id=' & attributes.consumer_id >
	</cfif>
	<cfif isDefined('attributes.company_id') and len(attributes.company_id) >
	  <cfset adres = adres & '&company_id=' & attributes.company_id >
	</cfif>
	<cfif isDefined('attributes.company') and len(attributes.company) >
	  <cfset adres = adres & '&company=' & attributes.company >
	</cfif>
	<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
		<cfset adres = "#adres#&stock_id=#attributes.stock_id#" >
	</cfif>
	<cfif isdefined("attributes.product_name") and len(attributes.product_name)>
		<cfset adres = "#adres#&product_name=#attributes.product_name#" >
	</cfif>
	<cfif isdate(attributes.date1)>
		<cfset adres = "#adres#&date1=#dateformat(attributes.date1,dateformat_style)#">
	</cfif>
	<cfif isdate(attributes.date2)>
		<cfset adres = "#adres#&date2=#dateformat(attributes.date2,dateformat_style)#">
	</cfif>
	<cfif len(attributes.member_cat_type)>
		<cfset adres = adres&'&member_cat_type=#attributes.member_cat_type#'>
	</cfif>
	<cfif isdefined("attributes.report_type") and len(attributes.report_type)>
		<cfset adres = "#adres#&report_type=#attributes.report_type#" >
	</cfif>
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
		<tr>
			<td>
				<cf_pages page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="#adres#&is_form_submitted=1"> 
			</td>
			<!-- sil --><td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='80.toplam'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
</cfif>
<br/>
<script type="text/javascript">
	document.getElementById('belge_no').focus();

	function control(){
		if(document.frm_search.is_excel.checked==false)
			{
				document.frm_search.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.ship_report"
				return true;
			}
			else
				document.frm_search.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_ship_report</cfoutput>"
	}
</script>
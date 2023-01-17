<cfif isdefined('attributes.stock_code') and isdefined('attributes.submit_type') and len(attributes.submit_type)>
<cfquery name="GET_VARIATION_ALL" datasource="#DSN1#">
	SELECT PROPERTY_DETAIL_ID, PROPERTY_DETAIL, PRPT_ID FROM PRODUCT_PROPERTY_DETAIL
</cfquery>
<cfquery name="GET_PROPERTY_ALL" datasource="#DSN1#">
	SELECT 
		PROPERTY,
		PROPERTY_ID
	FROM 
		PRODUCT_PROPERTY
</cfquery>
<!--- uyenin fiyat listesini bulmak icin--->
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfquery name="GET_PRICE_CAT_CREDIT" datasource="#dsn#">
		SELECT
			PRICE_CAT
		FROM
			COMPANY_CREDIT
		WHERE
			COMPANY_ID = #attributes.company_id#  AND
			OUR_COMPANY_ID = #session.ep.company_id#
	</cfquery>
	<cfif GET_PRICE_CAT_CREDIT.RECORDCOUNT and len(GET_PRICE_CAT_CREDIT.PRICE_CAT)>
		<cfset attributes.price_catid=GET_PRICE_CAT_CREDIT.PRICE_CAT>
	<cfelse>
		<cfquery name="GET_COMP_CAT" datasource="#dsn#">
			SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
		</cfquery>
		<cfquery name="GET_PRICE_CAT_COMP" datasource="#dsn3#">
			SELECT 
				PRICE_CATID
			FROM
				PRICE_CAT
			WHERE
				COMPANY_CAT LIKE '%,#GET_COMP_CAT.COMPANYCAT_ID#,%'
		</cfquery>
		<cfset attributes.price_catid=GET_PRICE_CAT_COMP.PRICE_CATID>
	</cfif>
</cfif>
<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfquery name="GET_COMP_CAT" datasource="#DSN#">
		SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = #attributes.consumer_id#
	</cfquery>
	<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
		SELECT PRICE_CATID FROM PRICE_CAT WHERE CONSUMER_CAT LIKE '%,#get_comp_cat.consumer_cat_id#,%'
	</cfquery>
	<cfset attributes.price_catid=get_price_cat.PRICE_CATID>
</cfif>
<!--- //uyenin fiyat listesini bulmak icin--->
	<cfquery name="GET_PRODUCT" datasource="#DSN3#">
		SELECT
			S.STOCK_ID,
			P.PRODUCT_ID,
			P.PRODUCT_CODE,
			P.PRODUCT_CODE_2,
			P.MANUFACT_CODE,
			P.PRODUCT_NAME,
			P.BARCOD,
			<cfif isdefined('attributes.is_sale_product') and attributes.is_sale_product eq 0>
				P.TAX_PURCHASE AS TAX,
			<cfelse>
				P.TAX AS TAX,
			</cfif>
			P.BRAND_ID,
			P.RECORD_DATE,
			P.UPDATE_DATE,
			P.PROD_COMPETITIVE,
			P.MAX_MARGIN,
			P.MIN_MARGIN,
			P.IS_PRODUCTION,
		<cfif (isDefined("attributes.price_catid") and (attributes.price_catid eq -1)) or (not isdefined("attributes.price_catid")) or (isDefined("attributes.price_catid") and (attributes.price_catid eq -2))>
			PS.PRICE,
			PS.PRICE_KDV,
			PS.IS_KDV,
			PS.MONEY,
		<cfelseif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
			PR.MONEY,
			PR.PRICE,
			PR.PRICE_KDV,
			PR.IS_KDV,
		</cfif>
			PU.ADD_UNIT,
			PU.MAIN_UNIT
		FROM 
			PRODUCT P, 
		<cfif (isDefined("attributes.price_catid") and (attributes.price_catid eq -1)) or (not isdefined("attributes.price_catid")) or (isDefined("attributes.price_catid") and (attributes.price_catid eq -2))>
			PRICE_STANDART PS,
		<cfelseif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
			PRICE PR,
		</cfif>
			PRODUCT_UNIT PU,
			STOCKS S
		WHERE
			P.PRODUCT_ID = PU.PRODUCT_ID AND
			S.PRODUCT_ID=P.PRODUCT_ID AND
		<cfif (isDefined("attributes.price_catid") and (attributes.price_catid eq -1)) or (not isdefined("attributes.price_catid")) or (isDefined("attributes.price_catid") and (attributes.price_catid eq -2))>
			PS.PURCHASESALES = <cfif isDefined("attributes.price_catid") and (attributes.price_catid eq -1)>0<cfelse>1</cfif> AND
			PS.PRICESTANDART_STATUS = 1 AND 			
			P.PRODUCT_ID = PS.PRODUCT_ID AND				
			PS.UNIT_ID = PU.PRODUCT_UNIT_ID
		<cfelseif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
			PR.PRICE_CATID = #attributes.PRICE_CATID# AND
			ISNULL(PR.STOCK_ID,0)=0 AND 
			ISNULL(PR.SPECT_VAR_ID,0)=0 AND 
			PR.STARTDATE <= #now()# AND
			(PR.FINISHDATE >= #now()# OR PR.FINISHDATE IS NULL) AND
			P.PRODUCT_ID = PR.PRODUCT_ID AND
			PR.UNIT = PU.PRODUCT_UNIT_ID
		</cfif>
			AND S.STOCK_CODE LIKE '#attributes.stock_code#'
	</cfquery>
	<cfif GET_PRODUCT.RECORDCOUNT eq 0>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='34072.Ürün Bulunamadı (Ürün fiyat listesine aktif bir fiyat olmayabilir)'>");
			history.go(-2);
		</script>
	<cfelse>
		<cfquery name="GET_PROPERTY" datasource="#DSN1#">
			SELECT 
				PRODUCT_DT_PROPERTIES.*,
				PRODUCT_PROPERTY.PROPERTY,
				PRODUCT_PROPERTY.PROPERTY_ID
			FROM 
				PRODUCT_DT_PROPERTIES,
				PRODUCT_PROPERTY
			WHERE 
				PRODUCT_DT_PROPERTIES.PRODUCT_ID = #get_product.product_id# AND
				PRODUCT_DT_PROPERTIES.PROPERTY_ID = PRODUCT_PROPERTY.PROPERTY_ID
		</cfquery>
		<cfquery name="GET_MONEY" datasource="#dsn#">
			SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
		</cfquery>
	</cfif>
</cfif>
<table cellspacing="1" cellpadding="2" border="0" height="100%" width="100%" class="color-border">
<cfform name="add_spect" action="" method="post">
<input type="hidden" name="submit_type" id="submit_type" value="">
	<tr class="color-list">
		<td height="35" class="headbold" colspan="2"><cf_get_lang dictionary_id ='34073.Özelliklere Göre Ürünler'></td>
	</tr>
	<tr class="color-row" valign="top">
		<td valign="top">
			<table>
				<tr>
					<td><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
					<td><input type="text" name="stock_code" id="stock_code" value="<cfif isdefined('attributes.stock_code')><cfoutput>#attributes.stock_code#</cfoutput></cfif>" style="width:150px;"></td>
					<td><input type="image" name="gonder_1" id="gonder_1" src="/images/plus_ques.gif" onClick="return search_prod()" alt="Ara"></td>
					<td><cf_get_lang dictionary_id='57647.Spec'></td>
					<td><input type="text" name="spect_name" id="spect_name" value="" style="width:150px;"></td>
				</tr> 
			</table>
			<table id="table">
			<cfif isdefined('get_property')><!--- arama yapıldı --->
				<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#GET_PRODUCT.PRODUCT_ID#</cfoutput>">
				<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#GET_PRODUCT.STOCK_ID#</cfoutput>">
				<input type="hidden" name="record_num" id="record_num" value="<cfif isdefined('attributes.record_num')><cfoutput>#attributes.record_num#</cfoutput><cfelse><cfoutput>#get_property.recordcount#</cfoutput></cfif>">
				<tr class="color-list" height="20">
					<td class="txtboldblue" width="125"><cf_get_lang dictionary_id='57632.Özellik'></td>
					<td class="txtboldblue" width="150"><cf_get_lang dictionary_id='33615.Varyasyon'></td>
					<td class="txtboldblue" width="75"><cf_get_lang dictionary_id='33329.Değer Aralığı'></td>
					<td class="txtboldblue" width="55"><cf_get_lang dictionary_id='29443.Tolerans'></td>
					<td class="txtboldblue"><cf_get_lang dictionary_id ='34074.Kriter'></td>
					<td width="15"><input type="button" class="eklebuton" title="" onClick="add_row();"></td>
				</tr>
				
				<cfoutput query="get_property">
				<cfquery name="GET_VARIATION" dbtype="query">
					SELECT PROPERTY_DETAIL_ID, PROPERTY_DETAIL FROM GET_VARIATION_ALL WHERE PRPT_ID = #property_id#
				</cfquery>
				<cfif (isdefined('form.submit_type') and form.submit_type neq 2) and isdefined('attributes.main_spec_id') and len(attributes.main_spec_id)><!--- eger iscilikli specli popuptan acildi ise main_spec_id gelebilir o durumda o specde kayitli degerler gelsin --->
					<cfquery name="GET_MAIN_SPEC_#property_id#" datasource="#dsn3#">
						SELECT 
							AMOUNT,
							PROPERTY_ID,
							VARIATION_ID,
							TOTAL_MIN,
							TOTAL_MAX,
							PRODUCT_NAME,
							IS_PROPERTY,
							TOLERANCE 
						FROM 
							SPECT_MAIN_ROW 
						WHERE 
							SPECT_MAIN_ID=#attributes.main_spec_id# AND
							PROPERTY_ID=#property_id#
					</cfquery>
					<cfset 'attributes.total_min#currentrow#'=evaluate('GET_MAIN_SPEC_#property_id#.TOTAL_MIN')>
					<cfset 'attributes.total_max#currentrow#'=evaluate('GET_MAIN_SPEC_#property_id#.TOTAL_MAX')>
					<cfset 'attributes.tolerans#currentrow#'=evaluate('GET_MAIN_SPEC_#property_id#.TOLERANCE')>
				</cfif>
				<tr>
					<td>
						<b>#property#</b>
						<cfif isdefined('attributes.property_id#currentrow#')><!--- form submit oldu ise submit edilmeden onceki degerler gelmesi icin --->
							<input type="hidden" name="property_id#currentrow#" id="property_id#currentrow#" value="#evaluate('attributes.property_id#currentrow#')#">
                            <input type="hidden" name="property_name#currentrow#" id="property_name#currentrow#" value="#evaluate('attributes.property_name#currentrow#')#">
						<cfelseif isdefined('GET_MAIN_SPEC_#property_id#')><!--- specdeki degerleri alması icin --->
							<input type="hidden" name="property_id#currentrow#" id="property_id#currentrow#" value="#evaluate('GET_MAIN_SPEC_#property_id#.PROPERTY_ID')#">
                            <input type="hidden" name="property_name#currentrow#" id="property_name#currentrow#" value="#evaluate('attributes.property_name#currentrow#')#">
						<cfelse>
							<input type="hidden" name="property_id#currentrow#" id="property_id#currentrow#" value="#property_id#">
                            <input type="hidden" name="property_name#currentrow#" id="property_name#currentrow#" value="#property#">
						</cfif>
					</td>
					<td>
						<select name="variation_id#currentrow#" id="variation_id#currentrow#" style="width:150px;">
						<cfif isdefined('attributes.variation_id#currentrow#')>
							<cfset var_value = evaluate('attributes.variation_id#currentrow#')>
						<cfelseif isdefined('GET_MAIN_SPEC') and len(GET_MAIN_SPEC.VARIATION_ID)>
							<cfset var_value = GET_MAIN_SPEC.VARIATION_ID>
						<cfelse>
							<cfset var_value = get_property.variation_id>
						</cfif>
							<option value=""><cf_get_lang dictionary_id ='33615.Varyasyon'></option>
							<cfloop query="get_variation">	
							<option value="#PROPERTY_DETAIL_ID#" <cfif var_value eq PROPERTY_DETAIL_ID>selected</cfif>>#PROPERTY_DETAIL#</option>
							</cfloop>
						</select>
					</td>
					<td nowrap="nowrap">
					<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='33933.Sayı Giriniz'></cfsavecontent>
					<cfif isdefined('attributes.total_min#currentrow#')>
						<cfinput type="text" name="total_min#currentrow#" value="#evaluate('attributes.total_min#currentrow#')#" validate="float" message="#alert#" style="width:35px">
					<cfelseif isdefined('GET_MAIN_SPEC_#property_id#')><!--- specdeki degerleri alması icin --->
						<cfinput type="text" name="total_min#currentrow#" value="#evaluate('GET_MAIN_SPEC_#property_id#.TOTAL_MIN')#" validate="float" message="#alert#" style="width:35px">
					<cfelse>
						<cfinput type="text" name="total_min#currentrow#" value="#TOTAL_MIN#" validate="float" message="Sayı Giriniz!" style="width:35px">
					</cfif>
					<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='33933.Sayı Giriniz'></cfsavecontent>
					<cfif isdefined('attributes.total_max#currentrow#')>
						<cfinput type="text" name="total_max#currentrow#" value="#evaluate('attributes.total_max#currentrow#')#" validate="float" message="#alert#" style="width:35px">
					<cfelseif isdefined('GET_MAIN_SPEC_#property_id#')><!--- specdeki degerleri alması icin --->
						<cfinput type="text" name="total_max#currentrow#" value="#evaluate('GET_MAIN_SPEC_#property_id#.TOTAL_MAX')#" validate="float" message="#alert#" style="width:35px">
					<cfelse>
						<cfinput type="text" name="total_max#currentrow#" value="#TOTAL_MAX#" validate="float" message="Sayı Giriniz!" style="width:35px">
					</cfif>
					</td>
					<td>
					<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='33933.Sayı Giriniz'></cfsavecontent>
					<cfif isdefined('attributes.tolerans#currentrow#')>
						<cfinput type="text" name="tolerans#currentrow#" value="#evaluate('attributes.tolerans#currentrow#')#" style="width:55px" validate="integer" message="#alert#">
					<cfelseif isdefined('GET_MAIN_SPEC_#property_id#')><!--- specdeki degerleri alması icin --->
						<cfinput type="text" name="tolerans#currentrow#" value="#evaluate('GET_MAIN_SPEC_#property_id#.TOLERANCE')#" style="width:55px" validate="integer" message="#alert#">
					<cfelse>
						<cfinput type="text" name="tolerans#currentrow#" value="" style="width:55px" validate="integer" message="#alert#">
					</cfif>
					</td>
					
					<td align="center"><input type="checkbox" name="input#currentrow#" id="input#currentrow#" value="1" <cfif isdefined('attributes.input#currentrow#') or isdefined('GET_MAIN_SPEC_#property_id#') and evaluate('GET_MAIN_SPEC_#property_id#.RECORDCOUNT')>checked</cfif>></td>
				</tr>
				</cfoutput>
				<cfif isdefined('attributes.record_num') and get_property.recordcount lt attributes.record_num>
					<cfloop from="#get_property.recordcount+1#" to="#attributes.record_num#" index="jj">
					<cfif isdefined('attributes.property_id#jj#') and len(evaluate('attributes.property_id#jj#')) and isdefined('attributes.input#jj#')>
						<tr>
							<td colspan="2">
							<cfset selected="#evaluate('attributes.property_id#jj#')#||#evaluate('attributes.property_name#jj#')#||#evaluate('attributes.variation_id#jj#')#">
							<select name="select_property<cfoutput>#jj#</cfoutput>" id="select_property<cfoutput>#jj#</cfoutput>" onChange="set_property_name(<cfoutput>#jj#</cfoutput>);" style="width:275px;">
								<option value=""><cf_get_lang dictionary_id ='57632.Özellik'> - <cf_get_lang dictionary_id ='33615.Varyasyon'></option>
								<cfoutput query="GET_PROPERTY_ALL">
									<cfquery name="GET_VARIATION" dbtype="query">
										SELECT PROPERTY_DETAIL_ID, PROPERTY_DETAIL FROM GET_VARIATION_ALL WHERE PRPT_ID = #PROPERTY_ID#
									</cfquery>
									<option value="#PROPERTY_ID#||#PROPERTY#||#GET_VARIATION.PROPERTY_DETAIL_ID#" >#PROPERTY#</option>
									<cfloop query="GET_VARIATION">
										<option value="#GET_PROPERTY_ALL.PROPERTY_ID#||#GET_PROPERTY_ALL.PROPERTY#||#PROPERTY_DETAIL_ID#" 
											<cfif '#GET_PROPERTY_ALL.PROPERTY_ID#||#GET_PROPERTY_ALL.PROPERTY#||#PROPERTY_DETAIL_ID#' eq selected>selected</cfif>>
												&nbsp;&nbsp;&nbsp;#PROPERTY_DETAIL#
										</option>
									</cfloop>
								</cfoutput>
							</select>
							<cfoutput>
								<input type="hidden" name="property_name#jj#" id="property_name#jj#" value="#evaluate('attributes.property_name#jj#')#">
								<input type="hidden" name="property_id#jj#" id="property_id#jj#" value="#evaluate('attributes.property_id#jj#')#">
								<input type="hidden" name="variation_id#jj#" id="variation_id#jj#" value="#evaluate('attributes.variation_id#jj#')#">
							</cfoutput>
							</td>
	
							<td nowrap="nowrap">
								<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='33933.Sayı Giriniz'></cfsavecontent>
								<cfinput type="text" name="total_min#jj#" value="#evaluate('attributes.total_min#jj#')#" validate="float" message="#alert#" style="width:35px">
								<cfinput type="text" name="total_max#jj#" value="#evaluate('attributes.total_max#jj#')#" validate="float" message="#alert#" style="width:35px">
							</td>
								<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='33933.Sayı Giriniz'></cfsavecontent>
							<td><cfinput type="text" name="tolerans#jj#" value="#evaluate('attributes.tolerans#jj#')#" style="width:55px" validate="integer" message="#alert#"></td>
							<td align="center"><input type="checkbox" name="input<cfoutput>#jj#</cfoutput>" id="input<cfoutput>#jj#</cfoutput>" value="1" checked></td>
						</tr>
					</cfif>
					</cfloop>
				</cfif>
			</table>
			<table width="100%">
			<tr>
				<td  style="text-align:right;">
					<input type="button" name="stock_search" id="stock_search" value="<cf_get_lang dictionary_id ='34075.Stok Araştır'>" onclick="return search_stock();">
					<cf_workcube_buttons is_upd='0' is_cancel='0' add_function='kontrol()'>
				</td>
			</tr>
			</table>
		</td>
		<td>
			<table>					
				<tr>
					<td><cf_get_lang dictionary_id='58084.Fiyat'></td>
					<td><!--- sistem para biriminde degilse fiyat url_den gelen para birimi ile sisteme para birimi cinsine ceviriyoruz --->
						<cfif GET_PRODUCT.MONEY neq session.ep.money>
							<cfset sistem_fiyat=get_product.price*evaluate('#GET_PRODUCT.MONEY#')>
						<cfelse>
							<cfset sistem_fiyat=get_product.price>
						</cfif>
						<input type="text" name="price" id="price" value="<cfoutput>#TLFormat(sistem_fiyat,4)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,4));" onBlur="hesapla();" style="width:75px;" class="moneybox"> <cfoutput>#session.ep.money#</cfoutput>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id ='34076.Döviz Fiyat'></td>
					<td nowrap>
						<cfset sistem_fiyat_2=sistem_fiyat/evaluate('#GET_PRODUCT.MONEY#')>
						<input type="text" name="other_price" id="other_price" value="<cfoutput>#TLFormat(sistem_fiyat_2,4)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,4));" onBlur="other_money_hesapla();" style="width:75px;" class="moneybox">
						<select name="other_money" id="other_money" onchange="other_money_hesapla();">
							<cfoutput query="GET_MONEY">
								<option value="#MONEY#,#evaluate('#MONEY#')#" <cfif GET_PRODUCT.MONEY eq MONEY>selected</cfif>>#MONEY#</option>
							</cfoutput>
						</select>
						<input type="hidden" name="money_record_num" id="money_record_num" value="<cfoutput>#GET_MONEY.RECORDCOUNT#</cfoutput>">
						<cfoutput query="GET_MONEY">
						<input type="hidden" name="MONEY#currentrow#" id="MONEY#currentrow#" value="#MONEY#,#evaluate('#MONEY#')#">
						</cfoutput>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id ='34077.İskonto Tutar'></td>
					<td><input type="text" name="discount" id="discount" value="<cfoutput>#TLFormat(0,2)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,2));" onblur="hesapla();" style="width:75px;" class="moneybox"></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id ='57641.İskonto'> %</td>
					<td><input type="text" name="discount_yuzde" id="discount_yuzde" value="<cfoutput>#TLFormat(0,2)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,2));" onBlur="hesapla();" style="width:50px;" class="moneybox"></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id ='34079.Net Fiyat'></td>
					<td><input type="text" name="net_price" id="net_price" value="<cfoutput>#TLFormat(sistem_fiyat,4)#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));" readonly style="width:75px;"></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id ='57635.Miktar'></td>
					<td><input type="text" name="amount" id="amount" value="<cfoutput>#TLFormat(1,3)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,3));" onBlur="hesapla();" class="moneybox"  style="width:75px;"></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id ='57492.Toplam'></td>
					<td><input type="text" name="total_price" id="total_price" value="<cfoutput>#TLFormat(sistem_fiyat,4)#</cfoutput>" style="width:75px;" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr  class="color-row" height="100%" valign="top">
				<td colspan="2">
				<cfif isdefined('attributes.record_num') and form.submit_type eq 2>
					<cfset st=0>
					<cfquery name="GET_SPECT" datasource="#dsn3#">
						SELECT 
							<!--- COUNT(SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID), --->
							SPECT_MAIN.SPECT_MAIN_ID,
							SPECT_MAIN.SPECT_MAIN_NAME
						FROM 
							SPECT_MAIN_ROW ,
							SPECT_MAIN
						WHERE
							<!--- SPECT_MAIN.SPECT_MAIN_ID IN (#spect_list_id#) AND --->
							SPECT_MAIN_ROW.SPECT_MAIN_ID=SPECT_MAIN.SPECT_MAIN_ID
							<cfset kontrol_d=0>
							<cfloop from="1" to="#attributes.record_num#" index="i">
								<cfif isdefined('attributes.input#i#')>
									<cfset kontrol_d=kontrol_d+1>
								</cfif>
							</cfloop>
							<cfif kontrol_d>
							 AND
							(
								<cfloop from="1" to="#attributes.record_num#" index="i">
									<cfif isdefined('attributes.input#i#')>
									<cfset st=st+1>
									(
										SPECT_MAIN_ROW.IS_PROPERTY=1
										<cfif len(evaluate('attributes.property_id#i#'))>AND SPECT_MAIN_ROW.PROPERTY_ID=#evaluate('attributes.property_id#i#')#</cfif>
										<cfif len(evaluate('attributes.variation_id#i#'))>AND SPECT_MAIN_ROW.VARIATION_ID=#evaluate('attributes.variation_id#i#')#</cfif>
										<cfif len(evaluate('attributes.total_min#i#'))>AND SPECT_MAIN_ROW.TOTAL_MIN >= #evaluate('attributes.total_min#i#')#</cfif>
										<cfif len(evaluate('attributes.total_max#i#'))>AND SPECT_MAIN_ROW.TOTAL_MAX <= #evaluate('attributes.total_max#i#')#</cfif>
										<cfif len(evaluate('attributes.tolerans#i#'))>AND SPECT_MAIN_ROW.TOLERANCE=#evaluate('attributes.tolerans#i#')#</cfif>
									)
									<cfif kontrol_d gt st>OR</cfif>
									</cfif>
								</cfloop>
							)
							</cfif>
						GROUP BY SPECT_MAIN.SPECT_MAIN_ID,SPECT_MAIN.SPECT_MAIN_NAME
					</cfquery>

				<cfif isdefined('GET_SPECT.RECORDCOUNT') and GET_SPECT.RECORDCOUNT>
					<cfset spect_id=valuelist(GET_SPECT.SPECT_MAIN_ID,',')>
					<cfquery name="GET_STOCK" datasource="#DSN2#">
						SELECT
							SUM(SR.STOCK_IN-SR.STOCK_OUT) AMOUNT,
							SR.STORE,
							SR.STORE_LOCATION,
							SR.SHELF_NUMBER,
							SR.SPECT_VAR_ID,
							SR.PRODUCT_MANUFACT_CODE,
							S.STOCK_CODE,
							S.PRODUCT_DETAIL,
							S.PRODUCT_UNIT_ID,
							S.PRODUCT_NAME,
							S.PRODUCT_ID
						FROM
							#dsn3_alias#.STOCKS S,
							STOCKS_ROW SR
						WHERE
							S.STOCK_ID = SR.STOCK_ID
							<!--- AND S.STOCK_ID=#STOCK_ID# --->
							AND SPECT_VAR_ID IN(#spect_id#)
						GROUP BY
							SR.STORE,
							SR.STORE_LOCATION,
							SR.SHELF_NUMBER,
							SR.PRODUCT_MANUFACT_CODE,
							SR.SPECT_VAR_ID,
							S.STOCK_CODE,
							S.PRODUCT_DETAIL,
							S.PRODUCT_UNIT_ID,
							S.PRODUCT_NAME,
							S.PRODUCT_ID
						HAVING SUM(SR.STOCK_IN-SR.STOCK_OUT)>0
					</cfquery>
				<cfelse>
					<script type="text/javascript">
						alert("<cf_get_lang dictionary_id='60235.Aradığınız Özelliklere Uygun Bir Spec Bulunamadı'>"!);
						//history.go(-1);
					</script>
					<!--- <cfabort> --->
				</cfif>
					<table cellspacing="1" cellpadding="2" border="0" width="100%" class="color-border">
						<tr class="color-header" height="20">
							<td class="form-title" width="75"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
							<td class="form-title" width="75"><cf_get_lang dictionary_id='34299.Spec'> <cf_get_lang dictionary_id='57487.No'></td>
							<td class="form-title" width="75"><cf_get_lang dictionary_id='34080.Etiket No'></td>
							<td class="form-title"><cf_get_lang dictionary_id ='57629.Açıklama'></td>
							<td class="form-title" width="125"><cf_get_lang dictionary_id ='32904.Depo-Lokasyon'></td>
							<td class="form-title" width="65"><cf_get_lang dictionary_id ='34081.Raf No'></td>
							<td width="60"  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id ='57635.Miktar'></td>
							<td class="form-title" width="50"><cf_get_lang dictionary_id ='57636.Birim'></td>
							<td width="60"  class="form-title" style="text-align:right;"><cf_get_lang no ='637.Kul Stok'></td>
							<td class="form-title" width="65"><cf_get_lang dictionary_id ='29750.Rezerve'></td>
						</tr>
						<cfif isdefined('GET_STOCK.RECORDCOUNT') and GET_STOCK.RECORDCOUNT>
						<cfoutput query="GET_STOCK">
						<cfquery name="get_unit" datasource="#dsn1#">
							SELECT MAIN_UNIT_ID,MAIN_UNIT,UNIT_ID,ADD_UNIT FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_ID=#PRODUCT_UNIT_ID#
						</cfquery>
						<cfif len(STORE)>
							<cfquery name="get_dep" datasource="#dsn#">
								SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID=#STORE#
							</cfquery>
						</cfif>
						<cfif len(STORE_LOCATION)>
							<cfquery name="get_dep_loc" datasource="#dsn#">
								SELECT COMMENT FROM STOCKS_LOCATION WHERE LOCATION_ID=#STORE_LOCATION#
							</cfquery>
						</cfif>
						<cfquery name="get_stock_reserved" datasource="#dsn2#">
							SELECT 
								SUM(STOCK_IN_RESERVED-STOCK_OUT_RESERVED) AMOUNT_RESERVED
							FROM 
								STOCKS_ROW_RESERVED 
							WHERE 
								<cfif len(STORE_LOCATION)>STORE_LOCATION=#STORE_LOCATION#</cfif>
								<cfif len(STORE)>AND STORE=#STORE#</cfif>
								<cfif len(STOCK_ID)>AND STOCK_ID=#STOCK_ID#</cfif>
								<cfif len(SPECT_VAR_ID)>AND SPECT_VAR_ID=#SPECT_VAR_ID#</cfif>
						</cfquery>
	 				 	<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<input type="hidden" name="use_product_id#currentrow#" id="use_product_id#currentrow#" value="#PRODUCT_ID#">
							<input type="hidden" name="use_stock_id#currentrow#" id="use_stock_id#currentrow#" value="#STOCK_ID#">
							<input type="hidden" name="use_stock_code#currentrow#" id="use_stock_code#currentrow#" value="#STOCK_CODE#">
							<input type="hidden" name="use_spect_id#currentrow#" id="use_spect_id#currentrow#" value="#SPECT_VAR_ID#">
							<input type="hidden" name="use_manufact_code#currentrow#" id="use_manufact_code#currentrow#" value="#PRODUCT_MANUFACT_CODE#">
							<input type="hidden" name="use_shelf_number#currentrow#" id="use_shelf_number#currentrow#" value="#SHELF_NUMBER#">
							<input type="hidden" name="use_amount#currentrow#" id="use_amount#currentrow#" value="#AMOUNT#">
							<input type="hidden" name="use_product_name#currentrow#" id="use_product_name#currentrow#" value="#PRODUCT_NAME#">
							<input type="hidden" name="use_store#currentrow#" id="use_store#currentrow#" value="#STORE#">
							<input type="hidden" name="use_store_location#currentrow#" id="use_store_location#currentrow#" value="#STORE_LOCATION#">
							<td>#STOCK_CODE#</td>
							<td>#SPECT_VAR_ID#</td>
							<td>#PRODUCT_MANUFACT_CODE#</td>
							<td>#PRODUCT_DETAIL#</td>
							<td><cfif len(STORE)>#get_dep.DEPARTMENT_HEAD#</cfif> - <cfif len(STORE_LOCATION)>#get_dep_loc.COMMENT#</cfif></td>
							<td>#SHELF_NUMBER#</td>
							<td  style="text-align:right;">#TLFormat(AMOUNT,3)#</td>
							<td>#get_unit.MAIN_UNIT#</td>
							<td  style="text-align:right;"><cfif len(get_stock_reserved.AMOUNT_RESERVED)>#TLFormat(GET_STOCK.AMOUNT-get_stock_reserved.AMOUNT_RESERVED,3)#<cfelse>#TLFormat(GET_STOCK.AMOUNT,3)#</cfif></td>
							<td nowrap="nowrap"><input type="text" name="stock_amount#currentrow#" id="stock_amount#currentrow#" class="moneybox" value="" style="width:50px;">
                            <input type="checkbox" name="use_stock" id="use_stock" value="#currentrow#"></td>
						</tr>
						</cfoutput>
						<cfelse>
						<tr><td colspan="11" class="color-row"><cf_get_lang dictionary_id ='34082.Ürün İçin İstenilen Özelliklerde Stok Bulunamadı'></td></tr>				
						</cfif>
					</table>
				</cfif>
				</td>
			</tr>
		</cfif>
		</table>
		</td>
	</tr>
</cfform>
</table>
<script type="text/javascript">
	document.add_spect.stock_code.focus();
	row_count=<cfif isdefined('attributes.record_num')><cfoutput>#attributes.record_num#</cfoutput><cfelseif isdefined('get_property')><cfoutput>#get_property.recordcount#</cfoutput><cfelse>0</cfif>;
	function search_prod()
	{
		if(trim(document.add_spect.stock_code.value).length==0)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_code=add_spect.stock_code','list');
			return false;
		}else{
			document.add_spect.submit_type.value=1;
			document.add_spect.action='';
			document.add_spect.submit();
		}
	}
	function search_stock()
	{
		if(trim(document.add_spect.stock_code.value).length==0)
		{
			alert("<cf_get_lang dictionary_id ='37332.Ürün Kodu Girmelisiniz'>!");
			return false;
		}else{
			document.add_spect.submit_type.value=2;
			document.add_spect.action='';
			document.add_spect.submit();
		}
	}
	function kontrol(){
		if(trim(document.add_spect.spect_name.value).length==0)
		{
			alert("<cf_get_lang dictionary_id ='34084.Spec Adını Girmelisiniz'>!");
			return false;
		}
		document.add_spect.amount.value=filterNum(document.add_spect.amount.value);
		document.add_spect.discount.value=filterNum(document.add_spect.discount.value);
		document.add_spect.discount_yuzde.value=filterNum(document.add_spect.discount_yuzde.value);
		document.add_spect.net_price.value=filterNum(document.add_spect.net_price.value);
		document.add_spect.total_price.value=filterNum(document.add_spect.total_price.value);
		document.add_spect.price.value=filterNum(document.add_spect.price.value);
		document.add_spect.other_price.value=filterNum(document.add_spect.other_price.value);
		document.add_spect.submit_type.value=3;
		document.add_spect.action='<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_add_spect_property_stock_price';
		document.add_spect.submit();
	}
	function hesapla()
	{<!--- tutar iskontosu hesaplandı yüzdelik iskonto hesaplanacak --->
		var amount_ = parseFloat(filterNum(document.add_spect.amount.value,4));
		if(isNaN(amount_)) amount_ = 1;
		var fiyat = parseFloat(filterNum(document.add_spect.price.value,4));
		if(isNaN(fiyat)) fiyat = 0;
		var iskonto_tutar = parseFloat(filterNum(document.add_spect.discount.value,4)*list_getat(document.add_spect.other_money.value,2));
		if(isNaN(iskonto_tutar)) iskonto_tutar = 0;
		var iskonto_yuzde = parseFloat(filterNum(document.add_spect.discount_yuzde.value,4));
		if(isNaN(iskonto_yuzde)) iskonto_yuzde = 0;
		iskonto_tutar_yuzde=0;
		if(iskonto_yuzde!=0) iskonto_tutar_yuzde=parseFloat((filterNum(document.add_spect.other_price.value,4)-filterNum(document.add_spect.discount.value))*iskonto_yuzde/100);
		iskonto_tutar_yuzde=iskonto_tutar_yuzde*list_getat(document.add_spect.other_money.value,2);
		var net_tutar=parseFloat(((fiyat-iskonto_tutar)-iskonto_tutar_yuzde)*amount_,4);
		document.add_spect.net_price.value=commaSplit(net_tutar,4);
		document.add_spect.total_price.value=commaSplit(net_tutar*amount_,4);
		document.add_spect.price.value=commaSplit(fiyat,4);
		document.add_spect.other_price.value=commaSplit(parseFloat(fiyat/list_getat(document.add_spect.other_money.value,2)),4);
	}
	function other_money_hesapla(){
		document.add_spect.other_price.value = parseFloat(filterNum(document.add_spect.other_price.value,4));
		if(isNaN(document.add_spect.other_price.value)) document.add_spect.other_price.value = 0;
		document.add_spect.price.value=commaSplit(parseFloat(document.add_spect.other_price.value*list_getat(document.add_spect.other_money.value,2)),4);
		document.add_spect.other_price.value=commaSplit(document.add_spect.other_price.value,4);
		hesapla();
	}
<cfif isdefined('attributes.stock_code') and isdefined('attributes.submit_type') and len(attributes.submit_type)>
	function add_row()
	{

		row_count++;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("table").insertRow(document.getElementById("table").rows.length);
		newRow.setAttribute("name","add_row_id" + row_count);
		newRow.setAttribute("id","add_row_id" + row_count);		
		newRow.setAttribute("NAME","add_row_id" + row_count);
		newRow.setAttribute("ID","add_row_id" + row_count);
		document.add_spect.record_num.value=row_count;

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.colSpan=2;
		newCell.innerHTML = '<input type="hidden" name="variation_id'+row_count+'" value=""><input type="hidden" name="property_name'+row_count+'" value=""><input type="hidden" name="property_id'+row_count+'" value=""><select name="select_property'+row_count+'" style="width:275px;" onChange="set_property_name('+row_count+')"><option value="">Özellik - Varyasyon</option><cfoutput query="GET_PROPERTY_ALL"><cfquery name="GET_VARIATION" dbtype="query">SELECT PROPERTY_DETAIL_ID, PROPERTY_DETAIL FROM GET_VARIATION_ALL WHERE PRPT_ID = #PROPERTY_ID#</cfquery><option value="#PROPERTY_ID#||#PROPERTY#||#GET_VARIATION.PROPERTY_DETAIL_ID#" >#PROPERTY#</option><cfloop query="GET_VARIATION"><option value="#GET_PROPERTY_ALL.PROPERTY_ID#||#GET_PROPERTY_ALL.PROPERTY#||#PROPERTY_DETAIL_ID#">&nbsp;&nbsp;&nbsp;#PROPERTY_DETAIL#</option></cfloop></cfoutput></select>';
		//newCell = newRow.insertCell();
		//newCell.innerHTML = '<select name="variation_id'+row_count+'" style="width:150px;"><option value="">Varyasyon</option><cfoutput query="GET_VARIATION_ALL"><option value="#PROPERTY_DETAIL_ID#">#PROPERTY_DETAIL#</option></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="total_min'+row_count+'" value="" style="width:35px"><input type="text" name="total_max'+row_count+'" value="" style="width:35px">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="tolerans'+row_count+'" value="" style="width:55px">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("align","center");
		newCell.innerHTML = '<input type="checkbox" name="input'+row_count+'" value="1">';
	}
</cfif>
function set_property_name(satir)
{
	eval('document.add_spect.property_name'+satir).value=list_getat(eval("document.add_spect.select_property"+satir).value,2,'||');
	eval('document.add_spect.property_id'+satir).value=list_getat(eval("document.add_spect.select_property"+satir).value,1,'||');
	eval('document.add_spect.variation_id'+satir).value=list_getat(eval("document.add_spect.select_property"+satir).value,3,'||');
}

</script>

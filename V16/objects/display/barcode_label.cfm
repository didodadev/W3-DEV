<cfinclude template="../functions/barcode.cfm">
<cfif isdefined("attributes.form_type") and len(attributes.form_type)>
	<cfquery name="GET_FORM" datasource="#DSN3#">
		SELECT
			TEMPLATE_FILE,
			FORM_ID,
			PROCESS_TYPE,
            IS_STANDART
		FROM
			SETUP_PRINT_FILES
		WHERE
			FORM_ID = #attributes.form_type#
	</cfquery>
    <cfif get_form.is_standart eq 1>
		<cfinclude template="/#get_form.template_file#">
	<cfelse>
        <cfinclude template="#file_web_path#settings/#get_form.template_file#">
	</cfif>
<cfelse>
	<cfquery name="GET_PRODUCT_DETAIL" datasource="#DSN3#">
		SELECT   
			S.PRODUCT_ID,
			S.PRODUCT_NAME,
			S.TAX,
			S.TAX_PURCHASE,
			PRODUCT_UNIT.ADD_UNIT,
			S.STOCK_CODE,
			S.STOCK_ID
		FROM
			PRODUCT_UNIT,
			STOCKS S,
			#dsn1_alias#.STOCKS_BARCODES SB
		WHERE  
			S.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID AND
			S.STOCK_ID = SB.STOCK_ID AND
			S.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID
		  <cfif isdefined('attributes.barcod')>
			AND SB.BARCODE='#attributes.barcod#'
		  <cfelse>
			AND S.BARCOD='#attributes.barcode#'			
		  </cfif>
	</cfquery>
	<cfif GET_PRODUCT_DETAIL.recordcount>
		<cfif isdefined("attributes.price_catid") and (attributes.price_catid gt 0)>
			<cfquery name="GET_PRICE" datasource="#DSN3#"> 
				SELECT	
					MONEY,
					IS_KDV,
					PRICE_KDV,
					PRICE,
					STARTDATE,
					FINISHDATE
				FROM 
					PRICE
				WHERE 
					PRICE.PRODUCT_ID = #get_product_detail.product_id# AND
					ISNULL(PRICE.STOCK_ID,0)=0 AND
					ISNULL(PRICE.SPECT_VAR_ID,0)=0 AND
					PRICE.PRODUCT_ID = #get_product_detail.product_id# AND
					PRICE.PRICE_CATID = #attributes.price_catid# AND
					PRICE.STARTDATE <= #now()# AND
					(PRICE.FINISHDATE >= #now()# OR PRICE.FINISHDATE IS NULL)
				  <cfif isdefined("attributes.main_unit_id") and len(attributes.main_unit_id)>
					AND UNIT = #attributes.main_unit_id#
				  </cfif>
			</cfquery>	
		<cfelseif not isdefined("attributes.price_catid") or (isdefined("attributes.price_catid") and (attributes.price_catid eq -2))>
			<cfquery name="GET_PRICE" datasource="#DSN3#"> 
				SELECT	
					PRICE,
					PRICE_KDV,				
					MONEY,
					IS_KDV,
					PRICE_STANDART.RECORD_DATE AS STARTDATE,
					'' AS FINISHDATE
				FROM 
					PRICE_STANDART
				WHERE 
					PRICE_STANDART.PRODUCT_ID = #get_product_detail.product_id# AND 
					PRICE_STANDART.PURCHASESALES = 1 AND 
					PRICE_STANDART.PRICESTANDART_STATUS = 1
				  <cfif isdefined("attributes.main_unit_id") and len(attributes.main_unit_id)>
					AND UNIT_ID = #attributes.main_unit_id#
				  </cfif>
			</cfquery>
		<cfelseif isdefined("attributes.price_catid") and (attributes.price_catid eq -1)>		
			<cfquery name="GET_PRICE" datasource="#DSN3#"> 
				SELECT	
					PRICE,
					PRICE_KDV,
					MONEY,
					IS_KDV,
					PRICE_STANDART.RECORD_DATE AS STARTDATE,
					'' AS FINISHDATE
				FROM 
					PRICE_STANDART
				WHERE 
					PRICE_STANDART.PRODUCT_ID = #get_product_detail.product_id# AND 
					PRICE_STANDART.PURCHASESALES = 0 AND 
					PRICE_STANDART.PRICESTANDART_STATUS = 1 
				<cfif isdefined("attributes.main_unit_id") and len(attributes.main_unit_id)>
					AND UNIT_ID = #attributes.main_unit_id#
				</cfif>
			</cfquery>
		</cfif>
	</cfif>
	<script type="text/javascript">
	function Arrange_Active_Barcode(obj)
	{
		barcode_id = obj.options[obj.selectedIndex].value;
		<cfoutput>
		<cfif page_code contains 'BARCODE_ID'>
			<cfset start = find('BARCODE_ID',page_code,1)>			
			extra_code = '#removechars(page_code,start,Len(page_code))#';
		<cfelse>
			extra_code = '#page_code#';
		</cfif>
		<cfif page_code contains 'first' or page_code contains 'withKDV'>
			extra_code = extra_code + '&withKDV=1';
		</cfif>
		window.location.href = '#request.self#?fuseaction=objects.popup_barcode' + extra_code + '&barcode_id=' + barcode_id;
		</cfoutput>
	}
	</script>	
<cfsavecontent variable="right">
<form name="kdvForm" id="kdvForm" method="post" action=""><!--- <cfoutput>#request.self#?fuseaction=objects.popup_barcode#page_code#</cfoutput> --->
	<input type="hidden" name="barcode" id="barcode" value="<cfoutput>#attributes.barcod#</cfoutput>">
	<cfif isdefined("attributes.price_catid")>
	<input type="hidden" name="price_catid" id="price_catid" value="<cfoutput>#attributes.price_catid#</cfoutput>">
	</cfif>
	<cfif page_code contains "&FIRST="><cfset page_code = RemoveChars(page_code,FindNoCase("&FIRST=",page_code,1),7)></cfif>
	<cfif page_code contains "&WITHKDV=on"><cfset page_code = RemoveChars(page_code,FindNoCase("&WITHKDV=on",page_code,1),11)></cfif>
	<cfif page_code contains "&WITHKDV=1"><cfset page_code = RemoveChars(page_code,FindNoCase("&WITHKDV=1",page_code,1),10)></cfif>
	<cfquery name="GET_DET_FORM" datasource="#DSN#">
		SELECT 
			SPF.TEMPLATE_FILE,
			SPF.FORM_ID,
			SPF.IS_DEFAULT,
			SPF.NAME,
			SPF.PROCESS_TYPE,
			SPF.MODULE_ID,
			SPFC.PRINT_NAME
		FROM 
			#dsn3_alias#.SETUP_PRINT_FILES SPF,
			SETUP_PRINT_FILES_CATS SPFC,
			MODULES MOD
		WHERE
			SPF.ACTIVE = 1 AND
			SPF.MODULE_ID = MOD.MODULE_ID AND
			SPFC.PRINT_TYPE = SPF.PROCESS_TYPE AND 
			SPFC.PRINT_TYPE = 193
		ORDER BY
			SPF.NAME
	</cfquery> 
	<select name="form_type" id="form_type" style="width:200px">
		<option value=""><cf_get_lang dictionary_id='57792.Modül Içi Yazici Belgeleri'></option>
		<cfoutput query="GET_DET_FORM">
			<option value="#form_id#" <cfif (isdefined("attributes.form_type") and attributes.form_type eq form_id) or (not isdefined("attributes.form_type") and IS_DEFAULT eq 1)>selected</cfif>>#name# - #print_name#</option>
		</cfoutput>
	</select>			  
	<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>												
		<input type="checkbox" name="withKDV" id="withKDV"<cfif isdefined("attributes.withKDV") or isDefined("attributes.first")> checked</cfif>><cf_get_lang dictionary_id='58716.KDV li'>
	</cfif>
	<cfoutput>
		<a href="##" onClick="kdvForm.submit();"><img src="/images/print.gif" border="0" title="Yazdir" align="absbottom"></a>
	</cfoutput>
</form>
</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57633.Barkod'></cfsavecontent>
<cf_box title="#message#" <!--- right_images='#right#' ---> popup_box="1">

<table>
	<cfif isdefined("attributes.price_catid") and (attributes.price_catid gt 0)>			
		<tr>
			<td class="txtbold"><cfif isdefined("attributes.withKDV") or isDefined("attributes.first")><cf_get_lang dictionary_id='58716.KDV li'></cfif><cf_get_lang dictionary_id='32763.Satis Fiyati'></td>
			<td>
			  <cfif isdefined("attributes.withKDV") or isDefined("attributes.first")>
				<cfif len(get_price.is_kdv) and get_price.is_kdv>
				  <cfoutput>#TLFormat(get_price.price_kdv)#</cfoutput>
				<cfelse>
				  <cfif len(get_price.price)>
					<cfset price_of = get_price.price>
				  <cfelse>
					<cfset price_of = 0>
				  </cfif>							
				  <cfoutput>#TLFormat(Evaluate(price_of*(get_product_detail.tax + 100)/100))#</cfoutput>
				</cfif>
			  <cfelse>
				<cfoutput>#TLFormat(get_price.price)#</cfoutput>
			  </cfif>
			  <cfoutput> #get_price.money#</cfoutput>
			</td>
		</tr>
	<cfelseif isdefined("attributes.price_catid") and (attributes.price_catid eq -2)>
		<tr>
			<td class="txtbold"><cfif isdefined("attributes.withKDV") or isDefined("attributes.first")><cf_get_lang dictionary_id='58716.KDV li'></cfif><cf_get_lang dictionary_id='32424.Std  Satis'></td>
			<td>
				<cfif isdefined("attributes.withKDV") or isDefined("attributes.first")>
					<cfif len(get_price.is_kdv) and get_price.is_kdv>
						<cfoutput>#TLFormat(get_price.price_kdv)# </cfoutput>
					<cfelse>
						<cfif len(get_price.price)>
							<cfset price_of = get_price.price>
						<cfelse>
							<cfset price_of = 0>
						</cfif>
						<cfoutput>#TLFormat(Evaluate(price_of*(get_product_detail.tax + 100)/100))# </cfoutput>
					</cfif>
					<cfelse>
					<cfoutput>#TLFormat(get_price.price)# </cfoutput>
				</cfif>
				<cfoutput> #get_price.money#</cfoutput>						
			</td>
		</tr>	  
	<cfelseif isdefined("attributes.price_catid") and (attributes.price_catid eq -1)>  
		<tr>
			<td class="txtbold"><cfif isdefined("attributes.withKDV") or isDefined("attributes.first")><cf_get_lang dictionary_id='58716.KDV li'></cfif> <cf_get_lang dictionary_id='32424.Std  Alis'></td>
			<td>
				<cfif isdefined("attributes.withKDV") or isDefined("attributes.first")>
				<cfif len(get_price.is_kdv) and get_price.is_kdv>
					<cfoutput>#TLFormat(get_price.price_kdv)# </cfoutput>
				<cfelse>
					<cfif len(get_price.price)>
						<cfset price_of = get_price.price>
					<cfelse>
						<cfset price_of = 0>
					</cfif>
						<cfoutput>#TLFormat(Evaluate(price_of*(get_product_detail.tax + 100)/100))# </cfoutput>
					</cfif>
				<cfelse>
				<cfoutput>#TLFormat(get_price.price)# </cfoutput>
				</cfif>
				<cfoutput> #get_price.money#</cfoutput>								
			</td>
		</tr>	  
	</cfif>  
		<tr>
			<td width="75" class="txtbold"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
			<td><cfoutput>#get_product_detail.stock_code#</cfoutput></td>
		</tr>
		<tr>
			<td width="75"  class="txtbold"><cf_get_lang dictionary_id='57633.Barkod'></td>
			<td><cfoutput><cfif isdefined('attributes.barcod')>#attributes.barcod#<cfelse>#attributes.barcode#</cfif></cfoutput></td>
		</tr>
		<tr>
			<td width="75"  class="txtbold"><cf_get_lang dictionary_id='58221.Ürün Adi'></td>
			<td><cfoutput>#get_product_detail.product_name#</cfoutput> </td>
		</tr>
		<tr>
			<td width="75"  class="txtbold"><cf_get_lang dictionary_id='57636.Birim'></td>
			<td><cfoutput>#get_product_detail.add_unit#</cfoutput> </td>
		</tr>
	</table><table>
	<tr>
		<td width="67"  class="txtbold"><cf_get_lang dictionary_id='57633.Barkod'></td>
		<td  bgcolor="#FFFFFF">
			<cfif isdefined('attributes.barcod')>
				<cfset barcod = attributes.barcod>
			<cfelse>
				<cfset barcod = attributes.barcode>
			</cfif>
			<cfif get_product_detail.add_unit neq "kg">
				<cfif (len(barcod) eq 13) or (len(barcod) eq 12)>
					<cf_barcode type="EAN13" barcode="#barcod#" extra_height="0"><cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
				<cfelseif (len(barcod) eq 8) or (len(barcod) eq 7)>
					<cf_barcode type="EAN8" barcode="#barcod#" extra_height="0"><cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
				</cfif>
				<cfelseif len(barcod) eq 7>
					<cf_barcode type="EAN13" barcode="#barcod#010000" extra_height="0"><cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
			</cfif>
		</td>
	</tr>
	</table>
		<cf_grid_list>
			 <cfif get_product_detail.recordcount>
				<cfquery name="STOCKS_BARCODES" datasource="#DSN3#">
					SELECT
						BARCODE,
						STOCK_ID,
						UNIT_ID
					FROM
						STOCKS_BARCODES
					WHERE
						STOCK_ID = #get_product_detail.stock_id# AND
						BARCODE <> '#attributes.BARCOD#'
				</cfquery>
				<cfif STOCKS_BARCODES.recordcount>
					<thead>
						<tr>
							<th colspan="2"><cf_get_lang dictionary_id='32821.Diger Barkodlar'></td>
						</tr>
					</thead>
					<cfoutput query="STOCKS_BARCODES">
						<tbody>
							<tr>
								<td width="20" valign="baseline"><img src="/images/barcode.gif" border="0"></td>
								<td>
								<!--- burda price_catid cakiyordu ben if li yaptim degismeli 25022004 TODO:ARZU --->
									<cfif isdefined("attributes.PRICE_CATID")>
										<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_barcode&BARCOD=#barcode#&PRICE_CATID=#attributes.price_catid#&main_unit_id=#unit_id#&first&CODE_TYPE=1','#attributes.modal_id#')">#barcode#</a>
									<cfelse>
										<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_barcode&BARCOD=#barcode#&main_unit_id=#unit_id#&first&CODE_TYPE=1','#attributes.modal_id#')">#barcode#</a>
										<!---<a href="javascript://" onclick="iframe_yazdir();">#barcode#</a>--->
									</cfif>
								</td>
							</tr>
						</tbody>
					</cfoutput>
				</cfif>
			</cfif>
		</cf_grid_list>
	</cf_box>
</cfif>
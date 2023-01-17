<cfif not isdefined('attributes.is_spec') or attributes.is_spec eq 0>
	<cfquery name="GET_SPECT_VAR" datasource="#DSN3#">
		SELECT
        	SMR.RELATED_MAIN_SPECT_ID,
			SM.SPECT_MAIN_ID SPECT_MAIN_ID,
			SM.SPECT_MAIN_NAME SPECT_MAIN_NAME,
			SM.DETAIL DETAIL,
			SM.SPECT_TYPE,
			SMR.STOCK_ID ROW_STOCK_ID,
			SMR.PRODUCT_NAME,
			SMR.AMOUNT ROW_AMOUNT,
			SMR.IS_SEVK ROW_SEVK,
			SMR.IS_PROPERTY ROW_PROPERTY,
			SMR.PROPERTY_ID
		FROM
			SPECT_MAIN SM,
			SPECT_MAIN_ROW SMR
		WHERE
			SM.SPECT_MAIN_ID = SMR.SPECT_MAIN_ID AND
			SM.SPECT_MAIN_ID = #attributes.ID#
	</cfquery>
<cfelseif attributes.is_spec eq 1>
	<cfquery name="GET_SPECT_VAR" datasource="#DSN3#">
		SELECT
        	<!--- SMR.RELATED_MAIN_SPECT_ID, --->
			SM.SPECT_MAIN_ID SPECT_MAIN_ID,
			SM.SPECT_VAR_ID SPECT_VAR_ID,
			SM.SPECT_VAR_NAME SPECT_MAIN_NAME,
			SM.DETAIL DETAIL,
			SM.SPECT_TYPE,
			SM.TOTAL_AMOUNT,
			SM.OTHER_TOTAL_AMOUNT,
			SMR.STOCK_ID ROW_STOCK_ID,
			SMR.PRODUCT_NAME,
			SMR.TOTAL_MIN,
			SMR.TOTAL_MAX,
			SMR.AMOUNT_VALUE ROW_AMOUNT,
			SMR.IS_SEVK ROW_SEVK,
			SMR.IS_PROPERTY ROW_PROPERTY,
			SMR.PROPERTY_ID
		FROM
			SPECTS SM,
			SPECTS_ROW SMR
		WHERE
			SM.SPECT_VAR_ID = SMR.SPECT_ID AND
			SM.SPECT_VAR_ID=#attributes.ID#
	</cfquery>
</cfif>
<table width="100%"  border="0" cellspacing="1" cellpadding="2" height="100%" class="color-border">
	<tr class="color-list">
		<td height="35" class="headbold">
		<table>
			<tr>
				<td width="100%">
					<b><cfif isdefined('get_spect_var.SPECT_VAR_ID') and len(get_spect_var.SPECT_VAR_ID)><cf_get_lang dictionary_id='57647.Spect'>:&nbsp;<cfoutput>#get_spect_var.spect_var_id#</cfoutput></cfif>
					&nbsp&nbsp<cfif isdefined('get_spect_var.SPECT_MAIN_ID') and len(get_spect_var.SPECT_MAIN_ID)><cf_get_lang dictionary_id="57647.Spect"> <cf_get_lang dictionary_id="58206.Main">:&nbsp;<cfoutput>#get_spect_var.spect_main_id#</cfoutput></cfif>
					</b>
				</td>
				<!-- sil --><cf_workcube_file_action doc=1><!-- sil -->
			</tr>
		</table>
		</td>	
	</tr>
	<tr class="color-row">
		<td colspan="2" valign="top">
		<table>
			<tr>
				<td width="65" class="txtbold"><cf_get_lang dictionary_id='57647.Spect'></td>
				<td><cfoutput>#get_spect_var.spect_main_name#</cfoutput></td>
			</tr> 
			<tr>
				<td valign="top" class="txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></td>
				<td><cfif len(get_spect_var.detail)><cfoutput>#get_spect_var.detail#</cfoutput></cfif></td>
			</tr>
		</table>
		<br/><br/>
		<table name="table1" id="table1">
			<tr class="formbold" height="25">
				<td colspan="3"><cf_get_lang dictionary_id='32747.Bilesenler'></td>
				<!-- sil -->
				<td>&nbsp;</td>
				<!-- sil -->
			</tr>
			<tr class="txtboldblue">
				<td width="75"><cf_get_lang dictionary_id="57518.Stok Kodu"></td>
				<td width="220"><cf_get_lang dictionary_id="57657.Ürün"></td>
                <cfif not isdefined('attributes.is_spec')>
                <td width="220"><cf_get_lang dictionary_id="57647.Spec"></td>
                </cfif>
				<td width="50"><cf_get_lang dictionary_id="57635.Miktar"></td>
				<td>SB</td>
			</tr>
		<cfoutput query="get_spect_var">
			<tr>
				<td>
				<cfif len(row_stock_id)>
					<cfquery name="get_stock" datasource="#DSN1#">
						SELECT STOCK_ID,STOCK_CODE FROM STOCKS WHERE STOCK_ID = #get_spect_var.row_stock_id#
					</cfquery>
					#get_stock.stock_code#
				</cfif>
				</td>
				<td>#product_name#</td>
                <cfif not isdefined('attributes.is_spec')>
                <td>#RELATED_MAIN_SPECT_ID#</td>
                </cfif>
				<td>#TLFormat(row_amount,2)#</td>
				<td><cfif row_sevk eq 1>SB</cfif></td>
			</tr>
		</cfoutput>
			<tr>
				<td colspan="5"><br/>
				<table>
					<tr class="formbold" height="25">
						<td colspan="3"><cf_get_lang dictionary_id="58910.Özellikler"></td>
						<!-- sil -->
						<td>&nbsp;</td>
						<!-- sil -->
					</tr>
					<tr class="txtboldblue">
						<td width="75"><cf_get_lang dictionary_id="57632.Özellik"></td>
						<td width="100"><cf_get_lang dictionary_id="33615.Varyasyon"></td>
						<td width="200"><cf_get_lang dictionary_id="57629.Açıklama"></td>
						<td width="50"><cf_get_lang dictionary_id="33616.Değer"></td>
						<td width="50"><cf_get_lang dictionary_id="57635.Miktar"></td>
					<cfif get_spect_var.spect_type eq 3 and isdefined('attributes.is_spec') and attributes.is_spec eq 1>
						<td width="50"><cf_get_lang dictionary_id="33329.Değer Aralığı"></td>
					</cfif>
					</tr>
				 <cfoutput query="get_spect_var">
				  <cfif row_property eq 1 and len(get_spect_var.property_id)>
					<cfquery name="GET_PROPERTY" datasource="#DSN1#">
						SELECT
							PPD.PROPERTY_DETAIL_ID,
							PPD.PROPERTY_DETAIL,
							PPD.PRPT_ID,
							PP.PROPERTY_ID,
							PP.PROPERTY,
							PP.DETAIL,
							PP.AMOUNT,
							PDTP.TOTAL_MIN,
							PDTP.TOTAL_MAX
						FROM 
							PRODUCT_PROPERTY_DETAIL PPD,
							PRODUCT_PROPERTY PP,
							PRODUCT_DT_PROPERTIES PDTP
						WHERE 
							PPD.PRPT_ID = #get_spect_var.property_id# AND
							PP.PROPERTY_ID = PPD.PRPT_ID AND
							PDTP.PROPERTY_ID = PPD.PRPT_ID
					</cfquery>
					<tr>
						<td>#get_property.property#</td>
						<td>#get_property.property_detail#</td>
						<td>#product_name#</td>
						<td><cfif len(get_property.total_min) and len(get_property.total_max)><!-- sil -->&nbsp;<!-- sil -->#get_property.total_min#/#get_property.total_max#</cfif></td>
						<td>#get_property.amount#</td>
					<cfif get_spect_var.spect_type eq 3 and isdefined('attributes.is_spec') and attributes.is_spec eq 1>
						<td>#get_spect_var.total_min#-#get_spect_var.total_max#</td>
					</cfif>
					</tr>
				  </cfif>
				  </cfoutput>
				</table>
			</td>
		  </tr>
		</table>
		</td>
	</tr>
</table>


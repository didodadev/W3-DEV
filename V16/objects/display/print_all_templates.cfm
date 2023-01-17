<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.form_type") and len(attributes.form_type)>
<cfinclude template="../functions/barcode.cfm">
<cfquery name="GET_FORM" datasource="#DSN3#">
	SELECT
		TEMPLATE_FILE,
		FORM_ID,
		PROCESS_TYPE
	FROM
		SETUP_PRINT_FILES
	WHERE
		FORM_ID = #attributes.form_type#
</cfquery>
<cfinclude template="#file_web_path#settings/#get_form.template_file#">
<cfelse>
	<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
		SELECT
			PRICE_CAT
		FROM
			PRICE_CAT
		WHERE
			PRICE_CAT.BRANCH LIKE '%,#listgetat(session.ep.user_location, 2, '-')#,%'
	</cfquery>
	<!-- sil -->
	<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
	  <tr class="color-border"> 
		<td> 
		<table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
		<form name="process" action="" method="post">
		  <tr height="35" class="color-list"><td class="headbold"><cf_get_lang no="569.Fiyat Değişimi Toplu Print"></td></tr>
		  <tr valign="top" class="color-row">
			<td>
			<table>
			  <cfoutput>
				  <input type="hidden" name="start_date" id="start_date" value="#attributes.start_date#">
				  <input type="hidden" name="finish_date" id="finish_date" value="#attributes.finish_date#">
				  <input type="hidden" name="product_catid" id="product_catid" value="#attributes.product_catid#">
				  <input type="hidden" name="price_catids" id="price_catids" value="#attributes.price_catids#">
				  <input type="hidden" name="keyword" id="keyword" value="#attributes.keyword#">
			  </cfoutput>
			  <tr>
				<td width="100"><cf_get_lang no="572.Şablon Tipi"></td>
				<td>
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
				  <option value="">Modül İçi Yazıcı Belgeleri</option>
				  <cfoutput query="GET_DET_FORM">
					<option value="#form_id#" <cfif (isdefined("attributes.form_type") and attributes.form_type eq form_id) or (not isdefined("attributes.form_type") and IS_DEFAULT eq 1)>selected</cfif>>#name# - #print_name#</option>
				  </cfoutput>
				  </select>
				</td>
			  </tr>
			  <tr>
				<td><cf_get_lang dictionary_id="58964.Fiyat Listesi"></td>
				<td><cfoutput>#get_price_cat.price_cat#</cfoutput></td>
			  </tr>			  
			  <tr>
				<td><cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></td>
				<td><cfoutput>#start_date#</cfoutput></td>
			  </tr>
			  <tr>
				<td><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></td>
				<td><cfoutput>#finish_date#</cfoutput></td>
			  </tr>
			  <tr>
				<td><cf_get_lang dictionary_id="57486.Kategori"></td>
				<td><cfoutput>#product_cat#</cfoutput></td>
			  </tr>
			  <tr>
				<td><cf_get_lang dictionary_id="57460.Filtre"></td>
				<td><cfoutput>#keyword#</cfoutput></td>
			  </tr>		  	  
			  <tr>
				<td></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="32965.Baskıya Gönder"></cfsavecontent>
					<cf_workcube_buttons 
						is_upd='0'
						is_cancel='0'
						insert_alert=''
						insert_info='#message#'>
				</td>
			</tr>
			</table>
			</td> 
		  </tr>
		  </form>
		</table>
		</td>
	  </tr>
	</table>
	<!-- sil -->
</cfif>

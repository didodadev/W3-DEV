<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_obm" default="1">
<cfparam name="attributes.brand_id" default="">
<cfif isdefined("attributes.form_submitted")>
    <cfquery name="get_product_models" datasource="#dsn1#">
        SELECT
            MODEL_ID,
			MODEL_CODE,
			#dsn#.Get_Dynamic_Language(MODEL_ID,'#session.ep.language#','PRODUCT_BRANDS_MODEL','MODEL_NAME',NULL,NULL,MODEL_NAME) AS MODEL_NAME,
            PRODUCT_BRANDS.BRAND_NAME
        FROM
            PRODUCT_BRANDS_MODEL LEFT JOIN PRODUCT_BRANDS ON PRODUCT_BRANDS_MODEL.BRAND_ID = PRODUCT_BRANDS.BRAND_ID
        WHERE
			1=1
        <cfif len(attributes.keyword)>
            AND (MODEL_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR BRAND_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
        </cfif> 
        ORDER BY
		<cfif isdefined("attributes.is_obm") and attributes.is_obm eq 0>
			MODEL_CODE
		<cfelse>
			MODEL_NAME
		</cfif>
    </cfquery>
<cfelse>
	<cfset get_product_models.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_product_models.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box>
	<cfform name="search_model" action="#request.self#?fuseaction=product.list_product_models" method="post">
	<input type="hidden" name="form_submitted" id="form_submitted" value="1">
		<cf_box_search more="0">
			<div class="form-group">					
				<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
			</div>
			<div class="form-group">                	
				<select name="is_obm" id="is_obm">
					<option value=""><cf_get_lang dictionary_id='58924.Sıralama'></option>
					<option value="1" <cfif attributes.is_obm eq 1>selected</cfif>><cf_get_lang dictionary_id='37930.Isme_Gore'></option>
					<option value="0" <cfif attributes.is_obm eq 0>selected</cfif>><cf_get_lang dictionary_id='37087.Koda_Gore'></option>
				</select>
			</div>
			<!---<td><cf_get_lang_main no='1435.Marka'>
			
				<cf_wrkProductBrand
					width="100"
					compenent_name="getProductBrand"               
					boxwidth="240"
					boxheight="150"
					brand_ID="#attributes.brand_id#">
			</td>--->
			<div class="form-group small">
				<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">                	
				<cf_wrk_search_button button_type="4">
			</div>
		</cf_box_search>
	</cfform>
</cf_box>
	<cf_box title="#getLang('','Model',58225)#" uidrop="1" hide_table_column="1" >
	<cf_grid_list>
		<thead>
			<tr>
				<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
				<th><cf_get_lang dictionary_id='58527.ID'></th>
				<th><cf_get_lang dictionary_id='58585.Kod'></th>
				<th><cf_get_lang dictionary_id='60401.Model Adı'></th>
				<th><cf_get_lang dictionary_id="58847.Marka"></th>
				<!-- sil -->
				<th width="20" class="header_icn_none text-center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.list_product_models&event=add</cfoutput>','','ui-draggable-box-small');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				<!-- sil -->
			</tr>
		</thead>
		<tbody>
			<cfif get_product_models.recordcount>
				<cfoutput query="get_product_models" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.list_product_models&event=upd&model_id=#get_product_models.model_id#','','ui-draggable-box-small');">#model_id#</a></td>
						<td>#model_code#</td>
						<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.list_product_models&event=upd&model_id=#get_product_models.model_id#','','ui-draggable-box-small');">#model_name#</a></td>
						<td>#BRAND_NAME#</td>
						<!-- sil -->
						<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.list_product_models&event=upd&model_id=#get_product_models.model_id#','','ui-draggable-box-small');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Guncelle'>" alt="<cf_get_lang dictionary_id='57464.Guncelle'>"></i></a></td>
						<!-- sil -->
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="6"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfset url_str = "">
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		<cfif isdefined ("attributes.is_obm") and len (attributes.is_obm)>
			<cfset url_str ="#url_str#&is_obm=#attributes.is_obm#">
		</cfif>
		<cfif isdefined ("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset url_str ="#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif isdefined ("attributes.brand_id") and len(attributes.brand_id)>
			<cfset url_str ="#url_str#&form_submitted=#attributes.brand_id#">
		</cfif>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="product.list_product_models#url_str#">
</cf_box>
<script type="text/javascript">
	$('#keyword').focus();
</script>

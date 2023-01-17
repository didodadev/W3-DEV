<cf_xml_page_edit fuseact="product.upd_property_main">
<!--- Ürün özellik tablosu --->
<cfquery name="GET_PROPERTY_CAT" datasource="#DSN1#">
	SELECT
		PROPERTY_ID,
		#dsn#.#dsn#.Get_Dynamic_Language(PROPERTY_ID,'#ucase(session.ep.language)#','PRODUCT_PROPERTY','PROPERTY',NULL,NULL,PROPERTY) AS PROPERTY
		,DETAIL  
		,PROPERTY_SIZE 
		,PROPERTY_COLOR 
		,PRODUCT_CAT_HIER  
		,ADDITIONAL_COST 
		,ADDITIONAL_MONEY
		,PROPERTY_CODE
		,CAT_PROPERTY_ID
		,VARIATION_ID
		,AMOUNT 
		,MIN_VALUE
		,MAX_VALUE
		,IS_OPTIONAL 
		,IS_INTERNET 
		,IS_ACTIVE 
		,IS_VARIATION_CONTROL 
		,RECORD_EMP
		,RECORD_DATE 
		,RECORD_IP  
		,UPDATE_EMP
		,UPDATE_DATE 
		,UPDATE_IP  
		,PROPERTY_LEN 
	FROM 
		PRODUCT_PROPERTY 
	WHERE 
		PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prpt_id#">
</cfquery>
<!--- Ürün özellik varyasyon (detay) tablosu --->
<cfquery name="GET_PROPERTY_DETAIL" datasource="#DSN1#">
	SELECT 
		PRPT_ID 
	FROM 
		PRODUCT_PROPERTY_DETAIL 
	WHERE 
		PRPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prpt_id#">
	UNION ALL
	SELECT
		PROPERTY_ID
	FROM
		PRODUCT_DT_PROPERTIES
	WHERE 
		PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prpt_id#">
</cfquery>
<!---Şirket tablosu --->
<cfquery name="GET_PERIOD" datasource="#dsn#">
	SELECT 
		COMP_ID 
	FROM 
		OUR_COMPANY
</cfquery>
<!---Konfügrasyon ve formül tabloları --->
<cfquery name="GET_PROPERTY_CONFIGURATOR_FORMULA_TABLES" datasource="#DSN#">
	<cfloop query="get_period">
		SELECT 
			PROPERTY_ID 
		FROM 
			#dsn#_#get_period.comp_id#.SETUP_PRODUCT_CONFIGURATOR_COMPONENTS 
		WHERE 
		PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prpt_id#">
		<cfif get_period.currentrow neq get_period.recordcount>UNION ALL </cfif>
	</cfloop>
	UNION ALL
	<cfloop query="get_period">
		SELECT 
			PROPERTY_ID 
		FROM 
			#dsn#_#get_period.comp_id#.SETUP_PRODUCT_FORMULA_COMPONENTS 
		WHERE 
			PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prpt_id#">
		<cfif get_period.currentrow neq get_period.recordcount>UNION ALL </cfif>
	</cfloop>
</cfquery>
<cfquery name="GET_PROPERT_OUR_COMPANY" datasource="#DSN1#">
	SELECT 
		OUR_COMPANY_ID 
	FROM 
		PRODUCT_PROPERTY_OUR_COMPANY 
	WHERE PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prpt_id#">
</cfquery>
<cfset our_comp_list=valuelist(get_propert_our_company.our_company_id)>

<!---Özellik Güncelle --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='33614.Ürün Özellikleri'></cfsavecontent>
	<cf_box  title="#head#" popup_box="1" closable="1" resize="0">
		<cfform name="upd_property_main" method="post" action="#request.self#?fuseaction=product.emptypopup_upd_property_main">
			<input type="hidden" name="prpt_id" id="prpt_id" value="<cfoutput>#attributes.prpt_id#</cfoutput>">
			<cf_box_elements vertical="0">
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-status">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
							<label><input type="checkbox" value="1" name="is_active" id="is_active" <cfif get_property_cat.is_active eq 1>checked</cfif>> <cf_get_lang dictionary_id='57493.Aktif'></label>
						</div>
					</div>
					<div class="form-group" id="item-property">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57632.Özellik'> *</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='29741.özellik girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="property" value="#get_property_cat.property#" maxlength="50" required="yes" message="#message#">
								<span class="input-group-addon"><cf_language_info table_name="PRODUCT_PROPERTY" column_name="PROPERTY" column_id_value="#url.prpt_id#" maxlength="50" datasource="#dsn1#" column_id="PROPERTY_ID" control_type="0"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-property_code">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özellik Kodu'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
							<cfinput type="text" name="property_code" value="#get_property_cat.property_code#" maxlength="20">
						</div>
					</div>
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
							<textarea name="detail" id="detail"  maxlength="500">
								<cfoutput>#get_property_cat.detail#</cfoutput>
							</textarea>
						</div>
					</div>
					<cfif xml_size_color eq 1>
						<div class="form-group" id="item-size_color">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37324.Beden'>/<cf_get_lang dictionary_id='37325.Renk'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
								<label><cf_get_lang dictionary_id='37324.Beden'> <input type="checkbox" name="size_color" id="size_color" value="1" <cfif get_property_cat.property_size eq 1> checked</cfif>></label>
								<label><cf_get_lang dictionary_id='37325.Renk'> <input type="checkbox" name="size_color" id="size_color" value="0" <cfif get_property_cat.property_color eq 1> checked</cfif>></label>
								<label><input type="checkbox" value="1" name="PROPERTY_LEN" id="PROPERTY_LEN" <cfif get_property_cat.PROPERTY_LEN eq 1>checked</cfif>><cf_get_lang dictionary_id='48153.Height'></label> 
								<label><input type="checkbox" value="1" name="is_variation_control" id="is_variation_control" <cfif get_property_cat.is_variation_control eq 1>checked</cfif>> <cf_get_lang dictionary_id='37651.Sepet Kontrol Yapılsın'></label> 
								<label><input type="checkbox" value="1" name="is_web_control" id="is_web_control" <cfif get_property_cat.is_internet eq 1>checked</cfif>> <cf_get_lang dictionary_id='37161.Web de Göster'></label>
							</div>
						</div>
					</cfif>
					<input type="hidden" name="property_id" id="property_id" value="<cfoutput query='get_property_cat'>#property_id#</cfoutput>">
					<div class="form-group" id="item-our_company_ids">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58017.İlişkili Şirketler'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
							<cf_multiselect_check name="our_company_ids" option_name="nick_name" option_value="comp_id" value="iif(#listlen(our_comp_list)#,#our_comp_list#,DE(''))" width="200" table_name="OUR_COMPANY">
						</div>
					</div>
					<div class="form-group" id="item-PROPERTY_LEN">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
					</div>
				</div>
			</cf_box_elements>
			<div class="ui-form-list-btn">
				<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
					<cf_record_info query_name="get_property_cat">
				</div>
				<div class="col col-6 col-md-4 col-sm-4 col-xs-12">
					<cfif not get_property_detail.recordcount and not get_property_configurator_formula_tables.recordcount>
						<cf_workcube_buttons is_upd='1' add_function='kontrol_prop()' delete_page_url='#request.self#?fuseaction=product.emptypopup_del_property&prpt_id=#attributes.prpt_id#'>
					<cfelse>
						<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol_prop()'>
					</cfif>
				</div>
			</div>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function kontrol_prop()
			{ 
			< cfif xml_size_color eq 1 >
			if (upd_property_main.size_color[0].checked && upd_property_main.size_color[1].checked) {
				alert("<cf_get_lang dictionary_id='57632.Özellik'>, <cf_get_lang dictionary_id='60448.hem renk hem beden seçilemez'>!!");
				return false;
			}
			< /cfif>
			if (document.upd_property_main.our_company_ids.value == "")
			{ 
			alert ("<cf_get_lang dictionary_id='55700.En az bir şirket seçmelisiniz'>");
			return false;
			}
		}
		

</script>


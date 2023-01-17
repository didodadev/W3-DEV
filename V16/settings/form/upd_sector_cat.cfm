<cf_xml_page_edit fuseact="settings.form_upd_sector_cat" is_multi_page="1">

<cfquery name="GET_SECTOR_CATS_COMP" datasource="#DSN#" maxrows="1">
	SELECT
		SECTOR_CAT_ID
	FROM
		COMPANY
	WHERE
		SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sector_cat_id#">
</cfquery>
<cfquery name="CAT" datasource="#DSN#">
	SELECT 
		SETUP_SECTOR_CATS.SECTOR_CAT_ID, 
		SETUP_SECTOR_CATS.SECTOR_UPPER_ID, 
		#dsn#.Get_Dynamic_Language(SETUP_SECTOR_CATS.SECTOR_CAT_ID,'#session.ep.language#','SETUP_SECTOR_CATS','SECTOR_CAT',NULL,NULL,SETUP_SECTOR_CATS.SECTOR_CAT) AS SECTOR_CAT,
		SETUP_SECTOR_CATS.SECTOR_LIMIT, 
		SETUP_SECTOR_CATS.IS_INTERNET, 
		SETUP_SECTOR_CATS.SECTOR_IMAGE, 
		SETUP_SECTOR_CATS.SERVER_SECTOR_IMAGE_ID, 
		SETUP_SECTOR_CATS.RECORD_EMP, 
		SETUP_SECTOR_CATS.RECORD_DATE, 
		SETUP_SECTOR_CATS.RECORD_IP, 
		SETUP_SECTOR_CATS.UPDATE_EMP, 
		SETUP_SECTOR_CATS.UPDATE_DATE, 
		SETUP_SECTOR_CATS.UPDATE_IP,
		SETUP_SECTOR_CATS.SECTOR_CAT_CODE,
		SETUP_SECTOR_CAT_UPPER.SECTOR_CAT_CODE AS UPPER_SECTOR_CAT_CODE
	FROM 
		SETUP_SECTOR_CATS 
		LEFT JOIN SETUP_SECTOR_CAT_UPPER ON SETUP_SECTOR_CATS.SECTOR_UPPER_ID = SETUP_SECTOR_CAT_UPPER.SECTOR_UPPER_ID
	WHERE 
		SETUP_SECTOR_CATS.SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sector_cat_id#">
</cfquery>
<cf_box title="#getLang('','Sektör Kategorisi Güncelle',42632)#" uidrop="1" add_href="#request.self#?fuseaction=settings.form_add_sector_cat">
<cfform action="#request.self#?fuseaction=settings.emptypopup_sector_cat_upd" method="post" name="upd_sector_cat" enctype="multipart/form-data">

        <cf_box_elements>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
				<div class="form-group">
                    <label class="col col-4  col-xs-12"><cf_get_lang dictionary_id='43647.Üst Sektör'></label>
					<cfinclude template="../query/get_sector_cat_upper.cfm">
                    <div class="col col-8  col-xs-12">
                        <select name="sector_upper" id="sector_upper"  onchange="put_upper_code();">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="get_sector_cat_upper">
                                <option value="#sector_upper_id#"<cfif cat.sector_upper_id eq sector_upper_id>selected</cfif>>#sector_cat#</option>
                            </cfoutput>
                        </select>
					</div>
                </div>
				<div class="form-group">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58585.Kod'></label>
                    <div class="col col-4 col-xs-12"> 
						<input type="text" name="upper_sector_cat_code" id="upper_sector_cat_code" value="<cfoutput>#cat.upper_sector_cat_code#</cfoutput>" readonly="readonly" />
					</div>
					<div class="col col-4 col-xs-12"> 
            			<input type="text" name="sector_cat_code" id="sector_cat_code" onkeyup="isNumber(this);" value="<cfoutput>#cat.sector_cat_code#</cfoutput>" />
                    </div>
                </div>
				<div class="form-group" >
					<label class="col col-4  col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'> *</label>
					   <div class="col col-8  col-xs-12"> 
					   <div class="input-group"> 
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık girmelisiniz'></cfsavecontent>
							<cfinput type="Text" name="sector_cat" id="sector_cat"  value="#cat.sector_cat#" maxlength="255" required="Yes" message="#message#">
							<span class="input-group-addon "><cf_language_info 
								table_name="SETUP_SECTOR_CATS" 
								column_name="SECTOR_CAT" 
								column_id_value="#sector_cat_id#" 
								maxlength="500" 
								datasource="#dsn#" 
								column_id="SECTOR_CAT_ID" 
								control_type="0">
							</span>
						</div>
						</div>
				</div>
				<div class="form-group" >
					<label class="col col-4  col-xs-12"><cf_get_lang dictionary_id='54820.Limit'></label>
					   <div class="col col-8  col-xs-12"> 
						<cfinput type="text" name="sector_limit" id="sector_limit" value="#cat.sector_limit#"  onKeyUp="return(FormatCurrency(this,event));">
						</div>
				</div>
				<div class="form-group" >
					<label class="col col-4  col-xs-12"><cf_get_lang dictionary_id='29762.İmaj'></label>
					   <div class="col col-8  col-xs-12"> 
						<input type="file" name="sector_image" id="sector_image">
						</div>
				</div>
				<div class="form-group" >
					<label class="col col-4  col-xs-12"></label>
					   <div class="col col-8  col-xs-12"> 
						<input type="checkbox" name="is_internet" id="is_internet" <cfif cat.is_internet eq 1>checked </cfif>> <cf_get_lang dictionary_id='43478.İnternette Yayımlansın'>
						</div>
				</div>
			</div>
		</cf_box_elements>

	<cf_box_footer>
		
				<div class="form-group" >
					<cfif len(cat.sector_image)>
						<tr class="color-border">
						<cfoutput query="cat">
							<td colspan="2">
								<cf_get_server_file output_file="settings/#sector_image#" output_server="#cat.server_sector_image_id#" output_type="0" image_width="295" image_height="200">
							</td>
						</cfoutput>
						</tr>
					</cfif>
				</div> 
				<cf_record_info query_name="cat" >
			<cfif get_sector_cats_comp.recordcount>
				<cf_workcube_buttons is_upd='1' is_delete='0' add_function="check_catid()">
			<cfelse>
				<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_sector_cat_del&sector_cat_id=#url.sector_cat_id#' add_function="check_catid()">
			</cfif>
	
	</cf_box_footer>

</cfform>
</cf_box>


<script type="text/javascript">
	function put_upper_code()
	{
		upper_sector_id = document.getElementById("sector_upper").options[document.getElementById("sector_upper").selectedIndex].value;
		if (!upper_sector_id == '')
			{
			query = 'SELECT SECTOR_CAT_CODE FROM SETUP_SECTOR_CAT_UPPER WHERE SECTOR_UPPER_ID = ' + upper_sector_id;
			result = wrk_query(query,'dsn','10');
			document.getElementById('upper_sector_cat_code').value = result.SECTOR_CAT_CODE;
			}
		else
			document.getElementById('upper_sector_cat_code').value = '';
	}
	function check_catid()
	{
		selected_upper_sector_id = document.getElementById("sector_upper").options[document.getElementById("sector_upper").selectedIndex].value;
		input_sector_code = document.getElementById('sector_cat_code').value;
		if (selected_upper_sector_id == '' && input_sector_code == '')
		{
		return true;
		}
		input_upper_code = document.getElementById('upper_sector_cat_code').value;
		upper_sector_code = <cfif len (cat.UPPER_SECTOR_CAT_CODE)><cfoutput>#cat.UPPER_SECTOR_CAT_CODE#</cfoutput><cfelse>''</cfif>;
		sector_code = <cfif len (cat.SECTOR_CAT_CODE)><cfoutput>#cat.SECTOR_CAT_CODE#</cfoutput><cfelse>''</cfif>;
		if ( input_upper_code == upper_sector_code && input_sector_code == sector_code )
		{
		return true;
		}
		sector_code_query = 'SELECT SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_UPPER_ID = ' + selected_upper_sector_id + ' AND SECTOR_CAT_CODE = ' + input_sector_code ;
		if (input_upper_code == '' && input_sector_code != '' )
		{
		<cfif xml_is_uppercat_required eq 1> //Üst Kategorisi yok ise alt sektör kod kontrolü yapılsınmı
		return true;
		<cfelse>
		sector_code_query = 'SELECT SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_UPPER_ID IS NULL AND SECTOR_CAT_CODE = ' + input_sector_code;
		</cfif>
		}
		sector_result = wrk_query(sector_code_query,'dsn','10');
		if (sector_result.recordcount > 0)
		{
		alert('Alt Sektör Kodu Mevcuttur Lütfen Değiştirin');
		return false;
		}
	}
</script>


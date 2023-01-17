<cfquery name="get_care_cats" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		SETUP_CARE_CAT
	ORDER BY	
		HIERARCHY
</cfquery>
<cfquery name="get_care" datasource="#DSN#">
	SELECT 
		*
	FROM 
		SETUP_CARE_CAT
	WHERE 
		CARE_CAT_ID=#URL.ID#
</cfquery>
<!--- <cfdump var="#get_care#" > --->
<cfparam name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box id="item_upd" title="#getLang('','Bakım Kategorileri','42903')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform  name="upd_care_cat" method="post" action='#request.self#?fuseaction=settings.care_cat_upd'>
			<input type="hidden" id="counter" name="counter">
			<input type="hidden" name="care_cat_id" id="care_cat_id" value="<cfoutput>#url.id#</cfoutput>">
			<input type="hidden" name="oldHierarchy" id="oldHierarchy" value="<cfoutput>#get_care.hierarchy#</cfoutput>">
			<cfset cat_code=listlast(get_care.hierarchy,".")>
			<cfset ust_cat_code=listdeleteat(get_care.hierarchy,ListLen(get_care.hierarchy,"."),".")>
			<input type="hidden" name="product_cat_code_old" id="product_cat_code_old" value="<cfoutput>#cat_code#</cfoutput>">
			<cf_box_elements>
				<div class="col col-6 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                    <div class="form-group" id="item-category">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29736.Üst Kategori'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="hierarchy" id="hierarchy" name="hierarchy" onChange="document.upd_care_cat.head_cat_code.value=document.upd_care_cat.hierarchy[document.upd_care_cat.hierarchy.selectedIndex].value;" style="width:200px;">
								<option value=""<cfif ust_cat_code eq "">selected</cfif>><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_care_cats">
									<cfif hierarchy is not get_care.hierarchy>
										<option value="#hierarchy#"<cfif ust_cat_code eq hierarchy and len(ust_cat_code) eq len(hierarchy)> selected</cfif>>#hierarchy# #care_cat#</option>
									</cfif>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-head_cat_code">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43389.Kategori Kodu'> *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <input type="text" name="head_cat_code" id="head_cat_code" value="<cfoutput>#ust_cat_code#</cfoutput>" disabled>
                            </div>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='43390.Kategori Kodu Girmelisiniz'></cfsavecontent>
                                <cfinput type="text" name="care_cat_code" id="care_cat_code" value="#cat_code#" maxlength="50" required="yes" message="#message#">
                            </div>
                        </div>
                    </div>
					<div class="form-group" id="item-care_cat">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="care_cat" id="care_cat" value="#get_care.care_cat#" maxlength="50" required="Yes" message="#message#">
								<span class="input-group-addon">
									<cf_language_info	
									table_name="SETUP_CARE_CAT"
									column_name="CARE_CAT" 
									column_id_value="#URL.ID#" 
									maxlength="500" 
									datasource="#dsn#" 
									column_id="CARE_CAT_ID" 
									control_type="0">
								</span>
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-detail">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <textarea name="detail" id="detail" style="width:200px;height:40px;" maxlength="100" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 100"><cfoutput>#get_care.detail#</cfoutput></textarea>
                        </div>
                    </div>
				</div>
            </cf_box_elements>
            <cf_box_footer>
				<cf_record_info query_name="get_care">
                <cf_workcube_buttons is_upd='1' is_delete='0' add_function='form_check();kontrol()'>
            </cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function form_check()
{
	x = (100 - upd_care_cat.detail.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='57629.Açıklama'>"+ ((-1) * x) +" <cf_get_lang dictionary_id='29538.Karakter Uzun'>");
		return false;
	}

	our_pro_str=upd_care_cat.care_cat_code.value;
	for(;;)
	{
			if (our_pro_str.search(" ") != -1){      
				our_pro_str = our_pro_str.replace(" ","");
				upd_care_cat.care_cat_code.value = our_pro_str;
			}else{
				break;
			}
	}
	
	if (upd_care_cat.care_cat_code.value.indexOf('.') != -1)
	{
		alert("<cf_get_lang dictionary_id='43391.Ürün özel kategori kodu içeremez'>");
		return false;
	}
	if (upd_care_cat.care_cat_code.value != upd_care_cat.product_cat_code_old.value)	
	{	
		if (confirm("<cf_get_lang dictionary_id='43819.Kategori Kodunda Yaptığınız Değişiklik Stok Hiyerarşisinin Bozulmasına ve Veri Kaybına Neden Olabilir! Devam Etmek İstiyor musunuz'>?")) 
			{
				return true;
			}	
		else 
			{
			return false;
			}
	}		
	else
	{
		return true;
	}	
}
</script>

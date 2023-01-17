<cfquery name="GET_INVENTORY_CAT" datasource="#DSN3#">
	SELECT 
	    INVENTORY_CAT_ID, 
		#dsn#.Get_Dynamic_Language(INVENTORY_CAT_ID,'#session.ep.language#','SETUP_INVENTORY_CAT','INVENTORY_CAT',NULL,NULL,INVENTORY_CAT) AS INVENTORY_CAT,
        AMORTIZATION_RATE, 
        INVENTORY_DURATION, 
		#dsn#.Get_Dynamic_Language(INVENTORY_CAT_ID,'#session.ep.language#','SETUP_INVENTORY_CAT','DETAIL',NULL,NULL,DETAIL) AS DETAIL,
        HIERARCHY, 
        SPECIAL_CODE, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP 
    FROM 
    	SETUP_INVENTORY_CAT 
    WHERE 
    	INVENTORY_CAT_ID = #attributes.inv_cat_id#
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='34247.Sabit Kıymet Kategorileri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_inventory_cat" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_inventory_cats.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="upd_inventory" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_inventory_cat">
				<cfinput type="hidden" name="inventory_cat_id_" id="inventory_cat_id_" value="#get_inventory_cat.inventory_cat_id#">
				<cfinput type="hidden" name="old_hierarchy" id="old_hierarchy" value="#get_inventory_cat.hierarchy#">
				<cfset cat_code=listlast(get_inventory_cat.hierarchy,".")>
					<cfif len(cat_code)>
						<cfset ust_cat_code=listdeleteat(get_inventory_cat.hierarchy,ListLen(get_inventory_cat.hierarchy,"."),".")>
					<cfelse>
						<cfset ust_cat_code=''>
					</cfif>
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="upper-cat">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29736.Üst Kategori'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="upper_cat" id="upper_cat" onChange="upper_hier();">
									<option value=""<cfif ust_cat_code eq "">selected</cfif>><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="GET_ALL_INVENTORY_CATS">
										<option value="#HIERARCHY#"<cfif ust_cat_code eq hierarchy and len(ust_cat_code) eq len(hierarchy)> selected</cfif>>#INVENTORY_CAT#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="cat-code">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43389.Kategori Kodu'>*</label>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<cfinput type="text" name="hierarchy1" value="#ust_cat_code#" readonly/>
                        		<cfsavecontent variable="message"><cf_get_lang dictionary_id='44853.Kategori Kodu Girmelisiniz!'></cfsavecontent>
							</div>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<cfinput type="text" name="hierarchy2" value="#cat_code#" required="yes" message="#message#">
							</div>
						</div>
						<div class="form-group" id="cat-name">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37163.Kategori Adı'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'>!</cfsavecontent>
								<div class="input-group">
									<cfinput type="text" name="inventory_cat_name" value="#get_inventory_cat.inventory_cat#" maxlength="100" required="yes" message="#message#">
									<span class="input-group-addon">
										<cf_language_info
										table_name="SETUP_INVENTORY_CAT"
										column_name="INVENTORY_CAT" 
										column_id_value="#attributes.inv_cat_id#" 
										maxlength="500" 
										datasource="#DSN3#" 
										column_id="INVENTORY_CAT_ID" 
										control_type="2"> 
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="inventory_duration">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='44577.Faydalı Ömür'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='44579.Sabit Kıymet İçin Faydalı Ömür Girmelisiniz'>!</cfsavecontent>
								<cfinput type="text" name="inventory_duration" value="#TLFormat(get_inventory_cat.inventory_duration)#" maxlength="5" validate="integer" required="yes" message="#message#">
							</div>
						</div>
						<div class="form-group" id="amortization_rate">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='44578.Amortisman Oranı'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='56988.Amortisman Oranı giriniz'>!</cfsavecontent>
								<cfinput type="text" name="amortization_rate" value="#TLFormat(get_inventory_cat.amortization_rate)#" maxlength="5" validate="integer" required="yes" message="#message#">
							</div>
						</div>
						<div class="form-group" id="special_code">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" name="special_code" value="#get_inventory_cat.special_code#" maxlength="50">
							</div>
						</div>
						<div class="form-group" id="detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<textarea name="detail" id="detail" style="height:100px;" maxlength="200" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#getLang('','Maksimum Karakter En Fazla 500 Karakter Olabilir',45174)#</cfoutput>"><cfoutput>#get_inventory_cat.detail#</cfoutput></textarea>
									<span class="input-group-addon">
										<cf_language_info
										table_name="SETUP_INVENTORY_CAT"
										column_name="DETAIL" 
										column_id_value="#attributes.inv_cat_id#" 
										maxlength="500" 
										datasource="#DSN3#" 
										column_id="INVENTORY_CAT_ID" 
										control_type="2"> 
									</span>
								</div>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_record_info query_name="get_inventory_cat">
					<cf_workcube_buttons is_upd='1' is_delete='0' add_function='controlInventroyCode()'>
				</cf_box_footer>
			</cfform>
    	</div>
  	</cf_box>
</div>
<script type="text/javascript">
	function upper_hier()
	{
		document.upd_inventory.hierarchy1.value=document.upd_inventory.upper_cat[document.upd_inventory.upper_cat.selectedIndex].value
	}
	function controlInventroyCode()
	{
		if(document.upd_inventory.hierarchy1.value != "")
			{code_ = document.upd_inventory.hierarchy1.value+'.'+document.upd_inventory.hierarchy2.value;}
		else
			{code_ = document.upd_inventory.hierarchy2.value;}
		
		var listParam = "<cfoutput>#attributes.inv_cat_id#</cfoutput>" + "*" + code_;
		var get_inventory_ =  wrk_safe_query("set_get_inventory_2",'dsn3',0,listParam);
		if (get_inventory_.recordcount)
		{
			alert("<cf_get_lang dictionary_id='44854.Bu Kod Kullanılmakta; Başka Kod Kullanınız'>");
			return false;
		}
	}
</script>











<cfquery name="GET_PACKAGE_TYPE_ID" datasource="#DSN2#">
	SELECT
		PACKAGE_TYPE
	FROM
		SHIP_RESULT_PACKAGE
	WHERE
		PACKAGE_TYPE = #url.type_id#
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Paket Tipleri',42140)#" add_href="#request.self#?fuseaction=settings.add_package_type" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_package_type.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="upd_package_type" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_package_type" onsubmit="return(change_dimension());">
			<input type="hidden" name="package_type_id" id="package_type_id" value="<cfoutput>#url.type_id#</cfoutput>">
			<cfquery name="GET_PACKAGE_TYPE" datasource="#DSN#">
					SELECT
						#dsn#.Get_Dynamic_Language(PACKAGE_TYPE_ID,'#session.ep.language#','SETUP_PACKAGE_TYPE','PACKAGE_TYPE',NULL,NULL,PACKAGE_TYPE) AS PACKAGE_TYPE,
						#dsn#.Get_Dynamic_Language(PACKAGE_TYPE_ID,'#session.ep.language#','SETUP_PACKAGE_TYPE','DETAIL',NULL,NULL,DETAIL) AS DETAIL,
						* 
					FROM 
						SETUP_PACKAGE_TYPE
					WHERE 
						PACKAGE_TYPE_ID = #url.type_id#
			</cfquery>	
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="package_type">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42468.Paket Tipi'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="text" name="package_type" id="package_type" value="<cfoutput>#get_package_type.package_type#</cfoutput>" maxlength="20">						
									<span class="input-group-addon">
										<cf_language_info 
											table_name="SETUP_PACKAGE_TYPE" 
											column_name="PACKAGE_TYPE" 
											column_id_value="#url.type_id#" 
											maxlength="500" 
											datasource="#dsn#" 
											column_id="PACKAGE_TYPE_ID" 
											control_type="0">
									</span>
								</div>
							</div>	
						</div>
						<div class="form-group" id="calculate_type">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43003.Hesaplama Yöntemi'>*</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<select name="calculate_type" id="calculate_type">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<option value="1" <cfif get_package_type.calculate_type_id eq 1> selected</cfif>><cf_get_lang dictionary_id='43004.Desi'></option>
										<option value="2" <cfif get_package_type.calculate_type_id eq 2> selected</cfif>><cf_get_lang dictionary_id='43005.Kg'></option>
										<option value="3" <cfif get_package_type.calculate_type_id eq 3> selected</cfif>><cf_get_lang dictionary_id='42540.Zarf'></option>
									</select>
								</div>
						</div>
						<div class="form-group" id="dimension">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42999.Boyut (a*b*h)'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input type="hidden" name="dimension" id="dimension">
									<cfif len(get_package_type.dimention)>
										<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
											<input type="text" name="dimension1" id="dimension1" value="<cfoutput>#TlFormat(listgetat(get_package_type.dimention,1,'*'),0)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,0));" maxlength="4" class="moneybox">
										</div>
										<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
											<input type="text" name="dimension2" id="dimension2" value="<cfoutput>#TlFormat(listgetat(get_package_type.dimention,2,'*'),0)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,0));" maxlength="4" class="moneybox">
										</div>
										<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
											<input type="text" name="dimension3" id="dimension3" value="<cfoutput>#TlFormat(listgetat(get_package_type.dimention,3,'*'),0)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,0));" maxlength="4" class="moneybox">	
										</div>
									<cfelse>
										<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
											<input type="text" name="dimension1" id="dimension1" value="" onkeyup="return(FormatCurrency(this,event,0));" maxlength="4" class="moneybox">
										</div>
										<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
											<input type="text" name="dimension2" id="dimension2" value="" onkeyup="return(FormatCurrency(this,event,0));" maxlength="4" class="moneybox">
										</div>
										<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
											<input type="text" name="dimension3" id="dimension3" value="" onkeyup="return(FormatCurrency(this,event,0));" maxlength="4" class="moneybox">	
										</div>
									</cfif>
								</div>
						</div>
						<div class="form-group" id="package_type">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29784.Ağırlık'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" name="weight" passthrough = "onkeyup='FormatCurrency(this,event,3)'" value="#TLFormat(get_package_type.weight,3)#" class="moneybox">
							</div>	
						</div>
						<div class="form-group" id="package_type">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								
								<div class="input-group">
									<textarea name="detail" id="detail" cols="75" maxlength="50" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı :50"><cfoutput>#get_package_type.detail#</cfoutput></textarea>
									<span class="input-group-addon">
										<cf_language_info 
											table_name="SETUP_PACKAGE_TYPE" 
											column_name="DETAIL" 
											column_id_value="#url.type_id#" 
											maxlength="500" 
											datasource="#dsn#" 
											column_id="PACKAGE_TYPE_ID" 
											control_type="0">
									</span>
								</div>
							</div>	
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_record_info query_name="get_package_type">
					<cfif get_package_type_id.recordcount>
						<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
					<cfelse>
						<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_package_type&type_id=#URL.TYPE_ID#' add_function='kontrol()'>
					</cfif>
				</cf_box_footer>
			</cfform>
				
    	</div>
  	</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if(document.upd_package_type.package_type.value == "")
		{
			alert("<cf_get_lang dictionary_id='42006.Paket Tipi Girmelisiniz'>!");
			return false;
		}
	
		x = document.upd_package_type.calculate_type.selectedIndex;
		if(document.upd_package_type.calculate_type[x].value == "")
		{ 
			alert("<cf_get_lang dictionary_id='43357.Hesaplama Yöntemi Seçiniz'>!");
			return false;
		}
		
		if(document.upd_package_type.calculate_type[x].value == 1)
		{
			if(document.upd_package_type.dimension1.value =="" || document.upd_package_type.dimension1.value ==0)
			{
				alert ("<cf_get_lang dictionary_id='43000.Boyut Değerlerinizi Kontrol Ediniz'>!");
				upd_package_type.dimension1.focus();
				return false;
			}
			
			if(document.upd_package_type.dimension2.value =="" || document.upd_package_type.dimension2.value ==0)
			{
				alert ("<cf_get_lang dictionary_id='43000.Boyut Değerlerinizi Kontrol Ediniz'>!");
				upd_package_type.dimension2.focus();
				return false;
			}
			
			if(document.upd_package_type.dimension3.value =="" || document.upd_package_type.dimension3.value ==0)
			{
				alert ("<cf_get_lang dictionary_id='43000.Boyut Değerlerinizi Kontrol Ediniz'>!");
				upd_package_type.dimension3.focus();
				return false;
			}		
		}
		$('#weight').val(filterNum($('#weight').val()));
	
		
		return true;
	}
	
	function change_dimension()
	{
		y = document.upd_package_type.calculate_type.selectedIndex;
		if(document.upd_package_type.calculate_type[x].value == 1)
			document.upd_package_type.dimension.value = filterNum(document.upd_package_type.dimension1.value) + '*' + filterNum(document.upd_package_type.dimension2.value) + '*' + filterNum(document.upd_package_type.dimension3.value);
		else
			document.upd_package_type.dimension.value = '';
	}
	</script>

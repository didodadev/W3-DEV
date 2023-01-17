<cffile action="read" file="#index_folder#admin_tools#dir_seperator#xml#dir_seperator#units.xml" variable="xmldosyam" charset = "UTF-8">
<cfset dosyam = XmlParse(xmldosyam)>
<cfset xml_dizi = dosyam.SETUP_UNITS.XmlChildren>
<cfset d_boyut = ArrayLen(xml_dizi)>
<cfquery name="GET_SETUP_EFATURA" datasource="#DSN#">
	SELECT IS_EFATURA FROM OUR_COMPANY_INFO WHERE IS_EFATURA = 1
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box collapsable="0" resize="0">
		<cfform action="#request.self#?fuseaction=product.unit_add" method="post" name="add_unit">
			<cf_box_elements vertical="0">
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-unit">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37190.Birim Adı'> *</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="Text" name="unit" value="" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-unit_code">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59289.UNECE standardı'><cfif get_setup_efatura.recordcount>*</cfif></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="unit_code" id="unit_code">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> !</option>
								<cfloop index="i" from ="1" to="#d_boyut#"><cfoutput>
									<option value="#dosyam.SETUP_UNITS.UNITS[i].UNIT_NAME.XmlText#,#dosyam.SETUP_UNITS.UNITS[i].UNIT_CODE.XmlText#">#dosyam.SETUP_UNITS.UNITS[i].UNIT_NAME.XmlText#</option>
								</cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons type_format='1' is_upd='0' add_function='check_code()'>
			</cf_box_footer>			
		</cfform>	
	</cf_box>
</div>
<script type="text/javascript">
function check_code()
{
		
	if($('#unit').val() == '')
	{
		alert("<cf_get_lang dictionary_id='36750.Birim Adı Girmelisiniz'>!");	
		return false;
	}
	<cfif GET_SETUP_EFATURA.recordcount> 
	
	if($('#unit_code').val() == '')
	{
		alert("<cf_get_lang dictionary_id='60493.UNECE Standart Değerini Seçiniz'>!");	
		return false;
	}
	</cfif>
}
</script>

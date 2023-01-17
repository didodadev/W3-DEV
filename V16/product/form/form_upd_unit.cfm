<cffile action="read" file="#index_folder#admin_tools#dir_seperator#xml#dir_seperator#units.xml" variable="xmldosyam" charset = "UTF-8">
<cfset dosyam = XmlParse(xmldosyam)>
<cfset xml_dizi = dosyam.SETUP_UNITS.XmlChildren>
<cfset d_boyut = ArrayLen(xml_dizi)>
<cfquery name="get_our_companies" datasource="#dsn#">
	SELECT COMP_ID FROM OUR_COMPANY
</cfquery>
<cfset kontrol_degiskeni = 0>
<cfloop query="get_our_companies">
	<cfset newdsn = '#dsn#_#comp_id#'>
	<cfquery name="get_pro" datasource="#newdsn#" maxrows="1">
		SELECT UNIT_ID FROM PRODUCT_UNIT WHERE UNIT_ID = #url.id#
	</cfquery>
	<cfif get_pro.recordcount>
		<cfset kontrol_degiskeni = 1>
		<cfbreak>
	</cfif>
</cfloop>
<cfquery name="GET_SETUP_EFATURA" datasource="#DSN#">
	SELECT IS_EFATURA FROM OUR_COMPANY_INFO WHERE IS_EFATURA = 1
</cfquery>
<cfsavecontent variable="txt">
    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_form_add_unit"><img src="/images/plus1.gif" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></a>
</cfsavecontent>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box collapsable="0" resize="0">
        <cfform action="#request.self#?fuseaction=product.unit_upd" method="post" name="upd_unit">
            <cfquery name="categories" datasource="#dsn#">
                SELECT 
                    #dsn#.Get_Dynamic_Language(UNIT_ID,'#session.ep.language#','SETUP_UNIT','UNIT',NULL,NULL,UNIT) AS UNIT,
                    UNIT_CODE,
                    RECORD_DATE,
                    RECORD_EMP,
                    UPDATE_DATE,
                    UPDATE_EMP 
                FROM 
                    SETUP_UNIT 
                WHERE 
                    UNIT_ID = #url.id#
            </cfquery>
            <input type="hidden" name="unit_id" id="unit_id" value="<cfoutput>#url.id#</cfoutput>">
            <cf_box_elements vertical="0">
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-unit">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37190.Birim Adı'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif kontrol_degiskeni>
                                    <cfinput type="text" name="unit" size="20" value="#categories.unit#" maxlength="50" readonly="true">
                                <cfelse>
                                    <cfinput type="text" name="unit" size="20" value="#categories.unit#" maxlength="50">
                                </cfif>
                                <span class="input-group-addon">
                                    <cf_language_info 
                                        table_name="SETUP_UNIT" 
                                        column_name="UNIT" 
                                        column_id_value="#url.id#" 
                                        maxlength="43" 
                                        datasource="#dsn#" 
                                        column_id="UNIT_ID" 
                                        control_type="0">
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-unit_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59289.UNECE standardı'><cfif get_setup_efatura.recordcount>*</cfif></label>
                        <div class="col col-8 col-xs-12">
                            <select name="unit_code" id="unit_code">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> !</option>
                                <cfloop index="i" from ="1" to="#d_boyut#"><cfoutput>
                                    <option value="#dosyam.SETUP_UNITS.UNITS[i].UNIT_NAME.XmlText#,#dosyam.SETUP_UNITS.UNITS[i].UNIT_CODE.XmlText#" <cfif dosyam.SETUP_UNITS.UNITS[i].UNIT_CODE.XmlText eq categories.unit_code>selected</cfif>>#dosyam.SETUP_UNITS.UNITS[i].UNIT_NAME.XmlText#</option>
                                </cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <cfif kontrol_degiskeni>
                        <div class="col col-12 font-red bold">
                            <cf_get_lang dictionary_id='60496.Bu Birim Ürünlerde Kullanıldığı İçin Birim Adı Güncellenemez'>!
                        </div>
                    </cfif>
                </div>
            </cf_box_elements>                
            <div class="ui-form-list-btn">
				<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                    <cf_record_info query_name="categories">
                </div>
                <div class="col col-6 col-md-4 col-sm-4 col-xs-12">
                    <cfif kontrol_degiskeni>
                        <!--- Urunde Kullanilmissa Guncelleme ve Silme Yapilmaz --->
                        <cf_workcube_buttons type_format='1' is_upd='1' is_delete='0' add_function='check_code()'>
                    <cfelse>
                        <cf_workcube_buttons type_format='1' is_upd='1' add_function='check_code()' delete_page_url='#request.self#?fuseaction=product.unit_del&unit_id=#URL.ID#'> 
                    </cfif>
                </div>
            </div>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function check_code()
{
		
	if($('#unit').val() == '')
	{
		alert("<cf_get_lang dictionary_id='36750.Birim Adı Girmelisiniz'>"!);	
		return false;
	}
	<cfif get_setup_efatura.recordcount>  
	if($('#unit_code').val() == '')
	{
		alert(<cf_get_lang dictionary_id='60493.UNECE Standart Değerini Seçiniz'>!");	
		return false;
	}
	</cfif>
}
</script>

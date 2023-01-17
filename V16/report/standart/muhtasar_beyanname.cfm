<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.sal_mon" default="#month(now())#">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.ssk_office" default="">
<cfparam name="attributes.companyid" default="">

<cfset upload_folder = '#GetDirectoryFromPath(GetCurrentTemplatePath())#..#dir_seperator#..#dir_seperator#admin_tools#dir_seperator#'>
<cffile action="read" variable="xmldosyam" file="#upload_folder#xml#dir_seperator#setup_process_cat.xml" charset = "UTF-8">
<cfset dosyam = XmlParse(xmldosyam)>
<cfset xml_dizi = dosyam.workcube_process_types.XmlChildren>
<cfset d_boyut = ArrayLen(xml_dizi)>

<cf_xml_page_edit fuseact="report.muhtasar_beyanname">

<cfobject name="muhtasar_beyan" type="component" component="V16.report.cfc.muhtasar_beyan">
<cfobject name="program_parameters" type="component" component="V16.hr.ehesap.cfc.get_program_parameters">
<cfset program_parameters.dsn = dsn>

<cfinclude template="../../hr/ehesap/query/export_muhtasar_xml.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<!--- islem tipleri --->
<cf_box title="#getlang('','Muhtasar SGK Beyan Hazırlama Raporu',888)#">
    <cfform name="rapor" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
        <div class="ui-form-list flex-list">
            <div class="form-group">
                <select name="sal_mon" id="sal_mon">
                    <cfloop from="1" to="12" index="i">
                        <cfoutput>
                            <option value="#i#"<cfif attributes.sal_mon eq i> selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                        </cfoutput>
                    </cfloop>
                </select>
            </div>
            <div class="form-group medium">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58455.Yıl'></cfsavecontent>
                <input type="text" name="sal_year" id="sal_year" value="<cfoutput>#attributes.sal_year#</cfoutput>" style="width:50px;" required="yes" validate="integer" range="1900,2100" maxlength="4" message="<cfoutput>#message#</cfoutput>">
			</div>
			<div class="form-group medium">
				<cfinclude template="../../hr/ehesap/query/get_ssk_offices.cfm">
				<select name="ssk_office">
					<cfoutput query="get_ssk_offices">
						<option value="#branch_id#" <cfif isdefined("attributes.ssk_office") and listfind(attributes.ssk_office,branch_id)>selected</cfif>>#BRANCH_NAME# (#ssk_office# - #ssk_no#)</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group medium">
				<cfset query_ourcompany = muhtasar_beyan.get_ourcompany()>
				<select name="companyid">
					<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
					<cfoutput query="query_ourcompany">
						<option value="#COMP_ID#" <cfif attributes.companyid eq COMP_ID>selected</cfif>>#COMPANY_NAME#</option>
					</cfoutput>
				</select>
			</div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4" is_excel="0" is_excelbuton="0" is_wordbuton="0" is_pdfbuton="0" is_mailbuton="0" is_printbuton="0" search_function="kontrol()">
            </div>
        </div>
    
    </cfform>

	
	<cfif get_module_user(48)>
		<cfsavecontent variable="header"><cf_get_lang dictionary_id='60778.SGK Bildirimleri'></cfsavecontent>
		<cf_seperator id="spr_sgk" header="#header#">
		<cf_grid_list id="spr_sgk">
			<thead>
				<tr>
					<cfloop list="#header_list#" index="name_" delimiters=";">
						<cfoutput><th>#name_#</th></cfoutput>
					</cfloop>
				</tr>
			</thead>
			<tbody>
			<cfloop from="1" to="#rowCount#" index="row">
				<cfoutput>
				<cfset satir_ = listgetat(row_list,row,CRLF)>
				<cfset satir_ = replace(satir_,';;',';-;','all')>
				<cfset satir_ = replace(satir_,';;',';-;','all')>
				<cfset kol_ = listlen(satir_,';')>
				<tr>
					<cfloop from="1" to="#kol_#" index="col">
						<cfset deger_ = listgetat(satir_,col,';')>
						<cfset type_ = listgetat(h_type_list,col,';')>
						<td style="text-align:<cfif type_ is 'float'>right<cfelse>left</cfif>;"><cfif type_ is 'float' and isnumeric(deger_)>#tlformat(deger_)#<cfelse>#deger_#</cfif></td>
					</cfloop>
				</tr>
				</cfoutput>
			</cfloop>
			</tbody>
		</cf_grid_list>
		<cfsavecontent variable="header"><cf_get_lang dictionary_id='60779.İstihdam Teşvikleri'></cfsavecontent>
		<cf_seperator id="spr2" header="#header#">
		<cf_grid_list id="spr2">
			<thead>
				<tr>
					<cfloop list="#header_list_7103#" index="name_" delimiters=";">
						<cfoutput><th>#name_#</th></cfoutput>
					</cfloop>
				</tr>
			</thead>
			<tbody>
			<cfloop from="1" to="#rowCount_7103#" index="row">
				<cfoutput>
				<cfset satir_ = listgetat(row_list_7103,row,CRLF)>
				<cfset satir_ = replace(satir_,';;',';-;','all')>
				<cfset satir_ = replace(satir_,';;',';-;','all')>
				<cfset kol_ = listlen(satir_,';')>
				<tr>
					<cfloop from="1" to="#kol_#" index="col">
						<cfset deger_ = listgetat(satir_,col,';')>
						<cfset type_ = listgetat(h_type_list_7103,col,';')>
						<td style="text-align:<cfif type_ is 'float'>right<cfelse>left</cfif>;"><cfif type_ is 'float' and isnumeric(deger_)>#tlformat(deger_)#<cfelse>#deger_#</cfif></td>
					</cfloop>
				</tr>
				</cfoutput>
			</cfloop>
			</tbody>
		</cf_grid_list>
		<!--- Muhtasarda belge kayıt edilmiş mi kontrol --->
		<cfset get_xml_cmp = createObject("component","V16.report.cfc.taxstatement_declaration")>
		<cfset get_ssk_xml_exports = get_xml_cmp.GET_SSK_XML_EXPORTS(
			sal_mon: attributes.sal_mon,
			sal_year: attributes.sal_year,
			ssk_office: attributes.ssk_office
		)>

		<cfif get_ssk_xml_exports.recordCount neq 0>
			<div class="ui-form-list-btn flex-start">
				<cfoutput>
					<div>
						<a href="#file_web_path#hr#dir_seperator#emuhtasar#dir_seperator##get_ssk_xml_exports.file_name#" class="ui-btn ui-btn-success"><cf_get_lang dictionary_id="60680.Muhtasar TXT Export Dosyası!"></a>
					</div>
					<div>
						<a href="#file_web_path#hr#dir_seperator#emuhtasar#dir_seperator##get_ssk_xml_exports.excel_file_name#" class="ui-btn ui-btn-success"><cf_get_lang dictionary_id="60679.Muhtasar CSV Export Dosyası!"></a>
					</div>
					<div>
						<a href="#file_web_path#hr#dir_seperator#emuhtasar#dir_seperator##get_ssk_xml_exports.EXCEL_XLS_FILE_NAME#" class="ui-btn ui-btn-success"><cf_get_lang dictionary_id='61588.E-bildirge CSV Dosyası'></a>
					</div>
					<!--- <input type="button" value="Muhtasar TXT Export Dosyası!" onclick="window.location.href='index.cfm?fuseaction=objects.popup_download_file&file_name=/hr/emuhtasar/#file_name#.txt';">
					<input type="button" value="Muhtasar CSV Export Dosyası!" onclick="window.location.href='index.cfm?fuseaction=objects.popup_download_file&file_name=/hr/emuhtasar/#file_name#.csv';"> --->
					<cfif rowCount_7103 gt 0>
						<div>
							<a href="#file_web_path#hr#dir_seperator#emuhtasar#dir_seperator##get_ssk_xml_exports.FILE_NAME_7103#"  class="ui-btn ui-btn-success"><cf_get_lang dictionary_id="60678.Muhtasar İstihdam Teşvik (7103) TXT Export Dosyası!"></a>
						</div>
						<div>
							<a href="#file_web_path#hr#dir_seperator#emuhtasar#dir_seperator##get_ssk_xml_exports.EXCEL_FILE_NAME_7103#"  class="ui-btn ui-btn-success"><cf_get_lang dictionary_id="60677.Muhtasar İstihdam Teşvik (7103)  CSV Export Dosyası!"></a>
						</div>
						
						<!--- <input type="button" value="Muhtasar İstihdam Teşvik (7103) TXT Export Dosyası!" onclick="window.location.href='index.cfm?fuseaction=objects.popup_download_file&file_name=/hr/emuhtasar/#file_name#_7103.txt';">
						<input type="button" value="Muhtasar İstihdam Teşvik (7103)  CSV Export Dosyası!" onclick="window.location.href='index.cfm?fuseaction=objects.popup_download_file&file_name=/hr/emuhtasar/#file_name#_7103.csv';"> --->
					</cfif>
				</cfoutput>
			</div>
		<cfelse>
			<div class="ui-form-list-btn flex-start">
				<cf_get_lang dictionary_id='62835.Belgeleri görüntülemek için ilgili ay, yıl ve şubeye muhtasar beyanname oluşturun!'>
			</div>
		</cfif>
	</cfif>
</cf_box>
</div>
<script type="text/javascript">
	function kontrol() {
		let yil = document.getElementById("sal_year").value;
		if (yil == "" || isNaN(yil)) {
			alert("<cf_get_lang dictionary_id ='912.Lütfen yıl alanını doldurun!'>");
			return false;
		}
		return true;
	}
</script>
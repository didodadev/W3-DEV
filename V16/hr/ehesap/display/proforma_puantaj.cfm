<cf_xml_page_edit fuseact="ehesap.list_puantaj">
<cfparam name="attributes.ssk_office" default="0">
<cfif from_list_puantaj neq 1>
	<cf_catalystHeader>
</cfif>
<cfparam name="attributes.sal_year" default="#year(now())#">
<cfif month(now()) eq 1>
	<cfparam name="attributes.sal_mon" default="1">
<cfelse>
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
</cfif>
<cfinclude template="../query/get_ssk_offices.cfm">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.hierarchy_puantaj" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.defaultOpen" default='sayfa_1'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset periods = createObject('component','V16.objects.cfc.periods')>
<cfset period_years = periods.get_period_year()>
<cfif from_list_puantaj neq 1>
	<div class="row">
		<div class="col col-12 uniqueRow">
			<div class="row formContent padding-bottom-10">			
				<div class="row" type="row">
					<div class="col col-12 form-inline">
						<cfform name="employee" method="post" action="" id="sube_puantaj">
							<div class="form-group">
								<div class="inpu-group x-20">
									<select name="ssk_office" id="ssk_office">
										<cfoutput query="GET_SSK_OFFICES" group="nick_name">
											<cfif len(SSK_OFFICE) and len(SSK_NO)>
												<optgroup label="#nick_name#"></optgroup>
												<cfoutput>
													<option value="#BRANCH_ID#"<cfif attributes.ssk_office is BRANCH_ID> selected</cfif>>#BRANCH_NAME#-#SSK_OFFICE#-#SSK_NO#</option>
												</cfoutput>
											</cfif>
										</cfoutput>
									</select>
								</div>
							</div>
							<input type="hidden" name="hierarchy_puantaj" id="hierarchy_puantaj" value="">
							<div class="form-group">
								<div class="input-group">
									<select name="sal_mon" id="sal_mon">
										<cfloop from="1" to="12" index="i">
											<cfoutput>
											<option value="#i#" <cfif month(now()) gt 1 and i eq month(now())-1>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
											</cfoutput>
										</cfloop>
									</select>
								</div>
								<div class="input-group">
									<select name="sal_year" id="sal_year">
										<cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
											<cfoutput>
												<option value="#i#" <cfif (isdefined("attributes.sal_year") and attributes.sal_year eq i) or (not isdefined("attributes.sal_year") and year(now()) eq i)>selected</cfif>>#i#</option>
											</cfoutput>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="form-group">
								<div class="input-group">
									<a href="javascript://" class="btn green-haze" onClick="document.employee.submit();"><cfoutput>#getLang('main',153)#</cfoutput></a>							
								</div>
							</div>
						</cfform>											
					</div> 				
				</div>
			</div>
		</div>
	</div>
</cfif>
<cfif len(attributes.ssk_office) and attributes.ssk_office neq 0>
	<cfsavecontent variable = "page1"><cf_get_lang dictionary_id='57757.Uyarılar'></cfsavecontent>
	<cfsavecontent variable = "page2"><cf_get_lang dictionary_id='47077.Çalışan Bilgileri'>(<cf_get_lang dictionary_id='57521.Banka'>)</cfsavecontent>
	<cfsavecontent variable = "page3"><cf_get_lang dictionary_id='46081.Gün Dağılımı'></cfsavecontent>
	<cfsavecontent variable = "page4"><cf_get_lang dictionary_id='38997.Ek Kazanç'></cfsavecontent>
	<cfsavecontent variable = "page5"><cf_get_lang dictionary_id='59208.Fazla Mesai'></cfsavecontent>
	<cfsavecontent variable = "page6"><cf_get_lang dictionary_id='53083.Kesinti'></cfsavecontent>
	<cfsavecontent variable = "page7"><cf_get_lang dictionary_id='64860.Zorunlu BES'></cfsavecontent>
	<cfsavecontent variable = "page8"><cf_get_lang dictionary_id='64861.Resmi Bordro'></cfsavecontent>
	<cfsavecontent variable = "page9"><cf_get_lang dictionary_id='46115.Tazminat'></cfsavecontent>
	<cfsavecontent variable = "page10"><cf_get_lang dictionary_id='40400.Net Ödeme'></cfsavecontent>
	<cfsavecontent variable = "page11"><cf_get_lang dictionary_id='46118.Tahmini Tazminat Yükü'></cfsavecontent>
	<cfsavecontent variable = "page12"><cf_get_lang dictionary_id='64862.Avans Listesi'></cfsavecontent>
	<cf_box closable="0">
		<cf_tab divID = "sayfa_1,sayfa_2,sayfa_3,sayfa_4,sayfa_5,sayfa_6,sayfa_7,sayfa_8,sayfa_9,sayfa_10,sayfa_11,sayfa_12" defaultOpen="#attributes.defaultOpen#" divLang = "#page1#;#page2#;#page3#;#page4#;#page5#;#page6#;#page7#;#page8#;#page9#;#page10#;#page11#;#page12#" tabcolor = "fff">
			<div id = "unique_sayfa_1" class = "uniqueBox">
				<cfinclude template="proforma_puantaj_warnings.cfm">
			</div>
			<div id = "unique_sayfa_2" class = "uniqueBox">
				<cfinclude template="proforma_puantaj_employee_infos.cfm">
			</div>
			<div id = "unique_sayfa_3" class = "uniqueBox">
				<cfinclude template="proforma_puantaj_employee_rows.cfm">
			</div>
			<div id = "unique_sayfa_4" class = "uniqueBox">
				<cfinclude template="proforma_puantaj_employee_rows_ext.cfm">
			</div>
			<div id = "unique_sayfa_5" class = "uniqueBox">
				<cfinclude template="proforma_puantaj_employee_rows_hour.cfm">
			</div>
			<div id = "unique_sayfa_6" class = "uniqueBox">
				<cfinclude template="proforma_puantaj_employee_rows_interruption.cfm">
			</div>
			<div id = "unique_sayfa_7" class = "uniqueBox">
				<cfinclude template="proforma_puantaj_bes.cfm">
			</div>
			<div id = "unique_sayfa_8" class = "uniqueBox">
				<cfinclude template="proforma_puantaj_puantaj.cfm">
			</div>
			<div id = "unique_sayfa_9" class = "uniqueBox">
				<cfinclude template="proforma_puantaj_tazminat.cfm">
			</div>
			<div id = "unique_sayfa_10" class = "uniqueBox">
				<cfinclude template="proforma_puantaj_net.cfm">
			</div>
			<div id = "unique_sayfa_11" class = "uniqueBox">
				<cfinclude template="proforma_puantaj_tazminat2.cfm">
			</div>
			<div id = "unique_sayfa_12" class = "uniqueBox">
				<cfinclude template="proforma_puantaj_avans_listesi.cfm">
			</div>
		</cf_tab>
	</cf_box>
</cfif>

<script>
	function get_proforma_tazminat_tarihli()
	{
		adres_ = '<cfoutput>#request.self#?fuseaction=ehesap.proforma_puantaj&event=tazminat</cfoutput>';
		
		adres_ = adres_ + '<cfoutput>&ssk_office=#attributes.ssk_office#</cfoutput>';
		adres_ = adres_ + '<cfoutput>&sal_mon=#attributes.sal_mon#</cfoutput>';
		adres_ = adres_ + '<cfoutput>&sal_year=#attributes.sal_year#</cfoutput>';
		
		div_name = 'puantaj_list_layer';
		AjaxPageLoad(adres_,div_name);
	}
</script>
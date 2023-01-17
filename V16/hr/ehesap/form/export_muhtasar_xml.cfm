<!---
File: export_muhtasar_xml.cfm
Author: Team Yazılım - Yunus Özay <yunusozay@gmail.com>
Edit: Workcube - Esma Uysal <esmauysal@workcube.com>
Controller: MuhtasarXMLExportController.cfm
--->
<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
<cfparam name="attributes.modal_id" default="">

<cfset is_control = 2>

<cfinclude template="../query/get_branch.cfm">

<cfscript>
	cmp_company = createObject("component","V16.hr.cfc.get_our_company");
	cmp_company.dsn = dsn;
	get_our_company = cmp_company.get_company(is_control : is_control);
</cfscript>

<cf_box title="#getLang('','Muhtasar Bildirge',62989)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="cari" action="" method="post">
		<input type="hidden" name="is_sgk_only" id="is_sgk_only" value="1">
		<cf_box_elements>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group require" id="item-process_stage">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="53806.İşyeri"></label>
					<div class="col col-8 col-sm-12">
						<select name="company_id" id="company_id">
							<option value=""><cf_get_lang dictionary_id='29531.Şirketler'></option>
							<cfoutput query="get_our_company"><option value="#comp_id#">#company_name#</option></cfoutput>
						</select>
					</div>                
				</div> 
				<div class="form-group require" id="item-process_stage">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="42355.SGK Şube"></label>
					<div class="col col-8 col-sm-12">
						<select name="ssk_office" id="ssk_office">
							<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							<cfoutput query="get_branch">
								<cfif len("#ssk_office##ssk_no#")>
									<option value="#branch_id#">#branch_name#-#ssk_office#-#ssk_no#</option>
								</cfif>
							</cfoutput>
						</select>
					</div>                
				</div> 
				<div class="form-group require" id="item-process_stage">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="59587.Belge Mahiyeti"></label>
					<div class="col col-8 col-sm-12">
						<select name="export_reason" id="export_reason">
							<option value="A"><cf_get_lang dictionary_id="31403.Asıl">(A)</option>
							<option value="E"><cf_get_lang dictionary_id="32589.Ek">(E)</option>
							<option value="I"><cf_get_lang dictionary_id="58506.İptal">(I)</option>
						</select>
					</div>                
				</div> 
				<div class="form-group require" id="item-process_stage">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="62279.Tahakkuk Nedeni"></label>
					<div class="col col-8 col-sm-12">
						<select name="export_type" id="export_type">
							<option value="A">A</option>
							<option value="B">B</option>
							<option value="F">F</option>
							<option value="G">G</option>
							<option value="H">H</option>
							<option value="I">I</option>
						</select>
					</div>                
				</div> 
				<div class="form-group require" id="item-process_stage">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='53808.Yıl Ay'></label>
					<div class="col col-4 col-sm-12">
						<select name="sal_year" id="sal_year">
							<cfloop from="-5" to="5" index="i">
								<cfoutput><option value="#session.ep.period_year + i#"<cfif session.ep.period_year eq (session.ep.period_year + i)> selected</cfif>>#session.ep.period_year + i#</option></cfoutput>
							</cfloop>
						</select>
					</div>       
					-         
					<div class="col col-4 col-sm-12">
						<select name="sal_mon" id="sal_mon">
							<cfloop from="1" to="12" index="i">
								<cfoutput><option value="#i#"<cfif attributes.sal_mon eq i> selected</cfif>>#i#</option></cfoutput>
							</cfloop>
						</select>
					</div>
				</div> 
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0'>
		</cf_box_footer>
	</cfform>
</cf_box>
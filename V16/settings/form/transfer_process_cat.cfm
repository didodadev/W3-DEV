<!--- 	
	FS Revize 20090513 Xml Den sirkete aktarilma seklinde calisan bu sayfa degistirildi
	Seceneklere gore istenilen sirketten istenilen sirkete veya Xmlden istenilen sirkete aktarilma yapilacak
 --->
<cfsetting showdebugoutput="no">
<cfparam name="attributes.to_company" default="">
<cfparam name="attributes.from_company" default="">
<cfparam name="attributes.mode" default="3">
<cfquery name="get_our_company" datasource="#dsn#">
	SELECT COMP_ID, COMPANY_NAME FROM OUR_COMPANY ORDER BY COMP_ID
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','İşlem Kategorileri Aktarım İşlemi','43563')#">
		<cfform name="form_" method="post" action="">
			<input type="hidden" name="submitted" id="submitted" value="">
            <cf_box_search>
				<div class="form-group" id="item-from_company">
					<select name="from_company" id="from_company" onchange="javascript:if(document.form_.from_company.value==document.form_.to_company.value){alert('Kaynak ve Hedef Şirketler Birbirinden Farklı Olmalıdır!');document.form_.from_company.value='';return false;};">
						<option value=""><cf_get_lang dictionary_id='44613.Kaynak'></option>
						<option value="0" style="font-style:italic;" <cfif attributes.from_company eq 0>selected</cfif>><cf_get_lang dictionary_id='44615.Default İşlem Kategorileri'></option>
						<cfoutput query="get_our_company">
							<option value="#comp_id#" <cfif attributes.from_company eq comp_id> selected</cfif>>#company_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="item-to_company">
					<select name="to_company" id="to_company" onchange="javascript:if(document.form_.from_company.value==document.form_.to_company.value){alert('Kaynak ve Hedef Şirketler Birbirinden Farklı Olmalıdır!');document.form_.to_company.value='';return false;};">
						<option value=""><cf_get_lang dictionary_id='57951.Hedef'></option>
						<cfoutput query="get_our_company">
							<option value="#comp_id#" <cfif attributes.to_company eq comp_id> selected</cfif>>#company_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="item-language">
					<select name="language" id="language">
						<option value="1" <cfif isdefined("attributes.language") and attributes.language eq 1>selected</cfif>><cf_get_lang dictionary_id='38745.Türkçe'></option>
						<option value="2" <cfif isdefined("attributes.language") and attributes.language eq 2>selected</cfif>><cf_get_lang dictionary_id='38746.İngilizce'></option>
					</select>
				</div>
				<div class="form-group" id="item-button">
					<cf_workcube_buttons add_function='kontrol()' is_upd='0' is_cancel='0' insert_info='#getLang('','Çalıştır','57911')#' type_format="1">
				</div>
				<div class="form-group" id="item-explanation">
					<font color="FF0000">
						<cf_get_lang dictionary_id='44935.Kaynak Kısmında Bilgilerin Nereden Alınacağı Seçilir'>,<br/>
						<cf_get_lang dictionary_id='44936.Default İşlem Kategorileri Seçilirse Sabit ve Önceden Tanımlı İşlem Kategorilerini Aktarır.'><br/>
					</font>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>

<cfif isdefined("attributes.submitted") and len(attributes.from_company) and len(attributes.to_company)>
	<cfset from_new_dsn3 = '#dsn#_#attributes.from_company#'><!--- Nereden --->
	<cfset to_new_dsn3 = '#dsn#_#attributes.to_company#'><!--- Nereye --->
	
	<!--- Varolan Kayitlar Gozardi Edilerek, Bunlarin Disindakiler Aktarilacak --->
	<cfset Process_Type_List = ''>
	<cfquery name="process_control" datasource="#to_new_dsn3#">
		SELECT PROCESS_TYPE FROM SETUP_PROCESS_CAT ORDER BY PROCESS_TYPE
	</cfquery>
	<cfif process_control.recordcount>
		<cfset Process_Type_List = ListSort(ListDeleteDuplicates(ValueList(process_control.process_type,',')),'numeric','asc',',')>
	</cfif>
	<cfif attributes.from_company eq 0>
		<cfset xml_folder = '#GetDirectoryFromPath(GetCurrentTemplatePath())#..#dir_seperator#..#dir_seperator#admin_tools#dir_seperator#'>
		<cffile action="read" file="#xml_folder#xml#dir_seperator#setup_process_cat.xml" variable="xmldosyam" charset = "UTF-8">
		<cfset WP = XmlParse(xmldosyam)>
		<cfset RecordCount_ = ArrayLen(WP.workcube_process_types.XmlChildren)>
	<cfelse>
		<cfquery name="get_from_cat" datasource="#from_new_dsn3#">
			SELECT * FROM SETUP_PROCESS_CAT
		</cfquery>
		<cfset RecordCount_ = get_from_cat.recordcount>
	</cfif>
	<cflock timeout="100">
	<cftransaction>
		<cfloop from="1" to="#RecordCount_#" index="x">
			<cfif not Len(Process_Type_List) or (Len(Process_Type_List) and ((attributes.from_company eq 0 and not ListFind(Process_Type_List,WP.workcube_process_types.process[x].process_type.XmlText,',')) or (attributes.from_company neq 0 and not ListFind(Process_Type_List,get_from_cat.process_type[x],','))))>
				<cfquery name="add_setup_process_cat" datasource="#to_new_dsn3#" result="MAX_ID">
					INSERT INTO
						SETUP_PROCESS_CAT
					(
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP,
						PROCESS_CAT,
						PROCESS_MODULE,
						PROCESS_TYPE,
						MULTI_TYPE,
						IS_DEFAULT,
						IS_CARI,
						IS_ACCOUNT,
						IS_DISCOUNT,
						IS_BUDGET,
						IS_STOCK_ACTION,
						IS_ACCOUNT_GROUP,
						IS_PARTNER,
						IS_PUBLIC,
						IS_COST,
						IS_PROJECT_BASED_ACC,
						IS_PROJECT_BASED_BUDGET,
						IS_CHEQUE_BASED_ACTION,
						IS_UPD_CARI_ROW,
						IS_DUE_DATE_BASED_CARI,
						IS_PAYMETHOD_BASED_CARI,
						IS_COST_ZERO_ROW,
						IS_ZERO_STOCK_CONTROL,
						IS_COST_FIELD,
						IS_EXP_BASED_ACC,
						IS_PROD_COST_ACC_ACTION,
                        INVOICE_TYPE_CODE,
                        PROFILE_ID,
                        SPECIAL_CODE,
                        IS_PROCESS_CURRENCY,
                        DOCUMENT_TYPE,
                        PAYMENT_TYPE,
                        IS_LOT_NO,
                        SHIP_TYPE_ID
					)
					VALUES
					(
						#session.ep.userid#,
						#now()#,
						'#cgi.remote_addr#',
						<cfif attributes.from_company eq 0>
							<cfif attributes.language eq 2>
								'#WP.workcube_process_types.process[x].process_cat_eng.XmlText#',
							<cfelse>
								'#WP.workcube_process_types.process[x].process_cat.XmlText#',
							</cfif>							
							#WP.workcube_process_types.process[x].process_module_id.XmlText#,
							#WP.workcube_process_types.process[x].process_type.XmlText#,
							<cfif len(WP.workcube_process_types.process[x].process_multi_type.XmlText)>#WP.workcube_process_types.process[x].process_multi_type.XmlText#<cfelse>NULL</cfif>,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
                            <cfif len(WP.workcube_process_types.process[x].invoice_type_code.XmlText)>'#WP.workcube_process_types.process[x].invoice_type_code.XmlText#'<cfelse>NULL</cfif>,
                            <cfif len(WP.workcube_process_types.process[x].profile_id.XmlText)>'#WP.workcube_process_types.process[x].profile_id.XmlText#'<cfelse>NULL</cfif>,
                            NULL,
                            0,
                            NULL,
                            NULL,
                            0,
							NULL						
						<cfelse>
							<cfif len(get_from_cat.process_cat[x])>'#get_from_cat.process_cat[x]#'<cfelse>NULL</cfif>,
							<cfif len(get_from_cat.process_module[x])>#get_from_cat.process_module[x]#<cfelse>NULL</cfif>,
							<cfif len(get_from_cat.process_type[x])>#get_from_cat.process_type[x]#<cfelse>NULL</cfif>,
							<cfif len(get_from_cat.multi_type[x])>#get_from_cat.multi_type[x]#<cfelse>NULL</cfif>,
							<cfif len(get_from_cat.is_default[x])>#get_from_cat.is_default[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_cari[x])>#get_from_cat.is_cari[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_account[x])>#get_from_cat.is_account[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_discount[x])>#get_from_cat.is_discount[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_budget[x])>#get_from_cat.is_budget[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_stock_action[x])>#get_from_cat.is_stock_action[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_account_group[x])>#get_from_cat.is_account_group[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_partner[x])>#get_from_cat.is_partner[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_public[x])>#get_from_cat.is_public[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_cost[x])>#get_from_cat.is_cost[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_project_based_acc[x])>#get_from_cat.is_project_based_acc[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_project_based_budget[x])>#get_from_cat.is_project_based_budget[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_cheque_based_action[x])>#get_from_cat.is_cheque_based_action[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_upd_cari_row[x])>#get_from_cat.is_upd_cari_row[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_due_date_based_cari[x])>#get_from_cat.is_due_date_based_cari[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_paymethod_based_cari[x])>#get_from_cat.is_paymethod_based_cari[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_cost_zero_row[x])>#get_from_cat.is_cost_zero_row[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_zero_stock_control[x])>#get_from_cat.is_zero_stock_control[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_cost_field[x])>#get_from_cat.is_cost_field[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_exp_based_acc[x])>#get_from_cat.is_exp_based_acc[x]#<cfelse>0</cfif>,
							<cfif len(get_from_cat.is_prod_cost_acc_action[x])>#get_from_cat.is_prod_cost_acc_action[x]#<cfelse>0</cfif>,
                            <cfif len(get_from_cat.invoice_type_code[x])>'#get_from_cat.invoice_type_code[x]#'<cfelse>NULL</cfif>,
                            <cfif len(get_from_cat.profile_id[x])>'#get_from_cat.profile_id[x]#'<cfelse>NULL</cfif>,
                            <cfif len(get_from_cat.special_code[x])>'#get_from_cat.special_code[x]#'<cfelse>NULL</cfif>,
                            <cfif len(get_from_cat.is_process_currency[x])>#get_from_cat.is_process_currency[x]#<cfelse>0</cfif>,
                            <cfif len(get_from_cat.document_type[x])>#get_from_cat.document_type[x]#<cfelse>NULL</cfif>,
                            <cfif len(get_from_cat.payment_type[x])>#get_from_cat.payment_type[x]#<cfelse>NULL</cfif>,
                            <cfif len(get_from_cat.is_lot_no[x])>#get_from_cat.is_lot_no[x]#<cfelse>0</cfif>,
                            <cfif len(get_from_cat.ship_type_id[x])>#get_from_cat.ship_type_id[x]#<cfelse>NULL</cfif>
						</cfif>
					)
				</cfquery>
				<!--- Fuseaction Aktarimlari --->
				<cfset FuseNameRecordCount_ = "">
				<cfif attributes.from_company eq 0>
					<cfif len(WP.workcube_process_types.process[x].process_fuseaction.XmlText)>
						<cfset FuseNameRecordCount_ = listlen(WP.workcube_process_types.process[x].process_fuseaction.XmlText)>
					</cfif>
				<cfelse>
					<cfquery name="get_from_cat_fusename" datasource="#to_new_dsn3#">
						SELECT * FROM #from_new_dsn3#.SETUP_PROCESS_CAT_FUSENAME WHERE PROCESS_CAT_ID = #get_from_cat.process_cat_id[x]#
					</cfquery>
					<cfif get_from_cat_fusename.recordcount>
						<cfset FuseNameRecordCount_ = get_from_cat_fusename.recordcount>
					</cfif>
				</cfif>
				<cfif len(FuseNameRecordCount_)>
					<cfloop from="1" to="#FuseNameRecordCount_#" index="w">
						<cfquery name="add_setup_process_cat_fusename" datasource="#to_new_dsn3#">
							INSERT INTO
								SETUP_PROCESS_CAT_FUSENAME
							(
								PROCESS_CAT_ID,
								FUSE_NAME
							)
							VALUES
							(
								#MAX_ID.IDENTITYCOL#,
								<cfif attributes.from_company eq 0>
									'#listgetat(WP.workcube_process_types.process[x].process_fuseaction.XmlText,w,',')#'
								<cfelse>
									'#get_from_cat_fusename.fuse_name[w]#'
								</cfif>
							)
						</cfquery>
					</cfloop>
				</cfif>
			</cfif>	
		</cfloop>
	</cftransaction>
	</cflock>
	<cf_box>
		<!--- Aktarim Sonrasi Kayitlar Goruntulenir --->
		<cfquery name="get_last_process" datasource="#to_new_dsn3#">
			SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT ORDER BY PROCESS_CAT
		</cfquery>
		<table cellpadding="2" cellspacing="1" width="98%" align="center" class="color-border">
			<tr class="color-row">
				<td>
				<table>
					<cfif get_last_process.recordcount>
						<cfoutput query="get_last_process">
							<cfif ((currentrow mod attributes.mode is 1)) or (currentrow eq 1)>
								<tr height="22">
							</cfif>
								<td width="400">(#process_cat_id#) #process_cat#</td>
							<cfif ((currentrow mod attributes.mode is 0)) or (currentrow eq recordcount)>
								</tr>
							</cfif>
						</cfoutput>
					<cfelse>
						<tr>
							<td><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
						</tr>
					</cfif>
				</table>
				</td>
			</tr>
		</table>
	</cf_box>
</cfif>
</div>
<script type="text/javascript">
function kontrol()
{
	if(document.form_.from_company.value == "" || document.form_.to_company.value == "")
	{
		alert("<cf_get_lang dictionary_id='44612.Kaynak ve Hedef Seçeneklerinden Size Uygun Olanları Seçiniz'>!");
		return false;
	}
	return true;
}
</script>

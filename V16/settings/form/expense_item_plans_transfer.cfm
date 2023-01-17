<script type="text/javascript">
function basamak_1()
	{
	if(confirm("<cf_get_lang no ='2069.Bütçe Kalemleri-Bütçe Kategorileri-Masraf Merkezleri Aktarım İşlemi Yapacaksınız !!!Bu İşlem Geri Alınamaz!!! Emin misiniz'>?"))
		document.form_.submit();
	else 
		return false;
	}
	
function basamak_2()
	{
	if(confirm("<cf_get_lang no ='2069.Bütçe Kalemleri-Bütçe Kategorileri-Masraf Merkezleri Aktarım İşlemi Yapacaksınız !!!Bu İşlem Geri Alınamaz!!! Emin misiniz'>?"))
		document.form1_.submit();
	else 
		return false;
	}
</script>
<cfquery name="get_companies" datasource="#dsn#">
	SELECT 
    	COMP_ID, 
        COMPANY_NAME
    FROM 
	    OUR_COMPANY 
</cfquery>
<cfparam name="attributes.expense_center" default="">
<cfparam name="attributes.expense_item" default="">
<cfparam name="attributes.expense_templates" default="">
<cfif not isdefined("attributes.hedef_period")>
<cfsavecontent variable = "title">
	<cf_get_lang no ='2068.Bütçe Kalemleri-Bütçe Kategorileri-Masraf Merkezleri Aktarımı'>
</cfsavecontent>
<cf_form_box title="#title#">
	<cf_area width="50%">
				<form name="form_" method="post"action="">	
				<table>
				<tr>
					<td>
						<label> <input type="checkbox" name="expense_center" id="expense_center" <cfif isDefined("attributes.expense_center") and len(attributes.expense_center)>checked</cfif>>
						<cf_get_lang no ='2067.Masraf Merkezleri'></td></label>
					<td>
						<label> <input type="checkbox" name="expense_item" id="expense_item" <cfif isDefined("attributes.expense_item") and len(attributes.expense_item)>checked</cfif>>		
						<cf_get_lang no ='2066.Bütçe Kalemleri ve Kategorileri'></td></label>
					<td>
						<label> <input type="checkbox" name="expense_templates" id="expense_templates" <cfif isDefined("attributes.expense_templates") and len(attributes.expense_templates)>checked</cfif>>	
						<cf_get_lang no ='15.Masraf/Gelir Sablonlari'></td></label>
					<td>
						<label> <input type="checkbox" name="expense_center_row" <cfif isDefined("attributes.expense_center_row") and len(attributes.expense_center_row)>checked</cfif>>	 	
						<cf_get_lang dictionary_id = "45900.Masraf Merkezi-Bütçe Kalemi İlişkisi"></label>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang no='1784.kaynak Dönem'></td>
					<td>
						<select name="source_company" id="source_company" onchange="show_periods_departments(1)">
							<cfoutput query="get_companies">
								<option value="#comp_id#" <cfif isdefined("attributes.source_company") and attributes.source_company eq comp_id>selected<cfelseif comp_id eq session.ep.company_id>selected</cfif>>#company_name#</option>
							</cfoutput>
						</select>
					</td>
					<td>
						<div id="source_div">
							<select name="kaynak_period_1" id="kaynak_period_1" style="width:220px;">
								<cfif isdefined("attributes.source_company") and len(attributes.source_company)>
									<cfquery name="get_periods" datasource="#dsn#">
										SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #attributes.source_company# ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
									</cfquery>
									<cfoutput query="get_periods">				
										<option value="#period_id#" <cfif isdefined("attributes.kaynak_period_1") and attributes.kaynak_period_1 eq period_id>selected</cfif>>#period#</option>						
									</cfoutput>
								</cfif>
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang no ='1277.Hedef Dönem'></td>
					<td>
						<select name="target_company" id="target_company" onchange="show_periods_departments(2)">
							<cfoutput query="get_companies">
								<option value="#comp_id#" <cfif isdefined("attributes.target_company") and attributes.target_company eq comp_id>selected<cfelseif comp_id eq session.ep.company_id>selected</cfif>>#company_name#</option>
							</cfoutput>
						</select>
					</td>
					<td>
						<div id="target_div">
							<select name="hedef_period_1" id="hedef_period_1" style="width:220px;">
								<cfif isdefined("attributes.target_company") and len(attributes.target_company)>
									<cfoutput query="get_periods">				
										<option value="#period_id#" <cfif isdefined("attributes.hedef_period_1") and attributes.hedef_period_1 eq period_id>selected</cfif>>#period#</option>						
									</cfoutput>
								</cfif>
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<td><input type="button" value="<cf_get_lang dictionary_id ='58676.Aktar'>" onClick="basamak_1();"></td>
				</tr>	
			</table>
			</form>
</cf_area>
	<cf_area width="50%">
		<table>
			<tr height="30">
				<td class="headbold"><cf_get_lang dictionary_id='57433.Yardım'></td>
				<td align="right" id="google_translate_element"> 
					<script type="text/javascript">
						function googleTranslateElementInit() 
						{
							new google.translate.TranslateElement({
								pageLanguage: '<cfoutput>#session.ep.language#</cfoutput>', 
								includedLanguages: 'tr,en,fr,ar,ru,de,es,it,ro',
								layout:google.translate.TranslateElement.InlineLayout.SIMPLE,
								autoDisplay: false
							},'google_translate_element');
						}
					</script>
					<script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
				</td>
			</tr>    
			<tr>
				<td valign="top"> 
					<cftry>
						<cfinclude template="#file_web_path#templates/period_help/expenseItemTransfer_#session.ep.language#.html">
						<cfcatch>
							<script type="text/javascript">
								alert("<cf_get_lang dictionary_id='29760.Yardım Dosyası Bulunamadı Lutfen Kontrol Ediniz'>");
							</script>
						</cfcatch>
					</cftry>
				</td>
			</tr>
		</table>
	</cf_area>					     
</cf_form_box>				
</cfif>
<cfif isdefined("attributes.hedef_period_1") and isdefined("attributes.kaynak_period_1")>
	<cfif not len(attributes.hedef_period_1)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2031.Hedef Period Seçmelisiniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfif not len(attributes.kaynak_period_1)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2064.Kaynak Dönem Secmelisiniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	
	<cfquery name="get_hedef_period" datasource="#dsn#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.hedef_period_1#
	</cfquery>
	
	<cfquery name="get_kaynak_period" datasource="#dsn#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID= #attributes.kaynak_period_1#
	</cfquery>
	<form action="" name="form1_" method="post">
	<cfif isdefined("attributes.expense_center") and len(attributes.expense_center)>
		<input type="hidden" name="expense_center" id="expense_center" value="1">
	</cfif>
	<cfif isdefined("attributes.expense_item") and len(attributes.expense_item)>
		<input type="hidden" name="expense_item" id="expense_item" value="1">
	</cfif>
	<cfif isdefined("attributes.expense_templates") and len(attributes.expense_templates)>
		<input type="hidden" name="expense_templates" id="expense_templates" value="1">
	</cfif>
	<cfif isdefined("attributes.expense_center_row") and len(attributes.expense_center_row)>
		<input type="hidden" name="expense_center_row" value="1">
	</cfif>
		<input type="hidden" name="aktarim_hedef_period" id="aktarim_hedef_period" value="<cfoutput>#attributes.hedef_period_1#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#get_kaynak_period.period_id#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_year" id="aktarim_kaynak_year" value="<cfoutput>#get_kaynak_period.period_year#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_company" id="aktarim_kaynak_company" value="<cfoutput>#get_kaynak_period.our_company_id#</cfoutput>">
		<input type="hidden" name="aktarim_hedef_year" id="aktarim_hedef_year" value="<cfoutput>#get_hedef_period.period_year#</cfoutput>">
		<input type="hidden" name="aktarim_hedef_company" id="aktarim_hedef_company" value="<cfoutput>#get_hedef_period.OUR_COMPANY_ID#</cfoutput>">
		<cf_get_lang no ='2028.Kaynak Veri Tabani'> : <cfoutput>#get_kaynak_period.period# (#get_kaynak_period.period_year#)</cfoutput><br/>
		<cf_get_lang no ='2029.Hedef Veri Tabanı'>: <cfoutput>#get_hedef_period.period# (#get_hedef_period.period_year#)</cfoutput><br/>
		<input type="button" value="<cf_get_lang no ='2027.Aktarimi Baslat'>" onClick="basamak_2();">
	</form>
</cfif>	
<cfif isdefined("attributes.aktarim_hedef_period")>	
	<cflock name="#CREATEUUID()#" timeout="70">
		<cftransaction>
        	<cfif fusebox.use_period>
				<cfset hedef_dsn2 = '#dsn#_#attributes.aktarim_hedef_year#_#attributes.aktarim_hedef_company#'>
                <cfset kaynak_dsn2 = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#'>
			<cfelse>
				<cfset hedef_dsn2 = '#dsn#'>
                <cfset kaynak_dsn2 = '#dsn#'>
            </cfif>
			<cfif isdefined("attributes.expense_item") and len(attributes.expense_item)>
				<!--- once hedef tabloda kayitlar varmi diye bakilir --->
				<cfquery name="SELECT_EXPENSE_CATEGORY" datasource="#hedef_dsn2#">
					SELECT * FROM EXPENSE_CATEGORY
				</cfquery>
				<!--- yoksa eski donemdeki bilgiler yeni donemdeki tabloya aktarilir --->
				<cfif SELECT_EXPENSE_CATEGORY.recordcount>
					<script type="text/javascript">
						alert("<cf_get_lang no ='2049.Bu aktarim daha önce yapılmıştır'>!");
						history.back();
						window.close;
					</script>
					<cfabort>
				<cfelse>
					<cfquery name="TRANSFER_EXPENSE_CATEGORY_" datasource="#hedef_dsn2#">
						SET IDENTITY_INSERT EXPENSE_CATEGORY ON
						
						INSERT INTO EXPENSE_CATEGORY
						(
							EXPENSE_CAT_ID,
							EXPENSE_CAT_NAME,
							EXPENSE_CAT_DETAIL,
                            EXPENSE_CAT_CODE,
							EXPENCE_IS_HR,
							EXPENCE_IS_TRAINING,
							IS_SUB_EXPENSE_CAT,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE,
							UPDATE_EMP,
							UPDATE_IP,
							UPDATE_DATE
						)
							SELECT
								EXPENSE_CAT_ID,
								EXPENSE_CAT_NAME,
								EXPENSE_CAT_DETAIL,
                                EXPENSE_CAT_CODE,
								EXPENCE_IS_HR,
								EXPENCE_IS_TRAINING,
								IS_SUB_EXPENSE_CAT,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE,
								UPDATE_EMP,
								UPDATE_IP,
								UPDATE_DATE
							FROM
								#kaynak_dsn2#.EXPENSE_CATEGORY
					
						SET IDENTITY_INSERT EXPENSE_CATEGORY OFF
					</cfquery>
				</cfif>
				<!--- Bütçe (gelir-gider) kalemleri --->
				<cfquery name="SELECT_EXPENSE_ITEM" datasource="#hedef_dsn2#">
					SELECT * FROM EXPENSE_ITEMS
				</cfquery>
				<!--- yoksa eski donemdeki bilgiler yeni donemdeki tabloya aktarilir --->
				<cfif SELECT_EXPENSE_ITEM.recordcount>
					<script type="text/javascript">
						alert("<cf_get_lang no ='2049.Bu aktarim daha önce yapılmıştır'>!");
						history.back();
						window.close;
					</script>
					<cfabort>
				<cfelse>
					<cfquery name="TRANSFER_EXPENSE_ITEM_" datasource="#hedef_dsn2#">
						SET IDENTITY_INSERT EXPENSE_ITEMS ON
						
						INSERT INTO EXPENSE_ITEMS
						(
							EXPENSE_ITEM_ID,
							ACCOUNT_CODE,
							EXPENSE_CATEGORY_ID,
							EXPENSE_ITEM_DETAIL,
							EXPENSE_ITEM_NAME,
                            EXPENSE_ITEM_CODE,
							INCOME_EXPENSE,
							IS_EXPENSE,
							IS_CONTROL,
							IS_ACTIVE,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE,
							UPDATE_EMP,
							UPDATE_IP,
							UPDATE_DATE
						)
							SELECT DISTINCT
								EXPENSE_ITEMS.EXPENSE_ITEM_ID,
								EXPENSE_ITEMS.ACCOUNT_CODE,
								EXPENSE_ITEMS.EXPENSE_CATEGORY_ID,
								EXPENSE_ITEMS.EXPENSE_ITEM_DETAIL,
								EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
                                EXPENSE_ITEMS.EXPENSE_ITEM_CODE,
								EXPENSE_ITEMS.INCOME_EXPENSE,
								EXPENSE_ITEMS.IS_EXPENSE,
								EXPENSE_ITEMS.IS_CONTROL,
								EXPENSE_ITEMS.IS_ACTIVE,
								EXPENSE_ITEMS.RECORD_EMP,
								EXPENSE_ITEMS.RECORD_IP,
								EXPENSE_ITEMS.RECORD_DATE,
								EXPENSE_ITEMS.UPDATE_EMP,
								EXPENSE_ITEMS.UPDATE_IP,
								EXPENSE_ITEMS.UPDATE_DATE
							FROM
								#kaynak_dsn2#.EXPENSE_ITEMS EXPENSE_ITEMS,
								#hedef_dsn2#.ACCOUNT_PLAN
							WHERE 
								ACCOUNT_PLAN.ACCOUNT_CODE = EXPENSE_ITEMS.ACCOUNT_CODE 
								
						SET IDENTITY_INSERT EXPENSE_ITEMS OFF
					</cfquery>
				</cfif>
			</cfif>
			<cfif isdefined("attributes.expense_center")and len(attributes.expense_center)>
				<!--- masraf merkezleri --->
				<cfquery name="SELECT_EXPENSE_CENTER" datasource="#hedef_dsn2#">
					SELECT * FROM EXPENSE_CENTER
				</cfquery>
				<!--- yoksa eski donemdeki bilgiler yeni donemdeki tabloya aktarilir --->
				<cfif SELECT_EXPENSE_CENTER.recordcount>
					<script type="text/javascript">
						alert("<cf_get_lang no ='2049.Bu aktarim daha önce yapılmıştır'>!");
						history.back();
						window.close;
					</script>
					<cfabort>
				<cfelse>
					<cfquery name="TRANSFER_EXPENSE_CENTER_" datasource="#hedef_dsn2#">
						SET IDENTITY_INSERT EXPENSE_CENTER ON
						
						INSERT INTO EXPENSE_CENTER
						(
							EXPENSE_ID,
							EXPENSE,
							HIERARCHY,
							DETAIL,
							EXPENSE_CODE,
							EXPENSE_ACTIVE,
							RESPONSIBLE1,
							RESPONSIBLE2,
							RESPONSIBLE3,
							IS_PRODUCTION,
							COMPANY_ID,
							WORKGROUP_ID,
							EXPENSE_BRANCH_ID,
							EXPENSE_DEPARTMENT_ID,
							IS_GENERAL,
							RECORD_EMP,
							RECORD_EMP_IP,
							RECORD_DATE,
							UPDATE_EMP,
							UPDATE_EMP_IP,
							UPDATE_DATE,
							IS_ACCOUNTING_BUDGET,
							ACTIVITY_ID
						)
							SELECT
								EXPENSE_ID,
								EXPENSE,
								HIERARCHY,
								DETAIL,
								EXPENSE_CODE,
								EXPENSE_ACTIVE,
								RESPONSIBLE1,
								RESPONSIBLE2,
								RESPONSIBLE3,
								IS_PRODUCTION,
								COMPANY_ID,
								WORKGROUP_ID,
								EXPENSE_BRANCH_ID,
								EXPENSE_DEPARTMENT_ID,
								IS_GENERAL,
								RECORD_EMP,
								RECORD_EMP_IP,
								RECORD_DATE,
								UPDATE_EMP,
								UPDATE_EMP_IP,
								UPDATE_DATE,
								IS_ACCOUNTING_BUDGET,
								ACTIVITY_ID
							FROM
								#kaynak_dsn2#.EXPENSE_CENTER
								
						SET IDENTITY_INSERT EXPENSE_CENTER OFF
					</cfquery>
				</cfif>
			</cfif>
			<!--- eski donemdeki bilgiler aktarilir --->
			
			<cfif isdefined("attributes.expense_templates")and len(attributes.expense_templates)>
				<!--- masraf/gelir şablonları --->
				<cfquery name="SELECT_EXPENSE_PLANS_TEMPLATES" datasource="#hedef_dsn2#">
					SELECT * FROM EXPENSE_PLANS_TEMPLATES
				</cfquery>
				<cfquery name="SELECT_EXPENSE_PLANS_TEMPLATES_ROWS" datasource="#hedef_dsn2#">
					SELECT * FROM EXPENSE_PLANS_TEMPLATES_ROWS
				</cfquery>
				<!--- yoksa eski donemdeki bilgiler yeni donemdeki tabloya aktarilir --->
				<cfif SELECT_EXPENSE_PLANS_TEMPLATES.recordcount or SELECT_EXPENSE_PLANS_TEMPLATES_ROWS.recordcount>
					<script type="text/javascript">
						alert("<cf_get_lang no ='2049.Bu aktarim daha önce yapılmıştır'>!");
						history.back();
						window.close;
					</script>
					<cfabort>
				<cfelse>
					<cfquery name="TRANSFER_EXPENSE_PLANS_TEMPLATES_" datasource="#hedef_dsn2#">
						SET IDENTITY_INSERT EXPENSE_PLANS_TEMPLATES ON
						
						INSERT INTO EXPENSE_PLANS_TEMPLATES
						(
							TEMPLATE_ID,
							TEMPLATE_NAME,
							IS_ACTIVE,
							IS_INCOME,
							IS_DEPARTMENT,
							RECORD_DATE,
							RECORD_EMP,
							UPDATE_DATE,
							UPDATE_EMP,
							UPDATE_IP
						)
							SELECT
								TEMPLATE_ID,
								TEMPLATE_NAME,
								IS_ACTIVE,
								IS_INCOME,
								IS_DEPARTMENT,
								RECORD_DATE,
								RECORD_EMP,
								UPDATE_DATE,
								UPDATE_EMP,
								UPDATE_IP
							FROM
								#kaynak_dsn2#.EXPENSE_PLANS_TEMPLATES
								
						SET IDENTITY_INSERT EXPENSE_PLANS_TEMPLATES OFF
					</cfquery>
					<cfquery name="TRANSFER_EXPENSE_PLANS_TEMPLATES_ROWS_" datasource="#hedef_dsn2#">
						SET IDENTITY_INSERT EXPENSE_PLANS_TEMPLATES_ROWS ON
						
						INSERT INTO EXPENSE_PLANS_TEMPLATES_ROWS
						(
							TEMPLATE_ROW_ID,
							TEMPLATE_ID,
							RATE,
							EXPENSE_ITEM_ID,
							EXPENSE_CENTER_ID,
							PROMOTION_ID,
							COMPANY_ID,
							COMPANY_PARTNER_ID,
							ASSET_ID,
							PROJECT_ID,
							MEMBER_TYPE,
							DEPARTMENT_ID,
							WORKGROUP_ID
						)
							SELECT
								TEMPLATE_ROW_ID,
								TEMPLATE_ID,
								RATE,
								EXPENSE_ITEM_ID,
								EXPENSE_CENTER_ID,
								PROMOTION_ID,
								COMPANY_ID,
								COMPANY_PARTNER_ID,
								ASSET_ID,
								PROJECT_ID,
								MEMBER_TYPE,
								DEPARTMENT_ID,
								WORKGROUP_ID
							FROM
								#kaynak_dsn2#.EXPENSE_PLANS_TEMPLATES_ROWS
								
						SET IDENTITY_INSERT EXPENSE_PLANS_TEMPLATES_ROWS OFF
					</cfquery>
				</cfif>
			</cfif>
			<cfif isdefined("attributes.expense_center_row")and len(attributes.expense_center_row)>
				<!--- masraf merkezleri - bütçe kalemi ilişkisi--->
				<cfquery name="SELECT_EXPENSE_CENTER_ROW" datasource="#hedef_dsn2#">
					SELECT * FROM EXPENSE_CENTER_ROW
				</cfquery>
				<!--- yoksa eski donemdeki bilgiler yeni donemdeki tabloya aktarilir --->
				<cfif SELECT_EXPENSE_CENTER_ROW.recordcount>
					<script type="text/javascript">
						alert("<cf_get_lang no ='2049.Bu aktarim daha önce yapılmıştır'>!");
						history.back();
						window.close;
					</script>
					<cfabort>
				<cfelse>	
					<cfquery name="TRANSFER_EXPENSE_CENTER_ROW" datasource="#hedef_dsn2#">
						SET IDENTITY_INSERT EXPENSE_CENTER_ROW ON
						
						INSERT INTO EXPENSE_CENTER_ROW
						(
							EXPENSE_CENTER_ROW_ID,
							EXPENSE_ID,
							EXPENSE_ITEM_ID,
							ACCOUNT_ID,
							ACCOUNT_CODE,
							RECORD_EMP,
							RECORD_DATE,
							RECORD_IP
						)
							SELECT
								EXPENSE_CENTER_ROW_ID,
								EXPENSE_ID,
								EXPENSE_ITEM_ID,
								ACCOUNT_ID,
								ACCOUNT_CODE,
								RECORD_EMP,
								RECORD_DATE,
								RECORD_IP
							FROM
								#kaynak_dsn2#.EXPENSE_CENTER_ROW
								
						SET IDENTITY_INSERT EXPENSE_CENTER_ROW OFF
					</cfquery>
				</cfif>
			</cfif>
		</cftransaction>
	</cflock>
	<script type="text/javascript">
		alert("<cf_get_lang no ='2020.İşlem Başarıyla Tamamlanmiştır'>!");
	</script>
</cfif>
<script type="text/javascript">	

	function show_periods_departments(number)
	{
		if(number == 1)
		{
			if(document.getElementById('source_company').value != '')
			{
				var company_id = document.getElementById('source_company').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'kaynak_period_1',1,'Dönemler');
			}
		}
		else if(number == 2)
		{
			if(document.getElementById('target_company').value != '')
			{
				var company_id = document.getElementById('target_company').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'hedef_period_1',1,'Dönemler');
			}
		}
	}
	$(document).ready(function(){
		<cfif NOT (isdefined("attributes.target_company") and len(attributes.target_company))>
			var company_id = document.getElementById('target_company').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'hedef_period_1',1,'Dönemler');
		</cfif>
		}
	)
	$(document).ready(function(){
		<cfif NOT (isdefined("attributes.source_company") and len(attributes.source_company))>
			var company_id = document.getElementById('source_company').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'kaynak_period_1',1,'Dönemler');
		</cfif>
		}
	)
</script>
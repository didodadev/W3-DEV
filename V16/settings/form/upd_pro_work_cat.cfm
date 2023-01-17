<cf_xml_page_edit fuseact="settings.form_add_pro_work_cat">
<cfquery name="GET_PROWORK" datasource="#DSN#" maxrows="1">
	SELECT COUNT(WORK_ID) COUNT FROM PRO_WORKS WHERE WORK_CAT_ID=#URL.ID#
</cfquery>
<cfquery name="GET_CAT" datasource="#DSN#">
	SELECT TEMPLATE_ID,TEMPLATE_HEAD FROM TEMPLATE_FORMS WHERE TEMPLATE_MODULE = 1
</cfquery>
<cfquery name="Get_Our_Company" datasource="#dsn#">
	SELECT COMP_ID, NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
</cfquery>
<cfquery name="GET_PROCESS_CAT" datasource="#DSN#">
	SELECT
	   DISTINCT 
	   SMC.MAIN_PROCESS_CAT_ID,
	   #dsn#.Get_Dynamic_Language(SMC.MAIN_PROCESS_CAT_ID,'#session.ep.language#','SETUP_MAIN_PROCESS_CAT','MAIN_PROCESS_CAT',NULL,NULL,SMC.MAIN_PROCESS_CAT) AS MAIN_PROCESS_CAT
	FROM 
	   SETUP_MAIN_PROCESS_CAT SMC,
	   SETUP_MAIN_PROCESS_CAT_ROWS SMR,
	   EMPLOYEE_POSITIONS
	WHERE
	   SMC.MAIN_PROCESS_CAT_ID = SMR.MAIN_PROCESS_CAT_ID AND
	   (EMPLOYEE_POSITIONS.POSITION_CAT_ID = SMR.MAIN_POSITION_CAT_ID OR EMPLOYEE_POSITIONS.POSITION_CODE = SMR.MAIN_POSITION_CODE)
</cfquery>
<cfquery name="GET_ALL_STAGE" datasource="#DSN#">
	SELECT
		#dsn#.Get_Dynamic_Language(PTR.PROCESS_ROW_ID,'#session.ep.language#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE,
        PTR.STAGE_CODE,
		PTR.PROCESS_ROW_ID,
		PT.PROCESS_ID,
        PT.PROCESS_NAME
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.addwork%">
	ORDER BY
		PTR.STAGE DESC
</cfquery> 
<cfquery name="GET_PROCESS" datasource="#DSN#">
	SELECT
		#dsn#.Get_Dynamic_Language(PT.PROCESS_ID,'#session.ep.language#','PROCESS_TYPE','PROCESS_NAME',NULL,NULL,PT.PROCESS_NAME) AS PROCESS_NAME,
		PT.PROCESS_ID
	FROM
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.addwork%">
	ORDER BY
		PT.PROCESS_NAME
</cfquery>
<cfquery name="CATS" datasource="#DSN#">
    SELECT MAIN_PROCESS_ID,OUR_COMPANY_ID,
	#dsn#.Get_Dynamic_Language(PRO_WORK_CAT.WORK_CAT_ID,'#session.ep.language#','PRO_WORK_CAT','WORK_CAT',NULL,NULL,PRO_WORK_CAT.WORK_CAT) AS WORK_CAT,
	DETAIL,TEMPLATE_ID,RECORD_EMP,RECORD_DATE,UPDATE_EMP,UPDATE_DATE,PROCESS_ID,IS_RD_SSK FROM PRO_WORK_CAT WHERE WORK_CAT_ID = #URL.ID#
</cfquery>
<cfset process_id_list = ''>
<cfif cats.recordcount and len(cats.PROCESS_ID)>
	<cfset process_id_list = valuelist(CATS.PROCESS_ID,',')>
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='42162.İş Kategorileri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_pro_work_cat" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_pro_work_cat.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform action="#request.self#?fuseaction=settings.emptypopup_pro_work_cat_upd" method="post" name="pro_work_cat">
			<input type="hidden" name="WORK_CAT_ID" id="WORK_CAT_ID" value="<cfoutput>#url.id#</cfoutput>">
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="IS_RD_SSK">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12"> &nbsp </div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="checkbox" name="IS_RD_SSK" id="IS_RD_SSK" value="1"<cfif cats.is_rd_ssk eq 1>checked</cfif>><cf_get_lang dictionary_id = "31750.ARGE Gününe Dahil">
							</div>
						</div>
						<div class="form-group" id="work_cat">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'>!</cfsavecontent>
									<cfinput type="Text" name="pro_work_cat" id="pro_work_cat" value="#cats.work_cat#" maxlength="30" required="Yes" message="#message#">
									<span class="input-group-addon">
										<cf_language_info
											table_name="PRO_WORK_CAT"
											column_name="work_cat" 
											column_id_value="#URL.ID#" 
											maxlength="500" 
											datasource="#dsn#" 
											column_id="WORK_CAT_ID" 
											control_type="0">
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="related_comp">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42089.Şablon Belge'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="template_id" id="template_id">
									<option value="" selected="selected"><cf_get_lang dictionary_id='58640.Şablon'></option>
									<cfoutput query="get_cat">
										<option value="#template_id#"<cfif len(CATS.template_id) and CATS.template_id eq template_id>selected</cfif>>#TEMPLATE_HEAD#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="related_comp">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58017.İlişkili Şirketler'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="our_company_id" id="our_company_id" multiple>
									<cfoutput query="Get_Our_Company">
										<option value="#comp_id#" <cfif listfind(cats.our_company_id,comp_id,',')> selected</cfif>>#nick_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="related_project_cat">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42122.İlişkili Proje Kategorisi'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="main_process_cat" id="main_process_cat" multiple>
									<cfoutput query="get_process_cat">
										<option value="#main_process_cat_id#" <cfif listfind(cats.main_process_id,main_process_cat_id,',')> selected</cfif>>#main_process_cat#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12" style="valign:top"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<textarea name="detail" id="detail" cols="75"><cfoutput>#cats.detail#</cfoutput></textarea>
							</div>
						</div>
						<cfif xml_work_stage eq 1>
							<cfif xml_work_stage_multiple>
								<div class="form-group" id="process_name">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<cfquery name="get_stage" dbtype="query">
											SELECT * FROM get_all_stage <cfif xml_work_stage_code eq 1>ORDER BY STAGE_CODE</cfif>
										</cfquery>						
										<select name="process_id" id="process_id" multiple>
											<cfoutput query="GET_PROCESS">
												<cfquery name="get_stage" dbtype="query">
													SELECT * FROM get_all_stage WHERE PROCESS_ID = #get_process.process_id[currentrow]# ORDER BY STAGE_CODE
												</cfquery>
												<cfif get_stage.recordcount>
													<cfloop query="get_stage">
															<option value="#process_row_id#" <cfif isdefined("attributes.id") and len (attributes.id) and listfind(cats.process_id,process_row_id,',')>selected</cfif>><cfif xml_work_stage_code eq 1 and len(stage_code)>#stage_code# - </cfif>#stage#</option>
														</cfloop>
												</cfif>
											</cfoutput>
										</select>
									</div>
								</div>
							<cfelse>
								<div class="form-group" id="process_name_2">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<select name="process_id" id="process_id">
											<cfoutput query="get_process">
												<optgroup label="#process_name#"></optgroup>
												<cfquery name="get_stage" dbtype="query">
													SELECT * FROM get_all_stage WHERE PROCESS_ID = #get_process.PROCESS_ID# <cfif xml_work_stage_code eq 1>ORDER BY STAGE_CODE</cfif>
												</cfquery>
												<cfloop query="get_stage">
													<option value="#process_row_id#" <cfif isdefined("attributes.id") and len (attributes.id) and listfind(cats.process_id,process_row_id,',')>selected</cfif>><cfif xml_work_stage_code eq 1 and len(stage_code)>#stage_code# - </cfif>#stage#</option>
												</cfloop>
											</cfoutput>
										</select>
									</div>
								</div>
							</cfif>
						</cfif>
				</cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<cf_box_footer>
						<cf_record_info query_name="cats">
						<cfif get_prowork.count gte 1><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'><cfelse>
						<cfif attributes.id lt 0><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'><cfelse>
						<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=settings.emptypopup_pro_work_cat_del&pro_work_cat_id=#URL.ID#'>
							</cfif>
						</cfif>
					</cf_box_footer>
				</div>
			</cfform>
				
    	</div>
  	</cf_box>
</div>
<script language="javascript">
	function kontrol()
	{

		if(document.pro_work_cat.our_company_id.value == '')
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='605.İlişkili Şirketler'> !");
			return false;
		}
	}
	function open_process()
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=settings.popup_list_work_stage_template&process_id_list=#process_id_list#&work_cat_id='+document.pro_work_cat.WORK_CAT_ID.value+</cfoutput>'','is_sending_zone',1);
	}
</script>


















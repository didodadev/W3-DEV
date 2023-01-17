<cfparam name="attributes.cpid" default="0">
<cfparam name="attributes.modal_id" default="0">
<cfquery name="GET_RELATED" datasource="#DSN#">
	SELECT TOTAL_POSTPONE,DEPO_STATUS,RELATED_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND COMPANY_ID = #attributes.cpid# AND DEPO_STATUS IS NOT NULL
</cfquery>
<cfif not isdefined("attributes.is_submitted")>
	<cfquery name="GET_CITY" datasource="#dsn#">
		SELECT CITY_ID, CITY_NAME,PHONE_CODE,COUNTRY_ID FROM SETUP_CITY ORDER BY CITY_NAME
	</cfquery>
	<cf_box title="#getLang('','Mikro Bölge Lokasyon Değişikliği',52020)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform action="" method="post" name="formexport" enctype="multipart/form-data">
			<cf_box_elements>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfif isdefined("attributes.cpid")>
						<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.cpid#</cfoutput>">
					</cfif>
					<cfinput type="hidden" name="is_submitted" id="is_submitted" value="1">
					<!--- Kontroller icin surec eklenmesi gerekiyor, kaldirmayin fbs --->
					<cfif Len(GET_RELATED.depo_status)>
						<div class="form-group"><div style="display:none;"><cf_workcube_process is_upd='0' select_value="#GET_RELATED.DEPO_STATUS#" process_cat_width='150' is_detail='0'></div></div>
					</cfif>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.cpid")><cfoutput>#attributes.cpid#</cfoutput></cfif>">
								<cfif isdefined("attributes.cpid")>
									<cfquery name="GET_FULL" datasource="#dsn#">
										SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #attributes.cpid#
									</cfquery>
									<input type="text" name="company_name" id="company_name" value="<cfoutput>#get_full.fullname#</cfoutput>">
								<cfelse>
									<cfinput type="text" name="company_name" id="company_name" value="">
								</cfif>
								<cfinput type="hidden" name="partner_id" id="partner_id" value="">
								<cfinput type="hidden" name="partner_name" id="partner_name" readonly="" value="">								
								<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multiuser_company&field_id=formexport.partner_id&field_comp_name=formexport.company_name&field_name=formexport.partner_name&field_comp_id=formexport.consumer_id&is_sales=1&is_single=1&select_list=2,6');"></span>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='722.IMS Bölge Kodu'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<cfinput type="hidden" name="ims_code_id" id="ims_code_id" value="">
							<cfinput type="text" name="ims_code_name" readonly="yes" value="">
							<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=formexport.ims_code_name&field_id=formexport.ims_code_id');return false" tabindex="4"></span>
						</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="country" id="country" onchange="LoadCity(this.value,'city','county_id',0);">
								<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
								<cfquery name="get_country" datasource="#dsn#">
									SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY 
								</cfquery>
								<cfoutput query="get_country">
									<option value="#country_id#">#country_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="city" id="city" onchange="LoadCounty(this.value,'county_id');">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfif isdefined('attributes.country') and len(attributes.country)>
										<cfquery name="get_city" datasource="#dsn#">
											SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID, PLATE_CODE FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#"> ORDER BY CITY_NAME 
										</cfquery>
										<cfoutput query="get_city">
											<option value="#city_id#;#phone_code#">#city_name#</option>
										</cfoutput>
									</cfif>
								</select>
							</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58638.Ilçe'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="county_id" id="county_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfif isdefined('attributes.city') and len(attributes.city)>
									<cfquery name="get_county" datasource="#DSN#">
										SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#"> ORDER BY COUNTY_NAME
									</cfquery>
									<cfoutput query="get_county">
										<option value="#county_id#">#county_name#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div> 
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='720.Semt'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="text" name="semt" maxlength="30" value="" tabindex="16">
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons type_format="1" is_upd='0' add_function="control()&&loadPopupBox('formexport')">
			</cf_box_footer>
		</cfform>
	</cf_box>
		<script type="text/javascript">
			function control()
			{ 
				if(formexport.company_name.value == "")
				{
					alert("<cf_get_lang no='574.Lütfen Müşteri Seçiniz'> !"); 
					return false;
				}
				return process_cat_control();
				loadPopupBox('formexport' , <cfoutput>#attributes.modal_id#</cfoutput>);
			} 
		</script>
<cfelse>
	<cfquery name="UPD_COMPANY" datasource="#dsn#">
		UPDATE 
			COMPANY 
		SET 
			<cfif len(attributes.ims_code_id)>IMS_CODE_ID = #attributes.ims_code_id#,</cfif>
			<cfif ListLen(attributes.city)>
				CITY = #ListFirst(attributes.city,';')#,
				COMPANY_TELCODE = '#ListLast(attributes.city,';')#',
				COMPANY_FAX_CODE = '#ListLast(attributes.city,';')#',
			</cfif>
			<cfif len(attributes.county_id)>COUNTY = #attributes.county_id#,</cfif>
			<cfif len(attributes.semt)>SEMT = '#attributes.semt#',</cfif>
			FULLNAME = '#attributes.company_name#'
		WHERE 
			COMPANY_ID = #attributes.consumer_id#
	</cfquery>
	<cfoutput>
		<cfif len(get_related.depo_status)>
			<cfset max_branch_id = get_related.related_id>
			<cfset cpid = attributes.cpid>
			<cfset is_insert_type = 5>
			<cfset related_id = get_related.related_id>
			<cfset is_noalert = 1>
			
			<cf_workcube_process 
				is_upd='1' 
				process_stage='#get_related.depo_status#' 
				record_member='#session.ep.userid#' 
				record_date='#now()#' 
				action_page='#request.self#?fuseaction=crm.form_upd_company&cpid=#attributes.cpid#' 
				action_id='#attributes.cpid#'
				old_process_line='#get_related.depo_status#' 
				warning_description = 'Müşteri : #attributes.company_name#'>
		</cfif>
	</cfoutput>
	<script type="text/javascript">
		location.href = document.referrer;
	</script>
</cfif>


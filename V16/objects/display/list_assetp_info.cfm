<cfinclude template="../query/get_assetp.cfm">
<cfquery name="GET_ASSET_CONTRACT" datasource="#DSN#">
	SELECT 
		ASSET_ID, 
		SUPPORT_COMPANY_ID, 
		SUPPORT_AUTHORIZED_ID, 
		SUPPORT_EMPLOYEE_ID,
		SUPPORT_START_DATE, 
		SUPPORT_FINISH_DATE, 
		SUPPORT_CAT_ID, 
		USE_CERTIFICATE, 
		DETAIL
	FROM 
		ASSET_CARE_CONTRACT 
	WHERE	
		ASSET_ID = #URL.ASSETP_ID#
</cfquery>
<cfquery name="GET_VEHICLE_INFO" datasource="#DSN#">
	SELECT 
		MOTORIZED_VEHICLE,
		ASSETP_CATID 
	FROM 
		ASSET_P_CAT 
	WHERE 
		ASSETP_CATID = #GET_ASSETP.ASSETP_CATID#
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Fiziki Varlık','58833')#:#GET_ASSETP.ASSETP#" popup_box="1">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-assetp_cats">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfif len(GET_ASSETP.ASSETP_CATID)>
							<cfinclude template="../query/get_assetp_cats.cfm">
							<cfoutput>#GET_ASSETP_CATS.ASSETP_CAT#</cfoutput>
						</cfif>
					</div>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-assetp_name">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32605.Varlık Adı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfoutput>#GET_ASSETP.ASSETP#</cfoutput>
					</div>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-assetp_dep">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfif len(GET_ASSETP.DEPARTMENT_ID)>
							<cfset attributes.department_id = GET_ASSETP.DEPARTMENT_ID>
							<cfinclude template="../query/get_assetp_department.cfm">
							<cfoutput>#GET_ASSETP_DEP.ZONE_NAME# / #GET_ASSETP_DEP.BRANCH_NAME# /#GET_ASSETP_DEP.DEPARTMENT_HEAD#</cfoutput>
						</cfif>
					</div>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-assetp_emp">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfif len(GET_ASSETP.POSITION_CODE)>
							<cfoutput>#get_emp_info(GET_ASSETP.POSITION_CODE,1,0)#</cfoutput>
						</cfif>
					</div>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-assetp_detail">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfoutput>#GET_ASSETP.ASSETP_DETAIL#</cfoutput>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_seperator id="care_support" title="#getLang('','Bakım Destek Anlaşması','32606')#">
		<div id="care_support" class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<div class="form-group" id="item-support_contract">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32607.Destek Firma - Yetkili'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfif len(GET_ASSET_CONTRACT.SUPPORT_AUTHORIZED_ID)>
						<cfoutput>#get_par_info(GET_ASSET_CONTRACT.SUPPORT_AUTHORIZED_ID,0,0,0)#</cfoutput>
					</cfif>
				</div>
			</div>
			<div class="form-group" id="item-support_emp">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32608.Destek Çalışan'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfif len(GET_ASSET_CONTRACT.SUPPORT_EMPLOYEE_ID)>
						<cfoutput>#get_emp_info(GET_ASSET_CONTRACT.SUPPORT_EMPLOYEE_ID,0,0)#</cfoutput>
					</cfif>
				</div>
			</div>
			<div class="form-group" id="item-support_date">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32609.Destek Tarih'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfif len(GET_ASSET_CONTRACT.SUPPORT_START_DATE)>
						<cfoutput>#dateformat(GET_ASSET_CONTRACT.SUPPORT_START_DATE,dateformat_style)#</cfoutput>
						</cfif>
						-
						<cfif len(GET_ASSET_CONTRACT.SUPPORT_FINISH_DATE)>
					<cfoutput>#dateformat(GET_ASSET_CONTRACT.SUPPORT_FINISH_DATE,dateformat_style)#</cfoutput>
					</cfif>
				</div>
			</div>
			<div class="form-group" id="item-support_cat">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32610.Destek Kategorisi'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfif len(GET_ASSET_CONTRACT.SUPPORT_CAT_ID)>
						<cfset attributes.asset_state_id=GET_ASSET_CONTRACT.SUPPORT_CAT_ID>
						<cfinclude template="../query/get_asset_state.cfm">
						<cfoutput>#GET_ASSET_STATE.ASSET_STATE#</cfoutput>
					</cfif>
				</div>
			</div>
			<div class="form-group" id="item-document">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32611.Destek Belgesi'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfif len(GET_ASSET_CONTRACT.USE_CERTIFICATE)>
						<a href="<cfoutput>asset/#get_asset_contract.use_certificate#</cfoutput>" target="_blank"><cf_get_lang dictionary_id='57468.Belge'></a>
					<cfelse>
						<cf_get_lang dictionary_id='32612.Ekli Belge Bulunamadı'> !
					</cfif>
				</div>
			</div>
			<div class="form-group" id="item-detail">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfoutput>#GET_ASSET_CONTRACT.DETAIL#</cfoutput>
				</div>
			</div>
		</div>
		<cfif get_vehicle_info.motorized_vehicle eq 1>
			<cfquery name="GET_ASSETP_INFOPLUS" datasource="#DSN#">
				SELECT
					PROPERTY1,
					PROPERTY2,
					PROPERTY3,
					PROPERTY4,
					PROPERTY5
				FROM
					ASSET_P_INFO_PLUS
				WHERE
					ASSETP_ID=#URL.ASSETP_ID#
			</cfquery>
			<cf_seperator id="care_support" title="#getLang('','Araç Bilgisi','33104')#">
			<div id="care_support" class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cfoutput>
					<div class="form-group" id="item-support_contract">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57632.Özellik'> 1</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif len(GET_ASSETP_INFOPLUS.PROPERTY1)>#GET_ASSETP_INFOPLUS.PROPERTY1#</cfif>
						</div>
					</div>
					<div class="form-group" id="item-support_contract">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57632.Özellik'> 2</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif len(GET_ASSETP_INFOPLUS.PROPERTY2)>#GET_ASSETP_INFOPLUS.PROPERTY2#</cfif>
						</div>
					</div>
					<div class="form-group" id="item-support_contract">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57632.Özellik'> 3</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif len(GET_ASSETP_INFOPLUS.PROPERTY3)>#GET_ASSETP_INFOPLUS.PROPERTY3#</cfif>
						</div>
					</div>
					<div class="form-group" id="item-support_contract">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57632.Özellik'> 4</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif len(GET_ASSETP_INFOPLUS.PROPERTY4)>#GET_ASSETP_INFOPLUS.PROPERTY4#</cfif>
						</div>
					</div>
					<div class="form-group" id="item-support_contract">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57632.Özellik'> 5</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif len(GET_ASSETP_INFOPLUS.PROPERTY5)>#GET_ASSETP_INFOPLUS.PROPERTY5#</cfif>
						</div>
					</div>
				</cfoutput>
			</div>
		</cfif>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cf_box_footer>
				<cf_record_info query_name="GET_ASSETP">
			</cf_box_footer>
		</div>
	</cf_box>
</div>

<cfinclude template="../query/get_branchs_deps.cfm">
<cfinclude template="../query/get_assetp.cfm">
<cfquery name="GET_ASSET" datasource="#DSN#">
	SELECT ASSETP_ID, ASSETP_CATID FROM ASSET_P WHERE ASSETP_ID = #URL.ASSETP_ID#
</cfquery>
<cfquery name="GET_ASSET_P" datasource="#DSN#">
	SELECT ASSETP_CATID, IT_ASSET, MOTORIZED_VEHICLE, ASSETP_RESERVE FROM ASSET_P_CAT WHERE ASSETP_CATID = #GET_ASSET.ASSETP_CATID#
</cfquery>
<cfquery name="GET_ASSETP_IT" datasource="#dsn#">
	SELECT ASSETP_ID FROM ASSET_P_IT WHERE ASSETP_ID = #URL.ASSETP_ID#
</cfquery>
<cfquery name="CONTROL3" datasource="#DSN#">
	SELECT ASSETP_ID FROM ASSET_P_INFO_PLUS WHERE ASSETP_ID = #URL.ASSETP_ID#
</cfquery>
<cfquery name="cat_control" datasource="#dsn#">
	SELECT LIBRARY FROM ASSET_P_CAT WHERE ASSETP_CATID = #get_assetp.assetp_catid#
</cfquery>
<cfsavecontent variable="right">
	<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=assetcare.popup_asset_history&&asset_id=#url.assetp_id#</cfoutput>','list')"><i class="icon-fa fa-history" style="color:#656565;" alt="<cf_get_lang_main no='61.Tarihçe'>" title="<cf_get_lang_main no='61.Tarihçe'>"></i></a>
</cfsavecontent>
<cf_box title="#getLang('main',1421)#: <cfif LEN(get_assetp.assetp)><cfoutput>#get_assetp.assetp#</cfoutput></cfif>" right_images="#right#" collapsable="0" resize="0">
	<cf_box_elements>
			<label class="col col-3 col-xs-12"><b><cf_get_lang_main no='1466.Demirbaş No'></b></label>
			<label class="col col-9 col-xs-12"><cfif LEN(get_assetp.inventory_number)><cfoutput>#get_assetp.inventory_number#</cfoutput></cfif></label>
		
			<label class="col col-3 col-xs-12"><b><cf_get_lang no='35.Varlık Adı'></b></label>
			<label class="col col-9 col-xs-12"><cfif LEN(get_assetp.assetp)><cfoutput>#get_assetp.assetp#</cfoutput></cfif></label>
			<label class="col col-3 col-xs-12"><b><cf_get_lang_main no ='344.Durum'></b></label>
			<label class="col col-9 col-xs-12">
				<cfif len(get_assetp.assetp_status)>
					<cfquery name="get_asset_state" datasource="#DSN#">
						SELECT ASSET_STATE_ID,ASSET_STATE FROM ASSET_STATE WHERE  ASSET_STATE_ID = #get_assetp.assetp_status#
					</cfquery>
						<cfif get_asset_state.RECORDCOUNT><CFOUTPUT>#get_asset_state.asset_state#</CFOUTPUT></cfif>
				</cfif>
			</label>
			<label class="col col-3 col-xs-12"><b><cf_get_lang_main no='74.Kategori'></b></label>
			<label class="col col-9 col-xs-12">
				<cfif len(get_assetp.assetp_catid)>
					<cfquery name="GET_ASSETP_CATS" datasource="#dsn#">
						SELECT ASSETP_CAT FROM  ASSET_P_CAT WHERE ASSETP_CATID = #get_assetp.assetp_catid#
					</cfquery>
					<cfif GET_ASSETP_CATS.recordcount>
						<cfoutput>#GET_ASSETP_CATS.assetp_cat#</cfoutput>
					</cfif>
				</cfif>
			</label>
			<label class="col col-3 col-xs-12"><b><cf_get_lang_main no='160.Departman'></b></label>
			<label class="col col-9 col-xs-12">
				<cfif len(get_assetp.department_id)>
					<cfquery name="GET_BRANCHS_DEPS" datasource="#dsn#">
						SELECT 
							DEPARTMENT.DEPARTMENT_ID, 
							DEPARTMENT.BRANCH_ID,
							DEPARTMENT.DEPARTMENT_HEAD,
							BRANCH.BRANCH_ID,
							BRANCH.BRANCH_NAME
						FROM 
							BRANCH,
							DEPARTMENT 
						WHERE
							BRANCH.BRANCH_ID=DEPARTMENT.BRANCH_ID
                            AND DEPARTMENT.DEPARTMENT_ID = #get_assetp.department_id#
						ORDER BY
							BRANCH.BRANCH_NAME,
							DEPARTMENT.DEPARTMENT_HEAD
					</cfquery>
				 <cfif GET_BRANCHS_DEPS.recordcount><cfoutput>#GET_BRANCHS_DEPS.branch_name#-#GET_BRANCHS_DEPS.department_head#</cfoutput></cfif>
				</cfif>
			</label>
			<label class="col col-3 col-xs-12"><b><cf_get_lang_main no='132.Sorumlu'> 1</b></label>
			<label class="col col-9 col-xs-12">
				<cfif len(get_assetp.position_code)>
					<cfoutput>#get_emp_info(get_assetp.position_code,1,0)#</cfoutput>
				</cfif>
			</label>
			<label class="col col-3 col-xs-12"><b><cf_get_lang_main no='132.Sorumlu'> 2</b></label>
			<label class="col col-9 col-xs-12">
				<cfif len(get_assetp.position_code2)>
					<CFOUTPUT>#get_emp_info(get_assetp.position_code2,0,0)#</CFOUTPUT>
				</cfif>
			</label>
			<label class="col col-3 col-xs-12"><b><cf_get_lang_main no='217.Açıklama'></b></label>
			<label class="col col-9 col-xs-12"><cfif len(get_assetp.assetp_detail)><cfoutput>#get_assetp.assetp_detail#</cfoutput></cfif></label>
</cf_box_elements>
</cf_box>

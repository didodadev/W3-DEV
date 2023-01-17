<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='42719.Özlük Belge Kategorileri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_employment_asset_cat" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_employment_asset_cat.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform action="#request.self#?fuseaction=settings.emptypopup_employment_asset_cat_upd" method="post" name="driver_licence" >
				<cfquery name="CATEGORY" datasource="#dsn#">
					SELECT 
    	                ASSET_CAT_ID, 
                        #dsn#.Get_Dynamic_Language(SETUP_EMPLOYMENT_ASSET_CAT.ASSET_CAT_ID,'#session.ep.language#','SETUP_EMPLOYMENT_ASSET_CAT','ASSET_CAT',NULL,NULL,SETUP_EMPLOYMENT_ASSET_CAT.ASSET_CAT) AS ASSET_CAT, 
                        RECORD_EMP, 
                        RECORD_IP, 
                        RECORD_DATE, 
                        UPDATE_EMP, 
                        UPDATE_IP, 
                        UPDATE_DATE, 
                        IS_LAST_YEAR_CONTROL, 
                        HIERARCHY, 
                        UPPER_ASSET_CAT_ID, 
                        USAGE_YEAR, 
                        SPECIAL_HIERARCHY,
                        IS_VIEW_MYHOME,
						SEQUENCE_NO
                    FROM 
	                    SETUP_EMPLOYMENT_ASSET_CAT 
                    WHERE 	
	                    ASSET_CAT_ID=#URL.ID#
				</cfquery>
				<input type="Hidden" name="asset_cat_id" id="asset_cat_id" value="<cfoutput>#url.id#</cfoutput>">
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="upper_asset_cat_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29736.Üst Kategori'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="upper_asset_cat_id" id="upper_asset_cat_id">
									<option value=""><cf_get_lang dictionary_id='29736.Üst Kategori'></option>
										<cfoutput query="get_upper_cats">
											<option value="#asset_cat_id#" <cfif CATEGORY.upper_asset_cat_id eq get_upper_cats.asset_cat_id>selected</cfif>>#asset_cat#</option>
										</cfoutput>
								</select>
                            </div>
                        </div>
                        <div class="form-group" id="asset_cat">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='55455.Konu Girmelisiniz'>!</cfsavecontent>
									<cfinput type="Text" name="asset_cat" id="asset_cat" size="20" value="#category.asset_cat#" maxlength="100" required="Yes" message="#message#">
									<span class="input-group-addon">
										<cf_language_info	
											table_name="SETUP_EMPLOYMENT_ASSET_CAT"
											column_name="ASSET_CAT" 
											column_id_value="#URL.ID#" 
											maxlength="500" 
											datasource="#dsn#" 
											column_id="ASSET_CAT_ID" 
											control_type="0">
									</span>
								</div>
                            </div>
                        </div>
						<div class="form-group" id="SPECIAL_HIERARCHY">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" value="<cfoutput>#category.SPECIAL_HIERARCHY#</cfoutput>" name="SPECIAL_HIERARCHY" id="SPECIAL_HIERARCHY" maxlength="5">
                            </div>
                        </div>
						<div class="form-group" id="sequence_no">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37624.Sıra no'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="number" value="<cfoutput>#category.SEQUENCE_NO#</cfoutput>" name="sequence_no" id="sequence_no">
                            </div>
                        </div>
						<div class="form-group" id="USAGE_YEAR">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42724.Kullanım Süresi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="Text" name="USAGE_YEAR" value="#category.USAGE_YEAR#" validate="integer" maxlength="2"  message="Kullanım Süresi Hatalı!">
                            </div>
                        </div>
						<div class="form-group" id="IS_LAST_YEAR_CONTROL">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42740.Bitiş Yılı'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="checkbox" value="1" name="IS_LAST_YEAR_CONTROL" id="IS_LAST_YEAR_CONTROL" <cfif category.IS_LAST_YEAR_CONTROL eq 1>checked</cfif>><cf_get_lang dictionary_id='42748.Kontrol Edilsin'>
                            </div>
                        </div>
						<div class="form-group" id="IS_VIEW_MYHOME">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="checkbox" value="1" name="IS_VIEW_MYHOME" id="IS_VIEW_MYHOME" <cfif category.IS_VIEW_MYHOME eq 1>checked</cfif>><cf_get_lang dictionary_id='64087.Bilgilerim sayfasında görüntülensin'>
                            </div>
                        </div>
					</div>
				</cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<cf_box_footer>
						<cf_record_info query_name="category">
						<cfset Upd_Control = 0>
						<cfquery name="Upd_Hierachy_Control" datasource="#dsn#">
							SELECT
								ASSET_CAT_ID
							FROM
								SETUP_EMPLOYMENT_ASSET_CAT
							WHERE
								<cfif Url.Id is Category.Hierarchy>
									<!--- Ust Kategori ise kendisi veya tum alt kategorilerinden herhangi birinde kayit varsa silinmez --->
									HIERARCHY LIKE '#ListFirst(CATEGORY.HIERARCHY,'.')#' OR
									HIERARCHY LIKE '#ListFirst(CATEGORY.HIERARCHY,'.')#.%'
								<cfelse>
									<!--- Alt kategori ise sadece kendisinde kayit varsa silinmez, ust ve paralel kategorilere bakmaz  --->
									HIERARCHY LIKE '#ListFirst(CATEGORY.HIERARCHY,'.')#.#Url.Id#'
								</cfif>
						</cfquery>
						<cfif Upd_Hierachy_Control.RecordCount>
							<cfquery name="Get_Record_Control" datasource="#dsn#">
								SELECT ASSET_CAT_ID FROM EMPLOYEE_EMPLOYMENT_ROWS WHERE ASSET_CAT_ID IN (#ValueList(Upd_Hierachy_Control.Asset_Cat_Id,',')#)
							</cfquery>
							<cfset Upd_Control = Get_Record_Control.RecordCount>
						</cfif>
						<cfif Upd_Control gt 0>
							<cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()">
						<cfelse>
							<cf_workcube_buttons is_upd='1' add_function="kontrol()" delete_page_url='#request.self#?fuseaction=settings.emptypopup_employment_asset_cat_del&asset_cat_id=#url.id#'>
						</cfif>
					</cf_box_footer>
				</div>
			</cfform>
    	</div>
  	</cf_box>
</div>
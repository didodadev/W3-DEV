<cfquery name="get_kont" datasource="#DSN#" maxrows="1">
	SELECT
		EDUCATION
	FROM
		EMPLOYEES_RELATIVES
	WHERE
		EDUCATION=#attributes.EDU_ID#
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='40749.Eğitim Seviyeleri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_edu_level" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_edu_level.cfm">
			<cfset attributes.upd_edu_id=attributes.edu_id>
			<cfinclude template="../query/get_edu_level.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="add_edu_level" action="#request.self#?fuseaction=settings.emptypopup_upd_edu_level">
			<input type="hidden" name="edu_id" id="edu_id" value="<cfoutput>#attributes.upd_edu_id#</cfoutput>">
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="is_aktif">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12"> &nbsp </div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <input type="checkbox" name="is_aktif" id="is_aktif" value="1" <cfif get_edu.is_active eq 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
                            </div>
                        </div>
                        <div class="form-group" id="edu_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31551.Okul Türü'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="edu_type" id="edu_type">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<option value="0"<cfif get_edu.edu_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58156.Diğer'></option>
									<option value="1"<cfif get_edu.edu_type eq 1>selected</cfif>><cf_get_lang dictionary_id='55680.Lise'></option>
									<option value="2"<cfif get_edu.edu_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29755.Üniversite'></option>
									<option value="3"<cfif get_edu.edu_type eq 3>selected</cfif>><cf_get_lang dictionary_id='30483.Yüksek Lisans'></option>
									<option value="4"<cfif get_edu.edu_type eq 4>selected</cfif>><cf_get_lang dictionary_id='44296.Doktora'></option>
                                </select>
                            </div>
                        </div>
						<div class="form-group" id="declaration_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='820.SGK İşe Giriş Bildirgesi Tipi'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="declaration_id" id="declaration_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="0" <cfif get_edu.DECLARATION_ID eq 0>selected</cfif>><cf_get_lang dictionary_id='41869.Bilinmeyen'></option>
                                    <option value="1" <cfif get_edu.DECLARATION_ID eq 1>selected</cfif>><cf_get_lang dictionary_id='41896.Okur yazar değil'></option>
                                    <option value="2" <cfif get_edu.DECLARATION_ID eq 2>selected</cfif>><cf_get_lang dictionary_id='55678.İlkokul'></option>
                                    <option value="3" <cfif get_edu.DECLARATION_ID eq 3>selected</cfif>><cf_get_lang dictionary_id='41886.Ortaokul yada İ.Ö.O'></option>
                                    <option value="4" <cfif get_edu.DECLARATION_ID eq 4>selected</cfif>><cf_get_lang dictionary_id='833.Lise veya Dengi Okul'></option>
                                    <option value="5" <cfif get_edu.DECLARATION_ID eq 5>selected</cfif>><cf_get_lang dictionary_id='41871.Yüksek okul veya fakülte'></option>
                                    <option value="6" <cfif get_edu.DECLARATION_ID eq 6>selected</cfif>><cf_get_lang dictionary_id='30483.Yüksek lisans'></option>
                                    <option value="7" <cfif get_edu.DECLARATION_ID eq 7>selected</cfif>><cf_get_lang dictionary_id='44296.Doktora'></option>
                                </select>
                            </div>                           
                        </div>
                        <div class="form-group" id="edu_cat_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42669.Eğitim Seviyesi'>*</label>
                            <div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='42644.Eğitim Seviyesi girmelisiniz'>!</cfsavecontent>
										<cfinput type="Text" name="edu_cat_name" id="edu_cat_name" size="60" value="#GET_EDU.EDUCATION_NAME#" maxlength="50" required="Yes" message="#message#">
										<span class="input-group-addon">
											<cf_language_info 
											table_name="SETUP_EDUCATION_LEVEL" 
											column_name="EDUCATION_NAME" 
											column_id_value="#url.edu_id#" 
											maxlength="500" 
											datasource="#dsn#" 
											column_id="EDU_LEVEL_ID" 
											control_type="0">
										</span>
								</div>
                            </div>
                        </div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_record_info query_name="GET_EDU">
					<cfif get_kont.recordcount>
						<cf_workcube_buttons is_upd='1' is_delete='0'  add_function="kontrol()">
					<cfelse>
						<cf_workcube_buttons is_upd='1'  add_function="kontrol()" delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_edu_level&edu_id=#attributes.edu_id#'>
					</cfif>
				</cf_box_footer>
			</cfform>
    	</div>
  	</cf_box>
</div>

<div class="col col-12 col-xs-12">
	<cf_box title="#getLang('','settings',32653)#" add_href="#request.self#?fuseaction=settings.form_add_guaranty_cat" is_blank="0"><!--- Garanti Kategorisi --->
		<cfform name="guaranty_form" method="post" action="#request.self#?fuseaction=settings.emptypopup_guaranty_cat_upd">
			<cf_box_elements>	
				<cfquery name="CATEGORY" datasource="#dsn#">
					SELECT 
        	            CURRENCY, 
                        GUARANTYCAT_ID,
						#dsn#.Get_Dynamic_Language(GUARANTYCAT_ID,'#session.ep.language#','SETUP_GUARANTY','GUARANTYCAT',NULL,NULL,GUARANTYCAT) AS GUARANTYCAT, 
                        GUARANTYCAT_TIME, 
                        MAX_GUARANTYCAT_TIME, 
                        DETAIL, 
                        RECORD_DATE, 
                        RECORD_EMP, 
                        RECORD_IP, 
                        UPDATE_DATE, 
                        UPDATE_EMP, 
                        UPDATE_IP 
                    FROM 
    	                SETUP_GUARANTY 
                    WHERE 
	                    GUARANTYCAT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
				</cfquery>
				<input type="Hidden" name="guarantyCat_ID" id="guarantyCat_ID" value="<cfoutput>#URL.ID#</cfoutput>">

				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
					<cfinclude template="../display/list_guaranty_cat.cfm">
				</div>
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="form-group" id="item-guarantyCat">
							<label class="col col-4 col-md-4 col-xs-12"></label>
							  <div class="col col-3 col-md-3 col-xs-12"><cf_get_lang_main dictionary_id='57493.Aktif'>
								<input type="Checkbox" name="currency" id="currency" <cfif category.currency>checked</cfif>>
							</div>
							</div>
						<div class="form-group" id="item-guarantyCat">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'> *</label>
							<div class="col col-8 col-md-6 col-xs-12">
								<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'></cfsavecontent>
									<cfinput type="Text" name="guarantyCat" id="guarantyCat" value="#category.guarantyCat#" maxlength="50" required="Yes" message="#message#">
									<span class="input-group-addon">
									<cf_language_info
										table_name="SETUP_GUARANTY"
										column_name="GUARANTYCAT"
										column_id_value="#URL.ID#"
										maxlength="500"
										datasource="#dsn#" 
										column_id="GUARANTYCAT_ID" 
										control_type="0">
									</span>
							 </div>
						  </div>
						 </div>
						 <div class="form-group small" id="item-guarantyCat">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main dictionary_id='29513.Süre'></label>
							<div class="col col-3 col-md-3 col-xs-12">
								<cfquery name="get_guarantycat_time" datasource="#dsn#">
									SELECT * FROM SETUP_GUARANTYCAT_TIME ORDER BY GUARANTYCAT_TIME
								</cfquery>
								<select name="guarantycat_time_" id="guarantycat_time_">
									<cfoutput query="get_guarantycat_time">
										<option value="#guarantycat_time_id#" <cfif guarantycat_time_id eq category.guarantycat_time>selected</cfif>>#guarantycat_time# <cf_get_lang_main dictionary_id='58724.Ay'></option>
									</cfoutput>
								</select>								
							</div>
						 </div>
						 <div class="form-group" id="item-max_guaranty_time_">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42758.Azami garanti süresi'>*</label>
							<div class="col col-2 col-md-2 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='42758.Azami Garanti Süresi'>!</cfsavecontent>
									<input type="text" name="max_guaranty_time_" id="max_guaranty_time_" value="<cfoutput>#category.max_guarantycat_time#</cfoutput>" onkeyup="isNumber(this);" style="width:170px;">
									</div>
							<div class="col col-1 col-md-1 col-xs-12"><cf_get_lang_main dictionary_id='57490.gün'></div>
						 </div>
						 <div class="form-group" id="item-detail">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42009.Ayrıntı'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<Textarea name="detail" id="detail" style="width:170px;height:60px;"><cfoutput>#category.detail#</cfoutput></Textarea>
							</div>
					</div></div>
			    </div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="category">
				<cfif CATEGORY.recordcount>
					<cf_workcube_buttons add_function='kontrol()' is_upd='1' is_delete='0'>
				<cfelse>
					<cf_workcube_buttons add_function='kontrol()' is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_guaranty_cat_del&guarantycat_id=#URL.ID#'>
				</cfif>
		</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
    function kontrol()
	{
		if(document.getElementById("guarantyCat").value == '')
		{
			alert('<cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'>!')
			return false;
		}
		else if(document.getElementById("max_guaranty_time_").value == '')
		{
			alert('<cf_get_lang dictionary_id='42758.Azami Garanti Süresi'>!')
			return false;
		}
	}

</script>
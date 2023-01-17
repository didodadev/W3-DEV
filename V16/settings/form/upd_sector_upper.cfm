<cfquery name="SECTOR_UPPER" datasource="#DSN#">
    SELECT 
        #dsn#.Get_Dynamic_Language(SECTOR_UPPER_ID,'#session.ep.language#','SETUP_SECTOR_CAT_UPPER','SECTOR_CAT',NULL,NULL,SECTOR_CAT) AS SECTOR_CAT,
        SECTOR_CAT_CODE,
        IS_INTERNET,
        SECTOR_IMAGE,
        SERVER_SECTOR_IMAGE_ID,
        RECORD_EMP,
        RECORD_DATE,
        UPDATE_EMP,
        UPDATE_DATE 
    FROM 
        SETUP_SECTOR_CAT_UPPER 
    WHERE 
        SECTOR_UPPER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sector_upper_id#">
</cfquery>

<cf_box title="#getLang('','Üst Sektör Güncelle',43646)#" uidrop="1"  add_href="#request.self#?fuseaction=settings.form_add_sector_upper" >
<cfform action="#request.self#?fuseaction=settings.emptypopup_sector_upper_upd" method="post" name="upd_sector_upper" enctype="multipart/form-data">
    <input type="Hidden" name="sector_upper_id" id="sector_upper_id" value="<cfoutput>#sector_upper_id#</cfoutput>">
        <cf_box_elements>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                <div class="form-group" >
                    <label class="col col-4  col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'> *</label>
                        <div class="col col-8  col-xs-12"> 
                        <div class="input-group"> 
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık girmelisiniz'></cfsavecontent>
                                <cfinput type="Text" name="sector_cat" id="sector_cat" value="#sector_upper.sector_cat#" maxlength="255" required="Yes" message="#message#">
                                 <span class="input-group-addon ">
                                    <cf_language_info 
                                        table_name="SETUP_SECTOR_CAT_UPPER" 
                                        column_name="SECTOR_CAT" 
                                        column_id_value="#attributes.sector_upper_id#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="SECTOR_UPPER_ID" 
                                        control_type="0">
                                </span>
                        </div>
                        </div>
                </div>

                <div class="form-group">
                    <label class="col col-4  col-xs-12"><cf_get_lang dictionary_id='58585.Kod'></label>
                    <div class="col col-8  col-xs-12"> 
                        <input type="text" name="sector_cat_code" id="sector_cat_code" value="<cfoutput>#sector_upper.sector_cat_code#</cfoutput>" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4  col-xs-12"><cf_get_lang dictionary_id='29762.İmaj'></label>
                    <div class="col col-8  col-xs-12"> 
                        <div class="col col-12 input-group">
                        <input type="file" name="sector_image" id="sector_image" >
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-xs-12"></label>
                    <div class="col col-8 col-xs-12">
                        <input type="checkbox" name="is_internet" id="is_internet" <cfif sector_upper.is_internet eq 1>checked </cfif>> <cf_get_lang dictionary_id='43478.İnternette Yayımlansın'>
                    </div>
                </div>

                </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-6 col-xs-12">
                <!--- <div class="form-group">
                    <label><cf_get_lang dictionary_id='57483.Kayıt'> :</label>
                    <cfoutput>
                        <cfif len(sector_upper.record_emp)>#get_emp_info(sector_upper.record_emp,0,0)#</cfif>
                        <cfif len(sector_upper.record_date)>#dateformat(sector_upper.record_date,dateformat_style)#</cfif>
                        <cfif len(sector_upper.update_emp)>
                </div>
                <div class="form-group">
                    <label><cf_get_lang dictionary_id='57891.Guncelleyen'> :</label>
                            #get_emp_info(sector_upper.update_emp,0,0)#
                            #dateformat(sector_upper.update_date,dateformat_style)#
                        </cfif>
                    </cfoutput> --->
                <div class="form-group">
                    <cfif len(sector_upper.sector_image)>
                        <tr class="color-border">
                            <cfoutput query="sector_upper">
                                <td colspan="2">
                                    <cf_get_server_file output_file="settings/#sector_image#" output_server="#sector_upper.server_sector_image_id#" output_type="0" image_width="295" image_height="200" >
                                </td>
                            </cfoutput>
                        </tr>
                    </cfif>
                </div>
                </div>

            </div>
           
				<cf_record_info query_name="SECTOR_UPPER" >
                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_sector_upper_del&sector_upper_id=#url.sector_upper_id#' add_function="check_catid()">
          
       </cf_box_footer>
</cfform>
</cf_box>

<script type="text/javascript">
	function check_catid(id)
	{
		id = document.getElementById('sector_cat_code').value;
		current_id = <cfif len(sector_upper.sector_cat_code)><cfoutput>#sector_upper.sector_cat_code#</cfoutput><cfelse>''</cfif>;
		if (id == current_id)
			return true;
		else
		{
			sector_query = 'SELECT SECTOR_UPPER_ID FROM SETUP_SECTOR_CAT_UPPER WHERE SECTOR_CAT_CODE = ' + id;
			result = wrk_query(sector_query,'dsn','10');
			if(result.recordcount > 0)
			{
				alert('Girmiş olduğunuz sektör kodu mevcuttur');
				return false;
			}
		}
	}
</script>

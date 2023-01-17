<cfquery name="get_guaranty_cat" datasource="#dsn#">
	SELECT 
        GUARANTYCAT_ID, 
        GUARANTYCAT, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_GUARANTY
</cfquery>
<div class="col col-12 col-xs-12">
    <cf_box title="#getLang('','Seri No Import','58523')#">
        <cfform name="formexport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=settings.emptypopup_import_seri_no_local">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" item="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Document Format'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format">
                                <option value="utf-8"><cf_get_lang dictionary_id='55929.UTF-8'></option>
                                <option value="iso-8859-9"><cf_get_lang dictionary_id='53845.ISO-8859-9 (Turkish)'></option>
                            </select>                        
                        </div>
                    </div> 
                    <div class="form-group" id="item-uploaded_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">
                        </div>
                    </div>  
                    <div class="form-group" id="item-department_location">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58524.Department - Location'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#listgetat(session.ep.user_location,1,'-')#</cfoutput>">
                                <cfif listlen(session.ep.user_location,'-') gt 2 and len(listgetat(session.ep.user_location,3,'-'))>
                                    <input type="hidden" name="location_id" id="location_id" value="<cfoutput>#listgetat(session.ep.user_location,3,'-')#</cfoutput>">
                                    <cfinput type="text" name="department" value="#get_location_info(listgetat(session.ep.user_location,1,'-'),listgetat(session.ep.user_location,3,'-'))#" required="yes" readonly message="#getLang('', 'Please Select a Department', '58836')#">
                                <cfelse>
                                    <input type="hidden" name="location_id" id="location_id" value="">
                                    <cfinput type="text" name="department" value="" required="yes" readonly message="#getLang('', 'Please Select a Department', '58836')#">
                                </cfif>
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stores_locations&form_name=formexport&field_name=department&field_location_id=location_id&field_id=department_id')"></span>                     
                            </div>     
                        </div>               
                    </div>  
                    <div class="form-group" id="item-category">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42107.Warranty Category'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="guaranty_cat_id" id="guaranty_cat_id">
                                <cfoutput query="get_guaranty_cat">
                                    <option value="#GUARANTYCAT_ID#">#GUARANTYCAT#</option>
                                </cfoutput>
                            </select>                        
                        </div>
                    </div>           
                </div> 
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>                    
                    </div>
                    <div class="form-group" id="item-exp1">
                        <label><b><cf_get_lang dictionary_id='44147.File Content'></b></label> 
                    </div>
                    <div class="form-group" id="item-exp2">
                        *<cf_get_lang dictionary_id='44153.Dosya Virgüller İle Ayrılmış .txt formatında olmalıdır'></br>  
                        *<cf_get_lang dictionary_id='44154.Dosya içersindeki elemanlar virgül sayısına göre alınacağı için boş geçilecek eleman içinde  şeklinde diziliş tamamlanmalıdır!'>           
                    </div>
                    <div class="form-group" id="item-exp3">
                        <label><b><cf_get_lang dictionary_id='44148.Eleman Sırası'></b></label>
                    </div>
                    <div class="form-group" item="item-exp4">
                        1-<cf_get_lang dictionary_id='57518.Stok Kodu'></br>
                        2-<cf_get_lang dictionary_id='44249.Stok Sayısı'></br>
                        3-<cf_get_lang dictionary_id='44151.Garanti Başlama Tarihi'></br>
                        4-<cf_get_lang dictionary_id='44152.Garanti Bitiş Tarihi'></br>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0'>
            </cf_box_footer>        
        </cfform>    
    </cf_box>
</div>

<cfquery name="testSubject" datasource="#dsn#">
	SELECT 
		SUBJECT_ID AS ID,
		CATEGORY_ID,
		SUBJECT,
		ORDER_NO,
		DETAIL,
		IS_ACTIVE,
		TYPE,
		RECORD_DATE,
		RECORD_EMP,
		UPDATE_DATE,
		UPDATE_EMP  
	FROM 
		TEST_SUBJECT
</cfquery>
<cfquery name="testSubjectDetail" dbtype="query">
	SELECT * FROM testSubject WHERE ID=#attributes.id#
</cfquery>
<cfquery name="get_cat" datasource="#dsn#">
	SELECT ID,CATEGORY_NAME FROM TEST_CAT 
</cfquery>
<cfscript>
	WBO_TYPES = QueryNew("TYPE_ID, TYPE_NAME");
	QueryAddRow(WBO_TYPES,2);
	QuerySetCell(WBO_TYPES,"TYPE_ID",11,1);
	QuerySetCell(WBO_TYPES,"TYPE_NAME","Form Update",1);
	QuerySetCell(WBO_TYPES,"TYPE_ID",40,2);
	QuerySetCell(WBO_TYPES,"TYPE_NAME","List",2);
</cfscript>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Test',58826)# #getLang('','Konu Güncelle',61838)#" add_href="#request.self#?fuseaction=settings.add_subject_cat" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
            <table>
				<cfif testSubject.recordcount>
					<cfoutput query="testSubject">
						<tr>
							<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
							<td  style="width:400px;"><a href="#request.self#?fuseaction=settings.upd_cat_subject&id=#id#" class="tableyazi">#subject#</a></td>
						</tr>
					</cfoutput>
				<cfelse>
					 <tr>
						<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
						<td style="width:400px;"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</table>
        </div>
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="upd_subject" id="upd_subject" action="#request.self#?fuseaction=settings.emptypopup_upd_subject_cat&id=#attributes.id#" method="post">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-active">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no ='81.Aktif'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
									<input type="checkbox" name="is_active" id="is_active" <cfif testSubjectDetail.is_active eq 1>checked="checked"</cfif> value="<cfoutput>#testSubjectDetail.is_active#</cfoutput>">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-category_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='20.Kategori Adı'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<select  name="cate_id" id="cate_id" style="width:250px;">
										<option><cf_get_lang_main no ='322.Seçiniz'></option>
										<cfoutput query="get_cat">
											<option value="#id#" <cfif testSubjectDetail.category_id eq id>selected</cfif>>#category_name#</option>
										</cfoutput>
									</select>
								</div>
                            </div>
                        </div>
                        <div class="form-group" id="item-page_type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='657.Sayfa Tipi'></label>
							<div class="col col-4 col-md-8 col-sm-8 col-xs-12">
								<cf_multiselect_check 
								query_name="WBO_TYPES"  
								name="wbo_type"
								width="250" 
								option_value="TYPE_ID"
								option_name="TYPE_NAME" value="#testSubjectDetail.type#">
							</div>
                        </div>
						<div class="form-group" id="item-test_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='333.Konu Adı'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <cftextarea name="test_name" id="test_name" maxlength="250" style="width:350px; height:30px"><cfoutput>#testSubjectDetail.subject#</cfoutput></cftextarea>
                                </div>
                            </div>
                        </div>
						<div class="form-group" id="item-detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <cftextarea name="detail" id="detail" maxlength="400" style="width:350px; height:60px"><cfoutput>#testSubjectDetail.detail#</cfoutput></cftextarea>
                                </div>
                            </div>
                        </div>
						<div class="form-group" id="item-order_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1165.Sıra'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <cfinput type="text" name="order_id" id="order_id" value="#testSubjectDetail.order_no#" maxlength="3" onKeyUp="isNumber(this);" style="width:50px!important">
                                </div>
                            </div>
                        </div>
                    </div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_record_info query_name="testSubjectDetail">
					<cf_workcube_buttons is_upd='1' is_cancel='0' is_delete='0'  add_function="control_()">
                </cf_box_footer>
			</cfform>
		</div>
	</cf_box>
</div>

 <script type="text/javascript">
 	function control_()
	{
		if(document.getElementById('cate_id').value=='')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='20.Kategori Adı'>");
			return false;
		}
		if(document.getElementById('test_name').value=='')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='333.Konu Adı'>");
			return false;
		}
		return true;
	}
 </script>

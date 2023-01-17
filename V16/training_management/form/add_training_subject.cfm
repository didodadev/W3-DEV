<cfscript>
	XFA.add = "training_management.add_training_subject";
	XFA.abort = "training_management.del_folder";
</cfscript>
<cfset cmp = createObject("component","V16.training_management.cfc.training_management")>
<cfset cfc = createObject('component','V16.training_management.cfc.trainingcat')>
<cfset get_training_cat = cfc.get_training_cat()>
<cfset get_training_sec = cfc.get_training_sec()>
<cfset GET_TRAINING_STYLE = cfc.GET_TRAINING_STYLE()>
<cfset GET_MONEY = cfc.GET_MONEY()>
<cfset GET_LANGUAGE = cmp.GET_LANGUAGE_F()>
<cf_xml_page_edit fuseact="training_management.form_add_training_subject">
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cfform name="add_training_management" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_training_subject">
		<cf_box title="#getLang('','Temel Bilgiler',58131)#">
			<cf_box_elements>
				<div class="col col-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">	
                    <div class="form-group" id="item-subject_status">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="checkbox" name="subject_status" id="subject_status" value="1" checked>
                        </div>
                    </div>
                    <div class="form-group" id="item-training_stage">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='180' is_detail='0'>
                        </div>
                    </div>
                    <div class="form-group" id="item-train_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57480.Konu'></cfsavecontent>
                            <cfinput type="text" name="train_head" id="train_head" style="width:424px;"  message="#message#" value="" maxlength="125">
                        </div>
                    </div>
                    <div class="form-group" id="item-training_cat_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="training_cat_id" id="training_cat_id" size="1" onChange="get_tran_sec(this.value)" style="width:160px;">
                                <option value="0"><cf_get_lang dictionary_id='57486.Kategori'></option>
                                <cfoutput query="get_training_cat">
                                    <option value="#training_cat_id#">#training_cat#</option>
                                </cfoutput>
                            </select>		
                        </div>						 
                    </div>
                    <div class="form-group" id="item-training_sec_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57995.Bölüm'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="training_sec_id" id="training_sec_id" size="1">
                                <option value="0"><cf_get_lang dictionary_id='57995.Bölüm'></option>
                            </select>	
                        </div>
                    </div>
                    <div class="form-group" id="item-train_objective">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46007.Amaç'></label>
                        <div class="col col-8 col-xs-12"><textarea type="text" name="train_objective" id="train_objective"></textarea></div>
                    </div>
                    <div class="form-group" id="item-emp_par_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46051.Eğitimci'></label>		
                        <div class="col col-8 col-xs-12">
                            <div class="input-group ">
                                <input type="hidden" name="emp_id" id="emp_id" value="">
                                <input type="hidden" name="par_id" id="par_id" value="">
                                <input type="hidden" name="cons_id" id="cons_id" value="">
                                <input type="hidden" name="member_type" id="member_type" value="">
                                <input type="text" name="emp_par_name" id="emp_par_name" value="" style="width:160px;" readonly>
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_training_management.emp_id&field_consumer=add_training_management.cons_id&field_name=add_training_management.emp_par_name&field_partner=add_training_management.par_id&field_type=add_training_management.member_type&select_list=1,2,3</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
				</div>
				<div class="col col-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">		
                    <div class="form-group" id="item-language_id">
                        <label class="col col-4 col-sm-6 col-xs-12">
                            <cf_get_lang_main no='1584.Dil'> *
                        </label>
                        <div class="col col-8 col-sm-6 col-xs-12">
                            <select name="language_id" id="language_id">
                                <cfoutput query="get_language">
                                    <option value="#language_short#">#language_set#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-training_style">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46122.Eğitim Şekli'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="training_style" id="training_style">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_training_style">
                                    <option value="#TRAINING_STYLE_ID#">#TRAINING_STYLE#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-training_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46120.Eğitim Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="training_type" id="training_type">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1"><cf_get_lang dictionary_id='46647.Standart Eğitim'></option>
                                <option value="2"><cf_get_lang dictionary_id='46648.Teknik Gelişim Eğitimi'></option>
                                <option value="3"><cf_get_lang dictionary_id='46649.Zorunlu Eğitim'></option>
                                <option value="4"><cf_get_lang dictionary_id='46650.Yetkinlik Gelişim Eğitimi'></option>
                            </select>
                        </div>
                    </div>
                    <cfif isdefined('x_product_associate') and x_product_associate eq 1>
                        <div class="form-group" id="form_ul_product_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="product_id" id="product_id" value="">
                                    <input type="text" name="product_name"  id="product_name" value="" passthrough="readonly=yes" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','225');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=add_training_management.product_id&field_name=add_training_management.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(document.add_training_management.product_name.value));"></span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-totalday">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29513.Süre'>/<cf_get_lang dictionary_id='57490.Gün'></label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='46644.Süre Gün Cinsinden Olmalıdır'></cfsavecontent>
                            <cfinput type="text" name="totalday" id="totalday" style="width:160px;" validate="integer" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-totalhours">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46377.Toplam Saat'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="total_hours" id="total_hours" value="" validate="integer">
                        </div>
                    </div>
                    <div class="form-group" id="item-expense">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46646.Tahmini Bedel'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="expense" id="expense" value=""  onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                                <span class="input-group-addon width">
                                    <select name="money" id="money">
                                        <cfoutput query="get_money">
                                        <option value="#money#">#money#</option>
                                        </cfoutput>
                                    </select>
                                </span>
                            </div>
                        </div>
                    </div>
				</div>
				<div class="col col-12 col-sm-12 col-xs-12" type="column" index="3" sort="true">		
					<cf_seperator id="item_train_detail" header="#getLang('','İçerik',57653)#" is_closed="0">
					<div class="col col-12 col-xs-12" id="item_train_detail">	
					<!--- <label class="txtbold" height="20"><cf_get_lang dictionary_id='57653.İçerik'></label>	 --->	
						<cfmodule
							template="/fckeditor/fckeditor.cfm"
							toolbarSet="WRKContent"
							basePath="/fckeditor/"
							instanceName="train_detail"
							valign="top"
							value=""
							width="530"
							height="150">
					</div>
				</div>
			</cf_box_elements>	
			<cf_box_elements>
				<div class="col col-12 col-xs-12">
					<cfset select_list="">
					<cfif isdefined("x_organization_unit") and x_organization_unit eq 1>
						<cfset select_list = '1,2,7'>
					</cfif>
					<cfif isdefined("x_planned_roles") and x_planned_roles eq 1>
						<cfset select_list = '#select_list#,3,5,6,9'>
					</cfif>
					<cfif isdefined("x_corporate_members") and x_corporate_members eq 1>
						<cfset select_list = '#select_list#,4'>
					</cfif>
					<cfif isdefined("x_individual_members") and x_individual_members eq 1>
						<cfset select_list = '#select_list#,8'>
					</cfif>
					<cf_seperator id="egitim_kategorisi_" header="#getLang('','Kimler İçin',54997)#?" is_closed="0">
					<div class="form-group" id="egitim_kategorisi_">	
							<cf_relation_segment 
										is_upd='0' 
										is_form='1' 
										table_name='TRAINING' 
										tag_head='#getLang('training_management',444)#' 
										action_table_name='RELATION_SEGMENT_TRAINING' 
										select_list='#select_list#'>	
					</div>		
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
		</cf_box>
	</cfform>
</div>
		
<script type="text/javascript">
	function get_tran_sec(cat_id)
	{
		document.add_training_management.training_sec_id.options.length = 0;
		var get_sec =  wrk_safe_query('trn_get_sec','dsn',0,cat_id); 
		document.add_training_management.training_sec_id.options[0]=new Option('Bölüm !','0')
		for(var jj=0;jj<get_sec.recordcount;jj++)
		{
			document.add_training_management.training_sec_id.options[jj+1]=new Option(get_sec.SECTION_NAME[jj],get_sec.TRAINING_SEC_ID[jj])
		}
	}
	function kontrol()
	{
		add_training_management.expense.value = filterNum(add_training_management.expense.value);
		if(document.getElementById('train_head').value == "")
		{
			alert ("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57480.Konu'>!");
			return false;
		}
	}
</script>

<cfparam name="is_dsp_cari_member" default="0">
<cf_xml_page_edit fuseact="account.account_card_import">
<cf_catalystHeader>
    <cfform name="acc_import" action="#request.self#?fuseaction=account.emptypopup_account_card_import" enctype="multipart/form-data" method="post">
    	<div class="row">
        	<div class="col col-12 uniqueRow">
            	<div class="row formContent">
                	<div class="row" type="row">
                		<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                        	<div class="form-group" id="item-process_date">
                            	<label class="col col-3 col-xs-12"><cf_get_lang no ='183.Fiş Tarihi'> *</label>
                                <div class="col col-9 col-xs-12">
                                	<div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang_main no='330.Tarih'></cfsavecontent>
                                        <cfinput type="text" name="process_date" maxlength="10" style="width:65px;" required="Yes" message="#message#" validate="#validate_style#">
                                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="process_date"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-process_cat">
                            	<label class="col col-3 col-xs-12"><cf_get_lang_main no="388.İşlem Tipi"> *</label>
                                <div class="col col-9 col-xs-12">
                                	<cf_workcube_process_cat slct_width="140px;" onclick_function="control_member();">
                                </div>
                            </div>
                            <cfif isDefined("session.ep") and len(session.ep.our_company_info.is_ifrs eq 1)>
                                <cfset is_ifrs = 1>
                            <cfelse>
                                <cfset is_ifrs = 0>
                            </cfif>
                            <div class="form-group" id="item-process_cat">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="43429.Kayıt tipi"> *</label>
                                <div class="col col-9 col-xs-12">
                                    <select name="show_type" id="show_type">
                                        <option value="1" <cfif is_ifrs eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id="58793.Tek düzen"></option>
                                        <option value="2"><cf_get_lang dictionary_id="58308.ufrs"></option>
                                        <option value="3"<cfif is_ifrs eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id="58793.Tek düzen"> + <cf_get_lang dictionary_id="58308.ufrs"></option>
                                    </select>
                                </div>
                            </div>
                            <cfif is_dsp_cari_member eq 1>
                                <div class="form-group" id="cari_hesap" style="display:none;">
                                    <label class="col col-3 col-xs-12"><cf_get_lang_main no='107.Cari Hesap'></label>
                                    <div class="col col-9 col-xs-12">
                                      <div class="input-group">
                                    	<input type="hidden" name="member_type" id="member_type" value="">
                                        <input type="hidden" name="member_id" id="member_id" value="">
                                        <input type="text" name="member_name" id="member_name" value="" style="width:140px;">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_member_name=acc_import.member_name&field_name=acc_import.member_name&field_type=acc_import.member_type&field_comp_id=acc_import.member_id&field_consumer=acc_import.member_id&select_list=2,3<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');"></span>
                                    </div>
                                </div>
                             </div>  
                            </cfif>
                            <div class="form-group" id="item-muhasebe_file">
                            	<label class="col col-3 col-xs-12"><cf_get_lang_main no ='56.Belge'> *</label>
                                <div class="col col-9 col-xs-12">
                                	<input type="file" name="muhasebe_file" id="muhasebe_file"  value="<cfoutput>#getLang('main',279)#</cfoutput>" style="width:200px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-bill_detail">
                            	<label class="col col-3 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                                <div class="col col-9 col-xs-12">
                                	<textarea name="bill_detail" id="bill_detail" style="width:200px;height:50px;"></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="col col-8 col-md-4 col-sm-6 col-xs-12" type="column" sort="false" index="2">
                        	<div class="form-group" id="item-format">
                            <table>
                                <tr><td class="color-row" height="25"><b><cf_get_lang_main no ='1182.Format'></b></td></tr>
                                <tr>
                                    <td>
                                        <cftry>
                                            <cfinclude template="#file_web_path#templates/import_example/muhasebefisiimport_#session.ep.language#.html">
                                            <cfcatch>
                                                <script type="text/javascript">
                                                    alert("<cf_get_lang_main no='1963.Yardım Dosyası Bulunamadı Lutfen Kontrol Ediniz'>");
                                                </script>
                                            </cfcatch>
                                        </cftry>
                                    </td>
                                </tr>
                            </table>
                            </div>
                        </div>
                	</div>
                    <div class="row formContentFooter">
                    	<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                    </div>
                </div>
            </div>
        </div>
    </cfform>
<script type="text/javascript">
	function control_member()
	{
		<cfif is_dsp_cari_member eq 1> //acılıs fişinde cari hesap gosterilmiyor
			var selected_ptype = document.acc_import.process_cat.options[document.acc_import.process_cat.selectedIndex].value;
			if(selected_ptype!='')
			{
				eval('var proc_control = document.acc_import.ct_process_type_'+selected_ptype+'.value');
				if(proc_control == 10)
					gizle(cari_hesap);
				else
					goster(cari_hesap);
			}
			else
				goster(cari_hesap);
		</cfif>
	}
	control_member();
	function kontrol()
	{
		if(!chk_process_cat('acc_import')) return false;
		if(!chk_period(acc_import.process_date,"İşlem")) return false;
		if(acc_import.muhasebe_file.value.length==0)
		{
			alert("<cf_get_lang no ='207.Belge Seçmelisiniz'>!");
			return false;
		}
		return true;
	}
</script>

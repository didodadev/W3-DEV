<cf_xml_page_edit fuseact="stock.add_ship_from_file">
    <!--- From_Where Icin;
        1	: Sevk Irsaliyesi
        2	: Alim Irsaliyesi
        3	: Satis Irsaliyesi
        4	: Fis
        5	: Grup Ici Irsaliye
     --->
     <cfparam name="attributes.modal_id" default="">
    <cf_get_lang_set module_name="stock">
    <cfsetting showdebugoutput="no">
    <cfswitch expression="#attributes.from_where#">
        <cfcase value="1">
            <cfset str_link = "#request.self#?fuseaction=#fusebox.circuit#.add_ship_dispatch">
        </cfcase>
        <cfcase value="2">
            <cfset str_link = "#request.self#?fuseaction=#fusebox.circuit#.form_add_purchase">
        </cfcase>
        <cfcase value="3">
            <cfset str_link = "#request.self#?fuseaction=#fusebox.circuit#.form_add_sale">
        </cfcase>
        <cfcase value="4">
            <cfset str_link = "#request.self#?fuseaction=#fusebox.circuit#.form_add_fis">
        </cfcase>
        <cfcase value="5">
            <cfset str_link = "#request.self#?fuseaction=store.form_add_group_ships">
        </cfcase>
        <cfcase value="6">
            <cfset str_link = "#request.self#?fuseaction=#fusebox.circuit#.form_add_ship_open_fis">
        </cfcase>
        <cfdefaultcase>
            <cfset str_link = "#request.self#?fuseaction=#fusebox.circuit#.form_add_purchase">
        </cfdefaultcase>
    </cfswitch>
    <cf_box title="#getLang('','Veri Aktarım',60009)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="form_basket_ship" action="#str_link#" method="post" enctype="multipart/form-data">
            <input type="hidden" name="file_format" id="file_format" value="1">
            <input type="hidden" name="ship_date" id="ship_date" value="">
            <input type="hidden" name="fis_date" id="fis_date" value="">
            <input type="hidden" name="txt_departman_" id="txt_departman_" value="">
            <input type="hidden" name="branch_id" id="branch_id" value="">
            <input type="hidden" name="department_id" id="department_id" value="">
            <input type="hidden" name="location_id" id="location_id" value="">
            <input type="hidden" name="txt_departman_out" id="txt_departman_out" value="">
            <input type="hidden" name="department_out" id="department_out" value="">
            <input type="hidden" name="location_out" id="location_out" value="">
            <input type="hidden" name="txt_department_in" id="txt_department_in" value="">
            <cfif attributes.from_where is 1>
            <input type="hidden" name="department_in_txt" id="txt_department_in" value="">
            <input type="hidden" name="department_in_id" id="txt_department_in" value="">
            <input type="hidden" name="location_in_id" id="txt_department_in" value="">
            </cfif>
            <input type="hidden" name="branch_in_id" id="branch_in_id" value="">
            <input type="hidden" name="department_in" id="department_in" value="">
            <input type="hidden" name="location_in" id="location_in" value="">
            <input type="hidden" name="project_id" id="project_id" value="">
            <input type="hidden" name="from_where" id="from_where" value="<cfoutput>#attributes.from_where#</cfoutput>">
            <cf_box_elements>
                <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="form_ul_process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'></label>
                            <cfset process_type_info = "">
                            <cfif isDefined("attributes.from_where")>
                                <cfif attributes.from_where eq 1>
                                    <cfset process_type_info = "81">
                                <cfelseif attributes.from_where eq 2>
                                    <cfset process_type_info = "73,74,75,76,77">
                                <cfelseif attributes.from_where eq 3>
                                    <cfset process_type_info = "70,71,72,78,79,83,85,88">
                                <cfelseif attributes.from_where eq 4>
                                    <cfset process_type_info = "110,111,112,113,1131,114,115,116,117,118,119">
                                <cfelseif attributes.from_where eq 6>
                                    <cfset process_type_info = "114">
                                </cfif>
                            </cfif>

                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process_cat slct_width="200" fuseaction="#attributes.fuseaction#" process_type_info="#process_type_info#">
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_comp_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.cari hesap'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="consumer_id" id="consumer_id" value="">
                                <input type="hidden" name="partner_id" id="partner_id" value="">
                                <input type="hidden" name="company_id" id="company_id" value="">
                                <input type="hidden" name="partner_name" id="partner_name" value="">
                                <input type="hidden" name="adres" id="adres" value="">
                                <cfinput type="text" name="comp_name" id="comp_name" readonly="" onFocus="AutoComplete_Create('comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','COMPANY_ID,PARTNER_ID,CONSUMER_ID,MEMBER_PARTNER_NAME,WORK_ADDRESS','company_id,partner_id,consumer_id,partner_name,adres','','3','200');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_partner=form_basket_ship.partner_id&field_comp_name=form_basket_ship.comp_name&field_comp_id=form_basket_ship.company_id&field_consumer=form_basket_ship.consumer_id&field_name=form_basket_ship.comp_name&come=stock&field_address=form_basket_ship.adres</cfoutput>','list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_uploaded_file">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="file" name="uploaded_file" required="yes" message="#getLang('','Belge Seçiniz',47469)#">
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_stock_identity_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58530.Aktarım Türü'> </label>
                        <div class="col col-8 col-xs-12">
                            <select name="stock_identity_type_" id="stock_identity_type_">
                                <option value="1"><cf_get_lang dictionary_id ='57633.Barkod'></option>
                                <option value="2" <cfif (isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 2) or xml_stock_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='57518.Stok Kodu'></option>
                                <option value="3" <cfif (isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 3) or xml_stock_type eq 3>selected</cfif>><cf_get_lang dictionary_id='57789.Özel Kod'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_ship_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'>!</cfsavecontent>
                            <cfif attributes.from_where eq 4>
                                <cfinput type="text" id="fis_date_" name="fis_date_" validate="#validate_style#" value="" message="#message#" required="yes">                                
                                <span class="input-group-addon"><cf_wrk_date_image date_field="fis_date_"></span>
                            <cfelse>
                                <cfinput type="text" id="ship_date_"  name="ship_date_" validate="#validate_style#" value="" message="#message#" required="yes">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="ship_date_"></span>
                            </cfif>
                            </div>
                        </div>
                    </div>
                    <cfif attributes.from_where eq 4>
                        <div class="form-group" id="form_ul_txt_departman_">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label>
                                <div class="col col-8 col-xs-12">
                                <cf_wrkdepartmentlocation
                                returnInputValue="location_out_,txt_departman_out_,department_out_,branch_id_"
                                returnInputQuery="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                fieldName="txt_departman_out_"
                                fieldid="location_out_"
                                department_fldId="department_out_"
                                branch_fldId="branch_id_"
                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                line_info="1"
                                is_store_kontrol = "0"
                                width="150"
                                call_function="kontrol_cikis()">
                            </div>
                        </div>
                    <cfelse>
                        <div class="form-group" id="form_ul_txt_departman_imp">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkdepartmentlocation
                                returnInputValue="location_id_,txt_departman_imp,department_id_,branch_id_"
                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                fieldId="location_id_"
                                fieldName="txt_departman_imp"
                                department_fldId="department_id_"
                                branch_fldId="branch_id_"
                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                width="150"
                                call_function="kontrol_cikis()">
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="form_ul_is_order_relation">
                        <cfif attributes.from_where eq 2>
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62824.Sipariş Bağlantısı Oluştur'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="checkbox" name="is_order_relation" id="is_order_relation" value="">
                            </div>	
                        <cfelseif attributes.from_where eq 4 or attributes.from_where eq 1>
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56969.Giriş Depo'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkdepartmentlocation
                                    returnInputValue="location_in_,txt_department_in_,department_in_,branch_in_id_"
                                    returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                    fieldName="txt_department_in_"
                                    fieldid="location_in_"
                                    department_fldId="department_in_"
                                    branch_fldId="branch_in_id_"
                                    user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                    line_info = "2"
                                    width="150"
                                    call_function="kontrol_giris()">
                            </div>
                        </cfif>
                    </div>
                </div>
                <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <b><cf_get_lang dictionary_id='58594.Format'></b><br/>
                        <cf_get_lang dictionary_id="30106.Dosya uzantısı csv olmalı kaydedilirken karakter desteği olarak UTF-8 seçilmelidir Alan araları noktalı virgül ile ayrılmalı sayısal değerler için nokta ayrac olarak kullanılmalıdır"><br />
                        <cf_get_lang dictionary_id='44960.Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır .'><br /><br />
                        <cf_get_lang dictionary_id='54207.Belgede toplam'> <cfif listfind('1,3',attributes.from_where)>6<cfelseif ListFind("2",attributes.from_where)>8<cfelseif ListFind("4",attributes.from_where)>7<cfelseif ListFind("6",attributes.from_where)>10<cfelse>4</cfif> <cf_get_lang dictionary_id='44196.alan olacaktır'> <cf_get_lang dictionary_id='45042.Alanlar sırası ile'>;<br/>
                        1 - <cf_get_lang dictionary_id='57518.Stok Kodu'> ,<cf_get_lang dictionary_id='57633.Barkod'> <cf_get_lang dictionary_id='57998.veya'> <cf_get_lang dictionary_id='57789.Özel Kod'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br />
                        2 - <cf_get_lang dictionary_id='57635.Miktar'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) <br />
                        <cfif listfind('1,3',attributes.from_where)>
                                3 - <cf_get_lang dictionary_id='58084.Fiyat'> (<cf_get_lang dictionary_id='62822.Spect Main ID girilecekse olmayan fiyatların yerine 0 yazılmalıdır'>.)<br />
                                4 - <cf_get_lang dictionary_id='37354.Spec Main ID'> <br />
                        <cfelseif  attributes.from_where is 2>
                                3 - <cf_get_lang dictionary_id='58084.Fiyat'> (<cf_get_lang dictionary_id='62822.Spect Main ID girilecekse olmayan fiyatların yerine 0 yazılmalıdır'>.)<br />
                                4 - <cf_get_lang dictionary_id='57677.Döviz'> <br>
                                5 - <cf_get_lang dictionary_id='37354.Spec Main ID'> <br />
                        <cfelse>
                            <cfif attributes.from_where is 4>
                                3 - <cf_get_lang dictionary_id='37354.Spec Main ID'> <br />
                            <cfelseif listfind('1,2,3',attributes.from_where)>
                                3 - <cf_get_lang dictionary_id='58084.Fiyat'> <br />
                            </cfif>
                        </cfif>
                        <cfif attributes.from_where is 6>
                                3 - <cf_get_lang dictionary_id='37354.Spec Main ID'> <br />
                        </cfif>
                        <cfif attributes.from_where is 4 or attributes.from_where is 6>
                            4 - <cf_get_lang dictionary_id='45254.Raf No'> (<cf_get_lang dictionary_id='57554.Giriş'>) <br />
                            5 - <cf_get_lang dictionary_id='45254.Raf No'> (<cf_get_lang dictionary_id='57431.Çıkış'>) <br />
                        </cfif>
                        <cfif attributes.from_where is 1>
                            5 - <cf_get_lang dictionary_id='45254.Raf No'> (<cf_get_lang dictionary_id='57554.Giriş'>) <br />
                            6 - <cf_get_lang dictionary_id='45254.Raf No'> (<cf_get_lang dictionary_id='57431.Çıkış'>) <br />
                        </cfif>

                        <cfif attributes.from_where is 4 or  attributes.from_where is 2 or attributes.from_where is 6>
                            6 - <cf_get_lang dictionary_id='45498.Lot No'> <br />
                        <cfelseif attributes.from_where is 1>
                            7 - <cf_get_lang dictionary_id='45498.Lot No'> <br />
                        <cfelse>
                            5 - <cf_get_lang dictionary_id='45498.Lot No'> <br />
                        </cfif>
                        <cfif attributes.from_where is 4 or  attributes.from_where is 2 or attributes.from_where is 6>
                            7 - <cf_get_lang dictionary_id='57416.Proje'> <cf_get_lang dictionary_id='58527.ID'> <br />
                        <cfelseif attributes.from_where is 1>
                            8 - <cf_get_lang dictionary_id='57416.Proje'> <cf_get_lang dictionary_id='58527.ID'> <br />
                        <cfelse>
                            6 - <cf_get_lang dictionary_id='57416.Proje'> <cf_get_lang dictionary_id='58527.ID'> <br />
                        </cfif>
                        <cfif attributes.from_where is 4 or  attributes.from_where is 2 or attributes.from_where is 6>
                            8 - <cf_get_lang dictionary_id='57629.Açıklama'> <br />
                        <cfelseif attributes.from_where is 1>
                            9 - <cf_get_lang dictionary_id='57629.Açıklama'> <br />
                        <cfelse>
                            7 - <cf_get_lang dictionary_id='57629.Açıklama'> <br />
                        </cfif>
                            <cfif attributes.from_where is 6>
                            9 - <cf_get_lang dictionary_id='58258.Maliyet'> <br />
                            10 - <cf_get_lang dictionary_id='58258.Maliyet'> <cf_get_lang dictionary_id='57489.Para Birimi'> <br />
                        </cfif>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons insert_info='#getLang('','Listele',58715)#' add_function="ekle_form_action(1)" is_cancel='0'>
                <cf_workcube_buttons add_function="ekle_form_action(2)">
            </cf_box_footer>    
        </cfform>
    </cf_box>
    
    
<script type="text/javascript">
function ekle_form_action(int_s_flag)
{
    <cfif attributes.from_where is 4>
        form_basket_ship.fis_date.value = form_basket_ship.fis_date_.value;
        form_basket_ship.txt_departman_out.value = form_basket_ship.txt_departman_out_.value;
        form_basket_ship.branch_id.value = form_basket_ship.branch_id_.value;
        form_basket_ship.department_out.value = form_basket_ship.department_out_.value;
        form_basket_ship.location_out.value = form_basket_ship.location_out_.value;
        form_basket_ship.txt_department_in.value = form_basket_ship.txt_department_in_.value;
        form_basket_ship.branch_in_id.value = form_basket_ship.branch_in_id_.value;
        form_basket_ship.department_in.value = form_basket_ship.department_in_.value;
        form_basket_ship.location_in.value = form_basket_ship.location_in_.value;
    <cfelse>
        form_basket_ship.ship_date.value = form_basket_ship.ship_date_.value;txt_departman_imp
        form_basket_ship.txt_departman_.value = form_basket_ship.txt_departman_imp.value;
        form_basket_ship.branch_id.value = form_basket_ship.branch_id_.value;
        form_basket_ship.department_id.value = form_basket_ship.department_id_.value;
        form_basket_ship.location_id.value = form_basket_ship.location_id_.value;
    </cfif>
    <cfif attributes.from_where is 1>
        form_basket_ship.department_in_txt.value = form_basket_ship.txt_department_in_.value;
        form_basket_ship.branch_in_id.value = form_basket_ship.branch_in_id_.value;
        form_basket_ship.department_in_id.value = form_basket_ship.department_in_.value;
        form_basket_ship.location_in_id.value = form_basket_ship.location_in_.value;
    </cfif>
    deger = form_basket_ship.process_cat.value;
	if(deger != ""){
        var fis_no = $("#ct_process_type_"+deger).val();
        dep_in = form_basket_ship.department_in_.value
        txt_dep_in = form_basket_ship.txt_department_in_.value
        dep_out = form_basket_ship.department_out_.value
		if(list_find('110,115,119',fis_no))
		{
		
			if(dep_in == ""  )
			{
				alert("<cf_get_lang dictionary_id ='45601.Giriş Deposunu Seçmelisiniz'>!");
				return false;
			}
		}
		if(list_find('111,112',fis_no))
		{
			if(dep_out == ""  )
			{
				alert("<cf_get_lang dictionary_id ='45602.Çıkış Deposunu Seçmelisiniz'>!");					
				return false;
			}
		}
		if(list_find('113,1131',fis_no))
		{
			if(dep_in == "" || txt_dep_in == "" || dep_out == "" )
			{
				alert("<cf_get_lang dictionary_id ='45603.Giriş ve Çıkış Depolarını Seçmelisiniz'>!");
				return false;
			}
		}
	}
	else{
		alert("<cf_get_lang dictionary_id='58770.İşlem Tipi seçiniz'>!");
		return false;
    }
   
	if(int_s_flag==1)
	{
		<cfif session.ep.isBranchAuthorization eq 1>
			$("#form_basket_ship").attr('action', '<cfoutput>#request.self#?fuseaction=store.display_file_phl_ship&from_where=#attributes.from_where#</cfoutput>');
        <cfelse>
            $("#form_basket_ship").attr('action', '<cfoutput>#request.self#?fuseaction=stock.display_file_phl&from_where=#attributes.from_where#</cfoutput>');
		</cfif>
		//return true;
	}
	<cfif attributes.from_where is 3>
		else
		{
			if(deger=="")
			{
				alert("<cf_get_lang dictionary_id='58770.İşlem tipi seçiniz'>!");
				return false;
			}
			else
				form_basket_ship.action = "<cfoutput>#str_link#</cfoutput>";
			return true;
		}
	<cfelse>
		else
		{
			form_basket_ship.action = "<cfoutput>#str_link#</cfoutput>";
			return true;
		}
	</cfif>
    if(int_s_flag == 2)
	{
        <cfif not isdefined("attributes.draggable")>
            window.close();
        <cfelse>
            closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
        </cfif>
    }
}

    function kontrol_giris()
    {
        deger = form_basket_ship.process_cat.value;
        if(deger != "")
        {
            var fis_no = $("#ct_process_type_"+deger).val();
            if(list_find('111,112', fis_no))
            {
                alert("<cf_get_lang dictionary_id ='45411.Sarf ve Fire Fişleri için Giriş Deposu Seçemezsiniz'>!");
                return false;
            }
            return true;
        }
        else
            alert("<cf_get_lang dictionary_id='58770.İşlem Tipi seçiniz'>!");
    }
    function kontrol_cikis()
    {
        /* deger = form_basket_ship.process_cat.value; */
        deger = form_basket_ship.process_cat.value;
        if(deger != "")
        {
            var fis_no = $("#ct_process_type_"+deger).val();
            if(list_find('110,115,119', fis_no))
            {
                alert("<cf_get_lang dictionary_id ='45599.Üretimden Gelen Ürünler ve Sayım Fişleri için Çıkış Deposu Seçemezsiniz'>!");
                return false;
            }
            return true;
        }
        else
        { 
            alert("<cf_get_lang dictionary_id='58770.İşlem Tipi seçiniz'>!") 
        }
    }
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
    
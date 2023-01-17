<cfscript>
	netbook = createObject("component","V16.e_government.cfc.netbook");
	netbook.dsn = dsn;
	get_account_card_document_types = netbook.getAccountCardDocumentTypes(is_company : 1, is_active : 1);
	get_account_card_payment_types = netbook.getAccountCardPaymentTypes(is_active : 1);

	accountingType = createObject("component","V16.settings.cfc.accountingType");
    getAccount = accountingType.getAccountType();

</cfscript>
<cfset a_hata = 0>
<cfset b_hata = 0>
<cfinclude template="../query/get_process_cat.cfm">
<cfinclude template="../query/get_process_cat_rows.cfm">
<cfset list_invoice_type_code= ''>
<cfif session.ep.our_company_info.is_efatura eq 1>
	<cfset upload_folder_ = '#GetDirectoryFromPath(GetCurrentTemplatePath())#..#dir_seperator#..#dir_seperator#admin_tools#dir_seperator#'>
    <cffile action="read" variable="xmldosyam" file="#upload_folder_#xml#dir_seperator#setup_process_cat.xml" charset = "UTF-8">
    <cfset dosyam = XmlParse(xmldosyam)>
    <cfset xml_dizi = dosyam.workcube_process_types.XmlChildren>
    <cfloop from='1' to='#ArrayLen(xml_dizi)#' index='i'>
      	<cfif len(dosyam.workcube_process_types.process[i].invoice_type_code.XmlText)>
        	<cfset list_invoice_type_code= listappend(list_invoice_type_code,dosyam.workcube_process_types.process[i].process_type.XmlText,',')>
        </cfif>    
    </cfloop>
</cfif>
<cf_catalystHeader>
<cfform name="upd_process_cat" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=settings.emptypopup_upd_process_cat">
<div class="col col-12 col-md-112 col-sm-12 col-xs-12">
<cf_box>
	<!---<cfif not listfindnocase(denied_pages,'process.emtypopup_dsp_process_cat_file_history')><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=process.emtypopup_dsp_process_cat_file_history&process_cat_id=#attributes.process_cat_id#</cfoutput>','wwide1');"><img src="/images/history.gif"  alt="<cf_get_lang_main no='61.Tarihçe'>" border="0" ></a></cfif>--->
    
    <cf_box_elements>
        <input type="hidden" name="process_cat_id" id="process_cat_id" value="<cfoutput>#process_cat_id#</cfoutput>">
        <input type="hidden" name="process_type_value" id="process_type_value" value="2" />
        <input type="hidden" name="process_multi_type" id="process_multi_type" value="<cfoutput>#GET_PROCESS_CAT.multi_type#</cfoutput>" />
            <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                <div class="form-group" id="item-process_cat">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42382.İşlem Kategorisi'>*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.kategori girmelisiniz'></cfsavecontent>
                            <cfinput maxlength="100" value="#get_process_cat.process_cat#" required="Yes" type="text" name="process_cat" message="#message#">
                            <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="windowopen('index.cfm?fuseaction=settings.popup_list_process_types&field_id=upd_process_cat.process_type&field_name=upd_process_cat.process_cat&field_module_id=upd_process_cat.module_id&detail=upd_process_cat.fuse_names&profile_id=upd_process_cat.profile_id&invoice_type_code=upd_process_cat.invoice_type_code&process_multi_type=upd_process_cat.process_multi_type','list');"></span>
                            <span class="input-group-addon">
                                <cf_language_info 
                                    table_name="SETUP_PROCESS_CAT" 
                                    column_name="PROCESS_CAT" 
                                    column_id_value="#ATTRIBUTES.PROCESS_CAT_ID#" 
                                    maxlength="500" 
                                    datasource="#dsn3#" 
                                    column_id="PROCESS_CAT_ID" 
                                    control_type="0">
                            </span>
                        </div>
                    </div>
                </div>
                <cfset check_export_registered = "53,71,74,59,79,78">
                <cfset check_inward_processing = "591,811,87">
                <div id="inward_processing" <cfif listfind(check_inward_processing,get_process_cat.process_type)> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_inward_processing">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_inward_processing" id="is_inward_processing" value="1"<cfif len(get_process_cat.is_inward_processing) and get_process_cat.is_inward_processing eq 1> checked</cfif>><cf_get_lang dictionary_id ='44261.Dahilde İşlem Parametresi'></label>
                    </div>
                </div>
                
                <cfif listfind('62,52,53,690,591,592,531,532,64,59,54,55',get_process_cat.process_type)>
                    <!--- Faturdan kesilen irsaliyelerde islem tipi belirlenir 20140617 --->
                    <cfswitch expression="#get_process_cat.process_type#">
                        <cfcase value="62">
                            <!--- alim iade faturasi --->
                            <cfset ship_type_id = 78>
                        </cfcase>
                        <cfcase value="52">
                            <!--- perakende satis faturasi --->
                            <cfset ship_type_id = 70>
                        </cfcase>
                        <cfcase value="53">
                            <!--- toptan satis faturasi --->
                            <cfset ship_type_id = 71>
                        </cfcase>
                        <cfcase value="690">
                            <!--- gider pusulasi (mal) --->
                            <cfset ship_type_id = 84>
                        </cfcase>
                        <cfcase value="592">
                            <!--- hal faturasi --->
                            <cfset ship_type_id = 761>
                        </cfcase>
                        <cfcase value="591">
                            <!--- ithalat faturasi --->
                            <cfset ship_type_id = 87>
                        </cfcase>
                        <cfcase value="531">
                            <!--- ihracat faturasi --->
                            <cfset ship_type_id = 88>
                        </cfcase>
                        <cfcase value="532">
                            <!--- konsinye faturasi --->
                            <cfset ship_type_id = 72>
                        </cfcase>
                        <cfcase value="64">
                            <!--- müsatahsil makbuzu --->
                            <cfset ship_type_id = 80>
                        </cfcase>
                        <cfcase value="59">
                            <!--- mal alim faturasi --->
                            <cfset ship_type_id = 76>
                        </cfcase>
                        <cfcase value="54">
                            <!--- perakende satis iade --->
                            <cfset ship_type_id = 73>
                        </cfcase>
                        <cfcase value="55">
                            <!--- toptan satis iade faturasi --->
                            <cfset ship_type_id = 74>
                        </cfcase>
                        <cfdefaultcase>
                            <!--- default --->
                            <cfset ship_type_id = "">
                        </cfdefaultcase>
                    </cfswitch>
                    <cfif len(ship_type_id)>
                        <cfquery name="get_ship_types" datasource="#dsn3#">
                            SELECT PROCESS_CAT, PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = #ship_type_id#
                        </cfquery>
                        <div id="ship_type_">
                            <div class="form-group" id="item-ship_type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="29430.İrsaliye Tipi"></label>
                            <div  id="ship_type2_" class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="ship_type" id="ship_type">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfoutput query="get_ship_types">
                                        <option value="#PROCESS_CAT_ID#" <cfif get_process_cat.SHIP_TYPE_ID eq PROCESS_CAT_ID>selected</cfif>>#PROCESS_CAT#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </div>
                </cfif>
                    </cfif>
            <!--- E-İrsaliye Tipi --->
                <cfif listfind('70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,761',get_process_cat.process_type)>
                    <cfset despatch_display = ''>
                <cfelse>
                    <cfset despatch_display = 'none'>
                </cfif>
                <div id="despatch_advice_type_" style="display:<cfoutput>#despatch_display#</cfoutput>">
                    <div class="form-group" id="item-despatch_advice_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="60910.E-irsaliye Tipi"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="despatch_advice_type" id="despatch_advice_type">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <option value="1" <cfif len(get_process_cat.DESPATCH_ADVICE_TYPE) and get_process_cat.DESPATCH_ADVICE_TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id="30098.Satış İrsaliye"></option>
                            </select>
                        </div>
                    </div>
                </div>
                <div id="eshipment_profile_id_" style="display:<cfoutput>#despatch_display#</cfoutput>">
                    <div class="form-group" id="item-eshipment_profile_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59321.Senaryo"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="eshipment_profile_id" id="eshipment_profile_id">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <option value="TEMELIRSALIYE" <cfif len(get_process_cat.ESHIPMENT_PROFILE_ID) and get_process_cat.ESHIPMENT_PROFILE_ID eq 'TEMELIRSALIYE'>selected</cfif>><cf_get_lang dictionary_id="60934.Temel İrsaliye"></option>
                            </select>
                        </div>
                    </div>
                </div>
            <!---  --->
                <cfif session.ep.our_company_info.is_efatura eq 1 and listfind(list_invoice_type_code,get_process_cat.process_type)>
                    <cfset temp_display = ''>
                <cfelse>
                    <cfset temp_display = 'none'>
                </cfif>
                <div id="invoice_type_code_tr" style="display:<cfoutput>#temp_display#</cfoutput>"><!--- E Fatura icin eklendi --->
                    <div class="form-group" id="item-invoice_type_code">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57288.Fatura Tipi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="invoice_type_code" id="invoice_type_code" disabled="disabled">
                            <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                            <option value="SATIS" <cfif get_process_cat.invoice_type_code eq 'SATIS'>selected="selected"</cfif>><cf_get_lang dictionary_id="57448.SATIS"></option>
                            <option value="IADE" <cfif get_process_cat.invoice_type_code eq 'IADE'>selected="selected"</cfif>><cf_get_lang dictionary_id="29418.IADE"></option>
                            <option value="IHRACKAYITLI" <cfif get_process_cat.invoice_type_code eq 'IHRACKAYITLI'>selected="selected"</cfif>><cf_get_lang dictionary_id="65169.IHRACKAYITLI"></option>
                            </select>
                        </div>
                    </div>
                </div>
                <div id="profile_id_tr" style="display:<cfoutput>#temp_display#</cfoutput>"><!--- E Fatura icin eklendi --->
                    <div class="form-group" id="item-profile_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="59321.Senaryo"></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="profile_id" id="profile_id" >
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <option value="TEMELFATURA" <cfif get_process_cat.profile_id eq 'TEMELFATURA'>selected="selected"</cfif>><cf_get_lang dictionary_id="57067.Temel Fatura"></option>
                                <option value="TICARIFATURA" <cfif get_process_cat.profile_id eq 'TICARIFATURA'>selected="selected"</cfif>><cf_get_lang dictionary_id="59874.Ticari Fatura"></option>
                                <option value="IHRACAT" <cfif get_process_cat.profile_id eq 'IHRACAT'>selected="selected"</cfif>><cf_get_lang dictionary_id="60823.İhracat"></option>
                                <option value="YOLCUBERABERFATURA" <cfif get_process_cat.profile_id eq 'YOLCUBERABERFATURA'>selected="selected"</cfif>><cf_get_lang dictionary_id="60824.Yolcu Beraber Fatura"></option>
                                <option value="BEDELSIZIHRACAT" <cfif get_process_cat.profile_id eq 'BEDELSIZIHRACAT'>selected="selected"</cfif>><cf_get_lang dictionary_id="60825.Bedelsiz İhracat"></option>
                                <option value="KAMU" <cfif get_process_cat.profile_id eq 'KAMU'>selected="selected"</cfif>><cf_get_lang dictionary_id="41536.Kamu Fatura"></option>
                                <cfset check_micro_export = "531,67">
                                <cfif listfind(check_micro_export,get_process_cat.process_type)>
                                    <option value="MIKROIHRACAT" <cfif get_process_cat.profile_id eq 'MIKROIHRACAT'>selected="selected"</cfif>><cf_get_lang dictionary_id="60847.Mikro İhracat"></option>
                                </cfif>
                                <!--- <cfset control_export_registered = "53,71,74">
                                <cfif listfind(control_export_registered,get_process_cat.process_type)>
                                    <option value="IHRACKAYITLI" <cfif get_process_cat.profile_id eq 'IHRACKAYITLI'>selected="selected"</cfif>>İhraç Kayıtlı Fatura</option>
                                </cfif> --->
                            </select>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-module_id">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42178.Modül'> <cf_get_lang dictionary_id="58527.ID"></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="text"  name="module_id" id="module_id" value="<cfoutput>#get_process_cat.process_module#</cfoutput>" readonly="yes">
                    </div>
                </div>    
                <div class="form-group" id="item-process_type">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43246.Process'> <cf_get_lang dictionary_id="58527.ID"></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="text"  name="process_type" id="process_type" value="<cfoutput>#get_process_cat.process_type#</cfoutput>" readonly="yes">
                    </div>
                </div>    
                <div class="form-group" id="item-special_code">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="text"  name="special_code" id="special_code" value="<cfoutput>#get_process_cat.special_code#</cfoutput>">
                    </div>
                </div>    
                <!--- tahakkuk, tahsil, tediye, mahsup fişlerinde kendi sayfalarından seçildiği için burada gelmeyecek --->
                <div id="tr_document_type" <cfif get_process_cat.is_account eq 0 or listFind('160,11,12,13',get_process_cat.process_type)>style="display:none"</cfif>>
                    <div class="form-group" id="item-document_type">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58533.Belge Tipi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="document_type" id="document_type">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <cfoutput query="get_account_card_document_types">
                                    <option value="#document_type_id#" <cfif get_process_cat.document_type eq document_type_id>selected</cfif>>#document_type#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div id="tr_payment_type" <cfif get_process_cat.is_account eq 0 or listFind('160,11,12,13',get_process_cat.process_type)>style="display:none"</cfif>>
                    <div class="form-group" id="item-payment_type"> 
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30057.Ödeme Şekli'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="payment_type" id="payment_type">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <cfoutput query="get_account_card_payment_types">
                                    <option value="#payment_type_id#" <cfif get_process_cat.payment_type eq payment_type_id>selected</cfif>>#payment_type#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <cfif get_process_cat.is_cari eq 1 or get_process_cat.is_account eq 1>
                    <div id="ACCOUNT_TYPE_ID">
                        <div class="form-group" id="item-account_type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='44270.Carileştirme'>/<cf_get_lang_main dictionary_id='44322.Muhasebeleştirme'><cf_get_lang dictionary_id='44333.Tercihi'></label>    
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="ACCOUNT_TYPE_ID" id="ACCOUNT_TYPE_ID">
                                    <cfoutput query="getAccount">    
                                        <option value="#ACCOUNT_TYPE_ID#" <cfif get_process_cat.ACCOUNT_TYPE_ID eq ACCOUNT_TYPE_ID>selected</cfif>>#ACCOUNT_TYPE#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </div>
                </cfif> 
                <div class="form-group" id="fuse_names">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42142.Fuseaction'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <cfquery name="get_fu_names" datasource="#DSN3#">
                            SELECT PROCESS_CAT_ID, FUSE_NAME FROM SETUP_PROCESS_CAT_FUSENAME WHERE PROCESS_CAT_ID = #attributes.process_cat_id#
                        </cfquery>
                        <textarea rows="5" name="fuse_names" id="fuse_names"><cfoutput>#ValueList(get_fu_names.FUSE_NAME)#</cfoutput></textarea>
                    </div>
                </div>
                <div class="form-group" id="item-display_display_file">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59000.Display File'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="display_file_del" id="display_file_del" value="0">
                                <input type="text" class="box" name="display_display_file" id="display_display_file" value="<cfif len(get_process_cat.DISPLAY_FILE_NAME) and get_process_cat.DISPLAY_FILE_FROM_TEMPLATE neq 1><cfoutput>#get_process_cat.DISPLAY_FILE_NAME#</cfoutput></cfif>" readonly="yes" style=" <cfif len(get_process_cat.DISPLAY_FILE_NAME) and get_process_cat.DISPLAY_FILE_FROM_TEMPLATE neq 1><cfelse>display:none;</cfif>" >
                                <span class="input-group-addon" href="javascript://" id="display_display_file_id" onclick="del_template_display_file(2);" style=" <cfif len(get_process_cat.DISPLAY_FILE_NAME) and get_process_cat.DISPLAY_FILE_FROM_TEMPLATE neq 1> display:'';<cfelse> display:none;</cfif>">
                                <i class="fa fa-minus"></i></span>
                                <input type="file" name="display_file_name" id="display_file_name" style=" <cfif len(get_process_cat.DISPLAY_FILE_FROM_TEMPLATE) and get_process_cat.DISPLAY_FILE_FROM_TEMPLATE eq 1>display:none;<cfelse></cfif>" >
                                <input type="text" name="display_file_name_template" id="display_file_name_template" readonly="" style=" <cfif len(get_process_cat.DISPLAY_FILE_FROM_TEMPLATE) and get_process_cat.DISPLAY_FILE_FROM_TEMPLATE eq 1><cfelse>display:none;</cfif>" value="<cfif len(get_process_cat.action_file_name) and get_process_cat.action_file_from_template eq 1><cfoutput>#get_process_cat.action_file_name#</cfoutput></cfif>">
                                <span class="input-group-addon" id="value11" href="javascript://" <cfif len(get_process_cat.action_file_name) and get_process_cat.DISPLAY_FILE_FROM_TEMPLATE eq 1> style="display:none;"</cfif> onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=process.popup_dsp_template&field_name=upd_process_cat.display_file_name_template&field_id=upd_process_cat.display_file_name&type=1&process_type=2','list');">
                                <i class="fa fa-plus"></i></span>
                                <span class="input-group-addon" href="javascript://" id="value12" onclick="del_template_display_file(1);" <cfif not len(get_process_cat.display_file_name) or not len(get_process_cat.DISPLAY_FILE_FROM_TEMPLATE)> style="display:none;"</cfif>>
                                <i class="fa fa-minus"></i></span>
                            </div>
                        </div>
                </div>
                <div class="form-group" id="item-display_action_file">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59001.Action File'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="action_file_del" id="action_file_del" value="0">
                                <input type="text" class="box" name="display_action_file" id="display_action_file" value="<cfif len(get_process_cat.ACTION_FILE_NAME) and get_process_cat.ACTION_FILE_FROM_TEMPLATE neq 1><cfoutput>#get_process_cat.ACTION_FILE_NAME#</cfoutput></cfif>" readonly="yes" style=" <cfif len(get_process_cat.ACTION_FILE_NAME) and get_process_cat.ACTION_FILE_FROM_TEMPLATE neq 1><cfelse>display:none;</cfif>" >
                                <span class="input-group-addon" href="javascript://" id="display_action_file_id" onclick="del_template_action_file(2);" style=" <cfif len(get_process_cat.ACTION_FILE_NAME) and get_process_cat.ACTION_FILE_FROM_TEMPLATE neq 1> display:'';<cfelse> display:none;</cfif>">
                                <i class="fa fa-minus"></i></span>
                                <input type="file" name="action_file_name" id="action_file_name" style=" <cfif len(get_process_cat.ACTION_FILE_FROM_TEMPLATE) and get_process_cat.ACTION_FILE_FROM_TEMPLATE eq 1>display:none;<cfelse></cfif>" >
                                <input type="text" name="action_file_name_template" id="action_file_name_template" readonly="" style=" <cfif len(get_process_cat.ACTION_FILE_FROM_TEMPLATE) and get_process_cat.ACTION_FILE_FROM_TEMPLATE eq 1><cfelse>display:none;</cfif>" value="<cfif len(get_process_cat.action_file_name) and get_process_cat.action_file_from_template eq 1><cfoutput>#get_process_cat.action_file_name#</cfoutput></cfif>">
                                <span class="input-group-addon" id="value21" href="javascript://" <cfif len(get_process_cat.action_file_name) and get_process_cat.ACTION_FILE_FROM_TEMPLATE eq 1> style="display:none;"</cfif> onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=process.popup_dsp_template&field_name=upd_process_cat.action_file_name_template&field_id=upd_process_cat.action_file_name&type=2&process_type=2','list');">
                                <i class="fa fa-plus"></i></span>
                                <span class="input-group-addon" href="javascript://" id="value22" onclick="del_template_action_file(1);" <cfif not len(get_process_cat.action_file_name) or not len(get_process_cat.ACTION_FILE_FROM_TEMPLATE)> style="display:none;"</cfif>>
                                <i class="fa fa-minus"></i></span>
                            </div>
                        </div>
                    </div>
                   
            </div>
            <cfset disable_process_type_list="2502,2504,2505,2506,2507,2508,2509,2510,2511,2512">
            <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                <div id="is_cari" <cfif listfind('#disable_process_type_list#,530',get_process_cat.process_type)>style="display:none;" <cfelse>style="display:'';" </cfif>>
                    <div class="form-group" id="item-is_cari"> 
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"> <input type="checkbox" name="is_cari" id="is_cari" value="1"<cfif get_process_cat.is_cari eq 1> checked</cfif>><cf_get_lang dictionary_id='42480.Cari İşlem'></label>
                    </div>    
                </div>
                <div id="is_account" <cfif listfind(disable_process_type_list,get_process_cat.process_type)>style="display:none;" <cfelse>style="display:'';" </cfif>>
                    <div class="form-group" id="item-is_account"> 
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_account" id="is_account" value="1" onchange="document_payment_types()" <cfif get_process_cat.is_account eq 1> checked</cfif>><cf_get_lang dictionary_id='42491.Muhasebe İşlemi'></label>
                    </div>   
                </div> 
                <div id="is_budget_field" <cfif listfind(disable_process_type_list,get_process_cat.process_type)>style="display:none;" <cfelse>style="display:'';" </cfif>>
                    <div class="form-group" id="item-is_budget"> 
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_budget" id="is_budget" value="1"<cfif get_process_cat.is_budget eq 1> checked</cfif>><cf_get_lang dictionary_id='43233.Bütçe İşlemi Yapılsın'></label>
                    </div>
                </div>   
                <div id="export_registered" <cfif get_process_cat.process_type eq 5311> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_export_registered">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"> <input type="checkbox" name="is_export_registered" id="is_export_registered" value="1"<cfif len(get_process_cat.is_export_registered) and get_process_cat.is_export_registered eq 1> checked</cfif>><cf_get_lang dictionary_id ='60097.İhraç Kayıtlı İşlem (Dahilde İşlem)'></label>
                    </div>
                </div>
                <div id="export_product"<cfif get_process_cat.process_type eq 5311> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_export_product">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_export_product" id="is_export_product" value="1"<cfif len(get_process_cat.is_export_product) and get_process_cat.is_export_product eq 1> checked</cfif>><cf_get_lang dictionary_id ='60094.İhraç Kayıtlı İşlem (Nihai Ürün)'></label>
                    </div>
                </div>
                <div id="allowance_deduction"<cfif get_process_cat.process_type eq 2503 or get_process_cat.process_type eq 1201> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_allowance_deduction">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_allowance_deduction" id="is_allowance_deduction" value="1"<cfif len(get_process_cat.is_allowance_deduction) and get_process_cat.is_allowance_deduction eq 1> checked</cfif>><cf_get_lang dictionary_id ='60864.Ödenek işlemi yapılsın'></label>
                    </div>
                    <div class="form-group" id="item-is_deduction">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_deduction" id="is_deduction" value="1"<cfif len(get_process_cat.is_deduction) and get_process_cat.is_deduction eq 1> checked</cfif>><cf_get_lang dictionary_id ='60895.Kesinti işlemi yapılsın'></label>
                    </div>
                </div>
                <cfset process_sales_cost_list = "59,76,171,54,55,73,74,62,78,114,115,116,811,591,58,81,113,1131,63,48,50,49,51,110,761,592,1182"><!--- 761 hal irsaliyesi 592 hal fat.--->
                <div id="sales_cost" <cfif listfind(process_sales_cost_list,get_process_cat.process_type)> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_cost">    
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_cost" id="is_cost" value="1"<cfif get_process_cat.is_cost eq 1> checked</cfif>><cf_get_lang dictionary_id='43234.Maliyet İşlemi Yapılsın'></label>
                    </div>
                </div>    
                <div id="sales_cost_field" <cfif listfind(process_sales_cost_list,get_process_cat.process_type)> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_cost_field">    
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_cost_field" id="is_cost_field" value="1"<cfif get_process_cat.is_cost_field eq 1> checked</cfif>><cf_get_lang dictionary_id='43695.Maliyet İşlemi Belgedeki Maliyet Tutarlarından Yapılsın'></label>
                    </div>
                </div>    
                <div id="sales_cost_row_zero" <cfif listfind(process_sales_cost_list,get_process_cat.process_type)> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_cost_zero_row">    
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"> <input type="checkbox" name="is_cost_zero_row" id="is_cost_zero_row" value="1"<cfif get_process_cat.is_cost_zero_row eq 1> checked</cfif>>0<cf_get_lang dictionary_id='43883.Tutarlı Satırlar İçin Maliyet İşlemi Yapılsın'></label>
                    </div>
                </div>
                <cfset process_stock_list = "171,52,53,54,55,59,62,64,65,66,69,690,591,592,531,532,70,71,72,73,74,75,76,77,78,79,80,81,811,82,83,84,85,86,88,761,110,111,112,113,1131,114,115,116,140,141,120,122,118,1182,5311,533">
                <div id="stock" <cfif listfind(process_stock_list,get_process_cat.process_type)> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_stock_action">    
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_stock_action" id="is_stock_action" value="1"<cfif get_process_cat.is_stock_action eq 1> checked</cfif>><cf_get_lang dictionary_id='43235.Stok Hareketi Yapılsın'></label>
                    </div>
                </div>    
                <div id="zero_stock" <cfif listfind(process_stock_list,get_process_cat.process_type)> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_zero_stock_control">    
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_zero_stock_control" id="is_zero_stock_control" value="1" <cfif len(get_process_cat.is_zero_stock_control) and get_process_cat.is_zero_stock_control eq 1> checked</cfif>><cf_get_lang dictionary_id ='43880.Sıfır Stok Kontrolu Yapılsın'></label>
                    </div>
                </div>
                <div class="form-group" id="item-is_default">    
                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_default" id="is_default" value="1"<cfif get_process_cat.is_default eq 1> checked</cfif>><cf_get_lang dictionary_id='43115.Standart Seçenek Olarak Gelsin'>(Default)</label>
                </div>
                <cfset process_discount_list = "50,51,52,53,531,532,54,55,56,561,57,58,59,591,592,60,601,61,62,63,64,65,66,67,68,690,691">
                <div id="discount" <cfif listfind(process_discount_list,get_process_cat.process_type)> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_discount">    
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_discount" id="is_discount" value="1"<cfif get_process_cat.is_discount eq 1> checked</cfif>><cf_get_lang dictionary_id='43236.Muhasebe İşlemlerinde İskontolar Alınmasın'></label>
                    </div>
                </div> 
                <cfset account_prod_cost_list = "52,53,54,55,56,531">
                <div id="account_prod_cost" <cfif listfind(account_prod_cost_list,get_process_cat.process_type)> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_prod_cost_acc_action">    
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"> <input type="checkbox" name="is_prod_cost_acc_action" id="is_prod_cost_acc_action" value="1"<cfif len(get_process_cat.is_prod_cost_acc_action) and get_process_cat.is_prod_cost_acc_action eq 1> checked</cfif>><cf_get_lang dictionary_id='60826.Satılan Malın Maliyeti Muhasebe Hareketi Yapılsın'></label>
                    </div>
                </div>    
                <div id="is_project_based_acc" <cfif listfind(disable_process_type_list,get_process_cat.process_type)>style="display:none;" <cfelse>style="display:'';" </cfif>>
                    <div class="form-group" id="item-is_project_based_acc">    
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_project_based_acc" id="is_project_based_acc" onClick="change_based_acc(1);" value="1"<cfif get_process_cat.is_project_based_acc eq 1> checked</cfif>><cf_get_lang dictionary_id='43237.Proje Bazlı Muhasebeleştirme Yapılsın'></label>
                    </div>
                </div>
                <div id="_is_dept_based_acc_"  <cfif not listfind('113,112,115,110,119,122,62,592,531,53,591,532,59,52,54,55,171,81,690,64,811',get_process_cat.process_type)> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_dept_based_acc">    
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"> <input type="checkbox" name="is_dept_based_acc" id="is_dept_based_acc" value="1"<cfif get_process_cat.is_dept_based_acc eq 1> checked</cfif>><cf_get_lang dictionary_id='60827.Depo Bazlı Muhasebeleştirme Yapılsın'></label>
                    </div>
                </div>    
                <div id="is_project_based_budget" <cfif listfind(disable_process_type_list,get_process_cat.process_type)>style="display:none;" <cfelse>style="display:'';" </cfif>>
                    <div id="is_project_based_budget_field" <cfif listfind('45,46',get_process_cat.process_type)> style="display:none;"</cfif>>
                        <div class="form-group" id="item-is_project_based_budget">    
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"> <input type="checkbox" name="is_project_based_budget" id="is_project_based_budget" value="1"<cfif get_process_cat.is_project_based_budget eq 1> checked</cfif>><cf_get_lang dictionary_id='43238.Proje Bazlı Bütçe İşlemi Yapılsın'></label>
                        </div>
                    </div>   
                </div> 
                <!--- toplu gelen havale, toplu giden havale, toplu tahsilat, toplu ödeme işlem kategorilerinde hesap bazında gruplama kilitleniyor. --->
                <div id="tr_is_account_group" <cfif session.ep.our_company_info.is_edefter and listFind('240,253,310,320,2410,410,420',get_process_cat.process_type)>style="display:none"</cfif>>
                    <div id="is_account_group" <cfif listfind(disable_process_type_list,get_process_cat.process_type)>style="display:none;" <cfelse>style="display:'';" </cfif>>
                        <div class="form-group" id="item-is_account_group">    
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_account_group" id="is_account_group" value="1" <cfif get_process_cat.is_account_group eq 1> checked</cfif>><cf_get_lang dictionary_id='43239.Hesap Bazında Grupla'></label>
                        </div>
                    </div>    
                </div>
                <div class="form-group" id="item-is_partner">
                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_partner" id="is_partner" value="1"<cfif get_process_cat.is_partner eq 1> checked</cfif>><cf_get_lang dictionary_id='43240.Partner da Kullanılsın'></label>
                </div>
                <div class="form-group" id="item-is_public">
                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_public" id="is_public" value="1"<cfif get_process_cat.is_public eq 1> checked</cfif>><cf_get_lang dictionary_id='43241.Public de Kullanılsın'></label>
                </div>       
                <cfset process_cheque_list = "90,91,92,93,94,95,105,97,98,99,100,101,104,106,107,108,109,1057">
                <div id="cheque" <cfif listfind(process_cheque_list,get_process_cat.process_type)> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_cheque_based_action">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_cheque_based_action" id="is_cheque_based_action" value="1"<cfif len(get_process_cat.is_cheque_based_action) and get_process_cat.is_cheque_based_action eq 1> checked</cfif>><cf_get_lang dictionary_id ='43884.Çek ve Senet Bazında Cari İşlem Yapılsın'></label>
                    </div>
                </div>    
                <cfset process_cheque_voucher_list = "90,91,94,95,97,98,101,108">
                <div id="cheque_voucher" <cfif listfind(process_cheque_voucher_list,get_process_cat.process_type)> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_cheque_based_acc_action">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_cheque_based_acc_action" id="is_cheque_based_acc_action" value="1"<cfif len(get_process_cat.is_cheque_based_acc_action) and get_process_cat.is_cheque_based_acc_action eq 1> checked</cfif>><cf_get_lang dictionary_id ='43544.Çek ve Senet Bazında Muhasebe İşlemi Yapılsın'></label>
                    </div>
                </div>
                <div id="cheque1" <cfif listfind(process_cheque_list,get_process_cat.process_type)> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_upd_cari_row">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_upd_cari_row" id="is_upd_cari_row" value="1"<cfif len(get_process_cat.is_upd_cari_row) and get_process_cat.is_upd_cari_row eq 1> checked</cfif>><cf_get_lang dictionary_id ='43879.Tahsilat Değeri Extreyi Günceller'></label>
                    </div>
                </div>    
                <cfset inv_process_type_list = "50,51,52,53,531,532,54,55,56,561,57,58,59,591,592,60,601,61,62,63,64,65,66,67,68,690,691">
                <div id="_is_due_date_based_cari_"<cfif listfind(inv_process_type_list,get_process_cat.process_type)> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_due_date_based_cari">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_due_date_based_cari" id="is_due_date_based_cari" onclick="change_based_cari(1);" value="1" <cfif len(get_process_cat.is_due_date_based_cari) and get_process_cat.is_due_date_based_cari eq 1> checked</cfif>><cf_get_lang dictionary_id ='43881.Vade ve Döviz Bazında Cari İşlem Yapılsın'></label>
                    </div>
                </div>    
                <div id="_is_paymethod_based_cari_"<cfif listfind(ListAppend(inv_process_type_list,'120,121'),get_process_cat.process_type)> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_paymethod_based_cari">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_paymethod_based_cari" id="is_paymethod_based_cari" onclick="change_based_cari(2);" value="1" <cfif len(get_process_cat.is_paymethod_based_cari) and get_process_cat.is_paymethod_based_cari eq 1> checked</cfif>><cf_get_lang dictionary_id='43430.Ödeme Yöntemi Bazında Cari İşlem Yapılsın'></label>
                    </div>
                </div>    
                <div id="_is_row_project_based_cari_"<cfif listfind(ListAppend(inv_process_type_list,'120,121'),get_process_cat.process_type)> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_paymethod_based_cari">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_row_project_based_cari" id="is_row_project_based_cari" onclick="change_based_cari(3);" value="1" <cfif len(get_process_cat.is_row_project_based_cari) and get_process_cat.is_row_project_based_cari eq 1> checked</cfif>><cf_get_lang dictionary_id='60833.Satırdaki Proje Bazında Cari İşlem Yapılsın'></label>
                    </div>
                </div>    
                <div id="_is_exp_based_acc_"  <cfif not listfind('120,121',get_process_cat.process_type)> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_exp_based_acc">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_exp_based_acc" id="is_exp_based_acc" onclick="change_based_acc(2);" value="1"<cfif get_process_cat.is_exp_based_acc eq 1> checked</cfif>><cf_get_lang dictionary_id='43442.Hizmet Kalemiyle Muhasebeleştir'></label>
                    </div>
                </div>     
                <div id="_is_add_inventory_"  <cfif not listfind('71,74,73',get_process_cat.process_type)> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_add_inventory">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_add_inventory" id="is_add_inventory" value="1"<cfif get_process_cat.is_add_inventory eq 1> checked</cfif>><cf_get_lang dictionary_id='60834.Demirbaş Stok Fişi Kaydı Yapılsın'></label>
                    </div>
                </div>
                <div id="_is_process_currency_"  <cfif not listfind('41,42,43',get_process_cat.process_type)> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_process_currency">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_process_currency" id="is_process_currency" value="1"<cfif get_process_cat.is_process_currency eq 1> checked</cfif>><cf_get_lang dictionary_id='60835.İşlem Dövizi Kurlarından Hesap Yapılmasın'></label>
                    </div>
                </div>    
                <cfset process_lotno_list = "171,70,71,72,73,74,75,76,77,78,79,80,81,811,82,83,84,85,86,88,761,110,111,112,113,1131,114,115,116,140,141,122,118,1182,48,49,50,51,52,53,54,55,56,561,57,58,59,60,601,61,62,63,64,65,66,67,68,69,690,691,591,592,531,532">
                <div id="_is_lot_no" <cfif listfind(process_lotno_list,get_process_cat.process_type)> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_lot_no">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"> <input type="checkbox" name="is_lot_no" id="is_lot_no" value="1"<cfif get_process_cat.is_lot_no eq 1> checked</cfif>><cf_get_lang dictionary_id='43045.Lot No Kullanılsın'></label>
                    </div>
                </div>
                <div id="_is_visible_tevkifat" <cfif not listFind('55,62', get_process_cat.process_type)> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_vis_tevkifat">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"> <input type="checkbox" name="is_visible_tevkifat" id="is_visible_tevkifat" value="1"<cfif get_process_cat.is_visible_tevkifat eq 1> checked</cfif>><cf_get_lang dictionary_id='62832.İade Faturalarında Tevkifat Muhasebeleşmesin'></label>
                    </div>
                </div>
                <cfset process_expensingTax_list = "48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,67,68,531,532,533,561,591,592,601,690,691,120,121">
                <div id="_is_expensing_tax" <cfif listfind(process_expensingTax_list,get_process_cat.process_type)> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_expensing_tax">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_expensing_tax" id="is_expensing_tax" value="1"<cfif get_process_cat.is_expensing_tax eq 1> checked</cfif>><cf_get_lang dictionary_id="56183.KDV'yi giderleştir"></label>
                    </div>
                </div>
                <cfset process_expensingOiv_list = "51,54,55,56,57,58,59,591,592,60,61,63,64,65,68,690,691,601,49,120,62"> <!--- alış faturaları ve masraf PY --->
                <div id="is_expensing_oiv" <cfif listfind(process_expensingOiv_list,get_process_cat.process_type)> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_expensing_oiv">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_expensing_oiv" id="is_expensing_oiv" value="1"<cfif get_process_cat.is_expensing_oiv eq 1> checked</cfif>><cf_get_lang dictionary_id="61094.Oiv'yi giderleştir"></label>
                    </div>
                </div>
                <div id="is_expensing_otv" <cfif listfind(process_expensingOiv_list,get_process_cat.process_type)> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_expensing_otv">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_expensing_otv" id="is_expensing_otv" value="1"<cfif get_process_cat.is_expensing_otv eq 1> checked</cfif>><cf_get_lang dictionary_id="61095.otv'yi giderleştir"></label>
                    </div>
                </div>
                <div id="next_periods_accrual_action"  <cfif listfind(disable_process_type_list,get_process_cat.process_type)>style="display:none;" <cfelse>style="display:'';" </cfif>>
                    <div class="form-group" id="item-next_periods_accrual_action">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="next_periods_accrual_action" id="next_periods_accrual_action" value="1"<cfif get_process_cat.next_periods_accrual_action eq 1> checked</cfif>><cf_get_lang dictionary_id='60836.Gelecek Ay ve Yıllara Ait İşlemleri Tahakkuklaştır'></label>
                    </div>
                </div>
                <div id="accrual_budget_action"  <cfif listfind(disable_process_type_list,get_process_cat.process_type)>style="display:none;" <cfelse>style="display:'';" </cfif>>
                    <div class="form-group" id="item-accrual_budget_action">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"> <input type="checkbox" name="accrual_budget_action" id="accrual_budget_action" value="1"<cfif get_process_cat.accrual_budget_action eq 1> checked</cfif>><cf_get_lang dictionary_id='60840.Tahakkuk İşlemine Göre Bütçe Planı Kaydı At'></label>
                    </div>
                </div>
                <cfset process_budget_list = "2502,59,60,65,68,64">
                <div id="budget_reserved_control"  <cfif listfind(process_budget_list,get_process_cat.process_type)>style="display:'';" <cfelse>style="display:none;" </cfif>>
                    <div class="form-group" id="item-budget_reserved_control">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"> <input type="checkbox" name="budget_reserved_control" id="budget_reserved_control" value="1"<cfif get_process_cat.is_budget_reserved_control eq 1> checked</cfif>><cf_get_lang dictionary_id='60843.Bütçe Rezerve İşlemi Yap'></label>
                    </div>
                </div>
                <cfset process_expensingBsmv_list = "48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,67,68,531,532,533,561,591,592,601,690,691,120,121">
                <div id="_is_expensing_bsmv" <cfif listfind(process_expensingBsmv_list,get_process_cat.process_type)> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_expensing_bsmv">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_expensing_bsmv" id="is_expensing_bsmv" value="1"<cfif get_process_cat.is_expensing_bsmv eq 1> checked</cfif>><cf_get_lang dictionary_id="60845.BSMV'yi giderleştir"></label>
                    </div>
                </div>
                <div id="_is_inventory_valuation"<cfif get_process_cat.process_type eq 122> style="display:'';"<cfelse> style="display:none;"</cfif>>
                    <div class="form-group" id="item-is_inventory_valuation">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_inventory_valuation" id="is_inventory_valuation" value="1"<cfif len(get_process_cat.is_inventory_valuation) and get_process_cat.is_inventory_valuation eq 1> checked</cfif>><cf_get_lang dictionary_id='56413.Değer Artışı Yaratan İşlem'></label>
                    </div>
                </div>
                <div class="form-group" id="item-is_all_users">
                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_all_users" id="is_all_users" value="1"<cfif get_process_cat.is_all_users eq 1> checked</cfif>><cf_get_lang dictionary_id='59523.Tüm Kullanıcılar'></label>
                </div>
            </div>
         
        <!-- sil --><div id="cc"><!-- sil --></div>
        <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
            <cf_flat_list id="td_yetkili2">
                <thead>
                    <tr>
                        <th width="20">
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_position_cats_multiuser&table_row_name=table_row_pcat&field_form_name=upd_process_cat&field_poscat_id=position_cats&field_td=td_yetkili2&table_name=pos_cats&row_count=row_count_positon_cat&function_row_name=sil_process_cat</cfoutput>','list');">
                            <i class="fa fa-plus"></i></a>
                        </th>
                        <th><cf_get_lang dictionary_id = '43395.Yetkili Pozisyon Kategorileri' ></th>
                    </tr>
                </thead>
                <tbody id="pos_cats" name="pos_cats">
                    <tr id="table_row_pcat0" name="table_row_pcat0">
                        <td><input type="hidden" name="row_count_positon_cat" id="row_count_positon_cat" value="<cfoutput>#GET_PROCESS_CAT_ROWS_POSITION_CATS.Recordcount#</cfoutput>">
                            <input type="hidden" name="position_cats" id="position_cats" value="">
                        </td>
                        <td></td>
                    </tr>
                    <cfoutput query="GET_PROCESS_CAT_ROWS_POSITION_CATS">
                        <tr id="table_row_pcat#currentrow#" name="table_row_pcat#currentrow#">
                            <td><input type="hidden" name="position_cats" id="position_cats" value="#POSITION_CAT_ID#">
                                <a href="javascript://" onclick="sil_process_cat('#currentrow#');"><i class="fa fa-minus"></i></a>
                            </td>
                            <td>#POSITION_CAT#</td>
                        </tr>
                    </cfoutput>
                </tbody>
            </cf_flat_list>
            <cfsavecontent variable="txt_2"><cf_get_lang dictionary_id='42683.Yetkili Pozisyonlar'></cfsavecontent>
            <cf_workcube_to_cc is_update="1" to_dsp_name="#txt_2#" form_name="upd_process_cat" str_list_param="1" action_dsn="#DSN3#" str_action_names = "POSITION_CODE AS TO_POS_CODE" str_alias_names = "TO_PAR,TO_POS_CODE" action_table="SETUP_PROCESS_CAT_ROWS" action_id_name="PROCESS_CAT_ID" data_type="2" action_id="#attributes.process_cat_id#">
        </div>
        <div class="col col-3 col-md-3 col-sm-6 col-xs-12">   <!--- onay ve uyarılar 6 ay sonra hala kullanılmıyorsa imha edilebilir CE 19122019 --->
            <cfsavecontent variable="txt_3"><b><cf_get_lang no='2144.Onay ve Uyarılacaklar'></b></cfsavecontent>
            <cf_workcube_to_cc is_update="1" cc2_dsp_name="#txt_3#" form_name="upd_process_cat" str_list_param="1" action_dsn="#DSN3#" str_action_names = "CAU_POSITION_CODE AS CC2_POS" str_alias_names = "" action_table="SETUP_PROCESS_CAT_ROWS_CAUID" action_id_name="PROCESS_CAT_ID" data_type="2" action_id="#attributes.process_cat_id#">
        </div>
    </cf_box_elements>    
    <div class="ui-form-list-btn">
        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
            <cf_record_info query_name="get_process_cat">
        </div>
        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
            <cf_workcube_buttons is_upd='1' is_delete='0' add_function='control_action_file()'>
        </div>
	</div>
<!---    		
	<tr class="row"><td colspan="2"></td></tr>
	<cfif len(get_process_cat.display_file_name)>
	   <tr class="row">
			<td colspan="2">
                <table width="100%" cellpadding="1" cellspacing="1">
                    <tr height="22" class="color-header" id="list_display_file">
                        <td class="form-title" colspan="2">
                            <a href="javascript://" onclick="gizle_goster_image('list_action_file_img_1','list_action_file_img_2','display_upd');"><img src="/images/listele_down.gif" alt="<cf_get_lang no ='1902.Ayrıntıları Gizle'>" width="12" height="7" border="0" align="absmiddle" id="list_action_file_img_1" style="display:none;cursor:pointer;"></a>
                            <a href="javascript://" onclick="gizle_goster_image('list_action_file_img_1','list_action_file_img_2','display_upd');"><img src="/images/listele.gif" alt="<cf_get_lang no ='1903.Ayrıntıları Göster'>" width="7" height="12" border="0" align="absmiddle" id="list_action_file_img_2" style="display:;cursor:pointer;"></a>
                            &nbsp;Display File ( <cf_get_lang_main no ='2003.Dosya Adı'>: <cfoutput>#get_process_cat.display_file_name#)</cfoutput>
                        </td>
                    </tr>
                    <tr height="22" id="display_upd" style="display:none;">
                        <td>
                            <table width="100%">
                                <tr>
                                    <td>
                                        <cftry>
                                            <cfif get_process_cat.display_file_from_template eq 1>
                                                <cffile action="read" file="#index_folder#process#dir_seperator#process_type_files#dir_seperator##get_process_cat.display_file_name#" variable="display_file">
                                            <cfelse>
                                                <cffile action="read" file="#upload_folder#settings#dir_seperator##get_process_cat.display_file_name#" variable="display_file">
                                            </cfif>
                                            <textarea name="display_file_read" id="display_file_read" style="width:100%;height:300px;"><cfoutput>#display_file#</cfoutput></textarea>
                                            <cfcatch type="any"><cf_get_lang_main no ='557.Dosya Görüntüleme Hatası'>!<cfset b_hata = 1></cfcatch>
                                        </cftry>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:right;"><cfif b_hata eq 0><input type="button" value="<cf_get_lang_main no ='52.Güncelle'>" onclick="dosya_guncelle(1)"> </cfif></td>
                                </tr>
                           </table>
                        </td>
                    </tr>
                </table>
			</td>
	   </tr>
    </cfif>
	<tr style="display:none;">
	<td>
		<form name="upd_files" id="upd_files" method="post" action="<cfoutput>#request.self#?fuseaction=process.emtypopup_upd_stage_files</cfoutput>">
			<input type="hidden" name="process_cat_id_" id="process_cat_id_" value="<cfoutput>#attributes.process_cat_id#</cfoutput>">
			<!--- ftype,action file'ın inbox klasöründen mi yoksa upload klasöründen mi geldiğini belirtmek için tutuluyor.1 ise inbox değilse upload edilmiştir. --->
			<input type="text" name="ftype" id="ftype" value="">
			<!--- 2 ise action file değilse display --->
			<input type="text" name="type" id="type" value="">
			<textarea name="dosya_icerik" id="dosya_icerik"></textarea>
			<input type="text" value="<cfoutput>#get_process_cat.ACTION_FILE_NAME#</cfoutput>" name="file_name" id="file_name">
			<input type="text" value="<cfoutput>#get_process_cat.DISPLAY_FILE_NAME#</cfoutput>" name="display_file_name" id="display_file_name">
		</form>
	</td>
	<tr><td colspan="2"></td></tr>
    <cfif len(get_process_cat.action_file_name)>
	   <tr class="color-row">
			<td colspan="2">
                <table width="100%" cellpadding="1" cellspacing="1" class="color-border">
                    <tr height="22" class="color-header" id="list_action_file">
                        <td class="form-title" colspan="2">
							<a href="javascript://" onclick="gizle_goster_image('list_action_file_img1','list_action_file_img2','list_action_file_menu');"><img src="/images/listele_down.gif" alt="<cf_get_lang no ='1902.Ayrıntıları Gizle'>" width="12" height="7" border="0" align="absmiddle" id="list_action_file_img1" style="display:none;cursor:pointer;"></a>
							<a href="javascript://" onclick="gizle_goster_image('list_action_file_img1','list_action_file_img2','list_action_file_menu');"><img src="/images/listele.gif" alt="<cf_get_lang no ='1903.Ayrıntıları Göster'>" width="7" height="12" border="0" align="absmiddle" id="list_action_file_img2" style="display:;cursor:pointer;"></a>
                            &nbsp;Action File (<cf_get_lang_main no ='2003.Dosya Adı'>: <cfoutput>#get_process_cat.action_file_name#)</cfoutput>
                        </td>
                    </tr>
                    <tr height="22" id="list_action_file_menu" style="display:none;">
                        <td>
                            <table  width="100%">
                                <tr>
                                    <td>
                                    <cftry>
                                        <cfif get_process_cat.action_file_from_template eq 1>
                                            <cffile action="read" file="#index_folder#process#dir_seperator#files#dir_seperator##get_process_cat.action_file_name#" variable="kosul_file">
                                        <cfelse>
                                            <cffile action="read" file="#upload_folder#settings#dir_seperator##get_process_cat.action_file_name#" variable="kosul_file">
                                        </cfif>
                                        <textarea name="action_file_read" id="action_file_read" style="width:100%;height:100px;"><cfoutput>#kosul_file#</cfoutput></textarea>
                                        <cfcatch type="any"><cf_get_lang_main no ='557.Dosya Görüntüleme Hatası'>!<cfset a_hata = 1></cfcatch>
                                    </cftry>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:right;"><cfif a_hata eq 0><input type="button" value="<cf_get_lang_main no ='52.Güncelle'>" onclick="dosya_guncelle(2)"> </cfif></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
			</td>
	   </tr>
    </cfif>
</table>
--->
</cf_box>
</div>
</cfform>
<script language="JavaScript1.3">
    $(function(){
        
        $('#is_export_registered').change(function(){
            $('#is_export_product').prop("checked", false);
        });
        $('#is_export_product').change(function(){
            $('#is_export_registered').prop("checked", false);
        });
    })
	function document_payment_types()
	{
		if(document.getElementById('is_account').checked == true && !(list_find('160,11,12,13',document.upd_process_cat.process_type.value)))
		{
			document.getElementById('tr_document_type').style.display = '';
			document.getElementById('tr_payment_type').style.display = '';
		}
		else
		{
			document.getElementById('tr_document_type').style.display = 'none';
			document.getElementById('tr_document_type').value = '';
			document.getElementById('tr_payment_type').style.display = 'none';
			document.getElementById('tr_payment_type').value = '';
		}
	}
	function sil_process_cat(param_sil)
	{
		var my_element = eval("document.all.table_row_pcat" + param_sil);
		my_element.style.display = "none";
		try{
		my_element.innerHTML = '';//Chrome'da sorun cikartiyordu diye ekledim. Silinen öge tekrar yükleniyordu.
		}catch(e){}
		my_element.disabled = true;
	}
	function control_action_file()
	{
		if(document.upd_process_cat.is_default!=undefined && document.upd_process_cat.is_default.checked==true)
		{
			var listParam = document.getElementById("process_cat_id").value + "*" + document.upd_process_cat.module_id.value + "*" + document.upd_process_cat.process_type.value;
			if(list_find("51,54,55,59,60,61,63,591",document.upd_process_cat.process_type.value))
				str_default_sql= 'set_get_inventory_7';
			else if(list_find("50,52,53,56,57,58,62,531",document.upd_process_cat.process_type.value))
				str_default_sql= 'set_get_inventory_8';
			else if(list_find("73,74,75,76,77",document.upd_process_cat.process_type.value))
				str_default_sql= 'set_get_inventory_9';
			else if(list_find("70,71,72,78,79",document.upd_process_cat.process_type.value))
				str_default_sql= 'set_get_inventory_10';
			else if(list_find("140,141",document.upd_process_cat.process_type.value))
				str_default_sql= 'set_get_inventory_11';
			else
				str_default_sql= 'set_get_inventory_12';
			var get_default_process_ = wrk_safe_query(str_default_sql,'dsn3',0,listParam);
			if(get_default_process_.recordcount)
					if(confirm("Aynı Process Tipli ' " +get_default_process_.PROCESS_CAT+ "' İşlem Kategorisi Default Seçenek Olarak Tanımlanmış.\n Default Seçenek Değiştirilecektir, Değişikliği Kaydetmek İstiyor musunuz?")); else return false;
		}
		if(document.upd_process_cat.is_upd_cari_row != undefined && document.upd_process_cat.is_upd_cari_row.checked == true && document.upd_process_cat.is_cheque_based_action.checked == false)
		{
			alert("Tahsilat Değeri Ekstreyi Günceller Seçeneğini Seçmek İçin Çek ve Senet Bazında Cari İşlem Yapılsın Seçeneği Seçili Olmalıdır ! ");
			return false;
		}
		var obj =  document.upd_process_cat.action_file_name.value;
		extention = list_getat(obj,list_len(obj,'.'),'.');
		/* ilgili fatura tiplerinde irsaliye tipi secme zorunlulugu */
		if (document.getElementById('ship_type') != undefined && document.getElementById('ship_type').value == "")
		{
			alert("İrsaliye Tipi Seçiniz!");
			return false;
		}
		if(obj != '' && extention != 'cfm')
		{
			alert("<cf_get_lang no ='1905.Lütfen Action File İçin cfm Dosyası Seçiniz '>!");
			return false;
		}
		var obj2 =  document.upd_process_cat.display_file_name.value;
		extention2 = list_getat(obj2,list_len(obj2,'.'),'.');
		if(obj2 != '' && extention2 != 'cfm')
		{
			alert("<cf_get_lang no ='2588.Lütfen Display File İçin cfm Dosyası Seçiniz '>!");
			return false;
		}

		<cfif session.ep.our_company_info.is_efatura>
			if(document.getElementById('invoice_type_code').value != '' && document.getElementById('profile_id').value == '')
			{
				alert('Senaryo Seçiniz !');
				return false;
			}
		</cfif>

		document.getElementById('invoice_type_code').disabled = false;

		return true;
	}
	function del_template_action_file(file_type)
	{
		if(file_type ==1)
		{
			upd_process_cat.action_file_name.style.display='';
			upd_process_cat.action_file_name_template.style.display='none';
			upd_process_cat.action_file_name_template.value='';
			value21.style.display='';
			value22.style.display='none';
		}
		else
		{
			upd_process_cat.display_action_file.value='';
			upd_process_cat.display_action_file.style.display='none';
			display_action_file_id.style.display='none';
			list_action_file_menu.style.display='none';
			list_action_file.style.display='none';
		}
		upd_process_cat.action_file_del.value = 1;
	}
	function del_template_display_file(file_type)
	{
		if(file_type ==1)
		{
			upd_process_cat.display_file_name.style.display='';
			upd_process_cat.display_file_name_template.style.display='none';
			upd_process_cat.display_file_name_template.value='';
			value11.style.display='';
			value12.style.display='none';
		}
		else
		{
			upd_process_cat.display_display_file.value='';
			upd_process_cat.display_display_file.style.display='none';
			display_display_file_id.style.display='none';
			display_upd.style.display='none';
			list_display_file.style.display='none';
		}
		upd_process_cat.display_file_del.value = 1;
	}
	function dosya_guncelle(type)
	{
		if (type==2)//Action File
			{
			document.upd_files.dosya_icerik.value = document.getElementById('action_file_read').value;
				//eğer action file inbox klasöründen yüklenmişse 1 olsun değilse 0
				<cfif get_process_cat.ACTION_FILE_FROM_TEMPLATE eq 1>
					document.upd_files.ftype.value = 1;
				<cfelse>
					document.upd_files.ftype.value = 0;
				</cfif>
			}
		if (type==1)//Display File
			{
			document.upd_files.dosya_icerik.value = document.getElementById('display_file_read').value;
				//eğer action file inbox klasöründen yüklenmişse 1 olsun değilse 0
				<cfif get_process_cat.DISPLAY_FILE_FROM_TEMPLATE eq 1>
					document.upd_files.ftype.value = 1;
				<cfelse>
					document.upd_files.ftype.value = 0;
				</cfif>
			}
		document.upd_files.type.value = type;
		upd_files.submit();
	}
	function change_based_cari(type_info)
	{
		if(type_info == 1)
		{
			document.getElementById('is_paymethod_based_cari').checked = false;
			document.getElementById('is_row_project_based_cari').checked = false;
		}
		else if(type_info == 2)
		{
			document.getElementById('is_due_date_based_cari').checked = false;
			document.getElementById('is_row_project_based_cari').checked = false;
		}
		else
		{
			document.getElementById('is_due_date_based_cari').checked = false;
			document.getElementById('is_paymethod_based_cari').checked = false;
		}
	}
	function change_based_acc(type_info)
	{
		if(type_info == 1)
		{
			if(document.getElementById('is_exp_based_acc') != undefined)
				document.getElementById('is_exp_based_acc').checked = false;
		}
		else if(type_info == 2)
		{
			if(document.getElementById('is_project_based_acc') != undefined)
				document.getElementById('is_project_based_acc').checked = false;
		}
	}
	function addOption(value,text)
	{
		var selectBox = document.getElementById('ship_type');
		if(selectBox.options.length != 1)
			selectBox.options[0]=new Option('<cf_get_lang_main no="322.Seçiniz">','',false,true);
		selectBox.options[selectBox.options.length] = new Option(value,text);
	}
</script>


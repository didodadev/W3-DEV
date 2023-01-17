<cf_xml_page_edit fuseact="account.add_acc_to_acc">
    <cfparam name="attributes.project_id" default="">
    <cf_catalystHeader>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cfform name="add_acc_to_acc" action="#request.self#?fuseaction=account.emptypopup_add_acc_to_acc_act" method="post">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-is_acc_remainder_transfer">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <label><cf_get_lang dictionary_id='47521.Transfer Balance'><input type="checkbox" name="is_acc_remainder_transfer" id="is_acc_remainder_transfer" value="1" checked="checked"></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-ACTION_DATE">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput validate="#validate_style#" maxlength="10" type="text" name="ACTION_DATE" value="#dateformat(now(),dateformat_style)#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="ACTION_DATE"></span>	
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-acc_card_type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfquery name="get_acc_card_type" datasource="#dsn3#">
                                    SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
                                </cfquery>
                                <select multiple="multiple" name="acc_card_type" id="acc_card_type">
                                    <cfoutput query="get_acc_card_type" group="process_type">
                                        <cfoutput>
                                        <option value="#process_type#-#process_cat_id#">#process_cat#</option>
                                        </cfoutput>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>		
                        <div class="form-group" id="item-START_DATE">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput validate="#validate_style#" type="text" maxlength="10" name="START_DATE">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="START_DATE"></span>	
                                </div>						
                            </div>
                        </div>							
                        <div class="form-group" id="item-FINISH_DATE">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput validate="#validate_style#" maxlength="10" type="text" name="FINISH_DATE">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="FINISH_DATE"></span>	
                                </div>					
                            </div>
                        </div>	
                        <cfif isDefined('xml_acc_project_based') and xml_acc_project_based eq 1>
                            <div class="form-group" id="item-project_name">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <cf_wrkProject project_id="#attributes.project_id#" fieldName="project_name" AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5">
                                </div>
                            </div>
                        </cfif>								
                        <div class="form-group" id="item-FROM_ACC_NAME">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47323.Hesabından'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfif isdefined('xml_dsp_top_account') and xml_dsp_top_account eq 1> 
                                        <cfset is_ust_hesap = 1>
                                    <cfelse>
                                        <cfset is_ust_hesap = 0>
                                    </cfif>
                                    <!---Hesabından alanının AutoComplete_Create olarak düzenlenmesi.--->
                                    <input type="hidden" name="FROM_ACC_ID" id="FROM_ACC_ID" autocomplete="off">
                                    <cfinput type="text" name="FROM_ACC_NAME" id="FROM_ACC_NAME" required="yes" onFocus="AutoComplete_Create('FROM_ACC_NAME','ACCOUNT_CODE','CODE_NAME','get_account_code','\'#is_ust_hesap#\',0','ACCOUNT_CODE','FROM_ACC_ID','','3','250');">
                                    <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='47323.Hesabından'>" onclick="pencere_ac('FROM_ACC_ID');"></span>	
                                </div>
                            </div>
                        </div>	
                        <div class="form-group" id="item-TO_ACC_NAME">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='35574.Hesabına'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <!---Hesabına alanının AutoComplete_Create olarak düzenlenmesi.--->
                                    <input type="hidden" name="TO_ACC_ID" id="TO_ACC_ID" autocomplete="off">
                                    <cfinput type="text" name="TO_ACC_NAME" id="TO_ACC_NAME" required="yes" onFocus="AutoComplete_Create('TO_ACC_NAME','ACCOUNT_CODE','CODE_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','TO_ACC_ID','','3','250');">
                                    <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='35574.Hesabına'>" onclick="pencere_ac('TO_ACC_ID');"></span>	
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-explanation">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cftextarea name="detail" maxlength="150"></cftextarea>
                            </div>
                        </div>
                    </div>										
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
                </cf_box_footer>
            </cfform>
        </cf_box>  
    </div>
    <script type="text/javascript">
        function pencere_ac(isim)
        {
            temp_account_code = eval('add_acc_to_acc.'+isim);
            if(isim=='FROM_ACC_ID')
            {
                <cfif isdefined('xml_dsp_top_account') and xml_dsp_top_account eq 1>
                    openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=add_acc_to_acc.'+isim+'&field_name=add_acc_to_acc.FROM_ACC_NAME&keyword='+ temp_account_code.value);
                <cfelse>
                    openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_acc_to_acc.'+isim+'&field_name=add_acc_to_acc.FROM_ACC_NAME&account_code=' + temp_account_code.value);
                </cfif>
            }
            else
                openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_acc_to_acc.'+isim+'&field_name=add_acc_to_acc.TO_ACC_NAME&account_code=' + temp_account_code.value);
        }
        
        function kontrol()
        {
            if(!$("#ACTION_DATE").val().length)
            {
                alertObject({message: "<cfoutput><cf_get_lang dictionary_id='47464.Lütfen İşlem Tarihini Giriniz'></cfoutput>"})    
                return false;
            }
            if(!$("#START_DATE").val().length)
            {
                alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfoutput>"})    
                return false;
            }
            if(!$("#FINISH_DATE").val().length)
            {
                alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfoutput>"})    
                return false;
            }
            if(!$("#FROM_ACC_NAME").val().length)
            {
                alertObject({message: "<cfoutput><cf_get_lang dictionary_id='47465.Hangi Hesaptan Aktarım Yapılacağını Seçiniz'>!</cfoutput>"})    
                return false;
            }
            if(!$("#TO_ACC_NAME").val().length)
            {
                alertObject({message: "<cfoutput><cf_get_lang dictionary_id='47466.Aktarım Yapılacak Hesabı Seçiniz'>!</cfoutput>"})    
                return false;
            }
            if(document.add_acc_to_acc.is_acc_remainder_transfer.checked==true)
            {
                if (!chk_period(document.add_acc_to_acc.ACTION_DATE,'İşlem')) return false;
            }
            else
            {
                if (!confirm("<cf_get_lang dictionary_id='59054.Seçtiğiniz Hesaba Ait Tüm Hareketler Aktarılacaktır. İşlem Geri Alınamaz.'>")) return false;
            }
        
            if (document.add_acc_to_acc.TO_ACC_ID.value == document.add_acc_to_acc.FROM_ACC_ID.value && document.add_acc_to_acc.FROM_ACC_ID.value !='' )				
            {
                alert("<cf_get_lang dictionary_id='47303.Seçtiğiniz Hesaplar Aynı'>!");		
                return false; 
            }
            return true;
        }
    </script>
    
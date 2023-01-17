<!---
    File: earchieve_integration_definition.cfm
    Folder: account\form
    Author: 
    Date:
    Description:
        
    History:
        2019-10-19 00:28:55 Gramoni-Mahmut
        E-devlet standart modül çalışması için düzenlemeler yapıldı
    To Do:

--->

<cfif session.ep.admin eq 1 and session.ep.our_company_info.is_efatura eq 1 and session.ep.our_company_info.is_earchive eq 1>
	<cfscript>
		earchieve = createObject("component","V16.e_government.cfc.earchieve");
		earchieve.dsn = dsn;
		get_integration_definitions = earchieve.get_our_company_fnc(session.ep.company_id);
		//get_integration_info = earchieve.getIntegrationDefinitions();
	</cfscript>

    <cfquery name="get_einvoice_prefix" datasource="#DSN2#">
    	SELECT
        	EINVOICE_PREFIX
        FROM
        	EINVOICE_NUMBER
        WHERE
        	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfquery>
    
    <cfset save_folder      = "#upload_folder#e_government#dir_seperator#xslt" />
    <!--- Dizin kontrolü --->
	<cfif Not DirectoryExists("#save_folder#")>
		<cfdirectory action="create" directory="#save_folder#" />
    </cfif>

    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','E-Arşiv Fatura Entegrasyon Tanımları',63855)#">
            <cfform name="earchieve_integration_definitions" action="#request.self#?fuseaction=account.emptypopup_upd_earchieve_integration" enctype="multipart/form-data" method="post">
                <input type="hidden" name="earchive_integration_type" id="earchive_integration_type" value="<cfoutput>#get_integration_definitions.earchive_integration_type#</cfoutput>" />
                <input type="hidden" name="save_folder" id="save_folder" value="<cfoutput>#save_folder#</cfoutput>" />
                <input type="hidden" name="einvoice_prefix" id="einvoice_prefix" value="<cfoutput>#get_einvoice_prefix.einvoice_prefix#</cfoutput>" />
                <cf_box_elements>
                    <div class="col col-12 col-md-4 col-sm-12" type="column" index="1" sort="true">
                        <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-date">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58826.Test'>*<input type="checkbox" id="earchive_test_system" name="earchive_test_system" onclick="show_test_2();" <cfif get_integration_definitions.earchive_test_system eq 1>checked</cfif>/></label>
                        </div>
                        <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-date">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62361.Çoklu Seri Kullanılsın'><input type="checkbox" id="multiple_prefix" name="multiple_prefix" <cfif get_integration_definitions.IS_MULTIPLE_PREFIX eq 1>checked</cfif>/></label>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57234.E-Arşiv Geçiş Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif len(session.ep.our_company_info.earchive_date)><cfoutput>#dateformat(session.ep.our_company_info.earchive_date,dateformat_style)#</cfoutput></cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-earchive_type">
                            <label class="col col-4 col-xs-12">Entegrasyon Tipi*</label>
                            <div class="col col-8 col-xs-12">
                                <select name="earchive_type" id="earchive_type" style="width:185px;">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> !</option>
                                    <option value="dp" <cfif get_integration_definitions.earchive_type_alias eq 'dp'> selected</cfif>>Digital Planet</option>
                                    <option value="dgn" <cfif get_integration_definitions.earchive_type_alias eq 'dgn'> selected</cfif>>Doğan E-Dönüşüm</option>
                                    <option value="spr" <cfif get_integration_definitions.earchive_type_alias eq 'spr'> selected</cfif>>Süper Entegratör</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-earchive_ublversion">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30522.UBL Versiyon Seçiniz'>*</label>
                            <div class="col col-8 col-xs-12">
                                <select name="earchive_ublversion" id="earchive_ublversion">
                                    <option value="" ><cf_get_lang dictionary_id='57734.Seçiniz'>!</option>	
                                    <option value="2.1;TR1.2" <cfif get_integration_definitions.customizationid eq 'TR1.2'> selected</cfif>>TR1.2</option>                            		
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-earchive_company_code">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47568.Şirket Kodu'> <cfif get_integration_definitions.earchive_integration_type eq 2>*</cfif></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" id="earchive_company_code" name="earchive_company_code" value="<cfoutput>#get_integration_definitions.earchive_company_code#</cfoutput>" maxlength="50"/>
                            </div>
                        </div>
                        <div class="form-group" id="item-earchive_username">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57551.Kullanıcı Adı'> *</label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" id="earchive_username" name="earchive_username" value="<cfoutput>#get_integration_definitions.earchive_username#</cfoutput>" maxlength="50"/>
                            </div>
                        </div>
                        <div class="form-group" id="item-earchive_password">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'> *</label>
                            <div class="col col-8 col-xs-12">
                                <input type="password" id="earchive_password" name="earchive_password" value="<cfoutput>#get_integration_definitions.earchive_password#</cfoutput>" maxlength="50"/>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-earchive_prefix">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57235.E-Arşiv No Ön Ek (Mağaza)'> *</label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="earchive_prefix" id="earchive_prefix" maxlength="3" <cfif get_integration_definitions.recordcount>value="<cfoutput>#get_integration_definitions.earchive_prefix#</cfoutput>"</cfif>>
                            </div>
                        </div>
                        <div class="form-group" id="item-earchive_template">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57241.Şablon Dosyası'></label>
                            <div class="col col-4 col-xs-12">
                                <input type="file" id="earchive_template" name="earchive_template" accept=".xslt" <cfif len(get_integration_definitions.template_filename)>value="<cfoutput>#get_integration_definitions.template_filename#</cfoutput>"</cfif>>
                            </div>
                            <cfif len(get_integration_definitions.template_filename)>
                                <div class="col col-4 col-xs-12">
                                    <input type="checkbox" id="earchive_del_template" name="earchive_del_template" onchange="earchive_del_template_control();"/><cf_get_lang dictionary_id='57250.Şablonu Sil'>
                                </div>
                            </cfif>
                        </div>
                        <div class="form-group" id="item-earchive_prefix_internet">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57251.E-Arşiv No Ön Ek (İnternet)'> *</label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="earchive_prefix_internet" id="earchive_prefix_internet" style="width:50px;" maxlength="3" <cfif get_integration_definitions.recordcount>value="<cfoutput>#get_integration_definitions.earchive_prefix_internet#</cfoutput>"</cfif>>
                            </div>
                        </div>
                        <div class="form-group" id="item-earchive_internet_template">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57241.Şablon Dosyası'></label>
                            <div class="col col-4 col-xs-12">
                                <input type="file" id="earchive_internet_template" name="earchive_internet_template" accept=".xslt" width="185" <cfif len(get_integration_definitions.template_filename_internet)>value="<cfoutput>#get_integration_definitions.template_filename_internet#</cfoutput>"</cfif>>
                            </div>
                            <cfif len(get_integration_definitions.template_filename_internet)>
                                <div class="col col-4 col-xs-12">
                                    <input type="checkbox" id="earchive_internet_del_template" name="earchive_internet_del_template" onchange="earchive_internet_del_template_control();"/> <cf_get_lang dictionary_id='57250.Şablonu Sil'>
                                </div>
                            </cfif>
                        </div>
                        <cfif get_integration_definitions.recordcount>
                            <div class="form-group" id="item-attachment_file">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57253.Ek Dosya (PDF)'></label>
                                <div class="col col-4 col-xs-12">
                                    <input type="file" id="attachment_file" name="attachment_file" accept=".pdf" width="185" <cfif len(get_integration_definitions.attachment_file)>value="<cfoutput>#get_integration_definitions.attachment_file#</cfoutput>"</cfif>>
                                </div>
                                <cfif len(get_integration_definitions.attachment_file)>
                                    <div class="col col-4 col-xs-12">
                                        <input type="checkbox" id="attachment_file_del" name="attachment_file_del" onchange="attachment_file_del_control();"/> <cf_get_lang dictionary_id='35193.Dosyayı Sil'>
                                    </div>
                                </cfif>
                            </div>
                        </cfif>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_record_info query_name="get_integration_definitions" record_emp="record_emp" update_emp="update_emp">
                    <cf_workcube_buttons is_upd='1' is_delete='0' add_function="upd_control()">
                </cf_box_footer>
            </cfform>
        </cf_box>
    </div>
                
    
	
	<script language="javascript">
		function earchive_del_template_control()
        {
            if (document.getElementById('earchive_del_template').checked)
                document.getElementById('earchive_template').disabled=true;
            else 
                document.getElementById('earchive_template').disabled=false;
        }
		
		function earchive_internet_del_template_control()
        {
            if (document.getElementById('earchive_internet_del_template').checked)
                document.getElementById('earchive_internet_template').disabled=true;
            else 
                document.getElementById('earchive_internet_template').disabled=false;
        }
		
		function attachment_file_del_control()
        {
            if (document.getElementById('attachment_file_del').checked)
                document.getElementById('attachment_file').disabled=true;
            else 
                document.getElementById('attachment_file').disabled=false;
        }
		
		function upd_control()
		{
			if(document.getElementById('earchive_type').value == '')
			{
				alert("<cf_get_lang dictionary_id='57262.Entegrasyon Yöntemi Seçiniz'>!");
				return false;
			}
			if(document.getElementById('earchive_integration_type').value == 2 && document.getElementById('earchive_company_code').value == '')
			{
				alert("<cf_get_lang dictionary_id='57265.Şirket Kodunu Giriniz'>!");
				return false;
			}
			if(document.getElementById('earchive_username').value == '')
			{
				alert("<cf_get_lang dictionary_id='45139.Lütfen Kullanıcı Adı Giriniz!'>!");
				return false;
			}
			if(document.getElementById('earchive_password').value == '')
			{
				alert("<cf_get_lang dictionary_id='49039.Şifre Giriniz'>!");
				return false;
			}
			
			if(document.getElementById('earchive_prefix').value == '')
			{
				alert("<cf_get_lang dictionary_id='57267.Ön Ek (Mağaza) Giriniz'>!");
				document.getElementById('earchive_prefix').focus();
				return false;
			}
			
			if(document.getElementById('earchive_prefix').value.length != 3)
            {
                alert('<cf_get_lang dictionary_id='57269.Ön Ek (Mağaza) 3 Karakter Olmalıdır'> !');
                document.getElementById('earchive_prefix').focus();
                return false;
            }
			
			if(document.getElementById('earchive_prefix_internet').value == '')
			{
				alert("<cf_get_lang dictionary_id='57270.Ön Ek (İnternet) Giriniz'>!");
				document.getElementById('earchive_prefix_internet').focus();
				return false;
			}
						
			if(document.getElementById('earchive_prefix_internet').value.length != 3)
			{
				alert('<cf_get_lang dictionary_id='57277.Ön Ek (İnternet) 3 Karakter Olmalıdır'> !');
                document.getElementById('earchive_prefix_internet').focus();
                return false;
			}
			
			if(document.getElementById('earchive_prefix').value == document.getElementById('einvoice_prefix').value)
            {
                alert ("<cf_get_lang dictionary_id='57290.E-Fatura / E-Arşiv Ön Ek Değerleri Aynı Olamaz'>! ");
                return false;			
            }
			
			if(document.getElementById('earchive_prefix_internet').value == document.getElementById('einvoice_prefix').value)
            {
                alert ("<cf_get_lang dictionary_id='57290.E-Fatura / E-Arşiv Ön Ek Değerleri Aynı Olamaz'>!");
                return false;			
            }
			
			if(document.getElementById('earchive_prefix').value == document.getElementById('earchive_prefix_internet').value)
            {
                alert ("<cf_get_lang dictionary_id='57293.E-Arşiv Mağaza ve İnternet Ön Ek Değerleri Aynı Olamaz'>! ");
                return false;			
            }
			
			var obj = $('#earchive_template');
            var file = obj[0].files[0];

			if(file.size == 0)
            {		
                alert("<cf_get_lang dictionary_id='57294.Ön Ek (Mağaza) İçin Şablon Dosyası İçeriğini Kontrol Ediniz'>");
                return false;			
            }

			if ((obj.val() != "") && !(file.name.substring(file.name.indexOf('.')+1,file.name.length).toLowerCase() == 'xslt'))
			{
                alert("<cf_get_lang dictionary_id='57297.Ön Ek (Mağaza) İçin İlgili dosya xslt olmalıdır'>!");        
                return false;
			}
					
			var obj_internet = $('#earchive_internet_template');
            var file_internet = obj_internet[0].files[0];
		
			if(file_internet.size == 0)
            {		
                alert("<cf_get_lang dictionary_id='57298.Ön Ek (İnternet) İçin Şablon Dosyası İçeriğini Kontrol Ediniz'>");
                return false;			
            }

			if ((obj_internet.val() != "") && !(file_internet.name.substring(file_internet.name.indexOf('.')+1,file_internet.name.length).toLowerCase() == 'xslt'))
            {
                alert("<cf_get_lang dictionary_id='57299.Ön Ek (İnternet) İçin İlgili dosya xslt olmalıdır'>!");        
                return false;
			}
		}
	</script> 
<cfelse>
	<cf_get_lang dictionary_id='29938.Sistem yöneticisine başvurun'>
</cfif>
<!---
    File: einvoice_integration_definition.cfm
    Folder: account\form
    Author: 
    Date:
    Description:
        
    History:
        2019-10-19 00:28:55 Gramoni-Mahmut - E-devlet standart modül çalışması için düzenlemeler yapıldı
        2021-04-30 00:28:55 Gramoni-Mahmut - Üye bazlı şablon özelliği eklendi.
    To Do:

--->

<cfif session.ep.admin eq 1 and session.ep.our_company_info.is_efatura eq 1>
	<cfscript>
        einvoice = createObject("component","V16.e_government.cfc.einvoice");
        einvoice.dsn = dsn;
        get_our_company = einvoice.get_our_company_fnc(session.ep.company_id);
    </cfscript>
    <cfquery name="GET_EINVOICE_NUM" datasource="#DSN2#">
        SELECT
            EINVOICE_PREFIX,
            EINVOICE_NUMBER
        FROM
            EINVOICE_NUMBER
    </cfquery>
    
    <cfquery name="get_earchive_prefix" datasource="#DSN#">
    	SELECT 
        	EARCHIVE_PREFIX,
        	EARCHIVE_PREFIX_INTERNET
        FROM
        	EARCHIVE_INTEGRATION_INFO
        WHERE
        	COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfquery>

    <cfquery name="get_templates" datasource="#dsn3#">
        SELECT
			et.TEMPLATE_ID,
			et.COMPANY_ID,
			c.MEMBER_CODE AS COMPANY_CODE,
			C.FULLNAME AS COMPANY_NAME,
			et.CONSUMER_ID,
			CO.CONSUMER_NAME + ' ' + CO.CONSUMER_SURNAME AS CONSUMER_NAME,
			co.MEMBER_CODE AS CONSUMER_CODE,
			et.TEMPLATE_PATH,
			et.RECORD_EMP,
			et.RECORD_IP,
			et.RECORD_DATE
		FROM
			EINVOICE_TEMPLATES AS et
			LEFT JOIN #dsn_alias#.COMPANY AS C ON C.COMPANY_ID = et.COMPANY_ID
			LEFT JOIN #dsn_alias#.CONSUMER AS CO ON CO.CONSUMER_ID = et.CONSUMER_ID
		ORDER BY
			ISNULL(C.FULLNAME, CO.CONSUMER_NAME)
    </cfquery>
	<cfset template_count = get_templates.recordCount />

    <cfset save_folder = "#upload_folder#e_government#dir_seperator#xslt" />
    <!--- Dizin kontrolü --->
	<cfif Not DirectoryExists("#save_folder#")>
		<cfdirectory action="create" directory="#save_folder#" />
    </cfif>
	<div class="col col-6 col-xs-12">
		<cf_box closable="0" collapsable="0" resize="0" title="#getLang('main','',31363,'E-Fatura Entegrasyon Tanımları')#">
		<cfform name="einvoice_integration_definition" action="#request.self#?fuseaction=account.emptypopup_upd_einvoice_integration" enctype="multipart/form-data" method="post">
			<input type="hidden" name="einvoice_type" id="einvoice_type" value="<cfoutput>#get_our_company.einvoice_type#</cfoutput>" />
			<input type="hidden" name="old_einvoice_type" id="old_einvoice_type" value="<cfoutput>#get_our_company.einvoice_type#</cfoutput>" />
			<input type="hidden" name="save_folder" id="save_folder" value="<cfoutput>#save_folder#</cfoutput>" />
			<input type="hidden" name="earchive_prefix" id="earchive_prefix" value="<cfoutput>#get_earchive_prefix.earchive_prefix#</cfoutput>" />
			<input type="hidden" name="earchive_prefix_internet" id="earchive_prefix_internet" value="<cfoutput>#get_earchive_prefix.earchive_prefix_internet#</cfoutput>" />
			<input type="hidden" name="form1_submitted" id="form1_submitted" value="1" />
			<cf_box_elements>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label nowrap><cf_get_lang dictionary_id='30556.E-Fatura Geçiş Tarihi'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12"><cfif len(get_our_company.efatura_date)><cfoutput>#dateformat(get_our_company.efatura_date,dateformat_style)#</cfoutput></cfif></div>
				</div>       
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="label_einvoice_signature_url">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='30555.İmza Adresi'> *</label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12"><input type="text" id="einvoice_signature_url" name="einvoice_signature_url" value="<cfoutput>#get_our_company.einvoice_signature_url#</cfoutput>" maxlength="100" style="width:185px;"/>&nbsp;(Örnek : http://192.168.7.77/sign.asmx?wsdl veya http://192.168.10.15:8080/signer/services/SignerPort)</div>
				</div>                
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="label_einvoice_test_system">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='58826.Test'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12"><input type="checkbox" id="einvoice_test_system" name="einvoice_test_system" <cfif get_our_company.einvoice_test_system eq 1>checked</cfif>/></div>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="label_einvoice_type_alias">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label>Entegrasyon Tipi *</label>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<select name="einvoice_type_alias" id="einvoice_type_alias" style="width:185px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> !</option>
							<option value="dp" <cfif get_our_company.einvoice_type_alias eq 'dp'> selected</cfif>>Digital Planet</option>
							<option value="dgn" <cfif get_our_company.einvoice_type_alias eq 'dgn'> selected</cfif>>Doğan E-Dönüşüm</option>
							<option value="spr" <cfif get_our_company.einvoice_type_alias eq 'spr'> selected</cfif>>Süper Entegratör</option>
						</select>
					</div>
				</div>				
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="label_einvoice_ublversion">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='30522.UBL Versiyon Seçiniz'> *</label>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<select name="einvoice_ublversion" id="einvoice_ublversion" style="width:185px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> !</option>
							<option value="2.1;TR1.2" <cfif get_our_company.customizationid eq 'TR1.2'> selected</cfif>>TR1.2</option>
						</select>
					</div>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="label_einvoice_company_code">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='47568.Şirket Kodu'> *</label>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="text" id="einvoice_company_code" name="einvoice_company_code" value="<cfoutput>#get_our_company.einvoice_company_code#</cfoutput>" maxlength="50" style="width:185px;"/></div>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="label_einvoice_user_name">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='57551.Kullanıcı Adı'> *</label>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="text" id="einvoice_user_name" name="einvoice_user_name" value="<cfoutput>#get_our_company.einvoice_user_name#</cfoutput>" maxlength="50" style="width:185px;"/></div>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="label_einvoice_password">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='57552.Şifre'> *</label>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="password" id="einvoice_password" name="einvoice_password" value="<cfoutput>#get_our_company.einvoice_password#</cfoutput>" maxlength="50" style="width:185px;"/></div>
				</div>
		
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="label_einvoice_sender_alias">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='30554.Gönderici Etiketi'> *</label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12"><input type="text" id="einvoice_sender_alias" name="einvoice_sender_alias" value="<cfoutput>#get_our_company.einvoice_sender_alias#</cfoutput>" maxlength="50" style="width:185px;"/></div>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="label_einvoice_receiver_alias">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='30526.Alıcı Etiketi'> *</label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12"><input type="text" id="einvoice_receiver_alias" name="einvoice_receiver_alias" value="<cfoutput>#get_our_company.einvoice_receiver_alias#</cfoutput>"  maxlength="50" style="width:185px;"/></div>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="label_einvoice_number">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='30525.E-Fatura No'> *</label>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="input-group">
							<cfinput type="text" name="einvoice_prefix" value="#get_einvoice_num.einvoice_prefix#" maxlength="3" required="yes" style="width:30px;text-align:left;"/>
							<span class="input-group-addon"></span>
							<cfinput type="text" name="einvoice_number" value="#get_einvoice_num.einvoice_number#" maxlength="9" required="yes" style="width:152px;text-align:left;"/>
						</div>				
					</div>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="label_einvoice_template">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='57241.Şablon Dosyası'></label>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="file" id="einvoice_template" name="einvoice_template" accept=".xslt" width="185" /></div>
					<cfif len(get_our_company.template_filename)>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12" height="35" nowrap="nowrap">
							<input type="checkbox" id="del_template" name="del_template" onchange="del_template_control();"/> <label for="del_template"><cf_get_lang dictionary_id='57250.Şablonu Sil'></label>
						</div>
					</cfif>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="label_is_receiving_process">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='30524.Gelen E-Faturada Süreç Kullanılıyor'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12"><input type="checkbox" id="is_receiving_process" name="is_receiving_process" <cfif get_our_company.is_receiving_process eq 1>checked</cfif>/></div>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="label_special_period">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='30523.Özel Periyot'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12"><input type="checkbox" id="special_period" name="special_period" <cfif get_our_company.special_period eq 1>checked</cfif>/></div>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label for="multiple_prefix"><cf_get_lang dictionary_id='62361.Çoklu Seri Kullanılsın'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12"><input type="checkbox" id="multiple_prefix" name="multiple_prefix" <cfif get_our_company.IS_MULTIPLE_PREFIX eq 1>checked</cfif>/></div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_our_company" record_emp="record_emp" update_emp="update_emp">
				<cf_workcube_buttons is_upd='1' is_delete='0' add_function='control()'>
			</cf_box_footer>
		</cfform>
		</cf_box>
	</div>
	<div class="col col-6 col-xs-12">
		<cf_box closable="0" collapsable="0" resize="0" title="#getLang('main','',62754,'Üye E-Fatura Şablonları')#">
			<cfform name="member_templates" method="post" action="#request.self#?fuseaction=account.emptypopup_upd_einvoice_integration" enctype="multipart/form-data">
				<input type="hidden" name="form2_submitted" id="form2_submitted" value="1" />
				<cf_flat_list name="table1" id="table1">
					<thead>
						<tr>
							<th width="20">
								<input type="hidden" name="record_num" id="record_num" value="0" />
								<a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
							</th>
							<th><cf_get_lang dictionary_id='57558.Üye No'></th>
							<th><cf_get_lang dictionary_id='30339.Üye Adı'></th>
							<th><cf_get_lang dictionary_id='57241.Şablon Dosyası'></th>
							<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
						</tr>
					</thead>
					<tbody>
						<cfif template_count>
							<cfoutput query="get_templates">
								<tr id="frm_row#currentrow#">
									<td >
										<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#COMPANY_ID#" />
										<input type="hidden" name="consumer_id#currentrow#" id="consumer_id#currentrow#" value="#CONSUMER_ID#" />
										<input type="hidden" name="row_control#currentrow#" id="row_control#currentrow#" value="-1" />
										<input type="hidden" name="template_id#currentrow#" id="template_id#currentrow#" value="#TEMPLATE_ID#" />
										<a style="cursor:pointer" onClick="sil(#currentrow#);"><img src="images/delete_list.gif" title="<cf_get_lang dictionary_id='57463.Sil'>" border="0" align="absmiddle"></a>
									</td>
									<td><cfif Len(COMPANY_ID)>#COMPANY_CODE#<cfelseif Len(CONSUMER_ID)>#CONSUMER_CODE#</cfif></td>
									<td nowrap="nowrap"><cfif Len(COMPANY_ID)>#COMPANY_NAME#<cfelseif Len(CONSUMER_ID)>#CONSUMER_NAME#</cfif></td>
									<td>#TEMPLATE_PATH#.xslt</td>
									<td>#dateFormat(RECORD_DATE,"dd.mm.YYYY")#</td>
								</tr>
							</cfoutput>
						</cfif>
					</tbody>			  
				</cf_flat_list>
				<cf_box_footer>
					<cf_record_info query_name="get_templates">
					<cf_workcube_buttons is_upd='1' is_delete='0' add_function='template_control()'>
				</cf_box_footer>
			</cfform>
		</cf_box>
	</div>

	<script type="text/javascript">
        show_hide_einvoice(<cfoutput>#get_our_company.einvoice_type#</cfoutput>);

        function del_template_control()
        {
            if (document.getElementById('del_template').checked)
                document.getElementById('einvoice_template').disabled=true;
            else 
                document.getElementById('einvoice_template').disabled=false;
        }

        function control()
        {
            if(document.getElementById('einvoice_type_alias').value == "")
            {
                alert ("<cf_get_lang dictionary_id='57262.Entegrasyon Yöntemi Seçiniz'> !");
                return false;
            }
    
            if(document.getElementById('einvoice_ublversion').value == "")
            {
                alert ("<cf_get_lang dictionary_id='30522.UBL Versiyon Seçiniz'> !");
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

			var obj = $('#einvoice_template');
            var file = obj[0].files[0];
            if(file.size == 0)
            {
				alert("<cf_get_lang dictionary_id='30521.Dosya İçeriğini Kontrol Ediniz'>");
				return false;
            }
    
			if ((obj.val() != "") && !(file.name.substring(file.name.indexOf('.')+1,file.name.length).toLowerCase() == 'xslt'))
            {
                alert("<cf_get_lang dictionary_id='30519.İlgili dosya xslt olmalıdır'>!");
                return false;
            }

            if(list_find('3',document.getElementById('einvoice_type').value))
            {
                if(document.getElementById('einvoice_company_code').value == "")
                {
                    alert ("<cf_get_lang dictionary_id='47568.Şirket Kodu'> !");
                    return false;
                }

                if(document.getElementById('einvoice_user_name').value == "")
                {
                    alert ("<cf_get_lang dictionary_id='45139.Lütfen Kullanıcı Adı Giriniz!'> !");
                    return false;
                }

                if(document.getElementById('einvoice_password').value == "")
                {
                    alert ("<cf_get_lang dictionary_id='49039.Şifre Giriniz'> !");
                    return false;
                }
            }
            else if(document.getElementById('einvoice_type').value ==1)
            {
                if(document.getElementById('einvoice_signature_url').value == "")
                {
                    alert ("<cf_get_lang dictionary_id='30515.İmza Adresi Giriniz'> !");
                    return false;
                }
            }

            if(document.getElementById('einvoice_prefix').value.length != 3)
            {
                alert('<cf_get_lang dictionary_id='59943.E-Fatura Ön Eki 3 Karakter Olmalıdır'> !');
                document.getElementById('einvoice_prefix').focus();
                return false;
            }

            if(document.getElementById('einvoice_number').value.length !=9)
            {
                alert('<cf_get_lang dictionary_id='30511.Fatura Numarası 9 Karakter Olmalıdır'> !');
                document.getElementById('einvoice_number').focus();
                return false;
            }
        }

        function show_hide_einvoice(sel_value)
        {
            if(sel_value == 3)
            {
                document.getElementById('label_einvoice_signature_url').style.display = 'none';
                document.getElementById('label_einvoice_test_system').style.display = '';
				document.getElementById('label_einvoice_company_code').style.display = '';
				document.getElementById('label_einvoice_user_name').style.display = '';
				document.getElementById('label_einvoice_password').style.display = '';
				document.getElementById('label_einvoice_number').style.display = '';
				document.getElementById('label_einvoice_sender_alias').style.display = 'none';
				document.getElementById('label_einvoice_receiver_alias').style.display = 'none';			
            }
            else
            {
                document.getElementById('label_einvoice_signature_url').style.display = 'none';	
                document.getElementById('label_einvoice_test_system').style.display = 'none';
                document.getElementById('label_einvoice_company_code').style.display = 'none';
                document.getElementById('label_einvoice_user_name').style.display = 'none';
                document.getElementById('label_einvoice_password').style.display = 'none';
                document.getElementById('label_einvoice_number').style.display = 'none';
                document.getElementById('label_einvoice_sender_alias').style.display = 'none';
                document.getElementById('label_einvoice_receiver_alias').style.display = 'none';			
            }
        }

		row_count = <cfoutput>#template_count#</cfoutput>;
		control_row_count = <cfoutput>#template_count#</cfoutput>;
		document.getElementById('record_num').value = row_count;

		function add_row()
		{
			row_count++;
			control_row_count++;
			var newRow;
			var newCell;
		
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		

			document.getElementById('record_num').value=row_count;

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="row_control' + row_count +'" id="row_control' + row_count +'" value="1" /><input type="hidden" name="template_id' + row_count +'" id="template_id' + row_count +'" value="" /><a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif"></a>';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<div class="input-group"><input type="hidden" name="member_type' + row_count +'" id="member_type' + row_count +'" value=""><input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value="" /><input type="hidden" name="consumer_id' + row_count +'" id="consumer_id' + row_count +'" value="" /><input type="text" name="ch_company' + row_count +'" id="ch_company' + row_count +'" style="width:200px;" value="" autocomplete="off"><span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen(\'?fuseaction=objects.popup_list_pars&field_name=member_templates.ch_company' + row_count +'&is_cari_action=1&field_type=member_templates.member_type' + row_count +'&field_comp_name=member_templates.ch_company' + row_count +'&field_consumer=member_templates.consumer_id' + row_count +'&field_comp_id=member_templates.company_id' + row_count +'&select_list=2,3\',\'list\');" title="<cfoutput>#getLang('main','',57785,'Üye Seçmelisiniz')#</cfoutput>"></span></div>';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="file" id="template' + row_count +'" name="template' + row_count +'" accept=".xslt" />';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '';
		}

		function sil(sy)
		{
			var my_element=document.getElementById("row_control"+sy);
			my_element.value=0;

			var my_element=document.getElementById("frm_row"+sy);
			my_element.style.display="none";
			control_row_count--;
		}

		function template_control()
		{
			static_row=0;
			if(row_count<=0)
			{
				alert("<cf_get_lang dictionary_id='53611.Satır eklemediniz'>!");
				return false;
			}
			else
			{
				for(r=1;r<=row_count;r++)		
				{
					my_element=eval(document.getElementById("row_control"+r));
					if(my_element.value == 1)			
					{
						static_row++;
						ref_member_type	= $('#member_type'+r);
						ref_template 	= $('#template'+r);

						if(ref_member_type.val()=="")
						{
							alert(static_row+". Satır İçin Üye Seçiniz");
							return false;
						}

						if(ref_template.val()=="")
						{
							alert(static_row+". Satır İçin Şablon Seçiniz");
							return false;
						}
						else
						{
							var obj = ref_template;
							var file = obj[0].files[0];
							if(file.size == 0)
							{
								alert(static_row+". Satır <cf_get_lang dictionary_id='30521.Dosya İçeriğini Kontrol Ediniz'>");
								return false;
							}

							if ((obj.val() != "") && !(file.name.substring(file.name.indexOf('.')+1,file.name.length).toLowerCase() == 'xslt'))
							{
								alert(static_row+". Satır <cf_get_lang dictionary_id='30519.İlgili dosya xslt olmalıdır'>!");
								return false;
							}
						}
					}
				}
			}
			return true;
		}
    </script>
<cfelse>
	<cf_get_lang dictionary_id='62639.Şirketin entegrasyon tanımlamaları eksik!'>
</cfif>
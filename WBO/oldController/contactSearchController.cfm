<cf_get_lang_set module_name="call">
<cf_xml_page_edit fuseact="call.list_callcenter">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.name" default="">
<cfparam name="attributes.member_status" default="1">
<cfparam name="attributes.partner_status" default="1">
<cfparam name="attributes.card_no" default="">
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID,CITY_NAME FROM SETUP_CITY
</cfquery>
<cfquery name="GET_MEMBER_DIRECT_DENIED" datasource="#DSN#">
	SELECT ISNULL(MEMBER_DIRECT_DENIED,0) AS MEMBER_DIRECT_DENIED FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>

<script type="text/javascript">
	<cfif isDefined("form_submitted") and isdefined("is_report")>
		nextPreviousPage(1);//Ozel rapordan linke tıklandığında listelenmesi için eklendi. kaldirmayin hgul.20120424
	</cfif>
	var _city_= document.getElementById("city_id").value;	
	<cfif isdefined('attributes.county_id') and not len(attributes.county_id)>
		if(_city_.length)
			LoadCounty(_city_,'county_id')
	</cfif>
	<cfif isdefined("is_company")>
		var is_company = '<cfoutput>#is_company#</cfoutput>';
	<cfelse>
		var is_company = 0;
	</cfif>
	function bireysel()
	{
		window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=member.form_add_consumer&consumer_name=' + document.getElementById("name").value + '&consumer_surname=' + document.getElementById("surname").value + '&home_telcode=' + document.getElementById("telcode").value + '&home_tel=' + document.getElementById("tel").value + '&mobilcat_id=' + document.getElementById("mobilcat_id").value + '&mobiltel=' + document.getElementById("mobiltel").value + '&work_faxcode=' + document.getElementById("faxcode").value + '&work_fax=' + document.getElementById("fax").value + '&consumer_email=' + document.getElementById("email").value + '&tax_no=' + document.getElementById("tax_no").value + '&home_city=' + document.getElementById("city_id").value + '&home_county=' + document.getElementById("county_id").value + '&home_city_id=' + document.getElementById("city_id").value + '&home_county_id=' + document.getElementById("county_id").value + '&home_semt=' + document.getElementById("semt").value + '&home_postcode=' + document.getElementById("post_code").value + '&home_address=' + document.getElementById("address").value + '&consumer_code=' + document.getElementById("uye_no").value+ '&ozel_kod=' + document.getElementById("ozel_kod").value+'&tc_identy_no=' + document.getElementById("tc_identity").value+'&city_id=' + document.getElementById("city_id").value+'&county_id=' + document.getElementById("county_id").value;
	}
	
	function kurumsal()
	{
		window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=member.form_add_company&name=' + document.getElementById("name").value + '&soyad=' + document.getElementById("surname").value + '&telcod=' + document.getElementById("telcode").value + '&tel1=' + document.getElementById("tel").value + '&mobiltel=' + document.getElementById("mobiltel").value + '&fax=' + document.getElementById("fax").value + '&email=' + document.getElementById("email").value + '&vno=' + document.getElementById("tax_no").value +'&semt=' + document.getElementById("semt").value + '&postcod=' + document.getElementById("post_code").value + '&adres=' + document.getElementById("address").value + '&fullname=' + document.getElementById("firm").value + '&nickname=' + document.getElementById("firm").value+ '&company_code=' + document.getElementById("uye_no").value+ '&mobilcat_id=' + document.getElementById("mobilcat_id").value+'&city_id=' + document.getElementById("city_id").value+'&county_id=' + document.getElementById("county_id").value+'&ozel_kod=' + document.getElementById("ozel_kod").value;
	}	
	
	function control()
	{
		if(document.getElementById("maxrows").value == '')
		{
			alert("<cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'>");
			return false;
		}

		<cfif isdefined("xml_customer_card_filter") and xml_customer_card_filter eq 1>
			var card_no_ = document.getElementById("card_no").value;
		<cfelse>
			var card_no_ = 0;
		</cfif>

		if(is_company == 1)
		{
			if(document.getElementById("firm").value == "" && document.getElementById("email").value == "" && document.getElementById("name").value == "" && document.getElementById("surname").value == "" && document.getElementById("tel").value == ""  && document.getElementById("tc_identity").value == ""  && document.getElementById("post_code").value == "" && document.getElementById("city_id").value == "" && document.getElementById("county_id").value == "" && document.getElementById("mobiltel").value == "" && document.getElementById("semt").value == "" && document.getElementById("uye_no").value == "" && document.getElementById("ozel_kod").value == "" && document.getElementById("address").value == "" && document.getElementById("tax_no").value == ""  && document.getElementById("fax").value == "" && card_no_ == "")
			{
				alert("<cf_get_lang_main no='114.En Az Bir Alanda Filtre Ediniz'>");
				return false;
			}
		}
		else
		{
			if(document.getElementById("name").value == "" && document.getElementById("email").value == "" && document.getElementById("surname").value == "" && document.getElementById("tel").value == ""  && document.getElementById("tc_identity").value == ""  && document.getElementById("post_code").value == "" && document.getElementById("city_id").value == "" && document.getElementById("county_id").value == "" && document.getElementById("mobiltel").value == "" && document.getElementById("semt").value == "" && document.getElementById("uye_no").value == "" && document.getElementById("ozel_kod").value == "" && document.getElementById("address").value == "" && document.getElementById("tax_no").value == ""  && document.getElementById("fax").value == "" && card_no_ == "")
			{
				alert("<cf_get_lang_main no='114.En Az Bir Alanda Filtre Ediniz'>");
				return false;
			}
		}

		var numberformat = "1234567890";
		for (var i = 1; i < document.getElementById("tel").value.length; i++)
		{
			check_tel_code_number = numberformat.indexOf(document.getElementById("tel").value.charAt(i));
			if (check_tel_code_number < 0)
			{
				alert("<cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='783.Tam Sayı'> <cf_get_lang no='53.Tel No'> !");
				document.getElementById("tel").focus();
				return false;
			}
		}
		for (var i = 1; i < document.getElementById("mobiltel").value.length; i++)
		{
			check_mobiltel = numberformat.indexOf(document.getElementById("mobiltel").value.charAt(i));
			if (check_mobiltel < 0)
			{
				alert("<cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='783.Tam Sayı'> <cf_get_lang no='53.Tel No'> !");
				document.getElementById("mobiltel").focus();
				return false;
			}
		}

		for (var i = 1; i < document.getElementById("fax").value.length; i++)
		{
			check_fax = numberformat.indexOf(document.getElementById("fax").value.charAt(i));
			if (check_fax < 0)
			{
				alert("<cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='783.Tam Sayı'> <cf_get_lang no='53.Tel No'> !");
				document.getElementById("fax").focus();
				return false;
			}
		}
		for (var i = 1; i < document.getElementById("tc_identity").value.length; i++)
		{
			check_tc_identity = numberformat.indexOf(document.getElementById("tc_identity").value.charAt(i));
			if (check_tc_identity < 0)
			{
				alert("<cf_get_lang_main no ='1334.Üye No Sayısal Olmalıdır'> !");
				document.getElementById("tc_identity").focus();
				return false;
			}
		}

		for (var i = 1; i < document.getElementById("tax_no").value.length; i++)
		{
			check_tax_no = numberformat.indexOf(document.getElementById("tax_no").value.charAt(i));
			if (check_tax_no < 0)
			{
				alert("<cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='783.Tam Sayı'> <cf_get_lang_main no='340.vergi No'> !");
				document.getElementById("tax_no").focus();
				return false;
			}
		}
		if(document.getElementById("telcode").value != "")
		{
			for (var i = 1; i < document.getElementById("telcode").value.length; i++)
			{
				check_telcode = numberformat.indexOf(document.getElementById("telcode").value.charAt(i));
				if (check_telcode < 0)
				{
					alert("<cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='783.Tam Sayı'> <cf_get_lang no='53.Tel No'> !");
					document.getElementById("telcode").focus();
					return false;
				}
			}
		}

		for (var i = 1; i < document.getElementById("post_code").value.length; i++)
		{
			check_post_code = numberformat.indexOf(document.getElementById("post_code").value.charAt(i));
			if (check_post_code < 0)
			{
				alert("<cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='783.Tam Sayı'> <cf_get_lang_main no='60.posta kodu'> !");
				document.getElementById("post_code").focus();
				return false;
			}
		}


		//pozisyon detayındaki yetki kısmı...
		<cfif get_member_direct_denied.member_direct_denied eq 1>
			var confirm_count = 0;
			if(document.getElementById('tc_identity').value != "") confirm_count++;
			if(document.getElementById('uye_no').value != "") confirm_count++;
			if(document.getElementById('mobilcat_id').value != "" && document.getElementById('mobiltel').value != "") confirm_count++;
			if(document.getElementById('telcode').value != "" && document.getElementById('tel').value != "") confirm_count++;
			if(confirm_count<2){
				alert('<cf_get_lang_main no="613.tc kimlik no">,<cf_get_lang_main no="146.Üye No">,<cf_get_lang no="82.Tel"><cf_get_lang no="81.Cep Tel"> En Az 2 Tanesinin Dolu Olması Gereklidir!');
				return false;
			}
		</cfif>
		var form_str = GetFormData(get_part);
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=call.popup_ajax_get_members#xml_str#</cfoutput>&'+form_str+'','members_result_detail_div',1);
		return false;
		
	}
	function nextPreviousPage(page)
	{
		var form_str = GetFormData(get_part);
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=call.popup_ajax_get_members#xml_str#</cfoutput>&page='+page+'&'+form_str+'','members_result_detail_div',1);
		return false;
	}
	
	function type_(company_id,partner_id,type)
	{	
		window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_company_details&cpid=' + company_id+'&partner_id=' + partner_id;
	}	
	function type__(consumer_id,type)
	{
		window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_consumer_details&cid=' + consumer_id;
	}
	<cfif is_company eq 1>
		document.getElementById("firm").focus();
	<cfelse>
		document.getElementById("name").focus();
	</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'call.list_callcenter';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'callcenter/display/list_callcenter.cfm';
	
</cfscript>

<cf_get_lang_set module = "assetcare">
<cfif not isdefined("attributes.event") or attributes.event is 'list'>
	<cf_xml_page_edit fuseact="assetcare.list_assetp">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.assetp_catid" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.branch" default="">
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.department" default="">
    <cfparam name="attributes.emp_id" default="">
    <cfparam name="attributes.employee_name" default="">
    <cfparam name="attributes.is_active" default="">
    <cfparam name="attributes.is_collective_usage" default="">
    <cfparam name="attributes.brand_type_id" default="">
    <cfparam name="attributes.brand_name" default="">
    <cfparam name="attributes.make_year" default="">
    <cfparam name="attributes.property" default="">
    <cfparam name="attributes.position2" default="">
    <cfparam name="attributes.position_code2" default="">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.assetp_status" default="">
    <cfparam name="attributes.order_type" default="1">
    <cfparam name="attributes.assetp_sub_catid" default="">
    <cfparam name="attributes.inventory_no" default="">
    <cfset colspan = 11>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif isdefined("attributes.form_submitted")>
        <cfinclude template="../assetcare/query/get_assetps1.cfm">
        <cfparam name="attributes.totalrecords" default='#get_assetps.query_count#'>
    <cfelse>
        <cfset GET_ASSETPS.recordcount = 0>
        <cfparam name="attributes.totalrecords" default='0'>
    </cfif>
    <cfquery name="GET_BRANCH" datasource="#DSN#">
        SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cf_xml_page_edit fuseact="assetcare.form_add_assetp">
    <cf_papers paper_type="FIXTURES">
    <cfif len(paper_number)>
        <cfset fixtures_no = paper_code & '-' & paper_number>
    <cfelse>
        <cfset fixtures_no = ''>
    </cfif>
    <cfinclude template="../assetcare/query/get_assetp_groups.cfm">
    <cfinclude template="../assetcare/query/get_money.cfm">
    <cfquery name="GET_PURPOSE" datasource="#DSN#">
        SELECT USAGE_PURPOSE_ID, USAGE_PURPOSE FROM SETUP_USAGE_PURPOSE ORDER BY USAGE_PURPOSE
    </cfquery>
    <cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
        SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT  WHERE MOTORIZED_VEHICLE = 0 AND IT_ASSET = 0 ORDER BY ASSETP_CAT
    </cfquery>
    <cfif isdefined('attributes.assetp_id')>
        <cfinclude template="../assetcare/query/get_assetp.cfm">
		<cfif len(get_assetp.department_id)>
            <cfquery name="GET_BRANCHS_DEPS" datasource="#DSN#">
                SELECT
                    DEPARTMENT.DEPARTMENT_HEAD,
                    BRANCH.BRANCH_NAME
                FROM
                    BRANCH,
                    DEPARTMENT
                WHERE
                    DEPARTMENT.DEPARTMENT_ID = #get_assetp.department_id# AND
                    BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
            </cfquery>
            <cfif len(get_assetp.department_id2)>
                <cfquery name="GET_BRANCHS_DEPS2" datasource="#DSN#">
                    SELECT
                        DEPARTMENT.DEPARTMENT_HEAD,
                        BRANCH.BRANCH_NAME
                    FROM 
                        BRANCH,
                        DEPARTMENT
                    WHERE
                        DEPARTMENT.DEPARTMENT_ID = #get_assetp.department_id2# AND
                        BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
                </cfquery>
            </cfif>
            <cfquery name="GET_PARTNER" datasource="#DSN#">
                <cfif len(get_assetp.sup_partner_id)>
                    SELECT
                        CP.PARTNER_ID,
                        CP.COMPANY_PARTNER_NAME,
                        CP.COMPANY_PARTNER_SURNAME,
                        C.COMPANY_ID, 
                        C.NICKNAME,
                        C.FULLNAME
                    FROM
                        COMPANY_PARTNER CP,
                        COMPANY C
                    WHERE
                        CP.PARTNER_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.sup_partner_id#"> AND
                        CP.COMPANY_ID = C.COMPANY_ID
                <cfelseif len(get_assetp.sup_consumer_id)>
                    SELECT
                        CONSUMER_NAME +' '+ CONSUMER_SURNAME AS FULLNAME,
                        COMPANY,
                        CONSUMER_ID
                    FROM
                        CONSUMER
                    WHERE
                        CONSUMER_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.sup_consumer_id#"> 
                </cfif>
            </cfquery>
        </cfif>
    </cfif>
    <cfif isdefined("attributes.assetp_id")>
		<cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
        <cfif isdefined('attributes.assetp_id')>
            <cfset model_yili = get_assetp.make_year>
        </cfif>
        <cfif len(get_assetp.relation_physical_asset_id)>
        <cfquery name="GET_ASSET_NAME" datasource="#DSN#">
            SELECT ASSETP_ID, ASSETP FROM ASSET_P WHERE	ASSETP_ID = #get_assetp.relation_physical_asset_id#
        </cfquery>
            <cfset relation_phy_asset_id = GET_ASSET_NAME.ASSETP_ID>
            <cfset relation_phy_asset = GET_ASSET_NAME.ASSETP>
        <cfelse>
            <cfset relation_phy_asset_id = ''>
            <cfset relation_phy_asset = ''>
        </cfif>
	<cfelse>
		<cfif isdefined("attributes.relation_assetp_id")>
            <cfquery name="GET_ASSET_NAME" datasource="#DSN#">
                 SELECT ASSETP_ID, ASSETP FROM ASSET_P WHERE ASSETP_ID = #attributes.relation_assetp_id#
            </cfquery>
            <cfset relation_phy_asset_id = GET_ASSET_NAME.ASSETP_ID>
            <cfset relation_phy_asset = GET_ASSET_NAME.ASSETP>
        <cfelse>
            <cfset relation_phy_asset_id = ''>
            <cfset relation_phy_asset = ''>
        </cfif>
        <cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
        <cfif isdefined('attributes.assetp_id')>
            <cfset model_yili = get_assetp.make_year>
        </cfif>
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfsetting showdebugoutput="yes">
    <cf_xml_page_edit fuseact="assetcare.form_add_assetp">
    <cf_papers paper_type="FIXTURES">
    <cfif not isnumeric(attributes.assetp_id)>
        <cfset hata  = 10>
        <cfinclude template="../dsp_hata.cfm">
    </cfif>
    <cfinclude template="../assetcare/query/get_assetp.cfm">
    <cfif (not get_assetp.recordcount)>
        <cfset hata  = 10>
        <cfinclude template="../dsp_hata.cfm">
        <cfabort>
    </cfif>
        <cfinclude template="../assetcare/query/get_assetp_groups.cfm">
        <cfinclude template="../assetcare/query/get_purpose.cfm">
    <cfinclude template="../assetcare/query/get_money.cfm">	
    <cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
        SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT  WHERE MOTORIZED_VEHICLE = 0 AND IT_ASSET = 0 ORDER BY ASSETP_CAT
    </cfquery>
    <cfquery name="GET_ASSETP_IT" datasource="#DSN#">
        SELECT ASSETP_ID FROM ASSET_P_IT WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
    </cfquery>
    <cfquery name="KONTROL_" datasource="#DSN#">
        SELECT ASSET_ID FROM CARE_STATES WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
    </cfquery>
    <cfif len(get_assetp.department_id)>
        <cfquery name="GET_BRANCHS_DEPS" datasource="#DSN#">
            SELECT
                DEPARTMENT.DEPARTMENT_HEAD,
                BRANCH.BRANCH_NAME
            FROM
                BRANCH,
                DEPARTMENT
            WHERE
                DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.department_id#"> AND
                BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
        </cfquery>
    </cfif>
    <cfif len(get_assetp.department_id2)>
        <cfquery name="GET_BRANCHS_DEPS2" datasource="#DSN#">
            SELECT
                DEPARTMENT.DEPARTMENT_HEAD,
                BRANCH.BRANCH_NAME
            FROM 
                BRANCH,
                DEPARTMENT
            WHERE
                DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.department_id2#"> AND
                BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
        </cfquery>
    </cfif>
    <cfquery name="GET_PARTNER" datasource="#DSN#">
		<cfif len(get_assetp.sup_partner_id)>
            SELECT
                CP.PARTNER_ID,
                CP.COMPANY_PARTNER_NAME,
                CP.COMPANY_PARTNER_SURNAME,
                C.COMPANY_ID, 
                C.NICKNAME,
                C.FULLNAME
            FROM
                COMPANY_PARTNER CP,
                COMPANY C
            WHERE
                CP.PARTNER_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.sup_partner_id#"> AND
                CP.COMPANY_ID = C.COMPANY_ID
        <cfelseif len(get_assetp.sup_consumer_id)>
            SELECT
                CONSUMER_NAME +' '+ CONSUMER_SURNAME AS FULLNAME,
                COMPANY,
                CONSUMER_ID
            FROM
                CONSUMER
            WHERE
                CONSUMER_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.sup_consumer_id#"> 
        </cfif>
    </cfquery>
   
    <cfif len(get_assetp.ASSETP_SUB_CATID)>
        <cfquery name="GET_SUB_CAT" datasource="#dsn#">
            SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = #get_assetp.assetp_catid# ORDER BY ASSETP_SUB_CAT
        </cfquery>
    </cfif>
    <cfif len(get_assetp.relation_physical_asset_id)>
        <cfquery name="GET_ASSET_NAME" datasource="#DSN#">
            SELECT ASSETP_ID, ASSETP FROM ASSET_P WHERE	ASSETP_ID = #get_assetp.relation_physical_asset_id#
        </cfquery>
        <cfset relation_phy_asset_id = GET_ASSET_NAME.ASSETP_ID>
        <cfset relation_phy_asset = GET_ASSET_NAME.ASSETP>
    <cfelse>
        <cfset relation_phy_asset_id = ''>
        <cfset relation_phy_asset = ''>
    </cfif>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.event") or attributes.event is 'list'>
		$(document).ready(function(){
			$('#keyword').focus();
			});
		function kontrol()
		{
			if($('#branch').val() == "")
			   $('#branch_id').val()=="";
			
			if($('#employee_name').val() == "")
			   $('#emp_id').val()=="";
			
			if($('#department').val() == "")
			   $('#department_id').val()=="";
			
			if($('#brand_name').val() == "")
			   $('#brand_type_id').val()=="";
			return true;		
		}
		function get_assetp_sub_cat()
		{
			for ( var i= $("#assetp_sub_catid option").length-1 ; i>-1 ; i--)
				{
						$('#assetp_sub_catid option').eq(i).remove();
				}
				url_= '/V16/assetcare/cfc/assetp.cfc?method=GET_ASSETP_SUB_CAT&assetp_catid='+ $("#assetp_catid").val();
				$.ajax({
						url: url_,
						method : 'GET', 
						dataType: "text",
						cache:false,
						async: false,
						success: function( res ) { 
						if (res) { 
							data = $.parseJSON( res ); 
							if(data.DATA.length != 0)
							{
								$.each(data.DATA, function( key, value ) {   
										
									var arg1 = 	value[0] ; //ASSETP_SUB_CATID
									var arg2 = 	value[1] ;//ASSETP_SUB_CAT
									$("#assetp_sub_catid").append("<option value='"+arg1+"'>"+arg2+"</option>");
									
								});
							}
								
						}
					}
				});
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		function kontrol()
		{	
			<cfif x_control_fixtures_no eq 1>
			if( document.getElementById('fixtures_no').value != '')
				if(!paper_control(document.getElementById('fixtures_no'),'FIXTURES',true,'','','','','','<cfoutput>#dsn#</cfoutput>')) return false;
			</cfif>
			if ($('#assetp').val() == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1655.Varlık'> <cf_get_lang_main no='485.adı'> !");
				return false;
			}
			
			if($('#sup_comp_name').val() =="" && $('#sup_partner_name').val() =="" )
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='21.Alınan Şirket'> !");
				return false;
			}
			
			if ($('#assetp_catid option')[$("#assetp_catid").prop('selectedIndex')].value == "")
			{ 
				alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='517.Varlık Tipi'> !");
				return false;
			}
					
			if($('#department').val()=="")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='144.Kayıtlı Departman '> !");
				return false;
			}
			if($('#employee_name').val() == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='132.Sorumlu !'>");
				return false;
			}
			
			if($('#start_date').val() == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='22.Alım Tarihi !'>!");
				return false;
			}		
			
			if(!CheckEurodate(document.getElementById('start_date').value,"<cf_get_lang no='22.Alış tarihi'>"))
			{
				return false;
			}
			
			if(!date_check(document.getElementById('start_date'),document.getElementById('date_now'),"<cf_get_lang no='552.Alış Tarihini Kontrol Ediniz'>!"))
			{
				return false;
			}
			if((250 - document.getElementById('assetp_detail').value.length) < 0)
			{ 
				alert ("<cf_get_lang_main no='217.Açıklama'> "+ ((-1) * (250 - document.getElementById('assetp_detail').value.length)) +" <cf_get_lang_main no='1741.Karakter Uzun'>");
				return false;
			}
			
			if($('#property_2').is(':checked') == true)
			{			
				$('#rent_amount').val(filterNum($('#rent_amount').val()));
			}
			
			if($('#property_4').is(':checked') == true)
			{			
				$('#rent_amount').val(filterNum($('#rent_amount').val()));
				$('#fuel_amount').val(filterNum($('#fuel_amount').val()));
				$('#care_amount').val(filterNum($('#care_amount').val()));				
			}
			$('#assetp_other_money_value').val(filterNum($('#assetp_other_money_value').val()));	
			if(process_cat_control())
				if(confirm("<cf_get_lang_main no='2117.Girdiğiniz bilgileri kaydetmek üzeresiniz lütfen değişiklikleri onaylayın'>!")) return true; else return false;
			else
				return false;
		}
		function add_department()
		{
			if($('#department_id2').val() == "" && $('#department2').val() == "")
			{
				id_ = $('#department_id').val();
				text_ = $('#department').val();
				$('#department_id2').val(id_);
				$('#department2').val(text_);
			}
		} 
		function change_depot()
		{
			$('#department_id2').val() =$('#department_id').val();
			$('#department2').val() = $('#department').val();
		}
		function show_hide()
		{
			if($('#property_1').is(':checked'))
			{
				gizle(outsource);
				gizle(rent);
				$('#care_amount').val("");
				$('#fuel_amount').val("");
				$('#rent_amount').val("");
				$('#rent_start_date').val("");
				$('#rent_finish_date').val("");
				$('#is_care_added_1').is(':checked')==true;
				$('#is_fuel_added').is(':checked')==true;
				$('#rent_payment_period')[0].selected = true;
			}
			
			if($('#property_2').is(':checked'))
			{
				gizle(outsource);
				goster(rent);
				$('#care_amount').val("");
				$('#fuel_amount').val("");
				
			}
			
			if($('#property_3').is(':checked'))
			{
				gizle(outsource);
				gizle(rent);
				$('#care_amount').val("");
		
				$('#fuel_amount').val("");
				$('#rent_amount').val("");
				$('#rent_start_date').val("");
				$('#rent_finish_date').val("");
				$('#is_care_added_1').is(':checked')==true;
				$('#is_fuel_added').is(':checked')==true;
				$('#rent_payment_period')[0].selected = true;
			}
			
			if($('#property_4').is(':checked'))
			{
				goster(outsource);
				goster(rent);
			}
			
			if($('#is_care_added_1').is(':checked'))
			{
				gizle(care);
				$('#care_amount').val("");
				$("#care_amount_currency").prop('selectedIndex')= "";
			}
			
			if($('#is_care_added_2').is(':checked'))
			{
				gizle(care);
				$('#care_amount').val("");
				$("#care_amount_currency").prop('selectedIndex')= "";
			}
			
			if($('#is_care_added_3').is(':checked'))
			{
				goster(care);
			}
			
			if($('#is_fuel_added_1').is(':checked'))
			{
				gizle(fuel);
				$('#fuel_amount').val("");
				$("#fuel_amount_currency").prop('selectedIndex')= "";
				
			}
			
			if($('#is_fuel_added_2').is(':checked'))
			{
				gizle(fuel);
				$('#fuel_amount').val("");
				$("#fuel_amount_currency").prop('selectedIndex')= "";
			}
			
			if($('#is_fuel_added_3').is(':checked'))
			{
				goster(fuel);
			}
			
			/*if($('#is_care_added_3').is(':checked') || $('#is_fuel_added_3').is(':checked'))
				goster(limit);
			else
				gizle(limit);*/
		}
		function get_assetp_sub_cat()
		{
			for ( var i= $("#assetp_sub_catid option").length-1 ; i>-1 ; i--)
				{
						$('#assetp_sub_catid option').eq(i).remove();
				}
				url_= '/V16/assetcare/cfc/assetp.cfc?method=GET_ASSETP_SUB_CAT&assetp_catid='+ $("#assetp_catid").val();
				$.ajax({
						url: url_,
						method : 'GET', 
						dataType: "text",
						cache:false,
						async: false,
						success: function( res ) { 
						if (res) { 
							data = $.parseJSON( res ); 
							if(data.DATA.length != 0)
							{
								$.each(data.DATA, function( key, value ) {   
										
									var arg1 = 	value[0] ; //ASSETP_SUB_CATID
									var arg2 = 	value[1] ;//ASSETP_SUB_CAT
									$("#assetp_sub_catid").append("<option value='"+arg1+"'>"+arg2+"</option>");
									
								});
							}
								
						}
					}
				});			
		}
		function fill_department()
		{	
			<cfif x_fill_department eq 1>
			
					$('#department_id').val("");
					$('#department_id2').val("");
					$('#department').val("");
					$('#department2').val("");
					var member_id=$('#emp_id').val();
					if(member_id!='')
					{
						url_= '/V16/assetcare/cfc/assetp.cfc?method=FILL_DEPARTMENTS&member_id='+ member_id;
						$.ajax({
								url: url_,
								method : 'GET', 
								dataType: "text",
								cache:false,
								async: false,
								success: function( res ) { 
								if (res) { 
									data = $.parseJSON( res ); 
									if(data.DATA.length != 0)
									{
										$.each(data.DATA, function( key, value ) {   
												
											var arg1 = 	value[0] ; //DEPARTMENT_ID
											var arg2 = 	value[1] ; //DEPARTMENT_HEAD
											var arg3 = 	value[2] ; //BRANCH_NAME
											$('#department_id').val(arg1);
											$('#department_id2').val(arg1);
											$('#department').val(arg2 +'-'+arg3);
											$('#department2').val(arg2 +'-'+arg3);
											
										});
									}
										
								}
							}
						});
					}
			
			</cfif>
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		function kontrol()
		{
			<cfif x_control_fixtures_no eq 1>
				if(document.getElementById('fixtures_no').value != '')
					if(!paper_control(document.getElementById('fixtures_no'),'1',<cfoutput>'#get_assetp.assetp_id#','#get_assetp.inventory_number#','','','','#dsn#</cfoutput>')) return false;
			</cfif>
			if($('#property_1').is(':checked')==false && $('#property_2').is(':checked')==false && $('#property_3').is(':checked')==false && $('#property_4').is(':checked')==false)
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='192.Mülkiyet Tipi'>");
				return false;
			}
			if ($('#assetp').val()== "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1655.Varlık'> <cf_get_lang_main no='485.adı'> !");
				return false;
			}
			if($('#sup_comp_name').val()== "" && $('#sup_partner_name').val()== "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='21.Alınan Şirket'> !");
				return false;
			}
			if ($('#assetp_catid option')[$("#assetp_catid").prop('selectedIndex')].value == "")
			{ 
				alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='517.Varlık Tipi'> !");
				return false;
			}
			if($('#get_date').val() == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='22.Alım Tarihi !'>!");
				return false;
			}		
			if((250 - document.getElementById('assetp_detail').value.length) < 0)
			{ 
				alert ("<cf_get_lang_main no='217.Açıklama'> "+ ((-1) * (250 - document.getElementById('assetp_detail').value.length)) +" <cf_get_lang_main no='1741.Karakter Uzun'>");
				return false;
			}
			if($('#get_date').val() != "")
			{
				if(!date_check(document.getElementById('get_date'),document.getElementById('date_now'),"<cf_get_lang no='552.Alış Tarihini Kontrol Ediniz'>!"))
				{
					return false;
				}
			}	
			
			if($('#status').prop('checked') == true)
			{
				if($('#department').val() == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='144.Kayıtlı Departman '> !");
					return false;
				}
				if($('#employee_name').val() == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='132.Sorumlu !'>");
					return false;
				}
				if($('#assetp_status option')[$("#assetp_status").prop('selectedIndex')].value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='344.Durum '>!");
					return false;
				}
			}
			for(var i=1;i<=4;i++)
			{
				if($('#property_'+i).is(':checked')==true)
					if($('#property_'+i).val() != $('#old_property').val() )
					{
						if(confirm("<cf_get_lang no='633.Mülkiyet Alanındaki Değişiklik Araçtaki Belli Bilgileri Silecektir,Emin Misiniz?'>"));
						else return false;
					}
			}	
			<!---<cfif x_transfer_date_required eq 1>
				new_department_id = $('#department_id').val();
				new_position_code = $('#position_code').val();
				if(($('#old_position_code') != undefined && new_position_code != $('#old_position_code').val()) || ($('#old_department_id') != undefined && new_department_id != $('#old_department_id').val()))
				{
					if($('#transfer_date').val() == ""||($('#transfer_date').val() == $('#old_transfer_date').val()))
					{
						alert("Kayıtlı Departman ya da Sorumlu Bilgilerinde Değişiklik Yaptınız.Lütfen Transfer Tarihini Giriniz");
						$('#transfer_date').val('');
						$('#old_transfer_date').val('');
						return false;
					}
				}
			</cfif>	--->
			$('#assetp_other_money_value').val( filterNum($('#assetp_other_money_value').val()) );	
			if(process_cat_control())
				if(confirm("<cf_get_lang_main no='2117.Girdiğiniz bilgileri kaydetmek üzeresiniz lütfen değişiklikleri onaylayın'>!")) return true; else return false;
			else
				return false;
	
	return true;
		}
		function add_department()
		{
			if($('#department_id2').val() == "" && $('#department2').val() == "")
			{
			$('#department_id2').val() =$('#department_id').val();
			$('#department2').val() = $('#department').val();
			}
		}
		function get_assetp_sub_cat()
		{
			for ( var i= $("#assetp_sub_catid option").length-1 ; i>-1 ; i--)
				{
						$('#assetp_sub_catid option').eq(i).remove();
				}
				
			url_= '/V16/assetcare/cfc/assetp.cfc?method=GET_ASSETP_SUB_CAT&assetp_catid='+ $("#assetp_catid").val();
			$.ajax({
					url: url_,
					method : 'GET', 
					dataType: "text",
					cache:false,
					async: false,
					success: function( res ) { 
					if (res) { 
						data = $.parseJSON( res ); 
						if(data.DATA.length != 0)
						{
							$.each(data.DATA, function( key, value ) {   
									
								var arg1 = 	value[0] ; //ASSETP_SUB_CATID
								var arg2 = 	value[1] ;//ASSETP_SUB_CAT
								$("#assetp_sub_catid").append("<option value='"+arg1+"'>"+arg2+"</option>");
								
							});
						}
							
					}
				}
			});
		}
			
		function fill_department()
		{	
			<cfif x_fill_department eq 1>
				$('#department_id').val("");
				$('#department_id2').val("");
				$('#department').val("");
				$('#department2').val("");
				var member_id=$('#position_code').val();
				if(member_id!='')
				{
					url_= '/V16/assetcare/cfc/assetp.cfc?method=FILL_DEPARTMENTS&member_id='+ member_id;
					$.ajax({
							url: url_,
							method : 'GET', 
							dataType: "text",
							cache:false,
							async: false,
							success: function( res ) { 
							if (res) { 
								data = $.parseJSON( res ); 
								if(data.DATA.length != 0)
								{
									$.each(data.DATA, function( key, value ) {   
											
										var arg1 = 	value[0] ; //DEPARTMENT_ID
										var arg2 = 	value[1] ; //DEPARTMENT_HEAD
										var arg3 = 	value[2] ; //BRANCH_NAME
										$('#department_id').val(arg1);
										$('#department_id2').val(arg1);
										$('#department').val(arg2 +'-'+arg3);
										$('#department2').val(arg2 +'-'+arg3);
										
									});
								}
									
							}
						}
					});
				}
			</cfif>
		}
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.form_add_assetp';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'assetcare/form/form_add_assetp.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'assetcare/query/add_assetp.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'assetcare.list_assetp&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.form_upd_assetp';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'assetcare/form/form_upd_assetp.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'assetcare/query/upd_assetp.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'assetcare.list_assetp&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'assetp_id=##attributes.assetp_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.assetp_id##';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.list_assetp';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'assetcare/display/list_assetp.cfm';
	
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-23" module_id="1" action_section="ASSETP_ID" action_id="#attributes.assetp_id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array_main.item[345]#';
        tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] ="windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=assetcare.list_assetp&event=upd&action_name=assetp_id&action_id=#attributes.assetp_id#','list')";
		
		if(len(get_assetp.inventory_id) and (get_module_user(31)))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array_main.item[1190]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] ="windowopen('#request.self#?fuseaction=invent.add_collacted_inventory&event=det&inventory_id=#get_assetp.inventory_id#','list')";
		}
		
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] =	"windowopen('#request.self#?fuseaction=assetcare.popup_asset_history&asset_id=#attributes.assetp_id#','wide')";
		
		if(get_assetp.property eq 2)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[740]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_upd_asset_contract1&asset_id=#attributes.assetp_id#&property=4','medium')";
		}
		else if(get_assetp.property eq 4)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[491]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_upd_asset_contract1&asset_id=#attributes.assetp_id#&property=2','medium')";
		}
	
		if(get_assetp.motorized_vehicle and not get_assetp.it_asset)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[114]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=logistic.popup_vehicle_ship_detail&assetp_id=#attributes.assetp_id#','list')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[131]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_list_kaza_detail&assetp_id=#attributes.assetp_id#','list')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[132]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_list_km_control_detail&assetp_id=#attributes.assetp_id#','list')";	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[133]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_list_punishment_detail&assetp_id=#attributes.assetp_id#','project')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[134]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_list_oil_detail&assetp_id=#attributes.assetp_id#','project')";
		}
		
		if(get_assetp.it_asset and not get_assetp.motorized_vehicle)
		{
			if(len(get_assetp_it.assetp_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[32]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_upd_it_asset&asset_id=#attributes.assetp_id#','medium')";	
			}
			else
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[32]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_add_it_asset&asset_id=#attributes.assetp_id#','medium')";
			}
		}
		
		if(get_assetp.assetp_reserve)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array_main.item[1160]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_asset_reserve_history&asset_id=#attributes.assetp_id#','medium')";	
		}
			
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[29]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_list_asset_care_nonperiod&asset_id=#attributes.assetp_id#','list')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])]['text'] = '#lang_array.item[6]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])-1]['onClick'] = "windowopen('#request.self#?fuseaction=assetcare.list_asset_care&event=add&window=popup&asset_id=#attributes.assetp_id#','list')";	
		
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=assetcare.list_assetp&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=assetcare.list_assetp&event=add&assetp_id=#attributes.assetp_id#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('index.cfm?fuseaction=objects.popup_print_files&iid=#attributes.assetp_id#&print_type=250','page','workcube_print')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'assetcareController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ASSET_P';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-property','item-assetp','item-sup_company_id','item-sup_partner_id','item-assetp_cat_id','item-department_id','item-position_code','item-start_date','item-assetp_status']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.

	
</cfscript>

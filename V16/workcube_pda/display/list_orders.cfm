<cfif isDefined('xml_list_type') and xml_list_type eq 0>
    <cf_get_lang_set module_name="sales">
    <cfparam name="attributes.start_date" default="">
    <cfif isdefined('attributes.cpid')>
        <cfparam name="attributes.finish_date" default="">
    <cfelse>
        <cfparam name="attributes.finish_date" default="#date_add('d',1,now())#">
    </cfif>
    <cfif isdefined('attributes.cpid')>
        <cfquery name="GET_COMP_INFO" datasource="#DSN#">
            SELECT 
                C.FULLNAME 
            FROM 
                COMPANY C,
                #dsn_alias#.WORKGROUP_EMP_PAR WEP 
            WHERE 
                C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#"> AND
                C.COMPANY_ID = WEP.COMPANY_ID AND
                WEP.IS_MASTER=1 
                <cfif session.pda.admin eq 0 and session.pda.power_user eq 0><!---  and session.pda.member_view_control --->
                    AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#"> 
                    AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#"> 		
                </cfif>
        </cfquery>	
    </cfif>
    <cfquery name="GET_EMPS" datasource="#DSN#">
        SELECT 
            EMPLOYEE_ID,
            EMPLOYEE_NAME,
            EMPLOYEE_SURNAME
        FROM 
            EMPLOYEE_POSITIONS 
        WHERE 
            POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#">        
        UNION
        SELECT 
            EMPLOYEE_ID,
            EMPLOYEE_NAME,
            EMPLOYEE_SURNAME
        FROM 
            EMPLOYEE_POSITIONS 
        WHERE 
            UPPER_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#"> 
        UNION 
        SELECT 
            EMPLOYEE_ID,
            EMPLOYEE_NAME,
            EMPLOYEE_SURNAME
        FROM 
            EMPLOYEE_POSITIONS 
        WHERE 
            UPPER_POSITION_CODE2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#">          
    </cfquery>
    <table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%">
        <tr style="height:35px;">
            <td class="headbold">Siparişlerim</td>
        </tr>
    </table>
    <cfform name="add_order" method="post" action="" enctype="multipart/form-data"> 
        <table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">	
            <tr>
                <td class="color-row">
                    <table align="center" style="width:99%">				 
                        <tr>
                            <td class="infotag" style="width:30%"><cf_get_lang_main no="45.Müşteri">*</td>
                            <td><input type="hidden" name="ref_company_id" id="ref_company_id" value="<cfif isdefined('attributes.cpid')><cfoutput>#attributes.cpid#</cfoutput></cfif>">
                                <input type="hidden" name="ref_partner_id" id="ref_partner_id" value="">
                                <input type="hidden" name="ref_consumer_id" id="ref_consumer_id" value="">
                                <input type="hidden" name="ref_employee_id" id="ref_employee_id" value="">
                                <input type="hidden" name="ref_member_type" id="ref_member_type" value="">
                                <input type="text" name="ref_member_name" id="ref_member_name" value="<cfif isdefined('attributes.cpid')><cfoutput>#get_comp_info.fullname#</cfoutput></cfif>"  style="width:163px;">
                                <a href="javascript://" onClick="get_turkish_letters_div('document.add_order.ref_member_name','turkish_letters_div');"><img src="/images/plus_thin.gif" border="0" align="absmiddle" class="form_icon"></a>
                                <a href="javascript://" onClick="get_company_all_div();"><img src="/images/buyutec.jpg" border="0" align="absmiddle" class="form_icon"></a>
                            </td>
                        </tr>
                        <tr><td></td><td><div id="turkish_letters_div"></div></td></tr>
                        <tr><td colspan="2"><div id="company_all_div"></div></td></tr>
                        <cfif isDefined('xml_order_type') and xml_order_type eq 1>
                            <tr>
                                <td><cf_get_lang_main no="164.Çalışan"></td>
                                <td>
                                    <select name="my_members" id="my_members" style="width:150px;">
                                        <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                        <cfoutput query="get_emps">
                                            <option value="#employee_id#" <cfif isDefined('attributes.my_members') and attributes.my_members eq employee_id>selected</cfif>>#employee_name# #employee_surname#</option>
                                        </cfoutput>
                                    </select>
                                </td>
                            </tr>
                        </cfif>
                        <tr>
                            <td><cf_get_lang_main no="344.Durum"></td>
                            <td>
                                <select name="order_status" id="order_status" style="width:70px;">
                                    <option value=""><cf_get_lang_main no="296.Tümü"></option>                            	
                                    <option value="1"><cf_get_lang_main no="81.Aktif"></option>
                                    <option value="2"><cf_get_lang_main no="82.Pasif"></option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="infotag"><cf_get_lang_main no="330.Tarih"></td>
                            <td>
                                <cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="641.Başlangıç Tarihi"></cfsavecontent>
                                <cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:80px;">
                                <cf_wrk_date_image date_field="start_date">
                    
                                <cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="288.Bitiş Tarihi"></cfsavecontent>
                                <cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:80px;">
                                <cf_wrk_date_image date_field="finish_date">
                            </td>
                        </tr>
                        <tr style="height:30px;">
                            <td>&nbsp;</td>
                            <td align="right"><input type="button" onClick="kontrol_prerecord();" class="button" value="Listele">
                            <!--- <cf_workcube_buttons is_upd='0' add_function="kontrol_prerecord()"> ---></td>
                        </tr>
                        <tr>
                            <td colspan="2"><div id="kontrol_prerecord_div"></div></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <br/>		
    </cfform>
    <script type="text/javascript">
        function get_company_all_div()
        {
            if(document.getElementById('ref_member_name').value.length <= 2)
            {
                alert("Lütfen listelemek için en az 3 karakter giriniz !");
                return false;
            }
            goster(company_all_div);
            AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_company_div_purchase&ref_member_name='+ encodeURI(document.getElementById('ref_member_name').value) +'&div_name='+'company_all_div' +'&form_id=' + 'add_order' +'&is_my=1','company_all_div');		
            return false;
        }
        function add_company_div(company_id,member_name,partner_id,member_type)
        {
            document.getElementById('ref_company_id').value = company_id;
            document.getElementById('ref_member_name').value = member_name;
            document.getElementById('ref_partner_id').value = partner_id;
            document.getElementById('ref_member_type').value = member_type;
            gizle(company_all_div);
        }
        function kontrol_prerecord()
        {
            if(document.getElementById('ref_company_id').value == '' && (document.getElementById('start_date').value == '' || document.getElementById('finish_date').value == ''))
            {
                alert("Lütfen listelemek için müşteri seçiniz veya başlangıç/bitiş tarih alanlarını doldurunuz !");
                return false;
            }
            if(document.getElementById('ref_member_name').value != '' && document.getElementById('ref_member_name').value.length < 3)
            {
                alert("Lütfen listelemek için en az 3 karakter giriniz !");
                return false;
            }
            if(document.getElementById('ref_member_name').value == '')
            {
                document.getElementById('ref_company_id').value = '';
                document.getElementById('ref_partner_id').value = '';
            }
            goster(kontrol_prerecord_div);
            AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_list_order_div&order_status='+document.getElementById('order_status').value+'&ref_company_id='+ document.getElementById('ref_company_id').value + '&<cfif isDefined('xml_order_type') and xml_order_type eq 1>my_members='+document.getElementById('my_members').value+'&</cfif>ref_partner_id='+ document.getElementById('ref_partner_id').value  +'&start_date='+ document.getElementById('start_date').value +'&finish_date=' + document.getElementById('finish_date').value +'&div_name='+'kontrol_prerecord_div' +'&form_id=' + 'add_order','kontrol_prerecord_div');		
            return false;
        }
        //+ '&opportunity_type_id=' + document.add_order.opportunity_type_id[add_order.opportunity_type_id.selectedIndex].value  +'&opp_currency_id=' + document.add_order.opp_currency_id[add_order.opp_currency_id.selectedIndex].value
    
        document.getElementById('ref_member_name').focus();
    
        <cfif isdefined('attributes.cpid')>
            kontrol_prerecord();
        </cfif>
    </script>
    <cf_get_lang_set module_name="sales"><!--- sayfanin en ustunde acilisi var --->
<cfelse>
	<cfinclude template="dsp_list_order.cfm">
</cfif>

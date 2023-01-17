<cfif not IsDefined("attributes.event") or attributes.event eq 'list'>
<cf_get_lang_set module_name="ch"><!--- sayfanin en altinda kapanisi var --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.detail" default="">
<cfparam name="attributes.POSITION_CODE" default="#session.ep.position_code#">
<cfif isdefined("attributes.is_submitted")>
	<!--- cari hesap tipleri çoklu seçilsin parametresine göre yetki kontrolleri yapılıyor. Tüm modüllerde ortak kullanılıyor --->
	<cfset hr_type_list = ''>
    <cfset ehesap_type_list = ''>
    <cfset other_type_list = ''>
    <cfif not isdefined("arguments.module_power_user_hr")>
        <cfset module_power_user_hr = get_module_power_user(3)>
    <cfelse>
        <cfset module_power_user_hr = arguments.module_power_user_hr>
    </cfif>
    <cfif not isdefined("arguments.module_power_user_ehesap")>
        <cfset module_power_user_ehesap = get_module_power_user(48)>
    <cfelse>
        <cfset module_power_user_ehesap = arguments.module_power_user_ehesap>
    </cfif>
    <cfquery name="get_acc_types_" datasource="#dsn#">
        SELECT 
            ISNULL(IS_EHESAP_USER,0) IS_EHESAP_USER,
            ISNULL(IS_HR_USER,0) IS_HR_USER,
            ACC_TYPE_ID 
        FROM 
            SETUP_ACC_TYPE
        WHERE
            ACC_TYPE_ID NOT IN(SELECT ACC_TYPE_ID FROM SETUP_ACC_TYPE_POSID)
        UNION ALL 
        SELECT 
            ISNULL(IS_EHESAP_USER,0) IS_EHESAP_USER,
            ISNULL(IS_HR_USER,0) IS_HR_USER,
            ACC_TYPE_ID 
        FROM 
            SETUP_ACC_TYPE SAT
        WHERE
            ACC_TYPE_ID IN(SELECT ACC_TYPE_ID FROM SETUP_ACC_TYPE_POSID SP INNER JOIN EMPLOYEE_POSITIONS EP ON SP.POSITION_ID = EP.POSITION_ID WHERE POSITION_CODE = #session.ep.position_code#)
    </cfquery>
    <cfoutput query="get_acc_types_">
        <cfif is_hr_user eq 1>
            <cfset hr_type_list = listappend(hr_type_list,get_acc_types_.acc_type_id)>
        </cfif>
        <cfif is_ehesap_user eq 1>
            <cfset ehesap_type_list = listappend(ehesap_type_list,get_acc_types_.acc_type_id)>
        </cfif>
        <cfif is_hr_user eq 0 and is_ehesap_user eq 0>
            <cfset other_type_list = listappend(other_type_list,get_acc_types_.acc_type_id)>
        </cfif>
    </cfoutput>
    <cfif module_power_user_hr>
        <cfset kontrol_type = 0>
    <cfelse>
        <cfset kontrol_type = 1>
    </cfif>
    <cfif module_power_user_ehesap>
        <cfset kontrol_type2 = 0>
    <cfelse>
        <cfset kontrol_type2 = 1>
    </cfif>
    <!--- Yetkili pozisyon seçili olan cari hesap tiplerini görmemeli SG 20150407--->
    <cfquery name="get_type_pos_control" datasource="#dsn#">
        SELECT 
            ACC_TYPE_ID 
        FROM 
            SETUP_ACC_TYPE SAT
        WHERE
            ACC_TYPE_ID IN(SELECT ACC_TYPE_ID FROM SETUP_ACC_TYPE_POSID SP INNER JOIN EMPLOYEE_POSITIONS EP ON SP.POSITION_ID = EP.POSITION_ID) AND <!--- yetkili pozisyon seçili olan hesap tipleri--->
            ACC_TYPE_ID NOT IN(SELECT ACC_TYPE_ID FROM SETUP_ACC_TYPE_POSID SP INNER JOIN EMPLOYEE_POSITIONS EP ON SP.POSITION_ID = EP.POSITION_ID WHERE POSITION_CODE = 2439)<!--- çalışanın yetkili olarak ekli olduğu hesap tipleri hariç--->
    </cfquery>
    <cfif not isdefined("ch_alias")><cfset ch_alias = ''></cfif>
    <cfoutput>
        <cfsavecontent variable="control_acc_type_list">
            (
                <cfif len(hr_type_list) or len(ehesap_type_list)>
                    (
                        <cfif len(hr_type_list)>
                            (
                                <cfif module_power_user_hr>
                                    #ch_alias#ACC_TYPE_ID IN(#hr_type_list#)
                                <cfelse>
                                    #ch_alias#ACC_TYPE_ID NOT IN(#hr_type_list#)
                                    <cfif len(valuelist(get_type_pos_control.acc_type_id))>    
                                    AND #ch_alias#ACC_TYPE_ID NOT IN(#valuelist(get_type_pos_control.acc_type_id)#)
                                    </cfif>                         
                                </cfif>
                            )
                        </cfif>
                        <cfif isdefined("kontrol_type") and len(ehesap_type_list) and len(hr_type_list)>
                            <cfif kontrol_type eq 0 and kontrol_type2 eq 0>OR<cfelse>AND</cfif>
                        </cfif>
                        <cfif len(ehesap_type_list)>
                            (
                                <cfif module_power_user_ehesap>
                                    #ch_alias#ACC_TYPE_ID IN(#ehesap_type_list#)
                                <cfelse>
                                    #ch_alias#ACC_TYPE_ID NOT IN(#ehesap_type_list#)
                                    <cfif len(valuelist(get_type_pos_control.acc_type_id))>    
                                    AND #ch_alias#ACC_TYPE_ID NOT IN(#valuelist(get_type_pos_control.acc_type_id)#)
                                    </cfif>                           
                                </cfif>
                            )
                        </cfif>
                    )
                </cfif>
                <cfif len(other_type_list) and (len(ehesap_type_list) or len(hr_type_list))>
                    OR
                </cfif>
                <cfif len(other_type_list)>
                    #ch_alias#ACC_TYPE_ID IN(#other_type_list#)
                </cfif>
                <cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)>
                    OR #ch_alias#ACC_TYPE_ID IS NULL
                </cfif>
            )
        </cfsavecontent>
    </cfoutput>


	<cfif isdefined("attributes.employee_id")>
		<cfscript>
			attributes.acc_type_id = '';
			if(listlen(attributes.employee_id,'_') eq 2)
			{
				attributes.acc_type_id = listlast(attributes.employee_id,'_');
				attributes.emp_id = listfirst(attributes.employee_id,'_');
			}
			else
				attributes.emp_id = attributes.employee_id;
		</cfscript>
	</cfif>
	<cfquery name="GET_CARI_OPEN" datasource="#DSN#">
		SELECT  DISTINCT
				CR.ACTION_CURRENCY_ID,
				CR.CARI_ACTION_ID,
				CR.ACTION_NAME,
				CR.PROCESS_CAT, 
				CR.TO_CMP_ID, 
				CR.FROM_CMP_ID, 
				CR.TO_CONSUMER_ID,
				CR.FROM_CONSUMER_ID,
				CR.TO_EMPLOYEE_ID,
				CR.FROM_EMPLOYEE_ID,
				CR.ACTION_VALUE,
				CR.ACTION_NAME,
				CR.OTHER_CASH_ACT_VALUE,
				CR.OTHER_MONEY,
				CR.ACTION_VALUE_2,
				CR.ACTION_CURRENCY_2,
				C.FULLNAME,
				C.MEMBER_CODE,
				C.OZEL_KOD,
				CR.ACC_TYPE_ID,
				CR.PAPER_NO
			FROM 
				#dsn2_alias#.CARI_ROWS CR,
				COMPANY C
			WHERE
				CR.ACTION_TYPE_ID=40 AND
				(CR.FROM_CMP_ID = C.COMPANY_ID OR CR.TO_CMP_ID = C.COMPANY_ID) 
				<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company_name") and len(attributes.company_name)>
					AND ( TO_CONSUMER_ID = #attributes.consumer_id# OR FROM_CONSUMER_ID = #attributes.consumer_id# )
				</cfif>
				<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company_name") and len(attributes.company_name)>
					AND C.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.employee_name") and len(attributes.employee_name)>
					AND ( TO_EMPLOYEE_ID = #attributes.emp_id# OR FROM_EMPLOYEE_ID = #attributes.emp_id# )
				</cfif>
				<cfif len (attributes.keyword)>
					AND  ACTION_NAME LIKE '#attributes.keyword#%'  
				</cfif>
		UNION ALL
			SELECT DISTINCT
				CR.ACTION_CURRENCY_ID,
				CR.CARI_ACTION_ID,
				CR.ACTION_NAME,
				CR.PROCESS_CAT, 
				CR.TO_CMP_ID, 
				CR.FROM_CMP_ID, 
				CR.TO_CONSUMER_ID,
				CR.FROM_CONSUMER_ID,
				CR.TO_EMPLOYEE_ID,
				CR.FROM_EMPLOYEE_ID,
				CR.ACTION_VALUE,
				CR.ACTION_NAME,
				CR.OTHER_CASH_ACT_VALUE,
				CR.OTHER_MONEY,
				CR.ACTION_VALUE_2,
				CR.ACTION_CURRENCY_2,
				<cfif database_type is "MSSQL">
					(CONS.CONSUMER_NAME + ' ' + CONSUMER_SURNAME) AS FULLNAME
				<cfelseif database_type is "DB2">
					(CONS.CONSUMER_NAME || ' ' || CONSUMER_SURNAME) AS FULLNAME
				</cfif>,
				CONS.MEMBER_CODE,
				CONS.OZEL_KOD,
				CR.ACC_TYPE_ID,
				CR.PAPER_NO
			FROM 
				#dsn2_alias#.CARI_ROWS CR,
				CONSUMER CONS
			WHERE
				CR.ACTION_TYPE_ID=40 AND
				(CR.FROM_CONSUMER_ID = CONS.CONSUMER_ID OR CR.TO_CONSUMER_ID = CONS.CONSUMER_ID)
				<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company_name") and len(attributes.company_name)>
					AND ( TO_CONSUMER_ID = #attributes.consumer_id# OR FROM_CONSUMER_ID = #attributes.consumer_id# )
				</cfif>
				<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company_name") and len(attributes.company_name)>
					AND ( TO_CMP_ID = #attributes.company_id# OR FROM_CMP_ID = #attributes.company_id# )
				</cfif>
				<cfif isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.employee_name") and len(attributes.employee_name)>
					AND ( TO_EMPLOYEE_ID = #attributes.emp_id# OR FROM_EMPLOYEE_ID = #attributes.emp_id# )
				</cfif>
				<cfif isdefined("attributes.keyword")and len (attributes.keyword)>
					AND  ACTION_NAME LIKE '#attributes.keyword#%' 
				</cfif>
				<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
					AND CR.ACC_TYPE_ID = #attributes.acc_type_id#
				</cfif>
		UNION ALL
				SELECT DISTINCT
					CR.ACTION_CURRENCY_ID,
					CR.CARI_ACTION_ID,
					CR.ACTION_NAME,
					CR.PROCESS_CAT, 
					CR.TO_CMP_ID, 
					CR.FROM_CMP_ID, 
					CR.TO_CONSUMER_ID,
					CR.FROM_CONSUMER_ID,
					CR.TO_EMPLOYEE_ID,
					CR.FROM_EMPLOYEE_ID,
					CR.ACTION_VALUE,
					CR.ACTION_NAME,
					CR.OTHER_CASH_ACT_VALUE,
					CR.OTHER_MONEY,
					CR.ACTION_VALUE_2,
					CR.ACTION_CURRENCY_2,
					<cfif database_type is "MSSQL">
						(EMP.EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME) AS FULLNAME
					<cfelseif database_type is "DB2">
						(EMP.EMPLOYEE_NAME || ' ' || EMPLOYEE_SURNAME) AS FULLNAME
					</cfif>,
					EMP.EMPLOYEE_NO MEMBER_CODE,
					EMP.OZEL_KOD,
					CR.ACC_TYPE_ID,
					CR.PAPER_NO
				FROM 
					#dsn2_alias#.CARI_ROWS CR,
					EMPLOYEES EMP
				WHERE
					CR.ACTION_TYPE_ID=40 AND
					(CR.FROM_EMPLOYEE_ID = EMP.EMPLOYEE_ID OR CR.TO_EMPLOYEE_ID = EMP.EMPLOYEE_ID)
					<cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
						AND #control_acc_type_list#
					</cfif>
					<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company_name") and len(attributes.company_name)>
						AND ( TO_CONSUMER_ID = #attributes.consumer_id# OR FROM_CONSUMER_ID = #attributes.consumer_id# )
					</cfif>
					<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company_name") and len(attributes.company_name)>
						AND ( TO_CMP_ID = #attributes.company_id# OR FROM_CMP_ID = #attributes.company_id# )
					</cfif>
					<cfif isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.employee_name") and len(attributes.employee_name)>
						AND ( TO_EMPLOYEE_ID = #attributes.emp_id# OR FROM_EMPLOYEE_ID = #attributes.emp_id# )
					</cfif>
					<cfif len (attributes.keyword)>
						AND  ACTION_NAME LIKE '#attributes.keyword#%'  
					</cfif>
					<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
						AND CR.ACC_TYPE_ID = #attributes.acc_type_id#
					</cfif>
		ORDER BY
			FULLNAME
	</cfquery>
<cfelse>
	<cfset get_cari_open.recordcount=0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'> 
<cfparam name="attributes.totalrecords" default="#get_cari_open.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >

 <script type="text/javascript">
		$( document ).ready(function() {
    		document.getElementById('keyword').focus();
		});
    </script>
</cfif>
<script type="text/javascript">
	function pencere_ac_member()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_pars&field_name=add_bill.company_name&field_comp_name=add_bill.company_name&field_consumer=add_bill.consumer_id&field_comp_id=add_bill.company_id&select_list=2,3<cfif fusebox.circuit is "store">&is_store_module=1</cfif>','list');
	}
	function auto_complate_member()
	{
		AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'<cfif fusebox.circuit is 'store'>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','225');
	}
	function pencere_ac_employee()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_positions&is_cari_action=1&field_emp_id=add_bill.employee_id&field_name=add_bill.employee_name&select_list=1,9&keyword='+encodeURIComponent(document.add_bill.employee_name.value),'list');
	}
		function auto_complate_employee()
	{
		AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3\',\'<cfif fusebox.circuit is 'store'>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','EMPLOYEE_ID','employee_id','','3','225');
	}
	function auto_complete_acc_name() 
	{
		AutoComplete_Create('acc_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID','comp_id,cons_id,emp_id','','3','200');
	}
	function auto_complete_project() 
	{
		AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');
	}
	function pencere_ac_project() 
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_projects&project_head=add_ch_open.project_name&project_id=add_ch_open.project_id','list');
	}
</script>
<cfif  IsDefined("attributes.event") >
	<cf_get_lang_set module_name="ch">
    <cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
        SELECT MONEY FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
    </cfquery>
</cfif>
<cfif  IsDefined("attributes.event") and attributes.event eq 'add'>
	<script type="text/javascript">
	function sil(gelen)
	{
		if( (gelen==0) && (add_ch_open.debt.value.length) && (add_ch_open.claim.value.length) )
		add_ch_open.claim.value = '';
		else if ( (gelen==1) && (add_ch_open.debt.value.length) && (add_ch_open.claim.value.length) )
		add_ch_open.debt.value = '';
	}
	function pencere_ac(r_row)
	{
		hesap_sec();
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&field_name=add_ch_open.acc_name&field_comp_name=add_ch_open.acc_name&field_consumer=add_ch_open.cons_id&field_emp_id=add_ch_open.emp_id&field_comp_id=add_ch_open.comp_id<cfif fusebox.circuit is "store" or isdefined("attributes.is_store_module")>&is_store_module=1</cfif>&select_list=2,3,1,9','list','popup_list_all_pars');
	}
	function kontrol()
	{
		if(!chk_process_cat('add_ch_open')) return false;
		if(!chk_period(document.add_ch_open.open_date,'İşlem')) return false;
		if((add_ch_open.acc_name.value=='') || (add_ch_open.comp_id.value=='' && add_ch_open.cons_id.value=='' && add_ch_open.emp_id.value==''))
		{
			alert("<cf_get_lang no='108.Lütfen Cari Hesap Seçiniz'> !");
			return false;
		}	
		if((add_ch_open.debt.value=='') && (add_ch_open.claim.value==''))
		{
			alert("<cf_get_lang_main no='1177.Değer Girmelisiniz'>!");
			return false;
		}
		if(((add_ch_open.debt.value=='') || (add_ch_open.debt.value=='0')) && ((add_ch_open.claim.value=='') || (add_ch_open.claim.value=='0')))
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='175.Borç'>/<cf_get_lang_main no='176.Alacak'> <cf_get_lang_main no='577.Ve'> <cf_get_lang_main no='2215.Değer 0 Sıfır Olamaz'>");
			return false;
		}
		if((add_ch_open.other_money_value.value==''))
		{
			alert("<cf_get_lang no='90.İşlem Dövizi Değeri Girmelisiniz'>!");
			return false;
		}	
		if((add_ch_open.action_value_2.value==''))
		{
			alert("<cf_get_lang no='89.Sistem Dövizi Değeri Girmelisiniz'>!");
			return false;
		}	
		add_ch_open.debt.value = filterNum(add_ch_open.debt.value);
		add_ch_open.claim.value = filterNum(add_ch_open.claim.value);
		add_ch_open.other_money_value.value = filterNum(add_ch_open.other_money_value.value);
		add_ch_open.action_value_2.value = filterNum(add_ch_open.action_value_2.value);
		return true;
	}
	function hesap_sec()
	{
		document.add_ch_open.comp_id.value='';
		document.add_ch_open.acc_name.value='';
		document.add_ch_open.emp_id.value='';
		document.add_ch_open.cons_id.value='';
	}
</script>
</cfif>


<cfif  IsDefined("attributes.event") and attributes.event eq 'upd'>
    <cfquery name="GET_CARI_OPEN_ROW" datasource="#DSN2#">
        SELECT 
            CR.ACTION_CURRENCY_ID,
            CR.CARI_ACTION_ID,
            CR.ACTION_NAME,
            CR.PROCESS_CAT, 
            CR.TO_CMP_ID, 
            CR.FROM_CMP_ID, 
            CR.FROM_CONSUMER_ID,
            CR.TO_CONSUMER_ID,
            CR.FROM_EMPLOYEE_ID,
            CR.TO_EMPLOYEE_ID,
            CR.ACTION_VALUE,
            CR.OTHER_CASH_ACT_VALUE,
            CR.OTHER_MONEY,
            CR.DUE_DATE,
            CR.PROJECT_ID,
            CR.ASSETP_ID,
            CR.ACTION_DATE,
            CR.ACTION_VALUE_2,
            CR.RECORD_EMP,
            CR.RECORD_DATE,
            CR.UPDATE_EMP,
            CR.UPDATE_DATE,
            CR.ACTION_CURRENCY_2,
            CR.PAPER_NO,
            ISNULL(CR.TO_BRANCH_ID,FROM_BRANCH_ID) BRANCH_ID,
            CR.ACC_TYPE_ID
        <cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
            ,C.FULLNAME
        <cfelseif isdefined("attributes.cons_id") and len(attributes.cons_id)>
            <cfif database_type is "MSSQL">
                ,(CON.CONSUMER_NAME + ' ' + CON.CONSUMER_SURNAME) AS FULLNAME
            <cfelseif database_type is "DB2">
                ,(CON.CONSUMER_NAME || ' ' || CON.CONSUMER_SURNAME) AS FULLNAME
            </cfif>
        <cfelseif isdefined("attributes.emp_id") and len(attributes.emp_id)>
            <cfif database_type is "MSSQL">
                ,(EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME) AS FULLNAME
            <cfelseif database_type is "DB2">
                ,(EMP.EMPLOYEE_NAME || ' ' || EMP.EMPLOYEE_SURNAME) AS FULLNAME
            </cfif>
        </cfif>
        FROM 
            CARI_ROWS CR
        <cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
            ,#dsn_alias#.COMPANY C
        <cfelseif isdefined("attributes.cons_id") and len(attributes.cons_id)>
            ,#dsn_alias#.CONSUMER CON
        <cfelseif isdefined("attributes.emp_id") and len(attributes.emp_id)>
            ,#dsn_alias#.EMPLOYEES EMP
        </cfif>
        WHERE		
            CR.ACTION_TYPE_ID = 40
        <cfif isdefined("attributes.cari_act_id")>
            AND CR.CARI_ACTION_ID = #attributes.cari_act_id#
        </cfif>
        <cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
             AND (CR.FROM_CMP_ID = #attributes.comp_id# OR CR.TO_CMP_ID = #attributes.comp_id#)
             AND (CR.FROM_CMP_ID = C.COMPANY_ID OR CR.TO_CMP_ID = C.COMPANY_ID)
        <cfelseif isdefined("attributes.cons_id") and len(attributes.cons_id)>
             AND (CR.FROM_CONSUMER_ID = #attributes.cons_id# OR CR.TO_CONSUMER_ID = #attributes.cons_id#)
             AND (CR.FROM_CONSUMER_ID = CON.CONSUMER_ID OR CR.TO_CONSUMER_ID = CON.CONSUMER_ID)
        <cfelseif isdefined("attributes.emp_id") and len(attributes.emp_id)>
             AND (CR.FROM_EMPLOYEE_ID = #attributes.emp_id# OR CR.TO_EMPLOYEE_ID = #attributes.emp_id#)
             AND (CR.FROM_EMPLOYEE_ID = EMP.EMPLOYEE_ID OR CR.TO_EMPLOYEE_ID = EMP.EMPLOYEE_ID)
        </cfif>
    </cfquery>
    <cfif len(GET_CARI_OPEN_ROW.PROJECT_ID)>
        <cfquery name="get_project_name" datasource="#dsn#">
            SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #GET_CARI_OPEN_ROW.PROJECT_ID#
        </cfquery>
    </cfif>
<script type="text/javascript">
	
	function sil(gelen)
	{
		if( (gelen==0) && (add_ch_open.debt.value.length) && (add_ch_open.claim.value.length) )
		add_ch_open.claim.value = '';
		else if ( (gelen==1) && (add_ch_open.debt.value.length) && (add_ch_open.claim.value.length) )
		add_ch_open.debt.value = '';
	}
	function pencere_ac(r_row)
	{
		hesap_sec();
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&field_name=add_ch_open.acc_name&field_type=add_ch_open.member_type&field_comp_name=add_ch_open.acc_name&field_consumer=add_ch_open.cons_id&field_emp_id=add_ch_open.emp_id&field_comp_id=add_ch_open.comp_id<cfif fusebox.circuit is "store" or isdefined("attributes.is_store_module")>&is_store_module=1</cfif>&select_list=2,3,1,9','list','popup_list_all_pars');
	}
	
	function kontrol()
	{
		if(!chk_process_cat('add_ch_open')) return false;
		if(!chk_period(document.add_ch_open.open_date,'İşlem')) return false;
		if((add_ch_open.acc_name.value=='') || (add_ch_open.comp_id.value=='' && add_ch_open.cons_id.value=='' && add_ch_open.emp_id.value==''))
		{
			alert("<cf_get_lang no='108.Lütfen Cari Hesap Seçiniz'> !");
			return false;
		}
		if((add_ch_open.debt.value=='') && (add_ch_open.claim.value==''))
		{
			alert("<cf_get_lang_main no='1177.Değer Girmelisiniz'>");
			return false;
		}
		if(((add_ch_open.debt.value==' ') || (add_ch_open.debt.value== 0 )) && ((add_ch_open.claim.value==' ') || (add_ch_open.claim.value== 0)))
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='175.Borç'>/<cf_get_lang_main no='176.Alacak'> <cf_get_lang_main no='577.Ve'> <cf_get_lang_main no='2215.Değer 0 Sıfır Olamaz'>");
			return false;
		}
		if((add_ch_open.other_money_value.value==''))
		{
			alert("<cf_get_lang no='90.İşlem Dövizi Değeri Girmelisiniz'>");
			return false;
		}	
		if((add_ch_open.action_value_2.value==''))
		{
			alert("<cf_get_lang no='89.Sistem Dövizi Değeri Girmelisiniz'>");
			return false;
		}
		add_ch_open.debt.value = filterNum(add_ch_open.debt.value,4);
		add_ch_open.claim.value = filterNum(add_ch_open.claim.value,4);
		add_ch_open.other_money_value.value = filterNum(add_ch_open.other_money_value.value,4);	
		add_ch_open.action_value_2.value = filterNum(add_ch_open.action_value_2.value,4);	
		return true;
	}
	function hesap_sec()
	{
		if(document.add_ch_open.comp_id.value!='')
		{
			document.add_ch_open.comp_id.value='';
			document.add_ch_open.acc_name.value='';
		}
		if(document.add_ch_open.emp_id.value!='')
		{
			document.add_ch_open.emp_id.value='';
			document.add_ch_open.acc_name.value='';
		}
		if(document.add_ch_open.cons_id.value!='')
		{
			document.add_ch_open.cons_id.value='';
			document.add_ch_open.acc_name.value='';
		}
	}
</script>
</cfif>
<cfif IsDefined("attributes.cari_act_id") and len (attributes.cari_act_id)>
	<cfset attributes.detail = "sdsa">
	<cfoutput query="GET_CARI_OPEN_ROW">   
		        
		<cfif len(to_cmp_id)>
            <cfset my_company_id = to_cmp_id>
        <cfelseif len(from_cmp_id)>
            <cfset my_company_id = from_cmp_id>
        <cfelse>
            <cfset my_company_id ="">
        </cfif>
        <cfif len(to_consumer_id)>
            <cfset my_consumer_id = to_consumer_id>
        <cfelseif len(from_consumer_id)>	
            <cfset my_consumer_id = from_consumer_id>
        <cfelse>
            <cfset my_consumer_id = "">
        </cfif>
        <cfif len(to_employee_id)>
            <cfset my_employee_id = to_employee_id>
        <cfelseif len(from_employee_id)>	
            <cfset my_employee_id = from_employee_id>
        <cfelse>
            <cfset my_employee_id = "">
        </cfif>
        <cfset emp_id = my_employee_id>
        <cfset fullname_ = fullname>
        <cfif len(my_employee_id) and len(acc_type_id)>
            <cfset fullname_ = get_emp_info(my_employee_id,0,0,0,acc_type_id)>
            <cfset emp_id = '#emp_id#_#acc_type_id#'>
        </cfif>
        
        <cfset attributes.detail = ACTION_NAME>
        <cfset attributes.process_cat = process_cat>
        <cfset attributes.acc_name = fullname_>
        <cfset attributes.comp_id = my_company_id>
        <cfset attributes.cons_id = my_consumer_id>
        <cfset attributes.emp_id = emp_id>
        <cfset attributes.cari_action_id = CARI_ACTION_ID>
        <cfset attributes.project_id = PROJECT_ID>
        <cfif len(attributes.project_id)>
        	<cfset attributes.project_head = get_project_name.project_head>
        <cfelse>
        	<cfset attributes.project_head = "">
        </cfif>
        <cfset attributes.assetp_id = assetp_id>
        <cfset attributes.branch_id = branch_id>
        <cfset attributes.action_date = action_date>
        <cfset attributes.due_date = due_date>
        <cfset attributes.paper_no = paper_no>
       <cfif len(to_cmp_id)>
        	<cfset attributes.to_value = to_cmp_id>
        <cfelseif len(to_consumer_id)>
        	<cfset attributes.to_value = to_consumer_id>
        <cfelse>
        	<cfset attributes.to_value = to_employee_id>
        </cfif>
        <cfset attributes.action_value = action_value>
        <cfif len(from_cmp_id)>
        	<cfset attributes.from_value = from_cmp_id>
        <cfelseif len(from_consumer_id)>
        	<cfset attributes.from_value = from_consumer_id>
        <cfelse>
        	<cfset attributes.from_value = from_employee_id>
        </cfif>
        <cfset attributes.action_value = action_value>
        <cfset attributes.other_money_value = OTHER_CASH_ACT_VALUE>
        <cfset attributes.other_money = other_money>
        <cfset attributes.action_value_2 = action_value_2>
	</cfoutput>
<cfelse>
	<cfparam name="attributes.detail" default="">
    <cfparam name="attributes.process_cat" default="">
    <cfparam name="attributes.comp_id" default="">
    <cfparam name="attributes.cons_id" default="">
    <cfparam name="attributes.emp_id" default="">
    <cfparam name="attributes.cari_action_id" default="">
    <cfparam name="attributes.acc_name" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.assetp_id" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.action_date" default="#dateformat(session.ep.period_date,'dd/mm/yyyy')#">
    <cfparam name="attributes.due_date" default="">
    <cfparam name="attributes.paper_no" default="">
    <cfparam name="attributes.to_value" default="">
    <cfparam name="attributes.to_cmp_id" default="">
    <cfparam name="attributes.to_consumer_id" default="">
    <cfparam name="attributes.to_employee_id" default="">
    <cfparam name="attributes.action_value" default="0">
    <cfparam name="attributes.other_money_value" default="0">
    <cfparam name="attributes.action_value_2" default="0">
    <cfparam name="attributes.from_value" default="">
    <cfparam name="attributes.from_cmp_id" default="">
    <cfparam name="attributes.from_consumer_id" default="">
    <cfparam name="attributes.from_employee_id" default="">
    <cfparam name="attributes.other_money" default="">
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ch.form_upd_account_open';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'ch/form/upd_bill_opening.cfm';
	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ch.form_upd_account_open';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'ch/form/add_ch_open_row.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'ch/query/add_ch_open_row.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ch.form_upd_account_open&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ch.form_upd_account_open';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'ch/form/add_ch_open_row.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'ch/query/upd_ch_open_row.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ch.form_upd_account_open&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'cari_act_id=##attributes.cari_act_id##';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'comp_id=##attributes.comp_id##';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'cons_id=##attributes.cons_id##';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'emp_id=##attributes.emp_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.cari_act_id##';
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.form_upd_account_open&event=del&cari_act_id=#attributes.cari_act_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'ch/query/del_ch_open_row.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'ch/query/del_ch_open_row.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ch.form_upd_account_open';
	}	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'openAccount';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CARI_ACTIONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item4','item2','item9','item10']"; 
	/*
	
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=finance.list_creditcard&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	} */
</cfscript>

<cf_get_lang_set module_name="myhome">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfsavecontent variable="lang_2"><cf_get_lang no='4.onaylarim'></cfsavecontent>
    <cfsavecontent variable="lang_3"><cf_get_lang no='9.Uyarılarım'></cfsavecontent>
    <cf_get_lang_set module_name="process">
    <cfsavecontent variable="lang_4"><cf_get_lang no='27.Uyarı ve Onaylar'></cfsavecontent>
    <cf_get_lang_set module_name="#fusebox.circuit#">
    <cfif fusebox.fuseaction contains 'popup'>
        <cfset page_type = 0><!--- Popup Myhome --->
        <cfset header_ = lang_4>
        <cfset attributes.is_form_submitted = 1>
    <cfelseif fusebox.fuseaction contains 'confirm'>
        <cfset page_type = 1><!--- Onaylar --->
        <cfset header_ = lang_2>
        <cfif isdefined("attributes.is_form_submitted")>
            <cfset attributes.is_form_submitted = 1>
        </cfif>
    <cfelseif fusebox.circuit contains 'myhome'>
        <cfset page_type = 2><!--- Uyarilar --->
        <cfset header_ = lang_3>
        <cfif isdefined("attributes.is_form_submitted")>
            <cfset attributes.is_form_submitted = 1>
        </cfif>
    <cfelse>
        <cfset page_type = 3><!--- Process Modulu --->
        <cfset header_ = lang_4>
    </cfif>
    <cfif page_type neq 3><cf_xml_page_edit fuseact="#fusebox.circuit#.popup_list_warning"></cfif>
    
    <!--- Sirket ve Donem Kontrolleri Yapilacak Tablolar Burada Belirlenir --->
    <cfset Comp_Id_Control_Tables = "OPPORTUNITIES,INTERNALDEMAND,OFFER,ORDERS,PRODUCTION_ORDERS,PRODUCT_TREE,PRODUCTION_ORDER_RESULT,BUDGET_PLAN,CAMPAIGNS,COMPANY_CREDIT,CORRESPONDENCE,SERVICE,SUBSCRIPTION_CONTRACT,SALES_QUOTAS">
    <cfset Period_Id_Control_Tables = "CARI_CLOSED,SHIP,INVOICE,EXPENSE_ITEM_PLAN_REQUESTS">
    
    <cf_get_lang_set module_name="myhome">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.list_type" default="">
    <cfparam name="attributes.process_type" default="">
    <cfif not isDefined("attributes.warning_isactive")>
        <cfparam name="attributes.warning_isactive" default="1">
    </cfif>
    <cfif not isDefined("attributes.warning_condition")>
        <cfparam name="attributes.warning_condition" default="1">
    </cfif>
    <cfparam name="attributes.employee_id" default="">
    <cfparam name="attributes.position_code" default="">
    <cfparam name="attributes.employee_name" default="">
    <cfparam name="attributes.action_table" default="">
    <cfscript>
        if(not isDefined('attributes.start_response_date'))
            attributes.start_response_date = date_add('d',-3,now());
        if(not isDefined('attributes.finish_response_date'))
            attributes.finish_response_date = date_add('d',30,now());
    </cfscript>
    <cfif isdefined("attributes.is_active_id")>
        <!--- Pasif Update islemi --->
        <cfquery name="upd_page_warning" datasource="#dsn#">
            UPDATE PAGE_WARNINGS SET IS_ACTIVE = 0 WHERE W_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_active_id#">
        </cfquery>
        <cfif isdefined("attributes.is_close")>
            <script type="text/javascript">
                window.close();
            </script>
        </cfif>
    </cfif>
    <cfif isDefined("attributes.is_form_submitted")>
        <cfinclude template="../myhome/query/get_warnings.cfm">
    <cfelse>
        <cfset get_warnings.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
    <cfparam name="attributes.totalrecords" default="#get_warnings.recordcount#">	
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfscript>
	url_str = "";
	if(isdefined("attributes.keyword") and len(attributes.keyword)) url_str = "#url_str#&keyword=#attributes.keyword#";
	if(isdefined("attributes.start_response_date") and len(attributes.start_response_date))url_str = "#url_str#&start_response_date=#dateformat(attributes.start_response_date,'dd/mm/yyyy')#";
	if(isdefined("attributes.finish_response_date") and len(attributes.finish_response_date))url_str = "#url_str#&finish_response_date=#dateformat(attributes.finish_response_date,'dd/mm/yyyy')#";
	if(isdefined("attributes.employee_name") and len(attributes.employee_name)) url_str='#url_str#&employee_id=#attributes.employee_id#&position_code=#attributes.position_code#&employee_name=#attributes.employee_name#';
	if(isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)) url_str='#url_str#&is_form_submitted=#attributes.is_form_submitted#';
	if(isdefined("attributes.warning_condition"))url_str='#url_str#&warning_condition=#attributes.warning_condition#';
	if(isdefined("attributes.warning_isactive"))url_str='#url_str#&warning_isactive=#attributes.warning_isactive#';
	if(isdefined("attributes.list_type") and len(attributes.list_type))url_str='#url_str#&list_type=#attributes.list_type#';
	if(isdefined("attributes.process_type") and len(attributes.process_type))url_str='#url_str#&process_type=#attributes.process_type#';
	if(isdefined("attributes.action_table") and len(attributes.action_table))url_str='#url_str#&action_table=#attributes.action_table#';
</cfscript>
	<cfif get_warnings.recordcount>
            <cfset employee_list = "">
            <cfset partner_list = "">
            <cfset consumer_list = "">
            <cfset position_code_list = "">
            <cfset period_list = "">
            <cfset our_company_list = "">
            <cfoutput query="get_warnings" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <cfif len(record_emp) and not listfind(employee_list,record_emp)>
                    <cfset employee_list=listappend(employee_list,record_emp)>
                </cfif>
                <cfif len(position_code) and not listfind(position_code_list,position_code)>
                    <cfset position_code_list=listappend(position_code_list,position_code)>
                </cfif>
                <cfif len(record_par) and not listfind(partner_list,record_par)>
                    <cfset partner_list=listappend(partner_list,record_par)>
                </cfif>
                <cfif len(record_con) and not listfind(consumer_list,record_con)>
                    <cfset consumer_list=listappend(consumer_list,record_con)>
                </cfif>
                <cfif len(period_id) and not listfind(period_list,period_id)>
                    <cfset period_list=listappend(period_list,period_id)>
                </cfif>
                <cfif len(our_company_id) and not listfind(our_company_list,our_company_id)>
                    <cfset our_company_list=listappend(our_company_list,our_company_id)>
                </cfif>
            </cfoutput>
            <cfif len(employee_list)>
                <cfquery name="get_employees" datasource="#dsn#">
                    SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_list#) ORDER BY EMPLOYEE_ID
                </cfquery>
                <cfset employee_list = listsort(listdeleteduplicates(valuelist(get_employees.employee_id,',')),'numeric','ASC',',')>
            </cfif>
            <cfif len(partner_list)>
                <cfquery name="get_partners" datasource="#dsn#">
                    SELECT PARTNER_ID, COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#partner_list#) ORDER BY PARTNER_ID
                </cfquery>
                <cfset partner_list = listsort(listdeleteduplicates(valuelist(get_partners.partner_id,',')),'numeric','ASC',',')>
            </cfif>
            <cfif len(consumer_list)>
                <cfquery name="get_consumers" datasource="#dsn#">
                    SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_list#) ORDER BY CONSUMER_ID
                </cfquery>
                <cfset consumer_list = listsort(listdeleteduplicates(valuelist(get_consumers.consumer_id,',')),'numeric','ASC',',')>
            </cfif>
            <cfif len(position_code_list)>
                <cfquery name="get_positions" datasource="#dsn#">
                    SELECT POSITION_CODE, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE IN (#position_code_list#) ORDER BY POSITION_CODE
                </cfquery>
                <cfset position_code_list = listsort(listdeleteduplicates(valuelist(get_positions.position_code,',')),'numeric','ASC',',')>
            </cfif>
            <cfif len(period_list)>
                <cfquery name="get_period" datasource="#dsn#">
                    SELECT PERIOD_ID, PERIOD FROM SETUP_PERIOD WHERE PERIOD_ID IN (#period_list#) ORDER BY PERIOD_ID
                </cfquery>
                <cfset period_list = listsort(listdeleteduplicates(valuelist(get_period.period_id,',')),'numeric','ASC',',')>
            </cfif>
            <cfif len(our_company_list)>
                <cfquery name="get_company" datasource="#dsn#">
                    SELECT COMP_ID, COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID IN (#our_company_list#) ORDER BY COMP_ID
                </cfquery>
                <cfset our_company_list = listsort(listdeleteduplicates(valuelist(get_company.comp_id,',')),'numeric','ASC',',')>
            </cfif>
    </cfif>
<cfelseif (isdefined("attributes.event") and attributes.event is 'det')>
	<cfset attributes.offtime_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.offtime_id,accountKey:'wrk') />
    <cfif (isDefined('attributes.offtime_id') and (not len(attributes.offtime_id)))>
        <script type="text/javascript">
            alert("<cf_get_lang_main no='1531.Boyle Bir Kayıt Bulunmamaktadir'>!");
            window.close(); 
        </script>
        <cfabort>
    </cfif>
    <cfquery name="get_my_pos" datasource="#dsn#">
        SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#
    </cfquery>
    <cfset my_pos_list = valuelist(get_my_pos.POSITION_CODE)>
    <!---İzinde olan kişilerin vekalet bilgileri alınıypr --->
    <cfquery name="Get_Offtime_Valid" datasource="#dsn#">
        SELECT
            O.EMPLOYEE_ID,
            EP.POSITION_CODE
        FROM
            OFFTIME O,
            EMPLOYEE_POSITIONS EP
        WHERE
            O.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
            O.VALID = 1 AND
            #Now()# BETWEEN O.STARTDATE AND O.FINISHDATE
    </cfquery>
    <cfif Get_Offtime_Valid.recordcount>
        <cfset Now_Offtime_PosCode = ValueList(Get_Offtime_Valid.Position_Code)>
        <cfquery name="Get_StandBy_Position1" datasource="#dsn#"><!--- Asil Kisi Izinli ise ve 1.Yedek Izinli Degilse --->
            SELECT POSITION_CODE, CANDIDATE_POS_1 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN(#my_pos_list#)
        </cfquery>
        <cfoutput query="Get_StandBy_Position1">
            <cfset my_pos_list = ListAppend(my_pos_list,ValueList(Get_StandBy_Position1.Position_Code))>
        </cfoutput>
        <cfquery name="Get_StandBy_Position2" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek Izinli ise ve 2.Yedek Izinli Degilse --->
            SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#my_pos_list#)
        </cfquery>
        <cfoutput query="Get_StandBy_Position2">
            <cfset my_pos_list = ListAppend(my_pos_list,ValueList(Get_StandBy_Position2.Position_Code))>
        </cfoutput>
        <cfquery name="Get_StandBy_Position3" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek,2.Yedek Izinli ise ve 3.Yedek Izinli Degilse --->
            SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_3 IN (#my_pos_list#)
        </cfquery>
        <cfoutput query="Get_StandBy_Position3">
            <cfset my_pos_list = ListAppend(my_pos_list,ValueList(Get_StandBy_Position3.Position_Code))>
        </cfoutput>
    </cfif>

    <cfinclude template="../myhome/query/get_offtime.cfm">
    <cfif len(get_offtime.startdate)>
      <cfset start_=date_add('h',session.ep.time_zone,get_offtime.startdate)>
    <cfelse>
        <cfset start_="">
    </cfif>
    <cfif len(get_offtime.finishdate)>
      <cfset end_=date_add('h',session.ep.time_zone,get_offtime.finishdate)>
    <cfelse>
        <cfset end_="">
    </cfif>
    <cfif len(get_offtime.work_startdate)>
      <cfset work_startdate=date_add('h',session.ep.time_zone,get_offtime.work_startdate)>
    <cfelse>
         <cfset work_startdate="">
    </cfif>
</cfif>

<script type="text/javascript">
//Event : list
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
document.getElementById('keyword').focus();
	function confirm_control(x,w)
	{
		var check_list = "0";
		if(w == "")
		{
			for (i=0; i < document.getElementsByName("warning_ids").length; i++)
			{
				if(document.getElementsByName("warning_ids")[i].checked == true)
					check_list = check_list + "," + document.getElementsByName("warning_ids")[i].value;
			}
		}
		else
			check_list = w;
		
		document.getElementById("valid_ids").value = "";
		document.getElementById("refusal_ids").value = "";
		if(x == 1)
			document.getElementById("valid_ids").value = check_list;
		else
			document.getElementById("refusal_ids").value = check_list;
		
		document.getElementById("upd_warnings_active").submit();
		return false;
	}
	function uyari_kontrol()
	{
		is_secili = 0;
		if(document.upd_warnings_active.warning_ids.length != undefined) /*n tane*/
		{	
			for (i=0; i < document.upd_warnings_active.warning_ids.length; i++)
			{
				if((document.upd_warnings_active.warning_ids[i].checked==true))
					is_secili = 1;
			}
		}
		else /*1 tane*/
		{			
			if((document.upd_warnings_active.warning_ids.checked==true))
				is_secili = 1;
		}
		
		if(is_secili==0)
		{
			alert('Uyarı Seçmelisiniz!');
			return false;
		}
		else
		{
			document.upd_warnings_active.submit();
			return false;
		}
	}
	function warning_redirect(x,url,warning_id,is_popup,sub_w_id,comp_id,per_id,enc_warning_id,enc_sub_w_id)
	{
		if((comp_id != '' && comp_id != <cfoutput>#session.ep.company_id#</cfoutput>) || (per_id != '' && per_id != <cfoutput>#session.ep.period_id#</cfoutput>))
		{
			alert("<cf_get_lang no ='959.Bulunduğunuz Dönem ve Şirket Uyarıyı Görmeniz İçin Uygun Değil'>!");
			return false;
		}	
		<cfif attributes.fuseaction contains 'popup'>
			if(is_popup==1) 
				windowopen(url,'page'); 
			else 
				window.opener.location.href = url;
				
			var is_close_ = "&is_close=1";
		<cfelse>
			if(is_popup==1) 
				windowopen(url,'page'); 
			else 
				window.open(url,"_blank");
				
			var is_close_ = "";
		</cfif>
		
		//window.location.href='<cfoutput>#request.self#?fuseaction=myhome.popup_list_warning&is_active_id=</cfoutput>' + warning_id +'&is_close=1';
		window.location.href='<cfoutput>#request.self#?fuseaction=#attributes.fuseaction##url_str#&is_active_id=</cfoutput>' + warning_id + is_close_;
		
		if(x == 0)//İlgili Onay Kutusu Aciliyor
			windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_dsp_warning&warning_id=</cfoutput>' + enc_warning_id+'<cfif page_type neq 1>&warning_is_active=0</cfif>&sub_warning_id='+enc_sub_w_id ,'medium');
	}
</cfif>

</script>


<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_confirms';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/popup_list_warning.cfm';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'myhome.list_confirms';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'myhome/form/form_upd_other_offtime.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = '';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = '';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.offtime_id##';
	
	
</cfscript>

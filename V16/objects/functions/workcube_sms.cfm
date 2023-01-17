<!---
	by : TolgaS 20080906
	notes : workcube sms ile ilgili fonksiyonlar
--->
<cffunction name="wrk_form_sms_template" returntype="string" output="true">
<!---
	by : TolgaS 20080906
	notes : bu form şekli kampanya ve ayarlarda olduğundan birine eklendiğinde öteki unutulmaması için 
	usage :
		wrk_form_sms_template(sms_body: '',is_camp:1);
	--->
	<cfargument name="sms_body" type="string" default="">
    <cfargument name="is_camp" type="numeric" default="0"><!--- kampanyadan geliyor ise gösterilmek istenmeyen değişkenler ayarlanır --->
    <td valign="top"><cf_get_lang_main no='1198 .SMS İçeriği'>*</td>
	<td><textarea name="sms_body" id="sms_body" style="width:250px;height:75px;" cols="40" rows="6" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"><cfoutput>#arguments.sms_body#</cfoutput></textarea></td>
    <td><input type="button" name="add_var" id="add_var" value="<< " onclick="document.getElementById('sms_body').value=document.getElementById('sms_body').value+document.getElementById('add_variable').options[document.getElementById('add_variable').selectedIndex].value"> </td>
    <td>
        <select name="add_variable" id="add_variable" style="width:200px;height:75px;" multiple="multiple">
            <option value="[VAR_COMPANY_NAME]"><cf_get_lang_main no='1199.Üyenin Şirket Kısa Adı'></option>
            <option value="[VAR_MEMBER_NAME]"><cf_get_lang_main no='1200.Üyenin Çalışanı'></option>
            <option value="[VAR_CHEQUE_REMAINDER]"><cf_get_lang_main no='1201.Üye Çek Bakiyesi'></option>
            <option value="[VAR_VOUCHER_REMAINDER]"><cf_get_lang_main no='1202.Üye Senet Bakiyesi'></option>
            <option value="[VAR_MEMBER_REMAINDER]"><cf_get_lang_main no='1203.Üye Bakiyesi'></option>
           <cfif arguments.is_camp neq 1><option value="[VAR_PAPER_NUMBER]"><cf_get_lang_main no='1204.Belge Numarası'></option></cfif>
            <option value="[VAR_MY_COMPANY_NAME]"><cf_get_lang_main no='1205.Bulunduğunuz Şirket Adı'></option>
            <option value="[VAR_MY_NAME]"><cf_get_lang_main no='1206.SMS Yollayan Kişinin Adı Soyadı'></option>
        </select>
	</td>
</cffunction>

<cffunction name="wrk_sms_body_replace" returntype="string" output="false">
<!---
	by : TolgaS 20080906
	notes : sms şablonundaki değişkenleri temizler yerlerine olması gereken değerleri atar
	usage : wrk_sms_body_replace(sms_body:'',member_type:'company',member_id:321,paper_type:1,paper_id:3214);
	--->
	<cfargument name="sms_body" type="string" required="yes">
	<cfargument name="member_type" type="string" default="">
	<cfargument name="member_id" type="string" default="">
	<cfargument name="paper_type" type="string" default="">
	<cfargument name="paper_id" type="string" default="">
	<cfargument name="dsn_type" type="string" default="">
	<cfargument name="is_process" type="numeric" default="0">
	<cfif arguments.is_process>
		<cfscript>
			dsn=caller.dsn;
			dsn_alias=caller.dsn_alias;
			dsn1=caller.dsn1;
			dsn1_alias=caller.dsn1_alias;
			dsn2=caller.dsn2;
			dsn2_alias=caller.dsn2_alias;
			dsn3=caller.dsn3;
			dsn3_alias=caller.dsn3_alias;
			database_type=caller.database_type;
		</cfscript>
	</cfif>
	<cfif not len(arguments.dsn_type)><cfset arguments.dsn_type=dsn></cfif>

    <!--- üye bilgileri alınıyor --->
	<cfif arguments.member_type eq 'company'>
        <cfquery name="GET_MEMBER_SMS" datasource="#arguments.dsn_type#">
         SELECT 
             COMPANY_PARTNER.PARTNER_ID,
             <cfif database_type is 'DB2'>
                COMPANY_PARTNER.COMPANY_PARTNER_NAME||' '||COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS MEMBER_NAME,
             <cfelse>
                COMPANY_PARTNER.COMPANY_PARTNER_NAME+' '+COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS MEMBER_NAME,
            </cfif>
             COMPANY.COMPANY_ID,
             COMPANY.NICKNAME
           FROM 
             #dsn_alias#.COMPANY_PARTNER COMPANY_PARTNER,	
             #dsn_alias#.COMPANY COMPANY
        WHERE 
           COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#"> AND
           COMPANY_PARTNER.PARTNER_ID= COMPANY.MANAGER_PARTNER_ID
        </cfquery>
    <cfelseif arguments.member_type eq 'partner'>
        <cfquery name="GET_MEMBER_SMS" datasource="#arguments.dsn_type#">
         SELECT 
             COMPANY_PARTNER.PARTNER_ID,
             <cfif database_type is 'DB2'>
                COMPANY_PARTNER.COMPANY_PARTNER_NAME||' '||COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS MEMBER_NAME,
             <cfelse>
                COMPANY_PARTNER.COMPANY_PARTNER_NAME+' '+COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS MEMBER_NAME,
            </cfif>
             COMPANY.COMPANY_ID,
             COMPANY.NICKNAME
		FROM 
			#dsn_alias#.COMPANY_PARTNER COMPANY_PARTNER,	
			#dsn_alias#.COMPANY COMPANY
        WHERE 
           COMPANY.COMPANY_ID=COMPANY_PARTNER.COMPANY_ID AND
           COMPANY_PARTNER.PARTNER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#">
        </cfquery>
    <cfelseif arguments.member_type eq 'consumer'>
        <cfquery name="GET_MEMBER_SMS" datasource="#arguments.dsn_type#">
            SELECT
               CONSUMER_ID,
               CONSUMER_NAME,
               CONSUMER_SURNAME,
			   <cfif database_type is 'DB2'>
			   CONSUMER_NAME||' '||CONSUMER_SURNAME AS MEMBER_NAME,
			   <cfelse>
               CONSUMER_NAME+' '+CONSUMER_SURNAME AS MEMBER_NAME,
			   </cfif>
               '' NICKNAME
            FROM
				#dsn_alias#.CONSUMER CONSUMER
            WHERE 
                CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#">
        </cfquery>
    <cfelseif arguments.member_type eq 'employee'>
    	 <cfquery name="GET_MEMBER_SMS" datasource="#arguments.dsn_type#">
            SELECT
               EMPLOYEE_ID,
			   <cfif database_type is 'DB2'>
					EMPLOYEE_NAME||' '||EMPLOYEE_SURNAME AS MEMBER_NAME,
			   <cfelse>
					EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME AS MEMBER_NAME,
			   </cfif>
               '' NICKNAME
            FROM
				#dsn_alias#.EMPLOYEES EMPLOYEES
            WHERE 
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#">
        </cfquery>
    </cfif>
    
    <cfif find('[VAR_PAPER_NUMBER]',arguments.sms_body) and len(arguments.paper_type) and len(arguments.paper_id)>
        <!--- msjda [VAR_PAPER_NUMBER] değişkeni var ve belge tip ve id geldi ise belge bulunuyor --->
		<cfif arguments.paper_type eq 1><!--- SİPARİŞ --->
            <cfquery name="GET_PAPER" datasource="#arguments.dsn_type#">
                SELECT ORDER_ID PAPER_ID, ORDER_NUMBER PAPER_NUMBER FROM #dsn3_alias#.ORDERS ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paper_id#">
            </cfquery>
        <cfelseif arguments.paper_type eq 2><!--- İRSALİYE --->
            <cfquery name="GET_PAPER" datasource="#arguments.dsn_type#">
                SELECT SHIP_ID PAPER_ID, SHIP_NUMBER PAPER_NUMBER FROM #dsn2_alias#.SHIP SHIP WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paper_id#">
            </cfquery>
        <cfelseif arguments.paper_type eq 3><!--- FATURA --->
            <cfquery name="GET_PAPER" datasource="#arguments.dsn_type#">
                SELECT INVOICE_ID PAPER_ID, INVOICE_NUMBER PAPER_NUMBER FROM #dsn2_alias#.INVOICE INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paper_id#">
            </cfquery>
        <cfelseif arguments.paper_type eq 4><!--- ÇEK --->
            <cfquery name="GET_PAPER" datasource="#arguments.dsn_type#">
                SELECT CHEQUE.CHEQUE_ID PAPER_ID,CHEQUE.CHEQUE_NO PAPER_NUMBER FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paper_id#">
            </cfquery>
        <cfelseif arguments.paper_type eq 5><!--- SENET --->
            <cfquery name="GET_PAPER" datasource="#arguments.dsn_type#">
                SELECT VOUCHER.VOUCHER_ID PAPER_ID, VOUCHER.VOUCHER_NO PAPER_NUMBER FROM #dsn2_alias#.VOUCHER VOUCHER WHERE VOUCHER.VOUCHER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paper_id#">
            </cfquery>
        <cfelseif arguments.paper_type eq 6><!--- CAĞRI MERKEZİ BAŞVURUSU --->
            <cfquery name="GET_PAPER" datasource="#arguments.dsn_type#">
                SELECT SERVICE_ID PAPER_ID, SERVICE_NO PAPER_NUMBER FROM #dsn_alias#.G_SERVICE G_SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paper_id#">
            </cfquery>
        <cfelseif arguments.paper_type eq 7><!--- SERVİS BAŞVURUSU --->
            <cfquery name="GET_PAPER" datasource="#arguments.dsn_type#">
                SELECT SERVICE_ID PAPER_ID, SERVICE_NO PAPER_NUMBER FROM #dsn3_alias#.SERVICE SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paper_id#">
            </cfquery>
        <cfelseif arguments.paper_type eq 8><!--- SİSTEM --->
            <cfquery name="GET_PAPER" datasource="#arguments.dsn_type#">
                SELECT SUBSCRIPTION_ID PAPER_ID, SUBSCRIPTION_NO PAPER_NUMBER FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paper_id#">
            </cfquery>	
        </cfif>
    </cfif>
    <cfif find('[VAR_CHEQUE_REMAINDER]',arguments.sms_body)>
        <cfquery name="GET_CHEQUE" datasource="#arguments.dsn_type#">
            SELECT SUM(CHEQUE_VALUE) CHEQUE_REMAINDER FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE_STATUS_ID IN(1,2) AND CHEQUE_DUEDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">
            <cfif arguments.member_type eq 'company'>
                AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MEMBER_SMS.COMPANY_ID#">
			<cfelseif arguments.member_type eq 'partner'>
                AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MEMBER_SMS.COMPANY_ID#">
            <cfelseif arguments.member_type eq 'consumer'>
                AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#">
            <cfelse>
                AND 1=0
            </cfif>
        </cfquery>
    </cfif>
    <cfif find('[VAR_VOUCHER_REMAINDER]',arguments.sms_body)>
        <cfquery name="GET_VOUCHER" datasource="#arguments.dsn_type#">
            SELECT SUM(VOUCHER_VALUE) VOUCHER_REMAINDER FROM #dsn2_alias#.VOUCHER VOUCHER WHERE VOUCHER_STATUS_ID IN(1,2) AND VOUCHER_DUEDATE <= #createodbcdatetime(now())#
            <cfif arguments.member_type eq 'company'>
                AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MEMBER_SMS.COMPANY_ID#">
			<cfelseif arguments.member_type eq 'partner'>
                AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MEMBER_SMS.COMPANY_ID#">
            <cfelseif arguments.member_type eq 'consumer'>
                AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#">
            <cfelse>
                AND 1=0
            </cfif>
        </cfquery>
    </cfif>
    
    <cfif find('[VAR_MEMBER_REMAINDER]',arguments.sms_body)>
        <cfif arguments.member_type eq 'partner' or arguments.member_type eq 'company'>
            <cfquery name="GET_REMAINDER" datasource="#arguments.dsn_type#">
               SELECT
					SUM(BORC-ALACAK) MEMBER_REMAINDER
				FROM
				(
					SELECT
						ACTION_VALUE AS BORC,
						0 AS ALACAK
					FROM
						#dsn2_alias#.CARI_ROWS
					WHERE
						(
							DUE_DATE <= CASE WHEN (ACTION_TYPE_ID NOT IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())# "> ELSE DUE_DATE END OR
							DUE_DATE IS NULL
						)
						AND (ACTION_DATE <= CASE WHEN (ACTION_TYPE_ID IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())# "> ELSE ACTION_DATE END)
						AND TO_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MEMBER_SMS.COMPANY_ID#">
					UNION ALL
					SELECT
						0 AS BORC,
						ACTION_VALUE AS ALACAK
					FROM
						#dsn2_alias#.CARI_ROWS
					WHERE
						(
							DUE_DATE <= CASE WHEN (ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())# "> ELSE DUE_DATE END OR
							DUE_DATE IS NULL
						)
						AND (ACTION_DATE <= CASE WHEN (ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())# "> ELSE ACTION_DATE END)
						AND FROM_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MEMBER_SMS.COMPANY_ID#">
				)T1
            </cfquery>
        <cfelseif arguments.member_type eq 'consumer'>
            <cfquery name="GET_REMAINDER" datasource="#arguments.dsn_type#">
               
			   SELECT
					SUM(BORC-ALACAK) MEMBER_REMAINDER
				FROM
				(
					SELECT
						ACTION_VALUE AS BORC,
						0 AS ALACAK
					FROM
						#dsn2_alias#.CARI_ROWS
					WHERE
						(
							DUE_DATE <= CASE WHEN (ACTION_TYPE_ID NOT IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())# "> ELSE DUE_DATE END OR
							DUE_DATE IS NULL
						)
						AND (ACTION_DATE <= CASE WHEN (ACTION_TYPE_ID IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())# "> ELSE ACTION_DATE END)
						AND TO_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MEMBER_SMS.CONSUMER_ID#">
					UNION ALL
					SELECT
						0 AS BORC,
						ACTION_VALUE AS ALACAK
					FROM
						#dsn2_alias#.CARI_ROWS
					WHERE
						(
							DUE_DATE <= CASE WHEN (ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())# "> ELSE DUE_DATE END OR
							DUE_DATE IS NULL
						)
						AND (ACTION_DATE <= CASE WHEN (ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())# "> ELSE ACTION_DATE END)
						AND FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MEMBER_SMS.CONSUMER_ID#">
				)T1
            </cfquery>	
        <cfelse>
            <cfset GET_REMAINDER.MEMBER_REMAINDER=0>
        </cfif>
    </cfif>
    
    <cfif find('[VAR_MY_COMPANY_NAME]',arguments.sms_body)>
        <cfquery name="GET_MY_COMPANY" datasource="#arguments.dsn_type#">
            SELECT NICK_NAME MY_COMPANY_NAME FROM #dsn_alias#.OUR_COMPANY OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>	
    </cfif>
    
    <cfif find('[VAR_MY_NAME]',arguments.sms_body)>
        <cfquery name="GET_MY_NAME" datasource="#arguments.dsn_type#">
            SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>	
    </cfif>
    
    <cfscript>
        sms_msg=arguments.sms_body;
        if(isdefined('GET_MEMBER_SMS') and find('[VAR_COMPANY_NAME]',sms_msg))//üye şirket ismi
            sms_msg=replace(sms_msg,'[VAR_COMPANY_NAME]','#GET_MEMBER_SMS.NICKNAME#','all');
        if(isdefined('GET_MEMBER_SMS') and find('[VAR_MEMBER_NAME]',sms_msg))//üye şirketi çalışan ismi
            sms_msg=replace(sms_msg,'[VAR_MEMBER_NAME]','#GET_MEMBER_SMS.MEMBER_NAME#','all');
        if(isdefined('GET_PAPER') and find('[VAR_PAPER_NUMBER]',sms_msg))//belge numarası
            sms_msg=replace(sms_msg,'[VAR_PAPER_NUMBER]','#GET_PAPER.PAPER_NUMBER#','all');
        if(isdefined('GET_CHEQUE') and find('[VAR_CHEQUE_REMAINDER]',sms_msg))//vadesi gelmiş çek tutarı
            sms_msg=replace(sms_msg,'[VAR_CHEQUE_REMAINDER]','#TLFormat(GET_CHEQUE.CHEQUE_REMAINDER)# #session.ep.money#','all');
        if(isdefined('GET_VOUCHER') and find('[VAR_VOUCHER_REMAINDER]',sms_msg))//vadesi gelmiş senet tutarı
            sms_msg=replace(sms_msg,'[VAR_VOUCHER_REMAINDER]','#TLFormat(GET_VOUCHER.VOUCHER_REMAINDER)# #session.ep.money#','all');
        if(isdefined('GET_REMAINDER') and find('[VAR_MEMBER_REMAINDER]',sms_msg))//vadesi gelmiş bakiye tutarı
            sms_msg=replace(sms_msg,'[VAR_MEMBER_REMAINDER]','#TLFormat(GET_REMAINDER.MEMBER_REMAINDER)# #session.ep.money#','all');
        if(isdefined('GET_MY_COMPANY') and find('[VAR_MY_COMPANY_NAME]',sms_msg))//bizim şirket ismi
            sms_msg=replace(sms_msg,'[VAR_MY_COMPANY_NAME]','#GET_MY_COMPANY.MY_COMPANY_NAME#','all');
        if(isdefined('GET_MY_NAME') and find('[VAR_MY_NAME]',sms_msg))//sms yollayanın adı
            sms_msg=replace(sms_msg,'[VAR_MY_NAME]','#GET_MY_NAME.EMPLOYEE_NAME# #GET_MY_NAME.EMPLOYEE_SURNAME#','all');	
    </cfscript>
	<cfreturn sms_msg>
</cffunction>

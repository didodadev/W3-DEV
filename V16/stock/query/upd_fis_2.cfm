<!---E.Y 22.08.2012 queryparam ifadeleri eklendi.--->
<cfquery name="GET_FIS_NUMBER" datasource="#DSN2#">
	SELECT 
		FIS_NUMBER,
		FIS_ID
	FROM 
		STOCK_FIS
	WHERE 
		FIS_NUMBER = '#FIS_NO#'
</cfquery>
<cfif attributes.rows_ eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='815.Ürün Seçiniz !'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>
	<cfabort>
</cfif>
<cfif get_fis_number.recordcount>
	<cfif get_fis_number.fis_id neq attributes.upd_id>
		<script type="text/javascript">
			alert("<cf_get_lang no='32.Fiş Numarasını Kontrol Ediniz !'>");
			window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
			//history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cf_date tarih = 'attributes.fis_DATE'>
<cfset attributes.fis_date_time = createdatetime(year(attributes.fis_date),month(attributes.fis_date),day(attributes.fis_date),attributes.fis_date_h,attributes.fis_date_m,0)>
<cfquery name="UPD_SALE" datasource="#DSN2#">
	UPDATE
		STOCK_FIS
	SET
		FIS_TYPE = #attributes.FIS_TYPE#,
		PROCESS_CAT = #attributes.PROCESS_CAT#,
		FIS_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FIS_NO#">,
 	  <cfif not listfind('110,115,119',attributes.fis_type)>
		DEPARTMENT_OUT = #attributes.department_out#,
		LOCATION_OUT = #attributes.location_out#,
		 <cfif listfind('111,112',attributes.fis_type)>
			DEPARTMENT_IN = NULL,
			LOCATION_IN = NULL,
		</cfif>
	  </cfif>
	  <cfif not listfind('111,112',attributes.fis_type)>
		DEPARTMENT_IN = #attributes.department_in#,
		LOCATION_IN = #attributes.location_in#,
		<cfif listfind('110,115,119',attributes.fis_type)>
			DEPARTMENT_OUT = NULL,
			LOCATION_OUT = NULL,
		</cfif>
       </cfif>
	  <cfif len(attributes.prod_order_number)>
	  	PROD_ORDER_NUMBER = #attributes.prod_order_number#,
		</cfif>	  
        <cfif attributes.member_type is 'partner' and len(attributes.member_name) and len(attributes.company_id)>
           PARTNER_ID = #attributes.partner_id#,
           COMPANY_ID = #attributes.company_id#,
           CONSUMER_ID = NULL,
           EMPLOYEE_ID = NULL,
        <cfelseif attributes.member_type is 'consumer' and len(attributes.member_name) and len(attributes.consumer_id)>
            PARTNER_ID = NULL,
            COMPANY_ID = NULL,
            CONSUMER_ID = #attributes.consumer_id#,
            EMPLOYEE_ID = NULL,
        <cfelseif attributes.member_type is 'employee' and len(attributes.member_name) and len(attributes.employee_id)>
            PARTNER_ID = NULL,
            COMPANY_ID = NULL,
            CONSUMER_ID = NULL,
            EMPLOYEE_ID = #attributes.employee_id#,
        </cfif>
        FIS_DATE = #attributes.FIS_DATE#,
		DELIVER_DATE = #attributes.fis_date_time#,
		REF_NO = <cfif isdefined("attributes.ref_no") and len(attributes.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#"><cfelse>NULL</cfif>,
		PROJECT_ID = <cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
        PROJECT_ID_IN = <cfif isdefined("attributes.project_id_in") and len(attributes.project_id_in) and len(attributes.project_head_in)>#attributes.project_id_in#<cfelse>NULL</cfif>,
		IS_PRODUCTION = <cfif isDefined("attributes.is_productions") and attributes.is_productions eq 1>1<cfelse>0</cfif>,
		UPDATE_DATE = #now()#,
		IS_COST=0,<!--- dagilimlar silindiğiden 0 set ediyoruz--->
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		FIS_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
		WORK_ID = <cfif isdefined('attributes.work_id') and len(attributes.work_id) and isdefined('attributes.work_head') and len(attributes.work_head)>#attributes.work_id#<cfelse>NULL</cfif>,
        SERVICE_ID = <cfif isdefined("attributes.service_id") and len(attributes.service_id)>#attributes.service_id#<cfelse>NULL</cfif>,
        SUBSCRIPTION_ID = <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isdefined("attributes.subscription_no") and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>
	WHERE
		FIS_ID = #attributes.UPD_ID#
</cfquery>	
<cfquery name="DEL_STOCKS_ROW" datasource="#DSN2#">
	DELETE FROM STOCK_FIS_ROW WHERE FIS_ID = #attributes.UPD_ID#
</cfquery>
<cfscript>
	//butce dagili siliniyor ancak otomatik dagilim yok o yüzden tekrar oluşmayacak elle dagılım yapılıyor
	butce_sil(action_id:attributes.UPD_ID,is_stock_fis:1,muhasebe_db:dsn2);
</cfscript>

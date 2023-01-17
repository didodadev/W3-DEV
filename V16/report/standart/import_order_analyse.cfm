<cfparam name="attributes.is_foreign" default="">
<cfparam name="attributes.process_row_id" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam  name="attributes.is_excel" default="">

<cfquery name="get_stages" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%purchase.form_add_order%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfif isdefined("attributes.form_submitted")>
    <cfquery name="GET_ORDERS" datasource="#DSN#">
        SELECT 
            O.ORDER_ID,
            O.ORDER_NUMBER,
            O.ORDER_DATE,
            <!---CASE 
                WHEN O.CONSUMER_ID IS NOT NULL THEN 
                    C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME
                WHEN O.PARTNER_ID IS NOT NULL THEN
                    CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME
                WHEN O.EMPLOYEE_ID IS NOT NULL THEN
                    E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME
				WHEN O.COMPANY_ID IS NOT NULL THEN
                    CPY.NICKNAME            
            END AS
                NAME,--->
            CASE 
                WHEN O.CONSUMER_ID IS NOT NULL THEN 
                    C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME
                WHEN O.PARTNER_ID IS NOT NULL THEN
                    CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME
                WHEN O.EMPLOYEE_ID IS NOT NULL THEN
                    E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME          
            END AS
                NAME,
            CASE 
				WHEN O.COMPANY_ID IS NOT NULL THEN
                    CPY.NICKNAME 
                ELSE
                	''           
            END AS
                NAME2,
            O.ORDER_STAGE,
            O.CONSUMER_ID,
            O.EMPLOYEE_ID,
            O.PARTNER_ID,
            O.COMPANY_ID,
            #dsn#.Get_Dynamic_Language(PTR.PROCESS_ROW_ID,'#session.ep.language#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,PTR.STAGE) AS STAGE,
            K1.WAREHOUSE_ENTRY_DATE,
            K1.OUT_DATE,
            K1.DELIVERY_DATE,
            K1.SERVICE_COMPANY_ID,
            K1.INSURANCE_COMP_ID,
            K1.DUTY_COMP_ID,
            #dsn#.Get_Dynamic_Language(SM.SHIP_METHOD_ID,'#session.ep.language#','SHIP_METHOD','SHIP_METHOD',NULL,NULL,SM.SHIP_METHOD) AS SHIP_METHOD,
            ISNULL(K1.CARGO_NICKNAME,'<font color="FF0000">#getLang('','Nakliye Firması Atanmadı',65008)# !</font>') CARGO_NICKNAME,
            ISNULL(K1.INSURANCE_NICKNAME,'<font color="FF0000">#getLang('','Sigorta Yapılmadı',65009)# !</font>') INSURANCE_NICKNAME,
            ISNULL(K1.DUTY_NICKNAME,'<font color="FF0000">#getLang('','Gümrük Firması Atanmadı',65010)# !</font>') DUTY_NICKNAME,
            A.ASSETCAT_ID,
            OH.RECORD_DATE,
            O.IS_FOREIGN,
            PP.PROJECT_HEAD,
            PP.PROJECT_ID
        FROM 
            #dsn3_alias#.ORDERS O
                LEFT JOIN CONSUMER C ON O.CONSUMER_ID= C.CONSUMER_ID
                LEFT JOIN EMPLOYEES E ON O.EMPLOYEE_ID = E.EMPLOYEE_ID
                LEFT JOIN COMPANY CPY ON O.COMPANY_ID = CPY.COMPANY_ID
                LEFT JOIN COMPANY_PARTNER CP ON O.PARTNER_ID = CP.PARTNER_ID
                LEFT JOIN #dsn3_alias#.ORDERS_HISTORY OH ON O.ORDER_ID = OH.ORDER_ID AND OH.ORDER_STAGE = 44
                LEFT JOIN #dsn_alias#.SHIP_METHOD SM ON O.SHIP_METHOD = SM.SHIP_METHOD_ID
                LEFT JOIN ASSET A ON A.ACTION_ID = O.ORDER_ID AND A.ACTION_SECTION = 'ORDER_ID'
                LEFT JOIN PRO_PROJECTS PP ON O.PROJECT_ID = PP.PROJECT_ID
                LEFT JOIN (
                            SELECT 
                            	COM_CARGO.NICKNAME CARGO_NICKNAME,
                                COM_INSURANCE.NICKNAME INSURANCE_NICKNAME,
                                COM_DUTY.NICKNAME DUTY_NICKNAME,
                                SRR.SHIP_ID,
                                SR.WAREHOUSE_ENTRY_DATE,
								SR.OUT_DATE,
								SR.DELIVERY_DATE,
								SR.SERVICE_COMPANY_ID,
								SR.INSURANCE_COMP_ID,
								SR.DUTY_COMP_ID
                            FROM 
                                #dsn2_alias#.SHIP_RESULT SR
                                    LEFT JOIN COMPANY COM_CARGO ON SR.SERVICE_COMPANY_ID = COM_CARGO.COMPANY_ID
                                    LEFT JOIN COMPANY COM_INSURANCE ON SR.INSURANCE_COMP_ID = COM_INSURANCE.COMPANY_ID
                                    LEFT JOIN COMPANY COM_DUTY ON SR.DUTY_COMP_ID = COM_DUTY.COMPANY_ID,
                                #dsn2_alias#.SHIP_RESULT_ROW SRR
                            WHERE
                            	SR.SHIP_RESULT_ID = SRR.SHIP_RESULT_ID
	                        ) K1 ON K1.SHIP_ID = O.ORDER_ID,
                            
            PROCESS_TYPE_ROWS PTR
        WHERE
            O.ORDER_STAGE = PTR.PROCESS_ROW_ID AND 
            O.PURCHASE_SALES = 0 AND
            O.IS_FOREIGN = 1
            <cfif len(attributes.process_row_id)>
                AND PTR.PROCESS_ROW_ID IN (#attributes.process_row_id#)
            </cfif>
            <cfif len(attributes.start_date)>
                AND O.ORDER_DATE >= #attributes.start_date#
            </cfif>
            <cfif len(attributes.finish_date)>
                AND O.ORDER_DATE <= #attributes.finish_date#
            </cfif>
            <cfif len(attributes.project_id) and len(attributes.project_head)>
            	AND O.PROJECT_ID = #attributes.project_id#
            </cfif>
	</cfquery>
<cfelse>
	<cfset GET_ORDERS.recordcount = 0>	
</cfif> 

<cfif not isdefined("attributes.start_date")>
 	<cfset attributes.start_date = dateadd('ww',-1,now())> 
</cfif>
<cfif not isdefined("attributes.finish_date")>
	<cfset attributes.finish_date = wrk_get_today()>
</cfif>
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
  <cfset attributes.maxrows = session.ep.maxrows>
</cfif>
<cfparam name="attributes.totalrecords" default='#GET_ORDERS.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='39181.İthalat Sipariş Takip Raporu'></cfsavecontent>
<cf_report_list_search title="#title#">	
	<cf_report_list_search_area>
        <cfform name="order_detail_report" action="#request.self#?fuseaction=report.import_order_analyse" method="post">
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <input name="form_submitted" id="form_submitted" value="1" type="hidden">
                            <div class="col col-3 col-md-6 col-xs-12">

                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
									<div class="col col-12 col-xs-12">
                                         <cf_multiselect_check 
                                            query_name="get_stages"  
                                            name="process_row_id"
                                            width="130" 
                                            height="70"
                                            option_value="PROCESS_ROW_ID"
                                            option_name="stage" value="#attributes.process_row_id#">
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                    <div class="col col-12 col-xs-12">
									    <div class="input-group">
                                            <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
                                            <input name="project_head" type="text" id="project_head" style="width:110px;" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');" value="<cfoutput>#attributes.project_head#</cfoutput>" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=order_detail_report.project_head&project_id=order_detail_report.project_id</cfoutput>');"></span>  
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                        <cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" style="width:65px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>   
                                        <span class="input-group-addon no-bg"></span>
                                        <cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" style="width:65px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>   
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>				
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,999" required="yes" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
                            <cf_wrk_report_search_button search_function='control()' button_type='1' >
                        </div>
                    </div>
                </div>
            </div>
        </cfform>
    </cf_report_list_search_area>
</cf_report_list_search>
<cfif isdefined("attributes.form_submitted")>
    <cfif attributes.is_excel eq 1>
        <cfset filename="import_order_analyse#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
        <cfheader name="Expires" value="#Now()#">
        <cfcontent type="application/vnd.msexcel;charset=utf-16">
        <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
        <meta http-equiv="Content-Type" content="text/plain; charset=utf-16">
        <cfset attributes.startrow=1>
        <cfset attributes.maxrows=GET_ORDERS.recordcount>
    </cfif>
    <cf_report_list>      
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id="58211.Sip No"> </th>
                    <th><cf_get_lang dictionary_id="29501.Sipariş Tarihi"></th>
                    <th><cf_get_lang dictionary_id="57416.Proje"></th>
                    <th><cf_get_lang dictionary_id="57574.Şirket"> - <cf_get_lang dictionary_id="57578.Yetkili"></th>
                    <th><cf_get_lang dictionary_id="40555.Sipariş Durumu"></th>
                    <th>Lead Time</th>
                    <th><cf_get_lang dictionary_id="39434.Nakliye Firması"></th>
                    <th><cf_get_lang dictionary_id="29500.Sevk Yöntemi"></th>
                    <th><cf_get_lang dictionary_id='65011.ETD'></th> 
                    <th><cf_get_lang dictionary_id='65012.ETA'></th>
                    <th><cf_get_lang dictionary_id="39459.Sigorta Firması"></th>
                    <th><cf_get_lang dictionary_id="39460.Seri Durumu"></th>
                    <th><cf_get_lang dictionary_id="39462.Gümrük Firması"></th>
                    <th><cf_get_lang dictionary_id="39465.Depoya Giriş Tarihi"></th>
                </tr>
            </thead>
            <tbody>
                <cfif GET_ORDERS.recordcount>
                    <cfoutput query="GET_ORDERS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td><a href="#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#order_id#" class="tableyazi">#ORDER_NUMBER#</a></td>
                            <td>#dateformat(ORDER_DATE,dateformat_style)#</td>
                            <td><a class="tableyazi" href="#request.self#?fuseaction=project.projects&event=upd&id=#project_id#">#project_head#</a></td>
                            <td>
                                <cfif len(COMPANY_ID)>
                                    <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#','medium');">#NAME2#</a>-
                                </cfif>                            
                                <cfif len(PARTNER_ID)>
                                <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#PARTNER_ID#','medium');">#NAME#</a>
                                <cfelseif len(EMPLOYEE_ID)>
                                <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&EMP_ID=#RECORD_EMP#','medium');">#NAME#</a>
                                <cfelseif len(CONSUMER_ID)>
                                <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#CONSUMER_ID#','medium');">#NAME#</a>
                                </cfif>
                            </td>
                            <td>#STAGE#</td>
                            <td>#dateformat(WAREHOUSE_ENTRY_DATE,'dd/mm/yyyyy')#</td>
                            <td><cfif len(SERVICE_COMPANY_ID)><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#SERVICE_COMPANY_ID#','medium');"></cfif>#CARGO_NICKNAME#<cfif len(SERVICE_COMPANY_ID)></a></cfif></td>
                            <td>#SHIP_METHOD#</td>
                            <td>#dateformat(OUT_DATE,'dd/mm/yyyyy')#</td>
                            <td>#dateformat(DELIVERY_DATE,dateformat_style)#</td>
                            <td><cfif len(INSURANCE_COMP_ID)><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#INSURANCE_COMP_ID#','medium');"></cfif>#INSURANCE_NICKNAME#<cfif len(INSURANCE_COMP_ID)></a></cfif></td>
                            <td><cfif len(ASSETCAT_ID)><cf_get_lang dictionary_id="58564.Var"><cfelse><cf_get_lang dictionary_id="58546.Yok"></cfif></td>
                            <td><cfif len(DUTY_COMP_ID)><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#DUTY_COMP_ID#','medium');"></cfif>#DUTY_NICKNAME#<cfif len(DUTY_COMP_ID)></a></cfif></td>
                            <td>#dateformat(RECORD_DATE,dateformat_style)#</td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="15"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
                    </tr>
                </cfif>
            </tbody>    

    </cf_report_list>
</cfif>
<cfset adres = url.fuseaction>
<cfif isDefined('attributes.process_row_id') and len(attributes.process_row_id)>
  <cfset adres = '#adres#&process_row_id=#attributes.process_row_id#'>
</cfif>	
<cfif isDefined('attributes.start_date') and len(attributes.start_date)>
  <cfset adres = '#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
</cfif>	
<cfif isDefined('attributes.finish_date') and len(attributes.finish_date)>
  <cfset adres = '#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
</cfif>	
<cfif isDefined('attributes.is_foreign') and len(attributes.is_foreign)>
  <cfset adres = '#adres#&is_foreign=#attributes.is_foreign#'>
</cfif>	
<cfif len(attributes.project_id) and len(attributes.project_head)>
  <cfset adres = '#adres#&project_id=#attributes.project_id#&project_head=#attributes.project_head#'>
</cfif>	
<cf_paging 
	page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#adres#&form_submitted=1">
<script>
    function control()
	{
		if(datediff(document.getElementById('start_date').value,document.getElementById('finish_date').value) < 0)
        {
            alert("<cf_get_lang dictionary_id='40467.Başlangıç Tarihi Bitiş Tarihinden Büyük Olmamalıdır'>");
            return false;
        }
        if ((document.order_detail_report.start_date.value != '') && (document.order_detail_report.finish_date.value != '') &&
        !date_check(order_detail_report.start_date,order_detail_report.finish_date,"<cf_get_lang dictionary_id='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
             return false;
		
		if(document.order_detail_report.is_excel.checked==false)
			{
				document.order_detail_report.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.import_order_analyse"
				return true;
			}
			else{
				document.order_detail_report.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_import_order_analyse</cfoutput>"}
		
	}
</script>
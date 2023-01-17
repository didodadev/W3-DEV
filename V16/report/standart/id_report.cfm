<cfparam name="attributes.is_select" default="">
<cfparam  name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.is_excel" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search_asset" method="post" action="#request.self#?fuseaction=report.id_report">
    <cfsavecontent variable='title'><cf_get_lang dictionary_id='40411.İd Raporu'></cfsavecontent>
    <cf_report_list_search title="#title#">
        <cf_report_list_search_area>
           <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
						<div class="row" type="row">
                             <input type="hidden" name="form_submitted" id="form_submitted" value="1" />
                               <div class="col col-3 col-md-6 col-xs-12">
                                    <div class="form-group">
                                            <label class="col col-12 col-xs-12"> <cf_get_lang dictionary_id='57460.Filtre'></label>
                                            <div class="col col-12 col-xs-12">                                           
                                                <input type="text" name="keyword" id="keyword" maxlength="50" value="<cfoutput>#attributes.keyword#</cfoutput>">
                                            </div>
                                    </div>    
                                     <div class="form-group">
                                         <label class="col col-12 col-xs-12"> <cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
                                             <div class="col col-12 col-xs-12">
                                                    <select name="is_select" id="is_select" style="width:150px;">
                                                            <option value="1" <cfif isdefined("attributes.is_select") and attributes.is_select eq 1>selected</cfif>><cf_get_lang dictionary_id="57574.Şirket"></option>
                                                            <option value="2" <cfif isdefined("attributes.is_select") and attributes.is_select eq 2>selected</cfif>><cf_get_lang dictionary_id="57453.Şube"></option>
                                                            <option value="3" <cfif isdefined("attributes.is_select") and attributes.is_select eq 3>selected</cfif>><cf_get_lang dictionary_id="57572.Departman"></option>
                                                            <option value="4" <cfif isdefined("attributes.is_select") and attributes.is_select eq 4>selected</cfif>><cf_get_lang dictionary_id="59004.Pozisyon Tipi"></option>
                                                            <option value="5" <cfif isdefined("attributes.is_select") and attributes.is_select eq 5>selected</cfif>><cf_get_lang dictionary_id='57571.Ünvan'></option>
                                                            <option value="6" <cfif isdefined("attributes.is_select") and attributes.is_select eq 6>selected</cfif>><cf_get_lang dictionary_id='58701.Fonksiyon'></option>
                                                            <option value="7" <cfif isdefined("attributes.is_select") and attributes.is_select eq 7>selected</cfif>><cf_get_lang dictionary_id='58710.Kademe'></option>
                                                            <option value="8" <cfif isdefined("attributes.is_select") and attributes.is_select eq 8>selected</cfif>><cf_get_lang dictionary_id='53605.Ödenekler'></option>
                                                            <option value="9" <cfif isdefined("attributes.is_select") and attributes.is_select eq 9>selected</cfif>><cf_get_lang dictionary_id='38977.Kesintiler'></option>
                                                            <option value="10" <cfif isdefined("attributes.is_select") and attributes.is_select eq 10>selected</cfif>><cf_get_lang dictionary_id='53017.Vergi İstisnası'></option>
                                                            <option value="11" <cfif isdefined("attributes.is_select") and attributes.is_select eq 11>selected</cfif>><cf_get_lang dictionary_id='40694.İzin Kategorileri'></option>
                                                            <option value="12" <cfif isdefined("attributes.is_select") and attributes.is_select eq 12>selected</cfif>><cf_get_lang dictionary_id='30368.Çalışan'></option>
                                                            <option value="13" <cfif isdefined("attributes.is_select") and attributes.is_select eq 13>selected</cfif>><cf_get_lang dictionary_id='56155.Üniversiteler'></option>
                                                            <option value="14" <cfif isdefined("attributes.is_select") and attributes.is_select eq 14>selected</cfif>><cf_get_lang dictionary_id='56527.Üniversite Bölümleri'></option>
                                                            <option value="15" <cfif isdefined("attributes.is_select") and attributes.is_select eq 15>selected</cfif>><cf_get_lang dictionary_id='56154.Lise Bölümleri'></option>
                                                            <option value="16" <cfif isdefined("attributes.is_select") and attributes.is_select eq 16>selected</cfif>><cf_get_lang dictionary_id='42669.Eğitim Seviyeleri'></option>
                                                            <option value="17" <cfif isdefined("attributes.is_select") and attributes.is_select eq 17>selected</cfif>><cf_get_lang dictionary_id='57521.Banka'></option>
                                                            <option value="18" <cfif isdefined("attributes.is_select") and attributes.is_select eq 18>selected</cfif>><cf_get_lang dictionary_id='55188.Bölgeler'></option>
                                                            <option value="19" <cfif isdefined("attributes.is_select") and attributes.is_select eq 19>selected</cfif>><cf_get_lang dictionary_id='55312.Özlük Belgeleri'></option>
                                                            <option value="20" <cfif isdefined("attributes.is_select") and attributes.is_select eq 20>selected</cfif>><cf_get_lang dictionary_id='59124.Diller'></option>
                                                            <option value="21" <cfif isdefined("attributes.is_select") and attributes.is_select eq 21>selected</cfif>><cf_get_lang dictionary_id='43445.Şirket İçi Gerekçeler'></option>
                                                            <option value="22" <cfif isdefined("attributes.is_select") and attributes.is_select eq 22>selected</cfif>><cf_get_lang dictionary_id='59125.PDKS Durumu'></option>
                                                            <option value="23" <cfif isdefined("attributes.is_select") and attributes.is_select eq 23>selected</cfif>><cf_get_lang dictionary_id='44817.Ulaşım Yöntemleri'></option>
                                                            <option value="24" <cfif isdefined("attributes.is_select") and attributes.is_select eq 24>selected</cfif>><cf_get_lang dictionary_id='59127.Cv Kaynağı'></option>
                                                            <option value="25" <cfif isdefined("attributes.is_select") and attributes.is_select eq 25>selected</cfif>><cf_get_lang dictionary_id='59128.Ülkeler'></option>
                                                            <option value="26" <cfif isdefined("attributes.is_select") and attributes.is_select eq 26>selected</cfif>><cf_get_lang dictionary_id='59129.İller'></option>
                                                            <option value="27" <cfif isdefined("attributes.is_select") and attributes.is_select eq 27>selected</cfif>><cf_get_lang dictionary_id='59130.İlçeler'></option>
                                                            <option value="28" <cfif isdefined("attributes.is_select") and attributes.is_select eq 28>selected</cfif>><cf_get_lang dictionary_id='59131.Hedef Kategorileri'></option>
                                                            <option value="29" <cfif isdefined("attributes.is_select") and attributes.is_select eq 29>selected</cfif>><cf_get_lang dictionary_id='59132.Cari Hesap Tipleri'></option>
                                                            <option value="30" <cfif isdefined("attributes.is_select") and attributes.is_select eq 30>selected</cfif>><cf_get_lang dictionary_id='59133.Eğitim Mazeretleri'></option>
                                                            <option value="31" <cfif isdefined("attributes.is_select") and attributes.is_select eq 31>selected</cfif>><cf_get_lang dictionary_id='29912.Eğitimler'></option>
                                                            <option value="32" <cfif isdefined("attributes.is_select") and attributes.is_select eq 32>selected</cfif>><cf_get_lang dictionary_id='47256.Yeterlilikler'></option>
                                                            <option value="33" <cfif isdefined("attributes.is_select") and attributes.is_select eq 33>selected</cfif>><cf_get_lang dictionary_id='59134.Ödül Tipleri'></option>
                                                            <option value="34" <cfif isdefined("attributes.is_select") and attributes.is_select eq 34>selected</cfif>><cf_get_lang dictionary_id='59135.Disiplin Cezası Tipleri'></option>
                                                            <option value="35" <cfif isdefined("attributes.is_select") and attributes.is_select eq 35>selected</cfif>><cf_get_lang dictionary_id='47079.Çalışan Grupları'></option>
                                                    </select>
                                            </div>
                                </div>
                            </div>
                         </div>
                    </div>
                    <div class="row ReportContentBorder">
							<div class="ReportContentFooter">
                                <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">              
                                <cf_wrk_report_search_button search_function='control()' button_type='1' is_excel='1'>
                            </div>
                    </div>
                </div>
            </div>
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
        <cfset filename = "#createuuid()#">
        <cfheader name="Expires" value="#Now()#">
        <cfcontent type="application/vnd.msexcel;charset=utf-8">
        <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    	<cfif attributes.is_select eq 12>
			<cfset type_ = 0>
		<cfelse>
			<cfset type_ = 1>
        </cfif>
	<cfelse>
		<cfset type_ = 0>
	</cfif>
    <!-- sil --> 
<cfif isdefined("attributes.form_submitted")>
    <cf_report_list>
         	     	<!--- Şirket --->
                        <cfif attributes.is_select eq 1>
                            <cfquery name="GET_OUR" datasource="#dsn#">
                                SELECT DISTINCT 
                                    NICK_NAME,
                                    COMP_ID,
                                    COMP_STATUS 
                                FROM 
                                    OUR_COMPANY
                                WHERE
                                    (NICK_NAME LIKE '%#attributes.keyword#%' OR COMP_ID LIKE '%#attributes.keyword#%')
                                    <cfif not session.ep.ehesap>
                                        AND COMP_ID IN (SELECT DISTINCT B.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH B ON B.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
                                    </cfif>
                                ORDER BY
                                    COMP_ID     
                            </cfquery>
                            <thead>
                                 <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_id="57574.Şirket"></th>
                                    <th><cf_get_lang dictionary_id="30642.Şirket id"></th>
                                    <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#get_our.recordcount#">
                        </cfif>
                        <!--- Şube --->
                        <cfif attributes.is_select eq 2>
                            <cfquery name="get_branch" datasource="#dsn#">
                                SELECT DISTINCT 
                                    B.BRANCH_ID,
                                    B.BRANCH_NAME,
                                    B.HIERARCHY,
                                    B.HIERARCHY2,
                                    B.BRANCH_STATUS,
                                    OC.COMPANY_NAME
                                FROM 
                                    BRANCH B
                                    LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
                                WHERE
                                    (B.BRANCH_NAME LIKE '%#attributes.keyword#%' OR B.BRANCH_ID LIKE '%#attributes.keyword#%')
                                    <cfif not session.ep.ehesap>
                                        AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
                                    </cfif>
                                ORDER BY
                                    B.BRANCH_ID     
                            </cfquery>
                            <thead>
                                 <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_id="57453.Şube"></th>
                                    <th><cf_get_lang dictionary_id="59137.Şube İd"></th>
                                    <th><cf_get_lang dictionary_id="57761.Hiyerarşi">1</th>
                                    <th><cf_get_lang dictionary_id="57761.Hiyerarşi">2</th>
                                    <th><cf_get_lang dictionary_id="57574.Şirket"></th>
                                    <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                                </tr>
                            </thead>        
                            <cfparam name="attributes.totalrecords" default="#get_branch.recordcount#">
                        </cfif>
                        <!--- Departman --->
                        <cfif attributes.is_select eq 3>
                            <cfquery name="get_department" datasource="#dsn#">
                                SELECT DISTINCT 
                                    DEPARTMENT.DEPARTMENT_ID,
                                    DEPARTMENT.DEPARTMENT_HEAD,
                                    DEPARTMENT.BRANCH_ID,
                                    DEPARTMENT.HIERARCHY,
                                    DEPARTMENT.DEPARTMENT_STATUS,
                                    BRANCH.BRANCH_ID,
                                    BRANCH.BRANCH_NAME
                                FROM 
                                    DEPARTMENT JOIN BRANCH ON DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
                                WHERE
                                    (BRANCH_NAME LIKE '%#attributes.keyword#%' OR DEPARTMENT_ID LIKE '%#attributes.keyword#%' OR DEPARTMENT_HEAD LIKE '%#attributes.keyword#%')
                            </cfquery>
                            <thead>
                                 <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_id="29532.Şube Adı"></th>
                                    <th><cf_get_lang dictionary_id="59138.Departman Adı"></th>
                                    <th><cf_get_lang dictionary_id="59139.Departman İd"></th>
                                    <th><cf_get_lang dictionary_id="57761.Hiyerarşi"></th>
                                    <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#get_department.recordcount#">
                        </cfif>
                        <!--- Pozisyon Tipleri --->
                        <cfif attributes.is_select eq 4>
                            <cfquery name="get_position" datasource="#dsn#">
                                SELECT DISTINCT 
                                    SP.POSITION_CAT_ID,
                                    SP.POSITION_CAT,
                                    SP.COLLAR_TYPE,
                                    SP.POSITION_CAT_STATUS,
                                    ST.TITLE,
                                    SPC.HIERARCHY,
                                    SCU.UNIT_NAME,
                                    SOS.ORGANIZATION_STEP_NAME
                                FROM 
                                    SETUP_POSITION_CAT SP 
                                    LEFT JOIN SETUP_TITLE ST ON SP.TITLE_ID = ST.TITLE_ID
                                    LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = SP.POSITION_CAT_ID
                                    LEFT JOIN SETUP_CV_UNIT SCU ON SCU.UNIT_ID = SP.FUNC_ID
                                    LEFT JOIN SETUP_ORGANIZATION_STEPS SOS ON SOS.ORGANIZATION_STEP_ID = SP.ORGANIZATION_STEP_ID
                                WHERE
                                    (SP.POSITION_CAT LIKE '%#attributes.keyword#%' OR SP.POSITION_CAT_ID LIKE '%#attributes.keyword#%')     
                                ORDER BY
                                    SP.POSITION_CAT_ID     
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_id="59004.Pozisyon Tipi"></th>
                                    <th><cf_get_lang dictionary_id="59140.Pozisyon İd"></th>
                                    <th><cf_get_lang dictionary_id="57571.Ünvan"></th>
                                    <th><cf_get_lang dictionary_id="57761.Hiyerarşi"></th>
                                    <th><cf_get_lang dictionary_id="58701.Fonksiyon"></th>
                                    <th><cf_get_lang dictionary_id="58710.Kademe"></th>
                                    <th><cf_get_lang dictionary_id="38908.Yaka Tipi"></th>
                                   <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#get_position.recordcount#">
                        </cfif>
                        <!--- Ünvan --->
                        <cfif attributes.is_select eq 5>
                            <cfquery name="get_titles" datasource="#dsn#">
                                SELECT DISTINCT 
                                    TITLE_ID,
                                    TITLE,
                                    IS_ACTIVE
                                FROM 
                                    SETUP_TITLE
                                WHERE
                                    (TITLE LIKE '%#attributes.keyword#%' OR TITLE_ID LIKE '%#attributes.keyword#%')  
                                ORDER BY
                                    TITLE_ID     
                            </cfquery>
                            <thead>
                                 <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_id="59141.Ünvan ADI"></th>
                                    <th><cf_get_lang dictionary_id="59142.Ünvan ID"></th>
                                   <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#get_titles.recordcount#">
                        </cfif>
                        <!--- Fonksiyon --->
                        <cfif attributes.is_select eq 6>
                            <cfquery name="GET_CV" datasource="#dsn#">
                                SELECT DISTINCT 
                                    UNIT_ID,
                                    UNIT_NAME,
                                    IS_ACTIVE
                                FROM 
                                    SETUP_CV_UNIT
                                WHERE
                                    (UNIT_NAME LIKE '%#attributes.keyword#%' OR UNIT_ID LIKE '%#attributes.keyword#%') 
                                ORDER BY
                                    UNIT_ID     
                            </cfquery>
                            <thead>
                                 <tr>
                                     <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_id="59143.Fonksiyon Adı"></th>
                                    <th><cf_get_lang dictionary_id="59144.Fonksiyon Id"></th>
                                    <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#GET_CV.recordcount#">
                        </cfif>
                        <!--- Kademe --->
                        <cfif attributes.is_select eq 7>
                            <cfquery name="get_step" datasource="#dsn#">
                                SELECT DISTINCT 
                                    ORGANIZATION_STEP_ID,
                                    ORGANIZATION_STEP_NAME 
                                FROM 
                                    SETUP_ORGANIZATION_STEPS
                                WHERE
                                    (ORGANIZATION_STEP_NAME LIKE '%#attributes.keyword#%' OR ORGANIZATION_STEP_ID LIKE '%#attributes.keyword#%')   
                                ORDER BY
                                    ORGANIZATION_STEP_ID     
                            </cfquery>
                            <thead>
                                 <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_id="59145.Kademe Adı"></th>
                                    <th><cf_get_lang dictionary_id="59146.Kademe İd"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#get_step.recordcount#">
                        </cfif>
                        <!--- Ödenek --->
                        <cfif attributes.is_select eq 8>
                            <cfquery name="get_payment" datasource="#dsn#">
                                SELECT DISTINCT 
                                    COMMENT_PAY,
                                    IS_ODENEK,
                                    STATUS,
                                    ODKES_ID 
                                FROM 
                                    SETUP_PAYMENT_INTERRUPTION 
                                WHERE 
                                    IS_ODENEK = 1
                                    AND (COMMENT_PAY LIKE '%#attributes.keyword#%' OR ODKES_ID LIKE '%#attributes.keyword#%')  
                                ORDER BY
                                    ODKES_ID     
                            </cfquery>
                            <thead>
                               <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_id='40073.Ödenek'> <cf_get_lang dictionary_id ='57897.Adı'></th>
                                    <th><cf_get_lang dictionary_id='40073.Ödenek'> <cf_get_lang dictionary_id='58527.ID'></th>
                                   <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#get_payment.recordcount#">
                        </cfif>
                        <!--- Kesinti --->
                        <cfif attributes.is_select eq 9>
                            <cfquery name="get_pay" datasource="#dsn#">
                                SELECT DISTINCT 
                                    COMMENT_PAY,
                                    IS_ODENEK,
                                    STATUS,
                                    ODKES_ID 
                                FROM 
                                    SETUP_PAYMENT_INTERRUPTION 
                                WHERE 
                                    IS_ODENEK = 0
                                    AND (COMMENT_PAY LIKE '%#attributes.keyword#%' OR ODKES_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    ODKES_ID     
                            </cfquery>
                            <thead>
                                  <tr>
                                        <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                        <th><cf_get_lang dictionary_id='39992.Kesinti'> <cf_get_lang dictionary_id ='57897.Adı'></th>
                                        <th><cf_get_lang dictionary_id='39992.Kesinti'> <cf_get_lang dictionary_id='58527.ID'></th>
                                        <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                                    </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#get_pay.recordcount#">
                        </cfif>
                        <!--- Vergi İstisnası --->
                        <cfif attributes.is_select eq 10>
                            <cfquery name="get_tax" datasource="#dsn#">
                                SELECT DISTINCT 
                                    TAX_EXCEPTION,
                                    TAX_EXCEPTION_ID,
                                    STATUS                               
                                FROM 
                                    TAX_EXCEPTION
                                WHERE
                                    (TAX_EXCEPTION LIKE '%#attributes.keyword#%' OR TAX_EXCEPTION_ID LIKE '%#attributes.keyword#%')                   
                                ORDER BY
                                    TAX_EXCEPTION_ID     
                            </cfquery>
                            <thead>
                                <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                <th><cf_get_lang dictionary_id='53017.Vergi İstisnası'> <cf_get_lang dictionary_id ='57897.Adı'></th>
                                <th><cf_get_lang dictionary_id='53017.Vergi İstisnası'> <cf_get_lang dictionary_id='58527.ID'></th>
                                <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#get_tax.recordcount#">
                        </cfif>
                        <!--- İzin Kategorileri --->
                        <cfif attributes.is_select eq 11>
                            <cfquery name="get_offtime" datasource="#dsn#">
                                SELECT DISTINCT 
                                    OFFTIMECAT,
                                    OFFTIMECAT_ID,
                                    IS_ACTIVE,
                                    IS_PAID,
                                    IS_YEARLY,
                                    SIRKET_GUN,
                                    IS_KIDEM,
                                    IS_REQUESTED
                                FROM 
                                    SETUP_OFFTIME
                                WHERE
                                    (OFFTIMECAT LIKE '%#attributes.keyword#%' OR OFFTIMECAT_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    OFFTIMECAT_ID 
                            </cfquery>
                            <thead>
                                <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                <th><cf_get_lang dictionary_id="40694.İzin Kategorileri"><cf_get_lang dictionary_id="57897.Adı"></th>
                                <th><cf_get_lang dictionary_id="60712.İzin Kategorileri İstisnası"> <cf_get_lang dictionary_id='58527.ID'></th>
                                <th><cf_get_lang_main dictionary_Id="42462.Ücretli"></th>
                                <th><cf_get_lang_main dictionary_Id="43082.Yıllık İzin"></th>
                                <th><cf_get_lang_main dictionary_Id="43083.2 gününü Şirket Öder"></th>
                                <th><cf_get_lang dictionary_Id="44802.Kıdeme Dahil"></th>
                                <th><cf_get_lang dictionary_id="40722.Talep"><cf_get_lang dictionary_Id="32986.Edilebilir"></th>
                                <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                                <cfparam name="attributes.totalrecords" default="#get_offtime.recordcount#">
                            </thead>
                        </cfif>
                        <!--- Çalışan --->
                        <cfif attributes.is_select eq 12>
                            <cfquery name="get_emp" datasource="#dsn#">
                                SELECT 
                                    E.EMPLOYEE_NAME,
                                    E.EMPLOYEE_ID,
                                    E.EMPLOYEE_SURNAME,
                                    E.EMPLOYEE_STATUS,
                                    EP.POSITION_ID,
                                    EP.EMPLOYEE_ID,
                                    EIO.EMPLOYEE_ID,
                                    EIO.IN_OUT_ID,
                                    OC.COMPANY_NAME,
                                    B.BRANCH_FULLNAME,
                                    EP.POSITION_NAME,
                                    EID.TC_IDENTY_NO
                                FROM 
                                    EMPLOYEES E 
                                    JOIN EMPLOYEES_IDENTY EID ON EID.EMPLOYEE_ID = E.EMPLOYEE_ID
                                    JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
                                    JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID =  E.EMPLOYEE_ID
                                    JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                                    JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                                    JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
                                WHERE
                                    (E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%' OR E.EMPLOYEE_ID LIKE '%#attributes.keyword#%' OR EP.POSITION_ID LIKE '%#attributes.keyword#%' OR EIO.IN_OUT_ID LIKE '%#attributes.keyword#%') 
                                    <cfif not session.ep.ehesap>
                                        AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
                                        AND OC.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
                                    </cfif>
                                ORDER BY
                                	  E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME              
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_Id="44688.Çalışan Adı"></th>
                                    <th><cf_get_lang dictionary_Id="59140.Pozisyon Id"></th>
                                    <th><cf_get_lang dictionary_Id="53181.Giriş-Çıkış"><cf_get_lang dictionary_id="58527.Id"></th>
                                    <th><cf_get_lang dictionary_Id="39097.Profil"><cf_get_lang dictionary_id="58527.Id"></th>
                                    <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                                    <th><cf_get_lang dictionary_id="57574.Şirket"></th>
                                    <th><cf_get_lang dictionary_id="57453.Şube"></th>
                                    <th><cf_get_lang dictionary_id="58497.Pozisyon"></th>
                                    <th><cf_get_lang dictionary_Id="54265.TC NO"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#get_emp.recordcount#">
                        </cfif>
                        <!--- Üniversite --->
                        <cfif attributes.is_select eq 13>
                            <cfquery name="SCHOOLS" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    SETUP_SCHOOL
                                WHERE
                                    (SCHOOL_NAME LIKE '%#attributes.keyword#%' OR SCHOOL_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    SCHOOL_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_Id="56518.Üniversite Adı"></th>
                                    <th><cf_get_lang dictionary_id="29755.Üniversite"><cf_get_lang dictionary_id="58527.Id"></th>
                                    </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#SCHOOLS.recordcount#">
                        </cfif>
                        <!--- Üniversite Bölüm --->
                        <cfif attributes.is_select eq 14>
                            <cfquery name="univ_part" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    SETUP_SCHOOL_PART
                                WHERE
                                    (PART_NAME LIKE '%#attributes.keyword#%' OR PART_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    PART_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                        <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                        <th><cf_get_lang dictionary_id="29755.Üniversite"><cf_get_lang dictionary_Id="40788.Bölüm Adı"></th>
                                         <th><cf_get_lang dictionary_id="29755.Üniversite"><cf_get_lang dictionary_id="57995.Bölüm"><cf_get_lang dictionary_id="58527.Id"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#univ_part.recordcount#">
                        </cfif>
                        <!--- Lise Bölüm --->
                        <cfif attributes.is_select eq 15>
                            <cfquery name="highscholl_part" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    SETUP_HIGH_SCHOOL_PART
                                WHERE
                                    (HIGH_PART_NAME LIKE '%#attributes.keyword#%' OR HIGH_PART_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    HIGH_PART_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_Id="44283.Lise"> <cf_get_lang dictionary_Id="40788.Bölüm Adı"></th>
                                    <th><cf_get_lang dictionary_Id="44283.Lise"> <cf_get_lang dictionary_id="57995.Bölüm"> <cf_get_lang dictionary_id="58527.Id"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#highscholl_part.recordcount#">
                        </cfif>
                        <!--- Eğitim Seviyesi --->
                        <cfif attributes.is_select eq 16>
                            <cfquery name="ADD_REC" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    SETUP_EDUCATION_LEVEL
                                WHERE
                                    (EDUCATION_NAME LIKE '%#attributes.keyword#%' OR EDU_LEVEL_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    EDU_LEVEL_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_Id="39521.Eğitim seviyesi"></th>
                                    <th><cf_get_lang dictionary_id="58527.Id"></th>
                                    <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                            </tr>
                           </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_REC.recordcount#">
                        </cfif>
                        <!--- Banka --->
                        <cfif attributes.is_select eq 17>
                            <cfquery name="ADD_BANK" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    SETUP_BANK_TYPES
                                WHERE
                                    (BANK_NAME LIKE '%#attributes.keyword#%' OR BANK_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    BANK_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_Id="48695.Banka adı"></th>
                                    <th><cf_get_lang dictionary_Id="44711.Banka Id"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_BANK.recordcount#">
                        </cfif>
                        <!--- Bölge --->
                        <cfif attributes.is_select eq 18>
                            <cfquery name="ADD_ZONE" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    ZONE
                                WHERE
                                    (ZONE_NAME LIKE '%#attributes.keyword#%' OR ZONE_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    ZONE_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_id="57992.Bölge"><cf_get_lang dictionary_id="57897.Adı"></th>
                                    <th><cf_get_lang dictionary_id="57992.Bölge"><cf_get_lang dictionary_id="58527.Id"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_ZONE.recordcount#">
                        </cfif>
                        <!--- Özlük Belgeleri --->
                        <cfif attributes.is_select eq 19>
                            <cfquery name="ADD_ASSET_CAT" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    SETUP_EMPLOYMENT_ASSET_CAT
                                WHERE
                                    (ASSET_CAT LIKE '%#attributes.keyword#%' OR ASSET_CAT_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    ASSET_CAT_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_Id="43382.Özlük Belgesi"></th>
                                    <th><cf_get_lang dictionary_id='43382.Özlük Belge'> <cf_get_lang dictionary_id="58527.Id"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_ASSET_CAT.recordcount#">
                        </cfif>
                        <!--- Diller --->
                        <cfif attributes.is_select eq 20>
                            <cfquery name="ADD_LANGUAGE" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    SETUP_LANGUAGES
                                WHERE
                                    (LANGUAGE_SET LIKE '%#attributes.keyword#%' OR LANGUAGE_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    LANGUAGE_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_id="58996.Dil"><cf_get_lang dictionary_id="57897.Adı"></th>
                                    <th><cf_get_lang dictionary_id="58996.Dil"><cf_get_lang dictionary_id="58527.Id"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_LANGUAGE.recordcount#">
                        </cfif>
                        <!--- Şirket İçi Gerekçeler --->
                        <cfif attributes.is_select eq 21>
                            <cfquery name="ADD_REASONS" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    SETUP_EMPLOYEE_FIRE_REASONS
                                WHERE
                                    (REASON LIKE '%#attributes.keyword#%' OR REASON_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    REASON_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_Id="43445.Şirket İçi Gerekçeler"></th>
                                    <th><cf_get_lang dictionary_Id="43445.Şirket İçi Gerekçeler"><cf_get_lang dictionary_id="58527.Id"></th>
                                    <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_REASONS.recordcount#">
                        </cfif>
                        <!--- PDKS Durumu --->
                        <cfif attributes.is_select eq 22>
                            <cfquery name="ADD_PDKS_TYPE" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    SETUP_PDKS_TYPES
                                WHERE
                                    (PDKS_TYPE LIKE '%#attributes.keyword#%' OR PDKS_TYPE_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    PDKS_TYPE_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_id="58009.PDKS"><cf_get_lang dictionary_id="57897.Adı"></th>
                                     <th><cf_get_lang dictionary_id="58009.PDKS"><cf_get_lang dictionary_id="58527.Id"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_PDKS_TYPE.recordcount#">
                        </cfif>
                        <!--- Ulaşım Türleri --->
                        <cfif attributes.is_select eq 23>
                            <cfquery name="ADD_TRANSPORT_TYPE" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    SETUP_TRANSPORT_TYPES
                                WHERE
                                    (TRANSPORT_TYPE LIKE '%#attributes.keyword#%' OR TRANSPORT_TYPE_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    TRANSPORT_TYPE_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_Id="45122.Ulaşım Yöntemi"><cf_get_lang dictionary_id="57897.Adı"></th>
                                     <th><cf_get_lang dictionary_Id="45122.Ulaşım Yöntemi"><cf_get_lang dictionary_id="58527.Id"></th>
                                    
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_TRANSPORT_TYPE.recordcount#">
                        </cfif>
                        <!--- Cv Kaynağı --->
                        <cfif attributes.is_select eq 24>
                            <cfquery name="ADD_CV" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    SETUP_CV_SOURCE
                                WHERE
                                    (SOURCE_HEAD LIKE '%#attributes.keyword#%' OR CV_SOURCE_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    CV_SOURCE_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_id ="29767.CV"><cf_get_lang dictionary_id="57897.Adı"></th>
                                    <th><cf_get_lang dictionary_id ="29767.CV"><cf_get_lang dictionary_id="58527.Id"></th>
                                    <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_CV.recordcount#">
                        </cfif>
                        <!--- Fonksiyon --->
                        <cfif attributes.is_select eq 25>
                            <cfquery name="ADD_COUNTRY" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    SETUP_COUNTRY
                                WHERE
                                    (COUNTRY_NAME LIKE '%#attributes.keyword#%' OR COUNTRY_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    COUNTRY_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id ="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_id ="58219.Ülke"><cf_get_lang dictionary_id="57897.Adı"></th>
                                    <th><cf_get_lang dictionary_id ="58219.Ülke"><cf_get_lang dictionary_id="58527.ıd"></th>>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_COUNTRY.recordcount#">
                        </cfif>
                        <!--- İl --->
                        <cfif attributes.is_select eq 26>
                            <cfquery name="ADD_CITY" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    SETUP_CITY
                                WHERE
                                    (CITY_NAME LIKE '%#attributes.keyword#%' OR CITY_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    CITY_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_Id="43364.İl adı"></th>
                                    <th><cf_get_lang dictionary_id="58608.il"><cf_get_lang dictionary_id="58527.ıd"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_CITY.recordcount#">
                        </cfif>
                        <!--- İlçe --->
                        <cfif attributes.is_select eq 27>
                            <cfquery name="ADD_COUNTY" datasource="#dsn#">
                                SELECT
                                   SETUP_COUNTY.COUNTY_ID,
                                   SETUP_COUNTY.COUNTY_NAME,
                                   SETUP_CITY.CITY_NAME
                                FROM
                                    SETUP_COUNTY LEFT JOIN SETUP_CITY ON SETUP_CITY.CITY_ID = SETUP_COUNTY.CITY 
                                WHERE
                                    (COUNTY_NAME LIKE '%#attributes.keyword#%' OR COUNTY_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    COUNTY_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_Id="43364.İl adı"></th>
                                    <th><cf_get_lang dictionary_Id="43481.İlçe adı"></th>
                                    <th><cf_get_lang dictionary_id="58638.İlçe"><cf_get_lang dictionary_id="58527.ıd"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_COUNTY.recordcount#">
                        </cfif>
                        <!--- Hedef Kategorileri --->
                        <cfif attributes.is_select eq 28>
                            <cfquery name="ADD_TARGET_CAT" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    TARGET_CAT
                                WHERE
                                    (TARGETCAT_NAME LIKE '%#attributes.keyword#%' OR TARGETCAT_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    TARGETCAT_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_Id="59131.Hedef Kategorileri"><cf_get_lang dictionary_id="57897.adı"></th>
                                    <th><cf_get_lang dictionary_Id="59131.Hedef Kategorileri"><cf_get_lang dictionary_id="58527.ıd"></th>
                                <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                            </tr>
                           </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_TARGET_CAT.recordcount#">
                        </cfif>
                        <!--- Cari Hesap Tipleri --->
                        <cfif attributes.is_select eq 29>
                            <cfquery name="ADD_ACC" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    SETUP_ACC_TYPE
                                WHERE
                                    (ACC_TYPE_NAME LIKE '%#attributes.keyword#%' OR ACC_TYPE_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    ACC_TYPE_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_Id="59132.Cari Hesap Tipleri"><cf_get_lang dictionary_id="57897.Adı"></th>
                                    <th><cf_get_lang dictionary_Id="59132.Cari Hesap Tipleri"><cf_get_lang dictionary_id="58527.ıd"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_ACC.recordcount#">
                        </cfif>
                        <!--- Eğitim Mazeretleri --->
                        <cfif attributes.is_select eq 30>
                            <cfquery name="ADD_TRAINING" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    SETUP_TRAINING_EXCUSES
                                WHERE
                                    (EXCUSE_HEAD LIKE '%#attributes.keyword#%' OR TRAINING_EXCUSE_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    TRAINING_EXCUSE_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_Id="59133.Eğitim Mazeretleri"></th>
                                    <th><cf_get_lang dictionary_id="58527.ıd"></th>
                                    <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_TRAINING.recordcount#">
                        </cfif>
                        <!--- Eğitim --->
                        <cfif attributes.is_select eq 31>
                            <cfquery name="ADD_CLASS" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    TRAINING_CLASS
                                WHERE
                                    (CLASS_NAME LIKE '%#attributes.keyword#%' OR CLASS_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    CLASS_ID 
                            </cfquery>
                            <thead>
                            <tr>
                            <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                            <th><cf_get_lang dictionary_id="57419.Eğitim"><cf_get_lang dictionary_id="57897.Adı"></th>
                            <th><cf_get_lang dictionary_id="57419.Eğitim"><cf_get_lang dictionary_id="58527.ıd"></th>
                            <th><cf_get_lang dictionary_id="57742.tarih"></th>
                           <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                           </tr>
                           </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_CLASS.recordcount#">
                        </cfif>
                        <!--- Yeterlilik --->
                        <cfif attributes.is_select eq 32>
                            <cfquery name="ADD_REQ_TYPE" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    POSITION_REQ_TYPE
                                WHERE
                                    (REQ_TYPE LIKE '%#attributes.keyword#%' OR REQ_TYPE_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    REQ_TYPE_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_Id="55471.Yeterlilik"><cf_get_lang dictionary_id="57897.adı"></th>
                                    <th><cf_get_lang dictionary_Id="55471.Yeterlilik"><cf_get_lang dictionary_id="58527.ıd"></th>
                                    <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_REQ_TYPE.recordcount#">
                        </cfif>
                        <!--- Ödül Tipleri --->
                        <cfif attributes.is_select eq 33>
                            <cfquery name="ADD_PRIZE_TYPE" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    SETUP_PRIZE_TYPE
                                WHERE
                                    (PRIZE_TYPE LIKE '%#attributes.keyword#%' OR PRIZE_TYPE_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    PRIZE_TYPE_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_Id="53506.Ödül tipi"><cf_get_lang dictionary_id="57897.adı"> </th>
                                    <th><cf_get_lang dictionary_Id="53506.Ödül tipi"><cf_get_lang dictionary_id="58527.ıd"> </th>
                                    <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_PRIZE_TYPE.recordcount#">
                        </cfif>
                        <!--- Disiplin Cezaları --->
                        <cfif attributes.is_select eq 34>
                            <cfquery name="ADD_CAUTION_TYPE" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    SETUP_CAUTION_TYPE
                                WHERE
                                    (CAUTION_TYPE LIKE '%#attributes.keyword#%' OR CAUTION_TYPE_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    CAUTION_TYPE_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_Id="43318.Disiplin Cezası"><cf_get_lang dictionary_id="57897.adı"> </th>
                                    <th><cf_get_lang dictionary_Id="43318.Disiplin Cezası"><cf_get_lang dictionary_id="58527.ıd"></th>
                                    <th><cf_get_lang dictionary_id="58515.Aktif/Pasif"></th>
                                </tr>
                           </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_CAUTION_TYPE.recordcount#">
                        </cfif>
                        <!--- Çalışan Grupları --->
                        <cfif attributes.is_select eq 35>
                            <cfquery name="ADD_GROUP" datasource="#dsn#">
                                SELECT
                                   *
                                FROM
                                    EMPLOYEES_PUANTAJ_GROUP
                                WHERE
                                    (GROUP_NAME LIKE '%#attributes.keyword#%' OR GROUP_ID LIKE '%#attributes.keyword#%')
                                ORDER BY
                                    GROUP_ID 
                            </cfquery>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_id="57576.Çalışan"><cf_get_lang dictionary_id="58969.Grup Adı"></th>
                                   <th><cf_get_lang dictionary_id="47079.Çalışan Grup"> <cf_get_lang dictionary_id="58527.ıd"></th>
                                </tr>
                            </thead>
                            <cfparam name="attributes.totalrecords" default="#ADD_GROUP.recordcount#">
                        </cfif>
                    
                <tbody>
                    <cfif attributes.is_select eq 1>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = GET_OUR.recordcount>
                        </cfif>
                        <cfif GET_OUR.recordcount>
                            <cfoutput query="GET_OUR" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#NICK_NAME#</td>
                                    <td>#COMP_ID#</td>
                                    <td><cfif COMP_STATUS eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></th></cfif></td>
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 2>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = get_branch.recordcount>
                        </cfif>
                        <cfif get_branch.recordcount>
                            <cfoutput query="get_branch" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#branch_name#</td>
                                    <td>#branch_id#</td>
                                    <td>#hierarchy#</td>
                                    <td>#hierarchy2#</td>
                                    <td>#company_name#</td>
                                    <td><cfif BRANCH_STATUS eq 0>
                                    <cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="8"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 3>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = get_department.recordcount>
                        </cfif>
                        <cfif get_department.recordcount>
                            <cfoutput query="get_department" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#branch_name#</td>
                                    <td>#department_head#</td>
                                    <td>#department_id#</td>
                                    <td>#hierarchy#</td>
                                    <td><cfif DEPARTMENT_STATUS eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="6"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 4>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = get_position.recordcount>
                        </cfif>
                        <cfif get_position.recordcount>
                            <cfoutput query="get_position" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#POSITION_CAT#</td>
                                    <td>#POSITION_CAT_ID#</td>
                                    <td>#TITLE#</td>
                                    <td>#UNIT_NAME#</td>
                                    <td>#HIERARCHY#</td>
                                    <td>#ORGANIZATION_STEP_NAME#</td>
                                    <td><cfif collar_type eq 1><cf_get_lang dictionary_id='56065.Mavi Yaka'><cfelse><cf_get_lang dictionary_id='56066.Beyaz Yaka'></cfif></td>
                                    <td><cfif POSITION_CAT_STATUS eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="9"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 5>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = get_titles.recordcount>
                        </cfif>
                        <cfif get_titles.recordcount>
                            <cfoutput query="get_titles" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#TITLE#</td>
                                    <td>#TITLE_ID#</td>
                                    <td><cfif IS_ACTIVE eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 6>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = get_cv.recordcount>
                        </cfif>
                        <cfif get_cv.recordcount>
                            <cfoutput query="get_cv" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#UNIT_NAME#</td>
                                    <td>#UNIT_ID#</td>
                                    <td><cfif is_active eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif>
                    </cfif>
                    <cfif attributes.is_select eq 7>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = get_step.recordcount>
                        </cfif>
                        <cfif get_step.recordcount>
                            <cfoutput query="get_step" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#ORGANIZATION_STEP_NAME#</td>
                                    <td>#ORGANIZATION_STEP_ID#</td>
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="3"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 8>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = get_payment.recordcount>
                        </cfif>
                        <cfif get_payment.recordcount>
                            <cfoutput query="get_payment" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#COMMENT_PAY#</td>
                                    <td>#ODKES_ID#</td>
                                    <td><cfif status eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 9>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = get_pay.recordcount>
                        </cfif>
                        <cfif get_pay.recordcount>
                            <cfoutput query="get_pay" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#COMMENT_PAY#</td>
                                    <td>#ODKES_ID#</td>
                                    <td><cfif status eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 10>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = get_tax.recordcount>
                        </cfif>
                        <cfif get_tax.recordcount>
                            <cfoutput query="get_tax" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#TAX_EXCEPTION#</td>
                                    <td>#TAX_EXCEPTION_ID#</td>
                                    <td><cfif status eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 11>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = get_offtime.recordcount>
                        </cfif>
                        <cfif get_offtime.recordcount>
                            <cfoutput query="get_offtime" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#OFFTIMECAT#</td>
                                    <td>#OFFTIMECAT_ID#</td>
                                    <td><cfif IS_PAID eq 0><cf_get_lang dictionary_id='57496.Hayır'><cfelse><cf_get_lang dictionary_id='57495.Evet'></cfif></td>
                                    <td><cfif IS_YEARLY eq 0><cf_get_lang dictionary_id='57496.Hayır'><cfelse><cf_get_lang dictionary_id='57495.Evet'></cfif></td>
                                    <td><cfif SIRKET_GUN eq 0><cf_get_lang dictionary_id='57496.Hayır'><cfelse><cf_get_lang dictionary_id='57495.Evet'></cfif></td>
                                    <td><cfif IS_KIDEM eq 0><cf_get_lang dictionary_id='57496.Hayır'><cfelse><cf_get_lang dictionary_id='57495.Evet'></cfif></td>
                                    <td><cfif IS_REQUESTED eq 0><cf_get_lang dictionary_id='57496.Hayır'><cfelse><cf_get_lang dictionary_id='57495.Evet'></cfif></td>
                                    <td><cfif IS_ACTIVE eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="9"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 12>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfquery name="get_emp_temp" datasource="#dsn#">
                                SELECT
                                    ROW_NUMBER() OVER (ORDER BY E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME) AS 'Sıra',
                                    E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS 'AD_SOYAD',
                                    EP.POSITION_ID AS 'POZISYON_ID',
                                    EIO.IN_OUT_ID AS 'GIRIS_CIKIS_ID',
                                    E.EMPLOYEE_ID AS 'PROFIL_ID',
                                    CASE WHEN E.EMPLOYEE_STATUS = 1 THEN 'Aktif' ELSE 'Pasif' END AS 'Durum',
                                    OC.COMPANY_NAME AS 'SIRKET',
                                    B.BRANCH_FULLNAME AS 'SUBE',
                                    EP.POSITION_NAME AS 'POZISYON',
                                    EID.TC_IDENTY_NO AS 'TC_NO'                                    
                                FROM 
                                    EMPLOYEES E 
                                    JOIN EMPLOYEES_IDENTY EID ON EID.EMPLOYEE_ID = E.EMPLOYEE_ID
                                    JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
                                    JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID =  E.EMPLOYEE_ID
                                    JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                                    JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                                    JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
                                WHERE
                                    (E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%' OR E.EMPLOYEE_ID LIKE '%#attributes.keyword#%' OR EP.POSITION_ID LIKE '%#attributes.keyword#%' OR EIO.IN_OUT_ID LIKE '%#attributes.keyword#%')                   
                            </cfquery>
                            <cfset file_name = "id_raporu_calisan_#session.ep.userid#_#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#.xls">
                            <cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
                            <cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
                                <cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
                            </cfif>
                            <cfspreadsheet action="write" filename="#upload_folder#reserve_files#dir_seperator##drc_name_#/#file_name#" query="get_emp_temp" sheetname="ID Raporu Çalışan" overwrite="true"  />
                            <script type="text/javascript">
                                <cfoutput>
                                    get_wrk_message_div("Excel","Excel","documents/reserve_files/#drc_name_#/#file_name#");
                                </cfoutput>
                            </script>
                        </cfif>
                        <cfif get_emp.recordcount>
                            <cfoutput query="get_emp" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>                           
                                    <td>#position_id#</td>
                                    <td>#IN_OUT_ID#</td>
                                    <td>#employee_id#</td>
                                    <td><cfif EMPLOYEE_STATUS eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
                                    <td>#COMPANY_NAME#</td>
                                    <td>#branch_fullname#</td>
                                    <td>#position_name#</td>
                                    <td>#TC_IDENTY_NO#</td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="10"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 13>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = SCHOOLS.recordcount>
                        </cfif>
                        <cfif SCHOOLS.recordcount>
                            <cfoutput query="SCHOOLS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#SCHOOL_NAME#</td>                           
                                    <td>#SCHOOL_ID#</td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="3"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif>                     
                    </cfif>
                    <cfif attributes.is_select eq 14>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = univ_part.recordcount>
                        </cfif>
                        <cfif univ_part.recordcount>
                            <cfoutput query="univ_part" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#PART_NAME#</td>                           
                                    <td>#PART_ID#</td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="3"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 15>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = highscholl_part.recordcount>
                        </cfif>
                        <cfif highscholl_part.recordcount>
                            <cfoutput query="highscholl_part" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#HIGH_PART_NAME#</td>                           
                                    <td>#HIGH_PART_ID#</td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="3"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 16>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_REC.recordcount>
                        </cfif>
                        <cfif ADD_REC.recordcount>
                            <cfoutput query="ADD_REC" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#EDUCATION_NAME#</td>                           
                                    <td>#EDU_LEVEL_ID#</td>
                                    <td><cfif is_active eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 17>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_BANK.recordcount>
                        </cfif>
                        <cfif ADD_BANK.recordcount>
                            <cfoutput query="ADD_BANK" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#BANK_NAME#</td>                           
                                    <td>#BANK_ID#</td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="3"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 18>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_ZONE.recordcount>
                        </cfif>
                        <cfif ADD_ZONE.recordcount>
                            <cfoutput query="ADD_ZONE" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#ZONE_NAME#</td>                           
                                    <td>#ZONE_ID#</td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 19>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_ASSET_CAT.recordcount>
                        </cfif>
                        <cfif ADD_ASSET_CAT.recordcount>
                            <cfoutput query="ADD_ASSET_CAT" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#ASSET_CAT#</td>                           
                                    <td>#ASSET_CAT_ID#</td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="3"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 20>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_LANGUAGE.recordcount>
                        </cfif>
                        <cfif ADD_LANGUAGE.recordcount>
                            <cfoutput query="ADD_LANGUAGE" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#LANGUAGE_SET#</td>                           
                                    <td>#LANGUAGE_ID#</td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="3"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 21>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_REASONS.recordcount>
                        </cfif>
                        <cfif ADD_REASONS.recordcount>
                            <cfoutput query="ADD_REASONS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#REASON#</td>                           
                                    <td>#REASON_ID#</td>
                                    <td><cfif is_active eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 22>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_PDKS_TYPE.recordcount>
                        </cfif>
                        <cfif ADD_PDKS_TYPE.recordcount>
                            <cfoutput query="ADD_PDKS_TYPE" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#PDKS_TYPE#</td>                           
                                    <td>#PDKS_TYPE_ID#</td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="3"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 23>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_TRANSPORT_TYPE.recordcount>
                        </cfif>
                        <cfif ADD_TRANSPORT_TYPE.recordcount>
                            <cfoutput query="ADD_TRANSPORT_TYPE" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#TRANSPORT_TYPE#</td>                           
                                    <td>#TRANSPORT_TYPE_ID#</td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="3"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 24>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_CV.recordcount>
                        </cfif>
                        <cfif ADD_CV.recordcount>
                            <cfoutput query="ADD_CV" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#SOURCE_HEAD#</td>                           
                                    <td>#CV_SOURCE_ID#</td>
                                    <td><cfif is_active eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 25>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_COUNTRY.recordcount>
                        </cfif>
                        <cfif ADD_COUNTRY.recordcount>
                            <cfoutput query="ADD_COUNTRY" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#COUNTRY_NAME#</td>                           
                                    <td>#COUNTRY_ID#</td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 26>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_CITY.recordcount>
                        </cfif>
                        <cfif ADD_CITY.recordcount>
                            <cfoutput query="ADD_CITY" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#CITY_NAME#</td>                           
                                    <td>#CITY_ID#</td>
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="3"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 27>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_COUNTY.recordcount>
                        </cfif>
                        <cfif ADD_COUNTY.recordcount>
                            <cfoutput query="ADD_COUNTY" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#CITY_NAME#</td>
                                    <td>#COUNTY_NAME#</td>                           
                                    <td>#COUNTY_ID#</td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 28>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_TARGET_CAT.recordcount>
                        </cfif>
                        <cfif ADD_TARGET_CAT.recordcount>
                            <cfoutput query="ADD_TARGET_CAT" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#TARGETCAT_NAME#</td>                           
                                    <td>#TARGETCAT_ID#</td>
                                    <td><cfif is_active eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 29>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_ACC.recordcount>
                        </cfif>
                        <cfif ADD_ACC.recordcount>
                            <cfoutput query="ADD_ACC" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#ACC_TYPE_NAME#</td>                           
                                    <td>#ACC_TYPE_ID#</td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="3"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 30>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_TRAINING.recordcount>
                        </cfif>
                        <cfif ADD_TRAINING.recordcount>
                            <cfoutput query="ADD_TRAINING" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#EXCUSE_HEAD#</td>                           
                                    <td>#TRAINING_EXCUSE_ID#</td>
                                    <td><cfif is_active eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 31>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_CLASS.recordcount>
                        </cfif>
                        <cfif ADD_CLASS.recordcount>
                            <cfoutput query="ADD_CLASS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#CLASS_NAME#</td>                           
                                    <td>#CLASS_ID#</td>
                                    <td>#dateformat(start_date,dateformat_style)# / #dateformat(finish_date,dateformat_style)#</td>
                                    <td><cfif is_active eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="5"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 32>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_REQ_TYPE.recordcount>
                        </cfif>
                        <cfif ADD_REQ_TYPE.recordcount>
                            <cfoutput query="ADD_REQ_TYPE" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#REQ_TYPE#</td>                           
                                    <td>#REQ_TYPE_ID#</td>
                                    <td><cfif is_active eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 33>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_PRIZE_TYPE.recordcount>
                        </cfif>
                        <cfif ADD_PRIZE_TYPE.recordcount>
                            <cfoutput query="ADD_PRIZE_TYPE" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#PRIZE_TYPE#</td>                           
                                    <td>#PRIZE_TYPE_ID#</td>
                                    <td><cfif is_active eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 34>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_CAUTION_TYPE.recordcount>
                        </cfif>
                        <cfif ADD_CAUTION_TYPE.recordcount>
                            <cfoutput query="ADD_CAUTION_TYPE" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#CAUTION_TYPE#</td>                           
                                    <td>#CAUTION_TYPE_ID#</td>
                                    <td><cfif is_active eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                    <cfif attributes.is_select eq 35>
                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                            <cfset attributes.startrow=1>
                            <cfset attributes.maxrows = ADD_GROUP.recordcount>
                        </cfif>
                        <cfif ADD_GROUP.recordcount>
                            <cfoutput query="ADD_GROUP" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#GROUP_NAME#</td>                           
                                    <td>#GROUP_ID#</td>
                                    </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="3"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif> 
                    </cfif>
                </tbody>
    </cf_report_list>
    </cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfset url_str = "">
    <cfif len(attributes.keyword)>
        <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
    </cfif>
    <cfif len(attributes.is_select)>
    	<cfset url_str = "#url_str#&is_select=#attributes.is_select#">
    </cfif>
    <cfif len(attributes.form_submitted)>
        <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
    </cfif>
    <cf_paging 
        page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="report.id_report#url_str#">
</cfif>

<script>
    function control(){
		if(document.search_asset.is_excel.checked==false)
			{
				document.search_asset.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.id_report"
				return true;
			}
			else
				document.search_asset.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_id_report</cfoutput>"
	}
</script>

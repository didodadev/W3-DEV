<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.action_type_" default="">
<cfparam name="attributes.log_start_date" default="#dateadd('d',now(),-7)#">
<cfparam name="attributes.log_finish_date" default="#now()#">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.paper_no" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.stage" default=""> 
<cfif isdefined("attributes.form_varmi")>
	<cfif isdefined("attributes.log_start_date")>
		<cf_date tarih ="attributes.log_start_date">
	</cfif>
		<cfif isdefined("attributes.log_finish_date")>
		<cf_date tarih ="attributes.log_finish_date">
	</cfif>
	<cfquery name="GET_WRK_LOG" datasource="#DSN#">
		SELECT
			WRK_L.ACTION_ID,
			WRK_L.ACTION_NAME,
			WRK_L.FUSEACTION,
			WRK_L.EMPLOYEE_ID,
			WRK_L.LOG_TYPE,
			WRK_L.LOG_DATE,
			WRK_L.PERIOD_ID,
			WRK_L.PROCESS_TYPE,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
            WRK_L.PAPER_NO,
            PTR.STAGE
		FROM
			WRK_LOG WRK_L
           	 LEFT JOIN PROCESS_TYPE_ROWS PTR ON WRK_L.PROCESS_STAGE=PTR.PROCESS_ROW_ID,
			EMPLOYEES E
		WHERE
			WRK_L.EMPLOYEE_ID = E.EMPLOYEE_ID
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND (<cfif ISNUMERIC(attributes.keyword)>WRK_L.ACTION_ID = #attributes.keyword# OR</cfif> (WRK_L.ACTION_NAME LIKE '<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%' OR WRK_L.FUSEACTION LIKE '<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%'))
		</cfif>
		<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and len(attributes.employee)>
			AND E.EMPLOYEE_ID = #attributes.employee_id#
		</cfif>
        <cfif isdefined('attributes.stage') and len(attributes.stage) and len(attributes.stage)>
			AND PTR.PROCESS_ROW_ID = #attributes.stage#
		</cfif>
		<cfif attributes.action_type_ eq -1>AND WRK_L.LOG_TYPE = -1</cfif>
		<cfif attributes.action_type_ eq 0>AND WRK_L.LOG_TYPE = 0</cfif>
		<cfif attributes.action_type_ eq 1>AND WRK_L.LOG_TYPE = 1</cfif>
		<cfif isdefined('attributes.log_start_date') and isdate(attributes.log_start_date)>
			AND WRK_L.LOG_DATE >= #attributes.log_start_date#
		</cfif>
		<cfif isdefined('attributes.log_finish_date') and isdate(attributes.log_finish_date)>
			AND WRK_L.LOG_DATE <  #DATEADD("d",1,attributes.log_finish_date)#
		</cfif>
		 <cfif isdefined("attributes.process_type") and len(attributes.process_type)>
			AND WRK_L.PROCESS_TYPE = #attributes.process_type#
		</cfif>
        <cfif isdefined("attributes.paper_no") and len(attributes.paper_no)>
        	AND WRK_L.PAPER_NO LIKE '%#attributes.paper_no#%'
        </cfif>
		ORDER BY 
			WRK_L.LOG_DATE DESC
	</cfquery>
<cfelse> 
	<cfset get_wrk_log.recordcount = 0>
</cfif>
<cfquery name="GET_PROCESS" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID,
		PT.PROCESS_NAME,
		PT.PROCESS_ID
	FROM
		PROCESS_TYPE_ROWS PTR 
        LEFT JOIN PROCESS_TYPE PT ON PT.PROCESS_ID = PTR.PROCESS_ID
		LEFT JOIN PROCESS_TYPE_OUR_COMPANY PTO ON PT.PROCESS_ID = PTO.PROCESS_ID
	WHERE
		PT.IS_ACTIVE = 1 AND		
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY
		PT.PROCESS_NAME,
		PTR.LINE_NUMBER
</cfquery>
<cfparam name="attributes.totalrecords" default="#get_wrk_log.recordcount#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
    <cfset attributes.startrow=1>
    <cfset attributes.maxrows = get_wrk_log.recordcount>
</cfif>
<cfsavecontent variable="head"><cf_get_lang dictionary_id ='39579.Kayıt Tarihçe Raporu'></cfsavecontent>
<cfform name="order_form" method="post" action="#request.self#?fuseaction=report.list_log_files">
	<cf_report_list_search title="#head#">
        <cf_report_list_search_area>  
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
                                    <div class="col col-12 col-xs-12">
                                        <input name="form_varmi" id="form_varmi" type="hidden" value="1">
                                        <cfinput type="text" name="keyword" value="#attributes.keyword#" >
                                    </div>				
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cfinput type="text" name="paper_no" id="paper_no" value="#attributes.paper_no#">
                                    </div>				
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="stage" id="stage">
                                            <option value=""><cf_get_lang dictionary_id='58859.Süreç'></option>
                                            <cfoutput query="get_process" group="process_id">
                                                <optgroup label="#process_name#"></optgroup>
                                                <cfoutput>
                                                    <option value="#get_process.process_row_id#" <cfif Len(attributes.stage) and attributes.stage eq get_process.process_row_id>selected</cfif>>&nbsp;&nbsp;&nbsp;#get_process.stage#</option>
                                                </cfoutput>
                                            </cfoutput>
                                        </select>
                                    </div>				
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57576.Çalışan'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.employee") and len(attributes.employee)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                                            <input type="text" name="employee" id="employee" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.employee") and len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>" maxlength="255">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=order_form.employee_id&field_name=order_form.employee&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.order_form.employee.value),'list');"></span>
                                        </div>
                                    </div>				
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57800.İşlem Tipi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="process_type" id="process_type" style="width:205px;">
                                            <option selected value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                            <option value="70" <cfif isDefined('attributes.process_type') and attributes.process_type eq 70>selected</cfif>><cf_get_lang dictionary_id='29579.Perekande Satis Irsaliyesi'>(<cf_get_lang dictionary_id ='57431.Çıkış'>)</option>
                                            <option value="71" <cfif isDefined('attributes.process_type') and attributes.process_type eq 71>selected</cfif>><cf_get_lang dictionary_id='58752.Toptan Satis Irsaliyesi'>(<cf_get_lang dictionary_id ='57431.Çıkış'>)</option>
                                            <option value="72" <cfif isDefined('attributes.process_type') and attributes.process_type eq 72>selected</cfif>><cf_get_lang dictionary_id='58753.Konsinye Çikis Irsaliyesi'> (<cf_get_lang dictionary_id ='57431.Çıkış'>)</option>
                                            <option value="73" <cfif isDefined('attributes.process_type') and attributes.process_type eq 73>selected</cfif>><cf_get_lang dictionary_id='58754.Perakende Satış İade İrsaliyesi'>(<cf_get_lang dictionary_id ='57554.Giriş'>)</option>
                                            <option value="74" <cfif isDefined('attributes.process_type') and attributes.process_type eq 74>selected</cfif>><cf_get_lang dictionary_id ='29580.Toptan Satis Iade Irsaliyesi'>(<cf_get_lang dictionary_id ='57554.Giriş'>)</option>
                                            <option value="75" <cfif isDefined('attributes.process_type') and attributes.process_type eq 75>selected</cfif>><cf_get_lang dictionary_id='58755.Konsinye Çikis Iade Irsaliy'>(<cf_get_lang dictionary_id ='57554.Giriş'>)</option>
                                            <option value="76" <cfif isDefined('attributes.process_type') and attributes.process_type eq 76>selected</cfif>><cf_get_lang dictionary_id='29581.Mal Alım İrsaliyesi'>(<cf_get_lang dictionary_id ='57554.Giriş'>)</option>
                                            <option value="77" <cfif isDefined('attributes.process_type') and attributes.process_type eq 77>selected</cfif>><cf_get_lang dictionary_id='29583.Konsinye Giriş İrsaliyesi'>(<cf_get_lang dictionary_id ='57554.Giriş'>)</option>
                                            <option value="78" <cfif isDefined('attributes.process_type') and attributes.process_type eq 78>selected</cfif>><cf_get_lang dictionary_id='29584.Alim Iade Irsaliyesi'>(<cf_get_lang dictionary_id ='57431.Çıkış'>)</option>
                                            <option value="79" <cfif isDefined('attributes.process_type') and attributes.process_type eq 79>selected</cfif>><cf_get_lang dictionary_id='29585.Konsinye Giriş İade İrsaliyesi'>(<cf_get_lang dictionary_id ='57431.Çıkış'>)</option>
                                            <option value="80" <cfif isDefined('attributes.process_type') and attributes.process_type eq 80>selected</cfif>><cf_get_lang dictionary_id='29586.Müstahsil İrsaliyesi'>(<cf_get_lang dictionary_id ='57554.Giriş'>)</option>
                                            <option value="81" <cfif isDefined('attributes.process_type') and attributes.process_type eq 81>selected</cfif>><cf_get_lang dictionary_id='29587.Sevk İrsaliyesi'>(<cf_get_lang dictionary_id ='57554.Giriş'>-<cf_get_lang dictionary_id ='57431.Çıkış'>)</option>
                                            <option value="811" <cfif isDefined('attributes.process_type') and attributes.process_type eq 811>selected</cfif>><cf_get_lang dictionary_id='29588.İthal Mal Girişi'>(<cf_get_lang dictionary_id ='57554.Giriş'>)</option>
                                            <option value="761" <cfif isDefined('attributes.process_type') and attributes.process_type eq 761>selected</cfif>><cf_get_lang dictionary_id='29582.Hal İrsaliyesi'>(<cf_get_lang dictionary_id ='57554.Giriş'>)</option>
                                            <option value="82" <cfif isDefined('attributes.process_type') and attributes.process_type eq 82>selected</cfif>><cf_get_lang dictionary_id='29589.Demirbaş Alım İrsaliyesi'>(<cf_get_lang dictionary_id ='57554.Giriş'>)</option>
                                            <option value="83" <cfif isDefined('attributes.process_type') and attributes.process_type eq 83>selected</cfif>><cf_get_lang dictionary_id='29590.Demirbaş Satış İrsaliyesi'> (<cf_get_lang dictionary_id ='57431.Çıkış'>)</option>
                                            <option value="84" <cfif isDefined('attributes.process_type') and attributes.process_type eq 84>selected</cfif>><cf_get_lang dictionary_id ='40002.Gider Pusulası Mal'> (<cf_get_lang dictionary_id ='57554.Giriş'>)</option>
                                            <option value="10" <cfif isDefined('attributes.process_type') and attributes.process_type eq 10>selected</cfif>><cf_get_lang dictionary_id='58756.Açilis Fisi'>(<cf_get_lang dictionary_id='57447.Muhasebe'>)</option>
                                            <option value="11" <cfif isDefined('attributes.process_type') and attributes.process_type eq 11>selected</cfif>><cf_get_lang dictionary_id='58844.Tahsil Fisi'></option>
                                            <option value="12" <cfif isDefined('attributes.process_type') and attributes.process_type eq 12>selected</cfif>><cf_get_lang dictionary_id='58954.Tediye Fisi'></option>
                                            <option value="13" <cfif isDefined('attributes.process_type') and attributes.process_type eq 13>selected</cfif>><cf_get_lang dictionary_id ='58452.Mahsup Fisi'></option>
                                            <option value="14" <cfif isDefined('attributes.process_type') and attributes.process_type eq 14>selected</cfif>><cf_get_lang dictionary_id='29435.Özel Fis'></option>
                                            <option value="15" <cfif isDefined('attributes.process_type') and attributes.process_type eq 15>selected</cfif>><cf_get_lang dictionary_id ='40003.Kur Farki Fisi'></option>
                                            <option value="16" <cfif isDefined('attributes.process_type') and attributes.process_type eq 16>selected</cfif>><cf_get_lang dictionary_id='29451.Enflasyon Muhasebesi'></option>
                                            <option value="17" <cfif isDefined('attributes.process_type') and attributes.process_type eq 17>selected</cfif>><cf_get_lang dictionary_id ='58060.Virman'>(<cf_get_lang dictionary_id='57447.Muhasebe'>)</option>
                                            <option value="20" <cfif isDefined('attributes.process_type') and attributes.process_type eq 20>selected</cfif>><cf_get_lang dictionary_id='58756.Açilis Fisi'>(<cf_get_lang dictionary_id='57521.Banka'>)</option>
                                            <option value="21" <cfif isDefined('attributes.process_type') and attributes.process_type eq 21>selected</cfif>><cf_get_lang dictionary_id ='57692.Islem'>(<cf_get_lang dictionary_id ='40005.para yatirma'>)</option>
                                            <option value="22" <cfif isDefined('attributes.process_type') and attributes.process_type eq 22>selected</cfif>><cf_get_lang dictionary_id ='57692.Islem'>(<cf_get_lang dictionary_id ='40006.para çekme'>)</option>
                                            <option value="23" <cfif isDefined('attributes.process_type') and attributes.process_type eq 23>selected</cfif>><cf_get_lang dictionary_id ='58060.Virman'>(<cf_get_lang dictionary_id='57521.Banka'>)</option>
                                            <option value="24" <cfif isDefined('attributes.process_type') and attributes.process_type eq 24>selected</cfif>><cf_get_lang dictionary_id ='57834.Gelen Havale'></option>
                                            <option value="25" <cfif isDefined('attributes.process_type') and attributes.process_type eq 25>selected</cfif>><cf_get_lang dictionary_id ='57835.Giden Havale'></option>
                                            <option value="250" <cfif isDefined('attributes.process_type') and attributes.process_type eq 250>selected</cfif>><cf_get_lang dictionary_id ='40007.Banka Talimatı'></option>
                                            <option value="26" <cfif isDefined('attributes.process_type') and attributes.process_type eq 26>selected</cfif>><cf_get_lang dictionary_id='29558.Döviz Alış İşlemi'></option>
                                            <option value="27" <cfif isDefined('attributes.process_type') and attributes.process_type eq 27>selected</cfif>><cf_get_lang dictionary_id='29559.Döviz Satış İşlemi'></option>
                                            <option value="28" <cfif isDefined('attributes.process_type') and attributes.process_type eq 28>selected</cfif>><cf_get_lang dictionary_id ='57843.Gider Ödeme'></option>
                                            <option value="29" <cfif isDefined('attributes.process_type') and attributes.process_type eq 29>selected</cfif>><cf_get_lang dictionary_id='29557.Banka Masraf Fişi'></option>
                                            <option value="241" <cfif isDefined('attributes.process_type') and attributes.process_type eq 241>selected</cfif>><cf_get_lang dictionary_id ='57836.Kredi Kartı Tahsilat'></option>
                                            <option value="242" <cfif isDefined('attributes.process_type') and attributes.process_type eq 242>selected</cfif>><cf_get_lang dictionary_id ='57837.Kredi Kartı Ödeme'></option>
                                            <option value="31" <cfif isDefined('attributes.process_type') and attributes.process_type eq 31>selected</cfif>><cf_get_lang dictionary_id ='57845.Tahsilat'></option>
                                            <option value="310" <cfif isDefined('attributes.process_type') and attributes.process_type eq 310>selected</cfif>><cf_get_lang dictionary_id='29560.Toplu Tahsilat'></option>
                                            <option value="32" <cfif isDefined('attributes.process_type') and attributes.process_type eq 32>selected</cfif>><cf_get_lang dictionary_id='29561.Cari Ödeme'></option>
                                            <option value="33" <cfif isDefined('attributes.process_type') and attributes.process_type eq 33>selected</cfif>><cf_get_lang dictionary_id ='58060.Virman'>(<cf_get_lang dictionary_id='57520.Kasa'>)</option>
                                            <option value="34" <cfif isDefined('attributes.process_type') and attributes.process_type eq 34>selected</cfif>><cf_get_lang dictionary_id='29564.Mal Alım Faturası Kapama İşlemi'></option>
                                            <option value="35" <cfif isDefined('attributes.process_type') and attributes.process_type eq 35>selected</cfif>><cf_get_lang dictionary_id='29565.Mal Satış Faturası Kapama İşlemi'></option>
                                            <option value="36" <cfif isDefined('attributes.process_type') and attributes.process_type eq 36>selected</cfif>><cf_get_lang dictionary_id ='57843.Gider Ödeme'></option>
                                            <option value="37" <cfif isDefined('attributes.process_type') and attributes.process_type eq 37>selected</cfif>><cf_get_lang dictionary_id='29566.Kasa Masraf Fişi'></option>
                                            <option value="38" <cfif isDefined('attributes.process_type') and attributes.process_type eq 38>selected</cfif>><cf_get_lang dictionary_id='29558.Döviz Alış İşlemi'></option>
                                            <option value="39" <cfif isDefined('attributes.process_type') and attributes.process_type eq 39>selected</cfif>><cf_get_lang dictionary_id='29559.Döviz Satış İşlemi'></option>
                                            <option value="40" <cfif isDefined('attributes.process_type') and attributes.process_type eq 40>selected</cfif>><cf_get_lang dictionary_id='58756.Açilis Fisi'>(C/H)</option>
                                            <option value="41" <cfif isDefined('attributes.process_type') and attributes.process_type eq 41>selected</cfif>><cf_get_lang dictionary_id ='57849.Borç Dekontu'></option>
                                            <option value="42" <cfif isDefined('attributes.process_type') and attributes.process_type eq 42>selected</cfif>><cf_get_lang dictionary_id ='57848.Alacak Dekontu'></option>
                                            <option value="43" <cfif isDefined('attributes.process_type') and attributes.process_type eq 43>selected</cfif>><cf_get_lang dictionary_id ='40016.Virman Fisi'></option>
                                            <option value="50" <cfif isDefined('attributes.process_type') and attributes.process_type eq 50>selected</cfif>><cf_get_lang dictionary_id ='57827.Verilen Vade Farki Fat'>(<cf_get_lang dictionary_id ='57448.satış'>)</option>
                                            <option value="51" <cfif isDefined('attributes.process_type') and attributes.process_type eq 51>selected</cfif>><cf_get_lang dictionary_id ='57763.Alinan Vade Farki Fat'>(<cf_get_lang dictionary_id='58176.alış'>)</option>
                                            <option value="52" <cfif isDefined('attributes.process_type') and attributes.process_type eq 52>selected</cfif>><cf_get_lang dictionary_id ='57765.Perakende Sat Faturasi'>(<cf_get_lang dictionary_id ='57448.satış'>)</option>
                                            <option value="53" <cfif isDefined('attributes.process_type') and attributes.process_type eq 53>selected</cfif>><cf_get_lang dictionary_id ='57825.Toptan Sat Faturasi'>(<cf_get_lang dictionary_id ='57448.satış'>)</option>
                                            <option value="54" <cfif isDefined('attributes.process_type') and attributes.process_type eq 54>selected</cfif>><cf_get_lang dictionary_id ='57824.Per Sat Iade Faturasi'>(<cf_get_lang dictionary_id='58176.alış'>)</option>
                                            <option value="55" <cfif isDefined('attributes.process_type') and attributes.process_type eq 55>selected</cfif>><cf_get_lang dictionary_id ='57826.Topt Sat Iade Fatura'>(<cf_get_lang dictionary_id='58176.alış'>)</option>
                                            <option value="56" <cfif isDefined('attributes.process_type') and attributes.process_type eq 56>selected</cfif>><cf_get_lang dictionary_id ='57829.Verilen Hizmet Fat'>(<cf_get_lang dictionary_id ='57448.satış'>)</option>
                                            <option value="57" <cfif isDefined('attributes.process_type') and attributes.process_type eq 57>selected</cfif>><cf_get_lang dictionary_id ='57770.Verilen Proforma Fat'></option>
                                            <option value="58" <cfif isDefined('attributes.process_type') and attributes.process_type eq 58>selected</cfif>><cf_get_lang dictionary_id ='57830.Verilen Fiyat Farki Fat'>(<cf_get_lang dictionary_id ='57448.satış'>)</option>
                                            <option value="59" <cfif isDefined('attributes.process_type') and attributes.process_type eq 59>selected</cfif>><cf_get_lang dictionary_id ='57822.Mal Alim Faturasi'>(<cf_get_lang dictionary_id='58176.alış'>)</option>
                                            <option value="60" <cfif isDefined('attributes.process_type') and attributes.process_type eq 60>selected</cfif>><cf_get_lang dictionary_id ='57813.Alınan Hizmet Faturasi'> (<cf_get_lang dictionary_id='58176.alış'>)</option>
                                            <option value="61" <cfif isDefined('attributes.process_type') and attributes.process_type eq 61>selected</cfif>><cf_get_lang dictionary_id ='57814.Alınan Proforma Fat'></option>
                                            <option value="62" <cfif isDefined('attributes.process_type') and attributes.process_type eq 62>selected</cfif>><cf_get_lang dictionary_id ='57815.Alim Iade Fatura'>(<cf_get_lang dictionary_id ='57448.satış'>)</option>
                                            <option value="63" <cfif isDefined('attributes.process_type') and attributes.process_type eq 63>selected</cfif>><cf_get_lang dictionary_id ='57811.Alinan Fiyat Farki Fat'>(<cf_get_lang dictionary_id='58176.alış'>)</option>
                                            <option value="64" <cfif isDefined('attributes.process_type') and attributes.process_type eq 64>selected</cfif>><cf_get_lang dictionary_id ='57823.Müstahsil Makbuzu'> (<cf_get_lang dictionary_id='58176.alış'>)</option>
                                            <option value="65" <cfif isDefined('attributes.process_type') and attributes.process_type eq 65>selected</cfif>><cf_get_lang dictionary_id='29574.Demirbaş Alış Faturası'></option>
                                            <option value="66" <cfif isDefined('attributes.process_type') and attributes.process_type eq 66>selected</cfif>><cf_get_lang dictionary_id='29575.Demirbaş Satış Faturası'></option>
                                            <option value="67" <cfif isDefined('attributes.process_type') and attributes.process_type eq 67>selected</cfif>><cf_get_lang dictionary_id ='40019.Sube Toplu Satis Islemi'>(<cf_get_lang dictionary_id ='57448.satış'>)</option>
                                            <option value="68" <cfif isDefined('attributes.process_type') and attributes.process_type eq 68>selected</cfif>><cf_get_lang dictionary_id='29577.Serbest Meslek Makbuzu'>(<cf_get_lang dictionary_id='58176.alış'>)</option>
                                            <option value="85" <cfif isDefined('attributes.process_type') and attributes.process_type eq 85>selected</cfif>><cf_get_lang dictionary_id ='39206.Üreticiye Çıkış İrsaliyesi'>(<cf_get_lang dictionary_id ='57431.Çıkış'>)</option>
                                            <option value="86" <cfif isDefined('attributes.process_type') and attributes.process_type eq 86>selected</cfif>><cf_get_lang dictionary_id ='39207.Üreticiden Giriş İrsaliyesi'>(<cf_get_lang dictionary_id ='57554.Giriş'>)</option>
                                            <option value="690" <cfif isDefined('attributes.process_type') and attributes.process_type eq 690>selected</cfif>><cf_get_lang dictionary_id ='40002.Gider Pusulası Mal'> (<cf_get_lang dictionary_id='58176.alış'>)</option>
                                            <option value="691" <cfif isDefined('attributes.process_type') and attributes.process_type eq 691>selected</cfif>><cf_get_lang dictionary_id='57818.Gider Pusulası Hizmet'> (<cf_get_lang dictionary_id='58176.alış'>)</option>
                                            <option value="591" <cfif isDefined('attributes.process_type') and attributes.process_type eq 591>selected</cfif>><cf_get_lang dictionary_id ='57820.İthalat Faturası'>(<cf_get_lang dictionary_id='58176.alış'>)</option>	
                                            <option value="592" <cfif isDefined('attributes.process_type') and attributes.process_type eq 592>selected</cfif>><cf_get_lang dictionary_id ='57819.Hal Faturası'>(<cf_get_lang dictionary_id='58176.alış'>)</option>
                                            <option value="531" <cfif isDefined('attributes.process_type') and attributes.process_type eq 531>selected</cfif>><cf_get_lang dictionary_id ='57821.İhracat Faturası'>(<cf_get_lang dictionary_id ='57448.satış'>)</option>
                                            <option value="90" <cfif isDefined('attributes.process_type') and attributes.process_type eq 90>selected</cfif>><cf_get_lang dictionary_id ='57852.Çek Giris Bordrosu'></option>
                                            <option value="91" <cfif isDefined('attributes.process_type') and attributes.process_type eq 91>selected</cfif>><cf_get_lang dictionary_id ='30089.Çek Çikis Bordrosu'>(c/h a)</option>
                                            <option value="92" <cfif isDefined('attributes.process_type') and attributes.process_type eq 92>selected</cfif>><cf_get_lang dictionary_id ='57853.Çek Çikis Bor(Kasa Tahsil)'></option>
                                            <option value="93" <cfif isDefined('attributes.process_type') and attributes.process_type eq 93>selected</cfif>><cf_get_lang dictionary_id ='29597.Çek Çikis Bor(Banka Tahsil)'></option>
                                            <option value="94" <cfif isDefined('attributes.process_type') and attributes.process_type eq 94>selected</cfif>><cf_get_lang dictionary_id='29595.Çek Çıkış İade Bordrosu'></option>
                                            <option value="95" <cfif isDefined('attributes.process_type') and attributes.process_type eq 95>selected</cfif>><cf_get_lang dictionary_id='29596.Çek Giriş İade Bordrosu'></option>
                                            <option value="96" <cfif isDefined('attributes.process_type') and attributes.process_type eq 96>selected</cfif>><cf_get_lang dictionary_id='29598.İşyerleri Arası Bordro(Müşteri Çekiyle)'></option>
                                            <option value="97" <cfif isDefined('attributes.process_type') and attributes.process_type eq 97>selected</cfif>><cf_get_lang dictionary_id ='58010.Senet Giris Bordrosu'></option>
                                            <option value="98" <cfif isDefined('attributes.process_type') and attributes.process_type eq 98>selected</cfif>><cf_get_lang dictionary_id ='58011.Senet Çikis Bordrosu'>(c/h a)</option>
                                            <option value="99" <cfif isDefined('attributes.process_type') and attributes.process_type eq 99>selected</cfif>><cf_get_lang dictionary_id='29600.Senet Çıkış Bordrosu-Banka Tahsil'></option>
                                            <option value="100" <cfif isDefined('attributes.process_type') and attributes.process_type eq 100>selected</cfif>><cf_get_lang dictionary_id='29600.Senet Çıkış Bordrosu-Banka Teminat'></option>
                                            <option value="101" <cfif isDefined('attributes.process_type') and attributes.process_type eq 101>selected</cfif>><cf_get_lang dictionary_id='29602.Senet Çıkış İade Bordrosu'></option>					  
                                            <option value="102" <cfif isDefined('attributes.process_type') and attributes.process_type eq 102>selected</cfif>><cf_get_lang dictionary_id ='40067.Senet Islem Bordrosu (Müsteri de Tahsil)'></option>	
                                            <option value="103" <cfif isDefined('attributes.process_type') and attributes.process_type eq 103>selected</cfif>><cf_get_lang dictionary_id='29598.İşyerleri Arası Bordro(Müşteri Çekiyle)'></option>
                                            <option value="105" <cfif isDefined('attributes.process_type') and attributes.process_type eq 105>selected</cfif>><cf_get_lang dictionary_id ='40078.Çek İade Giriş Banka'></option>	
                                            <option value="1040" <cfif isDefined('attributes.process_type') and attributes.process_type eq 1040>selected</cfif>><cf_get_lang dictionary_id='29606.Çek İşlemi Tahsil Kasaya'></option>	
                                            <option value="1041" <cfif isDefined('attributes.process_type') and attributes.process_type eq 1041>selected</cfif>><cf_get_lang dictionary_id='29607.Çek İşlemi Ödeme Kasadan'></option>	
                                            <option value="1042" <cfif isDefined('attributes.process_type') and attributes.process_type eq 1042>selected</cfif>><cf_get_lang dictionary_id='29608.Çek İşlemi Masraf Kasadan'></option>	
                                            <option value="1043" <cfif isDefined('attributes.process_type') and attributes.process_type eq 1043>selected</cfif>><cf_get_lang dictionary_id='29609.Çek İşlemi Tahsil Bankada'></option>	
                                            <option value="1044" <cfif isDefined('attributes.process_type') and attributes.process_type eq 1044>selected</cfif>><cf_get_lang dictionary_id='29610.Çek İşlemi Ödeme Bankadan'></option>	
                                            <option value="1045" <cfif isDefined('attributes.process_type') and attributes.process_type eq 1045>selected</cfif>><cf_get_lang dictionary_id='29611.Çek İşlemi Masraf Bankadan'></option>	
                                            <option value="1046" <cfif isDefined('attributes.process_type') and attributes.process_type eq 1046>selected</cfif>><cf_get_lang dictionary_id='29612.Çek İşlemi-Karşılıksız Çek'></option>	
                                            <option value="1050" <cfif isDefined('attributes.process_type') and attributes.process_type eq 1050>selected</cfif>><cf_get_lang dictionary_id='29613.Senet İşlemi Tahsil Kasaya'></option>	
                                            <option value="1051" <cfif isDefined('attributes.process_type') and attributes.process_type eq 1051>selected</cfif>><cf_get_lang dictionary_id='29617.Senet İşlemi Ödeme Kasadan'></option>	
                                            <option value="1052" <cfif isDefined('attributes.process_type') and attributes.process_type eq 1052>selected</cfif>><cf_get_lang dictionary_id='29615.Senet İşlemi Masraf Kasadan'></option>	
                                            <option value="1053" <cfif isDefined('attributes.process_type') and attributes.process_type eq 1053>selected</cfif>><cf_get_lang dictionary_id='29616.Senet İşlemi Tahsil Bankaya'></option>	
                                            <option value="1054" <cfif isDefined('attributes.process_type') and attributes.process_type eq 1054>selected</cfif>><cf_get_lang dictionary_id='29614.Senet İşlemi Ödeme Bankadan'></option>	
                                            <option value="1055" <cfif isDefined('attributes.process_type') and attributes.process_type eq 1055>selected</cfif>><cf_get_lang dictionary_id='29618.Senet İşlemi Masraf Bankadan'></option>	
                                            <option value="1056" <cfif isDefined('attributes.process_type') and attributes.process_type eq 1056>selected</cfif>><cf_get_lang dictionary_id='29619.Senet İşlemi Karşılıksız Senet'></option>
                                            <option value="1057" <cfif isDefined('attributes.process_type') and attributes.process_type eq 1057>selected</cfif>><cf_get_lang dictionary_id='29620.Senet Tahsilat İşlemi'></option>
                                            <option value="106" <cfif isDefined('attributes.process_type') and attributes.process_type eq 106>selected</cfif>><cf_get_lang dictionary_id='29621.Çek Açılış Devir'></option>
                                            <option value="107" <cfif isDefined('attributes.process_type') and attributes.process_type eq 107>selected</cfif>><cf_get_lang dictionary_id='29622.Senet Açılış Devir'></option>
                                            <option value="104" <cfif isDefined('attributes.process_type') and attributes.process_type eq 104>selected</cfif>><cf_get_lang dictionary_id='29605.Senet Çıkış Tahsil'></option>
                                            <option value="110" <cfif isDefined('attributes.process_type') and attributes.process_type eq 110>selected</cfif>><cf_get_lang dictionary_id ='29627.Üretimden Çıkış Fişi'></option>
                                            <option value="111" <cfif isDefined('attributes.process_type') and attributes.process_type eq 111>selected</cfif>><cf_get_lang dictionary_id='29628.Sarf Fişi'></option>
                                            <option value="112" <cfif isDefined('attributes.process_type') and attributes.process_type eq 112>selected</cfif>><cf_get_lang dictionary_id='29629.Fire Fişi'></option>
                                            <option value="113" <cfif isDefined('attributes.process_type') and attributes.process_type eq 113>selected</cfif>><cf_get_lang dictionary_id='29630.Ambar Fiş'>(<cf_get_lang dictionary_id='45508.Depolar arası'>)</option>
                                            <option value="114" <cfif isDefined('attributes.process_type') and attributes.process_type eq 114>selected</cfif>><cf_get_lang dictionary_id ='40583.Devir Fişi(Dönemler arasi)'></option>
                                            <option value="115" <cfif isDefined('attributes.process_type') and attributes.process_type eq 115>selected</cfif>><cf_get_lang dictionary_id='29632.Sayım Fişi'></option>
                                            <option value="116" <cfif isDefined('attributes.process_type') and attributes.process_type eq 116>selected</cfif>><cf_get_lang dictionary_id='29634.Sayım Sıfırlama'></option>
                                            <option value="118" <cfif isDefined('attributes.process_type') and attributes.process_type eq 118>selected</cfif>><cf_get_lang dictionary_id='29635.Demirbaş Stok Fişi'></option>
                                            <option value="119" <cfif isDefined('attributes.process_type') and attributes.process_type eq 119>selected</cfif>><cf_get_lang dictionary_id ='45267.Üretimden Giriş Fişi'>(<cf_get_lang_main no ='1866.Üretimden Giriş Fişi'>)</option>
                                            <option value="120" <cfif isDefined('attributes.process_type') and attributes.process_type eq 120>selected</cfif>><cf_get_lang dictionary_id='58064.Masraf Fişi'></option>
                                            <option value="130" <cfif isDefined('attributes.process_type') and attributes.process_type eq 130>selected</cfif>><cf_get_lang dictionary_id='29645.Bordro İşlemleri'></option>
                                            <option value="140" <cfif isDefined('attributes.process_type') and attributes.process_type eq 140>selected</cfif>><cf_get_lang dictionary_id ='40590.Service Stok Girişi'></option>
                                            <option value="141" <cfif isDefined('attributes.process_type') and attributes.process_type eq 141>selected</cfif>><cf_get_lang dictionary_id ='40591.Service Stok Çıkışı'></option>
                                            <option value="150" <cfif isDefined('attributes.process_type') and attributes.process_type eq 150>selected</cfif>><cf_get_lang dictionary_id ='40592.Proje Detayı'></option>
                                            <option value="160" <cfif isDefined('attributes.process_type') and attributes.process_type eq 160>selected</cfif>><cf_get_lang dictionary_id='29649.Gider Planlama Fişi'></option>
                                            <option value="161" <cfif isDefined('attributes.process_type') and attributes.process_type eq 161>selected</cfif>><cf_get_lang dictionary_id ='40594.Gelir Planlama Fişi'></option>
                                            <option value="171" <cfif isDefined('attributes.process_type') and attributes.process_type eq 171>selected</cfif>><cf_get_lang dictionary_id='29651.Üretim Sonucu'></option>
                                        </select>
                                    </div>				
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57692.İşlem'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="action_type_" id="action_type_">
                                                <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                                <option value="-1" <cfif attributes.action_type_ eq -1>selected </cfif>><cf_get_lang dictionary_id ='57463.Sil'></option>
                                                <option value="0"  <cfif attributes.action_type_ eq 0>selected </cfif>><cf_get_lang dictionary_id ='57464.Güncelle'></option>
                                                <option value="1"  <cfif attributes.action_type_ eq 1>selected </cfif>><cf_get_lang dictionary_id ='57582.Ekle'></option>
                                            </select>
                                        </div>				
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57627.Kayıt Tarihi'></cfsavecontent>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                        <input name="log_start_date" id="log_start_date" type="text" value="<cfif isdefined("attributes.log_start_date") and isdate(attributes.log_start_date)><cfoutput>#dateformat(attributes.log_start_date,dateformat_style)#</cfoutput></cfif>"> 
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="log_start_date"></span>            
                                        <span class="input-group-addon no-bg"></span>
                                        <input name="log_finish_date" id="log_finish_date" type="text" value="<cfif isdefined("attributes.log_finish_date") and isdate(attributes.log_finish_date)><cfoutput>#dateformat(attributes.log_finish_date,dateformat_style)#</cfoutput></cfif>">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="log_finish_date"></span>  
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                            <cf_wrk_report_search_button button_type='1' search_function='control()' is_excel="1">
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
    <cfcontent type="application/vnd.msexcel;charset=utf-16">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-16">
</cfif>
<cfif isdefined("attributes.form_varmi")>
    <cf_report_list>        
        <thead>
            <tr>               
                <th><cf_get_lang dictionary_id ='57880.Belge No'></th>
                <th><cf_get_lang dictionary_id ='40574.Fuseaction'></th>
                <th><cf_get_lang dictionary_id ='58772.İşlem No'></th>                
                <th><cf_get_lang dictionary_id ='57692.İşlem'></th>
                <th><cf_get_lang dictionary_id ='57800.İşlem Tipi'></th>
                <th><cf_get_lang dictionary_id ='57482.aşama'></th>
                <th><cf_get_lang dictionary_id ='58586.İşlem Yapan'></th>                
                <th><cf_get_lang dictionary_id ='57742.Tarih'></th>                
                <th><cf_get_lang dictionary_id ='57629.Açıklama'></th>                
            </tr>
        </thead>
        <tbody>
            <cfif GET_WRK_LOG.recordcount>
                <cfoutput query="GET_WRK_LOG" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#paper_no#</td>                                             
                        <td>#FUSEACTION#</td>
                        <td>#ACTION_ID#</td>
                        <td><cfif get_wrk_log.LOG_TYPE IS -1><cf_get_lang dictionary_id ='57463.Sil'><cfelseif get_wrk_log.LOG_TYPE IS 0><cf_get_lang dictionary_id ='57464.güncelle'><cfelseif get_wrk_log.LOG_TYPE IS 1><cf_get_lang dictionary_id ='57582.ekle'></cfif></td>
                        <td>#get_process_name(process_type)#</td>                 
                        <td>#STAGE#</td>
                        <td>
                            <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                                #EMPLOYEE_NAME# &nbsp;#EMPLOYEE_SURNAME#
                            <cfelse>
                                <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&EMP_ID=#EMPLOYEE_ID#','medium');">#EMPLOYEE_NAME# &nbsp;#EMPLOYEE_SURNAME#</a>
                            </cfif>
                        </td>
                            <td>#dateformat(date_add('h',session.ep.time_zone,LOG_DATE),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,LOG_DATE),timeformat_style)#)</td>
                        <td>#ACTION_NAME#</td> 
                    </tr>
                </cfoutput>
            <cfelse>
                <tr class="color-row">
                    <td colspan="9" height="20"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id ='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz '>!</cfif></td>
                </tr>
            </cfif>
        </tbody>   
    </cf_report_list>
</cfif>
<!-- sil -->
<cfif attributes.totalrecords gt attributes.maxrows>
    <cfset adres="report.list_log_files">
    <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
        <cfset adres = "#adres#&keyword=#attributes.keyword#">
    </cfif> 
    <cfif isdefined("attributes.log_start_date") and isdate(attributes.log_start_date)>
    <cfset adres = "#adres#&log_start_date=#dateformat(attributes.log_start_date,dateformat_style)#">
    </cfif>
    <cfif isdefined("attributes.log_finish_date") and isdate(attributes.log_finish_date)>
        <cfset adres = "#adres#&log_finish_date=#dateformat(attributes.log_finish_date,dateformat_style)#">
    </cfif>
    <cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
        <cfset adres = "#adres#&employee_id=#attributes.employee_id#">
        <cfset adres = "#adres#&employee=#attributes.employee#">
    </cfif>
    <cfif isdefined("attributes.action_type_") and len(attributes.action_type_)>
        <cfset adres = "#adres#&action_type_=#attributes.action_type_#">
    </cfif>
    <cfif isdefined("attributes.process_type") and len(attributes.process_type)>
        <cfset adres = "#adres#&process_type=#attributes.process_type#">
    </cfif>
    <cfif isdefined("attributes.form_varmi")>
        <cfset adres = "#adres#&form_varmi=#attributes.form_varmi#" >
    </cfif>
    <cfif isdefined("attributes.paper_no") and len(attributes.paper_no)>
        <cfset adres="#adres#&paper_no=#attributes.paper_no#">
    </cfif>
    <cf_paging page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="#adres#">
</cfif>
<!-- sil -->
<script>
    function control(){
		if(document.order_form.is_excel.checked==false)
			{
				document.order_form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.list_log_files"
				return true;
			}
			else
				document.order_form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_list_log_files</cfoutput>"
	}
</script>

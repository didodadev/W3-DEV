<!---  
Nurullah DEMİR - 31.08.2010

Fonksiyonu : Sisteme yapılan her saldırıyı getirir. Tanımlanmış 4 tane saldırı çeşidi vardır.
				 XSS Saldırısı : HTML kodları entegre edip saldırmak istemiştir.
				 SQL Injection : Sql kodlarını enjekte edip query çalıştırmak istemiştir.
				 Uzaktan yabanci dosya cagrilmak istendi : Saldırgan uzaktan (başka bir serverdan,siteden) bir dosyayı workcube aracılığıyla çağırmak istemiştir.
				 Sunucu yerel dosyaya ulasim istegi : Sunucuda bulunan (local) bir dosyaya ulaşmak istemiştir.
			
			 Banlanan kişi IP adresini değiştirmişse bile benzer cookie ler bulunup farklı IP lerden aynı bilgisayarın saldırdığı anlaşılabilir.
			 

--->
<cfparam name="attributes.module_id_control" default="7">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.IP" default="">
<cfparam name="attributes.attack_type" default="">
<cfparam name="attributes.record_date" default="">
<cfparam name="attributes.from_date" default="">
<cfparam name="attributes.to_date" default="">
<cfparam name="attributes.startrow" default="">
<cfparam name="attributes.maxrows" default="20">
<cfparam name="attributes.log_status" default="">
<cfparam name="attributes.form_submitted" default="">
<cfparam name="attributes.ID" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.is_excel" default="">

<cfif isdefined("attributes.from_date") and isdate(attributes.from_date)>
	<cf_date tarih = "attributes.from_date">
</cfif>
<cfif isdefined("attributes.to_date") and isdate(attributes.to_date)>
	<cf_date tarih = "attributes.to_date">
</cfif>

<cfif attributes.form_submitted is 1 or len(attributes.ip) or len(attributes.id)>
	<cfquery name="GET_ATTACK_LOGS" datasource="#DSN#">
		SELECT 
			ID,
            HTTP_COOKIE,
            HTTP_HOST,
            HTTP_REFERER,
            HTTP_USER_AGENT,
            PATH_INFO,
            QUERY_STRING,
            REMOTE_ADDR,
            REMOTE_HOST,
            SCRIPT_NAME,
            SERVER_NAME,
            ATTACK_TYPE,
            RECORD_DATE,
            NOTE,
            X_FORWARDED_FOR,
            HIT_COUNT,
            ACTIVE,
            EMPLOYEE_ID
		FROM 
			WRK_SECURE_LOG 
		WHERE
			1=1  
		<cfif len(attributes.IP)>	
			AND REMOTE_ADDR = '#attributes.IP#'
		</cfif>
		<cfif len(attributes.from_date) and len(attributes.to_date)>
			AND RECORD_DATE >= #CreateODBCDateTime(attributes.from_date)# 
			AND RECORD_DATE <= #CreateODBCDateTime(attributes.to_date)#
		</cfif> 
		<cfif len(attributes.attack_type)>
			AND ATTACK_TYPE = #attributes.attack_type#
		</cfif>
		<cfif len(attributes.id)>
			AND ID = #attributes.id#
		</cfif>
		<cfif len(attributes.log_status)>
			AND ACTIVE = #attributes.log_status#
		</cfif>
		<!---<cfif len(attributes.cookie)>
			AND HTTP_COOKIE = '#attributes.cookie#'
		</cfif>--->
		ORDER BY
			ID DESC
	</cfquery> 
<cfelse>
	<cfset get_attack_logs.recordcount = 0>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="filter" action="#request.self#?fuseaction=report.secure_get_attacks" method="post">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
    <cf_report_list_search title="Security Logs">
       <cf_report_list_search_area>            
                <div class="row">
                    <div class="col col-12 col-xs-12">
                        <div class="row formContent">
						    <div class="row" type="row">
                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">							
                                    <div class="col col-3 col-md-3 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='32421.IP'></label>							
                                            <div class="col col-12 col-xs-12">
                                                <cfinput type="Text" maxlength="255" value="#attributes.ip#" name="IP" id="IP">
                                            </div>                            
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-3 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12"> <cf_get_lang dictionary_id='60676.Saldırı Türü'></label>
                                            <div class="col col-12 col-xs-12">
                                                <select name="attack_type" id="attack_type">
                                                    <option title="Tüm saldiri türlerini getir" value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                                                    <option title="HTML kod entegre" value="1" <cfif attributes.attack_type eq 1>selected</cfif>>XSS</option>
                                                    <option title="SQL injection saldirilar" value="2" <cfif attributes.attack_type eq 2>selected</cfif>>SQL</option>
                                                    <option title="Sunucudaki yerel dosyaya erisim istegi" value="3" <cfif attributes.attack_type eq 3>selected</cfif>>LFI</option>
                                                    <option title="Uzaktan dosya entegre" value="4" <cfif attributes.attack_type eq 4>selected</cfif>>RFI</option>
                                                    <option title="Coldfusion saldırıları" value="5" <cfif attributes.attack_type eq 5>selected</cfif>>CF</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-3 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                                            <div class="col col-12 col-xs-12">
                                                <div class="input-group">
                                                    <cfsavecontent variable="alert"><cf_get_lang_main no ='1091.Lütfen Tarih Giriniz '></cfsavecontent>
                                                    <cfinput type="text" name="from_date" value="#dateformat(attributes.from_date,dateformat_style)#" style="width:65px" validate="#validate_style#" message="#alert#">
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="from_date"></span>            
                                                    <span class="input-group-addon no-bg"></span>
                                                    <cfsavecontent variable="alert"><cf_get_lang_main no ='1091.Lütfen Tarih Giriniz '></cfsavecontent>
                                                    <cfinput type="text" name="to_date" value="#dateformat(attributes.to_date,dateformat_style)#" style="width:65px" validate="#validate_style#" message="#alert#">
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="to_date"></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-3 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                                            <div class="col col-12 col-xs-12">
                                                <select name="log_status" id="log_status">
                                                    <option title="Tümünü getir" value=""><cf_get_lang dictionary_id='57708.Tüm'></option>
                                                    <option title="Bani acilmis kullanicinin saldirilarini getir" value="0" <cfif attributes.log_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                                                    <option title="Banli kullanicinin saldirilarini getir" value="1" <cfif attributes.log_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                                </select>
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
                            <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                            <cfelse>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                            </cfif>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57911.Çalıştır'></cfsavecontent>
                                <input type="hidden" name="is_submitted" id="is_submitted" value="1">
                                <cf_wrk_report_search_button  search_function='control()' insert_info='#message#' button_type='1' is_excel="1">   
                        </div>
				    </div>
					</div>
                    
                </div>
                               
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset filename="secure_get_logs#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="content-type" content="text/plain; charset=utf-16">
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_attack_logs.recordcount>
	<cfset type_ = 1>
	<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif IsDefined("attributes.is_submitted")>
<cf_report_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id='47987.IP'></th>
                <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                <th><cf_get_lang dictionary_id='978.Çerez'></th>
                <th><cf_get_lang dictionary_id='979.Kullanıcı Aracısı'></th>
                <th><cf_get_lang dictionary_id='58784.Referans'></th>
                <th><cf_get_lang dictionary_id='980.Host'></th>
                <th><cf_get_lang dictionary_id='981.Yol Bilgisi'></th>
                <th><cf_get_lang dictionary_id='982.Sorgu Dizesi'></th>
                <th><cf_get_lang dictionary_id='983.Uzak Host'></th>
                <th><cf_get_lang dictionary_id='984.Komut Dosyası Adı'></th>
                <th><cf_get_lang dictionary_id='58031.Server Adı'></th>
                <th><cf_get_lang dictionary_id='985.X İçin Yönlendirildi(Proxy)'></th>
                <th><cf_get_lang dictionary_id='58008.Senet'></th>
                <th><cf_get_lang dictionary_id='57742.Tarih	'></th>
                <th><cf_get_lang dictionary_id='57493.Aktif'></th>
            </tr>
        </thead>
        <tbody>
            <cfif get_attack_logs.recordcount>
                <cfoutput query="get_attack_logs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#remote_addr#</td>
                        <td>#get_emp_info(employee_id,0,0)#</td>
                        <td>#http_cookie#</td>
                        <td>#Wrap(http_user_agent,20)#</td>
                        <td>#Wrap(http_referer,50)#</td>
                        <td>#http_host#</td>
                        <td>#path_info#</td>		
                        <td>#Wrap(query_string, 100)#</td>
                        <td>#remote_host#</td>
                        <td>#script_name#</td>
                        <td>#server_name#</td>	
                        <td>#x_forwarded_for#</td>
                        <td>#note#</td>	
                        <td>#DateFormat(date_add("h",2,record_date),"#dateformat_style#")# #TimeFormat(date_add("h",2,record_date),timeformat_style)#</td>
                        <td><cfif #active# is "0"><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>		
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="16"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayit Bulunamadi'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz'> !</cfif></td>
                </tr>
            </cfif>
        </tbody>
</cf_report_list>
<cfif attributes.maxrows lt get_attack_logs.recordcount>
	<cfset url_string = "#attributes.fuseaction#">
	<cfif len(attributes.form_submitted)>
		<cfset url_string = '#url_string#&form_submitted=#attributes.form_submitted#'>
	</cfif>
	<cfif len(attributes.IP)>
		<cfset url_string = "#url_string#&ip=#attributes.ip#">
	</cfif>
	<cfif len(attributes.attack_type)>
		<cfset url_string = "#url_string#&attack_type=#attributes.attack_type#">
	</cfif>
	<cfif isdate(attributes.from_date)>
		<cfset url_string = "#url_string#&from_date=#dateformat(attributes.from_date,dateformat_style)#">
	</cfif>
	<cfif isdate(attributes.to_date)>
		<cfset url_string = "#url_string#&to_date=#dateformat(attributes.to_date,dateformat_style)#">
	</cfif>
	<cfif len(attributes.log_status)>
		<cfset url_string = "#url_string#&log_status=#attributes.log_status#">
	</cfif>
	<cfif len(attributes.startrow)>
		<cfset url_string = "#url_string#&startrow=#attributes.startrow#">
	</cfif>
	<cf_paging page="#attributes.page#" 
		maxrows="#attributes.maxrows#"
		totalrecords="#get_attack_logs.recordcount#"
		startrow="#attributes.startrow#"
		adres="#url_string#">
</cfif>
</cfif>
<script type="text/javascript">
    document.filter.IP.focus();
	function control()
	{	
		 if(document.filter.is_excel.checked==false)
        {
            document.filter.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.secure_get_attacks"
            return true;
        }
        else{
            document.filter.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_secure_get_attacks</cfoutput>"
        }
	}
</script>
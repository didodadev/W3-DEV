<cfparam name="attributes.date" default="#createodbcdatetime('#session.ep.period_year#-#month(now())#-1')#">
<cfparam name="attributes.date2" default="#now()#">
<cfparam name="attributes.is_excel" default="">
<cfquery name="get_domain" datasource="#dsn#">
	SELECT DISTINCT (VISIT_SITE) AS VISIT_SITE FROM WRK_VISIT_GENERAL_REPORT WHERE VISIT_SITE IS NOT NULL 
</cfquery>
<cfif isdefined("attributes.is_form_submitted")>
	<cf_date tarih="attributes.date">
	<cf_date tarih="attributes.date2">
    <cfquery name="get_visit" datasource="#dsn#">
        SELECT  
        	 COUNT(VISIT_IP) AS TOTAL_COUNT
            ,COUNT(DISTINCT(VISIT_IP))AS TOTAL_COUNT_TEKIL
            ,VISIT_FUSEACTION
            ,VISIT_MODULE
            <cfif isdefined("attributes.is_sayfa")>
            ,VISIT_PAGE
            </cfif>
            <cfif isdefined("attributes.is_tip")>
            ,CASE USER_TYPE WHEN -1 THEN 'Ziyaretçi'
            			   WHEN  0 THEN 'Çalışan'
                           WHEN  2 THEN 'Bireysel Üye'
                           WHEN  1 Then 'Kurumsal Üye'
                           END AS USER_TYPE
           </cfif>                
       FROM
       		WRK_VISIT
       WHERE
       		VISIT_DATE >= #attributes.date# 
            and
            VISIT_DATE <= #dateadd("d",1,attributes.date2)# 
            <cfif isdefined("attributes.member_type") and len(attributes.member_type)>
            	and
                USER_TYPE = #attributes.member_type#
            </cfif>
            <cfif isdefined("attributes.domain") and len(attributes.domain)>
            	and
                VISIT_SITE ='#attributes.domain#'
            </cfif>
            <cfif isdefined("attributes.fuseaction1") and len(attributes.fuseaction1)>
            	and
                VISIT_FUSEACTION LIKE '%#attributes.fuseaction1#%'
            </cfif> 
       GROUP BY
       		VISIT_MODULE,
            <cfif isdefined("attributes.is_sayfa")>
            VISIT_PAGE,
            </cfif>
            <cfif isdefined("attributes.is_tip")>
            	USER_TYPE,
            </cfif>
            VISIT_FUSEACTION
      ORDER BY
      	     TOTAL_COUNT DESC
    </cfquery>
     <cfquery name="get_visit_TOPLAM" dbtype="query">
    	SELECT SUM(TOTAL_COUNT) as TOTAL_COUNT FROM get_visit 
    </cfquery>
    <cfif isdefined("attributes.is_tip")>
        <cfquery name="get_visit_total" dbtype="query">
            SELECT SUM(TOTAL_COUNT) as TOTAL_COUNT,USER_TYPE FROM get_visit GROUP BY USER_TYPE
        </cfquery>
    </cfif>
<cfelse>
	<cfset get_visit.recordcount = 0 >
</cfif>

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_visit.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="list_visit" method="post">
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='59162.Sayfa Ziyaret Sayısı Raporu'></cfsavecontent>
    <cf_report_list_search title="#title#">
        <cf_report_list_search_area>
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">                                    
                            <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                                <div class="col col-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="59161.Sayfa Yolu"></label>
                                        <div class="col col-12">
                                            <input type="text" name="fuseaction1" id="fuseaction1" value="<cfif isdefined("attributes.fuseaction1")><cfoutput>#attributes.fuseaction1#</cfoutput></cfif>"/>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'>*</label>
                                        <div class="col col-6">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>!</cfsavecontent>
                                                <cfinput value="#dateformat(attributes.date,dateformat_style)#" type="text" name="date" id="date" validate="#validate_style#" message="#message#" required="yes" style="width:63px;">
                                                <span class="input-group-addon">
                                                <cf_wrk_date_image date_field="date">
                                                </span>                                
                                            </div>
                                        </div>
                                        <div class="col col-6">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>!</cfsavecontent>
                                                <cfinput value="#dateformat(attributes.date2,dateformat_style)#" type="text" name="date2" id="date2" validate="#validate_style#" message="#message#" required="yes" style="width:63px;">
                                                <span class="input-group-addon">
                                                <cf_wrk_date_image date_field="date2">
                                                </span> 
                                            </div>                                                 
                                        </div>
                                    </div>
                                    <div class="form-group">										
                                        <div class="col col-6">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="59159.Tip Getirilsin">
                                                <input type="checkbox" name="is_tip" id="is_tip" <cfif isdefined("attributes.is_tip")> checked </cfif> />
                                            </label>		
                                        </div>
                                        <div class="col col-6">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57581.Sayfa">
                                                <input type="checkbox" id="is_sayfa" name="is_sayfa" <cfif isdefined("attributes.is_sayfa")>checked</cfif>/>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>	
                            <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                                <div class="col col-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57892.domain'></label>
                                        <div class="col col-12"> 
                                            <select name="visit_site" id="visit_site" style="width:110px;">
                                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                                <cfoutput query="get_domain">
                                                    <option value="#VISIT_SITE#" <cfif isdefined("attributes.visit_site") and attributes.visit_site eq visit_site>selected</cfif>>#VISIT_SITE#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="39530.Üye Tipi"></label>
                                        <div class="col col-12">
                                            <select id="member_type" name="member_type">
                                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                                <option value="0" <cfif isdefined("attributes.member_type") and len(attributes.member_type) and (member_type eq 0 )>selected</cfif>><cf_get_lang dictionary_id="57576.Çalışan"></option>
                                                <option value="2" <cfif isdefined("attributes.member_type") and len(attributes.member_type) and (member_type eq 2 )>selected</cfif> ><cf_get_lang dictionary_id="57586.Bireysel"></option>
                                                <option value="1" <cfif isdefined("attributes.member_type") and len(attributes.member_type) and (member_type eq 1 )>selected</cfif> ><cf_get_lang dictionary_id="57585.Kurumsal"></option>
                                                <option value="-1" <cfif isdefined("attributes.member_type") and len(attributes.member_type) and (member_type eq -1)>selected</cfif> ><cf_get_lang dictionary_id="39773.Ziyaretçi"></option>
                                            </select>
                                        </div>
                                    </div>                                           
                                </div>
                            </div>													                             
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>checked</cfif>></label>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">
                            <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1"/>
                            <cf_wrk_report_search_button search_function='kontrol()' button_type='1' is_excel='1'>
                        </div>
                    </div>
                </div>
            </div>        
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform> 
<cfif attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">	
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
    </cfif>
<cfif isdefined("attributes.is_form_submitted")> 
    <cf_report_list>
        <cfif isdefined("get_visit_TOPLAM")>  
            <cfif isdefined("attributes.is_tip")>
                <thead>
                    <th><cf_get_lang dictionary_id="38925.Kullanıcı Tipi">:</th>
                    <th colspan="15">Total</th>
                </thead>
                <cfif get_visit_total.recordcount>
                    <tbody>
                        <cfoutput query="get_visit_total">
                            <tr>
                                <td>#USER_TYPE#</td>
                                <td colspan="30">#TOTAL_COUNT#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <tbody>
                        <tr>
                            <td><cf_get_lang dictionary_id="57492.Toplam"></td>
                            <td colspan="30"><cfoutput>#get_visit_TOPLAM.total_count#</cfoutput></td>
                        </tr>
                    </tbody>
                <cfelse>
                    <tr>
                       <td colspan="<cfoutput>#colsp#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                    </tr>    
                </cfif>   
            </cfif>  
        </cfif> 
        <thead >
            <th><cf_get_lang dictionary_id="34970.Modül"></th>
            <cfif isdefined("attributes.is_sayfa")><th><cf_get_lang dictionary_id="57581.Sayfa"></th> </cfif>
            <th><cf_get_lang dictionary_id="59161.Sayfa Yolu"></th>
            <cfif isdefined("attributes.is_tip")>
                <th><cf_get_lang dictionary_id="57630.Tip"></th>
            </cfif>
            <th><cf_get_lang dictionary_id="59164.Tıklanma Sayısı"></th>
            <th><cf_get_lang dictionary_id="40750.Tekil"><cf_get_lang dictionary_id="59164.Tıklanma Sayısı"></th>
        </thead>
        <cfif get_visit.recordcount>
            <tbody>
                <cfoutput query="get_visit" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#VISIT_MODULE#</td>
                        <cfif isdefined("attributes.is_sayfa")>
                        <td>#VISIT_PAGE#</td>
                        </cfif>
                        <td>#VISIT_FUSEACTION#</td>
                        <cfif isdefined("attributes.is_tip")>
                            <td>#USER_TYPE#</td>
                        </cfif>
                        <td>#TOTAL_COUNT#</td>
                        <td>#TOTAL_COUNT_TEKIL#</td>     
                    </tr>
                </cfoutput>
            </tbody>  
        <cfelse>
            <cfset colsp = 4>
            <cfif isdefined("attributes.is_sayfa")>
                <cfset colsp = colsp + 1>
            </cfif>
            <cfif isdefined("attributes.is_tip")>
                <cfset colsp = colsp + 1>
            </cfif> 
            <tr>
                <td colspan="<cfoutput>#colsp#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
            </tr>
        </cfif>
    </cf_report_list>
</cfif>
<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
	<cfset url_string = ''>
    <cfif isdefined("attributes.date") and len(attributes.date)>
		<cfset url_string = '#url_string#&date=#attributes.date#'>
	</cfif>
    <cfif isdefined("attributes.date2") and len(attributes.date2)>
		<cfset url_string = '#url_string#&date2=#attributes.date2#'>
	</cfif>
    <cfif isdefined("attributes.member_type") and len(attributes.member_type)>
		<cfset url_string = '#url_string#&member_type=#attributes.member_type#'>
	</cfif>
    <cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
		<cfset url_string = '#url_string#&is_form_submitted=#attributes.is_form_submitted#'>
	</cfif>
    <cfif isdefined("attributes.domain") and len(attributes.domain)>
		<cfset url_string = '#url_string#&domain=#attributes.domain#'>
	</cfif>
    <cfif isdefined("attributes.fuseaction1") and len(attributes.fuseaction1)>
		<cfset url_string = '#url_string#&fuseaction1=#attributes.fuseaction1#'>
	</cfif>
     <cfif isdefined("attributes.is_sayfa") >
		<cfset url_string = '#url_string#&is_sayfa=#attributes.is_sayfa#'>
	</cfif>	
        <cf_paging
            page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="report.list_visit_page_count#url_string#">	  
	
   </cfif>
<script>
	function kontrol(){	
		 b = document.getElementById('date').value;
		 c = document.getElementById('date2').value;
		
		var b3 = list_getat(b,3,'/');
		var c3 = list_getat(c,3,'/');
		var b2 = list_getat(b,2,'/');
		var c2 = list_getat(c,2,'/');
		
		if ((c3 - b3) != 0){
		alert("<cf_get_lang dictionary_id='59165.Tarih Aralığı maksimum 1 ay olmalıdır'>!");
		return false;
		}
		else{
			if((c2 -b2 )> 1){
				alert("<cf_get_lang dictionary_id='59165.Tarih Aralığı maksimum 1 ay olmalıdır'>!");
				return false;
			}
		}

        if ((document.list_visit.date.value != '') && (document.list_visit.date2.value != '') &&
	    !date_check(list_visit.date,list_visit.date2,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	    return false;

        if(document.list_visit.is_excel.checked==false){
            document.list_visit.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
            return true;
        }
        else
            document.list_visit.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_list_visit_page_count</cfoutput>"
        
    }
</script>













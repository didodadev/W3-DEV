<cfparam name="attributes.form_submitted" default="1">
<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = createodbcdatetime('2014-1-1')>
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = date_add('d',7,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>	
</cfif>

<cfparam name="attributes.table_code" default="">
<cfset attributes.table_code = replace(attributes.table_code,',','+','all')>

<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.price_status" default="">
<cfparam name="attributes.keyword" default="">


<cfset dsn_dev =  dsn >
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_table_codes" datasource="#dsn_dev#">
    SELECT
        	'' EMPLOYEE_NAME,
            '' EMPLOYEE_SURNAME,
            1 AS URUN_SAYISI,
           'aa' AS GUNCELLEYEN,
           3 AS FIYAT_DURUMU_SPECIAL,
           3 AS FIYAT_DURUMU_STD,
           3 as TABLE_CODE,
            3 as TABLE_INFO,
            GETDATE() RECORD_DATE,
            GETDATE() UPDATE_DATE
    	<!---SELECT
        	E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            (SELECT COUNT(STP.ROW_ID) AS SAYI FROM SEARCH_TABLES_PRODUCTS STP WHERE STP.TABLE_ID = ST.TABLE_ID) AS URUN_SAYISI,
            (SELECT E2.EMPLOYEE_NAME + ' ' + E2.EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES E2 WHERE E2.EMPLOYEE_ID = ST.UPDATE_EMP) AS GUNCELLEYEN,
            ISNULL((SELECT TOP 1 PT.TABLE_ID FROM PRICE_TABLE PT WHERE PT.TABLE_ID = ST.TABLE_ID),0) AS FIYAT_DURUMU_SPECIAL,
            ISNULL((SELECT TOP 1 PT.TABLE_ID FROM PRICE_TABLE_STANDART PT WHERE PT.TABLE_ID = ST.TABLE_ID),0) AS FIYAT_DURUMU_STD,
            ST.*
        FROM
        	SEARCH_TABLES ST,
            #dsn_alias#.EMPLOYEES E
        WHERE
        	<cfif isdefined("session.pp.userid")>
            	ST.IS_MAIN = 1 AND
                ST.TABLE_ID IN 
                	(
                    	SELECT
                        	STP.TABLE_ID
                        FROM
                        	SEARCH_TABLES_PRODUCTS STP,
                            #dsn1_alias#.PRODUCT P
                        WHERE
                        	STP.PRODUCT_ID = P.PRODUCT_ID
                            <cfif isdefined("session.pp.userid")>
                                AND P.COMPANY_ID = #session.pp.company_id#
                            </cfif>
                            <cfif isdefined("session.pp.project_id") and len(session.pp.project_id)>
                                AND P.PROJECT_ID IS NOT NULL
                                AND P.PROJECT_ID IN (#session.pp.project_id#)
                            </cfif>
                    ) AND
            </cfif>
			<cfif attributes.price_status eq 0>
            	ST.TABLE_ID NOT IN (SELECT PT.TABLE_ID FROM PRICE_TABLE PT) AND
            </cfif>
            <cfif attributes.price_status eq 1>
            	ST.TABLE_ID IN (SELECT PT.TABLE_ID FROM PRICE_TABLE PT) AND
            </cfif>
			<cfif len(attributes.keyword)>
            	ST.TABLE_INFO LIKE '%#attributes.keyword#%' AND
            </cfif>
			<cfif len(attributes.table_code)>
            	<cfif listlen(attributes.table_code,'+') eq 1>
            		ST.TABLE_CODE LIKE '%#attributes.table_code#%' AND
                <cfelse>
                	(
                    	<cfloop from="1" to="#listlen(attributes.table_code,'+')#" index="ccc">
                        	<cfset code_ = listgetat(attributes.table_code,ccc,'+')>
                        	ST.TABLE_CODE LIKE '%#code_#'
                        	<cfif ccc neq listlen(attributes.table_code,'+')>OR</cfif>
                        </cfloop>
                    )
                    AND
                </cfif>
            </cfif>
            <cfif len(attributes.record_emp_id) and len(attributes.record_emp_name)>
            	(
                ST.RECORD_EMP = #attributes.record_emp_id#
                OR
                ST.UPDATE_EMP = #attributes.record_emp_id#
                ) 
                AND
            </cfif>
            (
            ST.RECORD_DATE BETWEEN #attributes.startdate# AND #attributes.finishdate#
            OR
            ST.RECORD_DATE BETWEEN #attributes.startdate# AND #attributes.finishdate#
            ) 
            AND
        	ST.RECORD_EMP = E.EMPLOYEE_ID
            --->
    </cfquery>
<cfelse>
	<cfset get_table_codes.recordcount=0>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_table_codes.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_form" method="post" action="#request.self#?fuseaction=retail.list_manage_products">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="table_code" placeholder="#getLang('','Tablo Kodu',61478)#" id="table_code" style="width:75px;" value="#attributes.table_code#" maxlength="500">
                </div>
                <div class="form-group">
                    <cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" id="keyword" style="width:75px;" value="#attributes.keyword#" maxlength="500">
                </div>
                <div class="form-group">
                    <select name="price_status">
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="0" <cfif attributes.price_status eq 0>selected</cfif>><cf_get_lang dictionary_id='61953.Fiyat Yapılmayanlar'></option>
                        <option value="1" <cfif attributes.price_status eq 1>selected</cfif>><cf_get_lang dictionary_id='61954.Fiyat Yapılanlar'></option>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif isdefined("attributes.record_emp_id")><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
                        <input name="record_emp_name" type="text" id="record_emp_name" style="width:100px;" onfocus="AutoComplete_Create('record_emp_name','FULLNAME','FULLNAME','get_emp_pos','','EMPLOYEE_ID','record_emp_id','','3','130');" value="<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" maxlength="255" autocomplete="off" placeholder="<cfoutput>#getLang('','Kaydeden',57899)#</cfoutput>">
                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_form.record_emp_id&field_name=search_form.record_emp_name&select_list=1&is_form_submitted=1','list','popup_list_positions');"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='39354.Başlangıç Tarihini Giriniz'></cfsavecontent>
                        <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='38139.Bitiş Tarihini Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='43958.Kayıt Sayısı Hatalı'>!</cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" required="yes" message="#message#" range="1,250" style="width:25px;">
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='61955.Ürün ve Fiyat Listeleri'></cfsavecontent>
    <cfform name="combine_form" action="#request.self#?fuseaction=retail.emptypopup_combine_table_codes" method="post">
        <cf_box title="#header_#" uidrop="1" hide_table_column="1">
            <cf_grid_list> 
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='61478.Tablo Kodu'></th>
                        <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                        <th><cf_get_lang dictionary_id='61956.Fiyat Durumu'></th>
                        <th><cf_get_lang dictionary_id='33886.Ürün Sayısı'></th>
                        <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                        <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                        <th><cf_get_lang dictionary_id='58050.Son Güncelleme'></th>
                        <th><cf_get_lang dictionary_id='32449.Güncelleme Tarihi'></th>
                        <cfif isdefined("session.ep.userid")>
                        <th width="20"><!-- sil --><cfoutput><a href="#request.self#?fuseaction=retail.list_manage_products&event=add"><i class="fa fa-plus"></i></a></cfoutput><!-- sil --></th>
                        <th></th>
                        </cfif>
                    </tr> 
                </thead>
                <tbody>
                    <cfif get_table_codes.recordcount>
                    <cfoutput query="get_table_codes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=retail.speed_manage_product_new&table_code=#table_code#&is_form_submitted=1" class="tableyazi">#TABLE_CODE#</a></td>
                            <td>#table_info#</td>
                            <td><cfif FIYAT_DURUMU_SPECIAL gt 0 or FIYAT_DURUMU_STD gt 0><span style="color:green; font-weight:bold;">Fiyatlandırıldı</span><cfelse><span style="color:red; font-weight:bold;">Fiyatlandırılmadı</span></cfif></td>
                            <td>#URUN_SAYISI#</td>
                            <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                            <td>
                            <cfif isdefined("session.ep.userid")>
                                <cfset record_ = dateadd("h",session.ep.time_zone,record_Date)>
                                #dateformat(record_,'dd/mm/yyyy')# #timeformat(record_,'HH:MM')#
                            <cfelse>
                                <cfset record_ = dateadd("h",session.pp.time_zone,record_Date)>
                                #dateformat(record_,'dd/mm/yyyy')# #timeformat(record_,'HH:MM')#
                            </cfif>
                            </td>
                            <td>#GUNCELLEYEN#</td>
                            <td>
                                <cfif len(update_Date)>
                                    <cfif isdefined("session.ep.userid")>
                                        <cfset update_ = dateadd("h",session.ep.time_zone,update_Date)>
                                        #dateformat(update_,'dd/mm/yyyy')# #timeformat(update_,'HH:MM')#
                                    <cfelse>
                                        <cfset update_ = dateadd("h",session.pp.time_zone,update_Date)>
                                           #dateformat(update_,'dd/mm/yyyy')# #timeformat(update_,'HH:MM')#
                                    </cfif>
                                </cfif>
                            </td>
                            <cfif isdefined("session.ep.userid")>
                            <td>
                            <!-- sil -->
                                <a href="#request.self#?fuseaction=retail.speed_manage_product_new&table_code=#table_code#&is_form_submitted=1"><i class="fa fa-pencil"></i></a>
                                <!--- <a href="#request.self#?fuseaction=retail.speed_manage_product&table_code=#table_code#&is_form_submitted=1"><img src="/images/update_list.gif" /></a> --->
                                <!--- <a href="javascript://" onclick="delete_table('#table_code#')"><img src="/images/delete_list.gif" /></a> --->
                            <!-- sil -->
                            </td>
                            <td><cfif FIYAT_DURUMU_SPECIAL lte 0 and URUN_SAYISI gt 0><input type="checkbox" name="table_ids" id="table_ids" value="#table_id#"/></cfif></td>
                            </cfif>
                        </tr>
                    </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="10"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list> 
            <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
                <cfset url_string = ''>
                <cfif len(attributes.table_code)>
                    <cfset url_string = '#url_string#&table_code=#attributes.table_code#'>
                </cfif>
                <cfif len(attributes.keyword)>
                    <cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
                </cfif>
                <cfif len(attributes.startdate)>
                    <cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,"dd/mm/yyyy")#'>
                </cfif>
                <cfif len(attributes.finishdate)>
                    <cfset url_string = '#url_string#&finishdate=#dateformat(attributes.finishdate,"dd/mm/yyyy")#'>
                </cfif>
                <cfif isdefined("attributes.form_submitted")>
                    <cfset url_string = '#url_string#&form_submitted=#attributes.form_submitted#'>
                </cfif>	
                <cfif isdefined("attributes.record_emp_id")>
                    <cfset url_string = '#url_string#&record_emp_id=#attributes.record_emp_id#'>
                </cfif>	
                <cfif isdefined("attributes.record_emp_name")>
                    <cfset url_string = '#url_string#&record_emp_name=#attributes.record_emp_name#'>
                </cfif>
                <cfif isdefined("attributes.price_status")>
                    <cfset url_string = '#url_string#&price_status=#attributes.price_status#'>
                </cfif>
                            
                <cf_paging page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="retail.list_manage_products#url_string#">
                       
            </cfif>
        </cf_box>
        <cf_box>
            <cfif isdefined("session.ep.userid")>
                <input type="submit" value="<cfoutput>#getLang('','Seçili Tabloları Birleştir',61957)#</cfoutput>"/>
            </cfif>
        </cf_box>
    </cfform>
</div>



<script>
function delete_table(table_code)
{
	if(confirm('Tabloyu Silmek İstediğinize Emin misiniz!')) 
		window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=retail.del_speed_manage_product&is_form_submitted=1&table_code=' + table_code;
	else
		return false;
}
</script>
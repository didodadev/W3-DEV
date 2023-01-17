<cfparam name="attributes.form_submitted" default="1">
<cfset bugun_ = now()>
<cfset base_date_ = bugun_>
<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = dateadd('d',-5,base_date_)>	
</cfif>

<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = dateadd('d',3,base_date_)>	
</cfif>

<cfparam name="attributes.action_code" default="">
<cfparam name="attributes.table_code" default="">
<cfset attributes.table_code = replace(attributes.table_code,',','+','all')>
<cfset attributes.action_code = replace(attributes.action_code,',','+','all')>

<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.price_status" default="">
<cfparam name="attributes.keyword" default="">


<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfquery name="get_standart_prices" datasource="#dsn_dev#">
	SELECT
    	WRK_ID,
        STD_P_STARTDATE AS P_STARTDATE,
        NULL AS P_FINISHDATE,
        STANDART_S_STARTDATE AS STARTDATE,
        NULL AS FINISHDATE,
        PTS.TABLE_CODE,
        NULL AS PRICE_TYPE,
        COUNT(PRODUCT_ID) AS URUN_SAYISI,
        ST.TABLE_INFO,
        PTS.IS_ACTIVE_S,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS KAYIT
    FROM
        SEARCH_TABLES ST,
    	PRICE_TABLE_STANDART PTS
        	LEFT JOIN #dsn_alias#.EMPLOYEES E ON (E.EMPLOYEE_ID = PTS.RECORD_EMP)
    WHERE
    	PTS.TABLE_CODE = ST.TABLE_CODE AND
        (
        STD_P_STARTDATE BETWEEN #attributes.startdate# AND #attributes.finishdate#
        OR
        STANDART_S_STARTDATE BETWEEN #attributes.startdate# AND #attributes.finishdate#
        ) AND
        ISNULL(PTS.IS_ACTIVE_S,0) = 0
    GROUP BY
    	WRK_ID,
        STD_P_STARTDATE,
        STANDART_S_STARTDATE,
        PTS.TABLE_CODE,
        ST.TABLE_INFO,
        PTS.IS_ACTIVE_S,
        E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME
</cfquery>

<cfquery name="get_ozel_prices" datasource="#dsn_dev#">
	SELECT
    	ACTION_CODE AS WRK_ID,
        P_STARTDATE,
        P_FINISHDATE,
        STARTDATE,
        FINISHDATE,
        PTS.TABLE_CODE,
        NULL AS PRICE_TYPE,
        COUNT(PRODUCT_ID) AS URUN_SAYISI,
        ST.TABLE_INFO,
        PTS.IS_ACTIVE_S,
        PTS.IS_ACTIVE_P,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS KAYIT,
        PT.TYPE_NAME
    FROM
        SEARCH_TABLES ST,
    	PRICE_TABLE PTS
        	LEFT JOIN #dsn_alias#.EMPLOYEES E ON (E.EMPLOYEE_ID = PTS.RECORD_EMP)
            LEFT JOIN PRICE_TYPES PT ON (PT.TYPE_ID = PTS.PRICE_TYPE)
    WHERE
    	PTS.TABLE_CODE = ST.TABLE_CODE AND
        (
        STARTDATE BETWEEN #attributes.startdate# AND #attributes.finishdate#
        OR
        FINISHDATE BETWEEN #attributes.startdate# AND #attributes.finishdate#
        OR
        P_STARTDATE BETWEEN #attributes.startdate# AND #attributes.finishdate#
        OR
        P_FINISHDATE BETWEEN #attributes.startdate# AND #attributes.finishdate#
        ) 
        AND
        (ISNULL(PTS.IS_ACTIVE_S,0) = 0 OR ISNULL(PTS.IS_ACTIVE_P,0) = 0)
    GROUP BY
    	ACTION_CODE,
        P_STARTDATE,
        P_FINISHDATE,
        STARTDATE,
        FINISHDATE,
        PRICE_TYPE,
        PTS.TABLE_CODE,
        ST.TABLE_INFO,
        PTS.IS_ACTIVE_S,
        PTS.IS_ACTIVE_P,
        E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME,
        PT.TYPE_NAME
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_form" method="post" action="#request.self#?fuseaction=retail.list_waiting_prices">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent  variable="message"><cf_get_lang dictionary_id='61483.Tablo No'></cfsavecontent>
                        <cfinput type="text" name="table_code" id="table_code" style="width:75px;" value="#attributes.table_code#" maxlength="500" placeholder="#message#">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent  variable="message"><cf_get_lang dictionary_id='58772.İşlem No'></cfsavecontent>
                        <cfinput type="text" name="action_code" id="action_code" style="width:75px;" value="#attributes.action_code#" maxlength="500" placeholder="#message#">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent  variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                        <cfinput type="text" name="keyword" id="keyword" style="width:75px;" value="#attributes.keyword#" maxlength="500" placeholder="#message#">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent  variable="message"><cf_get_lang dictionary_id='57899.Kaydeden'></cfsavecontent>
                        <input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif isdefined("attributes.record_emp_id")><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
                        <input name="record_emp_name" type="text" id="record_emp_name" style="width:100px;" onfocus="AutoComplete_Create('record_emp_name','FULLNAME','FULLNAME','get_emp_pos','','EMPLOYEE_ID','record_emp_id','','3','130');" value="<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" maxlength="255" autocomplete="off" placeholder="<cfoutput>#getLang("","Kaydeden",57899)#</cfoutput>">
                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_form.record_emp_id&field_name=search_form.record_emp_name&select_list=1&is_form_submitted=1','list','popup_list_positions');"><img src="/images/plus_thin.gif" align="absmiddle"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi Girmelisiniz'>!</cfsavecontent>
                        <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
                        <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'>!</cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" required="yes" message="#message#" range="1,250" style="width:25px;">
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='61484.Onaysız Fiyat İşlemleri'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='61478.Tablo Kodu'></th>
                    <th><cf_get_lang dictionary_id='48886.İşlem Kodu'></th>
                    <th><cf_get_lang dictionary_id='61480.Fiyat Tipi'></th>
                    <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                    <th><cf_get_lang dictionary_id='33886.Ürün Sayısı'></th>
                    <th>A</th>
                    <th><cf_get_lang dictionary_id='61533.Alış Başlangıç'></th>
                    <th><cf_get_lang dictionary_id='61534.Alış Bitiş'></th>
                    <th>S</th>
                    <th><cf_get_lang dictionary_id='61535.Satış Başlangıç'></th>
                    <th><cf_get_lang dictionary_id='61536.Satış Bitiş'></th>
                    <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                </tr>
            </thead>
            <tbody>
                <cfif (get_standart_prices.recordcount or get_ozel_prices.recordcount)>
                    <cfset sira_ = 0>
                    <cfoutput query="get_standart_prices">
                    <cfset sira_ = sira_ + 1>
                        <tr>
                            <td>#sira_#</td>
                            <td>#table_code#</td>
                            <td><a href="#request.self#?fuseaction=retail.speed_manage_product_new&table_code=#table_code#&wrk_id=#wrk_id#&is_form_submitted=1" class="tableyazi" target="price_act_window"><cfif len(wrk_id)>#wrk_id#<cfelse>#table_code#</cfif></a></td>
                            <td><cf_get_lang dictionary_id='33137.Standart'></td>
                            <td>#TABLE_INFO#</td>
                            <td>#URUN_SAYISI#</td>
                            <td><cf_get_lang dictionary_id='57616.Onaylı'></td>
                            <td>#dateformat(P_STARTDATE,'dd/mm/yyyy')#</td>
                            <td>-</td>
                            <td><cfif IS_ACTIVE_S eq 1><cf_get_lang dictionary_id='57616.Onaylı'><cfelse><cf_get_lang dictionary_id='50716.Onaysız'></cfif></td>
                            <td>#dateformat(STARTDATE,'dd/mm/yyyy')#</td>
                            <td>-</td>
                            <td>#KAYIT#</td>
                        </tr>
                    </cfoutput>
                    <cfoutput query="get_ozel_prices">
                    <cfset sira_ = sira_ + 1>
                        <tr>
                            <td>#sira_#</td>
                            <td>#table_code#</td>
                            <td><a href="#request.self#?fuseaction=retail.speed_manage_product_new&table_code=#table_code#&action_code=#wrk_id#&is_form_submitted=1" class="tableyazi" target="price_act_window">#wrk_id#</a></td>
                            <td>#TYPE_NAME#</td>
                            <td>#TABLE_INFO#</td>
                            <td>#URUN_SAYISI#</td>
                            <td><cfif IS_ACTIVE_P eq 1><cf_get_lang dictionary_id='57616.Onaylı'><cfelse><cf_get_lang dictionary_id='50716.Onaysız'></cfif></td>
                            <td>#dateformat(P_STARTDATE,'dd/mm/yyyy')#</td>
                            <td>#dateformat(P_FINISHDATE,'dd/mm/yyyy')#</td>
                            <td><cfif IS_ACTIVE_S eq 1>Onaylı<cfelse><cf_get_lang dictionary_id='50716.Onaysız'></cfif></td>
                            <td>#dateformat(STARTDATE,'dd/mm/yyyy')#</td>
                            <td>#dateformat(FINISHDATE,'dd/mm/yyyy')#</td>
                            <td>#KAYIT#</td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="13"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>

<br />




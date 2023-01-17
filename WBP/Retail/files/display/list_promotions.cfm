<cfparam name="attributes.search_department_id" default="">
<cfparam name="attributes.promotion_type" default="">
<cfparam name="attributes.search_type_id" default="">
<cfset bugun_ = now()>
<cfset base_date_ = bugun_>
<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = createodbcdatetime('#year(base_date_)#-#month(base_date_)#-#day(base_date_)#')>	
</cfif>

<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = createodbcdatetime('#year(base_date_)#-#month(base_date_)#-#day(base_date_)#')>	
</cfif>

<cfquery name="get_card_types" datasource="#dsn_dev#">
    	SELECT 
            1 AS ROW_NUMBER,
            -1 AS TYPE_ID,
            'Tüm Müşteriler' AS TYPE_NAME
    UNION
        SELECT 
            2 AS ROW_NUMBER,
            -2 AS TYPE_ID,
            'Kart Müşterileri' AS TYPE_NAME
    UNION
        SELECT 
            3 AS ROW_NUMBER,
            -3 AS TYPE_ID,
            'Kartsız Müşteriler' AS TYPE_NAME
	UNION
        SELECT 
            4 AS ROW_NUMBER,
            TYPE_ID,
            TYPE_NAME
        FROM 
            CARD_TYPES
        WHERE
            TYPE_STATUS = 1
        ORDER BY 
            ROW_NUMBER,
            TYPE_NAME
</cfquery>

<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	BRANCH_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
        D.DEPARTMENT_ID NOT IN (#iade_depo_id#,#merkez_depo_id#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfquery name="get_promotions" datasource="#dsn_dev#">
	SELECT
    	MP.*,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS KAYIT_EDEN
    FROM 
    	MARKET_PROMOTIONS MP
        	INNER JOIN #dsn_alias#.EMPLOYEES E ON (E.EMPLOYEE_ID = MP.RECORD_EMP)
    WHERE
    	<cfif len(attributes.promotion_type)>
        	MP.PROMOTION_TYPE = #attributes.promotion_type# AND
        </cfif>
        <cfif len(attributes.search_department_id)>
        	MP.PROMOTION_ID IN (SELECT MPD.PROMOTION_ID FROM MARKET_PROMOTIONS_DEPARTMENTS MPD WHERE DEPARTMENT_ID = #attributes.search_department_id#) AND
        </cfif>
        <cfif len(attributes.search_type_id)>
        	MP.PROMOTION_ID IN (SELECT MPD.PROMOTION_ID FROM MARKET_PROMOTIONS_MEMBER_TYPES MPD WHERE MEMBER_TYPE_ID = #attributes.search_type_id#) AND
        </cfif>
        (
        MP.STARTDATE >= #attributes.startdate# AND MP.STARTDATE < #dateadd('d',1,attributes.finishdate)#
        OR
        MP.FINISHDATE >= #attributes.startdate# AND MP.FINISHDATE < #dateadd('d',1,attributes.finishdate)#
        )
    ORDER BY
    	MP.STARTDATE DESC
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_promotions.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=retail.list_promotions" method="post" name="search_">
            <cf_box_search>
                <div class="form-group medium">
                    <select name="promotion_type">
                        <option value=""><cf_get_lang dictionary_id='37488.Promosyon Tipi'></option>
                        <option value="1" <cfif attributes.promotion_type eq 1>selected</cfif>>PICK - MIX</option>
                        <option value="2" <cfif attributes.promotion_type eq 2>selected</cfif>><cf_get_lang dictionary_id='61488.Ürüne Yüzde veya Tutar İndirimi'></option>
                        <option value="3" <cfif attributes.promotion_type eq 3>selected</cfif>><cf_get_lang dictionary_id='61489.Ürüne İki Tarih veya Saat Arasında Yüzde veya Tutar İndirimi'></option>
                        <option value="4" <cfif attributes.promotion_type eq 4>selected</cfif>><cf_get_lang dictionary_id='61490.Müşteri Kartına Göre Fiyat Çeşidi Atama'></option>
                        <option value="5" <cfif attributes.promotion_type eq 5>selected</cfif>><cf_get_lang dictionary_id='61491.PICK - MIX Hediye Verme'></option>
                    </select>
                </div>
                <div class="form-group medium">
                    <cf_multiselect_check 
                                query_name="get_departments_search"  
                                name="search_department_id"
                                option_text="Şube" 
                                width="150"
                                height="200"
                                option_name="department_head" 
                                option_value="BRANCH_ID"
                                filter="0"
                                value="#attributes.search_department_id#">
                </div>
                <div class="form-group medium">
                    <cf_multiselect_check 
                                query_name="get_card_types"  
                                name="search_type_id"
                                option_text="Üye Tipi Seçiniz" 
                                width="200"
                                option_name="TYPE_NAME" 
                                option_value="type_id"
                                value="#attributes.search_type_id#">
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
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id='61492.Promosyonlar'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57756.Durum'></th>
                    <th><cf_get_lang dictionary_id='58233.Tanım'></th>
                    <th><cf_get_lang dictionary_id='59088.Tip'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                    <th><cf_get_lang dictionary_id='52123.Kayıt Eden'></th>
                    <th width="15"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.list_promotions&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_promotions.recordcount>
                    <cfoutput query="get_promotions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td><cfif promotion_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                        <td>#promotion_head#</td>
                        <td>
                            <cfif promotion_type eq 1>PICK - MIX</cfif>
                            <cfif promotion_type eq 2><cf_get_lang dictionary_id='61488.Ürüne Yüzde veya Tutar İndirimi'></cfif>
                            <cfif promotion_type eq 3><cf_get_lang dictionary_id='61489.Ürüne İki Tarih veya Saat Arasında Yüzde veya Tutar İndirimi'></cfif>
                            <cfif promotion_type eq 4><cf_get_lang dictionary_id='61490.Müşteri Kartına Göre Fiyat Çeşidi Atama'></cfif>
                            <cfif promotion_type eq 5><cf_get_lang dictionary_id='61491.PICK - MIX Hediye Verme'></cfif>
                        </td>
                        <td>#dateformat(startdate,'dd/mm/yyyy')# (#timeformat(startdate,'HH:MM')#) - #dateformat(finishdate,'dd/mm/yyyy')# (#timeformat(finishdate,'HH:MM')#)</td>
                        <td>#dateformat(record_date,'dd/mm/yyyy')#</td>
                        <td>#KAYIT_EDEN#</td>
                        <td width="15"><a href="#request.self#?fuseaction=retail.list_promotions&event=upd&promotion_id=#promotion_id#"><i class="fa fa-pencil"></i></a></td>
                    </tr>
                    </cfoutput>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
            <cfset url_string = ''>
            <cfif len(attributes.startdate)>
                <cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,"dd/mm/yyyy")#'>
            </cfif>
            <cfif len(attributes.finishdate)>
                <cfset url_string = '#url_string#&finishdate=#dateformat(attributes.finishdate,"dd/mm/yyyy")#'>
            </cfif>
            <cfif isdefined("attributes.search_department_id")>
                <cfset url_string = '#url_string#&search_department_id=#attributes.search_department_id#'>
            </cfif>	
            <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="retail.list_promotions#url_string#">
        
        </cfif>
    </cf_box>
</div>


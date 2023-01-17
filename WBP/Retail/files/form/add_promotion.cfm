<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
        D.DEPARTMENT_ID NOT IN (#merkez_depo_id#,#iade_depo_id#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

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
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_promotion" action="#request.self#?fuseaction=retail.emptypopup_add_promotion" method="post">
            <cf_box_elements>
                <div class="col col-12 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_status">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" value="1" checked="checked" name="promotion_status"/>
                        </label>
                    </div>
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_days_m">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='57604.Pazartesi'><input type="checkbox" value="1" checked="checked" name="promotion_days"/>
                        </label>
                    </div>
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_days_t">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='57605.Salı'><input type="checkbox" value="2" checked="checked" name="promotion_days"/>
                        </label>
                    </div>
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_days_w">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='57606.Çarşamba'><input type="checkbox" value="3" checked="checked" name="promotion_days"/> 
                        </label>
                    </div>
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_days_th">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='57607.Perşembe'><input type="checkbox" value="4" checked="checked" name="promotion_days"/>
                        </label>
                    </div>
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_days_f">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='57608.Cuma'><input type="checkbox" value="5" checked="checked" name="promotion_days"/>
                        </label>
                    </div>
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_days_s">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='57609.Cumartesi'><input type="checkbox" value="6" checked="checked" name="promotion_days"/>
                        </label>
                    </div>
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_days_sun">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id='57610.Pazar'><input type="checkbox" value="7" checked="checked" name="promotion_days"/>
                        </label>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-promotion_head">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58233.Tanım">*</label>
                        <div class="col col-8 col-sm-12">
                            <cfsavecontent  variable="message"><cf_get_lang dictionary_id='61637.Promosyon Tanımı Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="promotion_head" style="width:200px;" required="yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-department_head">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='35449.Departman'></label>
                        <div class="col col-8 col-sm-12">
                            <cfsavecontent  variable="message"><cf_get_lang dictionary_id='35449.Departman'></cfsavecontent>
                            <cf_multiselect_check 
                            query_name="get_departments_search"  
                            name="department_id"
                            option_text="#message#" 
                            width="200"
                            height="200"
                            option_name="department_head" 
                            option_value="department_id"
                            value="">
                        </div>
                    </div>
                   
                    <div class="form-group" id="item-type_name">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31097.Üye Tipi'></label>
                        <div class="col col-8 col-sm-12">
                            <cfsavecontent  variable="message"><cf_get_lang dictionary_id='61782.Üye Tipi Seçiniz'></cfsavecontent>
                            <cf_multiselect_check 
                            query_name="get_card_types"  
                            name="card_type"
                            option_text="#message#" 
                            width="200"
                            option_name="TYPE_NAME" 
                            option_value="type_id"
                            value="">
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-promotion_status">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>*</label>
                        <div class="col col-4 col-sm-12">
                            <div class="input-group">
                                <cfsavecontent  variable="message"><cf_get_lang dictionary_id='47474.Tarih Hatalı'>!</cfsavecontent>
                                <cfinput type="text" name="startdate" maxlength="10" value="#dateformat(bugun_,'dd/mm/yyyy')#" style="width:65px;" required="yes" validate="eurodate" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                            </div>
                        </div>
                        <div class="col col-2 col-sm-12">
                            <select name="start_clock" id="start_clock" style="width:50px;">
                                <cfloop from="7" to="30" index="i">
                                    <cfset saat=i mod 24>
                                    <option value="<cfoutput>#NumberFormat(saat,00)#</cfoutput>" <cfif 0 eq saat>selected</cfif>><cfoutput>#NumberFormat(saat,00)#</cfoutput></option>
                                </cfloop>
                            </select>   
                        </div>
                        <div class="col col-2 col-sm-12">
                            <select name="start_minute" id="start_minute">
                                <cfloop from="0" to="55" index="a" step="5">
                                    <cfoutput><option value="#Numberformat(a,00)#" <cfif 0 eq a>selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                </cfloop>
                            </select> 
                        </div>
                    </div>
                    <div class="form-group" id="item-finishdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
                        <div class="col col-4 col-sm-12">
                            <div class="input-group">
                                <cfsavecontent  variable="message"><cf_get_lang dictionary_id='47474.Tarih Hatalı'>!</cfsavecontent>
                                <cfinput type="text" name="finishdate" maxlength="10" value="#dateformat(bugun_,'dd/mm/yyyy')#" style="width:65px;" required="yes" validate="eurodate" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                            </div>
                        </div>
                        <div class="col col-2 col-sm-12">
                            <select name="finish_clock" id="finish_clock" style="width:50px;">
                                <cfloop from="7" to="30" index="i">
                                    <cfset saat=i mod 24>
                                    <option value="<cfoutput>#NumberFormat(saat,00)#</cfoutput>" <cfif 23 eq saat>selected</cfif>><cfoutput>#NumberFormat(saat,00)#</cfoutput></option>
                                </cfloop>
                            </select>    
                        </div>
                        <div class="col col-2 col-sm-12">
                            <select name="finish_minute" id="finish_minute">
                                <cfloop from="0" to="59" index="a">
                                    <cfoutput><option value="#Numberformat(a,00)#" <cfif 59 eq a>selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                </cfloop>
                            </select>  
                        </div>
                    </div>
                    <div class="form-group" id="item-promotion_type">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='37488.Promosyon Tipi'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="promotion_type" style="width:200px;">
                                <option value="1">PICK - MIX</option>
                                <option value="2"><cf_get_lang dictionary_id='61488.Ürüne Yüzde veya Tutar İndirimi'></option>
                                <option value="3"><cf_get_lang dictionary_id='61489.Ürüne İki Tarih veya Saat Arasında Yüzde veya Tutar İndirimi'></option>
                                <option value="4"><cf_get_lang dictionary_id='61490.Müşteri Kartına Göre Fiyat Çeşidi Atama'></option>
                                <option value="5"><cf_get_lang dictionary_id='61491.PICK - MIX Hediye Verme'></option>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons insert_alert="" is_cancel="0">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>



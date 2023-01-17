<cfquery name="get_guaranty_cat" datasource="#dsn#">
	SELECT * FROM SETUP_GUARANTY
</cfquery>
<cfquery name="get_support_cat" datasource="#dsn#">
	SELECT * FROM SETUP_SUPPORT
</cfquery>
<cfquery name="get_product_guaranty" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
		PRODUCT_GUARANTY 
	WHERE 
		PRODUCT_ID=#URL.PID#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33859.Garanti Bilgisi'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#message# :#get_product_name(product_id:attributes.pid)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cf_flat_list>
            <tr>
                <td width="150"><cf_get_lang dictionary_id ='33246.Satış Garanti Kategorisi'></td>
                <td>: 
                    <cfif get_product_guaranty.recordcount and len(get_product_guaranty.SALE_GUARANTY_CAT_ID)>
                    <cfquery name="get_guaranty_cat" datasource="#dsn#">
                    SELECT GUARANTYCAT FROM SETUP_GUARANTY WHERE GUARANTYCAT_ID = #get_product_guaranty.SALE_GUARANTY_CAT_ID#
                    </cfquery>
                    <cfif get_guaranty_cat.recordcount>
                    <cfoutput>#get_guaranty_cat.guarantycat#</cfoutput>
                    </cfif>
                    </cfif>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id ='33895.Satış 2 el Garanti Kategorisi'></td>
                <td>:
                    <cfif get_product_guaranty.recordcount and len(get_product_guaranty.SALE2_GUARANTY_CAT_ID)>
                    <cfquery name="get_guaranty_cat" datasource="#dsn#">
                    SELECT GUARANTYCAT FROM SETUP_GUARANTY WHERE GUARANTYCAT_ID = #get_product_guaranty.SALE2_GUARANTY_CAT_ID#
                    </cfquery>
                    <cfif get_guaranty_cat.recordcount>
                    <cfoutput>#get_guaranty_cat.guarantycat#</cfoutput>
                    </cfif>
                    </cfif>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id ='33244.Alış Garanti Kategorisi'></td>
                <td>: 
                    <cfif get_product_guaranty.recordcount and len(get_product_guaranty.TAKE_GUARANTY_CAT_ID)>
                    <cfquery name="get_guaranty_cat" datasource="#dsn#">
                    SELECT GUARANTYCAT FROM SETUP_GUARANTY WHERE GUARANTYCAT_ID = #get_product_guaranty.TAKE_GUARANTY_CAT_ID#
                    </cfquery>
                    <cfif get_guaranty_cat.recordcount>
                    <cfoutput>#get_guaranty_cat.guarantycat#</cfoutput>
                    </cfif>
                    </cfif>
                </td>
            </tr>                        
            <tr>
                <td><cf_get_lang dictionary_id ='32610.Destek Kategorisi'></td>
                <td>:
                    <cfif get_product_guaranty.recordcount and len(get_product_guaranty.SUPPORT_CAT_ID)>
                    <cfquery name="get_support_cat" datasource="#dsn#">
                    SELECT SUPPORT_CAT FROM SETUP_SUPPORT WHERE SUPPORT_CAT_ID = #get_product_guaranty.SUPPORT_CAT_ID#
                    </cfquery>
                    <cfif get_support_cat.recordcount>
                    <cfoutput>#get_support_cat.support_cat#</cfoutput>
                    </cfif>
                    </cfif>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id ='32610.Destek Süre'></td>
                <td>: 
                    <cfif get_product_guaranty.recordcount and get_product_guaranty.SUPPORT_DURATION EQ 90>3 <cf_get_lang dictionary_id='58724.ay'>
                    <cfelseif get_product_guaranty.recordcount and get_product_guaranty.SUPPORT_DURATION EQ 180> 6 <cf_get_lang dictionary_id='58724.ay'>
                    <cfelseif get_product_guaranty.recordcount and get_product_guaranty.SUPPORT_DURATION EQ 365> 1 <cf_get_lang dictionary_id ='58455.yıl'>
                    <cfelseif get_product_guaranty.recordcount and get_product_guaranty.SUPPORT_DURATION EQ 730> 2 <cf_get_lang dictionary_id ='58455.yıl'>
                    <cfelseif get_product_guaranty.recordcount and get_product_guaranty.SUPPORT_DURATION EQ 1095> 3 <cf_get_lang dictionary_id ='58455.yıl'>
                    <cfelseif get_product_guaranty.recordcount and get_product_guaranty.SUPPORT_DURATION EQ 1590> 4 <cf_get_lang dictionary_id ='58455.yıl'>
                    <cfelseif get_product_guaranty.recordcount and get_product_guaranty.SUPPORT_DURATION EQ 1825> 5 <cf_get_lang dictionary_id ='58455.yıl'>
                    </cfif>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id ='33897.Belge Onay Tarihi'></td>
                <td>: 
                    <cfif get_product_guaranty.recordcount and len(get_product_guaranty.DOCUMENT_APPROVA_DATE)>
                    <cfoutput>#dateformat(get_product_guaranty.document_approva_date,dateformat_style)#</cfoutput>
                    </cfif>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id ='33898.Belge Onay Sayısı'></td>
                <td>: 
                    <cfif get_product_guaranty.recordcount and len(get_product_guaranty.document_approva_number)>
                    <cfoutput>#get_product_guaranty.document_approva_number#</cfoutput>
                    </cfif>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id ='37396.Vize Tarihi'></td>
                <td>:
                <cfif get_product_guaranty.recordcount and len(get_product_guaranty.visa_date)>
                <cfoutput>#dateformat(get_product_guaranty.visa_date,dateformat_style)#</cfoutput>
                </cfif>
                </td>
                </tr>
                <tr>
                <td><cf_get_lang dictionary_id ='33900.Tamir Ediliyor'></td>
                <td>:
                <cfif (get_product_guaranty.recordcount) and (get_product_guaranty.IS_REPAIR eq 1)>
                <cf_get_lang dictionary_id ='57495.Evet'>
                <cfelseif (get_product_guaranty.recordcount) and (get_product_guaranty.IS_REPAIR eq 0)>
                <cf_get_lang dictionary_id ='57496.Hayır'>
                </cfif>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id ='33901.Garanti Belgesi Basılıyor'></td>
                <td>:
                <cfif (get_product_guaranty.recordcount) and (get_product_guaranty.IS_GUARANTY_WRITE eq 1)>
                <cf_get_lang dictionary_id='57495.Evet'>
                <cfelseif (get_product_guaranty.recordcount) and (get_product_guaranty.IS_GUARANTY_WRITE eq 0)>
                <cf_get_lang dictionary_id='57496.Hayır'>
                </cfif>
                </td>
            </tr>
        </cf_flat_list>
    </cf_box>
</div>
	




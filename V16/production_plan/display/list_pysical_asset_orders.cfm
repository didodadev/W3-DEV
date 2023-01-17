
<!---
    File:V16\production_plan\display\list_pysical_asset_orders.cfm
    Author:Fatma Zehra Dere
    Date: 2021-10-13
    Description:Operatorlerde İlişkili Fiziki varlıklar.
--->
<cf_get_lang_set module_name="prod">
    <cfsetting showdebugoutput="no">
    <style>
        .ajax_list > thead tr th {
        border-bottom: 2px solid #51bbb4;
        font-size: 20px;
        color: #555;
        font-weight: bold;
        margin: 0;
        padding: 5px;
        outline: none!important;
        cursor: pointer!important;
        text-align: left;
        white-space: nowrap;
    }
    </style>
    <cfquery name="get_physical_asset_order" datasource="#DSN#">
            
        SELECT distinct
        A_P.ASSETP_ID,
        RPAS.PHYSICAL_ASSET_ID,
        RPAS.STATION_ID,
        W.STATION_ID,
        W.EMP_ID,
        A_P.ASSETP ,
        APC.ASSETP_CATID,
        APC.ASSETP_CAT,
        W.STATION_NAME
        FROM
        
             RELATION_PHYSICAL_ASSET_STATION AS RPAS
            LEFT JOIN ASSET_P A_P ON A_P.ASSETP_ID=RPAS.PHYSICAL_ASSET_ID
            LEFT JOIN ASSET_P_CAT APC ON APC.ASSETP_CATID=A_P.ASSETP_CATID
            LEFT JOIN #DSN3#.WORKSTATIONS W  ON W.STATION_ID = RPAS.STATION_ID
        WHERE
            W.EMP_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.ep.userid#%">
            
    </cfquery>
    <cfparam name='attributes.totalrecords' default="#get_physical_asset_order.recordcount#">
    <cfparam  name="attributes.page" default="1">
    <cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
        <cfset attributes.maxrows = 10 />
    </cfif>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cf_box title="#getLang('','Kullanabileceğim',63768)# #getLang('','Makine',63769)# #getLang('','Ekipmanlar',30225)#" box_style="maxi"  scroll="0" collapsable="0" settings="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cf_flat_list>
            <thead>
                <tr>
                    <th width="40"><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='36342.Varlık Adı'></th>
                    <th><cf_get_lang dictionary_id='36646.Varlık Tipi'></th>
                    <th><cf_get_lang dictionary_id='36669.İstasyon Adı'></th>   
                </tr>
            </thead>
            <tbody>
                <cfif get_physical_asset_order.recordcount>
                    <cfoutput query="get_physical_asset_order"startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#assetp#</td>
                            <td>#assetp_cat#</td>
                            <TD>#STATION_NAME#</TD>
                            
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr class="color-row" height="20">
                        <td colspan="15"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfset url_str = "">
        <cf_paging page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="production.physical_assets_orders#url_str#"
        isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
    </cf_box>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
    
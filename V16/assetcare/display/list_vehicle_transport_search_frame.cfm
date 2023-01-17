<!---BU SAYFA HEM BASKET, HEM POPUP SAYFA OLARAK KULLANILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfsetting showdebugoutput="no">
<cfparam name="attributes.receiver_depot" default="">
<cfparam name="attributes.sender_depot" default="">
<cfparam name="attributes.transporter" default="">
<cfparam name="attributes.shipping_type" default="">
<cfparam name="attributes.shipping_num" default="">
<cfparam name="attributes.shipping_status" default="">
<cfparam name="attributes.shipping_date1" default="">
<cfparam name="attributes.shipping_date2" default="">
<cfif len(attributes.shipping_date1)><cf_date tarih='attributes.shipping_date1'></cfif>
<cfif len(attributes.shipping_date2)><cf_date tarih='attributes.shipping_date2'></cfif>
<cfif len("attributes.is_submitted")>
    <cfquery name="GET_TRANSPORT" datasource="#DSN#">
        SELECT 
            ASSET_P_TRANSPORT.SHIP_ID,
            ASSET_P_TRANSPORT.SHIP_NUM,
            ASSET_P_TRANSPORT.SHIP_DATE,
            ASSET_P_TRANSPORT.SENDER_DEPOT,
            ASSET_P_TRANSPORT.RECEIVER_DEPOT,
            ASSET_P_TRANSPORT.PLATE,
            ASSET_P_TRANSPORT.PACK_QUANTITY,
            ASSET_P_TRANSPORT.PACK_DESI,
            ASSET_P_TRANSPORT.STUFF_TYPE,
            ASSET_P_TRANSPORT.SHIP_STATUS,
            SHIP_METHOD.SHIP_METHOD,
            BRANCH1.BRANCH_NAME AS BRANCH_NAME1,
            DEPARTMENT1.DEPARTMENT_HEAD AS DEPARTMENT_HEAD1,
            BRANCH2.BRANCH_NAME AS BRANCH_NAME2,
            DEPARTMENT2.DEPARTMENT_HEAD AS DEPARTMENT_HEAD2,
            EMPLOYEE_NAME,
            EMPLOYEE_SURNAME,
            COMPANY.FULLNAME
        FROM
            ASSET_P_TRANSPORT,
            SHIP_METHOD,
            BRANCH AS BRANCH1,
            BRANCH AS BRANCH2,
            DEPARTMENT AS DEPARTMENT1,
            DEPARTMENT AS DEPARTMENT2,
            EMPLOYEES,
            COMPANY
        WHERE
            ASSET_P_TRANSPORT.SHIP_ID IS NOT NULL
            <cfif len(attributes.receiver_depot)>AND BRANCH1.BRANCH_ID = #attributes.receiver_depot_id#</cfif>
            <cfif len(attributes.sender_depot)>AND BRANCH2.BRANCH_ID = #attributes.sender_depot_id#</cfif>
            <cfif len(attributes.transporter)>AND ASSET_P_TRANSPORT.SHIP_FIRM = #attributes.transporter_id#</cfif>
            <cfif len(attributes.shipping_type)>AND ASSET_P_TRANSPORT.SHIP_METHOD = #attributes.shipping_type#</cfif>
            <cfif len(attributes.shipping_status)>AND ASSET_P_TRANSPORT.SHIP_STATUS = #attributes.shipping_status#</cfif>
            <cfif len(attributes.shipping_num)>AND ASSET_P_TRANSPORT.SHIP_NUM LIKE '%#attributes.shipping_num#%'</cfif>
            <cfif len(attributes.shipping_date1)>AND ASSET_P_TRANSPORT.SHIP_DATE >= #attributes.shipping_date1#</cfif>
            <cfif len(attributes.shipping_date2)>AND ASSET_P_TRANSPORT.SHIP_DATE <= #attributes.shipping_date2#</cfif>
            AND (BRANCH1.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#))		
            AND EMPLOYEES.EMPLOYEE_ID = ASSET_P_TRANSPORT.SENDER_EMP_ID
            AND COMPANY.COMPANY_ID = ASSET_P_TRANSPORT.SHIP_FIRM
            AND COMPANY.COMPANY_ID = ASSET_P_TRANSPORT.SHIP_FIRM
            AND SHIP_METHOD.SHIP_METHOD_ID = ASSET_P_TRANSPORT.SHIP_METHOD
            AND ASSET_P_TRANSPORT.RECEIVER_DEPOT  = DEPARTMENT1.DEPARTMENT_ID
            AND ASSET_P_TRANSPORT.SENDER_DEPOT = DEPARTMENT2.DEPARTMENT_ID
            AND DEPARTMENT1.BRANCH_ID = BRANCH1.BRANCH_ID
            AND DEPARTMENT2.BRANCH_ID = BRANCH2.BRANCH_ID
        ORDER BY 
            ASSET_P_TRANSPORT.SHIP_DATE DESC 
    </cfquery>
<cfelse>
	<cfset get_transport.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_transport.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<!-- sil -->
<table class="color-header" width="100%" style="text-align:right;">
	<tr>
    	<td><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></td>
    </tr>
</table>
<!-- sil -->
<table class="detail_basket_list">
	<thead>
        <tr>
            <th><cf_get_lang no='319.Sevk No'></th>
            <th><cf_get_lang no='411.Sevk Tarihi'></th>
            <th><cf_get_lang no='410.Gönderen Şube'></th>
            <th><cf_get_lang no='409.Gönderen Kişi'></th>
            <th><cf_get_lang no='408.Alıcı Şube'></th>
            <th><cf_get_lang_main no='670.Adet'></th>
            <th><cf_get_lang no='442.Desi'></th>
            <th><cf_get_lang no='443.Gönderi Tipi'></th>
            <th colspan="2"><cf_get_lang_main no='70.Aşama'></th>
        </tr>
     </thead>
     <tbody>
		<cfif get_transport.recordCount>
		<cfoutput query="get_transport" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
                <td>#ship_num#</td>
                <td>#dateformat(ship_date,dateformat_style)#</td>
                <td>#branch_name2# - #department_head2#</td>
                <td>#employee_name# #employee_surname#</td>
                <td>#branch_name1# - #department_head1#</td>
                <td style="text-align:right;">#pack_quantity#</td>
                <td style="text-align:right;">#pack_desi#</td>
                <td><cfif stuff_type eq 1><cf_get_lang no='441.Koli'><cfelseif stuff_type eq 2><cf_get_lang_main no='279.Dosya'><cfelseif stuff_type eq 3><cf_get_lang_main no='1068.Arac'></cfif></td>
                <td><cfif ship_status eq 0><cf_get_lang no='435.Gönderildi'><cfelse><cf_get_lang no='659.Alındı'></cfif></td>
                <td width="15"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_upd_vehicle_transport_detail&ship_id=#ship_id#','medium','popup_upd_vehicle_transport_detail');"><img src="/images/update_list.gif" alt="<cf_get_lang_main no='52.Güncelle'>" title="<cf_get_lang_main no='52.Güncelle'>" border="0" align="absmiddle"></a></td>
			</tr>
		</cfoutput>
		<cfelse>
			<tr>
			 	<td colspan="10"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
     </tbody>
</table>
<cfif isdefined("attributes.is_submitted") and attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfif isdefined("attributes.receiver_depot_id")>
	  <cfset url_str = "#url_str#&receiver_depot_id=#attributes.receiver_depot_id#">
	</cfif>
	<cfif isdefined("attributes.receiver_depot")>
	  <cfset url_str = "#url_str#&receiver_depot=#attributes.receiver_depot#">
	</cfif>
	<cfif isdefined("attributes.is_submitted")>
	  <cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
	</cfif>
	<cfif isdefined("attributes.sender_depot_id")>
	  <cfset url_str = "#url_str#&sender_depot_id=#attributes.sender_depot_id#">
	</cfif>
	<cfif isdefined("attributes.sender_depot")>
	  <cfset url_str = "#url_str#&sender_depot=#attributes.sender_depot#">
	</cfif>
	<cfif isdefined("attributes.shipping_type")>
	  <cfset url_str = "#url_str#&shipping_type=#attributes.shipping_type#">
	</cfif>
	<cfif isdefined("attributes.transporter_id")>
	  <cfset url_str = "#url_str#&transporter_id=#attributes.transporter_id#">
	</cfif>
	<cfif isdefined("attributes.transporter")>
	  <cfset url_str = "#url_str#&transporter=#attributes.transporter#">
	</cfif>
	<cfif isdefined("attributes.shipping_status")>
	  <cfset url_str = "#url_str#&shipping_status=#attributes.shipping_status#">
	</cfif>
	<cfif isdefined("attributes.shipping_num")>
	  <cfset url_str = "#url_str#&shipping_num=#attributes.shipping_num#">
	</cfif>
	<cfif isdefined("attributes.shipping_date1")>
	  <cfset url_str = "#url_str#&shipping_date1=#dateformat(attributes.shipping_date1)#">
	</cfif>
	<cfif isdefined("attributes.shipping_date2")>
	  <cfset url_str = "#url_str#&shipping_date2=#dateformat(attributes.shipping_date2)#">
	</cfif>	
	<!-- sil -->
     <table width="98%" align="center" cellpadding="0" cellspacing="0" height="35">
        <tr>
     	   	<td><cf_pages page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="assetcare.popup_list_vehicle_transport_search#url_str#">
        	</td>
        	<td  style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'> : #attributes.totalrecords#&nbsp;-&nbsp; <cf_get_lang_main no='169.Sayfa'> :#attributes.page#/#lastpage#</cfoutput></td>
        </tr>
	</table>
	<!-- sil -->
	<br/>
</cfif>

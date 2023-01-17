<!--- 20130717 SG 
	çalışanın aylık puantajına yansıyan kalemlerin tek bir ekrandan listelenip değiştirilebilmesi icin hazırlanmıstır
--->
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53012.Puantaj Güncelle"></cfsavecontent>
<cf_popup_box title="#message# : #get_emp_info(attributes.employee_id,0,0)# (#listgetat(ay_list(),attributes.sal_mon,',')# #attributes.sal_year#)">
<cfset start_date_ = CreateODBCDatetime('#attributes.sal_year#-#attributes.sal_mon#-01')>
<cfset son_gun = daysinmonth(start_date_)>
<cfset finish_date_ = CreateODBCDatetime('#attributes.sal_year#-#attributes.sal_mon#-#son_gun#')>
<cfquery name="get_daily_in_out" datasource="#dsn#">
    SELECT
        E.EMPLOYEE_ID,
        E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME,
        EIO.PDKS_NUMBER,
        ED.IN_OUT_ID,
        ED.ROW_ID,
        ED.FILE_ID,
        ED.IS_WEEK_REST_DAY,
        ED.BRANCH_ID,
        ED.START_DATE,
        ED.FINISH_DATE,
        B.BRANCH_NAME
    FROM
        EMPLOYEE_DAILY_IN_OUT ED,
        EMPLOYEES E,
        EMPLOYEES_IN_OUT EIO,
        BRANCH B
    WHERE
        ED.IN_OUT_ID = EIO.IN_OUT_ID AND
        ED.EMPLOYEE_ID = E.EMPLOYEE_ID AND
        ED.BRANCH_ID = B.BRANCH_ID AND
        ED.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
        (
            (ED.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date_#"> AND ED.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,finish_date_)#">) OR ED.START_DATE IS NULL
        )
        AND
        ((ED.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date_#"> AND ED.FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,finish_date_)#">) OR ED.FINISH_DATE IS NULL)
        AND ISNULL(ED.FROM_HOURLY_ADDFARE,0) = 0
</cfquery>
<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
    <cf_box>
        <!--- <cf_ajax_list>
            <tr>
                <td height="20" id="İzinler" style="cursor:pointer;" onClick="hepsini_gizle(id);gizle_goster(gizli1);"><strong>&raquo; <cf_get_lang dictionary_id='52986.İzinler'></strong></td>					
            </tr>
            <tr>
                <td height="20" id="Fazla Mesailer" style="cursor:pointer;" onClick="hepsini_gizle(id);gizle_goster(gizli2);"><strong>&raquo; <cf_get_lang dictionary_id='52970.Fazla Mesailer'></strong></td>					
            </tr>
            <tr>
                <td height="20" id="Ödenekler" style="cursor:pointer;" onClick="hepsini_gizle(id);gizle_goster(gizli3);"><strong>&raquo; <cf_get_lang dictionary_id='53605.Ödenekler'></strong></td>					
            </tr>
            <tr>
                <td height="20" id="Kesintiler" style="cursor:pointer;" onClick="hepsini_gizle(id);gizle_goster(gizli4);"><strong>&raquo; <cf_get_lang dictionary_id='38977.Kesintiler'></strong></td>					
            </tr>
            <tr>
                <td height="20" id="Vergi İstisnaları" style="cursor:pointer;" onClick="hepsini_gizle(id);gizle_goster(gizli5);"><strong>&raquo; <cf_get_lang dictionary_id='53085.Vergi İstisnaları'></strong></td>					
            </tr>
            <tr>
                <td height="20" id="PDKS Listesi" style="cursor:pointer;" onClick="hepsini_gizle(id);gizle_goster(gizli6);"><strong>&raquo; <cf_get_lang dictionary_id='29494.PDKS Listesi'></strong></td>					
            </tr>
        </cf_ajax_list> --->
        <ul class="ui-list">
            <li id="izinler" onClick="hepsini_gizle(id);gizle_goster(gizli1);">
                <a href="javascript:void(0)">
                    <div class="ui-list-left">
                        <span class="ui-list-icon ctl-flight"></span>
                        <cf_get_lang dictionary_id='52986.İzinler'>
                    </div>
                </a>
            </li>
            <li id="fazla_mesailer"  onClick="hepsini_gizle(id);gizle_goster(gizli2)">
                <a href="javascript:void(0)">
                    <div class="ui-list-left">
                        <span class="ui-list-icon ctl-briefcase"></span>
                        <cf_get_lang dictionary_id='52970.Fazla Mesailer'>
                    </div>
                </a>
            </li>
            <li id="odenekler" onClick="hepsini_gizle(id);gizle_goster(gizli3);">
                <a href="javascript:void(0)">
                    <div class="ui-list-left">
                        <span class="ui-list-icon ctl-measuring"></span>
                        <cf_get_lang dictionary_id='53605.Ödenekler'>
                    </div>
                </a>
            </li>
            <li id="kesintiler" onClick="hepsini_gizle(id);gizle_goster(gizli4);">
                <a href="javascript:void(0)">
                    <div class="ui-list-left">
                        <span class="ui-list-icon ctl-calculating"></span>
                        <cf_get_lang dictionary_id='38977.Kesintiler'>
                    </div>
                </a>
            </li>
            <li id="vergi_istisnalari"  onClick="hepsini_gizle(id);gizle_goster(gizli5);">
                <a href="javascript:void(0)">
                    <div class="ui-list-left">
                        <span class="ui-list-icon ctl-finances"></span>
                        <cf_get_lang dictionary_id='53085.Vergi İstisnaları'>
                    </div>
                </a>
            </li>
            <li id="pdks_listesi" onClick="hepsini_gizle(id);gizle_goster(gizli6);">
                <a href="javascript:void(0)">
                    <div class="ui-list-left">
                        <span class="ui-list-icon ctl-network-1"></span>
                        <cf_get_lang dictionary_id='29494.PDKS Listesi'>
                    </div>
                </a>
            </li>
        </ul>
    </cf_box>
</div>
<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
    <cfset izin_gun_toplam=0>
    <cfset sayfa_dakika = 0>
    <cfset odenek_toplam_tutar=0>
    <cfset kesinti_toplam_tutar=0>
    <cfset istisna_toplam_tutar=0>
    <cf_box 
        id="orta_box" 
        closable="0" 
        title="#getLang('','İzinler','52986')#"
        box_page="#request.self#?fuseaction=ehesap.employee_payroll_ajax&employee_id=#attributes.employee_id#&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&in_out_id=#attributes.in_out_id#">
    </cf_box>
    <cfoutput>
        <b><cf_get_lang dictionary_id="58575.İzin"> : </b><label name="total_offtime" id="total_offtime">#izin_gun_toplam# <cf_get_lang dictionary_id="57490.gün"></label><br />
        <b><cf_get_lang dictionary_id="52970.Fazla Mesailer"> : </b><label name="total_ext_work" id="total_ext_work">#sayfa_dakika# <cf_get_lang dictionary_id='58827.Dk'> (#int(sayfa_dakika/60)# <cf_get_lang dictionary_id='57491.saat'> <cfif sayfa_dakika gt (int(sayfa_dakika/60)*60)>#sayfa_dakika - (int(sayfa_dakika/60) * 60)#</cfif> <cf_get_lang dictionary_id="58827.dk">)</label><br />
        <b><cf_get_lang dictionary_id="40665.Ödenekler"> : </b><label name="total_pay" id="total_pay">#TLFormat(odenek_toplam_tutar)#</label><br />
        <b><cf_get_lang dictionary_id="38977.Kesintiler"> : </b><label name="total_int" id="total_int">#TLFormat(kesinti_toplam_tutar)#</label> <br />
        <b><cf_get_lang dictionary_id="32195.Vergi İstisnaları"> : </b><label name="total_tax" id="total_tax">#TLFormat(istisna_toplam_tutar)#</label><br />
        <b><cf_get_lang dictionary_id="29494.PDKS Listesi"> : </b><label name="total_pdks" id="total_pdks">#get_daily_in_out.recordcount# <cf_get_lang dictionary_id="57483.kayıt"></label><br />
        </cfoutput>
</div>
<table class="dpm">
    <tr>
        <td class="dpml">
            <table width="100%">
                <tr>
                    <td valign="top" width="200">
                        
					</td>
                    <tr>
                    	<td valign="top">
                        	
                        </td>
                    </tr>
				<tr>
					<td valign="top">
						
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>	
</cf_popup_box>
<script type="text/javascript">
	function hepsini_gizle(id)
	{
        $('#handle_orta_box').text("").append("<a href='javascript://'>" + $('#'+id).find('div').text().trim() + "</a>"); 
		for(var i=1;i<=6;i++)
		{
			document.getElementById('gizli'+i).style.display='none';
		}
	}
</script>

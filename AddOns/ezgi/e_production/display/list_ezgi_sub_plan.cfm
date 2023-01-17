<cfsetting showdebugoutput="no">
<cfquery name="get_default" datasource="#dsn3#">
	SELECT       
    	EMAD.POINT_METHOD,
        EMAD.FABRIC_CAT,
        EMAD.CONTROL_METHOD
	FROM            
    	EZGI_MASTER_PLAN_DEFAULTS AS EMAD INNER JOIN
     	EZGI_MASTER_PLAN AS EMAP ON EMAD.SHIFT_ID = EMAP.MASTER_PLAN_CAT_ID
	WHERE        
    	EMAP.MASTER_PLAN_ID = #attributes.upd#
</cfquery>
<cfquery name="GET_MASTER_ALT_PLAN" datasource="#DSN3#">
	SELECT
		MASTER_ALT_PLAN_ID, 
        MASTER_ALT_PLAN_NO, 
        PROCESS_ID,
        (
        SELECT     
        	STAGE
		FROM         
        	#dsn_alias#.PROCESS_TYPE_ROWS AS PTR
		WHERE     
        	PROCESS_ROW_ID = MASTER_ALT_PLAN_STAGE
        ) as MASTER_ALT_PLAN_NAME,
        MASTER_ALT_PLAN_STAGE, 
        RECORD_EMP, 
        RECORD_DATE, 
        PLAN_START_DATE,
        PLAN_FINISH_DATE,
        ISNULL(PLAN_POINT,0) AS W_POINT, 
      	LTRIM(PLAN_DETAIL) AS PLAN_DETAIL,
        <cfif get_default.POINT_METHOD eq 1>
            ISNULL(
                (
                    SELECT     
                        SUM(PO.QUANTITY) AS P_POINT
                    FROM         
                        EZGI_MASTER_PLAN_RELATIONS AS EMPR INNER JOIN
                        PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID
                    WHERE     
                        EMPR.MASTER_ALT_PLAN_ID = EZGI_MASTER_ALT_PLAN.MASTER_ALT_PLAN_ID
          	),0) AS TOTAL_POINT,
            ISNULL(
                (
                    SELECT     
                        SUM(PO.QUANTITY) AS P_POINT
                    FROM         
                        EZGI_MASTER_PLAN_RELATIONS AS EMPR INNER JOIN
                        PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID
                    WHERE     
                        EMPR.MASTER_ALT_PLAN_ID = EZGI_MASTER_ALT_PLAN.MASTER_ALT_PLAN_ID AND PO.IS_STAGE = 2
         	),0) AS G_POINT,
    	<cfelseif get_default.POINT_METHOD eq 2>
        	ISNULL(
                	(	
                    SELECT     
                		SUM(PO.QUANTITY * ISNULL(PTIP.PROPERTY2, 0)) AS P_POINT
                    FROM         
                        EZGI_MASTER_PLAN_RELATIONS AS EMPR INNER JOIN
                        PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID LEFT OUTER JOIN
                        PRODUCT_TREE_INFO_PLUS AS PTIP ON PO.STOCK_ID = PTIP.STOCK_ID
                    WHERE     
                        EMPR.MASTER_ALT_PLAN_ID =  EZGI_MASTER_ALT_PLAN.MASTER_ALT_PLAN_ID
        	),0) AS TOTAL_POINT,
        	ISNULL(
                	(	
                    SELECT     
                		SUM(PO.QUANTITY * ISNULL(PTIP.PROPERTY2, 0)) AS P_POINT
                    FROM         
                        EZGI_MASTER_PLAN_RELATIONS AS EMPR INNER JOIN
                        PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID LEFT OUTER JOIN
                        PRODUCT_TREE_INFO_PLUS AS PTIP ON PO.STOCK_ID = PTIP.STOCK_ID
                    WHERE     
                        EMPR.MASTER_ALT_PLAN_ID =  EZGI_MASTER_ALT_PLAN.MASTER_ALT_PLAN_ID AND PO.IS_STAGE = 2
         	),0) AS G_POINT,
      	</cfif>
      	ISNULL(
            (
            	SELECT     
                	COUNT(*) AS EMIR_ADET
				FROM         
                	EZGI_MASTER_PLAN_RELATIONS AS EMPR INNER JOIN
                    PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID
				WHERE     
                	EMPR.MASTER_ALT_PLAN_ID = EZGI_MASTER_ALT_PLAN.MASTER_ALT_PLAN_ID
				GROUP BY 
                	EMPR.MASTER_ALT_PLAN_ID
            ),0) AS EMIR_ADET    
	FROM
		EZGI_MASTER_ALT_PLAN
	WHERE
		MASTER_PLAN_ID = #attributes.upd# AND 
        PROCESS_ID = #islem_id#
	ORDER BY
		PLAN_FINISH_DATE DESC
</cfquery>
<cfquery name="get_w" datasource="#dsn3#">
	SELECT     
    	SIRA
	FROM         
    	EZGI_MASTER_PLAN_SABLON
	WHERE     
    	PROCESS_ID = #islem_id#
</cfquery>
<table cellspacing="1" cellpadding="2" width="100%" border="0" class="color-border">
  	<tr class="color-list" height="22">
      	<td class="txtboldblue" width="60"><cf_get_lang_main no='3212.Alt Plan'> No</td>
        <td class="txtboldblue" width="100" nowrap><cf_get_lang_main no='467.İşlem Tarihi'></td>
        <td class="txtboldblue" ><cf_get_lang_main no='1174.İşlemi Yapan'></td>
        <td class="txtboldblue" width="60"><cf_get_lang_main no='539.Hedef'></td>
        <td class="txtboldblue" width="60"><cf_get_lang_main no='1457.Planlanan'></td>
        <td class="txtboldblue" width="60"><cfoutput>#getLang('report',1004)#</cfoutput></td>
        <td class="txtboldblue" width="100"><cfoutput>#getLang('stock',179)#</cfoutput></td>
        <td class="txtboldblue" width="100"><cfoutput>#getLang('prod',293)#</cfoutput></td>
        <!---<td class="txtboldblue" width="80"><cf_get_lang_main no='70.Aşama'></td>--->
        <td class="txtboldblue"><cf_get_lang_main no='217.Açıklama'></td>
        <td width="20" align="center">
        	<a href="javascript://" onClick="secim(-4);"><img src="../images/print.gif" border="0"></a>
        </td>
        <td width="20" align="center">
        	<a href="javascript://" onClick=<cfoutput>"windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_master_sub_plan_manual&master_plan_id=#attributes.upd#&islem_id=#islem_id#','longpage');"</cfoutput>><img src="/images/plus_list.gif" align="absmiddle" border="0"  alt="Stok Üretim">
            </a>
       	</td>
  	</tr>
	<cfoutput query="GET_MASTER_ALT_PLAN">
      	<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
            <td>
                <a href="#request.self#?fuseaction=prod.upd_ezgi_master_sub_plan_manual&master_plan_id=#attributes.upd#&master_alt_plan_id=#master_alt_plan_id#&islem_id=#islem_id#" class="tableyazi">#MASTER_ALT_PLAN_NO#
                </a>
            </td>
            <td style="text-align:center">#dateformat(RECORD_DATE,'dd/mm/yyyy')# #timeformat(RECORD_DATE,'HH:mm')#</td>
            <td>&nbsp;#get_emp_info(RECORD_EMP,0,1)#</td>
            <td style="text-align:right">#TlFormat(W_POINT,2)#&nbsp;</td>
            <td style="text-align:right" bgcolor="<cfif total_point neq 0><cfif total_point gte w_point>red<cfelseif total_point gte w_point/2>orange<cfelse>green</cfif></cfif>">#Tlformat(TOTAL_POINT,2)#&nbsp;</td>
            <td style="text-align:right;" bgcolor="<cfif g_point neq 0><cfif g_point gte total_point>red<cfelseif g_point gte total_point/2>orange<cfelse>green</cfif></cfif>">#TlFormat(G_POINT,2)#&nbsp;</td>
            <td style="text-align:center">#dateformat(PLAN_START_DATE,'dd/mm/yyyy')# #timeformat(PLAN_START_DATE,'HH:mm')#</td>
            <td style="text-align:center">#dateformat(PLAN_FINISH_DATE,'dd/mm/yyyy')# #timeformat(PLAN_FINISH_DATE,'HH:mm')#</td>
            <!---<td>&nbsp;#GET_MASTER_ALT_PLAN.MASTER_ALT_PLAN_NAME#</td>--->
            <td>&nbsp;#PLAN_DETAIL#&nbsp;</td>
            <td width="20" align="center">
                <cfif EMIR_ADET lte 0>
                    <a href="#request.self#?fuseaction=prod.del_ezgi_master_sub_plan&master_plan_id=#attributes.upd#&master_alt_plan_id=#master_alt_plan_id#&islem_id=#islem_id#">
                        <img src="/images/delete_list.gif" align="absmiddle" border="0"/>
                    </a>
                <cfelse>
                    <input type="checkbox" name="select_sub_plan" value="#MASTER_ALT_PLAN_ID#">
                </cfif>
            </td>
            <td width="20">
                <a href="#request.self#?fuseaction=prod.upd_ezgi_master_sub_plan_manual&master_plan_id=#attributes.upd#&master_alt_plan_id=#master_alt_plan_id#&islem_id=#islem_id#"><img src="/images/update_list.gif" align="absmiddle" border="0"/></a>
          	</td>
      	</tr>
  	</cfoutput>
    <tr class="color-row">
    	<td colspan="8" align="right"></td>
    	<td align="right" nowrap="nowrap">&nbsp;&nbsp;
			<input type="button" value="<cf_get_lang_main no='3246.Malzeme İhtiyacı'>" style="font-size:8px" onClick="secim(-3);" />
            <cfif get_w.SIRA eq 1>
          		<input type="button" value="<cf_get_lang_main no='3329.Tüm Malzeme İhtiyacı'>" style="font-size:8px" onClick="secim(-2);" alt="<cf_get_lang_main no='3330.Tüm İlişkili Alt Planlar'>" />
            </cfif>
		</td>
        <td align="right">
        	<input type="checkbox" alt="<cf_get_lang no ='546.Hepsini Seç'>" onClick="secim(-1);">
        </td>
        <td align="right">
        </td>
	</tr>
</table>
<script language="javascript">
	function secim(type)
	{//type sadece -1 olarak gelir,-1 geliyorsa hepsini seç demektir.
		sub_plan_id_list = '';
		chck_leng = document.getElementsByName('select_sub_plan').length;
		for(ci=0;ci<chck_leng;ci++)
		{
			var my_objets = document.all.select_sub_plan[ci];
			if(chck_leng == 1)
				var my_objets =document.all.select_sub_plan;
			if(type == -1){//hepsini seç denilmişse	
				if(my_objets.checked == true)
					my_objets.checked = false;
				else
					my_objets.checked = true;
			}
			else
			{
				if(my_objets.checked == true)
					sub_plan_id_list +=my_objets.value+',';
			}
		}
		sub_plan_id_list = sub_plan_id_list.substr(0,sub_plan_id_list.length-1);//sondaki virgülden kurtarıyoruz.
		if(list_len(sub_plan_id_list,','))
		{
			<cfoutput>
				var master_alt_plan_id=#GET_MASTER_ALT_PLAN.MASTER_ALT_PLAN_ID#;
				var master_plan_id=#attributes.upd#;
				var islem_id=#GET_MASTER_ALT_PLAN.PROCESS_ID#;
			</cfoutput>
			if(type == -2)
			{
				windowopen('<cfoutput>#request.self#?fuseaction=prod.emptypopup_get_ezgi_sub_plan_metarial&type=5</cfoutput>&sub_plan_id_list='+sub_plan_id_list+'&islem_id='+islem_id+'&master_plan_id='+master_plan_id+'&master_alt_plan_id='+master_alt_plan_id,'longpage');
			}
			else if(type == -3)
			{
				windowopen('<cfoutput>#request.self#?fuseaction=prod.emptypopup_get_ezgi_sub_plan_metarial&type=6</cfoutput>&sub_plan_id_list='+sub_plan_id_list+'&islem_id='+islem_id+'&master_plan_id='+master_plan_id+'&master_alt_plan_id='+master_alt_plan_id,'longpage');
			}
			else if(type == -4)
			{
				window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_print_files&print_type=289&action_id='+sub_plan_id_list);	
			}
		}
	}
</script>
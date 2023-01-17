<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.department_id" default="">
<cfquery name="STORES" datasource="#dsn#">
	SELECT * FROM DEPARTMENT D WHERE D.IS_STORE <> 2 AND D.DEPARTMENT_STATUS = 1 AND BRANCH_ID IN (SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID <> #SESSION.EP.COMPANY_ID#) ORDER BY D.DEPARTMENT_HEAD
</cfquery>
<cfquery name="GET_COMPANY_IDS" datasource="#dsn#">
	SELECT COMPANY_ID FROM COMPANY WHERE OUR_COMPANY_ID = #SESSION.EP.COMPANY_ID#
</cfquery>
<cfset company_list = valuelist(GET_COMPANY_IDS.COMPANY_ID)>
<cfquery name="SETUP_PERIODS" datasource="#dsn#">
	SELECT SP.*,OC.NICK_NAME FROM SETUP_PERIOD SP,OUR_COMPANY OC WHERE SP.PERIOD_YEAR = #SESSION.EP.PERIOD_YEAR# AND SP.OUR_COMPANY_ID <> #SESSION.EP.COMPANY_ID# AND OC.COMP_ID = SP.OUR_COMPANY_ID ORDER BY SP.OUR_COMPANY_ID ASC
</cfquery>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfset period_list = valuelist(SETUP_PERIODS.OUR_COMPANY_ID)>
<cfif listlen(company_list) and listlen(period_list)>
	<cfquery name="GET_RECORD_OF_ACTION" datasource="#DSN#">
		<cfset c = 0>
		<cfloop list="#period_list#" index="i">
			<cfset c = c + 1>
			<cfquery name="get_period_info" dbtype="query">
				SELECT * FROM SETUP_PERIODS WHERE OUR_COMPANY_ID = #i#
			</cfquery>
			<cfset 'b#i#' = get_period_info.NICK_NAME>			
			<cfset a = dsn&'_'&get_period_info.PERIOD_YEAR&'_'&i>	
			<cfset d = get_period_info.OUR_COMPANY_ID>	
			<cfset new_dsn3 = dsn&'_'&i>
			<cfset old_period_id = get_period_info.PERIOD_ID>	
			SELECT			
				'#old_period_id#' AS OLD_PERIOD_ID,
				'#new_dsn3#'+'' AS NEW_DSN3,
				'#evaluate("b#i#")#' AS S_COMPANY_NAME,
				'#d#' AS OUR_COMPANY_ID,
				S.PURCHASE_SALES ,
				S.SHIP_ID AS ISLEM_ID,
				S.SHIP_NUMBER AS BELGE_NO,
				S.SHIP_TYPE AS ISLEM_TIPI,
				S.SHIP_DATE AS ISLEM_TARIHI,
				S.COMPANY_ID,
				C.FULLNAME,
				S.DELIVER_STORE_ID AS DEPARTMENT_ID_2
			FROM 	
				#a#.SHIP S,
				COMPANY C		
			WHERE
				S.SHIP_TYPE IN (70,71,72,78,79,81,83) AND
				S.IS_EXPORTED IS NULL AND
				S.COMPANY_ID IN (#company_list#) AND
				C.COMPANY_ID = S.COMPANY_ID
			<cfif len(attributes.keyword)>
				AND ( S.SHIP_NUMBER LIKE '%#attributes.keyword#%' OR C.FULLNAME LIKE '%#attributes.keyword#%' )
			</cfif>
			<cfif len(attributes.department_id)>
				AND S.DELIVER_STORE_ID = #attributes.department_id#
			</cfif>
			<cfif c neq listlen(period_list)>
				UNION
			</cfif>
		</cfloop>
	</cfquery>
	<cfquery name="FIS" dbtype="query">
		SELECT * FROM GET_RECORD_OF_ACTION
		<cfif isDefined('attributes.oby') and attributes.oby eq 2>
			ORDER BY ISLEM_TARIHI
		<cfelseif isDefined('attributes.oby') and attributes.oby eq 3>
			ORDER BY BELGE_NO
		<cfelseif isDefined('attributes.oby') and attributes.oby eq 4>
			ORDER BY BELGE_NO DESC
		<cfelse>
			ORDER BY ISLEM_TARIHI DESC
		</cfif>	
	</cfquery>
<cfelse>
	<cfset GET_RECORD_OF_ACTION.recordcount = 0>
	<cfset FIS.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#fis.recordcount#">
<cfform name="stock_search" action="#request.self#?fuseaction=store.list_group_ships" method="post">
	<cf_big_list_search title="#getLang('main',2272)#"> 
		<cf_big_list_search_area>
			<table>
				<tr>
                	<cfinput type="hidden" name="is_form_submitted" value="1">
					<td><cf_get_lang_main no='48.Filtre'></td>
					<td><cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
					<td>             
						<select name="department_id" id="department_id">
							<option value=""><cf_get_lang no ='104.Tüm Depolar'></option>
							<cfoutput query="stores">
								<option value="#DEPARTMENT_ID#"<cfif isDefined("attributes.DEPARTMENT_ID") and attributes.DEPARTMENT_ID eq DEPARTMENT_ID> selected</cfif>>#department_head#</option>
							</cfoutput>
						</select>
					</td> 
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" maxlength="3" onKeyUp="isNumber(this)" validate="integer" range="1,250" required="yes" message="#message#">
					</td>
					<td style="text-align:right;"><cf_wrk_search_button></td>
				<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
				</tr>	
			</table>
		</cf_big_list_search_area>
	</cf_big_list_search>
</cfform>	   
<cf_big_list>
	<thead>
		<tr>
        	<th width="35"><cf_get_lang_main no="1165.Sıra"></th>
			<th width="125"><cf_get_lang no='122.Grup Şirketi'></th>
			<th width="75"><cf_get_lang_main no ='330.Tarih'></th>
			<th width="75"><cf_get_lang_main no='468.Belge No'></th>
			<th><cf_get_lang_main no ='1166.Belge Türü'></th>
			<th><cf_get_lang_main no ='107.Cari Hesap'></th>
			<th><cf_get_lang no ='14.Depo Çıkış'></th>
			<th class="header_icn_none">&nbsp;</th>		  
			
		</tr>
	</thead>
	<tbody>
		<cfif fis.recordcount and form_varmi eq 1>
			<cfset dept_id_list=''>
			<cfoutput query="FIS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(DEPARTMENT_ID_2)>
					<cfif not listfind(dept_id_list,DEPARTMENT_ID_2)>
						<cfset dept_id_list=listappend(dept_id_list,DEPARTMENT_ID_2)>
					</cfif>
				</cfif>
			</cfoutput>
			<cfif len(dept_id_list)>
				<cfset dept_id_list=listsort(dept_id_list,"numeric","ASC",",")>
				<cfquery name="get_dept_detail" datasource="#dsn#" >
					SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#dept_id_list#) ORDER BY DEPARTMENT_ID
				</cfquery> 
			</cfif>
			<cfoutput query="fis" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
                	<td>#currentrow#</td>
					<td>#S_COMPANY_NAME#</td>			  
					<td>#dateformat(ISLEM_TARIHI,dateformat_style)#</td>
					<td>#BELGE_NO#</td>
					<td>
						<cfif ISLEM_TIPI eq 111><cf_get_lang_main no="1831.Sarf Fişi">
						<cfelseif ISLEM_TIPI eq 112><cf_get_lang_main no="1832.Fire Fişi"> 
							<cfelseif ISLEM_TIPI eq 110><cf_get_lang_main no="1841.Üretimden Giriş Fişi">
							<cfelseif ISLEM_TIPI eq 114><cf_get_lang_main no="1834.Devir Fişi"> 
							<cfelseif ISLEM_TIPI eq 113><cf_get_lang no="151.Depo Fişi">
							<cfelseif ISLEM_TIPI eq 115><cf_get_lang_main no="1835.Sayım Fişi">
							<cfelseif ISLEM_TIPI eq 76><cf_get_lang_main no="1784.Mal Alım İrsaliyesi">
							<cfelseif ISLEM_TIPI eq 78><cf_get_lang_main no="1787.Alım İade İrsaliyesi">
							<cfelseif ISLEM_TIPI eq 77><cf_get_lang no="188.Konsinye Giriş">
							<cfelseif ISLEM_TIPI eq 79><cf_get_lang no="189.Konsinye Giriş İade">
							<cfelseif ISLEM_TIPI eq 80><cf_get_lang_main no="411.Müstahsil Makbuz">
							<cfelseif ISLEM_TIPI eq 81><cf_get_lang_main no="1790.Sevk İrsaliyesi">
							<cfelseif ISLEM_TIPI eq 71><cf_get_lang_main no="1340.Toptan Satış İrsaliyesi">
							<cfelseif ISLEM_TIPI eq 70><cf_get_lang no="190.Parekande Satış İrsaliyesi">
							<cfelseif ISLEM_TIPI eq 72><cf_get_lang_main no="1341.Konsinye Çıkış İrsaliyesi">
							<cfelseif ISLEM_TIPI eq 73><cf_get_lang no="191.Parekende Satış İade İrsaliyesi">
							<cfelseif ISLEM_TIPI eq 74><cf_get_lang_main no="1783.Toptan Satış İade İrsaliyesi">
							<cfelseif ISLEM_TIPI eq 75><cf_get_lang_main no="1343.Konsinye Çıkış İade İrsaliyesi">
							<cfelseif ISLEM_TIPI eq 761><cf_get_lang_main no="1785.Hal İrsaliyesi">
							<cfelseif ISLEM_TIPI eq 82><cf_get_lang_main no="1792.Demirbaş Alım İrsaliyesi">
							<cfelseif ISLEM_TIPI eq 83><cf_get_lang_main no="1793.Demirbaş Satış İrsaliyesi">
						</cfif>
					</td>
					<td>#FULLNAME#</td>
					<td>
						<cfif len(DEPARTMENT_ID_2) and (DEPARTMENT_ID_2 neq 0)>
							#get_dept_detail.DEPARTMENT_HEAD[listfind(dept_id_list,DEPARTMENT_ID_2,',')]#
						</cfif>
					</td>
					<!-- sil -->
					<td align="center">
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=store.popup_add_ship_group_comp&ship_id=#ISLEM_ID#&our_company_id=#OUR_COMPANY_ID#&old_period_id=#old_period_id#','list');"><img src="images/plus1.gif"></a>
					</td>
					<!-- sil -->
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="8"><cfif form_varmi eq 0><cf_get_lang_main no="289.Filtre Ediniz">!<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfset adres="store.list_group_ships">
<cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
	<cfset adres = "#adres#&is_form_submitted=#attributes.is_form_submitted#">
</cfif>
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
	<cfset adres = "#adres#&department_id=#attributes.department_id#">
</cfif>
<cf_paging page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="#adres#"> 
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

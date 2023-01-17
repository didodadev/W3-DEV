<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.is_submit")>
<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
	SELECT 
		PRICE_CATID,
        PRICE_CAT_STATUS,
        GUEST,
        COMPANY_CAT,
        CONSUMER_CAT,
        BRANCH,
        #dsn#.Get_Dynamic_Language(PRICE_CATID,'#session.ep.language#','PRICE_CAT','PRICE_CAT',NULL,NULL,PRICE_CAT) AS PRICE_CAT,
        DISCOUNT,
        IS_KDV,
        TARGET_MARGIN,
        TARGET_MARGIN_ID,
        MARGIN,
        STARTDATE,
        FINISHDATE,
        VALID_DATE,
        VALID_EMP,
        MONEY_ID,
        ROUNDING,
        NUMBER_OF_INSTALLMENT,
        AVG_DUE_DAY,
        DUE_DIFF_VALUE,
        PAYMETHOD,
        EARLY_PAYMENT,
        TARGET_DUE_DATE,
        IS_CALC_PRODUCTCAT,
        IS_SALES,
        IS_PURCHASE,
        POSITION_CAT,
        RECORD_EMP,
        RECORD_DATE,
        RECORD_IP,
        UPDATE_EMP,
        UPDATE_DATE,
        UPDATE_IP
	FROM 
		PRICE_CAT 
	<cfif len(attributes.keyword)>
		WHERE PRICE_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
	</cfif> 
	ORDER BY PRICE_CAT
</cfquery>
<cfelse>
	<cfset get_price_cat.recordcount = 0>
</cfif>
<cfquery name="CALCULATE_AC_PRD_ALL" datasource="#DSN3#">
	SELECT COUNT(PRICE_ID) SUM_PRD, PRICE_CATID FROM PRICE WHERE STARTDATE <= #now()# AND (FINISHDATE >= #now()# OR FINISHDATE IS NULL) GROUP BY PRICE_CATID
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_price_cat.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_price_cat" action="#request.self#?fuseaction=product.list_price_cat" method="post">
			<input type="hidden" name="is_submit" id="is_submit" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" maxlength="50" value="#attributes.keyword#" placeholder="#message#">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" validate="integer" range="1,999" maxlength="3">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cf_wrk_search_button button_type="4" search_function="kontrol()">
						<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
					</div>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='37028.Fiyat Listeleri'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sira'></th>
					<th><cf_get_lang dictionary_id='37144.Liste Adı'></th>
					<th><cf_get_lang dictionary_id='37220.Fiyat Geçerlilik Alanları'></th>
					<th><cf_get_lang dictionary_id='37045.Marj'></th>
					<th class="form-title" width="80" align="center"><cf_get_lang dictionary_id='37221.Aktif Ürün'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none"><a onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.list_price_cat&event=add</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_price_cat.recordcount>
					<cfset consumer_cat_list = "">
					<cfset company_cat_list = "">
					<cfset branch_list = "">
					<cfoutput query="get_price_cat" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<cfif Len(consumer_cat) and not ListFind(consumer_cat_list,consumer_cat,',')>
							<cfset consumer_cat_list = ListAppend(consumer_cat_list,consumer_cat,',')>
						</cfif>
						<cfif Len(company_cat) and not ListFind(company_cat_list,company_cat,',')>
							<cfset company_cat_list = ListAppend(company_cat_list,company_cat,',')>
						</cfif>
						<cfif Len(branch) and not ListFind(company_cat_list,branch,',')>
							<cfset branch_list = ListAppend(branch_list,branch,',')>
						</cfif>
					</cfoutput>
					<cfif ListLen(consumer_cat_list)>
						<cfset consumer_cat_list=ListSort(consumer_cat_list,"numeric","ASC",",")>
						<cfquery name="get_consumer_cat" datasource="#dsn#">
							SELECT CONSCAT_ID, CONSCAT FROM CONSUMER_CAT WHERE CONSCAT_ID IN (#consumer_cat_list#) ORDER BY CONSCAT_ID
						</cfquery>
						<cfset consumer_cat_list = ListSort(ListDeleteDuplicates(ValueList(get_consumer_cat.conscat_id)),'numeric','ASC',',')>
					</cfif>
					<cfif ListLen(company_cat_list)>
						<cfset company_cat_list=ListSort(company_cat_list,"numeric","ASC",",")>
						<cfquery name="get_company_cat" datasource="#dsn#">
							SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_ID IN (#company_cat_list#) ORDER BY COMPANYCAT_ID
						</cfquery>
						<cfset company_cat_list = ListSort(ListDeleteDuplicates(ValueList(get_company_cat.companycat_id)),'numeric','ASC',',')>
					</cfif>
					<cfif ListLen(branch_list)>
						<cfset branch_list=ListSort(branch_list,"numeric","ASC",",")>
						<cfquery name="get_branch" datasource="#dsn#">
							SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH  WHERE BRANCH_ID IN (#branch_list#) ORDER BY BRANCH_ID
						</cfquery>
						<cfset branch_list = ListSort(ListDeleteDuplicates(ValueList(get_branch.branch_id)),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_price_cat" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<cfset attributes.pcat_id = price_catid>
						<input type="hidden" name="price_catid" id="price_catid" value="#price_catid#">
						<cfinclude template="../query/get_price_cat_rows.cfm">
						<tr>
							<td width="35">#currentrow#</td>
							<td><cfif get_price_cat_rows.recordcount>
									<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=product.form_upd_pricecat_2_productcat&pcat_id=#price_catid#')" class="tableyazi">#price_cat#</a>
								<cfelse>
									<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=product.list_price_cat&event=upd&pcat_id=#price_catid#')" class="tableyazi">#price_cat#</a>
								</cfif>
							</td>
							<td><cfif ListLen(consumer_cat)>
									<cfloop list="#ListDeleteDuplicates(consumer_cat)#" index="con">
										<font color="0099FF">#get_consumer_cat.conscat[ListFind(consumer_cat_list,con,',')]#,</font>
									</cfloop>
								</cfif>
								<cfif ListLen(company_cat)>
									<cfloop list="#ListDeleteDuplicates(company_cat)#" index="com">
										#get_company_cat.companycat[ListFind(company_cat_list,com,',')]#,
									</cfloop>
								</cfif>
								<cfif ListLen(branch)>
									<cfloop list="#ListDeleteDuplicates(branch)#" index="bra">
										<font color="##ff0000">#get_branch.branch_name[ListFind(branch_list,bra,',')]#,</font>
									</cfloop>
								</cfif>
								<cfif not ListLen(consumer_cat) and not ListLen(company_cat) and not ListLen(branch)>
									<cf_get_lang dictionary_id='37140.Yayın Alanı'><cf_get_lang dictionary_id='58546.Yok'>
								</cfif>
							</td>
							<td style="text-align:right;">#margin#</td>
								<cfquery name="calculate_ac_prd" dbtype="query">
									SELECT SUM_PRD FROM CALCULATE_AC_PRD_ALL WHERE PRICE_CATID = #attributes.pcat_id#
								</cfquery>
							<td style="text-align:right;">#calculate_ac_prd.sum_prd#</td>
							<!-- sil -->
							<td width="1%"><a onClick="openBoxDraggable('#request.self#?fuseaction=product.list_price_cat&event=upd&pcat_id=#price_catid#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="6"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
<cfset url_str = "">
<cfif isdefined ("attributes.keyword") and len(attributes.keyword)>
	<cfset url_str ="#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.is_submit") and len(attributes.is_submit)>
	<cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
</cfif>
<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="product.list_price_cat#url_str#">
<br/>
</cf_box>

<cfquery name="GET_PRICE_CAT_ALL" datasource="#DSN3#">
	SELECT COMPANY_CAT,CONSUMER_CAT,BRANCH FROM PRICE_CAT ORDER BY PRICE_CAT
</cfquery>
<cfquery name="GET_CONS_CAT_" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT
</cfquery>
<cfquery name="GET_COMP_CAT_" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT
</cfquery>
<cfquery name="GET_BRANCH_" datasource="#DSN#">
	SELECT
		B.BRANCH_ID,
		B.BRANCH_NAME
	FROM
		BRANCH B,
		ZONE Z
	WHERE 
		B.BRANCH_STATUS = 1 AND
		Z.ZONE_ID = B.ZONE_ID AND
		Z.ZONE_STATUS = 1 AND
		B.COMPANY_ID = #session.ep.company_id#
	ORDER BY
		B.BRANCH_NAME
</cfquery>
<cfset company_cat_list = listdeleteduplicates(valuelist(get_price_cat_all.company_cat,','))>
<cfset consumer_cat_list = listdeleteduplicates(valuelist(get_price_cat_all.consumer_cat,','))>
<cfset branch_list = listdeleteduplicates(valuelist(get_price_cat_all.branch,','))>
<cfset conscat_list = ''>
<cfset companycat_list = ''>
<cfset branch_name_list = ''>
<cfoutput query="get_cons_cat_">
	<cfif not listfind(consumer_cat_list,conscat_id)><cfset conscat_list = listAppend(conscat_list,conscat)></cfif>
</cfoutput>
<cfoutput query="get_comp_cat_">
	<cfif not listfind(company_cat_list,companycat_id)><cfset companycat_list = listAppend(companycat_list,companycat)></cfif>
</cfoutput>
<cfoutput query="get_branch_">
	<cfif not listfind(branch_list,branch_id)><cfset branch_name_list = listAppend(branch_name_list,branch_name)></cfif>
</cfoutput>
	<table width="99%" align="center">
		<tr>
			<td><cfif listlen(conscat_list) or listlen(companycat_list) or listlen(branch_name_list)>
				<cfoutput>
					<cfif listlen(companycat_list)><b><font color="0099FF"><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'> : #listsort(companycat_list,"text","ASC",",")#</font></b><br/></cfif>
					<cfif listlen(conscat_list)><b><font color="FF0000"><cf_get_lang dictionary_id='29406.Bireysel Üyeler'> : #listsort(conscat_list,"text","ASC",",")#</font></b><br/></cfif>
					<cfif listlen(branch_name_list)><b><font color="000000"><cf_get_lang dictionary_id='29434.Şubeler'> : #listsort(branch_name_list,"text","ASC",",")#</font></b><br/></cfif>
				</cfoutput>
				<cf_get_lang dictionary_id='37228.Kategorileri herhangi bir fiyat listesine dahil değildir'>.<br/>
				<cf_get_lang dictionary_id='37229.Bu gruplar Puplic Portal ve Partner Portal de alışveriş yapamayacaktır'>.<br/>					
			</cfif>
			</td>
		</tr>
	</table>
</div>
<script type="text/javascript">
	function kontrol(){
		if(!$("#maxrows").val().length){
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfoutput>"})	
			return false;
		}else
			return true;	
	}
	$('#keyword').focus();
	//document.getElementById('keyword').focus();
</script>

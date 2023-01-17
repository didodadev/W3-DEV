<cfparam name="attributes.keyword" default="">
<cfquery name="GET_CITY_NAME" datasource="#DSN#">
	SELECT CITY_ID,CITY_NAME FROM SETUP_CITY
</cfquery>
<cfquery name="get_our_companies" datasource="#dsn#">
	SELECT 
		DISTINCT
		SP.OUR_COMPANY_ID
	FROM
		EMPLOYEE_POSITIONS EP WITH (NOLOCK),
		SETUP_PERIOD SP WITH (NOLOCK),
		EMPLOYEE_POSITION_PERIODS EPP WITH (NOLOCK),
		OUR_COMPANY O WITH (NOLOCK)
	WHERE 
		SP.OUR_COMPANY_ID = O.COMP_ID AND
		SP.PERIOD_ID = EPP.PERIOD_ID AND
		EP.POSITION_ID = EPP.POSITION_ID 
		<cfif isdefined('session.ep.userid')>
			AND EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		</cfif>
</cfquery>
<cfquery name="get_comp_cat" datasource="#dsn#">
	SELECT 
		COMPANYCAT_ID, 
		COMPANYCAT
	FROM
		GET_MY_COMPANYCAT WITH (NOLOCK)
	WHERE
		<cfif isdefined('session.ep.userid')>
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">  AND
		</cfif>
		<cfif isdefined("attributes.period_id") and Len(attributes.period_id)>
			OUR_COMPANY_ID = #listGetAt(attributes.period_id,2,';')# AND
		</cfif>
		<cfif get_our_companies.recordcount>
			OUR_COMPANY_ID IN (#valuelist(get_our_companies.our_company_id,',')#)
		<cfelse>
			1 = 2	
		</cfif>
	GROUP BY
		COMPANYCAT_ID, 
		COMPANYCAT
	ORDER BY
		COMPANYCAT
</cfquery>

<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.modal_id" default="">

<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfif isdefined('attributes.is_form_submitted') or (isdefined("attributes.keyword") and len(attributes.keyword))>
	<cfquery name="get_partners" datasource="#dsn#">
    SELECT
    	*
    FROM
    (
    	SELECT
        	NULL AS PROJECT_ID,
        	C.COMPANY_ID,
            C.FULLNAME AS TEDARIKCI_ADI,
            '' AS PROJE_ADI,
            C.MEMBER_CODE,
            C.CITY,
            CC.COMPANYCAT
        FROM
        	COMPANY C,
            COMPANY_CAT CC
        WHERE
        	<cfif isdefined("attributes.is_buyer_seller") and attributes.is_buyer_seller eq 0>
            	C.IS_BUYER = 1 AND
            </cfif>
            <cfif isdefined("attributes.is_buyer_seller") and attributes.is_buyer_seller eq 1>
            	C.IS_SELLER = 1 AND
            </cfif>
			<cfif isdefined("attributes.comp_cat") and len(attributes.comp_cat)>
            	C.COMPANYCAT_ID = #attributes.comp_cat# AND
            </cfif>
            C.FULLNAME LIKE '%#attributes.keyword#%' AND
            C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
            C.COMPANY_ID NOT IN (SELECT PP.COMPANY_ID FROM PRO_PROJECTS PP WHERE PP.COMPANY_ID IS NOT NULL)
    UNION ALL
        SELECT
        	PP.PROJECT_ID,
        	C.COMPANY_ID,
            C.FULLNAME TEDARIKCI_ADI,
            PP.PROJECT_HEAD AS PROJE_ADI,
            C.MEMBER_CODE,
            C.CITY,
            CC.COMPANYCAT
        FROM
        	COMPANY C,
            COMPANY_CAT CC,
            PRO_PROJECTS PP
        WHERE
        	<cfif isdefined("attributes.is_buyer_seller") and attributes.is_buyer_seller eq 0>
            	C.IS_BUYER = 1 AND
            </cfif>
            <cfif isdefined("attributes.is_buyer_seller") and attributes.is_buyer_seller eq 1>
            	C.IS_SELLER = 1 AND
            </cfif>
			<cfif isdefined("attributes.comp_cat") and len(attributes.comp_cat)>
            	C.COMPANYCAT_ID = #attributes.comp_cat# AND
            </cfif>
            C.FULLNAME + ' - ' + PP.PROJECT_HEAD LIKE '%#attributes.keyword#%' AND
            C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
            C.COMPANY_ID = PP.COMPANY_ID
    ) 
    	T1
    ORDER BY
    	T1.TEDARIKCI_ADI
    </cfquery>
<cfelse>
	<cfset get_partners.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_partners.recordcount#">

<cfscript>
	url_string = '';
	if (isdefined('attributes.field_comp_name')) url_string = '#url_string#&field_comp_name=#field_comp_name#';
	if (isdefined('attributes.field_comp_id')) url_string = '#url_string#&field_comp_id=#field_comp_id#';
	if (isdefined('attributes.field_project_id')) url_string = '#url_string#&field_project_id=#field_project_id#';
	if (isdefined('attributes.field_comp_code')) url_string = '#url_string#&field_comp_code=#field_comp_code#';
	if (isdefined('attributes.row_id')) url_string = '#url_string#&row_id=#attributes.row_id#';
</cfscript>

<script type="text/javascript">
function load_opener_accounts(c_id,c_name,p_id,comp_code)
{   
	<cfif isdefined("attributes.row_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.$("#jqxgrid").jqxGrid('setcellvalue',<cfoutput>#attributes.row_id#</cfoutput>,'company_name',c_name);
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.$("#jqxgrid").jqxGrid('setcellvalue',<cfoutput>#attributes.row_id#</cfoutput>,'company_code',comp_code);
	<cfelse>
	try
	{
		<cfif isdefined("attributes.field_project_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_project_id#</cfoutput>').value = p_id;
		</cfif>
		<cfif isdefined("attributes.field_comp_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_comp_name#</cfoutput>').value = c_name;
		</cfif>
		<cfif isdefined("attributes.field_comp_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_comp_id#</cfoutput>').value = c_id;
		</cfif>
		<cfif isdefined("attributes.field_comp_code")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_comp_code#</cfoutput>').value = comp_code;
		</cfif>
	}
	catch(e)
	{
		<cfif isdefined("attributes.field_project_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_project_id#</cfoutput>.value = p_id;
		</cfif>
		<cfif isdefined("attributes.field_comp_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_comp_name#</cfoutput>.value = c_name;
		</cfif>
		<cfif isdefined("attributes.field_comp_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_comp_id#</cfoutput>.value = c_id;
		</cfif>
		<cfif isdefined("attributes.field_comp_code")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_comp_code#</cfoutput>.value = comp_code;
		</cfif>
	}
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Tedarikçiler',29528)#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_par" id="search_par" action="#request.self#?fuseaction=#attributes.fuseaction##url_string#" method="post">
			<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1" />
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" tabindex="1" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" style="width:120px;" placeholder="#getLang('','Kod',58585)#-#getLang('','Şirket',57574)#-#getLang('','Proje',57416)#">
				</div>
				<div class="form-group">
					<select name="comp_cat" id="comp_cat" tabindex="6">
						<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
						<cfoutput query="get_comp_cat">
							<option value="#get_comp_cat.companycat_id#" <cfif isdefined("attributes.comp_cat") and attributes.comp_cat eq get_comp_cat.companycat_id>selected</cfif>>#get_comp_cat.companycat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="is_buyer_seller" id="is_buyer_seller" tabindex="11">
						<option value=""><cf_get_lang dictionary_id='58081.Hepsi'></option>
						<option value="0" <cfif isdefined("attributes.is_buyer_seller") and attributes.is_buyer_seller eq 0>selected</cfif>><cf_get_lang dictionary_id='58733.Alıcı'></option>
						<option value="1" <cfif isdefined("attributes.is_buyer_seller") and attributes.is_buyer_seller eq 1>selected</cfif>><cf_get_lang dictionary_id='58873.Satıcı'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" tabindex="3" name="maxrows" id="maxrows" required="yes" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1,250" message="#getLang('','Kayıt Sayısı Hatalı',43958)#">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" is_excel="0" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_par' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
			<cfif len(attributes.keyword)>
				<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isdefined("attributes.is_buyer_seller") and len(attributes.is_buyer_seller)>
				<cfset url_string = "#url_string#&is_buyer_seller=#attributes.is_buyer_seller#">
			</cfif>
		</cfform>
		<cf_flat_list>
			<cfset cols = 7>
			<thead>
				<tr> 
					<th width="20"><cf_get_lang dictionary_id='57487.No'></th>		  
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='62532.Alt Marka'></th>
					<th><cf_get_lang dictionary_id='57971.Şehir'></th>
					<th><cf_get_lang dictionary_id='39091.Kategorisi'></th>
				</tr>
			</thead>
			<tbody>	
				<cfif get_partners.recordcount>
					<cfset city_list=''>
					<cfoutput query="get_partners" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(city) and not listfindnocase(city_list,city)>
							<cfset city_list = Listappend(city_list,city)>
						</cfif>
					</cfoutput>
					<cfif listlen(city_list)>
						<cfset city_list=listsort(city_list, "numeric","ASC",",")>
						<cfquery name="get_city_info" datasource="#dsn#">
							SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_list#) ORDER BY CITY_ID
						</cfquery>	
						<cfset city_list = listsort(listdeleteduplicates(valuelist(get_city_info.city_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_partners" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#member_code#</td>
						<td><a href="javascript://" onclick="load_opener_accounts('#company_id#','#TEDARIKCI_ADI# - #PROJE_ADI#','#project_id#','#company_id#_<cfif len(project_id)>#project_id#<cfelse>0</cfif>')" class="tableyazi">#TEDARIKCI_ADI#</a></td>
						<td><a href="javascript://" onclick="load_opener_accounts('#company_id#','#TEDARIKCI_ADI# - #PROJE_ADI#','#project_id#','#company_id#_<cfif len(project_id)>#project_id#<cfelse>0</cfif>')" class="tableyazi">#PROJE_ADI#</a></td>
						<td><cfif listlen(city_list)>#get_city_info.city_name[listfind(city_list,get_partners.city,',')]#</cfif></td>
						<td>#companycat#</td>
					</tr>
					</cfoutput> 
				<cfelse>
					<tr>
						<td height="20" colspan="<cfoutput>#cols#</cfoutput>"><cfif not isdefined('attributes.is_form_submitted')><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#attributes.fuseaction##url_string#&is_form_submitted=1"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">		
		</cfif>
	</cf_box>
</div>
	
<script>
	document.getElementById('keyword').focus();
</script>
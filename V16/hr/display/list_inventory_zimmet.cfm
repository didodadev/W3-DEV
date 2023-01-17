<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.is_form_submitted")>
	<cfquery name="get_zimmet" datasource="#dsn#">
		SELECT 
			EI.*,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME 
		FROM 
			EMPLOYEES_INVENT_ZIMMET EI,
			EMPLOYEES E,
            EMPLOYEE_POSITIONS EP,
            DEPARTMENT D
		WHERE
			E.EMPLOYEE_ID=EI.EMPLOYEE_ID 
            AND E.EMPLOYEE_ID=EP.EMPLOYEE_ID
            AND EP.DEPARTMENT_ID=D.DEPARTMENT_ID
            AND EI.COMPANY_ID = #session.ep.company_id#
            AND D.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND	(E.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">  COLLATE SQL_Latin1_General_CP1_CI_AI
					OR 
					E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
					OR 
					E.EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
                    )
			</cfif> 
        <cfif isdefined("attributes.get_branch_values") and len(attributes.get_branch_values) and attributes.get_branch_values neq -1>
       AND EP.DEPARTMENT_ID IN (select DEPARTMENT_ID from DEPARTMENT D,BRANCH B WHERE D.BRANCH_ID=B.BRANCH_ID AND D.BRANCH_ID=#attributes.get_branch_values#)
       </cfif>
            <cfif isdefined("attributes.get_department_values") and len(attributes.get_department_values) and attributes.get_department_values neq -1>
       AND EP.DEPARTMENT_ID=(select DEPARTMENT_ID from DEPARTMENT WHERE DEPARTMENT_ID=#attributes.get_department_values#)
       </cfif>
	</cfquery>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif isdefined("attributes.is_form_submitted")>
	<cfparam name="attributes.totalrecords" default='#get_zimmet.recordcount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_zimmet" method="post" action="#request.self#?fuseaction=hr.list_inventory_zimmet">
            <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1"/>
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
                    <cfinput type="text" name="keyword" placeholder="#message#" maxlength="50" value="#attributes.keyword#" style="width:100px;">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group medium">
                    <select id="get_branch_values" name="get_branch_values" onchange="degisim()">
                        <option value="-1"><cf_get_lang dictionary_id="57453.Şube"></option>
                        <cfquery name="get_branch" datasource="#dsn#">
                        Select 
                          * 
                        FROM 
                          BRANCH
                          WHERE BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
                        </cfquery>
                        <cfoutput query="get_branch">
                        <option value="#get_branch.BRANCH_ID#">#get_branch.BRANCH_NAME#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group medium" id="form_gizle" style="display:none;" >
                    <select id="get_department_values" name="get_department_values">
                    </select>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="55219.Zimmet İşlemleri | İK"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_grid_list> 
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='33199.Zimmet Alan'></th>
                    <!-- sil -->
                    <th width="20"><a href="<cfoutput>#request.self#?fuseaction=hr.list_inventory_zimmet&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif isdefined("attributes.is_form_submitted") and get_zimmet.recordcount>
                    <cfoutput query="get_zimmet"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td><a  href="#request.self#?fuseaction=hr.list_inventory_zimmet&event=upd&zimmet_id=#ZIMMET_ID#">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
                            <!-- sil -->
                            <td><a href="#request.self#?fuseaction=hr.list_inventory_zimmet&event=upd&zimmet_id=#ZIMMET_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                            <!-- sil -->
                        </tr>
                    </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="5"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'></cfif>!</td>
                        </tr>
                </cfif>
            </tbody>
        </cf_grid_list> 

        <cfset url_str = "">
        <cfif isdefined("attributes.is_form_submitted")>
            <cfset url_str = '#url_str#&is_form_submitted=1'>
        </cfif>
        <cfif isdefined("attributes.keyword")>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="hr.list_inventory_zimmet#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
function degisim(){
    var branch = document.getElementById("get_branch_values").value;
    if(branch!=-1){
     get_department_id = wrk_query('Select * FROM  DEPARTMENT WHERE BRANCH_ID='+branch,'dsn');
    var sel = document.getElementById('get_department_values');
    $("#get_department_values").empty();
    var opt = document.createElement('option');
    opt.innerHTML ="<cf_get_lang dictionary_id='57572.Departman'>";
    opt.value = "-1";
    sel.appendChild(opt);
      }
    if(get_department_id.DEPARTMENT_HEAD.length!=0){
    for(var i = 0; i < get_department_id.DEPARTMENT_HEAD.length; i++) {
    var opt = document.createElement('option');
    opt.innerHTML = get_department_id.DEPARTMENT_HEAD[i];
    opt.value = get_department_id.DEPARTMENT_ID[i];
    sel.appendChild(opt);
    goster(form_gizle);
      }
    }else{
        gizle(form_gizle);
       
    }
    get_department_id.DEPARTMENT_HEAD.length=0;
}
</script>

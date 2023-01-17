<cfparam name="attributes.startdate" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.finishdate" default="#dateformat(now(),dateformat_style)#"> 
<cfparam name="attributes.graph_type" default="pie">
<cfparam name="attributes.in_out_selection" default="">
<cfparam name="attributes.in_out_selection2" default="">
<cfparam name="attributes.service_branch_id" default="">
<cfparam name="attributes.workgroup_id" default="">

<cfif isDate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
<cfif isDate(attributes.finishdate)><cf_date tarih = "attributes.finishdate"></cfif> 
<cfif isDefined('attributes.form_varmi')>  
 <cfset cfc= createObject("component","V16.callcenter.cfc.get_callcenter_dashboard")>
<cfset get_company=cfc.GetCompany(
    startdate : #attributes.startdate#,
    finishdate : #attributes.finishdate#,
    service_branch_id: #attributes.service_branch_id#,
    workgroup_id: #attributes.workgroup_id#)>

<cfset get_project=cfc.GetProject(
    startdate : #attributes.startdate#,
    finishdate : #attributes.finishdate#,
    service_branch_id: #attributes.service_branch_id#,
    workgroup_id: #attributes.workgroup_id#)>

<cfset get_category=cfc.GetCategory(
    startdate : #attributes.startdate#,
    finishdate : #attributes.finishdate#,
    service_branch_id: #attributes.service_branch_id#,
    workgroup_id: #attributes.workgroup_id#)>      

<cfset get_stage=cfc.GetStage(
    startdate : #attributes.startdate#,
    finishdate : #attributes.finishdate#,
    service_branch_id: #attributes.service_branch_id#,
    workgroup_id: #attributes.workgroup_id#)>

<cfset get_employee=cfc.GetEmployee(
    startdate : #attributes.startdate#,
    finishdate : #attributes.finishdate#,
    workgroup_id: #attributes.workgroup_id#)>  

<cfset get_active=cfc.GetEmployee(
    startdate : #attributes.startdate#,
    finishdate : #attributes.finishdate#,
    service_branch_id: #attributes.service_branch_id#,
    isactive:1,
    workgroup_id: #attributes.workgroup_id#)>
<cfset get_employee_resp=cfc.GetEmployeeResp(
        startdate : #attributes.startdate#,
        finishdate : #attributes.finishdate#,
        service_branch_id: #attributes.service_branch_id#,
        isactive:1,
        workgroup_id: #attributes.workgroup_id#)>
<cfset get_timespent_stage=cfc.GetTimespentStage(
    startdate : #attributes.startdate#,
    finishdate : #attributes.finishdate#,
    service_branch_id: #attributes.service_branch_id#,
    workgroup_id: #attributes.workgroup_id#)>

<cfset get_timespent_category=cfc.GetTimespentCategory(
    startdate : #attributes.startdate#,
    finishdate : #attributes.finishdate#,
    service_branch_id: #attributes.service_branch_id#,
    workgroup_id: #attributes.workgroup_id#)>
</cfif>
<cfinclude template="../query/get_branch.cfm">
<cfquery name="GET_WORKGROUPS" datasource="#DSN#">
	SELECT
		#dsn#.Get_Dynamic_Language(WORK_GROUP.WORKGROUP_ID,'#session.ep.language#','WORK_GROUP','WORKGROUP_NAME',NULL,NULL,WORK_GROUP.WORKGROUP_NAME) AS workgroup_name,
		WORKGROUP_ID		
	FROM 
		WORK_GROUP
	WHERE
		STATUS = 1 AND
		HIERARCHY IS NOT NULL
	ORDER BY 
		WORKGROUP_NAME
</cfquery>
<script src="JS/Chart.min.js"></script>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform name="dashboard" method="post" action="">
        <input type="hidden" value="1" name="form_varmi" id="form_varmi">
        <cfsavecontent  variable="head"><cf_get_lang dictionary_id="49028.Cagri merkezi dashboard"></cfsavecontent>
        <cf_box title="#head#">
            <cf_box_search more="0">
                <div class="form-group">
                    <div class="input-group">
                        <!---  <cfsavecontent><cf_get_lang dictionary_id ='49302.Başvuru'><cf_get_lang dictionary_id='1181.tarihi'></cfsavecontent> --->
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>!</cfsavecontent>
                        <cfinput  type="text" name="startdate" id="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" maxlength="10" style="width:65px;" required="yes" message="#message#" validate="">
                        <span class="input-group-addon">
                            <cf_wrk_date_image date_field="startdate"> 
                        </span>
                    </div>
                </div>    
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message2"><cf_get_lang dictionary_id='57471.Eksik Veri'><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>!</cfsavecontent>
                        <cfinput  type="text" name="finishdate" id="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#"  maxlength="10" style="width:65px;" required="yes" message="#message2#" validate="">
                        <span class="input-group-addon">
                            <cf_wrk_date_image date_field="finishdate"> 
                        </span>
                    </div>
                </div>  
                <div class="form-group" id="item-branch_id">
                    <select name="service_branch_id" id="service_branch_id">
                        <option value=""><cf_get_lang dictionary_id='49274.İlgili Şube'><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_branch">
                            <option value="#branch_id#" <cfif isdefined("attributes.service_branch_id") and attributes.service_branch_id eq branch_id> selected</cfif>>#branch_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group" id="item-workgroup_id">
                    <select name="workgroup_id" id="workgroup_id">				  
                        <option value=""><cf_get_lang dictionary_id='58140.İş Grubu'><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_workgroups">
                            <option value="#get_workgroups.workgroup_id#"<cfif attributes.workgroup_id eq workgroup_id>selected</cfif>>#get_workgroups.workgroup_name#</option>
                        </cfoutput>
                    </select>                 
                </div>
                <div class="form-group">
                    <cf_wrk_search_button search_function='control()' button_type="4">
                </div>
            </cf_box_search>
        </cf_box>
    </cfform>
</div>
<cfif isDefined("attributes.form_varmi")>
    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
        <cfsavecontent  variable="head"><cf_get_lang dictionary_id="39858.Asamalara gore basvurular"></cfsavecontent>
        <cf_box title="#head#">
            <cfif get_stage.recordcount>
                <div style="float:left;max-height:350px;max-width:350px; margin:25px; padding-right:90px; margin-left:40px;">
                    <cfoutput query="get_stage">
                        <cfset value = #TOTAL#>
                        <cfset item = #STAGE#>
                        <cfset 'item_#currentrow#'="#value#">
                        <cfset 'value_#currentrow#'="#item#"> 
                    </cfoutput>
                </div>   
                <div>
                    <canvas id="Stage" style="float:left;max-height:400px;max-width:400px;"></canvas>
                    <script>
                        var ctx = document.getElementById('Stage');
                            var myChart = new Chart(ctx, {
                                type: '<cfoutput>#attributes.graph_type#</cfoutput>',
                                data: {
                                    labels: [<cfloop from="1" to="#get_stage.recordcount#" index="jj">
                                                    <cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                    datasets: [{
                                        label: "rapor",
                                        backgroundColor: [<cfloop from="1" to="#get_stage.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                        data: [<cfloop from="1" to="#get_stage.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                    }]
                                },
                                options: {
                                    legend: {
                                        display: false
                                    }
                                }
                        });
                    </script>
                </div>
            <cfelse>
                <tr>
                    <td colspan="2" ><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                </tr>
            </cfif>   
        </cf_box>   
        <cfsavecontent  variable="head"><cf_get_lang dictionary_id="48994.En Çok Başvuru Yapan Kurumsal Üyeler"></cfsavecontent>
        <cf_box title="#head#">
            <cf_flat_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id ='32402.Kurumsal'> <cf_get_lang dictionary_id ='57417.Uyeler'></th>
                        <th width="30"><cf_get_lang dictionary_id ='32879.Sayı'></th>  
                    </tr>
                </thead>
                <cfif get_company.recordcount>
                    <tbody>
                        <cfset totalcount=0>
                        <cfoutput query="get_company">
                            <tr>
                                <td>#FULLNAME#</td>  
                                <td>#TOTAL#</td> 
                                <cfset totalcount+=TOTAL>
                            </tr>
                        </cfoutput>
                    </tbody>
                        <cfoutput>
                            <tr>
                                <td><cf_get_lang dictionary_id ='57492.toplam'></td>
                                <td>#totalcount#</td>
                            </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="2" ><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                    </tr>
                </cfif>
            </cf_flat_list>
        </cf_box>
        <cfsavecontent  variable="head"><cf_get_lang dictionary_id="31030.görevler"></cfsavecontent>
        <cf_box title="#head#">
            <cf_flat_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id ='58875.Calışanlar'></th>
                        <th width="30"><cf_get_lang dictionary_id ='57708.Tumu'></th> 
                        <th width="30"><cf_get_lang dictionary_id ='57493.aktif'></th>  
                    </tr>
                </thead>
                <cfif get_active.recordcount >
                    <tbody>
                        <cfset totalcount=0>
                        
                        <cfoutput query="get_active">    
                            <tr>
                                <td>#USER_#</td>  
                                <td>#TOTAL#</td> 
                                <td>#aktifler#</td>
                                <cfset totalcount+=TOTAL>
                                
                            </tr>
                        </cfoutput>
                    </tbody>
                    <cfoutput>
                            <tr>
                                <td><cf_get_lang dictionary_id ='57492.toplam'></td>
                                <td>#totalcount#</td>
                                <td>#totalcount#</td>
                                
                            </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="6" ><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                    </tr>
                </cfif>
            </cf_flat_list>
        </cf_box>
        <cfsavecontent  variable="title"><cf_get_lang dictionary_id='56214.Çağrı Sorumluları'></cfsavecontent>
        <cf_box title="#title#">
            <cf_flat_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id ='58875.Calışanlar'></th>
                        <th width="30"><cf_get_lang dictionary_id ='57708.Tumu'></th> 
                        <th width="30"><cf_get_lang dictionary_id ='57493.aktif'></th>  
                    </tr>
                </thead>
                <cfif get_employee_resp.recordcount >
                    <tbody>
                        <cfset totalcountresp=0>
                        <cfset activecountresp=0>
                        <cfoutput query="get_employee_resp">    
                            <cfif len(get_employee_resp.resp_emp_id)>
                                <cfset USER_RESP = get_emp_info(get_employee_resp.resp_emp_id,0,0)>
                            <cfelseif len(get_employee_resp.resp_par_id)>
                                <cfset USER_RESP = get_par_info(get_employee_resp.resp_par_id,0,0,0)>
                            <cfelseif len(get_employee_resp.resp_cons_id)>
                                <cfset USER_RESP = get_cons_info(get_employee_resp.resp_cons_id,0,0)>
                            <cfelse>
                                <cfset USER_RESP = "Atanamayanlar">
                            </cfif>
                            <tr>
                                <td>#USER_RESP#</td>  
                                <td>#TOTAL#</td> 
                                <td>#aktifler#</td>
                                <cfset totalcountresp+=TOTAL>
                                <cfset activecountresp+=aktifler>
                                
                            </tr>
                        </cfoutput>
                    </tbody>
                    <cfoutput>
                            <tr>
                                <td><cf_get_lang dictionary_id ='57492.toplam'></td>
                                <td>#totalcountresp#</td>
                                <td>#activecountresp#</td>
                                
                            </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="6" ><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                    </tr>
                </cfif>
            </cf_flat_list>
        </cf_box>
    </div>
    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
        <cfsavecontent  variable="head"><cf_get_lang dictionary_id="39857.Kategorilere Göre Başvurular"></cfsavecontent>
        <cf_box title="#head#">
            <cfif get_category.recordcount>
                    <div style="float:right;max-height:350px;max-width:350px; margin:25px; padding-right:90px; margin-right:40px;">
                        <cfoutput query="get_category">
                            <cfset value = #TOTAL#>
                            <cfset item = #SERVICECAT#>
                            <cfset 'item_#currentrow#'="#value#">
                            <cfset 'value_#currentrow#'="#item#"> 
                        </cfoutput> 
                    </div> 
                    <div>
                        <canvas id="Category" style="float:right;max-height:400px;max-width:400px;"></canvas>
                        <script>
                            var ctx = document.getElementById('Category');
                                var myChart = new Chart(ctx, {
                                    type: '<cfoutput>#attributes.graph_type#</cfoutput>',
                                    data: {
                                        labels: [<cfloop from="1" to="#get_category.recordcount#" index="jj">
                                                        <cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                        datasets: [{
                                            label: "rapor",
                                            backgroundColor: [<cfloop from="1" to="#get_category.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                            data: [<cfloop from="1" to="#get_category.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                        }]
                                    },
                                    options:{
                                        legend: {
                                            display: false
                                        }
                                    }
                            });
                        </script>
                    </div> 
                <cfelse>
                    <tr>
                        <td colspan="2" ><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                    </tr>
                </cfif>        
        </cf_box>
        <cfsavecontent  variable="head"><cf_get_lang dictionary_id="49026.En Çok Başvuru Gelen Projeler"></cfsavecontent>
        <cf_box title="#head#">
            <cf_flat_list>          
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id ='58015.Projeler'></th>
                        <th width="30"><cf_get_lang dictionary_id ='32879.Sayı'></th>
                    </tr>
                </thead>
                <cfif get_project.recordcount>
                    <tbody>
                        <cfset totalcount=0>
                        <cfoutput query="get_project">
                            <tr>
                                <td>#PROJECT_HEAD#</td>  
                                <td>#TOTAL#</td>
                                <cfset totalcount+=TOTAL>
                            </tr> 
                        </cfoutput>
                    </tbody>
                    <cfoutput>
                            <tr>
                                <td><cf_get_lang dictionary_id ='57492.toplam'></td>
                                <td>#totalcount#</td>
                            </tr>
                    </cfoutput>                            
                <cfelse>
                    <tr>
                        <td colspan="2" ><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                    </tr>
                </cfif>
            </cf_flat_list> 
        </cf_box>
        <cfsavecontent  variable="head"><cf_get_lang dictionary_id="34989.Harcanan zaman"></cfsavecontent>
        <cf_box title="#head#">
            <cf_box_elements>
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <select name="in_out_selection" id="in_out_selection" onchange="change_in_out_det(this.value)">
                        <option value="1" <cfif isdefined("attributes.in_out_selection") and attributes.in_out_selection eq 1>selected</cfif>><cf_get_lang dictionary_id='57482.Aşama'></option>
                        <option value="2" <cfif isdefined("attributes.in_out_selection2") and attributes.in_out_selection2 eq 2>selected</cfif>><cf_get_lang dictionary_id='57486.Kategori'></option>
                    </select>
                </div>  
            </cf_box_elements>
            <cfif get_timespent_stage.recordcount>  
                <div id="timespent_stage"   <cfif attributes.in_out_selection neq 1> style="display:none;"</cfif>>
                    <cfset value1=0>
                    <cfset value2=0>
                    <cfset value3=0>
                    <cfset value4=0>
                    <cfset value5=0>
                    <cfset value6=0>
                    <cfset value7=0>
                    <cfset value8=0>
                    <cfset value9=0>
                    <cfset value10=0>
                    <cfset value11=0>
                    <cfset value12=0>
                    <cfoutput query="get_timespent_stage">                 
                        <cfif HarcananZaman lte 72>
                            <cfset value1=value1+1>
                        <cfelseif (HarcananZaman gt 72) and (HarcananZaman lte 96)>
                            <cfset value2=value2+1>
                        <cfelseif (HarcananZaman gt 96) and (HarcananZaman lte 120)>
                            <cfset value3=value3+1>
                        <cfelseif (HarcananZaman gt 120) and (HarcananZaman lte 144)>
                            <cfset value4=value4+1>
                        <cfelseif (HarcananZaman gt 144) and (HarcananZaman lte 168)>
                            <cfset value5=value5+1>
                        <cfelseif (HarcananZaman gt 168) and (HarcananZaman lte 192)>
                            <cfset value6=value6+1>
                        <cfelseif (HarcananZaman gt 192) and (HarcananZaman lte 216)>
                            <cfset value7=value7+1>
                        <cfelseif (HarcananZaman gte 216) and (HarcananZaman lte 240)>
                            <cfset value8=value8+1>
                        <cfelseif (HarcananZaman gte 240) and (HarcananZaman lte 264)>
                            <cfset value9=value9+1>
                        <cfelseif (HarcananZaman gte 264) and (HarcananZaman lte 288)>
                            <cfset value10=value10+1>
                        <cfelseif (HarcananZaman gte 288) and (HarcananZaman lte 312)>
                            <cfset value11=value11+1>
                        <cfelseif (HarcananZaman gte 312)>
                            <cfset value12=value12+1>    
                        </cfif> 
                    </cfoutput>                
                    <canvas id="myChart"></canvas>
                    <script>
                        var ctx = document.getElementById('myChart');
                        var myChart = new Chart(ctx, {
                            type: 'bar',
                            data: {
                                    labels: ["72 saat","96 saat","120 saat","144 saat","168 saat","192 saat","216 saat","240 saat","264 saat","288 saat","312 saat","312 saat üstü"],
                                    datasets: [{
                                    label: "Buglara göre",
                                    backgroundColor: [<cfloop from="1" to="6" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfoutput>"#value1#","#value2#","#value3#","#value4#","#value5#","#value6#","#value7#","#value8#","#value9#","#value10#","#value11#","#value12#"</cfoutput>],
                                        }]
                                    },
                                    options: {
                                        legend: {
                                            display: false
                                        }
                                    }
                        });
                    </script>
                </div>    
            <cfelse>
                <tr>
                    <td colspan="2" ><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                </tr>
            </cfif>  

            <cfif get_timespent_category.recordcount>  
                <div id="timespent_category"   <cfif attributes.in_out_selection2 neq 2> style="display:none;"</cfif>>
                    <cfset value1=0>
                    <cfset value2=0>
                    <cfset value3=0>
                    <cfset value4=0>
                    <cfset value5=0>
                    <cfset value6=0>
                    <cfset value7=0>
                    <cfset value8=0>
                    <cfset value9=0>
                    <cfset value10=0>
                    <cfset value11=0>
                    <cfset value12=0>
                    <cfoutput query="get_timespent_category">                 
                        <cfif HarcananZaman lte 72>
                            <cfset value1=value1+1>
                        <cfelseif (HarcananZaman gt 72) and (HarcananZaman lte 96)>
                            <cfset value2=value2+1>
                        <cfelseif (HarcananZaman gt 96) and (HarcananZaman lte 120)>
                            <cfset value3=value3+1>
                        <cfelseif (HarcananZaman gt 120) and (HarcananZaman lte 144)>
                            <cfset value4=value4+1>
                        <cfelseif (HarcananZaman gt 144) and (HarcananZaman lte 168)>
                            <cfset value5=value5+1>
                        <cfelseif (HarcananZaman gt 168) and (HarcananZaman lte 192)>
                            <cfset value6=value6+1>
                        <cfelseif (HarcananZaman gt 192) and (HarcananZaman lte 216)>
                            <cfset value7=value7+1>
                        <cfelseif (HarcananZaman gte 216) and (HarcananZaman lte 240)>
                            <cfset value8=value8+1>
                        <cfelseif (HarcananZaman gte 240) and (HarcananZaman lte 264)>
                            <cfset value9=value9+1>
                        <cfelseif (HarcananZaman gte 264) and (HarcananZaman lte 288)>
                            <cfset value10=value10+1>
                        <cfelseif (HarcananZaman gte 288) and (HarcananZaman lte 312)>
                            <cfset value11=value11+1>
                        <cfelseif (HarcananZaman gte 312)>
                            <cfset value12=value12+1>    
                        </cfif>  
                    </cfoutput>                
                    <canvas id="Chart"></canvas>
                    <script>
                        var ctx = document.getElementById('Chart');
                        var myChart = new Chart(ctx, {
                            type: 'bar',
                            data: {
                                    labels: ["72 saat","96 saat","120 saat","144 saat","168 saat","192 saat","216 saat","240 saat","264 saat","288 saat","312 saat","312 saat üstü"],
                                    datasets: [{
                                    label: "Kategorilere göre",
                                    backgroundColor: [<cfloop from="1" to="6" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfoutput>"#value1#","#value2#","#value3#","#value4#","#value5#","#value6#","#value7#","#value8#","#value9#","#value10#","#value11#","#value12#"</cfoutput>],
                                        }]
                                    },
                                    options: {
                                        legend: {
                                            display: false
                                        }
                                    }
                        });
                    </script>
                </div>    
        
            </cfif>  
        </cf_box>
    </div> 
</cfif> 
 <script>
    function change_in_out_det(in_out_selection1)
	{
		if(document.getElementById("in_out_selection").value == 1)
		{
            document.getElementById("timespent_stage").style.display = '';
            document.getElementById("timespent_category").style.display = 'none';
        }
        else
        {
            document.getElementById("timespent_stage").style.display = 'none';
            document.getElementById("timespent_category").style.display = '';
        }	
	}
    function control()
    {
        
        if(!date_check(dashboard.startdate,dashboard.finishdate,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
                        return false;
                    }
                    return true; 
    }
</script>   
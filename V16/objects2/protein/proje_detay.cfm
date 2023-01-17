<cfset getComponent = createObject('component','V16.project.cfc.projectData')>
<cfif isdefined("param_2") and param_2 eq 'wid'>
    <cfset getComponent_Work = createObject('component','V16.project.cfc.get_work')>
    <cfset get_works = getComponent_Work.DET_WORK(work_id:attributes.id,work_status:1
    )>
    <cfset attributes.id = get_works.project_id>
<cfelse>
    <cfset attributes.id=contentEncryptingandDecodingAES(isEncode:0,content:attributes.id,accountKey:'wrk')>
</cfif>
<cfset project_detail = getComponent.PROJECT_DETAIL(id : attributes.id)>
<cfset GET_CAT = getComponent.GET_CAT(process_cat : project_detail.process_cat)>
<cfif isDefined ('session.ep.time_zone')>
    <cfset simdi = dateadd ('h',session.ep.time_zone,now())>
<cfelseif isDefined ('session.pp.time_zone')>
    <cfset simdi = dateadd ('h',session.pp.time_zone,now())>
<cfelseif isDefined ('session.ww.time_zone')>
    <cfset simdi = dateadd ('h',session.ww.time_zone,now())>
<cfelse>
    <cfset simdi = now()>
</cfif>
<cfset fark3 = datediff('n',project_detail.target_start,project_detail.target_finish)>
<cfset toplam = fark3>

<cfset fark6 = datediff('n',project_detail.target_start,simdi)>
<cfset fark = fark6>

<cfset per_cent = Round (evaluate( (fark / toplam) * 100))>
<cfif per_cent gt 100>
    <cfset per_cent = 100>
</cfif>
<cfset per_cent = Round (evaluate( (fark / toplam) * 100))>
<cfif per_cent gt 100>
    <cfset per_cent = 100>
</cfif>
<div class="row">
    <div class="col-md-12">
        <cfsavecontent  variable="titleProject"><cf_get_lang dictionary_id='57416.Proje'> <cfoutput>#project_detail.PROJECT_NUMBER# </cfoutput></cfsavecontent>
        <a  href="javascript://" onclick="openBoxDraggable('<cfoutput>widgetloader?widget_load=updProject&isbox=1&style=maxi&title=#titleProject#&project_id=#attributes.id#</cfoutput>')" class="none-decoration">
            <i class="fas fa-pencil-alt float-right"></i>
        </a>
    </div>
</div>

<div class="row">
    <div class="col-md-6">
        <cfoutput query ="project_detail">
            <div class="row mb-4">
                <div class="col-md-12">
                    <div class="font-weight-bold"><cf_get_lang dictionary_id='57629.Açıklama'></div>
                    #project_detail#
                </div>
            </div>
            <div class="row mb-4">
                <div class="col-md-12">
                    <div class="font-weight-bold"><cf_get_lang dictionary_id='38554.Şirket-Yetkili'></div>
                    <p>
                        <cfif len(partner_id)>
                            #get_par_info(partner_id,0,0,0)#
                        <cfelseif len(consumer_id)>
                            #get_cons_info(consumer_id,0,0)#
                        <cfelseif len (company_id)>
                                #FULLNAME#
                        </cfif>
                    </p>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="font-weight-bold"><cf_get_lang dictionary_id='33285.Proje Lideri'></div>
                    <p>#get_emp_info(project_detail.PROJECT_EMP_ID,0,0)#</p>
                </div>
            </div>
        </div>
        
        <div class="col-md-6">
            <div class="row mb-2 justify-content-center">
                <div class="col-lg-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57486.Kategori'></label>
                </div>
                <div class="col-lg-4">
                    <label>#GET_CAT.main_process_cat#</label>
                </div>
            </div>

            <div class="row  mb-2 justify-content-center">
                <div class="col-lg-4 ">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57482.Aşama'></label>
                </div>
                <div class="col-lg-4">
                    <label>#stage#</label>
                </div>
            </div>

            <div class="row  mb-2 justify-content-center">
                <div class="col-lg-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='58467.Başlama'></label>
                </div>
                <div class="col-lg-4 pr-0">
                    <label>#Dateformat(target_start,'dd/mm/yyyy')# #Timeformat(target_start,"HH:mm")#</label>
                </div>
            </div>

            <div class="row mb-2 justify-content-center">
                <div class="col-lg-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57502.Bitiş'></label>
                </div>
                <div class="col-lg-4 pr-0">
                    <label>#Dateformat(target_finish,'dd/mm/yyyy')# #Timeformat(target_finish,"HH:mm")#</label>
                </div>
            </div>

            <div class="row mb-2 justify-content-end">
                <div class="col-lg-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='31031.Kalan Zaman'></label>
                </div>
                <div class="col-lg-4 my-1">
                    <div class="progress">
                        <div class="progress-bar bg-color-1" style="width:<cfoutput>#per_cent#</cfoutput>%" role="progressbar" aria-valuenow="#per_cent#" aria-valuemin="0" aria-valuemax="100">
                        </div>
                    </div>
                </div>
                <div class="col-lg-2">
                    <label><cfset days=abs(datediff("d",target_finish,target_start))>#days+1# gün</label>
                </div>
            </div>

            <div class="row mb-2 justify-content-end">
                <div class="col-lg-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='38307.Tamamlanma'></label>
                </div>
                <div class="col-lg-4 my-1">
                        <div class="progress">
                            <cfif len(complete_rate)>
                                <cfset success = Int(complete_rate)>
                                <cfset warning = Int(100-complete_rate)>
                            <cfelse>
                                <cfset success = 0>
                                <cfset warning = 100>
                            </cfif>
                                <div class="progress-bar bg-color-4" style="width:<cfoutput>#success#</cfoutput>%" role="progressbar" aria-valuenow="#success#" aria-valuemin="0" aria-valuemax="100">
                        </div>
                        </div>
                </div>
                <div class="col-lg-2">
                    <label><cfif complete_rate neq 0>#(success)#%<cfelse>0%</cfif></label>
                </div>
            </div>
        </cfoutput>
    </div>
</div>        

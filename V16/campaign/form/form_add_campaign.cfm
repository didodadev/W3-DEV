<!---Select ifadeleri düzenlendi.E.A 24082012--->
<cf_xml_page_edit fuseact="campaign.form_add_campaign">
<cfinclude template="../query/get_campaign_cats.cfm">
<cfquery name="GET_CAMP_TYPES" datasource="#dsn3#">
	SELECT CAMP_TYPE_ID,CAMP_TYPE FROM CAMPAIGN_TYPES ORDER BY CAMP_TYPE
</cfquery>
<cfquery name="GET_COMPANY_CAT" datasource="#dsn#">
	SELECT 
		COMPANYCAT_ID, 
		COMPANYCAT 
	FROM 
		COMPANY_CAT
	ORDER BY
		COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT
		CONSCAT_ID,CONSCAT
	FROM
		CONSUMER_CAT
	WHERE
		IS_ACTIVE = 1
	ORDER BY
		CONSCAT
</cfquery>
<cf_catalystHeader>
<cf_papers paper_type="CAMPAIGN">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_camp" id="add_camp" method="post" action="#request.self#?fuseaction=campaign.emptypopup_add_campaign">
            <cfoutput>
                <cf_box_elements>
                    <div class="col col-4 col-md-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-is_extranet">
                            <label class="col col-12">
                                <cf_get_lang dictionary_id='58019.Extranet'>
                                <input type="checkbox" name="is_extranet" id="is_extranet" value="1" />
                            </label>
                        </div>
                        <div class="form-group" id="item-comp_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49509.Partner Portal'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_multiselect_check
                                    name="comp_cat"
                                    width="170"
                                    query_name="get_company_cat"
                                    option_name="companycat"
                                    filter="1"
                                    option_value="COMPANYCAT_ID">
                            </div>
                        </div>
                        
                        <div class="form-group" id="item-camp_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrk_combo 
                                    name="camp_type"
                                    width="170"
                                    query_name="GET_CAMPAIGN_TYPES"
                                    option_name="camp_type"
                                    option_value="camp_type_id"
                                    option_text="#getLang('','Tip',57630)#"
                                    onchange="redirect(this.options.selectedIndex);">
                            </div>
                        </div>
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process is_upd='0' process_cat_width='170' is_detail='0'>
                            </div>
                        </div>
                        <div class="form-group" id="item-camp_startdate">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'> *</label>
                            <div class="col col-4 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="camp_startdate" id="camp_startdate" required="yes" validate="#validate_style#" data-msg="<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58053.Başlangıç Tarihi !'> | <cf_get_lang dictionary_id='49487.Başlangıç tarihi bitiş tarihinden önce olmalıdır'>">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="camp_startdate"></span>
                                </div>
                            </div>
                            <div class="col col-2 col-xs-12">
                                <cf_wrkTimeFormat name="camp_start_hour" id="camp_start_hour" value="00">	
                            </div>
                            <div class="col col-2 col-xs-12">
                                <select name="camp_start_min" id="camp_start_min">
                                    <cfloop from="0" to="55" index="a" step="5">
                                        <option value="#Numberformat(a,00)#">#NumberFormat(a,00)#</option>
                                    </cfloop>									  
                                </select>
                            </div>         
                        </div>
                        <div class="form-group" id="item-camp_finishdate">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'> *</label>
                            <div class="col col-4 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="camp_finishdate" id="camp_finishdate" validate="#validate_style#" required data-msg="<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi !'>">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="camp_finishdate"></span>
                                </div>
                            </div>
                            <div class="col col-2 col-xs-12">
                                <cf_wrkTimeFormat name="camp_finish_hour" id="camp_finish_hour" value="00">	
                            </div>
                            <div class="col col-2 col-xs-12">
                                <select name="camp_finish_min" id="camp_finish_min">
                                    <cfloop from="0" to="55" index="a" step="5">
                                        <option value="#Numberformat(a,00)#">#NumberFormat(a,00)#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-camp_head">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Başlık'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık !'></cfsavecontent>
                                <cfinput type="text" name="camp_head" maxlength="100" required="Yes" message="#message#">
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-6 col-xs-12" type="column" index="2" sort="true"> 
                        <div class="form-group" id="item-is_internet">
                            <label class="col col-12">
                                <input type="checkbox" name="is_internet" id="is_internet" value="1">
                                <cf_get_lang dictionary_id='49435.İnternet'>
                            </label>
                        </div>
                        <div class="form-group" id="item-cons_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49510.Public Portal'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_multiselect_check
                                    name="cons_cat"
                                    width="170"
                                    query_name="get_consumer_cat"
                                    option_name="conscat"
                                    option_value="conscat_id">
                            </div> 
                        </div>
                        <div class="form-group" id="item-camp_cat_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49552.Alt Kategori'> *</label>
                            <div class="col col-8 col-xs-12">
                                <input type="hidden" name="camp_status" id="camp_status" value="1">
                                <select name="camp_cat_id" id="camp_cat_id">
                                    <option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
                                    <cfloop query="get_campaign_cats"> <!--- tipe bağlıysa neden defaultta hepsi geliyor. --->
                                        <option value="#camp_cat_id#">#camp_cat_name#</option> 
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-project_head">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49344.İlgili Proje'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="">
                                    <input type="text" name="project_head" id="project_head">
                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_id=add_camp.project_id&project_head=add_camp.project_head</cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-leader_employee">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49336.Lider'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="leader_employee_id" id="leader_employee_id" value="">
                                    <input type="text" name="leader_employee" id="leader_employee" readonly="yes">
                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1,2,3&field_emp_id=add_camp.leader_employee_id&field_name=add_camp.leader_employee</cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-participation_time">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49362.Katılım Taahhüt Süresi'><cfoutput>(<cf_get_lang dictionary_id='58724.Ay'>)</cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="participation_time" id="participation_time" value="" maxlength="3" onkeyup="isNumber(this);" class="moneybox">                            
                            </div>
                        </div>
                        <div class="form-group" id="item-user_friendly_url">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='38023.Kullanıcı Dostu Url'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
								<input type="text" name="user_friendly_url" id="user_friendly_url" value="" maxlength="250">
							</div>
						</div>	
                        <div class="form-group" id="item-camp_objective">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Acıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea id="camp_objective" name="camp_objective"></textarea>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </cf_box_footer>
            </cfoutput>
        </cfform>
    </cf_box>
</div>

<script type="text/javascript">
	var groups=document.add_camp.camp_type.options.length;
	var group=new Array(groups);
	for (i=0; i<groups; i++)
		group[i]=new Array();
		group[0][0]=new Option("Kategori","");
		<cfset branch = ArrayNew(1)>
		<cfoutput query="get_camp_types">
			<cfset branch[currentrow]=#camp_type_id#>
		</cfoutput>
		<cfloop from="1" to="#ArrayLen(branch)#" index="indexer">
			<cfquery name="dep_names" datasource="#dsn3#">
				SELECT 
					CAMP_CAT_ID,
					CAMP_CAT_NAME,
					CAMP_TYPE,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					UPDATE_DATE,
					UPDATE_EMP,
					UPDATE_IP
				FROM 
					CAMPAIGN_CATS 
				WHERE 
					CAMP_TYPE = #branch[indexer]# ORDER BY CAMP_CAT_ID
			</cfquery>
			<cfif dep_names.recordcount>
				<cfset deg = 0>
				<cfoutput>group[#indexer#][#deg#]=new Option("Kategori","");</cfoutput>
					<cfoutput query="dep_names">
						<cfset deg = currentrow>
							<cfif dep_names.recordcount>
								group[#indexer#][#deg#]=new Option("#camp_cat_name#","#camp_cat_id#");
							</cfif>
					</cfoutput>
			<cfelse>
				<cfset deg = 0>
				<cfoutput>
				group[#indexer#][#deg#]=new Option("<cf_get_lang dictionary_id='57486.Kategori'>","");
				</cfoutput>
			</cfif>
		</cfloop>
	var temp = document.add_camp.camp_cat_id;
	function redirect(x)
	{
		for (m=temp.options.length-1;m>0;m--)
		temp.options[m]=null;
		for (i=0;i<group[x].length;i++)
		{
			temp.options[i]=new Option(group[x][i].text,group[x][i].value)
		}
	}
	function kontrol()
	{
		x = document.add_camp.camp_type.selectedIndex;
		if (document.add_camp.camp_type[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='49554.Kampanya Tipi'> !");
			return false;
		}
		
		x = document.add_camp.camp_cat_id.selectedIndex;
		if (document.add_camp.camp_cat_id[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='49555.Kampanya Kategorisi'> !");
			return false;
		}
		if (document.add_camp.camp_head.value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57480.Başlık'> !");
			return false;
		}
		unformat_fields();
		return process_cat_control();
	}
	function unformat_fields()
	{
		return date_check(add_camp.camp_startdate,add_camp.camp_finishdate,"<cf_get_lang dictionary_id='49487.Başlangıç tarihi bitiş tarihinden önce olmalıdır'>!");
	}

</script>

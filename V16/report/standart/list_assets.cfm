<cfparam name="attributes.is_active" default="">
<cfparam name="attributes.module_id_control" default="40">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.position_name" default="">
<cfparam name="attributes.sup_company_id" default="">
<cfparam name="attributes.sup_comp_name" default="">
<cfparam name="attributes.sup_partner_name" default="">
<cfparam name="attributes.sup_consumer_id" default="">
<cfparam name="attributes.sup_partner_id" default="">
<cfparam name="attributes.make_year" default="">
<cfparam name="attributes.asset_p_space_id" default="">
<cfparam name="attributes.asset_p_space_name" default="">
<cfparam name="attributes.category" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.property_type" default="">
<cfparam name="attributes.fuel_type" default="">
<cfparam name="attributes.assetp_group" default="">
<cfparam name="attributes.usage_purpose_id" default="">
<cfparam name="attributes.brand" default="">
<cfparam name="attributes.cat_category" default="">
<cfparam name="assetp_sub_catid" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.assetp_sub_catid" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.is_company" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif  isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif  isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfset colspan_=8>
<cfquery name="GET_PURPOSE" datasource="#DSN#">
	SELECT
		USAGE_PURPOSE_ID,
		USAGE_PURPOSE
	FROM
		SETUP_USAGE_PURPOSE
	ORDER BY
		USAGE_PURPOSE_ID
</cfquery>
<cfquery name="GET_ASSETP_GROUPS" datasource="#DSN#">
	SELECT
		GROUP_ID,
		GROUP_NAME
	FROM
		SETUP_ASSETP_GROUP
	ORDER BY 
		GROUP_NAME
</cfquery>
<cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
	SELECT 
		ASSETP_CATID, 
		ASSETP_CAT,
		IT_ASSET,
		MOTORIZED_VEHICLE 
	FROM 
		ASSET_P_CAT 
	WHERE 
		1=1
		<cfif attributes.report_type eq 1>
			AND (MOTORIZED_VEHICLE<>1) AND (IT_ASSET <> 1)
		<cfelseif attributes.report_type eq 2>
			AND IT_ASSET=1
		<cfelseif attributes.report_type eq 3>
			AND MOTORIZED_VEHICLE=1
		</cfif> 
	ORDER BY 
		ASSETP_CAT
</cfquery>
<cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
    SELECT * FROM OUR_COMPANY
</cfquery>
<cfquery name="GET_FUEL_TYPE" datasource="#DSN#">
	SELECT
		FUEL_ID,
		FUEL_NAME
	FROM
		SETUP_FUEL_TYPE
	ORDER BY
		FUEL_ID
</cfquery> 
<cfquery name="GET_BRAND" datasource="#dsn#">
	SELECT
		SETUP_BRAND_TYPE.BRAND_TYPE_ID,
        (SETUP_BRAND.BRAND_NAME + ' / ' + SETUP_BRAND_TYPE.BRAND_TYPE_NAME) BRAND_TYPE_CAT_HEAD
    FROM
        SETUP_BRAND_TYPE,
        SETUP_BRAND
    WHERE
        SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID
        <cfif attributes.report_type eq 1>
			AND SETUP_BRAND.IT_ASSET IS NULL and SETUP_BRAND.MOTORIZED_VEHICLE IS NULL
        <cfelseif attributes.report_type eq 2>
        	AND SETUP_BRAND.IT_ASSET=1
         <cfelseif attributes.report_type eq 3>
         	AND SETUP_BRAND.MOTORIZED_VEHICLE=1
		</cfif>
</cfquery>
<cfquery name="get_status" datasource="#dsn#">
	SELECT ASSET_STATE_ID,ASSET_STATE FROM ASSET_STATE
</cfquery>
<cfif len(attributes.cat_category)>
	<cfquery name="GET_SUB_CAT" datasource="#dsn#">
		SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID IN (#attributes.cat_category#)
	</cfquery>
</cfif>
<cfif isdefined("is_submit")>
	<cfquery name="GET_ASSET" datasource="#dsn#">
    	 SELECT 
		 	ASSET_P.EMPLOYEE_ID,
        	ASSET_P.ASSETP_ID,
            ASSET_P.PROPERTY,
            ASSET_P.ASSETP,
            ASSET_P.BARCODE,
            ASSET_P.SUP_COMPANY_ID,
            ASSET_P.SUP_CONSUMER_ID,
            ASSET_P.SUP_COMPANY_DATE,
            ASSET_P.INVENTORY_NUMBER,
            ASSET_P.BRANCH_ID,
            ASSET_P.BRAND_ID,
            ASSET_P.BRAND_TYPE_ID,
            ASSET_P.BRAND_TYPE_CAT_ID,
            ASSET_P.DEPARTMENT_ID,
         	ASSET_P.DEPARTMENT_ID2,
            ASSET_P.POSITION_CODE,
            ASSET_P.SERIAL_NO,
            ASSET_P.PRIMARY_CODE,
            ASSET_P.SERVICE_EMPLOYEE_ID,
            EP.EMPLOYEE_NAME+' '+EP.EMPLOYEE_SURNAME SERVICE_EMPLOYEE_NAME,
            SETUP_FUEL_TYPE.FUEL_NAME,
            ASSET_P.FUEL_TYPE,
            ASSET_P.ASSETP_STATUS,
            ASSET_P.ASSETP_GROUP,
            ASSET_P.USAGE_PURPOSE_ID,
            ASSET_P.MAKE_YEAR,
            ASSET_P.ASSETP_DETAIL,
            ASSET_P.OTHER_MONEY,
			ASSET_P.OTHER_MONEY_VALUE,
            ASSET_P.IS_COLLECTIVE_USAGE,
            ASSET_P.FIRST_KM,
            ASSET_P.FIRST_KM_DATE,
			ASSET_P_CAT.ASSETP_CAT,
            SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_NAME,
            SETUP_BRAND.BRAND_NAME,
            SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
            DEPARTMENT.DEPARTMENT_HEAD,
            D.DEPARTMENT_HEAD AS DEP_HEAD,
            D2.DEPARTMENT_HEAD AS UPPER_DEPARTMENT_HEAD,
            ASSET_STATE.ASSET_STATE,
            SETUP_ASSETP_GROUP.GROUP_NAME,
            SETUP_USAGE_PURPOSE.USAGE_PURPOSE,
            ASSET_P_INFO_PLUS.ENGINE_NUMBER,
            ASSET_P_INFO_PLUS.RENK,
            ASSET_P_INFO_PLUS.IDENTIFICATION_NUMBER,
            ASSET_P_INFO_PLUS.IL,
            ASSET_P_INFO_PLUS.ILCE,
			ASSET_P_INFO_PLUS.TRAFIK_CIKIS_TARIH,
			ASSET_P_INFO_PLUS.NET_AGIRLIK,
			ASSET_P_INFO_PLUS.ISTIHAP_HADDI_KG,
			ASSET_P_INFO_PLUS.ISTIHAP_HADDI_KISI,
			ASSET_P_INFO_PLUS.TESCIL_SIRA_NO,
			ASSET_P_INFO_PLUS.TESCIL_TARIHI,
			ASSET_P_INFO_PLUS.MOTOR,
			ASSET_P_INFO_PLUS.MOTOR_GUCU,
			ASSET_P_INFO_PLUS.USAGE_TYPE,
			ASSET_P_INFO_PLUS.ARAC_SAHIBI,
			ASSET_P_INFO_PLUS.IKAMETGAH_ADRES,
            INFO_PLUS.PROPERTY1,
            INFO_PLUS.PROPERTY2,
            INFO_PLUS.PROPERTY3,
            INFO_PLUS.PROPERTY4,
            INFO_PLUS.PROPERTY5,
            INFO_PLUS.PROPERTY6,
            INFO_PLUS.PROPERTY7,
            INFO_PLUS.PROPERTY8,
            INFO_PLUS.PROPERTY9,
            INFO_PLUS.PROPERTY10,
            INFO_PLUS.PROPERTY11,
            INFO_PLUS.PROPERTY12,
            INFO_PLUS.PROPERTY13,
            INFO_PLUS.PROPERTY14,
            INFO_PLUS.PROPERTY15,
            INFO_PLUS.PROPERTY16,
            INFO_PLUS.PROPERTY17,
            INFO_PLUS.PROPERTY18,
            INFO_PLUS.PROPERTY19,
            INFO_PLUS.PROPERTY20,
    		ASSET_P.STATUS,
    		ASSET_P.EXIT_DATE,
            ASSET_P_INFO_PLUS.CINS,
            ASSET_P_INFO_PLUS.TIP,
            ASSET_P_CAT.IT_ASSET,
            ASSET_P_CAT.MOTORIZED_VEHICLE,
			ASSETP_SUB_CAT,
			APSC.ASSETP_SUB_CAT,
			SM.MONEY,
            ASSET_P_SPACE.SPACE_CODE,
			ASSET_P_SPACE.SPACE_NAME, 
            BRANCH.BRANCH_ID AS LOCATION, 
			CASE 
				WHEN ASSET_P.MEMBER_TYPE_2='employee' THEN E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME 
				WHEN ASSET_P.MEMBER_TYPE_2='partner' THEN CP.COMPANY_PARTNER_NAME+' '+CP.COMPANY_PARTNER_SURNAME 
				WHEN ASSET_P.MEMBER_TYPE_2='consumer' THEN C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME 
				ELSE '' END SORUMLU2
		FROM
            ASSET_P_CAT,
            BRANCH,
            ASSET_P
            LEFT JOIN ASSET_P_SPACE ON ASSET_P_SPACE.ASSET_P_SPACE_ID=ASSET_P.ASSET_P_SPACE_ID
			LEFT JOIN EMPLOYEE_POSITIONS EP ON ASSET_P.SERVICE_EMPLOYEE_ID=EP.POSITION_CODE
            LEFT JOIN DEPARTMENT D ON ASSET_P.DEPARTMENT_ID = D.DEPARTMENT_ID
            LEFT JOIN DEPARTMENT as D2 ON D.HIERARCHY_DEP_ID  = CONCAT(D2.HIERARCHY_DEP_ID,'.',D.DEPARTMENT_ID)
            LEFT JOIN DEPARTMENT ON ASSET_P.DEPARTMENT_ID2 = DEPARTMENT.DEPARTMENT_ID
            LEFT JOIN SETUP_FUEL_TYPE ON ASSET_P.FUEL_TYPE=SETUP_FUEL_TYPE.FUEL_ID
            LEFT JOIN ASSET_STATE ON ASSET_STATE.ASSET_STATE_ID=ASSET_P.ASSETP_STATUS
            LEFT JOIN SETUP_ASSETP_GROUP ON SETUP_ASSETP_GROUP.GROUP_ID=ASSET_P.ASSETP_GROUP
            LEFT JOIN SETUP_USAGE_PURPOSE ON SETUP_USAGE_PURPOSE.USAGE_PURPOSE_ID=ASSET_P.USAGE_PURPOSE_ID
            LEFT JOIN ASSET_P_INFO_PLUS ON ASSET_P_INFO_PLUS.ASSETP_ID=ASSET_P.ASSETP_ID
			LEFT JOIN ASSET_P_SUB_CAT APSC ON APSC.ASSETP_CATID=ASSET_P.ASSETP_CATID AND APSC.ASSETP_SUB_CATID=ASSET_P.ASSETP_SUB_CATID
			LEFT JOIN SETUP_MONEY SM ON SM.MONEY=ASSET_P.OTHER_MONEY AND SM.PERIOD_ID = #session.ep.period_id#
			LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID=ASSET_P.POSITION_CODE2
			LEFT JOIN CONSUMER C ON C.CONSUMER_ID=ASSET_P.POSITION_CODE2
			LEFT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID=ASSET_P.POSITION_CODE2
            LEFT JOIN SETUP_BRAND_TYPE_CAT ON SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_ID=ASSET_P.BRAND_TYPE_CAT_ID
            LEFT JOIN SETUP_BRAND ON SETUP_BRAND.BRAND_ID=ASSET_P.BRAND_ID
            LEFT JOIN SETUP_BRAND_TYPE ON SETUP_BRAND_TYPE.BRAND_TYPE_ID=ASSET_P.BRAND_TYPE_ID
            LEFT JOIN INFO_PLUS ON INFO_PLUS.ASSETP_INFO_ID = ASSET_P.ASSETP_ID AND INFO_PLUS.INFO_OWNER_TYPE = -13
        WHERE
        	ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
          	AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
              <cfif listlen(attributes.branch_id)>
				AND BRANCH.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list="yes">)
			<cfelse>
				AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
			<cfif attributes.report_type eq 1>
            	AND (ASSET_P_CAT.MOTORIZED_VEHICLE<>1) AND (ASSET_P_CAT.IT_ASSET <> 1)
			<cfelseif attributes.report_type eq 2>
            	AND ASSET_P_CAT.IT_ASSET = 1
			<cfelseif attributes.report_type eq 3>
           		AND ASSET_P_CAT.MOTORIZED_VEHICLE = 1
			</cfif>
			<cfif len(attributes.make_year)>
                AND MAKE_YEAR = #attributes.make_year#
            </cfif>
            <cfif len(attributes.usage_purpose_id)>
                AND ASSET_P.USAGE_PURPOSE_ID=#attributes.usage_purpose_id#
            </cfif>
            <cfif isdefined("attributes.share_used")>
                AND IS_COLLECTIVE_USAGE=1
            </cfif>
            <cfif listlen(attributes.property_type)>
               AND PROPERTY IN (#attributes.property_type#)
           </cfif>
           <cfif len(attributes.is_active)>
                AND STATUS=#attributes.is_active#
           </cfif>
           <cfif len(attributes.start_date)>
                AND ASSET_P.SUP_COMPANY_DATE >= #attributes.start_date#
           </cfif>
           <cfif len(attributes.finish_date)>
                AND ASSET_P.SUP_COMPANY_DATE <= #attributes.finish_date#
           </cfif>
			<cfif len(attributes.fuel_type)>
                AND FUEL_TYPE=#attributes.fuel_type#
           </cfif>
           <cfif len(attributes.assetp_group)>
                AND GROUP_ID=#attributes.assetp_group#
           </cfif> 
           <cfif len(attributes.sup_company_id) and len(attributes.sup_comp_name)>
		   		AND SUP_COMPANY_ID=#attributes.sup_company_id#
		   </cfif>
           <cfif len(attributes.sup_partner_id) and len(attributes.sup_comp_name)>
           		AND SUP_PARTNER_ID=#attributes.sup_partner_id#
           </cfif>
           <cfif len(attributes.sup_consumer_id) and len(attributes.sup_comp_name)>
		   		AND SUP_CONSUMER_ID=#attributes.sup_consumer_id#
		   </cfif>
           <cfif len(attributes.employee_id) and len(attributes.position_name)>
           		AND ASSET_P.EMPLOYEE_ID=#attributes.employee_id#
		   </cfif>
           <cfif len(attributes.asset_id) and len(attributes.asset_name)>
		   		AND ASSET_P.ASSETP_ID=#attributes.asset_id#
		   </cfif>
			<cfif len(attributes.department) and len(attributes.department_id)>
            	AND ASSET_P.DEPARTMENT_ID =#attributes.department_id# 
			</cfif>
            <cfif len(attributes.brand)>
				AND ASSET_P.BRAND_TYPE_ID IN(#attributes.brand#)
			</cfif>
            <cfif len(attributes.cat_category)>
				AND ASSET_P_CAT.ASSETP_CATID IN(#attributes.cat_category#)
            </cfif>
            <cfif len(attributes.is_company)>
				AND BRANCH.COMPANY_ID = #attributes.is_company#
			</cfif>
			<cfif len(attributes.assetp_sub_catid)>AND ASSET_P.ASSETP_SUB_CATID IN (#attributes.assetp_sub_catid#)</cfif>
			<cfif len(attributes.status)>AND ASSET_P.ASSETP_STATUS IN (#attributes.status#)</cfif>
            <cfif len(attributes.asset_p_space_id) and len(attributes.asset_p_space_name)>AND ASSET_P.ASSET_P_SPACE_ID=#attributes.asset_p_space_id#</cfif>
	</cfquery>
	<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows=get_asset.recordcount>
	</cfif>
   	<cfparam name="attributes.totalrecords" default="#get_asset.recordcount#">
    <cfset list_cons_id=listdeleteduplicates(valuelist(get_asset.sup_consumer_id))>
    <cfset list_comp_id=listdeleteduplicates(valuelist(get_asset.sup_company_id))>
    <cfset list_poscode=listdeleteduplicates(valuelist(get_asset.employee_id))>
    <cfset list_emp_id=listdeleteduplicates(valuelist(get_asset.service_employee_id))>
    <cfif listlen(list_cons_id)>
    	<cfquery name="get_cons_name" datasource="#dsn#">
			SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME NAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID IN(#list_cons_id#) ORDER BY CONSUMER_ID
        </cfquery>
        <cfset list_cons_id = listsort(listdeleteduplicates(valuelist(get_cons_name.CONSUMER_ID,',')),'numeric','ASC',',')>
	</cfif>
    <cfif listlen(list_comp_id)>
        <cfquery name="get_comp_name" datasource="#dsn#">
            SELECT FULLNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID  IN(#list_comp_id#) ORDER BY COMPANY_ID
        </cfquery>
		<cfset list_comp_id = listsort(listdeleteduplicates(valuelist(get_comp_name.COMPANY_ID,',')),'numeric','ASC',',')>
    </cfif>
	<cfif listlen(list_poscode)>
		<cfquery name="get_empcode" datasource="#dsn#">
        	SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME NAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN(#list_poscode#) ORDER BY EMPLOYEE_ID
        </cfquery>
        <cfset list_poscode=listsort(listdeleteduplicates(valuelist(get_empcode.EMPLOYEE_ID,',')),'numeric','ASC',',')>
	</cfif>
    <!--- <cfif listlen(list_emp_id)>
		<cfquery name="get_empid" datasource="#dsn#">
        	SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME NAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN(#list_emp_id#) ORDER BY EMPLOYEE_ID
        </cfquery>
        <cfset list_emp_id=listsort(listdeleteduplicates(valuelist(get_empid.employee_id,',')),'numeric','ASC',',')>
	</cfif> --->
   	<cfif get_asset.recordcount>
		<cfquery name="get_asset_info" datasource="#dsn#">
        	SELECT ENGINE_NUMBER,RENK,IDENTIFICATION_NUMBER FROM ASSET_P_INFO_PLUS WHERE  ASSETP_ID IN(#valuelist(get_asset.assetp_id)#)
        </cfquery>
    </cfif>

</cfif>
<cfscript>
    cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp");
    cmp_branch.dsn = dsn;
    get_branches = cmp_branch.get_branch(ehesap_control:1,branch_status:1);
</cfscript>
<cfform name="physical_assets" id="physical_assets" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
    <cfsavecontent variable="title"><cf_get_lang dictionary_id = "38823.Fiziki Varlık Raporu"></cfsavecontent>
    <cf_report_list_search id="search" title="#title#"> 
        <cf_report_list_search_area>    
                <div class="row">
                    <div class="col col-12 col-xs-12">
                        <div class="row formContent">
                            <div class="row" type="row">
                                <cfoutput>	
                                    <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                                        <div class="col col-12 col-xs-12">
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id= "57574.Şirket"></label>
                                                    <div class="col col-12 col-xs-12">
                                                        <select name="is_company" id="is_company">
                                                            <option value=""><cf_get_lang dictionary_id= "57734.Seçiniz"></option>	
                                                            <cfloop query="GET_OUR_COMPANY">
                                                                <option value="#comp_id#" <cfif attributes.is_company eq comp_id>selected</cfif>>#company_name#</option>
                                                            </cfloop>
                                                        </select>
                                                    </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                                <div class="col col-12 col-xs-12">
                                                    <select name="branch_id" id="branch_id" multiple>
                                                        <cfloop query="get_branches" group="NICK_NAME">
                                                            <optgroup label="#get_branches.NICK_NAME#"></optgroup>
                                                            <cfloop>
                                                                <option value="#get_branches.BRANCH_ID#"<cfif listfind(attributes.branch_id,get_branches.branch_id,',')> selected</cfif>>#get_branches.BRANCH_NAME#</option>
                                                            </cfloop>
                                                        </cfloop>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29452.Varlık'></label>
                                                    <div class="col col-12 col-xs-12">
                                                        <div class="input-group">
                                                            <input type="hidden" id="asset_id" name="asset_id" value="#attributes.asset_id#" />
                                                            <input type="text" id="asset_name" name="asset_name" value="#attributes.asset_name#" />
                                                            <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('#request.self#?fuseaction=assetcare.popup_list_assetps&field_id=physical_assets.asset_id&field_name=physical_assets.asset_name&event_id=0','list','popup_list_assetps');"></span>
                                                        </div>
                                                    </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60371.Mekan'></label>
                                                <div class="col col-12 col-xs-12">
                                                    <div class="input-group">
                                                        <input type="hidden" name="asset_p_space_id" id="asset_p_space_id" value="<cfoutput>#attributes.asset_p_space_id#</cfoutput>"> 
                                                        <input type="text" name="asset_p_space_name" id="asset_p_space_name" value="<cfoutput>#attributes.asset_p_space_name#</cfoutput>" onFocus="AutoComplete_Create('asset_p_space_name','SPACE_NAME','SPACE_NAME','get_assetp_space','3','ASSET_P_SPACE_ID','asset_p_space_id','','3','135')">
                                                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_assetp_space&field_name=asset_p_space_name&field_id=asset_p_space_id</cfoutput>','list');"></span>
                                                </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
                                                <div class="col col-12 col-xs-12">
                                                    <div class="input-group">
                                                        <input type="hidden" id="employee_id" name="employee_id" value="#attributes.employee_id#" />
                                                        <input type="text" id="position_name" name="position_name" value="#attributes.position_name#">
                                                        <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57544.Sorumlu'>" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=physical_assets.employee_id&field_name=physical_assets.position_name&select_list=1&branch_related','list','popup_list_positions')"></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                                <div class="col col-12 col-xs-12">
                                                    <div class="input-group">
                                                        <input type="hidden" id="department_id" name="department_id" value="#attributes.department_id#" />
                                                        <input type="text" id="department" name="department" value="#attributes.department#" />
                                                        <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_departments&field_id=physical_assets.department_id&field_dep_branch_name=physical_assets.department','list');"></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38825.Alınan Şirket'></label>
                                                <div class="col col-12 col-xs-12">
                                                    <div class="input-group">
                                                            <input type="hidden" name="sup_company_id" id="sup_company_id" value="#attributes.sup_company_id#">
                                                            <input type="hidden" name="sup_partner_id" id="sup_partner_id" value="#attributes.sup_partner_id#">
                                                            <input type="hidden" name="sup_consumer_id" id="sup_consumer_id" value="#attributes.sup_consumer_id#" />
                                                            <input type="text" name="sup_comp_name" id="sup_comp_name" value="#attributes.sup_comp_name#"  style="width:135px;" />
                                                            <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57544.Sorumlu'>" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_partner=physical_assets.sup_partner_id&field_name=physical_assets.sup_comp_name&field_comp_id=physical_assets.sup_company_id&field_consumer=physical_assets.sup_consumer_id&select_list=2,3','list','popup_list_pars');"></span>
                                                    </div>
                                                </div>
                                            </div>    
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                                        <div class="col col-12 col-xs-12">
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                                                <div class="col col-12 col-xs-12"> 
                                                    <select  multiple="multiple" name="cat_category" id="cat_category" onchange="cat_subcat()">
                                                    <cfloop query="get_assetp_cats">
                                                    <option value="#assetp_catid#" <cfif listfind(attributes.cat_category,assetp_catid,',')>selected</cfif>>#assetp_cat#</option>
                                                    </cfloop>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39072.Varlık Alt Kategori'></label>
                                                <div class="col col-12 col-xs-12"> 
                                                    <select  multiple="multiple" name="assetp_sub_catid" id="assetp_sub_catid">
                                                        <cfif len(attributes.cat_category)>
                                                            <cfloop query="GET_SUB_CAT">
                                                                <option value="#ASSETP_SUB_CATID#" <cfif listfind(attributes.assetp_sub_catid,assetp_sub_catid,',') > selected="selected"</cfif>>#ASSETP_SUB_CAT#</option>
                                                            </cfloop>
                                                        </cfif>
                                                    </select>                  
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38874.Mülkiyet Tipi'></label>
                                                <div class="col col-12 col-xs-12">
                                                    <select  multiple="multiple" name="property_type" id="property_type" style="width:150px; height:75px">
                                                        <option value="1" <cfif listfind(attributes.property_type,1,',')>selected</cfif>><cf_get_lang dictionary_id='57449.Satın Alma'></option>
                                                        <option value="2" <cfif listfind(attributes.property_type,2,',')>selected</cfif>><cf_get_lang dictionary_id='38877.Kiralama'></option>
                                                        <option value="3" <cfif listfind(attributes.property_type,3,',')>selected</cfif>><cf_get_lang dictionary_id='38888.Leasing'></option>
                                                        <option value="4" <cfif listfind(attributes.property_type,4,',')>selected</cfif>><cf_get_lang dictionary_id='29522.Sözleşme'></option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>                                  
                                    </div>
                                    <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                                        <div class="col col-12 col-xs-12">
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38841.Marka/Marka Tipi'></label>
                                                <div class="col col-12 col-xs-12">
                                                    <select  multiple="multiple" name="brand" id="brand">
                                                        <cfloop query="GET_BRAND">
                                                            <option value="#BRAND_TYPE_ID#" <cfif listfind(attributes.brand,brand_type_id,',')>selected</cfif>>#BRAND_TYPE_CAT_HEAD#</option>
                                                        </cfloop>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                                                <div class="col col-12 col-xs-12"> 
                                                    <select  multiple="multiple" name="status" id="status">
                                                        <cfloop query="get_status">
                                                            <option value="#ASSET_STATE_ID#" <cfif listfind(attributes.status,ASSET_STATE_ID,',')>selected</cfif>>#ASSET_STATE#</option>
                                                        </cfloop>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39815.Liste Kategorisi'></label>
                                                <div class="col col-12 col-xs-12"> 
                                                    <select  multiple="multiple" name="category" id="category" >
                                                        <cfif attributes.report_type eq 1 or attributes.report_type eq 2 or not Len(attributes.report_type)>
                                                            <option value="1" <cfif listfind(attributes.category,1,',')>selected</cfif>><cf_get_lang dictionary_id='57633.Barkod'></option>
                                                            <option value="2" <cfif listfind(attributes.category,2,',')>selected</cfif>><cf_get_lang dictionary_id='38894.Kayıtlı Departman'></option>
                                                            <option value="5" <cfif listfind(attributes.category,5,',')>selected</cfif>><cf_get_lang dictionary_id='57637.Seri No'></option>
                                                            <option value="7" <cfif listfind(attributes.category,7,',')>selected</cfif>><cf_get_lang dictionary_id='38901.Servis Çalışanı'></option>
                                                            <option value="9" <cfif listfind(attributes.category,9,',')>selected</cfif>><cf_get_lang dictionary_id='57756.Durum'></option>
                                                        </cfif>
                                                        <option value="3" <cfif listfind(attributes.category,3,',')>selected</cfif>><cf_get_lang dictionary_id='38895.Kullanıcı Departman'></option>
                                                        <option value="4" <cfif listfind(attributes.category,4,',')>selected</cfif>><cf_get_lang dictionary_id='57544.Sorumlu'></option>
                                                        <option value="39" <cfif listfind(attributes.category,39,',')>selected</cfif>><cf_get_lang dictionary_id='57544.Sorumlu'>2</option>
                                                        <option value="6" <cfif listfind(attributes.category,6,',')>selected</cfif>><cf_get_lang dictionary_id='57789.Özel Kod'></option>
                                                        <option value="10" <cfif listfind(attributes.category,10,',')>selected</cfif>><cf_get_lang dictionary_id='58140.İş Grubu'></option>
                                                        <option value="11" <cfif listfind(attributes.category,11,',')>selected</cfif>><cf_get_lang dictionary_id='38828.Kullanım Amacı'></option>
                                                        <option value="16" <cfif listfind(attributes.category,16,',')>selected</cfif>><cf_get_lang dictionary_id='57629.Açıklama'></option>
                                                        <option value="17" <cfif listfind(attributes.category,17,',')>selected</cfif>><cf_get_lang dictionary_id='38794.Değer'></option>
                                                        <option value="19" <cfif listfind(attributes.category,19,',')>selected</cfif>><cf_get_lang dictionary_id='38866.Ortak Kullanım'></option>
                                                        <option value="23" <cfif listfind(attributes.category,23,',')>selected</cfif>><cf_get_lang dictionary_id='29438.Çıkış Tarihi'></option>
                                                        <option value="24" <cfif listfind(attributes.category,24,',')>selected</cfif>><cf_get_lang dictionary_id='57756.Durum'></option>
                                                        <option value="40" <cfif listfind(attributes.category,40,',')>selected</cfif>><cf_get_lang dictionary_id='57810.Ek Bilgi'></option>
                                                        <cfif attributes.report_type eq 3 or attributes.report_type eq 0>
                                                        <option value="8" <cfif listfind(attributes.category,8,',')>selected</cfif>><cf_get_lang dictionary_id='30113.Yakıt Tipi'></option>
                                                        <option value="20" <cfif listfind(attributes.category,20,',')>selected</cfif>><cf_get_lang dictionary_id='38909.İlk KM'></option>
                                                        <option value="21" <cfif listfind(attributes.category,21,',')>selected</cfif>><cf_get_lang dictionary_id='38918.İlk KM Tarihi'></option>
                                                        <option value="12" <cfif listfind(attributes.category,12,',')>selected</cfif>><cf_get_lang dictionary_id='58225.Model'></option>
                                                        <option value="13" <cfif listfind(attributes.category,13,',')>selected</cfif>><cf_get_lang dictionary_id='38906.Renk'></option>
                                                        <option value="14" <cfif listfind(attributes.category,14,',')>selected</cfif>><cf_get_lang dictionary_id='29454.Motor No'></option>
                                                        <option value="15" <cfif listfind(attributes.category,15,',')>selected</cfif>><cf_get_lang dictionary_id='29455.Şase No'></option>
                                                        <option value="18" <cfif listfind(attributes.category,18,',')>selected</cfif>><cf_get_lang dictionary_id='57489.Para Birimi'></option>
                                                        <option value="25" <cfif listfind(attributes.category,25,',')>selected</cfif>><cf_get_lang dictionary_id='29697.Verildiği İl-İlçe'></option>
                                                        <option value="26" <cfif listfind(attributes.category,26,',')>selected</cfif>><cf_get_lang dictionary_id='38924.Trafiğe Çıkış Tarihi'></option>
                                                        <option value="27" <cfif listfind(attributes.category,27,',')>selected</cfif>><cf_get_lang dictionary_id='38932.Cinsi'></option>
                                                        <option value="28" <cfif listfind(attributes.category,28,',')>selected</cfif>><cf_get_lang dictionary_id='38937.Tipi'></option>
                                                        <option value="29" <cfif listfind(attributes.category,29,',')>selected</cfif>><cf_get_lang dictionary_id='38938.Net Ağırlık'></option>
                                                        <option value="30" <cfif listfind(attributes.category,30,',')>selected</cfif>><cf_get_lang dictionary_id='38939.İstilap haddi'>\<cf_get_lang dictionary_id='40609.Kg'></option>
                                                        <option value="31" <cfif listfind(attributes.category,31,',')>selected</cfif>><cf_get_lang dictionary_id='38939.İstilap haddi'>\<cf_get_lang dictionary_id='29831.Kişi'></option>
                                                        <option value="32" <cfif listfind(attributes.category,32,',')>selected</cfif>><cf_get_lang dictionary_id='38951.Tescil Sıra No'></option>
                                                        <option value="33" <cfif listfind(attributes.category,33,',')>selected</cfif>><cf_get_lang dictionary_id='38958.Tescil Tarihi'></option>
                                                        <option value="34" <cfif listfind(attributes.category,34,',')>selected</cfif>><cf_get_lang dictionary_id='38976.Motor Gücü'></option>
                                                        <option value="35" <cfif listfind(attributes.category,35,',')>selected</cfif>><cf_get_lang dictionary_id='38980.Silindir Hacmi'></option>
                                                        <option value="36" <cfif listfind(attributes.category,36,',')>selected</cfif>><cf_get_lang dictionary_id='38966.Kullanım Tipi'></option>
                                                        <option value="37" <cfif listfind(attributes.category,37,',')>selected</cfif>><cf_get_lang dictionary_id='38972.Araç Sahibi'></option>
                                                        <option value="38" <cfif listfind(attributes.category,38,',')>selected</cfif>><cf_get_lang dictionary_id='38974.İkametgah Adresi'></option>
                                                        </cfif>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                                         <div class="col col-12 col-xs-12">
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58140.İş Grubu'></label>
                                                <div class="col col-12 col-xs-12">
                                                    <select name="assetp_group" id="assetp_group">
                                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                        <cfloop query="get_assetp_groups">
                                                        <option value="#group_id#" <cfif attributes.assetp_group eq group_id>selected</cfif>>#group_name#</option>
                                                        </cfloop>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38828.Kullanım Amacı'></label>
                                                <div class="col col-12 col-xs-12">
                                                    <select name="usage_purpose_id" id="usage_purpose_id">
                                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                        <cfloop query="get_purpose">
                                                        <option value="#usage_purpose_id#" <cfif attributes.usage_purpose_id eq usage_purpose_id>selected</cfif>>#usage_purpose#</option>
                                                        </cfloop>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38872.Alış Tarihi'></label>
                                                <div class="col col-6">
                                                    <div class="input-group">                   
                                                        <cfinput validate="#validate_style#" id="start_date" type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#">  
                                                        <span class="input-group-addon"> <cf_wrk_date_image date_field="start_date"></span>
                                                    </div>
                                                </div>
                                                 <div class="col col-6">
                                                    <div class="input-group">
                                                        <cfinput validate="#validate_style#" id="finish_date" type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#">
                                                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>  
                                                    </div>
                                                </div>
                                            </div>       
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
                                                <div class="col col-12 col-xs-12">
                                                    <select name="report_type" id="report_type" onchange="fill_inf(this.value)">
                                                        <option value="0"><cf_get_lang dictionary_id='57708.Tümü'></option>
                                                        <option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58833.Fiziki Varlık'><cf_get_lang dictionary_id='58601.Bazında'></option>
                                                        <option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='38893.IT Varlıklar'><cf_get_lang dictionary_id='58601.Bazında'></option>
                                                        <option value="3" <cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id='57414.Araçlar'><cf_get_lang dictionary_id='58601.Bazında'></option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="col col-12 col-xs-12">
                                                    <select name="is_active" id="is_active" >
                                                        <option value=""><cf_get_lang dictionary_id ='57708.Tümü'></option>
                                                        <option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                                        <option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                                                    </select>                                        
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="col col-12 col-xs-12">
                                                    <label><cf_get_lang dictionary_id='38866.Ortak Kullanım'><input type="checkbox" name="share_used" id="share_used" <cfif isdefined("attributes.share_used")>checked</cfif> value=""></label> 
                                                </div>
                                            </div>                                
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12" id="motorized_vehicle_label" <cfif attributes.report_type eq 1 or attributes.report_type eq 2>style="display:none"</cfif>><cf_get_lang dictionary_id='58225.Model'></label>
                                                <div class="col col-12 col-xs-12">
                                                    <div id="motorized_vehicle" <cfif attributes.report_type eq 1 or attributes.report_type eq 2>style="display:none"</cfif>>
                                                        <select name="make_year" id="make_year">
                                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                            <cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
                                                            <cfloop from="#yil#" to="1970" index="i" step="-1">
                                                                <option value="#i#" <cfif i eq attributes.make_year>selected</cfif>>#i#</option>
                                                            </cfloop>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12"  id="motorized_vehicle2_label" <cfif attributes.report_type eq 1 or attributes.report_type eq 2>style="display:none"</cfif>><cf_get_lang dictionary_id='30113.Yakıt Tipi'></label>
                                                <div class="col col-12 col-xs-12">
                                                    <div id="motorized_vehicle2" <cfif attributes.report_type eq 1 or attributes.report_type eq 2>style="display:none"</cfif>>
                                                        <select name="fuel_type" id="fuel_type">
                                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                            <cfloop query="get_fuel_type">
                                                                <option value="#fuel_id#" <cfif attributes.fuel_type eq fuel_id>selected</cfif>>#fuel_name#</option>
                                                            </cfloop>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div> 
                                        </div>                                      
                                    </div>
                                </cfoutput>
                            </div>
                        </div>
                        <div class="row ReportContentBorder">
                            <div class="ReportContentFooter">
                                <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>checked</cfif>></label>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                                <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#"  required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
                                <input type="hidden" name="is_submit" id="is_submit" value="1">
                                <cf_wrk_report_search_button button_type="1" is_excel='1' search_function="kontrol()">
                            </div>
                        </div>
                    </div>
                </div>
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</cfif>
<cfif isdefined("attributes.is_submit")>
	<cf_report_list>
        <thead>
            <tr>
            <th><cf_get_lang dictionary_id='38829.Mülkiyet'></th>
            <th><cf_get_lang dictionary_id='29452.Varlık'>/<cf_get_lang dictionary_id='29453.Plaka'></th>
            <th><cf_get_lang dictionary_id='60371.Mekan'></th>
            <th><cf_get_lang dictionary_id='38825.Alınan Şirket'></th>
            <th><cf_get_lang dictionary_id='30031.Lokasyon'></th>
            <th><cf_get_lang dictionary_id='57985.Üst'> <cf_get_lang dictionary_id='57572.Departman'></th>
            <th><cf_get_lang dictionary_id='57572.Departman'></th>
            <th><cf_get_lang dictionary_id='38919.Varlık Tipi'></th>
            <th><cf_get_lang dictionary_id='38919.Varlık Tipi'><cf_get_lang dictionary_id='38730.Alt Kategori'></th>
            <th><cf_get_lang dictionary_id='38872.Alış Tarihi'></th>
            <th><cf_get_lang dictionary_id='58878.Demirbaş No'></th>
            <th><cf_get_lang dictionary_id='38920.Marka Kategorisi'></th>
            <th><cf_get_lang dictionary_id='38841.Marka/Marka Tipi'></th>
            <cfif listfind(attributes.category,1,',')>
                <th><cf_get_lang dictionary_id='57633.Barkod'></th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,2,',')>
                <th><cf_get_lang dictionary_id='38894.Kayıtlı Departman'></th>
                 <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,3,',')>
                <th><cf_get_lang dictionary_id='38895.Kullanıcı Departman'></th>
                 <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,4,',')>
                <th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
                 <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,39,',')>
                <th><cf_get_lang dictionary_id='57544.Sorumlu'>2</th>
                 <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,5,',')>
                <th><cf_get_lang dictionary_id='57637.Seri No'></th>
                 <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,6,',')>
                <th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                 <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,7,',')>
                <th><cf_get_lang dictionary_id='38901.Servis Çalışanı'></th>
                 <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,8,',')>
                <th><cf_get_lang dictionary_id='30113.Yakıt Tipi'></th>
                 <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,9,',')>
                <th><cf_get_lang dictionary_id='57756.Durum'></th>
                 <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,10,',')>
                <th><cf_get_lang dictionary_id='58140.İş Grubu'></th>
                 <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,11,',')>
                <th><cf_get_lang dictionary_id='38828.Kullanım Amacı'></th>
                 <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,12,',')>
                <th><cf_get_lang dictionary_id='58225.Model'></th>
                 <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,13,',')>
                <th><cf_get_lang dictionary_id='38906.Renk'></th>
                 <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,14,',')>
                <th><cf_get_lang dictionary_id='29454.Motor No'></th>
                 <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,15,',')>
                <th><cf_get_lang dictionary_id='29455.Şase No'></th>
                 <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,16,',')>
                <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                 <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,17,',')>
                <th><cf_get_lang dictionary_id='38794.Değer'></th>
                 <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,18,',')>
                <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                 <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,19,',')>
                <th><cf_get_lang dictionary_id='38866.Ortak Kullanım'></th>
                 <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,24,',')>
                <th><cf_get_lang dictionary_id='58515.Aktif/Pasif'></th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,20,',')>
                <th><cf_get_lang dictionary_id='38909.İlk KM'></th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,21,',')>
                <th><cf_get_lang dictionary_id='38918.İlk KM Tarihi'></th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,23,',')>
                <th><cf_get_lang dictionary_id='29438.Çıkış Tarihi'></th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,25,',')>
                <th><cf_get_lang dictionary_id='29697.Verildiği İl-İlçe'></th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,26,',')>
                <th><cf_get_lang dictionary_id='38924.Trafiğe Çıkış Tarihi'></th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,27,',')>
                <th><cf_get_lang dictionary_id='38932.Cinsi'></th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,28,',')>
                <th><cf_get_lang dictionary_id='38937.Tipi'></th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,29,',')>
                <th><cf_get_lang dictionary_id='38938.Net Ağırlık'></th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,30,',')>
                <th><cf_get_lang dictionary_id='38939.İstilap haddi'>\<cf_get_lang dictionary_id='40609.Kg'></th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,31,',')>
                <th><cf_get_lang dictionary_id='38939.İstilap haddi'>\<cf_get_lang dictionary_id='29831.Kişi'></th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,32,',')>
                <th><cf_get_lang dictionary_id='38951.Tescil Sıra No'></th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,33,',')>
                <th><cf_get_lang dictionary_id='38958.Tescil Tarihi'></th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,34,',')>
                <th><cf_get_lang dictionary_id='38976.Motor Gücü'></th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,35,',')>
                <th><cf_get_lang dictionary_id='38980.Silindir Hacmi'></th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,36,',')>
                <th><cf_get_lang dictionary_id='38966.Kullanım Tipi'></th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,37,',')>
                <th><cf_get_lang dictionary_id='38972.Araç Sahibi'></th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,38,',')>
                <th><cf_get_lang dictionary_id='38974.İkametgah Adresi'></th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.category,40,',')>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 1</th>
                <cfset colspan_=colspan_ + 1>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 2</th>
                <cfset colspan_=colspan_ + 1>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 3</th>
                <cfset colspan_=colspan_ + 1>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 4</th>
                <cfset colspan_=colspan_ + 1>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 5</th>
                <cfset colspan_=colspan_ + 1>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 6</th>
                <cfset colspan_=colspan_ + 1>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 7</th>
                <cfset colspan_=colspan_ + 1>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 8</th>
                <cfset colspan_=colspan_ + 1>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 9</th>
                <cfset colspan_=colspan_ + 1>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 10</th>
                <cfset colspan_=colspan_ + 1>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 11</th>
                <cfset colspan_=colspan_ + 1>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 12</th>
                <cfset colspan_=colspan_ + 1>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 13</th>
                <cfset colspan_=colspan_ + 1>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 14</th>
                <cfset colspan_=colspan_ + 1>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 15</th>
                <cfset colspan_=colspan_ + 1>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 16</th>
                <cfset colspan_=colspan_ + 1>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 17</th>
                <cfset colspan_=colspan_ + 1>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 18</th>
                <cfset colspan_=colspan_ + 1>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 19</th>
                <cfset colspan_=colspan_ + 1>
                <th><cf_get_lang dictionary_id='39107.Ek Bilgiler'> 20</th>
                <cfset colspan_=colspan_ + 1>
            </cfif>
            </tr>
        </thead>	
        <tbody>
        <cfif get_asset.recordcount>
			<cfoutput query="get_asset" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
              <tr>
                <td>
                    <cfif property eq 1>
                        <cf_get_lang dictionary_id='57449.Satın Alma'>
                    <cfelseif property eq 2>
                        <cf_get_lang dictionary_id='38877.Kiralama'>
                    <cfelseif property eq 3>
                        <cf_get_lang dictionary_id='38888.Leasing'>
                    <cfelseif property eq 4>
                        <cf_get_lang dictionary_id='29522.Sözleşme'>
                    </cfif>
                </td>
                <td>
                    <cfif isdefined("attributes.is_excel") and attributes.is_excel neq 1>
                        <cfif it_asset eq 1>
                            <a href="#request.self#?fuseaction=assetcare.list_asset_it&event=upd&assetp_id=#assetp_id#">
                        <cfelseif motorized_vehicle eq 1>
                            <a href="#request.self#?fuseaction=assetcare.list_vehicles&event=upd&assetp_id=#assetp_id#">
                        <cfelse>
                            <a href="#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#assetp_id#">
                        </cfif>
                    </cfif>
                    #assetp#<cfif isdefined("attributes.is_excel") and attributes.is_excel neq 1></a></cfif>
                </td>
                <td><cfif len(get_asset.space_code) and len(get_asset.space_name)>#get_asset.space_code# - #get_asset.space_name#</cfif></td>
                <td>
                    <cfif len(sup_consumer_id)>
                        #get_cons_name.name[listfind(list_cons_id,sup_consumer_id,',')]#
                    <cfelseif len(sup_company_id)>
                        #get_comp_name.fullname[listfind(list_comp_id,sup_company_id,',')]#
                  </cfif>
               </td>
               <td>
                <cfif len(LOCATION)>
                    <cfquery name="get_branch_name" dbtype="query">
                        select BRANCH_NAME from get_branches where BRANCH_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#LOCATION#">
                    </cfquery>
                    #get_branch_name.BRANCH_NAME#
                </cfif>
                </td>
               <td>#UPPER_DEPARTMENT_HEAD#</td>
               <td>#department_head#</td>
                <td>#assetp_cat#</td>
                <td>#ASSETP_SUB_CAT#</td>
                <td>#dateformat(sup_company_date,dateformat_style)#</td>
                <td>#inventory_number#</td>
                <td style="mso-number-format:\@;">#brand_type_cat_name#</td>
                <td>#BRAND_NAME# / #BRAND_TYPE_NAME#</td>
                <cfif listfind(attributes.category,1,',')>
                    <td>#barcode#</td>
                </cfif>
               <cfif listfind(attributes.category,2,',')>
                    <td><cfif len(department_id)>#DEP_HEAD#</cfif></td>
                </cfif>
                <cfif listfind(attributes.category,3,',')>
                    <td><cfif len(department_id2)>#DEPARTMENT_HEAD#</cfif></td>
                </cfif>
                <cfif listfind(attributes.category,4,',')>
                    <td>#get_empcode.name[listfind(list_poscode,employee_id,',')]#</td>
                </cfif>
                <cfif listfind(attributes.category,39,',')>
                    <td>#sorumlu2#</td>
                </cfif>
                <cfif listfind(attributes.category,5,',')>
                    <td>#serial_no#</td>
                </cfif>
                <cfif listfind(attributes.category,6,',')>
                    <td>#primary_code#</td>
                </cfif>
                <cfif listfind(attributes.category,7,',')>
                    <td>#service_employee_name#</td>
                </cfif> 
                <cfif listfind(attributes.category,8,',')>
                    <td>#fuel_name#</td>
                </cfif>
                <cfif listfind(attributes.category,9,',')>
                    <td>#asset_state#</td>
                </cfif>
                <cfif listfind(attributes.category,10,',')>
                    <td>#group_name#</td>
                </cfif>
                <cfif listfind(attributes.category,11,',')>
                    <td>#usage_purpose#</td>
                </cfif>
                <cfif listfind(attributes.category,12,',')>
                    <td>#make_year#</td>
                </cfif>
                <cfif listfind(attributes.category,13,',')>
                    <td>#renk#</td>
                </cfif>
                <cfif listfind(attributes.category,14,',')>
                    <td>#engine_number#</td>
                </cfif>
                <cfif listfind(attributes.category,15,',')>
                    <td>#identification_numbeR#</td>
                </cfif>
                <cfif listfind(attributes.category,16,',')>
                    <td>#assetp_detail#</td>
                </cfif>
                <cfif listfind(attributes.category,17,',')>
                    <td><cfif len(other_money_value)>#TLformat(other_money_value,2)#&nbsp;#MONEY#</cfif></td>
                </cfif>
                <cfif listfind(attributes.category,18,',')>
                    <td>#other_money#</td>
                </cfif>
                <cfif listfind(attributes.category,19,',')>
                    <td>
                        <cfif is_collective_usage eq 1>
                            <cf_get_lang dictionary_id='57495.Evet'>
                        <cfelse>
                            <cf_get_lang dictionary_id='57496.Hayır'>
                        </cfif>
                    </td>
                </cfif>
                <cfif listfind(attributes.category,24,',')>
                    <td>
                        <cfif STATUS eq 1>
                            <cf_get_lang dictionary_id='57493.Aktif'>
                        <cfelse>
                            <cf_get_lang dictionary_id='57494.Pasif'>
                        </cfif>
                    </td>
                </cfif>
                <cfif listfind(attributes.category,20,',')>
                    <td>#first_km#</td>
                </cfif>
                <cfif listfind(attributes.category,21,',')>
                    <td>#dateformat(FIRST_KM_DATE,dateformat_style)#</td>
                </cfif>
                <cfif listfind(attributes.category,24,',')>
                    <td>#dateformat(exit_date,dateformat_style)#</td>
                </cfif>
                <cfif listfind(attributes.category,25,',')>
                    <td>#il#-#ilce#</td>
                </cfif>
                <cfif listfind(attributes.category,26,',')>
                    <td>#trafik_cikis_tarih#</td>
                </cfif>
                <cfif listfind(attributes.category,27,',')>
                    <td>#cins#</td>
                </cfif>
                <cfif listfind(attributes.category,28,',')>
                    <td>#tip#</td>
                </cfif>
                <cfif listfind(attributes.category,29,',')>
                    <td>#net_agirlik#</td>
                </cfif>
                <cfif listfind(attributes.category,30,',')>
                    <td>#istihap_haddi_kg#</td>
                </cfif>
               <cfif listfind(attributes.category,31,',')>
                    <td>#istihap_haddi_kisi#</td>
                </cfif>
               <cfif listfind(attributes.category,32,',')>
                    <td style="mso-number-format:\@;">#tescil_sira_no#</td>
               </cfif>
               <cfif listfind(attributes.category,33,',')>
                    <td>#tescil_tarihi#</td>
               </cfif>
               <cfif listfind(attributes.category,34,',')>
                    <td>#motor_gucu#</td>
               </cfif>
               <cfif listfind(attributes.category,35,',')>
                    <td>#motor#</td>
               </cfif>
               <cfif listfind(attributes.category,36,',')>
                    <td>
                        <cfif usage_type eq 1><cf_get_lang dictionary_id='48642.Yolcu Nakli'></cfif>
                        <cfif usage_type eq 2><cf_get_lang dictionary_id='48643.Yük Nakli'></cfif>	
                    </td>
              </cfif>
               <cfif listfind(attributes.category,37,',')>
                    <td>#arac_sahibi#</td>
               </cfif>
               <cfif listfind(attributes.category,38,',')>
                    <td>#ikametgah_adres#</td>
               </cfif>
               <cfif listfind(attributes.category,40,',')>
                    <td>#PROPERTY1#</td>
                    <td>#PROPERTY2#</td>
                    <td>#PROPERTY3#</td>
                    <td>#PROPERTY4#</td>
                    <td>#PROPERTY5#</td>
                    <td>#PROPERTY6#</td>
                    <td>#PROPERTY7#</td>
                    <td>#PROPERTY8#</td>
                    <td>#PROPERTY9#</td>
                    <td>#PROPERTY10#</td>
                    <td>#PROPERTY11#</td>
                    <td>#PROPERTY12#</td>
                    <td>#PROPERTY13#</td>
                    <td>#PROPERTY14#</td>
                    <td>#PROPERTY15#</td>
                    <td>#PROPERTY16#</td>
                    <td>#PROPERTY17#</td>
                    <td>#PROPERTY18#</td>
                    <td>#PROPERTY19#</td>
                    <td>#PROPERTY20#</td>
               </cfif>
              </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="<cfoutput>#colspan_+1#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
            </tr>
        </cfif>
        </tbody>
    </cf_report_list>
</cfif>
<cfset adres = 'report.list_assets'>
<cfif isdefined("attributes.is_submit") and attributes.totalrecords gt attributes.maxrows >
	<cfif  len(attributes.branch_id) and len(attributes.branch)>
        <cfset adres='#adres#&branch_id=#attributes.branch_id#&branch=#attributes.branch#'>
    </cfif>
    <cfif  len(attributes.cat_category)>
        <cfset adres = '#adres#&cat_category=#attributes.cat_category#'>
    </cfif>
    <cfif  len(attributes.property_type)>
        <cfset adres = '#adres#&property_type=#attributes.property_type#'>
    </cfif>
    <cfif len(attributes.department_id) and len(attributes.department)>
        <cfset adres = '#adres#&departman_id=#attributes.departman_id#&departman_type=#attributes.departman_type#'>
    </cfif>
    <cfif len(attributes.sup_company_id) and len(attributes.sup_partner_id) and len(attributes.sup_comp_name)>
        <cfset adres = '#adres#&sup_company_id=#attributes.sup_company_id#&sup_partner_id=#attributes.sup_partner_id#&sup_comp_name=#attributes.sup_comp_name#'>
    </cfif>
    <cfif len(attributes.sup_consumer_id) and len(attributes.sup_comp_name)>
        <cfset adres = '#adres#&sup_consumer_id=#attributes.sup_consumer_id#&sup_comp_name=#attributes.sup_comp_name#'>
    </cfif>
    <cfif  len(attributes.category)>
        <cfset adres = '#adres#&category=#attributes.category#'>
    </cfif>
    <cfif len(attributes.brand)>
        <cfset adres = '#adres#&brand=#attributes.brand#' >
    </cfif>
    <cfif len(attributes.make_year)>
        <cfset adres = '#adres#&make_year=#attributes.make_year#' >
    </cfif>
    <cfif len(attributes.start_date)>
        <cfset adres = '#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#' >
    </cfif>
    <cfif len(attributes.finish_date)>
        <cfset adres = '#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#' >
    </cfif>
    <cfif len(attributes.asset_id) and len(attributes.asset_name)>
        <cfset adres = '#adres#&asset_id=#attributes.asset_id#&asset_name=#attributes.asset_name#' >
    </cfif>
    <cfif len(attributes.is_active)>
        <cfset adres = '#adres#&is_active=#attributes.is_active#'>
    </cfif>
    <cfif len(attributes.fuel_type)>
        <cfset adres = '#adres#&fuel_type=#attributes.fuel_type#'>
    </cfif>
    <cfif isdefined("attributes.share_used") and  len(attributes.share_used)>
        <cfset adres = '#adres#&share_used=#attributes.share_used#'>
    </cfif>
    <cfif len(attributes.usage_purpose_id)>
        <cfset adres = '#adres#&usage_purpose_id=#attributes.usage_purpose_id#'>
    </cfif>
    <cfif len(attributes.assetp_group)>
        <cfset adres = '#adres#&assetp_group=#attributes.assetp_group#'>
    </cfif>
    <cfif len(assetp_sub_catid)>
        <cfset adres='#adres#&assetp_sub_catid=#attributes.assetp_sub_catid#'>
    </cfif>
    <cfif len(attributes.employee_id) and len(attributes.position_name)>
        <cfset adres = '#adres#&employee_id=#attributes.employee_id#&position_name=#attributes.position_name#'>
    </cfif>
    <cfif len(attributes.asset_p_space_id)>
        <cfset adres = '#adres#&asset_p_space_id=#attributes.asset_p_space_id#'>
    </cfif>
    <cfif len(attributes.status)>
     <cfset adres = '#adres#&status=#attributes.status#'>
    </cfif>
    <cfif len(attributes.report_type)>
        <cfset adres = '#adres#&report_type=#attributes.report_type#'>
    </cfif>

  <cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="#adres#&is_submit=1">
</cfif>
<script type="text/javascript">
function kontrol()
{	
    if ((document.physical_assets.start_date.value != '') && (document.physical_assets.finish_date.value != '') &&
	    !date_check(physical_assets.start_date,physical_assets.finish_date,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
	if(document.getElementById('is_excel').checked == false)
	{
		document.getElementById('physical_assets').action="<cfoutput>#request.self#?fuseaction=report.list_assets</cfoutput>";
		return true;
	}
	else
		document.getElementById('physical_assets').action="<cfoutput>#request.self#?fuseaction=report.emptypopup_list_assets</cfoutput>";
}	
function fill_inf(type)
{
	pysical_asset=document.getElementById("cat_category");
	var x=pysical_asset.length;
	//Kategori siliniyor...
	for (loop=1; loop <= x; loop++) 
	{  
		pysical_asset.remove(0);
	} 
	brand=document.getElementById("brand");
	var brand_x=brand.length;
	for (loop=1;loop<=brand_x;loop++)
	{
		brand.remove(0);
	}
	category=document.getElementById("category");
	var category_x=category.length;
	for(loop=1;loop<=category_x;loop++)
	{
	   category.remove(0);
	}
		if(type==1)
		{
			//her biri için sql alınıyor...
			sql="SELECT ASSETP_CATID,ASSETP_CAT FROM ASSET_P_CAT WHERE MOTORIZED_VEHICLE=0 AND IT_ASSET=0 ORDER BY ASSETP_CAT";
			get_asset_cat=wrk_query(sql,'dsn');
			sql_1="SELECT SETUP_BRAND_TYPE.BRAND_TYPE_ID,SETUP_BRAND.BRAND_NAME,SETUP_BRAND_TYPE.BRAND_TYPE_NAME FROM SETUP_BRAND_TYPE,SETUP_BRAND WHERE SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID and SETUP_BRAND.IT_ASSET IS NULL and SETUP_BRAND.MOTORIZED_VEHICLE IS NULL";
			get_brand=wrk_query(sql_1,'dsn');
		}
		else if(type==2)
		{
			//her biri için sql alınıyor...
			sql="SELECT ASSETP_CATID,ASSETP_CAT FROM ASSET_P_CAT WHERE MOTORIZED_VEHICLE=0 AND IT_ASSET=1 ORDER BY ASSETP_CAT";
			get_asset_cat=wrk_query(sql,'dsn');
			sql_1="SELECT SETUP_BRAND_TYPE.BRAND_TYPE_ID,SETUP_BRAND.BRAND_NAME,SETUP_BRAND_TYPE.BRAND_TYPE_NAME FROM SETUP_BRAND_TYPE,SETUP_BRAND WHERE SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID and SETUP_BRAND.IT_ASSET=1";
			get_brand=wrk_query(sql_1,'dsn');
		}
		else if(type==3)
		{
			//her biri için sql alınıyor...
			sql="SELECT ASSETP_CATID,ASSETP_CAT FROM ASSET_P_CAT WHERE MOTORIZED_VEHICLE=1 and IT_ASSET=0 ORDER BY ASSETP_CAT";
			get_asset_cat=wrk_query(sql,'dsn');
			sql_1="SELECT SETUP_BRAND_TYPE.BRAND_TYPE_ID,SETUP_BRAND.BRAND_NAME,SETUP_BRAND_TYPE.BRAND_TYPE_NAME FROM SETUP_BRAND_TYPE,SETUP_BRAND WHERE SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID and SETUP_BRAND.MOTORIZED_VEHICLE=1";
			get_brand=wrk_query(sql_1,'dsn');
		}
		else
		{
			//her biri için sql alınıyor...
			sql="SELECT ASSETP_CATID,ASSETP_CAT FROM ASSET_P_CAT ORDER BY ASSETP_CAT";
			get_asset_cat=wrk_query(sql,'dsn');
			sql_1="SELECT SETUP_BRAND_TYPE.BRAND_TYPE_ID,SETUP_BRAND.BRAND_NAME,SETUP_BRAND_TYPE.BRAND_TYPE_NAME FROM SETUP_BRAND_TYPE,SETUP_BRAND WHERE SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID";
			get_brand=wrk_query(sql_1,'dsn');
		}
	if(get_asset_cat.recordcount!=0)
	{
		//Yeni kategori eklenir.	
		for (x=0;x<get_asset_cat.recordcount;x++)
		{	
			pysical_asset.options[pysical_asset.options.length]=new Option(get_asset_cat.ASSETP_CAT[x],get_asset_cat.ASSETP_CATID[x]);
		}
	}
	if(get_brand.recordcount!=0)
	{
		//yeni marka eklenir.
		for(c=0;c<get_brand.recordcount;c++)
		{
			brand.options[brand.options.length]=new Option(get_brand.BRAND_NAME[c]+' / '+get_brand.BRAND_TYPE_NAME[c],get_brand.BRAND_TYPE_ID[c]);
		}
	}
	if(type==1 || type==2 || type==0)
	{
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='57633.Barkod'>",1);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38894.Kayıtlı Departman'>",2);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38895.Kullanıcı Departman'>",3);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='57544.Sorumlu'>",4);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='29438.Çıkış Tarihi'>",23);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38794.Değer'>",17);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='58515.Aktif/Pasif'>",24);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='57637.Seri No'>",5);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='57789.Özel Kod'>",6);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38901.Servis Çalışanı'>",7);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='57756.Durum'>",9);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='58140.İş Grubu'>",10);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38828.Kullanım Amacı'>",11);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='58225.Model'>",12);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='57629.Açıklama'>",16);
	}
	if(type==3 || type==0)
	{
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38895.Kullanıcı Departman'>",3);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='57544.Sorumlu'>",4);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='29438.Çıkış Tarihi'>",23);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38794.Değer'>",17);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='58515.Aktif/Pasif'>",24);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='57789.Özel Kod'>",6);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='58140.İş Grubu'>",10);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38828.Kullanım Amacı'>",11);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='58225.Model'>",12);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='57629.Açıklama'>",16);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='30113.Yakıt Tipi'>",8);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='29697.Verildiği İl-İlçe'>",25);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38924.Trafiğe Çıkış Tarihi'>",26);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38932.Cinsi'>",27);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38937.Tipi'>",28);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38938.Net Ağırlık'>",29);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38939.İstilap haddi'>\<cf_get_lang dictionary_id='40609.Kg'>",30);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38939.İstilap haddi'>\<cf_get_lang dictionary_id='29831.Kişi'>",31);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38951.Tescil Sıra No'>",32);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38958.Tescil Tarihi'>",34);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38976.Motor Gücü'>",35);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38980.Silindir Hacmi'>",36);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38966.Kullanım Tipi'>",37);
		category.options[category.options.length]=new Option("<cf_get_lang dictionary_id='38972.Araç Sahibi'>",38);
	}
	if(type==3 || type==0)
	{
		document.getElementById('motorized_vehicle').style.display=''
        document.getElementById('motorized_vehicle_label').style.display=''
		document.getElementById('motorized_vehicle2').style.display=''
        document.getElementById('motorized_vehicle2_label').style.display=''
	}
	else
	{
		document.getElementById('motorized_vehicle').style.display='none'
        document.getElementById('motorized_vehicle_label').style.display='none'
		document.getElementById('motorized_vehicle2').style.display='none'
        document.getElementById('motorized_vehicle2_label').style.display='none'
	}
}
function cat_subcat()
{
	pysical_asset_cat=document.getElementById("assetp_sub_catid");
	var x=pysical_asset_cat.length;
	//Kategori siliniyor...
	for (loop=1; loop <= x; loop++) 
	{  
		pysical_asset_cat.remove(0);
	} 
	for(k=0;k<document.getElementById("cat_category").options.length;++k)
	{
		if(document.getElementById("cat_category").options[k].selected==true)
		{
			var get_assetp_sub_cat = wrk_query("SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID IN (" + document.getElementById("cat_category").options[k].value + ") ORDER BY ASSETP_SUB_CAT","dsn");
			if(pysical_asset_cat.recordcount!=0)
			{
				//yeni alt kategori eklenir.
				for(c=0;c<get_assetp_sub_cat.recordcount;c++)
				{
					pysical_asset_cat.options[pysical_asset_cat.options.length]=new Option(get_assetp_sub_cat.ASSETP_SUB_CAT[c],get_assetp_sub_cat.ASSETP_SUB_CATID[c]);
				}
			}
		}
	}

}
</script>
<cfsetting showdebugoutput="yes">
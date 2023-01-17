<cfparam name="attributes.kasa_numarasi" default="">
<cfset bugun_ = now()>
<cfset base_date_ = bugun_>
<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = createodbcdatetime('#year(base_date_)#-#month(base_date_)#-#day(base_date_)#')>	
</cfif>

<cfquery name="get_kasalar" datasource="#dsn#">
	SELECT 
    	B.BRANCH_NAME + ' - ' + ISNULL(PE.EQUIPMENT_CODE,'') KASA_ADI,
        PE.EQUIPMENT_CODE
    FROM 
    	BRANCH B,
        #dsn3_alias#.POS_EQUIPMENT PE
    WHERE
        B.BRANCH_ID = PE.BRANCH_ID AND
        B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
    ORDER BY 
    	BRANCH_NAME,
        PE.EQUIPMENT_CODE
</cfquery>

<cfquery name="get_aktarimlar" datasource="#dsn_dev#">
	SELECT DISTINCT
    	YEAR(FIS_TARIHI) AS YIL,
        MONTH(FIS_TARIHI) AS AY,
        DAY(FIS_TARIHI) AS GUN,
        GA.ACTION_DATE,
        B.BRANCH_NAME,
        GA.KASA_NUMARASI,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS ISLEM_YAPAN
    FROM
    	GENIUS_ACTIONS GA,
        #dsn3_alias#.POS_EQUIPMENT PE,
        #dsn_alias#.BRANCH B,
        #dsn_alias#.EMPLOYEES E
    WHERE
    	PE.EQUIPMENT_CODE = GA.KASA_NUMARASI AND
        PE.BRANCH_ID = B.BRANCH_ID AND
        GA.IS_OFFLINE = 1 AND
        GA.RECORD_EMP = E.EMPLOYEE_ID
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="" method="post" name="search_">
            <cf_box_search>
                <div class="form-group medium">
                    <cf_multiselect_check 
                    query_name="GET_KASALAR"  
                    name="kasa_numarasi"
                    option_text="#getLang('','Kasa',57520)#" 
                    width="180"
                    option_name="KASA_ADI" 
                    option_value="equipment_code"
                    filter="1"
                    value="#attributes.kasa_numarasi#">
                </div>
                <div class="form-group"> 
                    <div class="input-group">       
                        <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#getLang('','Tarih',30631)#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <cf_workcube_buttons>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='61885.Pos Kasa Offline Aktarım'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='52124.Aktarım Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='57520.Kasa'></th>
                    <th><cf_get_lang dictionary_id='58586.İşlem Yapan'></th>
                </tr>
            </thead>
            <tbody>
            <cfoutput query="get_aktarimlar">
                <tr>
                    <td>#dateformat(ACTION_DATE,'dd/mm/yyyy')#</td>
                    <td>#GUN#/#AY#/#YIL#</td>
                    <td>#BRANCH_NAME#</td>
                    <td>#kasa_numarasi#</td>
                    <td>#ISLEM_YAPAN#</td>
                </tr>
            </cfoutput>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>



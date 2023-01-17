<cfparam name="attributes.kasa_numarasi" default="">
<cfset bugun_ = now()>
<cfset base_date_ = dateadd('d',-1,bugun_)>
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

<cf_catalystHeader>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cfform name="add_" method="post" action="">
                <cf_box_elements>
                    <div class="col col-6 col-md-4 col-sm-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-startdate">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30631.Tarih'></label>
                            <div class="col col-8 col-sm-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='30631.Tarih'></cfsavecontent>
                                    <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-md-4 col-sm-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-kasa_numarasi">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58657.Kasalar'></label>
                            <div class="col col-8 col-sm-12">
                                <cf_multiselect_check 
                                    query_name="GET_KASALAR"  
                                    name="kasa_numarasi"
                                    option_text="Kasalar" 
                                    width="180"
                                    option_name="KASA_ADI" 
                                    option_value="equipment_code"
                                    filter="1"
                                    value="#attributes.kasa_numarasi#">
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons insert_info="Silme İşlemini Başlat">
                </cf_box_footer>
            </cfform>
        </cf_box>
    </div>
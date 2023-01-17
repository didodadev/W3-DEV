<!---
    File: V16\hr\ehesap\display\hourly_addfare_percantege.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 08.06.2021
    Description: Ödenek PDKS
        
    History:
        
    To Do:

--->
<cf_xml_page_edit fuseact="ehesap.hourly_addfare_percantege">
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfif month(now()) eq 1>
	<cfparam name="attributes.sal_mon" default="1">
<cfelse>
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
</cfif>
<cfinclude template="../query/get_ssk_offices.cfm">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.ssk_office" default="0">
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
        <cfform name="employee" method="post" action="">
        	<cf_box_search more="0"> 
				<div class="form-group">
					<select name="ssk_office" id="ssk_office"  <cfif show_department eq 1>onChange="get_department_list(this.value)"</cfif>>
						<cfoutput query="GET_SSK_OFFICES">
							<cfif len(SSK_OFFICE) and len(SSK_NO)>
								<option value="#branch_id#"<cfif attributes.ssk_office is "#branch_id#"> selected</cfif>>#BRANCH_NAME#-#SSK_OFFICE#-#SSK_NO#</option>
							</cfif>
						</cfoutput>
					</select>
				</div>
                <cfif show_department eq 1>
                    <div class="form-group" id="item-department">
                        <select name="department" id="department">
                            <option value="0"><cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'></option>
                        </select>		
                    </div>
                </cfif>
                <div class="form-group" id="item-ssk_statue">
                    <select  name="ssk_statue" id="ssk_statue" onchange="change_ssk_statue(this.value)">
                        <option value="0"><cf_get_lang dictionary_id='53606.SSK Durumu'></option>
                        <option value="1"><cf_get_lang dictionary_id='45049.Worker'></option>
                        <option value="2"><cf_get_lang dictionary_id='62870.Memur'></option>
                        <option value="3"><cf_get_lang dictionary_id='62871.Serbest Çalışan'></option>
                        <option value="4"><cf_get_lang dictionary_id='63103.Sanatçı'></option>
                        <option value="5"><cf_get_lang dictionary_id='30439.Dış Kaynak'></option>
                    </select>
                </div>
                <div class="form-group" id="statue_type_div" style="display:none">
                    <select name="statue_type" id="statue_type">
                        <option value="0"><cf_get_lang dictionary_id='63047.Bordro Tipi'></option>
                        <option value="1"><cf_get_lang dictionary_id='40071.Maaş'></option>
                        <option value="2"><cf_get_lang dictionary_id='62888.Döner Sermaye'></option>
                        <option value="3"><cf_get_lang dictionary_id='62956.Ek Ders'></option>
                        <option value="4"><cf_get_lang dictionary_id='58015.Projeler'></option>
                        <option value="6"><cf_get_lang dictionary_id='64673.Jüri Üyeliği'></option>
                    </select>
				</div>
				<div class="form-group">
					<select name="sal_mon" id="sal_mon">
						<cfloop from="1" to="12" index="i">
							<cfoutput>
								<option value="#i#" <cfif month(now()) gt 1 and i eq month(now())-1>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
							</cfoutput>
						</cfloop>
					</select>
				</div>
				<div class="form-group">
					<input type="text" name="sal_year" id="sal_year" value="<cfoutput>#session.ep.period_year#</cfoutput>" readonly size="3">
				</div>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="57911.Çalıştır"></cfsavecontent>
					<cf_wrk_search_button button_type="4" button_name="#message#" search_function="open_form_ajax()">
					
				</div>
                
			</cf_box_search>
        </cfform>
	</cf_box>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='63111.PDKS - Ödenekli Çalışmalar'></cfsavecontent>
	<cf_box title="#title#" hide_table_column="1" uidrop="1"   woc_setting = "#{ checkbox_name : 'print_pdks_id',  print_type : 533 }#">
		<div id="branch_pdks_table">
		</div>
		<cf_grid_list id="ajax_load">
			<tbody>
                <tr>
                    <td colspan="50"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td>
                </tr>
            </tbody>
        </cf_grid_list>
	</cf_box>
</div>


<script type="text/javascript">
    function open_form_ajax()
    {
        if($("#ssk_statue").val() == 0)
        {
            alert("<cf_get_lang dictionary_id='53606.SGK Durumu'>!");
            return false;
        }else if($("#ssk_statue").val() == 2 && $("#statue_type").val() == 0)
        {
            alert("<cf_get_lang dictionary_id='63047.Bordro Tipi'>!");
            return false;
        }
        adres_ = '<cfoutput>#request.self#?fuseaction=ehesap.hourly_addfare_percantege&event=add</cfoutput>';
        sal_mon_ = $("#sal_mon").val();
        sal_year_ = $("#sal_year").val();
        ssk_office_ = $("#ssk_office").val();
        ssk_statue_ = $("#ssk_statue").val();
        statue_type_ = $("#statue_type").val();
        <cfif show_department eq 1>
            department_id_ =  $("#department").val();
        </cfif>
        adres_= adres_ + '&sal_mon=' + sal_mon_ + '&sal_year=' + sal_year_ + '&ssk_office=' + ssk_office_ +  <cfif show_department eq 1>'&department_id=' + department_id_ + </cfif>'&ssk_statue=' + ssk_statue_ + '&statue_type=' +statue_type_;
        $('#ajax_load').hide();
        AjaxPageLoad(adres_,'branch_pdks_table','1',"<cf_get_lang dictionary_id='65075.Tablo Listeleniyor'>");
        return false;
    }
    /*function send_adres_info()
    {
        adres = '<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=532</cfoutput>';
        adres +='&ssk_office_='+encodeURIComponent(list_getat(document.getElementById('ssk_office').value,1,'-'));
        adres +='&ssk_no_='+encodeURIComponent(list_getat(document.getElementById('ssk_office').value,2,'-'));
        adres +='&sal_mon_='+document.getElementById('sal_mon').value;
        window.open(adres,'woc');	
    }*/
    function change_ssk_statue()
    {
        ssk_statue_val = $("#ssk_statue").val();
        if(ssk_statue_val == 2)
        {
            $('#statue_type_div').css('display','');
        }
        else
        {
            $('#statue_type_div').css('display','none');
        }
    }
    function get_department_list()
    {
        document.getElementById('department').options.length = 0;
        var document_id = document.getElementById('ssk_office').options.length;	
        var document_name = '';
        for(i=0;i<document_id;i++)
            {
                if(document.employee.ssk_office.options[i].selected && document_name.length==0)
                    document_name = document_name + document.employee.ssk_office.options[i].value;
                else if(document.employee.ssk_office.options[i].selected)
                    document_name = document_name + ',' + document.employee.ssk_office.options[i].value;
            }
        var get_department_name = wrk_safe_query('hr_get_department_name','dsn',0,document_name);
        document.employee.department.options[0]=new Option("<cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'>",'0')
        if(get_department_name.recordcount != 0) 
        {
            for(var xx=0;xx<get_department_name.recordcount;xx++)
            {
                document.employee.department.options[xx+1]=new Option(get_department_name.DEPARTMENT_HEAD[xx],get_department_name.DEPARTMENT_ID[xx]);
                document.employee.department.options[xx+1].title = get_department_name.DEPARTMENT_HEAD[xx];
            }
        }
    }
</script>
